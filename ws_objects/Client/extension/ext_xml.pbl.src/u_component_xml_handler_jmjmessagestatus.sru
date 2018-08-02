$PBExportHeader$u_component_xml_handler_jmjmessagestatus.sru
forward
global type u_component_xml_handler_jmjmessagestatus from u_component_xml_handler_base
end type
end forward

global type u_component_xml_handler_jmjmessagestatus from u_component_xml_handler_base
end type
global u_component_xml_handler_jmjmessagestatus u_component_xml_handler_jmjmessagestatus

type variables

end variables

forward prototypes
protected function integer xx_interpret_xml ()
end prototypes

protected function integer xx_interpret_xml ();PBDOM_ELEMENT lo_root
PBDOM_ELEMENT lo_from_block
PBDOM_ELEMENT lo_to_block
PBDOM_ELEMENT lo_elem[]
integer li_sts
int i
string ls_root
string ls_tag
string ls_value
long ll_count
string ls_JMJMessageID
string ls_description
string ls_SenderMessageID
string ls_DocumentType
string ls_Status
string ls_StatusText
datetime ldt_StatusDate
long ll_Severity
long ll_patient_workplan_item_id
string ls_message
long ll_loglevel
string ls_progress
u_component_wp_item_document luo_document
long ll_risk_level
long ll_attachment_id
long li_diagnosis_sequence
string ls_new_object
long ll_patient_workplan_id
string ls_progress_type
string ls_progress_key
string ls_workplan_description
string ls_sender_user_id
string ls_recipient_user_id
string ls_from_addressee_user_id
string ls_to_addressee_user_id
string ls_progress_user_id

string ls_from_addresseetype
long ll_from_addresseeid
string ls_from_description
string ls_sendersenderid

string ls_to_addresseetype
long ll_to_addresseeid
string ls_to_description
string ls_senderrecipientid
string ls_attribute
string ls_workplan_verb

setnull(ls_JMJMessageID)
setnull(ls_SenderMessageID)
setnull(ls_DocumentType)
setnull(ls_Status)
setnull(ls_StatusText)
setnull(ldt_StatusDate)
setnull(ll_Severity)
setnull(ll_patient_workplan_item_id)
setnull(ll_risk_level)
setnull(ll_attachment_id)
setnull(li_diagnosis_sequence)

setnull(ls_sender_user_id)
setnull(ls_recipient_user_id)
setnull(ls_from_addressee_user_id)
setnull(ls_to_addressee_user_id)


TRY
	lo_root = xml.XML_Document.GetRootElement()
	ls_root = lo_root.getname()
	
	lo_root.GetChildElements(ref lo_elem)
	ll_count = UpperBound(lo_elem)
	
CATCH (pbdom_exception lo_error)
	log.log(this, "u_component_xml_handler_jmjmessagestatus.xx_interpret_xml.0076", "Error - " + lo_error.text, 4)
	return -1
END TRY

if isnull(ls_root) or lower(ls_root) <> "jmjmessagestatus" then
	log.log(this, "u_component_xml_handler_jmjmessagestatus.xx_interpret_xml.0081", "Error - Document root is not 'JMJMessageStatus'", 4)
	return -1
end if


for i = 1 to ll_count
	ls_tag = lo_elem[i].getname()
	ls_value = lo_elem[i].gettexttrim( )
	
	CHOOSE CASE lower(ls_tag)
		CASE "from"
			lo_from_block = lo_elem[i]
		CASE "to"
			lo_to_block = lo_elem[i]
		CASE "jmjmessageid"
			if len(ls_value) > 0 then
				ls_JMJMessageID = ls_value
			end if
		CASE "description"
			if len(ls_value) > 0 then
				ls_description = ls_value
			end if
		CASE "sendermessageid"
			if len(ls_value) > 0 then
				ls_SenderMessageID = ls_value
			end if
		CASE "ownerid"
			if len(ls_value) > 0 then
				if isnumber(ls_value) then
					owner_id = long(ls_value)
				else
					log.log(this, "u_component_xml_handler_jmjmessagestatus.xx_interpret_xml.0081", "OwnerID not numeric", 3)
				end if
			end if
		CASE "documenttype"
			if len(ls_value) > 0 then
				ls_DocumentType = ls_value
			end if
		CASE "status"
			if len(ls_value) > 0 then
				ls_Status = ls_value
			end if
		CASE "statustext"
			if len(ls_value) > 0 then
				ls_StatusText = ls_value
			end if
		CASE "statusdate"
			if len(ls_value) > 0 then
				ldt_StatusDate = f_xml_datetime(ls_value)
			end if
		CASE "severity"
			if len(ls_value) > 0 then
				if isnumber(ls_value) then
					ll_Severity = long(ls_value)
				else
					log.log(this, "u_component_xml_handler_jmjmessagestatus.xx_interpret_xml.0081", "Severity not numeric", 3)
				end if
			end if
	END CHOOSE
