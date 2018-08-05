$PBExportHeader$w_svc_documents.srw
forward
global type w_svc_documents from w_window_base
end type
type cb_finished from commandbutton within w_svc_documents
end type
type st_object_description from statictext within w_svc_documents
end type
type cb_refresh from commandbutton within w_svc_documents
end type
type st_title from statictext within w_svc_documents
end type
type st_subject_title from statictext within w_svc_documents
end type
type sle_subject from singlelineedit within w_svc_documents
end type
type st_message_title from statictext within w_svc_documents
end type
type mle_message from multilineedit within w_svc_documents
end type
type st_patient_title from statictext within w_svc_documents
end type
type st_patient from statictext within w_svc_documents
end type
type cb_subject from commandbutton within w_svc_documents
end type
type cb_body from commandbutton within w_svc_documents
end type
type st_item_title from statictext within w_svc_documents
end type
type st_item from statictext within w_svc_documents
end type
type dw_documents from u_dw_pick_list within w_svc_documents
end type
type cbx_include_cover_page from checkbox within w_svc_documents
end type
type cb_be_back from commandbutton within w_svc_documents
end type
type cbx_display_cancelled from checkbox within w_svc_documents
end type
type cbx_display_completed from checkbox within w_svc_documents
end type
type cb_send_and_exit from commandbutton within w_svc_documents
end type
type cb_print_send_all from commandbutton within w_svc_documents
end type
end forward

global type w_svc_documents from w_window_base
integer height = 1864
boolean controlmenu = false
windowtype windowtype = response!
boolean clientedge = true
string button_type = "COMMAND"
integer max_buttons = 3
cb_finished cb_finished
st_object_description st_object_description
cb_refresh cb_refresh
st_title st_title
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
dw_documents dw_documents
cbx_include_cover_page cbx_include_cover_page
cb_be_back cb_be_back
cbx_display_cancelled cbx_display_cancelled
cbx_display_completed cbx_display_completed
cb_send_and_exit cb_send_and_exit
cb_print_send_all cb_print_send_all
end type
global w_svc_documents w_svc_documents

type variables
u_component_workplan_item service

string patient_subdir

string view_context_object
long view_object_key

long context_object_mode_height
long single_document_mode_height = 254

string top_20_prefix

boolean document_mode
u_component_wp_item_document document

boolean cover_page_changed
boolean original_cover_page

u_ds_data status_refresh_documents
end variables

forward prototypes
public subroutine cancel_documents ()
public subroutine send_documents ()
public subroutine confirm_documents ()
public function integer refresh ()
public subroutine sign_documents ()
public subroutine create_documents (long pl_row)
public subroutine other_menu (long pl_row, u_component_wp_item_document puo_document)
public function integer refresh_status ()
public function integer pick_address_old (long pl_row, string ps_ordered_for, string ps_document_route, ref str_actor_communication pstr_actor_communication)
public subroutine change_documents_old ()
public function string pick_dispatch_method_old (long pl_row, string ps_ordered_for)
public function string pick_document_route_old (long pl_row, string ps_ordered_for)
public function string pick_ordered_for_old (long pl_row)
public subroutine show_routes_old (long pl_row, string ps_ordered_for, string ps_report_id, string ps_message)
end prototypes

public subroutine cancel_documents ();long ll_patient_workplan_item_id
long ll_row
u_component_wp_item_document luo_document

ll_row = 0

luo_document = CREATE u_component_wp_item_document

DO WHILE true
	ll_row = dw_documents.get_selected_row(ll_row)
	if ll_row <= 0 then exit
	
	ll_patient_workplan_item_id = dw_documents.object.patient_workplan_item_id[ll_row]
	
	luo_document.initialize(ll_patient_workplan_item_id)
	luo_document.document_cancel()
LOOP

DESTROY luo_document

refresh()

end subroutine

public subroutine send_documents ();long ll_patient_workplan_item_id
long ll_row
u_component_wp_item_document luo_document

ll_row = 0

luo_document = CREATE u_component_wp_item_document

