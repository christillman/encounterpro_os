$PBExportHeader$u_dw_child_treatments.sru
forward
global type u_dw_child_treatments from u_dw_pick_list
end type
end forward

global type u_dw_child_treatments from u_dw_pick_list
integer width = 1797
integer height = 484
string dataobject = "dw_followup_workplan_items"
borderstyle borderstyle = styleraised!
event child_treatments_loaded ( )
end type
global u_dw_child_treatments u_dw_child_treatments

type variables
String treatment_list_id // to pull out popup buttons from c_treatment_type_list
String followup_workplan_type  // determines what set of rows to show up (whether referral or followup)

u_component_service service
u_component_treatment 	parent_treatment
end variables

forward prototypes
public function integer insert_child_items_to_wp (string ps_treatment_type, string ps_treatment_description, string ps_attributes[], string ps_values[])
public function integer load_child_treatments ()
public subroutine add_treatment ()
public function integer delete_item (long pl_patient_workplan_item_id)
public function integer initialize (u_component_service puo_service)
end prototypes

public function integer insert_child_items_to_wp (string ps_treatment_type, string ps_treatment_description, string ps_attributes[], string ps_values[]);Long		ll_patient_workplan_id,ll_patient_workplan_item_id
Integer	i,li_attribute_count
String	ls_attribute,ls_value
datetime ldt_created
long ll_new_treatment_id
long ll_null

setnull(ll_null)
setnull(ldt_created)

li_attribute_count = Upperbound(ps_attributes)

sqlca.sp_get_treatment_followup_workplan(current_patient.cpr_id, &
														parent_treatment.treatment_id, &
														current_patient.open_encounter.encounter_id, &
														current_user.user_id, &
														current_scribe.user_id, &
														followup_workplan_type, &
														ll_patient_workplan_id)
If Not tf_check() then Return -1

If Not isnull(ll_patient_workplan_id) Then
	ll_new_treatment_id = sqlca.sp_set_treatment_followup_workplan_item(current_patient.cpr_id, &
																								current_patient.open_encounter.encounter_id, &
																								ll_patient_workplan_id, &
																								ps_treatment_type, &
																								ps_treatment_description, &
																								current_user.user_id, &
																								current_scribe.user_id, &
																								ldt_created, &
																								ll_patient_workplan_item_id)
	If Not tf_check() then Return -1
	
	If Not isnull(ll_patient_workplan_item_id) Then
		For i = 1 to li_attribute_count
			ls_attribute = ps_attributes[i]
			ls_value = ps_values[i]
			
			if ll_new_treatment_id > 0 then
				sqlca.sp_set_treatment_progress(current_patient.cpr_id, &
															ll_new_treatment_id, &
															current_patient.open_encounter.encounter_id, &
															"Modify", &
															ls_attribute, &
															ls_value, &
															datetime(today(), now()), &
															current_service.patient_workplan_item_id, & 
															ll_null, &
															ll_null, &
															current_user.user_id, &
															current_scribe.user_id )
				If Not tf_check() Then Return -1
			else
				sqlca.sp_add_workplan_item_attribute( &
					current_patient.cpr_id,&
					ll_patient_workplan_id,&
					ll_patient_workplan_item_id,&
					ls_attribute,&
					ls_value,&
					current_scribe.user_id,&
					current_USER.user_id)
				If Not tf_check() Then Return -1
			end if
		Next
	End if
End if

Return 1
end function

public function integer load_child_treatments ();Setredraw(false)
Reset()

retrieve(current_patient.cpr_id,parent_treatment.treatment_id,followup_workplan_type)
If not tf_check() then 
	Setredraw(true)
	return -1
End If
Setredraw(true)

Return 1


end function

public subroutine add_treatment ();/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Call the respective treatment component to define & order a treatment
//              
// Returns: None
//
// Created By:Sumathi Chinnasamy										Creation dt: 06/06/2001
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

String						ls_treatment_type,ls_description
String						ls_attributes[],ls_values[]
Integer						li_tr_count = 1,li_max,li_rtn
u_component_treatment   luo_treatment


