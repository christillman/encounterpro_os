$PBExportHeader$u_tabpage_shell_documents.sru
forward
global type u_tabpage_shell_documents from u_main_tabpage_base
end type
type cbx_display_completed from checkbox within u_tabpage_shell_documents
end type
type cb_order from commandbutton within u_tabpage_shell_documents
end type
type cb_print_send_all from commandbutton within u_tabpage_shell_documents
end type
type cb_refresh from commandbutton within u_tabpage_shell_documents
end type
type dw_documents from u_dw_pick_list within u_tabpage_shell_documents
end type
type cbx_display_cancelled from checkbox within u_tabpage_shell_documents
end type
end forward

global type u_tabpage_shell_documents from u_main_tabpage_base
integer width = 2981
integer height = 1320
event resized ( )
cbx_display_completed cbx_display_completed
cb_order cb_order
cb_print_send_all cb_print_send_all
cb_refresh cb_refresh
dw_documents dw_documents
cbx_display_cancelled cbx_display_cancelled
end type
global u_tabpage_shell_documents u_tabpage_shell_documents

type variables
u_ds_data status_refresh_documents

u_component_wp_item_document document
boolean document_mode = false

string view_context_object
string view_cpr_id
long view_object_key


date begin_date
date end_date

string tab_text = "Outbox"

boolean first_time = true

string order_menu_context = "Outbox Order"
long order_menu_id
end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public subroutine refresh_tab ()
public function integer refresh_status ()
public subroutine other_menu (long pl_row, u_component_wp_item_document puo_document)
public subroutine set_screen ()
public subroutine resize_tabpage ()
end prototypes

event resized();resize_tabpage()

end event

public function integer initialize ();string ls_null
long ll_width

setnull(ls_null)

resize_tabpage()

// Create a hidden datastore for refreshing the status of the on-screen documents
status_refresh_documents = CREATE u_ds_data
status_refresh_documents.set_dataobject("dw_jmj_get_documents")

dw_documents.settransobject(sqlca)

view_context_object = "General"
setnull(view_cpr_id)
setnull(view_object_key)

setnull(begin_date)
setnull(end_date)

tab_text = datalist.get_preference("Preferences", "Document Manager Tab Text", "Outbox")

order_menu_id = f_get_context_menu2(order_menu_context, ls_null, ls_null)

return 1

end function

public subroutine refresh ();long ll_lastrow
long ll_rows
string ls_null
long ll_null
long ll_new_lastrow
long ll_count
long i
string ls_status
long ll_ready_count
string ls_new_tab_text
long ll_new_tab_color
string ls_filter

setnull(ls_null)
setnull(ll_null)

dw_documents.setredraw(false)
ll_lastrow = long(dw_documents.object.datawindow.lastrowonpage)

// Context Object mode
ls_filter =""
if not cbx_display_cancelled.checked then
	ls_filter = "(lower(status)<>'cancelled')"
end if
if not cbx_display_completed.checked then
	if len(ls_filter) > 0 then
		ls_filter += " and "
	end if
	ls_filter += "(lower(status)<>'completed')"
end if
dw_documents.setfilter(ls_filter)
ll_rows = dw_documents.retrieve(begin_date, end_date)
if ll_rows < 0 then return

ll_new_lastrow = long(dw_documents.object.datawindow.lastrowonpage)

if ll_lastrow > ll_new_lastrow then
	dw_documents.scroll_to_row(ll_lastrow)
end if

dw_documents.setredraw(true)

first_time = false

set_screen()


end subroutine

public subroutine refresh_tab ();
refresh()

return

end subroutine

public function integer refresh_status ();long ll_rows
long i
long ll_row
long ll_patient_workplan_item_id
string ls_find
long ll_display_count
long ll_ready_count
string ls_status
long ll_count

ll_display_count = dw_documents.rowcount()
if ll_display_count <= 0 then return 0

if document_mode then
	// Single document mode
	dw_documents.setfilter("")
	ll_rows = status_refresh_documents.retrieve("Document", document.cpr_id, document.patient_workplan_item_id)
	if ll_rows < 0 then return -1
	if ll_rows = 0 then return 0
else
	// Context Object mode
	if cbx_display_cancelled.checked then
		dw_documents.setfilter("")
	else
		dw_documents.setfilter("lower(status)<>'cancelled'")
	end if
	ll_rows = status_refresh_documents.retrieve(view_context_object, view_cpr_id, view_object_key)
	if ll_rows < 0 then return -1
	if ll_rows = 0 then return 0
