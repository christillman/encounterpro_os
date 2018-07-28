HA$PBExportHeader$u_tabpage_context_documents_outgoing.sru
forward
global type u_tabpage_context_documents_outgoing from u_tabpage
end type
type cbx_display_completed from checkbox within u_tabpage_context_documents_outgoing
end type
type cb_order from commandbutton within u_tabpage_context_documents_outgoing
end type
type cb_print_send_all from commandbutton within u_tabpage_context_documents_outgoing
end type
type cb_refresh from commandbutton within u_tabpage_context_documents_outgoing
end type
type cbx_display_cancelled from checkbox within u_tabpage_context_documents_outgoing
end type
type st_subject_title from statictext within u_tabpage_context_documents_outgoing
end type
type sle_subject from singlelineedit within u_tabpage_context_documents_outgoing
end type
type st_message_title from statictext within u_tabpage_context_documents_outgoing
end type
type mle_message from multilineedit within u_tabpage_context_documents_outgoing
end type
type st_patient_title from statictext within u_tabpage_context_documents_outgoing
end type
type st_patient from statictext within u_tabpage_context_documents_outgoing
end type
type cb_subject from commandbutton within u_tabpage_context_documents_outgoing
end type
type cb_body from commandbutton within u_tabpage_context_documents_outgoing
end type
type st_item_title from statictext within u_tabpage_context_documents_outgoing
end type
type st_item from statictext within u_tabpage_context_documents_outgoing
end type
type cbx_include_cover_page from checkbox within u_tabpage_context_documents_outgoing
end type
type dw_documents from u_dw_pick_list within u_tabpage_context_documents_outgoing
end type
end forward

global type u_tabpage_context_documents_outgoing from u_tabpage
integer width = 2981
integer height = 1756
cbx_display_completed cbx_display_completed
cb_order cb_order
cb_print_send_all cb_print_send_all
cb_refresh cb_refresh
cbx_display_cancelled cbx_display_cancelled
st_subject_title st_subject_title
sle_subject sle_subject
st_message_title st_message_title
mle_message mle_message
st_patient_title st_patient_title
st_patient st_patient
cb_subject cb_subject
cb_body cb_body
st_item_title st_item_title
st_item st_item
cbx_include_cover_page cbx_include_cover_page
dw_documents dw_documents
end type
global u_tabpage_context_documents_outgoing u_tabpage_context_documents_outgoing

type variables
u_ds_data status_refresh_documents

u_component_wp_item_document document
boolean document_mode = false

string view_context_object
string view_cpr_id
long view_object_key


date begin_date
date end_date

string tab_text = "Outgoing"

boolean first_time = true

string order_menu_context
long order_menu_id

u_component_workplan_item service

string patient_subdir

long context_object_mode_height
long single_document_mode_height = 264

string top_20_prefix

boolean cover_page_changed
boolean original_cover_page


end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public function integer refresh_status ()
public subroutine other_menu (long pl_row, u_component_wp_item_document puo_document)
public subroutine refresh_tabtext ()
end prototypes

public function integer initialize ();string ls_null
long ll_width

setnull(ls_null)

this.trigger EVENT resize_tabpage()

// Make all the document fields invisible so they don't flash on the first refresh
st_item.visible = false
st_item_title.visible = false
st_message_title.visible = false
st_patient.visible = false
st_patient_title.visible = false
st_subject_title.visible = false
sle_subject.visible = false
mle_message.visible = false
cb_body.visible = false
cb_subject.visible = false
cbx_include_cover_page.visible = false
dw_documents.height = context_object_mode_height

// Create a hidden datastore for refreshing the status of the on-screen documents
status_refresh_documents = CREATE u_ds_data
status_refresh_documents.set_dataobject("dw_jmj_get_documents")


if isnull(parent_tab.service) or not isvalid(parent_tab.service) then
	if isnull(current_service) or not isvalid(current_service) then
		log.log(this, "initialize()", "Service context not found", 4)
	else
		service = current_service
		view_context_object = current_service.context_object
		view_cpr_id = current_service.cpr_id
		view_object_key = current_service.object_key
	end if
else
	service = parent_tab.service
	view_context_object = parent_tab.service.context_object
	view_cpr_id = parent_tab.service.cpr_id
	view_object_key = parent_tab.service.object_key
end if

// The Patient Data service can be called from any context but we would rather show the patient context
if upper(service.service) = "PATIENT_DATA" then
	view_context_object = "Patient"
	setnull(view_object_key)
