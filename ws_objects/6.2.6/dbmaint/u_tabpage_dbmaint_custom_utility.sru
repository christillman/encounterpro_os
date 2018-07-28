HA$PBExportHeader$u_tabpage_dbmaint_custom_utility.sru
forward
global type u_tabpage_dbmaint_custom_utility from u_tabpage
end type
type cb_2 from commandbutton within u_tabpage_dbmaint_custom_utility
end type
type cb_1 from commandbutton within u_tabpage_dbmaint_custom_utility
end type
type st_1 from statictext within u_tabpage_dbmaint_custom_utility
end type
type st_script_title from statictext within u_tabpage_dbmaint_custom_utility
end type
end forward

global type u_tabpage_dbmaint_custom_utility from u_tabpage
integer width = 2898
string text = "Updates"
cb_2 cb_2
cb_1 cb_1
st_1 st_1
st_script_title st_script_title
end type
global u_tabpage_dbmaint_custom_utility u_tabpage_dbmaint_custom_utility

type variables
string script_type

long script_id
string script_name
integer allow_users


end variables

on u_tabpage_dbmaint_custom_utility.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_1=create st_1
this.st_script_title=create st_script_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_script_title
end on

on u_tabpage_dbmaint_custom_utility.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_script_title)
end on

type cb_2 from commandbutton within u_tabpage_dbmaint_custom_utility
integer x = 731
integer y = 816
integer width = 1403
integer height = 104
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Merged Migrated Patients Repair Utility"
end type

event clicked;string ls_command

ls_command = "mmpma.exe ~"" + common_thread.default_database + "~""

run(ls_command)


end event

type cb_1 from commandbutton within u_tabpage_dbmaint_custom_utility
integer x = 731
integer y = 604
integer width = 1399
integer height = 104
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Modified Medication Repair Utility"
end type

event clicked;open(w_modmedrepair)
end event

type st_1 from statictext within u_tabpage_dbmaint_custom_utility
integer x = 558
integer y = 52
integer width = 1733
integer height = 288
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "These utility screens are intended for use during advanced EncounterPro maintenance and troubleshooting.  Please do not perform any of these scripts unless told to do so by an authorized EncounterPRO Support person."
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_script_title from statictext within u_tabpage_dbmaint_custom_utility
integer x = 626
integer y = 448
integer width = 1623
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Available Utility Screens"
alignment alignment = center!
boolean focusrectangle = false
end type

