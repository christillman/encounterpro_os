HA$PBExportHeader$u_patient_select.sru
forward
global type u_patient_select from u_main_tabpage_base
end type
type cb_import_chart from commandbutton within u_patient_select
end type
type uo_search_criteria from u_patient_search_criteria within u_patient_select
end type
type st_no_results from statictext within u_patient_select
end type
type cb_search from commandbutton within u_patient_select
end type
type st_page from statictext within u_patient_select
end type
type pb_up from u_picture_button within u_patient_select
end type
type pb_down from u_picture_button within u_patient_select
end type
type st_title from statictext within u_patient_select
end type
type cb_new_patient from commandbutton within u_patient_select
end type
type dw_patients from u_dw_pick_list within u_patient_select
end type
end forward

global type u_patient_select from u_main_tabpage_base
integer width = 2414
integer height = 1704
long tabbackcolor = 16777215
event select_patient ( string ps_cpr_id )
event new_patient ( string ps_cpr_id )
event resized ( )
cb_import_chart cb_import_chart
uo_search_criteria uo_search_criteria
st_no_results st_no_results
cb_search cb_search
st_page st_page
pb_up pb_up
pb_down pb_down
st_title st_title
cb_new_patient cb_new_patient
dw_patients dw_patients
end type
global u_patient_select u_patient_select

type variables

integer il_current_page = 1

time lastsearch

string cpr_id


long last_width
long last_height

str_patient passed_in_search

end variables

forward prototypes
public function integer search_patients ()
public subroutine clear ()
public subroutine set_search (str_patient pstr_patient)
public function integer initialize ()
public function integer refresh ()
public subroutine hotkey (keycode pe_key, unsignedlong pul_flags)
end prototypes

event resized();if width > 2500 then
	dw_patients.width = width - 887
else
	dw_patients.width = 1417
end if

pb_up.x = dw_patients.x + dw_patients.width + 20
pb_down.x = pb_up.x
st_page.x = pb_up.x + pb_up.width + 8
st_page.y = pb_down.y + pb_down.height - st_page.height

uo_search_criteria.x = (width + dw_patients.width + dw_patients.x - uo_search_criteria.width) / 2

st_title.x = uo_search_criteria.x + ((uo_search_criteria.width - st_title.width) / 2)
cb_search.x = uo_search_criteria.x + ((uo_search_criteria.width - cb_search.width) / 2)

cb_new_patient.x = width - cb_new_patient.width - 32

dw_patients.object.t_background.width = dw_patients.width - 120

cb_new_patient.y = height - cb_new_patient.height - 32

cb_import_chart.x = cb_new_patient.x - cb_import_chart.width - 50
cb_import_chart.y = cb_new_patient.y

dw_patients.height = height - dw_patients.y - 32

// Save the width and height so we'll know when this tab page changed
last_width = width
last_height = height


end event

public function integer search_patients ();integer li_sts
long ll_check


ll_check = sqlca.jmj_patient_search2(current_user.user_id, &
												uo_search_criteria.billing_id, &
												uo_search_criteria.last_name, &
												uo_search_criteria.first_name, &
												uo_search_criteria.ssn, &
												uo_search_criteria.date_of_birth, &
												uo_search_criteria.phone_number, &
												uo_search_criteria.employer, &
												uo_search_criteria.employeeid, &
												uo_search_criteria.patient_status, &
												1)
if not tf_check() then return -1

if ll_check < 0 then
	// too many patients found
	st_no_results.text = "Too many patients found.  Please supply more restrictive search criteria."
	st_no_results.visible = true
	dw_patients.visible = false
elseif ll_check = 0 then
	// no patients found
	st_no_results.text = "No patients found with these criteria."
	st_no_results.visible = true
	dw_patients.visible = false
