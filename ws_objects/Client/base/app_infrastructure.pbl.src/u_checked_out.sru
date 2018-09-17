$PBExportHeader$u_checked_out.sru
$PBExportComments$fixed #228; put valid encounter reference at menu()
forward
global type u_checked_out from u_main_tabpage_base
end type
type st_mode_title from statictext within u_checked_out
end type
type st_error from statictext within u_checked_out
end type
type cb_billing_status from commandbutton within u_checked_out
end type
type st_mode from statictext within u_checked_out
end type
type st_billing_status from statictext within u_checked_out
end type
type pb_help from u_pb_help_button within u_checked_out
end type
type cb_refresh from commandbutton within u_checked_out
end type
type pb_up from u_picture_button within u_checked_out
end type
type pb_down from u_picture_button within u_checked_out
end type
type st_page from statictext within u_checked_out
end type
type cb_today from commandbutton within u_checked_out
end type
type st_count from statictext within u_checked_out
end type
type st_pick_encounter_type from statictext within u_checked_out
end type
type st_type_title from statictext within u_checked_out
end type
type st_office from statictext within u_checked_out
end type
type cb_legend from commandbutton within u_checked_out
end type
type cb_next_day from commandbutton within u_checked_out
end type
type cb_prev_day from commandbutton within u_checked_out
end type
type pb_pick_date from u_picture_button within u_checked_out
end type
type st_title from statictext within u_checked_out
end type
type dw_checked_out from u_dw_pick_list within u_checked_out
end type
type st_filter_title from statictext within u_checked_out
end type
end forward

global type u_checked_out from u_main_tabpage_base
integer width = 2414
integer height = 1704
long tabbackcolor = 16777215
event resized ( )
st_mode_title st_mode_title
st_error st_error
cb_billing_status cb_billing_status
st_mode st_mode
st_billing_status st_billing_status
pb_help pb_help
cb_refresh cb_refresh
pb_up pb_up
pb_down pb_down
st_page st_page
cb_today cb_today
st_count st_count
st_pick_encounter_type st_pick_encounter_type
st_type_title st_type_title
st_office st_office
cb_legend cb_legend
cb_next_day cb_next_day
cb_prev_day cb_prev_day
pb_pick_date pb_pick_date
st_title st_title
dw_checked_out dw_checked_out
st_filter_title st_filter_title
end type
global u_checked_out u_checked_out

type variables
u_str_encounter encounter

date encounter_date

long color_not_billed
long color_not_posted
long color_posted
long color_error
long color_retry

string filter_office_id
string filter_description
string filter_user_id

string indirect_flag
string encounter_type
string filter_billing_status

boolean single_office

string code_check_review_service
string code_check_perform_service

long last_width
long last_height

end variables

forward prototypes
public subroutine initialize ()
public subroutine do_cpr ()
public subroutine refresh_tab ()
public function integer count_encounters (string ps_office_id, datetime pdt_encounter_date)
public subroutine menu (long pl_row)
public subroutine refresh ()
end prototypes

event resized();
// Set the datawindow width and height
dw_checked_out.height = height
dw_checked_out.width = width - 832

if f_is_module_licensed("Code Checker") then
	// Set the controls on the datawindow
	dw_checked_out.object.patient.width = dw_checked_out.width - 636
	dw_checked_out.object.compute_code_checker.visible = true
else
	dw_checked_out.object.patient.width = dw_checked_out.width - 476
	dw_checked_out.object.compute_code_checker.visible = false
end if


pb_down.x = dw_checked_out.width + 27
pb_up.x = dw_checked_out.width + 27
st_page.x = dw_checked_out.width + 173

// Set control positions
st_title.x = dw_checked_out.x + dw_checked_out.width + 20
st_title.width = width - st_title.x - 20
st_count.x = st_title.x
st_count.width = st_title.width

st_filter_title.x = dw_checked_out.x + dw_checked_out.width + 50
st_filter_title.width = width - st_filter_title.x - 50

st_office.x = st_filter_title.x
st_office.width = st_filter_title.width

st_mode_title.x = st_filter_title.x
st_mode_title.width = st_filter_title.width

st_mode.x = st_filter_title.x
st_mode.width = st_filter_title.width

st_type_title.x = st_filter_title.x
st_type_title.width = st_filter_title.width

