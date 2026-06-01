#include "tracker.hpp"
#include "headpose.hpp"
#include "landmarks.hpp"

#include <obs-module.h>

#include <opencv2/imgproc.hpp>

#include <algorithm>

FaceTracker::~FaceTracker()
{
	stop();
}

void FaceTracker::start(const std::string &yunet_path,
			const std::string &headpose_path,
			const std::string &landmark_path, float score_thresh)
{
	if (running_.load())
		return;
	yunet_path_ = yunet_path;
	headpose_path_ = headpose_path;
	landmark_path_ = landmark_path;
	score_thresh_.store(score_thresh);
	running_.store(true);
	thread_ = std::thread(&FaceTracker::worker, this);
}

void FaceTracker::stop()
{
	if (!running_.exchange(false))
		return;
	in_cv_.notify_all();
	if (thread_.joinable())
		thread_.join();
}

void FaceTracker::submit(const cv::Mat &bgr, float scale_to_full,
			 uint64_t frame_id)
{
	if (!running_.load() || bgr.empty())
		return;
	{
		std::lock_guard<std::mutex> lk(in_mtx_);
		bgr.copyTo(pending_); // keep only the latest frame
		pending_scale_ = scale_to_full;
		pending_id_ = frame_id;
		has_pending_ = true;
	}
	in_cv_.notify_one();
}

FaceResult FaceTracker::latest()
{
	std::lock_guard<std::mutex> lk(out_mtx_);
	return result_;
}

void FaceTracker::worker()
{
	cv::Ptr<cv::FaceDetectorYN> detector;
	HeadPoseNet headpose;
	try {
		detector = cv::FaceDetectorYN::create(
			yunet_path_, "", cv::Size(320, 320),
			score_thresh_.load(), 0.3f, 50);
	} catch (const std::exception &e) {
		blog(LOG_ERROR, "[aye-aye-mask] failed to load YuNet: %s",
		     e.what());
		running_.store(false);
		return;
	}
	if (detector.empty()) {
		blog(LOG_ERROR, "[aye-aye-mask] YuNet detector is null");
		running_.store(false);
		return;
	}
	if (!headpose.load(headpose_path_)) {
		blog(LOG_ERROR, "[aye-aye-mask] head-pose net failed to load");
		running_.store(false);
		return;
	}

	// FaceMesh is optional: if it fails to load we still run with YuNet
	// 5-point + head-pose net.
	LandmarkNet landmarks;
	if (!landmark_path_.empty())
		landmarks.load(landmark_path_);
	blog(LOG_INFO, "[aye-aye-mask] YuNet + head-pose%s loaded",
	     landmarks.loaded() ? " + FaceMesh" : "");

	cv::Size cur_size(0, 0);

	while (running_.load()) {
		cv::Mat frame;
		float scale = 1.f;
		uint64_t fid = 0;
		{
			std::unique_lock<std::mutex> lk(in_mtx_);
			in_cv_.wait(lk, [&] {
				return has_pending_ || !running_.load();
			});
			if (!running_.load())
				break;
			cv::swap(pending_, frame); // take ownership; leaves pending_ empty
			scale = pending_scale_;
			fid = pending_id_;
			has_pending_ = false;
		}
		if (frame.empty())
			continue;

		if (frame.size() != cur_size) {
			detector->setInputSize(frame.size());
			cur_size = frame.size();
		}
		detector->setScoreThreshold(score_thresh_.load());

		cv::Mat faces;
		try {
			detector->detect(frame, faces);
		} catch (const std::exception &e) {
			blog(LOG_WARNING, "[aye-aye-mask] detect() threw: %s",
			     e.what());
			continue;
		}

		// Highest-scoring face. faces: Nx15 CV_32F -> [x,y,w,h,
		//   re(x,y), le(x,y), nose, mouthR, mouthL, score].
		int bestRow = -1;
		float bestScore = 0.f;
		for (int i = 0; i < faces.rows; ++i) {
			float s = faces.ptr<float>(i)[14];
			if (bestRow < 0 || s > bestScore) {
				bestRow = i;
				bestScore = s;
			}
		}

		FaceResult best;
		best.frame_id = fid;

		if (bestRow >= 0) {
			const float *r = faces.ptr<float>(bestRow);
			best.score = bestScore;
			best.bbox = cv::Rect2f(r[0] * scale, r[1] * scale,
					       r[2] * scale, r[3] * scale);
			best.right_eye = {r[4] * scale, r[5] * scale};
			best.left_eye = {r[6] * scale, r[7] * scale};
			best.nose = {r[8] * scale, r[9] * scale};
			best.mouth_right = {r[10] * scale, r[11] * scale};
			best.mouth_left = {r[12] * scale, r[13] * scale};

			// Crop the face (downscaled coords) with margin -> head-pose net.
			const float f = 0.2f;
			int x0 = std::max(0, (int)std::lround(r[0] - f * r[3]));
			int y0 = std::max(0, (int)std::lround(r[1] - f * r[2]));
			int x1 = std::min(frame.cols,
					  (int)std::lround(r[0] + r[2] + f * r[3]));
			int y1 = std::min(frame.rows,
					  (int)std::lround(r[1] + r[3] + f * r[2]));
			if (x1 - x0 > 4 && y1 - y0 > 4) {
				cv::Mat crop =
					frame(cv::Rect(x0, y0, x1 - x0, y1 - y0));
				cv::Matx33d R;
				if (headpose.infer(crop, R)) {
					best.head_R = R;
					best.has_R = true;
				}
			}

			// Dense FaceMesh landmarks (optional). Square crop
			// centred on the bbox; points map back to full res.
			if (landmarks.loaded() && mesh_enabled_.load()) {
				float cx = r[0] + r[2] * 0.5f;
				float cy = r[1] + r[3] * 0.5f;
				float side = std::max(r[2], r[3]) * 1.5f;
				int mx0 = std::max(
					0, (int)std::lround(cx - side * 0.5f));
				int my0 = std::max(
					0, (int)std::lround(cy - side * 0.5f));
				int mx1 = std::min(
					frame.cols,
					(int)std::lround(cx + side * 0.5f));
				int my1 = std::min(
					frame.rows,
					(int)std::lround(cy + side * 0.5f));
				if (mx1 - mx0 > 8 && my1 - my0 > 8) {
					cv::Mat mcrop = frame(cv::Rect(
						mx0, my0, mx1 - mx0, my1 - my0));
					std::vector<cv::Point2f> pts;
					float presence = 0.f;
					if (landmarks.infer(mcrop, pts,
							    presence) &&
					    presence > 0.f) {
						best.mesh.resize(pts.size());
						for (size_t i = 0; i < pts.size();
						     ++i)
							best.mesh[i] = {
								(pts[i].x + mx0) *
									scale,
								(pts[i].y + my0) *
									scale};
						best.has_mesh = true;

						// Steadier eye centres than the
						// 5-point YuNet keypoints.
						auto ec = [&](int a, int b) {
							return cv::Point2f(
								(best.mesh[a].x +
								 best.mesh[b].x) *
									0.5f,
								(best.mesh[a].y +
								 best.mesh[b].y) *
									0.5f);
						};
						best.right_eye = ec(
							LandmarkNet::kRightEyeOuter,
							LandmarkNet::kRightEyeInner);
						best.left_eye = ec(
							LandmarkNet::kLeftEyeInner,
							LandmarkNet::kLeftEyeOuter);
					}
				}
			}

			best.valid = best.has_R; // need rotation to place the mask
		}

		{
			std::lock_guard<std::mutex> lk(out_mtx_);
			result_ = best;
		}
	}
}
