$PBExportHeader$u_component_service_get_medication.sru
forward
global type u_component_service_get_medication from u_component_service
end type
end forward

global type u_component_service_get_medication from u_component_service
end type
global u_component_service_get_medication u_component_service_get_medication

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:If any changes made then update it.
//
// Returns: 1 - Complete the Service 
//          2 - Cancel the Service
//          0 - No operation[Continue]
//         <0 - Failure
//
// Created By:Sumathi Chinnasamy										Creation dt: 11/24/2000
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////
boolean lb_auto_dose
string ls_return, ls_form_rxcui, ls_ingr_rxcui, ls_form_description
string ls_generic_rxcui, ls_brand_name_rxcui

Date		ld_begin_date
String	ls_temp

boolean lb_past_med_who_ordered
string ls_ordered_by
integer li_treatment_count, i, li_existing_treatment_defn_count

str_attributes lstr_attributes
str_pick_users lstr_pick_users

// Make sure we have a treatment object
if isnull(treatment) then
	log.log(this, "u_component_service_get_medication.xx_do_service:0019", "No treatment object", 4)
	return 2
end if

// Make sure we have a drug_id
if isnull(treatment.drug_id) then
	log.log(this, "u_component_service_get_medication.xx_do_service:0025", "Null Drug_id", 4)
	return 2
end if

// Make sure the drug_id is valid
f_get_rxnorm(treatment.drug_id, ls_generic_rxcui, ls_brand_name_rxcui)
IF IsNull(ls_generic_rxcui) AND IsNull(ls_brand_name_rxcui) THEN
	log.log(this, "u_component_service_get_medication.xx_do_service:0042", "drug_id " + treatment.drug_id + " not found", 4)
	return 2
END IF

// Make sure we have a formulation
if isnull(treatment.form_rxcui) then
	ls_form_description = f_choose_formulation(treatment)
	IF ls_form_description = "Nothing selected" THEN
		log.log(this, "u_component_service_get_medication.xx_do_service:0050", "No formulation selected", 4)
		return 2
	END IF
end if

// If it's a new treatment then use the dosing screen, otherwise use the edit screen
//if treatment.past_treatment or upper(service) <> "GET_MEDICATION" then
//	Openwithparm(service_window, this, "w_svc_drug_treatment_edit")
//else
//	Openwithparm(service_window, this, "w_drug_treatment")
//end if

// Verified w_drug_treatment handles both editing and new scripts 22/7/2023
Openwithparm(service_window, this, "w_drug_treatment")

ls_return = message.stringparm

CHOOSE CASE upper(ls_return)
	CASE "OK", "COMPLETE"
//		If treatment.past_treatment Then
			// moved from w_trt_pick_drugs.select_drug
//			ls_temp = f_select_date_interval(ld_begin_date, "For How Long?", today(), "ONSET")
//			If NOT isnull(ls_temp) AND NOT trim(ls_temp) = "" Then
//				f_attribute_add_attribute(lstr_attributes, "begin_date", string(ld_begin_date))
//			End If
//			
//			ls_ordered_by = "#Unknown"
//			lb_past_med_who_ordered = datalist.get_preference_boolean( "PREFERENCES", "Past Med Prompt Who Ordered", true)
//			if lb_past_med_who_ordered then
//				lstr_pick_users.pick_screen_title = "Who Ordered This Medication?"
//				lstr_pick_users.cpr_id = current_patient.cpr_id
//				lstr_pick_users.actor_class = "Consultant"
//				user_list.pick_users(lstr_pick_users)
//				if lstr_pick_users.selected_users.user_count > 0 then
//					ls_ordered_by = lstr_pick_users.selected_users.user[1].user_id
//				end if
//			end if
//			f_attribute_add_attribute(lstr_attributes, "ordered_by", ls_ordered_by)
//		end if
//		li_treatment_count = lstr_attributes.attribute_count
//		li_existing_treatment_defn_count = upperbound(treatment.treatment_definition)
//		For i = 1 To li_treatment_count
//			treatment.treatment_definition[i].item_description = f_attribute_find_attribute(lstr_attributes_list.attributes[i], "treatment_description")
//			treatment.treatment_definition[i].treatment_type   = treatment_type
//			treatment.treatment_definition[i].attribute_count  = f_attribute_str_to_arrays(lstr_attributes_list.attributes[i], &
//																										treatment_definition[i].attribute, &
//																										treatment_definition[i].value)
//		Next
		return 1
	CASE "CANCEL"
		return 2
	CASE "BEBACK"
		return 0
	CASE "ERROR"
		return -1
END CHOOSE

// If we get here then log a warning and just return success without saving
log.log(this, "u_component_service_get_medication.xx_do_service:0050", "unrecognized return status (" + ls_return + ")", 3)
Return 1

end function

on u_component_service_get_medication.create
call super::create
end on

on u_component_service_get_medication.destroy
call super::destroy
end on

