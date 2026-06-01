# Eye Mask Tracker — OBS plugin

Native OBS video filter that tracks the face and applies an **image or video
mask** to it in real time. Two render modes:

- **Flat quad** — projects the mask as a flat plane over the eyes; when the head
  turns (yaw/pitch/roll) it tilts in perspective. Size auto-tracks the face;
  position / scale / depth / rotation are adjustable.
- **Mesh morph** — deforms the mask onto the live face mesh (468 points), so the
  image bends and stretches with expressions and head turns (face-decal style).

## How it works

- **Detection:** OpenCV **YuNet** (`FaceDetectorYN`) finds the face + eyes on a
  worker thread.
- **Dense landmarks:** **MediaPipe FaceMesh** (468 points, ONNX via onnxruntime)
  refines tracking inside the face box — steadier eye centres than the 5 YuNet
  keypoints, and the geometry that drives mesh-morph mode. Toggleable.
- **Pose:** a dedicated **head-pose ONNX net** (mobilenetv2 → 3×3 rotation) gives
  robust yaw/pitch/roll; translation comes geometrically from the eyes.
- **Projection:** perspective-correct textured quad (flat mode) or a textured
  triangle list at the live landmarks (mesh mode).
- **Mask source:** any OBS *Image Source* or *Media Source*, referenced by name —
  images and video both work with no custom decoder. The selection auto-loads on
  restart.
- **Stability:** One-Euro filter + adaptive quaternion slerp on the pose, plus a
  moving-average window; hold + fade on face loss.

---

## Install on Windows (prebuilt installer)

1. Download `aye-aye-mask-<version>-windows-x64-installer.exe` from the
   [**Releases**](https://github.com/meketreve/aye-aye-sir-face-tracking-/releases/latest)
   page.
2. **Close OBS** (the plugin DLL is locked while OBS runs).
3. Run the installer (it asks for admin). It installs into your OBS folder:
   `obs-plugins\64bit\` (plugin + OpenCV/onnxruntime DLLs) and
   `data\obs-plugins\aye-aye-mask\` (effects, locale, models).
4. Open OBS — the filter appears as **Eye Mask Tracker**.

To uninstall: *Apps & features* → **Eye Mask Tracker**, or the bundled
`aye-aye-mask-uninstall.exe`.

---

## Install on Linux (build from source)

Tested on Ubuntu 24.04+/26.04 and WSLg.

```bash
# 1. Dependencies (libobs, OpenCV, onnxruntime, OBS itself)
sudo apt update
sudo apt install -y cmake pkg-config build-essential \
    libobs-dev libopencv-dev libonnxruntime-dev obs-studio

# 2. Get the source
git clone https://github.com/meketreve/aye-aye-sir-face-tracking-.git
cd aye-aye-sir-face-tracking-

# 3. Fetch the model files (YuNet, head-pose, FaceMesh) into data/models/
bash scripts/fetch-models.sh

# 4. Build
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build -j

# 5. Install into your per-user OBS plugin dir
cmake --install build
#    -> ~/.config/obs-studio/plugins/aye-aye-mask/

# 6. Run
obs
```

If `libonnxruntime-dev` is not in your distro's repos, install onnxruntime from
the [official releases](https://github.com/microsoft/onnxruntime/releases) and
point CMake at it with `-DORT_ROOT=/path/to/onnxruntime`.

> WSL note: WSLg does not expose USB webcams. Test with a **Media Source** (a
> face video) or attach a camera via `usbipd-win`.

---

## Use it in OBS

1. Add a video source with a face (Media Source / Video Capture Device).
2. Add a **mask** source: an *Image Source* (PNG with alpha) or a *Media Source*
   (video).
3. On the face source → **Filters** → **+** → **Eye Mask Tracker**.
4. Set **Mask source** to your image/video source.

Key controls:

| Control | What it does |
|---|---|
| **Mask source** | the image/video to apply (auto-loads on restart) |
| **Mesh morph** | off = flat quad over the eyes; on = deform onto the face mesh |
| **Dense landmarks (FaceMesh)** | steadier tracking; required for mesh morph |
| **Scale / Offset / Depth / Opacity** | place & size the flat mask |
| **Rotation follow** | 0 = billboard (always facing camera) … 1 = full 3D |
| **Smoothing** + **Moving-average window** | reduce jitter (more = smoother, more lag) |
| **Hold / Fade on face loss** | keep / fade the mask when tracking drops |
| **Invert pitch / yaw / roll** | fix axis orientation if needed |
| **Debug: show tracked landmarks** | overlay the detected points (incl. the 468 mesh) |

---

## Layout

| Path | Role |
|---|---|
| `src/plugin-main.cpp` | module entry, filter registration |
| `src/mask-filter.cpp` | filter: properties, orchestration, face-loss, mode switch |
| `src/frame-grab.cpp` | GPU readback (parent → downscaled BGR `cv::Mat`) |
| `src/tracker.cpp` | YuNet + head-pose + FaceMesh inference on a worker thread |
| `src/headpose.cpp` | head-pose ONNX net (onnxruntime) → rotation matrix |
| `src/landmarks.cpp` | FaceMesh ONNX net (onnxruntime) → 468 dense landmarks |
| `src/pose.cpp` | intrinsics, net-rotation + geometric translation, projection |
| `src/mask-renderer.cpp` + `data/effects/mask.effect` | flat quad + mesh-morph render |
| `src/facemesh_tables.hpp` | FaceMesh triangulation + frontal UV (generated) |
| `src/smoothing.cpp` | One-Euro + quaternion slerp + moving average |
| `data/models/` | YuNet (committed) + head-pose & FaceMesh (fetched) |
| `installer/` | Windows install layout + NSIS + build script |
| `.github/workflows/windows.yml` | CI that builds the Windows installer |

## Build the Windows installer yourself

CI (`.github/workflows/windows.yml`) builds it on every push. To build locally on
a Windows host (VS2022 + prebuilt OpenCV + onnxruntime + NSIS), see
[`installer/README.md`](installer/README.md).

## Credits

- [YuNet](https://github.com/opencv/opencv_zoo) face detector (OpenCV Zoo)
- [head-pose-estimation](https://github.com/yakhyo/head-pose-estimation) (yakhyo)
- [MediaPipe FaceMesh](https://github.com/google-ai-edge/mediapipe), ONNX via
  [keijiro/FaceLandmarkBarracuda](https://github.com/keijiro/FaceLandmarkBarracuda) (Apache-2.0)
