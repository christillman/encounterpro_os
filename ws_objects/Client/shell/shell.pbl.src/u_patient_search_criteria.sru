$PBExportHeader$u_patient_search_criteria.sru
forward
global type u_patient_search_criteria from userobject
end type
type cb_clear from commandbutton within u_patient_search_criteria
end type
type st_phone_title from statictext within u_patient_search_criteria
end type
type sle_phone_number from singlelineedit within u_patient_search_criteria
end type
type st_dob_title from statictext within u_patient_search_criteria
end type
type st_patient_status from statictext within u_patient_search_criteria
end type
type sle_employeeid from singlelineedit within u_patient_search_criteria
end type
type st_7 from statictext within u_patient_search_criteria
end type
type st_6 from statictext within u_patient_search_criteria
end type
type st_5 from statictext within u_patient_search_criteria
end type
type st_1 from statictext within u_patient_search_criteria
end type
type sle_employer from singlelineedit within u_patient_search_criteria
end type
type st_2 from statictext within u_patient_search_criteria
end type
type sle_last_name from singlelineedit within u_patient_search_criteria
end type
type st_3 from statictext within u_patient_search_criteria
end type
type sle_first_name from singlelineedit within u_patient_search_criteria
end type
type cb_abc_lastname from commandbutton within u_patient_search_criteria
end type
type cb_abc_firstname from commandbutton within u_patient_search_criteria
end type
type sle_billing_id from singlelineedit within u_patient_search_criteria
end type
type st_4 from statictext within u_patient_search_criteria
end type
type em_dob from editmask within u_patient_search_criteria
end type
type em_ssn from editmask within u_patient_search_criteria
end type
end forward

global type u_patient_search_criteria from userobject
integer width = 809
integer height = 1116
boolean border = true
long backcolor = 12632256
long tabtextcolor = 33554432
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
event select_patient ( string ps_cpr_id )
event new_patient ( string ps_cpr_id )
event search_criteria_changed ( )
cb_clear cb_clear
st_phone_title st_phone_title
sle_phone_number sle_phone_number
st_dob_title st_dob_title
st_patient_status st_patient_status
sle_employeeid sle_employeeid
st_7 st_7
st_6 st_6
st_5 st_5
st_1 st_1
sle_employer sle_employer
st_2 st_2
sle_last_name sle_last_name
st_3 st_3
sle_first_name sle_first_name
cb_abc_lastname cb_abc_lastname
cb_abc_firstname cb_abc_firstname
sle_billing_id sle_billing_id
st_4 st_4
em_dob em_dob
em_ssn em_ssn
end type
global u_patient_search_criteria u_patient_search_criteria

type variables
string billing_id
string last_name
string first_name
string employer
string employeeid
string ssn
string patient_status = "Active"
datetime date_of_birth
string phone_number

integer il_current_page = 1

time lastsearch

end variables

forward prototypes
public subroutine clear ()
public subroutine set_search (str_patient pstr_patient)
end prototypes

public subroutine clear ();sle_first_name.text = ""
sle_last_name.text = ""
sle_billing_id.text = ""
sle_employer.text = ""
sle_employeeid.text = ""
em_ssn.text = ""
sle_phone_number.text = ""
st_patient_status.text = "Active"
em_dob.text = ""

first_name = ""
last_name = ""
billing_id = ""
employer = ""
employeeid = ""
ssn = ""
setnull(date_of_birth)
phone_number = ""
patient_status = "Active"

sle_last_name.setfocus()

parent.postevent("search_criteria_changed")

end subroutine

public subroutine set_search (str_patient pstr_patient);string ls_temp

if len(pstr_patient.first_name) > 0 then
	sle_first_name.text = pstr_patient.first_name
	first_name = pstr_patient.first_name + "%"
else
	sle_first_name.text = ""
	first_name = ""
end if

if len(pstr_patient.last_name) > 0 then
	sle_last_name.text = pstr_patient.last_name
	last_name = pstr_patient.last_name + "%"
else
	sle_last_name.text = ""
	last_name = ""
end if

if len(pstr_patient.billing_id) > 0 then
	sle_billing_id.text = pstr_patient.billing_id
	billing_id = pstr_patient.billing_id + "%"
else
	sle_billing_id.text = ""
	billing_id = ""
end if
	
if len(pstr_patient.ssn) > 0 then
	em_ssn.text = pstr_patient.ssn
	ssn = pstr_patient.ssn + "%"
