$PBExportHeader$w_coding_element_pick.srw
forward
global type w_coding_element_pick from w_window_base
end type
type st_celement_title from statictext within w_coding_element_pick
end type
type st_title from statictext within w_coding_element_pick
end type
type st_page from statictext within w_coding_element_pick
end type
type cb_done from commandbutton within w_coding_element_pick
end type
type pb_up from u_picture_button within w_coding_element_pick
end type
type pb_down from u_picture_button within w_coding_element_pick
end type
type dw_elements from u_dw_pick_list within w_coding_element_pick
end type
type st_component_title from statictext within w_coding_element_pick
end type
type dw_category from u_dw_pick_list within w_coding_element_pick
end type
type st_cat_page from statictext within w_coding_element_pick
end type
type pb_cat_up from u_picture_button within w_coding_element_pick
end type
type pb_cat_down from u_picture_button within w_coding_element_pick
end type
type st_category_title from statictext within w_coding_element_pick
end type
type st_component from statictext within w_coding_element_pick
end type
type st_type_title from statictext within w_coding_element_pick
end type
type st_type from statictext within w_coding_element_pick
end type
type cb_new_element from commandbutton within w_coding_element_pick
end type
type cb_cancel from commandbutton within w_coding_element_pick
end type
end forward

global type w_coding_element_pick from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_celement_title st_celement_title
st_title st_title
st_page st_page
cb_done cb_done
pb_up pb_up
pb_down pb_down
dw_elements dw_elements
st_component_title st_component_title
dw_category dw_category
st_cat_page st_cat_page
pb_cat_up pb_cat_up
pb_cat_down pb_cat_down
st_category_title st_category_title
st_component st_component
st_type_title st_type_title
st_type st_type
cb_new_element cb_new_element
cb_cancel cb_cancel
end type
global w_coding_element_pick w_coding_element_pick

type variables
string em_component
string em_type
string em_category
string em_element

end variables

on w_coding_element_pick.create
int iCurrent
call super::create
this.st_celement_title=create st_celement_title
this.st_title=create st_title
this.st_page=create st_page
this.cb_done=create cb_done
this.pb_up=create pb_up
this.pb_down=create pb_down
this.dw_elements=create dw_elements
this.st_component_title=create st_component_title
this.dw_category=create dw_category
this.st_cat_page=create st_cat_page
this.pb_cat_up=create pb_cat_up
this.pb_cat_down=create pb_cat_down
this.st_category_title=create st_category_title
this.st_component=create st_component
this.st_type_title=create st_type_title
this.st_type=create st_type
this.cb_new_element=create cb_new_element
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_celement_title
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.st_page
this.Control[iCurrent+4]=this.cb_done
this.Control[iCurrent+5]=this.pb_up
this.Control[iCurrent+6]=this.pb_down
this.Control[iCurrent+7]=this.dw_elements
this.Control[iCurrent+8]=this.st_component_title
this.Control[iCurrent+9]=this.dw_category
this.Control[iCurrent+10]=this.st_cat_page
this.Control[iCurrent+11]=this.pb_cat_up
this.Control[iCurrent+12]=this.pb_cat_down
this.Control[iCurrent+13]=this.st_category_title
this.Control[iCurrent+14]=this.st_component
this.Control[iCurrent+15]=this.st_type_title
this.Control[iCurrent+16]=this.st_type
this.Control[iCurrent+17]=this.cb_new_element
this.Control[iCurrent+18]=this.cb_cancel
end on

on w_coding_element_pick.destroy
call super::destroy
destroy(this.st_celement_title)
destroy(this.st_title)
destroy(this.st_page)
destroy(this.cb_done)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.dw_elements)
destroy(this.st_component_title)
destroy(this.dw_category)
destroy(this.st_cat_page)
destroy(this.pb_cat_up)
destroy(this.pb_cat_down)
destroy(this.st_category_title)
destroy(this.st_component)
destroy(this.st_type_title)
destroy(this.st_type)
destroy(this.cb_new_element)
destroy(this.cb_cancel)
end on

event open;call super::open;str_popup popup
long ll_rows
string ls_specialty_id
long i
string ls_find
long ll_row

popup = message.powerobjectparm

if not isnull(popup.title) then
	st_title.text = popup.title
else
	st_title.text = "Select Coding Element"
end if

title = "Select Coding Element"

dw_category.settransobject(sqlca)
dw_elements.settransobject(sqlca)

if current_user.check_privilege("Super User") then
	cb_new_element.visible = true
else
	cb_new_element.visible = false
end if

em_component = datalist.get_preference("CODING", "pick_em_component")
if isnull(em_component) then em_component = "Examination"

st_component.text = em_component

em_type = datalist.get_preference("CODING", "pick_em_type|" + em_component)
if isnull(em_type) then
	st_type.postevent("clicked")
else
	st_type.text = em_type
	dw_category.retrieve(em_component, em_type)
	dw_category.set_page(1, pb_cat_up, pb_cat_down, st_cat_page)
	
	em_category = datalist.get_preference("CODING", "pick_em_category|" + em_component + "|" + em_type)
	if not isnull(em_category) then
		ll_row = dw_category.find("em_category='" + em_category + "'", 1, dw_category.rowcount())
		if ll_row > 0 then
			dw_category.object.selected_flag[ll_row] = 1
			dw_elements.retrieve(em_component, em_type, em_category)
			dw_elements.set_page(1, pb_up, pb_down, st_page)
		else
			setnull(em_category)
		end if
	end if
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_coding_element_pick
boolean visible = true
integer x = 2638
integer y = 116
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_coding_element_pick
end type

