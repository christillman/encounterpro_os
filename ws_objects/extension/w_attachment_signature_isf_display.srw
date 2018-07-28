HA$PBExportHeader$w_attachment_signature_isf_display.srw
forward
global type w_attachment_signature_isf_display from w_window_base
end type
type pb_done from u_picture_button within w_attachment_signature_isf_display
end type
type st_title from statictext within w_attachment_signature_isf_display
end type
type ip_ink from u_inkpicture within w_attachment_signature_isf_display
end type
end forward

global type w_attachment_signature_isf_display from w_window_base
integer width = 2935
integer height = 1840
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
st_title st_title
ip_ink ip_ink
end type
global w_attachment_signature_isf_display w_attachment_signature_isf_display

type variables
u_component_attachment attachment
end variables

on w_attachment_signature_isf_display.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.st_title=create st_title
this.ip_ink=create ip_ink
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.ip_ink
end on

on w_attachment_signature_isf_display.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.st_title)
destroy(this.ip_ink)
end on

event open;call super::open;string ls_title,ls_file

attachment = message.powerobjectparm

ls_title = "Signature by "
ls_title += attachment.originator.user_full_name
ls_title += " on " + string(attachment.attachment_date, "[shortdate] [time]")
st_title.text = ls_title

postevent("post_open")
end event

event post_open;long ll_sts
blob lbl_attachment


// get the attachment
ll_sts = attachment.get_attachment_blob(lbl_attachment)
If ll_sts <= 0 Then
	log.log(this,"xx_render()","failed to get signature attachment from database / file",3)
	pb_done.event clicked()
	return
Else
	ip_ink.loadink(lbl_attachment)
End If


end event

type pb_epro_help from w_window_base`pb_epro_help within w_attachment_signature_isf_display
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_attachment_signature_isf_display
end type

type pb_done from u_picture_button within w_attachment_signature_isf_display
integer x = 2569
integer y = 1552
integer taborder = 10
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;Close(parent)
end event

type st_title from statictext within w_attachment_signature_isf_display
integer width = 2921
integer height = 248
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type ip_ink from u_inkpicture within w_attachment_signature_isf_display
integer x = 590
integer y = 844
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
end type

