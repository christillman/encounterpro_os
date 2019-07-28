$PBExportHeader$w_svc_audit.srw
forward
global type w_svc_audit from w_window_base
end type
type cb_ok from commandbutton within w_svc_audit
end type
type cb_from_next_day from commandbutton within w_svc_audit
end type
type cb_from_prev_day from commandbutton within w_svc_audit
end type
type dw_audit from u_dw_pick_list within w_svc_audit
end type
type st_from_date from statictext within w_svc_audit
end type
type st_from_date_title from statictext within w_svc_audit
end type
type cb_to_next_day from commandbutton within w_svc_audit
end type
type cb_to_prev_day from commandbutton within w_svc_audit
end type
type st_to_date from statictext within w_svc_audit
end type
type st_to_date_title from statictext within w_svc_audit
end type
type cbx_include_object_updates from checkbox within w_svc_audit
end type
end forward

global type w_svc_audit from w_window_base
integer width = 2935
integer height = 1912
string title = "Outstanding Labs/Tests"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
cb_ok cb_ok
cb_from_next_day cb_from_next_day
cb_from_prev_day cb_from_prev_day
dw_audit dw_audit
st_from_date st_from_date
st_from_date_title st_from_date_title
cb_to_next_day cb_to_next_day
cb_to_prev_day cb_to_prev_day
st_to_date st_to_date
st_to_date_title st_to_date_title
cbx_include_object_updates cbx_include_object_updates
end type
global w_svc_audit w_svc_audit

type variables
string consultant_id
string specialty_id
string                     viewed_office_id
u_component_service        service

date from_date
date to_date


// Resize numbers
long left_gap = 20
long right_gap = 40
long top_gap = 24
long bottom_gap = 60




end variables

forward prototypes
public subroutine perform (long pl_row)
public function integer refresh ()
end prototypes

public subroutine perform (long pl_row);//integer li_sts
//long ll_treatment_id,ll_encounter_id
//string ls_cpr_id
//long selected_row
//long ll_menu_id
//str_service_info lstr_service
//str_attributes lstr_attributes
//
//selected_row = pl_row
//
//ls_cpr_id = dw_tests.object.cpr_id[selected_row]
//ll_treatment_id = dw_tests.object.treatment_id[selected_row]
//ll_encounter_id = dw_tests.object.open_encounter_id[selected_row]
//
//f_attribute_add_attribute(lstr_attributes, "cpr_id", ls_cpr_id)
//f_attribute_add_attribute(lstr_attributes, "treatment_id", string(ll_treatment_id))
//f_attribute_add_attribute(lstr_attributes, "encounter_id", string(ll_encounter_id))
//
//service.get_attribute("treatment_menu_id", ll_menu_id)
//if isnull(ll_menu_id) then
//	lstr_service.service = service.get_attribute("treatment_service")
//	if isnull(lstr_service.service) then lstr_service.service = "TREATMENT_REVIEW"
//	
//	lstr_service.attributes = lstr_attributes
//	
//	li_sts = service_list.do_service(lstr_service)
//else
//	f_display_menu_with_attributes(ll_menu_id, true, lstr_attributes)
//end if
//
//dw_tests.clear_selected()
//
//
end subroutine

public function integer refresh ();//
//
//
integer li_sts
string ls_filter
long ll_encounter_id
string ls_user_id
string ls_include_object_updates
string ls_include_patient_info

setnull(ll_encounter_id)
setnull(ls_user_id)

if cbx_include_object_updates.checked then
	ls_include_object_updates = "Y"
else
	ls_include_object_updates = "N"
end if

if current_user.clinical_access_flag then
	ls_include_patient_info = "Y"
else
	ls_include_patient_info = "N"
end if

st_from_date.text = string(from_date)
st_to_date.text = string(to_date)

dw_audit.object.compute_action.width = width - 2700
dw_audit.object.compute_object.width = width - 662
dw_audit.object.l_header.x2 = width

dw_audit.settransobject(sqlca)
dw_audit.retrieve(service.cpr_id, ll_encounter_id, date(st_from_date.text), date(st_to_date.text), ls_user_id, ls_include_object_updates, ls_include_patient_info)


return 1

end function

