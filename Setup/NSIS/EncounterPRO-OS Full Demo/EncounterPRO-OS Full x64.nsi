; EncounterPRO Setup Script
; 
; See DEFINES section to modify setup version and source folders
;  (this is the proper way to edit script to support a new version)

; See Component Sources section under defines to modify versions 
;   of included components.


; ------------------------------------------
; DEFINES
  !define PRODUCT   EncounterPRO-OS Full Demo Installation

; EncounterPRO Client Setup Version
  !define VERSION   7.0.1

; Source Root
 !define SOURCE_ROOT "C:\EncounterPro\Builds"
  
; Included Versions
  !define SQLServerExpress_VERSION   "2008R2"
  !define Epro_NewDB_Version   202
  !define EproClient_VERSION   7.0.1

  !define Required_Dotnet_VERSION   'v4.0'

  !define DISP_NAME '${PRODUCT} ${VERSION}'


  ; EproLibNET installer define
  ;*** To change EproLibNET version, change the path below
  !define SRC_SQLServerExpressInstaller  '${SOURCE_ROOT}\EncounterPRO-OS\SQLServerExpressInstaller\${SQLServerExpress_VERSION}'
  !define SRC_NewDatabase  '${SOURCE_ROOT}\EncounterPRO-OS\New Database\${Epro_NewDB_Version}\EncounterPRO-OS New Database ${Epro_NewDB_Version}'
  !define SRC_EproClient  '${SOURCE_ROOT}\EncounterPRO-OS\EncounterPRO.OS.Client\${EproClient_VERSION}\EncounterPRO.OS.Client ${EproClient_VERSION}'
  !define SRC_EPRO_Resources  '${SOURCE_ROOT}\EncounterPRO-OS\Resources'

; ------------------------------------------
; Variables

    Var SERVER
    Var DATABASE
    Var Dialog
    Var SText
    Var DText

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
OutFile 'InstallEproFull.${VERSION}.x64.exe'
InstallDir "$PROGRAMFILES\EncounterPRO.ORG\EncounterPRO-OS\FullInstall"
ShowInstDetails show
; Request Execution Priviliges for Vista / Server 2008
RequestExecutionLevel admin
    
; ------------------------------------------
; Interface Configuration

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP 'EncounterPRO-OS logo.png'
  !define MUI_ABORTWARNING
  
; ------------------------------------------
; Pages

  !insertmacro MUI_PAGE_LICENSE '${SRC_EPRO_Resources}\Open Source License.rtf'
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
; ------------------------------------------
; Languages

  !insertmacro MUI_LANGUAGE 'English'
  
; ------------------------------------------
; Installer Sections

Function PreInstall
  Call CheckBitness
  ;MessageBox MB_OK "$Bitness bit OS"

  Call getWindowsVersion
  ${If} $WinVer = 'not NT'
      MessageBox MB_OK "This program Windows XP, Windows 2003 or Later.  Setup cannot continue."
      Abort "This program Windows XP, Windows 2003 or Later."
  ${EndIf}
  ;MessageBox MB_OK "$WinVer"

    ; Make sure this is the right bitness for this computer
    StrCmp $Bitness 32 found32 found64
    
    found32:
    MessageBox MB_OK "This is the installer for 64-bit computers.  Please use the 32-bit installer (x86)."
    Abort "Please use the 32-bit SQL installer"
    
    found64:
  
  ${CheckDLLVersion} "$SYSDIR\MSI.dll" "4.5" $R0
  ${If} $R0 != 'Yes'
      MessageBox MB_YESNO|MB_ICONEXCLAMATION "This program requires the Windows Installer to be at least version 4.5.  Do you wish to download the required Windows Installer version now?" IDYES OpenBrowsermsi45 IDNO GiveUpNowmsi45
      
      OpenBrowsermsi45:
      ${OpenURL} "http://www.microsoft.com/downloads/details.aspx?familyid=5A58B56F-60B6-4412-95B9-54D056D6F9F4&displaylang=en#filelist"
      Abort "Please restart setup after installing the required version of Windows Installer"
      
      GiveUpNowmsi45:
      Abort "Please install Windows Installer version 4.5 or higher before running setup again."
  ${EndIf}

  Call isNet40Installed
  Pop $R0
  ${If} $R0 != 'Yes'
      MessageBox MB_YESNO|MB_ICONEXCLAMATION "This program requires the .NET Framework 4.  Do you wish to download the required framework now?" IDYES OpenBrowser4 IDNO GiveUpNow4
      
      OpenBrowser4:
      ${OpenURL} "http://www.microsoft.com/downloads/details.aspx?FamilyID=9cfb2d51-5ff4-4491-b0e5-b386f32c0992&displaylang=en"
      Abort "Please restart setup after installing the .NET Framework 4."
      
      GiveUpNow4:
      Abort "Please install the .NET Framework 4 before running setup again."
  ${EndIf}

  Call CheckIsAdminUser
FunctionEnd

Section '-DoFirst' DoFirst
    DetailPrint 'Ready to install...'
    DetailPrint 'Server=$SERVER  Database=$DATABASE'
