HA$PBExportHeader$w_svc_config_controller.srw
forward
global type w_svc_config_controller from w_svc_config_object_base
end type
type cb_delete_hotspot from commandbutton within w_svc_config_controller
end type
type hotspots from u_dw_pick_list within w_svc_config_controller
end type
type cb_new_hotspot from commandbutton within w_svc_config_controller
end type
type cb_change_menu from commandbutton within w_svc_config_controller
end type
type cb_configure_menu from commandbutton within w_svc_config_controller
end type
end forward

global type w_svc_config_controller from w_svc_config_object_base
cb_delete_hotspot cb_delete_hotspot
hotspots hotspots
cb_new_hotspot cb_new_hotspot
cb_change_menu cb_change_menu
cb_configure_menu cb_configure_menu
end type
global w_svc_config_controller w_svc_config_controller

forward prototypes
public function integer refresh ()
public function integer new_hotspot ()
public function integer change_menu (long pl_row)
public function integer delete_hotspot (long pl_row)
end prototypes

public function integer refresh ();long ll_rows


super::refresh()

hotspots.settransobject(sqlca)
ll_rows = hotspots.retrieve(config_object_info.config_object_id)

if editable then
	cb_new_hotspot.visible = true
	cb_delete_hotspot.visible = true
	cb_change_menu.visible = true
	cb_configure_menu.visible = true
else
	cb_new_hotspot.visible = false
	cb_delete_hotspot.visible = false
	cb_change_menu.visible = false
	cb_configure_menu.visible = false
end if


return 1

end function

public function integer new_hotspot ();str_pick_config_object lstr_pick_config_object
w_pick_config_object lw_pick
integer li_sts
str_popup popup
str_popup_return popup_return
string ls_context_object
string ls_hotspot_name
string ls_report_id
string ls_null
long ll_sts
long ll_count
string ls_long_description
long ll_row
string ls_menu_config_object_id

setnull(ls_null)
setnull(ls_long_description)

DO WHILE true
	popup.title = "Enter name of new hotspot"
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return 0
	
	ls_hotspot_name = popup_return.items[1]
	
	SELECT count(*)
	INTO :ll_count
	FROM c_Controller_Hotspots
	WHERE config_object_id = :config_object_info.config_object_id
	AND hotspot_name = :ls_hotspot_name;
	if not tf_check() then return -1
	if ll_count > 0 then
		openwithparm(w_pop_message, "There is already a hotspot or report with that title.  Please enter a different title for the new hotspot.")
	else
		exit
	end if
LOOP

popup.title = "Select hotspot Context"
popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "CONTEXT_OBJECT"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_context_object = popup_return.items[1]


lstr_pick_config_object.config_object_type = "Menu"
lstr_pick_config_object.context_object = config_object_info.context_object

openwithparm(lw_pick, lstr_pick_config_object, "w_pick_config_object")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	setnull(ls_menu_config_object_id)
else
	ls_menu_config_object_id = popup_return.items[1]
end if


ll_row = hotspots.insertrow(0)
hotspots.object.config_object_id[ll_row] = config_object_info.config_object_id
hotspots.object.hotspot_name[ll_row] = ls_hotspot_name
hotspots.object.context_object[ll_row] = ls_context_object
hotspots.object.menu_config_object_id[ll_row] = ls_menu_config_object_id
hotspots.object.created_by[ll_row] = current_scribe.user_id

li_sts = hotspots.update()
if li_sts <= 0 then return -1

return 1


end function

public function integer change_menu (long pl_row);str_pick_config_object lstr_pick_config_object
w_pick_config_object lw_pick
integer li_sts
str_popup popup
str_popup_return popup_return
string ls_context_object
string ls_hotspot_name
string ls_report_id
string ls_null
long ll_sts
long ll_count
string ls_long_description

if isnull(pl_row) or pl_row <= 0 then return 0

lstr_pick_config_object.config_object_type = "Menu"
lstr_pick_config_object.context_object = config_object_info.context_object

openwithparm(lw_pick, lstr_pick_config_object, "w_pick_config_object")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

hotspots.object.menu_config_object_id[pl_row] = popup_return.items[1]

li_sts = hotspots.update()
if li_sts <= 0 then return -1

return 1


end function

public function integer delete_hotspot (long pl_row);str_pick_config_object lstr_pick_config_object
w_pick_config_object lw_pick
integer li_sts
str_popup popup
str_popup_return popup_return
string ls_context_object
string ls_hotspot_name
string ls_report_id
string ls_null
long ll_sts
long ll_count
string ls_long_description
long ll_menu_id
string ls_menu_config_object_id

if isnull(pl_row) or pl_row <= 0 then return 0


hotspots.deleterow(pl_row)

li_sts = hotspots.update()
if li_sts <= 0 then return -1

return 1


end function

on w_svc_config_controller.create
int iCurrent
call super::create
this.cb_delete_hotspot=create cb_delete_hotspot
this.hotspots=create hotspots
this.cb_new_hotspot=create cb_new_hotspot
this.cb_change_menu=create cb_change_menu
this.cb_configure_menu=create cb_configure_menu
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_delete_hotspot
this.Control[iCurrent+2]=this.hotspots
this.Control[iCurrent+3]=this.cb_new_hotspot
this.Control[iCurrent+4]=this.cb_change_menu
this.Control[iCurrent+5]=this.cb_configure_menu
end on

