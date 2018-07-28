$PBExportHeader$u_param_observation_location_collect.sru
forward
global type u_param_observation_location_collect from u_param_base
end type
type st_popup_values from statictext within u_param_observation_location_collect
end type
end forward

global type u_param_observation_location_collect from u_param_base
st_popup_values st_popup_values
end type
global u_param_observation_location_collect u_param_observation_location_collect

type variables
string  param_value

string observation_id

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

ls_initial_value = get_initial_value(1)

ls_description = datalist.location_description(ls_initial_value)
if isnull(ls_description) or preference_in_use then
	setnull(param_value)
	ls_display = ""
else
	param_value = ls_initial_value
	ls_display = ls_description
end if

st_popup_values.text = ls_display

observation_id = f_attribute_find_attribute2(param_wizard.attributes, "observation_id", param_wizard.params.id)

return 1

end function

public function integer pick_param ();str_popup popup
str_popup_return popup_return
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_pop_pick lw_pick
string ls_display
string ls_location_domain

if isnull(observation_id) then
	openwithparm(w_pop_message, "No Observation Context")
	return 0
end if

SELECT collection_location_domain
INTO :ls_location_domain
FROM c_Observation
WHERE observation_id = :observation_id;
if not tf_check() then return -1


popup.title = "Select Location"
popup.dataobject = "dw_location_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.multiselect = false
popup.argument_count = 1
popup.argument[1] = ls_location_domain
openwithparm(lw_pick, popup, "w_pop_pick")
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

on u_param_observation_location_collect.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
end on

on u_param_observation_location_collect.destroy
call super::destroy
destroy(this.st_popup_values)
end on

type st_preference from u_param_base`st_preference within u_param_observation_location_collect
end type

type st_preference_title from u_param_base`st_preference_title within u_param_observation_location_collect
end type

type cb_clear from u_param_base`cb_clear within u_param_observation_location_collect
end type

event cb_clear::clicked;call super::clicked;setnull(param_value)
st_popup_values.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_observation_location_collect
integer x = 1358
integer y = 536
end type

type st_helptext from u_param_base`st_helptext within u_param_observation_location_collect
end type

type st_title from u_param_base`st_title within u_param_observation_location_collect
integer x = 46
integer y = 616
integer height = 76
end type

type st_popup_values from statictext within u_param_observation_location_collect
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