DO WHILE true
	ll_row = dw_documents.get_selected_row(ll_row)
	if ll_row <= 0 then exit
	
	ll_patient_workplan_item_id = dw_documents.object.patient_workplan_item_id[ll_row]
	
	luo_document.initialize(ll_patient_workplan_item_id)
	luo_document.document_send()
LOOP

DESTROY luo_document

refresh()

end subroutine

public subroutine confirm_documents ();long ll_patient_workplan_item_id
long ll_row
u_component_wp_item_document luo_document

ll_row = 0

luo_document = CREATE u_component_wp_item_document

DO WHILE true
	ll_row = dw_documents.get_selected_row(ll_row)
	if ll_row <= 0 then exit
	
	ll_patient_workplan_item_id = dw_documents.object.patient_workplan_item_id[ll_row]
	
	luo_document.initialize(ll_patient_workplan_item_id)
	luo_document.document_confirm_receipt()
LOOP

DESTROY luo_document

refresh()

end subroutine

public function integer refresh ();u_component_wp_item_document luo_document
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

if document_mode then
	// Single document mode
	dw_documents.setfilter("")
	ll_rows = dw_documents.retrieve("Document", service.cpr_id, document.patient_workplan_item_id)
	if ll_rows < 0 then return -1
	if ll_rows = 0 then return 0

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
	
	if lower(service.item_type) = "document" then
		cb_finished.text = "Close"
	else
		cb_finished.text = "OK"
	end if
	
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
	
	if lower(ls_dispatch_method) = "printer" then
		cb_send_and_exit.text = "Print and Close"
	else
		cb_send_and_exit.text = "Send and Close"
	end if
	
	if lower(document.status) = "ordered" then
		sle_subject.enabled = true
		mle_message.enabled = true
		cb_send_and_exit.visible = true
	else
		sle_subject.enabled = false
		mle_message.enabled = false
		cb_send_and_exit.visible = false
	end if
	
	cover_page_changed = false
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
	if ll_rows < 0 then return -1
	
	dw_documents.height = context_object_mode_height
	dw_documents.border = true
	dw_documents.vscrollbar = true
	
	ll_new_lastrow = long(dw_documents.object.datawindow.lastrowonpage)
	
	if ll_lastrow > ll_new_lastrow then
		dw_documents.scroll_to_row(ll_lastrow)
	end if

	dw_documents.setredraw(true)

	cb_send_and_exit.visible = false
	
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

	cb_finished.text = "Close"
	
	if ll_rows = 0 then return 0
end if

return 1

end function

public subroutine sign_documents ();long ll_patient_workplan_item_id
long ll_row
u_component_wp_item_document luo_document

ll_row = 0

luo_document = CREATE u_component_wp_item_document

DO WHILE true
	ll_row = dw_documents.get_selected_row(ll_row)
	if ll_row <= 0 then exit
	
	ll_patient_workplan_item_id = dw_documents.object.patient_workplan_item_id[ll_row]
	
	luo_document.initialize(ll_patient_workplan_item_id)
	luo_document.document_sign()
LOOP

DESTROY luo_document

refresh()

end subroutine

public subroutine create_documents (long pl_row);long ll_patient_workplan_item_id
long ll_row
u_component_wp_item_document luo_document
str_popup_return popup_return

ll_row = 0

luo_document = CREATE u_component_wp_item_document

DO WHILE true
	if pl_row > 0 then
		if ll_row > 0 then exit
		ll_row = pl_row
	else
		ll_row = dw_documents.get_selected_row(ll_row)
	end if
	if ll_row <= 0 then exit
	
	ll_patient_workplan_item_id = dw_documents.object.patient_workplan_item_id[ll_row]
	
	luo_document.initialize(ll_patient_workplan_item_id)
	
	CHOOSE CASE lower(luo_document.status)
		CASE "ordered"
			luo_document.document_create()
		CASE "created"
			luo_document.document_create()
		CASE "sent"
			openwithparm(w_pop_yes_no, "This document has already been sent.  It is not reccomended that you re-create the document unless you intend to re-send it.  Are you sure you wish to recreate this document?")
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then continue
			
			luo_document.document_create()
		CASE "completed"
			openwithparm(w_pop_message, "This document has already been completed and my not be re-created")
			continue
		CASE "cancelled"
			openwithparm(w_pop_message, "This document has cancelled and my not be re-created")
			continue
	END CHOOSE
	
