# anatomy.md

> Auto-maintained by OpenWolf. Last scanned: 2026-06-01T14:43:10.881Z
> Files: 35 tracked | Anatomy hits: 0 | Misses: 0

## ../../../../home/meketreve/.claude/

- `settings.json` (~255 tok)

## ../../../../home/meketreve/.claude/plans/

- `lively-exploring-brooks.md` — Plano — Plugin OBS: Eye-Tracking Mask (rosto → máscara 3D) (~2230 tok)

## ./

- `.gitignore` — Git ignore rules (~151 tok)
- `CLAUDE.md` — OpenWolf (~57 tok)
- `CMakeLists.txt` (~1254 tok)
- `README.md` — Project documentation (~1469 tok)

## .claude/

- `settings.json` (~441 tok)

## .claude/rules/

- `openwolf.md` (~364 tok)

## .github/workflows/

- `windows.yml` — CI: windows (~1360 tok)

## Planned (not yet created)


## data/effects/

- `mask.effect` — Eye Mask Tracker — draws a textured quad whose corners are already projected (~401 tok)

## data/locale/

- `en-US.ini` (~279 tok)
- `pt-BR.ini` (~313 tok)

## installer/

- `aye-aye-mask.nsi` (~704 tok)
- `build-and-install.bat` (~1172 tok)
- `build-and-package.ps1` (~841 tok)
- `README.md` — Project documentation (~488 tok)

## scripts/

- `fetch-models.sh` — Download model files into data/models/. (~314 tok)
- `gen-facemesh-tables.py` — Generate src/facemesh_tables.hpp from MediaPipe's canonical_face_model.obj. (~708 tok)

## src/

- `frame-grab.cpp` — include "frame-grab.hpp" (~653 tok)
- `frame-grab.hpp` — pragma once (~275 tok)
- `headpose.cpp` — include "headpose.hpp" (~767 tok)
- `headpose.hpp` — pragma once (~242 tok)
- `landmarks.cpp` — LandmarkNet impl: FaceMesh ONNX via onnxruntime, crop→192 RGB NCHW, out 468×3 mapped to crop px. (~788 tok)
- `landmarks.hpp` — LandmarkNet: MediaPipe FaceMesh 468pt wrapper + eye-corner indices (33/133/362/263). (~386 tok)
- `mask-filter.cpp` — include <obs-module.h> (~4112 tok)
- `mask-filter.hpp` — extern decl of mask_filter_info (obs_source_info). (~59 tok)
- `mask-renderer.cpp` — include "mask-renderer.hpp" (~2235 tok)
- `mask-renderer.hpp` — pragma once (~615 tok)
- `plugin-main.cpp` — OBS module entry: OBS_DECLARE_MODULE, registers filter, module name/description, PLUGIN_VERSION. (~165 tok)
- `pose.cpp` — include "pose.hpp" (~1310 tok)
- `pose.hpp` — pragma once (~446 tok)
- `smoothing.cpp` — include "smoothing.hpp" (~1171 tok)
- `smoothing.hpp` — pragma once (~464 tok)
- `tracker.cpp` — include "tracker.hpp" (~1614 tok)
- `tracker.hpp` — pragma once (~739 tok)
