$PBExportHeader$u_tab_preference_edit.sru
forward
global type u_tab_preference_edit from u_tab_manager
end type
type tabpage_global from u_tabpage_preference_edit within u_tab_preference_edit
end type
type tabpage_global from u_tabpage_preference_edit within u_tab_preference_edit
end type
type tabpage_office from u_tabpage_preference_edit within u_tab_preference_edit
end type
type tabpage_office from u_tabpage_preference_edit within u_tab_preference_edit
end type
type tabpage_computer from u_tabpage_preference_edit within u_tab_preference_edit
end type
type tabpage_computer from u_tabpage_preference_edit within u_tab_preference_edit
end type
type tabpage_specialty from u_tabpage_preference_edit within u_tab_preference_edit
end type
type tabpage_specialty from u_tabpage_preference_edit within u_tab_preference_edit
end type
type tabpage_user from u_tabpage_preference_edit within u_tab_preference_edit
end type
type tabpage_user from u_tabpage_preference_edit within u_tab_preference_edit
end type
end forward

global type u_tab_preference_edit from u_tab_manager
integer width = 2533
integer height = 1480
long backcolor = 33538240
boolean raggedright = false
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
alignment alignment = center!
tabpage_global tabpage_global
tabpage_office tabpage_office
tabpage_computer tabpage_computer
tabpage_specialty tabpage_specialty
tabpage_user tabpage_user
end type
global u_tab_preference_edit u_tab_preference_edit

type variables
string preference_type = "PREFERENCES"


end variables

on u_tab_preference_edit.create
this.tabpage_global=create tabpage_global
this.tabpage_office=create tabpage_office
this.tabpage_computer=create tabpage_computer
this.tabpage_specialty=create tabpage_specialty
this.tabpage_user=create tabpage_user
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_global
this.Control[iCurrent+2]=this.tabpage_office
this.Control[iCurrent+3]=this.tabpage_computer
this.Control[iCurrent+4]=this.tabpage_specialty
this.Control[iCurrent+5]=this.tabpage_user
end on

on u_tab_preference_edit.destroy
call super::destroy
destroy(this.tabpage_global)
destroy(this.tabpage_office)
destroy(this.tabpage_computer)
destroy(this.tabpage_specialty)
destroy(this.tabpage_user)
end on

type tabpage_global from u_tabpage_preference_edit within u_tab_preference_edit
integer x = 18
integer y = 16
integer width = 2496
integer height = 1352
string text = "Global"
string preference_level = "Global"
end type

type tabpage_office from u_tabpage_preference_edit within u_tab_preference_edit
integer x = 18
integer y = 16
integer width = 2496
integer height = 1352
string text = "Office"
string preference_level = "Office"
end type

type tabpage_computer from u_tabpage_preference_edit within u_tab_preference_edit
integer x = 18
integer y = 16
integer width = 2496
integer height = 1352
string text = "Computer"
string preference_level = "Computer"
end type

type tabpage_specialty from u_tabpage_preference_edit within u_tab_preference_edit
integer x = 18
integer y = 16
integer width = 2496
integer height = 1352
string text = "Specialty"
string preference_level = "Specialty"
end type

type tabpage_user from u_tabpage_preference_edit within u_tab_preference_edit
integer x = 18
integer y = 16
integer width = 2496
integer height = 1352
string text = "User"
string preference_level = "User"
end type

