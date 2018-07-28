HA$PBExportHeader$n_cst_shell32.sru
forward
global type n_cst_shell32 from nonvisualobject
end type
type browseinfoa from structure within n_cst_shell32
end type
type shfileopstruct from structure within n_cst_shell32
end type
type notifyicondataa from structure within n_cst_shell32
end type
type nvos_shellexecuteinfo from structure within n_cst_shell32
end type
end forward

type BROWSEINFOA from structure
	ulong		hwndOwner
	ulong		pidlRoot
	string		pszDisplayName
	string		lpszTitle
	uint		ulFlags
	ulong		lpfn
	ulong		lParam
	int		iImage
end type

type shfileopstruct from structure
	long		hwnd
	unsignedlong		wfunc
	long		pfrom
	string		pto
	unsignedlong		fflags
	boolean		fanyoperationsaborted
	long		hnamemappings
	string		lpszprogresstitle
end type

type NOTIFYICONDATAA from structure
	ulong		cbSize
	ulong		hWnd
	uint		uID
	uint		uFlags
	uint		uCallbackMessage
	ulong		hIcon
	character		szTip[128]
	ulong		dwState
	ulong		dwStateMask
	character		szInfo[256]
	uint		uTimeout
	character		szInfoTitle[64]
	ulong		dwInfoFlags
end type

type nvos_shellexecuteinfo from structure
	long		cbsize
	long		fmask
	long		hwnd
	string		lpverb
	string		lpfile
	string		lpparameters
	string		lpdirectory
	long		nshow
	long		hinstapp
	long		lpidlist
	string		lpclass
	long		hkeyclass
	long		dwhotkey
	long		hicon
	ulong		hprocess
end type

global type n_cst_shell32 from nonvisualobject autoinstantiate
end type

type prototypes
Subroutine SHAddToRecentDocs ( uint uFlags, ref string pV ) Library "SHELL32.DLL" alias for "SHAddToRecentDocs;Ansi" 
Function ulong SHBrowseForFolder (ref BrowseInfoA lpBi ) Library "SHELL32.DLL" Alias for "SHBrowseForFolderA;Ansi"
Function boolean SHGetPathFromIDList (ulong pIDL, ref string pszPath) Library "SHELL32.DLL" Alias For "SHGetPathFromIDListA;Ansi"
Function ulong ShellExecute (ulong hWnd, ref string lpOperation, ref string lpFile, ref string lpParameters, ref string lpDirectory, integer nShowCmd) Library "SHELL32.DLL" Alias for "ShellExecuteA;Ansi"
Function long SHFileOperation( Ref SHFILEOPSTRUCT lpFileOp ) Library "SHELL32.DLL" Alias For "SHFileOperationA;Ansi"
Function long SHGetSpecialFolderLocation( long hwndOwner, long nFolder, Ref ulong ppidl ) Library "SHELL32.DLL"
Function long SHFormatDrive( ulong hWnd, ulong iDrive, ulong iCapacity, ulong iType ) Library "SHELL32.DLL"
Function ulong FindExecutable (ref string lpFile, ref string lpDirectory, ref string lpResult) Library "SHELL32.DLL" Alias for "FindExecutableA;Ansi"
Function ulong ExtractAssociatedIcon (ulong hInst, ref string lpIconPath, ref uint lpiIcon) Library "SHELL32.DLL" Alias for "ExtractAssociatedIconA;Ansi"
subroutine DragAcceptFiles (ulong hWnd, boolean fAccept) Library "SHELL32.DLL"
subroutine DragFinish (ulong hDrop) Library "SHELL32.DLL"
Function uint DragQueryFile (ulong hDrop, uint iFile, ref string szFileName, uint cb) Library "SHELL32.DLL" alias for "DragQueryFile;Ansi"
Function boolean Shell_NotifyIcon (ulong dwMessage, ref NOTIFYICONDATAA lpData) Library "SHELL32.DLL" Alias for "Shell_NotifyIconA;Ansi"
FUNCTION long ShellExecuteEx(REF nvos_shellexecuteinfo lpExecInfo) LIBRARY "shell32.dll" ALIAS FOR "ShellExecuteExA;Ansi"

subroutine CoTaskMemFree (ulong pv) Library "OLE32.DLL"

FUNCTION boolean IsUserAnAdmin() LIBRARY "shell32.dll"

end prototypes

type variables
// SHBrowseForFolder constants
Public:
constant ulong BIF_RETURNONLYFSDIRS	= 1	// Browse for directory
constant ulong BIF_DONTGOBELOWDOMAIN	= 2	// For starting the Find Computer
constant ulong BIF_STATUSTEXT		= 4
constant ulong BIF_RETURNFSANCESTORS	= 8
constant ulong BIF_EDITBOX			= 16
constant ulong BIF_BROWSEFORCOMPUTER	= 4096	// Browse for computer
constant ulong BIF_BROWSEFORPRINTER	= 8192	// Browse for printers
constant ulong BIF_BROWSEINCLUDEFILES	= 16384	// Browse for everything

