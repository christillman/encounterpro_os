$PBExportHeader$u_tabpage_patient_employer.sru
forward
global type u_tabpage_patient_employer from u_tabpage
end type
type cb_termination_date_clear from commandbutton within u_tabpage_patient_employer
end type
type cb_start_date_clear from commandbutton within u_tabpage_patient_employer
end type
type st_termination_date from statictext within u_tabpage_patient_employer
end type
type st_start_date from statictext within u_tabpage_patient_employer
end type
type st_8 from statictext within u_tabpage_patient_employer
end type
type sle_employment_status from singlelineedit within u_tabpage_patient_employer
end type
type st_7 from statictext within u_tabpage_patient_employer
end type
type st_6 from statictext within u_tabpage_patient_employer
end type
type sle_job_description from singlelineedit within u_tabpage_patient_employer
end type
type st_2 from statictext within u_tabpage_patient_employer
end type
type sle_shift from singlelineedit within u_tabpage_patient_employer
end type
type st_1 from statictext within u_tabpage_patient_employer
end type
type st_cpr_id from statictext within u_tabpage_patient_employer
end type
type sle_employer from singlelineedit within u_tabpage_patient_employer
end type
type sle_employeeid from singlelineedit within u_tabpage_patient_employer
end type
type st_3 from statictext within u_tabpage_patient_employer
end type
type st_4 from statictext within u_tabpage_patient_employer
end type
type st_phone_num_title from statictext within u_tabpage_patient_employer
end type
type sle_department from singlelineedit within u_tabpage_patient_employer
end type
type st_5 from statictext within u_tabpage_patient_employer
end type
end forward

global type u_tabpage_patient_employer from u_tabpage
integer width = 3067
integer height = 1268
string text = "none"
cb_termination_date_clear cb_termination_date_clear
cb_start_date_clear cb_start_date_clear
st_termination_date st_termination_date
st_start_date st_start_date
st_8 st_8
sle_employment_status sle_employment_status
st_7 st_7
st_6 st_6
sle_job_description sle_job_description
st_2 st_2
sle_shift sle_shift
st_1 st_1
st_cpr_id st_cpr_id
sle_employer sle_employer
sle_employeeid sle_employeeid
st_3 st_3
st_4 st_4
st_phone_num_title st_phone_num_title
sle_department sle_department
st_5 st_5
end type
global u_tabpage_patient_employer u_tabpage_patient_employer

type variables


end variables

forward prototypes
public function integer initialize ()
public function integer show_patient (string ps_cpr_id)
end prototypes

public function integer initialize ();integer li_sts
string ls_temp

if isnull(current_patient) then
	log.log(this, "u_tabpage_patient_employer.initialize:0005", "No current patient", 4)
	return -1
else
	st_cpr_id.text = current_patient.cpr_id
	li_sts = show_patient(current_patient.cpr_id)
	if li_sts <= 0 then return -1
end if

return 1

end function

public function integer show_patient (string ps_cpr_id);string ls_temp

sle_department.text 		= current_patient.department
sle_employeeid.text 		= current_patient.employeeid
sle_employer.text 	= current_patient.employer
sle_employment_status.text 		= current_patient.employment_status
sle_job_description.text = current_patient.job_description
sle_shift.text = current_patient.shift

if isnull(current_patient.start_date) then
	cb_start_date_clear.visible = false
	st_start_date.text = ""
else
	cb_start_date_clear.visible = true
	ls_temp = string(date(current_patient.start_date))
	st_start_date.text = ls_temp
end if

if isnull(current_patient.termination_date) then
	cb_termination_date_clear.visible = false
	st_termination_date.text = ""
else
	cb_termination_date_clear.visible = true
	ls_temp = string(date(current_patient.termination_date))
	st_termination_date.text = ls_temp
end if

Return 1

end function

on u_tabpage_patient_employer.create
int iCurrent
call super::create
this.cb_termination_date_clear=create cb_termination_date_clear
this.cb_start_date_clear=create cb_start_date_clear
this.st_termination_date=create st_termination_date
this.st_start_date=create st_start_date
this.st_8=create st_8
this.sle_employment_status=create sle_employment_status
this.st_7=create st_7
this.st_6=create st_6
this.sle_job_description=create sle_job_description
this.st_2=create st_2
this.sle_shift=create sle_shift
this.st_1=create st_1
this.st_cpr_id=create st_cpr_id
this.sle_employer=create sle_employer
this.sle_employeeid=create sle_employeeid
this.st_3=create st_3
this.st_4=create st_4
this.st_phone_num_title=create st_phone_num_title
this.sle_department=create sle_department
this.st_5=create st_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_termination_date_clear
this.Control[iCurrent+2]=this.cb_start_date_clear
this.Control[iCurrent+3]=this.st_termination_date
this.Control[iCurrent+4]=this.st_start_date
this.Control[iCurrent+5]=this.st_8
this.Control[iCurrent+6]=this.sle_employment_status
this.Control[iCurrent+7]=this.st_7
this.Control[iCurrent+8]=this.st_6
this.Control[iCurrent+9]=this.sle_job_description
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.sle_shift
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.st_cpr_id
this.Control[iCurrent+14]=this.sle_employer
this.Control[iCurrent+15]=this.sle_employeeid
this.Control[iCurrent+16]=this.st_3
this.Control[iCurrent+17]=this.st_4
this.Control[iCurrent+18]=this.st_phone_num_title
this.Control[iCurrent+19]=this.sle_department
this.Control[iCurrent+20]=this.st_5
end on

