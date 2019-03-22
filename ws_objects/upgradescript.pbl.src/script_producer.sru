$PBExportHeader$script_producer.sru
forward
global type script_producer from nonvisualobject
end type
type os_filedatetime from structure within script_producer
end type
type os_fileopeninfo from structure within script_producer
end type
type os_finddata from structure within script_producer
end type
type os_securityattributes from structure within script_producer
end type
type os_systemtime from structure within script_producer
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

global type script_producer from nonvisualobject
end type
global script_producer script_producer

type prototypes

Function long FindFirstFileA (ref string filename, ref os_finddata findfiledata) library "KERNEL32.DLL" alias for "FindFirstFileA;Ansi"
Function boolean FindNextFileA (long handle, ref os_finddata findfiledata) library "KERNEL32.DLL" alias for "FindNextFileA;Ansi"
Function boolean FindClose (long handle) library "KERNEL32.DLL"

end prototypes

forward prototypes
public function integer produce_upgrade_file (string ps_ddl_path, string ps_dml_path, string ps_output_path)
public function integer get_scripts (string ps_directory, ref string ps_scripts[], ref string ps_scriptnames[])
public function integer add_scripts_in_folder (string ps_mod_folder, string ps_object_folder, ref pbdom_element pe_root)
public subroutine go ()
end prototypes

public function integer produce_upgrade_file (string ps_ddl_path, string ps_dml_path, string ps_output_path);

// This will produce an XML (*.mdlvl) file containing the scripts needed to 
// upgrade the database from one mod level to the next.

// The DDL path is currently 
//   E:\EncounterPro\encounter_pro_os\Database Schema\Mod Level Scripts\xxx

// and the DML path is
//   E:\EncounterPro\encounter_pro_os\Database\Scripts\Mod Level Upgrade\xxx

// where xxx represents the Mode Level e.g. 202.

// This routine will simply package up the scripts found into the XML. But it 
// will package up table and view scripts first, then procedures and functions, 
// and finally loose files in the upgrade folder in alphabetical order.

// A special folder is the attachments folder; those files will need to be copied 
// to the \\localhost\attachments share. They can then be used for e.g. bulk imports.
// The files will be installed into this folder. Here, we ignore the attachments folder
// but the bulk inserts script depends on it.

string ls_folder
string ls_mod_level
pbdom_document ld_upgrade_script
pbdom_element le_root, le_script

if Len(ps_dml_path) > 3 then
	ls_mod_level = Right(ps_dml_path,3)
else
	ls_mod_level = Right(ps_ddl_path,3)
end if


ld_upgrade_script = CREATE pbdom_document
ld_upgrade_script.NewDocument("EproDBSchema")
le_root = ld_upgrade_script.GetRootElement()

// First, list all the sub directories in the ddl folder. We need to 
// process them in the correct order. The assumption is there is only
// one level of directories.

add_scripts_in_folder(ps_ddl_path, "Tables", le_root)
add_scripts_in_folder(ps_ddl_path, "BulkInserts", le_root)
add_scripts_in_folder(ps_ddl_path, "Triggers", le_root)
add_scripts_in_folder(ps_ddl_path, "Views", le_root)
add_scripts_in_folder(ps_ddl_path, "Functions", le_root)
add_scripts_in_folder(ps_ddl_path, "Procedures", le_root)
// also scripts directly in the DDL mod folder
add_scripts_in_folder(ps_ddl_path, "DDL", le_root)

// no subfolders in DML mod folder
add_scripts_in_folder(ps_dml_path, "DML", le_root)


FileDelete(ps_output_path + "\ModLevel_" + ls_mod_level + ".mdlvl")
// Note, the uptake script looks for the dash, mod and .mdlvl
ld_upgrade_script.SaveDocument(ps_output_path + "\ModLevel-" + ls_mod_level + ".mdlvl")
DESTROY ld_upgrade_script

// The attachments files will be installed into the attachments share

RETURN 0
end function

