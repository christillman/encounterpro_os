; Epro Install Functions - eproinstallfunctions.nsh
;
; Functions for pre-post install checks and system changes
; required for installation of EncounterPRO and associated
; products

!ifndef EPINSTFUNC
    !define EPINSTFUNC

; MSI defines
!define INSTALLSTATE_DEFAULT "5"
!define INSTALLLEVEL_MAXIMUM "0xFFFF"
!define INSTALLSTATE_ABSENT "2"
!define ERROR_SUCCESS "0"
  
!include WordFunc.nsh
!insertmacro VersionCompare
!include LogicLib.nsh

;EnvVarUpdate
;!include "..\plugins\EnvVarUpdate.nsh"


Var WinVer
Var Bitness
        
Function getWindowsVersion
    Push $R0
    
    ClearErrors
 
    ReadRegStr $R0 HKLM \
    "SOFTWARE\Microsoft\Windows NT\CurrentVersion" CurrentVersion
    IfErrors 0 lbl_?winnt
    
    ; We are not NT
    StrCpy $WinVer 'not NT'
    goto lbl_?windone
    
    ; We are NT
    lbl_?winnt:
    StrCpy $WinVer $R0
    
    lbl_?windone:
    Pop $R0
FunctionEnd

Function isNet35Installed
    Push $R0
    Push $R1
    
    ReadRegDWORD $R0 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5" "Install"
    ReadRegStr $R1 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5" "Version"
        
    ${If} $R0 == 1
        ${VersionCompare} $R1 '3.5.30729.01' $R0
        ${If} $R0 < 2 ; If dotnetversion >= 3.5sp1
            StrCpy $R0 "Yes"
            goto lbl_?net35idone
        ${EndIf}
    ${EndIf}
    
    StrCpy $R0 "No"
    
    lbl_?net35idone:
    
    Pop $R1
    Exch $R0
FunctionEnd

Function Net4Version
    Push $R0
    Push $R1
    
    ReadRegDWORD $R0 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" "Install"
    ReadRegStr $R1 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" "Version"
       
	StrCpy $R0 $R1

    Pop $R1
    Exch $R0
FunctionEnd

Function isNet40Installed
    Push $R0
    Push $R1
    
    ReadRegDWORD $R0 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" "Install"
    ReadRegStr $R1 HKLM "SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full" "Version"
        
    ${If} $R0 == 1
        ${VersionCompare} $R1 '4.0.0.0' $R0
        ${If} $R0 < 2 ; If dotnetversion >= 4.0
            StrCpy $R0 "Yes"
            goto lbl_?net40idone
        ${EndIf}
    ${EndIf}
    
    StrCpy $R0 "No"
    
    lbl_?net40idone:
    
    Pop $R1
    Exch $R0
FunctionEnd

Function RemoveMSI
  ; Product or Upgrade Code expected on the top of the stack
  Exch $R0
  Push $R1
  Push $R2

  StrCpy $R1 0
  loop_RemoveMSI:

  StrCpy $1 "{00000000-0000-0000-0000-000000000000}"
  System::Call "msi::MsiEnumRelatedProducts(t '$R0', \
               i 0, i $R1, t .r8) i .r9"
  ;MessageBox MB_OK "UpgradeCode: $R0$\nReturn $0$\nValue $1"
  StrCmp $9 0 +5
  Push $R0              ; MsiEnumRelatedProducts failed.
  Call RemoveMSIProduct ; Try using the Guid as a ProductCode
  Pop $R0
  goto done_RemoveMSI

  Push $8
  Call RemoveMSIProduct
  Pop $8
  IntOp $R1 $R1 + 1
  goto loop_RemoveMSI

  done_RemoveMSI:
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd

