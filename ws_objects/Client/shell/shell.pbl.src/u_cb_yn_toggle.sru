$PBExportHeader$u_cb_yn_toggle.sru
forward
global type u_cb_yn_toggle from commandbutton
end type
end forward

global type u_cb_yn_toggle from commandbutton
integer width = 114
integer height = 100
integer taborder = 1
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type
global u_cb_yn_toggle u_cb_yn_toggle

type variables
string yn
end variables

forward prototypes
public subroutine set_yn (string ps_yn)
public subroutine display_yn ()
public function string get_yn ()
end prototypes

public subroutine set_yn (string ps_yn);yn = ps_yn
display_yn()
end subroutine

public subroutine display_yn ();
if yn = "Y" then
	text = "Y"
else
	text = "N"
end if

end subroutine

public function string get_yn ();return text
end function

on clicked;if yn = "Y" then
	yn = "N"
else
	yn = "Y"
end if

display_yn()

end on

on u_cb_yn_toggle.create
end on

on u_cb_yn_toggle.destroy
end on

