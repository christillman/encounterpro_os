$PBExportHeader$u_tab_assessment_review.sru
forward
global type u_tab_assessment_review from u_tab_manager
end type
type tabpage_1 from u_tabpage_assessment_overview within u_tab_assessment_review
end type
type tabpage_1 from u_tabpage_assessment_overview within u_tab_assessment_review
end type
type tabpage_documents from u_tabpage_documents within u_tab_assessment_review
end type
type tabpage_documents from u_tabpage_documents within u_tab_assessment_review
end type
type tabpage_2 from u_tabpage_assessment_attachments within u_tab_assessment_review
end type
type tabpage_2 from u_tabpage_assessment_attachments within u_tab_assessment_review
end type
type tabpage_3 from u_context_object_properties within u_tab_assessment_review
end type
type tabpage_3 from u_context_object_properties within u_tab_assessment_review
end type
end forward

global type u_tab_assessment_review from u_tab_manager
integer width = 3163
integer height = 1644
boolean raggedright = false
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
tabpage_1 tabpage_1
tabpage_documents tabpage_documents
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
global u_tab_assessment_review u_tab_assessment_review

on u_tab_assessment_review.create
this.tabpage_1=create tabpage_1
this.tabpage_documents=create tabpage_documents
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_1
this.Control[iCurrent+2]=this.tabpage_documents
this.Control[iCurrent+3]=this.tabpage_2
this.Control[iCurrent+4]=this.tabpage_3
end on

on u_tab_assessment_review.destroy
call super::destroy
destroy(this.tabpage_1)
destroy(this.tabpage_documents)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from u_tabpage_assessment_overview within u_tab_assessment_review
integer x = 18
integer y = 16
integer width = 3127
integer height = 1516
end type

type tabpage_documents from u_tabpage_documents within u_tab_assessment_review
integer x = 18
integer y = 16
integer width = 3127
integer height = 1516
string text = "Documents"
end type

type tabpage_2 from u_tabpage_assessment_attachments within u_tab_assessment_review
integer x = 18
integer y = 16
integer width = 3127
end type

type tabpage_3 from u_context_object_properties within u_tab_assessment_review
integer x = 18
integer y = 16
integer width = 3127
integer height = 1516
end type

