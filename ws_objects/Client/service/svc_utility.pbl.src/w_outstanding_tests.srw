$PBExportHeader$w_outstanding_tests.srw
forward
global type w_outstanding_tests from w_window_base
end type
type pb_cancel from u_picture_button within w_outstanding_tests
end type
type dw_tests from u_dw_pick_list within w_outstanding_tests
end type
type st_1 from statictext within w_outstanding_tests
end type
type st_sort_date from statictext within w_outstanding_tests
end type
type st_sort_billing_id from statictext within w_outstanding_tests
end type
type st_sort_patient from statictext within w_outstanding_tests
end type
type st_sort_description from statictext within w_outstanding_tests
end type
type st_sort_ascending from statictext within w_outstanding_tests
end type
type st_sort_descending from statictext within w_outstanding_tests
end type
type st_primary_provider from statictext within w_outstanding_tests
end type
type st_primary_provider_title from statictext within w_outstanding_tests
end type
type cb_all_providers from commandbutton within w_outstanding_tests
end type
type cb_print from commandbutton within w_outstanding_tests
end type
type st_office from statictext within w_outstanding_tests
end type
type st_filter from statictext within w_outstanding_tests
end type
type st_office_title from statictext within w_outstanding_tests
end type
type st_patient_name from statictext within w_outstanding_tests
end type
type cb_clear_filter from commandbutton within w_outstanding_tests
end type
type st_patient from statictext within w_outstanding_tests
end type
type cb_ok from commandbutton within w_outstanding_tests
end type
type pb_up from u_picture_button within w_outstanding_tests
end type
type st_page from statictext within w_outstanding_tests
end type
type pb_down from u_picture_button within w_outstanding_tests
end type
type r_1 from rectangle within w_outstanding_tests
end type
end forward

global type w_outstanding_tests from w_window_base
string title = "Outstanding Labs/Tests"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_cancel pb_cancel
dw_tests dw_tests
st_1 st_1
st_sort_date st_sort_date
st_sort_billing_id st_sort_billing_id
st_sort_patient st_sort_patient
st_sort_description st_sort_description
st_sort_ascending st_sort_ascending
st_sort_descending st_sort_descending
st_primary_provider st_primary_provider
st_primary_provider_title st_primary_provider_title
cb_all_providers cb_all_providers
cb_print cb_print
st_office st_office
st_filter st_filter
st_office_title st_office_title
st_patient_name st_patient_name
cb_clear_filter cb_clear_filter
st_patient st_patient
cb_ok cb_ok
pb_up pb_up
st_page st_page
pb_down pb_down
r_1 r_1
end type
global w_outstanding_tests w_outstanding_tests

type variables
string                     sort_column,sort_direction
string                     primary_provider_id,viewed_office_id,patient_name
string                     which_provider
u_component_service        service

string observation_type
string treatment_type
string treatment_key

end variables

forward prototypes
public subroutine sort_tests ()
public subroutine perform (long pl_row)
public function integer refresh ()
end prototypes

public subroutine sort_tests ();string ls_sort,ls_temp
string ls_filter

if isnull(primary_provider_id) then
	ls_filter = ""
else
	ls_filter = "("+which_provider + "='" + primary_provider_id + "')"
end if

ls_temp = upper(trim(patient_name))
If Not isnull(ls_temp) and ls_temp <> "" then
	If ls_filter = "" Then
		ls_filter = "(upper(last_name) like '" + ls_temp + "')"
	Else
		ls_filter += " And (upper(last_name) like '" + ls_temp + "')"
	End If
End if

ls_temp = upper(trim(viewed_office_id))
If Not isnull(ls_temp) and ls_temp <> "" then
	If ls_filter = "" Then
		ls_filter = "(upper(office_id)='" + ls_temp + "')"
	Else
		ls_filter += " And (upper(office_id)='" + ls_temp + "')"
	End If
End if
dw_tests.setfilter(ls_filter)
dw_tests.filter()


ls_sort = sort_column + " " + sort_direction
dw_tests.setsort(ls_sort)
dw_tests.sort()
dw_tests.last_page = 0
dw_tests.set_page(1, pb_up, pb_down, st_page)





end subroutine

