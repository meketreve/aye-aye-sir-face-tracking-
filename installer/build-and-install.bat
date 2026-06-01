@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul

rem ============================================================================
rem  Eye Mask Tracker - build + instala no OBS (Windows)
rem
rem  Duplo-clique (auto-eleva p/ admin) OU:
rem     build-and-install.bat [caminho-prefixo-libobs]
rem
rem  *** RECOMENDADO: use a CI do GitHub Actions (Route C no installer/README.md) ***
rem  *** Ela gera o .exe sem nenhum toolchain local. Este .bat e' o caminho      ***
rem  *** manual/avancado (precisa montar libobs dev a mao no Windows).            ***
rem
rem  Pre-requisitos (build local):
rem    - Visual Studio 2022 (C++) + CMake + NSIS
rem    - OpenCV prebuilt + onnxruntime prebuilt (set OpenCV_DIR / ORT_ROOT no cmake)
rem    - libobs dev (headers + import lib) -> passe o prefixo como 1o argumento
rem ============================================================================

rem ---- auto-elevar p/ admin (copiar p/ Program Files exige) ----
net session >nul 2>&1
if errorlevel 1 (
  echo Solicitando privilegios de administrador...
  if "%~1"=="" (
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  ) else (
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -ArgumentList '%*' -Verb RunAs"
  )
  exit /b
)

set "HERE=%~dp0"
set "HERE=%HERE:~0,-1%"
for %%I in ("%HERE%\..") do set "ROOT=%%~fI"
set "BUILD=%ROOT%\build_windows"
set "PKG=%HERE%\package"
set "TRIPLET=x64-windows"
set "CONFIG=Release"
set "OBSPREFIX=%~1"

rem ---- checagens ----
if "%VCPKG_ROOT%"=="" (
  echo [ERRO] VCPKG_ROOT nao definido. Ex: set VCPKG_ROOT=C:\vcpkg
  goto :fail
)
set "TOOLCHAIN=%VCPKG_ROOT%\scripts\buildsystems\vcpkg.cmake"
if not exist "%TOOLCHAIN%" (
  echo [ERRO] toolchain vcpkg nao encontrado: %TOOLCHAIN%
  goto :fail
)
where cmake >nul 2>nul || ( echo [ERRO] cmake nao esta no PATH. & goto :fail )

rem ---- baixar modelo de head-pose (~8.5MB) se faltar ----
if not exist "%ROOT%\data\models\headpose_mobilenetv2.onnx" (
  echo ==^> baixando headpose_mobilenetv2.onnx ^(~8.5MB^)
  curl -fSL "https://github.com/yakhyo/head-pose-estimation/releases/download/weights/mobilenetv2.onnx" -o "%ROOT%\data\models\headpose_mobilenetv2.onnx"
  if errorlevel 1 goto :fail
)

rem ---- configure ----
echo ==^> cmake configure
set "PREFIXARG="
if not "%OBSPREFIX%"=="" set "PREFIXARG=-DCMAKE_PREFIX_PATH=%OBSPREFIX%"
cmake -S "%ROOT%" -B "%BUILD%" -G "Visual Studio 17 2022" -A x64 ^
  -DCMAKE_TOOLCHAIN_FILE="%TOOLCHAIN%" -DVCPKG_TARGET_TRIPLET=%TRIPLET% %PREFIXARG%
if errorlevel 1 goto :fail

rem ---- build ----
echo ==^> cmake build (%CONFIG%)
cmake --build "%BUILD%" --config %CONFIG%
if errorlevel 1 goto :fail

rem ---- stage (layout do plugin OBS) ----
echo ==^> staging
if exist "%PKG%" rmdir /s /q "%PKG%"
cmake --install "%BUILD%" --config %CONFIG% --prefix "%PKG%"
if errorlevel 1 goto :fail

rem ---- copiar DLLs de runtime (OpenCV etc.) p/ junto do plugin ----
echo ==^> copiando DLLs de runtime
set "BIN=%PKG%\obs-plugins\64bit"
set "BUILTDIR="
for /r "%BUILD%" %%F in (aye-aye-mask.dll) do set "BUILTDIR=%%~dpF"
if defined BUILTDIR copy /y "%BUILTDIR%*.dll" "%BIN%" >nul

rem ---- detectar pasta de instalacao do OBS ----
set "OBSDIR="
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\OBS Studio" /ve 2^>nul ^| findstr /i "REG_SZ"') do set "OBSDIR=%%B"
if not defined OBSDIR set "OBSDIR=%ProgramFiles%\obs-studio"
if not exist "%OBSDIR%" (
  echo [ERRO] pasta do OBS nao encontrada: "%OBSDIR%"
  echo        passe o caminho instalando manualmente, ou ajuste OBSDIR.
  goto :fail
)

rem ---- instalar (copiar p/ o OBS) ----
echo ==^> instalando em "%OBSDIR%"
xcopy /e /i /y "%PKG%\obs-plugins" "%OBSDIR%\obs-plugins" >nul
if errorlevel 1 goto :fail
xcopy /e /i /y "%PKG%\data" "%OBSDIR%\data" >nul
if errorlevel 1 goto :fail
echo     OK: plugin copiado para o OBS.

rem ---- (opcional) gerar instalador .exe ----
where makensis >nul 2>nul
if not errorlevel 1 (
  echo ==^> gerando instalador .exe ^(makensis^)
  pushd "%HERE%"
  makensis aye-aye-mask.nsi
  popd
) else (
  echo [info] makensis ausente; pulei o .exe. Plugin ja foi instalado direto.
)

echo.
echo ============================================
echo  Concluido. Abra o OBS e use o filtro
echo  "Eye Mask Tracker".
echo ============================================
pause
exit /b 0

:fail
echo.
echo *** FALHOU. Veja as mensagens acima. ***
pause
exit /b 1