next

// Get the From Block elements
if isvalid(lo_from_block) and not isnull(lo_from_block) then
	TRY
		lo_from_block.GetChildElements(ref lo_elem)
		ll_count = UpperBound(lo_elem)
	CATCH (pbdom_exception lo_error2)
		log.log(this, "u_component_xml_handler_jmjmessagestatus.xx_interpret_xml.0076", "Error - " + lo_error2.text, 4)
		return -1
	END TRY

	for i = 1 to ll_count
		ls_tag = lo_elem[i].getname()
		ls_value = lo_elem[i].gettexttrim( )
		
		CHOOSE CASE lower(ls_tag)
			CASE "addresseetype"
				if len(ls_value) > 0 then
					ls_from_addresseetype = ls_value
				end if
			CASE "addresseeid"
				if len(ls_value) > 0 then
					if isnumber(ls_value) then
						ll_from_addresseeid = long(ls_value)
						ls_from_addressee_user_id = sqlca.fn_lookup_user_idvalue( customer_id, "AddresseeID", string(ll_from_addresseeid))
					else
						log.log(this, "u_component_xml_handler_jmjmessagestatus.xx_interpret_xml.0081", "From/AddresseeID not numeric", 3)
					end if
				end if
			CASE "description"
				if len(ls_value) > 0 then
					ls_from_description = ls_value
				end if
			CASE "sendersenderid"
				if len(ls_value) > 0 then
					ls_sendersenderid = ls_value
					ls_sender_user_id = sqlca.fn_lookup_user_idvalue( customer_id, "ID", ls_sendersenderid)
				end if
		END CHOOSE
	next
end if


// Get the To Block elements
if isvalid(lo_to_block) and not isnull(lo_to_block) then
	TRY
		lo_to_block.GetChildElements(ref lo_elem)
		ll_count = UpperBound(lo_elem)
	CATCH (pbdom_exception lo_error3)
		log.log(this, "u_component_xml_handler_jmjmessagestatus.xx_interpret_xml.0076", "Error - " + lo_error3.text, 4)
		return -1
	END TRY

	for i = 1 to ll_count
		ls_tag = lo_elem[i].getname()
		ls_value = lo_elem[i].gettexttrim( )
		
		CHOOSE CASE lower(ls_tag)
			CASE "addresseetype"
				if len(ls_value) > 0 then
					ls_to_addresseetype = ls_value
				end if
			CASE "addresseeid"
				if len(ls_value) > 0 then
					if isnumber(ls_value) then
						ll_to_addresseeid = long(ls_value)
						ls_to_addressee_user_id = sqlca.fn_lookup_user_idvalue( customer_id, "AddresseeID", string(ll_to_addresseeid))
					else
						log.log(this, "u_component_xml_handler_jmjmessagestatus.xx_interpret_xml.0081", "to/AddresseeID not numeric", 3)
					end if
				end if
			CASE "description"
				if len(ls_value) > 0 then
					ls_to_description = ls_value
				end if
			CASE "sendersenderid"
				if len(ls_value) > 0 then
					ls_senderrecipientid = ls_value
					ls_recipient_user_id = sqlca.fn_lookup_user_idvalue( customer_id, "ID", ls_senderrecipientid)
				end if
		END CHOOSE
	next
end if



if isnull(owner_id) then
	log.log(this, "u_component_xml_handler_jmjmessagestatus.xx_interpret_xml.0081", "Error - Document has no OwnerID element", 4)
	return -1
end if

customer_id = sqlca.customer_id

// If the severity isn't supplied then assume 3
if isnull(ll_Severity) then
	ll_Severity = 3
end if

// We have all the elements of the message status, now see what needs to be done

// First, see if we can find the original document for this message.  If not then just log and return success
if len(ls_SenderMessageID) > 0 then
	SELECT patient_workplan_item_id
	INTO :ll_patient_workplan_item_id
	FROM p_Patient_WP_Item
	WHERE id = :ls_SenderMessageID;
	if not tf_check() then return -1
end if

