# Windows installer (`.exe`)

Produces `aye-aye-mask-<ver>-windows-x64-installer.exe` that installs the plugin
into OBS:

```
<OBS>\obs-plugins\64bit\aye-aye-mask.dll   (+ opencv_world*.dll, onnxruntime.dll)
<OBS>\data\obs-plugins\aye-aye-mask\       (effects, locale, models)
```

The installer auto-detects the OBS path from the registry
(`HKLM\SOFTWARE\OBS Studio`), defaulting to `C:\Program Files\obs-studio`.

> A Windows `.dll` needs an MSVC build — it can't be produced from WSL/Linux.

## Route C — GitHub Actions (recommended) ✅

`.github/workflows/windows.yml` builds everything in the cloud and uploads the
installer `.exe` as an artifact. **No local toolchain.** It uses official
**prebuilt OpenCV + onnxruntime** (no vcpkg), fetches the head-pose model,
derives libobs from the OBS source tag + an import lib generated from `obs.dll`,
then runs `makensis`.

```bash
git init && git add -A && git commit -m "init"
git remote add origin https://github.com/<you>/<repo>.git
git push -u origin main
```
Then on GitHub: **Actions → windows → Run workflow** (pick the OBS version to
build against, default `31.0.3`). Download the **aye-aye-mask-windows-installer**
artifact.

> First run may need a version tweak. The OBS version input must be a real tag
> with an `OBS-Studio-<ver>-Windows-x64.zip` release asset.

## Route A — local build on Windows (advanced)

Needs VS2022 + NSIS, OpenCV + onnxruntime **prebuilt** (set `-DOpenCV_DIR=` and
`-DORT_ROOT=`), and libobs dev files (headers + an import lib from your installed
`obs.dll`). Easiest to mirror what the CI workflow does. `build-and-install.bat`
covers build→install but you must supply the libobs prefix as its first arg.

## Runtime DLLs

The plugin links OpenCV + onnxruntime, which OBS does not ship. The build bundles
`opencv_world*.dll` and `onnxruntime.dll` next to `aye-aye-mask.dll` so Windows
resolves them. If OBS logs "failed to load module", a runtime DLL is missing.
