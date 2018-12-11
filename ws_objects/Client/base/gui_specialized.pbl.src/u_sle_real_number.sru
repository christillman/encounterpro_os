$PBExportHeader$u_sle_real_number.sru
forward
global type u_sle_real_number from singlelineedit
end type
end forward

global type u_sle_real_number from singlelineedit
int Width=247
int Height=93
int TabOrder=1
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
event first_value pbm_custom01
event new_value pbm_custom02
end type
global u_sle_real_number u_sle_real_number

type variables
real value
end variables

event modified;real lr_new_value

lr_new_value = real(text)

if lr_new_value <> value then
	if value = 0 then
		postevent("first_value")
	else
		postevent("new_value")
	end if
	value = lr_new_value
end if

if value = 0 then
	text = ""
end if

end event