on w_svc_audit.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_from_next_day=create cb_from_next_day
this.cb_from_prev_day=create cb_from_prev_day
this.dw_audit=create dw_audit
this.st_from_date=create st_from_date
this.st_from_date_title=create st_from_date_title
this.cb_to_next_day=create cb_to_next_day
this.cb_to_prev_day=create cb_to_prev_day
this.st_to_date=create st_to_date
this.st_to_date_title=create st_to_date_title
this.cbx_include_object_updates=create cbx_include_object_updates
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_from_next_day
this.Control[iCurrent+3]=this.cb_from_prev_day
this.Control[iCurrent+4]=this.dw_audit
this.Control[iCurrent+5]=this.st_from_date
this.Control[iCurrent+6]=this.st_from_date_title
this.Control[iCurrent+7]=this.cb_to_next_day
this.Control[iCurrent+8]=this.cb_to_prev_day
this.Control[iCurrent+9]=this.st_to_date
this.Control[iCurrent+10]=this.st_to_date_title
this.Control[iCurrent+11]=this.cbx_include_object_updates
end on

on w_svc_audit.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_from_next_day)
destroy(this.cb_from_prev_day)
destroy(this.dw_audit)
destroy(this.st_from_date)
destroy(this.st_from_date_title)
destroy(this.cb_to_next_day)
destroy(this.cb_to_prev_day)
destroy(this.st_to_date)
destroy(this.st_to_date_title)
destroy(this.cbx_include_object_updates)
end on

event open;call super::open;integer	li_count
string   ls_observation_type
str_popup_return popup_return
long ll_menu_id
string ls_temp

popup_return.item_count = 1
popup_return.items[1] = "ERROR"


// get the service object
service = message.powerobjectparm


if not current_scribe.check_privilege("Audit") then
	openwithparm(w_pop_message, "You are not authorized to view audit records")
	popup_return.items[1] = "CANCEL"
	closewithreturn(this, popup_return)
	return
end if

dw_audit.settransobject(sqlca)

ls_temp = service.get_attribute("audit_from_date")
if isdate(ls_temp) then
	from_date = date(ls_temp)
else
	from_date = today()
end if

ls_temp = service.get_attribute("audit_to_date")
if isdate(ls_temp) then
	to_date = date(ls_temp)
else
	to_date = today()
end if

service.get_attribute("menu_id", ll_menu_id)
if not isnull(ll_menu_id) then
	paint_menu(ll_menu_id)
end if

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_audit
boolean visible = true
integer x = 2679
integer y = 16
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_audit
integer x = 0
integer y = 1644
end type

type cb_ok from commandbutton within w_svc_audit
integer x = 2331
integer y = 1688
integer width = 558
integer height = 112
integer taborder = 70
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

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_from_next_day from commandbutton within w_svc_audit
integer x = 1138
integer y = 84
integer width = 119
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;from_date = relativedate(from_date, 1)
refresh()

end event

type cb_from_prev_day from commandbutton within w_svc_audit
integer x = 549
integer y = 84
integer width = 119
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
end type

event clicked;from_date = relativedate(from_date, -1)
refresh()

end event

type dw_audit from u_dw_pick_list within w_svc_audit
integer x = 23
integer y = 192
integer width = 2862
integer height = 1452
integer taborder = 30
string dataobject = "dw_fn_audit"
boolean vscrollbar = true
end type