public subroutine perform (long pl_row);integer li_sts,li_attribute_count
long ll_treatment_id,ll_encounter_id
boolean lb_nested
string ls_cpr_id,ls_service
long selected_row
string ls_treatment_type_description
string ls_treatment_status
str_popup popup
str_popup_return popup_return
u_component_treatment treatment

selected_row = pl_row
lb_nested = false
ls_cpr_id = dw_tests.object.cpr_id[selected_row]
ll_treatment_id = dw_tests.object.treatment_id[selected_row]
ll_encounter_id = dw_tests.object.open_encounter_id[selected_row]

if isnull(current_patient) then
	li_sts = f_set_patient(ls_cpr_id)
	if li_sts <= 0 then
		log.log(this, "selected", "Error loading patient (" + ls_cpr_id + ")", 4)
		return
	end if
else
	if current_patient.cpr_id <> ls_cpr_id then
		log.log(this, "selected", "Current patient not correct (" + current_patient.cpr_id + ", " + ls_cpr_id + ")", 4)
		return
	end if
	lb_nested = true
end if

ls_service = service.get_attribute("treatment_service")
if isnull(ls_service) then ls_service = "TREATMENT_REVIEW"

li_sts = current_patient.treatments.treatment(treatment,ll_treatment_id)
If li_sts > 0 Then
	li_sts = service_list.do_service(ls_cpr_id,ll_encounter_id,ls_service,treatment)

	if not isnull(treatment.treatment_status) then
		dw_tests.deleterow(selected_row)
	end if
End If
dw_tests.clear_selected()

if not lb_nested then
	f_clear_patient()
end if

destroy treatment

end subroutine

public function integer refresh ();integer li_sts


dw_tests.settransobject(sqlca)
dw_tests.retrieve(observation_type, treatment_type, treatment_key)

sort_tests()


return 1


end function

on w_outstanding_tests.create
int iCurrent
call super::create
this.pb_cancel=create pb_cancel
this.dw_tests=create dw_tests
this.st_1=create st_1
this.st_sort_date=create st_sort_date
this.st_sort_billing_id=create st_sort_billing_id
this.st_sort_patient=create st_sort_patient
this.st_sort_description=create st_sort_description
this.st_sort_ascending=create st_sort_ascending
this.st_sort_descending=create st_sort_descending
this.st_primary_provider=create st_primary_provider
this.st_primary_provider_title=create st_primary_provider_title
this.cb_all_providers=create cb_all_providers
this.cb_print=create cb_print
this.st_office=create st_office
this.st_filter=create st_filter
this.st_office_title=create st_office_title
this.st_patient_name=create st_patient_name
this.cb_clear_filter=create cb_clear_filter
this.st_patient=create st_patient
this.cb_ok=create cb_ok
this.pb_up=create pb_up
this.st_page=create st_page
this.pb_down=create pb_down
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_cancel
this.Control[iCurrent+2]=this.dw_tests
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_sort_date
this.Control[iCurrent+5]=this.st_sort_billing_id
this.Control[iCurrent+6]=this.st_sort_patient
this.Control[iCurrent+7]=this.st_sort_description
this.Control[iCurrent+8]=this.st_sort_ascending
this.Control[iCurrent+9]=this.st_sort_descending
this.Control[iCurrent+10]=this.st_primary_provider
this.Control[iCurrent+11]=this.st_primary_provider_title
this.Control[iCurrent+12]=this.cb_all_providers
this.Control[iCurrent+13]=this.cb_print
this.Control[iCurrent+14]=this.st_office
this.Control[iCurrent+15]=this.st_filter
this.Control[iCurrent+16]=this.st_office_title
this.Control[iCurrent+17]=this.st_patient_name
this.Control[iCurrent+18]=this.cb_clear_filter
this.Control[iCurrent+19]=this.st_patient
this.Control[iCurrent+20]=this.cb_ok
this.Control[iCurrent+21]=this.pb_up
this.Control[iCurrent+22]=this.st_page
this.Control[iCurrent+23]=this.pb_down
this.Control[iCurrent+24]=this.r_1
end on

