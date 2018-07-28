HA$PBExportHeader$w_attachment_activex_display.srw
forward
global type w_attachment_activex_display from w_window_base
end type
type st_title from statictext within w_attachment_activex_display
end type
type cb_history from commandbutton within w_attachment_activex_display
end type
type cb_cancel from commandbutton within w_attachment_activex_display
end type
type cb_done from commandbutton within w_attachment_activex_display
end type
type cb_description from commandbutton within w_attachment_activex_display
end type
type st_attachment_text from statictext within w_attachment_activex_display
end type
type ole_control from u_ole_control within w_attachment_activex_display
end type
type cb_open from commandbutton within w_attachment_activex_display
end type
end forward

global type w_attachment_activex_display from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
cb_history cb_history
cb_cancel cb_cancel
cb_done cb_done
cb_description cb_description
st_attachment_text st_attachment_text
ole_control ole_control
cb_open cb_open
end type
global w_attachment_activex_display w_attachment_activex_display

type variables
u_component_attachment attachment
string display_file
string working_file
str_file_attributes working_file_attributes

boolean display_only
boolean updated = false

boolean loading = true


end variables

forward prototypes
public subroutine display_file ()
end prototypes

public subroutine display_file ();
end subroutine

on w_attachment_activex_display.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_history=create cb_history
this.cb_cancel=create cb_cancel
this.cb_done=create cb_done
this.cb_description=create cb_description
this.st_attachment_text=create st_attachment_text
this.ole_control=create ole_control
this.cb_open=create cb_open
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_history
this.Control[iCurrent+3]=this.cb_cancel
this.Control[iCurrent+4]=this.cb_done
this.Control[iCurrent+5]=this.cb_description
this.Control[iCurrent+6]=this.st_attachment_text
this.Control[iCurrent+7]=this.ole_control
this.Control[iCurrent+8]=this.cb_open
end on

on w_attachment_activex_display.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_history)
destroy(this.cb_cancel)
destroy(this.cb_done)
destroy(this.cb_description)
destroy(this.st_attachment_text)
destroy(this.ole_control)
destroy(this.cb_open)
end on

event open;call super::open;integer li_count
str_popup popup
str_popup_return popup_return
integer li_sts
string ls_title
string ls_open_command

attachment = message.powerobjectparm

ls_title = "File Attached by "
ls_title += attachment.originator.user_full_name
ls_title += " on " + string(attachment.attachment_date, "[shortdate] [time]")
st_title.text = ls_title

display_file = attachment.get_attachment()
if isnull(display_file) then
	log.log(this, "open", "Error getting attachment file", 4)
	close(this)
	return
end if

working_file = f_temp_file(attachment.extension)
filecopy(display_file, working_file)
log.file_attributes(working_file, working_file_attributes)

ls_open_command = datalist.extension_open_command(attachment.extension)
if isnull(ls_open_command) then
	cb_open.visible = false
else
	cb_open.visible = true
end if

postevent("post_open")


end event

event close;call super::close;
ole_control.clear()
closeuserobject(ole_control)

if fileexists(display_file) then filedelete(display_file)
if fileexists(working_file) then filedelete(working_file)

end event

event post_open;integer li_count
str_p_attachment_progress lstra_progress[]

ole_control.initialize(display_file, this)

li_count = attachment.get_attachment_progress("progress_type='UPDATE'", lstra_progress)
if li_count > 0 then
	cb_history.enabled = true
else
	cb_history.enabled = false
end if

st_attachment_text.text = attachment.attachment_text

loading = false

timer(2)


end event

event timer;call super::timer;str_file_attributes lstr_file
integer li_sts
datetime ldt_created
datetime ldt_updated

if not fileexists(working_file) then return

li_sts = log.file_attributes(working_file, lstr_file)
if li_sts <= 0 then return

// Compare the updated datetime with one second past the original datetime.
ldt_created = datetime(working_file_attributes.lastwritedate, relativetime(working_file_attributes.lastwritetime, 1))
ldt_updated = datetime(lstr_file.lastwritedate, lstr_file.lastwritetime)

if ldt_updated > ldt_created then
	filecopy(working_file, display_file, true)
	log.file_attributes(working_file, working_file_attributes)
	ole_control.clear()
	ole_control.insertfile(display_file)
	updated = true
	cb_cancel.visible = true
	cb_done.text = "Update Attachment"
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_attachment_activex_display
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_attachment_activex_display
end type

type st_title from statictext within w_attachment_activex_display
integer width = 2921
integer height = 128
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

type cb_history from commandbutton within w_attachment_activex_display
integer x = 1056
integer y = 1524
integer width = 594
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "View Update History"
end type

event clicked;openwithparm(w_transcription_history, attachment)

end event

type cb_cancel from commandbutton within w_attachment_activex_display
boolean visible = false
integer x = 1326
integer y = 1660
integer width = 718
integer height = 112
integer taborder = 60
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

if updated then
	openwithparm(w_pop_yes_no, "The attachment has been updated.  Are you sure you wish to exit without saving the updates?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then close(parent)
	return
end if

close(parent)


end event

type cb_done from commandbutton within w_attachment_activex_display
integer x = 2085
integer y = 1660
integer width = 763
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;integer li_sts

// if display only then just return
if display_only then
	close(parent)
	return
end if

// If no change then just return
if not updated then
	close(parent)
	return
end if

li_sts = attachment.add_update(working_file)
if li_sts <= 0 then
	openwithparm(w_pop_message, "Error saving update")
	return
end if

close(parent)


end event

type cb_description from commandbutton within w_attachment_activex_display
integer x = 1015
integer y = 1656
integer width = 142
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;openwithparm(w_attachment_edit_attachment_text, attachment)
st_attachment_text.text = attachment.attachment_text


end event

type st_attachment_text from statictext within w_attachment_activex_display
integer x = 32
integer y = 1540
integer width = 974
integer height = 228
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type ole_control from u_ole_control within w_attachment_activex_display
integer x = 27
integer y = 140
integer width = 2830
integer height = 1376
integer taborder = 30
boolean bringtotop = true
string binarykey = "w_attachment_activex_display.win"
end type

event clicked;common_thread.mm.display_ole_file(working_file)

end event

type cb_open from commandbutton within w_attachment_activex_display
integer x = 2542
integer y = 1532
integer width = 315
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Open"
end type

event clicked;attachment.open_attachment(working_file)

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Ew_attachment_activex_display.bin 
2B00000600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe00000006000000000000000000000001000000010000000000001000fffffffe00000000fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Ew_attachment_activex_display.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
