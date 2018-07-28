HA$PBExportHeader$w_log_display.srw
forward
global type w_log_display from w_window_base
end type
type dw_log from u_dw_pick_list within w_log_display
end type
type cb_ok from commandbutton within w_log_display
end type
type st_title from statictext within w_log_display
end type
type st_min_severity_title from statictext within w_log_display
end type
type st_min_severity from statictext within w_log_display
end type
type st_log_date from statictext within w_log_display
end type
type st_log_date_title from statictext within w_log_display
end type
type st_computer_title from statictext within w_log_display
end type
type st_computer from statictext within w_log_display
end type
type cb_clear_date from commandbutton within w_log_display
end type
type cb_clear_severity from commandbutton within w_log_display
end type
type cb_clear_computer from commandbutton within w_log_display
end type
type rb_ascending from radiobutton within w_log_display
end type
type rb_descending from radiobutton within w_log_display
end type
type cb_send_events from commandbutton within w_log_display
end type
type str_point from structure within w_log_display
end type
end forward

type str_point from structure
	long		x
	long		y
end type

global type w_log_display from w_window_base
integer width = 2962
integer height = 1864
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
dw_log dw_log
cb_ok cb_ok
st_title st_title
st_min_severity_title st_min_severity_title
st_min_severity st_min_severity
st_log_date st_log_date
st_log_date_title st_log_date_title
st_computer_title st_computer_title
st_computer st_computer
cb_clear_date cb_clear_date
cb_clear_severity cb_clear_severity
cb_clear_computer cb_clear_computer
rb_ascending rb_ascending
rb_descending rb_descending
cb_send_events cb_send_events
end type
global w_log_display w_log_display

type prototypes
SUBROUTINE GetCursorPos( ref str_point lppt ) LIBRARY "USER32.DLL" alias for "GetCursorPos;Ansi"

end prototypes

type variables
str_log_search original_search
str_log_search current_search

string severities[] = {"DEBUG", &
                             "INFORMATION", &
                             "WARNING", &
                             "ERROR", &
                             "FATAL ERROR", &
                             "UNKNOWN" }


end variables

forward prototypes
public function integer refresh ()
private function long order_document (string ps_description)
end prototypes

public function integer refresh ();
if isnull(current_search.computer_id) then
	st_computer.text = "<Any>"
	cb_clear_computer.visible = true
else
	st_computer.text = f_computer_description(current_search.computer_id)
	cb_clear_computer.visible = false
end if


if isnull(current_search.begin_date) then
	st_log_date.text = "<Any>"
	cb_clear_date.visible = false
else
	st_log_date.text = string(date(current_search.begin_date))
	cb_clear_date.visible = true
end if

if current_search.min_severity > 0 and current_search.min_severity < upperbound(severities) then
	st_min_severity.text = severities[current_search.min_severity]
	cb_clear_severity.visible = false
else
	st_min_severity.text = "<Any>"
	cb_clear_severity.visible = true
end if

if rb_ascending.checked then
	dw_log.setsort("log_id asc")
else
	dw_log.setsort("log_id desc")
end if

dw_log.retrieve(current_search.computer_id, current_search.min_severity, current_search.cpr_id, current_search.user_id, current_search.begin_date, current_search.end_date)

cb_send_events.visible = false

return 1

end function

private function long order_document (string ps_description);long i
long ll_patient_workplan_item_id
string ls_dispatch_method
string ls_ordered_for
long ll_patient_workplan_id
string ls_description
string ls_purpose
boolean lb_create_now
boolean lb_send_now
string ls_create_from
string ls_send_from
integer li_sts
u_ds_data luo_data
long ll_count
string ls_ordered_by
string ls_default_dispatch_method
boolean lb_found
boolean lb_suppress
string ls_document_type
str_attributes lstr_attributes

string ls_cpr_id
long ll_encounter_id
string ls_context_object
long ll_object_key
string ls_report_id
boolean lb_report_configured

setnull(ls_cpr_id)
setnull(ll_encounter_id)
ls_context_object = "General"
setnull(ll_object_key)
setnull(ls_report_id)
lb_report_configured = true


ls_ordered_by = current_user.user_id

