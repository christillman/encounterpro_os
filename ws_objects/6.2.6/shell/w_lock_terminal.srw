HA$PBExportHeader$w_lock_terminal.srw
forward
global type w_lock_terminal from w_window_base
end type
type st_title from statictext within w_lock_terminal
end type
type cb_unlock from commandbutton within w_lock_terminal
end type
type st_legal from statictext within w_lock_terminal
end type
type st_copyright from statictext within w_lock_terminal
end type
type st_build_number from statictext within w_lock_terminal
end type
type p_logo from picture within w_lock_terminal
end type
end forward

global type w_lock_terminal from w_window_base
integer width = 2935
integer height = 1840
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
st_title st_title
cb_unlock cb_unlock
st_legal st_legal
st_copyright st_copyright
st_build_number st_build_number
p_logo p_logo
end type
global w_lock_terminal w_lock_terminal

type variables
string access_id

string home

boolean minimizing = false

end variables

event open;call super::open;integer i, li_row
string ls_temp
integer li_sts
long ll_x

if isnull(current_scribe) then
	log.log(this, "open", "The terminal lock window should only be opened when a user is logged in", 3)
	close(this)
end if

st_build_number.text = "Version  " + f_app_version()

bringtotop = true

timer(refresh_timer, this)

// Move stuff around
p_logo.x = (width - p_logo.width) / 2
st_build_number.x = (width - st_build_number.width) / 2
st_copyright.x = (width - st_copyright.width) / 2
st_legal.x = (width - st_legal.width) / 2
cb_unlock.x = (width - cb_unlock.width) / 2
st_title.x = (width - st_title.width) / 2


idle(0)

postevent("timer")

end event

event timer;integer li_sts

w_main.uo_help_bar.uf_set_clock()

// See if the database is still OK
// See if the database is OK
li_sts = f_check_system_status()
if li_sts <= 0 then
	halt close
	return
end if


end event

on w_lock_terminal.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_unlock=create cb_unlock
this.st_legal=create st_legal
this.st_copyright=create st_copyright
this.st_build_number=create st_build_number
this.p_logo=create p_logo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_unlock
this.Control[iCurrent+3]=this.st_legal
this.Control[iCurrent+4]=this.st_copyright
this.Control[iCurrent+5]=this.st_build_number
this.Control[iCurrent+6]=this.p_logo
end on

on w_lock_terminal.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_unlock)
destroy(this.st_legal)
destroy(this.st_copyright)
destroy(this.st_build_number)
destroy(this.p_logo)
end on

event close;call super::close;idle(common_thread.idle_timeout)

end event

event key;// Override so the key events don't get processed
end event

type pb_epro_help from w_window_base`pb_epro_help within w_lock_terminal
integer x = 2866
integer y = 200
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_lock_terminal
integer x = 0
integer y = 1708
end type

type st_title from statictext within w_lock_terminal
integer x = 279
integer y = 28
integer width = 2336
integer height = 136
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "This terminal has been locked due to inactivity."
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_unlock from commandbutton within w_lock_terminal
integer x = 1097
integer y = 212
integer width = 695
integer height = 132
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Unlock Terminal"
end type

event clicked;str_attempt_logon lstr_attempt_logon
string ls_user_id
string ls_logged_off_user_id
integer li_sts
string ls_message
u_user luo_user
str_popup_return popup_return
string ls_null

setnull(ls_null)

ls_user_id = user_list.authenticate()
if isnull(ls_user_id) then return


if ls_user_id = current_scribe.user_id then
	li_sts = f_log_security_event("Reauthenticate", "Success", ls_null)
	if li_sts <= 0 then return
	close(parent)
	return
end if

ls_message = "This session is owned by " + current_scribe.user_full_name
ls_message += ".  Do you wish to take over this session?"

openwithparm(w_pop_yes_no, ls_message)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

// See if this user is authorized for this service
if not isnull(current_service) then
	if not user_list.is_user_service(ls_user_id, current_service.service) then
		openwithparm(w_pop_message, "You are not authorized to take over this session.")
		return
	end if
end if

ls_logged_off_user_id = current_scribe.user_id

sqlca.begin_transaction(this, "Session Takeover")

li_sts = f_log_security_event("Forced Logout", "Success", ls_null)
if li_sts <= 0 then return

sqlca.sp_user_logoff(current_scribe.user_id, computer_id)
if not tf_check() then return

lstr_attempt_logon.user_id = ls_user_id
lstr_attempt_logon.sticky_logon = false
luo_user = user_list.user_logon(lstr_attempt_logon)
if isnull(luo_user) then
	sqlca.rollback_transaction()
	return
end if

li_sts = f_log_security_event("Session Takeover", "Success", ls_logged_off_user_id)
if li_sts <= 0 then return

sqlca.commit_transaction()

current_scribe = luo_user

close(parent)

f_set_screen()

return


end event

type st_legal from statictext within w_lock_terminal
integer y = 1076
integer width = 2907
integer height = 536
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "By using this program, health care provider agrees that this product is not intended to suggest or replace any medical decisions or actions with respect to the patients medical care and that the sole and exclusive responsibility for determining the accuracy, completeness or appropriateness of any diagnostic, clinical or medical information provided by the program and any underlying clinical database resides solely with the health care provider.  Licensor assumes no responsibility for how such materials are used and disclaims all warranties, whether express or implied, including any warranty as to the quality, accuracy or suitability of this information and product for any particular purpose."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_copyright from statictext within w_lock_terminal
integer x = 407
integer y = 908
integer width = 2075
integer height = 76
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = roman!
string facename = "Times New Roman"
long backcolor = 33538240
boolean enabled = false
string text = "Copyright 1996-2008 EncounterPRO Healthcare Resources, Inc.  All Rights Reserved."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_build_number from statictext within w_lock_terminal
integer x = 814
integer y = 724
integer width = 1262
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Build 159"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_logo from picture within w_lock_terminal
integer x = 1001
integer y = 416
integer width = 891
integer height = 280
string picturename = "EHR_Logo_v5blue.jpg"
boolean focusrectangle = false
end type

