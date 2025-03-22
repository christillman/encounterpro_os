$PBExportHeader$u_event_log.sru
forward
global type u_event_log from nonvisualobject
end type
type os_filedatetime from structure within u_event_log
end type
type os_fileopeninfo from structure within u_event_log
end type
type os_finddata from structure within u_event_log
end type
type os_securityattributes from structure within u_event_log
end type
type os_systemtime from structure within u_event_log
end type
end forward

type os_filedatetime from structure
	unsignedlong		ul_lowdatetime
	unsignedlong		ul_highdatetime
end type

type os_fileopeninfo from structure
	character		c_length
	character		c_fixed_disk
	unsignedinteger		ui_dos_error
	unsignedinteger		ui_na1
	unsignedinteger		ui_na2
	character		c_pathname[128]
end type

type os_finddata from structure
	unsignedlong		ul_fileattributes
	os_filedatetime		str_creationtime
	os_filedatetime		str_lastaccesstime
	os_filedatetime		str_lastwritetime
	unsignedlong		ul_filesizehigh
	unsignedlong		ul_filesizelow
	unsignedlong		ul_reserved0
	unsignedlong		ul_reserved1
	character		ch_filename[260]
	character		ch_alternatefilename[14]
end type

type os_securityattributes from structure
	unsignedlong		ul_length
	character		ch_description
	boolean		b_inherit
end type

type os_systemtime from structure
	unsignedinteger		ui_wyear
	unsignedinteger		ui_wmonth
	unsignedinteger		ui_wdayofweek
	unsignedinteger		ui_wday
	unsignedinteger		ui_whour
	unsignedinteger		ui_wminute
	unsignedinteger		ui_wsecond
	unsignedinteger		ui_wmilliseconds
end type

global type u_event_log from nonvisualobject
end type
global u_event_log u_event_log

type prototypes
// Event Log Functions
function long RegisterEventSource( string pszServerName, string pszSourceName ) &
LIBRARY "ADVAPI32.DLL" &
alias for "RegisterEventSourceA;Ansi"

function boolean DeregisterEventSource( long hEventLog ) & 
LIBRARY "ADVAPI32.DLL" &
alias for "DeregisterEventSource"

function boolean ReportEvent( long hEventLog, integer wType, integer wCategory, &
long dwEventID, long pUserSID, integer wNumStrings, &
long dwDataSize, string pStringArray[], long pRawData ) &
LIBRARY "ADVAPI32.DLL" &
alias for "ReportEventA;Ansi"

// OS Version
FUNCTION long GetVersion() LIBRARY "kernel32.dll"   

// Win 32 calls
Function uint GetDriveTypeA (string drive) library "KERNEL32.DLL" alias for "GetDriveTypeA;Ansi"
Function boolean CreateDirectoryA (ref string directoryname, ref os_securityattributes secattr) library "KERNEL32.DLL" alias for "CreateDirectoryA;Ansi"
Function boolean RemoveDirectoryA (ref string directoryname) library "KERNEL32.DLL" alias for "RemoveDirectoryA;Ansi"
Function ulong GetCurrentDirectoryA (ulong textlen, ref string dirtext) library "KERNEL32.DLL" alias for "GetCurrentDirectoryA;Ansi"
Function boolean SetCurrentDirectoryA (ref string directoryname ) library "KERNEL32.DLL" alias for "SetCurrentDirectoryA;Ansi"
Function ulong GetFileAttributesA (ref string filename) library "KERNEL32.DLL" alias for "GetFileAttributesA;Ansi"
Function boolean SetFileAttributesA (ref string filename, ulong attrib) library "KERNEL32.DLL" alias for "SetFileAttributesA;Ansi"
Function boolean MoveFileA (ref string oldfile, ref string newfile) library "KERNEL32.DLL" alias for "MoveFileA;Ansi"
Function long FindFirstFileA (ref string filename, ref os_finddata findfiledata) library "KERNEL32.DLL" alias for "FindFirstFileA;Ansi"
Function boolean FindNextFileA (long handle, ref os_finddata findfiledata) library "KERNEL32.DLL" alias for "FindNextFileA;Ansi"
Function boolean FindClose (long handle) library "KERNEL32.DLL"
Function boolean GetDiskFreeSpaceA (string drive, ref long sectpercluster, ref long bytespersect, ref long freeclusters, ref long totalclusters) library "KERNEL32.DLL" alias for "GetDiskFreeSpaceA;Ansi"
Function long GetLastError() library "KERNEL32.DLL"
Function long GetFileSize(ulong file_hand,ref ulong filesizehigh) library "KERNEL32.DLL"
Function boolean DeleteFileA(ref string filename)  library "KERNEL32.DLL" alias for "DeleteFileA;Ansi"

// Win32 calls for file date and time
Function ulong OpenFile (ref string filename, ref os_fileopeninfo of_struct, uint action) LIBRARY "KERNEL32.DLL" alias for "OpenFile;Ansi"
Function boolean CloseHandle (ulong file_hand) LIBRARY "KERNEL32.DLL"
Function boolean GetFileTime(long hFile, ref os_filedatetime  lpCreationTime, ref os_filedatetime  lpLastAccessTime, ref os_filedatetime  lpLastWriteTime  )  library "KERNEL32.DLL" alias for "GetFileTime;Ansi"
Function boolean FileTimeToSystemTime(ref os_filedatetime lpFileTime, ref os_systemtime lpSystemTime) library "KERNEL32.DLL" alias for "FileTimeToSystemTime;Ansi"
Function boolean FileTimeToLocalFileTime(ref os_filedatetime lpFileTime, ref os_filedatetime lpLocalFileTime) library "KERNEL32.DLL" alias for "FileTimeToLocalFileTime;Ansi"
Function boolean SetFileTime(ulong hFile, os_filedatetime  lpCreationTime, os_filedatetime  lpLastAccessTime, os_filedatetime  lpLastWriteTime  )  library "KERNEL32.DLL" alias for "SetFileTime;Ansi"
Function boolean SystemTimeToFileTime(os_systemtime lpSystemTime, ref os_filedatetime lpFileTime) library "KERNEL32.DLL" alias for "SystemTimeToFileTime;Ansi"
Function boolean LocalFileTimeToFileTime(ref os_filedatetime lpLocalFileTime, ref os_filedatetime lpFileTime) library "KERNEL32.DLL" alias for "LocalFileTimeToFileTime;Ansi"

// User/computer information
function boolean GetUserNameA(ref string  lpBuffer, ref int nSize) library "ADVAPI32.DLL" alias for "GetUserNameA;Ansi"
function boolean GetComputerNameA(ref string  lpBuffer, ref int nSize) library "KERNEL32.DLL" alias for "GetComputerNameA;Ansi"
Function ulong CopyFileA (ref string ExistingFileName, ref string NewFileName, ref long notExists)  Library  "KERNEL32.DLL" alias for "CopyFileA;Ansi"

