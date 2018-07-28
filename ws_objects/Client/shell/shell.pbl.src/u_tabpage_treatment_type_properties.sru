$PBExportHeader$u_tabpage_treatment_type_properties.sru
forward
global type u_tabpage_treatment_type_properties from u_tabpage
end type
type st_dup_check_title from statictext within u_tabpage_treatment_type_properties
end type
type st_default_duplicate_check_days from statictext within u_tabpage_treatment_type_properties
end type
type st_complexity from statictext within u_tabpage_treatment_type_properties
end type
type st_complexity_title from statictext within u_tabpage_treatment_type_properties
end type
type st_status from statictext within u_tabpage_treatment_type_properties
end type
type st_status_title from statictext within u_tabpage_treatment_type_properties
end type
type st_soap_display_rule_title from statictext within u_tabpage_treatment_type_properties
end type
type st_soap_display_rule from statictext within u_tabpage_treatment_type_properties
end type
type st_1 from statictext within u_tabpage_treatment_type_properties
end type
type st_workplan_cancel_title from statictext within u_tabpage_treatment_type_properties
end type
type st_workplan_cancel_flag from statictext within u_tabpage_treatment_type_properties
end type
type st_workplan_close_title from statictext within u_tabpage_treatment_type_properties
end type
type st_workplan_close_flag from statictext within u_tabpage_treatment_type_properties
end type
type p_risk_level from picture within u_tabpage_treatment_type_properties
end type
type st_risk from statictext within u_tabpage_treatment_type_properties
end type
type st_risk_level from statictext within u_tabpage_treatment_type_properties
end type
type st_observation_type_title from statictext within u_tabpage_treatment_type_properties
end type
type st_observation_type from statictext within u_tabpage_treatment_type_properties
end type
type st_component_title from statictext within u_tabpage_treatment_type_properties
end type
type st_component_id from statictext within u_tabpage_treatment_type_properties
end type
type st_in_office_title from statictext within u_tabpage_treatment_type_properties
end type
type st_in_office_flag from statictext within u_tabpage_treatment_type_properties
end type
type st_followup_flag_title from statictext within u_tabpage_treatment_type_properties
end type
type st_followup_flag from statictext within u_tabpage_treatment_type_properties
end type
end forward

global type u_tabpage_treatment_type_properties from u_tabpage
integer width = 2802
integer height = 1228
st_dup_check_title st_dup_check_title
st_default_duplicate_check_days st_default_duplicate_check_days
st_complexity st_complexity
st_complexity_title st_complexity_title
st_status st_status
st_status_title st_status_title
st_soap_display_rule_title st_soap_display_rule_title
st_soap_display_rule st_soap_display_rule
st_1 st_1
st_workplan_cancel_title st_workplan_cancel_title
st_workplan_cancel_flag st_workplan_cancel_flag
st_workplan_close_title st_workplan_close_title
st_workplan_close_flag st_workplan_close_flag
p_risk_level p_risk_level
st_risk st_risk
st_risk_level st_risk_level
st_observation_type_title st_observation_type_title
st_observation_type st_observation_type
st_component_title st_component_title
st_component_id st_component_id
st_in_office_title st_in_office_title
st_in_office_flag st_in_office_flag
st_followup_flag_title st_followup_flag_title
st_followup_flag st_followup_flag
end type
global u_tabpage_treatment_type_properties u_tabpage_treatment_type_properties

type variables
string treatment_type

string component_id
string in_office_flag
string followup_flag
string treatment_button
string treatment_icon
string observation_type
long em_risk_level
long complexity
string workplan_close_flag
string workplan_cancel_flag
string soap_display_rule
long default_duplicate_check_days

string status

end variables

forward prototypes
public subroutine refresh ()
public function integer initialize (string ps_key)
public function integer save_changes ()
end prototypes

public subroutine refresh ();long ll_count
long i
string ls_room_name
string ls_room_id,ls_desc,ls_icon
string ls_description

SELECT description,
		 in_office_flag,
		 followup_flag,
		 button,
		 icon,
		 component_id,
		 observation_type,
		 risk_level,
		 complexity,
		 workplan_close_flag,
		 workplan_cancel_flag,
		 soap_display_rule,
		 status,
		 default_duplicate_check_days
