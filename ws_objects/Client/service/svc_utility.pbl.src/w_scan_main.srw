$PBExportHeader$w_scan_main.srw
forward
global type w_scan_main from w_window_base
end type
type cb_post_last from commandbutton within w_scan_main
end type
type cb_post from commandbutton within w_scan_main
end type
type cb_delete from commandbutton within w_scan_main
end type
type cb_scan_more from commandbutton within w_scan_main
end type
type cb_ok from commandbutton within w_scan_main
end type
type tab_lists from u_tab_to_be_posted_lists within w_scan_main
end type
type tab_lists from u_tab_to_be_posted_lists within w_scan_main
end type
type cb_configure from commandbutton within w_scan_main
end type
end forward

shared variables

end variables

global type w_scan_main from w_window_base
integer height = 1864
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
event new_cpr pbm_custom01
cb_post_last cb_post_last
cb_post cb_post
cb_delete cb_delete
cb_scan_more cb_scan_more
cb_ok cb_ok
tab_lists tab_lists
cb_configure cb_configure
end type
global w_scan_main w_scan_main

type variables

u_component_service service

u_tabpage_to_be_posted_list current_list

u_ds_attachments attachments

String last_posted_cpr_id
string last_posted_patient_name

boolean interfaceservices

end variables

forward prototypes
public function integer refresh ()
public function integer create_lists ()
end prototypes

public function integer refresh ();
tab_lists.refresh()

if not isnull(current_list) and isvalid(current_list) then
	current_list.postevent( "refresh_buttons")
end if

return 1

end function

public function integer create_lists ();u_tabpage_to_be_posted_list luo_list
u_ds_data luo_data
long ll_count
long i
string ls_folder
long ll_default_tab
string ls_default_list

ls_default_list = datalist.get_preference( "PREFERENCES", "Default Posting List")

tab_lists.setredraw(false)

// First destroy any existing tabs
tab_lists.close_pages( )


luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_posting_folder_display")
ll_count = luo_data.retrieve()

if ll_count = 0 then
	// First see if the 'Items To Be Posted' folder exists but is not visible
	UPDATE c_Folder
	SET status = 'OK'
	WHERE folder = 'Items To Be Posted';
	if not tf_check() then return -1
	if sqlca.sqlnrows = 0 then
		INSERT INTO c_Folder (
			folder,
			context_object,
			description,
			status,
			sort_sequence,
			workplan_required_flag)
		VALUES (
			'Items To Be Posted',
			'General',
			'Items To Be Posted',
			'OK',
			1,
			'N');
		if not tf_check() then return -1
	end if
	ll_count = luo_data.retrieve()
end if

ll_default_tab = 0
for i = 1 to ll_count
	ls_folder = luo_data.object.folder[i]
	if upper(ls_folder) = upper(ls_default_list) then ll_default_tab = i
	
	luo_list = tab_lists.open_page("u_tabpage_to_be_posted_list", false)
	if isnull(luo_list) then continue
	
	luo_list.list_folder = ls_folder
	luo_list.attachments = attachments
	luo_list.picturename = "icon030.bmp"
	if i = 1 then
		luo_list.default_list = true
	end if
next

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_practice_interfaces")
luo_data.setfilter("status='OK'")
ll_count = luo_data.retrieve()

interfaceservices = false
for i = 1 to ll_count
	luo_list = tab_lists.open_page("u_tabpage_to_be_posted_list", false)
	if isnull(luo_list) then continue
	
	luo_list.list_folder = luo_data.object.interfacedescription[i]
	luo_list.interfaceserviceid = luo_data.object.interfaceserviceid[i]
	luo_list.attachments = attachments
	luo_list.picturename = luo_data.object.interfaceServiceType_icon[i]
	
	interfaceservices = true
next


tab_lists.resize_tabs(width,  height - 208)
tab_lists.attachments = attachments

if ll_default_tab <= 0 then ll_default_tab = 1
tab_lists.selecttab(ll_default_tab)

tab_lists.setredraw(true)

tab_lists.attributes = service.get_attributes()
tab_lists.initialize()

return 1

end function

on w_scan_main.create
int iCurrent
call super::create
this.cb_post_last=create cb_post_last
this.cb_post=create cb_post
this.cb_delete=create cb_delete
this.cb_scan_more=create cb_scan_more
this.cb_ok=create cb_ok
this.tab_lists=create tab_lists
this.cb_configure=create cb_configure
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_post_last
this.Control[iCurrent+2]=this.cb_post
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.cb_scan_more
this.Control[iCurrent+5]=this.cb_ok
this.Control[iCurrent+6]=this.tab_lists
this.Control[iCurrent+7]=this.cb_configure
end on

on w_scan_main.destroy
call super::destroy
destroy(this.cb_post_last)
destroy(this.cb_post)
destroy(this.cb_delete)
destroy(this.cb_scan_more)
destroy(this.cb_ok)
destroy(this.tab_lists)
destroy(this.cb_configure)
end on

event open;call super::open;long ll_count
long i
string ls_folder
integer li_sts

service = message.powerobjectparm