on w_outstanding_tests.destroy
call super::destroy
destroy(this.pb_cancel)
destroy(this.dw_tests)
destroy(this.st_1)
destroy(this.st_sort_date)
destroy(this.st_sort_billing_id)
destroy(this.st_sort_patient)
destroy(this.st_sort_description)
destroy(this.st_sort_ascending)
destroy(this.st_sort_descending)
destroy(this.st_primary_provider)
destroy(this.st_primary_provider_title)
destroy(this.cb_all_providers)
destroy(this.cb_print)
destroy(this.st_office)
destroy(this.st_filter)
destroy(this.st_office_title)
destroy(this.st_patient_name)
destroy(this.cb_clear_filter)
destroy(this.st_patient)
destroy(this.cb_ok)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.r_1)
end on

event open;call super::open;integer	li_count

// get the service object
service = message.powerobjectparm

observation_type = service.get_attribute("observation_type")
if isnull(observation_type) Or len(observation_type) = 0 Then
	observation_type = 'Lab/Test'
end if

treatment_type = service.get_attribute("treatment_type")
treatment_key = service.get_attribute("treatment_key")

long ll_x
long ll_width
long ll_extra

ll_extra = dw_tests.width - 2423
if ll_extra > 200 then
	ll_width = long(256 + (ll_extra * 0.10))
	dw_tests.object.begin_date.width = ll_width
	
	dw_tests.object.billing_id.x = long(dw_tests.object.begin_date.x) + ll_width + 23
	ll_width = long(270 + (ll_extra * 0.10))
	dw_tests.object.billing_id.width = ll_width
	
	dw_tests.object.patient_name.x = long(dw_tests.object.billing_id.x) + ll_width + 23
	ll_width = long(695 + (ll_extra * 0.25))
	dw_tests.object.patient_name.width = ll_width
	
	dw_tests.object.treatment_description.x = long(dw_tests.object.patient_name.x) + ll_width + 27
	ll_width = long(969 + (ll_extra * 0.55))
	dw_tests.object.treatment_description.width = ll_width
end if

st_sort_descending.backcolor = color_object_selected
sort_direction = "D"

st_sort_date.backcolor = color_object_selected
sort_column = "begin_date"

which_provider = "ordered_by"

setnull(primary_provider_id)

SELECT count(*)
INTO :li_count
FROM c_Office
WHERE status = 'OK';
if not tf_check() then
	li_count = 1
end if

if li_count <= 1 then
	st_office_title.visible = false
	st_office.visible = false
	setnull(viewed_office_id)
else
	st_office_title.visible = true
	st_office.visible = true
	st_office.text = office_description
	viewed_office_id = office_id
end if

refresh()


end event

