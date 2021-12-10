$PBExportHeader$u_tabpage_messages.sru
forward
global type u_tabpage_messages from u_main_tabpage_base
end type
type pb_refresh from picturebutton within u_tabpage_messages
end type
type st_refresh_title from statictext within u_tabpage_messages
end type
type st_page from statictext within u_tabpage_messages
end type
type pb_up from u_picture_button within u_tabpage_messages
end type
type pb_down from u_picture_button within u_tabpage_messages
end type
type st_compose_message from statictext within u_tabpage_messages
end type
type st_edit_folders from statictext within u_tabpage_messages
end type
type st_folder from statictext within u_tabpage_messages
end type
type st_folder_title from statictext within u_tabpage_messages
end type
type dw_todo_list from u_dw_pick_list within u_tabpage_messages
end type
end forward

global type u_tabpage_messages from u_main_tabpage_base
integer width = 2414
integer height = 1724
long tabbackcolor = 16777215
event resized ( )
pb_refresh pb_refresh
st_refresh_title st_refresh_title
st_page st_page
pb_up pb_up
pb_down pb_down
st_compose_message st_compose_message
st_edit_folders st_edit_folders
st_folder st_folder
st_folder_title st_folder_title
dw_todo_list dw_todo_list
end type
global u_tabpage_messages u_tabpage_messages

type variables
string folder_type
string folder

string cpr_id

string compose_message_service = "SENDMESSAGE"
string review_message_service = "REVIEW_MESSAGE"


end variables

forward prototypes
public subroutine refresh ()
public subroutine display_read_messages ()
public subroutine display_sent_messages ()
public subroutine display_inbox ()
public subroutine set_folder (string ps_folder_type, string ps_folder)
public subroutine display_patient ()
public subroutine display_folder ()
public function integer initialize ()
public subroutine do_message (long pl_row)
public function integer refresh_tab ()
public subroutine display_deleted_messages ()
end prototypes

event resized();integer li_temp

dw_todo_list.width = width - 285
dw_todo_list.height = height - 172

li_temp = (width - dw_todo_list.x - dw_todo_list.width - pb_down.width) / 2

pb_down.x = dw_todo_list.x + dw_todo_list.width + 30
pb_up.x = pb_down.x
st_page.x = pb_down.x

st_compose_message.x = dw_todo_list.x + dw_todo_list.width - st_compose_message.width
pb_refresh.x = pb_down.x
st_refresh_title.x = pb_down.x

st_folder.y = height - 136
st_compose_message.y = st_folder.y
st_folder_title.y = height - 120
st_edit_folders.y = height - 112

end event

public subroutine refresh ();integer li_page
integer li_temp

if isnull(current_user) then return

li_page = dw_todo_list.current_page

if isnull(cpr_id) then
	CHOOSE CASE upper(folder_type)
		CASE "INBOX"
			display_inbox()
		CASE "READ"
			display_read_messages()
		CASE "DELETED"
			display_deleted_messages()
		CASE "SENT"
			display_sent_messages()
		CASE "USER"
			display_folder()
	END CHOOSE
else
	display_patient()
end if


dw_todo_list.set_page(li_page, pb_up, pb_down, st_page)

refresh_tab()

end subroutine

public subroutine display_read_messages ();dw_todo_list.dataobject = "dw_message_read_list"

dw_todo_list.object.t_1.width = dw_todo_list.width - 37

dw_todo_list.settransobject(sqlca)
dw_todo_list.retrieve(current_user.user_id)

end subroutine

public subroutine display_sent_messages ();dw_todo_list.dataobject = "dw_message_sent_list"

dw_todo_list.object.t_1.width = dw_todo_list.width - 37

dw_todo_list.settransobject(sqlca)
dw_todo_list.retrieve(current_user.user_id)

end subroutine

public subroutine display_inbox ();dw_todo_list.dataobject = "dw_message_inbox_list"

dw_todo_list.object.t_1.width = dw_todo_list.width - 37

dw_todo_list.settransobject(sqlca)
dw_todo_list.retrieve(current_user.user_id)

end subroutine

public subroutine set_folder (string ps_folder_type, string ps_folder);folder_type = ps_folder_type
folder = ps_folder

CHOOSE CASE folder_type
	CASE "INBOX"
		st_folder.text = "Inbox"
	CASE "READ"
		st_folder.text = "Read Messages"
	CASE "DELETED"
		st_folder.text = "Deleted Messages"
	CASE "SENT"
		st_folder.text = "Sent Messages"
	CASE "USER"
		st_folder.text = ps_folder
