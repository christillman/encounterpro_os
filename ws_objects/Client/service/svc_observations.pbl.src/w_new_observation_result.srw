$PBExportHeader$w_new_observation_result.srw
forward
global type w_new_observation_result from w_window_base
end type
type st_specimen_type from statictext within w_new_observation_result
end type
type st_specimen_type_title from statictext within w_new_observation_result
end type
type st_observation from statictext within w_new_observation_result
end type
type sle_result from singlelineedit within w_new_observation_result
end type
type st_result from statictext within w_new_observation_result
end type
type uo_normal from u_st_radio_abnormal within w_new_observation_result
end type
type uo_abnormal from u_st_radio_abnormal within w_new_observation_result
end type
type st_1 from statictext within w_new_observation_result
end type
type uo_yes from u_st_radio_numeric_yesno within w_new_observation_result
end type
type uo_no from u_st_radio_numeric_yesno within w_new_observation_result
end type
type st_unit from statictext within w_new_observation_result
end type
type st_unit_title from statictext within w_new_observation_result
end type
type pb_done from u_picture_button within w_new_observation_result
end type
type pb_cancel from u_picture_button within w_new_observation_result
end type
type st_tmp_title from statictext within w_new_observation_result
end type
type st_temporary from statictext within w_new_observation_result
end type
type st_permanent from statictext within w_new_observation_result
end type
type st_type_title from statictext within w_new_observation_result
end type
type st_severity from statictext within w_new_observation_result
end type
type p_result_severity from picture within w_new_observation_result
end type
type cb_get_phrase from commandbutton within w_new_observation_result
end type
type pb_1 from u_pb_help_button within w_new_observation_result
end type
type st_severity_title from statictext within w_new_observation_result
end type
end forward

global type w_new_observation_result from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_specimen_type st_specimen_type
st_specimen_type_title st_specimen_type_title
st_observation st_observation
sle_result sle_result
st_result st_result
uo_normal uo_normal
uo_abnormal uo_abnormal
st_1 st_1
uo_yes uo_yes
uo_no uo_no
st_unit st_unit
st_unit_title st_unit_title
pb_done pb_done
pb_cancel pb_cancel
st_tmp_title st_tmp_title
st_temporary st_temporary
st_permanent st_permanent
st_type_title st_type_title
st_severity st_severity
p_result_severity p_result_severity
cb_get_phrase cb_get_phrase
pb_1 pb_1
st_severity_title st_severity_title
end type
global w_new_observation_result w_new_observation_result

type variables
string observation_id
integer result_sequence

string abnormal_flag
string result_amount_flag
string result_unit
integer severity
string specimen_type

string status

string result_type


end variables

forward prototypes
public subroutine set_severity (integer pi_severity)
public function integer save_changes ()
public function integer new_result ()
end prototypes

public subroutine set_severity (integer pi_severity);string ls_bitmap

severity = pi_severity
st_severity.text = datalist.domain_item_description("RESULTSEVERITY", string(severity))
ls_bitmap = datalist.domain_item_bitmap("RESULTSEVERITY", string(severity))
p_result_severity.picturename = ls_bitmap

end subroutine

public function integer save_changes ();str_popup_return popup_return

string ls_print_result_flag
string ls_external_source
long ll_property_id
string ls_service
string ls_unit_preference

setnull(ls_print_result_flag)
setnull(ls_external_source)
setnull(ll_property_id)
setnull(ls_service)
setnull(ls_unit_preference)
 
if isnull(sle_result.text) or sle_result.text = "" then
	openwithparm(w_pop_message, "You must provide a result")
	sle_result.setfocus()
	return 0
end if

if result_amount_flag = "Y" then
	if isnull(result_unit) then
		openwithparm(w_pop_message, "You must provide a result unit")
		sle_result.setfocus()
		return 0
	end if
else
	setnull(result_unit)
end if

if isnull(result_sequence) then
sqlca.sp_new_observation_result( &
		observation_id, &
		result_type, &
		result_unit, &
		sle_result.text, &
		result_amount_flag, &
		ls_print_result_flag, &
		specimen_type, &
		abnormal_flag, &
		severity, &
		ls_external_source, &
		ll_property_id, &
		ls_service, &
		ls_unit_preference, &
		status, &
		result_sequence)
	if not tf_check() then return -1
else
	sqlca.sp_update_observation_result( &
			observation_id, &
			result_sequence, &
			result_unit, &
			result_amount_flag, &
			ls_print_result_flag, &
			specimen_type, &
			abnormal_flag, &
			severity, &
			ls_external_source, &
			ll_property_id, &
			ls_service, &
			ls_unit_preference, &
			status)
	if not tf_check() then return -1
end if

return 1

end function

public function integer new_result ();
if isnull(observation_id) or observation_id = "" then
	log.log(this, "w_new_observation_result.new_result:0003", "Invalid observation id", 4)
	return -1
end if

if status = "NA" then
	st_tmp_title.visible = true
	st_temporary.visible = true
	st_permanent.visible = true
	st_temporary.triggerevent("clicked")
