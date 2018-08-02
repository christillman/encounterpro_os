$PBExportHeader$w_drug_manual_edit.srw
forward
global type w_drug_manual_edit from window
end type
type cb_ok from commandbutton within w_drug_manual_edit
end type
type cb_cancel from commandbutton within w_drug_manual_edit
end type
type st_prefix from statictext within w_drug_manual_edit
end type
type st_chars from statictext within w_drug_manual_edit
end type
type st_page from statictext within w_drug_manual_edit
end type
type pb_up from picturebutton within w_drug_manual_edit
end type
type pb_down from picturebutton within w_drug_manual_edit
end type
type st_canned_title from statictext within w_drug_manual_edit
end type
type dw_canned from u_dw_pick_list within w_drug_manual_edit
end type
type sle_string from singlelineedit within w_drug_manual_edit
end type
type st_prompt from statictext within w_drug_manual_edit
end type
type st_max_length from statictext within w_drug_manual_edit
end type
end forward

global type w_drug_manual_edit from window
integer x = 402
integer y = 232
integer width = 2734
integer height = 1372
windowtype windowtype = response!
long backcolor = 33538240
cb_ok cb_ok
cb_cancel cb_cancel
st_prefix st_prefix
st_chars st_chars
st_page st_page
pb_up pb_up
pb_down pb_down
st_canned_title st_canned_title
dw_canned dw_canned
sle_string sle_string
st_prompt st_prompt
st_max_length st_max_length
end type
global w_drug_manual_edit w_drug_manual_edit

type variables
string top_20_code_1
string top_20_code_2
boolean canned_update = false
boolean allow_empty = false

integer max_length

end variables

event open;// Parameters (popup.):
// title					Screen title/user instructions
// item					Default string value
//	data_row_count		Number of items in the canned selections list
// items[]				list of canned selections
// argument_count		Number of top_20 arguments supplied
// argument[]			List of top_20 arguments
//							argument[1] = specific top_20_code
//							argument[2] = generic top_20_code
// multiselect			True = Allow empty string
//							False = Don't allow empty string
//

str_popup popup
long ll_row
long ll_rows
integer i 
long ll_count
string ls_find
long ll_pos
str_popup_return popup_return


if cpr_mode = "SERVER" then
	setnull(popup_return.item)
	popup_return.item_count = 0
	closewithreturn(this, popup_return)
	return
end if

popup = message.powerobjectparm

allow_empty = popup.multiselect

st_prompt.text = popup.title
st_prefix.text = popup.dataobject

if not isnull(popup.item) and trim(popup.item) <> "" then
	sle_string.text = popup.item
	sle_string.selecttext(1, len(sle_string.text))
end if

setnull(top_20_code_1)
setnull(top_20_code_2)

if popup.data_row_count > 0 then
	canned_update = false
	for i = 1 to popup.data_row_count
		ll_row = dw_canned.insertrow(0)
		dw_canned.object.item_text[ll_row] = popup.items[i]
	next
elseif popup.argument_count > 0 then
	canned_update = true
	top_20_code_1 = popup.argument[1]
	if isnull(top_20_code_1) then
		log.log(this, "w_drug_manual_edit.open.0056", "top_20_code_1 is NULL", 3)
		top_20_code_1 = ""
	end if

	if popup.argument_count = 1 then
		top_20_code_2 = ""
	else
		if isnull(popup.argument[2]) then
			top_20_code_2 = ""
		else
			top_20_code_2 = popup.argument[2]
		end if
	end if
	
	dw_canned.settransobject(sqlca)
	ll_count = dw_canned.retrieve(current_user.user_id, top_20_code_1, top_20_code_2)
end if

if dw_canned.rowcount() <= 0 then
	dw_canned.visible = false
	st_canned_title.visible = false
	st_page.visible = false
	pb_up.visible = false
	pb_down.visible = false
	cb_cancel.y = dw_canned.y
	cb_ok.y = dw_canned.y
	height = cb_cancel.y + cb_cancel.height + 50
else
	// Eliminate duplicates
	ll_rows = dw_canned.rowcount()
	for i = 2 to ll_rows
		ll_pos = pos(dw_canned.object.item_text[i], '"')
		if ll_pos > 0 then continue
		ls_find = 'item_text="' + f_string_substitute(string(dw_canned.object.item_text[i]), "~~", "~~~~") + '"'
		ll_row = dw_canned.find(ls_find, 1, i - 1)
		if ll_row > 0 then
			dw_canned.deleterow(i)
			ll_rows -= 1
			i -= 1
		end if
	next
	dw_canned.set_page(1, st_page.text)
	if dw_canned.last_page <= 1 then
		st_page.visible = false
		pb_up.visible = false
		pb_down.visible = false
	else
		st_page.visible = true
		pb_up.visible = true
		pb_down.visible = true
		pb_up.enabled = false
		pb_down.enabled = true
	end if
