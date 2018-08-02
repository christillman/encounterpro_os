$PBExportHeader$u_component_route_fax.sru
forward
global type u_component_route_fax from u_component_route
end type
end forward

global type u_component_route_fax from u_component_route
end type
global u_component_route_fax u_component_route_fax

type variables
u_file_action file_action

end variables

forward prototypes
protected function integer xx_send_document (u_component_wp_item_document puo_document)
end prototypes

protected function integer xx_send_document (u_component_wp_item_document puo_document);string ls_printer
boolean lb_cover_letter
integer li_wait
string ls_temp
integer li_sts
str_external_observation_attachment lstr_document

li_sts = puo_document.get_document(lstr_document)
if li_sts <= 0 then
	log.log(this, "u_component_route_fax.xx_send_document.0010", "Error getting document (" + string(puo_document.patient_workplan_item_id) + ")", 4)
	return -1
end if

li_wait = f_please_wait_open()

ls_printer = common_thread.select_fax_client()
if len(ls_printer) > 0 then
	common_thread.set_printer(ls_printer)
else
	f_please_wait_close(li_wait)
	return 0
end if
	
// We need to use the attachment component to perform the printing because it may have proprietary logic specific to the document type
li_sts = file_action.print_file(lstr_document, ls_printer)
if li_sts <= 0 then
	log.log(this, "u_component_route_fax.xx_send_document.0010", "Error printing document" + string(puo_document.patient_workplan_item_id) + ")", 4)
	f_please_wait_close(li_wait)
	return -1
end if

// Set the printer back to the default
if len(ls_printer) > 0 then
	common_thread.set_default_printer()
end if

f_please_wait_close(li_wait)

return 1

end function

on u_component_route_fax.create
call super::create
end on

on u_component_route_fax.destroy
call super::destroy
end on

