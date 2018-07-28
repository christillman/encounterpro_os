HA$PBExportHeader$w_user_signature_stamp.srw
forward
global type w_user_signature_stamp from w_window_base
end type
type cb_finished from commandbutton within w_user_signature_stamp
end type
type cb_cancel from commandbutton within w_user_signature_stamp
end type
type uo_signature_stamp_display from u_picture_display within w_user_signature_stamp
end type
type st_1 from statictext within w_user_signature_stamp
end type
type ole_easyink from u_ole_easyink_signature within w_user_signature_stamp
end type
type st_2 from statictext within w_user_signature_stamp
end type
type cb_use_easyink from commandbutton within w_user_signature_stamp
end type
type st_3 from statictext within w_user_signature_stamp
end type
type st_4 from statictext within w_user_signature_stamp
end type
type cb_import_bitmap from commandbutton within w_user_signature_stamp
end type
type cb_clear_easyink from commandbutton within w_user_signature_stamp
end type
type cb_clear_stamp from commandbutton within w_user_signature_stamp
end type
type st_no_stamp from statictext within w_user_signature_stamp
end type
end forward

global type w_user_signature_stamp from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
cb_cancel cb_cancel
uo_signature_stamp_display uo_signature_stamp_display
st_1 st_1
ole_easyink ole_easyink
st_2 st_2
cb_use_easyink cb_use_easyink
st_3 st_3
st_4 st_4
cb_import_bitmap cb_import_bitmap
cb_clear_easyink cb_clear_easyink
cb_clear_stamp cb_clear_stamp
st_no_stamp st_no_stamp
end type
global w_user_signature_stamp w_user_signature_stamp

type variables
u_user user
string signature_stamp
boolean signature_changed = false
boolean signature_deleted = false

end variables

on w_user_signature_stamp.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.cb_cancel=create cb_cancel
this.uo_signature_stamp_display=create uo_signature_stamp_display
this.st_1=create st_1
this.ole_easyink=create ole_easyink
this.st_2=create st_2
this.cb_use_easyink=create cb_use_easyink
this.st_3=create st_3
this.st_4=create st_4
this.cb_import_bitmap=create cb_import_bitmap
this.cb_clear_easyink=create cb_clear_easyink
this.cb_clear_stamp=create cb_clear_stamp
this.st_no_stamp=create st_no_stamp
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.cb_cancel
this.Control[iCurrent+3]=this.uo_signature_stamp_display
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.ole_easyink
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.cb_use_easyink
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.cb_import_bitmap
this.Control[iCurrent+11]=this.cb_clear_easyink
this.Control[iCurrent+12]=this.cb_clear_stamp
this.Control[iCurrent+13]=this.st_no_stamp
end on

on w_user_signature_stamp.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.cb_cancel)
destroy(this.uo_signature_stamp_display)
destroy(this.st_1)
destroy(this.ole_easyink)
destroy(this.st_2)
destroy(this.cb_use_easyink)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.cb_import_bitmap)
destroy(this.cb_clear_easyink)
destroy(this.cb_clear_stamp)
destroy(this.st_no_stamp)
end on

event open;call super::open;
user = message.powerobjectparm

title = user.user_full_name

uo_signature_stamp_display.initialize()

signature_stamp = user_list.user_signature_stamp(user.user_id)
if isnull(signature_stamp) or not fileexists(signature_stamp) then
	setnull(signature_stamp)
	st_no_stamp.visible = true
	uo_signature_stamp_display.visible = false
else
	st_no_stamp.visible = false
	uo_signature_stamp_display.visible = true
	uo_signature_stamp_display.display_picture(signature_stamp)
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_user_signature_stamp
boolean visible = true
integer x = 2112
integer y = 1580
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_user_signature_stamp
end type

type cb_finished from commandbutton within w_user_signature_stamp
integer x = 2427
integer y = 1568
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
boolean default = true
end type

event clicked;blob lbl_signature_stamp
integer li_sts


if signature_changed then
	if signature_deleted then
		setnull(lbl_signature_stamp)
	else
		if isnull(signature_stamp) or not fileexists(signature_stamp) then
			setnull(lbl_signature_stamp)
		else
			li_sts = log.file_read(signature_stamp, lbl_signature_stamp)
			if li_sts <= 0 then
				openwithparm(w_pop_message, "Error reading signature file")
				return
			end if
		end if
	end if
	
	if isnull(lbl_signature_stamp) then
		UPDATE c_User
		SET signature_stamp = NULL
		WHERE user_id = :user.user_id;
	else
		UPDATEBLOB c_User
		SET signature_stamp = :lbl_signature_stamp
		WHERE user_id = :user.user_id;
	end if
	if not tf_check() then
		openwithparm(w_pop_message, "Error saving signature file")
		return
	end if
end if

close(parent)