st_pick_encounter_type.x = st_filter_title.x
st_pick_encounter_type.width = st_filter_title.width

// right justify legend and refresh with filter box
cb_legend.x = st_office.x + st_office.width - cb_legend.width
cb_refresh.x = cb_legend.x

st_billing_status.x = dw_checked_out.width + 50
cb_billing_status.x = dw_checked_out.width + 50
st_error.x = dw_checked_out.width + 580

pb_help.x = dw_checked_out.width + 27
st_count.x = dw_checked_out.width + 27
pb_pick_date.x = dw_checked_out.width + 178
cb_prev_day.x = dw_checked_out.width + 429
cb_next_day.x = dw_checked_out.width + 557
cb_today.x = dw_checked_out.width + 448

last_width = width
last_height = height


end event

public subroutine initialize ();integer li_count

encounter_date = today()
dw_checked_out.settransobject(sqlca)

color_not_billed = f_get_system_preference_int("PREFERENCES", "checkout_color_not_billed")
if isnull(color_not_billed) then color_not_billed = rgb(192,192,192)

color_error = f_get_system_preference_int("PREFERENCES", "checkout_color_error")
if isnull(color_error) then color_error = rgb(255,128,128)

color_not_posted = f_get_system_preference_int("PREFERENCES", "checkout_color_not_posted")
if isnull(color_not_posted) then color_not_posted = rgb(128,255,255)

color_posted = f_get_system_preference_int("PREFERENCES", "checkout_color_posted")
if isnull(color_posted) then color_posted = rgb(128,255,128)

color_retry = f_get_system_preference_int("PREFERENCES", "checkout_color_retry")
if isnull(color_retry) then color_retry = rgb(255,255,128)

code_check_perform_service = f_get_system_preference("PREFERENCES", "code_check_perform_service")
if isnull(code_check_perform_service) then code_check_perform_service = "Code Check Perform"

code_check_review_service = f_get_system_preference("PREFERENCES", "code_check_review_service")
if isnull(code_check_review_service) then code_check_review_service = "Code Check Review"


SELECT count(*)
INTO :li_count
FROM c_Office
WHERE status = 'OK';
if not tf_check() then
	li_count = 1
end if

if li_count <= 1 then
	single_office = true
	st_filter_title.text = "Provider"
	st_office.text = "<All Providers>"
else
	st_filter_title.text = "Office"
	st_office.text = office_description
end if

setnull(filter_user_id)
filter_office_id = gnv_app.office_id
filter_description = st_office.text
indirect_flag = "[DI]"
encounter_type = "%"
st_type_title.visible = false
st_pick_encounter_type.visible = false
filter_billing_status = '%'

this.event trigger resized()

refresh_tab()

end subroutine

public subroutine do_cpr ();long ll_patient_workplan_item_id

if isnull(encounter) then return

ll_patient_workplan_item_id = encounter.do_service("LOOK")


end subroutine

public subroutine refresh_tab ();integer li_patient_count
datetime ldt_today

ldt_today = datetime(today())

li_patient_count = count_encounters(gnv_app.office_id, ldt_today)

if li_patient_count = 0 then
	if text <> "Checkout" then text = "Checkout"
else
	if text <> "Checkout " + string(li_patient_count) then text = "Checkout " + string(li_patient_count)
end if

if last_width <> width or last_height = height then
	this.event trigger resized()
end if

end subroutine

public function integer count_encounters (string ps_office_id, datetime pdt_encounter_date);integer li_patient_count

 DECLARE lsp_count_who_came_office PROCEDURE FOR dbo.sp_count_who_came_office
 			@ps_office_id = :ps_office_id,
         @pdt_date = :pdt_encounter_date,
         @pi_count = :li_patient_count OUT ;

EXECUTE lsp_count_who_came_office;
if not tf_check() then return -1

FETCH lsp_count_who_came_office INTO :li_patient_count;
if not tf_check() then return -1

CLOSE lsp_count_who_came_office;

return li_patient_count

end function

public subroutine menu (long pl_row);integer li_sts
long ll_row
long ll_encounter_id
string ls_cpr_id
string ls_key

f_user_logon()
If isnull(current_user) Then Return

ls_cpr_id = dw_checked_out.object.cpr_id[pl_row]
ll_encounter_id = dw_checked_out.object.encounter_id[pl_row]

