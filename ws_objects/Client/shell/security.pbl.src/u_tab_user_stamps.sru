$PBExportHeader$u_tab_user_stamps.sru
forward
global type u_tab_user_stamps from u_tab_manager
end type
end forward

global type u_tab_user_stamps from u_tab_manager
integer width = 3447
integer height = 2124
long backcolor = COLOR_BACKGROUND
boolean createondemand = false
tabposition tabposition = tabsonbottom!
end type
global u_tab_user_stamps u_tab_user_stamps

type variables

end variables

forward prototypes
public function integer save ()
public function integer initialize (u_user puo_user)
public function boolean any_changes ()
public function integer open_stamp_page (u_user puo_user, string ps_user_stamp)
end prototypes

public function integer save ();long i
u_tabpage_user_stamp_base luo_tabpage
integer li_sts
boolean lb_error

lb_error = false
for i = 1 to page_count
	luo_tabpage = pages[i]
	li_sts = luo_tabpage.save( )
	if li_sts < 0 then
		lb_error = true
	end if
next

if lb_error then return -1

return 1

end function

public function integer initialize (u_user puo_user);long ll_count
integer i
string ls_stamp_name
u_ds_data luo_data
integer li_sts

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_domain_notranslate_list")
ll_count = luo_data.retrieve("User Stamp")

li_sts = open_stamp_page(puo_user, "Signature")

for i = 1 to ll_count
	ls_stamp_name = luo_data.object.domain_item[i]
	if lower(ls_stamp_name) = "signature" then continue
	li_sts = open_stamp_page(puo_user, ls_stamp_name)
next

DESTROY luo_data

return 1

end function

public function boolean any_changes ();integer i
u_tabpage_user_stamp_base luo_tab

for i = 1 to page_count
	luo_tab = pages[i]
	if luo_tab.stamp_changed() then return true
next

return false



end function

public function integer open_stamp_page (u_user puo_user, string ps_user_stamp);u_tabpage_user_stamp_base luo_tab
string ls_tabpage_class

if lower(ps_user_stamp) = "signature" then
	ls_tabpage_class = "u_tabpage_user_stamp_signature"
else
	ls_tabpage_class = "u_tabpage_user_stamp_other"
end if

luo_tab = open_page(ls_tabpage_class)
luo_tab.text = ps_user_stamp

page_count++
pages[page_count] = luo_tab
luo_tab.parent_tab = this
luo_tab.initialize(puo_user)

return 1

end function