end if

if upper(view_context_object) = "GENERAL" then
	dw_documents.dataobject = "dw_jmj_get_documents_general"
else
	dw_documents.dataobject = "dw_jmj_get_documents"
end if

dw_documents.settransobject(sqlca)

setnull(begin_date)
setnull(end_date)

//tab_text = datalist.get_preference("Preferences", "Document Manager Tab Text", "Outbox")
order_menu_context = f_context_object_short(view_context_object) + " Order Doc"
order_menu_id = f_get_context_menu2(order_menu_context, ls_null, ls_null)

if lower(service.item_type) = "document" then
	document = service
	document_mode = true
else
	// Create an empty document object and set document_mode to false
	document_mode = false
end if

refresh_tabtext()

return 1

end function

public subroutine refresh ();u_component_wp_item_document luo_document
long ll_rows
string ls_context_object
long ll_object_key
string ls_dispatch_method
string ls_temp
long ll_lastrow
long ll_new_lastrow
long ll_count
long i
string ls_status
long ll_ready_count
string ls_filter
long ll_width

if first_time then
	initialize()
	
	// Since half of the extension beyond 700 pb-units will be added to the recipient and route fields, subtract off
	// half of the extension past 700
	ll_width = 700 + ((dw_documents.width - 2950) / 2)
	dw_documents.object.description.width = ll_width
	
	first_time = false
end if

if document_mode then
	// Single document mode
	dw_documents.setfilter("")
	ll_rows = dw_documents.retrieve("Document", service.cpr_id, document.patient_workplan_item_id)
	if ll_rows < 0 then return
	if ll_rows = 0 then return

	ls_dispatch_method = dw_documents.object.dispatch_method[1]
	ls_context_object = dw_documents.object.document_context_object[1]
	ll_object_key = dw_documents.object.document_object_key[1]
	
	st_patient.text = document.get_property_value("patient.FullName")
	st_item.text = sqlca.fn_patient_object_description(service.cpr_id, &
																		ls_context_object, &
																		ll_object_key)

	dw_documents.height = single_document_mode_height
	dw_documents.border = false
	dw_documents.vscrollbar = false
	
//	if lower(service.item_type) = "document" then
//		cb_finished.text = "Close"
//	else
//		cb_finished.text = "OK"
//	end if
	
	cb_print_send_all.visible = false
	
	st_item.visible = true
	st_item_title.visible = true
	st_message_title.visible = true
	st_patient.visible = true
	st_patient_title.visible = true
	st_subject_title.visible = true
	sle_subject.visible = true
	mle_message.visible = true
	cb_body.visible = true
	cb_subject.visible = true
	cbx_include_cover_page.visible = true

	sle_subject.text = document.get_attribute("message_subject")
	mle_message.text = document.get_attribute("message")
	ls_temp = document.get_attribute("cover_page")
	if isnull(ls_temp) then
		if len(sle_subject.text) > 0 or len(mle_message.text) > 0 then
			document.set_attribute("cover_page", "Y")
			cbx_include_cover_page.checked = true
		else
			cbx_include_cover_page.checked = false
		end if
	else
		cbx_include_cover_page.checked = f_string_to_boolean(ls_temp)
	end if
	original_cover_page = cbx_include_cover_page.checked
	
//	if lower(ls_dispatch_method) = "printer" then
//		cb_send_and_exit.text = "Print and Close"
//	else
//		cb_send_and_exit.text = "Send and Close"
//	end if
	
	if lower(document.status) = "ordered" then
		sle_subject.enabled = true
		mle_message.enabled = true
//		cb_send_and_exit.visible = true
	else
		sle_subject.enabled = false
		mle_message.enabled = false
//		cb_send_and_exit.visible = false
	end if
	
	cover_page_changed = false
	cb_order.visible = false
else
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
	ll_rows = dw_documents.retrieve(view_context_object, service.cpr_id, view_object_key)
	if ll_rows < 0 then return
	
	dw_documents.height = context_object_mode_height
	dw_documents.border = true
	dw_documents.vscrollbar = true
	
	ll_new_lastrow = long(dw_documents.object.datawindow.lastrowonpage)
	
	if ll_lastrow > ll_new_lastrow then
		dw_documents.scroll_to_row(ll_lastrow)
	end if

	dw_documents.setredraw(true)