LOOP

DESTROY luo_document

refresh()

end subroutine

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
		sqlca.sp_add_workplan_item_attribute(service.cpr_id, ll_null, ll_patient_workplan_item_id, "purpose", ls_purpose, current_scribe.user_id, current_user.user_id)
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
	ll_rows = status_refresh_documents.retrieve("Document", service.cpr_id, document.patient_workplan_item_id)
	if ll_rows < 0 then return -1
	if ll_rows = 0 then return 0
else
	// Context Object mode
	ll_rows = status_refresh_documents.retrieve(view_context_object, service.cpr_id, view_object_key)
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

return 1

end function

public function integer pick_address_old (long pl_row, string ps_ordered_for, string ps_document_route, ref str_actor_communication pstr_actor_communication);str_pick_users lstr_pick_users
integer li_sts
long ll_patient_workplan_item_id
string ls_report_id
str_popup popup
str_popup_return popup_return
string ls_null
string ls_communication_type
string ls_printer
string ls_room_id
long ll_response
string ls_actor_class
string ls_document_type
string ls_sender_component_id
string ls_send_from

setnull(ls_null)

ls_document_type = dw_documents.object.document_type[pl_row]
ls_report_id = dw_documents.object.report_id[pl_row]

ls_actor_class = user_list.user_property(ps_ordered_for, "actor_class")

// Get information about this route
SELECT communication_type, sender_component_id, send_from
INTO :ls_communication_type, :ls_sender_component_id, :ls_send_from
FROM dbo.fn_document_route_information(:ps_document_route);
if not tf_check() then return -1
if sqlca.sqlnrows <> 1 then
	log.log(this, "w_svc_documents.pick_address_old:0030", "Invalid document_route (" + ps_document_route + ")", 4)
	return -1
end if

// If the ls_communication_type is null and the document_route = "Printer" then prompt the user for a printer
if isnull(ls_communication_type) then
	if lower(ps_document_route) = "printer" then
		// pick a printer

		CHOOSE CASE lower(ls_document_type)
			CASE "report"
				// First get the default printer for this report
				if isnull(current_patient) or isnull(service.encounter_id) then
					setnull(ls_room_id)
				else
					// If we have both a patient context and an encounter context, then see where the patient is now
					ls_room_id = current_patient.encounters.get_property_value(service.encounter_id, "patient_location")
				end if
				
				ls_printer = f_get_default_printer(ls_report_id, office_id, computer_id, ls_room_id)
				
				if len(ls_printer) > 0 then
					popup.data_row_count = 2
					popup.items[1] = "Use Configured Printer"
					popup.items[2] = "Select Printer"
					popup.title = "The associated report is configured to use the ~"" + ls_printer + "~" printer.  Do you wish to..."
					openwithparm(w_pop_choices_2, popup)
					ll_response = message.doubleparm
					if ll_response = 2 then setnull(ls_printer)
				end if
				
				if isnull(ls_printer) or trim(ls_printer) = "" then
					ls_printer = common_thread.select_printer_server()
					if isnull(ls_printer) then return 0
				end if
			CASE "material"
				ls_printer = common_thread.select_printer()
				if isnull(ls_printer) then return 0
			CASE ELSE
				return 0
		END CHOOSE
		
		// We have a printer
		setnull(pstr_actor_communication.actor_id)
		setnull(pstr_actor_communication.communication_sequence)
		pstr_actor_communication.communication_type = "Printer"
		pstr_actor_communication.communication_value = ls_printer
		return 1
	else
		// No address required or available for this document_route
		setnull(pstr_actor_communication.actor_id)
		setnull(pstr_actor_communication.communication_sequence)
		setnull(pstr_actor_communication.communication_type)
		setnull(pstr_actor_communication.communication_value)
		return 1
	end if
end if

