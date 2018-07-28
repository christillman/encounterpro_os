HA$PBExportHeader$u_treatment_goal.sru
//
//EncounterPRO Open Source Project
//
//Copyright 2010 EncounterPRO Healthcare Resources, Inc.
//
//This program is free software: you can redistribute it and/or modify it under the terms
//of the GNU Affero General Public License as published by  the Free Software Foundation, 
//either version 3 of the License, or (at your option) any later version.
//
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//See the GNU Affero General Public License for more details.
//
//You should have received a copy of the GNU Affero General Public License along with this
//program.  If not, see <http://www.gnu.org/licenses/>.
//
//EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero
//General Public License version 3, or any later version.  As such, linking the Project
//statically or dynamically with other components is making a combined work based on the
//Project. Thus, the terms and conditions of the GNU Affero General Public License 
//version 3, or any later version, cover the whole combination. 
//
//However, as an additional permission, the copyright holders of EncounterPRO Open Source 
//Project give you permission to link the Project with independent components, regardless 
//of the license terms of these independent components, provided that all of the following
//are true:
// 
//1) all access from the independent component to persisted data which resides inside any 
//   EncounterPRO Open Source data store (e.g. SQL Server database) be made through a 
//   publically available database driver (e.g. ODBC, SQL Native Client, etc) or through 
//   a service which itself is part of The Project.
//2) the independent component does not create or rely on any code or data structures 
//   within the EncounterPRO Open Source data store unless such code or data structures, 
//   and all code and data structures referred to by such code or data structures, are 
//   themselves part of The Project.
//3) the independent component either a) runs locally on the user's computer, or b) is 
//   linked to at runtime by The Project’s Component Manager object which in turn is 
//   called by code which itself is part of The Project.
//
//An independent component is a component which is not derived from or based on the
//Project. If you modify the Project, you may extend this additional permission to your
//version of the Project, but you are not obligated to do so. If you do not wish to do
//so, delete this additional permission statement from your version. 
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

