HA$PBExportHeader$u_treatment_report_control.sru
forward
global type u_treatment_report_control from userobject
end type
type st_when from statictext within u_treatment_report_control
end type
type st_print from statictext within u_treatment_report_control
end type
type st_description from statictext within u_treatment_report_control
end type
end forward

global type u_treatment_report_control from userobject
integer width = 1367
integer height = 116
long backcolor = 33538240
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
st_when st_when
st_print st_print
st_description st_description
end type
global u_treatment_report_control u_treatment_report_control

type variables
string report_preference_id
long treatment_id

string print_flag
string when_flag

string report_service
string report_id
string display_format
string report_user_id

boolean report_is_ordered

end variables

forward prototypes
public function integer initialize (long pl_treatment_id, string ps_report, string ps_key)
public function integer queue_report ()
end prototypes

public function integer initialize (long pl_treatment_id, string ps_report, string ps_key);string ls_flags
str_attributes lstr_attributes
integer li_step_number

// preference is two characters:
// 1st character: 	"P" = Print
//							"D" = Don't Print
// 2nd character:		"N" = Now
//							"C" = At Checkout

treatment_id = pl_treatment_id

if isnull(current_service) then
	visible = false
	return 0
end if

report_service = current_service.get_attribute("report_service")
if isnull(report_service) then report_service = "REPORT"

report_id = current_service.get_attribute("report_id")
if isnull(report_id) then report_id = "{AD78CA36-789B-49F1-8C17-D76C730E488F}"

report_user_id = current_service.get_attribute("report_user_id")
if isnull(report_user_id) then report_user_id = "#SYSTEM"

display_format = current_service.get_attribute("display_format")
if isnull(display_format) then display_format = "Prescription"

lstr_attributes.attribute_count = 1

report_is_ordered = current_patient.treatments.is_ordered(treatment_id, report_service, li_step_number)

report_preference_id = "TRTRPT|" + ps_report + "|" + ps_key

ls_flags = datalist.get_preference("TREATMENT", report_preference_id)

if isnull(ls_flags) then ls_flags = "PC"


if left(ls_flags, 1) = "P" or report_is_ordered then
	print_flag = "P"
	st_print.text = "Print"
else
	print_flag = "D"
	st_print.text = "Don't Print"
end if

if right(ls_flags, 1) = "N" and (isnull(li_step_number) or li_step_number < 999) then
	when_flag = "N"
	st_when.text = "Now"
else
	when_flag = "C"
	st_when.text = "At Checkout"
end if

return 1

end function

public function integer queue_report ();str_attributes lstr_attributes
long ll_encounter_id
integer li_step_number

setnull(ll_encounter_id)

if not visible then return 0
if print_flag <> "P" then return 0

if not isnull(current_service) then
	ll_encounter_id = current_service.encounter_id
end if

if when_flag = "N" then
	setnull(li_step_number)
else
	li_step_number = 999
end if

lstr_attributes.attribute_count = 3
lstr_attributes.attribute[1].attribute = "report_id"
lstr_attributes.attribute[1].value = report_id
lstr_attributes.attribute[2].attribute = "display_format"
lstr_attributes.attribute[2].value = display_format
lstr_attributes.attribute[3].attribute = "treatment_id"
lstr_attributes.attribute[3].value = string(treatment_id)

service_list.order_service(current_patient.cpr_id, ll_encounter_id, report_service, report_user_id, st_description.text, li_step_number, lstr_attributes)

datalist.update_preference("TREATMENT", "User", current_user.user_id, report_preference_id, print_flag + when_flag)

return 1

end function

on u_treatment_report_control.create
this.st_when=create st_when
this.st_print=create st_print
this.st_description=create st_description
this.Control[]={this.st_when,&
this.st_print,&
this.st_description}
end on

on u_treatment_report_control.destroy
destroy(this.st_when)
destroy(this.st_print)
destroy(this.st_description)
end on

type st_when from statictext within u_treatment_report_control
integer x = 937
integer y = 8
integer width = 421
integer height = 104
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "at Checkout"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if when_flag = "N" then
	when_flag = "C"
	text = "At Checkout"
else
	when_flag = "N"
	text = "Now"
end if

end event

type st_print from statictext within u_treatment_report_control
integer x = 608
integer y = 8
integer width = 315
integer height = 104
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Don~'t Print"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if print_flag = "P" then
	print_flag = "D"
	text = "Don't Print"
else
	print_flag = "P"
	text = "Print"
end if

end event

type st_description from statictext within u_treatment_report_control
integer x = 14
integer y = 28
integer width = 590
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Prescription Report:"
alignment alignment = center!
boolean focusrectangle = false
end type

