HA$PBExportHeader$w_menu_edit.srw
forward
global type w_menu_edit from w_window_base
end type
type sle_menu from singlelineedit within w_menu_edit
end type
type st_specialty from statictext within w_menu_edit
end type
type st_context_object from statictext within w_menu_edit
end type
type st_menu_description_title from statictext within w_menu_edit
end type
type st_specialty_title from statictext within w_menu_edit
end type
type st_context_object_title from statictext within w_menu_edit
end type
type dw_menu_items from u_dw_pick_list within w_menu_edit
end type
type st_5 from statictext within w_menu_edit
end type
type pb_up from u_picture_button within w_menu_edit
end type
type pb_down from u_picture_button within w_menu_edit
end type
type st_page from statictext within w_menu_edit
end type
type st_title from statictext within w_menu_edit
end type
type cb_edit from commandbutton within w_menu_edit
end type
type cb_move from commandbutton within w_menu_edit
end type
type cb_delete from commandbutton within w_menu_edit
end type
type cb_new from commandbutton within w_menu_edit
end type
type cb_ok from commandbutton within w_menu_edit
end type
type st_menu_category_title from statictext within w_menu_edit
end type
type st_menu_category from statictext within w_menu_edit
end type
end forward

global type w_menu_edit from w_window_base
string title = "Menu"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
sle_menu sle_menu
st_specialty st_specialty
st_context_object st_context_object
st_menu_description_title st_menu_description_title
st_specialty_title st_specialty_title
st_context_object_title st_context_object_title
dw_menu_items dw_menu_items
st_5 st_5
pb_up pb_up
pb_down pb_down
st_page st_page
st_title st_title
cb_edit cb_edit
cb_move cb_move
cb_delete cb_delete
cb_new cb_new
cb_ok cb_ok
st_menu_category_title st_menu_category_title
st_menu_category st_menu_category
end type
global w_menu_edit w_menu_edit

type variables
string specialty_id
string context_object
string menu_category
long menu_id

boolean display_only

end variables

forward prototypes
public function integer save_menu ()
end prototypes

public function integer save_menu ();
UPDATE c_Menu
SET description = :sle_menu.text,
	specialty_id = :specialty_id,
	context_object = :context_object,
	menu_category = :menu_category
WHERE menu_id = :menu_id;
if not tf_check() then return -1

datalist.clear_cache("menus")

return 1

end function

on w_menu_edit.create
int iCurrent
call super::create
this.sle_menu=create sle_menu
this.st_specialty=create st_specialty
this.st_context_object=create st_context_object
this.st_menu_description_title=create st_menu_description_title
this.st_specialty_title=create st_specialty_title
this.st_context_object_title=create st_context_object_title
this.dw_menu_items=create dw_menu_items
this.st_5=create st_5
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_title=create st_title
this.cb_edit=create cb_edit
this.cb_move=create cb_move
this.cb_delete=create cb_delete
this.cb_new=create cb_new
this.cb_ok=create cb_ok
this.st_menu_category_title=create st_menu_category_title
this.st_menu_category=create st_menu_category
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_menu
this.Control[iCurrent+2]=this.st_specialty
this.Control[iCurrent+3]=this.st_context_object
this.Control[iCurrent+4]=this.st_menu_description_title
this.Control[iCurrent+5]=this.st_specialty_title
this.Control[iCurrent+6]=this.st_context_object_title
this.Control[iCurrent+7]=this.dw_menu_items
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.pb_up
this.Control[iCurrent+10]=this.pb_down
this.Control[iCurrent+11]=this.st_page
this.Control[iCurrent+12]=this.st_title
this.Control[iCurrent+13]=this.cb_edit
this.Control[iCurrent+14]=this.cb_move
this.Control[iCurrent+15]=this.cb_delete
this.Control[iCurrent+16]=this.cb_new
this.Control[iCurrent+17]=this.cb_ok
this.Control[iCurrent+18]=this.st_menu_category_title
this.Control[iCurrent+19]=this.st_menu_category
end on

on w_menu_edit.destroy
call super::destroy
destroy(this.sle_menu)
destroy(this.st_specialty)
destroy(this.st_context_object)
destroy(this.st_menu_description_title)
destroy(this.st_specialty_title)
destroy(this.st_context_object_title)
destroy(this.dw_menu_items)
destroy(this.st_5)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_title)
destroy(this.cb_edit)
destroy(this.cb_move)
destroy(this.cb_delete)
destroy(this.cb_new)
destroy(this.cb_ok)
destroy(this.st_menu_category_title)
destroy(this.st_menu_category)
end on

