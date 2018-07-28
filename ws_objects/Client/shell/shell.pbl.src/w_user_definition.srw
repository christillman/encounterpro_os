$PBExportHeader$w_user_definition.srw
forward
global type w_user_definition from w_window_base
end type
type tab_user from u_tab_user_profile within w_user_definition
end type
type tab_user from u_tab_user_profile within w_user_definition
end type
type cb_ok from commandbutton within w_user_definition
end type
type st_title from statictext within w_user_definition
end type
end forward

global type w_user_definition from w_window_base
integer width = 2944
integer height = 1768
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
tab_user tab_user
cb_ok cb_ok
st_title st_title
end type
global w_user_definition w_user_definition

type variables
u_user user



end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();tab_user.refresh()

return 1

end function

on w_user_definition.create
int iCurrent
call super::create
this.tab_user=create tab_user
this.cb_ok=create cb_ok
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_user
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.st_title
end on

on w_user_definition.destroy
call super::destroy
destroy(this.tab_user)
destroy(this.cb_ok)
destroy(this.st_title)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_email_domain
integer li_first_tab

popup = message.powerobjectparm
popup_return.item_count = 0

if popup.data_row_count = 0 then
	log.log(this, "open", "No User ID", 4)
	closewithreturn(this, popup_return)
	return
else
	user_list.clear_cache()
	user = user_list.find_user(popup.items[1])
	if isnull(user) then
		log.log(this, "load_user()", "User not found (" + popup.items[1] + ")", 4)
		closewithreturn(this, popup_return)
		return
	end if
	st_title.text = wordcap(user.actor_class)
	st_title.text += " - " + user.user_full_name
	
	li_sts = user.get_addresses( )
	if li_sts < 0 then
		log.log(this, "open", "Error getting user addresses (" + user.user_id + ")", 4)
		closewithreturn(this, popup_return)
		return
	end if
	
	li_sts = user.get_communications( )
	if li_sts < 0 then
		log.log(this, "open", "Error getting user communications (" + user.user_id + ")", 4)
		closewithreturn(this, popup_return)
		return
	end if
end if

if not current_scribe.check_privilege("Audit") then
	tab_user.tabpage_user_audit.visible = false
end if

li_first_tab = tab_user.initialize(user)
if li_first_tab <= 0 then
	log.log(this, "open", "Error initializing user (" + user.user_id + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

f_log_security_event("Edit User", "Success", user.user_id)

tab_user.function post selecttab(li_first_tab)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_user_definition
integer x = 2875
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_user_definition
end type

type tab_user from u_tab_user_profile within w_user_definition
integer y = 96
integer width = 2926
integer height = 1456
integer taborder = 20
boolean bringtotop = true
long backcolor = 33538240
boolean raggedright = false
end type

type cb_ok from commandbutton within w_user_definition
integer x = 2331
integer y = 1612
integer width = 544
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;str_popup_return		popup_return
Integer					li_sts


popup_return.item_count = 1
popup_return.items[1] = user.user_id
popup_return.descriptions[1] = user.user_full_name
Closewithreturn(Parent, popup_return)


end event

type st_title from statictext within w_user_definition
integer width = 2926
integer height = 96
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "User Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