else
	st_tmp_title.visible = false
	st_temporary.visible = false
	st_permanent.visible = false
end if

uo_abnormal.select_button()
abnormal_flag = "Y"
set_severity(3)

result_amount_flag = "N"
st_unit.text = "Not Applicable"
result_unit = "NA"
uo_no.select_button()

sle_result.enabled = true
sle_result.setfocus()

if result_type = "COLLECT" then
	st_specimen_type.visible = true
	st_specimen_type_title.visible = true
else
	st_specimen_type.visible = false
	st_specimen_type_title.visible = false
end if


return 1

end function

event open;call super::open;string ls_bitmap
str_popup popup
integer li_sts

popup = message.powerobjectparm


if popup.data_row_count = 3 then
	setnull(result_sequence)
	setnull(specimen_type)
	st_specimen_type.text = "<None>"
	observation_id = popup.items[1]
	result_type = popup.items[2]
	if isnull(result_type) then result_type = "PERFORM"
	status = popup.items[3]
else
	log.log(this, "w_new_observation_result:open", "Invalid Parameters", 4)
	close(this)
	return
end if

li_sts = new_result()
if li_sts < 0 then
	log.log(this, "w_new_observation_result:open", "Error initializing new result", 4)
	close(this)
	return
end if

if not isnull(popup.title) and popup.title <> "" then
	st_observation.text = popup.title
else
	st_observation.text = datalist.observation_description(observation_id)
end if


end event

on w_new_observation_result.create
int iCurrent
call super::create
this.st_specimen_type=create st_specimen_type
this.st_specimen_type_title=create st_specimen_type_title
this.st_observation=create st_observation
this.sle_result=create sle_result
this.st_result=create st_result
this.uo_normal=create uo_normal
this.uo_abnormal=create uo_abnormal
this.st_1=create st_1
this.uo_yes=create uo_yes
this.uo_no=create uo_no
this.st_unit=create st_unit
this.st_unit_title=create st_unit_title
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_tmp_title=create st_tmp_title
this.st_temporary=create st_temporary
this.st_permanent=create st_permanent
this.st_type_title=create st_type_title
this.st_severity=create st_severity
this.p_result_severity=create p_result_severity
this.cb_get_phrase=create cb_get_phrase
this.pb_1=create pb_1
this.st_severity_title=create st_severity_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_specimen_type
this.Control[iCurrent+2]=this.st_specimen_type_title
this.Control[iCurrent+3]=this.st_observation
this.Control[iCurrent+4]=this.sle_result
this.Control[iCurrent+5]=this.st_result
this.Control[iCurrent+6]=this.uo_normal
this.Control[iCurrent+7]=this.uo_abnormal
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.uo_yes
this.Control[iCurrent+10]=this.uo_no
this.Control[iCurrent+11]=this.st_unit
this.Control[iCurrent+12]=this.st_unit_title
this.Control[iCurrent+13]=this.pb_done
this.Control[iCurrent+14]=this.pb_cancel
this.Control[iCurrent+15]=this.st_tmp_title
this.Control[iCurrent+16]=this.st_temporary
this.Control[iCurrent+17]=this.st_permanent
this.Control[iCurrent+18]=this.st_type_title
this.Control[iCurrent+19]=this.st_severity
this.Control[iCurrent+20]=this.p_result_severity
this.Control[iCurrent+21]=this.cb_get_phrase
this.Control[iCurrent+22]=this.pb_1
this.Control[iCurrent+23]=this.st_severity_title
end on

on w_new_observation_result.destroy
call super::destroy
destroy(this.st_specimen_type)
destroy(this.st_specimen_type_title)
destroy(this.st_observation)
destroy(this.sle_result)
destroy(this.st_result)
destroy(this.uo_normal)
destroy(this.uo_abnormal)
destroy(this.st_1)
destroy(this.uo_yes)
destroy(this.uo_no)
destroy(this.st_unit)
destroy(this.st_unit_title)
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_tmp_title)
destroy(this.st_temporary)
destroy(this.st_permanent)
destroy(this.st_type_title)
destroy(this.st_severity)
destroy(this.p_result_severity)
destroy(this.cb_get_phrase)
destroy(this.pb_1)
destroy(this.st_severity_title)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_new_observation_result
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_new_observation_result
end type

type st_specimen_type from statictext within w_new_observation_result
integer x = 1161
integer y = 1252
integer width = 695
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_bitmap
str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_specimen_type_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 1
popup.add_blank_row = true
popup.blank_text = "<None>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.descriptions[1]

ls_bitmap = datalist.domain_item_bitmap("RESULTSEVERITY", string(severity))
p_result_severity.picturename = ls_bitmap


end event

type st_specimen_type_title from statictext within w_new_observation_result
integer x = 631
integer y = 1256
integer width = 489
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Specimen Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_observation from statictext within w_new_observation_result
integer width = 2894
integer height = 136
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_result from singlelineedit within w_new_observation_result
integer x = 133
integer y = 384
integer width = 2478
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;if len(text) > 80 then
	openwithparm(w_pop_message, "Result is being truncated to 80 characters")
	text = left(text, 80)