// If we have a communication_type then we need to let the user pick the commnication address
if not isnull(ls_communication_type) then
	// The patient communication addresses are stored differently from the actor communication addresses, so
	// present the list to the user based on the actor class
	if lower(ls_actor_class) = "patient" then
		// If the actor is a patient then offer choices from the patient Communication entries in p_Patient_Progress
		popup.dataobject = "dw_patient_progress_pick"
		popup.data_row_count = 0
		popup.title = "Select " + wordcap(ls_communication_type)
		popup.datacolumn = 12
		popup.displaycolumn = 12
		popup.argument_count = 2
		popup.argument[1] = service.cpr_id
		popup.argument[2] = "Communication " + ls_communication_type
		popup.auto_singleton = true
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count = 1 then
			setnull(pstr_actor_communication.actor_id)
			setnull(pstr_actor_communication.communication_sequence)
			pstr_actor_communication.communication_type = ls_communication_type
			pstr_actor_communication.communication_value = popup_return.items[1]
			return 1
		else
			if popup_return.choices_count = 0 then
				// There weren't any choices
				openwithparm(w_pop_message, "This patient does not have any " + ls_communication_type + " addresses.")
			end if
			return 0
		end if
	else
		// If the actor is not a patient then offer choices from the c_actor_communication table
		li_sts = f_pick_actor_communication(ps_ordered_for, ls_communication_type, pstr_actor_communication)
		if li_sts <= 0 then return li_sts
		
		return 1
	end if
end if



return 0



end function

public subroutine change_documents_old ();//long ll_row
//string ls_ordered_for
//string ls_dispatch_method
//integer li_sts
//str_actor_communication lstr_actor_communication
//string ls_communication_type
//string ls_via_address
//str_popup popup
//str_popup_return popup_return
//long ll_patient_workplan_item_id
//
//// Get the selections for all selected documents using the first selected document as an exemplar
//ll_row = dw_documents.get_selected_row(ll_row)
//if ll_row <= 0 then return
//
//ls_ordered_for = pick_ordered_for(ll_row)
//if isnull(ls_ordered_for) then return
//ls_dispatch_method = pick_dispatch_method(ll_row, ls_ordered_for)
//if isnull(ls_dispatch_method) then return
//li_sts = pick_address(ll_row, ls_ordered_for, ls_dispatch_method, lstr_actor_communication)
//if li_sts <= 0 then return
//
//ls_communication_type = lstr_actor_communication.communication_type
//ls_via_address = lstr_actor_communication.communication_value
//
//
//// Now loop through all the selected documents and set them the to the picked values
//ll_row = 0
//DO WHILE true
//	ll_row = dw_documents.get_selected_row(ll_row)
//	if ll_row <= 0 then exit
//	
//	ll_patient_workplan_item_id = dw_documents.object.patient_workplan_item_id[ll_row]
//
//	li_sts = sqlca.jmj_document_set_recipient(ll_patient_workplan_item_id, ls_ordered_for, ls_dispatch_method, ls_communication_type, ls_via_address, current_user.user_id, current_scribe.user_id)
//	if not tf_check() then return
//
//LOOP
//
//refresh()
//
end subroutine

public function string pick_dispatch_method_old (long pl_row, string ps_ordered_for);//str_document_send lstr_document_send
string ls_document_route
//u_ds_data luo_data
//long ll_patient_workplan_item_id
//long ll_count
//string ls_null
//long i
//string ls_document_description
//str_document_send_error_status lstr_document_send_error_status
//
//setnull(ls_null)
//
//ll_patient_workplan_item_id = dw_documents.object.patient_workplan_item_id[pl_row]
//ls_document_description = dw_documents.object.description[pl_row]
//
//ls_document_route = pick_document_route(pl_row, ps_ordered_for)
//if isnull(ls_document_route) then return ls_null
//
//// See if there are any errors with sending this document to this recipient via this route
//lstr_document_send.patient_workplan_item_id = ll_patient_workplan_item_id
//lstr_document_send.ordered_for = ps_ordered_for
//lstr_document_send.document_route = ls_document_route
//lstr_document_send.document_description = ls_document_description
//openwithparm(w_display_route_errors, lstr_document_send)
//lstr_document_send_error_status = message.powerobjectparm
//if lstr_document_send_error_status.error_count > 0 &
//  and lstr_document_send_error_status.max_severity > 1 &
//  and not lstr_document_send_error_status.send_anyways then
//	return ls_null
//end if
//
//
//// The dispatch_method is the same as the document_route, so just return the selected document_route
return ls_document_route
//
end function

