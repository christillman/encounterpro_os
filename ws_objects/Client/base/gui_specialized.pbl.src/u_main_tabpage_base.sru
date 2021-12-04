$PBExportHeader$u_main_tabpage_base.sru
forward
global type u_main_tabpage_base from userobject
end type
end forward

global type u_main_tabpage_base from userobject
integer width = 411
integer height = 432
long backcolor = COLOR_BACKGROUND
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event refresh ( )
end type
global u_main_tabpage_base u_main_tabpage_base

type variables
end variables

event refresh();
// implement in descendant
end event

on u_main_tabpage_base.create
end on

on u_main_tabpage_base.destroy
end on