//
// SHAddToRecentDocs
//
constant ulong SHARD_PIDL      = 1
constant ulong SHARD_PATHA     = 2
constant ulong SHARD_PATHW     = 3
constant ulong SHARD_PATH  = SHARD_PATHA

// File Operation constants
constant ulong FO_MOVE		= 1
constant ulong FO_COPY		= 2
constant ulong FO_DELETE		= 3
constant ulong FO_RENAME		= 4

// File Operation flags
constant ulong FOF_MULTIDESTFILES		= 1	// 0x0001
constant ulong FOF_CONFIRMMOUSE		= 2	// 0x0002
constant ulong FOF_SILENT			= 4	// 0x0004
constant ulong FOF_RENAMEONCOLLISION	= 8	// 0x0008
constant ulong FOF_NOCONFIRMATION	= 16	// 0x0010
constant ulong FOF_WANTMAPPINGHANDLE	= 32	// 0x0020
constant ulong FOF_ALLOWUNDO		= 64	// 0x0040
constant ulong FOF_FILESONLY		= 128	// 0x0080
constant ulong FOF_SIMPLEPROGRESS	= 256	// 0x0100
constant ulong FOF_NOCONFIRMMKDIR	= 512	// 0x0200
constant ulong FOF_NOERRORUI		= 1024	// 0x0400

// SHGetSpecialFolderLocation constants
constant ulong CSIDL_DESKTOP		= 0	// 0x0000
constant ulong CSIDL_PROGRAMS		= 2	// 0x0002
constant ulong CSIDL_CONTROLS		= 3	// 0x0003
constant ulong CSIDL_PRINTERS		= 4	// 0x0004
constant ulong CSIDL_PERSONAL		= 5	// 0x0005
constant ulong CSIDL_FAVORITES		= 6	// 0x0006
constant ulong CSIDL_STARTUP		= 7	// 0x0007
constant ulong CSIDL_RECENT		= 8	// 0x0008
constant ulong CSIDL_SENDTO		= 9	// 0x0009
constant ulong CSIDL_BITBUCKET		= 10	// 0x000a
constant ulong CSIDL_STARTMENU		= 11	// 0x000b
constant ulong CSIDL_DESKTOPDIRECTORY	= 16	// 0x0010
constant ulong CSIDL_DRIVES		= 17	// 0x0011
constant ulong CSIDL_NETWORK		= 18	// 0x0012
constant ulong CSIDL_NETHOOD		= 19	// 0x0013
constant ulong CSIDL_FONTS		= 20	// 0x0014
constant ulong CSIDL_TEMPLATES		= 21	// 0x0015
constant ulong CSIDL_COMMON_STARTMENU	= 22	// 0x0016
constant ulong CSIDL_COMMON_PROGRAMS	= 23	// 0X0017
constant ulong CSIDL_COMMON_STARTUP	= 24	// 0x0018
constant ulong CSIDL_COMMON_DESKTOPDIRECTORY = 25 // 0x0019
constant ulong CSIDL_APPDATA		= 26	// 0x001a
constant ulong CSIDL_PRINTHOOD		= 27	// 0x001b
constant ulong CSIDL_COMMONFILES		= 43	// 0x002b

/* ShellExecute() and ShellExecuteEx() error codes */

/* regular WinExec() codes */
constant int SE_ERR_FNF              = 2       // file not found
constant int SE_ERR_PNF              = 3       // path not found
constant int SE_ERR_ACCESSDENIED     = 5       // access denied
constant int SE_ERR_OOM              = 8       // out of memory
constant int SE_ERR_DLLNOTFOUND      = 32

/* error values for ShellExecute() beyond the regular WinExec() codes */
constant int SE_ERR_SHARE            = 26
constant int SE_ERR_ASSOCINCOMPLETE  = 27
constant int SE_ERR_DDETIMEOUT       = 28
constant int SE_ERR_DDEFAIL          = 29
constant int SE_ERR_DDEBUSY          = 30
constant int SE_ERR_NOASSOC          = 31

