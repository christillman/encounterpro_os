# Included files
!include Sections.nsh
!include WordFunc.nsh
!insertmacro WordFind
!insertmacro un.WordFind
!include FileFunc.nsh
!insertmacro GetParent
!insertmacro un.GetParent
!include LogicLib.nsh
!include MUI.nsh
!include Library.nsh

# Defines
!ifndef Name
  !define Name "EncounterPRO Component"
!endif
!ifndef Version
  !define Version 1.0.0
!endif
!ifndef Company
  !define Company "The EncounterPRO Foundation, Inc."
!endif
!ifndef Url
  !define Url "http://www.encounterpro.org"
!endif
!ifndef EPResolveOrder
  !define EPResolveOrder "Server,Client5,Client4"
!endif
!define StrLoc "!insertmacro StrLoc"
!define UnStrLoc "!insertmacro UnStrLoc"
!define EPUninstREG "Software\Microsoft\Windows\CurrentVersion\Uninstall\$EPName"
 
!macro StrLoc ResultVar String SubString StartPoint
  Push "${String}"
  Push "${SubString}"
  Push "${StartPoint}"
  Call StrLoc
  Pop "${ResultVar}"
!macroend

!macro UnStrLoc ResultVar String SubString StartPoint
  Push "${String}"
  Push "${SubString}"
  Push "${StartPoint}"
  Call un.StrLoc
  Pop "${ResultVar}"
!macroend

Function StrLoc
/*After this point:
  ------------------------------------------
   $R0 = StartPoint (input)
   $R1 = SubString (input)
   $R2 = String (input)
   $R3 = SubStringLen (temp)
   $R4 = StrLen (temp)
   $R5 = StartCharPos (temp)
   $R6 = TempStr (temp)*/
 
  ;Get input from user
  Exch $R0
  Exch
  Exch $R1
  Exch 2
  Exch $R2
  Push $R3
  Push $R4
  Push $R5
  Push $R6
 
  ;Get "String" and "SubString" length
  StrLen $R3 $R1
  StrLen $R4 $R2
  ;Start "StartCharPos" counter
  StrCpy $R5 0
 
  ;Loop until "SubString" is found or "String" reaches its end
  ${Do}
    ;Remove everything before and after the searched part ("TempStr")
    StrCpy $R6 $R2 $R3 $R5
 
    ;Compare "TempStr" with "SubString"
    ${If} $R6 == $R1
      ${If} $R0 == `<`
        IntOp $R6 $R3 + $R5
        IntOp $R0 $R4 - $R6
      ${Else}
        StrCpy $R0 $R5
      ${EndIf}
      ${ExitDo}
    ${EndIf}
    ;If not "SubString", this could be "String"'s end
    ${If} $R5 >= $R4
      StrCpy $R0 ``
      ${ExitDo}
    ${EndIf}
    ;If not, continue the loop
    IntOp $R5 $R5 + 1
  ${Loop}
 
  ;Return output to user
  Pop $R6
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Exch
  Pop $R1
  Exch $R0
FunctionEnd

Function un.StrLoc
/*After this point:
  ------------------------------------------
   $R0 = StartPoint (input)
   $R1 = SubString (input)
   $R2 = String (input)
   $R3 = SubStringLen (temp)
   $R4 = StrLen (temp)
   $R5 = StartCharPos (temp)
   $R6 = TempStr (temp)*/

  ;Get input from user
  Exch $R0
  Exch
  Exch $R1
  Exch 2
  Exch $R2
  Push $R3
  Push $R4
  Push $R5
  Push $R6

  ;Get "String" and "SubString" length
  StrLen $R3 $R1
  StrLen $R4 $R2
  ;Start "StartCharPos" counter
  StrCpy $R5 0

  ;Loop until "SubString" is found or "String" reaches its end
  ${Do}
    ;Remove everything before and after the searched part ("TempStr")
    StrCpy $R6 $R2 $R3 $R5

    ;Compare "TempStr" with "SubString"
    ${If} $R6 == $R1
      ${If} $R0 == `<`
        IntOp $R6 $R3 + $R5
        IntOp $R0 $R4 - $R6
      ${Else}
        StrCpy $R0 $R5
      ${EndIf}
      ${ExitDo}
    ${EndIf}
    ;If not "SubString", this could be "String"'s end
    ${If} $R5 >= $R4
      StrCpy $R0 ``
      ${ExitDo}
    ${EndIf}
    ;If not, continue the loop
    IntOp $R5 $R5 + 1
  ${Loop}

  ;Return output to user
  Pop $R6
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Exch
  Pop $R1
  Exch $R0