else
	// More than zero and less than a thousand patients found
	dw_patients.settransobject(sqlca)
	
	li_sts = dw_patients.retrieve(	current_user.user_id, &
											uo_search_criteria.billing_id, &
											uo_search_criteria.last_name, &
											uo_search_criteria.first_name, &
											uo_search_criteria.ssn, &
											uo_search_criteria.date_of_birth, &
											uo_search_criteria.phone_number, &
											uo_search_criteria.employer, &
											uo_search_criteria.employeeid, &
											uo_search_criteria.patient_status )
	
	if il_current_page <= 0 then il_current_page = 1
	dw_patients.set_page(il_current_page, pb_up, pb_down, st_page)
	st_no_results.visible = false
	dw_patients.visible = true
	
	lastsearch = now()
end if

return li_sts

end function

public subroutine clear ();
uo_search_criteria.clear()
dw_patients.reset()

pb_up.visible = false
pb_down.visible = false
st_page.visible = false

f_set_background_color(this)

st_no_results.text = "Please enter search criteria"
st_no_results.visible = true

triggerevent("resized")

end subroutine

public subroutine set_search (str_patient pstr_patient);
passed_in_search = pstr_patient

if isnull(pstr_patient.patient_status) &
	or lower(pstr_patient.patient_status) = "active" &
	or pstr_patient.patient_status = "" then
	pstr_patient.patient_status = "Active"
	passed_in_search.patient_status = "Active"
else
	pstr_patient.patient_status = "%"
end if
uo_search_criteria.set_search(pstr_patient)

this.function POST search_patients()

end subroutine

public function integer initialize ();postevent("resized")

return 1

end function

public function integer refresh ();

if width <> last_width or height <> last_height then
	this.event trigger resized()
end if

return 1

end function

public subroutine hotkey (keycode pe_key, unsignedlong pul_flags);
CHOOSE CASE pe_key
	CASE keyescape!
		clear()
END CHOOSE


end subroutine

on u_patient_select.create
int iCurrent
call super::create
this.cb_import_chart=create cb_import_chart
this.uo_search_criteria=create uo_search_criteria
this.st_no_results=create st_no_results
this.cb_search=create cb_search
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_title=create st_title
this.cb_new_patient=create cb_new_patient
this.dw_patients=create dw_patients
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_import_chart
this.Control[iCurrent+2]=this.uo_search_criteria
this.Control[iCurrent+3]=this.st_no_results
this.Control[iCurrent+4]=this.cb_search
this.Control[iCurrent+5]=this.st_page
this.Control[iCurrent+6]=this.pb_up
this.Control[iCurrent+7]=this.pb_down
this.Control[iCurrent+8]=this.st_title
this.Control[iCurrent+9]=this.cb_new_patient
this.Control[iCurrent+10]=this.dw_patients
end on

on u_patient_select.destroy
call super::destroy
destroy(this.cb_import_chart)
destroy(this.uo_search_criteria)
destroy(this.st_no_results)
destroy(this.cb_search)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_title)
destroy(this.cb_new_patient)
destroy(this.dw_patients)
end on

type cb_import_chart from commandbutton within u_patient_select
integer x = 1527
integer y = 1568
integer width = 366
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Import Chart"
end type

event clicked;str_service_info lstr_service
integer li_sts
datetime ldt_before
long ll_attachment_id
string ls_cpr_id
integer li_index

// Get the date/time before we import
SELECT getdate()
INTO :ldt_before
FROM c_1_record;
if not tf_check() then return

lstr_service.service = "EXTERNAL_SOURCE"
f_attribute_add_attribute(lstr_service.attributes, "external_source", "JMJ_FILE")
f_attribute_add_attribute(lstr_service.attributes, "xml_action", "process")
f_attribute_add_attribute(lstr_service.attributes, "comment_title", "Patient Data Import")

li_index = f_please_wait_open()

service_list.do_service(lstr_service)

f_please_wait_close(li_index)


// Now we want to auto-select the imported patient, so find out what the last attachment imported by this user was
SELECT max(attachment_id)
INTO :ll_attachment_id
FROM p_Attachment
WHERE created > :ldt_before
AND created_by = :current_scribe.user_id;
if not tf_check() then return

