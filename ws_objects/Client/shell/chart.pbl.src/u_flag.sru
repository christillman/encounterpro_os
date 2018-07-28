$PBExportHeader$u_flag.sru
forward
global type u_flag from checkbox
end type
end forward

global type u_flag from checkbox
int Width=522
int Height=73
string Text="none"
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type
global u_flag u_flag

type variables
string flag
end variables

forward prototypes
public subroutine set_flag (string ps_flag)
end prototypes

public subroutine set_flag (string ps_flag);if ps_flag = "Y" then
	checked = true
	flag = "Y"
else
	checked = false
	flag = "N"
end if
end subroutine

on constructor;checked = false
flag = "N"
end on

on clicked;if checked then
	flag = "Y"
else
	flag = "N"
end if
end on

