$PBExportHeader$w_demorte_main.srw
$PBExportComments$Generated SDI Main Window
forward
global type w_demorte_main from window
end type
type rte_1 from richtextedit within w_demorte_main
end type
end forward

global type w_demorte_main from window
integer width = 2949
integer height = 1920
boolean titlebar = true
string title = "Main Window"
string menuname = "m_demorte_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 79416533
boolean center = true
rte_1 rte_1
end type
global w_demorte_main w_demorte_main

on w_demorte_main.create
if this.MenuName = "m_demorte_main" then this.MenuID = create m_demorte_main
this.rte_1=create rte_1
this.Control[]={this.rte_1}
end on

on w_demorte_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rte_1)
end on

event open;

long ll_color
ll_color = 7191717
ll_color = ChooseColor(ll_color)

messagebox("Color","You chose " + string(ll_color))
end event

type rte_1 from richtextedit within w_demorte_main
integer x = 434
integer y = 180
integer width = 1157
integer height = 1040
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
borderstyle borderstyle = stylelowered!
end type

