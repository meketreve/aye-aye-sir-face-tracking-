<#
  build-and-package.ps1  —  Windows build + installer .exe

  Builds the plugin for Windows (MSVC) and produces an NSIS installer .exe.

  Prerequisites (Windows):
    - Visual Studio 2022 (C++ toolset) + CMake
    - vcpkg with OpenCV + contrib:  vcpkg install "opencv4[contrib]:x64-windows"
      (set VCPKG_ROOT, or pass -VcpkgRoot)  [contrib needed for the face module]
    - OBS dev files (libobs CMake config). Easiest: build/install obs-studio,
      or use the obs-deps. Point -ObsPrefix at the dir containing the libobs
      CMake package (e.g. an obs-studio install or deps prefix).
    - NSIS (makensis on PATH)   https://nsis.sourceforge.io/

  Example:
    pwsh installer\build-and-package.ps1 `
        -VcpkgRoot C:\vcpkg `
        -ObsPrefix C:\obs-studio\build\rundir\Release
#>

param(
  [string]$VcpkgRoot = $env:VCPKG_ROOT,
  [string]$ObsPrefix = "",
  [string]$Triplet   = "x64-windows",
  [string]$Config    = "Release"
)

$ErrorActionPreference = "Stop"
$here = $PSScriptRoot
$root = Split-Path -Parent $here
$build = Join-Path $root "build_windows"
$pkg   = Join-Path $here "package"

if (-not $VcpkgRoot) { throw "Set VCPKG_ROOT or pass -VcpkgRoot." }
$toolchain = Join-Path $VcpkgRoot "scripts\buildsystems\vcpkg.cmake"
if (-not (Test-Path $toolchain)) { throw "vcpkg toolchain not found: $toolchain" }

# Fetch the large Facemark model if missing.
$lbf = Join-Path $root "data\models\lbfmodel.yaml"
if (-not (Test-Path $lbf)) {
  Write-Host "==> fetching lbfmodel.yaml (~54MB)" -ForegroundColor Cyan
  curl.exe -fSL "https://github.com/kurnianggoro/GSOC2017/raw/master/data/lbfmodel.yaml" -o $lbf
}

# ---- configure ----
$cmakeArgs = @(
  "-S", $root, "-B", $build,
  "-G", "Visual Studio 17 2022", "-A", "x64",
  "-DCMAKE_TOOLCHAIN_FILE=$toolchain",
  "-DVCPKG_TARGET_TRIPLET=$Triplet"
)
if ($ObsPrefix) { $cmakeArgs += "-DCMAKE_PREFIX_PATH=$ObsPrefix" }
Write-Host "==> cmake configure" -ForegroundColor Cyan
cmake @cmakeArgs

# ---- build ----
Write-Host "==> cmake build ($Config)" -ForegroundColor Cyan
cmake --build $build --config $Config

# ---- stage install tree ----
Write-Host "==> staging into $pkg" -ForegroundColor Cyan
if (Test-Path $pkg) { Remove-Item -Recurse -Force $pkg }
cmake --install $build --config $Config --prefix $pkg

# ---- copy plugin + applocal runtime DLLs next to the plugin ----
$bin = Join-Path $pkg "obs-plugins\64bit"
$built = Get-ChildItem -Recurse $build -Filter "aye-aye-mask.dll" | Select-Object -First 1
if (-not $built) { throw "built plugin not found under $build" }
# vcpkg's applocal step copies dependent DLLs next to the built module.
Copy-Item (Join-Path $built.Directory.FullName "*.dll") $bin -Force
Write-Host "    bundled DLLs:" -ForegroundColor DarkGray
Get-ChildItem $bin -Filter *.dll | ForEach-Object { Write-Host "      $($_.Name)" }

# ---- build installer .exe ----
Write-Host "==> makensis" -ForegroundColor Cyan
Push-Location $here
try { makensis "aye-aye-mask.nsi" }
finally { Pop-Location }

Write-Host "`nDone. Installer:" -ForegroundColor Green
Get-ChildItem $here -Filter "aye-aye-mask-*-installer.exe" | ForEach-Object { Write-Host "  $($_.FullName)" }
