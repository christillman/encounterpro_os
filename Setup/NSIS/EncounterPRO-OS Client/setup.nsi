; EncounterPRO Setup Script
; 
; See DEFINES section to modify setup version and source folders
;  (this is the proper way to edit script to support a new version)

; See Component Sources section under defines to modify versions 
;   of included components.


; ------------------------------------------
; DEFINES
  !define PRODUCT   "GreenOlive_EHR"

; Client Setup Version
  !define VERSION   7.2.7.0

; Source Root
  !define SOURCE_ROOT "C:\EncounterPro\Builds"
  !define INST_ROOT "C:\Users\Public\Documents"
  !define DEST_FOLDER "${INST_ROOT}\${PRODUCT}\Client"
  !define ATT_FOLDER "${INST_ROOT}\Attachments"
  !define UTILITIES_FOLDER "${INST_ROOT}\Utilities"
  
; Included Versions
  !define EproClient_VERSION   ${VERSION}
  !define Database_Mod_Level   230
  !define EncounterPro_OS_Utilities_VERSION   1.0.6.0
  !define ConfigObjectManager_VERSION   2.1.3.2

  !define Required_Dotnet_VERSION   'v4.0'

  !define DISP_NAME '${PRODUCT} ${VERSION}'
  !define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT} 7"


  ; EproLibNET installer define
  ;*** To change EproLibNET version, change the path below
  !define SRC_EproUtils  '${SOURCE_ROOT}\EncounterPRO-OS\EncounterPRO.OS.Utilities'
  ; !define SRC_TextMaker  '${SOURCE_ROOT}\3rd Party Software\TextMaker'
  ; !define SRC_TextMaker_Filename  'freeoffice2021.msi'

  ;*** If Setup version != Client files version, modify following line ***
  !define SRC_EPRO  '${SOURCE_ROOT}\EncounterPRO-OS\EncounterPRO.OS.Client\${EproClient_VERSION}'
  !define SRC_EPRO_Resources  '${SOURCE_ROOT}\EncounterPRO-OS\Resources'

  !define SRC_Mod_Level  '${SOURCE_ROOT}\EncounterPRO-OS\Database\Upgrade\${Database_Mod_Level}'

  ; Installing the help file
  ;!define COMMONFILES_TARGET "EncounterPRO-OS"
  ;!define APPDATA_TARGET "${PRODUCT}"

  ; Installing certificates
  !define CERT_QUERY_OBJECT_FILE 1
  !define CERT_QUERY_CONTENT_FLAG_ALL 16382
  !define CERT_QUERY_FORMAT_FLAG_ALL 14
  !define CERT_STORE_PROV_SYSTEM 10
  !define CERT_STORE_OPEN_EXISTING_FLAG 0x4000
  !define CERT_SYSTEM_STORE_LOCAL_MACHINE 0x20000
  !define CERT_STORE_ADD_ALWAYS 4
 
  
; ------------------------------------------
; Variables

    Var SERVER
    Var DATABASE
    Var LOGID
    Var LOGPASS
    Var Dialog
    Var SText
    Var DText
    Var LText
    Var PText
    Var ALREADY_INSTALLED

; ------------------------------------------
; Include Modern UI

  !Include 'MUI2.nsh'
  
; ------------------------------------------
; Other Includes
; From C:\Program Files (x86)\NSIS\Include
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
; local
!include ..\plugins\eproinstallfunctions.nsh

; ------------------------------------------
; General

    ; Name and File
    Name '${DISP_NAME}'
    OutFile '${PRODUCT}_Install_${Database_Mod_Level}.exe'
    InstallDir "${DEST_FOLDER}"
    
    ; Default Installation Folder is set from .onInit's call to SetInstallDir
    
    ; Everything is now installed in C:\Users\Public so no need for special privs
    RequestExecutionLevel admin
    
; ------------------------------------------
; Interface Configuration

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP 'green-olive-avi-02.ico'
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
; Descriptions

    ; Language strings
    LangString PAGE_SERVDB_TITLE ${LANG_ENGLISH} "${PRODUCT} Settings"
    LangString PAGE_SERVDB_SUBTITLE ${LANG_ENGLISH} "Enter or confirm the Server and Database."

    ; Assign language strings to sections
    !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_FUNCTION_DESCRIPTION_END
	
; ------------------------------------------
; Installer Sections