end if

for i = 1 to ll_rows
	ll_patient_workplan_item_id = status_refresh_documents.object.patient_workplan_item_id[i]
	ls_find = "patient_workplan_item_id=" + string(ll_patient_workplan_item_id)
	ll_row = dw_documents.find(ls_find, 1, ll_display_count)
	if ll_row > 0 then
		dw_documents.object.status[ll_row] = status_refresh_documents.object.status[i]
		dw_documents.object.display_status[ll_row] = status_refresh_documents.object.display_status[i]
	end if
next

if not document_mode then
	ll_ready_count = 0
	ll_count = dw_documents.rowcount( )
	for i = 1 to ll_count
		ls_status = dw_documents.object.status[i]
		if lower(ls_status) = 'ordered' or lower(ls_status) = 'created' then
			ll_ready_count++
		end if
	next
	
	if ll_ready_count > 0 then
		cb_print_send_all.visible = true
	else
		cb_print_send_all.visible = false
	end if
end if

set_screen()

return 1

end function

public subroutine other_menu (long pl_row, u_component_wp_item_document puo_document);str_popup popup
str_popup_return popup_return
string lsa_buttons[]
integer li_button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_temp
string ls_description
string ls_null
long ll_null
datetime ldt_null
string ls_status
long ll_patient_workplan_item_id
string ls_ordered_by
string ls_ordered_for
string ls_purpose
string ls_context_object
str_service_info lstr_service
string ls_report_id

setnull(ldt_null)
setnull(ls_null)
setnull(ll_null)

ll_patient_workplan_item_id = dw_documents.object.patient_workplan_item_id[pl_row]
ls_status = lower(dw_documents.object.status[pl_row])
ls_ordered_by = dw_documents.object.ordered_by[pl_row]
ls_ordered_for = dw_documents.object.ordered_for[pl_row]
ls_purpose = dw_documents.object.purpose[pl_row]
ls_report_id = dw_documents.object.report_id[pl_row]
ls_context_object = dw_documents.object.document_context_object[pl_row]

if ls_status = "ordered" and not document_mode then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button18.bmp"
	popup.button_helps[popup.button_count] = "Edit the subject and message for this document"
	popup.button_titles[popup.button_count] = "Cover Letter"
	lsa_buttons[popup.button_count] = "COVER"
end if

if ls_status = "ordered" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit the context object associated with this document"
	popup.button_titles[popup.button_count] = "Edit"
	lsa_buttons[popup.button_count] = "EDIT"
end if

if ls_status = "ordered" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_sign.bmp"
	popup.button_helps[popup.button_count] = "Sign this document"
	popup.button_titles[popup.button_count] = "Sign"
	lsa_buttons[popup.button_count] = "SIGN"
end if

if ls_status = "ordered" or ls_status = "sent" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Cancel this document"
	popup.button_titles[popup.button_count] = "Cancel Document"
	lsa_buttons[popup.button_count] = "DELETE"
end if

if ls_status = "ready" and user_list.is_superuser(current_user.user_id) then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_message_send.bmp"
	popup.button_helps[popup.button_count] = "Send document from client computer"
	popup.button_titles[popup.button_count] = "Send From Client"
	lsa_buttons[popup.button_count] = "SENDFROMCLIENT"
end if

if ls_status = "sent" or ls_status = "error" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_message_send.bmp"
	popup.button_helps[popup.button_count] = "Resend this document"
	popup.button_titles[popup.button_count] = "Resend"
	lsa_buttons[popup.button_count] = "RESEND"
end if

if ls_status = "error" or config_mode then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button26.bmp"
	popup.button_helps[popup.button_count] = "Reset this document back to the 'Ordered' state"
	popup.button_titles[popup.button_count] = "Reset"
	lsa_buttons[popup.button_count] = "RESET"
end if

if ls_status = "ordered" and user_list.is_user_privileged(current_user.user_id, "Edit Users") then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Configure the sender of this document"
	popup.button_titles[popup.button_count] = "Config Sender"
	lsa_buttons[popup.button_count] = "CONFIG_SENDER"
end if

