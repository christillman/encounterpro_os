HA$PBExportHeader$u_cb_toggle.sru
forward
global type u_cb_toggle from commandbutton
end type
end forward

global type u_cb_toggle from commandbutton
int Width=293
int Height=109
int TabOrder=1
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type
global u_cb_toggle u_cb_toggle

type variables
string on_string
string off_string

string on_value
string off_value

string value

end variables

forward prototypes
public subroutine display ()
public subroutine initialize (string ps_on_string, string ps_on_value, string ps_off_string, string ps_off_value, string ps_current_value)
public subroutine set (string ps_value)
end prototypes

public subroutine display ();
if value = on_value then
	text = on_string
else
	text = off_string
end if

end subroutine

public subroutine initialize (string ps_on_string, string ps_on_value, string ps_off_string, string ps_off_value, string ps_current_value);on_string = ps_on_string
on_value = ps_on_value
off_string = ps_off_string
off_value = ps_off_value

set(ps_current_value)

end subroutine

public subroutine set (string ps_value);if ps_value = on_value then
	value = on_value
else
	value = off_value
end if

display()

end subroutine

on clicked;if on_value = value then
	set(off_value)
else
	set(on_value)
end if


end on