Function RemoveMSIProduct
  ; ProductCode expected at top of stack
  Exch $R0
  Push $R1
  Push $R2

  System::Call "msi::MsiQueryProductStateA(t '$R0') i .r0"
  StrCmp $0 "${INSTALLSTATE_DEFAULT}" 0 done_RemoveMSIProduct

  StrCpy $1 ${NSIS_MAX_STRLEN}
  StrCpy $R1 "ProductName"
  System::Call "msi::MsiGetProductInfoA(t '$R0', t '$R1', t .r0, *i r1)"
  StrCpy $R2 $0
  StrCpy $R1 "VersionString"
  System::Call "msi::MsiGetProductInfo(t '$R0', t '$R1', t .r0, *i r1)"
  StrCpy $R2 "$R2 $0"

  MessageBox MB_YESNO|MB_ICONQUESTION "It is recommended that you remove $R2 before proceeding with the installation.$\nMay I remove it for you?" \
             /SD IDYES IDNO done_RemoveMSIProduct

  DetailPrint "Uninstalling $R2..."
  System::Call "msi::MsiConfigureProductA(t '$R0', \
    i ${INSTALLLEVEL_MAXIMUM}, i ${INSTALLSTATE_ABSENT}) i .r0"
  StrCmp $0 0 done_RemoveMSIProduct

  DetailPrint "Uninstallation of $R3 failed with error code $0."
  MessageBox MB_YESNO|MB_ICONEXCLAMATION "Uninstallation of $R2 has failed with error code $0.$\nDo you want to proceed with the rest of the installation?" \
             /SD IDYES IDYES done_RemoveMSIProduct

  Abort "Installation was cancelled by the user."

  done_RemoveMSIProduct:
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd

Function CheckBitness
  System::Call "kernel32::GetCurrentProcess() i .s"
  System::Call "kernel32::IsWow64Process(i s, *i .r0)"
  StrCmp $0 0 0 +3
  StrCpy $Bitness 32
  goto +2
  StrCpy $Bitness 64
FunctionEnd
    
Function CheckIsAdminUser
  System::Call "kernel32::GetModuleHandle(t 'shell32.dll') i .s"
  System::Call "kernel32::GetProcAddress(i s, i 680) i .r0"
  System::Call "::$0() i .r0"
  IntCmp $0 1 +3
  MessageBox MB_OK "Administrator privileges are required to run this installer."
  Abort "Only users with Administrator privileges can run this installer."
FunctionEnd

Function un.CheckIsAdminUser
  System::Call "kernel32::GetModuleHandle(t 'shell32.dll') i .s"
  System::Call "kernel32::GetProcAddress(i s, i 680) i .r0"
  System::Call "::$0() i .r0"
  IntCmp $0 1 +3
  MessageBox MB_OK "Administrator privileges are required to run this uninstaller."
  Abort "Only users with Administrator privileges can run this uninstaller."
FunctionEnd

; ################################################################
; appends \ to the path if missing
; example: !insertmacro GetCleanDir "c:\blabla"
; Pop $0 => "c:\blabla\"
!macro GetCleanDir INPUTDIR
  ; ATTENTION: USE ON YOUR OWN RISK!
  ; Please report bugs here: http://stefan.bertels.org/
  !define Index_GetCleanDir 'GetCleanDir_Line${__LINE__}'
  Push $R0
  Push $R1
  StrCpy $R0 "${INPUTDIR}"
  StrCmp $R0 "" ${Index_GetCleanDir}-finish
  StrCpy $R1 "$R0" "" -1
  StrCmp "$R1" "\" ${Index_GetCleanDir}-finish
  StrCpy $R0 "$R0\"
${Index_GetCleanDir}-finish:
  Pop $R1
  Exch $R0
  !undef Index_GetCleanDir
!macroend
 
; ################################################################
; similar to "RMDIR /r DIRECTORY", but does not remove DIRECTORY itself
; example: !insertmacro RemoveFilesAndSubDirs "$INSTDIR"
!macro RemoveFilesAndSubDirs DIRECTORY
  ; ATTENTION: USE ON YOUR OWN RISK!
  ; Please report bugs here: http://stefan.bertels.org/
  !define Index_RemoveFilesAndSubDirs 'RemoveFilesAndSubDirs_${__LINE__}'
 
  Push $R0
  Push $R1
  Push $R2
 
  !insertmacro GetCleanDir "${DIRECTORY}"
  Pop $R2
  FindFirst $R0 $R1 "$R2*.*"
