$PBExportHeader$w_svc_referrals_by_day.srw
forward
global type w_svc_referrals_by_day from w_window_base
end type
type st_consultant from statictext within w_svc_referrals_by_day
end type
type cb_print from commandbutton within w_svc_referrals_by_day
end type
type st_consultant_title from statictext within w_svc_referrals_by_day
end type
type cb_ok from commandbutton within w_svc_referrals_by_day
end type
type pb_up from u_picture_button within w_svc_referrals_by_day
end type
type st_page from statictext within w_svc_referrals_by_day
end type
type pb_down from u_picture_button within w_svc_referrals_by_day
end type
type cb_next_day from commandbutton within w_svc_referrals_by_day
end type
type cb_prev_day from commandbutton within w_svc_referrals_by_day
end type
type dw_tests from u_dw_pick_list within w_svc_referrals_by_day
end type
type st_date from statictext within w_svc_referrals_by_day
end type
type st_date_title from statictext within w_svc_referrals_by_day
end type
type st_office from statictext within w_svc_referrals_by_day
end type
type st_office_title from statictext within w_svc_referrals_by_day
end type
end forward

global type w_svc_referrals_by_day from w_window_base
string title = "Outstanding Labs/Tests"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_consultant st_consultant
cb_print cb_print
st_consultant_title st_consultant_title
cb_ok cb_ok
pb_up pb_up
st_page st_page
pb_down pb_down
cb_next_day cb_next_day
cb_prev_day cb_prev_day
dw_tests dw_tests
st_date st_date
st_date_title st_date_title
st_office st_office
st_office_title st_office_title
end type
global w_svc_referrals_by_day w_svc_referrals_by_day

type variables
string consultant_id
string specialty_id
string                     viewed_office_id
u_component_service        service

date display_date



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

public subroutine perform (long pl_row);integer li_sts
long ll_treatment_id,ll_encounter_id
string ls_cpr_id
long selected_row
long ll_menu_id
str_service_info lstr_service
str_attributes lstr_attributes

selected_row = pl_row

ls_cpr_id = dw_tests.object.cpr_id[selected_row]
ll_treatment_id = dw_tests.object.treatment_id[selected_row]
ll_encounter_id = dw_tests.object.open_encounter_id[selected_row]

f_attribute_add_attribute(lstr_attributes, "cpr_id", ls_cpr_id)
f_attribute_add_attribute(lstr_attributes, "treatment_id", string(ll_treatment_id))
f_attribute_add_attribute(lstr_attributes, "encounter_id", string(ll_encounter_id))

service.get_attribute("treatment_menu_id", ll_menu_id)
if isnull(ll_menu_id) then
	lstr_service.service = service.get_attribute("treatment_service")
	if isnull(lstr_service.service) then lstr_service.service = "TREATMENT_REVIEW"
	
	lstr_service.attributes = lstr_attributes
	
	li_sts = service_list.do_service(lstr_service)
else
	f_display_menu_with_attributes(ll_menu_id, true, lstr_attributes)
end if

dw_tests.clear_selected()


end subroutine

public function integer refresh ();//
//
//
integer li_sts
datetime ldt_date, ldt_null
string ls_filter

setnull(ldt_null)

st_date.text = string(display_date)

st_consultant.text = datalist.consultant_description(consultant_id)

dw_tests.setredraw(false)

ldt_date = datetime(display_date, time(""))
li_sts = dw_tests.retrieve(consultant_id, ldt_date, ldt_null)

if len(viewed_office_id) > 0 then
	ls_filter = "office_id='" + viewed_office_id + "'"
else
	ls_filter = ""
end if

dw_tests.setfilter(ls_filter)
dw_tests.filter()

dw_tests.setredraw(true)


return 1

end function

on w_svc_referrals_by_day.create
int iCurrent
call super::create
this.st_consultant=create st_consultant
this.cb_print=create cb_print
this.st_consultant_title=create st_consultant_title
this.cb_ok=create cb_ok
this.pb_up=create pb_up
this.st_page=create st_page
this.pb_down=create pb_down
this.cb_next_day=create cb_next_day
this.cb_prev_day=create cb_prev_day
this.dw_tests=create dw_tests
this.st_date=create st_date
this.st_date_title=create st_date_title
this.st_office=create st_office
this.st_office_title=create st_office_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_consultant
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.st_consultant_title
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.pb_up
this.Control[iCurrent+6]=this.st_page
this.Control[iCurrent+7]=this.pb_down
this.Control[iCurrent+8]=this.cb_next_day
this.Control[iCurrent+9]=this.cb_prev_day
this.Control[iCurrent+10]=this.dw_tests
this.Control[iCurrent+11]=this.st_date
this.Control[iCurrent+12]=this.st_date_title
this.Control[iCurrent+13]=this.st_office
this.Control[iCurrent+14]=this.st_office_title
end on

on w_svc_referrals_by_day.destroy
call super::destroy
destroy(this.st_consultant)
destroy(this.cb_print)
destroy(this.st_consultant_title)
destroy(this.cb_ok)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.cb_next_day)
destroy(this.cb_prev_day)
destroy(this.dw_tests)
destroy(this.st_date)
destroy(this.st_date_title)
destroy(this.st_office)
destroy(this.st_office_title)
end on

event open;call super::open;integer	li_count
string   ls_observation_type
str_popup_return popup_return
long ll_menu_id

popup_return.item_count = 1
popup_return.items[1] = "ERROR"