FunctionEnd


# MUI defines
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

# Reserved Files

# Variables
Var EncounterPROFolder
Var EPName
Var DotNetVersion
Var DotNetFolder
Var ALREADY_INSTALLED

# Copy necessary files
;!system 'copy /Y "http://www.assembla.com/spaces/EncounterPRO-OS/documents/dWBzWwLvar37qbeJe5cbLr/download/NSISReplicate.exe" "NSISReplicate.exe"'
;!system 'copy /Y "http://www.assembla.com/spaces/EncounterPRO-OS/documents/aiIfC8Lver36_1eJe5cbCb/download/NSISUnReplicate.exe" "NSISUnReplicate.exe"'

# Installer pages
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
Name "${Name} ${Version}"
OutFile "${Name} ${Version} Install.exe"
InstallDir "$COMMONFILES32\EncounterPRO-OS\${Name}"
CRCCheck on
XPStyle on
ShowInstDetails show
ShowUninstDetails nevershow

# Installer sections
Section Main
    ReadINIStr $R9 "$COMMONFILES32\EncounterPRO-OS\EPCompInfo.ini" "${Name}" "ProductVersion"
    StrCmp $R9 '' 0 +2
    StrCpy $ALREADY_INSTALLED 1
    
    SetOverwrite on

    SetOutPath $INSTDIR
    File "EncounterPRO.OS.CSharpGACTool.exe"

    ; FILES
    DetailPrint 'FILES section'
    !tempfile FILESINCLUDE
    !system 'NSISReplicate.exe FILES\*.* "$INSTDIR" "File $\"%SOURCE%$\"" > "${FILESINCLUDE}"'
    !include ${FILESINCLUDE}
    !delfile ${FILESINCLUDE}
    !undef FILESINCLUDE
    
    ; REGFILES
    DetailPrint 'REGFILES section'
    !tempfile REGFILESINCLUDE
    !system 'NSISReplicate.exe REGFILES\*.* "$INSTDIR" "File \"%SOURCE%\"\r\nnsExec::Exec $\'regsvr32.exe \"%DEST%\"$\'" > "${REGFILESINCLUDE}"'
    !include ${REGFILESINCLUDE}
    !delfile ${REGFILESINCLUDE}
    !undef REGFILESINCLUDE
    
    ; GAC
    DetailPrint 'GAC section'
    !tempfile GACINCLUDE
    !system 'NSISReplicate.exe GAC\*.* "$INSTDIR" "File $\'%SOURCE%$\'\r\nnsExec::Exec $\'\"$INSTDIR\EncounterPRO.OS.CSharpGACTool.exe\" \"%DEST%\"$\'" > "${GACINCLUDE}"'
    !include ${GACINCLUDE}
    !delfile ${GACINCLUDE}
    !undef GACINCLUDE
    
    ; GACREG
    DetailPrint 'GACREG section'
    !tempfile GACREGINCLUDE
    !system 'NSISReplicate.exe GACREG\*.* "$INSTDIR" "File $\'%SOURCE%$\'\r\nnsExec::Exec $\'\"$INSTDIR\EncounterPRO.OS.CSharpGACTool.exe\" \"%DEST%\"$\'\r\nnsExec::Exec $\'\"$INSTDIR\EncounterPRO.OS.CSharpGACTool.exe\" /r \"%DEST%\"$\'" > "${GACREGINCLUDE}"'
    !include ${GACREGINCLUDE}
    !delfile ${GACREGINCLUDE}
    !undef GACREGINCLUDE
    
    ; SYS
    DetailPrint 'SYS section'
    !tempfile SYSINCLUDE
    !system 'NSISReplicate.exe SYS\*.* "$SYSDIR" "!insertmacro InstallLib DLL $ALREADY_INSTALLED REBOOT_PROTECTED \"%SOURCE%\" \"%DEST%\" \"$SYSDIR\"" > "${SYSINCLUDE}"'
    !include ${SYSINCLUDE}
    !delfile ${SYSINCLUDE}
    !undef SYSINCLUDE
    
    ; SYSREG
    DetailPrint 'SYSREG section'
    !tempfile SYSREGINCLUDE
    !system 'NSISReplicate.exe SYSREG\*.* "$SYSDIR" "!insertmacro InstallLib REGDLL $ALREADY_INSTALLED REBOOT_PROTECTED \"%SOURCE%\" \"%DEST%\" \"$SYSDIR\"" > "${SYSREGINCLUDE}"'
    !include ${SYSREGINCLUDE}
    !delfile ${SYSREGINCLUDE}
    !undef SYSREGINCLUDE

    ; RUN
    DetailPrint 'RUN section'
    !tempfile RUNINCLUDE
    !system 'NSISReplicate.exe RUN\*.* "$INSTDIR\Run" "File \"%SOURCE%\"\r\nDetailPrint \"Running %DEST%...\"\r\nnsExec::ExecToLog \"%DEST%\"" > "${RUNINCLUDE}"'
    !include ${RUNINCLUDE}
    !system 'NSISUnReplicate.exe RUN\*.* "$INSTDIR\Run" "Delete \"%FILE%\"" > "${RUNINCLUDE}"'
    !include ${RUNINCLUDE}
    !delfile ${RUNINCLUDE}
    !undef RUNINCLUDE
    RmDir "$INSTDIR\Run"
    
    !ifdef EXE
        ExecWait '${EXE}'
    !endif

    Delete "$INSTDIR\EncounterPRO.OS.CSharpGACTool.exe"
    
    ${GetTime} "" "L" $0 $1 $2 $3 $4 $5 $6
    ; $0="01"      day
    ; $1="04"      month
    ; $2="2005"    year
    ; $3="Friday"  day of week name
    ; $4="11"      hour
    ; $5="05"      minute
    ; $6="50"      seconds
 
    WriteINIStr "$COMMONFILES32\EncounterPRO-OS\EPCompInfo.ini" "${Name}" "ProductVersion" "${Version}"
    WriteINIStr "$COMMONFILES32\EncounterPRO-OS\EPCompInfo.ini" "${Name}" "${Version}" "$1/$0/$2 $4:$5:$6"
