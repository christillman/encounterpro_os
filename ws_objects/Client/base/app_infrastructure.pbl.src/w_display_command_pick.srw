$PBExportHeader$w_display_command_pick.srw
forward
global type w_display_command_pick from w_window_base
end type
type st_co_1 from statictext within w_display_command_pick
end type
type st_co_2 from statictext within w_display_command_pick
end type
type st_co_3 from statictext within w_display_command_pick
end type
type st_co_4 from statictext within w_display_command_pick
end type
type st_co_5 from statictext within w_display_command_pick
end type
type mle_command_help from multilineedit within w_display_command_pick
end type
type st_1 from statictext within w_display_command_pick
end type
type cb_ok from commandbutton within w_display_command_pick
end type
type cb_cancel from commandbutton within w_display_command_pick
end type
type dw_display_command from u_dw_pick_list within w_display_command_pick
end type
type pb_down from u_picture_button within w_display_command_pick
end type
type pb_up from u_picture_button within w_display_command_pick
end type
type st_page from statictext within w_display_command_pick
end type
end forward

global type w_display_command_pick from w_window_base
string title = "EncounterPRO Report Command Create/Edit"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_co_1 st_co_1
st_co_2 st_co_2
st_co_3 st_co_3
st_co_4 st_co_4
st_co_5 st_co_5
mle_command_help mle_command_help
st_1 st_1
cb_ok cb_ok
cb_cancel cb_cancel
dw_display_command dw_display_command
pb_down pb_down
pb_up pb_up
st_page st_page
end type
global w_display_command_pick w_display_command_pick

type variables
string context_object
string script_type



end variables

forward prototypes
public function integer show_commands ()
end prototypes

public function integer show_commands ();long ll_count

dw_display_command.settransobject(sqlca)
ll_count = dw_display_command.retrieve(script_type, context_object)
if ll_count <= 0 then return ll_count

dw_display_command.set_page(1, pb_up, pb_down, st_page)

return 1

end function

on w_display_command_pick.create
int iCurrent
call super::create
this.st_co_1=create st_co_1
this.st_co_2=create st_co_2
this.st_co_3=create st_co_3
this.st_co_4=create st_co_4
this.st_co_5=create st_co_5
this.mle_command_help=create mle_command_help
this.st_1=create st_1
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.dw_display_command=create dw_display_command
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_co_1
this.Control[iCurrent+2]=this.st_co_2
this.Control[iCurrent+3]=this.st_co_3
this.Control[iCurrent+4]=this.st_co_4
this.Control[iCurrent+5]=this.st_co_5
this.Control[iCurrent+6]=this.mle_command_help
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.cb_ok
this.Control[iCurrent+9]=this.cb_cancel
this.Control[iCurrent+10]=this.dw_display_command
this.Control[iCurrent+11]=this.pb_down
this.Control[iCurrent+12]=this.pb_up
this.Control[iCurrent+13]=this.st_page
end on

on w_display_command_pick.destroy
call super::destroy
destroy(this.st_co_1)
destroy(this.st_co_2)
destroy(this.st_co_3)
destroy(this.st_co_4)
destroy(this.st_co_5)
destroy(this.mle_command_help)
destroy(this.st_1)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.dw_display_command)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
end on

event open;call super::open;u_ds_data luo_data
integer li_count
integer i
boolean lb_same
string ls_compatible_context_object
str_script_command_context lstr_context

lstr_context = message.powerobjectparm
script_type = lstr_context.script_type
context_object = lstr_context.context_object

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_v_Compatible_Context_Object")
li_count = luo_data.retrieve(context_object)

for i = 1 to li_count
	ls_compatible_context_object = luo_data.object.compatible_context_object[i]
	if ls_compatible_context_object = context_object then
		lb_same = true
	else
		lb_same = false
	end if
	CHOOSE CASE i
		CASE 1
			st_co_1.text = wordcap(lower(ls_compatible_context_object))
			if lb_same then st_co_1.backcolor = color_object_selected
		CASE 2
			st_co_2.text = wordcap(lower(ls_compatible_context_object))
			if lb_same then st_co_2.backcolor = color_object_selected
		CASE 3
			st_co_3.text = wordcap(lower(ls_compatible_context_object))
			if lb_same then st_co_3.backcolor = color_object_selected
		CASE 4
			st_co_4.text = wordcap(lower(ls_compatible_context_object))
			if lb_same then st_co_4.backcolor = color_object_selected
		CASE 5
			st_co_5.text = wordcap(lower(ls_compatible_context_object))
			if lb_same then st_co_5.backcolor = color_object_selected
	END CHOOSE
