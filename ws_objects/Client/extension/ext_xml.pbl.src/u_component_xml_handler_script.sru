$PBExportHeader$u_component_xml_handler_script.sru
forward
global type u_component_xml_handler_script from u_component_xml_handler_base
end type
end forward

global type u_component_xml_handler_script from u_component_xml_handler_base
end type
global u_component_xml_handler_script u_component_xml_handler_script

type variables
// Record the latest context
str_complete_context last_context

pbdom_document XML_Document
pbdom_element current_element

str_attributes document_attributes

string xml_date_format
string xml_time_format
string xml_date_time_separator

str_c_xml_class xml_class

boolean nested = false



end variables

forward prototypes
private function long interpret_xml_command_perform (str_c_display_script_command pstr_command, long pl_object_key)
private subroutine interpret_xml_command (str_c_display_script_command pstr_command)
protected function integer xx_interpret_xml ()
private function integer interpret_element_from_script (long pl_display_script_id, pbdom_element po_current_element, string ps_cpr_id, string ps_context_object, long pl_object_key)
public function integer update_table (string ps_table)
end prototypes

private function long interpret_xml_command_perform (str_c_display_script_command pstr_command, long pl_object_key);string ls_null
long ll_count
long i, j
integer li_sts
string ls_tag
string ls_value
string ls_element_value
string ls_sql
string ls_property
string ls_amount_field
string ls_unit_field
long ll_xml_script_id
PBDOM_Element lo_element
PBDOM_Element lo_child_element
u_ds_data luo_data
str_encounter_description lstr_encounter
str_assessment_description lstr_assessment
str_treatment_description lstr_treatment
long ll_encounter_id
long ll_problem_id
long ll_treatment_id
str_attributes lstr_attributes
str_property_value lstr_property
real lr_amount
string ls_unit_id
long ll_owner_id
string ls_jmj_domain
string ls_jmj_domain_2
string ls_code_domain
string ls_epro_id
string ls_progress_type
string ls_progress_key
string ls_user_id
string ls_which
string ls_query
long ll_rows
string ls_temp
boolean lb_create_elements
string ls_condition
long ll_else_xml_script_id
boolean lb_condition
boolean lb_condition2
string ls_left_side
string ls_right_side
string ls_operator
string ls_attribute_attribute
string ls_attribute_value
boolean lb_attribute_query
long ll_config_object_index
string ls_name
string ls_config_object
string ls_config_object_key_name
string ls_config_object_id
string ls_child_element

setnull(ls_null)

ll_xml_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "xml_script_id"))
ls_child_element = f_attribute_find_attribute(pstr_command.attributes, "child_element")
if len(ls_child_element) > 0 then
	lo_child_element = current_element.getchildelement(ls_child_element)
else
	setnull(lo_child_element)
end if

CHOOSE CASE lower(pstr_command.display_command)
	CASE "actors"
		if not isnull(lo_child_element) then
			get_actors(lo_child_element)
		end if
	CASE "column"
	CASE "key"
	CASE "update"
END CHOOSE


return 1


end function

private subroutine interpret_xml_command (str_c_display_script_command pstr_command);integer li_argument
string ls_text
string ls_temp
string ls_temp1
string ls_temp2
string ls_temp3
string ls_find
integer li_count
integer i
long ll_linelength
long ll_currentline
long ll_last_nonempty_line
integer li_sts
boolean lb_found
str_observation_comment lstr_comment
str_attributes lstr_attributes
str_property_value lstr_property_value
integer li_blank_lines
long ll_command_object_key
long ll_null

setnull(ll_null)
setnull(ls_text)