//	cb_send_and_exit.visible = false
	
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

	st_item.visible = false
	st_item_title.visible = false
	st_message_title.visible = false
	st_patient.visible = false
	st_patient_title.visible = false
	st_subject_title.visible = false
	sle_subject.visible = false
	mle_message.visible = false
	cb_body.visible = false
	cb_subject.visible = false
	cbx_include_cover_page.visible = false

	sle_subject.text = ""
	mle_message.text = ""

	if order_menu_id > 0 or config_mode then
		cb_order.visible = true
	else
		cb_order.visible = false
	end if
end if

refresh_tabtext()

return

//long ll_lastrow
//long ll_rows
//string ls_null
//long ll_null
//long ll_new_lastrow
//long ll_count
//long i
//string ls_status
//long ll_ready_count
//string ls_new_tab_text
//long ll_new_tab_color
//string ls_filter
//
//setnull(ls_null)
//setnull(ll_null)
//
//dw_documents.setredraw(false)
//ll_lastrow = long(dw_documents.object.datawindow.lastrowonpage)
//
//// Context Object mode
//ls_filter =""
//if not cbx_display_cancelled.checked then
//	ls_filter = "(lower(status)<>'cancelled')"
//end if
//if not cbx_display_completed.checked then
//	if len(ls_filter) > 0 then
//		ls_filter += " and "
//	end if
//	ls_filter += "(lower(status)<>'completed')"
//end if
//dw_documents.setfilter(ls_filter)
//dw_documents.settransobject(sqlca)
//ll_rows = dw_documents.retrieve(begin_date, end_date)
//if ll_rows < 0 then return
//
//ll_new_lastrow = long(dw_documents.object.datawindow.lastrowonpage)
//
//if ll_lastrow > ll_new_lastrow then
//	dw_documents.scroll_to_row(ll_lastrow)
//end if
//
//dw_documents.setredraw(true)
//
//first_time = false
//
//set_screen()
//
//
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

refresh_tabtext()

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

public subroutine refresh_tabtext ();long ll_ready_count
long ll_total_count
long ll_cancelled_count
string ls_new_tab_text
long ll_new_tab_color

SELECT ready_count, total_count, cancelled_count
INTO :ll_ready_count, :ll_total_count, :ll_cancelled_count
FROM dbo.fn_count_documents_for_object(:view_context_object, :view_cpr_id, :view_object_key, :begin_date, :end_date);
if not tf_check() then return


ls_new_tab_text = tab_text + " (" + string(ll_ready_count) + " Ready / " + string(ll_total_count) + " Total)"

if ll_ready_count > 0 then
	cb_print_send_all.visible = true
	ll_new_tab_color = color_text_error
else
	cb_print_send_all.visible = false
	ll_new_tab_color = color_text_normal
end if

// updating the visible property is expensive on terminal servers so only do it if it has changed
if text <> ls_new_tab_text then text = ls_new_tab_text
if tabtextcolor <> ll_new_tab_color then tabtextcolor = ll_new_tab_color


return

end subroutine

on u_tabpage_context_documents_outgoing.create
int iCurrent
call super::create
this.cbx_display_completed=create cbx_display_completed
this.cb_order=create cb_order
this.cb_print_send_all=create cb_print_send_all
this.cb_refresh=create cb_refresh
this.cbx_display_cancelled=create cbx_display_cancelled
this.st_subject_title=create st_subject_title
this.sle_subject=create sle_subject
this.st_message_title=create st_message_title
this.mle_message=create mle_message
this.st_patient_title=create st_patient_title
this.st_patient=create st_patient
this.cb_subject=create cb_subject
this.cb_body=create cb_body
this.st_item_title=create st_item_title
this.st_item=create st_item
this.cbx_include_cover_page=create cbx_include_cover_page
this.dw_documents=create dw_documents
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_display_completed
this.Control[iCurrent+2]=this.cb_order
this.Control[iCurrent+3]=this.cb_print_send_all
this.Control[iCurrent+4]=this.cb_refresh
this.Control[iCurrent+5]=this.cbx_display_cancelled
this.Control[iCurrent+6]=this.st_subject_title
this.Control[iCurrent+7]=this.sle_subject
this.Control[iCurrent+8]=this.st_message_title
this.Control[iCurrent+9]=this.mle_message
this.Control[iCurrent+10]=this.st_patient_title
this.Control[iCurrent+11]=this.st_patient
this.Control[iCurrent+12]=this.cb_subject
this.Control[iCurrent+13]=this.cb_body
this.Control[iCurrent+14]=this.st_item_title
this.Control[iCurrent+15]=this.st_item
this.Control[iCurrent+16]=this.cbx_include_cover_page
this.Control[iCurrent+17]=this.dw_documents
end on

