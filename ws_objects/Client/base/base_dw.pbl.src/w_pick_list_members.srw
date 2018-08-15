$PBExportHeader$w_pick_list_members.srw
forward
global type w_pick_list_members from w_window_base
end type
type pb_cancel from u_picture_button within w_pick_list_members
end type
type pb_done from u_picture_button within w_pick_list_members
end type
type st_member_list_title from statictext within w_pick_list_members
end type
type st_title from statictext within w_pick_list_members
end type
type cb_new_list_member from commandbutton within w_pick_list_members
end type
type dw_list_members from u_dw_pick_list within w_pick_list_members
end type
type dw_selected from u_dw_pick_list within w_pick_list_members
end type
type st_selected_title from statictext within w_pick_list_members
end type
type pb_help from u_pb_help_button within w_pick_list_members
end type
type pb_up from u_picture_button within w_pick_list_members
end type
type pb_down from u_picture_button within w_pick_list_members
end type
type st_page from statictext within w_pick_list_members
end type
type st_desc_search from statictext within w_pick_list_members
end type
end forward

global type w_pick_list_members from w_window_base
boolean titlebar = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_cancel pb_cancel
pb_done pb_done
st_member_list_title st_member_list_title
st_title st_title
cb_new_list_member cb_new_list_member
dw_list_members dw_list_members
dw_selected dw_selected
st_selected_title st_selected_title
pb_help pb_help
pb_up pb_up
pb_down pb_down
st_page st_page
st_desc_search st_desc_search
end type
global w_pick_list_members w_pick_list_members

type variables

string is_list_id, is_list_description

end variables

forward prototypes
public function integer add_list_member ()
end prototypes

public function integer add_list_member ();
str_popup popup
str_popup_return popup_return
string ls_description
long ll_row
integer li_sts
integer i
string ls_list_item_id
string ls_suffix
string ls_prefix
integer li_count
u_ds_data dw_char_key

if is_list_id = "Locality" then
	// We only have six slots on the w_edit_patient window
	if dw_selected.rowcount() >= 6 then
		openwithparm(w_pop_message, "A maximum of six (6) locality types may be selected. In order to add a new one, please remove one of the selected items.")
		return -1
	end if
end if

popup.title = "Enter New " + is_list_id + " Description"
popup.item = ""
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count < 1 then return -1

ls_description = popup_return.items[1]

ll_row = dw_list_members.insertrow(0)
dw_list_members.object.list_id[ll_row] = is_list_id
dw_list_members.object.list_item[ll_row] = ls_description
dw_list_members.object.status[ll_row] = "Active"

ll_row = dw_selected.insertrow(0)
dw_selected.object.list_id[ll_row] = is_list_id
dw_selected.object.list_item[ll_row] = ls_description
dw_selected.object.status[ll_row] = "Active"

dw_list_members.scrolltorow(ll_row)
// up & dn buttons
dw_list_members.recalc_page(st_page.text)
if dw_list_members.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = true
	pb_down.enabled = true
end if
pb_done.enabled = true

RETURN 0
end function

on w_pick_list_members.create
int iCurrent
call super::create
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
this.st_member_list_title=create st_member_list_title
this.st_title=create st_title
this.cb_new_list_member=create cb_new_list_member
this.dw_list_members=create dw_list_members
this.dw_selected=create dw_selected
this.st_selected_title=create st_selected_title
this.pb_help=create pb_help
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_desc_search=create st_desc_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_cancel
this.Control[iCurrent+2]=this.pb_done
this.Control[iCurrent+3]=this.st_member_list_title
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.cb_new_list_member
this.Control[iCurrent+6]=this.dw_list_members
this.Control[iCurrent+7]=this.dw_selected
this.Control[iCurrent+8]=this.st_selected_title
this.Control[iCurrent+9]=this.pb_help
this.Control[iCurrent+10]=this.pb_up
this.Control[iCurrent+11]=this.pb_down
this.Control[iCurrent+12]=this.st_page
this.Control[iCurrent+13]=this.st_desc_search
end on

on w_pick_list_members.destroy
call super::destroy
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.st_member_list_title)
destroy(this.st_title)
destroy(this.cb_new_list_member)
destroy(this.dw_list_members)
destroy(this.dw_selected)
destroy(this.st_selected_title)
destroy(this.pb_help)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_desc_search)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts
long ll_rows
string ls_find, ls_service_name, ls_service_description
long ll_row
u_component_service luo_service

popup_return.item_count = 0

luo_service = message.powerobjectparm
ls_service_name = luo_service.service
ls_service_description = luo_service.description

// The service name is "Config_" + list_id
if left(ls_service_name, 7) = "Config_" then
	is_list_id = Mid(ls_service_name, 8)
else
	is_list_id = ls_service_name
end if
if left(ls_service_description, 10) = "Configure " then
	is_list_description = Mid(ls_service_description, 11)
else
	is_list_description = ls_service_description
end if

st_title.text = "Select Active " + is_list_description
st_member_list_title.text = "All " + is_list_description
st_selected_title.text = "Selected " + is_list_description

