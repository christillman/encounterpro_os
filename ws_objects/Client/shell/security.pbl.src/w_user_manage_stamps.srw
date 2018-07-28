$PBExportHeader$w_user_manage_stamps.srw
forward
global type w_user_manage_stamps from w_window_base
end type
type cb_finished from commandbutton within w_user_manage_stamps
end type
type cb_cancel from commandbutton within w_user_manage_stamps
end type
type tab_stamps from u_tab_user_stamps within w_user_manage_stamps
end type
type tab_stamps from u_tab_user_stamps within w_user_manage_stamps
end type
type cb_add_user_stamp from commandbutton within w_user_manage_stamps
end type
end forward

global type w_user_manage_stamps from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
cb_cancel cb_cancel
tab_stamps tab_stamps
cb_add_user_stamp cb_add_user_stamp
end type
global w_user_manage_stamps w_user_manage_stamps

type variables
u_user user

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();
if config_mode and user_list.is_user_privileged(current_scribe.user_id, "Global Preferences") then
	cb_add_user_stamp.visible = true
else
	cb_add_user_stamp.visible = false
end if


return 1

end function

on w_user_manage_stamps.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.cb_cancel=create cb_cancel
this.tab_stamps=create tab_stamps
this.cb_add_user_stamp=create cb_add_user_stamp
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.tab_stamps
this.Control[iCurrent+4]=this.cb_add_user_stamp
end on

on w_user_manage_stamps.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.cb_cancel)
destroy(this.tab_stamps)
destroy(this.cb_add_user_stamp)
end on

event open;call super::open;
user = message.powerobjectparm

title = user.user_full_name

tab_stamps.initialize(user)

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_user_manage_stamps
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_user_manage_stamps
end type

type cb_finished from commandbutton within w_user_manage_stamps
integer x = 2427
integer y = 1612
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
boolean default = true
end type

event clicked;blob lbl_signature_stamp
integer li_sts

li_sts = tab_stamps.save()
if li_sts < 0 then
	openwithparm(w_pop_message, "Error saving user stamps")
	return
end if

close(parent)

end event

type cb_cancel from commandbutton within w_user_manage_stamps
integer x = 69
integer y = 1612
integer width = 402
integer height = 112
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

event clicked;str_popup popup
str_popup_return popup_return

if tab_stamps.any_changes() then
	openwithparm(w_pop_yes_no, "Are you sure you want to exit without saving your changes")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if


close(parent)

end event

type tab_stamps from u_tab_user_stamps within w_user_manage_stamps
integer width = 2921
integer height = 1584
integer taborder = 20
boolean bringtotop = true
end type

type cb_add_user_stamp from commandbutton within w_user_manage_stamps
integer x = 1106
integer y = 1624
integer width = 709
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add User Stamp Type"
end type

event clicked;string ls_user_stamp
str_popup popup
str_popup_return popup_return
long ll_count
long ll_domain_sequence

popup.title = "Enter the name of the new user stamp type"
popup.displaycolumn = 24
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_user_stamp = popup_return.items[1]

SELECT count(*)
INTO :ll_count
FROM c_Domain
WHERE domain_id = 'User Stamp'
AND domain_item = :ls_user_stamp;
if not tf_check() then return

if ll_count > 0 then
	openwithparm(w_pop_message, "The user stamp type ~"" + ls_user_stamp + "~" already exists")
	return
end if

openwithparm(w_pop_yes_no, "Are you sure you want to create a new user stamp type (" + ls_user_stamp + ") ?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

SELECT max(domain_sequence)
INTO :ll_domain_sequence
FROM c_Domain
WHERE domain_id = 'User Stamp';
if not tf_check() then return

if isnull(ll_domain_sequence) or ll_domain_sequence <= 0 then
	ll_domain_sequence = 1
else
	ll_domain_sequence += 1
end if

INSERT INTO c_Domain (
	domain_id,
	domain_sequence,
	domain_item)
VALUES (
	'User Stamp',
	:ll_domain_sequence,
	:ls_user_stamp);
if not tf_check() then return -1

tab_stamps.open_stamp_page(user, ls_user_stamp)

end event

