$PBExportHeader$u_param_observation_multiple.sru
forward
global type u_param_observation_multiple from u_param_base
end type
type st_popup_values from statictext within u_param_observation_multiple
end type
type st_popup_title from statictext within u_param_observation_multiple
end type
end forward

global type u_param_observation_multiple from u_param_base
st_popup_values st_popup_values
st_popup_title st_popup_title
end type
global u_param_observation_multiple u_param_observation_multiple

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
str_popup popup
string lsa_keys[]
string ls_query
integer li_value_count
string lsa_values[]
integer i
integer j
string ls_display
string ls_initial_value
string ls_description

ls_initial_value = get_initial_value(1)

// parse the ';' seperated data list
li_value_count = f_parse_string(ls_initial_value, ";", lsa_values)

// find the existing observations and add them to the display
ls_display = ""
if not preference_in_use then
	for i = 1 to li_value_count
		ls_description = datalist.observation_description(lsa_values[i])
		if isnull(ls_description) then continue
		if ls_display <> "" then
			param_value += ";"
			ls_display += "~r~n"
		end if
		param_value += lsa_values[i]
		ls_display += ls_description
	next
end if

st_popup_values.text = ls_display

return 1

end function

public function integer pick_param ();str_popup popup
str_picked_observations lstr_observations
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_pick_observations lw_pick
string ls_display

popup.data_row_count = 2
popup.title = "Select Observations"

setnull(ls_treatment_type)

popup.multiselect = true
popup.items[1] = ls_treatment_type
popup.items[2] = current_user.specialty_id
openwithparm(lw_pick, popup, "w_pick_observations")
lstr_observations = message.powerobjectparm
if lstr_observations.observation_count < 1 then return 0

ls_display = ""
param_value = ""
for i = 1 to lstr_observations.observation_count
	ls_observation_id = lstr_observations.observation_id[i]
	ls_description = lstr_observations.description[i]
	
	if i > 1 then param_value += ";"
	param_value += ls_observation_id
	
	if i > 1 then ls_display += "~r~n"
	ls_display += ls_description
next

update_param(param_wizard.params.params[param_index].token1, param_value)

st_popup_values.text = ls_display

if st_required.visible and not isnull(param_value) then
	param_wizard.event POST ue_required(true)
end if


return 1

end function

on u_param_observation_multiple.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
this.st_popup_title=create st_popup_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
this.Control[iCurrent+2]=this.st_popup_title
end on

on u_param_observation_multiple.destroy
call super::destroy
destroy(this.st_popup_values)
destroy(this.st_popup_title)
end on

type st_preference from u_param_base`st_preference within u_param_observation_multiple
end type

type st_preference_title from u_param_base`st_preference_title within u_param_observation_multiple
end type

type cb_clear from u_param_base`cb_clear within u_param_observation_multiple
integer y = 992
end type

event cb_clear::clicked;call super::clicked;setnull(param_value)
st_popup_values.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_observation_multiple
integer x = 1490
integer y = 436
end type

type st_helptext from u_param_base`st_helptext within u_param_observation_multiple
end type

type st_title from u_param_base`st_title within u_param_observation_multiple
integer x = 155
integer y = 500
end type

type st_popup_values from statictext within u_param_observation_multiple
integer x = 1490
integer y = 496
integer width = 1138
integer height = 468
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

type st_popup_title from statictext within u_param_observation_multiple
integer x = 411
integer y = 716
integer width = 1051
integer height = 76
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Click this button to pick values = >"
boolean focusrectangle = false
end type