event open;call super::open;string ls_description
str_menu	lstr_menu

menu_id = message.doubleparm

SELECT description, specialty_id, context_object, menu_category
INTO :sle_menu.text, :specialty_id, :context_object, :menu_category
FROM c_Menu
WHERE menu_id = :menu_id;
if not tf_check() then
	close(this)
	return
end if
if sqlca.sqlcode = 100 then
	log.log(this, "open", "menu_id not found (" + string(menu_id) + ")", 4)
	close(this)
	return
end if

dw_menu_items.settransobject(sqlca)
dw_menu_items.retrieve(menu_id)
dw_menu_items.set_page(1, pb_up, pb_down, st_page)

postevent("post_open")


end event

event post_open;call super::post_open;
st_specialty.text = datalist.specialty_description(specialty_id)
st_context_object.text = wordcap(lower(context_object	))
st_menu_category.text = menu_category

sle_menu.setfocus()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_menu_edit
boolean visible = true
integer y = 16
integer width = 256
integer height = 128
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_menu_edit
end type

type sle_menu from singlelineedit within w_menu_edit
integer x = 526
integer y = 140
integer width = 2267
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 80
borderstyle borderstyle = stylelowered!
end type

type st_specialty from statictext within w_menu_edit
integer x = 2007
integer y = 280
integer width = 786
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_specialty_id

ls_specialty_id = f_pick_specialty("<None>")
if isnull(ls_specialty_id) then return

if ls_specialty_id = "<None>" then
	text = "<None>"
	setnull(specialty_id)
else
	text = datalist.specialty_description(ls_specialty_id)
	specialty_id = ls_specialty_id
end if
end event

type st_context_object from statictext within w_menu_edit
integer x = 530
integer y = 276
integer width = 613
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Assessment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup			popup
str_popup_return popup_return

// get the service type
popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "CONTEXT_OBJECT"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

context_object = popup_return.items[1]

text = wordcap(lower(context_object))

save_menu()

end event

type st_menu_description_title from statictext within w_menu_edit
integer x = 73
integer y = 160
integer width = 434
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Menu Name:"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_specialty_title from statictext within w_menu_edit
integer x = 1682
integer y = 300
integer width = 302
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Specialty:"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_context_object_title from statictext within w_menu_edit
integer x = 69
integer y = 300
integer width = 439
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Menu Context:"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_menu_items from u_dw_pick_list within w_menu_edit
integer x = 123
integer y = 536
integer width = 1815
integer height = 1144
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_sp_get_menu_items"
boolean border = false
end type

event selected;call super::selected;cb_edit.enabled = true
cb_move.enabled = true
cb_delete.enabled = true

end event

event unselected;call super::unselected;cb_edit.enabled = false
cb_move.enabled = false
cb_delete.enabled = false

end event

type st_5 from statictext within w_menu_edit
integer x = 123
integer y = 468
integer width = 1801
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Menu Items"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_menu_edit
integer x = 1934
integer y = 544
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_menu_items.current_page

dw_menu_items.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_menu_edit
integer x = 1934
integer y = 668
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_menu_items.current_page
li_last_page = dw_menu_items.last_page

dw_menu_items.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_menu_edit
integer x = 2071
integer y = 544
integer width = 274
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_menu_edit
integer width = 2930
integer height = 128
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Menu Properties"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_edit from commandbutton within w_menu_edit
integer x = 2240
integer y = 700
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
boolean enabled = false
string text = "Edit"
end type

event clicked;str_menu_item lstr_menu_item
long ll_row
w_edit_menu_item lw_edit

ll_row = dw_menu_items.get_selected_row()
if ll_row <= 0 then return

lstr_menu_item.menu_id = dw_menu_items.object.menu_id[ll_row]
lstr_menu_item.menu_item_id = dw_menu_items.object.menu_item_id[ll_row]
lstr_menu_item.menu_item_type = dw_menu_items.object.menu_item_type[ll_row]
lstr_menu_item.menu_item = dw_menu_items.object.menu_item[ll_row]
lstr_menu_item.context_object = dw_menu_items.object.context_object[ll_row]
lstr_menu_item.button_title = dw_menu_items.object.button_title[ll_row]
lstr_menu_item.button_help = dw_menu_items.object.button_help[ll_row]
lstr_menu_item.button = dw_menu_items.object.button[ll_row]
lstr_menu_item.sort_sequence = dw_menu_items.object.sort_sequence[ll_row]
lstr_menu_item.auto_close_flag = dw_menu_items.object.auto_close_flag[ll_row]
lstr_menu_item.authorized_user_id = dw_menu_items.object.authorized_user_id[ll_row]
lstr_menu_item.menu_item_description = dw_menu_items.object.menu_item_description[ll_row]
lstr_menu_item.id = dw_menu_items.object.id[ll_row]

