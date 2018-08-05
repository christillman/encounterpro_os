$PBExportHeader$u_component_report_rtf.sru
forward
global type u_component_report_rtf from u_component_report
end type
end forward

global type u_component_report_rtf from u_component_report
end type
global u_component_report_rtf u_component_report_rtf

type variables
long display_script_id


end variables

forward prototypes
public function integer xx_printreport ()
end prototypes

public function integer xx_printreport ();w_encounterpro_report_rtf lw_rtf
string ls_destination

openwithparm(lw_rtf, this, "w_encounterpro_report_rtf")

// If we're saving to a file then the window will have returned a structure
ls_destination = upper(get_attribute("DESTINATION"))
if upper(ls_destination) = "FILE" then
	document_file = message.powerobjectparm
	if len(document_file.attachment) > 0 then return 1
	return -1
end if

return 1

///////////////////////////////////////////////////////////////////////////////////////////////////////
////	Return: Integer
////
//// Create By:Mark									Created On:01/23/02
////
//// Description:
//// 
////
////
//////////////////////////////////////////////////////////////////////////////////////////////////////
//integer li_sts
//long ll_fieldid
//string ls_fielddata
//str_service_info lstr_service
//str_c_display_script_command lstr_command
//long ll_encounter_id
//long ll_problem_id
//long ll_treatment_id
//str_encounter_description lstr_encounter
//str_assessment_description lstr_assessment
//str_treatment_description lstr_treatment
//string ls_temp
//long ll_object_key
//long ll_template_length
//blob lbl_report_template
//any la_fielddata
//long ll_fieldstart
//long ll_fieldend
//string ls_fieldtext
//
//// Load the template, if any
//SELECTBLOB template
//INTO :lbl_report_template
//FROM c_Report_Definition
//WHERE report_id = :report_id;
//if not tf_check() then return -1
//if sqlca.sqlcode = 100 then
//	log.log(this, "u_component_report_rtf.xx_printreport:0053", "report_id not found (" + report_id + ")", 4)
//	return -1
//end if
//
//ll_template_length = len(lbl_report_template)
//if not isnull(lbl_report_template) and ll_template_length > 0 then
//	rtf.object.loadfrommemory(lbl_report_template, 5)
//end if
//
//
//// Get any available context
//ll_object_key = long(get_attribute("encounter_id"))
//if isnull(ll_object_key) then
//	setnull(lstr_encounter.encounter_id)
//else
//	li_sts = current_patient.encounters.encounter(lstr_encounter, ll_object_key)
//end if
//
//ll_object_key = long(get_attribute("problem_id"))
//if isnull(ll_object_key) then
//	setnull(lstr_assessment.problem_id)
//else
//	li_sts = current_patient.assessments.assessment(lstr_assessment, ll_object_key)
//end if
//
//ll_object_key = long(get_attribute("treatment_id"))
//if isnull(ll_object_key) then
//	setnull(lstr_treatment.treatment_id)
//else
//	li_sts = current_patient.treatments.treatment(lstr_treatment, ll_object_key)
//end if
//
//// Turn off the standard footer
//rtf.nested = true
//
//// First go through all the command fields and execute the corresponding commands
//ll_fieldid = 0
//DO WHILE true
//	ll_fieldid = rtf.object.fieldnext(ll_fieldid, 0)
//	if ll_fieldid <= 0 then exit
//	
//	rtf.object.fieldcurrent = ll_fieldid
//	
//	la_fielddata = rtf.object.fielddata[ll_fieldid]
//	if lower(classname(la_fielddata)) = "string" then
//		ls_fielddata = string(la_fielddata)
//		ll_fieldstart = rtf.object.fieldstart
//		ll_fieldend = rtf.object.fieldend
//		ls_fieldtext = rtf.object.fieldtext
//		
//		lstr_service = f_field_data_to_service(ls_fielddata)
//		f_split_string(lstr_service.service, " ", lstr_command.context_object, lstr_command.display_command)
//		lstr_command.attributes = lstr_service.attributes
//		
//		rtf.object.selstart = ll_fieldend
//		rtf.object.sellength = 0
//		rtf.object.fieldtext = ""
//		rtf.object.fontunderline = 0
//		rtf.object.forecolor = color_black
//	
//		rtf.display_script_command( lstr_command, lstr_encounter, lstr_assessment, lstr_treatment)	
//	end if
//LOOP
//
//// Turn on the standard footer
//rtf.nested = false
//	
//// Then, if there's a display script, execute it
//get_attribute("display_script_id", display_script_id)
//// If a report_format wasn't passed in, then use the "sql" column from c_Report_Definition
//if not isnull(display_script_id) then
//	rtf.goto_end_of_text()
//	rtf.display_script(display_script_id)
//end if
//	
//
//Return 1
//
//
end function

on u_component_report_rtf.create
call super::create
end on

on u_component_report_rtf.destroy
call super::destroy
end on

event constructor;call super::constructor;report_type = "RTF"

end event