// HANDLE GetProcessHeap(VOID); 
// obtains a handle to the heap of the calling process 
Function ulong GetProcessHeap() Library "KERNEL32.DLL" 

// LPVOID HeapAlloc(HANDLE hHeap, DWORD dwFlags, DWORD dwBytes); 
// allocates a block of memory from a heap 
Function ulong HeapAlloc (ulong hMem, uint uFlags, ulong uBytes) Library "KERNEL32.DLL" 

// BOOL HeapFree(HANDLE hHeap, DWORD dwFlags, LPVOID lpMem); 
// frees a memory block allocated from a heap 
Function long HeapFree (ulong hMem, uint uFlags, ulong uMemPoint) Library "KERNEL32.DLL" 

// LPTSTR lstrcpy(LPTSTR lpString1, LPCTSTR lpString2); 
// copies a string to a buffer 
Function ulong lstrcpy (REF string lpString1, ulong lpString2) Library "KERNEL32.DLL" 

// VOID MoveMemory (PVOID Destination, CONST VOID *Source, SIZE_T Length); 
// moves a block of memory from one location to another 
Subroutine MoveMemory (REF string sbytes, ulong lpbytes, ulong uLen) library "KERNEL32.DLL" alias for "RtlMoveMemory" 

// DWORD GetFileVersionInfoSize( LPTSTR lptstrFilename, LPDWORD lpdwHandle); 
// returns the size, in bytes, of version information about a specified file 
Function long GetFileVersionInfoSize (string sFile, REF ulong uDummy) library "VERSION.DLL" alias for "GetFileVersionInfoSizeA" 

// BOOL GetFileVersionInfo(LPTSTR lptstrFilename,DWORD dwHandle, DWORD dwLen, LPVOID lpData); 
// returns version information about a specified file 
Function long GetFileVersionInfo (REF string sFile, ulong uDummy, ulong uLen, ulong uPoint) library "VERSION.DLL" alias for "GetFileVersionInfoA" 

// BOOL VerQueryValue( const LPVOID pBlock, LPTSTR lpSubBlock, LPVOID *lplpBuffer, PUINT puLen); 
// returns selected version information from the specified version-information resource 
Function long VerQueryValue (ulong uPoint, string sValue, REF ulong uPoint, REF ulong uLen) library "VERSION.DLL" alias for "VerQueryValueA" 


end prototypes

type variables
boolean initialized = false
boolean display_enabled = false

u_sqlca cprdb

string event_source
//unsignedlong event_handle

integer loglevel
string logpath
string logfilename
string logfileext = "LOG"
integer displayloglevel
integer dbloglevel

string severities[] = {"DEBUG", &
                             "INFORMATION", &
                             "WARNING", &
                             "ERROR", &
                             "FATAL ERROR", &
                             "UNKNOWN" }

Protected:
string	is_Separator
string	is_AllFiles

private str_playback_log_entry playback_log[]

constant integer EVENTLOG_SUCCESS = 0 // 0X0000
constant integer EVENTLOG_ERROR_TYPE = 1 // 0x0001
constant integer EVENTLOG_WARNING_TYPE = 2 // 0x0002
constant integer EVENTLOG_INFORMATION_TYPE = 4 // 0x0004
constant integer EVENTLOG_AUDIT_SUCCESS = 8 // 0x0008
constant integer EVENTLOG_AUDIT_FAILURE = 16 // 0x0010 

constant integer LOGLEVEL_ANNOYANCE = 1
constant integer LOGLEVEL_INFORMATION = 2
constant integer LOGLEVEL_WARNING = 3
constant integer LOGLEVEL_ERROR = 4
constant integer LOGLEVEL_REDALERT = 5


end variables
forward prototypes
public function integer shutdown ()
public function integer log (powerobject po_who, string ps_script, string ps_message, integer pi_severity)
public function boolean of_directoryexists (string as_directoryname)
public function integer of_createdirectory (string as_directoryname)
public function integer file_copy (string ps_filefrom, string ps_fileto)
public subroutine set_cprdb (u_sqlca puo_cprdb)
public function integer initialize (string ps_event_source)
public function integer file_read (string ps_file, ref blob pblb_file)
public function integer file_write (ref blob pblb_file, string ps_file)
public function integer file_rename (string ps_oldfilename, string ps_newfilename)
public function string get_computername ()
public function string get_userid ()
public function integer of_convertfiledatetimetopb (os_filedatetime astr_filetime, ref date ad_filedate, ref time at_filetime)
public function integer file_attributes (string ps_filespec, ref str_file_attributes pstra_file)
public function long directory_list (string ps_filespec, ref str_file_attributes pstra_files[])
public function string get_first_file (string ps_path)
public function integer get_drive_type (string ps_drive_letter)
public function integer profile_keys (string ps_file, string ps_section, ref string psa_keys[])
public function integer log_db (powerobject po_who, string ps_script, string ps_message, integer pi_severity)
public function integer get_all_files (string ps_path, ref string psa_files[])
public function integer delete_files (string ps_filespec)
public function integer copy_files (string ps_from_path, string ps_to_path, boolean pb_overwrite)
public function long file_read2 (string ps_file, ref blob pblb_file, boolean pb_lock_file)
public function integer delete_old_files (string ps_filespec)
public function string get_file_version (string ps_filepath)
public function integer log (powerobject po_who, string ps_script, string ps_message, integer pi_severity, string ps_component_id, string ps_version_name)
public function integer log_db_with_seconds (powerobject po_who, string ps_script, string ps_message, integer pi_severity, decimal pd_seconds)
public function integer log_db (powerobject po_who, string ps_script, string ps_message, integer pi_severity, string ps_component_id, string ps_version_name, decimal pd_seconds)
public subroutine clear_playback ()
public subroutine play_back ()
end prototypes

public function integer shutdown ();//DeregisterEventSource(event_handle)
if IsValid(common_thread) then
	if NOT IsNull(common_thread.eprolibnet4) AND IsValid(common_thread.eprolibnet4) then
		common_thread.eprolibnet4.of_CloseEventLog(event_source)
	end if
end if
initialized = false

return 1

end function

public function integer log (powerobject po_who, string ps_script, string ps_message, integer pi_severity);string ls_component_id
string ls_version_name
string ls_who
decimal ld_seconds
u_component_base_class luo_component

setnull(ls_component_id)
setnull(ls_version_name)

if isvalid(po_who) then
	ls_who = po_who.classname()
	if lower(left(ls_who, 12)) = "u_component_" and lower(ls_who) <> "u_component_manager" then
		luo_component = po_who
		ls_component_id = luo_component.component_id
		ls_version_name = luo_component.component_version.compile_name
	end if
end if

