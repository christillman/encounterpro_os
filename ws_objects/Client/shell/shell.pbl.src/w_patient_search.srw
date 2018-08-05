$PBExportHeader$w_patient_search.srw
forward
global type w_patient_search from w_window_base
end type
type st_page from statictext within w_patient_search
end type
type pb_up from u_picture_button within w_patient_search
end type
type pb_down from u_picture_button within w_patient_search
end type
type cb_clear from commandbutton within w_patient_search
end type
type st_9 from statictext within w_patient_search
end type
type sle_ssn from singlelineedit within w_patient_search
end type
type st_6 from statictext within w_patient_search
end type
type cb_new_patient from commandbutton within w_patient_search
end type
type st_2 from statictext within w_patient_search
end type
type sle_last_name from singlelineedit within w_patient_search
end type
type st_3 from statictext within w_patient_search
end type
type sle_first_name from singlelineedit within w_patient_search
end type
type cb_abc_lastname from commandbutton within w_patient_search
end type
type cb_abc_firstname from commandbutton within w_patient_search
end type
type sle_billing_id from singlelineedit within w_patient_search
end type
type st_4 from statictext within w_patient_search
end type
type sle_phone_number from singlelineedit within w_patient_search
end type
type st_phone_title from statictext within w_patient_search
end type
type st_dob_title from statictext within w_patient_search
end type
type st_1 from statictext within w_patient_search
end type
type dw_patients from u_dw_pick_list within w_patient_search
end type
type cb_1 from commandbutton within w_patient_search
end type
type dw_patient_info from u_dw_patient_info within w_patient_search
end type
type st_date_of_birth from statictext within w_patient_search
end type
end forward

global type w_patient_search from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_page st_page
pb_up pb_up
pb_down pb_down
cb_clear cb_clear
st_9 st_9
sle_ssn sle_ssn
st_6 st_6
cb_new_patient cb_new_patient
st_2 st_2
sle_last_name sle_last_name
st_3 st_3
sle_first_name sle_first_name
cb_abc_lastname cb_abc_lastname
cb_abc_firstname cb_abc_firstname
sle_billing_id sle_billing_id
st_4 st_4
sle_phone_number sle_phone_number
st_phone_title st_phone_title
st_dob_title st_dob_title
st_1 st_1
dw_patients dw_patients
cb_1 cb_1
dw_patient_info dw_patient_info
st_date_of_birth st_date_of_birth
end type
global w_patient_search w_patient_search

type variables
date search_date_of_birth

str_patient patient


end variables

forward prototypes
public function integer search_patients ()
public subroutine clear ()
public function integer set_patient_data ()
end prototypes

public function integer search_patients ();integer li_sts
string ls_billing_id
string ls_last_name
string ls_first_name
string ls_phone_number
string ls_ssn
datetime ldt_dob

if len(sle_billing_id.text) > 0 then
	ls_billing_id = sle_billing_id.text + "%"
else
	ls_billing_id = ""
end if

if len(sle_last_name.text) > 0 then
	ls_last_name = sle_last_name.text + "%"
else
	ls_last_name = ""
end if

if len(sle_first_name.text) > 0 then
	ls_first_name = sle_first_name.text + "%"
else
	ls_first_name = ""
end if

if len(sle_phone_number.text) > 0 then
	ls_phone_number = sle_phone_number.text + "%"
else
	ls_phone_number = ""
end if

if len(sle_ssn.text) > 0 then
	ls_ssn = sle_ssn.text + "%"
else
	ls_ssn = ""
end if

if isnull(search_date_of_birth) then
	setnull(ldt_dob)
else
	ldt_dob = datetime(search_date_of_birth, time(""))
end if

dw_patients.settransobject(sqlca)
li_sts = dw_patients.retrieve(ls_billing_id, &
										ls_last_name, &
										ls_first_name, &
										ls_phone_number, &
										ldt_dob, &
										ls_ssn )

dw_patients.set_page(1, pb_up, pb_down, st_page)

return li_sts

end function

public subroutine clear ();sle_first_name.text = ""
sle_last_name.text = ""
sle_billing_id.text = ""
sle_ssn.text = ""
st_date_of_birth.text = ""
sle_phone_number.text = ""
setnull(search_date_of_birth)

dw_patients.reset()

sle_last_name.setfocus()

pb_up.visible = false
pb_down.visible = false
st_page.visible = false


end subroutine

public function integer set_patient_data ();string ls_encounter_type

