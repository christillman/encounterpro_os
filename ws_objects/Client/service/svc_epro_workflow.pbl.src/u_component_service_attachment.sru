$PBExportHeader$u_component_service_attachment.sru
forward
global type u_component_service_attachment from u_component_service
end type
end forward

global type u_component_service_attachment from u_component_service
end type
global u_component_service_attachment u_component_service_attachment

forward prototypes
public function long order_workplan (str_attachment pstr_attachment, long pl_workplan_id)
public function integer xx_do_service ()
public function integer show_attachments ()
end prototypes

public function long order_workplan (str_attachment pstr_attachment, long pl_workplan_id);long ll_patient_workplan_id
string ls_in_office_flag
string ls_mode
integer ll_parent_patient_workplan_item_id
string ls_dispatch_flag = "Y"

setnull(ls_in_office_flag)
setnull(ls_mode)
setnull(ll_parent_patient_workplan_item_id)

cprdb.sp_order_workplan( &
		current_patient.cpr_id, &
		pl_workplan_id, &
		encounter_id, &
		pstr_attachment.problem_id, &
		pstr_attachment.treatment_id, &
		pstr_attachment.observation_sequence, &
		pstr_attachment.attachment_id, &
		pstr_attachment.attachment_tag, &
		current_user.user_id, &
		current_user.user_id, &
		ls_in_office_flag, &
		ls_mode, &
		ll_parent_patient_workplan_item_id, &
		current_scribe.user_id, &
		ls_dispatch_flag, &
		ll_patient_workplan_id)
if not cprdb.check() then return -1

return ll_patient_workplan_id



end function

public function integer xx_do_service ();str_popup popup
str_popup_return popup_return
string ls_action
integer li_sts
str_attributes lstr_attributes

ls_action = get_attribute("action")
if isnull(ls_action) then ls_action = "review"

If isnull(attachment_id) then
	// assumed that it should show up all the attachments
 	show_attachments()
	Return 1
End If

lstr_attributes = get_attributes()

CHOOSE CASE lower(ls_action)
	CASE "display"
		li_sts = f_display_attachment_with_attributes(attachment_id, lstr_attributes)
	CASE "edit"
		li_sts = f_edit_attachment_with_attributes(attachment_id, lstr_attributes)
	CASE "review"
		li_sts = f_review_attachment_with_attributes(attachment_id, lstr_attributes)
	CASE "transcribe"
		li_sts = f_transcribe_attachment_with_attributes(attachment_id, lstr_attributes)
	CASE ELSE
		log.log(this, "xx_do_service()", "Invalid action (" + ls_action + ")", 4)
		return -1
END CHOOSE

if li_sts <= 0 then return -1

// If this is a manual service then we're done
if manual_service then return 1

// Now ask the user if they're done
popup.data_row_count = 2
popup.items[1] = "I'll Be Back"
popup.items[2] = "I'm Finished"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	return 0
else
	if popup_return.item_indexes[1] = 1 then
		return 0
	else
		return 1
	end if
end if

Return 1
end function

public function integer show_attachments ();////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:Loads all the attachments based on the given attachment object.
// 
// 
//
// Created By:Sumathi Chinnasamy															Creation dt: 10/26/2001
//
////////////////////////////////////////////////////////////////////////////////////////////////////


String ls_null
String ls_attachment_tag
String ls_cpr_id
Long ll_id

str_popup  				popup
w_window_base lw_window

ls_attachment_tag = get_attribute("comment_title")
ls_cpr_id = current_patient.cpr_id

If isnull(context_object) Then
	log.log(this, "show_attachments()", "Null context_object", 4)
	return -1
end if

CHOOSE CASE lower(context_object)
	CASE "patient"
	CASE "encounter"
		if isnull(encounter_id) then
			mylog.log(this, "xx_do_service()", "Null encounter_id", 4)
			return -1
		end if
		ll_id = encounter_id
	CASE "treatment"
		if isnull(treatment_id) then
			mylog.log(this, "xx_do_service()", "Null treatment_id", 4)
			return -1
		end if
		ll_id = treatment_id
	CASE "observation"
		if isnull(observation_sequence) then
			mylog.log(this, "xx_do_service()", "Null observation_sequence", 4)
			return -1
		end if
		ll_id = observation_sequence
	CASE "assessment"
		if isnull(problem_id) then
			mylog.log(this, "xx_do_service()", "Null problem_id", 4)
			return -1
		end if
		ll_id = problem_id
	CASE ELSE
		mylog.log(this, "xx_do_service()", "Invalid attachment_object (" + context_object + ")", 4)
		return -1
END CHOOSE
Setnull(ls_null)

popup.data_row_count = 4
popup.items[1] = context_object
popup.items[2] = String(ll_id)
popup.items[3] = ls_null
popup.items[4] = ls_attachment_tag
Openwithparm(lw_window, this, "w_attachment_display", f_active_window())

Return 1

end function

on u_component_service_attachment.create
call super::create
end on

on u_component_service_attachment.destroy
call super::destroy
end on