lb_create_now = false
lb_send_now = true
ls_description = ps_description
ls_create_from = "Server"
ls_send_from = "Server"

ls_purpose = "Message"
ls_document_type = "XML.JMJMESSAGE"

ll_patient_workplan_id = 0

ls_ordered_for = "0^JMJSupport"
ls_dispatch_method = "EproLink"


if len(ls_document_type) > 0 then
	f_attribute_add_attribute(lstr_attributes, "document_type", ls_document_type)
end if

ll_patient_workplan_item_id = f_order_document( ls_cpr_id, &
									ll_encounter_id, &
									ls_context_object, &
									ll_object_key, &
									ls_report_id, &
									ls_dispatch_method, &
									ls_ordered_for, &
									current_user.user_id, &
									ls_description, &
									ls_purpose, &
									lb_create_now, &
									lb_send_now, &
									ls_create_from, &
									ls_send_from, &
									lb_report_configured, &
									lstr_attributes)
if ll_patient_workplan_item_id <= 0 then
	openwithparm(w_pop_message, "Error Ordering Document")
	return -1
end if

openwithparm(w_pop_message, "Successfully Ordered Document ~"" + ls_description + "~"")


return ll_patient_workplan_item_id

end function

event open;call super::open;
original_search = message.powerobjectparm

// massage search fields
if original_search.computer_id <= 0 then setnull(original_search.computer_id)

if trim(original_search.user_id) = "" then setnull(original_search.user_id)

if date(original_search.begin_date) < date("1/1/1990") then setnull(original_search.begin_date)
if date(original_search.end_date)< date("1/1/1990") then setnull(original_search.end_date)

if not isnull(original_search.begin_date) and isnull(original_search.end_date) then
	original_search.end_date = datetime(relativedate(date(original_search.begin_date), 1), time("00:00"))
end if

if original_search.min_severity <= 0 then setnull(original_search.min_severity)

if trim(original_search.cpr_id) = "" then setnull(original_search.cpr_id)

current_search = original_search

dw_log.settransobject(sqlca)

refresh()

end event

on w_log_display.create
int iCurrent
call super::create
this.dw_log=create dw_log
this.cb_ok=create cb_ok
this.st_title=create st_title
this.st_min_severity_title=create st_min_severity_title
this.st_min_severity=create st_min_severity
this.st_log_date=create st_log_date
this.st_log_date_title=create st_log_date_title
this.st_computer_title=create st_computer_title
this.st_computer=create st_computer
this.cb_clear_date=create cb_clear_date
this.cb_clear_severity=create cb_clear_severity
this.cb_clear_computer=create cb_clear_computer
this.rb_ascending=create rb_ascending
this.rb_descending=create rb_descending
this.cb_send_events=create cb_send_events
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_log
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_min_severity_title
this.Control[iCurrent+5]=this.st_min_severity
this.Control[iCurrent+6]=this.st_log_date
this.Control[iCurrent+7]=this.st_log_date_title
this.Control[iCurrent+8]=this.st_computer_title
this.Control[iCurrent+9]=this.st_computer
this.Control[iCurrent+10]=this.cb_clear_date
this.Control[iCurrent+11]=this.cb_clear_severity
this.Control[iCurrent+12]=this.cb_clear_computer
this.Control[iCurrent+13]=this.rb_ascending
this.Control[iCurrent+14]=this.rb_descending
this.Control[iCurrent+15]=this.cb_send_events
end on

on w_log_display.destroy
call super::destroy
destroy(this.dw_log)
destroy(this.cb_ok)
destroy(this.st_title)
destroy(this.st_min_severity_title)
destroy(this.st_min_severity)
destroy(this.st_log_date)
destroy(this.st_log_date_title)
destroy(this.st_computer_title)
destroy(this.st_computer)
destroy(this.cb_clear_date)
destroy(this.cb_clear_severity)
destroy(this.cb_clear_computer)
destroy(this.rb_ascending)
destroy(this.rb_descending)
destroy(this.cb_send_events)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_log_display
integer x = 2866
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_log_display
integer x = 0
integer y = 1780
end type

type dw_log from u_dw_pick_list within w_log_display
integer x = 18
integer y = 424
integer width = 2894
integer height = 1196
integer taborder = 10
string dataobject = "dw_jmj_log_search"
boolean hscrollbar = true
boolean vscrollbar = true
boolean multiselect = true
end type