// Set the patient context
li_sts = f_set_patient(ls_cpr_id)
if li_sts < 0 then return

li_sts = f_set_current_encounter(ll_encounter_id)
if li_sts <= 0 then
	log.log(this, "u_checked_out.menu:0019", "Error setting encounter", 4)
	f_clear_patient()
	return
end if

// Display the room-specific menu
if isnull(filter_office_id) then
	ls_key = filter_user_id
else
	ls_key = filter_office_id
end if

li_sts = f_display_context_menu("Checkout", ls_key)

// Clear the patient context
f_clear_patient()

refresh()

Return

end subroutine

public subroutine refresh ();long ll_rowcount
long i
long ll_first_row_on_page
long ll_new_first_row_on_page
long ll_last
long ll_lastrowonpage

f_set_background_color(this)

if encounter_date = today() then
	st_title.text = "Patients Checked Out Today"
	cb_today.visible = false
else
	st_title.text = "Patient Encounters on " + string(encounter_date, date_format_string)
	cb_today.visible = true
end if

ll_first_row_on_page = long(dw_checked_out.object.DataWindow.FirstRowOnPage)
ll_lastrowonpage = long(dw_checked_out.object.DataWindow.LastRowOnPage)

if last_width <> width or last_height = height then
	this.event trigger resized()
end if

dw_checked_out.setredraw(false)
dw_checked_out.reset()
dw_checked_out.settransobject(sqlca)
ll_rowcount = dw_checked_out.retrieve(datetime(encounter_date), filter_office_id, filter_user_id, indirect_flag, encounter_type,filter_billing_status)
dw_checked_out.set_page_to_row(ll_lastrowonpage, pb_up, pb_down, st_page)

dw_checked_out.setredraw(true)

dw_checked_out.suppress_scroll_event = false

st_office.text = filter_description

st_count.text = string(ll_rowcount) + " Encounters"


refresh_tab()

end subroutine

on u_checked_out.create
int iCurrent
call super::create
this.st_mode_title=create st_mode_title
this.st_error=create st_error
this.cb_billing_status=create cb_billing_status
this.st_mode=create st_mode
this.st_billing_status=create st_billing_status
this.pb_help=create pb_help
this.cb_refresh=create cb_refresh
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.cb_today=create cb_today
this.st_count=create st_count
this.st_pick_encounter_type=create st_pick_encounter_type
this.st_type_title=create st_type_title
this.st_office=create st_office
this.cb_legend=create cb_legend
this.cb_next_day=create cb_next_day
this.cb_prev_day=create cb_prev_day
this.pb_pick_date=create pb_pick_date
this.st_title=create st_title
this.dw_checked_out=create dw_checked_out
this.st_filter_title=create st_filter_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_mode_title
this.Control[iCurrent+2]=this.st_error
this.Control[iCurrent+3]=this.cb_billing_status
this.Control[iCurrent+4]=this.st_mode
this.Control[iCurrent+5]=this.st_billing_status
this.Control[iCurrent+6]=this.pb_help
this.Control[iCurrent+7]=this.cb_refresh
this.Control[iCurrent+8]=this.pb_up
this.Control[iCurrent+9]=this.pb_down
this.Control[iCurrent+10]=this.st_page
this.Control[iCurrent+11]=this.cb_today
this.Control[iCurrent+12]=this.st_count
this.Control[iCurrent+13]=this.st_pick_encounter_type
this.Control[iCurrent+14]=this.st_type_title
this.Control[iCurrent+15]=this.st_office
this.Control[iCurrent+16]=this.cb_legend
this.Control[iCurrent+17]=this.cb_next_day
this.Control[iCurrent+18]=this.cb_prev_day
this.Control[iCurrent+19]=this.pb_pick_date
this.Control[iCurrent+20]=this.st_title
this.Control[iCurrent+21]=this.dw_checked_out
this.Control[iCurrent+22]=this.st_filter_title
end on

on u_checked_out.destroy
call super::destroy
destroy(this.st_mode_title)
destroy(this.st_error)
destroy(this.cb_billing_status)
destroy(this.st_mode)
destroy(this.st_billing_status)
destroy(this.pb_help)
destroy(this.cb_refresh)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.cb_today)
destroy(this.st_count)
destroy(this.st_pick_encounter_type)
destroy(this.st_type_title)
destroy(this.st_office)
destroy(this.cb_legend)
destroy(this.cb_next_day)
destroy(this.cb_prev_day)
destroy(this.pb_pick_date)
destroy(this.st_title)
destroy(this.dw_checked_out)
destroy(this.st_filter_title)
end on

