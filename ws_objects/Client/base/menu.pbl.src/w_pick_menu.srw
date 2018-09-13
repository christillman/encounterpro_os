$PBExportHeader$w_pick_menu.srw
forward
global type w_pick_menu from w_window_base
end type
type st_search_title from statictext within w_pick_menu
end type
type pb_up from u_picture_button within w_pick_menu
end type
type pb_down from u_picture_button within w_pick_menu
end type
type st_page from statictext within w_pick_menu
end type
type st_context_object from statictext within w_pick_menu
end type
type st_top_20 from statictext within w_pick_menu
end type
type st_search_status from statictext within w_pick_menu
end type
type st_specialty from statictext within w_pick_menu
end type
type st_specialty_title from statictext within w_pick_menu
end type
type st_title from statictext within w_pick_menu
end type
type st_description from statictext within w_pick_menu
end type
type st_common_flag from statictext within w_pick_menu
end type
type dw_menus from u_dw_menus within w_pick_menu
end type
type cb_new from commandbutton within w_pick_menu
end type
type st_1 from statictext within w_pick_menu
end type
type st_category from statictext within w_pick_menu
end type
type cb_ok from commandbutton within w_pick_menu
end type
type cb_cancel from commandbutton within w_pick_menu
end type
end forward

global type w_pick_menu from w_window_base
integer height = 1836
boolean controlmenu = false
windowtype windowtype = response!
st_search_title st_search_title
pb_up pb_up
pb_down pb_down
st_page st_page
st_context_object st_context_object
st_top_20 st_top_20
st_search_status st_search_status
st_specialty st_specialty
st_specialty_title st_specialty_title
st_title st_title
st_description st_description
st_common_flag st_common_flag
dw_menus dw_menus
cb_new cb_new
st_1 st_1
st_category st_category
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_pick_menu w_pick_menu

type variables
string specialty_id

string search_type

string common_flag = "Y"

long   menu_id
string menu_desc

string original_context_object

end variables

event open;call super::open;/////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
//
//
//
////////////////////////////////////////////////////////////////////////////

st_context_object.text = wordcap(message.stringparm)
if f_is_context_object(st_context_object.text) then
	original_context_object = st_context_object.text
else
	setnull(original_context_object)
	st_context_object.text = "<All>"
end if

dw_menus.set_context_object(original_context_object)

specialty_id = current_user.specialty_id
dw_menus.specialty_id = current_user.common_list_id()

dw_menus.object.description.width = dw_menus.width - 150

if isnull(current_patient) then
	title = st_title.text
else
	title = current_patient.id_line()
end if

If trim(specialty_id) = "" Then Setnull(specialty_id)
If Isnull(specialty_id) Then
	st_specialty.visible = False
	st_specialty_title.visible = False
	st_category.visible = false
Else
	st_specialty.text = datalist.specialty_description(specialty_id)
End if

postevent("post_open")

end event

on w_pick_menu.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_context_object=create st_context_object
this.st_top_20=create st_top_20
this.st_search_status=create st_search_status
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
this.st_title=create st_title
this.st_description=create st_description
this.st_common_flag=create st_common_flag
this.dw_menus=create dw_menus
this.cb_new=create cb_new
this.st_1=create st_1
this.st_category=create st_category
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.st_context_object
this.Control[iCurrent+6]=this.st_top_20
this.Control[iCurrent+7]=this.st_search_status
this.Control[iCurrent+8]=this.st_specialty
this.Control[iCurrent+9]=this.st_specialty_title
this.Control[iCurrent+10]=this.st_title
this.Control[iCurrent+11]=this.st_description
this.Control[iCurrent+12]=this.st_common_flag
this.Control[iCurrent+13]=this.dw_menus
this.Control[iCurrent+14]=this.cb_new
this.Control[iCurrent+15]=this.st_1
this.Control[iCurrent+16]=this.st_category
this.Control[iCurrent+17]=this.cb_ok
this.Control[iCurrent+18]=this.cb_cancel
end on

on w_pick_menu.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_context_object)
destroy(this.st_top_20)
destroy(this.st_search_status)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
destroy(this.st_title)
destroy(this.st_description)
destroy(this.st_common_flag)
destroy(this.dw_menus)
destroy(this.cb_new)
destroy(this.st_1)
destroy(this.st_category)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

event post_open;call super::post_open;dw_menus.mode = "PICK"
dw_menus.initialize("")
dw_menus.search_top_20()


end event

