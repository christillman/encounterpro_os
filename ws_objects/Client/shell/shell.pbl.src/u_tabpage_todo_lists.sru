$PBExportHeader$u_tabpage_todo_lists.sru
forward
global type u_tabpage_todo_lists from u_tabpage
end type
type tab_todo_items from u_tab_todo_items within u_tabpage_todo_lists
end type
type tab_todo_items from u_tab_todo_items within u_tabpage_todo_lists
end type
end forward

global type u_tabpage_todo_lists from u_tabpage
integer width = 2926
integer height = 1816
tab_todo_items tab_todo_items
end type
global u_tabpage_todo_lists u_tabpage_todo_lists

type variables
string user_id
boolean first_time = true
string base_text

string todo_type_default
string todo_office_default

end variables

forward prototypes
public function integer initialize (string ps_key)
public subroutine refresh ()
public subroutine refresh_tab_counts ()
public subroutine set_text (long pl_count)
end prototypes

public function integer initialize (string ps_key);long ll_tab_count

user_id = ps_key
base_text = text

if tag <> "OTHER" then
	// Get the initial service count for this tab
	SELECT count(*)
	INTO :ll_tab_count
	FROM p_Patient_WP_Item
	WHERE owned_by = :user_id
	AND active_service_flag = 'Y'
	AND ordered_service <> 'MESSAGE';
	if not tf_check() then return -1
	
	set_text(ll_tab_count)
end if

return 1

end function

public subroutine refresh ();u_tabpage_todo_items luo_tabpages[]
u_tabpage_todo_items luo_office_tabpage
integer li_office_count
str_c_office lstra_offices[]
integer i
str_popup popup
str_popup_return popup_return
u_user luo_user
integer li_default_tab
integer li_all_offices_tab
integer li_not_in_office_tab
integer li_count
integer li_my_office

li_default_tab = 0
if first_time then
	li_office_count = 0
	tab_todo_items.initialize(user_id)
	
	li_count = datalist.get_offices(lstra_offices)
	
	for i = 1 to li_count
		if upper(lstra_offices[i].status) = "OK" then
			li_office_count += 1
			luo_tabpages[li_office_count] = tab_todo_items.open_page("u_tabpage_todo_items", false)
			if isnull(luo_tabpages[li_office_count]) then
				log.log(this, "u_tabpage_todo_lists.refresh:0027", "Error opening office-todo-items tab page", 4)
				exit
			end if
			
			luo_tabpages[li_office_count].parent_tabpage = this
			luo_tabpages[li_office_count].tag = "OFFICE"
			luo_tabpages[li_office_count].todo_office_id = lstra_offices[i].office_id
			
			// Truncate the name to 30 to prevent the tabs from taking up too much space.
			luo_tabpages[li_office_count].text = left(lstra_offices[i].description, 30)

			luo_tabpages[li_office_count].service_filter = todo_type_default
			luo_tabpages[li_office_count].initialize(user_id)
			
			if upper(lstra_offices[i].office_id) = office_id then
				li_my_office = li_office_count
			end if
		end if
	next
	// If we only have one office, then we don't need it's name.  Save space by just calling it "Office".
	if li_office_count = 1 then
		luo_tabpages[1].base_text = "Office"
		luo_tabpages[1].text = luo_tabpages[1].base_text
		li_my_office = 1
	end if
	
		// It's the default tab is not "Not In Office" or "All Offices", assume it's "My Office"
	if upper(left(todo_office_default, 2)) <> "NO" and upper(left(todo_office_default, 2)) <> "AL" then
		li_default_tab = li_my_office
	end if
	
	// Add the All Offices tab
	if li_office_count > 1 then
		li_all_offices_tab = li_office_count + 1
		luo_office_tabpage = tab_todo_items.open_page("u_tabpage_todo_items", false)
		if isnull(luo_office_tabpage) then
			log.log(this, "u_tabpage_todo_lists.refresh:0063", "Error opening office-todo-items tab page", 4)
		else
			luo_office_tabpage.parent_tabpage = this
			luo_office_tabpage.tag = "ALL_OFFICES"
			luo_office_tabpage.todo_office_id = "%"
			luo_office_tabpage.text = "All Offices"
			luo_office_tabpage.service_filter = todo_type_default
			luo_office_tabpage.initialize(user_id)
		end if
	else
		li_all_offices_tab = 1
	end if
	
	// Add the "Not-In-Office" tab
	luo_office_tabpage = tab_todo_items.open_page("u_tabpage_todo_items", false)
	if isnull(luo_office_tabpage) then
		log.log(this, "u_tabpage_todo_lists.refresh:0079", "Error opening office-todo-items tab page", 4)
	else
		luo_office_tabpage.parent_tabpage = this
		luo_office_tabpage.tag = "NOT_IN_OFFICE"
		setnull(luo_office_tabpage.todo_office_id)
		luo_office_tabpage.text = "Not In Office"
		luo_office_tabpage.service_filter = todo_type_default
		luo_office_tabpage.initialize(user_id)
	end if
	li_not_in_office_tab = li_all_offices_tab + 1
	
	if li_default_tab = 0 then
		// The user wants the default tab to be "All Offices"
		if upper(left(todo_office_default, 2)) = "AL" then
			li_default_tab = li_all_offices_tab
		elseif upper(left(todo_office_default, 2)) = "NO" then
			li_default_tab = li_not_in_office_tab
		end if
	end if