end if

end event

type st_result from statictext within w_new_observation_result
integer x = 137
integer y = 312
integer width = 357
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Result:"
boolean focusrectangle = false
end type

type uo_normal from u_st_radio_abnormal within w_new_observation_result
integer x = 1161
integer y = 600
integer width = 393
integer height = 100
string text = "Normal"
end type

event clicked;call super::clicked;abnormal_flag = "N"
set_severity(0)

end event

type uo_abnormal from u_st_radio_abnormal within w_new_observation_result
integer x = 1605
integer y = 600
integer width = 393
integer height = 100
boolean bringtotop = true
string text = "Abnormal"
end type

event clicked;call super::clicked;abnormal_flag = "Y"
set_severity(3)

end event

type st_1 from statictext within w_new_observation_result
integer x = 631
integer y = 984
integer width = 489
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Numeric Result:"
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_yes from u_st_radio_numeric_yesno within w_new_observation_result
integer x = 1161
integer y = 984
integer width = 274
integer height = 92
string text = "Yes"
end type

event clicked;call super::clicked;result_amount_flag = "Y"
if isnull(result_unit) then
	st_unit.text = "Not Applicable"
	result_unit = "NA"
end if

st_unit.visible = true
st_unit_title.visible = true

end event

type uo_no from u_st_radio_numeric_yesno within w_new_observation_result
integer x = 1504
integer y = 984
integer width = 274
integer height = 92
boolean bringtotop = true
string text = "No"
end type

event clicked;call super::clicked;result_amount_flag = "N"
st_unit.visible = false
st_unit_title.visible = false

end event

type st_unit from statictext within w_new_observation_result
boolean visible = false
integer x = 1161
integer y = 1104
integer width = 521
integer height = 92
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

popup.dataobject = "dw_unit_list"
popup.displaycolumn = 1
popup.datacolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 1 then
	result_unit = popup_return.items[1]
	text = popup_return.descriptions[1]
end if


end event

type st_unit_title from statictext within w_new_observation_result
boolean visible = false
integer x = 946
integer y = 1104
integer width = 174
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Unit:"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_done from u_picture_button within w_new_observation_result
integer x = 2555
integer y = 1540
integer taborder = 50
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

popup_return.item_count = 2
popup_return.items[1] = status
popup_return.items[2] = string(result_sequence)

closewithreturn(parent, popup_return)


end event

type pb_cancel from u_picture_button within w_new_observation_result
integer x = 123
integer y = 1520
integer taborder = 10
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type st_tmp_title from statictext within w_new_observation_result
integer x = 631
integer y = 796
integer width = 489
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Persistence:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_temporary from statictext within w_new_observation_result
integer x = 1161
integer y = 792
integer width = 393
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Temporary"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;status = "NA"
backcolor = color_object_selected
st_permanent.backcolor = color_object


end event

type st_permanent from statictext within w_new_observation_result
integer x = 1605
integer y = 792
integer width = 393
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Permanent"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;status = "OK"
backcolor = color_object_selected
st_temporary.backcolor = color_object


end event

type st_type_title from statictext within w_new_observation_result
integer x = 631
integer y = 604
integer width = 489
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Result Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_severity from statictext within w_new_observation_result
integer x = 1161
integer y = 1408
integer width = 695
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_bitmap
str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_domain_pick_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "RESULTSEVERITY"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

severity = integer(popup_return.items[1])
text = popup_return.descriptions[1]

ls_bitmap = datalist.domain_item_bitmap("RESULTSEVERITY", string(severity))
p_result_severity.picturename = ls_bitmap


end event

type p_result_severity from picture within w_new_observation_result
integer x = 1920
integer y = 1408
integer width = 133
integer height = 100
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_get_phrase from commandbutton within w_new_observation_result
boolean visible = false
integer x = 2633
integer y = 388
integer width = 146
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;u_component_nomenclature luo_nomenclature
string ls_phrase

//luo_nomenclature = component_manager.get_component("NOMENCLATURE","PHRASE")
setnull(luo_nomenclature)
if isnull(luo_nomenclature) then
	openwithparm(w_pop_message, "A nomenclature component has not been installed")
	return
end if

ls_phrase = luo_nomenclature.get_phrase("RESULT")
if not (isnull(ls_phrase) or trim(ls_phrase) = "") then
	sle_result.text = ls_phrase
end if

component_manager.destroy_component(luo_nomenclature)


end event

type pb_1 from u_pb_help_button within w_new_observation_result
integer x = 2162
integer y = 1596
integer taborder = 20
boolean bringtotop = true
end type

type st_severity_title from statictext within w_new_observation_result
integer x = 837
integer y = 1412
integer width = 283
integer height = 92
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Severity:"
alignment alignment = right!
boolean focusrectangle = false
end type

