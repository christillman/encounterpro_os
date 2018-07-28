HA$PBExportHeader$u_st_time.sru
forward
global type u_st_time from statictext
end type
end forward

global type u_st_time from statictext
int Width=613
int Height=132
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type
global u_st_time u_st_time

type variables
real amount
string unit
boolean WasModified
end variables

forward prototypes
public subroutine pretty_text ()
public subroutine set_time (real pr_amount, string ps_unit)
end prototypes

public subroutine pretty_text ();if amount <= 0 or isnull(unit) then
	text = ""
else
	text = string(amount) + " " + upper(left(unit,1)) + lower(mid(unit,2))
	if amount <> 1 then text = text + "s"
end if

end subroutine

public subroutine set_time (real pr_amount, string ps_unit);amount = pr_amount
unit = ps_unit
pretty_text()
end subroutine

event clicked;//openwithparm(w_pop_time, this)
str_popup popup
str_popup_return popup_return
integer li_sts

popup.data_row_count = 2
popup.items[1] = string(amount)
popup.items[2] = unit
openwithparm(w_pop_time_interval, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return

set_time(real(popup_return.items[1]), popup_return.items[2])


end event

