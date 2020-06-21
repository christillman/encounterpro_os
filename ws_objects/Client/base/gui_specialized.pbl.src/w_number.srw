$PBExportHeader$w_number.srw
forward
global type w_number from window
end type
type cb_space from commandbutton within w_number
end type
type st_title from statictext within w_number
end type
type pb_down from picturebutton within w_number
end type
type pb_up from picturebutton within w_number
end type
type st_page from statictext within w_number
end type
type cb_negate from commandbutton within w_number
end type
type st_number from statictext within w_number
end type
type st_unit from statictext within w_number
end type
type pb_cancel from u_picture_button within w_number
end type
type pb_done from u_picture_button within w_number
end type
type cb_clear from commandbutton within w_number
end type
type cb_dot from commandbutton within w_number
end type
type cb_10 from commandbutton within w_number
end type
type cb_7 from commandbutton within w_number
end type
type cb_8 from commandbutton within w_number
end type
type cb_9 from commandbutton within w_number
end type
type cb_4 from commandbutton within w_number
end type
type cb_5 from commandbutton within w_number
end type
type cb_6 from commandbutton within w_number
end type
type cb_3 from commandbutton within w_number
end type
type cb_2 from commandbutton within w_number
end type
type cb_1 from commandbutton within w_number
end type
type dw_canned from u_dw_pick_list within w_number
end type
end forward

global type w_number from window
integer x = 306
integer y = 284
integer width = 2391
integer height = 1348
windowtype windowtype = response!
long backcolor = 33538240
cb_space cb_space
st_title st_title
pb_down pb_down
pb_up pb_up
st_page st_page
cb_negate cb_negate
st_number st_number
st_unit st_unit
pb_cancel pb_cancel
pb_done pb_done
cb_clear cb_clear
cb_dot cb_dot
cb_10 cb_10
cb_7 cb_7
cb_8 cb_8
cb_9 cb_9
cb_4 cb_4
cb_5 cb_5
cb_6 cb_6
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
dw_canned dw_canned
end type
global w_number w_number

type variables
boolean decimal
boolean first_time
boolean editunit
u_unit unit
real amount

string top_20_code_1
string top_20_code_2
boolean canned_update = false

integer unit_id_count
string unit_id_list[]

end variables

forward prototypes
public subroutine pick_unit ()
public subroutine add_digit (string ps_digit)
end prototypes

public subroutine pick_unit ();str_popup popup
str_popup_return popup_return
u_unit luo_unit
real lr_new_amount
string ls_old_unit, ls_new_unit
integer li_sts
integer i

IF IsNull(unit) OR NOT IsValid(unit) THEN RETURN

ls_old_unit = unit.unit_id

if unit_id_count = 1 then
	return
elseif unit_id_count > 1 then
	popup.data_row_count = unit_id_count
	for i = 1 to unit_id_count
		popup.items[i] = unit_list.unit_description(unit_id_list[i])
	next
else
	popup.argument_count = 1
	popup.argument[1] = unit.unit_id
	popup.dataobject = "dw_convertable_units"
	popup.displaycolumn = 2
	popup.datacolumn = 1
end if

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if unit_id_count > 0 then
	ls_new_unit = unit_id_list[popup_return.item_indexes[1]]
else
	ls_new_unit = popup_return.items[1]
end if

luo_unit = unit_list.find_unit(ls_new_unit)
if isnull(luo_unit) then return

if luo_unit.unit_id = unit.unit_id then return

unit = luo_unit

st_unit.text = unit.description

if first_time then
	li_sts = f_unit_convert(amount, ls_old_unit, ls_new_unit, lr_new_amount)
	if li_sts > 0 then
		amount = lr_new_amount
		st_number.text = f_pretty_amount(lr_new_amount, ls_new_unit, luo_unit)
	end if
end if


end subroutine

public subroutine add_digit (string ps_digit);string ls_left, ls_right

if isnull(st_number.text) or first_time then st_number.text = ""
first_time = false

f_split_string(st_number.text, decimal_character, ls_left, ls_right)

if decimal then
	ls_right += ps_digit
else
	ls_left += ps_digit
end if

if len(ls_right) > 0 then
	st_number.text = ls_left + decimal_character + ls_right
else
	st_number.text = ls_left
end if

pb_done.setfocus()

end subroutine

event open;str_popup popup
long ll_row
long ll_rows
integer i
long ll_count
string ls_find

decimal = false

popup = message.powerobjectparm

unit = popup.objectparm
if not isnull(unit) and isvalid(unit) then
	if unit.print_unit = "Y" then st_unit.text = unit.description
	if unit.multiplier > 0 then
		cb_space.visible = true
	end if
