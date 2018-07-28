HA$PBExportHeader$u_tabpage_assessment_info.sru
forward
global type u_tabpage_assessment_info from u_tabpage
end type
type cb_equivalence from commandbutton within u_tabpage_assessment_info
end type
type st_status from statictext within u_tabpage_assessment_info
end type
type st_status_title from statictext within u_tabpage_assessment_info
end type
type st_provider_reference_material from statictext within u_tabpage_assessment_info
end type
type st_provider_reference_material_title from statictext within u_tabpage_assessment_info
end type
type st_patient_reference_material from statictext within u_tabpage_assessment_info
end type
type st_patient_reference_material_title from statictext within u_tabpage_assessment_info
end type
type st_assessment_id from statictext within u_tabpage_assessment_info
end type
type cb_location_domain_clear from commandbutton within u_tabpage_assessment_info
end type
type st_location_domain_title from statictext within u_tabpage_assessment_info
end type
type st_location_domain from statictext within u_tabpage_assessment_info
end type
type st_complexity from statictext within u_tabpage_assessment_info
end type
type st_complexity_title from statictext within u_tabpage_assessment_info
end type
type p_risk_level from picture within u_tabpage_assessment_info
end type
type cb_common_list from commandbutton within u_tabpage_assessment_info
end type
type st_risk_level from statictext within u_tabpage_assessment_info
end type
type st_risk from statictext within u_tabpage_assessment_info
end type
type st_title_assessment_type from statictext within u_tabpage_assessment_info
end type
type st_assessment_type from statictext within u_tabpage_assessment_info
end type
type st_3 from statictext within u_tabpage_assessment_info
end type
type st_assessment_category from statictext within u_tabpage_assessment_info
end type
type st_2 from statictext within u_tabpage_assessment_info
end type
type sle_icd9 from singlelineedit within u_tabpage_assessment_info
end type
type st_1 from statictext within u_tabpage_assessment_info
end type
type sle_description from singlelineedit within u_tabpage_assessment_info
end type
end forward

global type u_tabpage_assessment_info from u_tabpage
integer width = 2839
integer height = 1292
cb_equivalence cb_equivalence
st_status st_status
st_status_title st_status_title
st_provider_reference_material st_provider_reference_material
st_provider_reference_material_title st_provider_reference_material_title
st_patient_reference_material st_patient_reference_material
st_patient_reference_material_title st_patient_reference_material_title
st_assessment_id st_assessment_id
cb_location_domain_clear cb_location_domain_clear
st_location_domain_title st_location_domain_title
st_location_domain st_location_domain
st_complexity st_complexity
st_complexity_title st_complexity_title
p_risk_level p_risk_level
cb_common_list cb_common_list
st_risk_level st_risk_level
st_risk st_risk
st_title_assessment_type st_title_assessment_type
st_assessment_type st_assessment_type
st_3 st_3
st_assessment_category st_assessment_category
st_2 st_2
sle_icd9 sle_icd9
st_1 st_1
sle_description sle_description
end type
global u_tabpage_assessment_info u_tabpage_assessment_info

type variables
boolean allow_editing

string assessment_id

// Fields managed on this tab
string description
string icd_9_code
string assessment_category_id
string location_domain
long em_risk_level
long complexity
long patient_reference_material_id
long provider_reference_material_id
string status

// Display Only
string assessment_type
long owner_id

end variables

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();string ls_desc
string ls_icon
str_patient_material lstr_patient_material

st_assessment_type.text = datalist.assessment_type_description(assessment_type)

sle_description.text = description

SELECT description
INTO :st_assessment_category.text
FROM c_Assessment_Category
WHERE assessment_type = :assessment_type
AND assessment_category_id = :assessment_category_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	setnull(assessment_category_id)
	st_assessment_category.text = ""
end if

sle_icd9.text = icd_9_code

f_set_risk_level(em_risk_level,ls_desc,ls_icon)
st_risk_level.text = ls_desc
if isnull(ls_icon) then 
	p_risk_level.visible = false
else
	p_risk_level.visible = true
	p_risk_level.picturename = ls_icon
end if

if isnull(complexity) then
	st_complexity.text = "N/A"
else
	st_complexity.text = string(complexity)
end if

if isnull(location_domain) then
	st_location_domain.text = "N/A"
	cb_location_domain_clear.visible = false
else
	st_location_domain.text = datalist.location_domain_description(location_domain)
	cb_location_domain_clear.visible = true
end if

lstr_patient_material = f_get_patient_material(patient_reference_material_id, false)
if len(lstr_patient_material.title) > 0 then
	st_patient_reference_material.text = lstr_patient_material.title
else
	st_patient_reference_material.text = "N/A"
end if

lstr_patient_material = f_get_patient_material(provider_reference_material_id, false)
if len(lstr_patient_material.title) > 0 then
	st_provider_reference_material.text = lstr_patient_material.title
else
	st_provider_reference_material.text = "N/A"
end if

st_assessment_id.text = assessment_id

if status = "OK" then
	st_status.text = "Active"
