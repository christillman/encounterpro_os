$PBExportHeader$u_tab_treatment_type.sru
forward
global type u_tab_treatment_type from u_tab_manager
end type
type tabpage_properties from u_tabpage_treatment_type_properties within u_tab_treatment_type
end type
type tabpage_properties from u_tabpage_treatment_type_properties within u_tab_treatment_type
end type
type tabpage_services from u_tabpage_treatment_type_services within u_tab_treatment_type
end type
type tabpage_services from u_tabpage_treatment_type_services within u_tab_treatment_type
end type
type tabpage_modes from u_tabpage_treatment_type_modes within u_tab_treatment_type
end type
type tabpage_modes from u_tabpage_treatment_type_modes within u_tab_treatment_type
end type
type tabpage_default_modes from u_tabpage_treatment_type_default_modes within u_tab_treatment_type
end type
type tabpage_default_modes from u_tabpage_treatment_type_default_modes within u_tab_treatment_type
end type
type tabpage_default_workplan from u_tabpage_treatment_type_default_wp within u_tab_treatment_type
end type
type tabpage_default_workplan from u_tabpage_treatment_type_default_wp within u_tab_treatment_type
end type
end forward

global type u_tab_treatment_type from u_tab_manager
integer width = 3058
integer height = 1384
long backcolor = COLOR_BACKGROUND
boolean boldselectedtext = true
boolean createondemand = false
tabposition tabposition = tabsonbottom!
tabpage_properties tabpage_properties
tabpage_services tabpage_services
tabpage_modes tabpage_modes
tabpage_default_modes tabpage_default_modes
tabpage_default_workplan tabpage_default_workplan
end type
global u_tab_treatment_type u_tab_treatment_type

on u_tab_treatment_type.create
this.tabpage_properties=create tabpage_properties
this.tabpage_services=create tabpage_services
this.tabpage_modes=create tabpage_modes
this.tabpage_default_modes=create tabpage_default_modes
this.tabpage_default_workplan=create tabpage_default_workplan
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_properties
this.Control[iCurrent+2]=this.tabpage_services
this.Control[iCurrent+3]=this.tabpage_modes
this.Control[iCurrent+4]=this.tabpage_default_modes
this.Control[iCurrent+5]=this.tabpage_default_workplan
end on

on u_tab_treatment_type.destroy
call super::destroy
destroy(this.tabpage_properties)
destroy(this.tabpage_services)
destroy(this.tabpage_modes)
destroy(this.tabpage_default_modes)
destroy(this.tabpage_default_workplan)
end on

type tabpage_properties from u_tabpage_treatment_type_properties within u_tab_treatment_type
integer x = 18
integer y = 16
integer width = 3022
integer height = 1256
string text = "Properties"
end type

type tabpage_services from u_tabpage_treatment_type_services within u_tab_treatment_type
integer x = 18
integer y = 16
integer width = 3022
integer height = 1256
string text = "Services"
end type

type tabpage_modes from u_tabpage_treatment_type_modes within u_tab_treatment_type
integer x = 18
integer y = 16
integer width = 3022
integer height = 1256
string text = "Treatment Modes"
end type

type tabpage_default_modes from u_tabpage_treatment_type_default_modes within u_tab_treatment_type
integer x = 18
integer y = 16
integer width = 3022
integer height = 1256
string text = "Default Treatment Modes"
end type

type tabpage_default_workplan from u_tabpage_treatment_type_default_wp within u_tab_treatment_type
integer x = 18
integer y = 16
integer width = 3022
integer height = 1256
string text = "Default Workplan (v4)"
end type

