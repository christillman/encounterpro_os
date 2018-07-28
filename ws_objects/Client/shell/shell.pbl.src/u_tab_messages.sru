$PBExportHeader$u_tab_messages.sru
forward
global type u_tab_messages from u_tab_manager
end type
type tabpage_messages from u_tabpage_messages within u_tab_messages
end type
type tabpage_messages from u_tabpage_messages within u_tab_messages
end type
type tabpage_todo from u_tabpage_todo_items within u_tab_messages
end type
type tabpage_todo from u_tabpage_todo_items within u_tab_messages
end type
end forward

global type u_tab_messages from u_tab_manager
integer width = 2706
integer height = 1760
boolean boldselectedtext = true
tabpage_messages tabpage_messages
tabpage_todo tabpage_todo
end type
global u_tab_messages u_tab_messages

on u_tab_messages.create
this.tabpage_messages=create tabpage_messages
this.tabpage_todo=create tabpage_todo
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_messages
this.Control[iCurrent+2]=this.tabpage_todo
end on

on u_tab_messages.destroy
call super::destroy
destroy(this.tabpage_messages)
destroy(this.tabpage_todo)
end on

type tabpage_messages from u_tabpage_messages within u_tab_messages
integer x = 18
integer y = 112
integer width = 2670
integer height = 1632
string text = "My Messages"
long tabbackcolor = 12632256
end type

type tabpage_todo from u_tabpage_todo_items within u_tab_messages
integer x = 18
integer y = 112
integer width = 2670
integer height = 1632
string text = "My Todo Items"
long tabbackcolor = 12632256
end type

