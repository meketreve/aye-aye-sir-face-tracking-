; -----------------------------------------------------------------------------
; Eye Mask Tracker — OBS plugin installer (NSIS)
;
; Packs a STAGED tree (installer/package/) produced by:
;     cmake --install build_windows --config Release --prefix installer/package
;   + OpenCV/runtime DLLs copied next to the plugin (see build-and-package.ps1).
;
; Build the installer .exe:
;     makensis installer/aye-aye-mask.nsi      (works on Windows or Linux/WSL)
; -----------------------------------------------------------------------------

Unicode True

!define NAME    "Eye Mask Tracker"
!define SLUG    "aye-aye-mask"
!define VERSION "0.1.0"

Name "${NAME} ${VERSION}"
OutFile "aye-aye-mask-${VERSION}-windows-x64-installer.exe"
RequestExecutionLevel admin
InstallDir "$PROGRAMFILES64\obs-studio"
ShowInstDetails show
ShowUnInstDetails show

Page directory
Page instfiles
UninstPage uninstConfirm
UninstPage instfiles

; Resolve the OBS install directory from the registry if present.
Function .onInit
  ReadRegStr $0 HKLM "SOFTWARE\OBS Studio" ""
  StrCmp $0 "" done 0
    StrCpy $INSTDIR $0
  done:
FunctionEnd

Section "Eye Mask Tracker (required)" SecMain
  SectionIn RO

  ; Plugin .dll + its runtime DLLs (OpenCV, etc.)
  SetOutPath "$INSTDIR\obs-plugins\64bit"
  File /r "package\obs-plugins\64bit\*.*"

  ; Plugin data (effects, locale, models)
  SetOutPath "$INSTDIR\data\obs-plugins\${SLUG}"
  File /r "package\data\obs-plugins\${SLUG}\*.*"

  ; Uninstaller + Add/Remove Programs entry
  WriteUninstaller "$INSTDIR\${SLUG}-uninstall.exe"
  WriteRegStr   HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SLUG}" "DisplayName"     "${NAME}"
  WriteRegStr   HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SLUG}" "DisplayVersion"  "${VERSION}"
  WriteRegStr   HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SLUG}" "UninstallString" "$INSTDIR\${SLUG}-uninstall.exe"
  WriteRegStr   HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SLUG}" "InstallLocation" "$INSTDIR"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SLUG}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SLUG}" "NoRepair" 1
SectionEnd

Section "Uninstall"
  RMDir /r "$INSTDIR\data\obs-plugins\${SLUG}"
  Delete   "$INSTDIR\obs-plugins\64bit\${SLUG}.dll"
  ; Bundled runtimes shipped with this plugin.
  Delete   "$INSTDIR\obs-plugins\64bit\opencv_world*.dll"
  Delete   "$INSTDIR\obs-plugins\64bit\onnxruntime.dll"
  Delete   "$INSTDIR\${SLUG}-uninstall.exe"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SLUG}"
SectionEnd