type st_celement_title from statictext within w_coding_element_pick
integer x = 1536
integer y = 424
integer width = 1074
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Coding Elements"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_coding_element_pick
integer width = 2921
integer height = 116
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Select Coding Element"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_page from statictext within w_coding_element_pick
boolean visible = false
integer x = 2510
integer y = 424
integer width = 297
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_done from commandbutton within w_coding_element_pick
integer x = 2409
integer y = 1672
integer width = 402
integer height = 112
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "OK"
boolean default = true
end type

event clicked;integer li_sts
str_popup_return popup_return

datalist.update_preference("CODING", "User", current_user.user_id, "pick_em_component", em_component)
datalist.update_preference("CODING", "User", current_user.user_id, "pick_em_type|" + em_component, em_type)
datalist.update_preference("CODING", "User", current_user.user_id, "pick_em_category|" + em_component + "|" + em_type, em_category)

popup_return.item_count = 4
popup_return.items[1] = em_component
popup_return.items[2] = em_type
popup_return.items[3] = em_category
popup_return.items[4] = em_element

closewithreturn(parent, popup_return)

end event

type pb_up from u_picture_button within w_coding_element_pick
boolean visible = false
integer x = 2670
integer y = 504
integer width = 137
integer height = 116
integer taborder = 11
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_elements.current_page

dw_elements.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_coding_element_pick
boolean visible = false
integer x = 2670
integer y = 628
integer width = 137
integer height = 116
integer taborder = 21
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_elements.current_page
li_last_page = dw_elements.last_page

dw_elements.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type dw_elements from u_dw_pick_list within w_coding_element_pick
integer x = 1531
integer y = 496
integer width = 1147
integer height = 1048
integer taborder = 10
string dataobject = "dw_em_element_list"
boolean border = false
end type

event selected(long selected_row);call super::selected;
em_element = object.em_element[selected_row]

cb_done.enabled = true

end event

event unselected(long unselected_row);call super::unselected;cb_done.enabled = false

end event

type st_component_title from statictext within w_coding_element_pick
integer x = 389
integer y = 148
integer width = 896
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Component"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_category from u_dw_pick_list within w_coding_element_pick
integer x = 128
integer y = 496
integer width = 1138
integer height = 1260
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_em_category_list"
boolean border = false
end type

event selected(long selected_row);call super::selected;
em_category = object.em_category[selected_row]
dw_elements.retrieve(em_component, em_type, em_category)
dw_elements.set_page(1, pb_up, pb_down, st_page)

end event

type st_cat_page from statictext within w_coding_element_pick
boolean visible = false
integer x = 1106
integer y = 424
integer width = 297
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_cat_up from u_picture_button within w_coding_element_pick
boolean visible = false
integer x = 1266
integer y = 504
integer width = 137
integer height = 116
integer taborder = 21
boolean bringtotop = true
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_category.current_page

dw_category.set_page(li_page - 1, st_cat_page.text)

if li_page <= 2 then enabled = false
pb_cat_down.enabled = true

end event

type pb_cat_down from u_picture_button within w_coding_element_pick
boolean visible = false
integer x = 1266
integer y = 628
integer width = 137
integer height = 116
integer taborder = 10
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_category.current_page
li_last_page = dw_category.last_page

dw_category.set_page(li_page + 1, st_cat_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_cat_up.enabled = true
end event

type st_category_title from statictext within w_coding_element_pick
integer x = 119
integer y = 424
integer width = 1138
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Category"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_component from statictext within w_coding_element_pick
integer x = 389
integer y = 228
integer width = 896
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_em_component_list"
popup.datacolumn = 1
popup.displaycolumn = 1
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

em_component = popup_return.items[1]
text = em_component

end event

type st_type_title from statictext within w_coding_element_pick
integer x = 1623
integer y = 148
integer width = 896
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_type from statictext within w_coding_element_pick
integer x = 1623
integer y = 228
integer width = 896
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_em_type_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = em_component
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

em_type = popup_return.items[1]
text = em_type

dw_category.retrieve(em_component, em_type)
dw_category.set_page(1, pb_cat_up, pb_cat_down, st_cat_page)

end event

type cb_new_element from commandbutton within w_coding_element_pick
integer x = 1339
integer y = 1672
integer width = 503
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Element"
end type

event clicked;string ls_em_element
integer li_sts
long ll_row
string ls_find
str_popup popup
str_popup_return popup_return

popup.title = "Please enter new element"
popup.argument_count = 1
popup.argument[1] = em_component
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_em_element = trim(popup_return.items[1])
if ls_em_element = "" or isnull(ls_em_element) then return

ls_find = "em_element='" + ls_em_element + "'"
ll_row = dw_elements.find(ls_find, 1, dw_elements.rowcount())
if ll_row > 0 then
	openwithparm(w_pop_message, "That element already exists")
	return
end if

ll_row = dw_elements.insertrow(0)
dw_elements.object.em_component[ll_row] = em_component
dw_elements.object.em_type[ll_row] = em_type
dw_elements.object.em_category[ll_row] = em_category
dw_elements.object.em_element[ll_row] = ls_em_element
dw_elements.object.sort_sequence[ll_row] = ll_row

li_sts = dw_elements.update()




end event

type cb_cancel from commandbutton within w_coding_element_pick
integer x = 1925
integer y = 1672
integer width = 402
integer height = 112
integer taborder = 51
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

