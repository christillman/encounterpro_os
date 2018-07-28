HA$PBExportHeader$w_observation_tree_attributes.srw
forward
global type w_observation_tree_attributes from w_window_base
end type
type st_child_observation from statictext within w_observation_tree_attributes
end type
type cb_clear_followon from commandbutton within w_observation_tree_attributes
end type
type st_description_title from statictext within w_observation_tree_attributes
end type
type sle_description from singlelineedit within w_observation_tree_attributes
end type
type st_followup_title from statictext within w_observation_tree_attributes
end type
type st_result_2 from statictext within w_observation_tree_attributes
end type
type st_result_2_title from statictext within w_observation_tree_attributes
end type
type st_followon_severity from statictext within w_observation_tree_attributes
end type
type st_location_title from statictext within w_observation_tree_attributes
end type
type st_followon_observation_title from statictext within w_observation_tree_attributes
end type
type st_result_title from statictext within w_observation_tree_attributes
end type
type st_location from statictext within w_observation_tree_attributes
end type
type st_followon_observation from statictext within w_observation_tree_attributes
end type
type st_result from statictext within w_observation_tree_attributes
end type
type st_followon_severity_title from statictext within w_observation_tree_attributes
end type
type st_observation_tag_title from statictext within w_observation_tree_attributes
end type
type st_observation_tag from statictext within w_observation_tree_attributes
end type
type cb_ok from commandbutton within w_observation_tree_attributes
end type
type cb_cancel from commandbutton within w_observation_tree_attributes
end type
type st_edit_service_title from statictext within w_observation_tree_attributes
end type
type st_edit_service from statictext within w_observation_tree_attributes
end type
type st_parent_observation from statictext within w_observation_tree_attributes
end type
type r_followup from rectangle within w_observation_tree_attributes
end type
type st_title from statictext within w_observation_tree_attributes
end type
type st_parent_title from statictext within w_observation_tree_attributes
end type
type st_child_title from statictext within w_observation_tree_attributes
end type
type st_1 from st_config_mode_menu within w_observation_tree_attributes
end type
type st_unit_preference_title from statictext within w_observation_tree_attributes
end type
type st_unit_preference from statictext within w_observation_tree_attributes
end type
type st_on_results_entered from statictext within w_observation_tree_attributes
end type
type st_on_results_entered_title from statictext within w_observation_tree_attributes
end type
end forward

global type w_observation_tree_attributes from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_child_observation st_child_observation
cb_clear_followon cb_clear_followon
st_description_title st_description_title
sle_description sle_description
st_followup_title st_followup_title
st_result_2 st_result_2
st_result_2_title st_result_2_title
st_followon_severity st_followon_severity
st_location_title st_location_title
st_followon_observation_title st_followon_observation_title
st_result_title st_result_title
st_location st_location
st_followon_observation st_followon_observation
st_result st_result
st_followon_severity_title st_followon_severity_title
st_observation_tag_title st_observation_tag_title
st_observation_tag st_observation_tag
cb_ok cb_ok
cb_cancel cb_cancel
st_edit_service_title st_edit_service_title
st_edit_service st_edit_service
st_parent_observation st_parent_observation
r_followup r_followup
st_title st_title
st_parent_title st_parent_title
st_child_title st_child_title
st_1 st_1
st_unit_preference_title st_unit_preference_title
st_unit_preference st_unit_preference
st_on_results_entered st_on_results_entered
st_on_results_entered_title st_on_results_entered_title
end type
global w_observation_tree_attributes w_observation_tree_attributes

type variables
str_observation_tree_branch original_branch
str_observation_tree_branch branch

string location_domain

string result_type

end variables

forward prototypes
public subroutine set_location ()
end prototypes

public subroutine set_location ();
if upper(result_type) = "COLLECT" then
	location_domain = datalist.observation_collection_location_domain(branch.child_observation_id)
else
	location_domain = datalist.observation_perform_location_domain(branch.child_observation_id)