else
	em_ssn.text = ""
	ssn = ""
end if

if len(pstr_patient.phone_number) > 0 then
	sle_phone_number.text = pstr_patient.phone_number
	phone_number = pstr_patient.phone_number
else
	sle_phone_number.text = ""
	ssn = ""
end if

if pstr_patient.date_of_birth > date('1/1/1902') then
	em_dob.text = string(pstr_patient.date_of_birth, "[shortdate]")
	date_of_birth = datetime(pstr_patient.date_of_birth, time(""))
else
	em_dob.text = ""
	setnull(date_of_birth)
end if

if len(pstr_patient.patient_status) > 0 then
	if pstr_patient.patient_status = "All Patients" or pstr_patient.patient_status = "%" then
		st_patient_status.text = "All Patients"
		patient_status = "%"
	else
		st_patient_status.text = pstr_patient.patient_status
		patient_status = pstr_patient.patient_status
	end if
else
	// get default
	ls_temp = datalist.get_preference("PREFERENCES", "Patient Search Default Status")
	if isnull(ls_temp) then
		st_patient_status.text = "Active"
		patient_status = "Active"
	else
		if ls_temp = "All Patients" or ls_temp = "%" then
			st_patient_status.text = "All Patients"
			patient_status = "%"
		else
			st_patient_status.text = ls_temp
			patient_status = ls_temp
		end if
	end if
end if

sle_employer.text = ""
sle_employeeid.text = ""
employer = ""
employeeid = ""


end subroutine

on u_patient_search_criteria.create
this.cb_clear=create cb_clear
this.st_phone_title=create st_phone_title
this.sle_phone_number=create sle_phone_number
this.st_dob_title=create st_dob_title
this.st_patient_status=create st_patient_status
this.sle_employeeid=create sle_employeeid
this.st_7=create st_7
this.st_6=create st_6
this.st_5=create st_5
this.st_1=create st_1
this.sle_employer=create sle_employer
this.st_2=create st_2
this.sle_last_name=create sle_last_name
this.st_3=create st_3
this.sle_first_name=create sle_first_name
this.cb_abc_lastname=create cb_abc_lastname
this.cb_abc_firstname=create cb_abc_firstname
this.sle_billing_id=create sle_billing_id
this.st_4=create st_4
this.em_dob=create em_dob
this.em_ssn=create em_ssn
this.Control[]={this.cb_clear,&
this.st_phone_title,&
this.sle_phone_number,&
this.st_dob_title,&
this.st_patient_status,&
this.sle_employeeid,&
this.st_7,&
this.st_6,&
this.st_5,&
this.st_1,&
this.sle_employer,&
this.st_2,&
this.sle_last_name,&
this.st_3,&
this.sle_first_name,&
this.cb_abc_lastname,&
this.cb_abc_firstname,&
this.sle_billing_id,&
this.st_4,&
this.em_dob,&
this.em_ssn}
end on

on u_patient_search_criteria.destroy
destroy(this.cb_clear)
destroy(this.st_phone_title)
destroy(this.sle_phone_number)
destroy(this.st_dob_title)
destroy(this.st_patient_status)
destroy(this.sle_employeeid)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_1)
destroy(this.sle_employer)
destroy(this.st_2)
destroy(this.sle_last_name)
destroy(this.st_3)
destroy(this.sle_first_name)
destroy(this.cb_abc_lastname)
destroy(this.cb_abc_firstname)
destroy(this.sle_billing_id)
destroy(this.st_4)
destroy(this.em_dob)
destroy(this.em_ssn)
end on

type cb_clear from commandbutton within u_patient_search_criteria
integer x = 201
integer y = 1012
integer width = 398
integer height = 88
integer taborder = 100
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear <esc>"
end type

event clicked;clear()

end event

type st_phone_title from statictext within u_patient_search_criteria
integer x = 361
integer y = 504
integer width = 421
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Phone"
boolean focusrectangle = false
end type

type sle_phone_number from singlelineedit within u_patient_search_criteria
integer x = 361
integer y = 568
integer width = 421
integer height = 92
integer taborder = 60
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "(770) 654-0000"
borderstyle borderstyle = stylelowered!
end type

event modified;text = sqlca.fn_pretty_phone(text)
phone_number = text

parent.postevent("search_criteria_changed")


end event

