$PBExportHeader$w_ext_observation_jmj_attachments.srw
forward
global type w_ext_observation_jmj_attachments from w_window_base
end type
type cb_cancel from commandbutton within w_ext_observation_jmj_attachments
end type
type tab_attachments from u_tab_attachments within w_ext_observation_jmj_attachments
end type
type tab_attachments from u_tab_attachments within w_ext_observation_jmj_attachments
end type
end forward

global type w_ext_observation_jmj_attachments from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_cancel cb_cancel
tab_attachments tab_attachments
end type
global w_ext_observation_jmj_attachments w_ext_observation_jmj_attachments

type variables
u_component_observation component


end variables

on w_ext_observation_jmj_attachments.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.tab_attachments=create tab_attachments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.tab_attachments
end on

on w_ext_observation_jmj_attachments.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.tab_attachments)
end on

event open;call super::open;
component = message.powerobjectparm

if not isnull(current_patient) then
	title = current_patient.id_line()
else
	title = "JMJ Attachment Files"
	tab_attachments.tabpage_patient_attachments.visible = false
end if

tab_attachments.initialize()


end event

type pb_epro_help from w_window_base`pb_epro_help within w_ext_observation_jmj_attachments
boolean visible = true
integer x = 2615
integer y = 1604
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_ext_observation_jmj_attachments
end type

type cb_cancel from commandbutton within w_ext_observation_jmj_attachments
integer x = 73
integer y = 1604
integer width = 681
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_external_observation_attachment lstr_attachment

setnull(lstr_attachment.attachment_type)

closewithreturn(parent, lstr_attachment)

end event

type tab_attachments from u_tab_attachments within w_ext_observation_jmj_attachments
integer width = 2930
integer height = 1544
boolean bringtotop = true
end type

event attachment_selected;call super::attachment_selected;closewithreturn(parent, pstr_attachment)

end event

