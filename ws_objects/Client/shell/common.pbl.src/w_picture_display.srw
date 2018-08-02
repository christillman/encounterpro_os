$PBExportHeader$w_picture_display.srw
forward
global type w_picture_display from w_window_base
end type
type uo_display from u_picture_display within w_picture_display
end type
type cb_ok from commandbutton within w_picture_display
end type
end forward

global type w_picture_display from w_window_base
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
uo_display uo_display
cb_ok cb_ok
end type
global w_picture_display w_picture_display

on w_picture_display.create
int iCurrent
call super::create
this.uo_display=create uo_display
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_display
this.Control[iCurrent+2]=this.cb_ok
end on

on w_picture_display.destroy
call super::destroy
destroy(this.uo_display)
destroy(this.cb_ok)
end on

event open;call super::open;string ls_file

ls_file = message.stringparm

if isnull(ls_file) then
	log.log(this, "w_picture_display.open.0006", "Null file", 4)
	close(this)
	return
end if

if not fileexists(ls_file) then
	log.log(this, "w_picture_display.open.0006", "File not found (" + ls_file + ")", 4)
	close(this)
	return
end if

uo_display.initialize()

uo_display.display_picture(ls_file)


end event

type pb_epro_help from w_window_base`pb_epro_help within w_picture_display
boolean visible = true
integer x = 64
integer y = 1672
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_picture_display
end type

type uo_display from u_picture_display within w_picture_display
integer x = 46
integer y = 32
integer width = 2839
integer height = 1596
integer taborder = 20
boolean bringtotop = true
boolean border = true
end type

on uo_display.destroy
call u_picture_display::destroy
end on

type cb_ok from commandbutton within w_picture_display
integer x = 2473
integer y = 1672
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
string text = "OK"
end type

event clicked;close(parent)

end event