cb_ok.y = height - 156
cb_ok.x = width - 466

cb_post.y = cb_ok.y
cb_post.x = (width - cb_post.width) / 2

cb_post_last.y = cb_ok.y
cb_post_last.x = cb_post.x + cb_post.width + 150

cb_delete.y = cb_ok.y
cb_delete.x = cb_post.x - cb_delete.width - 150

cb_scan_more.y = cb_ok.y
cb_scan_more.x = 82

cb_configure.x = width - cb_configure.width - 50

attachments = CREATE u_ds_attachments
attachments.dataobject = "dw_fn_incoming_documents"
attachments.settransobject(sqlca)

li_sts = create_lists()
if li_sts <= 0 then
	log.log(this, "open", "Error creating posting lists", 4)
	close(this)
	return
end if

refresh()


end event

event close;call super::close;//delete_temp_files()


end event

event key;call super::key;long ll_row
if isnull(current_list) or not isvalid(current_list) then return


CHOOSE CASE key
	CASE KeyUpArrow!
		if current_list.dw_holding_list.count_selected() < 1 then return
		ll_row = current_list.dw_holding_list.get_selected_row()
		if ll_row > 1 then
			if keyflags <> 1 then current_list.dw_holding_list.clear_selected()
			current_list.select_image(ll_row - 1)
		end if
	CASE KeyDownArrow!
		if current_list.dw_holding_list.count_selected() < 1 then return
		ll_row = current_list.dw_holding_list.get_last_selected_row()
		if ll_row < current_list.dw_holding_list.rowcount() then
			if keyflags <> 1 then current_list.dw_holding_list.clear_selected()
			current_list.select_image(ll_row + 1)
		end if
	CASE KeyI!
		cb_scan_more.postevent("clicked")
	CASE KeyD!, KeyDelete!
		cb_delete.postevent("clicked")
	CASE KeyP!
		cb_post.postevent("clicked")
	CASE KeyL!
		cb_post_last.postevent("clicked")
END CHOOSE


end event

type pb_epro_help from w_window_base`pb_epro_help within w_scan_main
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_scan_main
integer x = 0
integer y = 1560
end type

type cb_post_last from commandbutton within w_scan_main
event clicked pbm_bnclicked
boolean visible = false
integer x = 1723
integer y = 1676
integer width = 722
integer height = 108
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;if isnull(current_list) or not isvalid(current_list) then return

current_list.post_attachments(last_posted_cpr_id)
end event

type cb_post from commandbutton within w_scan_main
event clicked pbm_bnclicked
integer x = 1285
integer y = 1676
integer width = 297
integer height = 108
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Post"
end type

event clicked;string ls_null
if isnull(current_list) or not isvalid(current_list) then return

setnull(ls_null)

current_list.post_attachments(ls_null)

end event

type cb_delete from commandbutton within w_scan_main
integer x = 859
integer y = 1676
integer width = 297
integer height = 108
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Delete"
end type

event clicked;if isnull(current_list) or not isvalid(current_list) then return

str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you want to delete the selected pages?")
popup_return = message.powerobjectparm

if popup_return.item = "YES" then 
	current_list.delete_selected()
end if

end event

type cb_scan_more from commandbutton within w_scan_main
integer x = 82
integer y = 1676
integer width = 649
integer height = 108
integer taborder = 1
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Import"
end type

event clicked;if isnull(current_list) or not isvalid(current_list) then return

current_list.scan_more()

refresh()

end event

type cb_ok from commandbutton within w_scan_main
integer x = 2523
integer y = 1676
integer width = 297
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;f_clear_patient()

//DESTROY attachment_image
//setnull(attachment_image)
//
close(parent)

end event

type tab_lists from u_tab_to_be_posted_lists within w_scan_main
integer width = 2889
integer height = 1624
boolean bringtotop = true
boolean boldselectedtext = true
boolean createondemand = false
end type

event selectionchanged;call super::selectionchanged;
current_list = pages[newindex]

this.postevent("refresh_buttons")

end event

event refresh_buttons;call super::refresh_buttons;long ll_row

if len(last_posted_cpr_id) > 0 and len(last_posted_patient_name) > 0 then
	cb_post_last.text = last_posted_patient_name
	cb_post_last.visible = true
else
	cb_post_last.visible = false
end if

ll_row = current_list.dw_holding_list.get_selected_row( )
if ll_row <= 0 then
	cb_delete.enabled = false
	cb_post.enabled = false
	cb_post_last.enabled = false
else
	cb_delete.enabled = true
	cb_post.enabled = true
	cb_post_last.enabled = true
end if

if config_mode then
	cb_configure.visible = true
else
	cb_configure.visible = false
end if


end event

event patient_posted;call super::patient_posted;last_posted_cpr_id = ps_posted_cpr_id
last_posted_patient_name = ps_posted_patient_name

end event

type cb_configure from commandbutton within w_scan_main
boolean visible = false
integer x = 2514
integer y = 20
integer width = 357
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Configure"
end type

event clicked;open(w_config_posting_lists)

create_lists()

refresh()


end event