CHOOSE CASE lower(pstr_command.context_object)
	CASE "treatment"
		// Make sure we have a treatment
		if isnull(last_context.treatment_id) or last_context.treatment_id <= 0 then return
		ll_command_object_key = last_context.treatment_id
	CASE "assessment"
		// Make sure we have an assessment
		if isnull(last_context.problem_id) or last_context.problem_id <= 0 then return
		ll_command_object_key = last_context.problem_id
	CASE "encounter"
		// Make sure we have an encounter
		if isnull(last_context.encounter_id) or last_context.encounter_id <= 0 then return
		ll_command_object_key = last_context.encounter_id
	CASE "observation"
		// Make sure we have an encounter
		if isnull(last_context.observation_sequence) or last_context.observation_sequence <= 0 then return
		ll_command_object_key = last_context.observation_sequence
	CASE "attachment"
		// Make sure we have an encounter
		if isnull(last_context.attachment_id) or last_context.attachment_id <= 0 then return
		ll_command_object_key = last_context.attachment_id
	CASE "patient"
		// Make sure we have a patient
		if isnull(current_patient) then return
		if isnull(current_patient.cpr_id) then return
		setnull(ll_command_object_key)
	CASE "general"
		setnull(ll_command_object_key)
	CASE ELSE
END CHOOSE

// Check each of the command attributes for runtime substitution
f_attribute_value_substitute_multiple(pstr_command.attributes, last_context, document_attributes)

interpret_xml_command_perform(pstr_command, ll_command_object_key)


end subroutine

protected function integer xx_interpret_xml ();integer li_sts
string ls_temp
PBDOM_Element lo_root
string ls_cpr_id
string ls_context_object
long ll_object_key


// Start with document_attributes empty
document_attributes.attribute_count = 0

// Don't do anything if we don't have a display_script_id
if isnull(xml_class.handler_display_script_id) then return 0

// Initialize the last_context structure
last_context = my_context

// Pass nulls in to not redirect the context from my_context
setnull(ls_cpr_id)
setnull(ls_context_object)
setnull(ll_object_key)
li_sts = interpret_element_from_script(xml_class.handler_display_script_id, lo_root, ls_cpr_id, ls_context_object, ll_object_key)
if li_sts <= 0 then return -1

return 1

end function

private function integer interpret_element_from_script (long pl_display_script_id, pbdom_element po_current_element, string ps_cpr_id, string ps_context_object, long pl_object_key);integer li_sts
long i
str_display_script lstr_display_script
pbdom_element lo_last_current_element
str_complete_context lstr_prev_context
integer li_index
boolean lb_nested

lb_nested = nested
nested = true

// Don't do anything if we don't have a display_script_id
if isnull(pl_display_script_id) or pl_display_script_id <= 0 then return 0

// Save the current context
lstr_prev_context = last_context
lo_last_current_element = current_element

// Overwrite the current context with any passed in
if len(ps_cpr_id) > 0 then
	last_context.cpr_id = ps_cpr_id
end if

CHOOSE CASE lower(ps_context_object)
	CASE "patient"
		last_context = f_empty_context()
		last_context.cpr_id = ps_cpr_id
	CASE "encounter"
		last_context.encounter_id = pl_object_key
	CASE "assessment"
		last_context.problem_id = pl_object_key
	CASE "treatment"
		last_context.treatment_id = pl_object_key
	CASE "observation"
		last_context.observation_sequence = pl_object_key
	CASE "attachment"
		last_context.attachment_id = pl_object_key
END CHOOSE

current_element = po_current_element

// Get the display script commands
li_sts = datalist.display_script(pl_display_script_id,lstr_display_script)
if li_sts <= 0 then
	log.log(this, "u_component_xml_handler_script.interpret_element_from_script:0045", "Error getting display_script structure", 4)
	return -1
end if

if not lb_nested and cpr_mode = "CLIENT" then
	li_index = f_please_wait_open()
	f_please_wait_progress_bar(li_index, 0, lstr_display_script.display_command_count)
end if

// Perform the commands
for i = 1 to lstr_display_script.display_command_count
	interpret_xml_command(lstr_display_script.display_command[i])
	if not lb_nested and cpr_mode = "CLIENT" then
		f_please_wait_progress_bump(li_index)
	end if
next

if not lb_nested and cpr_mode = "CLIENT" then
	f_please_wait_close(li_index)
end if

// Reset the context
last_context = lstr_prev_context
current_element = lo_last_current_element

nested = lb_nested

return 1


end function

public function integer update_table (string ps_table);return 1



end function

on u_component_xml_handler_script.create
call super::create
end on

on u_component_xml_handler_script.destroy
call super::destroy
end on

