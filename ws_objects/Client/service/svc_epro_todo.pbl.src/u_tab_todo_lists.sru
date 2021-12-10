$PBExportHeader$u_tab_todo_lists.sru
forward
global type u_tab_todo_lists from u_tab_manager
end type
type tabpage_my_todo from u_tabpage_todo_lists within u_tab_todo_lists
end type
type tabpage_my_todo from u_tabpage_todo_lists within u_tab_todo_lists
end type
end forward

global type u_tab_todo_lists from u_tab_manager
integer width = 2875
integer height = 1908
long backcolor = 7191717
boolean boldselectedtext = true
tabpage_my_todo tabpage_my_todo
end type
global u_tab_todo_lists u_tab_todo_lists

type variables

end variables

on u_tab_todo_lists.create
this.tabpage_my_todo=create tabpage_my_todo
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_my_todo
end on

on u_tab_todo_lists.destroy
call super::destroy
destroy(this.tabpage_my_todo)
end on

type tabpage_my_todo from u_tabpage_todo_lists within u_tab_todo_lists
integer x = 18
integer y = 112
integer width = 2839
integer height = 1780
string text = "My Todo Items"
end type

