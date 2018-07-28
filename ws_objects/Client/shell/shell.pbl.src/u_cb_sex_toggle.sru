$PBExportHeader$u_cb_sex_toggle.sru
forward
global type u_cb_sex_toggle from commandbutton
end type
end forward

global type u_cb_sex_toggle from commandbutton
integer width = 293
integer height = 108
integer taborder = 1
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type
global u_cb_sex_toggle u_cb_sex_toggle

type variables
string sex
end variables

forward prototypes
public subroutine set_sex (string ps_sex)
public subroutine display_sex ()
end prototypes

public subroutine set_sex (string ps_sex);sex = ps_sex
display_sex()
end subroutine

public subroutine display_sex ();
if upper(left(sex, 1)) = "M" then
	text = "Male"
elseif upper(left(sex, 1)) = "F" then
	text = "Female"
else
	text = ""
end if

end subroutine

on clicked;if sex = "M" then
	sex = "F"
else
	sex = "M"
end if

display_sex()

end on

on u_cb_sex_toggle.create
end on

on u_cb_sex_toggle.destroy
end on

