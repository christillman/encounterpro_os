$PBExportHeader$u_st_radio_calc_per.sru
forward
global type u_st_radio_calc_per from statictext
end type
end forward

shared variables

// Modify the data type the user object itself
u_st_radio_calc_per last_button
end variables

global type u_st_radio_calc_per from statictext
int Width=531
int Height=73
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
string Text="none"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type
global u_st_radio_calc_per u_st_radio_calc_per

type variables
boolean button_selected = false

end variables

forward prototypes
public subroutine unselect_button ()
public subroutine select_button ()
public subroutine enable_button ()
public subroutine disable_button ()
end prototypes

public subroutine unselect_button ();backcolor = COLOR_LIGHT_GREY
borderstyle = styleraised!
button_selected = false


end subroutine

public subroutine select_button ();if isvalid(last_button) and not isnull(last_button) then last_button.unselect_button()
last_button = this
backcolor = COLOR_DARK_GREY
borderstyle = stylelowered!
button_selected = true

end subroutine

public subroutine enable_button ();weight = 700
italic = false
enabled = true

if button_selected then
	backcolor = COLOR_DARK_GREY
	borderstyle = stylelowered!
end if

end subroutine

public subroutine disable_button ();weight = 400
italic = true
enabled = false

backcolor = COLOR_LIGHT_GREY
borderstyle = styleraised!

end subroutine

event clicked;select_button()

end event