on u_tabpage_context_documents_outgoing.destroy
call super::destroy
destroy(this.cbx_display_completed)
destroy(this.cb_order)
destroy(this.cb_print_send_all)
destroy(this.cb_refresh)
destroy(this.cbx_display_cancelled)
destroy(this.st_subject_title)
destroy(this.sle_subject)
destroy(this.st_message_title)
destroy(this.mle_message)
destroy(this.st_patient_title)
destroy(this.st_patient)
destroy(this.cb_subject)
destroy(this.cb_body)
destroy(this.st_item_title)
destroy(this.st_item)
destroy(this.cbx_include_cover_page)
destroy(this.dw_documents)
end on

event resize_tabpage;call super::resize_tabpage;long ll_right_gap

// Restore object dimensions in case they have been auto-resized
cbx_display_completed.width = 590
cbx_display_completed.height = 80

cb_order.width = 553
cb_order.height = 108

cb_print_send_all.width = 553
cb_print_send_all.height = 108

cb_refresh.width = 443
cb_refresh.height = 108

cbx_display_cancelled.width = 590
cbx_display_cancelled.height = 80

st_subject_title.width = 343
st_subject_title.height = 76

sle_subject.width = 2194
sle_subject.height = 92

st_message_title.width = 343
st_message_title.height = 76

mle_message.width = 2194
mle_message.height = 656

st_patient_title.width = 343
st_patient_title.height = 76

st_patient.width = 1280
st_patient.height = 88

cb_subject.width = 128
cb_subject.height = 100

cb_body.width = 128
cb_body.height = 100

st_item_title.width = 343
st_item_title.height = 76

st_item.width = 2194
st_item.height = 88

cbx_include_cover_page.width = 841
cbx_include_cover_page.height = 80

dw_documents.width = 2976
dw_documents.height = 264

//////////////////////////////////////////////////////////////////////////////////////////
// Now size and move the objects
//////////////////////////////////////////////////////////////////////////////////////////

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
dw_documents.width = width - 20
dw_documents.height = cb_refresh.y - 50

context_object_mode_height = dw_documents.height

ll_right_gap = 250

// Top Row
st_patient_title.y = single_document_mode_height + 50
st_patient.y = st_patient_title.y
cbx_include_cover_page.y = st_patient.y + ((cbx_include_cover_page.height - st_patient.height) / 2)
cbx_include_cover_page.x = width - cbx_include_cover_page.width - ll_right_gap
st_patient.width = cbx_include_cover_page.x - st_patient.x - 100

// 2nd Row
st_item_title.y = st_patient_title.y + st_patient_title.height + 40
st_item.y = st_item_title.y
st_item.width = width  - st_item.x - ll_right_gap

// 3rd Row
st_subject_title.y = st_item_title.y + st_item_title.height + 40
sle_subject.y = st_subject_title.y
sle_subject.width = st_item.width
cb_subject.x = sle_subject.x + sle_subject.width + 12
cb_subject.y = st_subject_title.y - 4

// Last Row
st_message_title.y = st_subject_title.y + st_subject_title.height + 40
mle_message.y = st_message_title.y
mle_message.width = st_item.width
mle_message.height = cbx_display_completed.y - mle_message.y - 50
cb_body.x = cb_subject.x
cb_body.y = mle_message.y + mle_message.height - cb_body.height

// A display bug requires that we do a refresh, but we can only do it if a refresh has been initiated before
if not first_time then
	refresh()
end if

return

end event

type cbx_display_completed from checkbox within u_tabpage_context_documents_outgoing
integer x = 535
integer y = 1584
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
long backcolor = 33538240
string text = "Display Completed"
boolean checked = true
end type

event clicked;refresh()
end event

type cb_order from commandbutton within u_tabpage_context_documents_outgoing
integer x = 1289
integer y = 1620
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
	
	openwithparm(lw_pick, view_context_object, "w_pick_menu")
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return 0
	
	ll_new_menu_id = long(popup_return.items[1])
	
	sqlca.jmj_new_menu_selection(ll_new_menu_id, ls_null, order_menu_context, ls_null, ls_null)
	if not tf_check() then return
	
	order_menu_id = ll_new_menu_id
	f_display_menu_with_attributes(order_menu_id, false, lstr_attributes)