end if

height = cb_cancel.y + cb_cancel.height + 50

max_length = popup.displaycolumn

if max_length > 0 then
	st_max_length.text = "Max Length = " + string(max_length) + " Characters"
else
	st_max_length.visible = false
	st_chars.visible = false
end if


sle_string.setfocus()


end event

on w_drug_manual_edit.create
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_prefix=create st_prefix
this.st_chars=create st_chars
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_canned_title=create st_canned_title
this.dw_canned=create dw_canned
this.sle_string=create sle_string
this.st_prompt=create st_prompt
this.st_max_length=create st_max_length
this.Control[]={this.cb_ok,&
this.cb_cancel,&
this.st_prefix,&
this.st_chars,&
this.st_page,&
this.pb_up,&
this.pb_down,&
this.st_canned_title,&
this.dw_canned,&
this.sle_string,&
this.st_prompt,&
this.st_max_length}
end on

on w_drug_manual_edit.destroy
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_prefix)
destroy(this.st_chars)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_canned_title)
destroy(this.dw_canned)
destroy(this.sle_string)
destroy(this.st_prompt)
destroy(this.st_max_length)
end on

type cb_ok from commandbutton within w_drug_manual_edit
integer x = 2258
integer y = 1196
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;long ll_hits
integer li_sts
str_popup_return popup_return

popup_return.item = trim(sle_string.text)
popup_return.items[1] = popup_return.item
popup_return.descriptions[1] = popup_return.item
popup_return.item_count = 1

if isnull(popup_return.item) then popup_return.item = ""

if popup_return.item = "" and not allow_empty then
	openwithparm(w_pop_message, "Please enter a value")
	return
end if

if canned_update and popup_return.item <> "" then
	li_sts = f_update_pick_lists(top_20_code_1, top_20_code_2, popup_return.item)
end if

closewithreturn(parent, popup_return)

end event

type cb_cancel from commandbutton within w_drug_manual_edit
integer x = 73
integer y = 1196
integer width = 402
integer height = 112
integer taborder = 30
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

setnull(popup_return.item)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_prefix from statictext within w_drug_manual_edit
integer x = 73
integer y = 240
integer width = 923
integer height = 96
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_chars from statictext within w_drug_manual_edit
integer x = 2258
integer y = 332
integer width = 402
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "999 Characters"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_page from statictext within w_drug_manual_edit
integer x = 1929
integer y = 400
integer width = 297
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_up from picturebutton within w_drug_manual_edit
integer x = 1929
integer y = 472
integer width = 137
integer height = 116
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
alignment htextalign = left!
end type

event clicked;
dw_canned.set_page(dw_canned.current_page - 1, st_page.text)
pb_down.enabled = true

if dw_canned.current_page <= 1 then
	enabled = false
else
	enabled = true
end if

end event

type pb_down from picturebutton within w_drug_manual_edit
integer x = 1929
integer y = 596
integer width = 137
integer height = 116
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
alignment htextalign = left!
end type

event clicked;dw_canned.set_page(dw_canned.current_page + 1, st_page.text)
pb_up.enabled = true

if dw_canned.current_page >= dw_canned.last_page then
	enabled = false
else
	enabled = true
end if

end event

type st_canned_title from statictext within w_drug_manual_edit
integer x = 690
integer y = 400
integer width = 1243
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Previous Selections"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_canned from u_dw_pick_list within w_drug_manual_edit
integer x = 690
integer y = 464
integer width = 1243
integer height = 848
integer taborder = 11
string dataobject = "dw_top_20_phrases"
boolean border = false
end type

event selected;call super::selected;
sle_string.text = object.item_text[selected_row]

cb_ok.postevent("clicked")

end event

type sle_string from singlelineedit within w_drug_manual_edit
integer x = 997
integer y = 236
integer width = 1664
integer height = 96
integer taborder = 1
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event other;integer li_len

if max_length > 0 then
	li_len = len(text)
	
	if li_len > max_length then
		text = left(text, max_length)
		beep(1)
		selecttext(max_length, 0)
	end if
	
	st_chars.text = string(len(text)) + " Characters"
end if

end event

type st_prompt from statictext within w_drug_manual_edit
integer x = 73
integer y = 32
integer width = 2587
integer height = 184
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
boolean focusrectangle = false
end type

type st_max_length from statictext within w_drug_manual_edit
integer x = 997
integer y = 332
integer width = 713
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Max Length = 999 Characters"
boolean focusrectangle = false
end type