type st_mode_title from statictext within u_checked_out
integer x = 1632
integer y = 960
integer width = 709
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "By Patient/Enc Mode"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_error from statictext within u_checked_out
boolean visible = false
integer x = 2162
integer y = 836
integer width = 155
integer height = 92
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "ErrRpt"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string				ls_report_id,ls_service
string				ls_display_script_id

str_attributes		lstra_attributes


ls_display_script_id = datalist.get_preference("PREFERENCES","billing_error_display_script_id")
if isnull(ls_display_script_id) then
	log.log(this,"u_checked_out.st_error.clicked:0009","no display script id for this report. set a preference_id = billing_error_display_script_id and a valid display script id",3)
	return
end if

ls_report_id = datalist.get_preference("PREFERENCES","billing_error_report_id")
if isnull(ls_report_id) then ls_report_id = "{4B657EFA-AB67-482B-9FAB-1764440DF116}"

ls_service = datalist.get_preference("PREFERENCES","billing_error_service")
if isnull(ls_service) then ls_service = "REPORT"


lstra_attributes.attribute_count = 3
lstra_attributes.attribute[1].attribute = "report_id"
lstra_attributes.attribute[1].value = ls_report_id
lstra_attributes.attribute[2].attribute = "display_script_id"
lstra_attributes.attribute[2].value = ls_display_script_id
lstra_attributes.attribute[3].attribute = "encounter_date"
lstra_attributes.attribute[3].value = string(encounter_date)


service_list.do_service(ls_service,lstra_attributes)
end event

type cb_billing_status from commandbutton within u_checked_out
integer x = 1632
integer y = 808
integer width = 517
integer height = 120
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<All>"
end type

event clicked;str_popup			popup
str_popup_return	popup_return

popup.add_blank_row = true
popup.blank_text = "<All>"
popup.dataobject = "dw_c_domain_item_bitmap"
popup.datacolumn = 3
popup.displaycolumn = 4
popup.argument_count = 1
popup.argument[1] = "billing_posted"

Openwithparm(w_pop_pick, popup)
popup_return = Message.powerobjectparm
If popup_return.item_count <> 1 Then Return
If filter_billing_status = popup_return.items[1] Then Return

filter_billing_status = popup_return.items[1]
Text = popup_return.descriptions[1]

if filter_billing_status = "" or isnull(filter_billing_status) then
	filter_billing_status = '%'
	text = "<All>"
end if

refresh()
if filter_billing_status = 'E' then
	if dw_checked_out.rowcount() > 0 Then 
		st_error.visible = true
	else
		st_error.visible = false
	end if
else
	st_error.visible = false
end if

end event

type st_mode from statictext within u_checked_out
integer x = 1632
integer y = 1032
integer width = 709
integer height = 136
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<none>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string	ls_search,ls_exp,ls_mode
long ll_rows

str_popup popup
str_popup_return popup_return

popup.data_row_count = 3
popup.items[1] = "<<All>>"
popup.items[2] = "By Patient"
popup.items[3] = "By Encounter Mode"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 0 then return
text = popup_return.items[1]

dw_checked_out.setredraw(false)

