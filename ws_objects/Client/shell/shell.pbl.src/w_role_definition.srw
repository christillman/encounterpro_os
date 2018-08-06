$PBExportHeader$w_role_definition.srw
forward
global type w_role_definition from w_window_base
end type
type sle_role_name from singlelineedit within w_role_definition
end type
type st_color from statictext within w_role_definition
end type
type st_2 from statictext within w_role_definition
end type
type st_4 from statictext within w_role_definition
end type
type ole_dialogs from olecustomcontrol within w_role_definition
end type
type st_title from statictext within w_role_definition
end type
type mle_description from multilineedit within w_role_definition
end type
type st_description_title from statictext within w_role_definition
end type
type cb_ok from commandbutton within w_role_definition
end type
type cb_cancel from commandbutton within w_role_definition
end type
type st_status_title from statictext within w_role_definition
end type
type st_status from statictext within w_role_definition
end type
end forward

global type w_role_definition from w_window_base
boolean titlebar = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
sle_role_name sle_role_name
st_color st_color
st_2 st_2
st_4 st_4
ole_dialogs ole_dialogs
st_title st_title
mle_description mle_description
st_description_title st_description_title
cb_ok cb_ok
cb_cancel cb_cancel
st_status_title st_status_title
st_status st_status
end type
global w_role_definition w_role_definition

type variables
string role_id


end variables

forward prototypes
public function integer load_role (string ps_role_id)
public function integer save_role ()
end prototypes

public function integer load_role (string ps_role_id);long ll_color
integer li_sts
string ls_role_name
string ls_description
string ls_status

role_id = ps_role_id

SELECT	role_name,
			description,
			color,
			status
INTO	:ls_role_name,
		:ls_description,
		:ll_color,
		:ls_status
FROM c_Role
WHERE role_id = :role_id;
if not tf_check() then return -1

if sqlca.sqlcode = 100 then return 0

sle_role_name.text = ls_role_name
mle_description.text = ls_description

if isnull(ll_color) then
	st_color.backcolor = color_background
else
	st_color.backcolor = ll_color
end if

if upper(ls_status) = "OK" then
	st_status.text = "Enabled"
else
	st_status.text = "Disabled"
end if

return 1

end function

public function integer save_role ();string ls_role_base
integer i
integer li_count
string ls_provider_id
integer li_sts
string ls_status
u_ds_data dw_char_key

if isnull(sle_role_name.text) or trim(sle_role_name.text) = "" then
	openwithparm(w_pop_message, "An error occured saving role.  Please cancel and try again.")
	return 0
end if

if isnull(mle_description.text) or trim(mle_description.text) = "" then
	openwithparm(w_pop_message, "You must enter a role description")
	return 0
end if

if lower(st_status.text) = "enabled" then
	ls_status = "OK"
else
	ls_status = "NA"
end if

if isnull(role_id) then
	ls_role_base = "!" + f_gen_key_string(sle_role_name.text, 9)

	dw_char_key = CREATE u_ds_data
	dw_char_key.set_dataobject("dw_sp_get_char_key_resultset")
	dw_char_key.retrieve("c_Role", "role_id", ls_role_base)

	role_id = dw_char_key.object.new_key[1]
	
	INSERT INTO c_Role (
		role_id,
		role_name,
		description,
		color,
		status)
	VALUES (
		:role_id,
		:sle_role_name.text,
		:mle_description.text,
		:st_color.backcolor,
		:ls_status);
	if not tf_check() then return -1
else
	UPDATE c_Role
	SET	role_name = :sle_role_name.text,
			description = :mle_description.text,
			color = :st_color.backcolor,
			status = :ls_status
	WHERE role_id = :role_id;
	if not tf_check() then return -1
end if

return 1


end function

on w_role_definition.create
int iCurrent
call super::create
this.sle_role_name=create sle_role_name
this.st_color=create st_color
this.st_2=create st_2
this.st_4=create st_4
this.ole_dialogs=create ole_dialogs
this.st_title=create st_title
this.mle_description=create mle_description
this.st_description_title=create st_description_title
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_status_title=create st_status_title
this.st_status=create st_status
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_role_name
this.Control[iCurrent+2]=this.st_color
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.ole_dialogs
this.Control[iCurrent+6]=this.st_title
this.Control[iCurrent+7]=this.mle_description
this.Control[iCurrent+8]=this.st_description_title
this.Control[iCurrent+9]=this.cb_ok
this.Control[iCurrent+10]=this.cb_cancel
this.Control[iCurrent+11]=this.st_status_title
this.Control[iCurrent+12]=this.st_status
end on

on w_role_definition.destroy
call super::destroy
destroy(this.sle_role_name)
destroy(this.st_color)
destroy(this.st_2)
destroy(this.st_4)
destroy(this.ole_dialogs)
destroy(this.st_title)
destroy(this.mle_description)
destroy(this.st_description_title)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_status_title)
destroy(this.st_status)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts

popup = message.powerobjectparm
popup_return.item_count = 0

if isnull(popup.item) then
	// New role
	setnull(role_id)
else
	role_id = popup.item
end if

postevent("post_open")






end event

event post_open;call super::post_open;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_count
string ls_status