end if

if isvalid(service.service_window) and not isnull(service.service_window) then
	service.service_window.refresh()
end if

end event

type cb_print_send_all from commandbutton within u_tabpage_context_documents_outgoing
integer x = 2345
integer y = 1608
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

type cb_refresh from commandbutton within u_tabpage_context_documents_outgoing
integer x = 73
integer y = 1608
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

type cbx_display_cancelled from checkbox within u_tabpage_context_documents_outgoing
integer x = 535
integer y = 1656
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
long backcolor = 33538240
string text = "Display Cancelled"
end type

event clicked;refresh()
end event

type st_subject_title from statictext within u_tabpage_context_documents_outgoing
integer x = 59
integer y = 600
integer width = 343
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Subject:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_subject from singlelineedit within u_tabpage_context_documents_outgoing
integer x = 430
integer y = 592
integer width = 2194
integer height = 92
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;if not isvalid(document) or isnull(document) then return

document.set_attribute("message_subject", this.text)

if len(text) > 0 then
	if not cover_page_changed then
		cbx_include_cover_page.checked = true
		if not original_cover_page then
			document.set_attribute("cover_page", "Y")
		end if
	end if
end if


end event

type st_message_title from statictext within u_tabpage_context_documents_outgoing
integer x = 59
integer y = 748
integer width = 343
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Message:"
alignment alignment = right!
boolean focusrectangle = false
end type

type mle_message from multilineedit within u_tabpage_context_documents_outgoing
integer x = 430
integer y = 720
integer width = 2194
integer height = 656
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
end type

event modified;if not isvalid(document) or isnull(document) then return

document.set_attribute("message", this.text)

if len(text) > 0 then
	if not cover_page_changed then
		cbx_include_cover_page.checked = true
		if not original_cover_page then
			document.set_attribute("cover_page", "Y")
		end if
	end if
end if

end event

type st_patient_title from statictext within u_tabpage_context_documents_outgoing
integer x = 59
integer y = 348
integer width = 343
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Patient:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_patient from statictext within u_tabpage_context_documents_outgoing
integer x = 430
integer y = 340
integer width = 1280
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type cb_subject from commandbutton within u_tabpage_context_documents_outgoing
integer x = 2638
integer y = 588
integer width = 128
integer height = 100
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_popup popup
str_popup_return popup_return

if not isvalid(document) or isnull(document) then return

popup.title = "Select Message Subject"
popup.data_row_count = 2
popup.items[1] = top_20_prefix + "_SUBJECT"
popup.items[2] = ""
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

sle_subject.text = popup_return.items[1]

document.set_attribute("message_subject", sle_subject.text)

mle_message.setfocus()

end event

type cb_body from commandbutton within u_tabpage_context_documents_outgoing
integer x = 2638
integer y = 1276
integer width = 128
integer height = 100
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_popup popup
str_popup_return popup_return

if not isvalid(document) or isnull(document) then return

popup.title = "Select Message Body"
popup.data_row_count = 2
popup.items[1] = top_20_prefix + "_BODY"
popup.items[2] = ""
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

mle_message.replacetext(popup_return.items[1])

document.set_attribute("message", mle_message.text)

mle_message.setfocus()

end event

type st_item_title from statictext within u_tabpage_context_documents_outgoing
integer x = 59
integer y = 476
integer width = 343
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Item:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_item from statictext within u_tabpage_context_documents_outgoing
integer x = 430
integer y = 468
integer width = 2194
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type cbx_include_cover_page from checkbox within u_tabpage_context_documents_outgoing
integer x = 1815
integer y = 344
integer width = 841
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Include Cover Letter/Page"
end type

event clicked;if not isvalid(document) or isnull(document) then return

if this.checked then
	document.set_attribute("cover_page", "Y")
else
	document.set_attribute("cover_page", "N")
end if

cover_page_changed = true

end event

type dw_documents from u_dw_pick_list within u_tabpage_context_documents_outgoing
integer width = 2976
integer height = 264
integer taborder = 10
string dataobject = "dw_jmj_get_documents"
boolean vscrollbar = true
boolean multiselect = true
boolean select_computed = false
boolean multiselect_ctrl = true
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
		if lower(service.item_type) <> "document" then
			document_mode = false
		end if
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
			sle_subject.setfocus()
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