INTO :ls_description,
		:in_office_flag,
		:followup_flag,
		:treatment_button,
		:treatment_icon,
		:component_id,
		:observation_type,
		:em_risk_level,
		:complexity,
		:workplan_close_flag,
		:workplan_cancel_flag,
		:soap_display_rule,
		:status,
		:default_duplicate_check_days
FROM c_treatment_Type
WHERE treatment_type = :treatment_type;
if not tf_check() then return
if sqlca.sqlcode = 100 then
	log.log(this, "load_workplan()", "treatment_type not found (" + treatment_type + ")", 4)
	return
end if

if isnull(component_id) then
	st_component_id.text = ""
else
	SELECT description
	INTO :st_component_id.text
	FROM dbo.fn_components()
	WHERE component_id = :component_id;
	if not tf_check() then return
end if

if isnull(observation_type) then
	st_observation_type.text = "<None>"
else
	st_observation_type.text = observation_type
end if

if workplan_close_flag = "Y" then
	st_workplan_close_flag.text = "Yes"
else
	workplan_close_flag = "N"
	st_workplan_close_flag.text = "No"
end if

if workplan_cancel_flag = "Y" then
	st_workplan_cancel_flag.text = "Yes"
else
	workplan_cancel_flag = "N"
	st_workplan_cancel_flag.text = "No"
end if

if in_office_flag = "Y" then
	st_in_office_flag.text = "Yes"
else
	in_office_flag = "N"
	st_in_office_flag.text = "No"
end if

followup_flag = upper(followup_flag)
if followup_flag = "F" then
	st_followup_flag.text = "Followup"
elseif followup_flag = "R" then
	st_followup_flag.text = "Referral"
else
	followup_flag = "N"
	st_followup_flag.text = "N/A"
end if

st_soap_display_rule.text = soap_display_rule

//changed = false

f_set_risk_level(em_risk_level,ls_desc,ls_icon)
st_risk_level.text = ls_desc
if isnull(ls_icon) then
	p_risk_level.visible = false
else
	p_risk_level.visible = true
	p_risk_level.picturename = ls_icon
end if

if complexity > 0 then
	st_complexity.text = string(complexity)
else
	st_complexity.text = "N/A"
end if

if status = "OK" then
	st_status.text = "Active"
else
	st_status.text = "Inactive"
end if

if default_duplicate_check_days = 1 then
	st_default_duplicate_check_days.text = "1 Day"
elseif default_duplicate_check_days > 1 then
	st_default_duplicate_check_days.text = string(default_duplicate_check_days) + " Days"
else
	st_default_duplicate_check_days.text = "N/A"
end if

return


end subroutine

public function integer initialize (string ps_key);treatment_type = ps_key

return 1

end function

public function integer save_changes ();integer li_sts

UPDATE c_treatment_Type
SET in_office_flag = :in_office_flag,
	followup_flag = :followup_flag,
	button = :treatment_button,
	icon = :treatment_icon,
	component_id = :component_id,
	observation_type = :observation_type,
	risk_level = :em_risk_level,
	complexity = :complexity,
	workplan_close_flag = :workplan_close_flag,
	workplan_cancel_flag = :workplan_cancel_flag,
	soap_display_rule = :soap_display_rule,
	status = :status,
	default_duplicate_check_days = :default_duplicate_check_days
WHERE treatment_type = :treatment_type;
if not tf_check() then return -1

datalist.clear_cache("treatment_types")

return 1

end function

