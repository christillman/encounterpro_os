$PBExportHeader$w_menu_display.srw
forward
global type w_menu_display from w_window_base
end type
type sle_menu from singlelineedit within w_menu_display
end type
type st_specialty from statictext within w_menu_display
end type
type st_context_object from statictext within w_menu_display
end type
type st_menu_description_title from statictext within w_menu_display
end type
type st_specialty_title from statictext within w_menu_display
end type
type st_context_object_title from statictext within w_menu_display
end type
type dw_menu_items from u_dw_pick_list within w_menu_display
end type
type st_menu_items_title from statictext within w_menu_display
end type
type pb_up from u_picture_button within w_menu_display
end type
type pb_down from u_picture_button within w_menu_display
end type
type st_page from statictext within w_menu_display
end type
type st_title from statictext within w_menu_display
end type
type cb_finished from commandbutton within w_menu_display
end type
type st_menu_category_title from statictext within w_menu_display
end type
type st_menu_category from statictext within w_menu_display
end type
type cb_set_active from commandbutton within w_menu_display
end type
type cb_edit_menu from commandbutton within w_menu_display
end type
type st_versions_title from statictext within w_menu_display
end type
type cb_local_copy from commandbutton within w_menu_display
end type
type dw_versions from u_dw_pick_list within w_menu_display
end type
end forward

global type w_menu_display from w_window_base
integer height = 1880
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
st_menu_items_title st_menu_items_title
pb_up pb_up
pb_down pb_down
st_page st_page
st_title st_title
cb_finished cb_finished
st_menu_category_title st_menu_category_title
st_menu_category st_menu_category
cb_set_active cb_set_active
cb_edit_menu cb_edit_menu
st_versions_title st_versions_title
cb_local_copy cb_local_copy
dw_versions dw_versions
end type
global w_menu_display w_menu_display

type variables
string id
boolean allow_editing

end variables

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();integer li_sts
long ll_rows
long ll_active
long i
string ls_status
long ll_workplan_id
long ll_root_handle
boolean lb_local_found
long ll_owner_id

dw_versions.settransobject(sqlca)
ll_rows = dw_versions.retrieve(id, sqlca.customer_id)
if ll_rows < 0 then
	log.log(this, "w_menu_display.initialize.0014", "Error retrieving workplans (" + id + ")", 4)
	return -1
elseif ll_rows = 0 then	
	log.log(this, "w_menu_display.initialize.0014", "No menus found (" + id + ")", 4)
	return -1
end if

// Find the last active workplan and highlight it
ll_active = 0
lb_local_found = false
for i = ll_rows to 1 step -1
	ll_owner_id = dw_versions.object.owner_id[i]
	ls_status = dw_versions.object.status[i]
	if ll_owner_id = sqlca.customer_id then lb_local_found = true
	if upper(ls_status) = "OK" then
		if ll_active = 0 then
			ll_active = i
		else
			// If there are any other workplans with a status of OK, make them NA.
			dw_versions.object.status[i] = "NA"
			dw_versions.update()
		end if
	end if
next
if ll_active <= 0 then ll_active = 1

dw_versions.object.selected_flag[ll_active] = 1
dw_versions.event POST selected(ll_active)

if not lb_local_found then
	cb_local_copy.visible = true
else
	cb_local_copy.visible = false
end if


return 1

end function

on w_menu_display.create
int iCurrent
call super::create
this.sle_menu=create sle_menu
this.st_specialty=create st_specialty
this.st_context_object=create st_context_object
this.st_menu_description_title=create st_menu_description_title
this.st_specialty_title=create st_specialty_title
this.st_context_object_title=create st_context_object_title
this.dw_menu_items=create dw_menu_items
this.st_menu_items_title=create st_menu_items_title
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_title=create st_title
this.cb_finished=create cb_finished
this.st_menu_category_title=create st_menu_category_title
this.st_menu_category=create st_menu_category
this.cb_set_active=create cb_set_active
this.cb_edit_menu=create cb_edit_menu
this.st_versions_title=create st_versions_title
this.cb_local_copy=create cb_local_copy
this.dw_versions=create dw_versions
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_menu
this.Control[iCurrent+2]=this.st_specialty
this.Control[iCurrent+3]=this.st_context_object
this.Control[iCurrent+4]=this.st_menu_description_title
this.Control[iCurrent+5]=this.st_specialty_title
this.Control[iCurrent+6]=this.st_context_object_title
this.Control[iCurrent+7]=this.dw_menu_items
this.Control[iCurrent+8]=this.st_menu_items_title
this.Control[iCurrent+9]=this.pb_up
this.Control[iCurrent+10]=this.pb_down
this.Control[iCurrent+11]=this.st_page
this.Control[iCurrent+12]=this.st_title
this.Control[iCurrent+13]=this.cb_finished
this.Control[iCurrent+14]=this.st_menu_category_title
this.Control[iCurrent+15]=this.st_menu_category
this.Control[iCurrent+16]=this.cb_set_active
this.Control[iCurrent+17]=this.cb_edit_menu
this.Control[iCurrent+18]=this.st_versions_title
this.Control[iCurrent+19]=this.cb_local_copy
this.Control[iCurrent+20]=this.dw_versions
end on