// Set what we know
current_patient.modify_patient("last_name", patient.last_name)
current_patient.modify_patient("first_name", patient.first_name)
current_patient.modify_patient("middle_name", patient.middle_name)
current_patient.modify_patient("name_suffix", patient.name_suffix)
current_patient.modify_patient("name_prefix", patient.name_prefix)
current_patient.modify_patient("degree", patient.degree)
current_patient.modify_patient("date_of_birth", string(patient.date_of_birth))
current_patient.modify_patient("ssn", patient.ssn)
current_patient.modify_patient("billing_id", patient.billing_id)
current_patient.modify_patient("phone_number", patient.phone_number)
current_patient.modify_patient("sex", patient.sex)


ls_encounter_type = datalist.get_preference( "Preferences", "Initial Data Load Encounter Type", "Initial Data Load")

// Now create a data-entry encounter
current_patient.new_encounter( office_id, &
										ls_encounter_type, &
										datetime(today(), now()), &
										"N", &
										"Initial Data Load", &
										current_user.user_id, &
										current_scribe.user_id, &
										false, &
										false)

return 1

end function

on w_patient_search.create
int iCurrent
call super::create
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_clear=create cb_clear
this.st_9=create st_9
this.sle_ssn=create sle_ssn
this.st_6=create st_6
this.cb_new_patient=create cb_new_patient
this.st_2=create st_2
this.sle_last_name=create sle_last_name
this.st_3=create st_3
this.sle_first_name=create sle_first_name
this.cb_abc_lastname=create cb_abc_lastname
this.cb_abc_firstname=create cb_abc_firstname
this.sle_billing_id=create sle_billing_id
this.st_4=create st_4
this.sle_phone_number=create sle_phone_number
this.st_phone_title=create st_phone_title
this.st_dob_title=create st_dob_title
this.st_1=create st_1
this.dw_patients=create dw_patients
this.cb_1=create cb_1
this.dw_patient_info=create dw_patient_info
this.st_date_of_birth=create st_date_of_birth
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_page
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.cb_clear
this.Control[iCurrent+5]=this.st_9
this.Control[iCurrent+6]=this.sle_ssn
this.Control[iCurrent+7]=this.st_6
this.Control[iCurrent+8]=this.cb_new_patient
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.sle_last_name
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.sle_first_name
this.Control[iCurrent+13]=this.cb_abc_lastname
this.Control[iCurrent+14]=this.cb_abc_firstname
this.Control[iCurrent+15]=this.sle_billing_id
this.Control[iCurrent+16]=this.st_4
this.Control[iCurrent+17]=this.sle_phone_number
this.Control[iCurrent+18]=this.st_phone_title
this.Control[iCurrent+19]=this.st_dob_title
this.Control[iCurrent+20]=this.st_1
this.Control[iCurrent+21]=this.dw_patients
this.Control[iCurrent+22]=this.cb_1
this.Control[iCurrent+23]=this.dw_patient_info
this.Control[iCurrent+24]=this.st_date_of_birth
end on

on w_patient_search.destroy
call super::destroy
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_clear)
destroy(this.st_9)
destroy(this.sle_ssn)
destroy(this.st_6)
destroy(this.cb_new_patient)
destroy(this.st_2)
destroy(this.sle_last_name)
destroy(this.st_3)
destroy(this.sle_first_name)
destroy(this.cb_abc_lastname)
destroy(this.cb_abc_firstname)
destroy(this.sle_billing_id)
destroy(this.st_4)
destroy(this.sle_phone_number)
destroy(this.st_phone_title)
destroy(this.st_dob_title)
destroy(this.st_1)
destroy(this.dw_patients)
destroy(this.cb_1)
destroy(this.dw_patient_info)
destroy(this.st_date_of_birth)
end on

event open;call super::open;boolean lb_search

patient = message.powerobjectparm

clear()

dw_patient_info.display_patient(patient)

if len(patient.last_name) > 0 then
	sle_last_name.text = left(patient.last_name, 2)
	lb_search = true
end if

if len(patient.first_name) > 0 then
	sle_first_name.text = left(patient.first_name, 2)
	lb_search = true
end if

if not isnull(patient.date_of_birth) then
	st_date_of_birth.text = string(date(patient.date_of_birth), "[shortdate]")
	search_date_of_birth = patient.date_of_birth
	lb_search = true
end if


if lb_search then search_patients()



end event

