$PBExportHeader$u_followup_prn.sru
forward
global type u_followup_prn from statictext
end type
end forward

global type u_followup_prn from statictext
integer width = 613
integer height = 68
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15780004
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type
global u_followup_prn u_followup_prn

type variables
string prn
boolean WasModified
end variables

forward prototypes
public subroutine pretty_text ()
public subroutine pick_prn ()
public subroutine set_prn (string ps_prn)
end prototypes

public subroutine pretty_text ();if isnull(prn) then
	text = ""
else
	text = prn
end if
end subroutine

public subroutine pick_prn ();str_popup popup
str_popup_return popup_return
window w

w = parent

popup.pointerx = pointerx() + this.x + w.x
popup.pointery = pointery() + this.y + w.y
popup.item = prn

openwithparm(w_pop_pick, popup)

popup_return = message.powerobjectparm

if isvalid(popup_return) and not isnull(popup_return) then
	this.set_prn(popup_return.item)
end if

end subroutine

public subroutine set_prn (string ps_prn);prn = ps_prn
pretty_text()
end subroutine

event clicked;str_popup popup
str_popup_return popup_return
String	ls_null

Setnull(ls_null)
popup.data_row_count = 2
popup.items[1] = "FOLLOWUPPRN"
popup.items[2] = prn
popup.title = "Pick Followup Prns"
popup.multiselect = false

openwithparm(w_pick_top_20_multiline, popup, f_active_window())
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return

set_prn(popup_return.items[1])

end event

on constructor;setnull(prn)
end on

on u_followup_prn.create
end on

on u_followup_prn.destroy
end on

