; EncounterPRO Setup Script
; 
; See DEFINES section to modify setup version and source folders
;  (this is the proper way to edit script to support a new version)

; See Component Sources section under defines to modify versions 
;   of included components.


; ------------------------------------------
; DEFINES
  !define PRODUCT   EncounterPRO-OS

; EncounterPRO Client Setup Version
  !define VERSION   7.0.3.1

; Source Root
 !define SOURCE_ROOT "C:\Users\tofft\EncounterPro\Builds"
  
; Included Versions
  !define EproClient_VERSION   7.0.3.1
  !define Database_Mod_Level   204
  !define PBRuntime_VERSION   17.3.1858
  !define EncounterPRO_OS_Utilities_VERSION   1.0.1.0
  !define ConfigObjectManager_VERSION   2.1.3.2

  !define Required_Dotnet_VERSION   'v4.0'
  ; PBSNC170.DLL is now included in the Runtime Packager
  ; !define SQL_Native_Client_Version 2008.12

  !define DISP_NAME '${PRODUCT} ${VERSION}'
  !define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT} 7"


  ; EproLibNET installer define
  ;*** To change EproLibNET version, change the path below
  !define SRC_EproUtils  '${SOURCE_ROOT}\EncounterPRO-OS\EncounterPRO.OS.Utilities'

  ;*** If Setup version != Client files version, modify following line ***
  !define SRC_EPRO  '${SOURCE_ROOT}\EncounterPRO-OS\EncounterPRO.OS.Client\${EproClient_VERSION}'
  !define SRC_EPRO_Resources  '${SOURCE_ROOT}\EncounterPRO-OS\Resources'

  !define SRC_Mod_Level  '${SOURCE_ROOT}\EncounterPRO-OS\Database\Upgrade\${Database_Mod_Level}'

  ;*** To change PB Runtime version, modify following line ***
  !define SRC_PBR   '${SOURCE_ROOT}\3rd Party Software\Appeon PB Runtime\${PBRuntime_VERSION}'

  ; Installing the help file
  !define COMMONFILES_TARGET "EncounterPRO-OS"
  !define APPDATA_TARGET "EncounterPRO-OS"

; ------------------------------------------
; Variables

    Var SERVER
    Var DATABASE
    Var Dialog
    Var SText
    Var DText
    Var ALREADY_INSTALLED

; ------------------------------------------
; Include Modern UI

  !Include 'MUI2.nsh'
  
; ------------------------------------------
; Other Includes

!include WordFunc.nsh
!insertmacro VersionCompare
!include FileFunc.nsh
!insertmacro GetParent
!insertmacro GetDrives
!insertmacro GetFileVersion
!insertmacro GetRoot
!include LogicLib.nsh
!include Library.nsh
!include Sections.nsh
!include ..\plugins\eproinstallfunctions.nsh
; ------------------------------------------
; General

    ; Name and File
    Name '${DISP_NAME}'
    OutFile 'EncounterPRO.OS.Client ${VERSION} Install.exe'
    InstallDir "$PROGRAMFILES\EncounterPRO.ORG\EncounterPRO-OS"
    
    ; Default Installation Folder is set from .onInit's call to SetInstallDir
    
    ; Request Execution Priviliges for Vista / Server 2008
    RequestExecutionLevel admin
    
; ------------------------------------------
; Interface Configuration

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP 'EncounterPRO-OS logo.png'
  !define MUI_ABORTWARNING
  
; ------------------------------------------
; Macros
;  !macro ExecuteSQL Result Query
;    !define UniqueID ${__LINE__}
;    DetailPrint "Executing SQL: ${Query}"
;    IfFileExists "${Query}" ExecuteSQLFile_${UniqueID}
;    nsExec::ExecToStack /OEM "$\"sqlce.exe$\" $\"Connection Timeout=3;Integrated Security=sspi;server=$Server;database=$Database$\" $\"${Query}$\""
;    goto ExecuteSQLReturn_${UniqueID}
;    ExecuteSQLFile_${UniqueID}:
;    nsExec::ExecToStack /OEM "$\"sqlce.exe$\" $\"Connection Timeout=3;Integrated Security=sspi;server=$Server;database=$Database$\" -i $\"${Query}$\""
;    ExecuteSQLReturn_${UniqueID}:
;    Pop $9
;    Pop ${Result}
;    StrCmp $9 0 0 +3
;    DetailPrint "sqlce.exe reported success."
;    goto +3
;    MessageBox MB_ICONSTOP "sqlce.exe reported error.$\r$\n${Result}"
;    Abort
;    !undef UniqueID
;!macroend
  
; ------------------------------------------
; Pages

  !insertmacro MUI_PAGE_LICENSE '${SRC_EPRO_Resources}\Open Source License.rtf'
  Page custom createServerDBPage endServerDBPage
