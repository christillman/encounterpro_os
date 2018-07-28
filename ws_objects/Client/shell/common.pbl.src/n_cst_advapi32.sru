$PBExportHeader$n_cst_advapi32.sru
forward
global type n_cst_advapi32 from nonvisualobject
end type
end forward

type SERVICE_STATUS_PROCESS from structure
	ulong		dwServiceType
	ulong		dwCurrentState
	ulong		dwControlsAccepted
	ulong		dwWin32ExitCode
	ulong		dwServiceSpecificExitCode
	ulong		dwCheckPoint
	ulong		dwWaitHint
	ulong		dwProcessId
	ulong		dwServiceFlags
end type

global type n_cst_advapi32 from nonvisualobject autoinstantiate
end type

type prototypes
Function boolean GetUserName (ref string  lpBuffer, ref ulong nSize) Library "ADVAPI32.DLL" Alias for "GetUserNameA;Ansi"
Function boolean LogonUser ( ref string lpszUsername, ref string lpszDomain, ref string lpszPassword, ulong dwLogonType,  ulong dwLogonProvider, ref ulong phToken) Library "ADVAPI32.DLL" Alias for "LogonUserA;Ansi"
Function long RegOpenKeyEx (ulong hKey, string lpSubKey, ulong ulOptions, ulong samDesired,  ref ulong phkResult) Library "ADVAPI32.DLL" Alias for "RegOpenKeyExA;Ansi"
Function long RegSetValueEx (ulong hKey, string lpValueName, ulong Reserved, ulong dwType, string  lpData, ulong cbData) Library "ADVAPI32.DLL" Alias for "RegSetValueExA;Ansi"
Function boolean QueryServiceStatusEx (ulong hService, ulong InfoLevel, ref SERVICE_STATUS_PROCESS lpBuffer, ulong cbBufSize, ref ulong pcbBytesNeeded) Library "ADVAPI32.DLL" alias for "QueryServiceStatusEx;Ansi"
end prototypes

type variables
//
// Info levels for QueryServiceStatusEx
//

constant	int SC_STATUS_PROCESS_INFO      = 0


end variables

on n_cst_advapi32.create
TriggerEvent( this, "constructor" )
end on

on n_cst_advapi32.destroy
TriggerEvent( this, "destructor" )
end on

