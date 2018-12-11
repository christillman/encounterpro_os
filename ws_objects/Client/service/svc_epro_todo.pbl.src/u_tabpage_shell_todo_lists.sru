$PBExportHeader$u_tabpage_shell_todo_lists.sru
forward
global type u_tabpage_shell_todo_lists from u_main_tabpage_base
end type
type tab_todo from u_tab_todo_items within u_tabpage_shell_todo_lists
end type
type tab_todo from u_tab_todo_items within u_tabpage_shell_todo_lists
end type
end forward

global type u_tabpage_shell_todo_lists from u_main_tabpage_base
integer width = 2926
integer height = 1816
event resized ( )
tab_todo tab_todo
end type
global u_tabpage_shell_todo_lists u_tabpage_shell_todo_lists

type variables
string user_id
string base_text

string todo_type_default

long used_tab_count


end variables

forward prototypes
public subroutine refresh ()
public subroutine set_text (long pl_count)
public function integer initialize_user (string ps_user_id)
public function integer set_tab_user (string ps_user_id, string ps_tag, string ps_tabtext)
public function integer initialize ()
public subroutine refresh_tabtext ()
public subroutine resize_tabpage ()
end prototypes

event resized();resize_tabpage()

end event

public subroutine refresh ();long i
u_tabpage_shell_todo_items luo_tabpage

if isnull(user_id) or current_user.user_id <> user_id then
	initialize_user(current_user.user_id)
	tab_todo.selecttab(1)
	for i = 2 to used_tab_count
		if not tab_todo.pages[i].visible then exit
		luo_tabpage = tab_todo.pages[i]
		luo_tabpage.refresh_tabtext( )
	next
end if

for i = 1 to used_tab_count
	if not tab_todo.pages[i].visible then exit
	luo_tabpage = tab_todo.pages[i]
	if i = tab_todo.selectedtab then
		luo_tabpage.refresh( )
	else
		luo_tabpage.refresh_tabtext( )
	end if
next


end subroutine

public subroutine set_text (long pl_count);if pl_count <= 0 then
	text = base_text
	tabtextcolor = color_text_normal
else
	text = base_text + " (" + string(pl_count) + ")"
	tabtextcolor = color_text_error
end if


end subroutine

public function integer initialize_user (string ps_user_id);integer li_role_count
str_role lstra_roles[]
u_tabpage_shell_todo_items luo_tabpage
integer i
u_ds_data luo_data
long ll_count
integer li_sts

todo_type_default = datalist.get_preference("PREFERENCES", "my_todo_type_default", "%")

user_id = ps_user_id

// Make sure we're big enough
tab_todo.width = width
tab_todo.height = height

// Reset the tab count back to zero
used_tab_count = 0

// The first tab is always the user_id
set_tab_user(user_id, "USER", "My Tasks")

// Now set the tabs for the roles
li_role_count = user_list.roles_assigned_to_user(current_user.user_id, lstra_roles)

// Open a page for each role
for i = 1 to li_role_count
	li_sts = set_tab_user(lstra_roles[i].role_id, "ROLE", lstra_roles[i].role_name)
next

if f_string_to_boolean(datalist.get_preference("PREFERENCES", "todo_show_subordinates", "True")) then
	luo_data = CREATE u_ds_data
	luo_data.set_dataobject("dw_user_subordinates")
	ll_count = luo_data.retrieve(current_user.user_id)
	for i = 1 to ll_count
		li_sts = set_tab_user(luo_data.object.user_id[i], "SUBORDINATE", luo_data.object.user_full_name[i])
	next
end if

if current_user.check_privilege("See Other Users Todo") then
	li_sts = set_tab_user("%OTHER%", "OTHER", "Other")
end if

// Make the rest of the tabs invisible
for i = used_tab_count + 1 to tab_todo.page_count
	tab_todo.pages[i].visible = false
next

tab_todo.selecttab(1)

return 1

end function

public function integer set_tab_user (string ps_user_id, string ps_tag, string ps_tabtext);u_tabpage_shell_todo_items luo_tabpage


if isnull(ps_user_id) then
	log.log(this, "u_tabpage_shell_todo_lists.set_tab_user:0005", "Null user_id", 4)
	return -1
end if

if isnull(used_tab_count) or used_tab_count < 0 then
	used_tab_count = 0
end if

if used_tab_count >= tab_todo.page_count then
	// We need a new page
	luo_tabpage = tab_todo.open_page("u_tabpage_shell_todo_items", false)
	if isnull(luo_tabpage) then
		log.log(this, "u_tabpage_shell_todo_lists.set_tab_user:0017", "Error opening todo-items tab page (" + ps_user_id + ")", 4)
		return -1
	end if
	luo_tabpage.resize_tabpage( )
	used_tab_count++
else
	// Just use the existing page
	used_tab_count++
	luo_tabpage = tab_todo.pages[used_tab_count]
end if

luo_tabpage.tag = ps_tag
luo_tabpage.text = ps_tabtext
luo_tabpage.service_filter = todo_type_default
luo_tabpage.shelltab = this
luo_tabpage.initialize(ps_user_id)

return 1

end function

public function integer initialize ();
setnull(user_id)
base_text = "Tasks"

return 1

end function

public subroutine refresh_tabtext ();string ls_temp
long ll_my_count
long ll_role_count
integer li_max_priority
string ls_priority_bitmap

if isnull(current_user) then
	// Don't set the value unless it needs to because even setting it to the same value
	// causes a round-trip server refresh on thin clients
	if text <> "Tasks" then text = "Tasks"
	if tabtextcolor <> color_text_normal then tabtextcolor = color_text_normal
	return
end if

SELECT my_task_count, role_task_count, max_priority
INTO :ll_my_count, :ll_role_count, :li_max_priority
FROM dbo.fn_user_task_counts(:current_user.user_id);
if not tf_check() then return

if ll_my_count <= 0 and ll_role_count <= 0 then
	if text <> "No Tasks" then text = "No Tasks"
	if tabtextcolor <> color_text_normal then tabtextcolor = color_text_normal
else
	ls_temp = "Tasks (" + string(ll_my_count) + "/" + string(ll_role_count) + ")"
	if text <> ls_temp then text = ls_temp
	if tabtextcolor <> color_text_error then tabtextcolor = color_text_error
end if

common_thread.set_max_priority(li_max_priority)

ls_priority_bitmap = datalist.priority_bitmap(li_max_priority)
if len(ls_priority_bitmap) > 0 then
	if picturename <> ls_priority_bitmap then picturename = ls_priority_bitmap
else
	// Clear out the picture if we couldn't find one
	if picturename <> "" then picturename = ""
end if


return



end subroutine

public subroutine resize_tabpage ();long i
u_tabpage_shell_todo_items luo_tabpage

tab_todo.width = width
tab_todo.height = height

for i = 1 to used_tab_count
	luo_tabpage = tab_todo.pages[i]
	luo_tabpage.resize_tabpage()
next


end subroutine

on u_tabpage_shell_todo_lists.create
int iCurrent
call super::create
this.tab_todo=create tab_todo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_todo
end on

on u_tabpage_shell_todo_lists.destroy
call super::destroy
destroy(this.tab_todo)
end on

type tab_todo from u_tab_todo_items within u_tabpage_shell_todo_lists
integer taborder = 20
boolean multiline = true
boolean showpicture = false
boolean perpendiculartext = false
boolean createondemand = false
tabposition tabposition = tabsontop!
end type

