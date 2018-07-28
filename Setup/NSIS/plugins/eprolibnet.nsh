; EPROLIBNET support - eprolibnet.nsh
; Version 1.0 - November 16, 2006
;
; Usage:
;   !insertmacro InstallEproLibNET
;   !insertmacro UninstallEproLibNET

!ifndef EproLibNET
  !define EproLibNET

; Source Root
  !define SOURCE_ROOT "\\ICT1\ICTFileStore1\Open Source\Builds"

; Component Versions
  !define TPS_Foxit_Version 2.3
  !define EventLogInstaller_Version 1.1
  
; Other source definitions
  !define UTILITIES_SOURCE "${SOURCE_ROOT}\Utilities"
  !define THIRDPARTY_SOURCE "${SOURCE_ROOT}\3rd Party Software"
  
; Versioned module locations
  !define FOXIT_READER_SOURCE "${THIRDPARTY_SOURCE}\Foxit Reader\${TPS_Foxit_Version}"
  !define EVENTLOG_INSTALLER_SOURCE "${SOURCE_ROOT}\EncounterPRO-OS\Install\${EventLogInstaller_Version}"

; Installation constants
  !define COMMONFILES_TARGET "EncounterPRO-OS"


  ; FileFunc
  !include "FileFunc.nsh"
  !insertmacro GetFileVersion  
  
  ; InstallLib support
  !include Library.nsh
  
  var NETInstallLoc
  var RunningDotNetVersion
  
  !macro EproLibNETGacInstall Assembly
    File "${Assembly}"
    ${GetFileName} "${Assembly}" $R0
    nsExec::Exec '"${gacutil}" /r "$R0"'
    Pop $0
    StrCmp $0 "error" 0 +2
    DetailPrint "Failed to register $R0 in GAC."
    ; ngen.exe fails to compile if assemblies have dependencies that
    ; have not yet been installed.  We might re-implement this feature later,
    ; but for now we will rely on JIT-compiling
    ;ExecWait '"$WINDIR\Microsoft.NET\Framework\${DotNetVersion}\ngen.exe" "$R0"'
  !macroend

  !macro InstallEproLibNET EproLibNETSource
      ; Start by making sure that some .Net utilities are installed
      
      ; Get the running .net versoin
      Call GetDotNETVersion
      Pop $RunningDotNetVersion
      
      ; Set the outpath to the windows .Net directory for the running .net version 
      ReadRegStr $NETInstallLoc HKLM "SOFTWARE\Microsoft\.NETFramework" "InstallRoot"
      StrCpy $R9 $NETInstallLoc 1 -1
      StrCmp $R9 "\" 0 +4
      StrLen $R9 $NETInstallLoc
      IntOp $R9 $R9 - 1
      StrCpy $NETInstallLoc $NETInstallLoc $R9
      SetOutPath "$NETInstallLoc\$RunningDotNetVersion"
      
      ; Download the utilities if necessary
      File "${UTILITIES_SOURCE}\CSharpGACTool\CSharpGACTool.exe"
      File "${THIRDPARTY_SOURCE}\Microsoft .Net Tools\v2.0.50727\InstallUtil.exe"
      
      ; Define symbols for the utilities
      !define gacutil "$NETInstallLoc\$RunningDotNetVersion\CSharpGACTool.exe"
      !define regasm "$NETInstallLoc\$RunningDotNetVersion\regasm.exe"
      !define InstallUtil "$NETInstallLoc\$RunningDotNetVersion\InstallUtil.exe"

          SetOutPath "$COMMONFILES\${COMMONFILES_TARGET}\EproLibNET"
          
          ; Foxit Reader
          File "${FOXIT_READER_SOURCE}\Foxit Reader.exe"
          
          ; EproLibNET
          File "${EproLibNETSource}\EproLibNET.tlb"
          !insertmacro EproLibNETGacInstall "${EproLibNETSource}\ICSharpCode.SharpZipLib.dll"
          !insertmacro EproLibNETGacInstall "${EproLibNETSource}\ProgressBars.dll"
          !insertmacro EproLibNETGacInstall "${EproLibNETSource}\EproLibNET.dll"
          nsExec::Exec '"${regasm}" /codebase /tlb "$COMMONFILES\${COMMONFILES_TARGET}\EproLibNET\EproLibNET.dll"'
          Pop $0
          StrCmp $0 "error" 0 +2
          DetailPrint "Failed to register $R0 for COM-Interop."
          ${GetFileVersion} "$COMMONFILES\${COMMONFILES_TARGET}\EproLibNET\EproLibNET.dll" $R0
          WriteINIStr "$COMMONFILES\${COMMONFILES_TARGET}\EPCompInfo.ini" "EproLibNET" "ProductVersion" "$R0"

        ; Install the EncounterPRO Event Log Sources
          File "${EVENTLOG_INSTALLER_SOURCE}\EPROEventLogInstaller.dll"
          nsExec::Exec '"${InstallUtil}" "$COMMONFILES\${COMMONFILES_TARGET}\EproLibNET\EPROEventLogInstaller.dll"'
  !macroend

  !macro UninstallEproLibNET
    ; Nothing to remove
  !macroend
  
Function GetDotNETVersion
  Push $0
  Push $1

  System::Call "mscoree::GetCORVersion(w .r0, i 1024, *i r2) i .r1"
  StrCmp $1 0 +2
    StrCpy $0 0
  
  Pop $1
  Exch $0
FunctionEnd

!endif