if ls_status = "ordered" and user_list.is_user_privileged(current_user.user_id, "Edit Actors") then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Configure the recipient of this document"
	popup.button_titles[popup.button_count] = "Config Recipient"
	lsa_buttons[popup.button_count] = "CONFIG_RECIPIENT"
end if

If user_list.is_user_privileged(current_scribe.user_id, "Configuration Mode") Then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Configure Document"
	popup.button_titles[popup.button_count] = "Configure Document"
	lsa_buttons[popup.button_count] = "CONFIG_DOCUMENT"
End If
		
if ls_status = "ordered" and user_list.is_superuser(current_user.user_id) then
	if isnull(ls_purpose) then
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_changepurpose.bmp"
		popup.button_helps[popup.button_count] = "Set the document purpose"
		popup.button_titles[popup.button_count] = "Set Purpose"
		lsa_buttons[popup.button_count] = "PURPOSE"
	else
		popup.button_count = popup.button_count + 1
		popup.button_icons[popup.button_count] = "button_changepurpose.bmp"
		popup.button_helps[popup.button_count] = "Change the document purpose"
		popup.button_titles[popup.button_count] = "Change Purpose"
		lsa_buttons[popup.button_count] = "PURPOSE"
	end if
end if

if ls_status = "ordered" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_routes.bmp"
	popup.button_helps[popup.button_count] = "Show all the routes for this document"
	popup.button_titles[popup.button_count] = "Show Routes"
	lsa_buttons[popup.button_count] = "ROUTES"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	li_button_pressed = message.doubleparm
	if li_button_pressed < 1 or li_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	li_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[li_button_pressed]
	CASE "COVER"
		document = puo_document
		document_mode = true
	CASE "EDIT"
		puo_document.document_edit()
		// update the description
		dw_documents.object.description[pl_row] = puo_document.description
	CASE "SIGN"
		puo_document.document_sign()
	CASE "DELETE"
		puo_document.document_cancel()
	CASE "SENDFROMCLIENT"
		puo_document.document_send(true) // Send from here, don't queue up for server
	CASE "RESEND"
		puo_document.document_send()
	CASE "RESET"
		puo_document.document_reset()
	CASE "CONFIG_SENDER"
		popup.data_row_count = 1
		popup.items[1] = ls_ordered_by
		openwithparm(w_user_definition, popup)
	CASE "CONFIG_RECIPIENT"
		if upper(ls_ordered_for) = "#PATIENT" then
			lstr_service.service = "PATIENT_DATA"
			service_list.do_service(lstr_service)
		else
			popup.data_row_count = 1
			popup.items[1] = ls_ordered_for
			openwithparm(w_user_definition, popup)
		end if
	CASE "CONFIG_DOCUMENT"
		puo_document.document_configure()
	CASE "PURPOSE"
		popup.argument_count = 1
		popup.argument[1] = ls_context_object
		popup.dataobject = "dw_c_document_purpose_pick_list"
		popup.datacolumn = 1
		popup.displaycolumn = 2
		popup.title = "Select Document Purpose"
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		ls_purpose = popup_return.items[1]
		sqlca.sp_add_workplan_item_attribute(view_cpr_id, ll_null, ll_patient_workplan_item_id, "purpose", ls_purpose, current_scribe.user_id, current_user.user_id)
		if not tf_check() then return
		
		dw_documents.object.purpose[pl_row] = ls_purpose
	CASE "ROUTES"
		if isnull(ls_purpose) then
			openwithparm(w_pop_message, "This document has no purpose")
			return
		end if
		puo_document.show_routes("Routes")
END CHOOSE


end subroutine

public subroutine set_screen ();long ll_lastrow
long ll_rows
string ls_null
long ll_null
long ll_new_lastrow
long ll_count
long i
string ls_status
long ll_ready_count
string ls_new_tab_text
long ll_new_tab_color

setnull(ls_null)
setnull(ll_null)


ll_count = dw_documents.rowcount( )
for i = 1 to ll_count
	ls_status = dw_documents.object.status[i]
	if lower(ls_status) = 'ordered' or lower(ls_status) = 'created' then
		ll_ready_count++
	end if
next

if ll_ready_count > 0 then
	cb_print_send_all.visible = true
	ls_new_tab_text = tab_text + " (" + string(ll_ready_count) + ")"
	ll_new_tab_color = color_text_error
else
	cb_print_send_all.visible = false
	ls_new_tab_text = tab_text
	ll_new_tab_color = color_text_normal
end if