type st_dob_title from statictext within u_patient_search_criteria
integer x = 14
integer y = 504
integer width = 334
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "DOB"
boolean focusrectangle = false
end type

type st_patient_status from statictext within u_patient_search_criteria
integer x = 297
integer y = 848
integer width = 453
integer height = 152
integer taborder = 90
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "All Patients"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<All Patients>"
popup.argument_count = 1
popup.argument[1] = "PATIENT_STATUS"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.descriptions[1]

if popup_return.items[1] = "" then
	patient_status = "%"
	text = "All Patients"
else
	patient_status = popup_return.items[1]
	text = popup_return.descriptions[1]
end if

parent.postevent("search_criteria_changed")

end event

type sle_employeeid from singlelineedit within u_patient_search_criteria
integer x = 361
integer y = 732
integer width = 421
integer height = 92
integer taborder = 80
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;employeeid = text + "%"
parent.postevent("search_criteria_changed")

end event

type st_7 from statictext within u_patient_search_criteria
integer x = 64
integer y = 888
integer width = 210
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within u_patient_search_criteria
integer x = 361
integer y = 340
integer width = 421
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "SSN"
boolean focusrectangle = false
end type

type st_5 from statictext within u_patient_search_criteria
integer x = 361
integer y = 668
integer width = 421
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Employee ID"
boolean focusrectangle = false
end type

type st_1 from statictext within u_patient_search_criteria
integer x = 14
integer y = 668
integer width = 334
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Employer"
boolean focusrectangle = false
end type

type sle_employer from singlelineedit within u_patient_search_criteria
integer x = 14
integer y = 732
integer width = 334
integer height = 92
integer taborder = 70
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;employer = text + "%"
parent.postevent("search_criteria_changed")

end event

type st_2 from statictext within u_patient_search_criteria
integer x = 14
integer y = 12
integer width = 347
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Last name"
boolean focusrectangle = false
end type

type sle_last_name from singlelineedit within u_patient_search_criteria
integer x = 14
integer y = 76
integer width = 549
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;last_name = text + "%"
parent.postevent("search_criteria_changed")

end event

type st_3 from statictext within u_patient_search_criteria
integer x = 14
integer y = 176
integer width = 347
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "First name"
boolean focusrectangle = false
end type

type sle_first_name from singlelineedit within u_patient_search_criteria
integer x = 14
integer y = 240
integer width = 549
integer height = 92
integer taborder = 20
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;first_name = text + "%"
parent.postevent("search_criteria_changed")

end event

type cb_abc_lastname from commandbutton within u_patient_search_criteria
event clicked pbm_bnclicked
integer x = 576
integer y = 76
integer width = 146
integer height = 96
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
last_name = popup_return.items[1] + "%"

parent.postevent("search_criteria_changed")

end event

type cb_abc_firstname from commandbutton within u_patient_search_criteria
event clicked pbm_bnclicked
integer x = 576
integer y = 240
integer width = 146
integer height = 96
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
first_name = popup_return.items[1] + "%"

parent.postevent("search_criteria_changed")

end event

type sle_billing_id from singlelineedit within u_patient_search_criteria
integer x = 14
integer y = 404
integer width = 334
integer height = 92
integer taborder = 30
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "102191.0"
borderstyle borderstyle = stylelowered!
end type

event modified;billing_id = text + "%"
parent.postevent("search_criteria_changed")

end event

type st_4 from statictext within u_patient_search_criteria
integer x = 14
integer y = 340
integer width = 283
integer height = 56
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
string text = "Billing ID"
boolean focusrectangle = false
end type

type em_dob from editmask within u_patient_search_criteria
integer x = 14
integer y = 568
integer width = 334
integer height = 92
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
end type

event modified;if isnull(text) or trim(text) = "" or trim(text) = "00/00/0000" then
	text = ""
	setnull(date_of_birth)
	return
end if

if not isdate(text) then
	openwithparm(w_pop_message, "Please enter a valid date")
	return
end if

date_of_birth = datetime(date(text), time(""))

parent.postevent("search_criteria_changed")

end event

type em_ssn from editmask within u_patient_search_criteria
integer x = 361
integer y = 404
integer width = 421
integer height = 92
integer taborder = 40
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "###-##-####"
end type

event modified;
if isnull(text) or trim(text) = "" or text = "   -  -    " then
	text = ""
	ssn = ""
else
	ssn = text + "%"
end if

parent.postevent("search_criteria_changed")

end event

