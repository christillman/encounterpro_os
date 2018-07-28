HA$PBExportHeader$u_tabpage_user_id_numbers.sru
forward
global type u_tabpage_user_id_numbers from u_tabpage_user_base
end type
type cb_add_id from commandbutton within u_tabpage_user_id_numbers
end type
type cb_define_new_id from commandbutton within u_tabpage_user_id_numbers
end type
type dw_id_numbers from u_dw_pick_list within u_tabpage_user_id_numbers
end type
type st_title from statictext within u_tabpage_user_id_numbers
end type
end forward

global type u_tabpage_user_id_numbers from u_tabpage_user_base
string tag = "All"
integer width = 2912
cb_add_id cb_add_id
cb_define_new_id cb_define_new_id
dw_id_numbers dw_id_numbers
st_title st_title
end type
global u_tabpage_user_id_numbers u_tabpage_user_id_numbers

type variables
string erx_component_id = "E-Prescribing"

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize ()
public function integer set_id_number (long pl_row)
end prototypes

public subroutine refresh ();
if user_list.is_user_privileged(current_scribe.user_id, "Practice Configuration") and config_mode then
	cb_define_new_id.visible = true
else
	cb_define_new_id.visible = false
end if

if user_list.is_user_privileged(current_scribe.user_id, "Practice Configuration") then
	cb_add_id.visible = true
else
	cb_add_id.visible = false
end if

dw_id_numbers.settransobject(sqlca)
dw_id_numbers.retrieve(user.user_id)


end subroutine

public function integer initialize ();dw_id_numbers.width = 2665
dw_id_numbers.x = (width - dw_id_numbers.width) / 2

st_title.x = dw_id_numbers.x
st_title.y = 0
st_title.width = dw_id_numbers.width - 100
st_title.height = 88

cb_define_new_id.width = 512
cb_define_new_id.height = 88
cb_define_new_id.x = (width / 2) - cb_define_new_id.width - 50
cb_define_new_id.y = height - cb_define_new_id.height - 20

cb_add_id.width = 512
cb_add_id.height = 88
cb_add_id.x = (width / 2) + 50
cb_add_id.y = height - cb_add_id.height - 20

dw_id_numbers.y = st_title.y + st_title.height + 4
dw_id_numbers.height = cb_define_new_id.y - dw_id_numbers.y - 20



return 1

end function

public function integer set_id_number (long pl_row);integer li_sts
string ls_progress_type
string ls_progress_key
string ls_progress_value
string ls_display_key
string ls_owner_description
string ls_new_value
long ll_owner_id
str_popup popup
str_popup_return popup_return

ls_progress_type = dw_id_numbers.object.progress_type[pl_row]
ls_progress_key = dw_id_numbers.object.progress_key[pl_row]
ls_progress_value = dw_id_numbers.object.progress_value[pl_row]
ll_owner_id = dw_id_numbers.object.owner_id[pl_row]
ls_display_key = dw_id_numbers.object.display_key[pl_row]
ls_owner_description = dw_id_numbers.object.owner_description[pl_row]