end if

if isnull(location_domain) or location_domain = "NA" then
	st_location.text = "N/A"
	st_location.enabled = false
	st_location.borderstyle = stylebox!
	branch.location = "NA"
else
	st_location.enabled = true
	st_location.borderstyle = styleraised!
	if isnull(branch.location) then
		st_location.text = "<Any>"
	else
		st_location.text = datalist.location_description(branch.location)
	end if
end if


end subroutine

on w_observation_tree_attributes.create
int iCurrent
call super::create
this.st_child_observation=create st_child_observation
this.cb_clear_followon=create cb_clear_followon
this.st_description_title=create st_description_title
this.sle_description=create sle_description
this.st_followup_title=create st_followup_title
this.st_result_2=create st_result_2
this.st_result_2_title=create st_result_2_title
this.st_followon_severity=create st_followon_severity
this.st_location_title=create st_location_title
this.st_followon_observation_title=create st_followon_observation_title
this.st_result_title=create st_result_title
this.st_location=create st_location
this.st_followon_observation=create st_followon_observation
this.st_result=create st_result
this.st_followon_severity_title=create st_followon_severity_title
this.st_observation_tag_title=create st_observation_tag_title
this.st_observation_tag=create st_observation_tag
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_edit_service_title=create st_edit_service_title
this.st_edit_service=create st_edit_service
this.st_parent_observation=create st_parent_observation
this.r_followup=create r_followup
this.st_title=create st_title
this.st_parent_title=create st_parent_title
this.st_child_title=create st_child_title
this.st_1=create st_1
this.st_unit_preference_title=create st_unit_preference_title
this.st_unit_preference=create st_unit_preference
this.st_on_results_entered=create st_on_results_entered
this.st_on_results_entered_title=create st_on_results_entered_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_child_observation
this.Control[iCurrent+2]=this.cb_clear_followon
this.Control[iCurrent+3]=this.st_description_title
this.Control[iCurrent+4]=this.sle_description
this.Control[iCurrent+5]=this.st_followup_title
this.Control[iCurrent+6]=this.st_result_2
this.Control[iCurrent+7]=this.st_result_2_title
this.Control[iCurrent+8]=this.st_followon_severity
this.Control[iCurrent+9]=this.st_location_title
this.Control[iCurrent+10]=this.st_followon_observation_title
this.Control[iCurrent+11]=this.st_result_title
this.Control[iCurrent+12]=this.st_location
this.Control[iCurrent+13]=this.st_followon_observation
this.Control[iCurrent+14]=this.st_result
this.Control[iCurrent+15]=this.st_followon_severity_title
this.Control[iCurrent+16]=this.st_observation_tag_title
this.Control[iCurrent+17]=this.st_observation_tag
this.Control[iCurrent+18]=this.cb_ok
this.Control[iCurrent+19]=this.cb_cancel
this.Control[iCurrent+20]=this.st_edit_service_title
this.Control[iCurrent+21]=this.st_edit_service
this.Control[iCurrent+22]=this.st_parent_observation
this.Control[iCurrent+23]=this.r_followup
this.Control[iCurrent+24]=this.st_title
this.Control[iCurrent+25]=this.st_parent_title
this.Control[iCurrent+26]=this.st_child_title
this.Control[iCurrent+27]=this.st_1
this.Control[iCurrent+28]=this.st_unit_preference_title
this.Control[iCurrent+29]=this.st_unit_preference
this.Control[iCurrent+30]=this.st_on_results_entered
this.Control[iCurrent+31]=this.st_on_results_entered_title
end on

