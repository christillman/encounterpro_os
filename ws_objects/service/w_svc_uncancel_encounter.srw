HA$PBExportHeader$w_svc_uncancel_encounter.srw
forward
global type w_svc_uncancel_encounter from w_window_base
end type
type cb_finished from commandbutton within w_svc_uncancel_encounter
end type
type cb_cancel from commandbutton within w_svc_uncancel_encounter
end type
type st_title from statictext within w_svc_uncancel_encounter
end type
type dw_encounters from u_dw_pick_list within w_svc_uncancel_encounter
end type
end forward

global type w_svc_uncancel_encounter from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
cb_finished cb_finished
cb_cancel cb_cancel
st_title st_title
dw_encounters dw_encounters
end type
global w_svc_uncancel_encounter w_svc_uncancel_encounter

type variables
u_component_service	service

string summary_report_id
long summary_display_script_id
string report_service

end variables

on w_svc_uncancel_encounter.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.cb_cancel=create cb_cancel
this.st_title=create st_title
this.dw_encounters=create dw_encounters
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.dw_encounters
end on

on w_svc_uncancel_encounter.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.cb_cancel)
destroy(this.st_title)
destroy(this.dw_encounters)
end on

event open;call super::open;integer li_sts
integer ll_menu_id
string ls_cpr_id
long ll_rows
long ll_row
string ls_find

service = message.powerobjectparm

if isnull(current_patient) then
	log.log(this, "open", "No patient context", 4)
	return -1
end if

// Set the title and sizes
If isvalid(current_patient) and not isnull(current_patient) Then
	title = current_patient.id_line()
End If

if len(st_title.text) > 42 then
	if len(st_title.text) > 60 then
		if len(st_title.text) > 70 then
			st_title.textsize = -10
		else
			st_title.textsize = -12
		end if
	else
		st_title.textsize = -14
	end if
else
	st_title.textsize = -18
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

cb_finished.enabled = false

dw_encounters.setfilter("")
dw_encounters.settransobject(sqlca)
ll_rows = dw_encounters.retrieve(current_patient.cpr_id, '%', '%', "CANCELED")

if ll_rows = 1 then
	cb_finished.enabled = true
else
	if lower(service.context_object) = "encounter" and not isnull(service.encounter_id) then
		ls_find = "encounter_id=" + string(service.encounter_id)
		ll_row = dw_encounters.find(ls_find, 1, ll_rows)
		if ll_row > 0 then
			dw_encounters.setfilter(ls_find)
			dw_encounters.filter()
			cb_finished.enabled = true
		end if
	end if
end if

summary_report_id = datalist.get_preference("PREFERENCES", "summary_report_id")
if isnull(summary_report_id) then summary_report_id = "{4B657EFA-AB67-482B-9FAB-1764440DF116}"

summary_display_script_id = long(datalist.get_preference("PREFERENCES", "default_encounter_display_script_id"))

report_service = datalist.get_preference("PREFERENCES", "summary_report_service")
if isnull(report_service) then report_service = "REPORT"


end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_uncancel_encounter
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_uncancel_encounter
end type

type cb_finished from commandbutton within w_svc_uncancel_encounter
integer x = 1138
integer y = 1308
integer width = 686
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Uncancel Encounter"
end type

event clicked;string ls_warning
str_popup_return popup_return
integer li_sts
long ll_encounter_id
long ll_row
string ls_progress_key
string ls_progress
datetime ldt_progress_date_time
long ll_risk_level
long ll_attachment_id
long ll_patient_workplan_item_id
integer li_please_wait_index

ls_warning = service.get_attribute("Are You Sure Text")
if isnull(ls_warning) then
	ls_warning = "Are you sure you want to uncancel this encounter?"
end if

openwithparm(w_pop_yes_no_alert, ls_warning)
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

if dw_encounters.rowcount() = 1 then
	ll_row = 1
else
	ll_row = dw_encounters.get_selected_row()
	if ll_row <= 0 then
		openwithparm(w_pop_message, "Please select an encounter")
		return
	end if
end if

ll_encounter_id = dw_encounters.object.encounter_id[ll_row]
setnull(ls_progress_key)
setnull(ls_progress)
setnull(ldt_progress_date_time)
setnull(ll_risk_level)
setnull(ll_attachment_id)
setnull(ll_patient_workplan_item_id)

li_please_wait_index = f_please_wait_open()
li_sts = f_set_progress(current_patient.cpr_id, &
								"Encounter", &
								ll_encounter_id, &
								"UNCancelled", &
								ls_progress_key, &
								ls_progress, &
								ldt_progress_date_time, &
								ll_risk_level, &
								ll_attachment_id, &
								ll_patient_workplan_item_id)
f_please_wait_close(li_please_wait_index)

if li_sts <= 0 then
	openwithparm(w_pop_message, "Uncancelling Encounter Failed.  Check the error log and try again later.")
	return
else
	openwithparm(w_pop_message, "Uncancelling Encounter Succeeded.")
end if

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_cancel from commandbutton within w_svc_uncancel_encounter
integer x = 2391
integer y = 1592
integer width = 443
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"

closewithreturn(parent, popup_return)
end event

type st_title from statictext within w_svc_uncancel_encounter
integer width = 2921
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Uncancel Encounter Utility"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_encounters from u_dw_pick_list within w_svc_uncancel_encounter
integer x = 361
integer y = 280
integer width = 2331
integer height = 924
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_sp_get_encounter_list"
boolean border = false
end type

event selected;call super::selected;if rowcount() = 1 then
	clear_selected()
end if

cb_finished.enabled = true

end event

event computed_clicked;call super::computed_clicked;str_attributes lstr_attributes
long ll_encounter_id

ll_encounter_id = object.encounter_id[clicked_row]

f_attribute_add_attribute(lstr_attributes, "report_id", summary_report_id)
f_attribute_add_attribute(lstr_attributes, "display_script_id", string(summary_display_script_id))
f_attribute_add_attribute(lstr_attributes, "destination", "SCREEN")

service_list.do_service(current_patient.cpr_id, ll_encounter_id, report_service, lstr_attributes)


end event

event unselected;call super::unselected;if rowcount() > 1 then
	cb_finished.enabled = false
end if



end event

