HA$PBExportHeader$w_attributes_display.srw
forward
global type w_attributes_display from w_window_base
end type
type cb_ok from commandbutton within w_attributes_display
end type
type dw_display from u_dw_pick_list within w_attributes_display
end type
end forward

global type w_attributes_display from w_window_base
integer x = 649
integer y = 400
integer width = 1614
integer height = 1024
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_ok cb_ok
dw_display dw_display
end type
global w_attributes_display w_attributes_display

event open;call super::open;str_attributes lstr_attributes
integer i
long ll_row

lstr_attributes = message.powerobjectparm
for i = 1 to lstr_attributes.attribute_count
	ll_row = dw_display.insertrow(0)
	dw_display.object.attribute[ll_row] = lstr_attributes.attribute[i].attribute
	dw_display.object.value[ll_row] = lstr_attributes.attribute[i].value
next


end event

on w_attributes_display.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.dw_display=create dw_display
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.dw_display
end on

on w_attributes_display.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.dw_display)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_attributes_display
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_attributes_display
end type

type cb_ok from commandbutton within w_attributes_display
integer x = 1083
integer y = 832
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;close(parent)

end event

type dw_display from u_dw_pick_list within w_attributes_display
integer x = 87
integer y = 68
integer width = 1399
integer height = 704
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_attribute_value_display"
end type

