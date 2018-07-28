HA$PBExportHeader$w_svc_config_menu.srw
forward
global type w_svc_config_menu from w_svc_config_object_base
end type
type dw_menu_items from u_dw_pick_list within w_svc_config_menu
end type
type cb_edit_menu_item from commandbutton within w_svc_config_menu
end type
type cb_move_menu_item from commandbutton within w_svc_config_menu
end type
type cb_delete_menu_item from commandbutton within w_svc_config_menu
end type
type cb_new_menu_item from commandbutton within w_svc_config_menu
end type
type st_menu_items_title from statictext within w_svc_config_menu
end type
end forward

global type w_svc_config_menu from w_svc_config_object_base
dw_menu_items dw_menu_items
cb_edit_menu_item cb_edit_menu_item
cb_move_menu_item cb_move_menu_item
cb_delete_menu_item cb_delete_menu_item
cb_new_menu_item cb_new_menu_item
st_menu_items_title st_menu_items_title
end type
global w_svc_config_menu w_svc_config_menu

type variables
long menu_id

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();long ll_rows

super::refresh()

SELECT max(menu_id)
INTO :menu_id
FROM c_Menu
WHERE id = :config_object_info.config_object_id;
if not tf_check() then return -1

if isnull(menu_id) then
	INSERT INTO dbo.c_Menu (
           description,
           context_object,
           status,
           owner_id,
           id)
     VALUES (
	  	:config_object_info.description,
		  :config_object_info.context_object,
		  'OK',
		  :sqlca.customer_id,
		 :config_object_info.config_object_id
		 );
	if not tf_check() then return -1
	
	SELECT SCOPE_IDENTITY()
	INTO :menu_id
	FROM c_1_record;
	if not tf_check() then return -1
end if


dw_menu_items.settransobject(sqlca)
ll_rows = dw_menu_items.retrieve(menu_id)

if editable then
	cb_edit_menu_item.visible = true
	cb_move_menu_item.visible = true
	cb_delete_menu_item.visible = true
	cb_new_menu_item.visible = true
else
	cb_edit_menu_item.visible = false
	cb_move_menu_item.visible = false
	cb_delete_menu_item.visible = false
	cb_new_menu_item.visible = false
end if

return 1

end function

on w_svc_config_menu.create
int iCurrent
call super::create
this.dw_menu_items=create dw_menu_items
this.cb_edit_menu_item=create cb_edit_menu_item
this.cb_move_menu_item=create cb_move_menu_item
this.cb_delete_menu_item=create cb_delete_menu_item
this.cb_new_menu_item=create cb_new_menu_item
this.st_menu_items_title=create st_menu_items_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_menu_items
this.Control[iCurrent+2]=this.cb_edit_menu_item
this.Control[iCurrent+3]=this.cb_move_menu_item
this.Control[iCurrent+4]=this.cb_delete_menu_item
this.Control[iCurrent+5]=this.cb_new_menu_item
this.Control[iCurrent+6]=this.st_menu_items_title
end on

on w_svc_config_menu.destroy
call super::destroy
destroy(this.dw_menu_items)
destroy(this.cb_edit_menu_item)
destroy(this.cb_move_menu_item)
destroy(this.cb_delete_menu_item)
destroy(this.cb_new_menu_item)
destroy(this.st_menu_items_title)
end on

event resize;call super::resize;
dw_menu_items.x = (width - dw_menu_items.width) / 2
dw_menu_items.height = height - dw_menu_items.y - 150

st_menu_items_title.x = dw_menu_items.x

cb_edit_menu_item.x = dw_menu_items.x + dw_menu_items.width + 200
cb_move_menu_item.x = cb_edit_menu_item.x
cb_delete_menu_item.x = cb_edit_menu_item.x
cb_new_menu_item.x = cb_edit_menu_item.x


end event

type pb_epro_help from w_svc_config_object_base`pb_epro_help within w_svc_config_menu
end type

type st_config_mode_menu from w_svc_config_object_base`st_config_mode_menu within w_svc_config_menu
end type

type cb_finished from w_svc_config_object_base`cb_finished within w_svc_config_menu
integer x = 3474
integer y = 1596
end type

type st_title from w_svc_config_object_base`st_title within w_svc_config_menu
end type

type st_2 from w_svc_config_object_base`st_2 within w_svc_config_menu
end type

type st_report_description from w_svc_config_object_base`st_report_description within w_svc_config_menu
end type

type cb_change_name from w_svc_config_object_base`cb_change_name within w_svc_config_menu
end type

type cb_change_status from w_svc_config_object_base`cb_change_status within w_svc_config_menu
end type

type st_config_object_id from w_svc_config_object_base`st_config_object_id within w_svc_config_menu
end type

type st_config_object_id_title from w_svc_config_object_base`st_config_object_id_title within w_svc_config_menu
end type

type st_status from w_svc_config_object_base`st_status within w_svc_config_menu
end type

type st_status_title from w_svc_config_object_base`st_status_title within w_svc_config_menu
end type

type st_context_object from w_svc_config_object_base`st_context_object within w_svc_config_menu
end type

type st_context_object_title from w_svc_config_object_base`st_context_object_title within w_svc_config_menu
end type

type cb_change_context from w_svc_config_object_base`cb_change_context within w_svc_config_menu
end type

type st_report_category from w_svc_config_object_base`st_report_category within w_svc_config_menu
end type

type st_report_category_title from w_svc_config_object_base`st_report_category_title within w_svc_config_menu
end type

type cb_change_report_category from w_svc_config_object_base`cb_change_report_category within w_svc_config_menu
end type

type cb_copy_report from w_svc_config_object_base`cb_copy_report within w_svc_config_menu
end type

type st_not_copyable from w_svc_config_object_base`st_not_copyable within w_svc_config_menu
end type

type st_owner from w_svc_config_object_base`st_owner within w_svc_config_menu
end type

type st_owner_title from w_svc_config_object_base`st_owner_title within w_svc_config_menu
end type

type cb_checkout from w_svc_config_object_base`cb_checkout within w_svc_config_menu
end type

type st_checkout from w_svc_config_object_base`st_checkout within w_svc_config_menu
end type

type st_checkout_title from w_svc_config_object_base`st_checkout_title within w_svc_config_menu
end type

type st_version from w_svc_config_object_base`st_version within w_svc_config_menu
end type

type st_version_title from w_svc_config_object_base`st_version_title within w_svc_config_menu
end type

type dw_menu_items from u_dw_pick_list within w_svc_config_menu
integer x = 1051
integer y = 812
integer width = 1902
integer height = 616
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_sp_get_menu_items"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;
if editable then
	cb_edit_menu_item.enabled = true
	cb_move_menu_item.enabled = true
	cb_delete_menu_item.enabled = true
else
	clear_selected()
end if

end event

event unselected;call super::unselected;cb_edit_menu_item.enabled = false
cb_move_menu_item.enabled = false
cb_delete_menu_item.enabled = false

end event

type cb_edit_menu_item from commandbutton within w_svc_config_menu
integer x = 3122
integer y = 836
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

type cb_move_menu_item from commandbutton within w_svc_config_menu
integer x = 3122
integer y = 968
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

type cb_delete_menu_item from commandbutton within w_svc_config_menu
integer x = 3122
integer y = 1100
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

type cb_new_menu_item from commandbutton within w_svc_config_menu
integer x = 3122
integer y = 1320
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

end event

type st_menu_items_title from statictext within w_svc_config_menu
integer x = 1051
integer y = 712
integer width = 1902
integer height = 80
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Menu Items"
alignment alignment = center!
boolean focusrectangle = false
end type