public function integer get_scripts (string ps_directory, ref string ps_scripts[], ref string ps_scriptnames[]);
// Find all scripts from the folder given and subfolders, and package them into the mdlvl XML file

long   ll_handle
long   li_count = 1
os_finddata lpFindFileData, lst_FindData
string ls_filename
string ls_entries
long ll_input
string ls_directory
integer li_script_count

ls_directory = ps_directory + "\*"

li_script_count = UpperBound(ps_scripts)

// process the scripts in this folder
ll_handle = FindFirstFileA (ls_directory, lpFindFileData)
If ll_Handle <= 0 Then Return -1

li_count = 1
ls_filename = lpFindFileData.ch_filename 
//Call FindnextFile if there are multiple files as below :
lpFindFileData = lst_FindData //reset the structure
do while FindNextFileA( ll_handle,  lpFindFileData)
	if f_check_bit(lpFindFileData.ul_FileAttributes, 5) then
		// ignore subdirectories
		continue
	end if
   li_script_count = li_script_count + 1
	ls_filename = lpFindFileData.ch_filename

	ps_scriptnames[li_script_count] = ls_filename
	ll_input = FileOpen(ps_directory + "\" + ls_filename, TextMode!)
	if ll_input < 0 then
		MessageBox("File could not be opened", ps_directory + "\" + ls_filename)
	else
		FileReadEx(ll_input, ps_scripts[li_script_count])	
		FileClose(ll_input)
	end if

   lpFindFileData = lst_FindData //reset the structure
loop

//now close the search 
FindClose(ll_handle)

return li_count

end function

public function integer add_scripts_in_folder (string ps_mod_folder, string ps_object_folder, ref pbdom_element pe_root);
string ls_scripts[]
string ls_scriptnames[]
integer li_script
string ls_folder, ls_nodename
pbdom_element le_script

if ps_object_folder = "DDL" or ps_object_folder = "DML" then
	ls_folder = ps_mod_folder
else
	ls_folder = ps_mod_folder + "\" + ps_object_folder
end if

if FileExists (ls_folder) then
	get_scripts(ls_folder, ls_scripts, ls_scriptnames)
	for li_script = 1 to UpperBound(ls_scripts)
		try
			le_script = CREATE pbdom_element
   		ls_nodename = f_string_substitute(ls_scriptnames[li_script], ' ', '_')
			le_script.SetName(ps_object_folder + "." + ls_nodename)
			le_script.SetText(ls_scripts[li_script])
			pe_root.AddContent(le_script)
		catch (pbdom_exception ex)
			MessageBox("PBDOM Exception", ex.getMessage())
		end try	
	next
end if

return li_script
end function

public subroutine go ();

integer li_sts
string ls_ddl_path
string ls_dml_path
string ls_output_path
string ls_building_from

ls_building_from = GetCurrentDirectory ( )

ls_ddl_path = "C:\Users\tofft\EncounterPro\encounterpro_os\Database_Schema\Mod_Level_Scripts"
li_sts = GetFolder ("Select Database Schema Mod Folder", ls_ddl_path)
If li_sts <= 0 Then return

ls_dml_path = "C:\Users\tofft\EncounterPro\encounterpro_os\EncounterPRO.OS.Database\Scripts\Mod_Level_Upgrade"
li_sts = GetFolder ("Select Database DML Mod Folder", ls_dml_path)
If li_sts <= 0 Then return

ls_output_path = "C:\Users\tofft\EncounterPro\Builds\EncounterPRO-OS\Database\Upgrade"
li_sts = GetFolder ("Select Output Folder", ls_output_path)
If li_sts <= 0 Then return
li_sts = produce_upgrade_file(ls_ddl_path, ls_dml_path, ls_output_path + "\Attachments")

if li_sts < 0 then
	MessageBox("Error", "Error producing upgrade file")
else
	MessageBox("Success", "Upgrade file written in " + ls_output_path)
end if

end subroutine

on script_producer.create
call super::create
TriggerEvent( this, "constructor" )
end on

on script_producer.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

