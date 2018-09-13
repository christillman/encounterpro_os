$PBExportHeader$u_allergies.sru
forward
global type u_allergies from statictext
end type
end forward

global type u_allergies from statictext
integer width = 439
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15780004
string text = "No Allergies"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type
global u_allergies u_allergies

type variables
boolean allergies
end variables

forward prototypes
public subroutine set_value ()
end prototypes

public subroutine set_value ();if current_patient.any_allergies() then
	allergies = true
	text = "Allergies"
	textcolor = COLOR_RED
	weight = 700
else
	allergies = false
	text = "No Allergies"
	textcolor = COLOR_BLACK
	weight = 400
end if


end subroutine

event clicked;str_attributes lstr_attributes
string ls_service

ls_service = "ASSESSMENT_LIST"

service_list.do_service(current_patient.cpr_id, &
								current_patient.open_encounter_id, &
								ls_service, &
								lstr_attributes)


set_value()

end event

on u_allergies.create
end on

on u_allergies.destroy
end on

