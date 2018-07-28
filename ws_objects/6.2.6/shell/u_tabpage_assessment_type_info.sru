HA$PBExportHeader$u_tabpage_assessment_type_info.sru
forward
global type u_tabpage_assessment_type_info from u_tabpage
end type
type cb_location_domain_clear from commandbutton within u_tabpage_assessment_type_info
end type
type st_default_bill_flag from statictext within u_tabpage_assessment_type_info
end type
type st_status from statictext within u_tabpage_assessment_type_info
end type
type st_status_title from statictext within u_tabpage_assessment_type_info
end type
type st_soap_display_rule_title from statictext within u_tabpage_assessment_type_info
end type
type st_soap_display_rule from statictext within u_tabpage_assessment_type_info
end type
type st_complexity from statictext within u_tabpage_assessment_type_info
end type
type st_complexity_title from statictext within u_tabpage_assessment_type_info
end type
type st_in_office_flag from statictext within u_tabpage_assessment_type_info
end type
type st_in_office_flag_title from statictext within u_tabpage_assessment_type_info
end type
type st_title_assessment_type from statictext within u_tabpage_assessment_type_info
end type
type st_assessment_type from statictext within u_tabpage_assessment_type_info
end type
type st_button_title from statictext within u_tabpage_assessment_type_info
end type
type st_button from statictext within u_tabpage_assessment_type_info
end type
type st_default_bill_flag_title from statictext within u_tabpage_assessment_type_info
end type
type st_1 from statictext within u_tabpage_assessment_type_info
end type
type sle_description from singlelineedit within u_tabpage_assessment_type_info
end type
end forward

global type u_tabpage_assessment_type_info from u_tabpage
integer width = 2839
integer height = 1292
cb_location_domain_clear cb_location_domain_clear
st_default_bill_flag st_default_bill_flag
st_status st_status
st_status_title st_status_title
st_soap_display_rule_title st_soap_display_rule_title
st_soap_display_rule st_soap_display_rule
st_complexity st_complexity
st_complexity_title st_complexity_title
st_in_office_flag st_in_office_flag
st_in_office_flag_title st_in_office_flag_title
st_title_assessment_type st_title_assessment_type
st_assessment_type st_assessment_type
st_button_title st_button_title
st_button st_button
st_default_bill_flag_title st_default_bill_flag_title
st_1 st_1
sle_description sle_description
end type
global u_tabpage_assessment_type_info u_tabpage_assessment_type_info

type variables
string assessment_type
string status
string default_bill_flag
string in_office_flag
long complexity
end variables
forward prototypes
public function integer initialize (string ps_key)
end prototypes

public function integer initialize (string ps_key);string ls_description
string ls_button
string ls_icon_open
string ls_icon_closed
string ls_soap_display_rule
string ls_well_encounter_flag
		
assessment_type = ps_key

st_assessment_type.text = ps_key

SELECT description,
      button,
      icon_open,
      icon_closed,
      default_bill_flag,
      in_office_flag,
      status,
      complexity,
      soap_display_rule,
      well_encounter_flag
INTO :ls_description,
		:ls_button,
		:ls_icon_open,
		:ls_icon_closed,
		:default_bill_flag,
		:in_office_flag,
		:status,
		:complexity,
		:ls_soap_display_rule,
		:ls_well_encounter_flag
FROM dbo.c_Assessment_Type
WHERE assessment_type = :assessment_type;
if not tf_check() then return -1

sle_description.text = ls_description

st_button.text = ls_icon_open

if upper(default_bill_flag) = "Y" then
	st_default_bill_flag.text = "Yes"
	default_bill_flag = "Y"
else
	st_default_bill_flag.text = "No"
	default_bill_flag = "N"
end if

if upper(in_office_flag) = "Y" then
	st_in_office_flag.text = "Yes"
	in_office_flag = "Y"
else
	st_in_office_flag.text = "No"
	in_office_flag = "N"
end if

st_complexity.text = string(complexity)

st_soap_display_rule.text = ls_soap_display_rule


