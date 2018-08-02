$PBExportHeader$u_tabpage_shell_incoming_documents.sru
forward
global type u_tabpage_shell_incoming_documents from u_main_tabpage_base
end type
type cb_configure from commandbutton within u_tabpage_shell_incoming_documents
end type
type cb_scan_more from commandbutton within u_tabpage_shell_incoming_documents
end type
type cb_delete from commandbutton within u_tabpage_shell_incoming_documents
end type
type cb_post from commandbutton within u_tabpage_shell_incoming_documents
end type
type cb_post_last from commandbutton within u_tabpage_shell_incoming_documents
end type
type tab_lists from u_tab_to_be_posted_lists within u_tabpage_shell_incoming_documents
end type
type tab_lists from u_tab_to_be_posted_lists within u_tabpage_shell_incoming_documents
end type
end forward

global type u_tabpage_shell_incoming_documents from u_main_tabpage_base
integer width = 3337
integer height = 2076
event resized ( )
cb_configure cb_configure
cb_scan_more cb_scan_more
cb_delete cb_delete
cb_post cb_post
cb_post_last cb_post_last
tab_lists tab_lists
end type
global u_tabpage_shell_incoming_documents u_tabpage_shell_incoming_documents

type variables

//u_component_service service

u_tabpage_to_be_posted_list current_list

u_ds_attachments attachments

String last_posted_cpr_id
string last_posted_patient_name

boolean interfaceservices


end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public subroutine refresh_tab ()
public function integer create_lists ()
public subroutine resize_tabpage ()
public subroutine set_tab_text ()
end prototypes

event resized();resize_tabpage()

end event

public function integer initialize ();integer li_sts

attachments = CREATE u_ds_attachments
attachments.dataobject = "dw_fn_incoming_documents"
attachments.settransobject(sqlca)

resize_tabpage()

li_sts = create_lists()
if li_sts <= 0 then
	log.log(this, "u_tabpage_shell_incoming_documents.initialize.0011", "Error creating posting lists", 4)
	return -1
end if

return 1

end function

public subroutine refresh ();
tab_lists.refresh()

if not isnull(current_list) and isvalid(current_list) then
	current_list.postevent( "refresh_buttons")
end if

set_tab_text()

end subroutine

public subroutine refresh_tab ();long ll_rows

attachments.setfilter("")
ll_rows = attachments.retrieve()
if ll_rows < 0 then return

set_tab_text()

end subroutine

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

tab_lists.initialize()

return 1

end function

public subroutine resize_tabpage ();long ll_count
long i
string ls_folder
integer li_sts


cb_post.y = height - 156
cb_post.x = (width - cb_post.width) / 2

cb_post_last.y = cb_post.y
cb_post_last.x = cb_post.x + cb_post.width + 150

cb_delete.y = cb_post.y
cb_delete.x = cb_post.x - cb_delete.width - 150

cb_scan_more.y = cb_post.y
cb_scan_more.x = 82

cb_configure.x = width - cb_configure.width - 50


tab_lists.resize_tabs(width,  height - 208)

end subroutine

public subroutine set_tab_text ();long ll_normal_rows
long ll_interfacesservice_rows
string ls_filter
string ls_new_tab_text
long ll_new_tab_color

ls_filter = "isnull(interfaceserviceid) OR interfaceserviceid = 0"
attachments.setfilter(ls_filter)
attachments.filter()

ll_normal_rows = attachments.rowcount()

attachments.setfilter("")
attachments.filter()

ll_interfacesservice_rows = attachments.rowcount() - ll_normal_rows

ls_new_tab_text = "Inbox (" + string(ll_normal_rows) 
if interfaceservices then
	ls_new_tab_text += "/" + string(ll_interfacesservice_rows)
end if
ls_new_tab_text += ")"

if ll_interfacesservice_rows > 0 then
	ll_new_tab_color = color_text_error
else
	ll_new_tab_color = color_text_normal
end if

// updating the visible property is expensive on terminal servers so only do it if it has changed
if text <> ls_new_tab_text then text = ls_new_tab_text
if tabtextcolor <> ll_new_tab_color then tabtextcolor = ll_new_tab_color

end subroutine

on u_tabpage_shell_incoming_documents.create
int iCurrent
call super::create
this.cb_configure=create cb_configure
this.cb_scan_more=create cb_scan_more
this.cb_delete=create cb_delete
this.cb_post=create cb_post
this.cb_post_last=create cb_post_last
this.tab_lists=create tab_lists
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_configure
this.Control[iCurrent+2]=this.cb_scan_more
this.Control[iCurrent+3]=this.cb_delete
this.Control[iCurrent+4]=this.cb_post
this.Control[iCurrent+5]=this.cb_post_last
this.Control[iCurrent+6]=this.tab_lists
end on

on u_tabpage_shell_incoming_documents.destroy
call super::destroy
destroy(this.cb_configure)
destroy(this.cb_scan_more)
destroy(this.cb_delete)
destroy(this.cb_post)
destroy(this.cb_post_last)
destroy(this.tab_lists)
end on

type cb_configure from commandbutton within u_tabpage_shell_incoming_documents
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

type cb_scan_more from commandbutton within u_tabpage_shell_incoming_documents
integer x = 82
integer y = 1676
integer width = 649
integer height = 108
integer taborder = 20
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

type cb_delete from commandbutton within u_tabpage_shell_incoming_documents
integer x = 859
integer y = 1676
integer width = 297
integer height = 108
integer taborder = 20
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

type cb_post from commandbutton within u_tabpage_shell_incoming_documents
integer x = 1285
integer y = 1676
integer width = 297
integer height = 108
integer taborder = 20
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

type cb_post_last from commandbutton within u_tabpage_shell_incoming_documents
boolean visible = false
integer x = 1723
integer y = 1676
integer width = 722
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

event clicked;if isnull(current_list) or not isvalid(current_list) then return

current_list.post_attachments(last_posted_cpr_id)
end event

type tab_lists from u_tab_to_be_posted_lists within u_tabpage_shell_incoming_documents
integer width = 2889
integer height = 1624
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