// ShellExecute nShowCmd Values
constant int SW_ERASE = 20
constant int SW_HIDE = 0
constant int SW_INVALIDATE = 18
constant int SW_MAX = 10
constant int SW_MAXIMIZE = 3
constant int SW_MINIMIZE = 6
constant int SW_NORMAL = 1
constant int SW_OTHERUNZOOM = 4
constant int SW_OTHERZOOM = 2
constant int SW_PARENTCLOSING = 1
constant int SW_PARENTOPENING = 3
constant int SW_RESTORE = 9
constant int SW_SCROLLCHILDREN = 17
constant int SW_SHOW = 5
constant int SW_SHOWDEFAULT = 10
constant int SW_SHOWMAXIMIZED = 3
constant int SW_SHOWMINIMIZED = 2
constant int SW_SHOWMINNOACTIVE = 7
constant int SW_SHOWNA = 8
constant int SW_SHOWNOACTIVATE = 4
constant int SW_SHOWNORMAL = 1

// ShellExecuteEX fMask values
CONSTANT long SEE_MASK_CLASSNAME = 1
CONSTANT long SEE_MASK_NOCLOSEPROCESS = 64




end variables

forward prototypes
public function integer open_file (string ps_file)
public function integer open_file_ex (string ps_file, string ps_verb, boolean pb_wait_for_completion, ref unsignedlong pul_process_id)
end prototypes

public function integer open_file (string ps_file);long ll_hwnd
integer li_sts
string ls_null
string ls_command

setnull(ls_null)
ll_hwnd = handle(main_window)
ls_command = "open"

li_sts = windows_api.shell32.shellexecute( ll_hwnd, ls_command, ps_file, ls_null, ls_null, SW_SHOWNORMAL)

return li_sts

end function

public function integer open_file_ex (string ps_file, string ps_verb, boolean pb_wait_for_completion, ref unsignedlong pul_process_id);//
// ps_verb =	NULL			perform the default verb for class
//					edit			Launches an editor and opens the document for editing
//					explore		Explores the folder specified by ps_file
//					find			Initiates a search starting from the specified directory
//					open			Opens the file specified by the ps_file
//					print			Prints the document file specified by ps_file
//					properties	Displays the file or folder's properties
//
//
//
//
CONSTANT ulong WAIT_TIMEOUT                = 258 //L
CONSTANT ulong NORMAL_PRIORITY_CLASS       = 32 //0x00000020
CONSTANT ulong INFINITE            			 = 4294967295 //0xFFFFFFFF  // Infinite timeout

string ls_class
long ll_ret
nvos_shellexecuteinfo lnvos_shellexecuteinfo
Inet l_Inet
string ls_drive, ls_directory, ls_filename, ls_extension
ulong lul_rts

f_parse_filepath(ps_file, ls_drive, ls_directory, ls_filename, ls_extension)

// Search for the classname associated with extension
RegistryGet("HKEY_CLASSES_ROOT\." + ls_extension, "", ls_class)
IF isNull(ls_class) OR trim(ls_class) = "" THEN
   // The class is not found, try with .txt (why not ?)
   RegistryGet("HKEY_CLASSES_ROOT\.txt", "", ls_class)
END IF

IF isNull(ls_class) OR Trim(ls_class) = "" THEN
   // No class : error
   RETURN -1
END IF

lnvos_shellexecuteinfo.cbsize = 60
//lnvos_shellexecuteinfo.fMask = SEE_MASK_CLASSNAME + SEE_MASK_NOCLOSEPROCESS // Use classname
lnvos_shellexecuteinfo.fMask = SEE_MASK_NOCLOSEPROCESS
lnvos_shellexecuteinfo.hwnd = 0
lnvos_shellexecuteinfo.lpVerb = ps_verb
lnvos_shellexecuteinfo.lpfile = ps_file
lnvos_shellexecuteinfo.lpClass = ls_class
lnvos_shellexecuteinfo.nShow = SW_NORMAL

ll_ret = ShellExecuteEx(lnvos_shellexecuteinfo)
IF ll_ret = 0 THEN
	log.log(this, "open_file_ex()", "Error opening file (" + ps_verb + ", " + ps_file + ")", 4)
   RETURN -1
END IF

if pb_wait_for_completion then
	windows_api.kernel32.WaitForInputIdle(lnvos_shellexecuteinfo.hProcess,INFINITE)
//	CloseHandle(lpProcessInformation.hThread)
	DO
		lul_rts = windows_api.kernel32.WaitForSingleObject(lnvos_shellexecuteinfo.hProcess,INFINITE)
		if lul_rts <> WAIT_TIMEOUT Then
			exit
		end if
	Loop While True
	windows_api.kernel32.CloseHandle(lnvos_shellexecuteinfo.hProcess)
	// Set the process_id to 0 because we waited for it to complete
	pul_process_id = 0
else
	TRY
		pul_process_id = windows_api.kernel32.GetProcessId(lnvos_shellexecuteinfo.hProcess)
	CATCH (throwable lo_error)
		pul_process_id = 0
	END TRY
end if

RETURN 1

end function

on n_cst_shell32.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_shell32.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

