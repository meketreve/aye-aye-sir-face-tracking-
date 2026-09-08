# Memory

> Chronological action log. Hooks and AI append to this file automatically.
> Old sessions are consolidated by the daemon weekly.
| 18:18 | Edited ../../../../home/meketreve/.claude/settings.json | 3→7 lines | ~61 |

## Session: 2026-05-31 18:19

| Time | Action | File(s) | Outcome | ~Tokens |
|------|--------|---------|---------|--------|

## Session: 2026-05-31 18:19

| Time | Action | File(s) | Outcome | ~Tokens |
|------|--------|---------|---------|--------|

## Session: 2026-05-31 18:19

| Time | Action | File(s) | Outcome | ~Tokens |
|------|--------|---------|---------|--------|
| 18:29 | Created ../../../../home/meketreve/.claude/plans/lively-exploring-brooks.md | — | ~2379 |
| 18:35 | Created CMakeLists.txt | — | ~622 |
| 18:35 | Created src/mask-filter.hpp | — | ~59 |
| 18:35 | Created src/plugin-main.cpp | — | ~165 |
| 18:35 | Edited CMakeLists.txt | 3→4 lines | ~76 |
| 18:36 | Created src/mask-filter.cpp | — | ~365 |
| 18:36 | Created data/locale/en-US.ini | — | ~10 |

## Session note — 2026-05-31

