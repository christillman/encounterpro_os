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
string ls_return

// Make sure we have a treatment object
if isnull(treatment) then
	log.log(this, "xx_do_service()", "No treatment object", 4)
	return 2
end if

// Make sure we have a drug_id
if isnull(treatment.drug_id) then
	log.log(this, "xx_do_service()", "Null Drug_id", 4)
	return 2
end if

// If it's a new treatment then use the dosing screen, otherwise use the edit screen
if treatment.past_treatment or upper(service) <> "GET_MEDICATION" then
	Openwithparm(service_window, this, "w_svc_drug_treatment_edit")
else
	Openwithparm(service_window, this, "w_drug_treatment")
end if

ls_return = message.stringparm

CHOOSE CASE upper(ls_return)
	CASE "OK", "COMPLETE"
		return 1
	CASE "CANCEL"
		return 2
	CASE "BEBACK"
		return 0
	CASE "ERROR"
		return -1
END CHOOSE

// If we get here then log a warning and just return success without saving
log.log(this, "xx_do_service()", "unrecognized return status (" + ls_return + ")", 3)
Return 1

end function

on u_component_service_get_medication.create
call super::create
end on

on u_component_service_get_medication.destroy
call super::destroy
end on