return log(po_who, ps_script, ps_message, pi_severity, ls_component_id, ls_version_name)

end function

public function boolean of_directoryexists (string as_directoryname);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_DirectoryExists
//
//	Access:  public
//
//	Arguments:
//	as_DirectoryName		The name of the directory to be checked; an
//									absolute path may be specified or it will
//									be relative to the current working directory
//
//	Returns:		Boolean
//					True if the directory exists, False if it does not.
//
//	Description:	Check if the specified directory exists.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996 Powersoft Corporation.  All Rights Reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Powersoft is prohibited.
//
//////////////////////////////////////////////////////////////////////////////
ULong	lul_RC

lul_RC = GetFileAttributesA(as_DirectoryName)

// Check if 5th bit is set, if so this is a directory
If Mod(Integer(lul_RC / 16), 2) > 0 Then 
	Return True
Else
	Return False
End If

end function

public function integer of_createdirectory (string as_directoryname);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_CreateDirectory
//
//	Access:  public
//
//	Arguments:
//	as_DirectoryName		The name of the directory to be created; an
//									absolute path may be specified or it will
//									be relative to the current working directory
//
//	Returns:		Integer
//					1 if successful,
//					-1 if an error occurrs.
//
//	Description:	Create a new directory.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996 Powersoft Corporation.  All Rights Reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Powersoft is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

//os_securityattributes	lstr_Security
//
//lstr_Security.ul_Length = 7
//lstr_Security.ch_description = "~000"	//use default security
//lstr_Security.b_Inherit = False
//If CreateDirectoryA(as_DirectoryName, lstr_Security) Then
//	Return 1
//Else
//	Return -1
//End If
integer li_sts

li_sts = CreateDirectory(as_directoryname)

return li_sts

end function

public function integer file_copy (string ps_filefrom, string ps_fileto);//
//	Function:  file_copy
//
//	Access:  public
//
//	Arguments:
//	ps_filefrom				The name of the file to be copied from
//	ps_fileto				The name of the file to be copied into
//
//	Returns:		1 if success, -1 if an error occurrs.
//
//	Description:	Opens the from file, opens the to file, then successively
//						reads the from file and copies into the to file
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	10/8/98	MSC   Initial version
//
//////////////////////////////////////////////////////////////////////////////

//long ll_var, ll_rtn
//ll_rtn =  CopyFileA(ps_filefrom, ps_fileto, ll_var)
//If ll_rtn < 1 then Return -1
//

string ls_drive, ls_directory, ls_file, ls_extension
integer li_sts
string ls_dir

li_sts = f_parse_filepath(ps_fileto, ls_drive, ls_directory, ls_file, ls_extension)
if li_sts <= 0 then
	log.log(this, "u_event_log.file_copy:0035", "Invalid target (" + ps_fileto + ")", 4)
end if

ls_dir = ls_drive + ls_directory
if not of_directoryexists(ls_dir) then
	of_createdirectory(ls_dir)
end if

li_sts = filecopy(ps_filefrom, ps_fileto, false)
if li_sts <= 0 then
	if li_sts = -1 then
		log.log(this, "u_event_log.file_copy:0046", "Error opening source (" + ps_filefrom + ")", 4)
	elseif li_sts = -2 then
		log.log(this, "u_event_log.file_copy:0048", "Error writing target (" + ps_fileto + ")", 4)
	end if
	
	return -1
end if

Return 1

end function

public subroutine set_cprdb (u_sqlca puo_cprdb);
if isvalid(puo_cprdb) and not isnull(puo_cprdb) then
	if puo_cprdb.connected then
		cprdb = puo_cprdb
	else
		setnull(cprdb)
	end if
else
	setnull(cprdb)
end if


end subroutine

public function integer initialize (string ps_event_source);integer li_sts
unsignedlong ll_version
unsignedinteger li_low, li_high, li_highbit
string ls_temp
string ls_msg
string ls_displaylogenabled

loglevel = profileint(gnv_app.ini_file, "<LogSystem>", "LogLevel", 2)
if loglevel <= 0 then loglevel = 2
if loglevel > 5 then loglevel = 2

dbloglevel = profileint(gnv_app.ini_file, "<LogSystem>", "DBLogLevel", 3)
if dbloglevel <= 0 then dbloglevel = 3
if dbloglevel > 5 then dbloglevel = 3

displayloglevel = profileint(gnv_app.ini_file, "<LogSystem>", "DisplayLogLevel", 4)
if displayloglevel <= 0 then displayloglevel = 4
if displayloglevel > 5 then displayloglevel = 4

ls_displaylogenabled = profilestring(gnv_app.ini_file, "<LogSystem>", "DisplayEnabled", "No")
if ls_displaylogenabled = "Yes" or ls_displaylogenabled = "True" then
	display_enabled = True
end if

initialized = true
return 1
		
// EventLog not working, commenting out 30/09/2023
// trying with nvo_utilities
event_source = ps_event_source

if common_thread.utilities_ok() then
	if initialized then
	//	DeregisterEventSource(event_handle)
		common_thread.eprolibnet4.of_CloseEventLog(event_source)
		initialized = false
	end if
	
	//ls_server = ""	
	//event_handle = RegisterEventSource(ls_server, event_source)
	
	li_sts = common_thread.eprolibnet4.of_InitializeEventLog(event_source)
	
	if li_sts > 0 then
		initialized = true
		return 1
	end if
else
	log.log(this, "u_event_log.initialize:0039", "Event log not initialized (Utilities not available)", 3)
end if

return -1


end function

public function integer file_read (string ps_file, ref blob pblb_file);
long ll_bytes
integer li_filenum
blob lblob_empty

if isnull(ps_file) then
	log.log(this, "u_event_log.file_read:0003", "Null file path", 4)
	return -1
end if

TRY
	li_filenum = FileOpen(ps_file, StreamMode!, Read!, Shared!)

		
	ll_bytes = FileReadEx(li_filenum, lblob_empty)
	pblb_file = lblob_empty
	
	FileClose(li_filenum)
CATCH (throwable lt_error)
	log.log(this, "u_event_log.file_read:0010", "Error reading file (" + ps_file + "): " + lt_error.text, 4)
	return -1
END TRY

if len(pblb_file) > 0 then
	return 1
else
	return -1
end if


end function

public function integer file_write (ref blob pblb_file, string ps_file);long ll_rc
integer li_filenum

if isnull(ps_file) then
	log.log(this, "u_event_log.file_write:0004", "Null file path", 4)
	return -1
end if

if isnull(pblb_file) then
	log.log(this, "u_event_log.file_write:0009", "Null file blob", 4)
	return -1
end if

TRY
	li_filenum = FileOpen(ps_file, StreamMode!, Write!, LockWrite!, Replace!)

	ll_rc = FileWriteEx(li_filenum, pblb_file)
	
	FileClose(li_filenum)
