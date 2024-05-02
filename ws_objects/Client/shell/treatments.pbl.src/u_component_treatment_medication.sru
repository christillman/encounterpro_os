$PBExportHeader$u_component_treatment_medication.sru
forward
global type u_component_treatment_medication from u_component_treatment
end type
end forward

global type u_component_treatment_medication from u_component_treatment
end type
global u_component_treatment_medication u_component_treatment_medication

type variables
string prescription_flag,common_name,take_as_directed
end variables

forward prototypes
public function integer xx_define_treatment ()
end prototypes

public function integer xx_define_treatment ();//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Opens a window to pick one or more drugs.
//             
//
// Modified By:Sumathi Chinnasamy									Creation dt: 04/27/2000
//
// Note: 'PriorMeds' service window w_svc_prior_meds also uses this component
// to create past meds.
/////////////////////////////////////////////////////////////////////////////////////

Integer				i
str_popup			popup
str_popup_return	popup_return
str_attributes lstr_attributes
str_attributes_list lstr_attributes_list
string ls_temp, ls_description, ls_dosage_form
Datetime ldt_begin_date
Date		ld_begin_date

popup.data_row_count = 2
// to search for any medication, use MEDICATION here not PriorMedication
popup.items[1] = "MEDICATION"
popup.items[2] = f_boolean_to_string(this.include_strength)

If this.prior_treatment Then
	Openwithparm(w_pick_prior_drugs, popup)	
ElseIf this.past_treatment Then
	Openwithparm(w_pick_prior_drugs, popup)	
//	Openwithparm(service_window, this, "w_drug_treatment")
//	
//	// Let the user select a begin date
//	ls_temp = f_select_date_interval(ld_begin_date, "For How Long?", today(), "ONSET")
//	If isnull(ls_temp) OR trim(ls_temp) = "" Then
//		setnull(ldt_begin_date)
//	Else
//		ls_description += " " + ls_temp
//		f_attribute_add_attribute(lstr_attributes, "begin_date", string(ld_begin_date))
//	End If
//
//	ls_ordered_by = "#Unknown"
//	lb_past_med_who_ordered = datalist.get_preference_boolean( "PREFERENCES", "Past Med Prompt Who Ordered", true)
//	if lb_past_med_who_ordered then
//		lstr_pick_users.pick_screen_title = "Who Ordered This Medication?"
//		lstr_pick_users.cpr_id = current_patient.cpr_id
//		lstr_pick_users.actor_class = "Consultant"
//		user_list.pick_users(lstr_pick_users)
//		if lstr_pick_users.selected_users.user_count > 0 then
//			ls_ordered_by = lstr_pick_users.selected_users.user[1].user_id
//		end if
//	end if
//	f_attribute_add_attribute(lstr_attributes, "ordered_by", ls_ordered_by)
Else
	Openwithparm(w_trt_pick_drugs, popup)
End If

lstr_attributes_list = Message.powerobjectparm

treatment_count = lstr_attributes_list.attributes_count
For i = 1 To treatment_count
	treatment_definition[i].item_description = f_attribute_find_attribute(lstr_attributes_list.attributes[i], "treatment_description")
	treatment_definition[i].treatment_type   = treatment_type
	treatment_definition[i].attribute_count  = f_attribute_str_to_arrays(lstr_attributes_list.attributes[i], &
																								treatment_definition[i].attribute, &
																								treatment_definition[i].value)
Next

Return 1

end function

on u_component_treatment_medication.create
call super::create
end on

on u_component_treatment_medication.destroy
call super::destroy
end on