if isnull(role_id) then
	popup.title = "Enter name for new role"
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then
		popup_return.item_count = 0
		closewithreturn(this, popup_return)
		return
	end if
	SELECT count(*)
	INTO :ll_count
	FROM c_Role
	WHERE role_name = :popup_return.items[1];
	if not tf_check() then
		popup_return.item_count = 0
		closewithreturn(this, popup_return)
	end if
	if ll_count = 1 then
		SELECT role_id, status
		INTO :role_id, :ls_status
		FROM c_Role
		WHERE role_name = :popup_return.items[1];
		if not tf_check() then
			popup_return.item_count = 0
			closewithreturn(this, popup_return)
		end if
		if upper(ls_status) = "OK" then
			openwithparm(w_pop_message, "The role ~"" + popup_return.items[1] + "~" already exists")
			popup_return.item_count = 0
			closewithreturn(this, popup_return)
		else
			openwithparm(w_pop_yes_no, "The role ~"" + popup_return.items[1] + "~" already exists but is disabled.  Do you wish to enable this role?")
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then
				popup_return.item_count = 0
				closewithreturn(this, popup_return)
			end if
			UPDATE c_Role
			SET status = 'OK'
			WHERE role_id = :role_id;
			if not tf_check() then
				popup_return.item_count = 0
				closewithreturn(this, popup_return)
			end if
			
			li_sts = load_role(role_id)
			if li_sts <= 0 then
				log.log(this, "w_role_definition:post", "Invalid Role ID (" + popup.item + ")", 4)
				popup_return.item_count = 0
				closewithreturn(this, popup_return)
			end if
		end if
	elseif ll_count > 1 then
		openwithparm(w_pop_message, "The role ~"" + popup_return.items[1] + "~" already exists")
		popup_return.item_count = 0
		closewithreturn(this, popup_return)
	else
		sle_role_name.text = popup_return.items[1]
	end if
else
	li_sts = load_role(role_id)
	if li_sts <= 0 then
		log.log(this, "w_role_definition:post", "Invalid Role ID (" + popup.item + ")", 4)
		popup_return.item_count = 0
		closewithreturn(this, popup_return)
	end if
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_role_definition
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_role_definition
end type

type sle_role_name from singlelineedit within w_role_definition
integer x = 983
integer y = 292
integer width = 960
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
end type

type st_color from statictext within w_role_definition
integer x = 983
integer y = 564
integer width = 960
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;ole_dialogs.object.color = backcolor
ole_dialogs.object.showcolor()
backcolor = ole_dialogs.object.color


end event

type st_2 from statictext within w_role_definition
integer x = 983
integer y = 212
integer width = 960
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Role Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_role_definition
integer x = 983
integer y = 488
integer width = 960
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Color"
alignment alignment = center!
boolean focusrectangle = false
end type

type ole_dialogs from olecustomcontrol within w_role_definition
boolean visible = false
integer x = 1435
integer y = 1676
integer width = 146
integer height = 128
integer taborder = 20
boolean bringtotop = true
long backcolor = 16777215
string binarykey = "w_role_definition.win"
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

type st_title from statictext within w_role_definition
integer width = 2926
integer height = 164
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Role Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type mle_description from multilineedit within w_role_definition
integer x = 375
integer y = 844
integer width = 2121
integer height = 360
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

type st_description_title from statictext within w_role_definition
integer x = 366
integer y = 768
integer width = 411
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_role_definition
integer x = 2459
integer y = 1664
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

event clicked;integer li_sts
str_popup_return popup_return

li_sts = save_role()
if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = role_id
popup_return.descriptions[1] = sle_role_name.text
closewithreturn(parent, popup_return)


end event

type cb_cancel from commandbutton within w_role_definition
integer x = 59
integer y = 1664
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
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_status_title from statictext within w_role_definition
integer x = 1198
integer y = 1288
integer width = 530
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_status from statictext within w_role_definition
integer x = 1198
integer y = 1364
integer width = 530
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Enabled"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if lower(text) = "enabled" then
	text = "Disabled"
else
	text = "Enabled"
end if

end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
07w_role_definition.bin 
2100000c00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000916db74001c8d0af00000003000001800000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000480000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000020000004c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a000000020000000100000004f9043c85101af6f20008c9a3fb492f2b00000000916db74001c8d0af916db74001c8d0af00000000000000000000000000000001fffffffe00000003fffffffe00000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff003800320034004300380043003000320034002d00310030002d004100300031004200310041002d00430033002d00390038003000300030004200320046003200390034004200460000000000000000640a1981000000000000000000000001000000010000000100000001000000000000000000000000000000000000000012344321000000080000034f0000034ff9043c86000600000000000000000020000000000000000000000000000001040000000100000000000000000000000141000000000000000000000000000001000000010000000100000001000000000000000000000000000000000000000000000000000000000130e8040080008012344321000000080000034f0000034ff9043c86000600000000000000000020000000000000000000000000000001040000000100000000000000000000000141000000000000000000000000000000000000000000000000000000000000000000000000000000012cf0ec0140003000a2000e010c0135006b158c005e16085400000b00000000000000010000000000000000000000060000000000000000990a30c300000000000000000000000100000001000000010000000100000000000000000000000000000000000000000000000000000000012cf19c0070008000b0000a01100047070439b00704440000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000040000004c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17w_role_definition.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