end if

amount = popup.realitem

unit_id_count = popup.data_row_count
unit_id_list = popup.items

st_number.text = f_pretty_amount(amount, "", unit)
if isnull(st_number.text) then st_number.text = ""

if popup.item = "EDITUNIT" then
	st_unit.backcolor = color_object
	st_unit.border = true
	st_unit.borderstyle = StyleRaised!
	st_unit.enabled = true
	editunit = true
else
	st_unit.backcolor = this.backcolor
	st_unit.border = false
	st_unit.enabled = false
	editunit = false
end if

first_time = true

cb_dot.visible = not popup.numeric_argument
cb_negate.visible = not popup.multiselect

setnull(top_20_code_1)
setnull(top_20_code_2)

canned_update = false

//if popup.data_row_count > 0 then
//	for i = 1 to popup.data_row_count
//		ll_row = dw_canned.insertrow(0)
//		dw_canned.object.item_text[ll_row] = popup.items[i]
//	next
//elseif popup.argument_count > 0 then
if popup.argument_count > 0 then
	canned_update = true
	top_20_code_1 = popup.argument[1]
	if popup.argument_count = 1 then
		top_20_code_2 = ""
	else
		top_20_code_2 = popup.argument[2]
	end if
	
	dw_canned.settransobject(sqlca)
	ll_count = dw_canned.retrieve(current_user.user_id, top_20_code_1, top_20_code_2)
end if

if dw_canned.rowcount() <= 0 then
	dw_canned.visible = false
	st_page.visible = false
	pb_up.visible = false
	pb_down.visible = false
	// pb_done.x = 1513
	// width = 1911
else
	// Eliminate duplicates
	ll_rows = dw_canned.rowcount()
	for i = 2 to ll_rows
		ls_find = "item_text='" + dw_canned.object.item_text[i] + "'"
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
	
	// pb_done.x = 1915
	// width = 2263
end if

pb_cancel.x = pb_done.x
x = (2926 - width) / 2
y = (1832 - height) / 2

cb_dot.text = "&" + decimal_character

st_title.text = popup.title
st_title.width = width

pb_done.setfocus( )

end event

on w_number.create
this.cb_space=create cb_space
this.st_title=create st_title
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.cb_negate=create cb_negate
this.st_number=create st_number
this.st_unit=create st_unit
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
this.cb_clear=create cb_clear
this.cb_dot=create cb_dot
this.cb_10=create cb_10
this.cb_7=create cb_7
this.cb_8=create cb_8
this.cb_9=create cb_9
this.cb_4=create cb_4
this.cb_5=create cb_5
this.cb_6=create cb_6
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_canned=create dw_canned
this.Control[]={this.cb_space,&
this.st_title,&
this.pb_down,&
this.pb_up,&
this.st_page,&
this.cb_negate,&
this.st_number,&
this.st_unit,&
this.pb_cancel,&
this.pb_done,&
this.cb_clear,&
this.cb_dot,&
this.cb_10,&
this.cb_7,&
this.cb_8,&
this.cb_9,&
this.cb_4,&
this.cb_5,&
this.cb_6,&
this.cb_3,&
this.cb_2,&
this.cb_1,&
this.dw_canned}
end on

on w_number.destroy
destroy(this.cb_space)
destroy(this.st_title)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.cb_negate)
destroy(this.st_number)
destroy(this.st_unit)
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.cb_clear)
destroy(this.cb_dot)
destroy(this.cb_10)
destroy(this.cb_7)
destroy(this.cb_8)
destroy(this.cb_9)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.cb_6)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_canned)
end on

type cb_space from commandbutton within w_number
boolean visible = false
integer x = 91
integer y = 688
integer width = 366
integer height = 112
integer taborder = 70
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "& Space"
end type

event clicked;add_digit(" ")
end event

type st_title from statictext within w_number
integer x = 224
integer y = 24
integer width = 1911
integer height = 132
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down from picturebutton within w_number
integer x = 2062
integer y = 496
integer width = 137
integer height = 116
integer taborder = 50
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

type pb_up from picturebutton within w_number
integer x = 2062
integer y = 372
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

type st_page from statictext within w_number
integer x = 2062
integer y = 300
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

type cb_negate from commandbutton within w_number
event clicked pbm_bnclicked
integer x = 229
integer y = 848
integer width = 229
integer height = 192
integer taborder = 40
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&-/+"
end type

event clicked;string ls_minus

ls_minus = left(st_number.text, 1)
if ls_minus = "-" then
	st_number.text = mid(st_number.text, 2)