; Revise this to use Uploads subfolder in Client
    Section '-Dependencies' SecDeps
        SetDetailsPrint textonly
        SetOutPath '$SYSDIR'
        SetDetailsPrint both
        IfFileExists '\\localhost\attachments\*.*' GoAhead
        DetailPrint "The share folder \\localhost\attachments is required for the bulk import files "
        DetailPrint "supporting this installation."
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
                  
	  ; Adding a fake file which the installer errors out trying to delete
      ; CreateDirectory "$SMPROGRAMS\SoftMaker FreeOffice 2021"
      ; CreateDirectory "$SMPROGRAMS\SoftMaker FreeOffice 2021\TB"
      ; CreateShortCut "$SMPROGRAMS\SoftMaker FreeOffice 2021\TB\Downloader.exe" "$INSTDIR\PBCLTRT190.log"
      ; SetOutPath '$INSTDIR'
      ; DetailPrint "Installing TextMaker..."
      ; SetDetailsPrint both
      ; File "${SRC_TextMaker}\${SRC_TextMaker_Filename}"
      ; nsExec::Exec 'msiexec /i "$INSTDIR\${SRC_TextMaker_Filename}" /passive /norestart /l*v "$INSTDIR\TextMaker.log" APPLICATIONFOLDER="C:\Program Files (x86)\SoftMaker FreeOffice 2021" INSTALLTM=1 INSTALLUPDATER=0'
      ; Delete '$INSTDIR\${SRC_TextMaker_Filename}'
  
      SetDetailsPrint both
      DetailPrint "Installing EncounterPRO.OS.Utilities..."
      SetOutPath '${UTILITIES_FOLDER}'
	  File "${SRC_EproUtils}\${EncounterPro_OS_Utilities_VERSION}\Files\*.*"	  
      SetDetailsPrint both
    SectionEnd
    
    Section '-${PRODUCT} Client' SecEpro
        SetOutPath '$INSTDIR'
        SetDetailsPrint both
      
        DetailPrint "Installing ${PRODUCT}..."
        SetOverwrite on
        SetDetailsPrint both
        File "${SRC_EPRO}\*.*"
        DetailPrint "Setting ini SERVER and DATABASE to $SERVER and $DATABASE"
        DetailPrint "Setting ini DBLOGID and DBLOGPASS to $LOGID and $LOGPASS"
        WriteINIStr "$INSTDIR\EncounterPRO.ini" "<Default>" "dbserver" $SERVER
        WriteINIStr "$INSTDIR\EncounterPRO.ini" "<Default>" "dbname" $DATABASE
        WriteINIStr "$INSTDIR\EncounterPRO.ini" "<Default>" "dbms" "MSOLEDBSQL"
        WriteINIStr "$INSTDIR\EncounterPRO.ini" "<Default>" "office_id" "0001"
        WriteINIStr "$INSTDIR\EncounterPRO.ini" "<Default>" "dblogid" $LOGID
        WriteINIStr "$INSTDIR\EncounterPRO.ini" "<Default>" "dblogpass" $LOGPASS
        File "${SOURCE_ROOT}\Icons\green-olive-avi-02.ico"
        ${GetFileVersion} "$INSTDIR\EncounterPRO.OS.Client.exe" $R0
        WriteINIStr "$INSTDIR\EPCompInfo.ini" "EncounterPRO" "ProductVersion" "$R0"
        WriteINIStr "$INSTDIR\EPCompInfo.ini" "Client" "ProductVersion" "${EproClient_VERSION}"
        SetDetailsPrint both
    SectionEnd
    
    Section '-Help File' SecHelp
        SetOutPath "$INSTDIR"
        SetDetailsPrint both
        DetailPrint "Installing ${PRODUCT} Help..."
        SetOverwrite on
        SetDetailsPrint textonly
        File "${SOURCE_ROOT}\EncounterPRO-OS\Help\EncounterPro-OS Help.chm"
        File "${SOURCE_ROOT}\EncounterPRO-OS\Help\EncounterPro-OS Help.chw"
    SectionEnd

