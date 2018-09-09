$PBExportHeader$u_param_display_script.sru
forward
global type u_param_display_script from u_param_base
end type
type st_popup_values from statictext within u_param_display_script
end type
type cb_edit_display_script from commandbutton within u_param_display_script
end type
end forward

global type u_param_display_script from u_param_base
st_popup_values st_popup_values
cb_edit_display_script cb_edit_display_script
end type
global u_param_display_script u_param_display_script

type variables
str_display_script display_script

end variables

forward prototypes
public function integer check_required ()
public function integer x_initialize ()
public function integer pick_param ()
end prototypes

public function integer check_required ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer [ -1 - required column missing  1 - validation success
//
//	Description: validates whether it's required column
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/15/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
if upper(param_wizard.params.params[param_index].required_flag) = "Y" then
	If Isnull(display_script.display_script_id) Then
		Openwithparm(w_pop_message,"Please enter a " + st_title.text)
		Return -1
	End if
End If

Return 1

end function

public function integer x_initialize ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer
//
// Description:initialize the attribute
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/15/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

string ls_display
string ls_initial_value
integer li_sts
long ll_display_script_id
ls_initial_value = get_initial_value(1)

cb_edit_display_script.enabled = false

ll_display_script_id = long(ls_initial_value)
if ll_display_script_id > 0  and not preference_in_use then
	li_sts = datalist.display_script(ll_display_script_id, display_script)
	if li_sts > 0 then
		st_popup_values.text = display_script.context_object + " " + display_script.description
		cb_edit_display_script.enabled = true
	else
		setnull(display_script.display_script_id)
		st_popup_values.text = ""
	end if
else
	setnull(display_script.display_script_id)
	st_popup_values.text = ""
end if

return 1

end function

public function integer pick_param ();str_popup popup
w_pick_display_script lw_pick
string ls_context_object
long ll_display_script_id
integer li_sts
string ls_parent_config_object_id

ls_parent_config_object_id = f_attribute_find_attribute2(param_wizard.state_attributes, "parent_config_object_id", param_wizard.params.id)
ls_context_object = f_attribute_find_attribute2(param_wizard.attributes, "context_object", param_wizard.params.id)
if isnull(ls_context_object) then
	ls_context_object = f_attribute_find_attribute2(param_wizard.state_attributes, "context_object", param_wizard.params.id)
end if

popup.data_row_count = 4
popup.items[1] = ls_context_object
popup.items[2] = "PICK"
popup.items[3] = "RTF"
popup.items[4] = ls_parent_config_object_id
Openwithparm(lw_pick, popup, "w_pick_display_script")
ll_display_script_id = message.doubleparm
if isnull(ll_display_script_id) then return 0

li_sts = datalist.display_script(ll_display_script_id, display_script)
if li_sts > 0 then
	cb_edit_display_script.enabled = true
	st_popup_values.text = display_script.context_object + " " + display_script.description

	update_param(param_wizard.params.params[param_index].token1, string(ll_display_script_id))
else
	cb_edit_display_script.enabled = false
	setnull(display_script.display_script_id)
	st_popup_values.text = ""
end if

return 1

end function

on u_param_display_script.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
this.cb_edit_display_script=create cb_edit_display_script
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
this.Control[iCurrent+2]=this.cb_edit_display_script
end on

on u_param_display_script.destroy
call super::destroy
destroy(this.st_popup_values)
destroy(this.cb_edit_display_script)
end on

type st_preference from u_param_base`st_preference within u_param_display_script
end type

type st_preference_title from u_param_base`st_preference_title within u_param_display_script
end type

type cb_clear from u_param_base`cb_clear within u_param_display_script
end type

event cb_clear::clicked;call super::clicked;setnull(display_script.display_script_id)
st_popup_values.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )

cb_edit_display_script.enabled = false

end event

type st_required from u_param_base`st_required within u_param_display_script
integer x = 1358
integer y = 536
end type

type st_helptext from u_param_base`st_helptext within u_param_display_script
end type

type st_title from u_param_base`st_title within u_param_display_script
integer x = 46
integer y = 616
integer height = 76
end type

type st_popup_values from statictext within u_param_display_script
integer x = 1353
integer y = 596
integer width = 1294
integer height = 192
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = " "
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;pick_param()
end event

type cb_edit_display_script from commandbutton within u_param_display_script
integer x = 1833
integer y = 804
integer width = 297
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit"
end type

event clicked;w_window_base lw_edit_window
str_popup popup
string ls_id
string ls_parent_config_object_id

ls_parent_config_object_id = f_attribute_find_attribute2(param_wizard.state_attributes, "parent_config_object_id", param_wizard.params.id)

if isnull(display_script.display_script_id) or display_script.display_script_id <= 0 then return

SELECT CAST(id AS varchar(40))
INTO :ls_id
FROM c_Display_Script
WHERE display_script_id = :display_script.display_script_id;
if not tf_check() then return
if sqlca.sqlcode = 100 then return

popup.data_row_count = 3
popup.items[1] = string(display_script.display_script_id)
popup.items[2] = "true"
popup.items[3] = ls_parent_config_object_id

openwithparm(lw_edit_window, popup, "w_display_script_config")

end event