CATCH (throwable lt_error)
	log.log(this, "u_event_log.file_write:0016", "Error writing file (" + ps_file + ") : " + lt_error.text, 4)
	return -1
END TRY

Return 1

end function

public function integer file_rename (string ps_oldfilename, string ps_newfilename);Integer	li_sts

If MoveFileA(ps_oldfilename, ps_newfilename) Then
	li_sts = 1
Else
	li_sts = -1
End If

Return li_sts

end function

public function string get_computername ();string 	ls_computer_name
int 		li_size = 16 // MAX_COMPUTERNAME_LENGTH + 1

boolean	lb_rc

ls_computer_name = space(li_size)

lb_rc = GetComputerNameA( ls_computer_name, li_size)

if not lb_rc or trim(ls_computer_name) = "" then setnull(ls_computer_name)

return ls_computer_name

end function

public function string get_userid ();string 	ls_name
int 		li_size = 255
boolean	lb_rc

ls_name = space(li_size)

lb_rc = GetUserNameA( ls_name, li_size)

if not lb_rc or trim(ls_name) = "" then setnull(ls_name)

return ls_name


end function

public function integer of_convertfiledatetimetopb (os_filedatetime astr_filetime, ref date ad_filedate, ref time at_filetime);//////////////////////////////////////////////////////////////////////////////
//	Protected Function:  of_ConvertFileDatetimeToPB
//	Arguments:		astr_FileTime		The os_filedatetime structure containing the system date/time for the file.
//						ad_FileDate			The file date in PowerBuilder Date format	passed by reference.
//						at_FileTime			The file time in PowerBuilder Time format	passed by reference.
//	Returns:			Integer
//						1 if successful, -1 if an error occurrs.
//	Description:	Convert a sytem file type to PowerBuilder Date and Time.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   Initial version
//						5.0.03	Fixed - function would fail under some international date formats
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
string				ls_Time
os_filedatetime	lstr_LocalTime
os_systemtime		lstr_SystemTime

If Not FileTimeToLocalFileTime(astr_FileTime, lstr_LocalTime) Then Return -1

If Not FileTimeToSystemTime(lstr_LocalTime, lstr_SystemTime) Then Return -1

// works with all date formats
ad_FileDate = Date(lstr_SystemTime.ui_wyear, lstr_SystemTime.ui_WMonth, lstr_SystemTime.ui_WDay)

ls_Time = String(lstr_SystemTime.ui_wHour) + ":" + &
			 String(lstr_SystemTime.ui_wMinute) + ":" + &
			 String(lstr_SystemTime.ui_wSecond) + ":" + &
			 String(lstr_SystemTime.ui_wMilliseconds)
at_FileTime = Time(ls_Time)

Return 1

end function

public function integer file_attributes (string ps_filespec, ref str_file_attributes pstra_file);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_DirList
//	Arguments:		as_FileSpec				The file spec. to list (including wildcards); an
//													absolute path may be specified or it will
//													be relative to the current working directory
//						al_FileType				A number representing one or more types of files
//													to include in the list, see PowerBuilder Help on
//													the DirList listbox function for an explanation.
//						anv_DirList[]			An array of n_cst_dirattrib structure whichl will contain
//													the results, passed by reference.
//	Returns:			Long
//						The number of elements in anv_DirList if successful, -1 if an error occurrs.
//	Description:	List the contents of a directory (Name, Date, Time, and Size).
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   		Initial version
//						5.0.03		Changed long variables to Ulong for NT4.0 compatibility
//						7.0			Changed return datatype from int to long
//									Changed li_Cnt, li_Entries from int to long
//						7.0.02 	Changed datatype of lul_handle to long ll_handle
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
boolean					lb_Found
char						lc_Drive
long						ll_Cnt
long						ll_handle
time						lt_Time
os_finddata				lstr_FindData

// List the entries in the directory
ll_handle = FindFirstFileA(ps_fileSpec, lstr_FindData)
If ll_handle <= 0 Then Return -1

// Add it to the array
pstra_file.FileName = lstr_FindData.ch_filename
pstra_file.AltFileName = lstr_FindData.ch_alternatefilename
If Trim(pstra_file.AltFileName) = "" Then
	pstra_file.AltFileName = pstra_file.FileName
End If

// Set date and time
of_ConvertFileDatetimeToPB(lstr_FindData.str_CreationTime, pstra_file.CreationDate, &
											pstra_file.CreationTime)
of_ConvertFileDatetimeToPB(lstr_FindData.str_LastAccessTime, pstra_file.LastAccessDate, lt_Time)
of_ConvertFileDatetimeToPB(lstr_FindData.str_LastWriteTime, pstra_file.LastWriteDate, &
											pstra_file.LastWriteTime)

// Calculate file size
pstra_file.FileSize = (lstr_FindData.ul_FileSizeHigh * (2.0 ^ 32))  + lstr_FindData.ul_FileSizeLow

// Set file attributes
pstra_file.readonly_file = f_check_bit(lstr_FindData.ul_FileAttributes, 1)
pstra_file.hidden_file = f_check_bit(lstr_FindData.ul_FileAttributes, 2)
pstra_file.system_file = f_check_bit(lstr_FindData.ul_FileAttributes, 3)
pstra_file.SubDirectory = f_check_bit(lstr_FindData.ul_FileAttributes, 5)
pstra_file.Archive = f_check_bit(lstr_FindData.ul_FileAttributes, 6)
pstra_file.Drive = False

// Put brackets around subdirectories
If pstra_file.SubDirectory Then
	pstra_file.FileName = "[" + pstra_file.FileName + "]"
	pstra_file.AltFileName = "[" + pstra_file.AltFileName + "]"
End If
	
FindClose(ll_handle)

Return 1

end function

public function long directory_list (string ps_filespec, ref str_file_attributes pstra_files[]);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_DirList
//	Arguments:		as_FileSpec				The file spec. to list (including wildcards); an
//													absolute path may be specified or it will
//													be relative to the current working directory
//						al_FileType				A number representing one or more types of files
//													to include in the list, see PowerBuilder Help on
//													the DirList listbox function for an explanation.
//						anv_DirList[]			An array of n_cst_dirattrib structure whichl will contain
//													the results, passed by reference.
//	Returns:			Long
//						The number of elements in anv_DirList if successful, -1 if an error occurrs.
//	Description:	List the contents of a directory (Name, Date, Time, and Size).
//////////////////////////////////////////////////////////////////////////////
//	Rev. History:	Version
//						5.0   		Initial version
//						5.0.03		Changed long variables to Ulong for NT4.0 compatibility
//						7.0			Changed return datatype from int to long
//									Changed li_Cnt, li_Entries from int to long
//						7.0.02 	Changed datatype of lul_handle to long ll_handle
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
boolean					lb_Found
char						lc_Drive
long						ll_Cnt, ll_Entries
long						ll_handle
time						lt_Time
os_finddata				lstr_FindData
str_file_attributes		lstra_empty[]
//n_cst_numerical		lnv_Numeric

