$PBExportHeader$u_tab_consultant_info.sru
forward
global type u_tab_consultant_info from u_tab_manager
end type
type tabpage_general from u_tabpage_consultant_info_general within u_tab_consultant_info
end type
type tabpage_general from u_tabpage_consultant_info_general within u_tab_consultant_info
end type
type tabpage_address from u_tabpage_consultant_info_address within u_tab_consultant_info
end type
type tabpage_address from u_tabpage_consultant_info_address within u_tab_consultant_info
end type
type tabpage_authorities from u_tabpage_consultant_info_authorities within u_tab_consultant_info
end type
type tabpage_authorities from u_tabpage_consultant_info_authorities within u_tab_consultant_info
end type
end forward

global type u_tab_consultant_info from u_tab_manager
integer width = 2898
integer height = 1372
long backcolor = 33538240
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
tabpage_general tabpage_general
tabpage_address tabpage_address
tabpage_authorities tabpage_authorities
end type
global u_tab_consultant_info u_tab_consultant_info

on u_tab_consultant_info.create
this.tabpage_general=create tabpage_general
this.tabpage_address=create tabpage_address
this.tabpage_authorities=create tabpage_authorities
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_general
this.Control[iCurrent+2]=this.tabpage_address
this.Control[iCurrent+3]=this.tabpage_authorities
end on

on u_tab_consultant_info.destroy
call super::destroy
destroy(this.tabpage_general)
destroy(this.tabpage_address)
destroy(this.tabpage_authorities)
end on

type tabpage_general from u_tabpage_consultant_info_general within u_tab_consultant_info
integer x = 18
integer y = 16
integer width = 2862
integer height = 1244
string text = "General Info"
end type

type tabpage_address from u_tabpage_consultant_info_address within u_tab_consultant_info
integer x = 18
integer y = 16
integer width = 2862
integer height = 1244
string text = "Address"
end type

type tabpage_authorities from u_tabpage_consultant_info_authorities within u_tab_consultant_info
integer x = 18
integer y = 16
integer width = 2862
integer height = 1244
string text = "Authorities"
end type