on u_tabpage_patient_employer.destroy
call super::destroy
destroy(this.cb_termination_date_clear)
destroy(this.cb_start_date_clear)
destroy(this.st_termination_date)
destroy(this.st_start_date)
destroy(this.st_8)
destroy(this.sle_employment_status)
destroy(this.st_7)
destroy(this.st_6)
destroy(this.sle_job_description)
destroy(this.st_2)
destroy(this.sle_shift)
destroy(this.st_1)
destroy(this.st_cpr_id)
destroy(this.sle_employer)
destroy(this.sle_employeeid)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_phone_num_title)
destroy(this.sle_department)
destroy(this.st_5)
end on

type cb_termination_date_clear from commandbutton within u_tabpage_patient_employer
integer x = 2441
integer y = 808
integer width = 174
integer height = 64
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;string ls_null

setnull(ls_null)

current_patient.modify_patient("termination_date", ls_null)
st_termination_date.text = ""

visible = false

end event

type cb_start_date_clear from commandbutton within u_tabpage_patient_employer
integer x = 1161
integer y = 808
integer width = 174
integer height = 64
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;string ls_null

setnull(ls_null)

current_patient.modify_patient("start_date", ls_null)
st_start_date.text = ""

visible = false

end event

type st_termination_date from statictext within u_tabpage_patient_employer
integer x = 1989
integer y = 768
integer width = 443
integer height = 104
integer taborder = 50
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

event clicked;date ld_termination_date
string ls_text

ld_termination_date = date(current_patient.termination_date)

ls_text = f_select_date(ld_termination_date, "Employment End Date")
if isnull(ls_text) then return

if (ld_termination_date <> date(current_patient.termination_date)) or isnull(current_patient.termination_date) then
	current_patient.modify_patient("termination_date", ls_text)
	text = string(current_patient.termination_date, date_format_string)
	cb_termination_date_clear.visible = true
end if


end event

type st_start_date from statictext within u_tabpage_patient_employer
integer x = 709
integer y = 768
integer width = 443
integer height = 104
integer taborder = 50
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

event clicked;date ld_start_date
string ls_text

ld_start_date = date(current_patient.start_date)

ls_text = f_select_date(ld_start_date, "Employment Start Date")
if isnull(ls_text) then return

if (ld_start_date <> date(current_patient.start_date)) or isnull(current_patient.start_date) then
	current_patient.modify_patient("start_date", ls_text)
	text = string(current_patient.start_date, date_format_string)
	cb_start_date_clear.visible = true
end if


end event

type st_8 from statictext within u_tabpage_patient_employer
integer x = 50
integer y = 944
integer width = 617
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Employment Status"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_employment_status from singlelineedit within u_tabpage_patient_employer
integer x = 709
integer y = 924
integer width = 1029
integer height = 104
integer taborder = 80
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
if f_string_modified(current_patient.employment_status, text) then
	current_patient.modify_patient("employment_status", text)
	text = current_patient.employment_status
end if

end event

type st_7 from statictext within u_tabpage_patient_employer
integer x = 1440
integer y = 784
integer width = 517
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Termination Date"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within u_tabpage_patient_employer
integer x = 329
integer y = 784
integer width = 338
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Start Date"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_job_description from singlelineedit within u_tabpage_patient_employer
integer x = 709
integer y = 612
integer width = 1723
integer height = 108
integer taborder = 50
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;if f_string_modified(current_patient.job_description, text) then
	current_patient.modify_patient("job_description", text)
	text = current_patient.job_description
end if

end event

type st_2 from statictext within u_tabpage_patient_employer
integer x = 50
integer y = 624
integer width = 617
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Job Description"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_shift from singlelineedit within u_tabpage_patient_employer
integer x = 1742
integer y = 456
integer width = 690
integer height = 108
integer taborder = 40
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;if f_string_modified(current_patient.shift, text) then
	current_patient.modify_patient("shift", text)
	text = current_patient.shift
end if

end event

type st_1 from statictext within u_tabpage_patient_employer
integer x = 1504
integer y = 472
integer width = 201
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Shift"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_cpr_id from statictext within u_tabpage_patient_employer
integer x = 23
integer y = 20
integer width = 375
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_employer from singlelineedit within u_tabpage_patient_employer
integer x = 709
integer y = 152
integer width = 1723
integer height = 104
integer taborder = 10
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

if f_string_modified(current_patient.employer, text) then
	current_patient.modify_patient("employer", text)
	text = current_patient.employer
end if

end event

type sle_employeeid from singlelineedit within u_tabpage_patient_employer
integer x = 709
integer y = 304
integer width = 1029
integer height = 104
integer taborder = 20
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
if f_string_modified(current_patient.employeeid, text) then
	current_patient.modify_patient("employeeid", text)
	text = current_patient.employeeid
end if

end event

type st_3 from statictext within u_tabpage_patient_employer
integer x = 50
integer y = 320
integer width = 617
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Employee ID"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within u_tabpage_patient_employer
integer x = 50
integer y = 168
integer width = 617
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Employer"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_phone_num_title from statictext within u_tabpage_patient_employer
integer x = 50
integer y = 472
integer width = 617
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Department"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_department from singlelineedit within u_tabpage_patient_employer
integer x = 709
integer y = 456
integer width = 690
integer height = 108
integer taborder = 30
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;if f_string_modified(current_patient.department, text) then
	current_patient.modify_patient("department", text)
	text = current_patient.department
end if

end event

type st_5 from statictext within u_tabpage_patient_employer
integer width = 2848
integer height = 96
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Employment Information"
alignment alignment = center!
boolean focusrectangle = false
end type