SectionEnd

Section -Post
    WriteUninstaller $INSTDIR\uninstall.exe
    !ifdef AddRemoveSupport
      WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${Name}" DisplayName "$(^Name)"
      WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${Name}" DisplayVersion "${VERSION}"
      WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${Name}" Publisher "${COMPANY}"
      WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${Name}" URLInfoAbout "${URL}"
      WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${Name}" DisplayIcon $INSTDIR\uninstall.exe
      WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${Name}" UninstallString $INSTDIR\uninstall.exe
      WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${Name}" NoModify 1
      WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${Name}" NoRepair 1
    !endif
SectionEnd

# Uninstaller sections
Section un.Main
    
    SetOutPath "$INSTDIR"
    File "EncounterPRO.OS.CSharpGACTool.exe"
    
    ; FILES
    DetailPrint 'FILES section'
    !tempfile FILESINCLUDE
    !system 'NSISUNReplicate.exe FILES\*.* "$INSTDIR" "Delete \"%FILE%\"" > "${FILESINCLUDE}"'
    !include ${FILESINCLUDE}
    !delfile ${FILESINCLUDE}
    !undef FILESINCLUDE

    ; REGFILES
    DetailPrint 'REGFILES section'
    !tempfile REGFILESINCLUDE
    !system 'NSISUNReplicate.exe REGFILES\*.* "$INSTDIR" "nsExec::Exec $\'regsvr32.exe /u \"%FILE%\"\r\nDelete \"%FILE%\"" > "${REGFILESINCLUDE}"'
    !include ${REGFILESINCLUDE}
    !delfile ${REGFILESINCLUDE}
    !undef REGFILESINCLUDE

    ; EPFILES
    DetailPrint 'EPFILES section'
    !tempfile EPFILESINCLUDE
    !system 'NSISUNReplicate.exe EPFILES\*.* "$EncounterPROFolder" "Delete \"%FILE%\"" > "${EPFILESINCLUDE}"'
    !include ${EPFILESINCLUDE}
    !delfile ${EPFILESINCLUDE}
    !undef EPFILESINCLUDE

    ; EPREGFILES
    DetailPrint 'EPREGFILES section'
    !tempfile EPREGFILESINCLUDE
    !system 'NSISUNReplicate.exe EPREGFILES\*.* "$EncounterPROFolder" "!insertmacro UnInstallLib REGDLL SHARED REMOVE \"%FILE%\"" > "${EPREGFILESINCLUDE}"'
    !include ${EPREGFILESINCLUDE}
    !delfile ${EPREGFILESINCLUDE}
    !undef EPREGFILESINCLUDE

    ; CPRFILES
    DetailPrint 'CPRFILES section'
    IfFileExists $CPRFILES\*.* +3 0
    MessageBox MB_OK "The CPRFILES folder $\"$CPRFILES$\" could not be found.  Setup cannot continue."
    Abort
    !tempfile CPRFILESINCLUDE
    !system 'NSISUNReplicate.exe CPRFILES\*.* "$CPRFILES" "SetFileAttributes %FILE% NORMAL\r\nDelete \"%FILE%\"" > "${CPRFILESINCLUDE}"'
    !include ${CPRFILESINCLUDE}
    !delfile ${CPRFILESINCLUDE}
    !undef CPRFILESINCLUDE

    ; GAC
    DetailPrint 'GAC section'
    !tempfile GACINCLUDE
    !system 'NSISUNReplicate.exe GAC\*.* "$INSTDIR" "nsExec::Exec $\'\"$INSTDIR\EncounterPRO.OS.CSharpGACTool.exe\" /u \"%FILE%\"$\'\r\nDelete $\'%FILE%$\'" > "${GACINCLUDE}"'
    !include ${GACINCLUDE}
    !delfile ${GACINCLUDE}
    !undef GACINCLUDE

    ; GACREG
    DetailPrint 'GACREG section'
    !tempfile GACREGINCLUDE
    !system 'NSISUNReplicate.exe GACREG\*.* "$INSTDIR" "nsExec::Exec $\'\"$INSTDIR\EncounterPRO.OS.CSharpGACTool.exe\" /u \"%FILE%\"$\'\r\nnsExec::Exec $\'\"$INSTDIR\EncounterPRO.OS.CSharpGACTool.exe\" /ur \"%FILE%\"$\'\r\nDelete $\'%FILE%$\'" > "${GACREGINCLUDE}"'
    !include ${GACREGINCLUDE}
    !delfile ${GACREGINCLUDE}
    !undef GACREGINCLUDE

    ; SYS
    DetailPrint 'SYS section'
    !tempfile SYSINCLUDE
    !system 'NSISUNReplicate.exe SYS\*.* "$SYSDIR" "!insertmacro UnInstallLib DLL SHARED NOREMOVE \"%FILE%\"" > "${SYSINCLUDE}"'
    !include ${SYSINCLUDE}
    !delfile ${SYSINCLUDE}
    !undef SYSINCLUDE

    ; SYSREG
    DetailPrint 'SYSREG section'
    !tempfile SYSREGINCLUDE
    !system 'NSISUNReplicate.exe SYSREG\*.* "$INSTDIR" "!insertmacro UnInstallLib REGDLL SHARED NOREMOVE \"%FILE%\"" > "${SYSREGINCLUDE}"'
    !include ${SYSREGINCLUDE}
    !delfile ${SYSREGINCLUDE}
    !undef SYSREGINCLUDE
    
    ; SCRIPTS
    ; Scripts are removed during installation
    Delete "$INSTDIR\EncounterPRO.OS.CSharpGACTool.exe"

    WriteINIStr "$COMMONFILES32\EncounterPRO-OS\EPCompInfo.ini" "${Name}" "ProductVersion" ""
    DeleteINIStr "$COMMONFILES32\EncounterPRO-OS\EPCompInfo.ini" "${Name}" "${Version}"
