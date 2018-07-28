HA$PBExportHeader$w_svc_change_scribe_context.srw
forward
global type w_svc_change_scribe_context from w_window_base
end type
type cb_cancel from commandbutton within w_svc_change_scribe_context
end type
type st_title from statictext within w_svc_change_scribe_context
end type
type st_current_title from statictext within w_svc_change_scribe_context
end type
type st_current_scribe_context from statictext within w_svc_change_scribe_context
end type
type st_change_title from statictext within w_svc_change_scribe_context
end type
type st_no_scribe from statictext within w_svc_change_scribe_context
end type
type dw_scribe_shortlist from u_dw_pick_list within w_svc_change_scribe_context
end type
type cb_pick_user from commandbutton within w_svc_change_scribe_context
end type
type st_not_authorized from statictext within w_svc_change_scribe_context
end type
type dw_message from datawindow within w_svc_change_scribe_context
end type
type cb_ok from commandbutton within w_svc_change_scribe_context
end type
end forward

global type w_svc_change_scribe_context from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
cb_cancel cb_cancel
st_title st_title
st_current_title st_current_title
st_current_scribe_context st_current_scribe_context
st_change_title st_change_title
st_no_scribe st_no_scribe
dw_scribe_shortlist dw_scribe_shortlist
cb_pick_user cb_pick_user
st_not_authorized st_not_authorized
dw_message dw_message
cb_ok cb_ok
end type
global w_svc_change_scribe_context w_svc_change_scribe_context

type variables
u_component_service	service

string new_scribe_context

string top_20_code_1
string top_20_code_2

string scribe_message

boolean scribing_allowed

end variables

forward prototypes
public function integer refresh ()
public subroutine set_screen ()
end prototypes

public function integer refresh ();long ll_count
string ls_find
long ll_row

dw_scribe_shortlist.settransobject(sqlca)
ll_count = dw_scribe_shortlist.retrieve(current_scribe.user_id, top_20_code_1, "")
if ll_count < 0 then
	return -1
end if

set_screen()

return 1

end function

public subroutine set_screen ();string ls_find
long ll_row
string ls_selected_user_id


if not scribing_allowed then
	st_no_scribe.visible = false
	st_change_title.visible = false
	dw_scribe_shortlist.visible = false
	cb_pick_user.visible = false
	dw_message.visible = false
	st_not_authorized.visible = true
	cb_ok.text = "OK"
	cb_ok.enabled = true
	cb_cancel.visible = false
else
	st_no_scribe.visible = true
	st_change_title.visible = true
	dw_scribe_shortlist.visible = true
	cb_pick_user.visible = true
	dw_message.visible = true
	st_not_authorized.visible = false
	cb_cancel.visible = true

	if len(new_scribe_context) > 0 then
		if new_scribe_context = current_scribe.user_id then
			st_no_scribe.backcolor = color_object_selected
			cb_ok.text = "OK"
			dw_message.visible = false
			dw_scribe_shortlist.clear_selected()
			cb_ok.enabled = true
		else
			st_no_scribe.backcolor = color_object
			ll_row = dw_scribe_shortlist.get_selected_row()
			if ll_row > 0 then
				ls_selected_user_id = dw_scribe_shortlist.object.search_user_id[ll_row]
				if ls_selected_user_id <> new_scribe_context then
					dw_scribe_shortlist.clear_selected()
					ll_row = 0
				end if
			end if
			if ll_row = 0 then
				ls_find = "search_user_id = '" + new_scribe_context + "'"
				ll_row = dw_scribe_shortlist.find(ls_find, 1, dw_scribe_shortlist.rowcount())
			end if
			if ll_row > 0 then
				dw_scribe_shortlist.object.selected_flag[ll_row] = 1
				dw_scribe_shortlist.scrolltorow(ll_row)
				cb_ok.text = "I Agree"
				dw_message.visible = true
				cb_ok.enabled = true
			else
				cb_ok.text = "OK"
				dw_message.visible = false
				cb_ok.enabled = false
			end if
		end if
	else
		dw_scribe_shortlist.clear_selected()
		st_no_scribe.backcolor = color_object
		cb_ok.text = "OK"
		dw_message.visible = false
		cb_ok.enabled = false
	end if
end if


return

end subroutine

on w_svc_change_scribe_context.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.st_title=create st_title
this.st_current_title=create st_current_title
this.st_current_scribe_context=create st_current_scribe_context
this.st_change_title=create st_change_title
this.st_no_scribe=create st_no_scribe
this.dw_scribe_shortlist=create dw_scribe_shortlist
this.cb_pick_user=create cb_pick_user
this.st_not_authorized=create st_not_authorized
this.dw_message=create dw_message
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.st_current_title
this.Control[iCurrent+4]=this.st_current_scribe_context
this.Control[iCurrent+5]=this.st_change_title
this.Control[iCurrent+6]=this.st_no_scribe
this.Control[iCurrent+7]=this.dw_scribe_shortlist
this.Control[iCurrent+8]=this.cb_pick_user
this.Control[iCurrent+9]=this.st_not_authorized
this.Control[iCurrent+10]=this.dw_message
this.Control[iCurrent+11]=this.cb_ok
end on

