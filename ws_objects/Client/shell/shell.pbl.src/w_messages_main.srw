$PBExportHeader$w_messages_main.srw
forward
global type w_messages_main from w_window_base
end type
type tab_messages from u_tab_messages within w_messages_main
end type
type tab_messages from u_tab_messages within w_messages_main
end type
type st_title from statictext within w_messages_main
end type
type cb_exit from commandbutton within w_messages_main
end type
end forward

global type w_messages_main from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
tab_messages tab_messages
st_title st_title
cb_exit cb_exit
end type
global w_messages_main w_messages_main

type variables
boolean sticky_logon

string specialty_id
string top_20_code

end variables

on w_messages_main.create
int iCurrent
call super::create
this.tab_messages=create tab_messages
this.st_title=create st_title
this.cb_exit=create cb_exit
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_messages
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_exit
end on

on w_messages_main.destroy
call super::destroy
destroy(this.tab_messages)
destroy(this.st_title)
destroy(this.cb_exit)
end on

event open;call super::open;integer li_role_count
str_role lstra_roles[]
u_tabpage_todo_items luo_tabpage
integer i

tab_messages.initialize()

li_role_count = user_list.roles_assigned_to_user(current_user.user_id, lstra_roles)

for i = 1 to li_role_count
	luo_tabpage = tab_messages.open_page("u_tabpage_todo_items", false)
	if isnull(luo_tabpage) then
		log.log(this, "open", "Error opening role-todo-items tab page", 4)
		exit
	end if
	
	luo_tabpage.user_id = lstra_roles[i].role_id
	luo_tabpage.text = lstra_roles[i].role_name + " Todo Items"
	luo_tabpage.initialize()
next

sticky_logon = current_scribe.sticky_logon
current_scribe.sticky_logon = true

end event

event close;call super::close;if not isnull(current_scribe) then
	current_scribe.sticky_logon = sticky_logon
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_messages_main
boolean visible = true
integer x = 2665
integer y = 12
end type

type tab_messages from u_tab_messages within w_messages_main
integer y = 124
integer width = 2921
integer height = 1700
integer taborder = 20
boolean bringtotop = true
long backcolor = 33538240
boolean multiline = true
end type

type st_title from statictext within w_messages_main
integer width = 2921
integer height = 112
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "EncounterPRO Message Center"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_exit from commandbutton within w_messages_main
integer x = 2551
integer y = 1684
integer width = 320
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Exit"
end type

event clicked;tab_messages.close_pages()
close(parent)

end event