on u_tabpage_treatment_type_properties.create
int iCurrent
call super::create
this.st_dup_check_title=create st_dup_check_title
this.st_default_duplicate_check_days=create st_default_duplicate_check_days
this.st_complexity=create st_complexity
this.st_complexity_title=create st_complexity_title
this.st_status=create st_status
this.st_status_title=create st_status_title
this.st_soap_display_rule_title=create st_soap_display_rule_title
this.st_soap_display_rule=create st_soap_display_rule
this.st_1=create st_1
this.st_workplan_cancel_title=create st_workplan_cancel_title
this.st_workplan_cancel_flag=create st_workplan_cancel_flag
this.st_workplan_close_title=create st_workplan_close_title
this.st_workplan_close_flag=create st_workplan_close_flag
this.p_risk_level=create p_risk_level
this.st_risk=create st_risk
this.st_risk_level=create st_risk_level
this.st_observation_type_title=create st_observation_type_title
this.st_observation_type=create st_observation_type
this.st_component_title=create st_component_title
this.st_component_id=create st_component_id
this.st_in_office_title=create st_in_office_title
this.st_in_office_flag=create st_in_office_flag
this.st_followup_flag_title=create st_followup_flag_title
this.st_followup_flag=create st_followup_flag
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_dup_check_title
this.Control[iCurrent+2]=this.st_default_duplicate_check_days
this.Control[iCurrent+3]=this.st_complexity
this.Control[iCurrent+4]=this.st_complexity_title
this.Control[iCurrent+5]=this.st_status
this.Control[iCurrent+6]=this.st_status_title
this.Control[iCurrent+7]=this.st_soap_display_rule_title
this.Control[iCurrent+8]=this.st_soap_display_rule
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_workplan_cancel_title
this.Control[iCurrent+11]=this.st_workplan_cancel_flag
this.Control[iCurrent+12]=this.st_workplan_close_title
this.Control[iCurrent+13]=this.st_workplan_close_flag
this.Control[iCurrent+14]=this.p_risk_level
this.Control[iCurrent+15]=this.st_risk
this.Control[iCurrent+16]=this.st_risk_level
this.Control[iCurrent+17]=this.st_observation_type_title
this.Control[iCurrent+18]=this.st_observation_type
this.Control[iCurrent+19]=this.st_component_title
this.Control[iCurrent+20]=this.st_component_id
this.Control[iCurrent+21]=this.st_in_office_title
this.Control[iCurrent+22]=this.st_in_office_flag
this.Control[iCurrent+23]=this.st_followup_flag_title
this.Control[iCurrent+24]=this.st_followup_flag
end on

on u_tabpage_treatment_type_properties.destroy
call super::destroy
destroy(this.st_dup_check_title)
destroy(this.st_default_duplicate_check_days)
destroy(this.st_complexity)
destroy(this.st_complexity_title)
destroy(this.st_status)
destroy(this.st_status_title)
destroy(this.st_soap_display_rule_title)
destroy(this.st_soap_display_rule)
destroy(this.st_1)
destroy(this.st_workplan_cancel_title)
destroy(this.st_workplan_cancel_flag)
destroy(this.st_workplan_close_title)
destroy(this.st_workplan_close_flag)
destroy(this.p_risk_level)
destroy(this.st_risk)
destroy(this.st_risk_level)
destroy(this.st_observation_type_title)
destroy(this.st_observation_type)
destroy(this.st_component_title)
destroy(this.st_component_id)
destroy(this.st_in_office_title)
destroy(this.st_in_office_flag)
destroy(this.st_followup_flag_title)
destroy(this.st_followup_flag)
end on

type st_dup_check_title from statictext within u_tabpage_treatment_type_properties
integer x = 9
integer y = 788
integer width = 567
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Duplicate Warning:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_default_duplicate_check_days from statictext within u_tabpage_treatment_type_properties
integer x = 594
integer y = 772
integer width = 581
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Active"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = complexity
popup.title = "Dup Check Days"
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item = "CANCEL" then return

default_duplicate_check_days = popup_return.realitem

if default_duplicate_check_days = 1 then
	st_default_duplicate_check_days.text = "1 Day"
elseif default_duplicate_check_days > 1 then
	st_default_duplicate_check_days.text = string(default_duplicate_check_days) + " Days"
else
	st_default_duplicate_check_days.text = "N/A"
end if

save_changes()

end event

type st_complexity from statictext within u_tabpage_treatment_type_properties
integer x = 594
integer y = 328
integer width = 443
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = complexity
popup.title = "Enter Complexity"
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item = "CANCEL" then return

complexity = popup_return.realitem
text = string(complexity)

save_changes()

end event

type st_complexity_title from statictext within u_tabpage_treatment_type_properties
integer x = 215
integer y = 344
integer width = 361
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Complexity:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_status from statictext within u_tabpage_treatment_type_properties
integer x = 594
integer y = 920
integer width = 288
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Active"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if status = "OK" then
	status = "NA"
	st_status.text = "Inactive"
else
	status = "OK"
	st_status.text = "Active"
end if


save_changes()

end event

type st_status_title from statictext within u_tabpage_treatment_type_properties
integer x = 215
integer y = 936
integer width = 361
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_soap_display_rule_title from statictext within u_tabpage_treatment_type_properties
integer x = 5
integer y = 492
integer width = 571
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Soap Display Rule:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_soap_display_rule from statictext within u_tabpage_treatment_type_properties
integer x = 594
integer y = 476
integer width = 832
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_domain_notranslate_list"
popup.title = "Select SOAP Display Rule"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "SOAP_DISPLAY_RULE"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