${Index_RemoveFilesAndSubDirs}-loop:
  StrCmp $R1 "" ${Index_RemoveFilesAndSubDirs}-done
  StrCmp $R1 "." ${Index_RemoveFilesAndSubDirs}-next
  StrCmp $R1 ".." ${Index_RemoveFilesAndSubDirs}-next
  IfFileExists "$R2$R1\*.*" ${Index_RemoveFilesAndSubDirs}-directory
  ; file
  Delete "$R2$R1"
  goto ${Index_RemoveFilesAndSubDirs}-next
${Index_RemoveFilesAndSubDirs}-directory:
  ; directory
  RMDir /r "$R2$R1"
${Index_RemoveFilesAndSubDirs}-next:
  FindNext $R0 $R1
  Goto ${Index_RemoveFilesAndSubDirs}-loop
${Index_RemoveFilesAndSubDirs}-done:
  FindClose $R0
 
  Pop $R2
  Pop $R1
  Pop $R0
  !undef Index_RemoveFilesAndSubDirs
!macroend

Function openLinkNewWindow
  Push $3
  Exch
  Push $2
  Exch
  Push $1
  Exch
  Push $0
  Exch
 
  ReadRegStr $0 HKCR "http\shell\open\command" ""
# Get browser path
    DetailPrint $0
  StrCpy $2 '"'
  StrCpy $1 $0 1
  StrCmp $1 $2 +2 # if path is not enclosed in " look for space as final char
    StrCpy $2 ' '
  StrCpy $3 1
  loop:
    StrCpy $1 $0 1 $3
    DetailPrint $1
    StrCmp $1 $2 found
    StrCmp $1 "" found
    IntOp $3 $3 + 1
    Goto loop
 
  found:
    StrCpy $1 $0 $3
    StrCmp $2 " " +2
      StrCpy $1 '$1"'
 
  Pop $0
  Exec '$1 $0'
  Pop $0
  Pop $1
  Pop $2
  Pop $3
FunctionEnd
 
!macro _OpenURL URL
Push "${URL}"
Call openLinkNewWindow
!macroend
 
!define OpenURL '!insertmacro "_OpenURL"'

; This function returns "Yes" in $R0 if the MSI version is at least 4.5.  Otherwise "No" is returned in $R0.
Function isMSIVersion45
  Push $R0
  Push $R1
    
  GetDllVersion "$SYSDIR\MSI.dll" $R0 $R1
  IntOp $R2 $R0 >> 16
  IntOp $R2 $R2 & 0x0000FFFF ; $R2 now contains major version
  IntOp $R3 $R0 & 0x0000FFFF ; $R3 now contains minor version
  IntOp $R4 $R1 >> 16
  IntOp $R4 $R4 & 0x0000FFFF ; $R4 now contains release
  IntOp $R5 $R1 & 0x0000FFFF ; $R5 now contains build
  StrCpy $0 "$R2.$R3.$R4.$R5" ; $0 now contains string like "1.2.0.192"

  ${VersionCompare} $0 '4.5' $R0
  ${If} $R0 < 2 ; If msi version >= 4.5
    StrCpy $R0 "Yes"
    goto msiversioncheckdone
  ${EndIf}
 
  StrCpy $R0 "No"
    
  msiversioncheckdone:
    
  Pop $R1
  Exch $R0
