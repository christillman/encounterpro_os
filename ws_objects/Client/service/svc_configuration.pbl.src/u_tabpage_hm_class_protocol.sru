$PBExportHeader$u_tabpage_hm_class_protocol.sru
forward
global type u_tabpage_hm_class_protocol from u_tabpage_hm_class_base
end type
type st_interval_title from statictext within u_tabpage_hm_class_protocol
end type
type st_perform_title from statictext within u_tabpage_hm_class_protocol
end type
type st_title from statictext within u_tabpage_hm_class_protocol
end type
type cb_add_procedure from commandbutton within u_tabpage_hm_class_protocol
end type
type dw_protocol_items from u_dw_pick_list within u_tabpage_hm_class_protocol
end type
type st_interval from statictext within u_tabpage_hm_class_protocol
end type
type st_interval_unit from statictext within u_tabpage_hm_class_protocol
end type
end forward

global type u_tabpage_hm_class_protocol from u_tabpage_hm_class_base
integer width = 2761
st_interval_title st_interval_title
st_perform_title st_perform_title
st_title st_title
cb_add_procedure cb_add_procedure
dw_protocol_items dw_protocol_items
st_interval st_interval
st_interval_unit st_interval_unit
end type
global u_tabpage_hm_class_protocol u_tabpage_hm_class_protocol

type variables
long protocol_index

string hm_treatment_list_id = "HealthMaintenance"

end variables

forward prototypes
public subroutine proc_menu (long pl_row)
public subroutine refresh ()
public function integer add_protocol_item ()
public function integer add_treatment ()
public function integer add_assessment ()
public function integer initialize (str_hm_context pstr_hm_context, long pl_index)
end prototypes