; ini files now in program directory 
    ; Section '-Ini Files' SecIni
    ;     SetOutPath "$APPDATA\${APPDATA_TARGET}"
    ;     SetDetailsPrint both
    ;     DetailPrint "Installing EncounterPro.ini to $APPDATA\${APPDATA_TARGET}"
    ;     File "${SOURCE_ROOT}\EncounterPRO-OS\EncounterPRO.OS.Client\EncounterPRO.ini"
    ;     DetailPrint "Setting ini SERVER to $SERVER"
    ;     DetailPrint "Setting ini DATABASE to $DATABASE"
    ;     WriteINIStr "$APPDATA\${APPDATA_TARGET}\EncounterPRO.ini" "<Default>" "dbserver" $SERVER
    ;     WriteINIStr "$APPDATA\${APPDATA_TARGET}\EncounterPRO.ini" "<Default>" "dbname" $DATABASE
    ;     WriteINIStr "$APPDATA\${APPDATA_TARGET}\EncounterPRO.ini" "<Default>" "dbms" "SNC"
    ;     WriteINIStr "$APPDATA\${APPDATA_TARGET}\EncounterPRO.ini" "<Default>" "office_id" "0001"
    ;     ${GetFileVersion} "$INSTDIR\EncounterPRO.OS.Client.exe" $R0
    ;     WriteINIStr "$APPDATA\${APPDATA_TARGET}\EPCompInfo.ini" "EncounterPRO" "ProductVersion" "$R0"
    ;     WriteINIStr "$APPDATA\${APPDATA_TARGET}\EPCompInfo.ini" "Client" "ProductVersion" "${EproClient_VERSION}"
    ;     SetDetailsPrint both
    ; SectionEnd

    Section '-Attachments' SecAT
        CreateDirectory "${ATT_FOLDER}"
		nsExec::ExecToLog 'NET SHARE attachments="${ATT_FOLDER}"'
        SetOutPath "\\localhost\attachments"
        SetDetailsPrint both
        DetailPrint "Installing Attachments in \\localhost\attachments ..."
        SetOverwrite on
        File /nonfatal "${SRC_Mod_Level}\Attachments\*.*"
    SectionEnd
    
    Section -AdditionalIcons
        SetDetailsPrint textonly
        SetOutPath '$INSTDIR'
        CreateDirectory "${DEST_FOLDER}"
        CreateDirectory "${DEST_FOLDER}\Uploads"
        CreateShortCut "${DEST_FOLDER}\Uninstall.lnk" "$INSTDIR\uninst.exe"
        CreateShortCut "${DEST_FOLDER}\${PRODUCT}.lnk" "$INSTDIR\EncounterPRO.OS.Client.exe" "CLIENT=<Default>" "$INSTDIR\green-olive-avi-02.ico"
        CreateShortCut "${DEST_FOLDER}\${PRODUCT} Ask.lnk" "$INSTDIR\EncounterPRO.OS.Client.exe" "ASK" "$INSTDIR\green-olive-avi-02.ico"
        SetOutPath "$DESKTOP"
        CreateShortCut "$DESKTOP\${PRODUCT}.lnk" "$INSTDIR\EncounterPRO.OS.Client.exe" "CLIENT=<Default>" "$INSTDIR\green-olive-avi-02.ico"
        SetDetailsPrint both
    SectionEnd
    
    Section '-Post' SecPost
        SetDetailsPrint textonly
        ; Store installation folder
        WriteRegStr HKLM 'Software\${PRODUCT}' '' $INSTDIR   
        
        ; Uninstaller
        WriteUninstaller "$INSTDIR\uninst.exe"
        WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^name)"
        WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\green-olive-avi-02.ico"
        WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
        WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${VERSION}"
        SetDetailsPrint both
    SectionEnd

    Section "Certificates"
		; https://nsis.sourceforge.io/Import_Root_Certificate
		; Push C:\path\to\certificate.cer
		; Call AddCertificateToStore
		; Pop $0
		; ${If} $0 != success
		  ; MessageBox MB_OK "Certificate import failed: $0"
		; ${EndIf}
    SectionEnd
       
    Section Uninstall
      Delete "$INSTDIR\uninst.exe"
    
      Delete "${DEST_FOLDER}\Uninstall.lnk"
	  
      Delete "$DESKTOP\EncounterPRO-OS.lnk"
      Delete "${DEST_FOLDER}\EncounterPRO-OS.lnk"
      Delete "${DEST_FOLDER}\EncounterPRO-OS Ask.lnk"
	  
      Delete "$DESKTOP\${PRODUCT}.lnk"
      Delete "${DEST_FOLDER}\${PRODUCT}.lnk"
      Delete "${DEST_FOLDER}\${PRODUCT} Ask.lnk"
    
      RMDir "${DEST_FOLDER}"
    
      RMDir $INSTDIR
    
      DeleteRegKey HKLM "${PRODUCT_UNINST_KEY}"
      SetAutoClose true
    SectionEnd
    
    Section "un.${PRODUCT}"
      DetailPrint "UnInstalling ${PRODUCT}..."
      Delete "$INSTDIR\*.pbd"
      Delete "$INSTDIR\*.log"
      Delete "$INSTDIR\*.ico"
      Delete "$INSTDIR\Encounterpro.OS.Client.exe"
    SectionEnd
    
    Section "un.Dependencies"
      ; MSVC needed for PowerBuilder
      !insertmacro UnInstallLib DLL    SHARED NOREMOVE "$SYSDIR\msvcr80.dll"
      !insertmacro UnInstallLib DLL    SHARED NOREMOVE "$SYSDIR\msvcp80.dll"
      !insertmacro UnInstallLib DLL    SHARED NOREMOVE "$SYSDIR\atl80.dll"
       
		Delete "$INSTDIR\*.txt"
		Delete "$INSTDIR\*.exe"
		Delete "$INSTDIR\*.dll"
		Delete "$INSTDIR\*.pbx"
		Delete "$INSTDIR\*.pbd"
		Delete "$INSTDIR\*.ocx"
		Delete "$INSTDIR\*.jar"
		Delete "$INSTDIR\*.manifest"
		Delete "$INSTDIR\*.xml"
		Delete "$INSTDIR\*.tlb"
        Delete "$INSTDIR\*.zip"
		Delete "$INSTDIR\Open Source License.rtf"
		Delete "$INSTDIR\LICENSE"
		Delete "$INSTDIR\*.flt"
		Delete "$INSTDIR\*.ico"
		Delete "$INSTDIR\*.lnk"
		Delete "$INSTDIR\*.chm"
		Delete "$INSTDIR\*.json"
		Delete "$INSTDIR\*.ini"
      Delete "$INSTDIR\Uploads"
      Delete "$INSTDIR\Attachments"
      Delete "$INSTDIR"
	SectionEnd

 
