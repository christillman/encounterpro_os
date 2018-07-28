$PBExportHeader$u_param_procedure.sru
forward
global type u_param_procedure from u_param_base
end type
type st_popup_values from statictext within u_param_procedure
end type
type cb_configure from commandbutton within u_param_procedure
end type
end forward

global type u_param_procedure from u_param_base
st_popup_values st_popup_values
cb_configure cb_configure
end type
global u_param_procedure u_param_procedure

type variables
string procedure_id
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
	If Isnull(procedure_id) Then
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
string ls_procedure_description
string ls_cpt_code
string ls_category_id
string ls_cat_description
decimal ldc_charge

ls_initial_value = get_initial_value(1)

cb_configure.enabled = false

if len(ls_initial_value) > 0 and not preference_in_use then
	li_sts = tf_get_procedure_detail(ls_initial_value, &
												ls_procedure_description, &
												ls_cpt_code, &
												ls_category_id, &
												ls_cat_description, &
												ldc_charge)
	if li_sts > 0 then
		procedure_id = ls_initial_value
		st_popup_values.text = ls_procedure_description
		cb_configure.enabled = true
	else
		st_popup_values.text = ""
		setnull(procedure_id)
	end if
else
	st_popup_values.text = ""
	setnull(procedure_id)
end if

return 1

end function

public function integer pick_param ();str_popup popup
w_pick_procedures lw_pick
integer li_sts
str_picked_procedures lstr_procedures
string ls_procedure_description
string ls_cpt_code
string ls_category_id
string ls_cat_description
decimal ldc_charge

popup.data_row_count = 1
if len(param_wizard.params.params[param_index].query) > 0 then
	popup.items[1] = param_wizard.params.params[param_index].query
else
	setnull(popup.items[1]) // procedure_type
end if
Openwithparm(lw_pick, popup, "w_pick_procedures")
lstr_procedures = message.powerobjectparm
if lstr_procedures.procedure_count <= 0 then return 0

procedure_id = lstr_procedures.procedures[1].procedure_id
cb_configure.enabled = true
st_popup_values.text = lstr_procedures.procedures[1].description

update_param(param_wizard.params.params[param_index].token1, procedure_id)

return 1

end function

on u_param_procedure.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
this.cb_configure=create cb_configure
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
this.Control[iCurrent+2]=this.cb_configure
end on

on u_param_procedure.destroy
call super::destroy
destroy(this.st_popup_values)
destroy(this.cb_configure)
end on

type st_preference from u_param_base`st_preference within u_param_procedure
end type

type st_preference_title from u_param_base`st_preference_title within u_param_procedure
end type

type cb_clear from u_param_base`cb_clear within u_param_procedure
end type

event cb_clear::clicked;call super::clicked;setnull(procedure_id)
st_popup_values.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )

cb_configure.enabled = false

end event

type st_required from u_param_base`st_required within u_param_procedure
integer x = 1358
integer y = 536
end type

type st_helptext from u_param_base`st_helptext within u_param_procedure
end type

type st_title from u_param_base`st_title within u_param_procedure
integer x = 46
integer y = 616
integer height = 76
end type

type st_popup_values from statictext within u_param_procedure
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

type cb_configure from commandbutton within u_param_procedure
integer x = 1824
integer y = 804
integer width = 347
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Configure"
end type

event clicked;w_window_base lw_edit_window
str_popup popup
str_popup_return popup_return
string ls_procedure_type

SELECT procedure_type
INTO :ls_procedure_type
FROM c_Procedure
WHERE procedure_id = :procedure_id;
if not tf_check() then return



popup.data_row_count = 2
popup.items[1] = ls_procedure_type
popup.items[2] = procedure_id
openwithparm(w_procedure_definition, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 4 then return

procedure_id = popup_return.item
st_popup_values.text = popup_return.items[4]

end event