//
//sle_icd9.text = icd_9_code
//
//f_set_risk_level(em_risk_level,:ls_desc,:ls_icon)
//st_risk_level.text = :ls_desc
//if isnull(:ls_icon) then 
//	p_risk_level.visible = false
//else
//	p_risk_level.visible = true
//	p_risk_level.picturename = :ls_icon
//end if
//
//if isnull(complexity) then
//	st_complexity.text = "N/A"
//else
//	st_complexity.text = string(complexity)
//end if
//
//if isnull(location_domain) then
//	st_location_domain.text = "N/A"
//	cb_location_domain_clear.visible = false
//else
//	st_location_domain.text = datalist.location_domain_description(location_domain)
//	cb_location_domain_clear.visible = true
//end if
//
//lstr_patient_material = f_get_patient_material(patient_reference_material_id, false)
//if len(lstr_patient_material.title) > 0 then
//	st_patient_reference_material.text = lstr_patient_material.title
//else
//	st_patient_reference_material.text = "N/A"
//end if
//
//lstr_patient_material = f_get_patient_material(provider_reference_material_id, false)
//if len(lstr_patient_material.title) > 0 then
//	st_provider_reference_material.text = lstr_patient_material.title
//else
//	st_provider_reference_material.text = "N/A"
//end if
//
//st_assessment_id.text = assessment_id
//

if upper(status) = "OK" then
	st_status.text = "Active"
	status = "OK"
else
	st_status.text = "Inactive"
	status = "NA"
end if


return 1

end function

on u_tabpage_assessment_type_info.create
int iCurrent
call super::create
this.cb_location_domain_clear=create cb_location_domain_clear
this.st_default_bill_flag=create st_default_bill_flag
this.st_status=create st_status
this.st_status_title=create st_status_title
this.st_soap_display_rule_title=create st_soap_display_rule_title
this.st_soap_display_rule=create st_soap_display_rule
this.st_complexity=create st_complexity
this.st_complexity_title=create st_complexity_title
this.st_in_office_flag=create st_in_office_flag
this.st_in_office_flag_title=create st_in_office_flag_title
this.st_title_assessment_type=create st_title_assessment_type
this.st_assessment_type=create st_assessment_type
this.st_button_title=create st_button_title
this.st_button=create st_button
this.st_default_bill_flag_title=create st_default_bill_flag_title
this.st_1=create st_1
this.sle_description=create sle_description
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_location_domain_clear
this.Control[iCurrent+2]=this.st_default_bill_flag
this.Control[iCurrent+3]=this.st_status
this.Control[iCurrent+4]=this.st_status_title
this.Control[iCurrent+5]=this.st_soap_display_rule_title
this.Control[iCurrent+6]=this.st_soap_display_rule
this.Control[iCurrent+7]=this.st_complexity
this.Control[iCurrent+8]=this.st_complexity_title
this.Control[iCurrent+9]=this.st_in_office_flag
this.Control[iCurrent+10]=this.st_in_office_flag_title
this.Control[iCurrent+11]=this.st_title_assessment_type
this.Control[iCurrent+12]=this.st_assessment_type
this.Control[iCurrent+13]=this.st_button_title
this.Control[iCurrent+14]=this.st_button
this.Control[iCurrent+15]=this.st_default_bill_flag_title
this.Control[iCurrent+16]=this.st_1
this.Control[iCurrent+17]=this.sle_description
end on

on u_tabpage_assessment_type_info.destroy
call super::destroy
destroy(this.cb_location_domain_clear)
destroy(this.st_default_bill_flag)
destroy(this.st_status)
destroy(this.st_status_title)
destroy(this.st_soap_display_rule_title)
destroy(this.st_soap_display_rule)
destroy(this.st_complexity)
destroy(this.st_complexity_title)
destroy(this.st_in_office_flag)
destroy(this.st_in_office_flag_title)
destroy(this.st_title_assessment_type)
destroy(this.st_assessment_type)
destroy(this.st_button_title)
destroy(this.st_button)
destroy(this.st_default_bill_flag_title)
destroy(this.st_1)
destroy(this.sle_description)
end on

type cb_location_domain_clear from commandbutton within u_tabpage_assessment_type_info
integer x = 1321
integer y = 840
integer width = 238
integer height = 68
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;//
//setnull(location_domain)
//st_location_domain.text = "N/A"
//visible = false
//
//
//
end event