else
	st_status.text = "Inactive"
end if


return 1

end function

on u_tabpage_assessment_info.create
int iCurrent
call super::create
this.cb_equivalence=create cb_equivalence
this.st_status=create st_status
this.st_status_title=create st_status_title
this.st_provider_reference_material=create st_provider_reference_material
this.st_provider_reference_material_title=create st_provider_reference_material_title
this.st_patient_reference_material=create st_patient_reference_material
this.st_patient_reference_material_title=create st_patient_reference_material_title
this.st_assessment_id=create st_assessment_id
this.cb_location_domain_clear=create cb_location_domain_clear
this.st_location_domain_title=create st_location_domain_title
this.st_location_domain=create st_location_domain
this.st_complexity=create st_complexity
this.st_complexity_title=create st_complexity_title
this.p_risk_level=create p_risk_level
this.cb_common_list=create cb_common_list
this.st_risk_level=create st_risk_level
this.st_risk=create st_risk
this.st_title_assessment_type=create st_title_assessment_type
this.st_assessment_type=create st_assessment_type
this.st_3=create st_3
this.st_assessment_category=create st_assessment_category
this.st_2=create st_2
this.sle_icd9=create sle_icd9
this.st_1=create st_1
this.sle_description=create sle_description
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_equivalence
this.Control[iCurrent+2]=this.st_status
this.Control[iCurrent+3]=this.st_status_title
this.Control[iCurrent+4]=this.st_provider_reference_material
this.Control[iCurrent+5]=this.st_provider_reference_material_title
this.Control[iCurrent+6]=this.st_patient_reference_material
this.Control[iCurrent+7]=this.st_patient_reference_material_title
this.Control[iCurrent+8]=this.st_assessment_id
this.Control[iCurrent+9]=this.cb_location_domain_clear
this.Control[iCurrent+10]=this.st_location_domain_title
this.Control[iCurrent+11]=this.st_location_domain
this.Control[iCurrent+12]=this.st_complexity
this.Control[iCurrent+13]=this.st_complexity_title
this.Control[iCurrent+14]=this.p_risk_level
this.Control[iCurrent+15]=this.cb_common_list
this.Control[iCurrent+16]=this.st_risk_level
this.Control[iCurrent+17]=this.st_risk
this.Control[iCurrent+18]=this.st_title_assessment_type
this.Control[iCurrent+19]=this.st_assessment_type
this.Control[iCurrent+20]=this.st_3
this.Control[iCurrent+21]=this.st_assessment_category
this.Control[iCurrent+22]=this.st_2
this.Control[iCurrent+23]=this.sle_icd9
this.Control[iCurrent+24]=this.st_1
this.Control[iCurrent+25]=this.sle_description
end on

on u_tabpage_assessment_info.destroy
call super::destroy
destroy(this.cb_equivalence)
destroy(this.st_status)
destroy(this.st_status_title)
destroy(this.st_provider_reference_material)
destroy(this.st_provider_reference_material_title)
destroy(this.st_patient_reference_material)
destroy(this.st_patient_reference_material_title)
destroy(this.st_assessment_id)
destroy(this.cb_location_domain_clear)
destroy(this.st_location_domain_title)
destroy(this.st_location_domain)
destroy(this.st_complexity)
destroy(this.st_complexity_title)
destroy(this.p_risk_level)
destroy(this.cb_common_list)
destroy(this.st_risk_level)
destroy(this.st_risk)
destroy(this.st_title_assessment_type)
destroy(this.st_assessment_type)
destroy(this.st_3)
destroy(this.st_assessment_category)
destroy(this.st_2)
destroy(this.sle_icd9)
destroy(this.st_1)
destroy(this.sle_description)
end on

type cb_equivalence from commandbutton within u_tabpage_assessment_info
integer x = 1989
integer y = 1092
integer width = 626
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Equivalence"
end type

event clicked;str_content_object lstr_item
w_object_equivalence lw_window

if isnull(assessment_id) then return

lstr_item.object_id = sqlca.fn_object_id_from_key("Assessment", assessment_id)
lstr_item.object_type = "Assessment"
lstr_item.object_key = assessment_id
lstr_item.description = sle_description.text
lstr_item.owner_id = owner_id

openwithparm(lw_window, lstr_item, "w_object_equivalence")

end event

type st_status from statictext within u_tabpage_assessment_info
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

type st_status_title from statictext within u_tabpage_assessment_info
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

type st_provider_reference_material from statictext within u_tabpage_assessment_info
integer x = 1906
integer y = 736
integer width = 791
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;w_pick_patient_material lw_pick
long ll_material_id
str_patient_material lstr_patient_material
str_popup popup
str_popup_return popup_return
integer li_choice

if provider_reference_material_id > 0 then
	popup.data_row_count = 3
	popup.items[1] = "View Provider Material"
	popup.items[2] = "Pick Provider Material"
	popup.items[3] = "Clear Provider Material"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	li_choice = popup_return.item_indexes[1]
else
	li_choice = 2
end if

