HA$PBExportHeader$u_tab_report_config.sru
forward
global type u_tab_report_config from u_tab_manager
end type
type tabpage_patient from u_tabpage_report_config within u_tab_report_config
end type
type tabpage_patient from u_tabpage_report_config within u_tab_report_config
end type
type tabpage_treatment from u_tabpage_report_config within u_tab_report_config
end type
type tabpage_treatment from u_tabpage_report_config within u_tab_report_config
end type
type tabpage_assessment from u_tabpage_report_config within u_tab_report_config
end type
type tabpage_assessment from u_tabpage_report_config within u_tab_report_config
end type
type tabpage_encounter from u_tabpage_report_config within u_tab_report_config
end type
type tabpage_encounter from u_tabpage_report_config within u_tab_report_config
end type
type tabpage_general from u_tabpage_report_config within u_tab_report_config
end type
type tabpage_general from u_tabpage_report_config within u_tab_report_config
end type
end forward

global type u_tab_report_config from u_tab_manager
integer width = 2368
integer height = 1376
long backcolor = 33538240
boolean boldselectedtext = true
tabpage_patient tabpage_patient
tabpage_treatment tabpage_treatment
tabpage_assessment tabpage_assessment
tabpage_encounter tabpage_encounter
tabpage_general tabpage_general
end type
global u_tab_report_config u_tab_report_config

on u_tab_report_config.create
this.tabpage_patient=create tabpage_patient
this.tabpage_treatment=create tabpage_treatment
this.tabpage_assessment=create tabpage_assessment
this.tabpage_encounter=create tabpage_encounter
this.tabpage_general=create tabpage_general
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_patient
this.Control[iCurrent+2]=this.tabpage_treatment
this.Control[iCurrent+3]=this.tabpage_assessment
this.Control[iCurrent+4]=this.tabpage_encounter
this.Control[iCurrent+5]=this.tabpage_general
end on

on u_tab_report_config.destroy
call super::destroy
destroy(this.tabpage_patient)
destroy(this.tabpage_treatment)
destroy(this.tabpage_assessment)
destroy(this.tabpage_encounter)
destroy(this.tabpage_general)
end on

type tabpage_patient from u_tabpage_report_config within u_tab_report_config
string tag = "Patient"
integer x = 18
integer y = 112
integer width = 2331
integer height = 1248
string text = "Patient"
end type

type tabpage_treatment from u_tabpage_report_config within u_tab_report_config
string tag = "treatment"
integer x = 18
integer y = 112
integer width = 2331
integer height = 1248
string text = "Treatment"
end type

type tabpage_assessment from u_tabpage_report_config within u_tab_report_config
string tag = "assessment"
integer x = 18
integer y = 112
integer width = 2331
integer height = 1248
string text = "Assessment"
end type

type tabpage_encounter from u_tabpage_report_config within u_tab_report_config
string tag = "encounter"
integer x = 18
integer y = 112
integer width = 2331
integer height = 1248
string text = "Encounter"
end type

type tabpage_general from u_tabpage_report_config within u_tab_report_config
string tag = "general"
integer x = 18
integer y = 112
integer width = 2331
integer height = 1248
string text = "General"
end type