CHOOSE CASE text
	Case "<<All>>"
		encounter_type = "%"
		indirect_flag = "%"
		dw_checked_out.setfilter("")
		dw_checked_out.filter()
		st_type_title.visible = false
		st_pick_encounter_type.visible = false
	Case "By Patient"
		dw_checked_out.setfilter("")
		dw_checked_out.filter()
		st_type_title.visible = true
		st_pick_encounter_type.visible = true
		Open(w_pop_get_string_abc)
		popup_return = message.powerobjectparm
		if popup_return.item_count = 0 Then
			ls_search = "%"
			st_pick_encounter_type.text = "All"
		else
			ls_search = popup_return.items[1]
			st_pick_encounter_type.text = popup_return.descriptions[1]
		end if
		st_type_title.text = "Name"
		st_pick_encounter_type.enabled = false
		encounter_type = "%"
		indirect_flag = "%"
		ll_rows = dw_checked_out.rowcount()
		ls_exp = "((upper(last_name) like '"+upper(ls_search)+"') OR (upper(first_name) like '"+upper(ls_search)+"'))"
		dw_checked_out.setfilter(ls_exp)
		dw_checked_out.filter()
		ll_rows = dw_checked_out.rowcount()
	Case "By Encounter Mode"
		st_type_title.visible = true
		st_pick_encounter_type.visible = true
		popup.data_row_count = 5
		popup.items[1] = "Direct"
		popup.items[2] = "Indirect"
		popup.items[3] = "Direct and Indirect"
		popup.items[4] = "All"
		popup.items[5] = "Specific Type"

		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		st_type_title.text = "Mode"
		st_pick_encounter_type.enabled = false
		if popup_return.item_count = 0 then 
			ls_mode = 'All'
		else
			ls_mode = popup_return.items[1]
		end if
		encounter_type = "%"
	
		dw_checked_out.setfilter("")
		dw_checked_out.filter()

		st_pick_encounter_type.text = ls_mode
		CHOOSE CASE ls_mode
			CASE "Direct"
			indirect_flag = "D"
			CASE "Indirect"
			indirect_flag = "I"
			CASE "Direct and Indirect"
			indirect_flag = "[DI]"
			CASE "All"
			indirect_flag = "%"
			CASE "Specific Type"
			st_type_title.text = "Type"
			st_pick_encounter_type.enabled = true
			st_pick_encounter_type.postevent("clicked")
			indirect_flag = "%"
		END CHOOSE
END CHOOSE
dw_checked_out.setredraw(true)

if text <> "Specific Type" and text <> "By Patient" then refresh()


end event

type st_billing_status from statictext within u_checked_out
integer x = 1632
integer y = 736
integer width = 517
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Billing Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_help from u_pb_help_button within u_checked_out
integer x = 1609
integer y = 1512
integer width = 137
integer height = 116
integer taborder = 110
boolean originalsize = false
end type

type cb_refresh from commandbutton within u_checked_out
integer x = 2117
integer y = 392
integer width = 229
integer height = 72
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh"
end type

event clicked;refresh()

end event

type pb_up from u_picture_button within u_checked_out
integer x = 1609
integer y = 296
integer width = 137
integer height = 116
integer taborder = 40
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_checked_out.current_page

dw_checked_out.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within u_checked_out
integer x = 1609
integer y = 420
integer width = 137
integer height = 116
integer taborder = 90
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_checked_out.current_page
li_last_page = dw_checked_out.last_page

dw_checked_out.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within u_checked_out
integer x = 1755
integer y = 292
integer width = 160
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
boolean focusrectangle = false
end type

type cb_today from commandbutton within u_checked_out
integer x = 2030
integer y = 1532
integer width = 219
integer height = 96
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Today"
end type

event clicked;encounter_date = today()
refresh()

end event

type st_count from statictext within u_checked_out
integer x = 1609
integer y = 1628
integer width = 622
integer height = 68
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "20 Encounters"
boolean focusrectangle = false
end type

type st_pick_encounter_type from statictext within u_checked_out
integer x = 1632
integer y = 1240
integer width = 709
integer height = 124
boolean bringtotop = true
integer textsize = -10
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
string ls_encounter_type

popup.data_row_count = 2
popup.items[1] = "PICK"
popup.items[2] = "D"

openwithparm(w_pick_encounter_type, popup)
ls_encounter_type = message.stringparm
if isnull(ls_encounter_type) then return

encounter_type = ls_encounter_type
text = datalist.encounter_type_description(encounter_type)

refresh()


end event

type st_type_title from statictext within u_checked_out
integer x = 1632
integer y = 1168
integer width = 709
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
boolean enabled = false
string text = "Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_office from statictext within u_checked_out
integer x = 1632
integer y = 588
integer width = 709
integer height = 140
integer textsize = -10
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


if single_office then 
	if not isnull(filter_user_id) then
		setnull(filter_user_id)
		filter_office_id = gnv_app.office_id
		filter_description = "<All Providers>"
	else
		// The user must be logged in to use this option
		f_user_logon()
		If isnull(current_user) Then Return
	
		luo_user = user_list.pick_user(false, false, false)
		if isnull(luo_user) then return
		
		setnull(filter_office_id)
		filter_user_id = luo_user.user_id
		filter_description = luo_user.user_full_name
	end if