on w_observation_tree_attributes.destroy
call super::destroy
destroy(this.st_child_observation)
destroy(this.cb_clear_followon)
destroy(this.st_description_title)
destroy(this.sle_description)
destroy(this.st_followup_title)
destroy(this.st_result_2)
destroy(this.st_result_2_title)
destroy(this.st_followon_severity)
destroy(this.st_location_title)
destroy(this.st_followon_observation_title)
destroy(this.st_result_title)
destroy(this.st_location)
destroy(this.st_followon_observation)
destroy(this.st_result)
destroy(this.st_followon_severity_title)
destroy(this.st_observation_tag_title)
destroy(this.st_observation_tag)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_edit_service_title)
destroy(this.st_edit_service)
destroy(this.st_parent_observation)
destroy(this.r_followup)
destroy(this.st_title)
destroy(this.st_parent_title)
destroy(this.st_child_title)
destroy(this.st_1)
destroy(this.st_unit_preference_title)
destroy(this.st_unit_preference)
destroy(this.st_on_results_entered)
destroy(this.st_on_results_entered_title)
end on

event open;call super::open;string ls_composite_flag
str_popup_return popup_return

branch = message.powerobjectparm
original_branch = branch

popup_return.item_count = 1
popup_return.items[1] = "ERROR"
popup_return.returnobject = original_branch

st_parent_observation.text = datalist.observation_description(branch.parent_observation_id)
st_child_observation.text = datalist.observation_description(branch.child_observation_id)

if isnull(branch.description) then
	sle_description.text = st_child_observation.text
else
	sle_description.text = branch.description
end if

if isnull(branch.observation_tag) then
	st_observation_tag.text = "N/A"
else
	st_observation_tag.text = branch.observation_tag
end if

if isnull(branch.edit_service) then
	st_edit_service.text = "N/A"
else
	st_edit_service.text = datalist.service_description(branch.edit_service)
end if



if isnull(branch.result_sequence) then
	st_result.text = "<Any>"
else
	SELECT result, result_type
	INTO :st_result.text, :result_type
	FROM c_Observation_Result
	WHERE observation_id = :branch.child_observation_id
	AND result_sequence = :branch.result_sequence;
	if not tf_check() then
		closewithreturn(this, popup_return)
		return
	end if
end if

if isnull(branch.result_sequence_2) then
	st_result_2.text = "N/A"
else
	SELECT result
	INTO :st_result_2.text
	FROM c_Observation_Result
	WHERE observation_id = :branch.child_observation_id
	AND result_sequence = :branch.result_sequence_2;
	if not tf_check() then
		closewithreturn(this, popup_return)
		return
	end if
end if

set_location()

if isnull(branch.followon_severity) then
	st_followon_severity.text = "N/A"
else
	st_followon_severity.text = datalist.domain_item_description("RESULTSEVERITY", string(branch.followon_severity))
end if

if isnull(branch.followon_observation_id) then
	st_followon_observation.text = "N/A"
else
	st_followon_observation.text = datalist.observation_description(branch.followon_observation_id)
end if

CHOOSE CASE upper(branch.unit_preference)
	CASE "ENGLISH"
		st_unit_preference.text = "English"
	CASE "METRIC"
		st_unit_preference.text = "Metric"
	CASE ELSE
		st_unit_preference.text = "N/A"
		setnull(branch.unit_preference)
END CHOOSE

CHOOSE CASE upper(branch.on_results_entered)
	CASE "UP"
		st_on_results_entered.text = "Move Up"
	CASE "NEXT"
		st_on_results_entered.text = "Move Next"
	CASE ELSE
		st_on_results_entered.text = "Don't Move"
		branch.on_results_entered = "None"
END CHOOSE

ls_composite_flag = datalist.observation_composite_flag(branch.child_observation_id)
if ls_composite_flag = "Y" then
	st_result_title.visible = false
	st_result.visible = false
	st_result_2_title.visible = false
	st_result_2.visible = false
	st_location_title.visible = false
	st_location.visible = false
	st_followup_title.visible = false
	r_followup.visible = false
	st_followon_severity_title.visible = false
	st_followon_severity.visible = false
	st_followon_observation_title.visible = false
	st_followon_observation.visible = false
	cb_clear_followon.visible = false
end if
	
end event