SectionEnd
    
    Section 'SQL Server Express' SQLXpress
        SetOutPath '$INSTDIR'
        DetailPrint 'Installing SQL Server Express... Server=$SERVER'
        SetDetailsPrint none
        File '${SRC_SQLServerExpressInstaller}\EproSQLx64.exe'
        
        nsExec::Exec '"$INSTDIR\EproSQLx64.exe"'
        IfErrors 0 +3
        MessageBox MB_OK "The SQL Server Express Installation Failed.  Try downloading it from Microsoft and installing it separately."
        Abort "The SQL Server Express Installation Failed"
        
        SetDetailsPrint both
    SectionEnd
    
    Section 'EncounterPRO-OS Database' EproDatabase
        SetOutPath '$INSTDIR'
        DetailPrint 'Installing EncounterPRO Database...'
        SetDetailsPrint none
        File '${SRC_NewDatabase}\EncounterPRO-OS New Database ${Epro_NewDB_Version}.exe'
        
        nsExec::Exec '"$INSTDIR\EncounterPRO-OS New Database ${Epro_NewDB_Version}.exe" /S /DBServer=$SERVER /NewDBName=$DATABASE'
        IfErrors 0 +3
        MessageBox MB_OK "The Database Creation Failed"
        Abort "The Database Creation Failed"

        SetDetailsPrint both
    SectionEnd
    
    Section 'EncounterPRO-OS Client' EproClient
        SetOutPath '$INSTDIR'
        DetailPrint 'Installing EncounterPRO Client...'
        SetDetailsPrint none
        File '${SRC_EproClient}\EncounterPRO.OS.Client ${EproClient_VERSION} Install.exe'
        
        ; Run this NSIS installer in silent mode by using /S flag
        nsExec::Exec '"$INSTDIR\EncounterPRO.OS.Client ${EproClient_VERSION} Install.exe" /S /DBServer=$SERVER /NewDBName=$DATABASE'
        SetDetailsPrint both
    SectionEnd
    
Section '-Post' SecPost
    !insertmacro RemoveFilesAndSubDirs "$INSTDIR"
SectionEnd

; ------------------------------------------
; Descriptions

    ; Language strings
;    LangString DESC_SecCmpMgr ${LANG_ENGLISH} \
;        'This provides component import/export \
;        functionality. Requires Version 3.5 of \
;        the .NET Framework. Not available for Windows \
;        versions earlier than Windows XP.'
    LangString DESC_SQLXpress ${LANG_ENGLISH} 'This installs a local instance of SQL Server Express.  The instance name will be EncounterPRO_OS'
    LangString DESC_EproDatabase ${LANG_ENGLISH} 'This installs a copy of the EncounterPRO-OS starter database'
    LangString DESC_EproClient ${LANG_ENGLISH} 'This installs EncounterPRO-OS client program'
;    LangString DESC_SecPDFEng ${LANG_ENGLISH} \
;        'This provides PDF reporting support.'
;    LangString DESC_SecJMJDoc ${LANG_ENGLISH} \
;        'This provides JMJ Document creation support. \
;        It is necessary for e-Rx and other integrations.'
;    LangString DESC_SecXmlHl7 ${LANG_ENGLISH} \
;        'This provides Xml to HL7 conversion support. \
;        It is necessary for some integrations.'
;    LangString DESC_SecEPSign ${LANG_ENGLISH} \
;        'This provides JMJ Signature Capture support. \
;        It provides a smoother signature than other \
;        supported options when signing through RDP.'
    
    LangString PAGE_SERVDB_TITLE ${LANG_ENGLISH} "EncounterPRO-OS Settings"
    LangString PAGE_SERVDB_SUBTITLE ${LANG_ENGLISH} "Enter/select the names \
        of your EncounterPRO-OS Server and Database."
    

    ; Assign language strings to sections
    !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
;        !insertmacro MUI_DESCRIPTION_TEXT ${SecCmpMgr} $(DESC_SecCmpMgr)
    !insertmacro MUI_DESCRIPTION_TEXT ${SQLXpress} $(DESC_SQLXpress)
    !insertmacro MUI_DESCRIPTION_TEXT ${EproDatabase} $(DESC_EproDatabase)
    !insertmacro MUI_DESCRIPTION_TEXT ${EproClient} $(DESC_EproClient)
 ;       !insertmacro MUI_DESCRIPTION_TEXT ${SecPDFEng} $(DESC_SecPDFEng)
 ;       !insertmacro MUI_DESCRIPTION_TEXT ${SecJMJDoc} $(DESC_SecJMJDoc)
;        !insertmacro MUI_DESCRIPTION_TEXT ${SecXmlHl7} $(DESC_SecXmlHl7)
;        !insertmacro MUI_DESCRIPTION_TEXT ${SecEPSign} $(DESC_SecEPSign)
    !insertmacro MUI_FUNCTION_DESCRIPTION_END
    
Function .onInit
    Call PreInstall
  
    SetShellVarContext all
    
    StrCpy $SERVER ".\EncounterPRO_OS"
    StrCpy $DATABASE "EncounterPRO_OS"
FunctionEnd

