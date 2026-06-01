#pragma once

#include "tracker.hpp"

#include <opencv2/core.hpp>

/* Head pose recovered from the 5 YuNet keypoints via solvePnP.
 * R,t map object (head model) space -> camera space; K is the assumed pinhole
 * intrinsic matrix. */
struct HeadPose {
	bool valid = false;
	cv::Matx33d R;
	cv::Vec3d t;
	cv::Matx33d K;
};

/* Canonical 3D head model (arbitrary mm-ish units), Y up, X = image-right,
 * +Z = toward back of head (camera sits on the -Z side). */
namespace facemodel {
cv::Vec3d eye_anchor();      // midpoint between the eyes
double interocular();        // eye-to-eye distance (model units)
cv::Vec3d axis_right();      // +X
cv::Vec3d axis_up();         // +Y (projects to screen-up)
cv::Vec3d toward_camera();   // unit vector from the face toward the camera (-Z)
} // namespace facemodel

/* Solve head pose for one detection. fov_deg sets the assumed horizontal FOV
 * used to build K. Returns false if solvePnP fails. */
bool solve_head_pose(const FaceResult &f, int w, int h, double fov_deg,
		     HeadPose &out);

/* Build pose from the head-pose NET rotation (f.head_R) plus geometric
 * position/scale from the YuNet eye keypoints. Robust pitch. invert_* flip the
 * sign of each axis to match the render frame (set empirically). */
bool build_pose_from_net(const FaceResult &f, int w, int h, double fov_deg,
			 bool invert_pitch, bool invert_yaw, bool invert_roll,
			 HeadPose &out);

/* Project an object-space point to screen pixels; also returns camera-space
 * depth (z_cam > 0 in front of camera) for perspective-correct texturing. */
void project_point(const HeadPose &p, const cv::Vec3d &obj, cv::Point2d &screen,
		   double &z_cam);
