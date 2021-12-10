$PBExportHeader$u_tab_assessment_definition.sru
forward
global type u_tab_assessment_definition from u_tab_manager
end type
type tabpage_info from u_tabpage_assessment_info within u_tab_assessment_definition
end type
type tabpage_info from u_tabpage_assessment_info within u_tab_assessment_definition
end type
type tabpage_long_description from u_tabpage_assessment_long_description within u_tab_assessment_definition
end type
type tabpage_long_description from u_tabpage_assessment_long_description within u_tab_assessment_definition
end type
type tabpage_acuteness from u_tabpage_assessment_acuteness within u_tab_assessment_definition
end type
type tabpage_acuteness from u_tabpage_assessment_acuteness within u_tab_assessment_definition
end type
type tabpage_drugs from u_tabpage_assessment_drugs within u_tab_assessment_definition
end type
type tabpage_drugs from u_tabpage_assessment_drugs within u_tab_assessment_definition
end type
type tabpage_health_maintenance from u_tabpage_assessment_health_maintenance within u_tab_assessment_definition
end type
type tabpage_health_maintenance from u_tabpage_assessment_health_maintenance within u_tab_assessment_definition
end type
end forward

global type u_tab_assessment_definition from u_tab_manager
integer width = 2587
integer height = 1548
long backcolor = 7191717
boolean raggedright = false
tabposition tabposition = tabsonbottom!
tabpage_info tabpage_info
tabpage_long_description tabpage_long_description
tabpage_acuteness tabpage_acuteness
tabpage_drugs tabpage_drugs
tabpage_health_maintenance tabpage_health_maintenance
end type
global u_tab_assessment_definition u_tab_assessment_definition

on u_tab_assessment_definition.create
this.tabpage_info=create tabpage_info
this.tabpage_long_description=create tabpage_long_description
this.tabpage_acuteness=create tabpage_acuteness
this.tabpage_drugs=create tabpage_drugs
this.tabpage_health_maintenance=create tabpage_health_maintenance
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_info
this.Control[iCurrent+2]=this.tabpage_long_description
this.Control[iCurrent+3]=this.tabpage_acuteness
this.Control[iCurrent+4]=this.tabpage_drugs
this.Control[iCurrent+5]=this.tabpage_health_maintenance
end on

on u_tab_assessment_definition.destroy
call super::destroy
destroy(this.tabpage_info)
destroy(this.tabpage_long_description)
destroy(this.tabpage_acuteness)
destroy(this.tabpage_drugs)
destroy(this.tabpage_health_maintenance)
end on

type tabpage_info from u_tabpage_assessment_info within u_tab_assessment_definition
integer x = 18
integer y = 16
integer width = 2551
integer height = 1420
string text = "Definition"
end type

type tabpage_long_description from u_tabpage_assessment_long_description within u_tab_assessment_definition
integer x = 18
integer y = 16
integer width = 2551
integer height = 1420
string text = "Long Description"
end type

type tabpage_acuteness from u_tabpage_assessment_acuteness within u_tab_assessment_definition
integer x = 18
integer y = 16
integer width = 2551
integer height = 1420
string text = "Acuteness/Auto Close"
end type

type tabpage_drugs from u_tabpage_assessment_drugs within u_tab_assessment_definition
integer x = 18
integer y = 16
integer width = 2551
integer height = 1420
string text = "Reactive Drugs"
end type

type tabpage_health_maintenance from u_tabpage_assessment_health_maintenance within u_tab_assessment_definition
boolean visible = false
integer x = 18
integer y = 16
integer width = 2551
integer height = 1420
string text = "Health Maintenance"
end type