// updating the visible property is expensive on terminal servers so only do it if it has changed
if text <> ls_new_tab_text then text = ls_new_tab_text
if tabtextcolor <> ll_new_tab_color then tabtextcolor = ll_new_tab_color

if order_menu_id > 0 or config_mode then
	cb_order.visible = true
else
	cb_order.visible = false
end if

return

end subroutine

public subroutine resize_tabpage ();long ll_width

cb_refresh.x = 30
cb_refresh.y = height - cb_refresh.height - 30

cbx_display_cancelled.x = cb_refresh.x + cb_refresh.width + 30
cbx_display_cancelled.y = height - cbx_display_cancelled.height - 10

cbx_display_completed.x = cbx_display_cancelled.x
cbx_display_completed.y = cbx_display_cancelled.y - 72

cb_print_send_all.x = width - cb_print_send_all.width - 200
cb_print_send_all.y = cb_refresh.y

cb_order.x = (width - cb_order.width ) / 2
cb_order.y = cb_refresh.y

dw_documents.x = 0
dw_documents.y = 0
dw_documents.width = width
dw_documents.height = cb_refresh.y - 50

// Since half of the extension beyond 700 pb-units will be added to the recipient and route fields, subtract off
// half of the extension past 700
ll_width = 700 + ((dw_documents.width - 2950) / 2)
dw_documents.object.description.width = ll_width

// A display bug requires that we do a refresh, but we can only do it if a refresh has been initiated before
if not first_time then
	refresh()
end if

return

end subroutine

on u_tabpage_shell_documents.create
int iCurrent
call super::create
this.cbx_display_completed=create cbx_display_completed
this.cb_order=create cb_order
this.cb_print_send_all=create cb_print_send_all
this.cb_refresh=create cb_refresh
this.dw_documents=create dw_documents
this.cbx_display_cancelled=create cbx_display_cancelled
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_display_completed
this.Control[iCurrent+2]=this.cb_order
this.Control[iCurrent+3]=this.cb_print_send_all
this.Control[iCurrent+4]=this.cb_refresh
this.Control[iCurrent+5]=this.dw_documents
this.Control[iCurrent+6]=this.cbx_display_cancelled
end on

on u_tabpage_shell_documents.destroy
call super::destroy
destroy(this.cbx_display_completed)
destroy(this.cb_order)
destroy(this.cb_print_send_all)
destroy(this.cb_refresh)
destroy(this.dw_documents)
destroy(this.cbx_display_cancelled)
end on

type cbx_display_completed from checkbox within u_tabpage_shell_documents
integer x = 530
integer y = 1112
integer width = 590
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Display Completed"
boolean checked = true
end type

event clicked;refresh()
end event

type cb_order from commandbutton within u_tabpage_shell_documents
integer x = 1285
integer y = 1148
integer width = 553
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Order Document"
end type

event clicked;str_attributes lstr_attributes
str_popup_return popup_return
w_window_base lw_pick
string ls_null
long ll_new_menu_id

setnull(ls_null)

if order_menu_id > 0 then
	f_display_menu_with_attributes(order_menu_id, false, lstr_attributes)
