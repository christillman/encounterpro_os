$PBExportHeader$w_ext_observation_pbink_signature.srw
forward
global type w_ext_observation_pbink_signature from w_window_base
end type
type st_claimed_id from statictext within w_ext_observation_pbink_signature
end type
type st_prompt from statictext within w_ext_observation_pbink_signature
end type
type st_title from statictext within w_ext_observation_pbink_signature
end type
type cb_clear from commandbutton within w_ext_observation_pbink_signature
end type
type ip_ink from u_inkpicture within w_ext_observation_pbink_signature
end type
type st_1 from statictext within w_ext_observation_pbink_signature
end type
type cb_change_user from commandbutton within w_ext_observation_pbink_signature
end type
type cb_ok from commandbutton within w_ext_observation_pbink_signature
end type
type cb_cancel from commandbutton within w_ext_observation_pbink_signature
end type
end forward

global type w_ext_observation_pbink_signature from w_window_base
integer width = 2953
integer height = 1856
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_claimed_id st_claimed_id
st_prompt st_prompt
st_title st_title
cb_clear cb_clear
ip_ink ip_ink
st_1 st_1
cb_change_user cb_change_user
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_ext_observation_pbink_signature w_ext_observation_pbink_signature

type variables

String mode

string ink
string bitmap_file

long bitmap_height
long bitmap_width

InkPersistenceFormat  inkformat
string ink_extension

u_component_observation external_source

string captured_from_user

end variables

on w_ext_observation_pbink_signature.create
int iCurrent
call super::create
this.st_claimed_id=create st_claimed_id
this.st_prompt=create st_prompt
this.st_title=create st_title
this.cb_clear=create cb_clear
this.ip_ink=create ip_ink
this.st_1=create st_1
this.cb_change_user=create cb_change_user
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_claimed_id
this.Control[iCurrent+2]=this.st_prompt
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.cb_clear
this.Control[iCurrent+5]=this.ip_ink
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cb_change_user
this.Control[iCurrent+8]=this.cb_ok
this.Control[iCurrent+9]=this.cb_cancel
end on

on w_ext_observation_pbink_signature.destroy
call super::destroy
destroy(this.st_claimed_id)
destroy(this.st_prompt)
destroy(this.st_title)
destroy(this.cb_clear)
destroy(this.ip_ink)
destroy(this.st_1)
destroy(this.cb_change_user)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
string ls_temp
string ls_inkformat
long ll_material_id
str_patient_material lstr_image
u_user luo_user
boolean lb_allow_user_change

external_source = message.powerobjectparm
popup_return.item_count = 0


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

ls_inkformat = external_source.get_attribute("ink_format")
if isnull(ls_inkformat) then ls_inkformat = "ISF"

CHOOSE CASE upper(ls_inkformat)
	CASE "ISF"
		inkformat = InkSerializedFormat!
		ink_extension = "isf"
	CASE "ISF64"
		inkformat = Base64InkSerializedFormat!
		ink_extension = "isf"
	CASE "GIF"
		inkformat = GIFFormat!
		ink_extension = "gif"
	CASE "GIF64"
		inkformat = Base64GIFFormat!
		ink_extension = "gif"
	CASE ELSE
END CHOOSE

ll_material_id = long(external_source.get_attribute("signature_background_material_id"))
if not isnull(ll_material_id) then
	lstr_image = f_get_patient_material(ll_material_id, true)
	if not isnull(lstr_image.material_id) then
		ip_ink.loadpicture(lstr_image.material_object)
	end if
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_ext_observation_pbink_signature
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_ext_observation_pbink_signature
end type

type st_claimed_id from statictext within w_ext_observation_pbink_signature
integer x = 571
integer y = 164
integer width = 1984
integer height = 76
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

type st_prompt from statictext within w_ext_observation_pbink_signature
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
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_ext_observation_pbink_signature
integer width = 2917
integer height = 120
integer textsize = -18
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

type cb_clear from commandbutton within w_ext_observation_pbink_signature
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
//ole_signature.object.clear()
ip_ink.resetink()

end event

type ip_ink from u_inkpicture within w_ext_observation_pbink_signature
integer x = 590
integer y = 844
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_ext_observation_pbink_signature
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
long backcolor = COLOR_BACKGROUND
string text = "Claimed ID:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_change_user from commandbutton within w_ext_observation_pbink_signature
integer x = 2574
integer y = 160
integer width = 146
integer height = 88
integer taborder = 20
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

type cb_ok from commandbutton within w_ext_observation_pbink_signature
integer x = 2414
integer y = 1656
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
string text = "OK"
boolean default = true
end type

event clicked;str_popup_return popup_return
blob lbl_ink
integer li_sts
string ls_description
blob lbl_rendered_attachment
string ls_rendered_attachment_extension
string ls_temp_gif
string ls_temp_bmp

li_sts = ip_ink.saveink(lbl_ink, inkformat)
if li_sts < 1 then
	openwithparm(w_pop_message, "This does not appear to be a valid signature.  Please try again.")
	ip_ink.resetink()
	return
end if

ls_rendered_attachment_extension = "bmp"
ls_temp_gif = f_temp_file("gif")
li_sts = ip_ink.saveink(ls_temp_gif, GIFFormat!)
if li_sts < 1 then
	openwithparm(w_pop_message, "An error occured saving this signature.  Please try again.")
	ip_ink.resetink()
	return
end if

ls_temp_bmp = f_temp_file("bmp")
li_sts = f_convert_image_to_bmp(ls_temp_gif, ls_temp_bmp)
if li_sts < 1 then
	openwithparm(w_pop_message, "An error occured saving this signature image.  Please try again.")
	ip_ink.resetink()
	return
end if

li_sts = log.file_read(ls_temp_bmp, lbl_rendered_attachment)
if li_sts < 1 then
	openwithparm(w_pop_message, "An error occured saving the image for this signature.  Please try again.")
	ip_ink.resetink()
	return
end if

ls_description = external_source.get_attribute("description")
if isnull(ls_description) then ls_description = "Signature of " + st_claimed_id.text

external_source.observation_count = 1
external_source.observations[1].result_count = 0
external_source.observations[1].attachment_list.attachment_count = 1
external_source.observations[1].attachment_list.attachments[1].attachment_type = "SIGNATURE"
external_source.observations[1].attachment_list.attachments[1].extension = ink_extension
external_source.observations[1].attachment_list.attachments[1].attachment_comment_title = ls_description
external_source.observations[1].attachment_list.attachments[1].attachment = lbl_ink

external_source.observations[1].attachment_list.attachments[1].attachment_render_file = lbl_rendered_attachment
external_source.observations[1].attachment_list.attachments[1].attachment_render_file_type = ls_rendered_attachment_extension
external_source.observations[1].attachment_list.attachments[1].attached_by_user_id = captured_from_user


popup_return.item_count = 1
popup_return.items[1] = "OK"
closewithreturn(parent, popup_return)


end event

type cb_cancel from commandbutton within w_ext_observation_pbink_signature
integer x = 82
integer y = 1656
integer width = 402
integer height = 112
integer taborder = 40
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

event clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

