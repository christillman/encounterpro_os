HA$PBExportHeader$u_picture_button.sru
forward
global type u_picture_button from picturebutton
end type
end forward

global type u_picture_button from picturebutton
integer width = 247
integer height = 216
integer taborder = 1
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "button16.bmp"
string disabledname = "button16.bmp"
event mouse_move pbm_mousemove
end type
global u_picture_button u_picture_button

type variables
integer button_index
string button_help
end variables

event clicked;w_window_base parent_window

// If this is w_pop_buttons, then trigger the button_pressed event.  Otherwise post it
if parent.classname() = "w_pop_buttons" then
	parent.triggerevent("button_pressed", button_index, button_index)
elseif button_index >= 0 then
	parent_window = parent
	parent_window.event POST button_pressed(button_index)
end if

end event

on u_picture_button.create
end on

on u_picture_button.destroy
end on

event constructor;setnull(button_index)

end event

event rbuttondown;if config_mode then
	openwithparm(w_pop_message, picturename)
end if

end event

