$PBExportHeader$w_svc_edit_supervisor.srw
forward
global type w_svc_edit_supervisor from w_window_base
end type
type cb_cancel from commandbutton within w_svc_edit_supervisor
end type
type st_title from statictext within w_svc_edit_supervisor
end type
type cb_ok from commandbutton within w_svc_edit_supervisor
end type
type st_current_title from statictext within w_svc_edit_supervisor
end type
type st_current_supervisor from statictext within w_svc_edit_supervisor
end type
type st_change_title from statictext within w_svc_edit_supervisor
end type
type st_change_supervisor from statictext within w_svc_edit_supervisor
end type
type st_not_permitted from statictext within w_svc_edit_supervisor
end type
end forward

global type w_svc_edit_supervisor from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
cb_cancel cb_cancel
st_title st_title
cb_ok cb_ok
st_current_title st_current_title
st_current_supervisor st_current_supervisor
st_change_title st_change_title
st_change_supervisor st_change_supervisor
st_not_permitted st_not_permitted
end type
global w_svc_edit_supervisor w_svc_edit_supervisor

type variables
u_component_service	service

u_user new_supervisor

end variables

on w_svc_edit_supervisor.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.st_title=create st_title
this.cb_ok=create cb_ok
this.st_current_title=create st_current_title
this.st_current_supervisor=create st_current_supervisor
this.st_change_title=create st_change_title
this.st_change_supervisor=create st_change_supervisor
this.st_not_permitted=create st_not_permitted
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.st_current_title
this.Control[iCurrent+5]=this.st_current_supervisor
this.Control[iCurrent+6]=this.st_change_title
this.Control[iCurrent+7]=this.st_change_supervisor
this.Control[iCurrent+8]=this.st_not_permitted
end on

on w_svc_edit_supervisor.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.st_current_title)
destroy(this.st_current_supervisor)
destroy(this.st_change_title)
destroy(this.st_change_supervisor)
destroy(this.st_not_permitted)
end on

event open;call super::open;integer li_sts
integer ll_menu_id
string ls_cpr_id

service = message.powerobjectparm

if current_user.check_privilege("Change Supervisor") then
	st_not_permitted.visible = false
else
	st_change_supervisor.visible = false
	st_change_title.visible = false
end if

if isnull(current_user.supervisor) then
	st_current_supervisor.text = "<None>"
else
	st_current_supervisor.text = current_user.supervisor.user_full_name
	st_current_supervisor.backcolor = current_user.supervisor.color
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_edit_supervisor
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_edit_supervisor
end type

type cb_cancel from commandbutton within w_svc_edit_supervisor
integer x = 59
integer y = 1596
integer width = 443
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"

closewithreturn(parent, popup_return)
end event

type st_title from statictext within w_svc_edit_supervisor
integer width = 2921
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Change Supervisor"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_svc_edit_supervisor
integer x = 2418
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = user_list.set_user_progress( current_user.user_id, &
												"Modify", &
												"supervisor_user_id", &
												new_supervisor.user_id)
if li_sts <= 0 then
	openwithparm(w_pop_message, "An error occured saving the supervisor")
	return
end if

current_user.supervisor = new_supervisor

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)
end event

type st_current_title from statictext within w_svc_edit_supervisor
integer x = 567
integer y = 648
integer width = 686
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Current Supervisor:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_current_supervisor from statictext within w_svc_edit_supervisor
integer x = 1280
integer y = 628
integer width = 1019
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_change_title from statictext within w_svc_edit_supervisor
integer x = 567
integer y = 848
integer width = 686
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Change Supervisor To:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_change_supervisor from statictext within w_svc_edit_supervisor
integer x = 1280
integer y = 828
integer width = 1019
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;u_user luo_user
integer li_sts


luo_user = user_list.pick_user()
if isnull(luo_user) then return

if isnull(luo_user.license_flag) or luo_user.license_flag <> "P" then
	openwithparm(w_pop_message, "Only a user whose provider class is ~"Physician~" may be a supervisor")
	return
end if

// Check for a supervisor loop
if f_is_supervisor_loop(current_user.user_id, luo_user.user_id) then return

new_supervisor = luo_user
text = luo_user.user_full_name
backcolor = luo_user.color



end event

type st_not_permitted from statictext within w_svc_edit_supervisor
integer x = 763
integer y = 1036
integer width = 1413
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "You are not permitted to change your supervisor"
alignment alignment = right!
boolean focusrectangle = false
end type

