$PBExportHeader$w_ext_observation_easyink_signature.srw
forward
global type w_ext_observation_easyink_signature from w_window_base
end type
type pb_done from u_picture_button within w_ext_observation_easyink_signature
end type
type pb_cancel from u_picture_button within w_ext_observation_easyink_signature
end type
type st_prompt from statictext within w_ext_observation_easyink_signature
end type
type st_title from statictext within w_ext_observation_easyink_signature
end type
type cb_clear from commandbutton within w_ext_observation_easyink_signature
end type
type ole_signature from u_ole_easyink_signature within w_ext_observation_easyink_signature
end type
type st_claimed_id from statictext within w_ext_observation_easyink_signature
end type
type st_1 from statictext within w_ext_observation_easyink_signature
end type
type cb_change_user from commandbutton within w_ext_observation_easyink_signature
end type
end forward

global type w_ext_observation_easyink_signature from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_prompt st_prompt
st_title st_title
cb_clear cb_clear
ole_signature ole_signature
st_claimed_id st_claimed_id
st_1 st_1
cb_change_user cb_change_user
end type
global w_ext_observation_easyink_signature w_ext_observation_easyink_signature

type variables

String mode

string ink
string bitmap_file

long bitmap_height
long bitmap_width

string captured_from_user

u_component_observation external_source

end variables

on w_ext_observation_easyink_signature.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_prompt=create st_prompt
this.st_title=create st_title
this.cb_clear=create cb_clear
this.ole_signature=create ole_signature
this.st_claimed_id=create st_claimed_id
this.st_1=create st_1
this.cb_change_user=create cb_change_user
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_prompt
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.cb_clear
this.Control[iCurrent+6]=this.ole_signature
this.Control[iCurrent+7]=this.st_claimed_id
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.cb_change_user
end on

on w_ext_observation_easyink_signature.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_prompt)
destroy(this.st_title)
destroy(this.cb_clear)
destroy(this.ole_signature)
destroy(this.st_claimed_id)
destroy(this.st_1)
destroy(this.cb_change_user)
end on

event open;call super::open;str_popup popup
str_captured_signature lstr_captured_signature
boolean lb_allow_user_change
string ls_temp
u_user luo_user

external_source = message.powerobjectparm

setnull(lstr_captured_signature.captured_signature_file)

external_source.get_attribute("allow_user_change", lb_allow_user_change)

ls_temp = external_source.get_attribute("claimed_id")
if isnull(ls_temp) then 
	luo_user = current_user
else
	luo_user = user_list.find_user(ls_temp)
	if isnull(luo_user) then
		st_claimed_id.text = ls_temp
		lb_allow_user_change = false
	end if
end if

cb_change_user.visible = lb_allow_user_change

if not isnull(luo_user) then
	captured_from_user = luo_user.user_id
	st_claimed_id.text = luo_user.user_full_name
end if

ls_temp = external_source.get_attribute("gravityprompt")
if isnull(ls_temp) then ls_temp = "Authorized Signature"
st_prompt.text = ls_temp

ls_temp = external_source.get_attribute("title")
if isnull(ls_temp) then ls_temp = "Please Sign"
st_title.text = ls_temp

//popup = message.powerobjectparm
//
//If popup.data_row_count = 2 Then
//	st_claimed_id.text = popup.items[1]
//	st_prompt.text = popup.items[2]
//	visible = true
//Else
//	log.log(This, "open", "invalid parameters", 4)
//	closewithreturn(this, lstr_captured_signature)
//	Return
//End If
//
//st_title.text = popup.title


end event