public function string pick_document_route_old (long pl_row, string ps_ordered_for);//str_popup popup
//str_popup_return popup_return
//string ls_document_route
string ls_null
//string ls_report_id
//string ls_ordered_by
//u_ds_data luo_data
//long ll_count
//string ls_communication_type
//string ls_message
//long i
//string ls_document_type
//string ls_purpose
//
setnull(ls_null)
//
//ls_document_type = dw_documents.object.document_type[pl_row]
//CHOOSE CASE lower(ls_document_type)
//	CASE "report"
//		ls_report_id = dw_documents.object.report_id[pl_row]
//		ls_ordered_by = dw_documents.object.ordered_by[pl_row]
//		ls_purpose = dw_documents.object.purpose[pl_row]
//		
//		popup.dataobject = "dw_document_valid_routes_pick"
//		popup.datacolumn = 1
//		popup.displaycolumn = 1
//		popup.auto_singleton = true
//		popup.argument_count = 5
//		popup.argument[1] = ls_ordered_by
//		popup.argument[2] = ps_ordered_for
//		popup.argument[3] = ls_purpose
//		popup.argument[4] = service.cpr_id
//		popup.argument[5] = ls_report_id
//		openwithparm(w_pop_pick, popup)
//		popup_return = message.powerobjectparm
//		if popup_return.item_count = 1 then
//			ls_document_route = popup_return.items[1]
//			return ls_document_route
//		end if
//		
//		if popup_return.choices_count > 0 then return ls_null
//		
//		// Show the available routes and reasons for not being valid
//		show_routes(pl_row, ps_ordered_for, ls_report_id, "No valid Routes")
//		return ls_null
//		
//	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	// This is the start of some code to offer the user more choices at the point they find out that there are no valid routes
//	//
//	// It's not finished
//	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	
//		if ll_count = 1 then
//			ls_communication_type = luo_data.object.communication_type[1]
//			ls_message = "The selected recipient does not have a " + ls_communication_type + " number.  Would you like to enter one?"
//		else
//			ls_communication_type = ""
//			for i = 1 to ll_count
//				if len(ls_communication_type) > 0 then ls_communication_type += ", "
//				ls_communication_type += luo_data.object.communication_type[i]
//			next
//			ls_message = "The selected recipient does not have any of the following numbers:  " + ls_communication_type + ".  Would you like to enter one?"
//		end if
//	
//		openwithparm(w_pop_yes_no, ls_message)
//		popup_return = message.powerobjectparm
//		if popup_return.item <> "YES" then return ls_null
//		
//		popup.dataobject = "dw_document_available_routes_pick"
//		popup.datacolumn = 1
//		popup.displaycolumn = 1
//		popup.auto_singleton = true
//		popup.argument_count = 5
//		popup.argument[1] = ls_ordered_by
//		popup.argument[2] = ps_ordered_for
//		popup.argument[3] = ls_purpose
//		popup.argument[4] = service.cpr_id
//		popup.argument[5] = ls_report_id
//		openwithparm(w_pop_pick, popup)
//		popup_return = message.powerobjectparm
//		if popup_return.item_count <> 1 then return ls_null
//		
//	// title					Screen title/user instructions
//	// item					Default string value
//	//	data_row_count		Number of items in the canned selections list
//	// items[]				list of canned selections
//	// argument_count		Number of top_20 arguments supplied
//	// argument[]			List of top_20 arguments
//	//							argument[1] = specific top_20_code
//	//							argument[2] = generic top_20_code
//	// multiselect			True = Allow empty string
//	//							False = Don't allow empty string
//		popup.argument_count = 0
//		popup.item = ""
//		popup.data_row_count = 0
//		popup.multiselect = false
//		popup.displaycolumn = 80 // max length
//		CHOOSE CASE lower(popup_return.items[1])
//			CASE "phone", "fax"
//				popup.title = "Enter " + popup_return.items[1] + " number for " + user_list.user_full_name(ps_ordered_for)
//			CASE ELSE
//				popup.title = "Enter " + popup_return.items[1] + " address for " + user_list.user_full_name(ps_ordered_for)
//		END CHOOSE
//		openwithparm(w_pop_prompt_string, popup)
//		popup_return = message.powerobjectparm
//		if popup_return.item_count <> 1 then return ls_null
//		
//	CASE "material"
//		popup.dataobject = "dw_jmj_get_actor_document_routes"
//		popup.datacolumn = 1
//		popup.displaycolumn = 1
//		popup.auto_singleton = true
//		popup.argument_count = 2
//		popup.argument[1] = ls_ordered_by
//		popup.argument[2] = ps_ordered_for
//		openwithparm(w_pop_pick, popup)
//		popup_return = message.powerobjectparm
//		if popup_return.item_count = 1 then
//			ls_document_route = popup_return.items[1]
//			return ls_document_route
//		end if
//
//		// If there were choices then the user clicked "Cancel"
//		if popup_return.choices_count > 0 then return ls_null
//
//		show_routes(pl_row, ps_ordered_for, ls_report_id, "No Valid Routes")
//		return ls_null
//
//END CHOOSE
//
return ls_null
//
//
//
end function