FunctionEnd

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CheckDLLVersion
; Usage:
;   ${CheckDLLVersion} "mylib.dll" "4.5.0.2" $R0
;
;  Puts "Yes" into $R0 if version of mylib.dll is >= 4.5.0.2
;  Puts "No" otherwise
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This function returns "Yes" if the DLL at the top
; is at least as high as the version specified in the
; top of the stack.  Otherwise "No" is returned in $R0.
;
; Usage:
;    Push "mylib.dll"
;    Push "4.5.0.2"
;    Call isDLLVersionOK
Function isDLLVersionOK
  Push $R8
  Exch 2
  Push $R7
  Exch 2
  Pop $R7
  Pop $R8
  Push $R6
  Push $R5
  Push $R4
  Push $R3
  Push $R2
  Push $R1
  Push $R0

  GetDllVersion "$R8" $R0 $R1
  IntOp $R2 $R0 >> 16
  IntOp $R2 $R2 & 0x0000FFFF ; $R2 now contains major version
  IntOp $R3 $R0 & 0x0000FFFF ; $R3 now contains minor version
  IntOp $R4 $R1 >> 16
  IntOp $R4 $R4 & 0x0000FFFF ; $R4 now contains release
  IntOp $R5 $R1 & 0x0000FFFF ; $R5 now contains build
  StrCpy $R6 "$R2.$R3.$R4.$R5" ; $R6 now contains string like "1.2.0.192"

  ${VersionCompare} $R6 $R7 $R0
  ${If} $R0 < 2 ; If actual version in $R6 >= desired version in $R7
    StrCpy $R8 "Yes"
    goto isDLLVersionOKdone
  ${EndIf}
 
  StrCpy $R8 "No"
    
  isDLLVersionOKdone:
  Pop $R0
  Pop $R1
  Pop $R2
  Pop $R3
  Pop $R4
  Pop $R5
  Pop $R6
  Pop $R7
  Exch $R8
FunctionEnd

!macro _isDLLVersionOK CheckDLL CheckVersion CheckResult
Push "${CheckDLL}"
Push "${CheckVersion}"
Call isDLLVersionOK
Pop "${CheckResult}"
!macroend
 
!define CheckDLLVersion '!insertmacro "_isDLLVersionOK"'


!macro StrStr ResultVar String SubString
  Push `${String}`
  Push `${SubString}`
  Call StrStr
  Pop `${ResultVar}`
!macroend
 
Function StrStr
/*After this point:
  ------------------------------------------
  $R0 = SubString (input)
  $R1 = String (input)
  $R2 = SubStringLen (temp)
  $R3 = StrLen (temp)
  $R4 = StartCharPos (temp)
  $R5 = TempStr (temp)*/
 
  ;Get input from user
  Exch $R0
  Exch
  Exch $R1
  Push $R2
  Push $R3
  Push $R4
  Push $R5
 
  ;Get "String" and "SubString" length
  StrLen $R2 $R0
  StrLen $R3 $R1
  ;Start "StartCharPos" counter
  StrCpy $R4 0
 
  ;Loop until "SubString" is found or "String" reaches its end
  loop:
    ;Remove everything before and after the searched part ("TempStr")
    StrCpy $R5 $R1 $R2 $R4
 
    ;Compare "TempStr" with "SubString"
    StrCmp $R5 $R0 done
    ;If not "SubString", this could be "String"'s end
    IntCmp $R4 $R3 done 0 done
    ;If not, continue the loop
    IntOp $R4 $R4 + 1
    Goto loop
  done:
 
/*After this point:
  ------------------------------------------
  $R0 = ResultVar (output)*/
 
  ;Remove part before "SubString" on "String" (if there has one)
  StrCpy $R0 $R1 `` $R4
 
  ;Return output to user
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd



!define StrStr "!insertmacro StrStr"
 

 ; GetParameters
 ; input, none
 ; output, top of stack (replaces, with e.g. whatever)
 ; modifies no other variables.
 
Function GetParameters
 
  Push $R0
  Push $R1
  Push $R2
  Push $R3
 
  StrCpy $R2 1
  StrLen $R3 $CMDLINE
 
  ;Check for quote or space
  StrCpy $R0 $CMDLINE $R2
  StrCmp $R0 '"' 0 +3
    StrCpy $R1 '"'
    Goto loop
  StrCpy $R1 " "
 
  loop:
    IntOp $R2 $R2 + 1
    StrCpy $R0 $CMDLINE 1 $R2
    StrCmp $R0 $R1 get
    StrCmp $R2 $R3 get
    Goto loop
 
  get:
    IntOp $R2 $R2 + 1
    StrCpy $R0 $CMDLINE 1 $R2
    StrCmp $R0 " " get
    StrCpy $R0 $CMDLINE "" $R2
 
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0
 
FunctionEnd

