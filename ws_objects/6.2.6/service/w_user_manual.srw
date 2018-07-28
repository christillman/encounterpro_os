HA$PBExportHeader$w_user_manual.srw
forward
global type w_user_manual from w_window_base
end type
end forward

global type w_user_manual from w_window_base
boolean visible = false
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
end type
global w_user_manual w_user_manual

event open;call super::open;postevent("post_open")
end event

event post_open;call super::post_open;string ls_path

ls_path = datalist.get_preference( "SYSTEM", "User Manual Location")

if isnull(ls_path) then
	ls_path = f_default_attachment_path() + "\User Manual\HTML\Table of Contents.htm"
end if

f_open_file(ls_path, false)

Close(this)

end event

on w_user_manual.create
call super::create
end on

on w_user_manual.destroy
call super::destroy
end on

type pb_epro_help from w_window_base`pb_epro_help within w_user_manual
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_user_manual
end type

