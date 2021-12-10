$PBExportHeader$w_pop_legend.srw
forward
global type w_pop_legend from w_window_base
end type
type dw_legend from u_dw_pick_list within w_pop_legend
end type
type st_title from statictext within w_pop_legend
end type
type cb_ok from commandbutton within w_pop_legend
end type
end forward

global type w_pop_legend from w_window_base
integer x = 599
integer y = 300
integer width = 1774
integer height = 1252
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
dw_legend dw_legend
st_title st_title
cb_ok cb_ok
end type
global w_pop_legend w_pop_legend

type variables
string domain_id

end variables

event open;call super::open;integer i
str_point pt

domain_id = message.stringparm

dw_legend.settransobject(sqlca)
dw_legend.retrieve(domain_id)

end event

on w_pop_legend.create
int iCurrent
call super::create
this.dw_legend=create dw_legend
this.st_title=create st_title
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_legend
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_ok
end on

on w_pop_legend.destroy
call super::destroy
destroy(this.dw_legend)
destroy(this.st_title)
destroy(this.cb_ok)
end on

type dw_legend from u_dw_pick_list within w_pop_legend
integer x = 32
integer y = 128
integer width = 1719
integer height = 884
integer taborder = 10
boolean enabled = false
string dataobject = "dw_c_domain_item_bitmap"
boolean vscrollbar = true
boolean border = false
end type

type st_title from statictext within w_pop_legend
integer width = 1751
integer height = 104
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Legend"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_pop_legend
integer x = 649
integer y = 1056
integer width = 453
integer height = 124
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;
close(parent)

end event

