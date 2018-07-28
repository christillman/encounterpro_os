$PBExportHeader$w_change_password.srw
forward
global type w_change_password from w_window_base
end type
end forward

global type w_change_password from w_window_base
boolean visible = false
string title = "Change Password"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
end type
global w_change_password w_change_password

on w_change_password.create
call super::create
end on

on w_change_password.destroy
call super::destroy
end on

event post_open;call super::post_open;integer li_sts
str_popup_return popup_return

li_sts = user_list.change_access_code(current_user.user_id)

popup_return.item_count = 1

if li_sts < 0 then
	popup_return.items[1] = "ERROR"
else
	popup_return.items[1] = "OK"
end if

closewithreturn(this, popup_return)

end event

event open;call super::open;postevent("post_open")
end event

type pb_epro_help from w_window_base`pb_epro_help within w_change_password
end type