;  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
; ------------------------------------------
; Languages

  !insertmacro MUI_LANGUAGE 'English'
  
; ------------------------------------------
; Installer Sections

    Section '-Dependencies' SecDeps
        SetDetailsPrint textonly
        SetOutPath '$SYSDIR'
        SetDetailsPrint both
        IfFileExists '\\localhost\attachments\*.*' GoAhead
        DetailPrint "The share folder \\localhost\attachments is required for the bulk import files "
        DetailPrint "supporting this installation."
        DetailPrint ""
        DetailPrint "Create an empty folder anywhere on this computer. Right click on it and choose Share."
        DetailPrint "Make the share name 'attachments', and be sure to share it with 'Everyone'. "
        DetailPrint "The bulk import files will be copied to it during installation when you try again."
        DetailPrint ""
        SetDetailsView show
        Abort "The share folder \\localhost\attachments was not found. Aborting now."
        GoAhead:
        IfFileExists "$INSTDIR\EncounterPRO.OS.Client.exe" 0 new_installation
        StrCpy $ALREADY_INSTALLED 1
        new_installation:
  
        DetailPrint "Installing MS System Files..."
          SetDetailsPrint textonly
        
        ; Microsoft Files needed for PowerBuilder: NB, 100 versions required for 64-bit
          !insertmacro InstallLib DLL    $ALREADY_INSTALLED REBOOT_PROTECTED \
            "${SOURCE_ROOT}\3rd Party Software\Microsoft\msvcr80.dll" "$SYSDIR\msvcr80.dll" "$SYSDIR"
          !insertmacro InstallLib DLL    $ALREADY_INSTALLED REBOOT_PROTECTED \
            "${SOURCE_ROOT}\3rd Party Software\Microsoft\msvcp80.dll" "$SYSDIR\msvcp80.dll" "$SYSDIR"
          !insertmacro InstallLib DLL    $ALREADY_INSTALLED REBOOT_PROTECTED \
            "${SOURCE_ROOT}\3rd Party Software\Microsoft\atl80.dll" "$SYSDIR\atl80.dll" "$SYSDIR"
                  
      ; Install PB Runtime
      SetOutPath $INSTDIR
      DetailPrint "Installing Powerbuilder Runtime Files..."
      SetDetailsPrint textonly
      File "${SRC_PBR}\PBCLTRT170.msi"
      nsExec::Exec 'msiexec /i "$INSTDIR\PBCLTRT170.msi" /passive /norestart'
      Delete '$INSTDIR\PBCLTRT170.msi'

      SetDetailsPrint both
      DetailPrint "Installing EncounterPRO.OS.Utilities..."
      SetDetailsPrint none
      SetOutPath $INSTDIR
      File '${SRC_EproUtils}\EncounterPRO.OS.Utilities ${EncounterPRO_OS_Utilities_VERSION} Install.exe'
      nsExec::Exec '"$INSTDIR\EncounterPRO.OS.Utilities ${EncounterPRO_OS_Utilities_VERSION} Install.exe"'
      Delete '$INSTDIR\EncounterPRO.OS.Utilities ${EncounterPRO_OS_Utilities_VERSION} Install.exe'
      
      SetDetailsPrint both
    SectionEnd
    
    Section '-EncounterPRO Client' SecEpro
        SetOutPath '$INSTDIR'
        SetDetailsPrint both
      
        DetailPrint "Installing EncounterPRO Client..."
        SetOverwrite on
        SetDetailsPrint both
        File "${SRC_EPRO}\*.*"
        File "${SOURCE_ROOT}\Icons\epmanos.ico"
        SetDetailsPrint both
    SectionEnd
    
    Section '-Help File' SecHelp
        SetOutPath "$COMMONFILES\${COMMONFILES_TARGET}"
        SetDetailsPrint both
        DetailPrint "Installing EncounterPro-OS Help..."
        SetOverwrite on
        SetDetailsPrint textonly
        File "${SOURCE_ROOT}\EncounterPRO-OS\Help\EncounterPro-OS Help.chm"
        File "${SOURCE_ROOT}\EncounterPRO-OS\Help\EncounterPro-OS Help.chw"
    SectionEnd

    Section '-Ini Files' SecHelp
        SetOutPath '$APPDATA\${APPDATA_TARGET}'
        File "${SOURCE_ROOT}\EncounterPRO-OS\EncounterPRO.OS.Client\EncounterPRO.ini"
        DetailPrint "Setting ini SERVER to $SERVER"
        DetailPrint "Setting ini DATABASE to $DATABASE"
        WriteINIStr "$APPDATA\${APPDATA_TARGET}\EncounterPRO.ini" "<Default>" "dbserver" $SERVER
        WriteINIStr "$APPDATA\${APPDATA_TARGET}\EncounterPRO.ini" "<Default>" "dbname" $DATABASE
        WriteINIStr "$APPDATA\${APPDATA_TARGET}\EncounterPRO.ini" "<Default>" "dbms" "SNC"
        WriteINIStr "$APPDATA\${APPDATA_TARGET}\EncounterPRO.ini" "<Default>" "office_id" "0001"
        ${GetFileVersion} "$INSTDIR\EncounterPRO.OS.Client.exe" $R0
        WriteINIStr "$APPDATA\${APPDATA_TARGET}\EPCompInfo.ini" "EncounterPRO" "ProductVersion" "$R0"
        WriteINIStr "$APPDATA\${APPDATA_TARGET}\EPCompInfo.ini" "Client" "ProductVersion" "${EproClient_VERSION}"
        SetDetailsPrint both
    SectionEnd


