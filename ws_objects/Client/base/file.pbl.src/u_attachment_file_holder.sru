$PBExportHeader$u_attachment_file_holder.sru
forward
global type u_attachment_file_holder from nonvisualobject
end type
end forward

global type u_attachment_file_holder from nonvisualobject
end type
global u_attachment_file_holder u_attachment_file_holder

type variables
blob attachment_file

string cpr_id
string object_file
string object_type

u_event_log mylog

end variables

forward prototypes
public function string subdir (string ps_string)
private function string file_path ()
public subroutine initialize (u_event_log puo_log)
public function integer get_file (string ps_cpr_id, string ps_object_file, string ps_object_type)
public function integer save_file (string ps_cpr_id, string ps_object_file, string ps_object_type)
end prototypes

public function string subdir (string ps_string);integer li_asc

if len(ps_string) > 1 then
	ps_string = left(ps_string, 1)
elseif len(ps_string) < 1 then
	return "0"
end if

if ps_string >= "0" and ps_string <= "9" then
	return ps_string
end if

li_asc = mod(asc(ps_string), 10)

return char(asc("0") + li_asc)

end function

private function string file_path ();string ls_xx, ls_1, ls_2
string ls_object_file_server
string ls_object_file_path
string ls_path

ls_xx = right(cpr_id, 2)

ls_1 = subdir(left(ls_xx, 1))
ls_2 = subdir(right(ls_xx, 1))

ls_object_file_server = f_get_global_preference("SYSTEM", "object_file_server_" + ls_1)
if isnull(ls_object_file_server) then
	ls_object_file_server = f_get_global_preference("SYSTEM", "object_file_server")
end if

ls_object_file_path = f_get_global_preference("SYSTEM", "object_file_path_" + ls_1)
if isnull(ls_object_file_path) then
	ls_object_file_path = f_get_global_preference("SYSTEM", "object_file_path")
end if

if len(ls_object_file_server) > 1 then
	ls_path = "\\" + ls_object_file_server
else
	ls_path = ls_object_file_server + ":"
end if

ls_path += "\" + ls_object_file_path + "\" + ls_1 + "\" + ls_2 + "\" + object_file + "." + object_type

return ls_path


end function

public subroutine initialize (u_event_log puo_log);mylog = puo_log

end subroutine

public function integer get_file (string ps_cpr_id, string ps_object_file, string ps_object_type);string ls_filepath
integer li_sts

cpr_id = ps_cpr_id
object_file = ps_object_file
object_type = ps_object_type

ls_filepath = file_path()

if not fileexists(ls_filepath) then return 0

li_sts = mylog.file_read(ls_filepath, attachment_file)
if li_sts <= 0 then return li_sts

return 1

end function

public function integer save_file (string ps_cpr_id, string ps_object_file, string ps_object_type);string ls_filepath
integer li_sts

cpr_id = ps_cpr_id
object_file = ps_object_file
object_type = ps_object_type

ls_filepath = file_path()

li_sts = mylog.file_write(attachment_file, ls_filepath)
if li_sts <= 0 then return li_sts

return 1

end function

on u_attachment_file_holder.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_attachment_file_holder.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