if ll_attachment_id > 0 then
	SELECT cpr_id
	INTO :ls_cpr_id
	FROM p_Attachment
	WHERE attachment_id = :ll_attachment_id;
	if not tf_check() then return
	
	if len(ls_cpr_id) > 0 then
		parent.event TRIGGER select_patient(ls_cpr_id)
	end if
end if

if isvalid(this) then
	il_current_page = dw_patients.current_page
	search_patients()
end if

return 0

end event

type uo_search_criteria from u_patient_search_criteria within u_patient_select
event destroy ( )
integer x = 1527
integer y = 284
integer taborder = 10
end type

on uo_search_criteria.destroy
call u_patient_search_criteria::destroy
end on

event search_criteria_changed;call super::search_criteria_changed;search_patients()

end event

type st_no_results from statictext within u_patient_select
integer x = 82
integer y = 540
integer width = 1243
integer height = 344
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Too many patients found.  Please supply more restrictive search criteria."
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_search from commandbutton within u_patient_select
integer x = 1682
integer y = 1416
integer width = 448
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Search"
end type

event clicked;if lastsearch < relativetime(now(), -1) then
	search_patients()
end if

end event

type st_page from statictext within u_patient_select
integer x = 1669
integer y = 204
integer width = 274
integer height = 64
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

type pb_up from u_picture_button within u_patient_select
integer x = 1522
integer y = 32
integer width = 137
integer height = 116
integer taborder = 0
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_patients.current_page

dw_patients.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within u_patient_select
integer x = 1522
integer y = 156
integer width = 137
integer height = 116
integer taborder = 0
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_patients.current_page
li_last_page = dw_patients.last_page

dw_patients.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_title from statictext within u_patient_select
integer x = 1673
integer y = 24
integer width = 613
integer height = 152
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Patient Search Criteria"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_new_patient from commandbutton within u_patient_select
integer x = 1970
integer y = 1568
integer width = 366
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Patient"
end type

event clicked;str_popup_return popup_return
str_popup popup
string ls_cpr_id
integer li_sts
str_patient lstr_patient

openwithparm(w_pop_yes_no, "Are you sure you wish to create a new patient record?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

setnull(ls_cpr_id)

popup.title = "New Patient"
lstr_patient = f_empty_patient()

// Default the patient status to the status passed into the search
if len(passed_in_search.patient_status) > 0 then
	lstr_patient.patient_status = passed_in_search.patient_status
else
	lstr_patient.patient_status = "Active"
end if

popup.objectparm = lstr_patient
popup.multiselect = true // enable test patient
openwithparm(w_edit_patient_data, popup)
popup_return = message.powerobjectparm
if popup_return.item <> "OK" then return

lstr_patient = popup_return.objectparm2

li_sts = f_new_patient(lstr_patient)
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error creating new patient")
	return
end if

if isnull(lstr_patient.cpr_id) or trim(lstr_patient.cpr_id) = "" then
	openwithparm(w_pop_message, "Error creating cpr_id for new patient")
	return
end if

cpr_id = lstr_patient.cpr_id
parent.event POST new_patient(cpr_id)


end event

type dw_patients from u_dw_pick_list within u_patient_select
integer x = 14
integer y = 24
integer width = 1495
integer height = 1656
integer taborder = 0
string dataobject = "dw_jmj_patient_search2"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event post_click;call super::post_click;string 	ls_cpr_id
integer	li_current_page

str_popup_return popup_return

if lastrow <= 0 then return

ls_cpr_id = object.cpr_id[lastrow]

if ls_cpr_id = "" then
	log.log(this, "post_click", "Blank CPR_ID", 3)
	return
end if

cpr_id = ls_cpr_id

parent.event TRIGGER select_patient(cpr_id)
if isvalid(this) then
	il_current_page = current_page
	search_patients()
end if


end event

