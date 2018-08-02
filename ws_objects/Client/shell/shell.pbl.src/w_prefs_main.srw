$PBExportHeader$w_prefs_main.srw
forward
global type w_prefs_main from w_window_base
end type
type cb_exit from commandbutton within w_prefs_main
end type
type st_title from statictext within w_prefs_main
end type
type pb_up from u_picture_button within w_prefs_main
end type
type pb_down from u_picture_button within w_prefs_main
end type
type st_page from statictext within w_prefs_main
end type
type dw_menu from u_dw_pick_list within w_prefs_main
end type
end forward

global type w_prefs_main from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_exit cb_exit
st_title st_title
pb_up pb_up
pb_down pb_down
st_page st_page
dw_menu dw_menu
end type
global w_prefs_main w_prefs_main

type variables
boolean sticky_logon
long menu_id

end variables

on w_prefs_main.create
int iCurrent
call super::create
this.cb_exit=create cb_exit
this.st_title=create st_title
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.dw_menu=create dw_menu
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_exit
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.pb_down
this.Control[iCurrent+5]=this.st_page
this.Control[iCurrent+6]=this.dw_menu
end on

on w_prefs_main.destroy
call super::destroy
destroy(this.cb_exit)
destroy(this.st_title)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.dw_menu)
end on

event open;call super::open;string ls_null
string ls_menu_item_type
string ls_context
integer i
integer li_sts
long ll_row

setnull(ls_null)

sticky_logon = current_scribe.sticky_logon
current_scribe.sticky_logon = true

ls_context = Message.Stringparm

pb_epro_help.context = ls_context

// Set the title
If ls_context = "Utility" Then st_title.text = 'Utilities'

menu_id = f_get_context_menu(ls_context, ls_null)
if isnull(menu_id) then
	log.log(this, "w_prefs_main.open.0022", "Unable to determine "+ls_context+" menu", 4)
	close(this)
	return
end if

menu = datalist.get_menu(menu_id)
st_config_mode_menu.text = menu.description

if config_mode then
	st_config_mode_menu.visible = true
else
	st_config_mode_menu.visible = false
end if

for i = 1 to menu.menu_item_count
	ll_row = dw_menu.insertrow(0)
	dw_menu.object.menu_id[ll_row] = menu.menu_id
	dw_menu.object.menu_item_id[ll_row] = menu.menu_item[i].menu_item_id
	dw_menu.object.menu_item_type[ll_row] = menu.menu_item[i].menu_item_type
	dw_menu.object.menu_item[ll_row] = menu.menu_item[i].menu_item
	dw_menu.object.button[ll_row] = menu.menu_item[i].button
	dw_menu.object.button_title[ll_row] = menu.menu_item[i].button_title
	dw_menu.object.button_help[ll_row] = menu.menu_item[i].button_help
	dw_menu.object.sort_sequence[ll_row] = menu.menu_item[i].sort_sequence
next

dw_menu.sort()
dw_menu.last_page = 0
dw_menu.set_page(1,pb_up,pb_down,st_page)


end event

event close;call super::close;current_scribe.sticky_logon = sticky_logon

end event

type pb_epro_help from w_window_base`pb_epro_help within w_prefs_main
boolean visible = true
integer x = 78
integer y = 1660
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_prefs_main
integer x = 736
integer y = 1740
integer width = 1371
integer height = 72
end type

type cb_exit from commandbutton within w_prefs_main
integer x = 2427
integer y = 1644
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Exit"
boolean cancel = true
boolean default = true
end type

event clicked;close(parent)

end event

type st_title from statictext within w_prefs_main
integer width = 2921
integer height = 112
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "EncounterPRO Configuration"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_prefs_main
boolean visible = false
integer x = 2135
integer y = 140
integer width = 137
integer height = 116
integer taborder = 11
boolean bringtotop = true
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_menu.current_page

dw_menu.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_prefs_main
boolean visible = false
integer x = 2135
integer y = 268
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

li_page = dw_menu.current_page
li_last_page = dw_menu.last_page

dw_menu.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type st_page from statictext within w_prefs_main
boolean visible = false
integer x = 2281
integer y = 140
integer width = 270
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
boolean focusrectangle = false
end type

type dw_menu from u_dw_pick_list within w_prefs_main
integer x = 745
integer y = 132
integer width = 1394
integer height = 1568
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_menu_item_pick_list"
boolean border = false
boolean livescroll = false
end type

event selected(long selected_row);call super::selected;long ll_menu_id
long ll_menu_item_id
integer li_sts

ll_menu_id = object.menu_id[selected_row]
ll_menu_item_id = object.menu_item_id[selected_row]

li_sts = f_do_menu_item(ll_menu_id, ll_menu_item_id)

clear_selected()

end event