END CHOOSE


end subroutine

public subroutine display_patient ();dw_todo_list.dataobject = "dw_message_patient_list"

dw_todo_list.object.t_1.width = dw_todo_list.width - 37

dw_todo_list.settransobject(sqlca)
dw_todo_list.retrieve(cpr_id)

end subroutine

public subroutine display_folder ();dw_todo_list.dataobject = "dw_message_folder_list"

dw_todo_list.object.t_1.width = dw_todo_list.width - 37

dw_todo_list.settransobject(sqlca)
dw_todo_list.retrieve(current_user.user_id, folder)

end subroutine

public function integer initialize ();integer li_temp

//cpr_id = ps_cpr_id
setnull(cpr_id)

if isnull(cpr_id) then
	st_edit_folders.visible = true
	st_folder.visible = true
	st_folder_title.visible = true
else
	st_edit_folders.visible = false
	st_folder.visible = false
	st_folder_title.visible = false
end if


folder_type = "INBOX"
st_folder.text = "Inbox"

this.event trigger resized()

return 1

end function

public subroutine do_message (long pl_row);long ll_patient_workplan_item_id
integer li_sts
string ls_status
integer li_page
str_attributes lstr_attributes
string ls_cpr_id
long ll_encounter_id

ll_patient_workplan_item_id = dw_todo_list.object.patient_workplan_item_id[pl_row]

if folder_type = "INBOX" then
	li_sts = service_list.do_service(ll_patient_workplan_item_id)
else
	SELECT cpr_id, encounter_id
	INTO :ls_cpr_id, :ll_encounter_id
	FROM p_Patient_WP_Item
	WHERE patient_workplan_item_id = :ll_patient_workplan_item_id;
	if not tf_check() then return
	
	lstr_attributes.attribute_count = 1
	lstr_attributes.attribute[lstr_attributes.attribute_count].attribute = "message_workplan_item_id"
	lstr_attributes.attribute[lstr_attributes.attribute_count].value = string(ll_patient_workplan_item_id)
		
	li_sts = service_list.do_service(ls_cpr_id, ll_encounter_id, review_message_service, lstr_attributes)
end if

li_page = dw_todo_list.current_page

refresh()

dw_todo_list.set_page(li_page, pb_up, pb_down, st_page)

end subroutine

public function integer refresh_tab ();long ll_count
integer li_max_priority
string ls_priority_bitmap

if isnull(current_user) then
	if text <> "Messages" then text = "Messages"
	if tabtextcolor <> color_text_normal then tabtextcolor = color_text_normal
	return 0
end if

SELECT count(*), max(priority)
INTO :ll_count, :li_max_priority
FROM p_Patient_WP_Item (NOLOCK)
WHERE owned_by = :current_user.user_id
AND ordered_service = 'MESSAGE'
AND active_service_flag = 'Y';
if not tf_check() then return -1

if ll_count <= 0 then
	if text <> "No Messages" then text = "No Messages"
	if tabtextcolor <> color_text_normal then tabtextcolor = color_text_normal
else
	if text <> "Messages (" + string(ll_count) + ")" then text = "Messages (" + string(ll_count) + ")"
	if tabtextcolor <> color_text_error then tabtextcolor = color_text_error
end if

ls_priority_bitmap = datalist.priority_bitmap(li_max_priority)
if len(ls_priority_bitmap) > 0 then
	if picturename <> ls_priority_bitmap then picturename = ls_priority_bitmap
else
	// Clear out the picture if we couldn't find one
	if picturename <> "" then picturename = ""
end if

return 1

end function

public subroutine display_deleted_messages ();dw_todo_list.dataobject = "dw_message_deleted_list"

dw_todo_list.object.t_1.width = dw_todo_list.width - 37

dw_todo_list.settransobject(sqlca)
dw_todo_list.retrieve(current_user.user_id)

end subroutine

on u_tabpage_messages.create
int iCurrent
call super::create
this.pb_refresh=create pb_refresh
this.st_refresh_title=create st_refresh_title
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_compose_message=create st_compose_message
this.st_edit_folders=create st_edit_folders
this.st_folder=create st_folder
this.st_folder_title=create st_folder_title
this.dw_todo_list=create dw_todo_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_refresh
this.Control[iCurrent+2]=this.st_refresh_title
this.Control[iCurrent+3]=this.st_page
this.Control[iCurrent+4]=this.pb_up
this.Control[iCurrent+5]=this.pb_down
this.Control[iCurrent+6]=this.st_compose_message
this.Control[iCurrent+7]=this.st_edit_folders
this.Control[iCurrent+8]=this.st_folder
this.Control[iCurrent+9]=this.st_folder_title
this.Control[iCurrent+10]=this.dw_todo_list
end on