event computed_clicked;//////////////////////////////////////////////////////////////////////////////////////////////
////
//// Description:Popup a toolbar with more options.
////
//// Created By:Sumathi Chinnasamy										Creation dt: 11/29/2001
////
//// Modified By:															Modified On:
//////////////////////////////////////////////////////////////////////////////////////////////
//
//String					ls_buttons[],ls_status
//Long						ll_button_pressed
//Long						ll_treatment_id,ll_encounter_id,ll_patient_workplan_item_id
//String					ls_cpr_id,ls_progress
//window					lw_popup_buttons
//str_popup				popup
//str_popup_return		popup_return
//
//DECLARE lsp_set_treatment_progress PROCEDURE FOR sp_set_treatment_progress
//	@ps_cpr_id = :ls_cpr_id,
//	@pl_treatment_id = :ll_treatment_id,
//	@pl_encounter_id = :ll_encounter_id,
//	@ps_progress_type = "CANCELLED",
//	@ps_progress_value =  :ls_progress,
//	@ps_user_id = :current_user.user_id,
//	@ps_created_by = :current_scribe.user_id;
//	
////--The DECLARE below is missing the optional parameter "pdt_progress_date_time"
//
//DECLARE lsp_complete_workplan_item PROCEDURE FOR sp_complete_workplan_item
//			@pl_patient_workplan_item_id = :ll_patient_workplan_item_id,   
//         @ps_completed_by = :current_user.user_id,   
//         @ps_progress_type = :ls_status,   
//         @ps_created_by = :current_scribe.user_id;
//
//If true Then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button15.bmp"
//	popup.button_helps[popup.button_count] = "Complete the lab"
//	popup.button_titles[popup.button_count] = "Perform"
//	ls_buttons[popup.button_count] = "PERFORM"
//End if
//
////If true Then
////	popup.button_count = popup.button_count + 1
////	popup.button_icons[popup.button_count] = "button13.bmp"
////	popup.button_helps[popup.button_count] = "Delete this"
////	popup.button_titles[popup.button_count] = "Delete"
////	ls_buttons[popup.button_count] = "DELETE"
////End If
//
//If true Then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Cancel treatment"
//	popup.button_titles[popup.button_count] = "Cancel treatment"
//	ls_buttons[popup.button_count] = "CANCELTREATMENT"
//End If
//
//If True Then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button11.bmp"
//	popup.button_helps[popup.button_count] = "Cancel"
//	popup.button_titles[popup.button_count] = "Cancel"
//	ls_buttons[popup.button_count] = "CANCEL"
//End If
//
//popup.button_titles_used = True
//// open the toolbar
//If popup.button_count > 1 Then
//	Openwithparm(lw_popup_buttons, popup, "w_pop_buttons")
//	ll_button_pressed = Message.doubleparm
//	If ll_button_pressed < 1 Or ll_button_pressed > popup.button_count Then Return
//Elseif popup.button_count = 1 Then
//	ll_button_pressed = 1
//Else
//	Return
//End if
//
//ll_treatment_id = object.treatment_id[clicked_row]
//ll_encounter_id = object.open_encounter_id[clicked_row]
//ls_cpr_id = object.cpr_id[clicked_row]
//Choose Case ls_buttons[ll_button_pressed]
//	Case "PERFORM"
//		perform(clicked_row)
//	Case "CANCELTREATMENT"
//		// Ask the user for the name of the new result set
//		popup.argument_count = 1
//		popup.argument[1] = "CANCELTREATMENT"
//		popup.title = "Enter the reason for cancellation:"
//		openwithparm(w_pop_prompt_string, popup)
//		popup_return = message.powerobjectparm
//		if popup_return.item_count <> 1 then return
//
//		ls_progress = popup_return.items[1]
//		EXECUTE lsp_set_treatment_progress;
//		dw_tests.deleterow(clicked_row)
//	Case "DELETE"
////		ls_status = "CANCELLED"
////		ll_patient_workplan_item_id = object.patient_workplan_item_id[clicked_row]
////		EXECUTE lsp_complete_workplan_item;
//	Case ELSE
//		Return
//END CHOOSE
//
//Return
//
end event

event selected;perform(selected_row)
refresh()

end event

type st_from_date from statictext within w_svc_audit
integer x = 677
integer y = 84
integer width = 453
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
string text = "10/10/2000"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Select Encounter Date"
popup.data_row_count = 1
popup.items[1] = string(from_date, date_format_string)

openwithparm(w_pick_date, popup)
popup_return = message.powerobjectparm

if not isnull(popup_return.item) then
	from_date = date(popup_return.item)
	refresh()
end if

end event

type st_from_date_title from statictext within w_svc_audit
integer x = 658
integer y = 8
integer width = 485
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Audit From Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_to_next_day from commandbutton within w_svc_audit
integer x = 2130
integer y = 84
integer width = 119
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;to_date = relativedate(to_date, 1)
refresh()

end event

type cb_to_prev_day from commandbutton within w_svc_audit
integer x = 1541
integer y = 84
integer width = 119
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
end type

event clicked;to_date = relativedate(to_date, -1)
refresh()

end event

type st_to_date from statictext within w_svc_audit
integer x = 1669
integer y = 84
integer width = 453
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
string text = "10/10/2000"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Select Encounter Date"
popup.data_row_count = 1
popup.items[1] = string(to_date, date_format_string)

openwithparm(w_pick_date, popup)
popup_return = message.powerobjectparm

if not isnull(popup_return.item) then
	to_date = date(popup_return.item)
	refresh()
end if

end event

type st_to_date_title from statictext within w_svc_audit
integer x = 1669
integer y = 8
integer width = 453
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Audit To Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_include_object_updates from checkbox within w_svc_audit
integer x = 992
integer y = 1648
integer width = 795
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Include Object Updates"
boolean checked = true
end type

event clicked;refresh()

end event