type st_default_bill_flag from statictext within u_tabpage_assessment_type_info
integer x = 686
integer y = 508
integer width = 411
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if status = "OK" then
	status = "NA"
	text = "Inactive"
else
	status = "OK"
	text = "Active"
end if

end event

type st_status from statictext within u_tabpage_assessment_type_info
integer x = 686
integer y = 1100
integer width = 411
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if status = "OK" then
	status = "NA"
	text = "Inactive"
else
	status = "OK"
	text = "Active"
end if

end event

type st_status_title from statictext within u_tabpage_assessment_type_info
integer x = 119
integer y = 1116
integer width = 526
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

type st_soap_display_rule_title from statictext within u_tabpage_assessment_type_info
integer x = 64
integer y = 968
integer width = 581
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "SOAP Display Rule:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_soap_display_rule from statictext within u_tabpage_assessment_type_info
integer x = 686
integer y = 952
integer width = 946
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;//str_popup_return popup_return
//
//openwithparm(w_pick_location_domain, location_domain)
//popup_return = message.powerobjectparm
//if popup_return.item_count <> 1 then return
//
//location_domain = popup_return.items[1]
//text = datalist.location_domain_description(location_domain)
//
//cb_location_domain_clear.visible = true
//
//
end event

type st_complexity from statictext within u_tabpage_assessment_type_info
integer x = 686
integer y = 804
integer width = 622
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;//str_popup popup
//str_popup_return popup_return
//
//popup.realitem = real(complexity)
//openwithparm(w_number, popup)
//popup_return = message.powerobjectparm
//if popup_return.item <> "OK" then return
//
//complexity = integer(popup_return.realitem)
//text = string(complexity)
//
//
//
end event

type st_complexity_title from statictext within u_tabpage_assessment_type_info
integer x = 197
integer y = 820
integer width = 448
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

type st_in_office_flag from statictext within u_tabpage_assessment_type_info
integer x = 686
integer y = 656
integer width = 411
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;//string ls_desc,ls_icon
//
//f_get_risk_level(em_risk_level,ls_desc)
//text = ls_desc
//f_set_risk_level(em_risk_level,ls_desc,ls_icon)
//if isnull(ls_icon) then
//	p_risk_level.visible = false
//else
//	p_risk_level.visible = true
//	p_risk_level.picturename = ls_icon
//end if
end event

type st_in_office_flag_title from statictext within u_tabpage_assessment_type_info
integer x = 46
integer y = 672
integer width = 599
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "In Office Flag:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title_assessment_type from statictext within u_tabpage_assessment_type_info
integer x = 110
integer y = 100
integer width = 535
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Assessment Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_assessment_type from statictext within u_tabpage_assessment_type_info
integer x = 686
integer y = 88
integer width = 946
integer height = 104
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
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_assessment_type_list"
popup.datacolumn = 1
popup.displaycolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

assessment_type = popup_return.items[1]
text = popup_return.descriptions[1]

end event

type st_button_title from statictext within u_tabpage_assessment_type_info
integer x = 247
integer y = 392
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Button:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_button from statictext within u_tabpage_assessment_type_info
integer x = 686
integer y = 376
integer width = 946
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;//str_popup popup
//str_popup_return popup_return
//
//popup.dataobject = "dw_assessment_category_list"
//popup.datacolumn = 1
//popup.displaycolumn = 2
//popup.argument_count = 2
//popup.argument[1] = current_user.common_list_id()
//popup.argument[2] = assessment_type
//
//openwithparm(w_pop_pick, popup)
//popup_return = message.powerobjectparm
//if popup_return.item_count = 1 then
//	assessment_category_id = popup_return.items[1]
//	text = popup_return.descriptions[1]
//end if
//
//
end event

type st_default_bill_flag_title from statictext within u_tabpage_assessment_type_info
integer x = 46
integer y = 528
integer width = 599
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Default Bill Flag:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within u_tabpage_assessment_type_info
integer x = 247
integer y = 244
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_description from singlelineedit within u_tabpage_assessment_type_info
integer x = 686
integer y = 236
integer width = 1495
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
boolean displayonly = true
borderstyle borderstyle = StyleBox!
end type

event modified;//description = text

end event