type pb_epro_help from w_window_base`pb_epro_help within w_pick_menu
boolean visible = true
integer x = 2629
integer width = 256
integer height = 128
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_menu
end type

type st_search_title from statictext within w_pick_menu
integer x = 1842
integer y = 544
integer width = 558
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Search Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_pick_menu
integer x = 1358
integer y = 116
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_menus.current_page

dw_menus.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_pick_menu
integer x = 1358
integer y = 240
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_menus.current_page
li_last_page = dw_menus.last_page

dw_menus.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_pick_menu
integer x = 1495
integer y = 116
integer width = 274
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
alignment alignment = center!
boolean focusrectangle = false
end type

type st_context_object from statictext within w_pick_menu
integer x = 2021
integer y = 408
integer width = 695
integer height = 96
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
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
boolean disabledlook = true
end type

event clicked;str_popup			popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

if isnull(original_context_object) then
	popup.dataobject = "dw_domain_notranslate_list"
	popup.datacolumn = 2
	popup.displaycolumn = 2
	popup.argument_count = 1
	popup.argument[1] = "CONTEXT_OBJECT"
	popup.add_blank_row = true
	popup.blank_text = "<All>"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
else
	popup.dataobject = "dw_v_compatible_context_object"
	popup.datacolumn = 1
	popup.displaycolumn = 1
	popup.argument_count = 1
	popup.argument[1] = original_context_object
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
end if

if popup_return.items[1] = "" then
	dw_menus.set_context_object(ls_null)
	text = "<All>"
else
	dw_menus.set_context_object(popup_return.items[1])
	text = wordcap(lower(popup_return.items[1]))
end if



end event

type st_top_20 from statictext within w_pick_menu
integer x = 1495
integer y = 668
integer width = 411
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Short List"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if search_type = "TOP20" then
	if dw_menus.search_description = "Personal List" then
		dw_menus.search_top_20(false)
	else
		dw_menus.search_top_20(true)
	end if
else
	if dw_menus.search_description = "Personal List" then
		dw_menus.search_top_20(true)
	else
		dw_menus.search_top_20(false)
	end if
end if


end event

type st_search_status from statictext within w_pick_menu
integer x = 1394
integer y = 792
integer width = 1458
integer height = 88
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

type st_specialty from statictext within w_pick_menu
integer x = 2021
integer y = 276
integer width = 695
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
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_specialty_id

ls_specialty_id = f_pick_specialty("<None>")
if isnull(ls_specialty_id) then return

if ls_specialty_id = "<None>" then
	text = "<None>"
	setnull(specialty_id)
	setnull(dw_menus.specialty_id)
	st_common_flag.text = "All"
else
	text = datalist.specialty_description(ls_specialty_id)
	specialty_id = ls_specialty_id
	dw_menus.specialty_id = ls_specialty_id
	st_common_flag.text = "Specialty"
end if

common_flag = "Y"

st_top_20.visible = true
if isnull(dw_menus.specialty_id) then
	st_category.visible = false
	st_common_flag.visible = false
else
	st_category.visible = true
	st_common_flag.visible = true
end if
dw_menus.search()


end event

type st_specialty_title from statictext within w_pick_menu
integer x = 1701
integer y = 284
integer width = 297
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_pick_menu
integer x = 14
integer width = 1477
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Select Menu"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_description from statictext within w_pick_menu
integer x = 1920
integer y = 668
integer width = 411
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Description"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_menus.search_description()

end event

type st_common_flag from statictext within w_pick_menu
integer x = 2592
integer y = 552
integer width = 270
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Specialty"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if common_flag = "Y" then
	common_flag = "N"
	text = "All"
	setnull(dw_menus.specialty_id)
else
	common_flag = "Y"
	text = "Specialty"
	dw_menus.specialty_id = specialty_id
end if

dw_menus.search()

end event

type dw_menus from u_dw_menus within w_pick_menu
integer x = 14
integer y = 108
integer width = 1344
integer height = 1592
integer taborder = 11
boolean bringtotop = true
boolean vscrollbar = false
end type

event menu_loaded;call super::menu_loaded;search_type = current_search

st_top_20.backcolor = color_object
st_category.backcolor = color_object
st_description.backcolor = color_object

st_search_status.text = ps_description

CHOOSE CASE current_search
	CASE "TOP20"
		st_top_20.backcolor = color_object_selected
		st_common_flag.visible = false
	CASE "CATEGORY"
		st_category.backcolor = color_object_selected
		st_common_flag.visible = true
	CASE "DESCRIPTION"
		st_description.backcolor = color_object_selected
		st_common_flag.visible = true
END CHOOSE

set_page(1, pb_up, pb_down, st_page)

end event

event selected;call super::selected;menu_id = object.menu_id[selected_row]
menu_desc = object.description[selected_row]
cb_ok.enabled = true

end event

event unselected;call super::unselected;cb_ok.enabled = false


end event

type cb_new from commandbutton within w_pick_menu
integer x = 1897
integer y = 1040
integer width = 494
integer height = 132
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Menu"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////////////
//
// Description: Create a new menu
//
// Created By:Sumathi Chinnasamy										Creation dt: 01/14/2003
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

str_popup popup
str_popup_return popup_return
string ls_null
long ll_menu_id
string ls_menu_description
w_menu_edit lw_menu_edit

setnull(ls_null)

popup.title = "Enter description for new menu"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return


ll_menu_id = sqlca.sp_new_menu(popup_return.items[1], ls_null, ls_null, ls_null)
if ll_menu_id > 0 then
	Openwithparm(lw_menu_edit, ll_menu_id, "w_menu_edit")
	
	datalist.clear_cache("menus")
	ls_menu_description = datalist.menu_description(ll_menu_id)
	
	popup_return.item_count = 1
	popup_return.items[1] = string(ll_menu_id)
	popup_return.descriptions[1] = ls_menu_description
	Closewithreturn(Parent,popup_return)
//	dw_menus.search()
end if


end event

type st_1 from statictext within w_pick_menu
integer x = 1536
integer y = 428
integer width = 462
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Context Object:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_category from statictext within w_pick_menu
integer x = 2345
integer y = 668
integer width = 411
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Category"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_menus.search_category()

end event

type cb_ok from commandbutton within w_pick_menu
integer x = 2299
integer y = 1548
integer width = 475
integer height = 112
integer taborder = 100
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

event clicked;str_popup_return	popup_return

popup_return.item_count = 1
popup_return.items[1] = string(menu_id)
popup_return.descriptions[1] = menu_desc
Closewithreturn(Parent,popup_return)

end event

type cb_cancel from commandbutton within w_pick_menu
integer x = 1440
integer y = 1548
integer width = 475
integer height = 112
integer taborder = 110
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
Closewithreturn(Parent,popup_return)


end event