on w_svc_config_controller.destroy
call super::destroy
destroy(this.cb_delete_hotspot)
destroy(this.hotspots)
destroy(this.cb_new_hotspot)
destroy(this.cb_change_menu)
destroy(this.cb_configure_menu)
end on

event resize;call super::resize;
hotspots.x = 200 + ((width - 4000) / 2)
cb_new_hotspot.x = hotspots.x + hotspots.width + 100
cb_change_menu.x = cb_new_hotspot.x
cb_delete_hotspot.x = cb_new_hotspot.x
cb_configure_menu.x = cb_new_hotspot.x

hotspots.height = cb_finished.y - hotspots.y - 50


end event

type pb_epro_help from w_svc_config_object_base`pb_epro_help within w_svc_config_controller
end type

type st_config_mode_menu from w_svc_config_object_base`st_config_mode_menu within w_svc_config_controller
end type

type cb_finished from w_svc_config_object_base`cb_finished within w_svc_config_controller
integer x = 3497
integer y = 1604
end type

type st_title from w_svc_config_object_base`st_title within w_svc_config_controller
end type

type st_2 from w_svc_config_object_base`st_2 within w_svc_config_controller
end type

type st_report_description from w_svc_config_object_base`st_report_description within w_svc_config_controller
end type

type cb_change_name from w_svc_config_object_base`cb_change_name within w_svc_config_controller
end type

type cb_change_status from w_svc_config_object_base`cb_change_status within w_svc_config_controller
end type

type st_config_object_id from w_svc_config_object_base`st_config_object_id within w_svc_config_controller
end type

type st_config_object_id_title from w_svc_config_object_base`st_config_object_id_title within w_svc_config_controller
end type

type st_status from w_svc_config_object_base`st_status within w_svc_config_controller
end type

type st_status_title from w_svc_config_object_base`st_status_title within w_svc_config_controller
end type

type st_context_object from w_svc_config_object_base`st_context_object within w_svc_config_controller
end type

type st_context_object_title from w_svc_config_object_base`st_context_object_title within w_svc_config_controller
end type

type cb_change_context from w_svc_config_object_base`cb_change_context within w_svc_config_controller
end type

type st_report_category from w_svc_config_object_base`st_report_category within w_svc_config_controller
end type

type st_report_category_title from w_svc_config_object_base`st_report_category_title within w_svc_config_controller
end type

type cb_change_report_category from w_svc_config_object_base`cb_change_report_category within w_svc_config_controller
end type

type cb_copy_report from w_svc_config_object_base`cb_copy_report within w_svc_config_controller
end type

type st_not_copyable from w_svc_config_object_base`st_not_copyable within w_svc_config_controller
end type

type st_owner from w_svc_config_object_base`st_owner within w_svc_config_controller
end type

type st_owner_title from w_svc_config_object_base`st_owner_title within w_svc_config_controller
end type

type cb_checkout from w_svc_config_object_base`cb_checkout within w_svc_config_controller
end type

type st_checkout from w_svc_config_object_base`st_checkout within w_svc_config_controller
end type

type st_checkout_title from w_svc_config_object_base`st_checkout_title within w_svc_config_controller
end type

type st_version from w_svc_config_object_base`st_version within w_svc_config_controller
end type

type st_version_title from w_svc_config_object_base`st_version_title within w_svc_config_controller
end type

type cb_save_to_file from w_svc_config_object_base`cb_save_to_file within w_svc_config_controller
end type

type cb_delete_hotspot from commandbutton within w_svc_config_controller
integer x = 3465
integer y = 1016
integer width = 489
integer height = 112
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Delete Hotspot"
end type

event clicked;integer li_sts
long ll_row

ll_row = hotspots.get_selected_row( )
if ll_row <= 0 then return

li_sts = delete_hotspot(ll_row)

refresh()


end event

type hotspots from u_dw_pick_list within w_svc_config_controller
integer x = 197
integer y = 740
integer width = 3223
integer height = 900
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_controller_hotspots"
boolean vscrollbar = true
end type

event selected;call super::selected;string ls_menu_config_object_id

if editable then
	cb_change_menu.enabled = true
	cb_delete_hotspot.enabled = true
	ls_menu_config_object_id = object.menu_config_object_id[selected_row]
	if len(ls_menu_config_object_id) > 0 then
		cb_configure_menu.enabled = true
	else
		cb_configure_menu.enabled = false
	end if
else
	clear_selected()
end if
end event

event unselected;call super::unselected;cb_change_menu.enabled = false
cb_delete_hotspot.enabled = false

end event

type cb_new_hotspot from commandbutton within w_svc_config_controller
integer x = 3465
integer y = 820
integer width = 489
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New HotSpot"
end type

event clicked;integer li_sts

li_sts = new_hotspot()

refresh()

end event

type cb_change_menu from commandbutton within w_svc_config_controller
integer x = 3465
integer y = 1212
integer width = 489
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Change Menu"
end type

event clicked;integer li_sts
long ll_row

ll_row = hotspots.get_selected_row( )
if ll_row <= 0 then return

li_sts = change_menu(ll_row)

refresh()


end event

type cb_configure_menu from commandbutton within w_svc_config_controller
integer x = 3465
integer y = 1408
integer width = 489
integer height = 112
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Configure Menu"
end type

event clicked;integer li_sts
long ll_row
string ls_menu_config_object_id

ll_row = hotspots.get_selected_row( )
if ll_row <= 0 then return

ls_menu_config_object_id = hotspots.object.menu_config_object_id[ll_row]

f_configure_config_object(ls_menu_config_object_id)


end event