dw_list_members.settransobject(sqlca)
dw_selected.settransobject(sqlca)

ll_rows = dw_list_members.retrieve(is_list_id)
if ll_rows <= 0 then
	log.log(this, "w_pick_list_members.open:0035", "Error getting list members", 4)
	closewithreturn(this, popup_return)
	return
end if

ll_rows = dw_selected.retrieve(is_list_id)

pb_done.enabled = false
dw_list_members.set_page(1, pb_up, pb_down, st_page)


end event

type pb_epro_help from w_window_base`pb_epro_help within w_pick_list_members
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_list_members
end type

type pb_cancel from u_picture_button within w_pick_list_members
integer x = 87
integer y = 1568
integer width = 256
integer height = 224
integer taborder = 60
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;
str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_done from u_picture_button within w_pick_list_members
integer x = 2569
integer y = 1556
integer taborder = 10
boolean bringtotop = true
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;
long ll_row, ll_edit_row
integer li_inc
string ls_find, ls_list_item

// Reset all sort_sequence to 0 first
FOR ll_row = 1 TO dw_list_members.rowcount()
	dw_list_members.object.sort_sequence[ll_row] = 0
NEXT

// Renumber the selected ones
li_inc = 0
FOR ll_row = 1 TO dw_selected.rowcount()
	li_inc = li_inc + 10
	ls_list_item = dw_selected.object.list_item[ll_row]
	
	ls_find = "list_item ='" + ls_list_item + "'"
	ll_edit_row = dw_list_members.Find(ls_find, 1, dw_list_members.rowcount())
		
	dw_list_members.object.sort_sequence[ll_edit_row] = li_inc
NEXT

dw_list_members.Update()
tf_check()


str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type st_member_list_title from statictext within w_pick_list_members
integer x = 407
integer y = 184
integer width = 960
integer height = 84
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
string text = "<Members>"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_pick_list_members
integer y = 40
integer width = 2930
integer height = 136
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Select <Members>"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_new_list_member from commandbutton within w_pick_list_members
integer x = 1673
integer y = 1640
integer width = 631
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New List Member"
end type

event clicked;
add_list_member()
end event

type dw_list_members from u_dw_pick_list within w_pick_list_members
integer x = 306
integer y = 268
integer width = 1175
integer height = 1364
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_list_items"
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event selected;call super::selected;
string ls_list_item, ls_find
long ll_row

ls_list_item = object.list_item[selected_row]

ls_find = "list_item ='" + ls_list_item + "'"
if dw_selected.Find(ls_find, 1, dw_selected.rowcount()) > 0 then
	return
end if

if is_list_id = "Locality" then
	// We only have six slots on the w_edit_patient window
	if dw_selected.rowcount() >= 6 then
		openwithparm(w_pop_message, "A maximum of six (6) locality types may be selected.")
		return
	end if
end if

ll_row = dw_selected.insertrow(0)
dw_selected.object.list_item[ll_row] = ls_list_item
dw_selected.object.list_item[ll_row] = object.list_item[selected_row]

// We will save changes to this dw when done
object.status[selected_row] = 'Active'

pb_done.enabled = true
end event

event retrieveend;call super::retrieveend;
object.list_item.width = width - 260

end event

type dw_selected from u_dw_pick_list within w_pick_list_members
integer x = 1609
integer y = 588
integer width = 1175
integer height = 904
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_list_items_active"
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event selected;call super::selected;
string ls_list_item, ls_find
long ll_row

ls_list_item = object.list_item[selected_row]

ls_find = "list_item ='" + ls_list_item + "'"
ll_row = dw_list_members.Find(ls_find, 1, dw_list_members.rowcount())

if ll_row = 0 then
	MessageBox("Rows out of sync", "List item " + object.list_item[selected_row])
	return
end if

dw_list_members.object.status[ll_row] = 'OK'

DeleteRow(selected_row)

pb_done.enabled = true

end event

event retrieveend;call super::retrieveend;
object.list_item.width = width - 260


end event

type st_selected_title from statictext within w_pick_list_members
integer x = 1682
integer y = 488
integer width = 955
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
string text = "Selected <Members>"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_help from u_pb_help_button within w_pick_list_members
integer x = 2629
integer y = 196
integer width = 169
integer height = 128
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
end type

type pb_up from u_picture_button within w_pick_list_members
integer x = 1509
integer y = 272
integer width = 146
integer height = 124
integer taborder = 11
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_list_members.current_page

dw_list_members.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_pick_list_members
integer x = 1509
integer y = 396
integer width = 137
integer height = 116
integer taborder = 21
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_list_members.current_page
li_last_page = dw_list_members.last_page

dw_list_members.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type st_page from statictext within w_pick_list_members
integer x = 1326
integer y = 200
integer width = 320
integer height = 60
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
alignment alignment = right!
boolean focusrectangle = false
end type

type st_desc_search from statictext within w_pick_list_members
boolean visible = false
integer x = 2181
integer y = 276
integer width = 640
integer height = 104
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
boolean focusrectangle = false
end type

