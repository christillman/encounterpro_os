HA$PBExportHeader$u_pb_help_button.sru
forward
global type u_pb_help_button from picturebutton
end type
end forward

global type u_pb_help_button from picturebutton
integer width = 229
integer height = 104
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "buttonhelp.bmp"
string disabledname = "buttonhelp.bmp"
alignment htextalign = left!
end type
global u_pb_help_button u_pb_help_button

type variables
string context

end variables

event clicked;string ls_context

ls_context = parent.classname()
if len(context) > 0 then
	ls_context += "-" + context
end if

f_display_help(ls_context, "USER", false)

end event

on u_pb_help_button.create
end on

on u_pb_help_button.destroy
end on

