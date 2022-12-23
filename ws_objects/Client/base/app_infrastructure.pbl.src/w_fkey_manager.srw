$PBExportHeader$w_fkey_manager.srw
forward
global type w_fkey_manager from w_window_base
end type
type cb_1 from commandbutton within w_fkey_manager
end type
type st_1 from statictext within w_fkey_manager
end type
type dw_fkey_assignment from u_dw_pick_list within w_fkey_manager
end type
end forward

global type w_fkey_manager from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_1 cb_1
st_1 st_1
dw_fkey_assignment dw_fkey_assignment
end type
global w_fkey_manager w_fkey_manager

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();long ll_row

dw_fkey_assignment.reset()


ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F1"
dw_fkey_assignment.object.flags[ll_row] = 0
dw_fkey_assignment.object.assignment[ll_row] = "Display Online User Help for Current Screen"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F1"
dw_fkey_assignment.object.flags[ll_row] = 1
dw_fkey_assignment.object.assignment[ll_row] = "Display FKey Assignments (this screen)"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F2"
dw_fkey_assignment.object.flags[ll_row] = 0
dw_fkey_assignment.object.assignment[ll_row] = "Display Online Config Help for Current Screen"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F3"
dw_fkey_assignment.object.flags[ll_row] = 0
dw_fkey_assignment.object.assignment[ll_row] = "Display Current Context and System Information"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F3"
dw_fkey_assignment.object.flags[ll_row] = 2
dw_fkey_assignment.object.assignment[ll_row] = "Display EDAS Property Browser"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F3"
dw_fkey_assignment.object.flags[ll_row] = 3
dw_fkey_assignment.object.assignment[ll_row] = "Exit EncounterPRO"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F4"
dw_fkey_assignment.object.flags[ll_row] = 0
dw_fkey_assignment.object.assignment[ll_row] = "Toggle Config Mode On/Off"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F5"
dw_fkey_assignment.object.flags[ll_row] = 0
dw_fkey_assignment.object.assignment[ll_row] = "Refresh Current Screen"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F5"
dw_fkey_assignment.object.flags[ll_row] = 2
dw_fkey_assignment.object.assignment[ll_row] = "Clear EncounterPRO's Cache and Refresh Current Screen"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F6"
dw_fkey_assignment.object.flags[ll_row] = 0
dw_fkey_assignment.object.assignment[ll_row] = "Unassigned"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F7"
dw_fkey_assignment.object.flags[ll_row] = 0
dw_fkey_assignment.object.assignment[ll_row] = "Select and Run a Report"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F8"
dw_fkey_assignment.object.flags[ll_row] = 0
dw_fkey_assignment.object.assignment[ll_row] = "Display Document Manager for Current Context"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F8"
dw_fkey_assignment.object.flags[ll_row] = 2
dw_fkey_assignment.object.assignment[ll_row] = "Display Document Manager for Current Encounter"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F8"
dw_fkey_assignment.object.flags[ll_row] = 3
dw_fkey_assignment.object.assignment[ll_row] = "Display Document Manager for Current Patient"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F9"
dw_fkey_assignment.object.flags[ll_row] = 0
dw_fkey_assignment.object.assignment[ll_row] = "Change Current Scribing Context"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F10"
dw_fkey_assignment.object.flags[ll_row] = 0
dw_fkey_assignment.object.assignment[ll_row] = "User Defined Menu (menu_context = 'Hotkey', meny_key = 'F10')"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F11"
dw_fkey_assignment.object.flags[ll_row] = 0
dw_fkey_assignment.object.assignment[ll_row] = "User Defined Menu (menu_context = 'Hotkey', meny_key = 'F11')"

ll_row = dw_fkey_assignment.insertrow(0)
dw_fkey_assignment.object.fkey[ll_row] = "F12"
dw_fkey_assignment.object.flags[ll_row] = 0
dw_fkey_assignment.object.assignment[ll_row] = "Lock This Terminal"

return 1

end function

on w_fkey_manager.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.st_1=create st_1
this.dw_fkey_assignment=create dw_fkey_assignment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_fkey_assignment
end on

on w_fkey_manager.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.dw_fkey_assignment)
end on

event open;call super::open;refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_fkey_manager
integer x = 2857
integer y = 12
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_fkey_manager
end type

type cb_1 from commandbutton within w_fkey_manager
integer x = 2455
integer y = 1600
integer width = 402
integer height = 112
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean cancel = true
boolean default = true
end type

event clicked;close(parent)
end event

type st_1 from statictext within w_fkey_manager
integer width = 2921
integer height = 104
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "FKey Assignments"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_fkey_assignment from u_dw_pick_list within w_fkey_manager
integer x = 558
integer y = 172
integer width = 1778
integer height = 1376
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_fkey_assignment_display"
boolean vscrollbar = true
end type

