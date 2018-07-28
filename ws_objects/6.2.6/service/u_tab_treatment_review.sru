HA$PBExportHeader$u_tab_treatment_review.sru
forward
global type u_tab_treatment_review from u_tab_manager
end type
type tabpage_dashboard from u_tabpage_patient_context_dashboard within u_tab_treatment_review
end type
type tabpage_dashboard from u_tabpage_patient_context_dashboard within u_tab_treatment_review
end type
type tabpage_documents from u_tabpage_documents within u_tab_treatment_review
end type
type tabpage_documents from u_tabpage_documents within u_tab_treatment_review
end type
type tabpage_followup from u_treatment_followups within u_tab_treatment_review
end type
type tabpage_followup from u_treatment_followups within u_tab_treatment_review
end type
type tabpage_assessments from u_treatment_assessments within u_tab_treatment_review
end type
type tabpage_assessments from u_treatment_assessments within u_tab_treatment_review
end type
type tabpage_workplan from u_treatment_workplans within u_tab_treatment_review
end type
type tabpage_workplan from u_treatment_workplans within u_tab_treatment_review
end type
type tabpage_attachments from u_tabpage_treatment_attachments within u_tab_treatment_review
end type
type tabpage_attachments from u_tabpage_treatment_attachments within u_tab_treatment_review
end type
type tabpage_billing from u_treatment_billing within u_tab_treatment_review
end type
type tabpage_billing from u_treatment_billing within u_tab_treatment_review
end type
type tabpage_properties from u_context_object_properties within u_tab_treatment_review
end type
type tabpage_properties from u_context_object_properties within u_tab_treatment_review
end type
end forward

global type u_tab_treatment_review from u_tab_manager
integer width = 3072
integer height = 1388
boolean raggedright = false
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
tabpage_dashboard tabpage_dashboard
tabpage_documents tabpage_documents
tabpage_followup tabpage_followup
tabpage_assessments tabpage_assessments
tabpage_workplan tabpage_workplan
tabpage_attachments tabpage_attachments
tabpage_billing tabpage_billing
tabpage_properties tabpage_properties
end type
global u_tab_treatment_review u_tab_treatment_review

on u_tab_treatment_review.create
this.tabpage_dashboard=create tabpage_dashboard
this.tabpage_documents=create tabpage_documents
this.tabpage_followup=create tabpage_followup
this.tabpage_assessments=create tabpage_assessments
this.tabpage_workplan=create tabpage_workplan
this.tabpage_attachments=create tabpage_attachments
this.tabpage_billing=create tabpage_billing
this.tabpage_properties=create tabpage_properties
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_dashboard
this.Control[iCurrent+2]=this.tabpage_documents
this.Control[iCurrent+3]=this.tabpage_followup
this.Control[iCurrent+4]=this.tabpage_assessments
this.Control[iCurrent+5]=this.tabpage_workplan
this.Control[iCurrent+6]=this.tabpage_attachments
this.Control[iCurrent+7]=this.tabpage_billing
this.Control[iCurrent+8]=this.tabpage_properties
end on

on u_tab_treatment_review.destroy
call super::destroy
destroy(this.tabpage_dashboard)
destroy(this.tabpage_documents)
destroy(this.tabpage_followup)
destroy(this.tabpage_assessments)
destroy(this.tabpage_workplan)
destroy(this.tabpage_attachments)
destroy(this.tabpage_billing)
destroy(this.tabpage_properties)
end on

type tabpage_dashboard from u_tabpage_patient_context_dashboard within u_tab_treatment_review
integer x = 18
integer y = 16
integer width = 3035
integer height = 1260
end type

type tabpage_documents from u_tabpage_documents within u_tab_treatment_review
integer x = 18
integer y = 16
integer width = 3035
integer height = 1260
string text = "Documents"
end type

type tabpage_followup from u_treatment_followups within u_tab_treatment_review
integer x = 18
integer y = 16
integer width = 3035
integer height = 1260
end type

type tabpage_assessments from u_treatment_assessments within u_tab_treatment_review
integer x = 18
integer y = 16
integer width = 3035
integer height = 1260
end type

type tabpage_workplan from u_treatment_workplans within u_tab_treatment_review
integer x = 18
integer y = 16
integer width = 3035
integer height = 1260
end type

type tabpage_attachments from u_tabpage_treatment_attachments within u_tab_treatment_review
integer x = 18
integer y = 16
integer width = 3035
integer height = 1260
end type

type tabpage_billing from u_treatment_billing within u_tab_treatment_review
integer x = 18
integer y = 16
integer width = 3035
integer height = 1260
end type

type tabpage_properties from u_context_object_properties within u_tab_treatment_review
integer x = 18
integer y = 16
integer width = 3035
integer height = 1260
end type