public subroutine proc_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
long i

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove protocol Item From This Maintenance Rule"
	popup.button_titles[popup.button_count] = "Remove"
	buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "REMOVE"
		openwithparm(w_pop_yes_no, "Are you sure you wish to remove this procedure?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		dw_protocol_items.deleterow(pl_row)
		li_sts = dw_protocol_items.update()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public subroutine refresh ();long ll_count

st_interval.text = string(hmclasstab.hm_class.protocol[protocol_index].interval)
st_interval_unit.text = wordcap(hmclasstab.hm_class.protocol[protocol_index].interval_unit)

ll_count = dw_protocol_items.retrieve(hmclasstab.hm_class.maintenance_rule_id, hmclasstab.hm_class.protocol[protocol_index].protocol_sequence)

return

end subroutine

public function integer add_protocol_item ();str_popup popup
str_popup_return popup_return
integer li_index

popup.data_row_count = 2
popup.items[1] = "Assessment"
popup.items[2] = "Treatment"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

li_index = popup_return.item_indexes[1]
if li_index = 1 then
	return add_assessment()
elseif li_index = 2 then
	return add_treatment()
else
	return 0
end if

return 1

end function

public function integer add_treatment ();string ls_treatment_type
string ls_description
string ls_button
string ls_icon_open
string ls_icon_closed
integer li_sts
long ll_row
string ls_primary_flag
long i
str_picked_treatments lstr_treatments
str_popup popup
u_component_treatment luo_treatment
string ls_treatment_key

ls_treatment_type = f_get_treatments_list(hm_treatment_list_id)
ls_button = datalist.treatment_type_define_button(ls_treatment_type)

If Not Isnull(ls_treatment_type) Then
	luo_treatment = f_get_treatment_component(ls_treatment_type)
	If Not Isnull(luo_treatment) Then 
		luo_treatment.define_treatment()
		
		for i = 1 to luo_treatment.treatment_count
			ls_treatment_key = f_get_treatment_key(ls_treatment_type, &
													luo_treatment.treatment_definition[i].attribute_count, &
													luo_treatment.treatment_definition[i].attribute, &
													luo_treatment.treatment_definition[i].value)

			ll_row = dw_protocol_items.insertrow(0)

			
			dw_protocol_items.object.maintenance_rule_id[ll_row] = HMClassTab.hm_class.maintenance_rule_id
			dw_protocol_items.object.protocol_sequence[ll_row] = HMClassTab.hm_class.protocol[protocol_index].protocol_sequence
			dw_protocol_items.object.description[ll_row] = left(luo_treatment.treatment_definition[i].item_description, 80)
			dw_protocol_items.object.context_object[ll_row] = "Treatment"
			dw_protocol_items.object.treatment_type[ll_row] = ls_treatment_type
			dw_protocol_items.object.treatment_key[ll_row] = ls_treatment_key
			dw_protocol_items.object.created_by[ll_row] = current_scribe.user_id
		next
	End If
End If

li_sts = dw_protocol_items.update()
if li_sts < 0 then return -1

return 1

end function

public function integer add_assessment ();string ls_assessment_type
string ls_description
string ls_button
string ls_icon_open
string ls_icon_closed
integer li_sts
long ll_row
long i
str_picked_assessments lstr_assessments
str_popup popup


popup.data_row_count = 2
popup.items[1] = "" // assessment_type
setnull(popup.items[2]) // encounter_id

openwithparm(w_pick_assessments, popup)
lstr_assessments = message.powerobjectparm
if lstr_assessments.assessment_count <= 0 then return 0

for i = 1 to lstr_assessments.assessment_count
	SELECT t.assessment_type,
			t.description,
			t.button,
			t.icon_open,
			t.icon_closed
	INTO :ls_assessment_type,
			:ls_description,
			:ls_button,
			:ls_icon_open,
			:ls_icon_closed
	FROM c_assessment_definition p, c_assessment_Type t
	WHERE p.assessment_id = :lstr_assessments.assessments[i].assessment_id
	AND p.assessment_type = t.assessment_type;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		log.log(this, "u_tabpage_hm_class_protocol.add_assessment.0037", "assessment_type not found for assessment (" + lstr_assessments.assessments[i].assessment_id + ")", 4)
		return -1
	end if
	
	ll_row = dw_protocol_items.insertrow(0)
	dw_protocol_items.object.maintenance_rule_id[ll_row] = HMClassTab.hm_class.maintenance_rule_id
	dw_protocol_items.object.protocol_sequence[ll_row] = HMClassTab.hm_class.protocol[protocol_index].protocol_sequence
	dw_protocol_items.object.description[ll_row] = lstr_assessments.assessments[i].description
	dw_protocol_items.object.context_object[ll_row] = "Assessment"
	dw_protocol_items.object.assessment_type[ll_row] = ls_assessment_type
	dw_protocol_items.object.assessment_id[ll_row] = lstr_assessments.assessments[i].assessment_id
	dw_protocol_items.object.created_by[ll_row] = current_scribe.user_id
next

li_sts = dw_protocol_items.update()
if li_sts < 0 then return -1

return 1


end function

public function integer initialize (str_hm_context pstr_hm_context, long pl_index);long i
long ll_row

protocol_index = pl_index

// Set the object positions
st_title.width = width

dw_protocol_items.x = ((width - dw_protocol_items.width) / 2) + 50
dw_protocol_items.height = height - dw_protocol_items.y - 180

cb_add_procedure.x = dw_protocol_items.x + dw_protocol_items.width - cb_add_procedure.width - 100
cb_add_procedure.y = dw_protocol_items.y + dw_protocol_items.height + 36

st_perform_title.x = dw_protocol_items.x

st_interval_title.x = dw_protocol_items.x
st_interval_title.y = dw_protocol_items.y + dw_protocol_items.height + 36

st_interval.x = st_interval_title.x + st_interval_title.width + 4
st_interval.y = st_interval_title.y

st_interval_unit.x = st_interval.x + st_interval.width + 36
st_interval_unit.y = st_interval_title.y

st_title.text = hmclasstab.hm_class.protocol[protocol_index].description

dw_protocol_items.settransobject(sqlca)
//for i = 1 to HMClassTab.hm_class.procedure_count
//	ll_row = dw_protocol_items.insertrow(0)
//	dw_protocol_items.object.property[ll_row] = HMClassTab.hm_class.procedure[i].property
//	dw_protocol_items.object.property_display[ll_row] = wordcap(f_string_substitute(HMClassTab.hm_class.procedure[i].property, "_", " "))
//	dw_protocol_items.object.value[ll_row] = HMClassTab.hm_class.procedure[i].value
//	dw_protocol_items.object.operation[ll_row] = HMClassTab.hm_class.procedure[i].operation
//	if isnull(HMClassTab.hm_class.procedure[i].value) then
//		dw_protocol_items.object.value_display[ll_row] = "<Any>"
//	else
//		dw_protocol_items.object.value_display[ll_row] = f_property_value_display(HMClassTab.hm_class.procedure[i].property, HMClassTab.hm_class.procedure[i].value)
//	end if
//next

return 1


end function

on u_tabpage_hm_class_protocol.create
int iCurrent
call super::create
this.st_interval_title=create st_interval_title
this.st_perform_title=create st_perform_title
this.st_title=create st_title
this.cb_add_procedure=create cb_add_procedure
this.dw_protocol_items=create dw_protocol_items
this.st_interval=create st_interval
this.st_interval_unit=create st_interval_unit
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_interval_title
this.Control[iCurrent+2]=this.st_perform_title
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.cb_add_procedure
this.Control[iCurrent+5]=this.dw_protocol_items
this.Control[iCurrent+6]=this.st_interval
this.Control[iCurrent+7]=this.st_interval_unit
end on

on u_tabpage_hm_class_protocol.destroy
call super::destroy
destroy(this.st_interval_title)
destroy(this.st_perform_title)
destroy(this.st_title)
destroy(this.cb_add_procedure)
destroy(this.dw_protocol_items)
destroy(this.st_interval)
destroy(this.st_interval_unit)
end on

type st_interval_title from statictext within u_tabpage_hm_class_protocol
integer x = 101
integer y = 1272
integer width = 617
integer height = 104
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Every Interval of:"
boolean focusrectangle = false
end type

type st_perform_title from statictext within u_tabpage_hm_class_protocol
integer x = 133
integer y = 140
integer width = 1102
integer height = 64
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Perform at least one of these:"
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_hm_class_protocol
integer width = 2738
integer height = 100
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Class Protocol"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_add_procedure from commandbutton within u_tabpage_hm_class_protocol
integer x = 1957
integer y = 1276
integer width = 613
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Protocol Item(s)"
end type

event clicked;add_protocol_item()


end event

type dw_protocol_items from u_dw_pick_list within u_tabpage_hm_class_protocol
integer x = 128
integer y = 216
integer width = 2528
integer height = 888
integer taborder = 10
string dataobject = "dw_c_maintenance_protocol_items"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;proc_menu(selected_row)
clear_selected()

end event

type st_interval from statictext within u_tabpage_hm_class_protocol
integer x = 722
integer y = 1260
integer width = 283
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "99"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = real(hmclasstab.hm_class.protocol[protocol_index].interval)
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

hmclasstab.hm_class.protocol[protocol_index].interval = long(popup_return.realitem)
text = string(hmclasstab.hm_class.protocol[protocol_index].interval)

UPDATE c_Maintenance_Protocol
SET interval = :hmclasstab.hm_class.protocol[protocol_index].interval
WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id
AND protocol_sequence = :hmclasstab.hm_class.protocol[protocol_index].protocol_sequence;
if not tf_check() then return


end event

type st_interval_unit from statictext within u_tabpage_hm_class_protocol
integer x = 1042
integer y = 1260
integer width = 283
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Month"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
integer li_index

popup.data_row_count = 3
popup.items[1] = "Days"
popup.items[2] = "Months"
popup.items[3] = "Years"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

li_index = popup_return.item_indexes[1]
if li_index = 1 then
	hmclasstab.hm_class.protocol[protocol_index].interval_unit = "DAY"
	text = "Days"
elseif li_index = 2 then
	hmclasstab.hm_class.protocol[protocol_index].interval_unit = "MONTH"
	text = "Months"
else
	hmclasstab.hm_class.protocol[protocol_index].interval_unit = "YEAR"
	text = "Years"
end if

UPDATE c_Maintenance_Protocol
SET interval_unit = :hmclasstab.hm_class.protocol[protocol_index].interval_unit
WHERE maintenance_rule_id = :hmclasstab.hm_class.maintenance_rule_id
AND protocol_sequence = :hmclasstab.hm_class.protocol[protocol_index].protocol_sequence;
if not tf_check() then return



end event