SectionEnd

Section un.Post
    !ifdef AddRemoveSupport
      DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${Name}"
    !endif
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    RmDir /REBOOTOK $INSTDIR
SectionEnd

# Installer functions
Function .onInit
    InitPluginsDir
    Call GetDotNETVersion
    Pop $DotNetVersion
    StrCpy $R0 $DotNetVersion 1 1
    IntCmp $R0 1 0 +3 +5
    StrCpy $R0 $DotNetVersion 3 1
    IntCmp $R0 1 +3 0 +3
    MessageBox MB_OK 'This setup requires version 1.1 or later of the .NET Framework.'
    Abort
    ReadRegStr $DotNetFolder HKLM "SOFTWARE\Microsoft\.NETFramework" "InstallRoot"
    StrCpy $DotNetFolder "$DotNetFolder\$DotNetVersion"
    SetOutPath $SYSDIR
    Call InitEncounterPROFolder
FunctionEnd

Function un.onInit
    Call un.InitEncounterPROFolder
FunctionEnd

Function InitEncounterPROFolder
    ${StrLoc} $R0 $CMDLINE EncounterPROFolder >
    StrCmp $R0 '' ResolveEPFolder ; EP location was not passed in
    ${StrLoc} $R0 $CMDLINE = $R0
    StrCmp $R0 '' ResolveEPFolder ; EP location was not passed in correctly
    IntOp $R0 $R0 + 1
    ${StrLoc} $R1 $CMDLINE ";" $R0
    StrCmp $R0 '' ResolveEPFolder ; EP location was not passed in correctly
    
    IntOp $R2 $R1 - $R0
    StrCpy $EncounterPROFolder $CMDLINE $R2 $R0
    goto DoneEPFolder
    
    ResolveEPFolder:
    ${WordFind} ${EPResolveOrder} ',' '#' $R0
    IntOp $R0 $R0 + 1
    ; $R0 = word count
    StrCpy $R1 1
    ; $R1 = current word
    
    EPFolderLoop:
    StrCpy $EPName ''
    ; If current word # is more than word count, we're done
    IntCmp $R0 $R1 0 DoneEPFolder
    
    ${WordFind} ${EPResolveOrder} ',' +$R1 $R2
    ; Get next in resolve order into $R2
    
    StrCmp $R2 "Client4" 0 +2
    StrCpy $EPName "EncounterPRO"
    StrCmp $R2 "Client5" 0 +2
    StrCpy $EPName "EncounterPRO 5"
    StrCmp $R2 "Server" 0 +2
    StrCpy $EPName "EncounterPRO Server"
    
    StrCmp $R2 "Client2" 0 EPFolderCont
    ReadRegStr $EncounterPROFolder HKLM "SOFTWARE\JMJ Technologies\EncounterPRO" "InstallPath"
    StrCmp $EncounterPROFolder '' EPFolderDoneIter
    goto FoundEPFolder
    
    EPFolderCont:

    ReadRegStr $R3 HKLM "${EPUninstReg}" "UninstallString"
    StrCmp $R3 '' EPFolderDoneIter
    ${GetParent} $R3 $R3
    StrCpy $EncounterPROFolder $R3
    goto DoneEPFolder
        
    EPFolderDoneIter:
    IntOp $R1 $R1 + 1
    goto EPFolderLoop
    
    DoneEPFolder:
    
    StrCmp $EncounterPROFolder '' 0 FoundEPFolder
    IfFileExists 'D:\Program Files\JMJ\EncounterPRO\encounterpro.ini' 0 +3
    StrCpy $EncounterPROFolder 'D:\Program Files\JMJ\EncounterPRO'
    goto FoundEPFolder
    IfFileExists 'C:\Program Files\JMJ\EncounterPRO\encounterpro.ini' 0 +3
    StrCpy $EncounterPROFolder 'C:\Program Files\JMJ\EncounterPRO'
    goto FoundEPFolder
    MessageBox MB_OK 'The location of the EncounterPRO installation could not be found.  Please re-run the setup with the "EncounterPROFolder" argument.  Be sure that you place a semicolon at the end of the argument.  Example: setup.exe EncounterPROFolder=C:\Program Files\JMJ\EncounterPRO;'
    Abort
    
    FoundEPFolder:
