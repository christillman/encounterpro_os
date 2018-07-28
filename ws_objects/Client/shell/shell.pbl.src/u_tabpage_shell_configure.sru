$PBExportHeader$u_tabpage_shell_configure.sru
forward
global type u_tabpage_shell_configure from u_main_tabpage_base
end type
type tv_practice_config from u_tv_configuration within u_tabpage_shell_configure
end type
type st_config_mode_menu from statictext within u_tabpage_shell_configure
end type
type dw_menu from u_dw_pick_list within u_tabpage_shell_configure
end type
type cb_toggle_mode from commandbutton within u_tabpage_shell_configure
end type
end forward

global type u_tabpage_shell_configure from u_main_tabpage_base
integer width = 2990
integer height = 2396
event resized ( )
tv_practice_config tv_practice_config
st_config_mode_menu st_config_mode_menu
dw_menu dw_menu
cb_toggle_mode cb_toggle_mode
end type
global u_tabpage_shell_configure u_tabpage_shell_configure

type variables
boolean old_config
long menu_id
str_menu menu


end variables

forward prototypes
public function integer initialize ()
public subroutine reselect_menu ()
public subroutine refresh ()
end prototypes

event resized();
dw_menu.x = (width - dw_menu.width) / 2
dw_menu.y = 0
dw_menu.height = height

st_config_mode_menu.x = 0
st_config_mode_menu.y = height - st_config_mode_menu.height

tv_practice_config.width = width
tv_practice_config.height = height - tv_practice_config.y

end event

public function integer initialize ();string ls_null

setnull(ls_null)

menu_id = f_get_context_menu(tag, ls_null)
if isnull(menu_id) then
	log.log(this, "open", "Unable to determine " + tag + " menu", 4)
	return -1
end if

this.event trigger resized()

if tag <> "CONFIG" then
	cb_toggle_mode.visible = false
end if

reselect_menu()

end function

public subroutine reselect_menu ();long i
long ll_row
integer li_sts
boolean lb_allow_editing

if tag = "CONFIG" then
	old_config = datalist.get_preference_boolean("Shell", "Use Old Configuration List", false)
else
	old_config = true
end if

menu = datalist.get_menu(menu_id)
st_config_mode_menu.text = menu.description

dw_menu.reset()
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

if isnull(current_scribe) then
	tv_practice_config.visible = false
else
	tv_practice_config.visible = true
	lb_allow_editing = current_scribe.check_privilege("Practice Configuration")
	li_sts = tv_practice_config.display_root(lb_allow_editing)
end if

cb_toggle_mode.x = width - cb_toggle_mode.width - 100
cb_toggle_mode.y = height - cb_toggle_mode.height
cb_toggle_mode.bringtotop = true

end subroutine

public subroutine refresh ();integer li_sts
boolean lb_allow_editing

tv_practice_config.width = width

if old_config then
	dw_menu.visible = true
	tv_practice_config.visible = false

	if config_mode then
		st_config_mode_menu.visible = true
	else
		st_config_mode_menu.visible = false
	end if
else
	dw_menu.visible = false
	st_config_mode_menu.visible = false

	if isnull(current_scribe) then
		tv_practice_config.visible = false
	else
		tv_practice_config.visible = true
	end if
end if

cb_toggle_mode.x = width - cb_toggle_mode.width - 100
cb_toggle_mode.y = height - cb_toggle_mode.height
cb_toggle_mode.bringtotop = true

end subroutine

on u_tabpage_shell_configure.create
int iCurrent
call super::create
this.tv_practice_config=create tv_practice_config
this.st_config_mode_menu=create st_config_mode_menu
this.dw_menu=create dw_menu
this.cb_toggle_mode=create cb_toggle_mode
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tv_practice_config
this.Control[iCurrent+2]=this.st_config_mode_menu
this.Control[iCurrent+3]=this.dw_menu
this.Control[iCurrent+4]=this.cb_toggle_mode
end on

on u_tabpage_shell_configure.destroy
call super::destroy
destroy(this.tv_practice_config)
destroy(this.st_config_mode_menu)
destroy(this.dw_menu)
destroy(this.cb_toggle_mode)
end on

type tv_practice_config from u_tv_configuration within u_tabpage_shell_configure
integer width = 2359
integer height = 1828
integer taborder = 20
long backcolor = 12632256
boolean border = false
end type

type st_config_mode_menu from statictext within u_tabpage_shell_configure
boolean visible = false
integer y = 1448
integer width = 1202
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
alignment alignment = right!
boolean focusrectangle = false
end type

event clicked;w_menu_edit lw_window
str_popup popup
w_menu_display lw_menu_display

//if menu.menu_id > 0 then
//	openwithparm(lw_window, menu.menu_id, "w_menu_edit")
//end if

SELECT CAST(id AS varchar(38))
INTO :popup.items[1]
FROM c_menu
WHERE menu_id = :menu.menu_id;
if not tf_check() then return
popup.items[2] = f_boolean_to_string(true)
popup.data_row_count = 2
openwithparm(lw_menu_display, popup, "w_menu_display")

reselect_menu( )
end event

type dw_menu from u_dw_pick_list within u_tabpage_shell_configure
integer x = 439
integer width = 1490
integer height = 1512
integer taborder = 10
string dataobject = "dw_menu_item_pick_list"
boolean vscrollbar = true
boolean border = false
end type

event resize;call super::resize;dw_menu.height = height

end event

event selected;call super::selected;long ll_menu_id
long ll_menu_item_id
integer li_sts
boolean lb_sticky_logon

ll_menu_id = object.menu_id[selected_row]
ll_menu_item_id = object.menu_item_id[selected_row]

lb_sticky_logon = current_scribe.sticky_logon
current_scribe.sticky_logon = true

li_sts = f_do_menu_item(ll_menu_id, ll_menu_item_id)

current_scribe.sticky_logon = lb_sticky_logon

clear_selected()

end event

type cb_toggle_mode from commandbutton within u_tabpage_shell_configure
integer x = 2491
integer y = 1816
integer width = 361
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Switch View"
end type

event clicked;old_config = not old_config

refresh()

end event