public function string pick_ordered_for_old (long pl_row);//str_pick_users lstr_pick_users
//integer li_sts
//long ll_patient_workplan_item_id
//str_popup popup
//str_popup_return popup_return
//string ls_actor_class
//string ls_document_route
string ls_user_id
//string ls_null
//string ls_document_type
//string ls_purpose
//string ls_context_object
//long ll_null
//
//setnull(ls_null)
//setnull(ll_null)
//
//ls_document_type = dw_documents.object.document_type[pl_row]
//ls_purpose = dw_documents.object.purpose[pl_row]
//ls_context_object = dw_documents.object.document_context_object[pl_row]
//ll_patient_workplan_item_id = dw_documents.object.patient_workplan_item_id[pl_row]
//
//if isnull(ls_purpose) then
//	popup.argument_count = 1
//	popup.argument[1] = ls_context_object
//	popup.dataobject = "dw_c_document_purpose_pick_list"
//	popup.datacolumn = 1
//	popup.displaycolumn = 2
//	popup.title = "Select Document Purpose"
//	openwithparm(w_pop_pick, popup)
//	popup_return = message.powerobjectparm
//	if popup_return.item_count <> 1 then return ls_null
//	
//	ls_purpose = popup_return.items[1]
//	sqlca.sp_add_workplan_item_attribute(service.cpr_id, ll_null, ll_patient_workplan_item_id, "purpose", ls_purpose, current_scribe.user_id, current_user.user_id)
//	if not tf_check() then return ls_null
//	
//	dw_documents.object.purpose[pl_row] = ls_purpose
//end if
//
//popup.dataobject = "dw_actor_class_for_purpose"
//popup.datacolumn = 1
//popup.displaycolumn = 1
//popup.auto_singleton = true
//popup.argument_count = 1
//popup.argument[1] = ls_purpose
//popup.title = "Select Recipient Class"
//openwithparm(w_pop_pick, popup)
//popup_return = message.powerobjectparm
//if popup_return.item_count <> 1 then
//	// If there were any choices then the user clicked "Cancel"
//	if popup_return.choices_count > 0 then return ls_null
//	
//	// If there were no choices, then have the user pick between user and patient
//	popup.dataobject = ""
//	popup.datacolumn = 0
//	popup.displaycolumn = 0
//	popup.auto_singleton = false
//	popup.argument_count = 0
//	popup.title = "Select Recipient Class"
//	popup.data_row_count = 2
//	popup.items[1] = "User"
//	popup.items[2] = "Patient"
//	openwithparm(w_pop_pick, popup)
//	popup_return = message.powerobjectparm
//	if popup_return.item_count <> 1 then return ls_null
//end if
//ls_actor_class = popup_return.items[1]
//
//
//if lower(ls_actor_class)  = "patient" then
//	ls_user_id = "#PATIENT"
//else
//	lstr_pick_users.cpr_id = service.cpr_id
//	lstr_pick_users.hide_users = true
//	lstr_pick_users.actor_class = ls_actor_class
//	lstr_pick_users.pick_screen_title = "Select " + wordcap(ls_actor_class)
//	li_sts = user_list.pick_users(lstr_pick_users)
//	if li_sts <= 0 then return ls_null
//	
//	ls_user_id = lstr_pick_users.selected_users.user[1].user_id
//end if
//
return ls_user_id
//
//
end function