next

for i = li_count + 1 to 5
	CHOOSE CASE i
		CASE 1
			st_co_1.visible = false
		CASE 2
			st_co_2.visible = false
		CASE 3
			st_co_3.visible = false
		CASE 4
			st_co_4.visible = false
		CASE 5
			st_co_5.visible = false
	END CHOOSE
next

show_commands()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_display_command_pick
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_display_command_pick
end type

type st_co_1 from statictext within w_display_command_pick
integer x = 23
integer y = 28
integer width = 306
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "General"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_co_1.backcolor = color_object_selected
st_co_2.backcolor = color_object
st_co_3.backcolor = color_object
st_co_4.backcolor = color_object
st_co_5.backcolor = color_object

context_object = lower(text)

show_commands()

end event

type st_co_2 from statictext within w_display_command_pick
integer x = 347
integer y = 28
integer width = 306
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Patient"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_co_1.backcolor = color_object
st_co_2.backcolor = color_object_selected
st_co_3.backcolor = color_object
st_co_4.backcolor = color_object
st_co_5.backcolor = color_object

context_object = lower(text)

show_commands()

end event

type st_co_3 from statictext within w_display_command_pick
integer x = 672
integer y = 28
integer width = 306
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Encounter"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_co_1.backcolor = color_object
st_co_2.backcolor = color_object
st_co_3.backcolor = color_object_selected
st_co_4.backcolor = color_object
st_co_5.backcolor = color_object

context_object = lower(text)

show_commands()

end event

type st_co_4 from statictext within w_display_command_pick
integer x = 997
integer y = 28
integer width = 306
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Assessment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_co_1.backcolor = color_object
st_co_2.backcolor = color_object
st_co_3.backcolor = color_object
st_co_4.backcolor = color_object_selected
st_co_5.backcolor = color_object

context_object = lower(text)

show_commands()

end event

type st_co_5 from statictext within w_display_command_pick
integer x = 1321
integer y = 28
integer width = 306
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Treatment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_co_1.backcolor = color_object
st_co_2.backcolor = color_object
st_co_3.backcolor = color_object
st_co_4.backcolor = color_object
st_co_5.backcolor = color_object_selected

context_object = lower(text)

show_commands()

end event

type mle_command_help from multilineedit within w_display_command_pick
integer x = 1678
integer y = 200
integer width = 1166
integer height = 1232
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_display_command_pick
integer x = 1678
integer y = 120
integer width = 1166
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Command Help"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_display_command_pick
integer x = 2441
integer y = 1580
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;str_c_display_command_definition lstr_command
long ll_row

ll_row = dw_display_command.get_selected_row()
if ll_row <= 0 then return

lstr_command.context_object = dw_display_command.object.context_object[ll_row]
lstr_command.display_command = dw_display_command.object.display_command[ll_row]
lstr_command.description = dw_display_command.object.description[ll_row]
lstr_command.command_help = dw_display_command.object.command_help[ll_row]
lstr_command.script_type = dw_display_command.object.script_type[ll_row]
lstr_command.id = dw_display_command.object.id[ll_row]
lstr_command.min_build = dw_display_command.object.min_build[ll_row]


closewithreturn(parent, lstr_command)

end event

type cb_cancel from commandbutton within w_display_command_pick
integer x = 1934
integer y = 1580
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_c_display_command_definition lstr_command
long ll_row

setnull(lstr_command.context_object)
setnull(lstr_command.display_command)
setnull(lstr_command.description)
setnull(lstr_command.command_help)

closewithreturn(parent, lstr_command)

end event

type dw_display_command from u_dw_pick_list within w_display_command_pick
integer x = 18
integer y = 160
integer width = 1390
integer height = 1556
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_c_display_command_definition"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;mle_command_help.text = object.command_help[selected_row]


end event

event unselected;call super::unselected;mle_command_help.text = ""

end event

type pb_down from u_picture_button within w_display_command_pick
integer x = 1422
integer y = 296
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_display_command.current_page
li_last_page = dw_display_command.last_page

dw_display_command.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type pb_up from u_picture_button within w_display_command_pick
integer x = 1422
integer y = 172
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_display_command.current_page

dw_display_command.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_display_command_pick
integer x = 1426
integer y = 428
integer width = 146
integer height = 124
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Page 99/99"
boolean focusrectangle = false
end type