soap_display_rule = popup_return.items[1]
text = popup_return.descriptions[1]


save_changes()

end event

type st_1 from statictext within u_tabpage_treatment_type_properties
integer x = 2130
integer y = 128
integer width = 489
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
string text = "Flags"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_workplan_cancel_title from statictext within u_tabpage_treatment_type_properties
integer x = 1952
integer y = 404
integer width = 530
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Workplan Cancel:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_workplan_cancel_flag from statictext within u_tabpage_treatment_type_properties
integer x = 2496
integer y = 388
integer width = 288
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if workplan_cancel_flag = "Y" then
	workplan_cancel_flag = "N"
	text = "No"
else
	workplan_cancel_flag = "Y"
	text = "Yes"
end if

save_changes()

end event

type st_workplan_close_title from statictext within u_tabpage_treatment_type_properties
integer x = 1993
integer y = 280
integer width = 489
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Workplan Close:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_workplan_close_flag from statictext within u_tabpage_treatment_type_properties
integer x = 2496
integer y = 264
integer width = 288
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if workplan_close_flag = "Y" then
	workplan_close_flag = "N"
	text = "No"
else
	workplan_close_flag = "Y"
	text = "Yes"
end if


save_changes()

end event

type p_risk_level from picture within u_tabpage_treatment_type_properties
integer x = 1047
integer y = 196
integer width = 133
integer height = 112
boolean bringtotop = true
boolean originalsize = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_risk from statictext within u_tabpage_treatment_type_properties
integer x = 247
integer y = 196
integer width = 329
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Risk Level:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_risk_level from statictext within u_tabpage_treatment_type_properties
integer x = 594
integer y = 180
integer width = 443
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_desc,ls_icon

f_get_risk_level(em_risk_level,ls_desc)
text = ls_desc
f_set_risk_level(em_risk_level,ls_desc,ls_icon)
if isnull(ls_icon) then
	p_risk_level.visible = false
else
	p_risk_level.visible = true
	p_risk_level.picturename = ls_icon
end if

save_changes()

end event

type st_observation_type_title from statictext within u_tabpage_treatment_type_properties
integer x = 18
integer y = 48
integer width = 558
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Observation Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_observation_type from statictext within u_tabpage_treatment_type_properties
integer x = 594
integer y = 32
integer width = 425
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_bitmap
str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_observation_type_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 1
popup.add_blank_row = true
popup.blank_text = "<None>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

if popup_return.items[1] = "" then
	setnull(observation_type)
	text = "<None>"
else
	observation_type = popup_return.items[1]
	text = popup_return.descriptions[1]
end if


save_changes()

end event

type st_component_title from statictext within u_tabpage_treatment_type_properties
integer x = 137
integer y = 640
integer width = 439
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Component:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_component_id from statictext within u_tabpage_treatment_type_properties
integer x = 594
integer y = 624
integer width = 1152
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_components_of_type_pick_list"
popup.title = "Select Treatment Component"
popup.datacolumn = 1
popup.displaycolumn = 4
popup.argument_count = 2
popup.argument[1] = "TREATMENT"
popup.argument[2] = "TREATMENT"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

component_id = popup_return.items[1]
text = popup_return.descriptions[1]


save_changes()

end event

type st_in_office_title from statictext within u_tabpage_treatment_type_properties
integer x = 2139
integer y = 528
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Office Only:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_in_office_flag from statictext within u_tabpage_treatment_type_properties
integer x = 2496
integer y = 512
integer width = 288
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if in_office_flag = "Y" then
	in_office_flag = "N"
	text = "No"
else
	in_office_flag = "Y"
	text = "Yes"
end if

save_changes()

end event

type st_followup_flag_title from statictext within u_tabpage_treatment_type_properties
integer x = 1865
integer y = 652
integer width = 617
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Followup Workplans:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_followup_flag from statictext within u_tabpage_treatment_type_properties
integer x = 2496
integer y = 636
integer width = 288
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 3
popup.items[1] = "Followup"
popup.items[2] = "Referral"
popup.items[3] = "N/A"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		followup_flag = "F"
		text = "Followup"
	CASE 2
		followup_flag = "R"
		text = "Referral"
	CASE 3
		followup_flag = "N"
		text = "N/A"
END CHOOSE

save_changes()

end event

