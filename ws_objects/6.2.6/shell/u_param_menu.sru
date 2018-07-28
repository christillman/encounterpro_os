HA$PBExportHeader$u_param_menu.sru
forward
global type u_param_menu from u_param_base
end type
type st_popup_values from statictext within u_param_menu
end type
type cb_edit_display_script from commandbutton within u_param_menu
end type
end forward

global type u_param_menu from u_param_base
st_popup_values st_popup_values
cb_edit_display_script cb_edit_display_script
end type
global u_param_menu u_param_menu

type variables
string  param_value


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
	If Isnull(param_value) Then
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
string ls_description
long ll_menu_id

ls_initial_value = get_initial_value(1)

ll_menu_id = long(ls_initial_value)

ls_description = datalist.menu_description(ll_menu_id)
if isnull(ls_description) or preference_in_use then
	setnull(param_value)
	ls_display = ""
else
	param_value = ls_initial_value
	ls_display = ls_description
end if

st_popup_values.text = ls_display

return 1

end function

public function integer pick_param ();str_popup_return	popup_return
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_pick_menu lw_pick
string ls_display
string ls_context_object

ls_context_object = f_attribute_find_attribute2(param_wizard.attributes, "context_object", param_wizard.params.id)

openwithparm(lw_pick, ls_context_object, "w_pick_menu")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_display = popup_return.descriptions[1]
param_value = popup_return.items[1]

update_param(param_wizard.params.params[param_index].token1, param_value)

st_popup_values.text = ls_display

if st_required.visible and not isnull(param_value) then
	param_wizard.event POST ue_required(true)
end if

return 1

end function

on u_param_menu.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
this.cb_edit_display_script=create cb_edit_display_script
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
this.Control[iCurrent+2]=this.cb_edit_display_script
end on

on u_param_menu.destroy
call super::destroy
destroy(this.st_popup_values)
destroy(this.cb_edit_display_script)
end on

type st_preference from u_param_base`st_preference within u_param_menu
end type

type st_preference_title from u_param_base`st_preference_title within u_param_menu
end type

type cb_clear from u_param_base`cb_clear within u_param_menu
end type

event cb_clear::clicked;call super::clicked;setnull(param_value)
st_popup_values.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_menu
integer x = 1358
integer y = 536
end type

type st_helptext from u_param_base`st_helptext within u_param_menu
end type

type st_title from u_param_base`st_title within u_param_menu
integer x = 46
integer y = 616
integer height = 76
end type

type st_popup_values from statictext within u_param_menu
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

type cb_edit_display_script from commandbutton within u_param_menu
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
long ll_menu_id
string ls_id

ll_menu_id = long(param_value)
if isnull(ll_menu_id) or ll_menu_id <= 0 then return

SELECT CAST(id AS varchar(40))
INTO :ls_id
FROM c_Menu
WHERE menu_id = :ll_menu_id;
if not tf_check() then return
if sqlca.sqlcode = 100 then return

popup.data_row_count = 2
popup.items[1] = ls_id
popup.items[2] = "true"

openwithparm(lw_edit_window, popup, "w_menu_display")


end event