event post_click;call super::post_click;long ll_row

ll_row = get_selected_row()

if ll_row > 0 then
	cb_send_events.visible = true
else
	cb_send_events.visible = false
end if


end event

type cb_ok from commandbutton within w_log_display
integer x = 2318
integer y = 1688
integer width = 558
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean cancel = true
boolean default = true
end type

event clicked;
close(parent)

end event

type st_title from statictext within w_log_display
integer width = 2926
integer height = 100
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "EncounterPRO Event Log"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_min_severity_title from statictext within w_log_display
integer x = 1929
integer y = 140
integer width = 480
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Min Severity"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_min_severity from statictext within w_log_display
integer x = 1929
integer y = 212
integer width = 480
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Information"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 5
popup.items = severities

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(current_search.min_severity)
else
	current_search.min_severity = popup_return.item_indexes[1]
end if

refresh()

end event

type st_log_date from statictext within w_log_display
integer x = 1225
integer y = 212
integer width = 480
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

event clicked;string ls_text
date ld_date

ld_date = date(current_search.begin_date)

ls_text = f_select_date(ld_date, "Select Log Date")
if isnull(ls_text) then return

text = ls_text

current_search.begin_date = datetime(date(ls_text), time("00:00"))
current_search.end_date = datetime(relativedate(date(ls_text), 1), time("00:00"))

refresh()

end event

type st_log_date_title from statictext within w_log_display
integer x = 1275
integer y = 140
integer width = 375
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_computer_title from statictext within w_log_display
integer x = 242
integer y = 140
integer width = 759
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Computer"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_computer from statictext within w_log_display
integer x = 242
integer y = 212
integer width = 759
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Information"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_office_id

popup.dataobject = "dw_office_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.auto_singleton = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(current_search.computer_id)
	refresh()
	return
else
	ls_office_id = popup_return.items[1]
end if

popup.dataobject = "dw_computer_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = false
popup.argument_count = 1
popup.argument[1] = ls_office_id
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

current_search.computer_id = long(popup_return.items[1])

refresh()

end event

type cb_clear_date from commandbutton within w_log_display
integer x = 1358
integer y = 312
integer width = 215
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(current_search.begin_date)
setnull(current_search.end_date)

refresh()

end event

type cb_clear_severity from commandbutton within w_log_display
integer x = 2062
integer y = 312
integer width = 215
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(current_search.min_severity)

refresh()

end event

type cb_clear_computer from commandbutton within w_log_display
integer x = 517
integer y = 312
integer width = 215
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(current_search.computer_id)

refresh()

end event

type rb_ascending from radiobutton within w_log_display
integer x = 18
integer y = 1632
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Ascending"
end type

event clicked;refresh()

end event

type rb_descending from radiobutton within w_log_display
integer x = 485
integer y = 1632
integer width = 421
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Descending"
boolean checked = true
end type

event clicked;refresh()

end event

type cb_send_events from commandbutton within w_log_display
integer x = 1111
integer y = 1656
integer width = 704
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Send Selected Events ..."
end type

event clicked;u_ds_data luo_data
long ll_row
string ls_filename
Integer					li_sts
string lsa_paths[]
string lsa_files[]
string ls_filter
integer li_count
string ls_extension

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_jmj_log_search")


ll_row = dw_log.get_selected_row()
DO WHILE ll_row > 0
	dw_log.RowsCopy(ll_row, ll_row, Primary!, luo_data, luo_data.rowcount() + 1, Primary!)
	
	ll_row = dw_log.get_selected_row(ll_row)
LOOP

ls_extension = "xml"

ls_filter = upper(ls_extension) + " Files (*." + lower(ls_extension) + "), *." + lower(ls_extension)

ls_filename = windows_api.comdlg32.getsavefilename( handle(w_main), &
															"Save Log Events To File", &
															ls_filter)
if isnull(ls_filename) then return -1

if lower(right(ls_filename, len(ls_extension))) <> lower(ls_extension) then
	ls_filename += "." + ls_extension
end if


luo_data.saveas(ls_filename, XML!, false)


end event