type pb_epro_help from w_window_base`pb_epro_help within w_ext_observation_easyink_signature
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_ext_observation_easyink_signature
end type

type pb_done from u_picture_button within w_ext_observation_easyink_signature
integer x = 2569
integer y = 1552
integer taborder = 10
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_captured_signature lstr_captured_signature
blob lbl_rendered_attachment
string ls_rendered_attachment_extension
string ls_rendered_temp_file
integer li_sts

ls_rendered_attachment_extension = "bmp"
ls_rendered_temp_file = f_temp_file(ls_rendered_attachment_extension)
ole_signature.object.saveimage(ls_rendered_temp_file)

if not fileexists(ls_rendered_temp_file) then
	log.log(this, "w_ext_observation_easyink_signature.pb_done.clicked.0012", "An error occured saving this signature.  Please try again.", 4)
	ole_signature.object.clear()
	return
end if

li_sts = log.file_read(ls_rendered_temp_file, lbl_rendered_attachment)
if li_sts <= 0 then
	log.log(this, "w_ext_observation_easyink_signature.pb_done.clicked.0012", "An error occured while saving this signature.  Please try again.", 4)
	ole_signature.object.clear()
	return
end if


lstr_captured_signature.capture_prompt = st_prompt.text
lstr_captured_signature.capture_title = st_title.text
lstr_captured_signature.captured_date_time = datetime(today(), now())
lstr_captured_signature.captured_from_user = captured_from_user
lstr_captured_signature.observed_by_user = current_scribe.user_id
lstr_captured_signature.captured_signature_file = ole_signature.object.imagedata
lstr_captured_signature.captured_signature_file_type = "easyink_signature"
lstr_captured_signature.signature_external_source = "EASYINK_SIGNATURE"
lstr_captured_signature.signature_render_file = lbl_rendered_attachment
lstr_captured_signature.signature_render_file_type = ls_rendered_attachment_extension

//popup_return.item_count = 1
//popup_return.items[1] = "OK"
//popup_return.blob_data = ole_signature.object.imagedata

closewithreturn(parent, lstr_captured_signature)


end event

type pb_cancel from u_picture_button within w_ext_observation_easyink_signature
integer x = 82
integer y = 1552
integer taborder = 30
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_captured_signature lstr_captured_signature

setnull(lstr_captured_signature.captured_signature_file)

closewithreturn(parent, lstr_captured_signature)

end event

type st_prompt from statictext within w_ext_observation_easyink_signature
integer x = 155
integer y = 292
integer width = 2606
integer height = 412
integer textsize = -10
integer weight = 400
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

type st_title from statictext within w_ext_observation_easyink_signature
integer width = 2917
integer height = 120
integer textsize = -18
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

type cb_clear from commandbutton within w_ext_observation_easyink_signature
integer x = 1303
integer y = 1580
integer width = 302
integer height = 132
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;
ole_signature.object.clear()

end event

type ole_signature from u_ole_easyink_signature within w_ext_observation_easyink_signature
integer x = 590
integer y = 844
integer width = 1765
integer height = 444
integer taborder = 20
boolean bringtotop = true
string binarykey = "w_ext_observation_easyink_signature.win"
end type

type st_claimed_id from statictext within w_ext_observation_easyink_signature
integer x = 571
integer y = 164
integer width = 1984
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_1 from statictext within w_ext_observation_easyink_signature
integer x = 146
integer y = 168
integer width = 402
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
string text = "Claimed ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_change_user from commandbutton within w_ext_observation_easyink_signature
integer x = 2574
integer y = 160
integer width = 146
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;str_pick_users lstr_pick_users

lstr_pick_users.pick_screen_title = "Who is signing?"
lstr_pick_users.cpr_id = current_patient.cpr_id
lstr_pick_users.allow_special_users = true
user_list.pick_users(lstr_pick_users)
if lstr_pick_users.selected_users.user_count > 0 then
	captured_from_user = lstr_pick_users.selected_users.user[1].user_id
	st_claimed_id.text = user_list.user_full_name(captured_from_user)
end if



end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Dw_ext_observation_easyink_signature.bin 
2B00000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000001000000000000000000000000000000000000000000000000000000006309f84001c667e400000003000000800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000034d17496d11d47da3100070927ca0a95a000000006307874001c667e46309f84001c667e4000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000001c00000000fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Affffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000300000027e500000b79ffff000b000500130013800080000008002e007100590037003f004b005d007b0075007400280066003f005e007100650067004600000300000027e500000b79ffff000b0005001300138000800000080025005600710065006700460057006b0042005f00330038003500260042002c0070005e002800660025005600710065006700460057006b0042005f006a002700300059007a002800710037002800660056006600710062006700460057006b0042005f005900680077002c006d003d0073006700280066004a0059004c002a006c005b002b006a002800270035004d0044004b00530059006e00550028006600410048004c002a0078005b0058006500790029005300290028007d0028007a006f004200280066006c003000650039004700660079006a0031006f00330021006e00750024006e0027007000280067004b0045003f007900580056005d0042006400320000000000000000012e0551010810ad0015017800150178004e0049004f0044005300570073005c00730079006500740033006d005c003200690072006800630078007400320033006f002e007800630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Dw_ext_observation_easyink_signature.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
