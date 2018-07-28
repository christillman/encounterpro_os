HA$PBExportHeader$u_tab_encounter_type_definition.sru
forward
global type u_tab_encounter_type_definition from u_tab_manager
end type
type tabpage_properties from u_tabpage_encounter_type_properties within u_tab_encounter_type_definition
end type
type tabpage_properties from u_tabpage_encounter_type_properties within u_tab_encounter_type_definition
end type
type tabpage_workplans from u_tabpage_encounter_type_workplans within u_tab_encounter_type_definition
end type
type tabpage_workplans from u_tabpage_encounter_type_workplans within u_tab_encounter_type_definition
end type
type tabpage_dashboard from u_tabpage_configure_dashboard within u_tab_encounter_type_definition
end type
type tabpage_dashboard from u_tabpage_configure_dashboard within u_tab_encounter_type_definition
end type
end forward

global type u_tab_encounter_type_definition from u_tab_manager
integer width = 2587
integer height = 1548
long backcolor = 33538240
boolean raggedright = false
tabposition tabposition = tabsonbottom!
tabpage_properties tabpage_properties
tabpage_workplans tabpage_workplans
tabpage_dashboard tabpage_dashboard
end type
global u_tab_encounter_type_definition u_tab_encounter_type_definition

on u_tab_encounter_type_definition.create
this.tabpage_properties=create tabpage_properties
this.tabpage_workplans=create tabpage_workplans
this.tabpage_dashboard=create tabpage_dashboard
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_properties
this.Control[iCurrent+2]=this.tabpage_workplans
this.Control[iCurrent+3]=this.tabpage_dashboard
end on

on u_tab_encounter_type_definition.destroy
call super::destroy
destroy(this.tabpage_properties)
destroy(this.tabpage_workplans)
destroy(this.tabpage_dashboard)
end on

type tabpage_properties from u_tabpage_encounter_type_properties within u_tab_encounter_type_definition
integer x = 18
integer y = 16
integer width = 2551
integer height = 1420
end type

type tabpage_workplans from u_tabpage_encounter_type_workplans within u_tab_encounter_type_definition
integer x = 18
integer y = 16
integer width = 2551
integer height = 1420
end type

type tabpage_dashboard from u_tabpage_configure_dashboard within u_tab_encounter_type_definition
integer x = 18
integer y = 16
integer width = 2551
integer height = 1420
string text = "Dashboard"
string context_object = "Assessment"
end type

