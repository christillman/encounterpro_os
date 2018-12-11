$PBExportHeader$u_cb_menu_item.sru
forward
global type u_cb_menu_item from commandbutton
end type
end forward

global type u_cb_menu_item from commandbutton
integer width = 571
integer height = 112
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type
global u_cb_menu_item u_cb_menu_item

type variables
integer button_index

end variables

on u_cb_menu_item.create
end on

on u_cb_menu_item.destroy
end on

event clicked;w_window_base lw_parent

if button_index >= 0 then
	lw_parent = parent
	lw_parent.event POST button_pressed(button_index)
end if

end event