CHOOSE CASE li_choice
	CASE 1
		f_display_patient_material(provider_reference_material_id)
	CASE 2
		open(lw_pick, "w_pick_patient_material")
		ll_material_id = message.doubleparm
		if ll_material_id <= 0 then return
		
		lstr_patient_material = f_get_patient_material(ll_material_id, false)
		if lstr_patient_material.material_id > 0 then
			provider_reference_material_id = lstr_patient_material.material_id
			text = lstr_patient_material.title
		end if
	CASE 3
		setnull(provider_reference_material_id)
		text = "N/A"
END CHOOSE




end event

type st_provider_reference_material_title from statictext within u_tabpage_assessment_info
integer x = 1888
integer y = 660
integer width = 832
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Provider Reference Material"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_patient_reference_material from statictext within u_tabpage_assessment_info
integer x = 1906
integer y = 524
integer width = 791
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;w_pick_patient_material lw_pick
long ll_material_id
str_patient_material lstr_patient_material
str_popup popup
str_popup_return popup_return
integer li_choice

if patient_reference_material_id > 0 then
	popup.data_row_count = 3
	popup.items[1] = "View Patient Material"
	popup.items[2] = "Pick Patient Material"
	popup.items[3] = "Clear Patient Material"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	li_choice = popup_return.item_indexes[1]
else
	li_choice = 2
end if

CHOOSE CASE li_choice
	CASE 1
		f_display_patient_material(patient_reference_material_id)
	CASE 2
		open(lw_pick, "w_pick_patient_material")
		ll_material_id = message.doubleparm
		if ll_material_id <= 0 then return
		
		lstr_patient_material = f_get_patient_material(ll_material_id, false)
		if lstr_patient_material.material_id > 0 then
			patient_reference_material_id = lstr_patient_material.material_id
			text = lstr_patient_material.title
		end if
	CASE 3
		setnull(patient_reference_material_id)
		text = "N/A"
END CHOOSE




end event

type st_patient_reference_material_title from statictext within u_tabpage_assessment_info
integer x = 1906
integer y = 448
integer width = 791
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Patient Reference Material"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_assessment_id from statictext within u_tabpage_assessment_info
integer width = 567
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean focusrectangle = false
end type

type cb_location_domain_clear from commandbutton within u_tabpage_assessment_info
integer x = 1394
integer y = 1060
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

event clicked;
setnull(location_domain)
st_location_domain.text = "N/A"
visible = false



end event

type st_location_domain_title from statictext within u_tabpage_assessment_info
integer x = 119
integer y = 968
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
string text = "Location Domain:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_location_domain from statictext within u_tabpage_assessment_info
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

event clicked;str_popup_return popup_return

openwithparm(w_pick_location_domain, location_domain)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

location_domain = popup_return.items[1]
text = datalist.location_domain_description(location_domain)

cb_location_domain_clear.visible = true


end event

type st_complexity from statictext within u_tabpage_assessment_info
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
string text = "N/A"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(complexity)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

complexity = integer(popup_return.realitem)
text = string(complexity)



end event

type st_complexity_title from statictext within u_tabpage_assessment_info
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

type p_risk_level from picture within u_tabpage_assessment_info
integer x = 1317
integer y = 656
integer width = 133
integer height = 112
boolean bringtotop = true
boolean originalsize = true
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_common_list from commandbutton within u_tabpage_assessment_info
integer x = 1989
integer y = 948
integer width = 626
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Specialty List"
end type

event clicked;str_popup popup

popup.title = sle_description.text
popup.items[1] = "Assessment" // common list context
popup.items[2] = assessment_id // common list id
popup.data_row_count = 2

openwithparm(w_specialty_common_lists, popup)

end event

type st_risk_level from statictext within u_tabpage_assessment_info
integer x = 686
integer y = 656
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
string text = "N/A"
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
end event

type st_risk from statictext within u_tabpage_assessment_info
integer x = 197
integer y = 672
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
string text = "Risk Level:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title_assessment_type from statictext within u_tabpage_assessment_info
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

type st_assessment_type from statictext within u_tabpage_assessment_info
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
long backcolor = 79741120
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

type st_3 from statictext within u_tabpage_assessment_info
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
string text = "Category:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_assessment_category from statictext within u_tabpage_assessment_info
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

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_assessment_category_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 2
popup.argument[1] = current_user.common_list_id()
popup.argument[2] = assessment_type

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 1 then
	assessment_category_id = popup_return.items[1]
	text = popup_return.descriptions[1]
end if


end event

type st_2 from statictext within u_tabpage_assessment_info
integer x = 247
integer y = 528
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
string text = "ICD-9 Code:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_icd9 from singlelineedit within u_tabpage_assessment_info
integer x = 686
integer y = 520
integer width = 334
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;icd_9_code = text

end event

type st_1 from statictext within u_tabpage_assessment_info
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

type sle_description from singlelineedit within u_tabpage_assessment_info
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
borderstyle borderstyle = stylelowered!
end type

event modified;description = text

end event