if isnull(ll_patient_workplan_item_id) then
	ls_message = "Message Status Returned"
	if len(ls_JMJMessageID) > 0 then
		ls_message += ", JMJ Message ID = " + ls_JMJMessageID
	end if
	if len(ls_SenderMessageID) > 0 then
		ls_message += ", Local Message ID = " + ls_SenderMessageID
	end if
	if len(ls_Status) > 0 then
		ls_message += ", Status = " + ls_Status
	end if
	if len(ls_StatusText) > 0 then
		ls_message += " - " + ls_StatusText
	end if
	if ll_Severity > 0 then
		ls_message += " (" + string(ll_Severity) + ")"
	end if
	if ll_Severity > 1 then
		ll_loglevel = 3  // Warning
	else
		ll_loglevel = 2  // Informational
	end if
	log.log(this, "u_component_xml_handler_jmjmessagestatus.xx_interpret_xml.0081", ls_message, ll_loglevel)
	document_context.context_object = "General"
	return 1
end if

// Get the document object
luo_document = CREATE u_component_wp_item_document

li_sts = luo_document.initialize(ll_patient_workplan_item_id)
if li_sts < 0 then return -1

document_context.context_object = luo_document.context_object
document_context.cpr_id = luo_document.cpr_id
document_context.encounter_id = luo_document.encounter_id
document_context.problem_id = luo_document.problem_id
document_context.treatment_id = luo_document.treatment_id
document_context.attachment_id = luo_document.attachment_id

// Log the message id if there is one
if len(ls_JMJMessageID) > 0 then
	luo_document.add_attribute("jmjmessageid", ls_JMJMessageID)
end if

// If we found the original document, then log a progress note against it
if ll_Severity = 1 then
	luo_document.set_progress("Success")
	ls_attribute = "success_message"
	ls_workplan_verb = "Succeeded"
	document_context.purpose = "Message Success"
elseif ll_Severity = 2 then
	luo_document.set_progress("Warning")
	ls_attribute = "error_message"
	ls_workplan_verb = "Succeeded with a Warning"
	document_context.purpose = "Message Success"
elseif ll_Severity > 2 then
	luo_document.set_progress("Error")
	ls_attribute = "error_message"
	ls_workplan_verb = "Failed"
	document_context.purpose = "Message Failure"
end if

luo_document.add_attribute(ls_attribute, ls_StatusText)
luo_document.save_wp_item_attributes( )

// If the original document has a context object, then log a progress note against that
if not isnull(luo_document.cpr_id) then
	ls_progress_type = "Message"
	ls_progress_key = "Return Status"
	if len(ls_StatusText) > 0 then
		ls_progress = ls_StatusText
	end if
	if len(ls_Status) > 0 then
		if len(ls_progress) > 0 then
			ls_progress += " (" + ls_Status + ")"
		else
			ls_progress = "Status = " + ls_Status
		end if
	end if
	
	if len(ls_recipient_user_id) > 0 then
		ls_progress_user_id = ls_recipient_user_id
	elseif len(ls_to_addressee_user_id) > 0 then
		ls_progress_user_id = ls_to_addressee_user_id
	else
		ls_progress_user_id = current_user.user_id
	end if
	
	li_sts = f_set_progress3(luo_document.cpr_id, &
								luo_document.context_object, &
								luo_document.object_key, &
								ls_progress_type, &
								ls_progress_key, &
								ls_progress, &
								datetime(today(), now()), &
								ll_risk_level, &
								ll_attachment_id, &
								ll_patient_workplan_item_id, &
								li_diagnosis_sequence, &
								string(ll_Severity), &
								ls_progress_user_id)
	if li_sts < 0 then return -1
end if

// If there is a purpose, then order the associated workplan
if len(document_context.purpose) > 0 then
	ls_new_object = "N"
	ls_workplan_description = "Sending  to " + luo_document.dispatch_method + " " + ls_workplan_verb + " - " + luo_document.description
	ll_patient_workplan_id = sqlca.jmj_document_order_workplan( luo_document.cpr_id, &
																					luo_document.context_object, &
																					luo_document.object_key, &
																					document_context.purpose, &
																					ls_new_object, &
																					current_user.user_id, &
																					current_scribe.user_id, &
																					ls_workplan_description)
	if not tf_check() then return -1
end if

DESTROY luo_document

return 1


end function

on u_component_xml_handler_jmjmessagestatus.create
call super::create
end on

on u_component_xml_handler_jmjmessagestatus.destroy
call super::destroy
end on

