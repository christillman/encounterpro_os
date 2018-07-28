HA$PBExportHeader$w_doc_link.srw
forward
global type w_doc_link from w_window_base
end type
type st_1 from statictext within w_doc_link
end type
type st_2 from statictext within w_doc_link
end type
type st_3 from statictext within w_doc_link
end type
type sle_url from singlelineedit within w_doc_link
end type
type cb_attach from commandbutton within w_doc_link
end type
type cb_cancel from commandbutton within w_doc_link
end type
type st_4 from statictext within w_doc_link
end type
type sle_description from singlelineedit within w_doc_link
end type
end forward

global type w_doc_link from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_1 st_1
st_2 st_2
st_3 st_3
sle_url sle_url
cb_attach cb_attach
cb_cancel cb_cancel
st_4 st_4
sle_description sle_description
end type
global w_doc_link w_doc_link

type variables
u_component_document document

end variables

on w_doc_link.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.sle_url=create sle_url
this.cb_attach=create cb_attach
this.cb_cancel=create cb_cancel
this.st_4=create st_4
this.sle_description=create sle_description
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.sle_url
this.Control[iCurrent+5]=this.cb_attach
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.sle_description
end on

on w_doc_link.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_url)
destroy(this.cb_attach)
destroy(this.cb_cancel)
destroy(this.st_4)
destroy(this.sle_description)
end on

event open;call super::open;
document = message.powerobjectparm

if not isnull(current_patient) then
	title = current_patient.id_line()
else
	title = "Attach Link"
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_doc_link
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_doc_link
end type

type st_1 from statictext within w_doc_link
integer width = 2930
integer height = 116
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Attach LINK"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_doc_link
integer x = 457
integer y = 412
integer width = 2002
integer height = 236
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Warning:  This operation only attaches a link to the patient~'s chart.  The content of the Link is not in the EncounterPRO database, not under the control of EncounterPRO, and may change without notice."
boolean focusrectangle = false
end type

type st_3 from statictext within w_doc_link
integer x = 64
integer y = 792
integer width = 160
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "URL:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_url from singlelineedit within w_doc_link
integer x = 242
integer y = 772
integer width = 2565
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_attach from commandbutton within w_doc_link
integer x = 2478
integer y = 1608
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Attach"
boolean default = true
end type

event clicked;blob lbl_rtf_file
integer li_sts
string ls_temp_file


if trim(sle_url.text) = "" then
	openwithparm(w_pop_message, "Please enter a URL")
	return
end if

if trim(sle_description.text) = "" then
	openwithparm(w_pop_message, "Please enter a description")
	return
end if

document.observation_count = 1
document.observations[1].result_count = 0
document.observations[1].attachment_list.attachment_count = 1
document.observations[1].attachment_list.attachments[1].attachment_type = "LINK"
document.observations[1].attachment_list.attachments[1].extension = "url"
document.observations[1].attachment_list.attachments[1].attachment_comment_title = sle_description.text
document.observations[1].attachment_list.attachments[1].attachment = blob(sle_url.text)

document.observations[1].attachment_list.attachments[1].attached_by_user_id = current_user.user_id

closewithreturn(parent, "OK")

end event

type cb_cancel from commandbutton within w_doc_link
integer x = 27
integer y = 1608
integer width = 402
integer height = 112
integer taborder = 40
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

event clicked;closewithreturn(parent, "CANCEL")

end event

type st_4 from statictext within w_doc_link
integer x = 41
integer y = 968
integer width = 357
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_description from singlelineedit within w_doc_link
integer x = 439
integer y = 948
integer width = 2194
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