; Just put it into attachments
;    Section '-Mod Level Script' SecML
;        Delete "$INSTDIR\*.mdlvl"
;        SetOutPath '$INSTDIR'
;        SetDetailsPrint both
;        DetailPrint "Installing Upgrade Script For Mod Level ${Database_Mod_Level}..."
;        SetDetailsPrint textonly
;        File "${SRC_Mod_Level}\*.mdlvl"
;    SectionEnd

    Section '-Attachments' SecAT
        Delete "$INSTDIR\*.mdlvl"
        SetOutPath '\\localhost\attachments'
        SetDetailsPrint both
        DetailPrint "Installing Attachments in \\localhost\attachments ..."
        SetOverwrite on
        File /nonfatal "${SRC_Mod_Level}\Attachments\*.*"
    SectionEnd
    
    Section -AdditionalIcons
        SetDetailsPrint textonly
        SetOutPath $INSTDIR
        CreateDirectory "$SMPROGRAMS\EncounterPRO-OS"
        CreateShortCut "$SMPROGRAMS\EncounterPRO-OS\Uninstall.lnk" "$INSTDIR\uninst.exe"
        CreateShortCut "$DESKTOP\EncounterPRO-OS.lnk" "$INSTDIR\EncounterPRO.OS.Client.exe" "CLIENT=<Default>" "$INSTDIR\epmanos.ico"
        CreateShortCut "$SMPROGRAMS\EncounterPRO-OS\EncounterPRO-OS.lnk" "$INSTDIR\EncounterPRO.OS.Client.exe" "CLIENT=<Default>" "$INSTDIR\epmanos.ico"
        CreateShortCut "$SMPROGRAMS\EncounterPRO-OS\EncounterPRO-OS Ask.lnk" "$INSTDIR\EncounterPRO.OS.Client.exe" "ASK" "$INSTDIR\epmanos.ico"
        SetDetailsPrint both
    SectionEnd
    
    Section '-Post' SecPost
        SetDetailsPrint textonly
        ; Store installation folder
        WriteRegStr HKLM 'Software\EncounterPRO.ORG\EncounterPRO-OS' '' $INSTDIR   
        
        ; Uninstaller
        WriteUninstaller "$INSTDIR\uninst.exe"
        WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^name)"
        WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\epmanos.ico"
        WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
        WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${VERSION}"
        SetDetailsPrint both
    SectionEnd
    
    Section Uninstall
      Delete "$INSTDIR\uninst.exe"
    
      Delete "$SMPROGRAMS\EncounterPRO-OS\Uninstall.lnk"
      Delete "$DESKTOP\EncounterPRO-OS.lnk"
      Delete "$SMPROGRAMS\EncounterPRO-OS\EncounterPRO-OS.lnk"
      Delete "$SMPROGRAMS\EncounterPRO-OS\EncounterPRO-OS Ask.lnk"
    
      RMDir "$SMPROGRAMS\EncounterPRO-OS"
    
      RMDir $INSTDIR
    
      DeleteRegKey HKLM "${PRODUCT_UNINST_KEY}"
      SetAutoClose true
    SectionEnd
    
    Section "un.EncounterPRO Client"
      DetailPrint "UnInstalling EncounterPRO-OS Client..."
      Delete "$INSTDIR\*.pbd"
      Delete "$INSTDIR\Encounterpro.OS.Client.exe"
    SectionEnd
    
    Section "un.Dependencies"
      ; MSVC needed for PowerBuilder
      !insertmacro UnInstallLib DLL    SHARED NOREMOVE "$SYSDIR\msvcr80.dll"
      !insertmacro UnInstallLib DLL    SHARED NOREMOVE "$SYSDIR\msvcp80.dll"
      !insertmacro UnInstallLib DLL    SHARED NOREMOVE "$SYSDIR\atl80.dll"
       
      Delete "$INSTDIR\*.txt"
      Delete "$INSTDIR\*.dll"
      Delete "$INSTDIR\*.pbx"
      Delete "$INSTDIR\*.ocx"
      Delete "$INSTDIR\*.ini"
      Delete "$INSTDIR\Open Source License.rtf"
      Delete "$INSTDIR\*.flt"  
      Delete "$INSTDIR\*.mdlvl"  
    SectionEnd

