$PBExportHeader$w_attachment_audio_display.srw
forward
global type w_attachment_audio_display from w_window_base
end type
type st_title from statictext within w_attachment_audio_display
end type
type st_transcription_title from statictext within w_attachment_audio_display
end type
type st_display_only from statictext within w_attachment_audio_display
end type
type cb_history from commandbutton within w_attachment_audio_display
end type
type st_who from statictext within w_attachment_audio_display
end type
type cb_cancel from commandbutton within w_attachment_audio_display
end type
type cb_done from commandbutton within w_attachment_audio_display
end type
type mle_text from multilineedit within w_attachment_audio_display
end type
type cb_open from commandbutton within w_attachment_audio_display
end type
type ole_mediaplayer from olecustomcontrol within w_attachment_audio_display
end type
end forward

global type w_attachment_audio_display from w_window_base
boolean titlebar = false
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
cb_open cb_open
ole_mediaplayer ole_mediaplayer
end type
global w_attachment_audio_display w_attachment_audio_display

type variables
u_component_attachment attachment

boolean display_only
boolean updated

string audio_file

end variables

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();

ole_mediaplayer.object.currentmedia = ole_mediaplayer.object.mediacollection.add(audio_file)


//ole_mm.object.Notify = FALSE
//ole_mm.object.Wait = TRUE
//ole_mm.object.Shareable = FALSE
//ole_mm.object.DeviceType = "WaveAudio"
//ole_mm.object.Frames = 10
//ole_mm.object.FileName = audio_file
//ole_mm.object.Command = "Open"
//
//hpb_audio.Minposition = 0
//hpb_audio.Maxposition = ole_mm.object.Length
//hpb_audio.position = 0

return 1

end function

on w_attachment_audio_display.create
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
this.cb_open=create cb_open
this.ole_mediaplayer=create ole_mediaplayer
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_transcription_title
this.Control[iCurrent+3]=this.st_display_only
this.Control[iCurrent+4]=this.cb_history
this.Control[iCurrent+5]=this.st_who
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_done
this.Control[iCurrent+8]=this.mle_text
this.Control[iCurrent+9]=this.cb_open
this.Control[iCurrent+10]=this.ole_mediaplayer
end on

on w_attachment_audio_display.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_transcription_title)
destroy(this.st_display_only)
destroy(this.cb_history)
destroy(this.st_who)
destroy(this.cb_cancel)
destroy(this.cb_done)
destroy(this.mle_text)
destroy(this.cb_open)
destroy(this.ole_mediaplayer)
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

attachment.get_attribute("menu_id", ll_menu_id)
if not isnull(ll_menu_id) then
	max_buttons = 3
	paint_menu(ll_menu_id)
end if

ls_title = "Audio Recording by "
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

audio_file = attachment.get_attachment()
if isnull(audio_file) then
	log.log(this, "w_attachment_audio_display:open", "Error getting attachment file", 4)
	closewithreturn(this, popup_return)
	return
end if

li_sts = initialize()
if li_sts <= 0 then
	log.log(this, "w_attachment_audio_display:open", "Error initializing dictation", 4)
	closewithreturn(this, popup_return)
	return
end if

ls_open_command = datalist.extension_open_command(attachment.extension)
if isnull(ls_open_command) then
	cb_open.visible = false
else
	cb_open.visible = true
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

event close;call super::close;if fileexists(audio_file) then filedelete(audio_file)
end event