type pb_epro_help from w_window_base`pb_epro_help within w_observation_tree_attributes
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_observation_tree_attributes
end type

type st_child_observation from statictext within w_observation_tree_attributes
integer x = 695
integer y = 284
integer width = 2149
integer height = 92
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "child observation"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_clear_followon from commandbutton within w_observation_tree_attributes
integer x = 2185
integer y = 1056
integer width = 251
integer height = 88
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(branch.followon_observation_id)
setnull(branch.followon_severity)

st_followon_observation.text = "N/A"
st_followon_severity.text = "N/A"
end event

type st_description_title from statictext within w_observation_tree_attributes
integer x = 55
integer y = 444
integer width = 805
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Description for this context:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_description from singlelineedit within w_observation_tree_attributes
integer x = 878
integer y = 432
integer width = 1966
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;branch.description = text
end event

type st_followup_title from statictext within w_observation_tree_attributes
integer x = 1170
integer y = 948
integer width = 622
integer height = 64
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Followup Question"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_result_2 from statictext within w_observation_tree_attributes
integer x = 2002
integer y = 604
integer width = 695
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_result_by_type_list"
popup.add_blank_row = true
popup.blank_text = "N/A"
popup.datacolumn = 1
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = branch.child_observation_id

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(branch.result_sequence_2)
	text = "N/A"
else
	branch.result_sequence_2 = integer(popup_return.items[1])
	text = popup_return.descriptions[1]
end if


end event

type st_result_2_title from statictext within w_observation_tree_attributes
integer x = 1385
integer y = 624
integer width = 599
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "2nd Specific Result:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_followon_severity from statictext within w_observation_tree_attributes
integer x = 901
integer y = 1056
integer width = 517
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 1
popup.items[1] = string(branch.followon_severity)

openwithparm(w_pick_result_severity, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

branch.followon_severity = integer(popup_return.items[1])
text = popup_return.descriptions[1]


end event

type st_location_title from statictext within w_observation_tree_attributes
integer x = 731
integer y = 820
integer width = 640
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Specific Location:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_followon_observation_title from statictext within w_observation_tree_attributes
integer x = 485
integer y = 1212
integer width = 379
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Observation:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_result_title from statictext within w_observation_tree_attributes
integer x = 123
integer y = 624
integer width = 485
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Specific Result:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_location from statictext within w_observation_tree_attributes
integer x = 1417
integer y = 800
integer width = 695
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_location_pick"
popup.add_blank_row = true
popup.blank_text = "N/A"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = location_domain

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

branch.location = popup_return.items[1]
text = popup_return.descriptions[1]
if branch.location = "" then setnull(branch.location)

end event

type st_followon_observation from statictext within w_observation_tree_attributes
integer x = 901
integer y = 1192
integer width = 1536
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "NA"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_picked_observations lstr_observations

SELECT min(treatment_type)
INTO :popup.items[1]
FROM c_Observation_Treatment_Type
WHERE observation_id = :branch.child_observation_id;
if not tf_check() then return

popup.data_row_count = 2
popup.items[2] = current_user.specialty_id
popup.multiselect = false
openwithparm(w_pick_observations, popup)
lstr_observations = message.powerobjectparm
if lstr_observations.observation_count <> 1 then return

branch.followon_observation_id = lstr_observations.observation_id[1]
text = lstr_observations.description[1]

end event

type st_result from statictext within w_observation_tree_attributes
integer x = 626
integer y = 604
integer width = 695
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_result_by_type_list"
popup.add_blank_row = true
popup.blank_text = "<Any>"
popup.datacolumn = 1
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = branch.child_observation_id

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(branch.result_sequence)
	text = "<Any>"
else
	branch.result_sequence = integer(popup_return.items[1])
	SELECT result, result_type
	INTO :st_result.text, :result_type
	FROM c_Observation_Result
	WHERE observation_id = :branch.child_observation_id
	AND result_sequence = :branch.result_sequence;
	if not tf_check() then return
	
	set_location()
end if


end event

type st_followon_severity_title from statictext within w_observation_tree_attributes
integer x = 507
integer y = 1076
integer width = 357
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Severity:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_observation_tag_title from statictext within w_observation_tree_attributes
integer x = 82
integer y = 1384
integer width = 521
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Observation Tag:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_observation_tag from statictext within w_observation_tree_attributes
integer x = 622
integer y = 1364
integer width = 695
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.title = "Observation Tag for " + st_child_observation.text
popup.item = branch.observation_tag
popup.argument_count = 1
popup.argument[1] = "BRANCH|OBSERVATION_TAG"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(branch.observation_tag)
else
	branch.observation_tag = popup_return.items[1]
end if

text = popup_return.descriptions[1]


end event

type cb_ok from commandbutton within w_observation_tree_attributes
integer x = 2235
integer y = 1660
integer width = 608
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;str_popup_return popup_return
integer li_sts

popup_return.item_count = 1
popup_return.items[1] = "OK"
popup_return.returnobject = branch

closewithreturn(parent, popup_return)


end event

type cb_cancel from commandbutton within w_observation_tree_attributes
integer x = 64
integer y = 1660
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"
popup_return.returnobject = original_branch

closewithreturn(parent, popup_return)


end event

type st_edit_service_title from statictext within w_observation_tree_attributes
integer x = 1563
integer y = 1384
integer width = 416
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Edit Service:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_edit_service from statictext within w_observation_tree_attributes
integer x = 1998
integer y = 1364
integer width = 695
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.dataobject = "dw_service_for_treatment_workplan"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "N/A"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(branch.edit_service)
else
	branch.edit_service = popup_return.items[1]
end if

text = popup_return.descriptions[1]


end event

type st_parent_observation from statictext within w_observation_tree_attributes
integer x = 695
integer y = 160
integer width = 2149
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "parent observation"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type r_followup from rectangle within w_observation_tree_attributes
integer linethickness = 1
long fillcolor = 33538240
integer x = 430
integer y = 1020
integer width = 2117
integer height = 312
end type

type st_title from statictext within w_observation_tree_attributes
integer width = 2921
integer height = 116
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Observation Parent/Child Attributes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_parent_title from statictext within w_observation_tree_attributes
integer x = 87
integer y = 168
integer width = 590
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Parent Observation:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_child_title from statictext within w_observation_tree_attributes
integer x = 87
integer y = 292
integer width = 590
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Child Observation:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from st_config_mode_menu within w_observation_tree_attributes
integer x = 46
integer y = 1564
boolean bringtotop = true
end type

type st_unit_preference_title from statictext within w_observation_tree_attributes
integer x = 82
integer y = 1524
integer width = 521
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Unit Preference:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_unit_preference from statictext within w_observation_tree_attributes
integer x = 622
integer y = 1504
integer width = 695
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.title = "Unit Preference"
popup.data_row_count = 3
popup.items[1] = "N/A"
popup.items[2] = "English"
popup.items[3] = "Metric"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.descriptions[1]

CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		setnull(branch.unit_preference)
	CASE 2
		branch.unit_preference = "ENGLISH"
	CASE 3
		branch.unit_preference = "METRIC"
END CHOOSE


end event

type st_on_results_entered from statictext within w_observation_tree_attributes
integer x = 1998
integer y = 1504
integer width = 695
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.title = "Unit Preference"
popup.data_row_count = 3
popup.items[1] = "Move Up"
popup.items[2] = "Move Next"
popup.items[3] = "Don't Move"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.descriptions[1]

CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		branch.on_results_entered = "Up"
	CASE 2
		branch.on_results_entered = "Next"
	CASE 3
		branch.on_results_entered = "None"
END CHOOSE


end event

type st_on_results_entered_title from statictext within w_observation_tree_attributes
integer x = 1399
integer y = 1524
integer width = 581
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "On Results Entered:"
alignment alignment = right!
boolean focusrectangle = false
end type