elseif config_mode then
	openwithparm(w_pop_yes_no, "There is no menu for ordering outbox documents.  Do you wish to select or create one now?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	
	openwithparm(lw_pick, "General", "w_pick_menu")
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return 0
	
	ll_new_menu_id = long(popup_return.items[1])
	
	sqlca.jmj_new_menu_selection(ll_new_menu_id, ls_null, order_menu_context, ls_null, ls_null)
	if not tf_check() then return
	
	order_menu_id = ll_new_menu_id
	f_display_menu_with_attributes(order_menu_id, false, lstr_attributes)
end if

end event

type cb_print_send_all from commandbutton within u_tabpage_shell_documents
integer x = 2341
integer y = 1136
integer width = 553
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Send/Print All"
end type

event clicked;long ll_count
long i
long ll_ready_count
long lla_ready_row[]
string ls_status
integer li_wait
long ll_patient_workplan_item_id
u_component_wp_item_document luo_document
integer li_sts

ll_ready_count = 0
luo_document = CREATE u_component_wp_item_document

ll_count = dw_documents.rowcount( )
for i = 1 to ll_count
	ls_status = dw_documents.object.status[i]
	if lower(ls_status) = 'ordered' or lower(ls_status) = 'created' then
		ll_ready_count++
		lla_ready_row[ll_ready_count] = i
	end if
next

li_wait = f_please_wait_open()
f_please_wait_progress_bar(li_wait, 0, ll_ready_count)

for i = 1 to ll_ready_count
	ll_patient_workplan_item_id = dw_documents.object.patient_workplan_item_id[lla_ready_row[i]]
	li_sts = luo_document.initialize(ll_patient_workplan_item_id)
	if li_sts > 0 then
		li_sts = luo_document.document_send()
	end if
	
	f_please_wait_progress_bar(li_wait, i, ll_ready_count)
next

f_please_wait_close(li_wait)

DESTROY luo_document

refresh()


end event

type cb_refresh from commandbutton within u_tabpage_shell_documents
integer x = 69
integer y = 1136
integer width = 443
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresh"
end type

event clicked;refresh()

end event

type dw_documents from u_dw_pick_list within u_tabpage_shell_documents
integer width = 2843
integer height = 1024
integer taborder = 10
string dataobject = "dw_jmj_get_documents_general"
boolean vscrollbar = true
boolean border = false
end type

event buttonclicked;call super::buttonclicked;long ll_patient_workplan_item_id

if not document_mode then
	ll_patient_workplan_item_id = object.patient_workplan_item_id[row]
	document = CREATE u_component_wp_item_document
	document.initialize(ll_patient_workplan_item_id)
end if

CHOOSE CASE lower(dwo.name)
	CASE "b_view"
		document.document_view()
	CASE "b_other"
		other_menu(row, document)
	CASE "b_confirm"
		document.document_confirm_receipt()
	CASE "b_send"
		document.document_send()
		document_mode = false
END CHOOSE

if not document_mode then
	DESTROY document
end if

refresh_status()


end event

event selected;call super::selected;string ls_column
string ls_temp
long ll_pos
integer li_selected_flag
integer li_column
string ls_ordered_for
string ls_dispatch_method
str_actor_communication lstr_actor_communication
integer li_sts
long ll_patient_workplan_item_id
string ls_communication_type
string ls_via_address
long ll_via_address_choices
string ls_status
string ls_error_message
w_window_base lw_window

li_selected_flag = object.selected_flag[selected_row]
ll_patient_workplan_item_id = object.patient_workplan_item_id[selected_row]
ls_ordered_for = object.ordered_for[selected_row]
ls_dispatch_method = object.dispatch_method[selected_row]
ls_communication_type = object.communication_type[selected_row]
ls_via_address = object.via_address[selected_row]
ll_via_address_choices = object.via_address_choices[selected_row]
ls_status = object.status[selected_row]

li_sts = 0

// If we're not in document mode then temporarily instantiate a document object
if not document_mode then
	ll_patient_workplan_item_id = object.patient_workplan_item_id[selected_row]
	document = CREATE u_component_wp_item_document
	document.initialize(ll_patient_workplan_item_id)
end if

CHOOSE CASE lower(lastcolumnname)
	CASE "description"
		if not document_mode then
			document_mode = true
			refresh()
//			sle_subject.setfocus()
			return
		else
			// Let any pending events from the cover letter controls complete
			yield()
			
			document_mode = false
			parent.function POST refresh()
			return
		end if
	CASE "user_full_name"
		if lower(ls_status) = "ordered" or lower(ls_status) = "created" then
			li_sts = document.document_pick_recipient()
		end if
	CASE "dispatch_method"
		if lower(ls_status) = "ordered" or lower(ls_status) = "created" then
			li_sts = document.document_pick_dispatch_method()
		end if
	CASE "via_address", "compute_via_address"
		if (lower(ls_status) = "ordered" or lower(ls_status) = "created") &
			and  ll_via_address_choices > 1 &
			and not isnull(ls_ordered_for) &
			and not isnull(ls_dispatch_method) then
				li_sts = document.document_pick_address()
		end if
	CASE "display_status"
		document.document_display_properties()
//	CASE "b_view"
//	CASE "b_sign"
END CHOOSE

if not document_mode then
	DESTROY document
end if

if li_sts > 0 then
	refresh()
else
	clear_selected( )
end if

end event

type cbx_display_cancelled from checkbox within u_tabpage_shell_documents
integer x = 530
integer y = 1184
integer width = 590
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Display Cancelled"
end type

event clicked;refresh()
end event

