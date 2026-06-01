# Cerebrum

> OpenWolf's learning memory. Updated automatically as the AI learns from interactions.
> Do not edit manually unless correcting an error.
> Last updated: 2026-05-31

## User Preferences

- User writes in Portuguese (pt-BR). Ask clarifying questions and explain in PT.
- **Audible alert when input needed:** run `powershell.exe -NoProfile -c "[System.Media.SystemSounds]::Exclamation.Play()"` at handoff/blocked points. (`echo -ne "\007"` does NOT work — Bash tool stdout is captured by the harness, never reaches the user's TTY. powershell.exe from WSL plays real audio on the Windows host; user confirmed audible 2026-05-31.)

## Key Learnings

- **Project:** aye-aye-sir ( face tracking ) = native C++ OBS plugin. Tracks face/eyes, projects an image/video mask in 3D over the eyes; mask follows full head rotation in perspective.
- **Stack:** libobs (OBS 32.1) video filter + OpenCV 4.10 (YuNet `FaceDetectorYN` for detection+5 keypoints, `solvePnP` for head pose). Mask = textured 3D quad via MVP matrix.
- **Repo location:** /mnt/d (= Windows D:\) shared with Windows host. Dev in WSL, build/test on OBS Linux via WSLg; Windows build later (same CMake).
- **Build deps (Ubuntu 26.04 universe):** `cmake pkg-config build-essential libobs-dev libopencv-dev obs-studio`. libobs-dev 32.1.0, obs-studio 32.1.0, libopencv-dev 4.10.0 all available.
- **Video mask trick:** reference another OBS source (Image/Media Source) and render it to a texrender — covers image AND video with zero decoder code.
- **OBS plugin install path (Linux, per-user):** `~/.config/obs-studio/plugins/<name>/bin/64bit/<name>.so` + `.../data/`.
- **OBS gs API names (32.1):** vertex buffers = `gs_vertexbuffer_create/destroy` (NOT gs_vertbuffer_*); blend enums = `GS_BLEND_SRCALPHA`/`GS_BLEND_INVSRCALPHA`; custom vbuffer via `gs_vbdata_create()` + `bzalloc` arrays. Effects auto-receive `uniform float4x4 ViewProj`. **Texture-vertex `tvarray[].width` MUST be 2 or 4** — D3D11 rejects 3 ("Invalid texture vertex size specified", vbuffer create returns null). For projective texcoords pad to width 4: `(u/z, v/z, 0, 1/z)`, divide by `.w` in the pixel shader (GL accepts 3 but Windows is D3D11).
- **Perspective-correct 2D quad trick:** project 4 corners on CPU (cv::projectPoints / manual K*[R|t]), draw in OBS ortho/pixel space with projective texcoord `(u/z, v/z, 1/z)`, divide in pixel shader. Skip the headache of replacing OBS's projection matrix. Implemented in `data/effects/mask.effect` + `mask-renderer.cpp`.
- **Head-pose model:** 5-pt model in `pose.cpp` (nose origin, eyes (±165,170,-135), mouth (±150,-150,-125)), Y-up, X image-right. solvePnP SOLVEPNP_ITERATIVE. K from assumed FOV (default 60°). Mask size auto-tracks face because fixed-size model projected at solved tvec.
- **Mask texture = referenced OBS source:** property `mask_source` (editable source dropdown) → obs_weak_source → render to texrender → use texture. Covers image + video, no decoder.
- **Build validated:** YuNet column layout = [x,y,w,h, REye(x,y), LEye, Nose, RMouth, LMouth, score] (15 cols). kp0=subject's right eye = image LEFT.
- **Pitch FAIL with landmarks:** YuNet 5pt → pitch weakly observable (no chin). Facemark LBF 68pt (chin) → MORE jitter + worse roll (LBF chin is noisy and has huge pose leverage at Y=-330). Both bad. Reverted to YuNet 5pt (stable, yaw+roll good, pitch flat). Lesson: pitch needs an accurate DEDICATED head-pose net, not noisy landmarks.
- **Head-pose net solution (M8):** yakhyo/head-pose-estimation ONNX (mobilenetv2 8.5MB / resnet18 43MB). Output = 3x3 rotation matrix directly. Input: face crop bbox+0.2 margin, 224x224, BGR->RGB, /255, ImageNet mean[.485,.456,.406] std[.229,.224,.225], NCHW. Validated on user's video: pitch RESPONDS (+37 up, -15 down), yaw/roll too. Plan: YuNet=position/scale, net=rotation.
- **cv::dnn CANNOT load these ONNX** (Gather layer error, OpenCV 4.10 importer bug). Use **onnxruntime** (`libonnxruntime-dev` 1.23 in Ubuntu 26.04 apt; vcpkg `onnxruntime` for Windows, no contrib needed).
- **Quick model validation trick:** pip `--user --break-system-packages onnxruntime opencv-python-headless` (PEP668 + no python3-venv), run pipeline in Python on real frames before C++ integration.
- **Dense landmarks (M10a):** MediaPipe FaceMesh 468pt via keijiro's Apache-2.0 ONNX `face_landmark_barracuda.onnx` (2.44MB, `keijiro/FaceLandmarkBarracuda` repo, raw path `Packages/jp.keijiro.mediapipe.facelandmark/ONNX/`). Input `[1,3,192,192]` RGB `/255` NCHW; outputs `conv2d_20` `[1,1404,1,1]`=468×3 (x,y in 192-space, z rel) and `conv2d_30` `[1,1,1,1]`=presence logit (sigmoid>0.5 ⇒ logit>0; validated face gave ~20). Chosen over dlib-68 (99MB + iBUG 300-W research-only license + heavy build). MediaPipe's canonical triangulation+UV makes future mesh-morph easy. Eye-corner indices: right 33(outer)/133(inner), left 263(outer)/362(inner).
- **Pipeline (M10a):** YuNet detects bbox → head-pose net gives rotation R → FaceMesh refines dense landmarks inside a square bbox crop (×1.5). Eye centres taken from mesh eye-corner means (steadier than YuNet 5pt) feed mask position/scale. Axis-aligned crop (no roll-align yet) → slight error on heavily tilted faces; fine for upright streaming.
- **Mesh-morph (M10b):** `facemesh_tables.hpp` (gen from MediaPipe `canonical_face_model.obj` via `scripts/gen-facemesh-tables.py`) holds the 898-triangle list + per-vertex **frontal-projection UV** (normalized canonical x,y, Y flipped). Mesh mode draws a textured triangle list at the live 468 screen-space landmarks → image deforms with the face; any picture/video works (mapped as a front-facing decal, no hand-authored UV needed). `mask.effect` technique `DrawMesh` uses plain float2 UV (mesh already in screen space, no projective texcoord). Static index buffer cached in MaskRenderer (`gs_indexbuffer_create(GS_UNSIGNED_LONG, idx, n, 0)`, takes ownership of bmalloc'd idx). Landmark points EMA-smoothed in mask-filter (alpha from Smoothing slider) since mesh mode bypasses the pose smoother.

## Do-Not-Repeat

<!-- Format: [YYYY-MM-DD] Description of what went wrong and what to do instead. -->
- [2026-05-31] `sudo` in this WSL env requires an interactive password — agent CANNOT run `sudo apt install`. Hand apt commands to the user (run via `! sudo ...` in-session). Don't retry sudo non-interactively.
- [2026-05-31] Fresh env has g++/make/git but NOT cmake/pkg-config/libobs/opencv/obs. Don't assume a build toolchain exists; probe first.
- [2026-05-31] `cv::solvePnP` with `SOLVEPNP_ITERATIVE` on a NON-coplanar model THROWS if <6 points ("DLT needs at least 6 points"). Our model = 5 pts (YuNet) → use `SOLVEPNP_SQPNP` (works >=3). Uncaught it aborted OBS. ALWAYS wrap OpenCV calls on the OBS graphics thread in try/catch — an uncaught C++ exception in video_render kills the whole OBS process.
- [2026-06-01] libobs generated config header = `libobs/obsconfig.h.in` → `obsconfig.h` (NO dash). `obs-config.h` (WITH dash) is a SEPARATE already-committed static version header — do not confuse them. When generating obsconfig.h from the .in outside CMake: strip `#cmakedefine` lines and resolve `@OBS_RELEASE_CANDIDATE@`/`@OBS_BETA@` → 0. The old `@OBS_VERSION_*@` tokens are gone since OBS 28+. (windows.yml CI bug-025.)
- [2026-06-01] onnxruntime `Ort::Session` (and APIs taking model paths) use `const ORTCHAR_T*` = `char*` on POSIX but `wchar_t*` on Windows. `std::string::c_str()` compiles on Linux, fails MSVC (C2665). Portable fix: pass `std::filesystem::path::c_str()` (native type == ORTCHAR_T), build the path via `std::filesystem::u8path(utf8str)`. No `#ifdef` needed.
- [2026-06-01] OBS Windows release asset = `OBS-Studio-<ver>-Windows.zip` (NO `-x64`). The Linux/source download names differ — verify real asset names with `gh api repos/obsproject/obs-studio/releases/tags/<ver> -q '.assets[].name'` before hardcoding a download URL in CI.
- [2026-06-01] OBS custom vertex buffer `tvarray[].width=3` works on OpenGL (Linux) but D3D11 (Windows) REJECTS it → `gs_vertexbuffer_create` returns null → silent no-draw. Symptom: feature works in Linux OBS, invisible in the Windows build, debug overlay (built-in SOLID effect) still draws. ALWAYS use texcoord width 2 or 4. Test graphics features on the actual Windows/D3D11 build, not just Linux/GL. (bug-031)
- [2026-06-01] OBS log on Windows host (readable from WSL): `/mnt/c/Users/<User>/AppData/Roaming/obs-studio/logs/*.txt`. Our plugin's `blog()` lines (`[aye-aye-mask] ...`) and libobs graphics errors (e.g. `device_vertexbuffer_create (D3D11): ...`) land here — grep it FIRST when debugging Windows-only runtime issues instead of guessing.
- [2026-06-01] `gh run watch --exit-status` exits 0 if the run ALREADY completed before watch attaches (it just prints "has already completed with 'failure'"). Don't trust the watch exit code alone — always re-query `gh run view --json conclusion` to confirm pass/fail.

## Decision Log

- [2026-05-31] Native C++ libobs filter chosen over Browser-Source overlay — user wants a real OBS plugin that filters any source (accepted higher effort).
- [2026-05-31] Tracking = OpenCV YuNet (5 keypoints) + solvePnP, NOT dlib (avoids ~99MB model; YuNet ~340KB, Apache) and NOT MediaPipe C++ (Bazel build pain).
- [2026-05-31] 3D projection = real 3D quad + MVP matrix (perspective-correct for free), with cv::projectPoints+homography warp as documented fallback.
- [2026-05-31] Mask follows FULL head rotation (yaw/pitch/roll) per user, with a rotation-follow strength slider.
- [2026-06-01] Referencing another OBS source by name: resolve it LAZILY on the render/graphics thread, not eagerly in update/load. At scene load OBS may create this filter before the referenced source exists, so `obs_get_source_by_name()` returns null and the mask stays blank until manual reselect. Store the NAME, retry the lookup each frame until it resolves, then cache the weak ref. (bug-032)
- [2026-06-01] Dense landmarks = MediaPipe FaceMesh 468 (ONNX/onnxruntime), NOT dlib-68. Reason: dlib model 99MB + iBUG 300-W research/non-commercial license (bad for a streaming plugin) + heavy build; FaceMesh is 2.4MB, Apache-2.0, fits the existing onnxruntime stack, and its canonical triangulation+UV enables mesh-morph. YuNet stays as the detector (better than dlib HOG on angle/occlusion). User goal: selectable mesh-morph render mode + more precise tracking.
