$PBExportHeader$w_todo_main.srw
forward
global type w_todo_main from w_window_base
end type
type cb_exit from commandbutton within w_todo_main
end type
type tab_todo from u_tab_todo_lists within w_todo_main
end type
type tab_todo from u_tab_todo_lists within w_todo_main
end type
end forward

global type w_todo_main from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_exit cb_exit
tab_todo tab_todo
end type
global w_todo_main w_todo_main

type variables
boolean sticky_logon

string specialty_id
string top_20_code

end variables

on w_todo_main.create
int iCurrent
call super::create
this.cb_exit=create cb_exit
this.tab_todo=create tab_todo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_exit
this.Control[iCurrent+2]=this.tab_todo
end on

on w_todo_main.destroy
call super::destroy
destroy(this.cb_exit)
destroy(this.tab_todo)
end on

event open;call super::open;integer li_role_count
str_role lstra_roles[]
u_tabpage_todo_lists luo_tabpage
integer i
long ll_tab_count
string ls_my_todo_office_default
string ls_role_todo_office_default
string ls_my_todo_type_default
string ls_role_todo_type_default
u_ds_data luo_data
long ll_count

ls_role_todo_office_default = datalist.get_preference("PREFERENCES", "role_todo_office_default", "My Office")
ls_role_todo_type_default = datalist.get_preference("PREFERENCES", "role_todo_type_default", "%")

tab_todo.tabpage_my_todo.todo_office_default = datalist.get_preference("PREFERENCES", "my_todo_office_default", "My Office")
tab_todo.tabpage_my_todo.todo_type_default = datalist.get_preference("PREFERENCES", "my_todo_type_default", "%")

tab_todo.initialize(current_user.user_id)

li_role_count = user_list.roles_assigned_to_user(current_user.user_id, lstra_roles)

// Open a page for each office
for i = 1 to li_role_count
	luo_tabpage = tab_todo.open_page("u_tabpage_todo_lists", false)
	if isnull(luo_tabpage) then
		log.log(this, "w_todo_main:open", "Error opening role-todo-items tab page", 4)
		continue
	end if
	
	luo_tabpage.tag = "ROLE"
	luo_tabpage.text = lstra_roles[i].role_name
	luo_tabpage.todo_office_default = ls_role_todo_office_default
	luo_tabpage.todo_type_default = ls_role_todo_type_default
	luo_tabpage.initialize(lstra_roles[i].role_id)
next

if f_string_to_boolean(datalist.get_preference("PREFERENCES", "todo_show_subordinates", "True")) then
	luo_data = CREATE u_ds_data
	luo_data.set_dataobject("dw_user_subordinates")
	ll_count = luo_data.retrieve(current_user.user_id)
	for i = 1 to ll_count
		// Open a page for each subordinate
		luo_tabpage = tab_todo.open_page("u_tabpage_todo_lists", false)
		if isnull(luo_tabpage) then
			log.log(this, "w_todo_main:open", "Error opening subordinate-todo-items tab page", 4)
			continue
		end if
		
		luo_tabpage.tag = "SUBORDINATE"
		luo_tabpage.text = luo_data.object.user_full_name[i]
		luo_tabpage.todo_office_default = "My Office"
		luo_tabpage.todo_type_default = "%"
		luo_tabpage.initialize(luo_data.object.user_id[i])
	next
end if

if current_user.check_privilege("See Other Users Todo") then
	// Open a page for other users
	luo_tabpage = tab_todo.open_page("u_tabpage_todo_lists", false)
	if isnull(luo_tabpage) then
		log.log(this, "w_todo_main:open", "Error opening role-todo-items tab page", 4)
	end if
	
	luo_tabpage.tag = "OTHER"
	luo_tabpage.text = "Other"
	luo_tabpage.todo_office_default = "All Offices"
	luo_tabpage.todo_type_default = "%"
	luo_tabpage.initialize("%OTHER%")
end if


sticky_logon = current_scribe.sticky_logon
current_scribe.sticky_logon = true

tab_todo.resize_tabs(width, height)

end event

event close;call super::close;if not isnull(current_scribe) then
	current_scribe.sticky_logon = sticky_logon
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_todo_main
boolean visible = true
integer x = 2656
integer y = 1544
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_todo_main
end type

type cb_exit from commandbutton within w_todo_main
integer x = 2565
integer y = 1672
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

event clicked;close(parent)

end event

type tab_todo from u_tab_todo_lists within w_todo_main
integer width = 2921
integer taborder = 20
boolean multiline = true
end type