; GetParameterValue
; Chris Morgan<cmorgan@alum.wpi.edu> 5/10/2004
; -Updated 4/7/2005 to add support for retrieving a command line switch
;  and additional documentation
;
; Searches the command line input, retrieved using GetParameters, for the
; value of an option given the option name.  If no option is found the
; default value is placed on the top of the stack upon function return.
;
; This function can also be used to detect the existence of just a
; command line switch like /OUTPUT  Pass the default and "OUTPUT"
; on the stack like normal.  An empty return string "" will indicate
; that the switch was found, the default value indicates that
; neither a parameter or switch was found.
;
; Inputs - Top of stack is default if parameter isn't found,
;  second in stack is parameter to search for, ex. "OUTPUT"
; Outputs - Top of the stack contains the value of this parameter
;  So if the command line contained /OUTPUT=somedirectory, "somedirectory"
;  will be on the top of the stack when this function returns
;
; Register usage
;$R0 - default return value if the parameter isn't found
;$R1 - input parameter, for example OUTPUT from the above example
;$R2 - the length of the search, this is the search parameter+2
;      as we have '/OUTPUT='
;$R3 - the command line string
;$R4 - result from StrStr calls
;$R5 - search for ' ' or '"'
 
Function GetParameterValue
  Exch $R0  ; get the top of the stack(default parameter) into R0
  Exch      ; exchange the top of the stack(default) with
            ; the second in the stack(parameter to search for)
  Exch $R1  ; get the top of the stack(search parameter) into $R1
 
  ;Preserve on the stack the registers used in this function
  Push $R2
  Push $R3
  Push $R4
  Push $R5
 
  Strlen $R2 $R1+2    ; store the length of the search string into R2
 
  Call GetParameters  ; get the command line parameters
  Pop $R3             ; store the command line string in R3
 
  # search for quoted search string
  StrCpy $R5 '"'      ; later on we want to search for a open quote
  Push $R3            ; push the 'search in' string onto the stack
  Push '"/$R1='       ; push the 'search for'
  Call StrStr         ; search for the quoted parameter value
  Pop $R4
  StrCpy $R4 $R4 "" 1   ; skip over open quote character, "" means no maxlen
  StrCmp $R4 "" "" next ; if we didn't find an empty string go to next
 
  # search for non-quoted search string
  StrCpy $R5 ' '      ; later on we want to search for a space since we
                      ; didn't start with an open quote '"' we shouldn't
                      ; look for a close quote '"'
  Push $R3            ; push the command line back on the stack for searching
  Push '/$R1='        ; search for the non-quoted search string
  Call StrStr
  Pop $R4
 
  ; $R4 now contains the parameter string starting at the search string,
  ; if it was found
next:
  StrCmp $R4 "" check_for_switch ; if we didn't find anything then look for
                                 ; usage as a command line switch
  # copy the value after /$R1= by using StrCpy with an offset of $R2,
  # the length of '/OUTPUT='
  StrCpy $R0 $R4 "" $R2  ; copy commandline text beyond parameter into $R0
  # search for the next parameter so we can trim this extra text off
  Push $R0
  Push $R5            ; search for either the first space ' ', or the first
                      ; quote '"'
                      ; if we found '"/output' then we want to find the
                      ; ending ", as in '"/output=somevalue"'
                      ; if we found '/output' then we want to find the first
                      ; space after '/output=somevalue'
  Call StrStr         ; search for the next parameter
  Pop $R4
  StrCmp $R4 "" done  ; if 'somevalue' is missing, we are done
  StrLen $R4 $R4      ; get the length of 'somevalue' so we can copy this
                      ; text into our output buffer
  StrCpy $R0 $R0 -$R4 ; using the length of the string beyond the value,
                      ; copy only the value into $R0
  goto done           ; if we are in the parameter retrieval path skip over
                      ; the check for a command line switch
 
; See if the parameter was specified as a command line switch, like '/output'
check_for_switch:
  Push $R3            ; push the command line back on the stack for searching
  Push '/$R1'         ; search for the non-quoted search string
  Call StrStr
  Pop $R4
  StrCmp $R4 "" done  ; if we didn't find anything then use the default
  StrCpy $R0 ""       ; otherwise copy in an empty string since we found the
                      ; parameter, just didn't find a value
 
done:
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0 ; put the value in $R0 at the top of the stack
FunctionEnd




!endif