FunctionEnd

Function un.InitEncounterPROFolder
    ${UnStrLoc} $R0 $CMDLINE EncounterPROFolder >
    StrCmp $R0 '' ResolveEPFolder ; EP location was not passed in
    ${UnStrLoc} $R0 $CMDLINE = $R0
    StrCmp $R0 '' ResolveEPFolder ; EP location was not passed in correctly
    IntOp $R0 $R0 + 1
    ${UnStrLoc} $R1 $CMDLINE ";" $R0
    StrCmp $R0 '' ResolveEPFolder ; EP location was not passed in correctly
    
    IntOp $R2 $R1 - $R0
    StrCpy $EncounterPROFolder $CMDLINE $R2 $R0
    goto DoneEPFolder
    
    ResolveEPFolder:
    ${un.WordFind} ${EPResolveOrder} ',' '#' $R0
    ; $R0 = word count
    StrCpy $R1 1
    ; $R1 = current word
    
    EPFolderLoop:
    ; If current word # is more than word count, we're done
    IntCmp $R0 $R1 0 DoneEPFolder
    
    ${un.WordFind} ${EPResolveOrder} ',' +$R1 $R2
    StrCmp $R2 "Client4" 0 +2
    StrCpy $EPName "EncounterPRO"
    StrCmp $R2 "Client5" 0 +2
    StrCpy $EPName "EncounterPRO 5"
    StrCmp $R2 "Server" 0 +2
    StrCpy $EPName "EncounterPRO Server"
    StrCmp $R2 "Client2" 0 EPFolderCont
    ReadRegStr $EncounterPROFolder HKLM "SOFTWARE\JMJ Technologies\EncounterPRO" "InstallPath"
    StrCmp $EncounterPROFolder '' EPFolderDoneIter
    goto FoundEPFolder
    
    EPFolderCont:

    ReadRegStr $R3 HKLM "${EPUninstReg}" "UninstallString"
    StrCmp $R3 '' EPFolderDoneIter
    ${un.GetParent} $R3 $R3
    StrCpy $EncounterPROFolder $R3
    goto DoneEPFolder
        
    EPFolderDoneIter:
    IntOp $R1 $R1 + 1
    goto EPFolderLoop
    
    DoneEPFolder:
    
    StrCmp $EncounterPROFolder '' 0 FoundEPFolder
    IfFileExists 'D:\Program Files\JMJ\EncounterPRO\encounterpro.ini' 0 +3
    StrCpy $EncounterPROFolder 'D:\Program Files\JMJ\EncounterPRO'
    goto FoundEPFolder
    IfFileExists 'C:\Program Files\JMJ\EncounterPRO\encounterpro.ini' 0 +3
    StrCpy $EncounterPROFolder 'C:\Program Files\JMJ\EncounterPRO'
    goto FoundEPFolder
    MessageBox MB_OK 'The location of the EncounterPRO installation could not be found.  Please re-run the setup with the "EncounterPROFolder" argument.  Be sure that you place a semicolon at the end of the argument.  Example: setup.exe EncounterPROFolder=C:\Program Files\JMJ\EncounterPRO;'
    Abort
    
    FoundEPFolder:
FunctionEnd

Function GetDotNETVersion
  Push $0
  Push $1

  System::Call "mscoree::GetCORVersion(w .r0, i ${NSIS_MAX_STRLEN}, *i) i .r1"
  StrCmp $1 0 +2
    StrCpy $0 0

  Pop $1
  Exch $0
FunctionEnd

;!system 'del "NSISReplicate.exe"'
;!system 'del "NSISUnReplicate.exe"'