on w_menu_display.destroy
call super::destroy
destroy(this.sle_menu)
destroy(this.st_specialty)
destroy(this.st_context_object)
destroy(this.st_menu_description_title)
destroy(this.st_specialty_title)
destroy(this.st_context_object_title)
destroy(this.dw_menu_items)
destroy(this.st_menu_items_title)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_title)
destroy(this.cb_finished)
destroy(this.st_menu_category_title)
destroy(this.st_menu_category)
destroy(this.cb_set_active)
destroy(this.cb_edit_menu)
destroy(this.st_versions_title)
destroy(this.cb_local_copy)
destroy(this.dw_versions)
end on

event open;call super::open;integer li_sts
str_popup popup

popup = message.powerobjectparm

if popup.data_row_count <> 2 then
	log.log(this, "w_menu_display.open.0007", "Invalid Parameters", 4)
	close(this)
	return
end if

id = popup.items[1]
allow_editing = f_string_to_boolean(popup.items[2])

li_sts = initialize()
if li_sts <= 0 then
	log.log(this, "w_menu_display.open.0007", "Initialize failed", 4)
	close(this)
end if


end event

event resize;call super::resize;//long ll_delta
//
//
//dw_versions.x = newwidth - dw_versions.width - 50
//
//ll_delta = (dw_versions.width - cb_set_active.width) / 2
//cb_set_active.x = dw_versions.x + ll_delta
//
//ll_delta = (dw_versions.width - st_versions_title.width) / 2
//st_versions_title.x = dw_versions.x + ll_delta
//
//ll_delta = (dw_versions.width - cb_edit_menu.width) / 2
//cb_edit_menu.x = dw_versions.x + ll_delta
//
//ll_delta = (dw_versions.width - cb_local_copy.width) / 2
//cb_local_copy.x = dw_versions.x + ll_delta
//
//dw_menu_items.height = newheight - dw_menu_items.y - 100
//st_title.width = newwidth
//
//pb_epro_help.x = newwidth - pb_epro_help.width - 100
//
//cb_finished.x = newwidth - cb_finished.width - 100
//cb_finished.y = newheight - cb_finished.height - 80
//
//
//ll_delta = (dw_versions.x - 2100 ) / 2
//if ll_delta > 0 then
//	dw_menu_items.x += ll_delta
//	pb_down.x += ll_delta
//	pb_up.x += ll_delta
//	st_page.x += ll_delta
//	st_context_object.x += ll_delta
//	st_context_object_title.x += ll_delta
//	st_menu_category.x += ll_delta
//	st_menu_category_title.x += ll_delta
//	st_specialty.x += ll_delta
//	st_specialty_title.x += ll_delta
//	sle_menu.x += ll_delta
//	st_menu_description_title.x += ll_delta
//	st_menu_items_title.x += ll_delta
//end if
//
//
//
//
//
//
//
//
//
//
//
//
//
//
end event

