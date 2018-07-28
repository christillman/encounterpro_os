HA$PBExportHeader$u_param_patient.sru
forward
global type u_param_patient from u_param_base
end type
type st_popup_values from statictext within u_param_patient
end type
end forward

global type u_param_patient from u_param_base
st_popup_values st_popup_values
end type
global u_param_patient u_param_patient

type variables
string cpr_id


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
	If Isnull(cpr_id) Then
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
string ls_patient_name

cpr_id = get_initial_value(1)

ls_patient_name = sqlca.fn_patient_full_name(cpr_id)

if isnull(ls_patient_name) or preference_in_use then
	ls_display = ""
	setnull(cpr_id)
else
	ls_display = ls_patient_name
end if

st_popup_values.text = ls_display

return 1

end function

public function integer pick_param ();str_popup_return popup_return
string ls_patient_name

open(w_patient_select)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_patient_name = sqlca.fn_patient_full_name(popup_return.items[1])
if isnull(ls_patient_name) then return 0

cpr_id = popup_return.items[1]

update_param(param_wizard.params.params[param_index].token1, cpr_id)

st_popup_values.text = ls_patient_name

if st_required.visible and not isnull(cpr_id) then
	param_wizard.event POST ue_required(true)
end if

return 1

end function

on u_param_patient.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
end on

on u_param_patient.destroy
call super::destroy
destroy(this.st_popup_values)
end on

type st_preference from u_param_base`st_preference within u_param_patient
end type

type st_preference_title from u_param_base`st_preference_title within u_param_patient
end type

type cb_clear from u_param_base`cb_clear within u_param_patient
end type

event cb_clear::clicked;call super::clicked;setnull(cpr_id)
st_popup_values.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_patient
integer x = 1358
integer y = 536
end type

type st_helptext from u_param_base`st_helptext within u_param_patient
end type

type st_title from u_param_base`st_title within u_param_patient
integer x = 46
integer y = 616
integer height = 76
end type

type st_popup_values from statictext within u_param_patient
integer x = 1353
integer y = 596
integer width = 1294
integer height = 120
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

