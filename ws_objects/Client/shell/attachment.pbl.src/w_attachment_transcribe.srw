$PBExportHeader$w_attachment_transcribe.srw
forward
global type w_attachment_transcribe from w_window_base
end type
type st_title from statictext within w_attachment_transcribe
end type
type st_transcription_title from statictext within w_attachment_transcribe
end type
type st_display_only from statictext within w_attachment_transcribe
end type
type cb_history from commandbutton within w_attachment_transcribe
end type
type st_who from statictext within w_attachment_transcribe
end type
type cb_cancel from commandbutton within w_attachment_transcribe
end type
type cb_done from commandbutton within w_attachment_transcribe
end type
type mle_text from multilineedit within w_attachment_transcribe
end type
type st_1 from statictext within w_attachment_transcribe
end type
type cb_open_attachment from commandbutton within w_attachment_transcribe
end type
type cb_properties from commandbutton within w_attachment_transcribe
end type
type cb_attachment_object from commandbutton within w_attachment_transcribe
end type
end forward

global type w_attachment_transcribe from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
st_title st_title
st_transcription_title st_transcription_title
st_display_only st_display_only
cb_history cb_history
st_who st_who
cb_cancel cb_cancel
cb_done cb_done
mle_text mle_text
st_1 st_1
cb_open_attachment cb_open_attachment
cb_properties cb_properties
cb_attachment_object cb_attachment_object
end type
global w_attachment_transcribe w_attachment_transcribe

type variables
u_component_attachment attachment

boolean display_only
boolean updated

ulong process_id
boolean my_process
end variables

on w_attachment_transcribe.create
int iCurrent
call super::create
this.st_title=create st_title
this.st_transcription_title=create st_transcription_title
this.st_display_only=create st_display_only
this.cb_history=create cb_history
this.st_who=create st_who
this.cb_cancel=create cb_cancel
this.cb_done=create cb_done
this.mle_text=create mle_text
this.st_1=create st_1
this.cb_open_attachment=create cb_open_attachment
this.cb_properties=create cb_properties
this.cb_attachment_object=create cb_attachment_object
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_transcription_title
this.Control[iCurrent+3]=this.st_display_only
this.Control[iCurrent+4]=this.cb_history
this.Control[iCurrent+5]=this.st_who
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_done
this.Control[iCurrent+8]=this.mle_text
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.cb_open_attachment
this.Control[iCurrent+11]=this.cb_properties
this.Control[iCurrent+12]=this.cb_attachment_object
end on

on w_attachment_transcribe.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_transcription_title)
destroy(this.st_display_only)
destroy(this.cb_history)
destroy(this.st_who)
destroy(this.cb_cancel)
destroy(this.cb_done)
destroy(this.mle_text)
destroy(this.st_1)
destroy(this.cb_open_attachment)
destroy(this.cb_properties)
destroy(this.cb_attachment_object)
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

if len(attachment.attachment_tag) > 0 then
	ls_title = attachment.attachment_tag + "~r~n"
else
	ls_title = ""
end if
ls_title += "Attached by "
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

if li_count <= 0 then
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

type pb_epro_help from w_window_base`pb_epro_help within w_attachment_transcribe
integer width = 247
integer height = 120
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_attachment_transcribe
integer y = 1516
end type

type st_title from statictext within w_attachment_transcribe
integer width = 2921
integer height = 356
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

type st_transcription_title from statictext within w_attachment_transcribe
integer x = 274
integer y = 360
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

type st_display_only from statictext within w_attachment_transcribe
integer x = 2254
integer y = 360
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

type cb_history from commandbutton within w_attachment_transcribe
integer x = 366
integer y = 1260
integer width = 613
integer height = 96
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

type st_who from statictext within w_attachment_transcribe
integer x = 699
integer y = 360
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

type cb_cancel from commandbutton within w_attachment_transcribe
boolean visible = false
integer x = 1600
integer y = 1592
integer width = 498
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

type cb_done from commandbutton within w_attachment_transcribe
integer x = 2130
integer y = 1592
integer width = 713
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

type mle_text from multilineedit within w_attachment_transcribe
event editkeydown pbm_keydown
integer x = 265
integer y = 436
integer width = 2341
integer height = 772
integer taborder = 40
boolean bringtotop = true
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

type st_1 from statictext within w_attachment_transcribe
integer x = 256
integer y = 1428
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
long backcolor = COLOR_BACKGROUND
string text = "The attachment should already be open in another window.  If it~'s not, click here:"
boolean focusrectangle = false
end type

type cb_open_attachment from commandbutton within w_attachment_transcribe
integer x = 2249
integer y = 1412
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

// Then open the attachment and remember the process_id
li_sts = attachment.open_attachment("Open", false, process_id)
if li_sts > 0 and process_id > 0 then
	my_process = true
else
	my_process = false
end if


return

end event

type cb_properties from commandbutton within w_attachment_transcribe
integer x = 1074
integer y = 1260
integer width = 663
integer height = 96
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

type cb_attachment_object from commandbutton within w_attachment_transcribe
integer x = 1833
integer y = 1260
integer width = 663
integer height = 96
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