Started OBS face-tracking mask plugin (native C++ libobs filter). Plan approved (lively-exploring-brooks.md). M1 code written: CMake + plugin-main + no-op passthrough filter + locale. **BLOCKED on build**: env has g++/make/git but NO cmake/pkg-config/libobs-dev/opencv/OBS, and sudo needs a password (can't install from agent). All deps exist in Ubuntu 26.04 universe (libobs-dev 32.1.0, obs-studio 32.1.0, libopencv-dev 4.10.0). User must run the apt install (handed off). Next: validate M1 loads in OBS, then M2 (frame-grab + YuNet).
| 18:38 | Session end: 7 writes across 6 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 0 reads | ~3939 tok |
| 18:45 | Created src/tracker.hpp | — | ~540 |
| 18:46 | Created src/tracker.cpp | — | ~851 |
| 18:46 | Created src/frame-grab.hpp | — | ~275 |
| 18:46 | Created src/frame-grab.cpp | — | ~653 |
| 18:47 | Created src/mask-filter.cpp | — | ~1757 |
| 18:47 | Edited CMakeLists.txt | 4→6 lines | ~28 |
| 18:47 | Edited CMakeLists.txt | expanded (+9 lines) | ~214 |
| 18:48 | Created data/locale/en-US.ini | — | ~72 |
| 18:48 | Edited src/tracker.cpp | inline fix | ~19 |
| 18:54 | Created src/pose.hpp | — | ~346 |
| 18:54 | Created src/pose.cpp | — | ~600 |
| 18:54 | Created data/effects/mask.effect | — | ~242 |
| 18:55 | Created src/mask-renderer.hpp | — | ~443 |
| 18:55 | Created src/mask-renderer.cpp | — | ~1387 |
| 18:55 | Edited src/mask-filter.cpp | 5→7 lines | ~41 |
| 18:56 | Edited src/mask-filter.cpp | 17→21 lines | ~118 |
| 18:56 | Edited src/mask-filter.cpp | expanded (+8 lines) | ~160 |
| 18:56 | Edited src/mask-filter.cpp | modified mask_update() | ~282 |
| 18:56 | Edited src/mask-filter.cpp | added 2 condition(s) | ~684 |
| 18:56 | Edited src/mask-filter.cpp | added 3 condition(s) | ~140 |
| 18:56 | Edited src/mask-filter.cpp | 5→6 lines | ~33 |
| 18:56 | Edited CMakeLists.txt | 6→8 lines | ~38 |
| 18:57 | Created data/locale/en-US.ini | — | ~151 |
| 18:57 | Edited src/mask-renderer.cpp | gs_vertbuffer_create() → gs_vertexbuffer_create() | ~69 |
| 18:57 | Edited src/mask-renderer.cpp | gs_vertbuffer_destroy() → gs_vertexbuffer_destroy() | ~17 |
| 18:59 | Session end: 32 writes across 15 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 0 reads | ~13752 tok |
| 19:01 | Created src/smoothing.hpp | — | ~383 |
| 19:02 | Created src/smoothing.cpp | — | ~880 |
| 19:02 | Edited src/smoothing.hpp | modified reset() | ~53 |
| 19:02 | Edited src/mask-filter.cpp | 2→3 lines | ~20 |
| 19:02 | Edited src/mask-filter.cpp | 12→14 lines | ~91 |
| 19:02 | Edited src/mask-filter.cpp | 3→5 lines | ~59 |
| 19:02 | Edited src/mask-filter.cpp | 4→7 lines | ~97 |
| 19:02 | Edited src/mask-filter.cpp | 4→6 lines | ~74 |
| 19:02 | Edited src/mask-filter.cpp | expanded (+6 lines) | ~103 |
| 19:02 | Edited src/mask-filter.cpp | 5→8 lines | ~68 |
| 19:02 | Edited CMakeLists.txt | 3→4 lines | ~16 |
| 19:03 | Edited data/locale/en-US.ini | 2→4 lines | ~52 |
| 19:04 | Edited CMakeLists.txt | added 1 condition(s) | ~265 |
| 19:05 | Created installer/aye-aye-mask.nsi | — | ~695 |
| 19:05 | Created installer/build-and-package.ps1 | — | ~747 |
| 19:05 | Created installer/README.md | — | ~657 |
| 19:22 | Edited src/mask-filter.cpp | expanded (+7 lines) | ~104 |
| 19:22 | Edited src/mask-filter.cpp | 3→8 lines | ~99 |
| 19:22 | Edited src/mask-filter.cpp | 3→5 lines | ~80 |
| 19:22 | Edited src/mask-filter.cpp | 2→4 lines | ~60 |
| 19:22 | Edited src/mask-filter.cpp | 5→9 lines | ~103 |
| 19:23 | Edited src/mask-filter.cpp | added 5 condition(s) | ~379 |
| 19:23 | Edited data/locale/en-US.ini | 2→4 lines | ~47 |
| 19:23 | Created data/locale/pt-BR.ini | — | ~228 |
| 19:23 | Created README.md | — | ~714 |
| 19:24 | Session end: 57 writes across 21 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 0 reads | ~20261 tok |
| 19:27 | Session end: 57 writes across 21 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 0 reads | ~20261 tok |
| 19:29 | Session end: 57 writes across 21 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 0 reads | ~20261 tok |
| 19:29 | Session end: 57 writes across 21 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 0 reads | ~20261 tok |
| 19:33 | Created installer/build-and-install.bat | — | ~981 |
| 19:33 | Edited installer/README.md | modified equivalent() | ~271 |
| 19:33 | Session end: 59 writes across 22 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 0 reads | ~21602 tok |
| 19:54 | Edited installer/build-and-install.bat | 7→11 lines | ~102 |
| 19:54 | Session end: 60 writes across 22 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 0 reads | ~21711 tok |
| 20:18 | Edited CMakeLists.txt | added 1 condition(s) | ~222 |
| 20:19 | Created .github/workflows/windows.yml | — | ~1391 |
| 20:19 | Created .gitignore | — | ~71 |
| 20:19 | Edited installer/README.md | expanded (+17 lines) | ~255 |
| 20:20 | Session end: 64 writes across 24 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 0 reads | ~23688 tok |
| 20:22 | Session end: 64 writes across 24 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 0 reads | ~23688 tok |
| 20:37 | Edited src/pose.cpp | added error handling | ~135 |
| 20:37 | Edited src/pose.cpp | 3→5 lines | ~20 |
| 20:37 | Edited src/mask-filter.cpp | 3→4 lines | ~27 |
| 20:37 | Edited src/mask-filter.cpp | modified if() | ~58 |
| 20:39 | Session end: 68 writes across 24 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 0 reads | ~23946 tok |
| 21:03 | Edited src/tracker.hpp | 23→26 lines | ~229 |
| 21:04 | Edited src/tracker.hpp | 4→6 lines | ~75 |
| 21:04 | Edited src/tracker.hpp | 2→3 lines | ~24 |
| 21:04 | Edited src/tracker.cpp | modified start() | ~81 |
| 21:04 | Edited src/tracker.cpp | modified catch() | ~179 |
| 21:05 | Edited src/tracker.cpp | added error handling | ~403 |
| 21:05 | Edited src/pose.cpp | 9→10 lines | ~149 |
| 21:05 | Edited src/pose.cpp | 9→11 lines | ~99 |
| 21:05 | Edited src/mask-filter.cpp | 1→2 lines | ~36 |
| 21:06 | Edited src/mask-filter.cpp | modified if() | ~80 |
| 21:06 | Edited src/mask-filter.cpp | 6→7 lines | ~70 |
| 21:06 | Edited CMakeLists.txt | inline fix | ~21 |
| 21:08 | Edited .gitignore | 7→10 lines | ~42 |
| 21:08 | Created scripts/fetch-models.sh | — | ~199 |
| 21:08 | Edited .github/workflows/windows.yml | 19→23 lines | ~185 |
| 21:08 | Edited installer/build-and-install.bat | inline fix | ~27 |
| 21:08 | Edited installer/build-and-install.bat | expanded (+7 lines) | ~112 |
| 21:09 | Edited installer/build-and-package.ps1 | 2→2 lines | ~43 |
| 21:09 | Edited installer/build-and-package.ps1 | added 1 condition(s) | ~120 |
| 21:09 | Edited README.md | 2→4 lines | ~61 |
| 21:09 | Edited README.md | 5→6 lines | ~72 |
| 21:10 | Session end: 89 writes across 25 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 1 reads | ~27274 tok |
| 21:42 | Session end: 89 writes across 25 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 1 reads | ~27274 tok |
| 21:49 | Created src/headpose.hpp | — | ~242 |
| 21:50 | Created src/headpose.cpp | — | ~692 |
| 21:50 | Edited src/tracker.hpp | 11→13 lines | ~107 |
| 21:50 | Edited src/tracker.hpp | 4→5 lines | ~72 |
| 21:50 | Edited src/tracker.hpp | 2→3 lines | ~26 |
| 21:50 | Edited src/tracker.cpp | 5→8 lines | ~34 |
| 21:50 | Edited src/tracker.cpp | modified start() | ~85 |
| 21:50 | Edited src/tracker.cpp | added 1 condition(s) | ~186 |
| 21:51 | Edited src/tracker.cpp | added 3 condition(s) | ~412 |
| 21:51 | Edited src/pose.hpp | expanded (+7 lines) | ~162 |
| 21:51 | Edited src/pose.cpp | added 6 condition(s) | ~591 |
| 21:51 | Edited src/mask-filter.cpp | 1→2 lines | ~41 |
| 21:51 | Edited src/mask-filter.cpp | 4→7 lines | ~50 |
| 21:52 | Edited src/mask-filter.cpp | 3→6 lines | ~72 |
| 21:52 | Edited src/mask-filter.cpp | 4→7 lines | ~88 |
| 21:52 | Edited src/mask-filter.cpp | modified if() | ~88 |
| 21:52 | Edited src/mask-filter.cpp | 4→7 lines | ~88 |
| 21:52 | Edited src/mask-filter.cpp | 2→6 lines | ~94 |
| 21:52 | Edited src/mask-filter.cpp | solve_head_pose() → build_pose_from_net() | ~42 |
| 21:52 | Edited CMakeLists.txt | 4→5 lines | ~22 |
| 21:52 | Edited CMakeLists.txt | added 1 condition(s) | ~265 |
| 21:53 | Edited data/locale/en-US.ini | 3→6 lines | ~60 |
| 21:53 | Edited data/locale/pt-BR.ini | 3→6 lines | ~68 |
| 21:54 | Edited src/pose.cpp | 4→6 lines | ~87 |
| 21:55 | Edited .gitignore | 2→4 lines | ~44 |
| 21:55 | Edited scripts/fetch-models.sh | yaml() → net() | ~87 |
| 21:56 | Session end: 115 writes across 27 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 1 reads | ~31349 tok |
| 22:29 | Edited src/pose.cpp | 12→14 lines | ~147 |
| 22:31 | Edited CMakeLists.txt | added 1 condition(s) | ~220 |
| 22:32 | Created .github/workflows/windows.yml | — | ~1309 |
| 22:32 | Edited installer/aye-aye-mask.nsi | 8→9 lines | ~111 |
| 22:32 | Edited installer/build-and-install.bat | grande() → pose() | ~98 |
| 22:32 | Edited installer/build-and-install.bat | modified requisitos() | ~136 |
| 22:33 | Created installer/README.md | — | ~520 |
| 22:33 | Edited README.md | 6→6 lines | ~79 |
| 22:33 | Edited README.md | 4→5 lines | ~78 |
| 22:33 | Edited README.md | 2→3 lines | ~64 |
| 22:34 | Session end: 125 writes across 27 files (lively-exploring-brooks.md, CMakeLists.txt, mask-filter.hpp, plugin-main.cpp, mask-filter.cpp) | 1 reads | ~34213 tok |

## Session: 2026-06-01 08:56

| Time | Action | File(s) | Outcome | ~Tokens |
|------|--------|---------|---------|--------|
| 09:04 | Edited .github/workflows/windows.yml | 9→9 lines | ~183 |
| 09:07 | Edited .github/workflows/windows.yml | "OBS-Studio-$ver-Windows-x" → "OBS-Studio-$ver-Windows.z" | ~14 |
| 09:11 | Edited src/headpose.cpp | 3→4 lines | ~19 |
| 09:11 | Edited src/headpose.cpp | 2→7 lines | ~90 |
| 09:14 | Session end: 4 writes across 2 files (windows.yml, headpose.cpp) | 5 reads | ~2315 tok |
| 09:17 | Edited .github/workflows/windows.yml | 5→7 lines | ~138 |
| 09:17 | Edited .github/workflows/windows.yml | 2→2 lines | ~23 |
| 09:19 | Session end: 6 writes across 2 files (windows.yml, headpose.cpp) | 7 reads | ~3228 tok |
| 09:27 | Edited .gitignore | 5→6 lines | ~23 |

## Session note — 2026-06-01 (Windows CI green + .exe)
- Pushed 6 backlog commits to origin/main, then drove the `windows` workflow to green through 4 fixes:
  1. windows.yml `Get libobs`: generated header is `libobs/obsconfig.h.in`→`obsconfig.h` (NO dash); `obs-config.h` is a separate committed static header. Strip `#cmakedefine`, resolve `@OBS_RELEASE_CANDIDATE@`/`@OBS_BETA@`→0.
  2. windows.yml: OBS release asset = `OBS-Studio-<ver>-Windows.zip` (dropped bogus `-x64`); 404 before.
  3. src/headpose.cpp: `Ort::Session` wants `const ORTCHAR_T*` (wchar_t* on Win). Pass `std::filesystem::u8path(model_path).c_str()` — native type == ORTCHAR_T, portable, no #ifdef. Linux still builds.
  4. windows.yml: NSIS resolves `File` relative to the .nsi dir (`installer/`), so stage with `--prefix installer/package` and upload that path.
- Result: run 26754403755 SUCCESS. Artifacts: installer .exe + plugin zip. Downloaded → `dist/aye-aye-mask-0.1.0-windows-x64-installer.exe` (34.5MB). Added `/dist/` to .gitignore.
- Logged bug-025/026/027; cerebrum Do-Not-Repeat += ORTCHAR_T, OBS asset name, `gh run watch --exit-status` caveat.
- NEXT: user runs the .exe on Windows OBS for visual validation.
| 09:30 | Session end: 7 writes across 3 files (windows.yml, headpose.cpp, .gitignore) | 9 reads | ~3391 tok |
| 09:48 | Edited src/mask-renderer.cpp | modified for() | ~174 |
| 09:48 | Edited data/effects/mask.effect | 4→4 lines | ~35 |
| 09:49 | Edited data/effects/mask.effect | inline fix | ~9 |
| 09:54 | Session end: 10 writes across 5 files (windows.yml, headpose.cpp, .gitignore, mask-renderer.cpp, mask.effect) | 12 reads | ~8822 tok |
| 09:57 | Session end: 10 writes across 5 files (windows.yml, headpose.cpp, .gitignore, mask-renderer.cpp, mask.effect) | 13 reads | ~8822 tok |
| 10:07 | Edited src/smoothing.hpp | 4→5 lines | ~28 |
| 10:07 | Edited src/smoothing.hpp | 2→6 lines | ~72 |
| 10:07 | Edited src/smoothing.hpp | 5→10 lines | ~56 |
| 10:07 | Edited src/smoothing.cpp | modified set_avg_window() | ~93 |
| 10:08 | Edited src/smoothing.cpp | added 1 condition(s) | ~238 |
| 10:08 | Edited src/mask-filter.cpp | 1→2 lines | ~26 |
| 10:08 | Edited src/mask-filter.cpp | 1→2 lines | ~39 |
| 10:08 | Edited src/mask-filter.cpp | 1→2 lines | ~29 |
| 10:08 | Edited src/mask-filter.cpp | 3→6 lines | ~59 |
| 10:08 | Edited data/locale/en-US.ini | 1→2 lines | ~29 |
| 10:08 | Edited data/locale/pt-BR.ini | 1→2 lines | ~29 |

## Session note — 2026-06-01 (mask visible + anti-jitter)
- Windows mask-invisible bug fixed via OBS log: D3D11 rejects texcoord width 3 → vbuffer null → no draw. Padded to width 4 (mask-renderer.cpp + mask.effect). User confirmed mask now visible. bug-031.
- Jitter still high → added "Moving-average window" slider (1–30 frames, 1=off). PoseSmoother post-filters the 1€/slerp output with an N-frame boxcar: mean translation + sign-aligned quaternion mean. smoothing.{hpp,cpp} + mask-filter.cpp wiring + en-US/pt-BR locale. (run 26756921011 green; .exe in dist/.)
- NEXT: user reinstalls, raises avg window until jitter gone, balances vs latency.
| 10:19 | Session end: 21 writes across 10 files (windows.yml, headpose.cpp, .gitignore, mask-renderer.cpp, mask.effect) | 18 reads | ~11320 tok |
| 10:29 | Session end: 21 writes across 10 files (windows.yml, headpose.cpp, .gitignore, mask-renderer.cpp, mask.effect) | 18 reads | ~11320 tok |
| 10:42 | Created src/landmarks.hpp | — | ~386 |
| 10:42 | Created src/landmarks.cpp | — | ~788 |
| 10:42 | Edited CMakeLists.txt | 3→4 lines | ~16 |
| 10:42 | Edited src/tracker.hpp | 6→7 lines | ~37 |
| 10:42 | Edited src/tracker.hpp | 4→7 lines | ~68 |
| 10:43 | Edited src/tracker.hpp | modified set_landmarks_enabled() | ~174 |
| 10:43 | Edited src/tracker.hpp | 3→5 lines | ~44 |
| 10:43 | Edited src/tracker.cpp | 4→5 lines | ~26 |
| 10:43 | Edited src/tracker.cpp | modified start() | ~83 |
| 10:43 | Edited src/tracker.cpp | added 1 condition(s) | ~118 |
| 10:44 | Edited src/tracker.cpp | added 3 condition(s) | ~469 |
| 10:44 | Edited src/mask-filter.cpp | 2→3 lines | ~60 |
| 10:44 | Edited src/mask-filter.cpp | 1→2 lines | ~23 |
| 10:44 | Edited src/mask-filter.cpp | 2→3 lines | ~34 |
| 10:44 | Edited src/mask-filter.cpp | modified if() | ~118 |
| 10:44 | Edited src/mask-filter.cpp | 1→2 lines | ~29 |
| 10:44 | Edited src/mask-filter.cpp | 1→2 lines | ~38 |
| 10:44 | Edited src/mask-filter.cpp | added 1 condition(s) | ~112 |
| 10:44 | Edited data/locale/en-US.ini | 1→2 lines | ~29 |
| 10:44 | Edited data/locale/pt-BR.ini | 1→2 lines | ~31 |
| 10:45 | Edited scripts/fetch-models.sh | expanded (+9 lines) | ~176 |
| 10:45 | Edited .gitignore | 2→3 lines | ~27 |
| 10:49 | Session end: 43 writes across 16 files (windows.yml, headpose.cpp, .gitignore, mask-renderer.cpp, mask.effect) | 23 reads | ~17566 tok |

## Session note — 2026-06-01 (M10a: FaceMesh dense landmarks)
- User asked for dlib-68; corrected: dlib doesn't improve detection (YuNet ≥ dlib HOG), only gives dense landmarks, and dlib-68 = 99MB + iBUG research-only license + heavy build. Chose MediaPipe FaceMesh 468 (keijiro Apache ONNX, 2.44MB) instead. User confirmed: want selectable mesh-morph + more precise tracking.
- Validated FaceMesh in Python on test/face.jpg: input [1,3,192,192] RGB/255 NCHW, out conv2d_20=468×3 (192-space) + conv2d_30 presence logit. Points land on face. /tmp/facemesh.onnx.
- M10a built: src/landmarks.{hpp,cpp} (LandmarkNet, mirrors HeadPoseNet). tracker runs FaceMesh in YuNet bbox crop, refines eye centres from mesh corner means (idx 33/133/362/263). FaceResult.mesh + has_mesh. "Dense landmarks" toggle (default on). Debug draws 468. fetch-models.sh + CI bundle face_landmark_468.onnx. CI green run 26758924126; .exe in dist/ (38MB).
- NEXT M10b: selectable mesh-morph render (canonical FaceMesh triangulation+UV, deforming textured triangle list). Caveat: mask art must be a face-UV template. Optional roll-aligned crop for tilted-face accuracy.
| 10:53 | Session end: 43 writes across 16 files (windows.yml, headpose.cpp, .gitignore, mask-renderer.cpp, mask.effect) | 24 reads | ~17566 tok |
| 11:04 | Created scripts/gen-facemesh-tables.py | — | ~708 |
| 11:04 | Edited data/effects/mask.effect | modified VSMesh() | ~167 |
| 11:04 | Edited src/mask-renderer.hpp | 4→7 lines | ~28 |
| 11:04 | Edited src/mask-renderer.hpp | expanded (+8 lines) | ~252 |
| 11:04 | Edited src/mask-renderer.cpp | 6→7 lines | ~32 |
| 11:05 | Edited src/mask-renderer.cpp | added 1 condition(s) | ~46 |
| 11:05 | Edited src/mask-renderer.cpp | added 6 condition(s) | ~649 |
| 11:05 | Edited src/mask-renderer.cpp | modified if() | ~31 |
| 11:06 | Edited src/mask-filter.cpp | 2→4 lines | ~27 |
| 11:06 | Edited src/mask-filter.cpp | 5→9 lines | ~60 |
| 11:06 | Edited src/mask-filter.cpp | 1→2 lines | ~25 |
| 11:06 | Edited src/mask-filter.cpp | 2→4 lines | ~62 |
| 11:06 | Edited src/mask-filter.cpp | 2→3 lines | ~44 |
| 11:06 | Edited src/mask-filter.cpp | 2→3 lines | ~58 |
| 11:06 | Edited src/mask-filter.cpp | added 2 condition(s) | ~219 |
| 11:07 | Edited src/mask-filter.cpp | modified if() | ~41 |
| 11:07 | Edited data/locale/en-US.ini | 1→2 lines | ~36 |
| 11:07 | Edited data/locale/pt-BR.ini | 1→2 lines | ~39 |

## Session note — 2026-06-01 (M10b: mesh-morph mode)
- User approved M10a, asked to proceed. Chose frontal-UV mesh-morph (any image works, deforms with face) over hand-authored UV templates.
- Generated src/facemesh_tables.hpp from MediaPipe canonical_face_model.obj (898 tris + frontal UV) via scripts/gen-facemesh-tables.py.
- mask.effect +DrawMesh (float2 uv). MaskRenderer::render_mesh draws textured triangle list at live 468 landmarks + cached static index buffer (GS_UNSIGNED_LONG). "Mesh morph" toggle (default off). Landmark EMA smoothing (Smoothing slider) since mesh mode bypasses pose smoother.
- Build Linux OK. CI run 26760086229 (pending at note time). NEXT: download .exe; user tests mesh mode visually on Windows/D3D11.
| 11:13 | Session end: 61 writes across 18 files (windows.yml, headpose.cpp, .gitignore, mask-renderer.cpp, mask.effect) | 26 reads | ~21208 tok |
| 11:22 | Edited src/mask-renderer.hpp | 3→5 lines | ~51 |
| 11:22 | Edited src/mask-renderer.cpp | modified set_source() | ~124 |
| 11:22 | Edited src/mask-renderer.cpp | added 2 condition(s) | ~136 |
| 11:27 | Session end: 64 writes across 18 files (windows.yml, headpose.cpp, .gitignore, mask-renderer.cpp, mask.effect) | 26 reads | ~21542 tok |

## Session note — 2026-06-01 (startup mask-source fix)
- Bug: mask blank on OBS launch until user reselects the source (bug-032). Cause: eager obs_get_source_by_name in set_source ran before the referenced source existed (OBS load order). Fix: store name, lazy-resolve in resolve_mask_texture each frame until found, cache weak ref. mask-renderer.{hpp,cpp}. CI green run 26761131378; .exe in dist/.
| 11:35 | Session end: 64 writes across 18 files (windows.yml, headpose.cpp, .gitignore, mask-renderer.cpp, mask.effect) | 27 reads | ~21542 tok |
| 11:43 | Created README.md | — | ~1567 |
| 11:47 | Session end: 65 writes across 19 files (windows.yml, headpose.cpp, .gitignore, mask-renderer.cpp, mask.effect) | 28 reads | ~23974 tok |
| 14:05 | Session end: 65 writes across 19 files (windows.yml, headpose.cpp, .gitignore, mask-renderer.cpp, mask.effect) | 28 reads | ~23974 tok |
| 14:10 | Session end: 65 writes across 19 files (windows.yml, headpose.cpp, .gitignore, mask-renderer.cpp, mask.effect) | 28 reads | ~23974 tok |
