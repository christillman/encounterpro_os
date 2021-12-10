$PBExportHeader$u_tab_attachments.sru
forward
global type u_tab_attachments from u_tab_manager
end type
type tabpage_patient_attachments from u_tabpage_attachments_patient within u_tab_attachments
end type
type tabpage_patient_attachments from u_tabpage_attachments_patient within u_tab_attachments
end type
type tabpage_to_be_posted from u_tabpage_attachments_to_be_posted within u_tab_attachments
end type
type tabpage_to_be_posted from u_tabpage_attachments_to_be_posted within u_tab_attachments
end type
end forward

global type u_tab_attachments from u_tab_manager
integer width = 2277
integer height = 1312
long backcolor = 7191717
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
tabpage_patient_attachments tabpage_patient_attachments
tabpage_to_be_posted tabpage_to_be_posted
event attachment_selected ( str_external_observation_attachment pstr_attachment )
end type
global u_tab_attachments u_tab_attachments

on u_tab_attachments.create
this.tabpage_patient_attachments=create tabpage_patient_attachments
this.tabpage_to_be_posted=create tabpage_to_be_posted
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_patient_attachments
this.Control[iCurrent+2]=this.tabpage_to_be_posted
end on

on u_tab_attachments.destroy
call super::destroy
destroy(this.tabpage_patient_attachments)
destroy(this.tabpage_to_be_posted)
end on

type tabpage_patient_attachments from u_tabpage_attachments_patient within u_tab_attachments
integer x = 18
integer y = 16
integer width = 2240
integer height = 1184
string text = "Patient Attachments"
end type

type tabpage_to_be_posted from u_tabpage_attachments_to_be_posted within u_tab_attachments
integer x = 18
integer y = 16
integer width = 2240
integer height = 1184
string text = "To Be Posted"
end type

