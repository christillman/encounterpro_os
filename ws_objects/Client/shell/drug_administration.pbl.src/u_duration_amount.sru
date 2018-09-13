$PBExportHeader$u_duration_amount.sru
forward
global type u_duration_amount from statictext
end type
end forward

global type u_duration_amount from statictext
int Width=613
int Height=68
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
global u_duration_amount u_duration_amount

type variables
real amount
string unit
string prn
string pretty_fraction
boolean WasModified
end variables

forward prototypes
public subroutine pretty_text ()
public subroutine set_amount (real pr_amount, string ps_unit, string ps_prn)
public subroutine pick_prn_old ()
public subroutine pick_unit_old ()
end prototypes

public subroutine pretty_text ();if isnull(prn) then
	if amount = -1 then
		text = "Indefinite"
	elseif amount > 0 then
		text = f_pretty_amount_unit(amount, unit)
	else
		text = ""
	end if
else
	text = "PRN " + prn
end if
end subroutine

public subroutine set_amount (real pr_amount, string ps_unit, string ps_prn);amount = pr_amount

if ps_unit = "" then
	setnull(unit)
else
	unit = ps_unit
end if

if ps_prn = "" then
	setnull(prn)
else
	prn = ps_prn
end if

pretty_text()
end subroutine

public subroutine pick_prn_old ();//str_popup popup
//window w
//
//w = parent
//
//popup.pointerx = pointerx() + this.x + w.x
//popup.pointery = pointery() + this.y + w.y
//popup.item = prn
//openwithparm(w_pop_domain_prn, popup)
//
//if message.stringparm <> "" then
//	this.set_amount(amount, unit, message.stringparm)
//end if
//
end subroutine

public subroutine pick_unit_old ();//str_popup popup
//str_popup_return popup_return
//
//popup.dataobject = "dw_convertable_units"
//popup.displaycolumn = 2
//popup.datacolumn = 1
//openwithparm(w_pop_time_unit, popup)
//popup_return = message.powerobjectparm
//
//if not isnull(popup_return.item) then
//	set_amount(amount, popup_return.item, prn)
//end if
//
end subroutine

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 3
popup.items[1] = string(amount)
popup.items[2] = unit
popup.items[3] = prn

openwithparm(w_pop_duration, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 3 then return

set_amount(real(popup_return.items[1]),popup_return.items[2],popup_return.items[3])

end event

event constructor;unit = "DAY"
end event