else
	st_number.text = "-" + st_number.text
end if

first_time = false

end event

type st_number from statictext within w_number
integer x = 114
integer y = 172
integer width = 1189
integer height = 112
integer textsize = -18
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = right!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_unit from statictext within w_number
integer x = 1339
integer y = 172
integer width = 1001
integer height = 112
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;pick_unit()

end event

type pb_cancel from u_picture_button within w_number
integer x = 1733
integer y = 800
integer width = 256
integer height = 224
integer taborder = 60
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

on clicked;call u_picture_button::clicked;str_popup_return popup_return

popup_return.item = "CANCEL"

closewithreturn(parent, popup_return)

end on

type pb_done from u_picture_button within w_number
integer x = 1733
integer y = 1064
integer width = 256
integer height = 224
integer taborder = 20
boolean default = true
string picturename = "button26.bmp"
string disabledname = "button26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
integer li_sts
string ls_value

if isnull(popup_return.realitem) then
	popup_return.item = "CANCEL"
	setnull(popup_return.realitem)
	setnull(popup_return.returnobject)
else
	popup_return.item = "OK"
	if cb_space.visible then
		ls_value = st_number.text
		li_sts = unit.check_value(ls_value)
		if li_sts < 0 then
			openwithparm(w_pop_message, "Value is not valid.  Please enter another value.")
			first_time = true
			return
		end if
		popup_return.realitem = real(ls_value)
		popup_return.rawdata = ls_value
	else
		popup_return.realitem = real(st_number.text)
		popup_return.rawdata = st_number.text
	end if
	popup_return.returnobject = unit
	
	if canned_update then
		li_sts = f_update_pick_lists(top_20_code_1, top_20_code_2, st_number.text)
	end if
end if



closewithreturn(parent, popup_return)

end event

type cb_clear from commandbutton within w_number
integer x = 229
integer y = 1088
integer width = 229
integer height = 192
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&C"
end type

on clicked;st_number.text = ""
decimal = false

pb_done.setfocus()

end on

type cb_dot from commandbutton within w_number
integer x = 1106
integer y = 1088
integer width = 229
integer height = 192
integer textsize = -16
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&."
end type

event clicked;if isnull(st_number.text) or first_time then st_number.text = ""
first_time = false

if not decimal then
	decimal = true
	if right(st_number.text, 1) <> decimal_character then st_number.text += decimal_character
end if

pb_done.setfocus()

end event

type cb_10 from commandbutton within w_number
integer x = 521
integer y = 1088
integer width = 521
integer height = 192
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&0"
end type

on clicked;add_digit("0")

end on

type cb_7 from commandbutton within w_number
integer x = 521
integer y = 368
integer width = 229
integer height = 192
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&7"
end type

on clicked;add_digit("7")

end on

type cb_8 from commandbutton within w_number
integer x = 814
integer y = 368
integer width = 229
integer height = 192
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&8"
end type

on clicked;add_digit("8")

end on

type cb_9 from commandbutton within w_number
integer x = 1106
integer y = 368
integer width = 229
integer height = 192
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&9"
end type

on clicked;add_digit("9")

end on

type cb_4 from commandbutton within w_number
integer x = 521
integer y = 608
integer width = 229
integer height = 192
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&4"
end type

on clicked;add_digit("4")

end on

type cb_5 from commandbutton within w_number
integer x = 814
integer y = 608
integer width = 229
integer height = 192
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&5"
end type

on clicked;add_digit("5")

end on

type cb_6 from commandbutton within w_number
integer x = 1106
integer y = 608
integer width = 229
integer height = 192
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&6"
end type

on clicked;add_digit("6")

end on

type cb_3 from commandbutton within w_number
integer x = 1106
integer y = 848
integer width = 229
integer height = 192
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&3"
end type

on clicked;add_digit("3")

end on

type cb_2 from commandbutton within w_number
integer x = 814
integer y = 848
integer width = 229
integer height = 192
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&2"
end type

on clicked;add_digit("2")

end on

type cb_1 from commandbutton within w_number
integer x = 521
integer y = 848
integer width = 229
integer height = 192
integer textsize = -16
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&1"
end type

on clicked;add_digit("1")

end on

type dw_canned from u_dw_pick_list within w_number
integer x = 1609
integer y = 364
integer width = 453
integer height = 848
integer taborder = 30
string dataobject = "dw_top_20_phrases_short"
boolean border = false
end type

event selected;call super::selected;st_number.text = object.item_text[selected_row]
pb_done.postevent("clicked")

end event