; ------------------------------------------
; Descriptions

    ; Language strings
    LangString PAGE_SERVDB_TITLE ${LANG_ENGLISH} "EncounterPRO-OS Settings"
    LangString PAGE_SERVDB_SUBTITLE ${LANG_ENGLISH} "Enter or confirm the names \
        of your EncounterPRO-OS Server and Database."

    ; Assign language strings to sections
    !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_FUNCTION_DESCRIPTION_END
    
Function .onInit
    ; Install for ALL USERS
    SetShellVarContext all
    Call CheckBitness
    Call CheckIsAdminUser

  Call getWindowsVersion
  ${If} $WinVer = 'not NT'
      MessageBox MB_OK "This program requires Windows XP, Windows 2003 or Later.  Setup cannot continue."
      Abort "This program requires Windows XP, Windows 2003 or Later."
  ${EndIf}
  ;MessageBox MB_OK "$WinVer"
  
  Call isNet40Installed
  Pop $R0
  ${If} $R0 != 'Yes'
      MessageBox MB_YESNO|MB_ICONEXCLAMATION "This program requires the .NET Framework 4 Service Pack 1.  Do you wish to download the required framework now?" IDYES OpenBrowser40 IDNO GiveUpNow40
      
      OpenBrowser40:
      ${OpenURL} "https://www.microsoft.com/net/download/windows"
      Abort "Please restart setup after installing the .NET Framework 4."
      
      GiveUpNow40:
      Abort "Please install the .NET Framework 4 before running setup again."
  ${EndIf}

    Call SetInstallDir
    Call cpServerAndDatabase
FunctionEnd

Function un.onInit
    SetShellVarContext all
    Call un.CheckIsAdminUser
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
    Abort
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function createServerDBPage
    !insertmacro MUI_HEADER_TEXT $(PAGE_SERVDB_TITLE) $(PAGE_SERVDB_SUBTITLE)

    ${If} $SERVER == ""
        StrCpy $SERVER "localhost\ENCOUNTERPRO_OS"
    ${EndIf}
    ${If} $DATABASE == ""
        StrCpy $DATABASE "EncounterPro_OS"
    ${EndIf}
    
    nsDialogs::Create /NOUNLOAD 1018
    Pop $Dialog

    ${If} $Dialog == error
        Abort
    ${EndIf}
    
    ${NSD_CreateLabel} 0 0 100% 12u "Server Name"

    ${NSD_CreateText} 0 13u 100% 12u $SERVER
    Pop $SText
    
    ${NSD_CreateLabel} 0 30u 100% 12u "Database Name"

    ${NSD_CreateText} 0 43u 100% 12u $DATABASE
    Pop $DText

    ${NSD_SetFocus} $SText

    nsDialogs::Show    
FunctionEnd

Function endServerDBPage
    ${NSD_GetText} $SText $SERVER
    ${NSD_GetText} $DText $DATABASE
FunctionEnd

Function ProcessDrives
  ; If drive is Windows drive, proceed to next drive
  ; otherwise, stop listing drives
  StrCmp $9 $R0 +3
  StrCpy $R0 $9
  StrCpy $0 StopGetDrives
  Push $0
FunctionEnd

Function SetInstallDir
  ClearErrors
  ReadRegStr $R0 HKLM 'Software\EncounterPRO.ORG\EncounterPRO-OS' ''
  IfErrors lbl_tryuninstkey
  StrCpy $INSTDIR $R0
  goto done
  lbl_tryuninstkey:
  ReadRegStr $R0 HKLM '${PRODUCT_UNINST_KEY}' 'UninstallString'
  IfErrors done
  ${GetParent} $R0 $R0
  StrCpy $INSTDIR $R0
  goto done
  done:
FunctionEnd

Function cpServerAndDatabase
  SetOutPath "$APPDATA\${APPDATA_TARGET}"
  ; if EncounterPRO.ini doesn't exist, don't try to get its data
  IfFileExists "$APPDATA\${APPDATA_TARGET}\EncounterPRO.ini" 0 lbl_?servdbdone
  ; Read Server and Database from EncounterPRO.ini
  ReadINIStr $SERVER "$APPDATA\${APPDATA_TARGET}\EncounterPRO.ini" "<Default>" "dbserver"
  ReadINIStr $DATABASE "$APPDATA\${APPDATA_TARGET}\EncounterPRO.ini" "<Default>" "dbname"
  lbl_?servdbdone:
FunctionEnd