// Empty the result array
pstra_files = lstra_empty

// List the entries in the directory
ll_handle = FindFirstFileA(ps_fileSpec, lstr_FindData)
If ll_handle <= 0 Then Return -1
Do
	// Add it to the array
	ll_Entries ++
	pstra_files[ll_Entries].FileName = lstr_FindData.ch_filename
	pstra_files[ll_Entries].AltFileName = lstr_FindData.ch_alternatefilename
	If Trim(pstra_files[ll_Entries].AltFileName) = "" Then
		pstra_files[ll_Entries].AltFileName = pstra_files[ll_Entries].FileName
	End If

	// Set date and time
	of_ConvertFileDatetimeToPB(lstr_FindData.str_CreationTime, pstra_files[ll_Entries].CreationDate, &
												pstra_files[ll_Entries].CreationTime)
	of_ConvertFileDatetimeToPB(lstr_FindData.str_LastAccessTime, pstra_files[ll_Entries].LastAccessDate, lt_Time)
	of_ConvertFileDatetimeToPB(lstr_FindData.str_LastWriteTime, pstra_files[ll_Entries].LastWriteDate, &
												pstra_files[ll_Entries].LastWriteTime)

	// Calculate file size
	pstra_files[ll_Entries].FileSize = (lstr_FindData.ul_FileSizeHigh * (2.0 ^ 32))  + lstr_FindData.ul_FileSizeLow
	
	// Set file attributes
	pstra_files[ll_Entries].readonly_file = f_check_bit(lstr_FindData.ul_FileAttributes, 1)
	pstra_files[ll_Entries].hidden_file = f_check_bit(lstr_FindData.ul_FileAttributes, 2)
	pstra_files[ll_Entries].system_file = f_check_bit(lstr_FindData.ul_FileAttributes, 3)
	pstra_files[ll_Entries].SubDirectory = f_check_bit(lstr_FindData.ul_FileAttributes, 5)
	pstra_files[ll_Entries].Archive = f_check_bit(lstr_FindData.ul_FileAttributes, 6)
	pstra_files[ll_Entries].Drive = False
	
	// Put brackets around subdirectories
	If pstra_files[ll_Entries].SubDirectory Then
		pstra_files[ll_Entries].FileName = "[" + pstra_files[ll_Entries].FileName + "]"
		pstra_files[ll_Entries].AltFileName = "[" + pstra_files[ll_Entries].AltFileName + "]"
	End If
	
	lb_Found = FindNextFileA(ll_handle, lstr_FindData)
Loop Until Not lb_Found

FindClose(ll_handle)

Return ll_Entries
end function

public function string get_first_file (string ps_path);string ls_file
string ls_null
long ll_handle, ll_file_sz
ulong ll_filesize_high
boolean lb_success
os_finddata lstr_FindData

setnull(ls_null)

ll_Handle = FindFirstFileA(ps_path, lstr_FindData)
If ll_Handle <= 0 Then Return ls_null

ls_file = lstr_FindData.ch_filename

ll_file_sz = GetFileSize(ll_Handle,ll_filesize_high)
if ll_file_sz = 0 then
	lb_success = DeleteFileA(ls_file)
	Return ls_null
end if	

FindClose(ll_Handle)

return ls_file

end function

public function integer get_drive_type (string ps_drive_letter);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  get_drive_type
//
//	Access:  public
//
//	Arguments:
//	ps_drive_letter					The letter of the drive to be checked.
//
//	Returns:		Integer
//					The type of the drive:
//					2 - floppy drive,
//					3 - hard drive,
//					4 - network drive,
//					5 - cdrom drive,
//					6 - ramdisk,
//					any other value is the result of an error.
//
//	Description:	Determine the type of a drive.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996 Powersoft Corporation.  All Rights Reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Powersoft is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