openwithparm(lw_edit, lstr_menu_item, "w_edit_menu_item")
lstr_menu_item = message.powerobjectparm

dw_menu_items.object.menu_item_type[ll_row] = lstr_menu_item.menu_item_type
dw_menu_items.object.menu_item[ll_row] = lstr_menu_item.menu_item
dw_menu_items.object.context_object[ll_row] = lstr_menu_item.context_object
dw_menu_items.object.button_title[ll_row] = lstr_menu_item.button_title
dw_menu_items.object.button_help[ll_row] = lstr_menu_item.button_help
dw_menu_items.object.button[ll_row] = lstr_menu_item.button
dw_menu_items.object.auto_close_flag[ll_row] = lstr_menu_item.auto_close_flag
dw_menu_items.object.authorized_user_id[ll_row] = lstr_menu_item.authorized_user_id
dw_menu_items.setitemstatus(ll_row, 0, Primary!, NotModified!)


end event

type cb_move from commandbutton within w_menu_edit
integer x = 2240
integer y = 832
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
boolean enabled = false
string text = "Move"
end type

event clicked;str_popup popup
long ll_row
integer li_sts
long ll_rowcount
long i

ll_row = dw_menu_items.get_selected_row()
if ll_row <= 0 then return 0

ll_rowcount = dw_menu_items.rowcount()
for i = 1 to ll_rowcount
	dw_menu_items.object.sort_sequence[ll_row] = i
next

popup.objectparm = dw_menu_items

openwithparm(w_pick_list_sort, popup)

li_sts = dw_menu_items.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Sort update failed")
	return
end if

return


end event

type cb_delete from commandbutton within w_menu_edit
integer x = 2240
integer y = 964
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
boolean enabled = false
string text = "Delete"
end type

event clicked;str_popup_return popup_return
long ll_row
integer li_sts

ll_row = dw_menu_items.get_selected_row()
if ll_row <= 0 then return

openwithparm(w_pop_yes_no, "Are you sure you want to delete the selected menu item?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	dw_menu_items.deleterow(ll_row)
end if

li_sts = dw_menu_items.update()

return

end event

type cb_new from commandbutton within w_menu_edit
integer x = 2240
integer y = 1184
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
string text = "New"
end type

event clicked;str_menu_item lstr_menu_item
long ll_row
w_edit_menu_item lw_edit
integer li_sts

lstr_menu_item.menu_id = menu_id
setnull(lstr_menu_item.menu_item_id)
setnull(lstr_menu_item.menu_item_type)
setnull(lstr_menu_item.menu_item)
setnull(lstr_menu_item.button_title)
setnull(lstr_menu_item.button_help)
setnull(lstr_menu_item.button)
setnull(lstr_menu_item.authorized_user_id)
lstr_menu_item.auto_close_flag = "N"
lstr_menu_item.sort_sequence = dw_menu_items.rowcount() + 1
setnull(lstr_menu_item.menu_item_description)

openwithparm(lw_edit, lstr_menu_item, "w_edit_menu_item")
lstr_menu_item = message.powerobjectparm

if isnull(lstr_menu_item.menu_item_type) or isnull(lstr_menu_item.menu_item) then return

dw_menu_items.retrieve(menu_id)
dw_menu_items.set_page(1, pb_up, pb_down, st_page)
dw_menu_items.set_page(dw_menu_items.last_page, pb_up, pb_down, st_page)

end event

type cb_ok from commandbutton within w_menu_edit
integer x = 2327
integer y = 1572
integer width = 503
integer height = 112
integer taborder = 21
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

if isnull(sle_menu.text) or trim(sle_menu.text) = "" then
	openwithparm(w_pop_message, "You must enter a menu description")
	return
end if


li_sts = save_menu()
if li_sts < 0 then
	openwithparm(w_pop_message, "An error occured when saving the menu settings")
end if

close(parent)

end event

type st_menu_category_title from statictext within w_menu_edit
integer x = 1682
integer y = 432
integer width = 302
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Category:"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_menu_category from statictext within w_menu_edit
integer x = 2007
integer y = 412
integer width = 786
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup			popup
str_popup_return popup_return

// get the service type
popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "Menu Category"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

menu_category = popup_return.items[1]

text = menu_category


end event