on w_svc_change_scribe_context.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.st_title)
destroy(this.st_current_title)
destroy(this.st_current_scribe_context)
destroy(this.st_change_title)
destroy(this.st_no_scribe)
destroy(this.dw_scribe_shortlist)
destroy(this.cb_pick_user)
destroy(this.st_not_authorized)
destroy(this.dw_message)
destroy(this.cb_ok)
end on

event open;call super::open;integer li_sts
integer ll_menu_id
string ls_cpr_id

service = message.powerobjectparm

top_20_code_1 = "MyScribeContexts"
setnull(top_20_code_2)
scribe_message = "By logging into the EncounterPRO$$HEX2$$ae002000$$ENDHEX$$Electronic Health Record as a scribe for a licensed provider, I hereby affirm that the provider I designate has specifically asked me to do so.  I further affirm that when I am logged into the EncounterPRO EHR as a scribe, I am only recording observations and orders made and communicated to me by such provider.  I am not recording my own observations, orders or other information."

if current_scribe.user_id = current_user.user_id then
	st_current_scribe_context.text = "Yourself"
else
	st_current_scribe_context.text = current_user.user_full_name
	st_current_scribe_context.backcolor = current_user.color
end if


dw_message.object.message.width = dw_message.width
dw_message.insertrow(0)
dw_message.object.message[1] = scribe_message

setnull(new_scribe_context)


if not datalist.get_preference_boolean("PREFERENCES", "Enable Scribing", false) then
	scribing_allowed = false
	st_not_authorized.text = "Scribing is not allowed"
elseif not current_scribe.check_privilege("Scribe") then
	scribing_allowed = false
	st_not_authorized.text = "You are not authorized to change your scribe context"
else
	scribing_allowed = true
end if


refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_change_scribe_context
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_change_scribe_context
end type

type cb_cancel from commandbutton within w_svc_change_scribe_context
integer x = 59
integer y = 1608
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

type st_title from statictext within w_svc_change_scribe_context
integer width = 2921
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Change Scribe Context"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_current_title from statictext within w_svc_change_scribe_context
integer x = 18
integer y = 216
integer width = 891
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "You are currently scribing for:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_current_scribe_context from statictext within w_svc_change_scribe_context
integer x = 955
integer y = 200
integer width = 1445
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

type st_change_title from statictext within w_svc_change_scribe_context
integer x = 114
integer y = 428
integer width = 795
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Change scribe context to:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_no_scribe from statictext within w_svc_change_scribe_context
integer x = 955
integer y = 1140
integer width = 1445
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
string text = "None (Scribe for yourself)"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;new_scribe_context = current_scribe.user_id
backcolor = color_object_selected

set_screen()

end event

type dw_scribe_shortlist from u_dw_pick_list within w_svc_change_scribe_context
integer x = 955
integer y = 404
integer width = 1445
integer height = 692
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_sp_user_top_20_search"
end type

event selected;call super::selected;new_scribe_context = object.search_user_id[selected_row]

parent.function POST set_screen()

end event

event unselected;call super::unselected;string ls_new_scribe_context

ls_new_scribe_context = object.search_user_id[unselected_row]

if ls_new_scribe_context = new_scribe_context then
	// If the unselected row is the current selection then clear the current selection
	setnull(new_scribe_context)
	parent.function POST set_screen()
end if


end event

type cb_pick_user from commandbutton within w_svc_change_scribe_context
integer x = 2414
integer y = 1016
integer width = 407
integer height = 80
integer taborder = 21
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Find Other..."
end type

event clicked;u_user luo_user
integer li_sts
str_pick_users lstr_pick_users

//luo_user = user_list.pick_user()
lstr_pick_users.actor_class = "Consultant"
lstr_pick_users.pick_screen_title = "Select User For Whom You Are Scribing"
li_sts = user_list.pick_users(lstr_pick_users)
if li_sts <= 0 then return

luo_user = user_list.find_user(lstr_pick_users.selected_users.user[1].user_id)
if isnull(luo_user) then return

new_scribe_context = luo_user.user_id

if new_scribe_context <> current_scribe.user_id then
	li_sts = f_update_pick_lists_2(top_20_code_1, top_20_code_2, luo_user.user_id, luo_user.user_full_name)
end if

refresh()


end event

type st_not_authorized from statictext within w_svc_change_scribe_context
integer x = 590
integer y = 736
integer width = 1751
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "You are not authorized to change your scribe context"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_message from datawindow within w_svc_change_scribe_context
integer x = 357
integer y = 1296
integer width = 2208
integer height = 252
integer taborder = 21
boolean bringtotop = true
boolean enabled = false
string dataobject = "dw_security_alert_message"
boolean vscrollbar = true
boolean border = false
end type

type cb_ok from commandbutton within w_svc_change_scribe_context
integer x = 2222
integer y = 1608
integer width = 626
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I Agree"
boolean default = true
end type

event clicked;integer li_sts
str_popup_return popup_return
u_user luo_user

  
if scribing_allowed then
	if not user_list.is_active_user(new_scribe_context) then
		openwithparm(w_pop_message, "The selected user is not an active user.  You may only scribe for an active user.")
		return
	end if
	
	
	li_sts = user_list.set_scribe_context(new_scribe_context)
	if li_sts <= 0 then
		openwithparm(w_pop_message, "Setting scribe context failed")
		return
	end if
end if

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)


end event

