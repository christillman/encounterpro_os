$PBExportHeader$w_attachment_review.srw
forward
global type w_attachment_review from w_window_base
end type
type st_title from statictext within w_attachment_review
end type
type st_transcription_title from statictext within w_attachment_review
end type
type cb_history from commandbutton within w_attachment_review
end type
type cb_done from commandbutton within w_attachment_review
end type
type mle_text from multilineedit within w_attachment_review
end type
type st_1 from statictext within w_attachment_review
end type
type cb_open_attachment from commandbutton within w_attachment_review
end type
type cb_properties from commandbutton within w_attachment_review
end type
type cb_attachment_object from commandbutton within w_attachment_review
end type
type uo_attachment from u_picture_display within w_attachment_review
end type
type st_thumbnail_title from statictext within w_attachment_review
end type
type cb_transcribe from commandbutton within w_attachment_review
end type
end forward

global type w_attachment_review from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
st_title st_title
st_transcription_title st_transcription_title
cb_history cb_history
cb_done cb_done
mle_text mle_text
st_1 st_1
cb_open_attachment cb_open_attachment
cb_properties cb_properties
cb_attachment_object cb_attachment_object
uo_attachment uo_attachment
st_thumbnail_title st_thumbnail_title
cb_transcribe cb_transcribe
end type
global w_attachment_review w_attachment_review

type variables
u_component_attachment attachment
string display_file

ulong process_id = 0
boolean my_process

end variables

forward prototypes
public subroutine show_attachment ()
end prototypes

public subroutine show_attachment ();integer li_count
string ls_title
str_p_attachment_progress lstra_progress[]

if len(attachment.attachment_tag) > 0 then
	ls_title = attachment.attachment_tag + "~r~n"
else
	ls_title = ""
end if
ls_title += "Attached by "
ls_title += attachment.originator.user_full_name
ls_title += " on " + string(attachment.attachment_date, "[shortdate] [time]")
st_title.text = ls_title


if isnull(attachment.attachment_text) then
	mle_text.text = "< No Transcription >"
else
	mle_text.text = attachment.attachment_text
end if

li_count = attachment.get_attachment_progress("progress_type='TEXT'", lstra_progress)

if li_count <= 0 then
	cb_history.enabled = false
else
	cb_history.enabled = true
end if

display_file = attachment.get_attachment()
uo_attachment.display_picture(display_file)

return

end subroutine

on w_attachment_review.create
int iCurrent
call super::create
this.st_title=create st_title
this.st_transcription_title=create st_transcription_title
this.cb_history=create cb_history
this.cb_done=create cb_done
this.mle_text=create mle_text
this.st_1=create st_1
this.cb_open_attachment=create cb_open_attachment
this.cb_properties=create cb_properties
this.cb_attachment_object=create cb_attachment_object
this.uo_attachment=create uo_attachment
this.st_thumbnail_title=create st_thumbnail_title
this.cb_transcribe=create cb_transcribe
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_transcription_title
this.Control[iCurrent+3]=this.cb_history
this.Control[iCurrent+4]=this.cb_done
this.Control[iCurrent+5]=this.mle_text
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cb_open_attachment
this.Control[iCurrent+8]=this.cb_properties
this.Control[iCurrent+9]=this.cb_attachment_object
this.Control[iCurrent+10]=this.uo_attachment
this.Control[iCurrent+11]=this.st_thumbnail_title
this.Control[iCurrent+12]=this.cb_transcribe
end on

on w_attachment_review.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_transcription_title)
destroy(this.cb_history)
destroy(this.cb_done)
destroy(this.mle_text)
destroy(this.st_1)
destroy(this.cb_open_attachment)
destroy(this.cb_properties)
destroy(this.cb_attachment_object)
destroy(this.uo_attachment)
destroy(this.st_thumbnail_title)
destroy(this.cb_transcribe)
end on