Return GetDriveTypeA(Upper(ps_drive_letter) + ":\")

end function

public function integer profile_keys (string ps_file, string ps_section, ref string psa_keys[]);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_GetKeys
//
//	Access:  		public
//
//	Arguments:	
//	ps_file			The .ini file.
//	ps_section		The section name to retrieve keys from
//	psa_keys[]		An array of strings passed by reference.  This will store the 
//							key names retrieved from the .INI file
//
//	Returns:			Integer
//						The number of keys retrieved
//						 0	if there are no keys that exist for section, or section does not exist
//						-1	file error
//						-2	if .INI file has not been specified or does not exist.  
//
//	Description:  	Retrieves all keys from a specified section.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
// 5.0.02 Initialize keys array to blanks at start of function
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996 Powersoft Corporation.  All Rights Reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Powersoft is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

boolean	lb_sectionfound
long	ll_file
integer	li_rc
integer	li_keys
long		ll_pos
long		ll_first
long		ll_last
long		ll_equal
long		ll_length
string	ls_line
string	ls_key
string	ls_section
string	ls_comment
string	ls_keys[]
//n_cst_string lnv_string

SetPointer (Hourglass!)

// Verify that .INI file name has been specified.
if not FileExists (ps_file) then
	return -2
end if

// Open file (check rc).
ll_length = FileLength (ps_file)
ll_file = FileOpen (ps_file, LineMode!)
if ll_file = -1 then return -1

// reset the array coming in
psa_keys = ls_keys
//////////////////////////////////////////////////////////////////////////////
// Find the correct section name
//////////////////////////////////////////////////////////////////////////////
do while li_rc >= 0 and not lb_sectionfound
	
	// Read one line from the inifile (check rc).
	li_rc = FileRead (ll_file, ls_line)
	if li_rc = -1 then
		return -1
	end if
	
	// Check if any characters were read.
	if li_rc > 0 then
		
		// Look for a section header components (the OpenBracket and CloseBracket (if any)).
		ll_first = Pos (ls_line, "[")
		ll_last = Pos (ls_line, "]")
		
		// Was section header found?		
		if ll_first > 0 and ll_last > 0 then
			// Yes, a section header has been found.
			// Get the name of the section.
			ls_line = LeftTrim (ls_line)
			if Left (ls_line, 1) = "[" then
				ll_pos = Pos (ls_line, "]")
				ls_section = Mid (ls_line, 2, ll_pos - 2)
				// Determine if this is the section being searched for.								
				if Lower(ls_section) = Lower(ps_section) then
					// The search for section has been found.
					lb_sectionfound = true
				end if
			end if
		end if
	end if
loop 


//////////////////////////////////////////////////////////////////////////////
// Retrieve all keys for section
//////////////////////////////////////////////////////////////////////////////
if lb_sectionfound then
	lb_sectionfound = false
	do while li_rc >= 0 and not lb_sectionfound
		
		// Read one line from the file (validate the rc).
		li_rc = FileRead (ll_file, ls_line)
		if li_rc = -1 then
			return -1
		end if
		
		// Check if any characters were read.		
		if li_rc > 0 then
			// Check for a "commented" line (skip if found).
			ls_comment = LeftTrim (ls_line)
			if Char (ls_comment) = ";" then Continue
			
			ll_equal = Pos (ls_line, "=")
			if ll_equal > 0 then
				ls_key = Trim(Left(ls_line, ll_equal - 1))
				if Len (ls_key) > 0 then
					li_keys++
					psa_keys[li_keys] = ls_key
				end if
			else
				ll_first = Pos (ls_line, "[")
				ll_last = Pos (ls_line, "]")
				if ll_first > 0 and ll_last > 0 then
					ls_line = LeftTrim(ls_line)
					if Left (ls_line, 1) = "[" then
						lb_sectionfound = true
					end if
				end if
			end if
		end if
	loop 
end if


//////////////////////////////////////////////////////////////////////////////
// Close file and return
//////////////////////////////////////////////////////////////////////////////
FileClose (ll_file)
return li_keys

end function

public function integer log_db (powerobject po_who, string ps_script, string ps_message, integer pi_severity);string ls_component_id
string ls_version_name
decimal ld_seconds

setnull(ls_component_id)
setnull(ls_version_name)
setnull(ld_seconds)

return log_db(po_who, ps_script, ps_message, pi_severity, ls_component_id, ls_version_name, ld_seconds)

end function

public function integer get_all_files (string ps_path, ref string psa_files[]);long   ll_handle
long   li_count = 1
os_finddata lpFindFileData, lst_FindData

ll_handle = FindFirstFileA (ps_path, lpFindFileData)
If ll_Handle <= 0 Then Return 0

li_count = 1
psa_files[li_count] = lpFindFileData.ch_filename //You get the name of the first file.

//Call FindnextFile if there are multiple files as below :
lpFindFileData = lst_FindData //reset the structure
do while FindNextFileA( ll_handle,  lpFindFileData)
    li_count = li_count + 1
    psa_files[li_count] = lpFindFileData.ch_filename //You get the name of the next file.
    //here you can capture other detils.
    lpFindFileData = lst_FindData //reset the structure
loop

//now close the search 
FindClose(ll_handle)

return li_count

end function

public function integer delete_files (string ps_filespec);str_file_attributes lstra_files[]
string ls_drive
string ls_dir
string ls_filename
string ls_extension
long ll_file_count
long i
string ls_filepath

f_parse_filepath(ps_filespec, ls_drive, ls_dir, ls_filename, ls_extension)

ll_file_count = log.directory_list(ps_filespec, lstra_files)
for i = 1 to ll_file_count
	ls_filepath = ls_drive + ls_dir + "\"
	if left(lstra_files[i].filename, 1) = "[" and lstra_files[i].filename <> "[.]" and lstra_files[i].filename <> "[..]" then
		// Directory
		ls_filepath += mid(lstra_files[i].filename, 2, len(lstra_files[i].filename) - 2)
		
		if directoryexists(ls_filepath) then
			// First delete the contents
			delete_files(ls_filepath + "\*.*")
			
			// Then remove the directory itself
			removedirectory(ls_filepath)
		end if
	else
		// File
		ls_filepath += lstra_files[i].filename
		if fileexists(ls_filepath) then
			filedelete(ls_filepath)
		end if
	end if
next

return ll_file_count

end function

public function integer copy_files (string ps_from_path, string ps_to_path, boolean pb_overwrite);str_file_attributes lstra_files[]
string ls_drive
string ls_dir
string ls_filename
string ls_extension
long ll_file_count
long ll_copy_count
long i
string ls_from_file
string ls_to_file
boolean lb_Fail_If_Exists
boolean lb_success

f_parse_filepath(ps_from_path, ls_drive, ls_dir, ls_filename, ls_extension)
lb_Fail_If_Exists = NOT pb_overwrite
ll_copy_count = 0

// We assume that ps_to_path is a directory
// Make sure it has a backslash
if right(ps_to_path, 1) <> "\" then ps_to_path += "\"

ll_file_count = log.directory_list(ps_from_path, lstra_files)
for i = 1 to ll_file_count
	if left(lstra_files[i].filename, 1) <> "[" then
		ls_from_file = ls_drive + ls_dir + "\" + lstra_files[i].filename
		ls_to_file = ps_to_path + lstra_files[i].filename
		
		lb_success = windows_api.kernel32.copyfile(ls_from_file, ls_to_file, lb_Fail_If_Exists)
		if not lb_success then return -1
		ll_copy_count += 1
	end if
next

return ll_copy_count

end function

public function long file_read2 (string ps_file, ref blob pblb_file, boolean pb_lock_file);long ll_fileNum
FileLock le_filelock
long ll_bytes
blob lblob_empty

if isnull(ps_file) then
	log.log(this, "u_event_log.file_read2:0006", "Null file path", 4)
	return -1
end if

if pb_lock_file then
	le_filelock = LockRead!
else
	le_filelock = Shared!
end if

ll_fileNum = FileOpen(ps_file, StreamMode!, Read!, le_filelock)
if ll_fileNum < 0 then
	log.log(this, "u_event_log.file_read2:0018", "Error opening file (" + ps_file + ")", 4)
	return -1
end if

ll_bytes = FileReadEx(ll_fileNum, lblob_empty)
pblb_file = lblob_empty

if ll_bytes = -1 then
	log.log(this, "u_event_log.file_read2:0024", "Error reading file (" + ps_file + ")", 4)
	return -1
end if

FileClose(ll_fileNum)

return ll_bytes

end function

public function integer delete_old_files (string ps_filespec);str_file_attributes lstra_files[]
string ls_drive
string ls_dir
string ls_filename
string ls_extension
long ll_file_count
long i
string ls_filepath
datetime ldt_24hours

ldt_24hours = datetime(relativedate(today(), -1), now())

f_parse_filepath(ps_filespec, ls_drive, ls_dir, ls_filename, ls_extension)

ll_file_count = log.directory_list(ps_filespec, lstra_files)
for i = 1 to ll_file_count
	if datetime(lstra_files[i].lastwritedate, lstra_files[i].lastwritetime) < ldt_24hours then
		ls_filepath = ls_drive + ls_dir + "\"
		if left(lstra_files[i].filename, 1) = "[" and lstra_files[i].filename <> "[.]" and lstra_files[i].filename <> "[..]" then
			// Directory
			ls_filepath += mid(lstra_files[i].filename, 2, len(lstra_files[i].filename) - 2)
			
			if directoryexists(ls_filepath) then
				// First delete the contents
				delete_old_files(ls_filepath + "\*.*")
				
				// Then remove the directory itself
				removedirectory(ls_filepath)
			end if
		else
			// File
			ls_filepath += lstra_files[i].filename
			if fileexists(ls_filepath) then
				filedelete(ls_filepath)
			end if
		end if
	end if
next

return ll_file_count

end function

public function string get_file_version (string ps_filepath);string ls_query, ls_version, ls_langcodepage, ls_bytes = space(256) 
ulong ll_dummy, ll_size, hMem, lpInfo, lpPoint, ll_len 
long ll_ret 
int i, arr_int[4] 
char arr_hex[16] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'} 

// return the number of bytes of the file information for ps_filepath 
ll_size = GetFileVersionInfoSize (ps_filepath, ll_dummy) 

// obtain handle to the process heap 
hMem = GetProcessHeap() 

// allocate the number of bytes needed to store version information on the heap 
lpInfo = HeapAlloc(hMem, 0, ll_size) 

// write the file version information to the allocated memory 
ll_ret = GetFileVersionInfo(ps_filepath, ll_dummy, ll_size, lpInfo) 

// lpPoint is a pointer to 4 bytes where the first two bytes 
// represent the language id and the last two bytes the code page 
// query the file information on the heap for language id and code page: 
ls_query = "\VarFileInfo\Translation" 
ll_ret = VerQueryValue(lpInfo, ls_query, lpPoint, ll_len) 

// copy the 4 bytes from the heap into a PowerBuilder storage location (ls_bytes) 
MoveMemory(ls_bytes, lpPoint, ll_len) 

// on an Intel computer, the little end is stored first (Little Endian) 
// this means a Hex word like 0x1234 (two bytes) is stored in memory as (0x34 0x12) 
// copy the 4 bytes into ASCII integers and perform byte swapping: 
arr_int[1] = asc(mid(ls_bytes, 2, 1)) 
arr_int[2] = asc(mid(ls_bytes, 1, 1)) 
arr_int[3] = asc(mid(ls_bytes, 4, 1)) 
arr_int[4] = asc(mid(ls_bytes, 3, 1)) 

// to query the FileVersion in a subsequent call to VerQueryValue 
// we need the language id and code page in a Hex string representation 
// for example, it may look like 040904E4 - as in: 
// 04------ = SUBLANG_ENGLISH_USA 
// --09---- = LANG_ENGLISH 
// ----04E4 = 1252 = Codepage for Windows:Multilingual 
// convert the 4 bytes of ASCII integers into a Hex string: 
for i=1 to 4 
if arr_int[i] < 16 then 
ls_langcodepage = ls_langcodepage + '0' + arr_hex[arr_int[i] +1] 
else 
ls_langcodepage = ls_langcodepage + arr_hex[arr_int[i]/16 +1] + arr_hex[mod(arr_int[i], 16) +1] 
end if 
next 

// at this point we could also query for 
// CompanyName, FileDescription, InternalName, LegalCopyright 
// ProductName or ProductVersion by replacing the string literal FileVersion below 
// lpPoint is a pointer to the FileVersion string on the heap: 
ls_query = "\StringFileInfo\" + ls_langcodepage + "\FileVersion" 
ll_ret = VerQueryValue(lpInfo, ls_query, lpPoint, ll_len) 

// copy the version string into a PowerBuilder string location 
ls_version = space(255) 
lstrcpy(ls_version, lpPoint) 

// free the memory on the heap 
HeapFree(hMem, 0, lpInfo);

return ls_version

end function

public function integer log (powerobject po_who, string ps_script, string ps_message, integer pi_severity, string ps_component_id, string ps_version_name);integer li_sts
boolean lb_reported
integer li_event_type
integer li_category
unsignedlong ll_user
long ll_event_id
integer li_string_count
long ll_data_size
string lsa_string[]
string ls_message
long ll_rawdata
str_popup popup
string ls_who
string ls_error_file
long ll_dochandle
str_event_log_entry lstr_log
decimal ld_seconds

setnull(ld_seconds)

// Make Sure the severity is in our range
if isnull(pi_severity) then pi_severity = 1
if pi_severity < 1 then pi_severity = 1
if pi_severity > 5 then pi_severity = 5

// set event type
if pi_severity <= 1 then
	// Debug Message
	ll_event_id = 0
	li_event_type = 4
elseif pi_severity = 2 then
	// Informational Message
	ll_event_id = 0
	li_event_type = 4
elseif pi_severity = 3 then
	// Warning Message
	ll_event_id = 0
	li_event_type = 2
else
	// Error Message
	ll_event_id = 0
	li_event_type = 1
end if

// set category
li_category = 1

// Set Raw Data
ll_rawdata = 0

// Set user id
ll_user = 0

// Set Data Size
ll_data_size = 0

// Set Strings
lsa_string[1] = f_app_version() + " "

// Determine the "who" text
if isvalid(po_who) then
	ls_who = po_who.classname()
elseif isnull(po_who) and not isnull(ps_script) then
	ls_who = ps_script
else
	ls_who = "NULL CALLER"
end if

li_string_count = 1
if isnull(ps_script) then
	ps_script = "Script Unknown"
end if

if isnull(ps_message) then
	ps_message = "No Message"
end if

ls_message = "Who: " + ls_who + ", Where: " + ps_script + ", Message:" + ps_message + ", Severity: " + string(pi_severity)

// If not initialized, write to a file in the current folder
if not initialized then 
	ls_error_file = GetCurrentDirectory( ) + "\EPro-Initialization-Errors.txt"
	ll_dochandle = FileOpen(ls_error_file, LineMode!, Write!, Shared!, Append!)
	if ll_dochandle = -1 then	
		Clipboard(ls_message)
		DebugBreak()
		return -1
	end if
	FileWrite(ll_dochandle, ls_message)
	FileClose(ll_dochandle)
	return 0
end if

// If the message needs to be logged to the database, do that first
if pi_severity >= dbloglevel and not isnull(cprdb) and isvalid(cprdb) then
	f_unrecoverable(ps_message)
	li_sts = log_db(po_who, ps_script, ps_message, pi_severity, ps_component_id, ps_version_name, ld_seconds)
	lb_reported = True
end if

// Report Event to the Windows Event Log

//#define EVENTLOG_SUCCESS                0X0000
//#define EVENTLOG_ERROR_TYPE             0x0001
//#define EVENTLOG_WARNING_TYPE           0x0002
//#define EVENTLOG_INFORMATION_TYPE       0x0004
//#define EVENTLOG_AUDIT_SUCCESS          0x0008
//#define EVENTLOG_AUDIT_FAILURE          0x0010

// Commenting 30/09/2023
// trying again with nvo_utilities
if pi_severity >= loglevel then
	if common_thread.utilities_ok() then
		li_sts = common_thread.eprolibnet4.of_LogEvent(ls_who, ps_script, ps_message, pi_severity)
		lb_reported = True
	else
		log.log(this, "u_event_log.log:0112", "Event not logged (Utilities not available)", 3)
	end if
end if

// Construct the event structure
lstr_log.severity = pi_severity
lstr_log.severity_text = severities[pi_severity]
lstr_log.class = ls_who
lstr_log.script = ps_script
lstr_log.message = ps_message
lstr_log.date_time = datetime(today(), now())

// If the severity is >= 4, then report it to the message bar at the bottom of the screen
if pi_severity >= 4 then
	f_cpr_set_error(lstr_log)
	lb_reported = True
end if	

// If the display is enabled and the severity is >= the display level, then show the message to the user
if display_enabled then
	if pi_severity >= displayloglevel then
		f_display_log_entry(lstr_log)
		lb_reported = True
	end if
end if

f_unrecoverable(ps_message)

if not lb_reported then return -1

if pi_severity >= 4 then
	// Call to developer attention
	Clipboard(ls_message)
	DebugBreak()
end if

return 1


end function

public function integer log_db_with_seconds (powerobject po_who, string ps_script, string ps_message, integer pi_severity, decimal pd_seconds);string ls_component_id
string ls_version_name

setnull(ls_component_id)
setnull(ls_version_name)

return log_db(po_who, ps_script, ps_message, pi_severity, ls_component_id, ls_version_name, pd_seconds)

end function

public function integer log_db (powerobject po_who, string ps_script, string ps_message, integer pi_severity, string ps_component_id, string ps_version_name, decimal pd_seconds);string ls_user
string ls_scribe
string ls_who
string ls_message
string ls_computer
string ls_cpr_id
long ll_encounter_id
long ll_treatment_id
long ll_patient_workplan_item_id
string ls_service
string ls_app_version
environment lo_env
integer li_tran_count, li_sts
string ls_os_version
integer li_playback_count

if not cprdb.connected then return 1

if cprdb.transaction_open then
	// In case of potenetial rollback, push log messages onto the instance stack;
	// they will be played back (and logged to the db) after the rollback is complete
	li_playback_count = upperbound(playback_log) + 1
	playback_log[li_playback_count].who = po_who
	playback_log[li_playback_count].script = ps_script
	playback_log[li_playback_count].message = ps_message
	playback_log[li_playback_count].severity = pi_severity
	playback_log[li_playback_count].component_id = ps_component_id
	playback_log[li_playback_count].version_name = ps_version_name
	playback_log[li_playback_count].date_time = datetime(today(),now())
	playback_log[li_playback_count].seconds = pd_seconds
end if

li_sts = getenvironment(lo_env)
if li_sts > 0 then
	ls_os_version = string(lo_env.OSMajorRevision)
	ls_os_version += "." + string(lo_env.OSMinorRevision)
	ls_os_version += "." + string(lo_env.OSFixesRevision)
else
	setnull(ls_os_version)
end if

if len(ps_message) > 500 then
	ls_message = left(ps_message, 500)
else
	ls_message = ps_message
end if

// Determine the "who" text
if isvalid(po_who) then
	ls_who = po_who.classname()
elseif isnull(po_who) and not isnull(ps_script) then
	ls_who = ps_script
else
	ls_who = "NULL CALLER"
end if

if isnull(current_user) then
	setnull(ls_user)
else
	ls_user = current_user.user_id
end if

if isnull(current_scribe) then
	setnull(ls_scribe)
else
	ls_scribe = current_scribe.user_id
end if

if isnull(current_patient) then
	setnull(ls_cpr_id)
else
	ls_cpr_id = current_patient.cpr_id
	if isnull(current_patient.open_encounter) then
		setnull(ll_encounter_id)
	else
		ll_encounter_id = current_patient.open_encounter.encounter_id
	end if
end if

if isnull(current_service) then
	setnull(ll_treatment_id)
	setnull(ll_patient_workplan_item_id)
	setnull(current_service)
else
	ll_patient_workplan_item_id = current_service.patient_workplan_item_id
	ll_treatment_id = current_service.treatment_id
	ls_service = current_service.service
end if

ls_app_version = f_app_version()

if pi_severity >= 3 then
	// We want to be sure warnings and errors are logged. Is there any open transaction?
	SELECT count(*) INTO :li_tran_count FROM sys.sysprocesses WHERE open_tran = 1 USING cprdb;
	IF li_tran_count = 0 THEN
		cprdb.begin_transaction(this, ps_script)
	END IF
end if

INSERT INTO o_Log (
		severity,
		caller,
		script,
		message,
		computer_id,
		computername,
		windows_logon_id,
		cpr_id,
		encounter_id,
		treatment_id,
		patient_workplan_item_id,
		service,
		user_id,
		scribe_user_id,
		os_version,
		epro_version,
		component_id,
		compile_name,
		progress_seconds)
VALUES (
		:severities[pi_severity],
		:ls_who,
		:ps_script,
		:ls_message,
		:gnv_app.computer_id,
		:gnv_app.computername,
		:gnv_app.windows_logon_id,
		:ls_cpr_id,
		:ll_encounter_id,
		:ll_treatment_id,
		:ll_patient_workplan_item_id,
		:ls_service,
		:ls_user,
		:ls_scribe,
		:ls_os_version,
		:ls_app_version,
		:ps_component_id,
		:ps_version_name,
		:pd_seconds)
USING cprdb;

li_sts = cprdb.sqlcode

IF pi_severity >= 3 AND li_tran_count = 0 THEN
	cprdb.commit_transaction()
END IF

if li_sts = 0 then
	return 1
else
	return -1
end if

end function

public subroutine clear_playback ();str_playback_log_entry lstr_empty[]

playback_log = lstr_empty
end subroutine

public subroutine play_back ();
// Called from u_sqlca.rollback_transaction, to play back the log messages that were saved during the transaction
// Otherwise the messages are lost when the transaction rolls back
integer li_log_count, li_playback_count
string ls_message

li_playback_count = upperbound(playback_log)
ls_message = "Next " + string(li_playback_count) + " log records are played back from rolled back transaction"
this.log_db(this,"u_event_log.play_back:0009",ls_message,2)

for li_log_count = 1 TO li_playback_count
	ls_message = playback_log[li_log_count].message + " (" + string(playback_log[li_log_count].date_time) + ")"
	this.log_db( &
	playback_log[li_log_count].who, &
	playback_log[li_log_count].script, &
	ls_message, &
	playback_log[li_log_count].severity, &
	playback_log[li_log_count].component_id, &
	playback_log[li_log_count].version_name, &
	playback_log[li_log_count].seconds &
	)
NEXT

clear_playback()

end subroutine

on u_event_log.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_event_log.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