else
	popup.dataobject = ""
	popup.data_row_count = 2
	popup.items[1] = "Office"
	popup.items[2] = "Provider"
	popup.title = "Filter By:"
	
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	if popup_return.item_indexes[1] = 1 then
		popup.data_row_count = 0
		popup.title = ""
		popup.dataobject = "dw_fn_user_privilege_offices"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.argument_count = 2
		popup.argument[1] = current_user.user_id
		popup.argument[2] = "View Patients"
		
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		setnull(filter_user_id)
		filter_office_id = popup_return.items[1]
		filter_description = popup_return.descriptions[1]
		st_filter_title.text = "Office"
	else
		// The user must be logged in to use this option
		f_user_logon()
		If isnull(current_user) Then Return
	
		luo_user = user_list.pick_user(false, false, false)
		if isnull(luo_user) then return
		
		setnull(filter_office_id)
		filter_user_id = luo_user.user_id
		filter_description = luo_user.user_full_name
		st_filter_title.text = "Provider"	
	end if
end if

refresh()


end event

type cb_legend from commandbutton within u_checked_out
integer x = 2117
integer y = 308
integer width = 229
integer height = 72
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Legend"
end type

event clicked;Openwithparm(w_pop_legend, "billing_posted")




end event

type cb_next_day from commandbutton within u_checked_out
event clicked pbm_bnclicked
integer x = 2139
integer y = 1412
integer width = 119
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;encounter_date = relativedate(encounter_date, 1)
refresh()

end event

type cb_prev_day from commandbutton within u_checked_out
event clicked pbm_bnclicked
integer x = 2011
integer y = 1412
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

event clicked;encounter_date = relativedate(encounter_date, -1)
refresh()

end event

type pb_pick_date from u_picture_button within u_checked_out
event clicked pbm_bnclicked
integer x = 1760
integer y = 1412
integer width = 256
integer height = 224
integer taborder = 10
string picturename = "button14.bmp"
string disabledname = "b_push14.bmp"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Select Encounter Date"
popup.data_row_count = 1
popup.items[1] = string(encounter_date, date_format_string)

openwithparm(w_pick_date, popup)
popup_return = message.powerobjectparm

if not isnull(popup_return.item) then
	encounter_date = date(popup_return.item)
	refresh()
end if

end event

type st_title from statictext within u_checked_out
integer x = 1577
integer y = 16
integer width = 832
integer height = 264
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_checked_out from u_dw_pick_list within u_checked_out
integer width = 1582
integer height = 1700
integer taborder = 30
string dataobject = "dw_who_came_today"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;str_popup popup
str_popup_return popup_return
string ls_code_check_status
str_attributes lstr_attributes
integer li_idx
long ll_encounter_id
string ls_cpr_id

ls_cpr_id = dw_checked_out.object.cpr_id[selected_row]
ll_encounter_id = dw_checked_out.object.encounter_id[selected_row]

f_user_logon()
If isnull(current_user) Then Return

if lastcolumnname = "compute_billing" then
	service_list.do_service( ls_cpr_id, ll_encounter_id, "RETRYPOSTING")
elseif lastcolumnname = "compute_docs" then
	service_list.do_service( ls_cpr_id, ll_encounter_id, common_thread.manage_documents_service)
elseif lastcolumnname = "compute_code_checker" then
	ls_code_check_status = dw_checked_out.object.code_check_status[selected_row]
	if isnull(ls_code_check_status) then
		openwithparm(w_pop_yes_no, "The Code Check service has not yet been performed on this encounter.  Do you with to perform the Code Check service now?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
	
		li_idx = f_please_wait_open()
		
		service_list.do_service(ls_cpr_id, &
										ll_encounter_id, &
										code_check_perform_service, &
										lstr_attributes)
		
		f_please_wait_close(li_idx)
	end if
	
	service_list.do_service(ls_cpr_id, &
									ll_encounter_id, &
									code_check_review_service, &
									lstr_attributes)
else
	menu(selected_row)
end if

clear_selected()

end event

type st_filter_title from statictext within u_checked_out
integer x = 1632
integer y = 520
integer width = 709
integer height = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Office"
alignment alignment = center!
boolean focusrectangle = false
end type