Function .onInit
    ; Install for ALL USERS
    SetShellVarContext all
    Call CheckBitness
    ;Call CheckIsAdminUser

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
        StrCpy $SERVER "tcp:DESKTOP-5KDV41N,54321"
    ${EndIf}
    ${If} $DATABASE == ""
        StrCpy $DATABASE "EncounterPro_OS"
    ${EndIf}
    ${If} $LOGID == ""
        StrCpy $LOGID "greenoliveehr"
    ${EndIf}
    ${If} $LOGPASS == ""
        StrCpy $LOGPASS "greenoliveEHR"
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

    ${NSD_CreateLabel} 0 60u 100% 12u "DB Login"

    ${NSD_CreateText} 0 73u 100% 12u $LOGID
    Pop $LText
	
    ${NSD_CreateLabel} 0 90u 100% 12u "DB Password"

    ${NSD_CreateText} 0 103u 100% 12u $LOGPASS
    Pop $PText
	
    ${NSD_SetFocus} $SText

    nsDialogs::Show    
FunctionEnd

Function endServerDBPage
    ${NSD_GetText} $SText $SERVER
    ${NSD_GetText} $DText $DATABASE
    ${NSD_GetText} $LText $LOGID
    ${NSD_GetText} $PText $LOGPASS
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
  ReadRegStr $R0 HKLM 'Software\${PRODUCT}' ''
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
  IfFileExists "$INSTDIR\EncounterPRO.ini" 0 lbl_?servdbdone
  ; Read Server and Database from EncounterPRO.ini
  ReadINIStr $SERVER "$INSTDIR\EncounterPRO.ini" "<Default>" "dbserver"
  ReadINIStr $DATABASE "$INSTDIR\EncounterPRO.ini" "<Default>" "dbname"
  ReadINIStr $LOGID "$INSTDIR\EncounterPRO.ini" "<Default>" "dblogid"
  ReadINIStr $LOGPASS "$INSTDIR\EncounterPRO.ini" "<Default>" "dblogpass"
  lbl_?servdbdone:
FunctionEnd


Function AddCertificateToStore
 
  Exch $0
  Push $1
  Push $R0
 
  System::Call "crypt32::CryptQueryObject(i ${CERT_QUERY_OBJECT_FILE}, w r0, \
    i ${CERT_QUERY_CONTENT_FLAG_ALL}, i ${CERT_QUERY_FORMAT_FLAG_ALL}, \
    i 0, i 0, i 0, i 0, i 0, i 0, *i .r0) i .R0"
 
  ${If} $R0 <> 0
 
    System::Call "crypt32::CertOpenStore(i ${CERT_STORE_PROV_SYSTEM}, i 0, i 0, \
      i ${CERT_STORE_OPEN_EXISTING_FLAG}|${CERT_SYSTEM_STORE_LOCAL_MACHINE}, \
      w 'ROOT') i .r1"
 
    ${If} $1 <> 0
 
      System::Call "crypt32::CertAddCertificateContextToStore(i r1, i r0, \
        i ${CERT_STORE_ADD_ALWAYS}, i 0) i .R0"
      System::Call "crypt32::CertFreeCertificateContext(i r0)"
 
      ${If} $R0 = 0
 
        StrCpy $0 "Unable to add certificate to certificate store"
 
      ${Else}
 
        StrCpy $0 "success"
 
      ${EndIf}
 
      System::Call "crypt32::CertCloseStore(i r1, i 0)"
 
    ${Else}
 
      System::Call "crypt32::CertFreeCertificateContext(i r0)"
 
      StrCpy $0 "Unable to open certificate store"
 
    ${EndIf}
 
  ${Else}
 
    StrCpy $0 "Unable to open certificate file"
 
  ${EndIf}
 
  Pop $R0
  Pop $1
  Exch $0
 
FunctionEnd