type pb_epro_help from w_window_base`pb_epro_help within w_patient_search
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_patient_search
end type

type st_page from statictext within w_patient_search
integer x = 1422
integer y = 280
integer width = 146
integer height = 120
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
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_patient_search
integer x = 1422
integer y = 36
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
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

type pb_down from u_picture_button within w_patient_search
integer x = 1422
integer y = 160
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
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

type cb_clear from commandbutton within w_patient_search
integer x = 2098
integer y = 1488
integer width = 279
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;clear()

end event

type st_9 from statictext within w_patient_search
integer x = 1929
integer y = 876
integer width = 613
integer height = 100
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
string text = "Search"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_ssn from singlelineedit within w_patient_search
integer x = 2395
integer y = 1180
integer width = 329
integer height = 104
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;search_patients()

end event

type st_6 from statictext within w_patient_search
integer x = 2226
integer y = 1196
integer width = 165
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "SSN"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_new_patient from commandbutton within w_patient_search
integer x = 1202
integer y = 1620
integer width = 576
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Patient"
end type

event clicked;str_popup_return popup_return
string ls_cpr_id
integer li_sts

openwithparm(w_pop_yes_no, "Are you sure you wish to create a new patient record?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

setnull(ls_cpr_id)

li_sts = f_create_patient(ls_cpr_id)
if li_sts <= 0 then return

li_sts = f_set_patient(ls_cpr_id)
if li_sts <= 0 then return

set_patient_data()

//long ll_encounter_id
//setnull(ll_encounter_id)
//li_sts = service_list.do_service(ls_cpr_id, ll_encounter_id, "PATIENT_DATA") 

closewithreturn(parent, ls_cpr_id)


end event

type st_2 from statictext within w_patient_search
integer x = 1531
integer y = 1024
integer width = 192
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Last"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_last_name from singlelineedit within w_patient_search
integer x = 1733
integer y = 1008
integer width = 329
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;search_patients()

end event

type st_3 from statictext within w_patient_search
integer x = 2249
integer y = 1024
integer width = 142
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "First"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_first_name from singlelineedit within w_patient_search
integer x = 2395
integer y = 1008
integer width = 329
integer height = 104
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

event modified;search_patients()

end event

type cb_abc_lastname from commandbutton within w_patient_search
integer x = 2075
integer y = 1012
integer width = 146
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&ABC"
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_get_string_abc, "X") // Turn off "Begins"/"Contains" buttons
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

sle_last_name.text = popup_return.items[1]

search_patients()



end event

type cb_abc_firstname from commandbutton within w_patient_search
integer x = 2738
integer y = 1012
integer width = 146
integer height = 104
integer taborder = 40
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "A&BC"
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_get_string_abc, "X") // Turn off "Begins"/"Contains" buttons
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

sle_first_name.text = popup_return.items[1]

search_patients()


end event

type sle_billing_id from singlelineedit within w_patient_search
integer x = 1733
integer y = 1180
integer width = 329
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;search_patients()

end event

type st_4 from statictext within w_patient_search
integer x = 1417
integer y = 1196
integer width = 306
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Billing ID"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_phone_number from singlelineedit within w_patient_search
integer x = 2395
integer y = 1352
integer width = 329
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;search_patients()

end event

type st_phone_title from statictext within w_patient_search
integer x = 2190
integer y = 1368
integer width = 201
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Phone"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_dob_title from statictext within w_patient_search
integer x = 1536
integer y = 1368
integer width = 187
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "DOB"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_patient_search
integer x = 1591
integer y = 124
integer width = 1248
integer height = 100
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
string text = "Patient Info"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_patients from u_dw_pick_list within w_patient_search
integer x = 32
integer y = 24
integer width = 1390
integer height = 1556
integer taborder = 20
string dataobject = "dw_sp_patient_search2"
boolean border = false
boolean livescroll = false
end type

event post_click;call super::post_click;str_popup_return popup_return

string ls_cpr_id

if lastrow <= 0 then return

ls_cpr_id = object.cpr_id[lastrow]

if ls_cpr_id = "" then
	log.log(this, "w_patient_search.dw_patients.post_click:0010", "Blank CPR_ID", 3)
	return
end if

closewithreturn(parent, ls_cpr_id)


end event

type cb_1 from commandbutton within w_patient_search
integer x = 101
integer y = 1620
integer width = 457
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;string ls_cpr_id

setnull(ls_cpr_id)

closewithreturn(parent, ls_cpr_id)


end event

type dw_patient_info from u_dw_patient_info within w_patient_search
integer x = 1591
integer y = 224
integer taborder = 40
boolean bringtotop = true
end type

type st_date_of_birth from statictext within w_patient_search
integer x = 1733
integer y = 1352
integer width = 439
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
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;date ld_date_of_birth
string ls_text

ld_date_of_birth = search_date_of_birth

ls_text = f_select_date(ld_date_of_birth, "Date of Birth")
if isnull(ls_text) then return

if (ld_date_of_birth <> search_date_of_birth) or isnull(search_date_of_birth) then
	search_date_of_birth = ld_date_of_birth
	text = string(search_date_of_birth)
end if


end event

