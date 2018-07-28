HA$PBExportHeader$u_tab_encounter_review.sru
forward
global type u_tab_encounter_review from u_tab_manager
end type
type tabpage_overview from u_tabpage_patient_context_dashboard within u_tab_encounter_review
end type
type tabpage_overview from u_tabpage_patient_context_dashboard within u_tab_encounter_review
end type
type tabpage_1 from u_encounter_overview within u_tab_encounter_review
end type
type tabpage_1 from u_encounter_overview within u_tab_encounter_review
end type
type tabpage_documents from u_tabpage_documents within u_tab_encounter_review
end type
type tabpage_documents from u_tabpage_documents within u_tab_encounter_review
end type
type tabpage_2 from u_tabpage_encounter_attachments within u_tab_encounter_review
end type
type tabpage_2 from u_tabpage_encounter_attachments within u_tab_encounter_review
end type
type tabpage_3 from u_encounter_workplans within u_tab_encounter_review
end type
type tabpage_3 from u_encounter_workplans within u_tab_encounter_review
end type
type tabpage_4 from u_encounter_audit within u_tab_encounter_review
end type
type tabpage_4 from u_encounter_audit within u_tab_encounter_review
end type
type tabpage_5 from u_context_object_properties within u_tab_encounter_review
end type
type tabpage_5 from u_context_object_properties within u_tab_encounter_review
end type
end forward

global type u_tab_encounter_review from u_tab_manager
integer width = 3104
integer height = 1468
boolean raggedright = false
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
tabpage_overview tabpage_overview
tabpage_1 tabpage_1
tabpage_documents tabpage_documents
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
global u_tab_encounter_review u_tab_encounter_review

on u_tab_encounter_review.create
this.tabpage_overview=create tabpage_overview
this.tabpage_1=create tabpage_1
this.tabpage_documents=create tabpage_documents
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_overview
this.Control[iCurrent+2]=this.tabpage_1
this.Control[iCurrent+3]=this.tabpage_documents
this.Control[iCurrent+4]=this.tabpage_2
this.Control[iCurrent+5]=this.tabpage_3
this.Control[iCurrent+6]=this.tabpage_4
this.Control[iCurrent+7]=this.tabpage_5
end on

on u_tab_encounter_review.destroy
call super::destroy
destroy(this.tabpage_overview)
destroy(this.tabpage_1)
destroy(this.tabpage_documents)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

type tabpage_overview from u_tabpage_patient_context_dashboard within u_tab_encounter_review
integer x = 18
integer y = 16
integer width = 3067
integer height = 1340
string text = "Overview"
end type

type tabpage_1 from u_encounter_overview within u_tab_encounter_review
integer x = 18
integer y = 16
integer width = 3067
integer height = 1340
end type

type tabpage_documents from u_tabpage_documents within u_tab_encounter_review
integer x = 18
integer y = 16
integer width = 3067
integer height = 1340
string text = "Documents"
end type

type tabpage_2 from u_tabpage_encounter_attachments within u_tab_encounter_review
integer x = 18
integer y = 16
integer width = 3067
integer height = 1340
end type

type tabpage_3 from u_encounter_workplans within u_tab_encounter_review
integer x = 18
integer y = 16
integer width = 3067
integer height = 1340
end type

type tabpage_4 from u_encounter_audit within u_tab_encounter_review
integer x = 18
integer y = 16
integer width = 3067
integer height = 1340
end type

type tabpage_5 from u_context_object_properties within u_tab_encounter_review
integer x = 18
integer y = 16
integer width = 3067
integer height = 1340
end type