// Filter the treatments associated with 'FOLLOWUP' Or Referral or ..
ls_treatment_type = f_get_treatments_list(treatment_list_id)
If Not Isnull(ls_treatment_type) Then
	luo_treatment = f_get_treatment_component(ls_treatment_type)
	If Not Isnull(luo_treatment) Then 
		li_rtn = luo_treatment.define_treatment()
		If li_rtn <= 0 Then GOTO destroyobj
		li_max = Upperbound(luo_treatment.treatment_definition)
		If li_max <= 0 Then GOTO destroyobj
		// Loop thru all selected treatments and order one by one.
		Do While li_tr_count <= li_max
			ls_description = luo_treatment.treatment_definition[li_tr_count].item_description
			ls_attributes = luo_treatment.treatment_definition[li_tr_count].attribute
			ls_values = luo_treatment.treatment_definition[li_tr_count].value
			// reset the properties
			luo_treatment.reset()
			// now add the followup/referral treatment items into patient wp tables
			li_rtn = insert_child_items_to_wp(ls_treatment_type,ls_description,ls_attributes,ls_values)
			If li_rtn < 0 Then GOTO destroyobj
			li_tr_count++
		Loop
		load_child_treatments()
	End If
End If
destroyobj:
component_manager.destroy_component(luo_treatment)
Return
end subroutine

public function integer delete_item (long pl_patient_workplan_item_id);datetime ldt_progress_date_time
long ll_child_treatment_id
string ls_null
long ll_null

setnull(ls_null)
setnull(ll_null)
setnull(ldt_progress_date_time)

// Cancel the treatment
SELECT t.treatment_id
INTO :ll_child_treatment_id
FROM p_Treatment_Item t
	INNER JOIN p_Patient_WP_Item i
	ON t.cpr_id = i.cpr_id
	AND t.treatment_id = i.treatment_id
WHERE i.patient_workplan_item_id = :pl_patient_workplan_item_id;
if not tf_check() then return -1

if ll_child_treatment_id > 0 then
	sqlca.sp_set_treatment_progress(service.cpr_id,&
												ll_child_treatment_id, &
												service.encounter_id, &
												"Cancelled", &
												ls_null, &
												ls_null, &
												datetime(today(), now()), &
												service.patient_workplan_item_id, &
												ll_null, &
												ll_null, &
												current_user.user_id, &
												current_scribe.user_id)
	if not tf_check() then return -1
end if

sqlca.sp_complete_workplan_item( &
		pl_patient_workplan_item_id, &
		current_user.user_id, &
		'CANCELLED', &
		ldt_progress_date_time, &
		current_scribe.user_id)

If Not tf_check() then Return -1

Return deleterow(0)

end function

public function integer initialize (u_component_service puo_service);string ls_child_flag

// Set the transaction object
Settransobject(SQLCA)

service = puo_service
if isnull(service.treatment) then
	log.log(this, "u_dw_child_treatments.initialize:0008", "Service has no treatment context", 4)
	return -1
end if

parent_treatment = service.treatment

ls_child_flag = datalist.treatment_type_followup_flag(parent_treatment.treatment_type)

treatment_list_id = service.get_attribute("followup_treatment_list_id")
if isnull(treatment_list_id) then
	treatment_list_id = "FOLLOWUP_FLAG_" + ls_child_flag
end if

If upper(ls_child_flag) = "R" Then
	followup_workplan_type = "Referral"
Else
	followup_workplan_type = "Followup" 
End If


Return load_child_treatments()

end function

event post_click;call super::post_click;String						buttons[],ls_button
Integer						button_pressed,li_rtn
Long							ll_patient_workplan_item_id
// user defined
str_popup			     	popup

If clicked_row > 0 Then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete This Treatment"
	popup.button_titles[popup.button_count] = "Delete"
	buttons[popup.button_count] = "DELETE"

	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"

	popup.button_titles_used = True

	If popup.button_count > 1 Then
		Openwithparm(w_pop_buttons, popup)
		button_pressed = message.doubleparm
	Elseif popup.button_count = 1 then
		button_pressed = 1
	Else
		Return
	End If

	CHOOSE CASE buttons[button_pressed]
		CASE "DELETE"
			ll_patient_workplan_item_id = object.patient_workplan_item_id[clicked_row]
			this.delete_item(ll_patient_workplan_item_id)
	END CHOOSE
End If

Return
end event

on u_dw_child_treatments.create
call super::create
end on

on u_dw_child_treatments.destroy
call super::destroy
end on

