HA$PBExportHeader$u_tab_assessment_type_definition.sru
forward
global type u_tab_assessment_type_definition from u_tab_manager
end type
type tabpage_info from u_tabpage_assessment_type_info within u_tab_assessment_type_definition
end type
type tabpage_info from u_tabpage_assessment_type_info within u_tab_assessment_type_definition
end type
type tabpage_dashboard from u_tabpage_configure_dashboard within u_tab_assessment_type_definition
end type
type tabpage_dashboard from u_tabpage_configure_dashboard within u_tab_assessment_type_definition
end type
end forward

global type u_tab_assessment_type_definition from u_tab_manager
integer width = 2587
integer height = 1548
long backcolor = 33538240
boolean raggedright = false
tabposition tabposition = tabsonbottom!
tabpage_info tabpage_info
tabpage_dashboard tabpage_dashboard
end type
global u_tab_assessment_type_definition u_tab_assessment_type_definition

on u_tab_assessment_type_definition.create
this.tabpage_info=create tabpage_info
this.tabpage_dashboard=create tabpage_dashboard
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_info
this.Control[iCurrent+2]=this.tabpage_dashboard
end on

on u_tab_assessment_type_definition.destroy
call super::destroy
destroy(this.tabpage_info)
destroy(this.tabpage_dashboard)
end on

type tabpage_info from u_tabpage_assessment_type_info within u_tab_assessment_type_definition
integer x = 18
integer y = 16
integer width = 2551
integer height = 1420
string text = "Definition"
end type

type tabpage_dashboard from u_tabpage_configure_dashboard within u_tab_assessment_type_definition
integer x = 18
integer y = 16
integer width = 2551
integer height = 1420
string text = "Dashboard"
string context_object = "Assessment"
end type