public subroutine show_routes_old (long pl_row, string ps_ordered_for, string ps_report_id, string ps_message);str_popup popup


popup.data_row_count = 5
popup.title = ps_message
popup.items[1] = dw_documents.object.ordered_by[pl_row]
popup.items[2] = ps_ordered_for
popup.items[3] = dw_documents.object.purpose[pl_row]
popup.items[4] = service.cpr_id
popup.items[5] = ps_report_id
openwithparm(w_pop_document_routes, popup)



end subroutine

event open;call super::open;long ll_menu_id
long ll_rows
str_popup_return popup_return
string ls_null
long i
long ll_count
long ll_row
string ls_temp
string lsa_patient_reports[]
string ls_patient
string ls_subdir
long ll_width
setnull(ls_null)

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

// Set the view context
view_context_object = service.context_object
view_object_key = service.object_key

sle_subject.text = ""
mle_message.text = ""

// Set the title and sizes
title = current_patient.id_line()

st_title.text = wordcap(service.context_object) + " Documents"

st_object_description.text = sqlca.fn_patient_object_description(current_patient.cpr_id, &
																						service.context_object, &
																						service.object_key)

if len(st_title.text) > 42 then
	if len(st_title.text) > 60 then
		if len(st_title.text) > 70 then
			st_title.textsize = -10
		else
			st_title.textsize = -12
		end if
	else
		st_title.textsize = -14
	end if
else
	st_title.textsize = -18
end if


// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
end if


// Create a hidden datastore for refreshing the status of the on-screen documents
status_refresh_documents = CREATE u_ds_data
status_refresh_documents.set_dataobject("dw_jmj_get_documents")

dw_documents.settransobject(sqlca)

// Since half of the extension beyond 700 pb-units will be added to the recipient and route fields, subtract off
// half of the extension past 700
ll_width = 700 + ((dw_documents.width - 2950) / 2)
dw_documents.object.description.width = ll_width

context_object_mode_height = mle_message.y + mle_message.height - dw_documents.y

if lower(service.item_type) = "document" then
	document = service
	document_mode = true
else
	// Create an empty document object and set document_mode to false
	document_mode = false
end if

cbx_display_cancelled.height = 80
cbx_display_completed.height = 80
cbx_display_completed.y = cbx_display_cancelled.y - 72

refresh()

timer(2)

end event

on w_svc_documents.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.st_object_description=create st_object_description
this.cb_refresh=create cb_refresh
this.st_title=create st_title
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
this.dw_documents=create dw_documents
this.cbx_include_cover_page=create cbx_include_cover_page
this.cb_be_back=create cb_be_back
this.cbx_display_cancelled=create cbx_display_cancelled
this.cbx_display_completed=create cbx_display_completed
this.cb_send_and_exit=create cb_send_and_exit
this.cb_print_send_all=create cb_print_send_all
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.st_object_description
this.Control[iCurrent+3]=this.cb_refresh
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.st_subject_title
this.Control[iCurrent+6]=this.sle_subject
this.Control[iCurrent+7]=this.st_message_title
this.Control[iCurrent+8]=this.mle_message
this.Control[iCurrent+9]=this.st_patient_title
this.Control[iCurrent+10]=this.st_patient
this.Control[iCurrent+11]=this.cb_subject
this.Control[iCurrent+12]=this.cb_body
this.Control[iCurrent+13]=this.st_item_title
this.Control[iCurrent+14]=this.st_item
this.Control[iCurrent+15]=this.dw_documents
this.Control[iCurrent+16]=this.cbx_include_cover_page
this.Control[iCurrent+17]=this.cb_be_back
this.Control[iCurrent+18]=this.cbx_display_cancelled
this.Control[iCurrent+19]=this.cbx_display_completed
this.Control[iCurrent+20]=this.cb_send_and_exit
this.Control[iCurrent+21]=this.cb_print_send_all
end on

