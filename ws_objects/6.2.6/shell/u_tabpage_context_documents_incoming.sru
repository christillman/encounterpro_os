HA$PBExportHeader$u_tabpage_context_documents_incoming.sru
forward
global type u_tabpage_context_documents_incoming from u_tabpage_incoming_documents_base
end type
type cb_test from commandbutton within u_tabpage_context_documents_incoming
end type
end forward

global type u_tabpage_context_documents_incoming from u_tabpage_incoming_documents_base
cb_test cb_test
end type
global u_tabpage_context_documents_incoming u_tabpage_context_documents_incoming

type variables

string view_context_object
string view_cpr_id
long view_object_key

u_component_service service

end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize ();
super::initialize()

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

attachments = CREATE u_ds_attachments
attachments.dataobject = "dw_fn_incoming_documents_for_context"
attachments.settransobject(sqlca)


setnull(list_folder)
interfaceserviceid = 0
picturename = ""
default_list = true

return 1

end function

public subroutine refresh ();long ll_rows

attachments.setfilter("")
ll_rows = attachments.retrieve(view_context_object, view_cpr_id, view_object_key)
if ll_rows < 0 then return

cb_test.visible = current_patient.test_patient

super::refresh()

end subroutine

on u_tabpage_context_documents_incoming.create
int iCurrent
call super::create
this.cb_test=create cb_test
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_test
end on

on u_tabpage_context_documents_incoming.destroy
call super::destroy
destroy(this.cb_test)
end on

event resize_tabpage;call super::resize_tabpage;
dw_holding_list.y = 12

cb_test.height = 84
cb_test.width = 677

cb_test.x = dw_holding_list.x + ((dw_holding_list.width - cb_test.width) / 2) - 40
cb_test.y = dw_holding_list.y + dw_holding_list.height + 4

end event

type st_attachment_details from u_tabpage_incoming_documents_base`st_attachment_details within u_tabpage_context_documents_incoming
end type

type cb_clear_all from u_tabpage_incoming_documents_base`cb_clear_all within u_tabpage_context_documents_incoming
boolean visible = false
end type

type cb_select_all from u_tabpage_incoming_documents_base`cb_select_all within u_tabpage_context_documents_incoming
boolean visible = false
end type

type cb_sort from u_tabpage_incoming_documents_base`cb_sort within u_tabpage_context_documents_incoming
boolean visible = false
end type

type dw_holding_list from u_tabpage_incoming_documents_base`dw_holding_list within u_tabpage_context_documents_incoming
integer height = 1352
end type

type uo_picture from u_tabpage_incoming_documents_base`uo_picture within u_tabpage_context_documents_incoming
end type

type cb_test from commandbutton within u_tabpage_context_documents_incoming
integer x = 274
integer y = 1452
integer width = 677
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generate Test Results"
end type

event clicked;str_popup popup
str_popup_return popup_return
str_pick_config_object lstr_pick_config_object
w_window_base lw_pick
string ls_interface_description
string ls_document_description
string ls_config_object_id
str_service_info lstr_service
string ls_purpose
long ll_interfaceserviceid

openwithparm(w_pop_yes_no, "This action will send test results to EpIE for downloading and posting into this treatment.  Are you sure you want to do this?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

// Pick which interface we're testing
popup.title = "Select Interface"
popup.dataobject = "dw_fn_practice_interfaces_pick"
popup.datacolumn = 2
popup.displaycolumn = 7
popup.argument_count = 0
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_interface_description = popup_return.descriptions[1]
ll_interfaceserviceid = long(popup_return.items[1])

// Get a document datafile definition for the selected interface
lstr_pick_config_object.owner_filter = ll_interfaceserviceid
lstr_pick_config_object.config_object_type = "Datafile"
lstr_pick_config_object.context_object = view_context_object

openwithparm(lw_pick, lstr_pick_config_object, "w_pick_config_object")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_config_object_id = popup_return.items[1]
ls_document_description = popup_return.descriptions[1]

// Get the document purpose
popup.argument_count = 2
popup.argument[1] = view_context_object
popup.argument[2] = "Practice"
popup.dataobject = "dw_purpose_for_actor_class_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.title = "Select Document Purpose"
popup.auto_singleton = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_purpose = popup_return.items[1]

// Send the document to ourselves (i.e. the local EncounterPRO Practice)
lstr_service.service = "Order Document"
f_attribute_add_attribute(lstr_service.attributes, "report_id", ls_config_object_id)
f_attribute_add_attribute(lstr_service.attributes, "send_now", "Yes")
f_attribute_add_attribute(lstr_service.attributes, "document_description", "Test: " + ls_document_description + " from " + ls_interface_description)
f_attribute_add_attribute(lstr_service.attributes, "purpose", ls_purpose)
f_attribute_add_attribute(lstr_service.attributes, "interfaceserviceid", string(ll_interfaceserviceid))
f_attribute_add_attribute(lstr_service.attributes, "dispatch_method", "EproLink")
f_attribute_add_attribute(lstr_service.attributes, "ordered_for", common_thread.practice_user_id)
f_attribute_add_attribute(lstr_service.attributes, "context_object", view_context_object)

service_list.do_service(lstr_service)

if isnull(service.service_window) then
	parent_tab.refresh()
else
	service.service_window.refresh()
end if

end event