event open;call super::open;integer li_count
str_popup popup
str_popup_return popup_return
integer li_sts
string ls_title
str_p_attachment_progress lstra_progress[]
long ll_menu_id
string ls_open_command

attachment = message.powerobjectparm

if isnull(current_patient) then
	title = current_patient.id_line()
else
	title = "Transcribe Attachment"
end if

attachment.get_attribute("menu_id", ll_menu_id)
if not isnull(ll_menu_id) then
	max_buttons = 3
	paint_menu(ll_menu_id)
end if

uo_attachment.initialize()

show_attachment()

this.event POST post_open(0,0)

end event

event post_open;call super::post_open;integer li_sts
string ls_temp

process_id = 0

ls_temp = attachment.get_attribute("open_attachment_process_id")
if isnumber(ls_temp) then
	process_id = longlong(ls_temp)
	my_process = false
end if

if isnull(process_id) or process_id = 0 then
	li_sts = attachment.open_attachment("Open", false, process_id)
	if li_sts > 0 and process_id > 0 then
		my_process = true
	else
		my_process = false
	end if
end if

return

end event

type pb_epro_help from w_window_base`pb_epro_help within w_attachment_review
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_attachment_review
end type

type st_title from statictext within w_attachment_review
integer width = 2921
integer height = 288
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_transcription_title from statictext within w_attachment_review
integer x = 1115
integer y = 296
integer width = 626
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Current Transcription"
boolean focusrectangle = false
end type

type cb_history from commandbutton within w_attachment_review
integer x = 59
integer y = 1592
integer width = 613
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Transcription History"
end type

event clicked;openwithparm(w_transcription_history, attachment)

end event

type cb_done from commandbutton within w_attachment_review
integer x = 2345
integer y = 1592
integer width = 498
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;
close(parent)

end event

type mle_text from multilineedit within w_attachment_review
event editkeydown pbm_keydown
integer x = 1106
integer y = 372
integer width = 1678
integer height = 840
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_attachment_review
integer x = 251
integer y = 1400
integer width = 1993
integer height = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "The attachment should already be open in another window.  If it~'s not, click here:"
boolean focusrectangle = false
end type

type cb_open_attachment from commandbutton within w_attachment_review
integer x = 2245
integer y = 1384
integer width = 498
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Open Attachment"
end type

event clicked;integer li_sts


// Open the attachment and remember the process_id
li_sts = attachment.open_attachment("Open", false, process_id)
if li_sts > 0 and process_id > 0 then
	my_process = true
else
	my_process = false
end if

end event

type cb_properties from commandbutton within w_attachment_review
integer x = 731
integer y = 1592
integer width = 663
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Attachment Properties"
end type

event clicked;openwithparm(w_attachment_properties, attachment, f_active_window())

end event

type cb_attachment_object from commandbutton within w_attachment_review
integer x = 1454
integer y = 1592
integer width = 663
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Attachment Object"
end type

event clicked;string ls_service
str_attributes lstr_attributes
integer li_sts


f_attribute_add_attribute(lstr_attributes, "context_object", attachment.context_object)
f_attribute_add_attribute(lstr_attributes, "object_key", string(attachment.object_key))

ls_service = f_default_context_object_review_service(attachment.context_object)
service_list.do_service(ls_service, lstr_attributes)




end event

type uo_attachment from u_picture_display within w_attachment_review
event destroy ( )
integer x = 133
integer y = 372
integer width = 859
integer height = 840
integer taborder = 50
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
end type

on uo_attachment.destroy
call u_picture_display::destroy
end on

type st_thumbnail_title from statictext within w_attachment_review
integer x = 133
integer y = 296
integer width = 626
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Thumbnail"
boolean focusrectangle = false
end type

type cb_transcribe from commandbutton within w_attachment_review
integer x = 2350
integer y = 1228
integer width = 434
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Transcribe"
end type

event clicked;attachment.transcribe()
show_attachment()

end event

