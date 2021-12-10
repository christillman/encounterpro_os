$PBExportHeader$u_param_observation_result_2.sru
forward
global type u_param_observation_result_2 from u_param_base
end type
type st_observation from statictext within u_param_observation_result_2
end type
type st_result from statictext within u_param_observation_result_2
end type
type st_result_title from statictext within u_param_observation_result_2
end type
type st_observation_title from statictext within u_param_observation_result_2
end type
end forward

global type u_param_observation_result_2 from u_param_base
st_observation st_observation
st_result st_result
st_result_title st_result_title
st_observation_title st_observation_title
end type
global u_param_observation_result_2 u_param_observation_result_2

type variables
string  param_value

string observation_id
integer result_sequence

string result_type


end variables

forward prototypes
public function integer check_required ()
public function integer x_initialize ()
public function integer pick_param ()
public function integer pick_observation ()
public function integer pick_result ()
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
	If Isnull(observation_id) Then
		Openwithparm(w_pop_message,"Please select an observation and a result")
		Return -1
	End if
	If Isnull(result_sequence) Then
		Openwithparm(w_pop_message,"Please select a result")
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

string ls_initial_value
string ls_left
string ls_right

ls_initial_value = get_initial_value(1)

result_type = f_attribute_find_attribute2(param_wizard.attributes, "result_type", param_wizard.params.id)
if isnull(result_type) then
	if len(param_wizard.params.params[param_index].query) > 0 then
		result_type = param_wizard.params.params[param_index].query
	else
		result_type = "PERFORM"
	end if
end if

if len(ls_initial_value) > 0 then
	f_split_string(ls_initial_value, "|", ls_left, ls_right)
	if isnumber(ls_right) then
		observation_id = ls_left
		result_sequence = integer(ls_right)
		param_value = ls_initial_value
	else
		observation_id = f_attribute_find_attribute2(param_wizard.attributes, "observation_id", param_wizard.params.id)
		setnull(result_sequence)
		setnull(param_value)
	end if
else
	observation_id = f_attribute_find_attribute2(param_wizard.attributes, "observation_id", param_wizard.params.id)
	setnull(result_sequence)
	setnull(param_value)
end if


if len(observation_id) > 0 and not preference_in_use then
	SELECT description
	INTO :st_observation.text
	FROM c_Observation
	WHERE observation_id = :observation_id;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		setnull(param_value)
		setnull(observation_id)
		setnull(result_sequence)
		st_observation.text = ""
	end if
end if

if len(observation_id) > 0 and not isnull(result_sequence) and not preference_in_use then
	SELECT result
	INTO :st_result.text
	FROM c_Observation_Result
	WHERE observation_id = :observation_id
	AND result_sequence = :result_sequence;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		setnull(param_value)
		setnull(result_sequence)
		st_result.text = ""
	end if
end if

return 1

end function

public function integer pick_param ();integer li_sts

li_sts = pick_observation()
if li_sts <= 0 then return li_sts

li_sts = pick_result()
if li_sts <= 0 then return li_sts

return 1

end function

public function integer pick_observation ();str_popup popup
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

popup.multiselect = false
popup.items[1] = ls_treatment_type
popup.items[2] = current_user.specialty_id
openwithparm(lw_pick, popup, "w_pick_observations")
lstr_observations = message.powerobjectparm
if lstr_observations.observation_count <> 1 then return 0

ls_display = lstr_observations.description[1]
observation_id = lstr_observations.observation_id[1]

st_observation.text = ls_display

setnull(param_value)
setnull(result_sequence)
st_result.text = ""

return 1

end function

public function integer pick_result ();str_popup popup
str_popup_return popup_return
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_pop_pick lw_pick
string ls_display


if isnull(observation_id) then
	openwithparm(w_pop_message, "First Select an Observation")
	return 0
end if

popup.title = "Select Result"
popup.dataobject = "dw_result_edit_list"
popup.datacolumn = 1
popup.displaycolumn = 3
popup.multiselect = false
popup.argument_count = 2
popup.argument[1] = observation_id
popup.argument[2] = result_type
openwithparm(lw_pick, popup, "w_pop_pick")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_display = popup_return.descriptions[1]
result_sequence = integer(popup_return.items[1])
param_value = observation_id + "|" + popup_return.items[1]

update_param(param_wizard.params.params[param_index].token1, param_value)

st_result.text = ls_display

if st_required.visible and not isnull(param_value) then
	param_wizard.event POST ue_required(true)
end if


return 1

end function

on u_param_observation_result_2.create
int iCurrent
call super::create
this.st_observation=create st_observation
this.st_result=create st_result
this.st_result_title=create st_result_title
this.st_observation_title=create st_observation_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_observation
this.Control[iCurrent+2]=this.st_result
this.Control[iCurrent+3]=this.st_result_title
this.Control[iCurrent+4]=this.st_observation_title
end on

on u_param_observation_result_2.destroy
call super::destroy
destroy(this.st_observation)
destroy(this.st_result)
destroy(this.st_result_title)
destroy(this.st_observation_title)
end on

type st_preference from u_param_base`st_preference within u_param_observation_result_2
integer y = 960
end type

type st_preference_title from u_param_base`st_preference_title within u_param_observation_result_2
integer y = 892
end type

type cb_clear from u_param_base`cb_clear within u_param_observation_result_2
end type

event cb_clear::clicked;call super::clicked;setnull(observation_id)
setnull(result_sequence)
setnull(param_value)

st_observation.text = ""
st_result.text = ""

f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_observation_result_2
integer x = 1358
integer y = 732
end type

type st_helptext from u_param_base`st_helptext within u_param_observation_result_2
end type

type st_title from u_param_base`st_title within u_param_observation_result_2
integer x = 576
integer y = 448
integer width = 1531
integer height = 76
alignment alignment = center!
end type

type st_observation from statictext within u_param_observation_result_2
integer x = 1353
integer y = 604
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

event clicked;pick_observation()

end event

type st_result from statictext within u_param_observation_result_2
integer x = 1353
integer y = 784
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

event clicked;pick_result()
end event

type st_result_title from statictext within u_param_observation_result_2
integer x = 873
integer y = 808
integer width = 448
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Result"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_observation_title from statictext within u_param_observation_result_2
integer x = 873
integer y = 624
integer width = 448
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Observation"
alignment alignment = right!
boolean focusrectangle = false
end type