on u_tabpage_messages.destroy
call super::destroy
destroy(this.pb_refresh)
destroy(this.st_refresh_title)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_compose_message)
destroy(this.st_edit_folders)
destroy(this.st_folder)
destroy(this.st_folder_title)
destroy(this.dw_todo_list)
end on

event constructor;setnull(cpr_id)

end event

type pb_refresh from picturebutton within u_tabpage_messages
integer x = 2034
integer y = 784
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "button_refresh.bmp"
alignment htextalign = right!
end type

event clicked;refresh()

end event

type st_refresh_title from statictext within u_tabpage_messages
integer x = 2034
integer y = 732
integer width = 137
integer height = 68
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Rfrsh"
boolean focusrectangle = false
end type

type st_page from statictext within u_tabpage_messages
integer x = 2043
integer y = 272
integer width = 133
integer height = 136
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_up from u_picture_button within u_tabpage_messages
boolean visible = false
integer x = 2034
integer y = 16
integer width = 137
integer height = 116
integer taborder = 50
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_todo_list.current_page

dw_todo_list.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within u_tabpage_messages
boolean visible = false
integer x = 2034
integer y = 144
integer width = 137
integer height = 116
integer taborder = 40
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_todo_list.current_page
li_last_page = dw_todo_list.last_page

dw_todo_list.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type st_compose_message from statictext within u_tabpage_messages
integer x = 1728
integer y = 1588
integer width = 325
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "New Msg"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;integer li_sts
str_attributes lstr_attributes

lstr_attributes.attribute_count = 1
lstr_attributes.attribute[1].attribute = "allow_multiple_recipients"
lstr_attributes.attribute[1].value = "true"

li_sts = service_list.do_service(compose_message_service, lstr_attributes)
if li_sts <= 0 then return


end event

type st_edit_folders from statictext within u_tabpage_messages
integer x = 1179
integer y = 1612
integer width = 398
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Edit Folder List"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
openwithparm(w_message_folder_edit, "MESSAGE_FOLDER", f_active_window())


end event

type st_folder from statictext within u_tabpage_messages
event tab_selected ( )
integer x = 293
integer y = 1588
integer width = 878
integer height = 104
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Inbox"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
u_ds_data luo_data
long ll_count
long i
string ls_filter
long ll_folder_count

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_top_20_user_list_pick")
ll_count = luo_data.retrieve(current_user.user_id, "MESSAGE_FOLDER")

ll_folder_count = 3
popup.items[1] = "Inbox"
popup.items[2] = "Read Messages"
popup.items[3] = "Sent Messages"

if datalist.get_preference_boolean( "PREFERENCES", "Show Deleted Folder", true) then
	ll_folder_count = 4
	popup.items[4] = "Deleted Messages"
end if

for i = 1 to ll_count
	popup.items[i + ll_folder_count] = luo_data.object.item_text[i]
next

popup.data_row_count = ll_count + ll_folder_count

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return


text = popup_return.items[1]

CHOOSE CASE lower(popup_return.items[1])
	CASE "inbox"
		set_folder("INBOX", "")
	CASE "read messages"
		set_folder("READ", "")
	CASE "sent messages"
		set_folder("SENT", "")
	CASE "deleted messages"
		set_folder("DELETED", "")
	CASE ELSE
		// User folder
		set_folder("USER", popup_return.items[1])
END CHOOSE


refresh()


end event

type st_folder_title from statictext within u_tabpage_messages
integer x = 27
integer y = 1604
integer width = 247
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Folder:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_todo_list from u_dw_pick_list within u_tabpage_messages
event post_click ( long clicked_row )
integer width = 2030
integer height = 1552
integer taborder = 10
string dataobject = "dw_message_inbox_list"
boolean border = false
boolean select_computed = false
end type

event selected;call super::selected;String		ls_user_id
Long			ll_patient_workplan_item_id
str_popup	popup

// If we register a click on the messages screen, we can be certain that
// there isn't any user or service context, so clear it.
f_clear_context()

f_user_logon()
If isnull(current_user) Then Return

do_message(selected_row)

clear_selected()


end event

event computed_clicked;call super::computed_clicked;long ll_patient_workplan_item_id

ll_patient_workplan_item_id = object.patient_workplan_item_id[clicked_row]
if ll_patient_workplan_item_id > 0 then
	service_list.display_service_properties(ll_patient_workplan_item_id)
end if

end event