end event

type cb_cancel from commandbutton within w_user_signature_stamp
integer x = 69
integer y = 1568
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup popup
str_popup_return popup_return

if signature_changed then
	openwithparm(w_pop_yes_no, "Are you sure you want to exit without saving your changes")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if


close(parent)

end event

type uo_signature_stamp_display from u_picture_display within w_user_signature_stamp
integer x = 567
integer y = 996
integer width = 2176
integer height = 540
integer taborder = 20
boolean bringtotop = true
long backcolor = 33538240
end type

on uo_signature_stamp_display.destroy
call u_picture_display::destroy
end on

type st_1 from statictext within w_user_signature_stamp
integer x = 23
integer y = 996
integer width = 521
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
string text = "Signature Stamp:"
alignment alignment = right!
boolean focusrectangle = false
end type

type ole_easyink from u_ole_easyink_signature within w_user_signature_stamp
integer x = 567
integer y = 196
integer width = 1897
integer height = 512
integer taborder = 20
boolean bringtotop = true
string binarykey = "w_user_signature_stamp.win"
end type

type st_2 from statictext within w_user_signature_stamp
integer width = 2921
integer height = 152
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "User Signature Stamp"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_use_easyink from commandbutton within w_user_signature_stamp
integer x = 2487
integer y = 596
integer width = 343
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Use This"
end type

event clicked;blob lbl_signature

lbl_signature = ole_easyink.object.imagedata
if isnull(signature_stamp) then
	signature_stamp = f_temp_file("bmp")
end if

ole_easyink.object.saveimage(signature_stamp)
uo_signature_stamp_display.display_picture(signature_stamp)
st_no_stamp.visible = false
uo_signature_stamp_display.visible = true

signature_changed = true
signature_deleted = false

end event

type st_3 from statictext within w_user_signature_stamp
integer x = 110
integer y = 204
integer width = 434
integer height = 252
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Capture New Signature"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_user_signature_stamp
integer x = 23
integer y = 820
integer width = 521
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
string text = "Import Signature:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_import_bitmap from commandbutton within w_user_signature_stamp
integer x = 567
integer y = 796
integer width = 878
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Import Bitmap File"
end type

event clicked;integer li_sts
string ls_filepath
string ls_filename

li_sts = GetFileOpenName ("Select Bitmap File Containing User Signature", ls_filepath, ls_filename ,"bmp", "Bitmap Files,*.bmp")
If li_sts <= 0 Then Return 0

if isnull(signature_stamp) then
	signature_stamp = f_temp_file("bmp")
end if

filecopy(ls_filepath, signature_stamp, true)

uo_signature_stamp_display.display_picture(signature_stamp)
st_no_stamp.visible = false
uo_signature_stamp_display.visible = true

signature_changed = true
signature_deleted = false

end event

type cb_clear_easyink from commandbutton within w_user_signature_stamp
integer x = 2487
integer y = 196
integer width = 343
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;
ole_easyink.object.clear()

end event

type cb_clear_stamp from commandbutton within w_user_signature_stamp
integer x = 1143
integer y = 1568
integer width = 727
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Remove Signature Stamp"
boolean cancel = true
end type

event clicked;st_no_stamp.visible = true
uo_signature_stamp_display.visible = false

signature_changed = true
signature_deleted = true

end event

type st_no_stamp from statictext within w_user_signature_stamp
integer x = 567
integer y = 988
integer width = 1582
integer height = 124
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "No Signature Stamp On File"
boolean focusrectangle = false
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
01w_user_signature_stamp.bin 
2200000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000001000000000000000000000000000000000000000000000000000000005c18d2d001c528cb00000003000000400000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe0000000000000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000034d17496d11d47da3100070927ca0a95a000000005c18d2d001c528cb5c18d2d001c528cb000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c00000000fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Cffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000030000002ae400000d3bffff000b000500130013800080000008006e007200200073006f006c0067006e005b002000620070005f006d0072006400670061006e006500650074005d00720064000000610072006c00670061006500650076002800200064002000610072006f0067006a00620063006500200074006f0073007200750065006300290020002000200065007200750074006e007200200073006f006c0067006e005b002000620070005f006d00720064006700610065006c00760061005d006500640000006100720077006700740069006900680020006e0020002800720064006700610062006f0065006a00740063007300200075006f0063007200200065002000290072002000740065007200750073006e006c0020006e006f002000670070005b006d00620064005f00610072007700670074006900690068005d006e00680000006c00650020007000200028006e0069006500740065006700200072007000780073006f0020002c006e0069006500740065006700200072007000790073006f00290020002000200065007200750074006e007200200073006f006c0067006e005b002000620070005f006d006500680070006c0000005d001cfe687fffffff7fffffff7fff7fff00007fff00000000031b66a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11w_user_signature_stamp.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