on w_svc_documents.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.st_object_description)
destroy(this.cb_refresh)
destroy(this.st_title)
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
destroy(this.dw_documents)
destroy(this.cbx_include_cover_page)
destroy(this.cb_be_back)
destroy(this.cbx_display_cancelled)
destroy(this.cbx_display_completed)
destroy(this.cb_send_and_exit)
destroy(this.cb_print_send_all)
end on

event close;DESTROY document

end event

event timer;call super::timer;refresh_status()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_documents
integer x = 2802
integer y = 0
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_documents
end type

type cb_finished from commandbutton within w_svc_documents
integer x = 2395
integer y = 1616
integer width = 443
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts
string ls_path

if lower(service.item_type) <> "document" and document_mode then
	if isvalid(document) and not isnull(document) then DESTROY document
	document_mode = false
	refresh()
	return
end if

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type st_object_description from statictext within w_svc_documents
integer y = 136
integer width = 2894
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Encounter description"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_refresh from commandbutton within w_svc_documents
integer x = 41
integer y = 1616
integer width = 443
integer height = 108
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

type st_title from statictext within w_svc_documents
integer width = 2898
integer height = 132
boolean bringtotop = true
integer textsize = -22
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Encounter Documents"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_subject_title from statictext within w_svc_documents
integer x = 59
integer y = 788
integer width = 343
integer height = 76
boolean bringtotop = true
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

type sle_subject from singlelineedit within w_svc_documents
integer x = 430
integer y = 780
integer width = 2194
integer height = 92
integer taborder = 10
boolean bringtotop = true
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

type st_message_title from statictext within w_svc_documents
integer x = 59
integer y = 936
integer width = 343
integer height = 76
boolean bringtotop = true
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

type mle_message from multilineedit within w_svc_documents
integer x = 430
integer y = 908
integer width = 2194
integer height = 656
integer taborder = 20
boolean bringtotop = true
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

type st_patient_title from statictext within w_svc_documents
integer x = 59
integer y = 536
integer width = 343
integer height = 76
boolean bringtotop = true
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

type st_patient from statictext within w_svc_documents
integer x = 430
integer y = 528
integer width = 1280
integer height = 88
boolean bringtotop = true
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

type cb_subject from commandbutton within w_svc_documents
integer x = 2638
integer y = 776
integer width = 128
integer height = 100
boolean bringtotop = true
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

type cb_body from commandbutton within w_svc_documents
integer x = 2638
integer y = 1464
integer width = 128
integer height = 100
boolean bringtotop = true
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

type st_item_title from statictext within w_svc_documents
integer x = 59
integer y = 664
integer width = 343
integer height = 76
boolean bringtotop = true
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

type st_item from statictext within w_svc_documents
integer x = 430
integer y = 656
integer width = 2194
integer height = 88
boolean bringtotop = true
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

type dw_documents from u_dw_pick_list within w_svc_documents
integer x = 59
integer y = 224
integer width = 2779
integer height = 264
integer taborder = 0
boolean bringtotop = true
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

type cbx_include_cover_page from checkbox within w_svc_documents
integer x = 1815
integer y = 532
integer width = 841
integer height = 80
boolean bringtotop = true
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

type cb_be_back from commandbutton within w_svc_documents
integer x = 1893
integer y = 1616
integer width = 443
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cbx_display_cancelled from checkbox within w_svc_documents
integer x = 498
integer y = 1660
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

type cbx_display_completed from checkbox within w_svc_documents
integer x = 498
integer y = 1588
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

type cb_send_and_exit from commandbutton within w_svc_documents
integer x = 1175
integer y = 1616
integer width = 553
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Send and Close"
end type

event clicked;str_popup_return popup_return
integer li_sts
string ls_path

if not isvalid(document) or isnull(document) then return

li_sts = document.document_send()
if li_sts < 0 then
	openwithparm(w_pop_message, "Error sending docucument")
	return
end if

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_print_send_all from commandbutton within w_svc_documents
integer x = 1175
integer y = 1616
integer width = 553
integer height = 108
integer taborder = 40
boolean bringtotop = true
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