// get the service object
service = message.powerobjectparm

dw_tests.settransobject(sqlca)

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
	viewed_office_id = gnv_app.office_id
end if

display_date = today()

consultant_id = service.get_attribute("consultant_id")
if isnull(consultant_id) then
	specialty_id = service.get_attribute("specialty_id")
	if isnull(specialty_id) then
		specialty_id = "$LAB"
	end if
	st_consultant.event POST clicked()
else
	SELECT specialty_id
	INTO :specialty_id
	FROM c_Consultant
	WHERE consultant_id = :consultant_id;
	if not tf_check() then
		closewithreturn(this, popup_return)
		return
	end if
	refresh()
end if


service.get_attribute("menu_id", ll_menu_id)
if not isnull(ll_menu_id) then
	paint_menu(ll_menu_id)
end if

end event

event resize;call super::resize;

st_consultant_title.x = left_gap
st_consultant_title.y = top_gap

st_office_title.x = st_consultant_title.x + st_consultant_title.width + 160
st_office_title.y = top_gap

cb_prev_day.x = st_office_title.x + st_office_title.width + 160
cb_prev_day.y = top_gap + st_date_title.height + 16

st_date_title.x = cb_prev_day.x + cb_prev_day.width + 16
st_date_title.y = top_gap

st_date.x = st_date_title.x
st_date.y = cb_prev_day.y

cb_next_day.x = st_date.x + st_date.width + 16
cb_next_day.y = cb_prev_day.y

pb_epro_help.x = width - pb_epro_help.width - right_gap
pb_epro_help.y = top_gap

cb_print.x = pb_epro_help.x - cb_print.width - 32
cb_print.y = top_gap

pb_down.x = width - pb_down.width - right_gap
pb_down.y = pb_epro_help.y + pb_epro_help.height + 32

pb_up.x = pb_down.x - pb_up.width - 16
pb_up.y = pb_down.y

st_page.x = pb_up.x - st_page.width - 16
st_page.y = pb_up.y

dw_tests.x = left_gap
dw_tests.y = pb_down.y + pb_down.height + 32
dw_tests.width = width - left_gap - right_gap
dw_tests.height = height - dw_tests.y - 250

cb_ok.x = width - right_gap - cb_ok.width
cb_ok.y = dw_tests.y + dw_tests.height + 32





end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_referrals_by_day
boolean visible = true
integer x = 2674
integer y = 12
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_referrals_by_day
integer x = 0
integer y = 1576
end type

type st_consultant from statictext within w_svc_referrals_by_day
integer x = 37
integer y = 112
integer width = 603
integer height = 156
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Labcorp at Eggleston"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_pick_users lstr_pick_users
integer li_sts

lstr_pick_users.hide_users = true
lstr_pick_users.cpr_id = service.cpr_id
lstr_pick_users.actor_class = "Consultant"
lstr_pick_users.specialty_id = specialty_id
lstr_pick_users.pick_screen_title = "Select Refer-To Provider"

li_sts = user_list.pick_users(lstr_pick_users)
if lstr_pick_users.selected_users.user_count < 1 then return

consultant_id = lstr_pick_users.selected_users.user[1].user_id


refresh()


end event

type cb_print from commandbutton within w_svc_referrals_by_day
integer x = 2432
integer y = 16
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

event clicked;dw_tests.print(false, true)

end event

type st_consultant_title from statictext within w_svc_referrals_by_day
integer x = 37
integer y = 32
integer width = 576
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Referred To"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_svc_referrals_by_day
integer x = 2313
integer y = 1604
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

type pb_up from u_picture_button within w_svc_referrals_by_day
integer x = 2555
integer y = 132
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

type st_page from statictext within w_svc_referrals_by_day
integer x = 2395
integer y = 136
integer width = 137
integer height = 116
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within w_svc_referrals_by_day
integer x = 2720
integer y = 136
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

type cb_next_day from commandbutton within w_svc_referrals_by_day
integer x = 2021
integer y = 112
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

event clicked;display_date = relativedate(display_date, 1)
refresh()

end event

type cb_prev_day from commandbutton within w_svc_referrals_by_day
integer x = 1431
integer y = 112
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

event clicked;display_date = relativedate(display_date, -1)
refresh()

end event

type dw_tests from u_dw_pick_list within w_svc_referrals_by_day
integer x = 23
integer y = 260
integer width = 2862
integer height = 1308
integer taborder = 30
string dataobject = "dw_jmj_get_treatments_by_consultant"
boolean vscrollbar = true
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

event selected;perform(selected_row)
refresh()

end event

type st_date from statictext within w_svc_referrals_by_day
integer x = 1559
integer y = 112
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

popup.title = "Select Appointment Date"
popup.data_row_count = 1
popup.items[1] = string(display_date, date_format_string)

openwithparm(w_pick_date, popup)
popup_return = message.powerobjectparm

if not isnull(popup_return.item) then
	display_date = date(popup_return.item)
	refresh()
end if

end event

type st_date_title from statictext within w_svc_referrals_by_day
integer x = 1559
integer y = 36
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
long backcolor = 7191717
string text = "On Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_office from statictext within w_svc_referrals_by_day
integer x = 786
integer y = 108
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

refresh()


end event

type st_office_title from statictext within w_svc_referrals_by_day
integer x = 786
integer y = 36
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
long backcolor = 7191717
string text = "From Office"
alignment alignment = center!
boolean focusrectangle = false
end type