type pb_epro_help from w_window_base`pb_epro_help within w_menu_display
boolean visible = true
integer y = 16
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_menu_display
end type

type sle_menu from singlelineedit within w_menu_display
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
long backcolor = 12632256
integer limit = 80
end type

type st_specialty from statictext within w_menu_display
integer x = 1445
integer y = 284
integer width = 562
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
boolean focusrectangle = false
end type

type st_context_object from statictext within w_menu_display
integer x = 530
integer y = 276
integer width = 562
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Assessment"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_menu_description_title from statictext within w_menu_display
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

type st_specialty_title from statictext within w_menu_display
integer x = 1120
integer y = 304
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

type st_context_object_title from statictext within w_menu_display
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

type dw_menu_items from u_dw_pick_list within w_menu_display
integer x = 32
integer y = 536
integer width = 1888
integer height = 1144
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_sp_get_menu_items_display"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type st_menu_items_title from statictext within w_menu_display
integer x = 32
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

type pb_up from u_picture_button within w_menu_display
integer x = 1938
integer y = 540
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

type pb_down from u_picture_button within w_menu_display
integer x = 1938
integer y = 664
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

type st_page from statictext within w_menu_display
integer x = 1938
integer y = 792
integer width = 142
integer height = 132
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

type st_title from statictext within w_menu_display
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

type cb_finished from commandbutton within w_menu_display
integer x = 2331
integer y = 1648
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
string text = "Finished"
end type

event clicked;
close(parent)


end event

type st_menu_category_title from statictext within w_menu_display
integer x = 2034
integer y = 304
integer width = 123
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
string text = "Cat:"
alignment alignment = right!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_menu_category from statictext within w_menu_display
integer x = 2181
integer y = 284
integer width = 562
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
boolean focusrectangle = false
end type

type cb_set_active from commandbutton within w_menu_display
integer x = 2267
integer y = 1092
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Set Inactive"
end type

event clicked;long ll_row
string ls_status
long i
integer li_sts

ll_row = dw_versions.get_selected_row()
if ll_row <= 0 then return

ls_status = dw_versions.object.status[ll_row]

if upper(ls_status) = "OK" then
	dw_versions.object.status[ll_row] = "NA"
	text = "Set Active"
else
	text = "Set Inactive"
	for i = 1 to dw_versions.rowcount()
		if i = ll_row then
			dw_versions.object.status[i] = "OK"
		else
			dw_versions.object.status[i] = "NA"
		end if
	next
end if

li_sts = dw_versions.update()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Status change failed")
	return
end if


end event

type cb_edit_menu from commandbutton within w_menu_display
integer x = 2162
integer y = 1280
integer width = 617
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit Menu"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_menu_id
long ll_root_handle
long ll_row
w_menu_edit lw_menu_edit

ll_row = dw_versions.get_selected_row()
if ll_row <= 0 then return

ll_menu_id = dw_versions.object.menu_id[ll_row]

openwithparm(lw_menu_edit, ll_menu_id, "w_menu_edit")

dw_versions.event TRIGGER selected(ll_row) 


end event

type st_versions_title from statictext within w_menu_display
integer x = 2267
integer y = 428
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
string text = "Versions"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_local_copy from commandbutton within w_menu_display
integer x = 2162
integer y = 1468
integer width = 617
integer height = 112
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Create Local Copy"
end type

event clicked;long ll_menu_id
string ls_id
string ls_description
long ll_new_menu_id
long ll_row

ll_row = dw_versions.get_selected_row()
if ll_row <= 0 then return

ll_menu_id = dw_versions.object.menu_id[ll_row]
ls_id = dw_versions.object.id[ll_row]
ls_description = dw_versions.object.description[ll_row]

if not f_popup_yes_no("Are you sure you wish to create a local copy of this menu?") then return

ll_new_menu_id = sqlca.sp_local_copy_menu(ll_menu_id, ls_id, ls_description)
if not tf_check() then return

initialize()

end event

type dw_versions from u_dw_pick_list within w_menu_display
integer x = 2080
integer y = 492
integer width = 782
integer height = 576
integer taborder = 21
string dataobject = "dw_id_menus"
boolean border = false
end type

event selected;call super::selected;long ll_menu_id
long ll_root_handle
string ls_status
long ll_owner_id
long ll_local_owner_id
string ls_specialty_id
string ls_context_object
string ls_menu_category

ll_menu_id = object.menu_id[selected_row]

dw_menu_items.settransobject(sqlca)
dw_menu_items.retrieve(ll_menu_id)
dw_menu_items.set_page(1, pb_up, pb_down, st_page)

ls_status = object.status[selected_row]
if upper(ls_status) = "OK" then
	cb_set_active.text = "Set Inactive"
else
	cb_set_active.text = "Set Active"
end if

ll_owner_id = object.owner_id[selected_row]
ll_local_owner_id = object.local_owner_id[selected_row]

if ll_local_owner_id = ll_owner_id and allow_editing then
	cb_edit_menu.visible = true
else
	cb_edit_menu.visible = false
end if

SELECT description, specialty_id, context_object, menu_category
INTO :sle_menu.text, :ls_specialty_id, :ls_context_object, :ls_menu_category
FROM c_Menu
WHERE menu_id = :ll_menu_id;
if not tf_check() then return
if sqlca.sqlcode = 100 then
	log.log(this, "w_menu_display.open.0007", "menu_id not found (" + string(ll_menu_id) + ")", 4)
	return
end if

st_specialty.text = datalist.specialty_description(ls_specialty_id)
st_context_object.text = wordcap(lower(ls_context_object))
st_menu_category.text = ls_menu_category

sle_menu.setfocus()


end event