end if

first_time = false

if tag = "OTHER" then
	luo_user = user_list.pick_user(false, false, false)
	if isnull(luo_user) then
		setnull(user_id)
		return
	end if
	user_id = luo_user.user_id
	text = "Other - " + luo_user.user_full_name
	base_text = "Other - " + luo_user.user_full_name
	for i = 1 to tab_todo_items.page_count
		luo_office_tabpage = tab_todo_items.pages[i]
		luo_office_tabpage.text = luo_office_tabpage.base_text
		luo_office_tabpage.initialize(user_id)
	next
end if

// Then resize the tabs
tab_todo_items.resize_tabs(width, height)

// Then refresh the displayed tab
if li_default_tab > 1 then
	tab_todo_items.function POST selecttab(li_default_tab)
end if


end subroutine

public subroutine refresh_tab_counts ();integer i
long ll_tab_count
long ll_total
u_tabpage_todo_items luo_tabpage

ll_total = 0

for i = 1 to tab_todo_items.page_count
	luo_tabpage = tab_todo_items.pages[i]
	CHOOSE CASE luo_tabpage.tag
		CASE "OFFICE"
			ll_tab_count = datalist.service_count(luo_tabpage.user_id, luo_tabpage.todo_office_id)
			ll_total += ll_tab_count
			luo_tabpage.set_text(ll_tab_count)
		CASE "ALL_OFFICES"
			luo_tabpage.set_text(ll_total)
		CASE "NOT_IN_OFFICE"
			ll_tab_count = sqlca.sp_count_ready_todo_items( luo_tabpage.user_id, "N")
			if not tf_check() then return
			
			luo_tabpage.set_text(ll_tab_count)
			
			ll_total += ll_tab_count
	END CHOOSE
next

set_text(ll_total)

end subroutine

public subroutine set_text (long pl_count);if pl_count <= 0 then
	text = base_text
	tabtextcolor = color_text_normal
else
	text = base_text + " (" + string(pl_count) + ")"
	tabtextcolor = color_text_error
end if


end subroutine

on u_tabpage_todo_lists.create
int iCurrent
call super::create
this.tab_todo_items=create tab_todo_items
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_todo_items
end on

on u_tabpage_todo_lists.destroy
call super::destroy
destroy(this.tab_todo_items)
end on

type tab_todo_items from u_tab_todo_items within u_tabpage_todo_lists
integer taborder = 20
end type

