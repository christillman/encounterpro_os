$PBExportHeader$w_authority_categories_edit.srw
forward
global type w_authority_categories_edit from w_window_base
end type
type pb_done from u_picture_button within w_authority_categories_edit
end type
type pb_cancel from u_picture_button within w_authority_categories_edit
end type
type st_title from statictext within w_authority_categories_edit
end type
type dw_authority_categories from u_dw_pick_list within w_authority_categories_edit
end type
type cb_page from commandbutton within w_authority_categories_edit
end type
type cb_new from commandbutton within w_authority_categories_edit
end type
type cb_delete from commandbutton within w_authority_categories_edit
end type
type cb_move_up from commandbutton within w_authority_categories_edit
end type
type cb_move_down from commandbutton within w_authority_categories_edit
end type
type cb_sort from commandbutton within w_authority_categories_edit
end type
end forward

global type w_authority_categories_edit from w_window_base
integer x = 0
integer y = 0
integer height = 1832
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_title st_title
dw_authority_categories dw_authority_categories
cb_page cb_page
cb_new cb_new
cb_delete cb_delete
cb_move_up cb_move_up
cb_move_down cb_move_down
cb_sort cb_sort
end type
global w_authority_categories_edit w_authority_categories_edit

type variables
string authority_id
string authority_type
string authority_category


end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer li_sts

li_sts = dw_authority_categories.retrieve(authority_type)
if li_sts < 0 then return -1

dw_authority_categories.set_page(1, cb_page.text)

cb_move_down.enabled = false
cb_move_up.enabled = false
cb_delete.enabled = false

Return 1



end function

event open;call super::open;authority_type = message.stringparm
if isnull(authority_type) then
	log.log(this,"w_authority_categories_edit:open","authority type is not valid",4)
	Close(this)
	Return
end if
dw_authority_categories.settransobject(sqlca)
refresh()

end event

on w_authority_categories_edit.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_title=create st_title
this.dw_authority_categories=create dw_authority_categories
this.cb_page=create cb_page
this.cb_new=create cb_new
this.cb_delete=create cb_delete
this.cb_move_up=create cb_move_up
this.cb_move_down=create cb_move_down
this.cb_sort=create cb_sort
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.dw_authority_categories
this.Control[iCurrent+5]=this.cb_page
this.Control[iCurrent+6]=this.cb_new
this.Control[iCurrent+7]=this.cb_delete
this.Control[iCurrent+8]=this.cb_move_up
this.Control[iCurrent+9]=this.cb_move_down
this.Control[iCurrent+10]=this.cb_sort
end on

on w_authority_categories_edit.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_title)
destroy(this.dw_authority_categories)
destroy(this.cb_page)
destroy(this.cb_new)
destroy(this.cb_delete)
destroy(this.cb_move_up)
destroy(this.cb_move_down)
destroy(this.cb_sort)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_authority_categories_edit
end type

type pb_done from u_picture_button within w_authority_categories_edit
integer x = 2569
integer y = 1532
integer taborder = 0
boolean default = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)


end event

type pb_cancel from u_picture_button within w_authority_categories_edit
boolean visible = false
integer x = 1614
integer y = 1524
integer taborder = 0
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_title from statictext within w_authority_categories_edit
integer width = 2528
integer height = 104
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Authority Categories For "
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_authority_categories from u_dw_pick_list within w_authority_categories_edit
integer y = 112
integer width = 1243
integer height = 1668
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_authority_category_pick_list"
boolean border = false
end type

event selected;if selected_row < rowcount() then
	cb_move_down.enabled = true
else
	cb_move_down.enabled = false
end if

if selected_row > 1 then
	cb_move_up.enabled = true
else
	cb_move_up.enabled = false
end if

cb_delete.enabled = true

end event

event unselected;cb_move_down.enabled = false
cb_move_up.enabled = false
cb_delete.enabled = false

end event

type cb_page from commandbutton within w_authority_categories_edit
integer x = 1266
integer y = 120
integer width = 357
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Page 99/99"
end type

event clicked;dw_authority_categories.set_page(dw_authority_categories.current_page + 1, text)

end event

type cb_new from commandbutton within w_authority_categories_edit
integer x = 1637
integer y = 472
integer width = 416
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New"
end type

event clicked;str_popup			popup
str_popup_return	popup_return
Long					ll_row, ll_return
String				ls_authority_category, ls_description

popup.title = "Enter new authority category"
Openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
If popup_return.item_count <> 1 Then Return

ls_description = popup_return.items[1]
ls_authority_category = f_gen_key_string(ls_description, 24)

// Insert new insurance type
ll_row = dw_authority_categories.insertrow(0)
dw_authority_categories.object.authority_type[ll_row] = authority_type
dw_authority_categories.object.authority_type[ll_row] = ls_authority_category
dw_authority_categories.object.description[ll_row] = ls_description
dw_authority_categories.object.sort_sequence[ll_row] = ll_row

// Update to Database
ll_return = dw_authority_categories.update()
If Not tf_check() Then Return -1
end event

type cb_delete from commandbutton within w_authority_categories_edit
integer x = 1637
integer y = 652
integer width = 416
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete"
end type

event clicked;long ll_row
str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you wish to delete the selected authority category?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

ll_row = dw_authority_categories.get_selected_row()
if ll_row <= 0 then return

dw_authority_categories.deleterow(ll_row)
dw_authority_categories.update()


end event

type cb_move_up from commandbutton within w_authority_categories_edit
integer x = 1637
integer y = 956
integer width = 416
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Up"
end type

event clicked;long i
long ll_rowcount
long ll_row

ll_row = dw_authority_categories.get_selected_row()
if ll_row <= 1 then return

ll_rowcount = dw_authority_categories.rowcount()

for i = 1 to ll_rowcount
	if i = ll_row - 1 then
		dw_authority_categories.object.sort_sequence[i] = ll_row
	elseif i = ll_row then
		dw_authority_categories.object.sort_sequence[i] = ll_row - 1
	else
		dw_authority_categories.object.sort_sequence[i] = i
	end if
next

dw_authority_categories.update()

dw_authority_categories.sort()

end event

type cb_move_down from commandbutton within w_authority_categories_edit
integer x = 1637
integer y = 1108
integer width = 416
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Move Down"
end type

event clicked;long i
long ll_rowcount
long ll_row


ll_rowcount = dw_authority_categories.rowcount()

ll_row = dw_authority_categories.get_selected_row()
if ll_row < 1 or i >= ll_rowcount then return

for i = 1 to ll_rowcount
	if i = ll_row + 1 then
		dw_authority_categories.object.sort_sequence[i] = ll_row
	elseif i = ll_row then
		dw_authority_categories.object.sort_sequence[i] = ll_row + 1
	else
		dw_authority_categories.object.sort_sequence[i] = i
	end if
next

dw_authority_categories.update()

dw_authority_categories.sort()

end event

type cb_sort from commandbutton within w_authority_categories_edit
integer x = 1637
integer y = 1260
integer width = 416
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sort"
end type

event clicked;long i
long ll_rowcount


ll_rowcount = dw_authority_categories.rowcount()
dw_authority_categories.setsort("description a")
dw_authority_categories.sort()


for i = 1 to ll_rowcount
	dw_authority_categories.object.sort_sequence[i] = i
next

dw_authority_categories.update()

dw_authority_categories.setsort("sort_sequence a")
dw_authority_categories.sort()

end event

