$PBExportHeader$w_attachment_edit_attachment_text.srw
forward
global type w_attachment_edit_attachment_text from w_window_base
end type
type st_title from statictext within w_attachment_edit_attachment_text
end type
type st_transcription_title from statictext within w_attachment_edit_attachment_text
end type
type mle_text from multilineedit within w_attachment_edit_attachment_text
end type
type st_display_only from statictext within w_attachment_edit_attachment_text
end type
type cb_history from commandbutton within w_attachment_edit_attachment_text
end type
type st_who from statictext within w_attachment_edit_attachment_text
end type
type cb_cancel from commandbutton within w_attachment_edit_attachment_text
end type
type cb_done from commandbutton within w_attachment_edit_attachment_text
end type
end forward

global type w_attachment_edit_attachment_text from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
st_transcription_title st_transcription_title
mle_text mle_text
st_display_only st_display_only
cb_history cb_history
st_who st_who
cb_cancel cb_cancel
cb_done cb_done
end type
global w_attachment_edit_attachment_text w_attachment_edit_attachment_text

type variables
u_component_attachment attachment

boolean display_only
boolean updated


end variables

on w_attachment_edit_attachment_text.create
int iCurrent
call super::create
this.st_title=create st_title
this.st_transcription_title=create st_transcription_title
this.mle_text=create mle_text
this.st_display_only=create st_display_only
this.cb_history=create cb_history
this.st_who=create st_who
this.cb_cancel=create cb_cancel
this.cb_done=create cb_done
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_transcription_title
this.Control[iCurrent+3]=this.mle_text
this.Control[iCurrent+4]=this.st_display_only
this.Control[iCurrent+5]=this.cb_history
this.Control[iCurrent+6]=this.st_who
this.Control[iCurrent+7]=this.cb_cancel
this.Control[iCurrent+8]=this.cb_done
end on

on w_attachment_edit_attachment_text.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_transcription_title)
destroy(this.mle_text)
destroy(this.st_display_only)
destroy(this.cb_history)
destroy(this.st_who)
destroy(this.cb_cancel)
destroy(this.cb_done)
end on

event open;call super::open;integer li_count
str_popup popup
str_popup_return popup_return
integer li_sts
string ls_title
str_p_attachment_progress lstra_progress[]

attachment = message.powerobjectparm

ls_title = "Attachment created by "
ls_title += attachment.originator.user_full_name
ls_title += " on " + string(attachment.attachment_date, "[shortdate] [time]")
st_title.text = ls_title

// mark 10/14/02 We don't have a "TRANSCRIBE" privilege
//if (current_user.user_id = attachment.originator.user_id) or current_user.check_privilege("TRANSCRIBE") then
	display_only = false
	mle_text.displayonly = false
	mle_text.backcolor = color_white
//else
//	display_only = true
//	mle_text.displayonly = true
//	mle_text.backcolor = color_object
//end if	

if isnull(attachment.attachment_text) then
	st_who.text = "No previous transcriptions"
	mle_text.text = ""
else
	mle_text.text = attachment.attachment_text
	st_who.text = string(attachment.created, "[shortdate] [time]")
	st_who.text += "  " + user_list.user_full_name(attachment.attached_by)
end if

li_count = attachment.get_attachment_progress("progress_type='TEXT'", lstra_progress)

if li_count <= 1 then
	cb_history.visible = false
else
	cb_history.visible = true
end if


// Hard code display_only as false for now
display_only = false

if display_only then
	display_only = true
	st_display_only.visible = true
	mle_text.displayonly = true
	mle_text.backcolor = color_object
else
	display_only = false
	st_display_only.visible = false
	mle_text.displayonly = false
	mle_text.backcolor = color_white
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_attachment_edit_attachment_text
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_attachment_edit_attachment_text
end type

type st_title from statictext within w_attachment_edit_attachment_text
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
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_transcription_title from statictext within w_attachment_edit_attachment_text
integer x = 293
integer y = 296
integer width = 421
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Transcription"
boolean focusrectangle = false
end type

type mle_text from multilineedit within w_attachment_edit_attachment_text
event editkeydown pbm_keydown
integer x = 265
integer y = 388
integer width = 2341
integer height = 1188
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

event editkeydown;updated = true
cb_cancel.visible = true
cb_done.text = "Update Transcription"

end event

event modified;updated = true
cb_cancel.visible = true
cb_done.text = "Update Transcription"

end event

type st_display_only from statictext within w_attachment_edit_attachment_text
integer x = 2272
integer y = 296
integer width = 352
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Display Only"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_history from commandbutton within w_attachment_edit_attachment_text
integer x = 96
integer y = 1660
integer width = 654
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Transcription History"
end type

event clicked;openwithparm(w_transcription_history, attachment)

end event

type st_who from statictext within w_attachment_edit_attachment_text
integer x = 718
integer y = 296
integer width = 1472
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_attachment_edit_attachment_text
boolean visible = false
integer x = 1216
integer y = 1660
integer width = 718
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Discard Changes"
end type

event clicked;str_popup_return popup_return

if updated and not display_only then
	openwithparm(w_pop_yes_no, "The attachment has been updated.  Are you sure you wish to exit without saving the updates?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then close(parent)
	return
end if

close(parent)


end event

type cb_done from commandbutton within w_attachment_edit_attachment_text
integer x = 2075
integer y = 1660
integer width = 763
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

event clicked;str_popup_return popup_return
integer li_sts

// if display only or not updated then just return
if display_only or not updated then
	close(parent)
	return
end if

li_sts = attachment.add_progress("TEXT", trim(mle_text.text))
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error saving transcription")
	return
end if

close(parent)

end event

