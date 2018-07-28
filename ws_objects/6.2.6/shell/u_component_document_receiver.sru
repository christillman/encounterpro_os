HA$PBExportHeader$u_component_document_receiver.sru
forward
global type u_component_document_receiver from u_component_base_class
end type
end forward

global type u_component_document_receiver from u_component_base_class
end type
global u_component_document_receiver u_component_document_receiver

type variables
long interfaceserviceid
long transportsequence
long patient_workplan_item_id

end variables

forward prototypes
public function long new_document (ref str_external_observation_attachment pstr_new_document)
protected function long xx_get_documents ()
public function integer get_documents (long pl_patient_workplan_item_id)
end prototypes

public function long new_document (ref str_external_observation_attachment pstr_new_document);long ll_attachment_id

// Generate a filename if we don't have one yet
if isnull(pstr_new_document.filename) or trim(pstr_new_document.filename) = "" then
	pstr_new_document.filename = "Attachment_" + string(today(), "yyyymmdd") + string(now(), "hhmmssffffff")
end if

// Workaround for problem where interfaceserviceid isn't always populated.  If it's null or zero then set to the running interfaceserviceid,
// unless the running interfaceserviceid is zero (epie) in which case set the document's interfaceserviceis to be the
// same as it's owner_id
if isnull(pstr_new_document.interfaceserviceid) or pstr_new_document.interfaceserviceid = 0 then
	if interfaceserviceid = 0 then
		pstr_new_document.interfaceserviceid = pstr_new_document.owner_id
	else
		pstr_new_document.interfaceserviceid = interfaceserviceid
	end if
end if

ll_attachment_id = sqlca.jmj_new_attachment2( pstr_new_document.attachment_comment_title, &
															pstr_new_document.filename, &
															pstr_new_document.extension, &
															pstr_new_document.owner_id, &
															pstr_new_document.box_id, &
															pstr_new_document.item_id, &
															pstr_new_document.interfaceserviceid, &
															pstr_new_document.transportsequence, &
															patient_workplan_item_id, &
															current_user.user_id, &
															current_scribe.user_id, &
															pstr_new_document.message_id )
if not tf_check() then return -1

if isnull(ll_attachment_id) or ll_attachment_id <= 0 then
	log.log(this, "new_document()", "Error creating attachment.  Invalid attachment_id returned.", 4)
	return -1
end if

UPDATEBLOB p_Attachment
SET attachment_image = :pstr_new_document.attachment
WHERE attachment_id = :ll_attachment_id;
if not tf_check() then return -1

sqlca.jmj_set_incoming_attachment_ready(ll_attachment_id, pstr_new_document.interfaceserviceid, pstr_new_document.transportsequence, current_user.user_id, current_scribe.user_id)
if not tf_check() then return -1


return 1

end function

protected function long xx_get_documents ();

return 0

end function

public function integer get_documents (long pl_patient_workplan_item_id);long ll_document_count
string ls_status

patient_workplan_item_id = pl_patient_workplan_item_id

SELECT status, workplan_id, item_number
INTO :ls_status, :interfaceserviceid, :transportsequence
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = :pl_patient_workplan_item_id;
if not tf_check() then return -1

sqlca.sp_set_workplan_item_progress(patient_workplan_item_id, current_user.user_id, "Started", datetime(today(), now()), current_user.user_id, computer_id)
if not tf_check() then return -1


ll_document_count = xx_get_documents()

if ll_document_count < 0 then return -1

sqlca.sp_set_workplan_item_progress(pl_patient_workplan_item_id, current_user.user_id, "Completed", datetime(today(), now()), current_user.user_id, computer_id)
if not tf_check() then return -1

add_attribute( "document_count", string(ll_document_count))


return 1

end function

on u_component_document_receiver.create
call super::create
end on

on u_component_document_receiver.destroy
call super::destroy
end on

