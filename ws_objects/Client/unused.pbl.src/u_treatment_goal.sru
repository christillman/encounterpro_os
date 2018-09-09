$PBExportHeader$u_treatment_goal.sru
forward
global type u_treatment_goal from statictext
end type
end forward

global type u_treatment_goal from statictext
integer width = 1477
integer height = 200
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type
global u_treatment_goal u_treatment_goal

type variables
string treatment_goal
end variables

forward prototypes
public subroutine set_goal (string ps_goal)
public subroutine pretty_text ()
end prototypes

public subroutine set_goal (string ps_goal);treatment_goal = ps_goal
pretty_text()

end subroutine

public subroutine pretty_text ();if isnull(treatment_goal) then
	text = ""
else
	text = treatment_goal
end if

end subroutine

event clicked;str_popup 			popup
str_popup_return 	popup_return
String				ls_null

Setnull(ls_null)
popup.data_row_count = 2
popup.items[1] = "FOLLOWUPGOAL"
popup.items[2] = treatment_goal
popup.title = "Pick Treatment Goal"
popup.multiselect = false
openwithparm(w_pick_top_20_multiline, popup, f_active_window())
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return

set_goal(popup_return.items[1])


end event

on constructor;setnull(treatment_goal)
end on

on u_treatment_goal.create
end on

on u_treatment_goal.destroy
end on