type pb_epro_help from w_window_base`pb_epro_help within w_outstanding_tests
boolean visible = true
integer x = 2638
integer y = 252
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_outstanding_tests
end type

type pb_cancel from u_picture_button within w_outstanding_tests
boolean visible = false
integer x = 2171
integer y = 1464
integer taborder = 60
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type dw_tests from u_dw_pick_list within w_outstanding_tests
integer x = 23
integer y = 260
integer width = 2423
integer height = 1456
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_outstanding_tests"
boolean border = false
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

event selected(long selected_row);perform(selected_row)

end event

type st_1 from statictext within w_outstanding_tests
integer x = 2491
integer y = 712
integer width = 375
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
string text = "Sort By"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_sort_date from statictext within w_outstanding_tests
integer x = 2491
integer y = 800
integer width = 375
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Date"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_sort_billing_id.backcolor = color_object
st_sort_patient.backcolor = color_object
st_sort_description.backcolor = color_object
sort_column = "begin_date"

sort_tests()



end event

type st_sort_billing_id from statictext within w_outstanding_tests
integer x = 2487
integer y = 928
integer width = 375
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "ID"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_sort_date.backcolor = color_object
st_sort_patient.backcolor = color_object
st_sort_description.backcolor = color_object
sort_column = "billing_id"

sort_tests()



end event

type st_sort_patient from statictext within w_outstanding_tests
integer x = 2491
integer y = 1048
integer width = 375
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Name"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_sort_billing_id.backcolor = color_object
st_sort_date.backcolor = color_object
st_sort_description.backcolor = color_object
sort_column = "patient_name"

sort_tests()



end event

type st_sort_description from statictext within w_outstanding_tests
integer x = 2496
integer y = 1172
integer width = 375
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Test"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_sort_billing_id.backcolor = color_object
st_sort_patient.backcolor = color_object
st_sort_date.backcolor = color_object
sort_column = "treatment_description"

sort_tests()



end event

type st_sort_ascending from statictext within w_outstanding_tests
integer x = 2496
integer y = 1340
integer width = 375
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ascending"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_sort_descending.backcolor = color_object
sort_direction = "A"

sort_tests()



end event

type st_sort_descending from statictext within w_outstanding_tests
integer x = 2496
integer y = 1460
integer width = 375
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Descending"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_sort_ascending.backcolor = color_object
sort_direction = "D"

sort_tests()



end event

type st_primary_provider from statictext within w_outstanding_tests
integer x = 631
integer y = 96
integer width = 805
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<All>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;u_user luo_user

luo_user = user_list.pick_user("ALL")
if isnull(luo_user) then return

text = luo_user.user_full_name
backcolor = luo_user.color

primary_provider_id = luo_user.user_id

sort_tests()

cb_all_providers.visible = true

end event

type st_primary_provider_title from statictext within w_outstanding_tests
integer x = 37
integer y = 96
integer width = 576
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
string text = "Ordering Provider:"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if which_provider = "ordered_by" then
	which_provider = "primary_provider_id"
	text = "Primary Provider:"
else
	which_provider = "ordered_by"
	text = "Ordering Provider:"
end if

sort_tests()

end event

type cb_all_providers from commandbutton within w_outstanding_tests
boolean visible = false
integer x = 1445
integer y = 116
integer width = 315
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "All Providers"
end type

event clicked;setnull(primary_provider_id)
st_primary_provider.backcolor = color_object
st_primary_provider.text = "<All>"
visible = false
sort_tests()

end event

type cb_print from commandbutton within w_outstanding_tests
integer x = 2638
integer y = 412
integer width = 229
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Print"
end type

event clicked;string ls_title

ls_title = "Outstanding Labs/Tests as of " + string(today(), date_format_string)
if not isnull(primary_provider_id) then
	ls_title += "~n~rfor " + st_primary_provider.text
end if

dw_tests.setredraw(false)
dw_tests.object.tests_title.text = ls_title
dw_tests.object.datawindow.header.height = 240

dw_tests.print()

dw_tests.object.datawindow.header.height = 0
dw_tests.setredraw(true)

end event

type st_office from statictext within w_outstanding_tests
integer x = 1810
integer y = 96
integer width = 475
integer height = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

popup.dataobject = "dw_office_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<All>"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	text = "<All>"
	viewed_office_id = ""
else
	viewed_office_id = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

sort_tests()


end event

type st_filter from statictext within w_outstanding_tests
integer x = 41
integer y = 20
integer width = 325
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
string text = "Filter By:"
boolean focusrectangle = false
end type

type st_office_title from statictext within w_outstanding_tests
integer x = 1810
integer y = 24
integer width = 475
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "By Office"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_patient_name from statictext within w_outstanding_tests
integer x = 2341
integer y = 24
integer width = 526
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "By Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_clear_filter from commandbutton within w_outstanding_tests
integer x = 2491
integer y = 568
integer width = 375
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear filter"
end type

event clicked;setnull(primary_provider_id)
setnull(viewed_office_id)
setnull(patient_name)
st_patient.text = ""
st_office.text = ""
sort_tests()

end event

type st_patient from statictext within w_outstanding_tests
integer x = 2341
integer y = 96
integer width = 526
integer height = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_null
long ll_count
str_popup_return popup_return
integer li_sts

setnull(ls_null)

open(w_pop_get_string_abc)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

patient_name = popup_return.items[1]
text = popup_return.descriptions[1]
sort_tests()




end event

type cb_ok from commandbutton within w_outstanding_tests
integer x = 2496
integer y = 1604
integer width = 375
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
popup_return.items[1] = "CLOSE"

closewithreturn(parent, popup_return)

end event

type pb_up from u_picture_button within w_outstanding_tests
integer x = 2437
integer y = 264
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_tests.current_page

dw_tests.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_outstanding_tests
integer x = 2199
integer y = 200
integer width = 366
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within w_outstanding_tests
integer x = 2437
integer y = 400
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_tests.current_page
li_last_page = dw_tests.last_page

dw_tests.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type r_1 from rectangle within w_outstanding_tests
integer linethickness = 1
long fillcolor = 33538240
integer x = 2469
integer y = 700
integer width = 421
integer height = 872
end type