type pb_epro_help from w_window_base`pb_epro_help within w_attachment_audio_display
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_attachment_audio_display
end type

type st_title from statictext within w_attachment_audio_display
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
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_transcription_title from statictext within w_attachment_audio_display
integer x = 55
integer y = 1176
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
long backcolor = 7191717
boolean enabled = false
string text = "Transcription"
boolean focusrectangle = false
end type

type st_display_only from statictext within w_attachment_audio_display
integer x = 2514
integer y = 1176
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
long backcolor = 7191717
boolean enabled = false
string text = "Display Only"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_history from commandbutton within w_attachment_audio_display
integer x = 37
integer y = 1688
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

type st_who from statictext within w_attachment_audio_display
integer x = 699
integer y = 752
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
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_attachment_audio_display
boolean visible = false
integer x = 1806
integer y = 1660
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

type cb_done from commandbutton within w_attachment_audio_display
integer x = 2363
integer y = 1680
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

type mle_text from multilineedit within w_attachment_audio_display
event editkeydown pbm_keydown
integer x = 55
integer y = 1260
integer width = 2811
integer height = 376
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

type cb_open from commandbutton within w_attachment_audio_display
integer x = 2295
integer y = 692
integer width = 521
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Open in Windows"
end type

event clicked;attachment.open_attachment(audio_file)

end event

type ole_mediaplayer from olecustomcontrol within w_attachment_audio_display
event openstatechange ( long newstate )
event playstatechange ( long newstate )
event audiolanguagechange ( long langid )
event statuschange ( )
event scriptcommand ( string sctype,  string param )
event newstream ( )
event ocx_disconnect ( long result )
event buffering ( boolean start )
event ocx_error ( )
event warning ( long warningtype,  long param,  string description )
event endofstream ( long result )
event positionchange ( double oldposition,  double newposition )
event markerhit ( long markernum )
event durationunitchange ( long newdurationunit )
event cdrommediachange ( long cdromnum )
event playlistchange ( oleobject playlist,  integer change )
event currentplaylistchange ( integer change )
event currentplaylistitemavailable ( string bstritemname )
event mediachange ( oleobject item )
event currentmediaitemavailable ( string bstritemname )
event currentitemchange ( oleobject pdispmedia )
event mediacollectionchange ( )
event mediacollectionattributestringadded ( string bstrattribname,  string bstrattribval )
event mediacollectionattributestringremoved ( string bstrattribname,  string bstrattribval )
event mediacollectionattributestringchanged ( string bstrattribname,  string bstroldattribval,  string bstrnewattribval )
event playlistcollectionchange ( )
event playlistcollectionplaylistadded ( string bstrplaylistname )
event playlistcollectionplaylistremoved ( string bstrplaylistname )
event playlistcollectionplaylistsetasdeleted ( string bstrplaylistname,  boolean varfisdeleted )
event modechange ( string modename,  boolean newvalue )
event mediaerror ( oleobject pmediaobject )
event openplaylistswitch ( oleobject pitem )
event domainchange ( string strdomain )
event switchedtoplayerapplication ( )
event switchedtocontrol ( )
event playerdockedstatechange ( )
event playerreconnect ( )
event click ( integer nbutton,  integer nshiftstate,  long fx,  long fy )
event doubleclick ( integer nbutton,  integer nshiftstate,  long fx,  long fy )
event keydown ( integer nkeycode,  integer nshiftstate )
event keypress ( integer nkeyascii )
event keyup ( integer nkeycode,  integer nshiftstate )
event mousedown ( integer nbutton,  integer nshiftstate,  long fx,  long fy )
event mousemove ( integer nbutton,  integer nshiftstate,  long fx,  long fy )
event mouseup ( integer nbutton,  integer nshiftstate,  long fx,  long fy )
event deviceconnect ( oleobject pdevice )
event devicedisconnect ( oleobject pdevice )
event devicestatuschange ( oleobject pdevice,  integer newstatus )
event devicesyncstatechange ( oleobject pdevice,  integer newstate )
event devicesyncerror ( oleobject pdevice,  oleobject pmedia )
integer x = 649
integer y = 296
integer width = 1586
integer height = 848
integer taborder = 20
boolean bringtotop = true
boolean border = false
boolean focusrectangle = false
string binarykey = "w_attachment_audio_display.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Cw_attachment_audio_display.bin 
2600000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000100000000000000000000000000000000000000000000000000000000f02734b001c8fd6300000003000001800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000a200000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000036bf52a5211d3394ac00053b1a6fa794f00000000f02734b001c8fd63f02734b001c8fd63000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000003000000a2000000000000000100000002fffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
27ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000003000000000800050000000000003ff0000000000003000500000000000000000000000200080000000000010003000b00000003ffff00000000ffff000b000200080000000000320003000b0000000800000000000a00750066006c006c000b0000000b0000000b0000000bffff000bffff0008000000000002000800000000000200080000000000020008000000000002000b000023dd000015e90000006d0000005c0065005400510079005300740073006d0065003b005c003a0043000003000000000800050000000000003ff0000000000003000500000000000000000000000200080000000000010003000b00000003ffff00000000ffff000b000200080000000000320003000b0000000800000000000a00750066006c006c000b0000000b0000000b0000000bffff000bffff0008000000000002000800000000000200080000000000020008000000000002000b000023dd000015e90000006900000065006c005c00730079005300610062006500730050005c0077006f0072006500750042006c00690065006400200072003100310030002e0043003b005c003a007200500067006f006100720020006d006900460065006c005c00730079005300610062006500730053005c0061006800650072005c00640065005700200062006100540067007200740065003b0073000000000140000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Cw_attachment_audio_display.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
