$PBExportHeader$u_tab_vial_list.sru
forward
global type u_tab_vial_list from u_tab_manager
end type
type tabpage_open_vials from u_tabpage_open_vials within u_tab_vial_list
end type
type tabpage_open_vials from u_tabpage_open_vials within u_tab_vial_list
end type
type tabpage_closed_vials from u_tabpage_closed_vials within u_tab_vial_list
end type
type tabpage_closed_vials from u_tabpage_closed_vials within u_tab_vial_list
end type
end forward

global type u_tab_vial_list from u_tab_manager
integer width = 2139
integer height = 1180
long backcolor = 7191717
boolean raggedright = false
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
alignment alignment = center!
tabpage_open_vials tabpage_open_vials
tabpage_closed_vials tabpage_closed_vials
end type
global u_tab_vial_list u_tab_vial_list

type variables

end variables

on u_tab_vial_list.create
this.tabpage_open_vials=create tabpage_open_vials
this.tabpage_closed_vials=create tabpage_closed_vials
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_open_vials
this.Control[iCurrent+2]=this.tabpage_closed_vials
end on

on u_tab_vial_list.destroy
call super::destroy
destroy(this.tabpage_open_vials)
destroy(this.tabpage_closed_vials)
end on

type tabpage_open_vials from u_tabpage_open_vials within u_tab_vial_list
integer x = 18
integer y = 16
integer width = 2103
integer height = 1052
string text = "Open Vials"
end type

type tabpage_closed_vials from u_tabpage_closed_vials within u_tab_vial_list
integer x = 18
integer y = 16
integer width = 2103
integer height = 1052
string text = "Closed Vials"
end type