if isnull(ll_owner_id) or ll_owner_id <> sqlca.customer_id then
	openwithparm(w_pop_yes_no, "This " + ls_display_key + " is needed for the interface with " + ls_owner_description + " and modifying it may adversly impact the interface.  Are you sure you wish to modify this ID?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 0
end if

popup.title = "Enter " + ls_display_key
popup.displaycolumn = 40
popup.item = ls_progress_value
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0
ls_new_value = popup_return.items[1]

li_sts = user_list.set_user_progress( user.user_id, &
												ls_progress_type, &
												ls_progress_key, &
												ls_new_value)
if li_sts <= 0 then return -1


CHOOSE CASE lower(ls_progress_key)
	CASE "dea_number"
		user.dea_number = ls_new_value
	CASE "license_number"
		user.license_number = ls_new_value
	CASE "certification_number"
		user.certification_number = ls_new_value
	CASE "upin"
		user.upin = ls_new_value
	CASE "npi"
		user.npi = ls_new_value
END CHOOSE

return 1

end function

on u_tabpage_user_id_numbers.create
int iCurrent
call super::create
this.cb_add_id=create cb_add_id
this.cb_define_new_id=create cb_define_new_id
this.dw_id_numbers=create dw_id_numbers
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add_id
this.Control[iCurrent+2]=this.cb_define_new_id
this.Control[iCurrent+3]=this.dw_id_numbers
this.Control[iCurrent+4]=this.st_title
end on

on u_tabpage_user_id_numbers.destroy
call super::destroy
destroy(this.cb_add_id)
destroy(this.cb_define_new_id)
destroy(this.dw_id_numbers)
destroy(this.st_title)
end on

type cb_add_id from commandbutton within u_tabpage_user_id_numbers
integer x = 1646
integer y = 1340
integer width = 512
integer height = 88
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add ID"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_owner_id
string ls_owner_id
string ls_IDDomain
long ll_count
string ls_id_name
string ls_id_value
string ls_progress_key

popup.title = "Enter ID Owner"
popup.displaycolumn = 32
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_owner_id = trim(popup_return.items[1])

popup.title = "Enter ID Name"
popup.displaycolumn = 32
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_id_name = popup_return.items[1]

if isnull(ls_id_name) or trim(ls_id_name) = "" then return

if pos(ls_id_name, "^") > 0 then
	openwithparm(w_pop_message, "That caret character (^) is not allowed in a user ID")
	return
end if

popup.title = "Enter ID Value"
popup.displaycolumn = 40
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_id_value = popup_return.items[1]

if isnull(ls_id_value) or trim(ls_id_value) = "" then return

ls_progress_key = ls_owner_id + "^" + ls_id_name

user_list.set_user_progress( current_user.user_id, &
									"ID", &
									ls_progress_key, &
									ls_id_value)

refresh()

end event

type cb_define_new_id from commandbutton within u_tabpage_user_id_numbers
integer x = 937
integer y = 1352
integer width = 512
integer height = 88
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Define New ID"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_owner_id
string ls_owner_id
string ls_IDDomain
long ll_count
string ls_id_name

popup.title = "Enter name of new user ID"
popup.displaycolumn = 32
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_id_name = popup_return.items[1]

if isnull(ls_id_name) or trim(ls_id_name) = "" then return

if pos(ls_id_name, "^") > 0 then
	openwithparm(w_pop_message, "That caret character (^) is not allowed in a user ID")
	return
end if
	

SELECT count(*)
INTO :ll_count
FROM c_Domain
WHERE domain_id = 'User ID'
AND domain_item = :ls_id_name;
if not tf_check() then return

if ll_count > 0 then
	openwithparm(w_pop_message, "That user ID already exists")
	return
end if

openwithparm(w_pop_yes_no, "This operation will create a new ID field for every user.  The new ID will be called ~"" + ls_id_name + "~".  Are you sure you want to do this?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

SELECT max(domain_sequence) + 1
INTO :ll_count
FROM c_Domain
WHERE domain_id = 'User ID';
if not tf_check() then return

IF isnull(ll_count) then ll_count = 1

INSERT INTO c_Domain (
	domain_id,
	domain_sequence,
	domain_item)
VALUES (
	'User ID',
	:ll_count,
	:ls_id_name);
if not tf_check() then return

refresh()

end event

type dw_id_numbers from u_dw_pick_list within u_tabpage_user_id_numbers
integer x = 91
integer y = 92
integer width = 2665
integer height = 1328
integer taborder = 10
string dataobject = "dw_jmj_get_user_id_numbers"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;integer li_sts


li_sts = set_id_number(selected_row)
if li_sts > 0 then
	refresh()
else
	clear_selected()
end if



end event

type st_title from statictext within u_tabpage_user_id_numbers
integer x = 91
integer width = 2578
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Identification Numbers"
alignment alignment = center!
boolean focusrectangle = false
end type

