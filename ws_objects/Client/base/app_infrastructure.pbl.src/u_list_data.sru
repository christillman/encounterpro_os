$PBExportHeader$u_list_data.sru
forward
global type u_list_data from nonvisualobject
end type
end forward

global type u_list_data from nonvisualobject
end type
global u_list_data u_list_data

type prototypes

end prototypes

type variables
u_ds_data table_update
u_ds_data attachment_types
u_ds_data assessment_definition
u_ds_data assessment_types
u_ds_data attachment_location
u_ds_data chart_page_attributes
u_ds_data consultants
u_ds_data display_script_selection
u_ds_data display_scripts
u_ds_data display_script_commands
u_ds_data display_script_command_attributes
u_ds_data em_component_level
u_ds_data em_type_level
u_ds_data encounter_types
u_ds_data epro_object
u_ds_data extensions
u_ds_data external_source_types
u_ds_data external_observations
u_ds_data folder_selection
u_ds_data treatment_types
u_ds_data treatment_type_list_def
u_ds_data treatment_type_list
u_ds_data observation_types
u_ds_data observation_categories
u_ds_data observations
u_ds_data observation_results
u_ds_data observation_stages
string stage_observation_id
u_ds_data preferences
u_ds_data progress_types
u_ds_data locations
u_ds_data location_domains
u_ds_data specialties
u_ds_data c_config_object_type
u_ds_data c_Property
u_ds_data c_Property_Attribute
u_ds_data property_types
u_ds_data domain_items
u_ds_data procedure_types
u_ds_data offices
u_ds_data qualifier_domains
u_ds_data qualifier_domain_categories
u_ds_data room_types
u_ds_data services
u_ds_data menus
u_ds_data menu_items
u_ds_data exam_default_results
u_ds_data exam_definition
u_ds_data visit_level
u_ds_data visit_level_rule
u_ds_data visit_level_rule_item
u_ds_data vial_type
u_ds_data workplan
u_ds_data xml_class

// Office status datastores
u_ds_data open_encounters
u_ds_data active_services
u_ds_data office_rooms
time office_last_refresh
long office_refresh_interval = 5

// Datastores to lookup context columns
u_ds_data property_columns_patient
u_ds_data property_columns_encounter
u_ds_data property_columns_assessment
u_ds_data property_columns_treatment

// Datastore to find observations in the database
u_ds_data observation_find

// Datastores for finding and cacheing (respectively) observation_tree data
u_ds_data observation_tree
u_ds_data observation_tree_lookup


// Generic datastore for finding data in the database
u_ds_data datafind

long observation_tree_cache_count
str_observation_tree observation_tree_cache[]

long observation_results_cache_count
str_observation_results observation_results_cache[]

integer office_count
str_c_office office_cache[]

long display_script_count
str_display_script display_script_cache[]

//time last_table_update_load

long location_domain_cache_count
str_location_domain location_domain_cache[]

long progress_type_cache_count
str_progress_type_cache progress_type_cache[]

private u_ds_data code_by_epro

private long menu_cache_count
private str_menu menu_cache[]

str_priorities priorities


u_clinical_data_cache clinical_data_cache
u_epro_object_data_cache epro_object_data_cache

end variables

forward prototypes
public function string attachment_button (string ps_attachment_type)
public function string attachment_button_new (string ps_attachment_type)
public function string attachment_button_not (string ps_attachment_type)
public function string attachment_type_description (string ps_attachment_type)
public function string encounter_type_default_role (string ps_encounter_type)
public function string encounter_type_description (string ps_encounter_type)
public function boolean encounter_type_is_valid (string ps_encounter_type)
public function string encounter_type_default_indirect_flag (string ps_encounter_type)
public function string observation_observation_type (string ps_observation_id)
public function string observation_category_description (string ps_observation_type, string ps_observation_category_id)
public function string observation_observation_category_id (string ps_observation_id)
public function string observation_description (string ps_observation_id)
public function string specialty_description (string ps_specialty_id)
public function string observation_perform_location_domain (string ps_observation_id)
public function string first_location (string ps_location_domain)
public function string observation_exclusive_flag (string ps_observation_id)
public function string domain_item_description (string ps_domain_id, string ps_domain_item)
public function string domain_item_bitmap (string ps_domain_id, string ps_domain_item)
public function integer refresh_observation (string ps_observation_id)
public function integer observation_category_sort_order (string ps_observation_type, string ps_observation_category_id)
public function string observation_category_abbreviation (string ps_observation_type, string ps_observation_category_id)
public function string procedure_type_description (string ps_procedure_type)
public function string qualifier_class (long pl_qualifier_domain_category_id)
public function long qualifier_domain_category_id (long pl_qualifier_domain_id)
public function string observation_composite_flag (string ps_observation_id)
public function string service_component_id (string ps_service)
public function string service_owner_flag (string ps_service)
public function string service_close_flag (string ps_service)
public function string service_button (string ps_service)
public function long load_assessment_types ()
public function long load_attachment_types ()
public function long load_domain_items ()
public function long load_encounter_types ()
public function long load_locations ()
public function long load_observation_categories ()
public function long load_procedure_types ()
public function long load_qualifier_domain_categories ()
public function long load_qualifier_domains ()
public function long load_services ()
public function long load_specialties ()
public function string service_description (string ps_service)
public function long load_treatment_type_list_def ()
public function string encounter_type_bill_flag (string ps_encounter_type)
public function string observation_default_view (string ps_observation_id)
public function long load_treatment_types ()
public function string observation_collection_procedure_id (string ps_observation_id)
public function string observation_perform_procedure_id (string ps_observation_id)
public function long load_treatment_type_list ()
public function string treatment_type_list_defined_flag (string ps_treatment_list_id, long pl_list_sequence)
public function string observation_collection_location_domain (string ps_observation_id)
public function string get_preference (string ps_preference_type, string ps_preference_id, string ps_default_value)
public function long get_preference_int (string ps_preference_type, string ps_preference_id, long pl_default_value)
public function string assessment_type_icon_open (string ps_assessment_type)
public function string assessment_type_icon_closed (string ps_assessment_type)
public function string treatment_type_list_description (string ps_treatment_list_id)
public function string assessment_type_description (string ps_assessment_type)
public function string exam_root_observation_id (long pl_exam_sequence)
public function string exam_description (long pl_exam_sequence)
private function long load_exams ()
private function long find_exam_definition (long pl_exam_sequence)
public function long load_exam_default_results ()
public function integer exam_set_default_results (long pl_exam_sequence, string ps_user_id, long pl_branch_id, str_observation_tree pstr_tree)
public function integer exam_set_default_results (long pl_exam_sequence, string ps_user_id, long pl_branch_id, string ps_observation_id, integer pi_default_result_count, str_exam_default_result pstra_default_results[])
private function integer exam_set_tree_default_results (long pl_exam_sequence, string ps_user_id, str_observation_tree pstr_tree)
private function integer exam_clear_default_results (long pl_exam_sequence, string ps_user_id, str_observation_tree pstr_tree)
public function integer exam_clear_defaults (long pl_exam_sequence, string ps_user_id, long pl_branch_id)
private function integer exam_clear_default_results (long pl_exam_sequence, string ps_user_id, long pl_branch_id)
public function long new_exam (string ps_description, string ps_root_observation_id, string ps_default_flag)
public function long new_exam (string ps_description, string ps_root_observation_id)
public function long observation_default_exam_sequence (string ps_observation_id)
private function long find_assessment (string ps_assessment_id)
public function str_observation_results observation_perform_results (string ps_observation_id)
public function str_observation_results observation_collect_results (string ps_observation_id)
public function str_observation_tree observation_tree (string ps_parent_observation_id, boolean pb_get_subtrees)
private function integer exam_default_results (long pl_exam_sequence, ref str_observation_tree_branch pstr_branch)
private function str_observation_tree observation_tree (string ps_parent_observation_id, boolean pb_get_subtrees, datetime pdt_last_updated)
public function string observation_tree_branch_parent (long pl_branch_id)
public function str_observation_tree exam_default_results (long pl_exam_sequence, long pl_branch_id)
public function long get_preference_int (string ps_preference_type, string ps_preference_id)
public function string menu_description (long pl_menu_id)
public function str_menu get_menu (long pl_menu_id)
public function long load_external_observations ()
public function string external_observation (string ps_external_source, string ps_observation_id)
public function string get_edit_list_id (string ps_top_20_user_id, string ps_top_20_code)
public function string assessment_icd10_code (string ps_assessment_id)
public function long load_observation_types ()
public function string observation_type_default_composite_flag (string ps_observation_type)
public function integer observation_type_sort_sequence (string ps_observation_type)
public function string assessment_description (string ps_assessment_id)
public function str_observation_tree observation_tree (string ps_parent_observation_id)
public function str_observation_tree_branch observation_tagged_child (string parent_observation_id, string observation_tag)
public function string observation_in_context_flag (string ps_observation_id)
public function long load_extensions ()
public function string extension_component_id (string ps_extension)
public function string external_source_component_id (string ps_external_source)
public function long external_source_workplan_id (string ps_external_source)
public function long external_source_in_office_workplan_id (string ps_external_source)
public function string extension_description (string ps_extension)
public function any service (string ps_service, string ps_field)
public function string service_secure_flag (string ps_service)
public function long observation_material_id (string ps_observation_id)
public function string extension_default_attachment_type (string ps_extension)
public function string extension_button (string ps_extension)
private function long find_observation (string ps_observation_id)
public function long load_visit_level_rule ()
public function str_default_results exam_default_results_simple (long pl_exam_sequence, long pl_branch_id, string ps_location)
public function integer default_locations_in_domain (string ps_location_domain, ref string psa_locations[], ref string psa_descriptions[])
public function string observation_tree_branch_child (long pl_branch_id)
public function str_default_results observation_default_results_simple (string ps_observation_id, integer pi_result_sequence, string ps_location)
private function integer exam_set_branch_default_results (long pl_exam_sequence, string ps_user_id, long pl_branch_id, string ps_observation_id, integer pi_default_result_count, str_exam_default_result pstra_default_results[])
public function integer branch_child_ordinal (string parent_observation_id, long branch_id)
public function str_default_results exam_default_results_simple (long pl_exam_sequence, long pl_branch_id)
public function str_default_results exam_default_results_simple (long pl_exam_sequence, long pl_branch_id, integer pi_result_sequence)
private function str_default_results exam_default_results_simple (long pl_exam_sequence, long pl_branch_id, integer pi_result_sequence, string ps_location)
public function string treatment_type_list_button (string ps_treatment_list_id)
public function string treatment_type_component (string ps_treatment_type)
public function string treatment_type_composite_flag (string ps_treatment_type)
public function string treatment_type_define_button (string ps_treatment_type)
public function string treatment_type_define_title (string ps_treatment_type)
public function string treatment_type_description (string ps_treatment_type)
public function character treatment_type_followup_flag (string ps_treatment_type)
public function string treatment_type_icon (string ps_treatment_type)
public function string treatment_type_observation_type (string ps_treatment_type)
public function integer treatment_type_sort_sequence (string ps_treatment_type)
public function string external_source_description (string ps_external_source)
public function string external_source_button (string ps_external_source)
public function string observation_display_style (string ps_observation_id)
public function string observation_type_display_style (string ps_observation_type)
public subroutine clear_cache (string ps_cache)
public function long load_property_types ()
public function string property_type_description (string ps_property_type)
public function string property_type_component_id (string ps_property_type)
public function str_c_observation_result observation_result (string ps_observation_id, integer pi_result_sequence)
public function str_observation_results observation_results (string ps_observation_id)
private function str_observation_results get_observation_results (string ps_observation_id)
public function string property_type_button (string ps_property_type)
public function string property_type_icon (string ps_property_type)
public function string assessment_assessment_type (string ps_assessment_id)
public function integer location_sort_sequence (string ps_location)
public function long load_consultants ()
public function string consultant_description (string ps_consultant_id)
public function string consultant_address (string ps_consultant_id)
public function string consultant_phone (string ps_consultant_id)
public function string extension_default_storage_flag (string ps_extension)
public function str_observation_tree_branch observation_branch (string ps_parent_observation_id, string ps_child_observation_id, integer pi_child_ordinal)
public function string get_preference (string ps_preference_type, string ps_preference_id)
public function long load_visit_level_rule_item ()
public function integer visit_level (string ps_em_documentation_guide, string ps_new_flag, integer pi_history_level, integer pi_exam_level, integer pi_decision_level)
public function long load_visit_level ()
public function string visit_level_description (long pl_visit_level)
public function string encounter_type_visit_code_group (string ps_encounter_type)
public function long load_em_component_level ()
public function long load_em_type_level ()
public function string location_description (string ps_location)
public function string location_description (string ps_location_domain, string ps_location)
public function integer locations_in_domain (string ps_location_domain, ref string psa_locations[], ref string psa_descriptions[])
private function str_observation_tree get_observation_tree (string ps_parent_observation_id)
private function long find_observation (string ps_observation_id, datetime pdt_last_updated)
public function string em_component_level_description (string ps_em_component, long pl_em_component_level)
public function string em_type_level_description (string ps_em_component, string ps_em_type, long pl_em_type_level)
public function long load_external_source_types ()
public function string external_source_type_description (string ps_external_source_type)
public function string extension_display_control (string ps_extension)
public function str_observation_tree_branch observation_tree_branch (string ps_parent_observation_id, long pl_branch_id)
public function integer observation_tree_branch_update (str_observation_tree_branch pstr_branch)
private function str_default_results exam_default_result_list (long pl_exam_sequence)
private function integer load_office_status (ref long pl_room_count, ref long pl_encounter_count, ref long pl_service_count)
public function str_room_list office_group_rooms (long pl_group_id)
public function str_wp_item_list office_encounter_services (string ps_cpr_id, long pl_encounter_id)
private function str_room office_room (long pl_row)
public function str_room office_room (string ps_room_id)
private function str_encounter_description office_encounter (long pl_row)
public function str_encounter_list office_room_encounters (string ps_room_id)
public function str_observation_tree_branch observation_tree_branch (long pl_branch_id)
public function string assessment_auto_close (string ps_assessment_id)
public function string treatment_type_in_office_flag (string ps_treatment_type)
public function string treatment_type_workplan_close_flag (string ps_treatment_type)
public function string treatment_type_referral_specialty_id (string ps_treatment_type)
public function long load_chart_page_attributes ()
public function string get_chart_page_attribute (string ps_page_class, string ps_attribute)
public function string treatment_type_soap_display_rule (string ps_treatment_type)
public function str_c_assessment_definition get_assessment (string ps_assessment_id)
public function string location_domain_description (string ps_location_domain)
public function string office_description (string ps_office_id)
public function string treatment_type_followup_workplan_type (string ps_treatment_type)
public function integer observation_branch_child_ordinal (long pl_branch_id)
public function integer display_script (long pl_display_script_id, ref str_display_script pstr_display_script)
public function string display_script_description (long pl_display_script_id)
public function long get_display_script_id (string ps_format_object, string ps_object_key)
public function long load_display_script_selection ()
public function long load_c_property ()
public function integer update_preference (string ps_preference_type, string ps_preference_level, string ps_preference_key, string ps_preference_id, string ps_preference_value)
public function string computer_description (long pl_computer_id)
public function long load_progress_types ()
public function long progress_types (string ps_context_object, string ps_context_object_type, ref str_progress_type pstr_progress_types[])
public function integer progress_type (string ps_context_object, string ps_context_object_type, string ps_progress_type, ref str_progress_type pstr_progress_type)
public function integer progress_types_soap (string ps_context_object, string ps_context_object_type, ref str_progress_type pstr_progress_type[])
public function string consultant_field (string ps_consultant_id, string ps_field_name)
public function string object_icon (string ps_context_object, string ps_object_type)
public function string encounter_type_button (string ps_encounter_type)
public function string extension_open_command (string ps_extension)
public function string object_type_description (string ps_context_object, string ps_object_type)
public function string service_id (string ps_service)
public function str_c_workplan get_workplan (long pl_workplan_id)
public function long load_folder_selection ()
public function string get_folder_selection (string ps_context_object, string ps_object_type, string ps_attachment_type, string ps_extension)
public function str_folder_list get_folder_selections (string ps_context_object, string ps_object_type, string ps_attachment_type, string ps_extension)
public function string stage_description (string ps_observation_id, long pl_stage)
public function str_property find_property (string ps_context_object, string ps_property)
public function str_property find_property (long pl_property_id)
public function long load_offices ()
public function string office_field (string ps_office_id, string ps_field_name)
private function str_property get_property (long pl_row)
public function str_menu_item get_menu_item (long pl_menu_id, long pl_menu_item_id)
public function integer get_offices (ref str_c_office pstr_office[])
public function integer get_office (string ps_office_id, ref str_c_office pstr_office)
public function long service_count (string ps_user_id, string ps_office_id)
public function datetime last_table_update (string ps_table)
public function str_room get_room (string ps_room_id)
public function string treatment_type_field (string ps_treatment_type, string ps_field_name)
public function string menu_context_object (long pl_menu_id)
public function string extension_edit_command (string ps_extension)
public function long load_display_scripts ()
public function str_location_domain find_location_domain (string ps_location_domain)
public function long load_location_domains ()
public function str_c_attachment_extension extension (string ps_file)
public function string office_address (string ps_office_id)
public function string get_preference_d (string ps_preference_type, string ps_preference_id)
public function str_maintenance_rule get_maintenance_rule (long pl_maintenance_rule_id)
public function string assessment_acuteness (string ps_assessment_id)
public function str_c_xml_class get_xml_class (string ps_xml_class)
public function long load_vial_types ()
public function string vial_type_description (string ps_vial_type)
public function str_c_xml_code_list xml_lookup_code_by_epro (string ps_epro_domain, string ps_epro_id, long pl_owner_id)
public function boolean get_preference_boolean (string ps_preference_type, string ps_preference_id, boolean pb_default_value)
public function string encounter_type_coding_mode (string ps_encounter_type)
public function string encounter_type_new_list_id (string ps_encounter_type)
public function string encounter_type_est_list_id (string ps_encounter_type)
private function integer get_menu_items (ref str_menu pstr_menu)
public function long consultant_owner_id (string ps_consultant_id)
public function string consultant_from_owner_id (long pl_owner_id)
public subroutine check_table_update ()
public function str_menu get_menu (long pl_menu_id, boolean pb_authorized_only)
public function string treatment_type_id (string ps_treatment_type)
public function string assessment_property (string ps_assessment_id, string ps_property)
public function str_priorities get_priorities ()
public function string priority_bitmap (integer pi_priority)
public function integer load_priorities ()
public function string priority_sound_file (integer pi_priority)
public function string assessment_type_property (string ps_assessment_type, string ps_property)
public function datetime last_table_update (string ps_table, boolean pb_reselect_now)
public function long load_xml_class ()
public function integer xml_class (string ps_xml_class, ref str_c_xml_class pstr_c_xml_class)
public function long xml_class_config_object_creator_script (string ps_config_object)
public function long load_config_object_types ()
public function str_config_object_type config_object_type_from_key_name (string ps_config_object_key)
private function str_config_object_type config_object_type (long pl_row)
public function str_config_object_type get_config_object_type (string ps_config_object_type)
public function long load_attachment_locations ()
public function long get_attachment_location_assignment (string ps_cpr_id)
public function str_attachment_location get_attachment_location (long pl_attachment_location_id)
public function integer display_script (long pl_display_script_id, ref str_display_script pstr_display_script, boolean pb_include_disabled_commands)
private function integer display_script_actual (long pl_display_script_id, datetime pdt_last_updated, ref str_display_script pstr_display_script, boolean pb_include_disabled_commands)
public function str_display_script display_script_remove_disabled_commands (str_display_script pstr_display_script)
public function str_wp_item_list office_other_office_my_services (string ps_user_id)
private function str_encounter_description office_encounter (string ps_cpr_id, long pl_encounter_id)
public function string authority_type_description (string ps_authority_type)
public function integer get_offices (ref str_c_office pstr_office[], boolean pb_active_only)
public function str_epro_object_definition epro_object_definition (string ps_epro_object)
public function integer find_epro_object_property (string ps_epro_object, string ps_property_name, ref str_property pstr_property)
public function string xml_lookup_code (string ps_epro_domain, string ps_epro_id, long pl_owner_id, string ps_code_domain)
public function long xml_add_mapping (str_c_xml_code pstr_c_xml_code)
public function string xml_lookup_epro_id (long pl_owner_id, string ps_code_domain, string ps_code_version, string ps_code, string ps_description, string ps_epro_domain)
public function string xml_lookup_epro_id (long pl_owner_id, string ps_code_domain, string ps_code, string ps_description, string ps_epro_domain)
public function integer xml_remove_mapping (str_c_xml_code pstr_c_xml_code, boolean pb_remove_all)
public function str_c_xml_code_list xml_get_epro_ids (long pl_owner_id, string ps_code_domain, string ps_code_version, string ps_code)
public function integer set_preference (string ps_preference_type, string ps_preference_level, string ps_preference_key, string ps_preference_id, string ps_preference_value)
private function str_property get_fixed_property (string ps_object, string ps_property)
public function str_room_type room_type (string ps_room_type)
public function long load_room_types ()
public function string age_range_description (long pl_age_range_id)
end prototypes

public function string attachment_button (string ps_attachment_type);string ls_find
long ll_row
string ls_button

if attachment_types.rowcount() <= 0 then load_attachment_types()

ls_find = "attachment_type='" + ps_attachment_type + "'"
ll_row = attachment_types.find(ls_find, 1, attachment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_button)
else
	ls_button = attachment_types.object.button[ll_row]
end if

return ls_button

end function

public function string attachment_button_new (string ps_attachment_type);string ls_find
long ll_row
string ls_button

if attachment_types.rowcount() <= 0 then load_attachment_types()

ls_find = "attachment_type='" + ps_attachment_type + "'"
ll_row = attachment_types.find(ls_find, 1, attachment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_button)
else
	ls_button = attachment_types.object.button_new[ll_row]
end if

return ls_button

end function

public function string attachment_button_not (string ps_attachment_type);string ls_find
long ll_row
string ls_button
long ll_rowcount

ll_rowcount = attachment_types.rowcount()

if ll_rowcount <= 0 then
	load_attachment_types()
	ll_rowcount = attachment_types.rowcount()
end if

ls_find = "attachment_type='" + ps_attachment_type + "'"
ll_row = attachment_types.find(ls_find, 1, attachment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_button)
else
	ls_button = attachment_types.object.button_not[ll_row]
end if

return ls_button

end function

public function string attachment_type_description (string ps_attachment_type);string ls_find
long ll_row
string ls_button

if attachment_types.rowcount() <= 0 then load_attachment_types()

ls_find = "attachment_type='" + ps_attachment_type + "'"
ll_row = attachment_types.find(ls_find, 1, attachment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_button)
else
	ls_button = attachment_types.object.description[ll_row]
end if

return ls_button

end function

public function string encounter_type_default_role (string ps_encounter_type);string ls_find
long ll_row
string ls_role

if encounter_types.rowcount() <= 0 then load_encounter_types()

ls_find = "encounter_type='" + ps_encounter_type + "'"
ll_row = encounter_types.find(ls_find, 1, encounter_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_role)
else
	ls_role = encounter_types.object.default_role[ll_row]
end if

return ls_role

end function

public function string encounter_type_description (string ps_encounter_type);string ls_find
long ll_row
string ls_description

if encounter_types.rowcount() <= 0 then load_encounter_types()

ls_find = "encounter_type='" + ps_encounter_type + "'"
ll_row = encounter_types.find(ls_find, 1, encounter_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = encounter_types.object.description[ll_row]
end if

return ls_description

end function

public function boolean encounter_type_is_valid (string ps_encounter_type);string ls_find
long ll_row
string ls_description

if encounter_types.rowcount() <= 0 then load_encounter_types()

ls_find = "encounter_type='" + ps_encounter_type + "'"
ll_row = encounter_types.find(ls_find, 1, encounter_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	return false
else
	return true
end if


end function

public function string encounter_type_default_indirect_flag (string ps_encounter_type);string ls_find
long ll_row
string ls_default_indirect_flag

if encounter_types.rowcount() <= 0 then load_encounter_types()

ls_find = "encounter_type='" + ps_encounter_type + "'"
ll_row = encounter_types.find(ls_find, 1, encounter_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_default_indirect_flag)
else
	ls_default_indirect_flag = encounter_types.object.default_indirect_flag[ll_row]
end if

return ls_default_indirect_flag

end function

public function string observation_observation_type (string ps_observation_id);string ls_find
long ll_row
string ls_observation_type

ll_row = find_observation(ps_observation_id)

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_observation_type)
else
	ls_observation_type = observations.object.observation_type[ll_row]
end if

return ls_observation_type

end function

public function string observation_category_description (string ps_observation_type, string ps_observation_category_id);string ls_find
long ll_row
string ls_description

if observation_categories.rowcount() <= 0 then load_observation_categories()

ls_find = "observation_type='" + ps_observation_type + "'"
ls_find += " AND observation_category_id='" + ps_observation_category_id + "'"
ll_row = observation_categories.find(ls_find, 1, observation_categories.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = observation_categories.object.description[ll_row]
end if

return ls_description

end function

public function string observation_observation_category_id (string ps_observation_id);string ls_find
long ll_row
string ls_observation_category_id

ll_row = find_observation(ps_observation_id)

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_observation_category_id)
else
	ls_observation_category_id = observations.object.observation_category_id[ll_row]
end if

return ls_observation_category_id

end function

public function string observation_description (string ps_observation_id);string ls_find
long ll_row
string ls_description

ll_row = find_observation(ps_observation_id)

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = observations.object.description[ll_row]
end if

return ls_description

end function

public function string specialty_description (string ps_specialty_id);string ls_find
long ll_row
string ls_description

if specialties.rowcount() <= 0 then load_specialties()

ls_find = "specialty_id='" + ps_specialty_id + "'"
ll_row = specialties.find(ls_find, 1, specialties.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = specialties.object.description[ll_row]
end if

return ls_description

end function

public function string observation_perform_location_domain (string ps_observation_id);string ls_find
long ll_row
string ls_perform_location_domain

ll_row = find_observation(ps_observation_id)

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_perform_location_domain)
else
	ls_perform_location_domain = observations.object.perform_location_domain[ll_row]
end if

return ls_perform_location_domain

end function

public function string first_location (string ps_location_domain);str_location_domain lstr_location_domain
string ls_location

//lstr_location_domain = find_location_domain(ps_location_domain)
//
//
//if locations.rowcount() <= 0 then load_locations()
//
//locations.setfilter("location_domain='" + ps_location_domain + "'")
//locations.filter()
//
//if locations.rowcount() <= 0 then
//	setnull(ls_location)
//else
//	locations.setsort("sort_sequence A")
//	locations.sort()
//	ls_location = locations.object.location[1]
//end if
//
//locations.setfilter("")
//locations.filter()

return ls_location

end function

public function string observation_exclusive_flag (string ps_observation_id);string ls_find
long ll_row
string ls_exclusive_flag

ll_row = find_observation(ps_observation_id)

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_exclusive_flag)
else
	ls_exclusive_flag = observations.object.exclusive_flag[ll_row]
end if

return ls_exclusive_flag

end function

public function string domain_item_description (string ps_domain_id, string ps_domain_item);string ls_find
long ll_row
string ls_description

if domain_items.rowcount() <= 0 then load_domain_items()

ls_find = "domain_id='" + ps_domain_id + "'"
ls_find += " and domain_item='" + ps_domain_item + "'"

ll_row = domain_items.find(ls_find, 1, domain_items.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = domain_items.object.domain_item_description[ll_row]
end if

return ls_description

end function

public function string domain_item_bitmap (string ps_domain_id, string ps_domain_item);string ls_find
long ll_row
string ls_bitmap

if domain_items.rowcount() <= 0 then load_domain_items()

ls_find = "domain_id='" + ps_domain_id + "'"
ls_find += " and domain_item='" + ps_domain_item + "'"

ll_row = domain_items.find(ls_find, 1, domain_items.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_bitmap)
else
	ls_bitmap = domain_items.object.domain_item_bitmap[ll_row]
end if

return ls_bitmap

end function

public function integer refresh_observation (string ps_observation_id);long ll_row

//ll_row = find_observation(ps_observation_id)
//if ll_row <= 0 or isnull(ll_row) then return 0
//observations.reselectrow(ll_row)

// msc 11/26/99
// reselectrow isn't working for dynamically created datastores, so for now we'll just
// flush the cache

clear_cache("observations")

return 1

end function

public function integer observation_category_sort_order (string ps_observation_type, string ps_observation_category_id);string ls_find
long ll_row
integer li_sort_order

if observation_categories.rowcount() <= 0 then load_observation_categories()

ls_find = "observation_type='" + ps_observation_type + "'"
ls_find += " AND observation_category_id='" + ps_observation_category_id + "'"
ll_row = observation_categories.find(ls_find, 1, observation_categories.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(li_sort_order)
else
	li_sort_order = observation_categories.object.sort_order[ll_row]
end if

return li_sort_order

end function

public function string observation_category_abbreviation (string ps_observation_type, string ps_observation_category_id);string ls_find
long ll_row
string ls_abbreviation

if observation_categories.rowcount() <= 0 then load_observation_categories()

ls_find = "observation_type='" + ps_observation_type + "'"
ls_find += " AND observation_category_id='" + ps_observation_category_id + "'"
ll_row = observation_categories.find(ls_find, 1, observation_categories.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_abbreviation)
else
	ls_abbreviation = observation_categories.object.abbreviation[ll_row]
end if

return ls_abbreviation

end function

public function string procedure_type_description (string ps_procedure_type);string ls_find
long ll_row
string ls_description

if procedure_types.rowcount() <= 0 then load_procedure_types()

ls_find = "procedure_type='" + ps_procedure_type + "'"
ll_row = procedure_types.find(ls_find, 1, procedure_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = procedure_types.object.description[ll_row]
end if

return ls_description

end function

public function string qualifier_class (long pl_qualifier_domain_category_id);string ls_find
long ll_row
string ls_qualifier_class

if qualifier_domain_categories.rowcount() <= 0 then load_qualifier_domain_categories()

ls_find = "qualifier_domain_category_id=" + string(pl_qualifier_domain_category_id)
ll_row = qualifier_domain_categories.find(ls_find, 1, qualifier_domain_categories.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_qualifier_class)
else
	ls_qualifier_class = qualifier_domain_categories.object.qualifier_class[ll_row]
end if

return ls_qualifier_class

end function

public function long qualifier_domain_category_id (long pl_qualifier_domain_id);string ls_find
long ll_row
long ll_qualifier_domain_category_id

if qualifier_domains.rowcount() <= 0 then load_qualifier_domains()

ls_find = "qualifier_domain_id=" + string(pl_qualifier_domain_id)
ll_row = qualifier_domains.find(ls_find, 1, qualifier_domains.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ll_qualifier_domain_category_id)
else
	ll_qualifier_domain_category_id = qualifier_domains.object.qualifier_domain_category_id[ll_row]
end if

return ll_qualifier_domain_category_id

end function

public function string observation_composite_flag (string ps_observation_id);string ls_find
long ll_row
string ls_composite_flag

ll_row = find_observation(ps_observation_id)

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_composite_flag)
else
	ls_composite_flag = observations.object.composite_flag[ll_row]
end if

return ls_composite_flag

end function

public function string service_component_id (string ps_service);string ls_find
long ll_row
string ls_component_id

if services.rowcount() <= 0 then load_services()

ls_find = "lower(service)='" + lower(ps_service) + "'"
ll_row = services.find(ls_find, 1, services.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	load_services()
	ll_row = services.find(ls_find, 1, services.rowcount())
end if

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_component_id)
else
	ls_component_id = services.object.component_id[ll_row]
end if

return ls_component_id

end function

public function string service_owner_flag (string ps_service);string ls_find
long ll_row
string ls_owner_flag

if services.rowcount() <= 0 then load_services()

ls_find = "service='" + ps_service + "'"
ll_row = services.find(ls_find, 1, services.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	load_services()
	ll_row = services.find(ls_find, 1, services.rowcount())
end if

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_owner_flag)
else
	ls_owner_flag = services.object.owner_flag[ll_row]
end if

return ls_owner_flag

end function

public function string service_close_flag (string ps_service);string ls_find
long ll_row
string ls_close_flag

if services.rowcount() <= 0 then load_services()

ls_find = "service='" + ps_service + "'"
ll_row = services.find(ls_find, 1, services.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	load_services()
	ll_row = services.find(ls_find, 1, services.rowcount())
end if

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_close_flag)
else
	ls_close_flag = services.object.close_flag[ll_row]
end if

return ls_close_flag

end function

public function string service_button (string ps_service);string ls_find
long ll_row
string ls_button

if services.rowcount() <= 0 then load_services()

ls_find = "service='" + ps_service + "'"
ll_row = services.find(ls_find, 1, services.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	load_services()
	ll_row = services.find(ls_find, 1, services.rowcount())
end if

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_button)
else
	ls_button = services.object.button[ll_row]
end if

return ls_button

end function

public function long load_assessment_types ();long ll_rows

assessment_types.set_dataobject("dw_data_assessment_types")

ll_rows = assessment_types.retrieve()

return ll_rows

end function

public function long load_attachment_types ();long ll_rows

attachment_types.set_dataobject("dw_data_attachment_types")

ll_rows = attachment_types.retrieve()

return ll_rows

end function

public function long load_domain_items ();long ll_rows

domain_items.set_dataobject("dw_data_domain_items")

ll_rows = domain_items.retrieve()

return ll_rows

end function

public function long load_encounter_types ();long ll_rows

encounter_types.set_dataobject("dw_data_encounter_types")

ll_rows = encounter_types.retrieve()

return ll_rows

end function

public function long load_locations ();long ll_rows

locations.set_dataobject("dw_data_locations")

ll_rows = locations.retrieve()

return ll_rows

end function

public function long load_observation_categories ();long ll_rows

observation_categories.set_dataobject("dw_data_observation_categories")

ll_rows = observation_categories.retrieve()

return ll_rows

end function

public function long load_procedure_types ();long ll_rows

procedure_types.set_dataobject("dw_data_procedure_types")

ll_rows = procedure_types.retrieve()

return ll_rows

end function

public function long load_qualifier_domain_categories ();long ll_rows

qualifier_domain_categories.set_dataobject("dw_data_qualifier_domain_categories")

ll_rows = qualifier_domain_categories.retrieve()

return ll_rows

end function

public function long load_qualifier_domains ();long ll_rows

qualifier_domains.set_dataobject("dw_data_qualifier_domains")

ll_rows = qualifier_domains.retrieve()

return ll_rows

end function

public function long load_services ();long ll_rows

services.set_dataobject("dw_data_services")

ll_rows = services.retrieve()

return ll_rows

end function

public function long load_specialties ();long ll_rows

specialties.set_dataobject("dw_data_specialties")

ll_rows = specialties.retrieve()

return ll_rows

end function

public function string service_description (string ps_service);string ls_find
long ll_row
string ls_description

if services.rowcount() <= 0 then load_services()

ls_find = "service='" + ps_service + "'"
ll_row = services.find(ls_find, 1, services.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	load_services()
	ll_row = services.find(ls_find, 1, services.rowcount())
end if

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = services.object.description[ll_row]
end if

return ls_description

end function

public function long load_treatment_type_list_def ();long ll_rows

treatment_type_list_def.set_dataobject("dw_data_treatment_type_list_def")

ll_rows = treatment_type_list_def.retrieve()

return ll_rows

end function

public function string encounter_type_bill_flag (string ps_encounter_type);string ls_find
long ll_row
string ls_bill_flag

if encounter_types.rowcount() <= 0 then load_encounter_types()

ls_find = "encounter_type='" + ps_encounter_type + "'"
ll_row = encounter_types.find(ls_find, 1, encounter_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_bill_flag)
else
	ls_bill_flag = encounter_types.object.bill_flag[ll_row]
end if

return ls_bill_flag

end function

public function string observation_default_view (string ps_observation_id);string ls_find
long ll_row
string ls_default_view

ll_row = find_observation(ps_observation_id)

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_default_view)
else
	ls_default_view = observations.object.default_view[ll_row]
end if

return ls_default_view

end function

public function long load_treatment_types ();long ll_rows

treatment_types.set_dataobject("dw_data_treatment_types")

ll_rows = treatment_types.retrieve()

return ll_rows

end function

public function string observation_collection_procedure_id (string ps_observation_id);string ls_find
long ll_row
string ls_collection_procedure_id

ll_row = find_observation(ps_observation_id)

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_collection_procedure_id)
else
	ls_collection_procedure_id = observations.object.collection_procedure_id[ll_row]
end if

return ls_collection_procedure_id

end function

public function string observation_perform_procedure_id (string ps_observation_id);string ls_find
long ll_row
string ls_perform_procedure_id

ll_row = find_observation(ps_observation_id)

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_perform_procedure_id)
else
	ls_perform_procedure_id = observations.object.perform_procedure_id[ll_row]
end if

return ls_perform_procedure_id

end function

public function long load_treatment_type_list ();long ll_rows

treatment_type_list.set_dataobject("dw_data_treatment_type_list")

ll_rows = treatment_type_list.retrieve()

return ll_rows

end function

public function string treatment_type_list_defined_flag (string ps_treatment_list_id, long pl_list_sequence);//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Get the treatment type perform button  from c_treatment_type table. 
//
// Created By:Sumathi Chinnasamy										Creation dt: 04/04/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

String			ls_find
Long				ll_row
String			ls_defined_flag

//If treatment_type_list.rowcount() <= 0 then load_treatment_type_list()

ls_find = "treatment_list_id='" + ps_treatment_list_id + "'"
ls_find += " and list_sequence=" + string(pl_list_sequence)
ll_row = treatment_type_list.find(ls_find, 1, treatment_type_list.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_defined_flag)
else
	ls_defined_flag = treatment_type_list.object.defined_flag[ll_row]
end if

return ls_defined_flag


end function

public function string observation_collection_location_domain (string ps_observation_id);string ls_find
long ll_row
string ls_collection_location_domain

ll_row = find_observation(ps_observation_id)

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_collection_location_domain)
else
	ls_collection_location_domain = observations.object.collection_location_domain[ll_row]
end if

return ls_collection_location_domain

end function

public function string get_preference (string ps_preference_type, string ps_preference_id, string ps_default_value);string ls_preference

ls_preference = get_preference(ps_preference_type, ps_preference_id)
if isnull(ls_preference) then return ps_default_value

return ls_preference

end function

public function long get_preference_int (string ps_preference_type, string ps_preference_id, long pl_default_value);string ls_preference
long ll_preference

ls_preference = get_preference(ps_preference_type, ps_preference_id)
if isnull(ls_preference) then
	return pl_default_value
end if

ll_preference = long(ls_preference)

return ll_preference

end function

public function string assessment_type_icon_open (string ps_assessment_type);string ls_find
long ll_row
string ls_temp

if assessment_types.rowcount() <= 0 then load_assessment_types()

ls_find = "assessment_type='" + ps_assessment_type + "'"
ll_row = assessment_types.find(ls_find, 1, assessment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_temp)
else
	ls_temp = assessment_types.object.icon_open[ll_row]
end if

return ls_temp

end function

public function string assessment_type_icon_closed (string ps_assessment_type);string ls_find
long ll_row
string ls_temp

if assessment_types.rowcount() <= 0 then load_assessment_types()

ls_find = "assessment_type='" + ps_assessment_type + "'"
ll_row = assessment_types.find(ls_find, 1, assessment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_temp)
else
	ls_temp = assessment_types.object.icon_closed[ll_row]
end if

return ls_temp

end function

public function string treatment_type_list_description (string ps_treatment_list_id);//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Get the treatment type perform button  from c_treatment_type table. 
//
// Created By:Sumathi Chinnasamy										Creation dt: 04/04/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

String			ls_find
Long				ll_row
String			ls_description

If treatment_type_list_def.rowcount() <= 0 then load_treatment_type_list_def()

ls_find = "treatment_list_id='" + ps_treatment_list_id + "'"
ll_row = treatment_type_list_def.find(ls_find, 1, treatment_type_list_def.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = treatment_type_list_def.object.description[ll_row]
end if

return ls_description
end function

public function string assessment_type_description (string ps_assessment_type);string ls_find
long ll_row
string ls_temp

if assessment_types.rowcount() <= 0 then load_assessment_types()

ls_find = "assessment_type='" + ps_assessment_type + "'"
ll_row = assessment_types.find(ls_find, 1, assessment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_temp)
else
	ls_temp = assessment_types.object.description[ll_row]
end if

return ls_temp

end function

public function string exam_root_observation_id (long pl_exam_sequence);string ls_root_observation_id
long ll_row

ll_row = find_exam_definition(pl_exam_sequence)
if ll_row <= 0 then
	setnull(ls_root_observation_id)
else
	ls_root_observation_id = exam_definition.object.root_observation_id[ll_row]
end if


return ls_root_observation_id

end function

public function string exam_description (long pl_exam_sequence);string ls_description
long ll_row

ll_row = find_exam_definition(pl_exam_sequence)
if ll_row <= 0 then
	setnull(ls_description)
else
	ls_description = exam_definition.object.description[ll_row]
end if


return ls_description

end function

private function long load_exams ();long ll_rowcount


// It wasn't there, so re-retrieve the rows and look again
exam_definition.set_dataobject("dw_u_exam_definition")
ll_rowcount = exam_definition.retrieve()

return ll_rowcount


end function

private function long find_exam_definition (long pl_exam_sequence);string ls_find
long ll_row
long ll_rowcount

// Count how many there are now
ll_rowcount = exam_definition.rowcount()

if ll_rowcount > 0 then
	// See if the one we're looking for is there
	ls_find = "exam_sequence=" + string(pl_exam_sequence)
	ll_row = exam_definition.find(ls_find, 1, ll_rowcount)
	if ll_row > 0 then return ll_row
end if

// It wasn't there, so re-retrieve the rows and look again
ll_rowcount = load_exams()

ls_find = "exam_sequence=" + string(pl_exam_sequence)
ll_row = exam_definition.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then return ll_row

return 0

end function

public function long load_exam_default_results ();long ll_rows

exam_default_results.set_dataobject("dw_u_exam_default_results")

ll_rows = exam_default_results.retrieve()

return ll_rows

end function

public function integer exam_set_default_results (long pl_exam_sequence, string ps_user_id, long pl_branch_id, str_observation_tree pstr_tree);integer li_sts

tf_begin_transaction(this, "exam_set_default_results()")

// Clear the default results for the tree
li_sts = exam_clear_default_results(pl_exam_sequence, ps_user_id, pstr_tree)
if li_sts < 0 then
	tf_rollback()
	return -1
end if

// Then set the new default results
li_sts = exam_set_tree_default_results(pl_exam_sequence, ps_user_id, pstr_tree)
if li_sts < 0 then
	tf_rollback()
	return -1
end if

li_sts = exam_default_results.update()
if li_sts < 0 then return -1

tf_commit_transaction()

return 1

end function

public function integer exam_set_default_results (long pl_exam_sequence, string ps_user_id, long pl_branch_id, string ps_observation_id, integer pi_default_result_count, str_exam_default_result pstra_default_results[]);integer li_sts

tf_begin_transaction(this, "exam_set_default_results()")

li_sts = exam_clear_default_results(pl_exam_sequence, ps_user_id, pl_branch_id)
if li_sts < 0 then
	tf_rollback()
	return -1
end if

li_sts = exam_set_branch_default_results(pl_exam_sequence, ps_user_id, pl_branch_id, ps_observation_id, pi_default_result_count, pstra_default_results)
if li_sts < 0 then
	tf_rollback()
	return -1
end if

li_sts = exam_default_results.update()
if li_sts < 0 then return -1

tf_commit_transaction()

return 1

end function

private function integer exam_set_tree_default_results (long pl_exam_sequence, string ps_user_id, str_observation_tree pstr_tree);integer i
string ls_composite_flag
integer li_sts

// Loop through all the branches of the tree and set the default results
for i = 1 to pstr_tree.branch_count
	ls_composite_flag = observation_composite_flag(pstr_tree.branch[i].child_observation_id)
	if ls_composite_flag = "Y" then
		// Composite observations have no results so recursively call this method to set
		// the results for the child observations
		li_sts = exam_set_tree_default_results(pl_exam_sequence, ps_user_id, pstr_tree.branch[i].child_observation_tree)
	else
		li_sts = exam_set_branch_default_results(pl_exam_sequence, &
																ps_user_id, &
																pstr_tree.branch[i].branch_id, &
																pstr_tree.branch[i].child_observation_id, &
																pstr_tree.branch[i].default_result_count, &
																pstr_tree.branch[i].default_result)
	end if
next

return 1

end function

private function integer exam_clear_default_results (long pl_exam_sequence, string ps_user_id, str_observation_tree pstr_tree);long i
integer li_sts
string ls_composite_flag

for i = 1 to pstr_tree.branch_count
	ls_composite_flag = observation_composite_flag(pstr_tree.branch[i].child_observation_id)
	if ls_composite_flag = "Y" then
		li_sts = exam_clear_default_results(pl_exam_sequence, ps_user_id, pstr_tree.branch[i].child_observation_tree)
	else
		li_sts = exam_clear_default_results(pl_exam_sequence, ps_user_id, pstr_tree.branch[i].branch_id)
	end if
	if li_sts < 0 then
		log.log(this, "u_list_data.exam_clear_default_results:0013", "Error clearing results", 4)
		return -1
	end if
next


return 1

end function

public function integer exam_clear_defaults (long pl_exam_sequence, string ps_user_id, long pl_branch_id);integer li_sts

li_sts = exam_clear_default_results(pl_exam_sequence, ps_user_id, pl_branch_id)
if li_sts <= 0 then return li_sts

li_sts = exam_default_results.update()

return li_sts


end function

private function integer exam_clear_default_results (long pl_exam_sequence, string ps_user_id, long pl_branch_id);string ls_filter
long ll_rowcount
long i
integer li_sts
string ls_observation_id
str_observation_tree lstr_tree
str_observation_tree_branch lstr_branch
string ls_composite_flag

// Make sure the default results are loaded
ll_rowcount = exam_default_results.rowcount()
if ll_rowcount <= 0 then ll_rowcount = load_exam_default_results()

// See if this branch represents a composite or simple observation
if pl_branch_id > 0 then
	lstr_branch = observation_tree_branch(pl_branch_id)
	ls_observation_id = lstr_branch.child_observation_id
	ls_composite_flag = observation_composite_flag(ls_observation_id)
else
	ls_composite_flag = "N"
end if

if ls_composite_flag = "Y" then
	// For a composite observation, get the entire tree underneath it
	lstr_tree = observation_tree(ls_observation_id, true)
	
	// Clear the default results for all observations in the tree
	li_sts = exam_clear_default_results(pl_exam_sequence, ps_user_id, lstr_tree)
else
	// For a simple observation (or the root), delete the default results for the branch
	ls_filter = "exam_sequence=" + string(pl_exam_sequence)
	ls_filter += " and user_id='" + ps_user_id + "'"
	
	if pl_branch_id > 0 then
		ls_filter += " and branch_id=" + string(pl_branch_id)
	end if
	
	exam_default_results.setfilter(ls_filter)
	exam_default_results.filter()
	
	ll_rowcount = exam_default_results.rowcount()
	
	for i = ll_rowcount to 1 step -1
		exam_default_results.deleterow(i)
	next
	
	exam_default_results.setfilter("")
	exam_default_results.filter()
	
	li_sts = 1
end if


return li_sts

end function

public function long new_exam (string ps_description, string ps_root_observation_id, string ps_default_flag);integer li_sts
long ll_row
long ll_exam_sequence
long ll_rowcount

ll_rowcount = exam_definition.rowcount()
if ll_rowcount <= 0 then ll_rowcount = load_exams()

ll_row = exam_definition.insertrow(0)
exam_definition.object.root_observation_id[ll_row] = ps_root_observation_id
exam_definition.object.description[ll_row] = ps_description
exam_definition.object.default_flag[ll_row] = ps_default_flag

li_sts = exam_definition.update()
if li_sts < 0 then return -1

ll_exam_sequence = exam_definition.object.exam_sequence[ll_row]

return ll_exam_sequence

end function

public function long new_exam (string ps_description, string ps_root_observation_id);return new_exam(ps_description, ps_root_observation_id, "N")

end function

public function long observation_default_exam_sequence (string ps_observation_id);string ls_description
long ll_row
long ll_rowcount
long ll_exam_sequence
string ls_find

ll_rowcount = exam_definition.rowcount()
if ll_rowcount <= 0 then ll_rowcount = load_exams()

ls_find = "root_observation_id='" + ps_observation_id + "'"
ls_find += " and default_flag='Y'"
ll_row = exam_definition.find(ls_find, 1, ll_rowcount)
if ll_row <= 0 then
	ll_exam_sequence = new_exam("Default Exam", ps_observation_id, "Y")
else
	ll_exam_sequence = exam_definition.object.exam_sequence[ll_row]
end if


return ll_exam_sequence

end function

private function long find_assessment (string ps_assessment_id);string ls_find
long ll_row
long ll_rowcount

// Count how many there are now
ll_rowcount = assessment_definition.rowcount()

// See if the one we're looking for is there
ls_find = "assessment_id='" + ps_assessment_id + "'"
ll_row = assessment_definition.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then return ll_row

// It wasn't there, so try to get it from the database
datafind.set_dataobject("dw_c_assessment_definition")
ll_rowcount = datafind.retrieve(ps_assessment_id)
// We didn't find it in the database, so return 0
if ll_rowcount <= 0 then return 0

// We found it in the database, so add it to the cache
ll_row = assessment_definition.insertrow(0)
assessment_definition.object.data[ll_row] = datafind.object.data[1]

return ll_row

end function

public function str_observation_results observation_perform_results (string ps_observation_id);str_observation_results lstr_observation_results
str_observation_results lstr_results
long i

// First, get all the results
lstr_observation_results = observation_results(ps_observation_id)
if isnull(lstr_observation_results.observation_id) then return lstr_observation_results

// Now return only the perform results
lstr_results.observation_id = ps_observation_id
lstr_results.result_count = 0
for i = 1 to lstr_observation_results.result_count
	if lstr_observation_results.result[i].result_type = "PERFORM" then
		lstr_results.result_count += 1
		lstr_results.result[lstr_results.result_count] = lstr_observation_results.result[i]
	end if
next

return lstr_observation_results


end function

public function str_observation_results observation_collect_results (string ps_observation_id);str_observation_results lstr_observation_results
str_observation_results lstr_results
long i

// First, get all the results
lstr_observation_results = observation_results(ps_observation_id)
if isnull(lstr_observation_results.observation_id) then return lstr_observation_results

// Now return only the perform results
lstr_results.observation_id = ps_observation_id
lstr_results.result_count = 0
for i = 1 to lstr_observation_results.result_count
	if lstr_observation_results.result[i].result_type = "COLLECT" then
		lstr_results.result_count += 1
		lstr_results.result[lstr_results.result_count] = lstr_observation_results.result[i]
	end if
next

return lstr_observation_results


end function

public function str_observation_tree observation_tree (string ps_parent_observation_id, boolean pb_get_subtrees);datetime ldt_last_updated

setnull(ldt_last_updated)

return observation_tree(ps_parent_observation_id, pb_get_subtrees, ldt_last_updated)

end function

private function integer exam_default_results (long pl_exam_sequence, ref str_observation_tree_branch pstr_branch);str_default_results lstr_default_results
str_observation_tree lstr_child_tree
integer li_count
integer i
integer li_sts

li_count = 0
pstr_branch.child_observation_tree.branch_count = 0

string ls_composite_flag

ls_composite_flag = observation_composite_flag(pstr_branch.child_observation_id)

if ls_composite_flag = "Y" then
	// If this is a composite branch, then recusively call this function to see if there are any default
	// results below this branch
	lstr_child_tree = observation_tree(pstr_branch.child_observation_id)
	for i = 1 to lstr_child_tree.branch_count
		li_sts = exam_default_results(pl_exam_sequence, lstr_child_tree.branch[i])
		if li_sts > 0 then
			li_count += 1
			pstr_branch.child_observation_tree.branch_count += 1
			pstr_branch.child_observation_tree.branch[pstr_branch.child_observation_tree.branch_count] = lstr_child_tree.branch[i]
		end if
	next
else
	// If this is a simple branch, see if there are any default results for this branch
	lstr_default_results = exam_default_results_simple(pl_exam_sequence, pstr_branch.branch_id)
	pstr_branch.default_result_count = lstr_default_results.default_result_count
	pstr_branch.default_result = lstr_default_results.default_result
	li_count = pstr_branch.default_result_count
end if


return li_count


end function

private function str_observation_tree observation_tree (string ps_parent_observation_id, boolean pb_get_subtrees, datetime pdt_last_updated);str_observation_tree lstr_observation_tree
long ll_row
long ll_tree_index
long i
string ls_composite_flag

lstr_observation_tree.branch_count = 0

// Find the observation and perform the stale-data check
ll_row = find_observation(ps_parent_observation_id, pdt_last_updated)
if ll_row <= 0 then return lstr_observation_tree

// get the actual last_updated value
if isnull(pdt_last_updated) then pdt_last_updated = observations.object.last_updated[ll_row]

ll_tree_index = observations.object.tree_index[ll_row]
if ll_tree_index <= 0 or isnull(ll_tree_index) then
	// The observation didn't have its tree cached, so cache them
	// Set the tree index to the row
	ll_tree_index = ll_row
	if ll_tree_index > observation_tree_cache_count then
		observation_tree_cache_count = ll_tree_index
	end if
	observation_tree_cache[ll_tree_index] = get_observation_tree(ps_parent_observation_id)
	observations.object.tree_index[ll_row] = ll_tree_index
end if

lstr_observation_tree = observation_tree_cache[ll_tree_index]

// If we need to get subtrees then populate the child tree structures
if pb_get_subtrees then
	for i = 1 to lstr_observation_tree.branch_count
		ls_composite_flag = observation_composite_flag(lstr_observation_tree.branch[i].child_observation_id)
		if ls_composite_flag = "Y" then
			lstr_observation_tree.branch[i].child_observation_tree = observation_tree(lstr_observation_tree.branch[i].child_observation_id, true, pdt_last_updated)
		end if
	next
end if


return lstr_observation_tree


end function

public function string observation_tree_branch_parent (long pl_branch_id);string ls_find
long ll_row
string ls_observation_id
string ls_null

setnull(ls_null)

// First get the branch's parent_observation_id
ls_find = "branch_id=" + string(pl_branch_id)
ll_row = observation_tree_lookup.find(ls_find, 1, observation_tree_lookup.rowcount())
if ll_row > 0 then
	ls_observation_id = observation_tree_lookup.object.parent_observation_id[ll_row]
else
	SELECT parent_observation_id
	INTO :ls_observation_id
	FROM c_Observation_Tree
	WHERE branch_id = :pl_branch_id;
	if not tf_check() then return ls_null
	if sqlca.sqlcode = 100 then return ls_null
end if

return ls_observation_id

end function

public function str_observation_tree exam_default_results (long pl_exam_sequence, long pl_branch_id);string ls_root_observation_id
str_observation_tree lstr_results_tree
str_observation_tree lstr_observation_tree
str_observation_tree_branch lstr_branch
integer i
integer li_sts
datetime ldt_last_updated

lstr_results_tree.branch_count = 0

if isnull(pl_branch_id) or pl_branch_id <= 0 then
	ls_root_observation_id = exam_root_observation_id(pl_exam_sequence)
	if isnull(ls_root_observation_id) then return lstr_results_tree
	setnull(ldt_last_updated)
else
	lstr_branch = observation_tree_branch(pl_branch_id)
	if isnull(lstr_branch.child_observation_id) then return lstr_results_tree
	ls_root_observation_id = lstr_branch.child_observation_id
	ldt_last_updated = lstr_branch.last_updated
	
//	ls_root_observation_id = observation_tree_branch_child(pl_branch_id)
//	if isnull(ls_root_observation_id) then return lstr_results_tree
end if

lstr_observation_tree = observation_tree(ls_root_observation_id, false, ldt_last_updated)

for i = 1 to lstr_observation_tree.branch_count
	li_sts = exam_default_results(pl_exam_sequence, lstr_observation_tree.branch[i])
	if li_sts > 0 then
		lstr_results_tree.branch_count += 1
		lstr_results_tree.branch[lstr_results_tree.branch_count] = lstr_observation_tree.branch[i]
	end if
next

return lstr_results_tree

end function

public function long get_preference_int (string ps_preference_type, string ps_preference_id);string ls_preference
long ll_preference

ls_preference = get_preference(ps_preference_type, ps_preference_id)

ll_preference = long(ls_preference)

return ll_preference

end function

public function string menu_description (long pl_menu_id);str_menu lstr_menu
long i
string ls_null

setnull(ls_null)

lstr_menu = get_menu(pl_menu_id)
if lstr_menu.menu_id > 0 then
	return lstr_menu.description
end if


return ls_null


end function

public function str_menu get_menu (long pl_menu_id);// Call the method to get the filtered menu
return get_menu(pl_menu_id, true)

end function

public function long load_external_observations ();long ll_rows

external_observations.set_dataobject("dw_c_external_observation")

ll_rows = external_observations.retrieve("%")

return ll_rows

end function

public function string external_observation (string ps_external_source, string ps_observation_id);string ls_find
long ll_row
string ls_external_observation

if external_observations.rowcount() <= 0 then load_external_observations()

ls_find = "external_source='" + ps_external_source + "'"
ls_find += " and observation_id='" + ps_observation_id + "'"
ll_row = external_observations.find(ls_find, 1, external_observations.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_external_observation)
else
	ls_external_observation = external_observations.object.external_observation[ll_row]
end if

return ls_external_observation

end function

public function string get_edit_list_id (string ps_top_20_user_id, string ps_top_20_code);/////////////////////////////////////////////////////////////////////////////////////////////////////
//
// description: decides which list to show up(personal / common). if the personal list is empty , 
//              depends on users choice it copies common list data to start with.
//
//
//
//
// created by: sumathi asokumar                                                      On:10/08/01
//
//////////////////////////////////////////////////////////////////////////////////////////////////////
String				ls_common_list_id
Long					ll_rows,li_sts

u_ds_data   		lds_top_20_list
str_popup_return	popup_return

lds_top_20_list = Create u_ds_data

lds_top_20_list.set_dataobject("dw_top_20_edit")
ls_common_list_id = current_user.common_list_id()

If ps_top_20_user_id = current_user.user_id Then
	ps_top_20_user_id = ls_common_list_id
Else 
	ps_top_20_user_id = current_user.user_id
	ll_rows = lds_top_20_list.retrieve(ps_top_20_user_id, ps_top_20_code)
	If ll_rows = 0 Then
		Openwithparm(w_pop_yes_no, "Your personal list is empty.  Do you wish to start with the defaults?")
		popup_return = Message.powerobjectparm
		If popup_return.item = "YES" then
			li_sts = f_copy_top_20_common_list(current_user.user_id, ls_common_list_id, ps_top_20_code)
		Else
			ps_top_20_user_id = ls_common_list_id
		End if
	End if
End if
/*
ll_rows = top_20_list.retrieve(ps_top_20_user_id, top_20_code)
If not tf_check() then return -1

For i = 1 to ll_rows
	... records into array of top20 structure
Next
*/
destroy lds_top_20_list
Return ps_top_20_user_id
end function

public function string assessment_icd10_code (string ps_assessment_id);string ls_icd10_code
long ll_row

ll_row = find_assessment(ps_assessment_id)
if ll_row <= 0 then
	setnull(ls_icd10_code)
else
	ls_icd10_code = assessment_definition.object.icd10_code[ll_row]
end if


return ls_icd10_code

end function

public function long load_observation_types ();long ll_rows

observation_types.set_dataobject("dw_c_observation_type")

ll_rows = observation_types.retrieve()

return ll_rows

end function

public function string observation_type_default_composite_flag (string ps_observation_type);string ls_find
long ll_row
string ls_default_composite_flag

if observation_types.rowcount() <= 0 then load_observation_types()

ls_find = "observation_type='" + ps_observation_type + "'"
ll_row = observation_types.find(ls_find, 1, observation_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_default_composite_flag)
else
	ls_default_composite_flag = observation_types.object.default_composite_flag[ll_row]
end if

return ls_default_composite_flag

end function

public function integer observation_type_sort_sequence (string ps_observation_type);string ls_find
long ll_row
integer li_sort_sequence

if observation_types.rowcount() <= 0 then load_observation_types()

ls_find = "observation_type='" + ps_observation_type + "'"
ll_row = observation_types.find(ls_find, 1, observation_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(li_sort_sequence)
else
	li_sort_sequence = observation_types.object.sort_sequence[ll_row]
end if

return li_sort_sequence

end function

public function string assessment_description (string ps_assessment_id);string ls_description
long ll_row

ll_row = find_assessment(ps_assessment_id)
if ll_row <= 0 then
	setnull(ls_description)
else
	ls_description = assessment_definition.object.description[ll_row]
end if


return ls_description

end function

public function str_observation_tree observation_tree (string ps_parent_observation_id);return observation_tree(ps_parent_observation_id, false)

end function

public function str_observation_tree_branch observation_tagged_child (string parent_observation_id, string observation_tag);string ls_observation_id
str_observation_tree lstr_tree
str_observation_tree_branch lstr_branch
integer i

lstr_tree = observation_tree(parent_observation_id)

for i = 1 to lstr_tree.branch_count
	if lstr_tree.branch[i].observation_tag = observation_tag then return lstr_tree.branch[i]
next

// Null out the default return structure
setnull(lstr_branch.branch_id)
setnull(lstr_branch.parent_observation_id)
setnull(lstr_branch.child_observation_id)
setnull(lstr_branch.edit_service)
setnull(lstr_branch.location)
setnull(lstr_branch.result_sequence)
setnull(lstr_branch.result_sequence_2)
setnull(lstr_branch.description)
setnull(lstr_branch.followon_severity)
setnull(lstr_branch.followon_observation_id)
setnull(lstr_branch.observation_tag)
setnull(lstr_branch.sort_sequence)
setnull(lstr_branch.child_ordinal)

return lstr_branch

end function

public function string observation_in_context_flag (string ps_observation_id);string ls_find
long ll_row
string ls_in_context_flag

ll_row = find_observation(ps_observation_id)

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_in_context_flag)
else
	ls_in_context_flag = observations.object.in_context_flag[ll_row]
end if

return ls_in_context_flag

end function

public function long load_extensions ();long ll_rows

extensions.set_dataobject("dw_c_attachment_extension")

ll_rows = extensions.retrieve()

return ll_rows

end function

public function string extension_component_id (string ps_extension);string ls_find
long ll_row
string ls_component_id

if extensions.rowcount() <= 0 then load_extensions()

ls_find = "lower(extension)='" + lower(ps_extension) + "'"
ll_row = extensions.find(ls_find, 1, extensions.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_component_id)
else
	ls_component_id = extensions.object.component_id[ll_row]
end if

return ls_component_id

end function

public function string external_source_component_id (string ps_external_source);long i
str_external_sources lstr_sources
string ls_null

setnull(ls_null)

// If no external_source_type is specified then display all available
lstr_sources = common_thread.get_external_sources(ls_null)

for i = 1 to lstr_sources.external_source_count
	if lower(lstr_sources.external_source[i].external_source) = lower(ps_external_source) then
		return lstr_sources.external_source[i].component_id
	end if
next

return ls_null


end function

public function long external_source_workplan_id (string ps_external_source);long i
str_external_sources lstr_sources
long ll_null
string ls_null

setnull(ll_null)
setnull(ls_null)

// If no external_source_type is specified then display all available
lstr_sources = common_thread.get_external_sources(ls_null)

for i = 1 to lstr_sources.external_source_count
	if lower(lstr_sources.external_source[i].external_source) = lower(ps_external_source) then
		return lstr_sources.external_source[i].workplan_id
	end if
next

return ll_null


end function

public function long external_source_in_office_workplan_id (string ps_external_source);long i
str_external_sources lstr_sources
long ll_null
string ls_null

setnull(ll_null)
setnull(ls_null)

// If no external_source_type is specified then display all available
lstr_sources = common_thread.get_external_sources(ls_null)

for i = 1 to lstr_sources.external_source_count
	if lower(lstr_sources.external_source[i].external_source) = lower(ps_external_source) then
		return lstr_sources.external_source[i].in_office_workplan_id
	end if
next

return ll_null


end function

public function string extension_description (string ps_extension);string ls_find
long ll_row
string ls_description

if extensions.rowcount() <= 0 then load_extensions()

ls_find = "lower(extension)='" + lower(ps_extension) + "'"
ll_row = extensions.find(ls_find, 1, extensions.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = extensions.object.description[ll_row]
end if

return ls_description

end function

public function any service (string ps_service, string ps_field);string ls_find
long ll_row
any la_value
integer li_col

if services.rowcount() <= 0 then load_services()

la_value = ""
setnull(la_value)

ls_find = "service='" + ps_service + "'"
ll_row = services.find(ls_find, 1, services.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	load_services()
	ll_row = services.find(ls_find, 1, services.rowcount())
end if

if ll_row <= 0 or isnull(ll_row) then
	return la_value
else
	li_col = integer(services.describe(ps_field + ".ID"))
	if li_col <= 0 then return la_value
	la_value = services.object.data[ll_row, li_col]
end if

return la_value

end function

public function string service_secure_flag (string ps_service);string ls_find
long ll_row
string ls_secure_flag

SELECT secure_flag
INTO :ls_secure_flag
FROM o_Service
WHERE service = :ps_service;
if not tf_check() then return "Y"
if sqlca.sqlcode = 100 then
	log.log(this, "u_list_data.service_secure_flag:0011", "Service not found (" + ps_service + ")", 3)
	return "Y"
end if

return ls_secure_flag

end function

public function long observation_material_id (string ps_observation_id);string ls_find
long ll_row
long ll_material_id

ll_row = find_observation(ps_observation_id)

if ll_row <= 0 or isnull(ll_row) then
	setnull(ll_material_id)
else
	ll_material_id = observations.object.material_id[ll_row]
end if

return ll_material_id

end function

public function string extension_default_attachment_type (string ps_extension);string ls_find
long ll_row
string ls_default_attachment_type

if extensions.rowcount() <= 0 then load_extensions()

ls_find = "lower(extension)='" + lower(ps_extension) + "'"
ll_row = extensions.find(ls_find, 1, extensions.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_default_attachment_type)
else
	ls_default_attachment_type = extensions.object.default_attachment_type[ll_row]
end if

return ls_default_attachment_type

end function

public function string extension_button (string ps_extension);string ls_find
long ll_row
string ls_button

if extensions.rowcount() <= 0 then load_extensions()

ls_find = "lower(extension)='" + lower(ps_extension) + "'"
ll_row = extensions.find(ls_find, 1, extensions.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_button)
else
	ls_button = extensions.object.button[ll_row]
end if

return ls_button

end function

private function long find_observation (string ps_observation_id);
// Anyone who calls this version of find_observation() doesn't need to perform
// the stale-data check, so pretend the last_updated date is very old
return find_observation(ps_observation_id, datetime(date("1/1/1960"), now()))


end function

public function long load_visit_level_rule ();long ll_rows

visit_level_rule.set_dataobject("dw_em_visit_level_rule")

ll_rows = visit_level_rule.retrieve()

return ll_rows

end function

public function str_default_results exam_default_results_simple (long pl_exam_sequence, long pl_branch_id, string ps_location);integer li_result_sequence

setnull(li_result_sequence)

return exam_default_results_simple(pl_exam_sequence, pl_branch_id, li_result_sequence, ps_location)

end function

public function integer default_locations_in_domain (string ps_location_domain, ref string psa_locations[], ref string psa_descriptions[]);long ll_rows
long i
string ls_find
long ll_row

ll_rows = locations.rowcount()
if ll_rows <= 0 then ll_rows = load_locations()
i = 0

ls_find = "location_domain='" + ps_location_domain + "'"
ls_find += " and status='OK'"
ls_find += " and diffuse_flag='Y'"

// First look for the first "diffuse" location
ll_row = locations.find(ls_find, 1, ll_rows)
if ll_row > 0 then
	psa_locations[1] = locations.object.location[ll_row]
	psa_descriptions[1] = locations.object.description[ll_row]
	return 1
end if

// If we didn't find one, then just get all locations
return locations_in_domain(ps_location_domain, psa_locations, psa_descriptions)

end function

public function string observation_tree_branch_child (long pl_branch_id);string ls_find
long ll_row
string ls_observation_id
string ls_null

setnull(ls_null)

// First get the branch's parent_observation_id
ls_find = "branch_id=" + string(pl_branch_id)
ll_row = observation_tree_lookup.find(ls_find, 1, observation_tree_lookup.rowcount())
if ll_row > 0 then
	ls_observation_id = observation_tree_lookup.object.child_observation_id[ll_row]
else
	SELECT child_observation_id
	INTO :ls_observation_id
	FROM c_Observation_Tree
	WHERE branch_id = :pl_branch_id;
	if not tf_check() then return ls_null
	if sqlca.sqlcode = 100 then return ls_null
end if

return ls_observation_id

end function

public function str_default_results observation_default_results_simple (string ps_observation_id, integer pi_result_sequence, string ps_location);integer i
str_default_results lstr_default_results
string ls_find
long ll_row
long ll_rowcount
boolean lb_found
integer li_result_sequence
string ls_location
string ls_result_flag
string ls_user_id
string ls_result_value
string ls_result_unit
string lsa_locations[]
string lsa_location_descriptions[]
integer li_location_count
string ls_perform_location_domain

lstr_default_results.default_result_count = 0

setnull(ls_result_value)
setnull(ls_result_unit)

ll_rowcount = observation_results.retrieve(ps_observation_id)

if isnull(pi_result_sequence) then
	ls_find = "abnormal_flag='N' and result_type='PERFORM'"
else
	ls_find = "result_sequence=" + string(pi_result_sequence)
end if

ll_row = observation_results.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	li_result_sequence = observation_results.object.result_sequence[ll_row]
else
	return lstr_default_results
end if

if isnull(ps_location) then
	ls_perform_location_domain = observation_perform_location_domain(ps_observation_id)
	
	li_location_count = default_locations_in_domain(ls_perform_location_domain, lsa_locations, lsa_location_descriptions)
	
	for i = 1 to li_location_count
		lstr_default_results.default_result_count += 1
		lstr_default_results.default_result[lstr_default_results.default_result_count].result_sequence = li_result_sequence
		lstr_default_results.default_result[lstr_default_results.default_result_count].location = lsa_locations[i]
		lstr_default_results.default_result[lstr_default_results.default_result_count].user_id = current_user.user_id
		lstr_default_results.default_result[lstr_default_results.default_result_count].result_value = ls_result_value
		lstr_default_results.default_result[lstr_default_results.default_result_count].result_unit = ls_result_unit
	next
else
	lstr_default_results.default_result_count = 1
	lstr_default_results.default_result[1].result_sequence = li_result_sequence
	lstr_default_results.default_result[1].location = ps_location
	lstr_default_results.default_result[1].user_id = current_user.user_id
	lstr_default_results.default_result[1].result_value = ls_result_value
	lstr_default_results.default_result[1].result_unit = ls_result_unit
end if


return lstr_default_results

end function

private function integer exam_set_branch_default_results (long pl_exam_sequence, string ps_user_id, long pl_branch_id, string ps_observation_id, integer pi_default_result_count, str_exam_default_result pstra_default_results[]);string ls_base_find
string ls_find
integer i
long ll_base_row
long ll_row
long ll_rowcount
boolean lb_found[]
string ls_user_id
string ls_next_user_id
integer li_result_sequence
string ls_location
boolean lb_found_result

ll_rowcount = exam_default_results.rowcount()
if ll_rowcount <= 0 then ll_rowcount = load_exam_default_results()

// Initialize the found-array to false
for i = 1 to pi_default_result_count
	lb_found[i] = false
next


// We can assume that all the user's results were deleted just prior to calling this method,
// so we only need to look for the default rows.  Note that if the user is a specialty_id (common_list)
// this logic still works because no existing default rows will be found
// so all the default results will produce new positive rows.
ls_base_find = "exam_sequence=" + string(pl_exam_sequence)
ls_base_find += " and branch_id=" + string(pl_branch_id)
ls_base_find += " and user_id='" + current_user.common_list_id() + "'"


// First add the negative rows for the result/location pairs which exist in the exam's
// default list but do not exist in the user's default results
ll_base_row = exam_default_results.find(ls_base_find, 1, ll_rowcount)
DO WHILE ll_base_row > 0 and ll_base_row <= ll_rowcount
	li_result_sequence = exam_default_results.object.result_sequence[ll_base_row]
	ls_location = exam_default_results.object.location[ll_base_row]
	lb_found_result = false
	for i = 1 to pi_default_result_count
		if pstra_default_results[i].result_sequence = li_result_sequence &
		 and pstra_default_results[i].location = ls_location then
		 	// We found the result/location pair, so mark it
			lb_found[i] = true
			lb_found_result = true
			exit
		end if
	next
	// If we did not find this result in the users results then we must add a negative row
	if not lb_found_result then
		ll_row = exam_default_results.insertrow(0)
		exam_default_results.object.exam_sequence[ll_row] = pl_exam_sequence
		exam_default_results.object.branch_id[ll_row] = pl_branch_id
		exam_default_results.object.result_sequence[ll_row] = li_result_sequence
		exam_default_results.object.location[ll_row] = ls_location
		exam_default_results.object.user_id[ll_row] = ps_user_id
		exam_default_results.object.observation_id[ll_row] = ps_observation_id
		exam_default_results.object.result_flag[ll_row] = "N"
	end if

	// Get the next result
	ll_base_row = exam_default_results.find(ls_base_find, ll_base_row + 1, ll_rowcount + 1)
LOOP

// Then add the positive rows for the result/location pairs which do exist in the default results
for i = 1 to pi_default_result_count
	if not lb_found[i] then
		// The result/location doesn't exist so add it
		ll_row = exam_default_results.insertrow(0)
		exam_default_results.object.exam_sequence[ll_row] = pl_exam_sequence
		exam_default_results.object.branch_id[ll_row] = pl_branch_id
		exam_default_results.object.result_sequence[ll_row] = pstra_default_results[i].result_sequence
		exam_default_results.object.location[ll_row] = pstra_default_results[i].location
		exam_default_results.object.user_id[ll_row] = ps_user_id
		exam_default_results.object.observation_id[ll_row] = ps_observation_id
		exam_default_results.object.result_value[ll_row] = pstra_default_results[i].result_value
		exam_default_results.object.result_unit[ll_row] = pstra_default_results[i].result_unit
		exam_default_results.object.result_flag[ll_row] = "Y"
	end if
next



return 1

end function

public function integer branch_child_ordinal (string parent_observation_id, long branch_id);string ls_observation_id
str_observation_tree lstr_tree
str_observation_tree_branch lstr_branch
integer i

lstr_tree = observation_tree(parent_observation_id)

for i = 1 to lstr_tree.branch_count
	if lstr_tree.branch[i].branch_id = branch_id then return lstr_tree.branch[i].child_ordinal
next

return 0

end function

public function str_default_results exam_default_results_simple (long pl_exam_sequence, long pl_branch_id);integer li_result_sequence
string ls_location

setnull(li_result_sequence)
setnull(ls_location)

return exam_default_results_simple(pl_exam_sequence, pl_branch_id, li_result_sequence, ls_location)

end function

public function str_default_results exam_default_results_simple (long pl_exam_sequence, long pl_branch_id, integer pi_result_sequence);string ls_location

setnull(ls_location)

return exam_default_results_simple(pl_exam_sequence, pl_branch_id, pi_result_sequence, ls_location)

end function

private function str_default_results exam_default_results_simple (long pl_exam_sequence, long pl_branch_id, integer pi_result_sequence, string ps_location);str_default_results lstr_default_results
string ls_find
long ll_row
long ll_rowcount
boolean lb_found
integer li_result_sequence
string ls_location
string ls_result_flag
string ls_user_id
string ls_result_value
string ls_result_unit
string ls_observation_id

lstr_default_results.default_result_count = 0

ll_rowcount = exam_default_results.rowcount()
if ll_rowcount <= 0 then ll_rowcount = load_exam_default_results()

ls_find = "exam_sequence=" + string(pl_exam_sequence)
ls_find += " and branch_id=" + string(pl_branch_id)
ls_find += " and (user_id='" + current_user.common_list_id() + "'"
ls_find += " OR user_id='" + current_user.user_id + "')"

if not isnull(pi_result_sequence) then
	ls_find += " and result_sequence=" + string(pi_result_sequence)
end if

if not isnull(ps_location) then
	ls_find += " and location='" + ps_location + "'"
end if

ll_row = exam_default_results.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	li_result_sequence = exam_default_results.object.result_sequence[ll_row]
	ls_location = exam_default_results.object.location[ll_row]
	ls_result_flag = exam_default_results.object.result_flag[ll_row]
	ls_user_id = exam_default_results.object.user_id[ll_row]
	ls_result_value = exam_default_results.object.result_value[ll_row]
	ls_result_unit = exam_default_results.object.result_unit[ll_row]
	lb_found = false
	
	// See if this is the same result
	if lstr_default_results.default_result_count >= 1 then
		if li_result_sequence = lstr_default_results.default_result[lstr_default_results.default_result_count].result_sequence &
				AND ls_location = lstr_default_results.default_result[lstr_default_results.default_result_count].location then
			
			// We found the same result, so we need to determine whether to use the previous
			// result or this new one or neither
			lb_found = true

			// If the new result is not user-specific then just skip it
			if ls_user_id = current_user.user_id then
				// The new result is user specific so remove the previous result
				lstr_default_results.default_result_count -= 1
				
				// If the result is a "positive" then add this result instead of the previous one
				if ls_result_flag = "Y" then
					lb_found = false
				end if
			end if
		end if
	end if

	// If the new result was not the same as the previous result, then add it
	if not lb_found then
		lstr_default_results.default_result_count += 1
		lstr_default_results.default_result[lstr_default_results.default_result_count].result_sequence = li_result_sequence
		lstr_default_results.default_result[lstr_default_results.default_result_count].location = ls_location
		lstr_default_results.default_result[lstr_default_results.default_result_count].user_id = ls_user_id
		lstr_default_results.default_result[lstr_default_results.default_result_count].result_value = ls_result_value
		lstr_default_results.default_result[lstr_default_results.default_result_count].result_unit = ls_result_unit
	end if
	
	ll_row = exam_default_results.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

return lstr_default_results

end function

public function string treatment_type_list_button (string ps_treatment_list_id);//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Get the treatment type perform button  from c_treatment_type table. 
//
// Created By:Sumathi Chinnasamy										Creation dt: 04/04/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

String			ls_find
Long				ll_row
String			ls_button

If treatment_type_list_def.rowcount() <= 0 then load_treatment_type_list_def()

ls_find = "treatment_list_id='" + ps_treatment_list_id + "'"
ll_row = treatment_type_list_def.find(ls_find, 1, treatment_type_list_def.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_button)
else
	ls_button = treatment_type_list_def.object.button[ll_row]
end if

return ls_button
end function

public function string treatment_type_component (string ps_treatment_type);//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Get the treatment type component from c_treatment_type table. 
//
// Created By:Sumathi Chinnasamy										Creation dt: 03/10/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

String			ls_find
Long				ll_row
String			ls_component

If treatment_types.rowcount() <= 0 then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.find(ls_find, 1, treatment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_component)
else
	ls_component = treatment_types.object.component_id[ll_row]
end if

return ls_component
end function

public function string treatment_type_composite_flag (string ps_treatment_type);//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Get the treatment type component from c_treatment_type table. 
//
// Created By:Sumathi Chinnasamy										Creation dt: 03/10/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

String			ls_find
Long				ll_row
String			ls_composite_flag

If treatment_types.rowcount() <= 0 then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.find(ls_find, 1, treatment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_composite_flag)
else
	ls_composite_flag = treatment_types.object.composite_flag[ll_row]
end if

return ls_composite_flag

end function

public function string treatment_type_define_button (string ps_treatment_type);//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Get the treatment type bitmap from c_treatment_type table. 
//
// Created By:Sumathi Chinnasamy										Creation dt: 04/26/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

String				ls_find, ls_button
Long					ll_row


If treatment_types.Rowcount() <= 0 Then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.Find(ls_find, 1, treatment_types.Rowcount())
If ll_row <= 0 Or Isnull(ll_row) Then
	Setnull(ls_button)
Else
	ls_button = treatment_types.object.button[ll_row]
End if

Return ls_button
end function

public function string treatment_type_define_title (string ps_treatment_type);//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Get the treatment definition title from c_treatment_type table. 
//
// Created By:Sumathi Chinnasamy										Creation dt: 04/26/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

String				ls_find, ls_title
Long					ll_row


If treatment_types.Rowcount() <= 0 Then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.Find(ls_find, 1, treatment_types.Rowcount())
If ll_row <= 0 Or Isnull(ll_row) Then
	Setnull(ls_title)
Else
	ls_title = treatment_types.object.define_title[ll_row]
End if

Return ls_title
end function

public function string treatment_type_description (string ps_treatment_type);string ls_find
long ll_row
string ls_description

if treatment_types.rowcount() <= 0 then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.find(ls_find, 1, treatment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = treatment_types.object.description[ll_row]
end if

return ls_description

end function

public function character treatment_type_followup_flag (string ps_treatment_type);long ll_row
string ls_find
char lc_followup_flag

If treatment_types.rowcount() <= 0 Then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.find(ls_find, 1, treatment_types.rowcount())
If ll_row <= 0 Or isnull(ll_row) Then
	setnull(lc_followup_flag)
Else
	lc_followup_flag = treatment_types.object.followup_flag[ll_row]
End If

Return lc_followup_flag

end function

public function string treatment_type_icon (string ps_treatment_type);//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Get the treatment type icon from c_treatment_type table. 
//
// Created By:Sumathi Chinnasamy										Creation dt: 02/10/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

String				ls_find, ls_icon
Long					ll_row

if upper(ps_treatment_type) = "!COMPOSITE" then
	ls_icon = get_preference("PREFERENCES", "Treatment List Group Icon")
	if isnull(ls_icon) then ls_icon = "iconcomposite.bmp"
else
	If treatment_types.Rowcount() <= 0 Then load_treatment_types()
	
	ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
	ll_row = treatment_types.Find(ls_find, 1, treatment_types.Rowcount())
	If ll_row <= 0 Or Isnull(ll_row) Then
		Setnull(ls_icon)
	Else
		ls_icon = treatment_types.object.icon[ll_row]
	End if
end if

Return ls_icon
end function

public function string treatment_type_observation_type (string ps_treatment_type);long ll_row
string ls_find
string ls_observation_type

If treatment_types.rowcount() <= 0 Then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.find(ls_find, 1, treatment_types.rowcount())
If ll_row <= 0 Or isnull(ll_row) Then
	setnull(ls_observation_type)
Else
	ls_observation_type = treatment_types.object.observation_type[ll_row]
End If

Return ls_observation_type

end function

public function integer treatment_type_sort_sequence (string ps_treatment_type);//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Get the treatment type sort_sequence from c_treatment_type table. 
//
// Created By:Sumathi Chinnasamy										Creation dt: 03/10/2000
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

String			ls_find
Long				ll_row
integer			li_sort_sequence

If treatment_types.rowcount() <= 0 then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.find(ls_find, 1, treatment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(li_sort_sequence)
else
	li_sort_sequence = treatment_types.object.sort_sequence[ll_row]
end if

return li_sort_sequence
end function

public function string external_source_description (string ps_external_source);long i
str_external_sources lstr_sources
string ls_null

setnull(ls_null)

// If no external_source_type is specified then display all available
lstr_sources = common_thread.get_external_sources(ls_null)

for i = 1 to lstr_sources.external_source_count
	if lower(lstr_sources.external_source[i].external_source) = lower(ps_external_source) then
		return lstr_sources.external_source[i].description
	end if
next

return ls_null


end function

public function string external_source_button (string ps_external_source);long i
str_external_sources lstr_sources
string ls_null

setnull(ls_null)

// If no external_source_type is specified then display all available
lstr_sources = common_thread.get_external_sources(ls_null)

for i = 1 to lstr_sources.external_source_count
	if lower(lstr_sources.external_source[i].external_source) = lower(ps_external_source) then
		return lstr_sources.external_source[i].button
	end if
next

return ls_null


end function

public function string observation_display_style (string ps_observation_id);string ls_find
long ll_row
string ls_display_style

ll_row = find_observation(ps_observation_id)

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_display_style)
else
	ls_display_style = observations.object.display_style[ll_row]
end if

return ls_display_style

end function

public function string observation_type_display_style (string ps_observation_type);string ls_find
long ll_row
string ls_display_style

if observation_types.rowcount() <= 0 then load_observation_types()

ls_find = "observation_type='" + ps_observation_type + "'"
ll_row = observation_types.find(ls_find, 1, observation_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_display_style)
else
	ls_display_style = observation_types.object.display_style[ll_row]
end if

return ls_display_style

end function

public subroutine clear_cache (string ps_cache);long ll_count


CHOOSE CASE lower(ps_cache)
	CASE"assessments" 
		assessment_definition.reset()
	CASE"assessment_types" 
		assessment_types.reset()
	CASE"attachment_types" 
		attachment_types.reset()
	CASE"chart_page_attributes" 
		chart_page_attributes.reset()
	CASE"consultants" 
		consultants.reset()
	CASE"display_script_selection" 
		display_script_selection.reset()
	CASE"display_scripts" 
		display_scripts.reset()
	CASE"encounter_types" 
		encounter_types.reset()
	CASE "epro_object"
		ll_count = epro_object.retrieve()
	CASE"menus" , "c_menu"
		menu_cache_count = 0
	CASE"treatment_types" 
		treatment_types.reset()
	CASE"treatment_type_list_def" 
		treatment_type_list_def.reset()
	CASE"treatment_type_list" 
		treatment_type_list.reset()
	CASE"observation_stages" 
		setnull(stage_observation_id)
	CASE"observation_types" , "c_observation_type"
		observation_types.reset()
	CASE"observations" , "c_observation"
		observation_tree.reset()
		observations.reset()
		setnull(stage_observation_id)
	CASE"procedure_types" , "c_procedure_type"
		procedure_types.reset()
	CASE"properties" 
		c_property.reset()
	CASE"observation_categories" 
		observation_categories.reset()
	CASE"specialties" 
		specialties.reset()
	CASE"offices" 
		offices.reset()
	CASE"preferences" 
		ll_count = preferences.retrieve()
		component_manager.clear_cache( )
		common_thread.load_preferences()
		if not isnull(current_user) then
			current_user.get_preferences()
			if not isnull(current_scribe) then
				if current_user.user_id <> current_scribe.user_id then
					current_scribe.get_preferences()
				end if
			end if
		end if
	CASE"progress_types" 
		progress_type_cache_count = 0
		progress_types.reset()
	CASE"property_types" 
		property_types.reset()
	CASE"locations" , "c_location"
		location_domain_cache_count = 0
		location_domains.reset()
	CASE"domain_items" 
		domain_items.reset()
	CASE"qualifier_domains" 
		qualifier_domains.reset()
	CASE"qualifier_domain_categories" 
		qualifier_domain_categories.reset()
	CASE"office_status" 
		setnull(office_last_refresh)
	CASE"xml_class" 
		xml_class.reset()
END CHOOSE



end subroutine

public function long load_property_types ();long ll_rows

property_types.set_dataobject("dw_c_property_type")

ll_rows = property_types.retrieve()

return ll_rows

end function

public function string property_type_description (string ps_property_type);string ls_find
long ll_row
string ls_description

if property_types.rowcount() <= 0 then load_property_types()

ls_find = "property_type='" + ps_property_type + "'"
ll_row = property_types.find(ls_find, 1, property_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = property_types.object.description[ll_row]
end if

return ls_description

end function

public function string property_type_component_id (string ps_property_type);string ls_find
long ll_row
string ls_component_id

if property_types.rowcount() <= 0 then load_property_types()

ls_find = "property_type='" + ps_property_type + "'"
ll_row = property_types.find(ls_find, 1, property_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_component_id)
else
	ls_component_id = property_types.object.component_id[ll_row]
end if

return ls_component_id

end function

public function str_c_observation_result observation_result (string ps_observation_id, integer pi_result_sequence);str_observation_results lstr_results
str_c_observation_result lstr_null_result
long i
long ll_row
long ll_results_index

// First get the results for this observation
lstr_results = observation_results(ps_observation_id)
if not isnull(lstr_results.observation_id) then
	for i = 1 to lstr_results.result_count
		if lstr_results.result[i].result_sequence = pi_result_sequence then return lstr_results.result[i]
	next
end if

// If we didn't find our result then refresh result cache and try again
ll_row = find_observation(ps_observation_id)
if ll_row > 0 then
	ll_results_index = observations.object.results_index[ll_row]
	if ll_results_index > 0 then
		observation_results_cache[ll_results_index] = get_observation_results(ps_observation_id)
		for i = 1 to observation_results_cache[ll_results_index].result_count
			if observation_results_cache[ll_results_index].result[i].result_sequence = pi_result_sequence then return observation_results_cache[ll_results_index].result[i]
		next
	end if
end if

// If we didn't find our result then return a null result
setnull(lstr_null_result.observation_id)
setnull(lstr_null_result.result_sequence)
setnull(lstr_null_result.result_type)
setnull(lstr_null_result.result_unit)
setnull(lstr_null_result.result)
setnull(lstr_null_result.result_amount_flag)
setnull(lstr_null_result.print_result_flag)
setnull(lstr_null_result.severity)
setnull(lstr_null_result.abnormal_flag)
setnull(lstr_null_result.display_mask)
setnull(lstr_null_result.specimen_type)
setnull(lstr_null_result.specimen_amount)
setnull(lstr_null_result.sort_sequence)
setnull(lstr_null_result.status)
setnull(lstr_null_result.normal_range)
setnull(lstr_null_result.property_address)
setnull(lstr_null_result.id)
setnull(lstr_null_result.observation_description)

return lstr_null_result

end function

public function str_observation_results observation_results (string ps_observation_id);str_observation_results lstr_observation_results
long ll_row
long ll_results_index
long i

setnull(lstr_observation_results.observation_id)

ll_row = find_observation(ps_observation_id)
if ll_row <= 0 then return lstr_observation_results

ll_results_index = observations.object.results_index[ll_row]
if ll_results_index <= 0 or isnull(ll_results_index) then
	// The observation didn't have its results cached, so cache them
	// Set the tree index to the row
	ll_results_index = ll_row
	if ll_results_index > observation_results_cache_count then
		observation_results_cache_count = ll_results_index
	end if
	observation_results_cache[ll_results_index] = get_observation_results(ps_observation_id)
	observations.object.results_index[ll_row] = ll_results_index
end if

// Remove the deleted results
lstr_observation_results.observation_id = ps_observation_id
for i = 1 to observation_results_cache[ll_results_index].result_count
	if observation_results_cache[ll_results_index].result[i].status = "OK" then
		lstr_observation_results.result_count += 1
		lstr_observation_results.result[lstr_observation_results.result_count] = observation_results_cache[ll_results_index].result[i]
	end if
next

return lstr_observation_results

end function

private function str_observation_results get_observation_results (string ps_observation_id);long ll_rowcount
str_observation_results lstr_observation_results
long i

ll_rowcount = observation_results.retrieve(ps_observation_id)

lstr_observation_results.observation_id = ps_observation_id
lstr_observation_results.result_count = ll_rowcount

for i = 1 to ll_rowcount
	lstr_observation_results.result[i].observation_id = observation_results.object.observation_id[i]
	lstr_observation_results.result[i].result_sequence = observation_results.object.result_sequence[i]
	lstr_observation_results.result[i].result_type = observation_results.object.result_type[i]
	lstr_observation_results.result[i].result_unit = observation_results.object.result_unit[i]
	lstr_observation_results.result[i].result = observation_results.object.result[i]
	lstr_observation_results.result[i].result_amount_flag = observation_results.object.result_amount_flag[i]
	lstr_observation_results.result[i].print_result_flag = observation_results.object.print_result_flag[i]
	lstr_observation_results.result[i].severity = observation_results.object.severity[i]
	lstr_observation_results.result[i].abnormal_flag = observation_results.object.abnormal_flag[i]
	lstr_observation_results.result[i].specimen_type = observation_results.object.specimen_type[i]
	lstr_observation_results.result[i].specimen_amount = observation_results.object.specimen_amount[i]
	lstr_observation_results.result[i].external_source = observation_results.object.external_source[i]
	lstr_observation_results.result[i].property_id = observation_results.object.property_id[i]
	lstr_observation_results.result[i].service = observation_results.object.service[i]
	lstr_observation_results.result[i].print_result_separator = observation_results.object.print_result_separator[i]
	lstr_observation_results.result[i].unit_preference = observation_results.object.unit_preference[i]
	lstr_observation_results.result[i].sort_sequence = observation_results.object.sort_sequence[i]
	lstr_observation_results.result[i].status = observation_results.object.status[i]
	lstr_observation_results.result[i].display_mask = observation_results.object.display_mask[i]
	lstr_observation_results.result[i].property_address = observation_results.object.property_address[i]
	lstr_observation_results.result[i].normal_range = observation_results.object.normal_range[i]
	lstr_observation_results.result[i].id = observation_results.object.id[i]
	lstr_observation_results.result[i].observation_description = observation_results.object.observation_description[i]
next

return lstr_observation_results

end function

public function string property_type_button (string ps_property_type);string ls_find
long ll_row
string ls_description

if property_types.rowcount() <= 0 then load_property_types()

ls_find = "property_type='" + ps_property_type + "'"
ll_row = property_types.find(ls_find, 1, property_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = property_types.object.description[ll_row]
end if

return ls_description

end function

public function string property_type_icon (string ps_property_type);string ls_find
long ll_row
string ls_icon

if property_types.rowcount() <= 0 then load_property_types()

ls_find = "property_type='" + ps_property_type + "'"
ll_row = property_types.find(ls_find, 1, property_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_icon)
else
	ls_icon = property_types.object.icon[ll_row]
end if

return ls_icon

end function

public function string assessment_assessment_type (string ps_assessment_id);string ls_assessment_type
long ll_row

ll_row = find_assessment(ps_assessment_id)
if ll_row <= 0 then
	setnull(ls_assessment_type)
else
	ls_assessment_type = assessment_definition.object.assessment_type[ll_row]
end if


return ls_assessment_type

end function

public function integer location_sort_sequence (string ps_location);string ls_find
long ll_row
integer li_sort_sequence

if isnull(ps_location) then return 0

// If there aren't any records then load them
if locations.rowcount() <= 0 then load_locations()

// Construct the find string
ls_find = "location='" + ps_location + "'"

// Find the record
ll_row = locations.find(ls_find, 1, locations.rowcount())
if ll_row < 0 then
	// If error, return null
	setnull(li_sort_sequence)
elseif ll_row = 0 then
	// If we didn't find a record then try reloading
	load_locations()
	// The find again
	ll_row = locations.find(ls_find, 1, locations.rowcount())
	if ll_row <= 0 then
		// If not found, return null
		setnull(li_sort_sequence)
	else
		// If found, return sort_sequence
		li_sort_sequence = locations.object.sort_sequence[ll_row]
	end if
else
	// If we found a record then return the sort_sequence
	li_sort_sequence = locations.object.sort_sequence[ll_row]
end if

return li_sort_sequence


end function

public function long load_consultants ();long ll_rows

consultants.set_dataobject("dw_c_consultant")

ll_rows = consultants.retrieve()

return ll_rows

end function

public function string consultant_description (string ps_consultant_id);string ls_find
long ll_row
string ls_description

if consultants.rowcount() <= 0 then load_consultants()

ls_find = "consultant_id='" + ps_consultant_id + "'"
ll_row = consultants.find(ls_find, 1, consultants.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	load_consultants()
	ll_row = consultants.find(ls_find, 1, consultants.rowcount())
	if ll_row <= 0 or isnull(ll_row) then
		setnull(ls_description)
		return ls_description
	end if
end if

ls_description = consultants.object.description[ll_row]

return ls_description

end function

public function string consultant_address (string ps_consultant_id);string ls_find
long ll_row
string ls_address
string ls_address1
string ls_address2
string ls_city
string ls_state
string ls_zip
string ls_cr
string ls_temp

ls_cr = "~r~n"

if consultants.rowcount() <= 0 then load_consultants()

ls_find = "consultant_id='" + ps_consultant_id + "'"
ll_row = consultants.find(ls_find, 1, consultants.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	load_consultants()
	ll_row = consultants.find(ls_find, 1, consultants.rowcount())
	if ll_row <= 0 or isnull(ll_row) then
		setnull(ls_address)
		return ls_address
	end if
end if

ls_address1 = consultants.object.address1[ll_row]
ls_address2 = consultants.object.address2[ll_row]
ls_city = consultants.object.city[ll_row]
ls_state = consultants.object.state[ll_row]
ls_zip = consultants.object.zip[ll_row]

ls_address = ""
if not isnull(ls_address1) then ls_address = ls_address1
if not isnull(ls_address2) then
	if ls_address <> "" then ls_address += ls_cr
	ls_address += ls_address2
end if

// Construct city/state/zip
ls_temp = ""
if not isnull(ls_city) then ls_temp += ls_city
if not isnull(ls_state) then ls_temp += ", " + ls_state
if not isnull(ls_zip) then ls_temp += "  " + ls_zip

if trim(ls_temp) <> "" then
	if ls_address <> "" then ls_address += ls_cr
	ls_address += ls_temp
end if

return ls_address

end function

public function string consultant_phone (string ps_consultant_id);string ls_find
long ll_row
string ls_phone

if consultants.rowcount() <= 0 then load_consultants()

ls_find = "consultant_id='" + ps_consultant_id + "'"
ll_row = consultants.find(ls_find, 1, consultants.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	load_consultants()
	ll_row = consultants.find(ls_find, 1, consultants.rowcount())
	if ll_row <= 0 or isnull(ll_row) then
		setnull(ls_phone)
		return ls_phone
	end if
end if

ls_phone = consultants.object.phone[ll_row]

return ls_phone

end function

public function string extension_default_storage_flag (string ps_extension);string ls_find
long ll_row
string ls_default_storage_flag

if extensions.rowcount() <= 0 then load_extensions()

ls_find = "lower(extension)='" + lower(ps_extension) + "'"
ll_row = extensions.find(ls_find, 1, extensions.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_default_storage_flag)
else
	ls_default_storage_flag = extensions.object.default_storage_flag[ll_row]
end if

return ls_default_storage_flag

end function

public function str_observation_tree_branch observation_branch (string ps_parent_observation_id, string ps_child_observation_id, integer pi_child_ordinal);str_observation_tree lstr_tree
str_observation_tree_branch lstr_branch
integer i
integer li_null
integer li_found

setnull(li_null)
setnull(lstr_branch.branch_id)

lstr_tree = observation_tree(ps_parent_observation_id)

li_found = 0

if isnull(pi_child_ordinal) or pi_child_ordinal <= 0 then pi_child_ordinal = 1

for i = 1 to lstr_tree.branch_count
	if lstr_tree.branch[i].child_observation_id = ps_child_observation_id then
		li_found += 1
		if li_found >= pi_child_ordinal then return lstr_tree.branch[i]	
	end if
next

return lstr_branch

end function

public function string get_preference (string ps_preference_type, string ps_preference_id);string ls_preference_value
string ls_null
string ls_user_id
string ls_find
string ls_encrypted
long ll_row
string ls_preference_d

setnull(ls_null)

if isnull(current_scribe) then
	setnull(ls_user_id)
else
	ls_user_id = current_scribe.user_id
end if

ls_preference_value = sqlca.fn_get_preference(ps_preference_type, ps_preference_id, ls_user_id, gnv_app.computer_id)
if not tf_check() then return ls_null

if isnull(ls_preference_value) then return ls_null
if ls_preference_value = "" then return ls_null

// See if this preference is encrypted
ls_find = "upper(preference_type)='" + upper(ps_preference_type) + "' and upper(preference_id)='" + upper(ps_preference_id) + "'"
ll_row = preferences.find(ls_find, 1, preferences.rowcount())
if ll_row > 0 then
	ls_encrypted = preferences.object.encrypted[ll_row]
	if f_string_to_boolean(ls_encrypted) then
		ls_preference_d = common_thread.eprolibnet4.decryptstring(ls_preference_value, common_thread.key())
		if ls_preference_d = "" then
			setnull(ls_preference_value)
		else
			ls_preference_value = ls_preference_d
		end if
	end if
end if

return ls_preference_value

end function

public function long load_visit_level_rule_item ();long ll_rows

visit_level_rule_item.set_dataobject("dw_em_visit_level_rule_item")

ll_rows = visit_level_rule_item.retrieve()

return ll_rows

end function

public function integer visit_level (string ps_em_documentation_guide, string ps_new_flag, integer pi_history_level, integer pi_exam_level, integer pi_decision_level);long ll_rule_rows
long ll_item_rows
long i, j
long ll_rule_id
long ll_visit_level
string ls_new_flag
long ll_min_em_component_level
long ll_null
boolean lb_rule_satisfied
string ls_em_component
long ll_max_visit_level
integer li_rule_item_count
integer li_actual_item_count
integer li_total_items
string ls_filter
string ls_find
long ll_row

If visit_level_rule.rowcount() <= 0 then load_visit_level_rule()
If visit_level_rule_item.rowcount() <= 0 then load_visit_level_rule_item()

ls_filter = "em_documentation_guide='" + ps_em_documentation_guide + "'"

visit_level_rule.setfilter(ls_filter)
visit_level_rule.filter()

visit_level_rule_item.setfilter(ls_filter)
visit_level_rule_item.filter()

setnull(ll_null)

ll_rule_rows = visit_level_rule.rowcount()
ll_item_rows = visit_level_rule_item.rowcount()

ll_max_visit_level = 0

for i = 1 to ll_rule_rows
	// First make sure that this rule applies
	ls_new_flag = visit_level_rule.object.new_flag[i]
	if not isnull(ls_new_flag) and ls_new_flag <> ps_new_flag then continue
	
	// The get the data about the rule itself
	ll_visit_level = visit_level_rule.object.visit_level[i]
	ll_rule_id = visit_level_rule.object.rule_id[i]
	li_rule_item_count = visit_level_rule.object.item_count[i]
	li_actual_item_count = 0
	li_total_items = 0
	lb_rule_satisfied = false
	
	ls_find = "visit_level=" + string(ll_visit_level) + " and rule_id=" + string(ll_rule_id)
	ll_row = visit_level_rule_item.find(ls_find, 1, ll_item_rows)
	DO WHILE ll_row > 0 and ll_row <= ll_item_rows
		li_total_items += 1
		ls_em_component = visit_level_rule_item.object.em_component[ll_row]
		ll_min_em_component_level = visit_level_rule_item.object.min_em_component_level[ll_row]
		CHOOSE CASE lower(ls_em_component)
			CASE "history"
				if pi_history_level >= ll_min_em_component_level then li_actual_item_count += 1
			CASE "examination"
				if pi_exam_level >= ll_min_em_component_level then li_actual_item_count += 1
			CASE "decision making"
				if pi_decision_level >= ll_min_em_component_level then li_actual_item_count += 1
			CASE ELSE
		END CHOOSE
		
		ll_row = visit_level_rule_item.find(ls_find, ll_row + 1, ll_item_rows + 1)
	LOOP
	
	// If the rule item_count is null then all the items must have been met
	if isnull(li_rule_item_count) then
		if li_actual_item_count >= li_total_items then
			lb_rule_satisfied = true
		end if
	else
		// Otherwise, see if the required number of items were met
		if li_actual_item_count >= li_rule_item_count then
			lb_rule_satisfied = true
		end if
	end if
	
	// If the rule was satisfied then see if this is the highest visit level found so far
	if lb_rule_satisfied then
		if ll_visit_level > ll_max_visit_level then ll_max_visit_level = ll_visit_level
	end if
	
next

// return the highest visit level found
return ll_max_visit_level

end function

public function long load_visit_level ();long ll_rows

visit_level.set_dataobject("dw_em_visit_level")

ll_rows = visit_level.retrieve()

return ll_rows

end function

public function string visit_level_description (long pl_visit_level);string ls_find
long ll_row
string ls_description

if visit_level.rowcount() <= 0 then load_visit_level()

ls_find = "visit_level=" + string(pl_visit_level)
ll_row = visit_level.find(ls_find, 1, visit_level.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = visit_level.object.description[ll_row]
end if

return ls_description

end function

public function string encounter_type_visit_code_group (string ps_encounter_type);string ls_find
long ll_row
string ls_visit_code_group

if encounter_types.rowcount() <= 0 then load_encounter_types()

ls_find = "encounter_type='" + ps_encounter_type + "'"
ll_row = encounter_types.find(ls_find, 1, encounter_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_visit_code_group)
else
	ls_visit_code_group = encounter_types.object.visit_code_group[ll_row]
end if

return ls_visit_code_group

end function

public function long load_em_component_level ();long ll_rows

em_component_level.set_dataobject("dw_em_component_levels")

ll_rows = em_component_level.retrieve()

return ll_rows

end function

public function long load_em_type_level ();long ll_rows

em_type_level.set_dataobject("dw_em_type_levels")

ll_rows = em_type_level.retrieve()

return ll_rows

end function

public function string location_description (string ps_location);string ls_find
long ll_row
string ls_description

// If we're passed in a null, then return null
setnull(ls_description)
if isnull(ps_location) then return ls_description

// If there aren't any records then load them
if locations.rowcount() <= 0 then load_locations()

// Construct the find string
ls_find = "upper(location)='" + upper(ps_location) + "'"

// Find the record
ll_row = locations.find(ls_find, 1, locations.rowcount())
if ll_row < 0 then
	// If error, return null
	setnull(ls_description)
elseif ll_row = 0 then
	// If we didn't find a record then try reloading
	load_locations()
	// The find again
	ll_row = locations.find(ls_find, 1, locations.rowcount())
	if ll_row <= 0 then
		// If not found, return null
		setnull(ls_description)
	else
		// If found, return description
		ls_description = locations.object.description[ll_row]
	end if
else
	// If we found a record then return the description
	ls_description = locations.object.description[ll_row]
end if

return ls_description


end function

public function string location_description (string ps_location_domain, string ps_location);string ls_find
long ll_row
string ls_description

// If we're passed in a null, then return null
setnull(ls_description)
if isnull(ps_location) or isnull(ps_location_domain) then return ls_description

// If there aren't any records then load them
if locations.rowcount() <= 0 then load_locations()

// Construct the find string
ls_find = "upper(location_domain)='" + upper(ps_location_domain) + "'"
ls_find += " and upper(location)='" + upper(ps_location) + "'"

// Find the record
ll_row = locations.find(ls_find, 1, locations.rowcount())
if ll_row < 0 then
	// If error, return null
	setnull(ls_description)
elseif ll_row = 0 then
	// If we didn't find a record then try reloading
	load_locations()
	// The find again
	ll_row = locations.find(ls_find, 1, locations.rowcount())
	if ll_row <= 0 then
		// If not found, return null
		setnull(ls_description)
	else
		// If found, return description
		ls_description = locations.object.description[ll_row]
	end if
else
	// If we found a record then return the description
	ls_description = locations.object.description[ll_row]
end if

return ls_description


end function

public function integer locations_in_domain (string ps_location_domain, ref string psa_locations[], ref string psa_descriptions[]);long i
str_location_domain lstr_location_domain

lstr_location_domain = find_location_domain(ps_location_domain)
if isnull(lstr_location_domain.location_domain) then return 0

for i = 1 to lstr_location_domain.location_count
	psa_locations[i] = lstr_location_domain.location[i].location
	psa_descriptions[i] = lstr_location_domain.location[i].description
next

return lstr_location_domain.location_count


end function

private function str_observation_tree get_observation_tree (string ps_parent_observation_id);string ls_composite_flag
string ls_find
long ll_row
long ll_rowcount
string ls_description
string ls_child_observation_id
str_observation_tree lstr_observation_tree
integer i
integer j
long ll_branch_id

lstr_observation_tree.branch_count = 0

ll_rowcount = observation_tree.retrieve(ps_parent_observation_id)
lstr_observation_tree.branch_count = ll_rowcount
for i = 1 to ll_rowcount
	// Make sure the branch_id is non-zero.
	ll_branch_id = observation_tree.object.branch_id[i]
	if isnull(ll_branch_id) or ll_branch_id <= 0 then
		log.log(this, "u_list_data.get_observation_tree:0020", "Invalid branch_id for parent observation (" + ps_parent_observation_id + ")", 3)
		continue
	end if
	
	// Get child observation_description if branch description is null
	ls_description = observation_tree.object.description[i]
	if isnull(ls_description) then
		ls_child_observation_id = observation_tree.object.child_observation_id[i]
		ls_description = observation_description(ls_child_observation_id)
	end if

	lstr_observation_tree.branch[i].branch_id = ll_branch_id
	lstr_observation_tree.branch[i].parent_observation_id = observation_tree.object.parent_observation_id[i]
	lstr_observation_tree.branch[i].child_observation_id = observation_tree.object.child_observation_id[i]
	lstr_observation_tree.branch[i].edit_service = observation_tree.object.edit_service[i]
	lstr_observation_tree.branch[i].location = observation_tree.object.location[i]
	lstr_observation_tree.branch[i].result_sequence = observation_tree.object.result_sequence[i]
	lstr_observation_tree.branch[i].result_sequence_2 = observation_tree.object.result_sequence_2[i]
	lstr_observation_tree.branch[i].description = ls_description
	lstr_observation_tree.branch[i].followon_severity = observation_tree.object.followon_severity[i]
	lstr_observation_tree.branch[i].followon_observation_id = observation_tree.object.followon_observation_id[i]
	lstr_observation_tree.branch[i].observation_tag = observation_tree.object.observation_tag[i]
	lstr_observation_tree.branch[i].on_results_entered = observation_tree.object.on_results_entered[i]
	lstr_observation_tree.branch[i].unit_preference = observation_tree.object.unit_preference[i]
	lstr_observation_tree.branch[i].sort_sequence = observation_tree.object.sort_sequence[i]
	lstr_observation_tree.branch[i].last_updated = observation_tree.object.last_updated[i]

	// See if this branch is already in the branch cache
	ls_find = "branch_id=" + string(lstr_observation_tree.branch[i].branch_id)
	ll_row = observation_tree_lookup.find(ls_find, 1, observation_tree_lookup.rowcount())
	if ll_row <= 0 then
		ll_row = observation_tree_lookup.insertrow(0)
		observation_tree_lookup.object.branch_id[ll_row] = lstr_observation_tree.branch[i].branch_id
		observation_tree_lookup.object.parent_observation_id[ll_row] = lstr_observation_tree.branch[i].parent_observation_id
		observation_tree_lookup.object.child_observation_id[ll_row] = lstr_observation_tree.branch[i].child_observation_id
	end if

	// Calculate child_ordinal by checking if the same observation_id appeared earlier under the same parent
	lstr_observation_tree.branch[i].child_ordinal = 1
	for j = 1 to i - 1
		if lstr_observation_tree.branch[j].child_observation_id = lstr_observation_tree.branch[i].child_observation_id then
			lstr_observation_tree.branch[i].child_ordinal += 1
		end if
	next
next

return lstr_observation_tree

end function

private function long find_observation (string ps_observation_id, datetime pdt_last_updated);string ls_find
long ll_row
string ls_query
long i, j
long ll_rowcount
long ll_tree_index
long ll_results_index
datetime ldt_last_updated
datetime ldt_cache_last_refreshed
integer li_column_count
long ll_found
date ld_cache_date
time lt_cache_time
str_observation_tree lstr_observation_tree

if isnull(ps_observation_id) then return 0

// Count how many there are now
ll_rowcount = observations.rowcount()

// See if the one we're looking for is there
ls_find = "observation_id='" + ps_observation_id + "'"
ll_row = observations.find(ls_find, 1, ll_rowcount)
if ll_row <= 0 then
	// It wasn't there, so try to get it from the database.  In anticipation of future finds, this retrieve will also get the 1st level children of this observation
	ll_found = observation_find.retrieve(ps_observation_id)
	// We didn't find it in the database, so return 0
	if ll_found <= 0 then return 0

	for i = 1 to ll_found
		// See if the observation already exists
		ls_find = "observation_id='" + string(observation_find.Object.observation_id[i]) + "'"
		ll_row = observations.find(ls_find, 1, ll_rowcount)
		if ll_row <= 0 then
			// It didn't exist so create a new cache record
			ll_row = observations.insertrow(0)
			setnull(ll_tree_index)
			setnull(ll_results_index)
			
			// Copy the observation data into the cache record
			observations.object.data[ll_row] = observation_find.object.data[i]
			
			// preserve the links to the tree cache and the results cache
			observations.object.tree_index[ll_row] = ll_tree_index
			observations.object.results_index[ll_row] = ll_results_index

			// Set the lst_update time to now indicating that we just refreshed from the database
			observations.object.last_updated[ll_row] = datetime(today(), now())
		end if
	next
	// refresh the rowcount ..
	ll_rowcount = observations.rowcount()	
	// Now find the one we're looking for
	ls_find = "observation_id='" + ps_observation_id + "'"
	ll_row = observations.find(ls_find, 1, ll_rowcount)
	if ll_row <= 0 then return 0
end if



return ll_row


end function

public function string em_component_level_description (string ps_em_component, long pl_em_component_level);string ls_find
long ll_row
string ls_description

if em_component_level.rowcount() <= 0 then load_em_component_level()

ls_find = "em_component='" + ps_em_component + "'"
ls_find += " and em_component_level=" + string(pl_em_component_level)
ll_row = em_component_level.find(ls_find, 1, em_component_level.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = em_component_level.object.description[ll_row]
end if

return ls_description

end function

public function string em_type_level_description (string ps_em_component, string ps_em_type, long pl_em_type_level);string ls_find
long ll_row
string ls_description

if em_type_level.rowcount() <= 0 then load_em_type_level()

ls_find = "em_type='" + ps_em_type + "'"
ls_find += " and em_component='" + ps_em_component + "'"
ls_find += " and em_type_level=" + string(pl_em_type_level)
ll_row = em_type_level.find(ls_find, 1, em_type_level.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = em_type_level.object.description[ll_row]
end if

return ls_description

end function

public function long load_external_source_types ();long ll_rows

external_source_types.set_dataobject("dw_c_external_source_type")

ll_rows = external_source_types.retrieve()

return ll_rows

end function

public function string external_source_type_description (string ps_external_source_type);string ls_find
long ll_row
string ls_description

if external_source_types.rowcount() <= 0 then load_external_source_types()

ls_find = "external_source_type='" + ps_external_source_type + "'"
ll_row = external_source_types.find(ls_find, 1, external_source_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = external_source_types.object.description[ll_row]
end if

return ls_description

end function

public function string extension_display_control (string ps_extension);string ls_find
long ll_row
string ls_display_control

if extensions.rowcount() <= 0 then load_extensions()

ls_find = "lower(extension)='" + lower(ps_extension) + "'"
ll_row = extensions.find(ls_find, 1, extensions.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_display_control)
else
	ls_display_control = extensions.object.display_control[ll_row]
end if

return ls_display_control

end function

public function str_observation_tree_branch observation_tree_branch (string ps_parent_observation_id, long pl_branch_id);string ls_find
long ll_row
long ll_rowcount
string ls_description
str_observation_tree lstr_tree
str_observation_tree_branch lstr_branch
integer i

// Null out the default return structure
setnull(lstr_branch.branch_id)
setnull(lstr_branch.parent_observation_id)
setnull(lstr_branch.child_observation_id)
setnull(lstr_branch.edit_service)
setnull(lstr_branch.location)
setnull(lstr_branch.result_sequence)
setnull(lstr_branch.result_sequence_2)
setnull(lstr_branch.description)
setnull(lstr_branch.followon_severity)
setnull(lstr_branch.followon_observation_id)
setnull(lstr_branch.observation_tag)
setnull(lstr_branch.sort_sequence)
setnull(lstr_branch.child_ordinal)

// If a null parent is passed in but a valid branch_id, then look up the parent
if isnull(ps_parent_observation_id) and pl_branch_id > 0 then
	ps_parent_observation_id = observation_tree_branch_parent(pl_branch_id)
end if

// Check for null parent
if isnull(ps_parent_observation_id) or isnull(pl_branch_id) or pl_branch_id <= 0 then return lstr_branch

// Then find the parent's observation tree
lstr_tree = observation_tree(ps_parent_observation_id)

// Now loop through the branches and find the one we're looking for
for i = 1 to lstr_tree.branch_count
	if lstr_tree.branch[i].branch_id = pl_branch_id then return lstr_tree.branch[i]
next

// If we didn't find the one we're looking for, return the null branch structure
return lstr_branch



end function

public function integer observation_tree_branch_update (str_observation_tree_branch pstr_branch);integer li_sts
long ll_row
long ll_tree_index
long i
long ll_rowcount
string ls_find
string ls_child_description
string ls_description

// Find the observation
ll_row = find_observation(pstr_branch.parent_observation_id)
if ll_row <= 0 then return -1

// Get the cached tree index
ll_tree_index = observations.object.tree_index[ll_row]

// If there is no cached tree, then we don't need to update the cache
if ll_tree_index > 0 then
	// Now loop through the branches and find the one we're looking for
	for i = 1 to observation_tree_cache[ll_tree_index].branch_count
		if observation_tree_cache[ll_tree_index].branch[i].branch_id = pstr_branch.branch_id then
			// We found the updated branch in the tree cache, so update it with the passed in branch
			observation_tree_cache[ll_tree_index].branch[i] = pstr_branch
			exit
		end if
	next
end if

// We've updated the cache if necessary, so now update the database
ll_rowcount = observation_tree.retrieve(pstr_branch.parent_observation_id)
ls_find = "branch_id=" + string(pstr_branch.branch_id)
ll_row = observation_tree.find(ls_find, 1, ll_rowcount)
// If we didn't find this branch then return an error
if ll_row <= 0 then
	log.log(this, "u_list_data.observation_tree_branch_update:0035", "Branch not found (" + pstr_branch.parent_observation_id + ", " + string(pstr_branch.branch_id) + ")", 4)
	return -1
end if

ls_description = pstr_branch.description
if not isnull(ls_description) then
	// If the branch description is the same as the child description then set
	// the branch description to null
	ls_child_description = observation_description(pstr_branch.child_observation_id)
	if trim(ls_child_description) = trim(ls_description) then setnull(ls_description)
end if

observation_tree.object.edit_service[ll_row] = pstr_branch.edit_service
observation_tree.object.location[ll_row] = pstr_branch.location
observation_tree.object.result_sequence[ll_row] = pstr_branch.result_sequence
observation_tree.object.result_sequence_2[ll_row] = pstr_branch.result_sequence_2
observation_tree.object.description[ll_row] = ls_description
observation_tree.object.followon_severity[ll_row] = pstr_branch.followon_severity
observation_tree.object.followon_observation_id[ll_row] = pstr_branch.followon_observation_id
observation_tree.object.observation_tag[ll_row] = pstr_branch.observation_tag
observation_tree.object.on_results_entered[ll_row] = pstr_branch.on_results_entered
observation_tree.object.unit_preference[ll_row] = pstr_branch.unit_preference
observation_tree.object.sort_sequence[ll_row] = pstr_branch.sort_sequence
observation_tree.object.last_updated[ll_row] = pstr_branch.last_updated
observation_tree.object.updated_by[ll_row] = current_scribe.user_id

li_sts = observation_tree.update()
if li_sts < 0 then return -1

return 1

end function

private function str_default_results exam_default_result_list (long pl_exam_sequence);str_default_results lstr_default_results
string ls_find
long ll_row
long ll_rowcount
boolean lb_found
integer li_result_sequence
string ls_location
string ls_result_flag
string ls_user_id
string ls_result_value
string ls_result_unit
string ls_observation_id
long ll_branch_id

lstr_default_results.default_result_count = 0

ll_rowcount = exam_default_results.rowcount()
if ll_rowcount <= 0 then ll_rowcount = load_exam_default_results()

ls_find = "exam_sequence=" + string(pl_exam_sequence)
ls_find += " and (user_id='" + current_user.common_list_id() + "'"
ls_find += " OR user_id='" + current_user.user_id + "')"


ll_row = exam_default_results.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	ll_branch_id = exam_default_results.object.branch_id[ll_row]
	ls_observation_id = exam_default_results.object.observation_id[ll_row]
	li_result_sequence = exam_default_results.object.result_sequence[ll_row]
	ls_location = exam_default_results.object.location[ll_row]
	ls_user_id = exam_default_results.object.user_id[ll_row]
	ls_result_value = exam_default_results.object.result_value[ll_row]
	ls_result_unit = exam_default_results.object.result_unit[ll_row]
	ls_result_flag = exam_default_results.object.result_flag[ll_row]
	lb_found = false
	
	// See if this is the same result
	if lstr_default_results.default_result_count >= 1 then
		if li_result_sequence = lstr_default_results.default_result[lstr_default_results.default_result_count].result_sequence &
				AND ls_location = lstr_default_results.default_result[lstr_default_results.default_result_count].location &
				AND ll_branch_id = lstr_default_results.default_result[lstr_default_results.default_result_count].branch_id then
			
			// We found the same result, so we need to determine whether to use the previous
			// result or this new one or neither
			lb_found = true

			// If the new result is not user-specific then just skip it
			if ls_user_id = current_user.user_id then
				// The new result is user specific so remove the previous result
				lstr_default_results.default_result_count -= 1
				
				// If the result is a "positive" then add this result instead of the previous one
				if ls_result_flag = "Y" then
					lb_found = false
				end if
			end if
		end if
	end if

	// If the new result was not the same as the previous result, then add it
	if not lb_found then
		lstr_default_results.default_result_count += 1
		lstr_default_results.default_result[lstr_default_results.default_result_count].result_sequence = li_result_sequence
		lstr_default_results.default_result[lstr_default_results.default_result_count].location = ls_location
		lstr_default_results.default_result[lstr_default_results.default_result_count].user_id = ls_user_id
		lstr_default_results.default_result[lstr_default_results.default_result_count].result_value = ls_result_value
		lstr_default_results.default_result[lstr_default_results.default_result_count].result_unit = ls_result_unit
	end if
	
	ll_row = exam_default_results.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

return lstr_default_results

end function

private function integer load_office_status (ref long pl_room_count, ref long pl_encounter_count, ref long pl_service_count);long ll_rows

// See if we need to refresh the data stores
if secondsafter(office_last_refresh, now()) <= office_refresh_interval then
	pl_room_count = office_rooms.rowcount()
	pl_encounter_count = open_encounters.rowcount()
	pl_service_count = active_services.rowcount()
else
	// refresh the data stores
	
	// Get the groups and rooms in this office
	pl_room_count = office_rooms.retrieve(gnv_app.office_id)
	if pl_room_count < 0 then return -1
	
	// Get all the open encounters
	pl_encounter_count = open_encounters.retrieve('%')
	if pl_encounter_count < 0 then return -1
	
	// Get all the active services
	pl_service_count = active_services.retrieve("Y")
	if pl_service_count < 0 then return -1
	
	// Set the refresh time stamp to now
	office_last_refresh = now()
	
	// Now is a good time to see if any tables have been updated
	check_table_update()
end if


return 1


end function

public function str_room_list office_group_rooms (long pl_group_id);integer li_sts
long ll_room_count
long ll_encounter_count
long ll_service_count
str_room_list lstr_room_list
string ls_room_find
long ll_room_row

li_sts = load_office_status(ll_room_count, ll_encounter_count, ll_service_count)
if li_sts < 0 then
	lstr_room_list.room_count = -1
	return lstr_room_list
end if


// Loop through the rooms which should appear on this tab
ls_room_find = "group_id=" + string(pl_group_id)
ll_room_row = office_rooms.find(ls_room_find, 1, ll_room_count)
DO WHILE ll_room_row > 0 and ll_room_row <= ll_room_count
	lstr_room_list.room_count += 1
	lstr_room_list.room[lstr_room_list.room_count] = office_room(ll_room_row)
	
	// Get the next room in this group
	ll_room_row = office_rooms.find(ls_room_find, ll_room_row + 1, ll_room_count + 1)
LOOP

return lstr_room_list


end function

public function str_wp_item_list office_encounter_services (string ps_cpr_id, long pl_encounter_id);integer li_sts
long ll_room_count
long ll_encounter_count
long ll_wp_item_count
str_wp_item_list lstr_service_list
string ls_service_find
long ll_service_row

li_sts = load_office_status(ll_room_count, ll_encounter_count, ll_wp_item_count)
if li_sts < 0 then
	lstr_service_list.wp_item_count = -1
	return lstr_service_list
end if


// Loop through the services which should appear on this tab
// See if there are any patients in this room
ls_service_find = "cpr_id='" + ps_cpr_id + "'"
ls_service_find += " and encounter_id=" + string(pl_encounter_id)
ls_service_find += " and in_office_flag='Y'"
ll_service_row = active_services.find(ls_service_find, 1, ll_wp_item_count)
DO WHILE ll_service_row > 0 and ll_service_row <= ll_wp_item_count
	lstr_service_list.wp_item_count += 1
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].patient_workplan_id = active_services.object.patient_workplan_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].patient_workplan_item_id = active_services.object.patient_workplan_item_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].cpr_id = active_services.object.cpr_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].encounter_id = active_services.object.encounter_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].ordered_service = active_services.object.ordered_service[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].followup_workplan_id = active_services.object.followup_workplan_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].description = active_services.object.description[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].ordered_by = active_services.object.ordered_by[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].ordered_for = active_services.object.ordered_for[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].priority = active_services.object.priority[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].dispatch_date = active_services.object.dispatch_date[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].owned_by = active_services.object.owned_by[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].begin_date = active_services.object.begin_date[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].status = active_services.object.status[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].room_id = active_services.object.room_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].observation_id = active_services.object.observation_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].result_sequence = active_services.object.result_sequence[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].escalation_date = active_services.object.escalation_date[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].expiration_date = active_services.object.expiration_date[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].minutes = active_services.object.minutes[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].user_id = active_services.object.user_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].computer_id = active_services.object.computer_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].patient_location = active_services.object.patient_location[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].office_id = active_services.object.office_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].result = active_services.object.result[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].result_date_time = active_services.object.result_date_time[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].location = active_services.object.location[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].location_description = active_services.object.location_description[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].result_value = active_services.object.result_value[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].result_unit = active_services.object.result_unit[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].result_amount_flag = active_services.object.result_amount_flag[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].print_result_flag = active_services.object.print_result_flag[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].print_result_separator = active_services.object.print_result_separator[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].abnormal_flag = active_services.object.abnormal_flag[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].abnormal_nature = active_services.object.abnormal_nature[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].severity = active_services.object.severity[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].unit_preference = active_services.object.unit_preference[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].display_mask = active_services.object.display_mask[ll_service_row]
	
	// Get the next service in this group
	ll_service_row = active_services.find(ls_service_find, ll_service_row + 1, ll_wp_item_count + 1)
LOOP


return lstr_service_list


end function

private function str_room office_room (long pl_row);str_room lstr_room

lstr_room.room_id = office_rooms.object.room_id[pl_row]
lstr_room.room_name = office_rooms.object.room_name[pl_row]
lstr_room.room_sequence = office_rooms.object.room_sequence[pl_row]
lstr_room.room_type = office_rooms.object.room_type[pl_row]
lstr_room.room_status = office_rooms.object.room_status[pl_row]
lstr_room.computer_id = office_rooms.object.computer_id[pl_row]
lstr_room.office_id = office_rooms.object.office_id[pl_row]
lstr_room.status = office_rooms.object.status[pl_row]
lstr_room.default_encounter_type = office_rooms.object.default_encounter_type[pl_row]
lstr_room.sort = room_list.room_sort(lstr_room.room_id)
lstr_room.in_room_user_id = office_rooms.object.in_room_user_id[pl_row]
lstr_room.dirty_flag = office_rooms.object.dirty_flag[pl_row]

return lstr_room


end function

public function str_room office_room (string ps_room_id);string ls_find
long ll_row
str_room lstr_room
integer li_sts
long ll_room_count
long ll_encounter_count
long ll_service_count

setnull(lstr_room.room_id)

// Refresh the office status
li_sts = load_office_status(ll_room_count, ll_encounter_count, ll_service_count)
if li_sts < 0 then
	return lstr_room
end if


ls_find = "room_id='" + ps_room_id + "'"
ll_row = office_rooms.find(ls_find, 1, ll_room_count)
if ll_row > 0 then return office_room(ll_row)

return get_room(ps_room_id)


end function

private function str_encounter_description office_encounter (long pl_row);str_encounter_description lstr_encounter

lstr_encounter.cpr_id = open_encounters.object.cpr_id[pl_row]
lstr_encounter.encounter_id = open_encounters.object.encounter_id[pl_row]
lstr_encounter.encounter_date = open_encounters.object.encounter_date[pl_row]
lstr_encounter.encounter_type = open_encounters.object.encounter_type[pl_row]
lstr_encounter.description = open_encounters.object.encounter_description[pl_row]
// Open encounters will always have a null discharge_date
setnull(lstr_encounter.discharge_date)
lstr_encounter.attending_doctor = open_encounters.object.attending_doctor[pl_row]
lstr_encounter.referring_doctor = open_encounters.object.referring_doctor[pl_row]
lstr_encounter.new_flag = open_encounters.object.new_flag[pl_row]
lstr_encounter.billing_posted = false
lstr_encounter.encounter_status = "OPEN"
lstr_encounter.patient_name = open_encounters.object.patient_name[pl_row]
lstr_encounter.patient_location = open_encounters.object.patient_location[pl_row]
lstr_encounter.date_of_birth = date(datetime(open_encounters.object.date_of_birth[pl_row]))
lstr_encounter.color = open_encounters.object.color[pl_row]
lstr_encounter.document_status = open_encounters.object.document_status[pl_row]
	

return lstr_encounter


end function

public function str_encounter_list office_room_encounters (string ps_room_id);integer li_sts
boolean lb_found
long ll_room_count
long ll_encounter_count
long ll_service_count
str_encounter_list lstr_encounter_list
string ls_encounter_find
long ll_encounter_row
string ls_service_find
long ll_service_row
string lsa_rooms[]
integer li_type_count
integer i
string ls_cpr_id
long ll_encounter_id

li_sts = load_office_status(ll_room_count, ll_encounter_count, ll_service_count)
if li_sts < 0 then
	lstr_encounter_list.encounter_count = -1
	return lstr_encounter_list
end if

// Get our list of rooms
if isnull(ps_room_id) then
	li_type_count = 0
	ls_encounter_find = "isnull(patient_location)"
	// If the room_id is null, then we don't want to find any services
	ls_service_find = "1=2"
else
	if left(ps_room_id, 1) = "$" then
		// If we're looking for a room_type, build a find string which
		// includes each room of that type
		li_type_count = room_list.get_rooms_of_type(ps_room_id, lsa_rooms)
	else
		li_type_count = 1
		lsa_rooms[1] = ps_room_id
	end if
	for i = 1 to li_type_count
		if i = 1 then
			ls_service_find = "room_id='" + lsa_rooms[i] + "'"
			ls_encounter_find = "patient_location='" + lsa_rooms[i] + "'"
		else
			ls_service_find += " or room_id='" + lsa_rooms[i] + "'"
			ls_encounter_find += " or patient_location='" + lsa_rooms[i] + "'"
		end if
	next
end if

ls_service_find = "(" + ls_service_find + ") and in_office_flag = 'Y'"

// Loop through the encounters which should appear on this tab
// See if there are any patients in this room
ll_encounter_row = open_encounters.find(ls_encounter_find, 1, ll_encounter_count)
DO WHILE ll_encounter_row > 0 and ll_encounter_row <= ll_encounter_count
	lstr_encounter_list.encounter_count += 1
	lstr_encounter_list.encounter[lstr_encounter_list.encounter_count] = office_encounter(ll_encounter_row)
	
	// Get the next encounter in this group
	ll_encounter_row = open_encounters.find(ls_encounter_find, ll_encounter_row + 1, ll_encounter_count + 1)
LOOP

// Now add to the list any encounters which have services in this room but haven't been found already
ll_service_row = active_services.find(ls_service_find, 1, ll_service_count)
DO WHILE ll_service_row > 0 and ll_service_row <= ll_service_count
	ls_cpr_id = active_services.object.cpr_id[ll_service_row]
	ll_encounter_id = active_services.object.encounter_id[ll_service_row]
	
	// Make sure we don't already have this encounter
	lb_found = false
	for i = 1 to lstr_encounter_list.encounter_count
		if lstr_encounter_list.encounter[i].cpr_id = ls_cpr_id &
		  and lstr_encounter_list.encounter[i].encounter_id = ll_encounter_id then
			lb_found = true
			exit
		end if
	next
	
	if not lb_found then
		lstr_encounter_list.encounter[lstr_encounter_list.encounter_count+1] = office_encounter(ls_cpr_id, ll_encounter_id)
		if not isnull(lstr_encounter_list.encounter[lstr_encounter_list.encounter_count+1].encounter_id) then
			lstr_encounter_list.encounter_count += 1
		end if
	end if
	
	// Get the next encounter in this group
	ll_service_row = active_services.find(ls_service_find, ll_service_row + 1, ll_service_count + 1)
LOOP


return lstr_encounter_list


end function

public function str_observation_tree_branch observation_tree_branch (long pl_branch_id);string ls_observation_id

setnull(ls_observation_id)

return observation_tree_branch(ls_observation_id, pl_branch_id)



end function

public function string assessment_auto_close (string ps_assessment_id);string ls_auto_close
long ll_row

ll_row = find_assessment(ps_assessment_id)
if ll_row <= 0 then
	setnull(ls_auto_close)
else
	ls_auto_close = assessment_definition.object.auto_close[ll_row]
end if


return ls_auto_close

end function

public function string treatment_type_in_office_flag (string ps_treatment_type);string ls_find
long ll_row
string ls_in_office_flag

if treatment_types.rowcount() <= 0 then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.find(ls_find, 1, treatment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	ls_in_office_flag = "N"
else
	ls_in_office_flag = treatment_types.object.in_office_flag[ll_row]
end if

if upper(ls_in_office_flag) = "Y" then
	return "Y"
end if

return "N"



end function

public function string treatment_type_workplan_close_flag (string ps_treatment_type);string ls_find
long ll_row
string ls_workplan_close_flag

if treatment_types.rowcount() <= 0 then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.find(ls_find, 1, treatment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_workplan_close_flag)
else
	ls_workplan_close_flag = treatment_types.object.workplan_close_flag[ll_row]
end if

return ls_workplan_close_flag


end function

public function string treatment_type_referral_specialty_id (string ps_treatment_type);string ls_find
long ll_row
string ls_referral_specialty_id

if treatment_types.rowcount() <= 0 then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.find(ls_find, 1, treatment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_referral_specialty_id)
else
	ls_referral_specialty_id = treatment_types.object.referral_specialty_id[ll_row]
end if

return ls_referral_specialty_id

end function

public function long load_chart_page_attributes ();long ll_rows

chart_page_attributes.set_dataobject("dw_c_chart_page_attribute")

ll_rows = chart_page_attributes.retrieve()

return ll_rows

end function

public function string get_chart_page_attribute (string ps_page_class, string ps_attribute);long ll_count
string ls_value
string ls_find
long ll_row

setnull(ls_value)

ll_count = chart_page_attributes.rowcount()
if ll_count <= 0 then ll_count = load_chart_page_attributes()

ls_find = "page_class='" + ps_page_class + "'"
ls_find += " and attribute='" + ps_attribute + "'"
ll_row = chart_page_attributes.find(ls_find, 1, ll_count)
if ll_row > 0 then
	ls_value = chart_page_attributes.object.value[ll_row]
end if


return ls_value

end function

public function string treatment_type_soap_display_rule (string ps_treatment_type);string ls_find
long ll_row
string ls_soap_display_rule

if treatment_types.rowcount() <= 0 then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.find(ls_find, 1, treatment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_soap_display_rule)
else
	ls_soap_display_rule = treatment_types.object.soap_display_rule[ll_row]
end if

return ls_soap_display_rule

end function

public function str_c_assessment_definition get_assessment (string ps_assessment_id);str_c_assessment_definition lstr_assessment
long ll_row

ll_row = find_assessment(ps_assessment_id)
if ll_row <= 0 then
	setnull(lstr_assessment.assessment_id)
else
	lstr_assessment.assessment_id = assessment_definition.object.assessment_id[ll_row]
	lstr_assessment.assessment_type = assessment_definition.object.assessment_type[ll_row]
	lstr_assessment.assessment_category_id = assessment_definition.object.assessment_category_id[ll_row]
	lstr_assessment.description = assessment_definition.object.description[ll_row]
	lstr_assessment.long_description = assessment_definition.object.long_description[ll_row]
	lstr_assessment.location_domain = assessment_definition.object.location_domain[ll_row]
	lstr_assessment.icd10_code = assessment_definition.object.icd10_code[ll_row]
	lstr_assessment.risk_level = assessment_definition.object.risk_level[ll_row]
	lstr_assessment.complexity = assessment_definition.object.complexity[ll_row]
	lstr_assessment.status = assessment_definition.object.status[ll_row]
	lstr_assessment.auto_close = assessment_definition.object.auto_close[ll_row]
	lstr_assessment.auto_close_interval_amount = assessment_definition.object.auto_close_interval_amount[ll_row]
	lstr_assessment.auto_close_interval_unit = assessment_definition.object.auto_close_interval_unit[ll_row]
	lstr_assessment.acuteness = assessment_definition.object.acuteness[ll_row]
end if


return lstr_assessment




end function

public function string location_domain_description (string ps_location_domain);str_location_domain lstr_location_domain

lstr_location_domain = find_location_domain(ps_location_domain)

return lstr_location_domain.description


end function

public function string office_description (string ps_office_id);return office_field(ps_office_id, "description")

end function

public function string treatment_type_followup_workplan_type (string ps_treatment_type);string ls_child_flag
string ls_followup_workplan_type

setnull(ls_followup_workplan_type)

ls_child_flag = treatment_type_followup_flag(ps_treatment_type)

If upper(ls_child_flag) = "R" Then
	ls_followup_workplan_type = "Referral"
else
	ls_followup_workplan_type = "Followup" 
End If

return ls_followup_workplan_type

end function

public function integer observation_branch_child_ordinal (long pl_branch_id);str_observation_tree lstr_observation_tree
str_observation_tree_branch lstr_observation_tree_branch
long i
integer li_child_ordinal
string ls_observation_id
boolean lb_found
integer li_branch_index

// Initialize the child_ordinal to 1 because that is the default value
li_child_ordinal = 1

// First get the branch so we can find out who the parent is
lstr_observation_tree_branch = observation_tree_branch(pl_branch_id)
if isnull(lstr_observation_tree_branch.parent_observation_id) then return li_child_ordinal

// The get the tree
lstr_observation_tree = observation_tree(lstr_observation_tree_branch.parent_observation_id)

// Find the specified branch within the tree
lb_found = false
for i = 1 to lstr_observation_tree.branch_count
	if lstr_observation_tree.branch[i].branch_id = pl_branch_id then
		ls_observation_id = lstr_observation_tree.branch[i].child_observation_id
		li_branch_index = i
		lb_found = true
		exit
	end if
next

// If we didn't find it then just return
if not lb_found then return li_child_ordinal

// If we found the branch then count how many branches before it have the same child observation_id
for i = 1 to li_branch_index - 1
	if lstr_observation_tree.branch[i].child_observation_id = ls_observation_id then
		li_child_ordinal += 1
	end if
next

return li_child_ordinal



end function

public function integer display_script (long pl_display_script_id, ref str_display_script pstr_display_script);return display_script(pl_display_script_id, pstr_display_script, false)

end function

public function string display_script_description (long pl_display_script_id);str_display_script lstr_script
integer li_sts
string ls_description

li_sts = display_script(pl_display_script_id, lstr_script)
if li_sts <= 0 then 
	setnull(ls_description)
else
	ls_description = lstr_script.context_object + " " + lstr_script.display_script
end if


return ls_description


end function

public function long get_display_script_id (string ps_format_object, string ps_object_key);long ll_display_script_id
long ll_count
string ls_user_id
string ls_object_key
string ls_find
long ll_row

ll_count = display_script_selection.rowcount()
if ll_count <= 0 then ll_count = load_display_script_selection()

setnull(ll_display_script_id)

ps_format_object = trim(lower(ps_format_object))
if trim(ps_object_key) = "" then
	setnull(ps_object_key)
else
	ps_object_key = lower(ps_object_key)
end if

ls_find = "lower(context_object)='" + ps_format_object + "'"
ll_row = display_script_selection.find(ls_find, 1, ll_count)
DO WHILE ll_row > 0 and ll_row <= ll_count
	ls_user_id = display_script_selection.object.user_id[ll_row]
	ls_object_key = lower(display_script_selection.object.object_key[ll_row])
	
	if not isnull(ls_user_id) then
		if ls_user_id <> current_user.user_id and ls_user_id <> current_user.specialty_id then
			ll_row = display_script_selection.find(ls_find, ll_row + 1, ll_count + 1)
			continue
		end if
	end if
	
	if not isnull(ls_object_key) then
		if isnull(ps_object_key) or (ls_object_key <> ps_object_key) then
			ll_row = display_script_selection.find(ls_find, ll_row + 1, ll_count + 1)
			continue
		end if
	end if
	
	ll_display_script_id = display_script_selection.object.display_script_id[ll_row]
	exit
LOOP


return ll_display_script_id



end function

public function long load_display_script_selection ();long ll_rows

display_script_selection.set_dataobject("dw_u_display_script_selection")

ll_rows = display_script_selection.retrieve()

return ll_rows

end function

public function long load_c_property ();long ll_rows
long ll_rows2

c_property.set_dataobject("dw_fn_epro_properties")
c_property_attribute.set_dataobject("dw_c_property_attribute")

ll_rows = c_property.retrieve()
ll_rows2 = c_property_attribute.retrieve()

return ll_rows

end function

public function integer update_preference (string ps_preference_type, string ps_preference_level, string ps_preference_key, string ps_preference_id, string ps_preference_value);return set_preference(ps_preference_type, ps_preference_level, ps_preference_key, ps_preference_id, ps_preference_value)

end function

public function string computer_description (long pl_computer_id);string ls_computername
string ls_logon_id
string ls_null

setnull(ls_null)

SELECT computername, logon_id
INTO :ls_computername, :ls_logon_id
FROM o_Computers
WHERE computer_id = :pl_computer_id;
if not tf_check() then return ls_null
if sqlca.sqlcode = 100 then return ls_null

return ls_computername + "/" + ls_logon_id



end function

public function long load_progress_types ();long ll_rows

progress_types.set_dataobject("dw_sp_fn_object_progress_types")

ll_rows = progress_types.retrieve()

return ll_rows

end function

public function long progress_types (string ps_context_object, string ps_context_object_type, ref str_progress_type pstr_progress_types[]);string ls_find
long ll_row
string ls_icon
long ll_rowcount
long ll_count
long i, j
boolean lb_found

ps_context_object = lower(ps_context_object)
ps_context_object_type =lower(ps_context_object_type)

// Find the context_object stack
lb_found = false
for i = 1 to progress_type_cache_count
	if ps_context_object = progress_type_cache[i].context_object then
		lb_found = true
		exit
	end if
next

if not lb_found then
	progress_type_cache_count += 1
	i = progress_type_cache_count
	progress_type_cache[i].context_object = ps_context_object
end if

// Then look for the object type
lb_found = false
for j = 1 to progress_type_cache[i].progress_types_count
	if progress_type_cache[i].progress_types[j].context_object_type = ps_context_object_type then
		lb_found = true
		exit
	end if
next

if not lb_found then
	progress_type_cache[i].progress_types_count += 1
	j = progress_type_cache[i].progress_types_count
	progress_type_cache[i].progress_types[j].context_object = ps_context_object
	progress_type_cache[i].progress_types[j].context_object_type = ps_context_object_type
	
	// Fill the structure with the progress types
	ll_rowcount = progress_types.rowcount()
	if ll_rowcount <= 0 then ll_rowcount = load_progress_types()
	ll_count = 0
	ls_find = "lower(context_object)='" + ps_context_object + "'"
	ls_find += " and lower(context_object_type)='" + ps_context_object_type + "'"
	ll_row = progress_types.find(ls_find, 1, ll_rowcount)
	DO WHILE ll_row > 0 and ll_row <= ll_rowcount
		ll_count += 1
		progress_type_cache[i].progress_types[j].progress_type[ll_count].progress_type = progress_types.object.progress_type[ll_row]
		progress_type_cache[i].progress_types[j].progress_type[ll_count].display_flag = progress_types.object.display_flag[ll_row]
		progress_type_cache[i].progress_types[j].progress_type[ll_count].display_style = progress_types.object.display_style[ll_row]
		progress_type_cache[i].progress_types[j].progress_type[ll_count].soap_display_style = progress_types.object.soap_display_style[ll_row]
		progress_type_cache[i].progress_types[j].progress_type[ll_count].progress_key_required_flag = progress_types.object.progress_key_required_flag[ll_row]
		progress_type_cache[i].progress_types[j].progress_type[ll_count].progress_key_enumerated_flag = progress_types.object.progress_key_enumerated_flag[ll_row]
		progress_type_cache[i].progress_types[j].progress_type[ll_count].progress_key_object = progress_types.object.progress_key_object[ll_row]
		progress_type_cache[i].progress_types[j].progress_type[ll_count].sort_sequence = progress_types.object.sort_sequence[ll_row]
		
		ll_row = progress_types.find(ls_find, ll_row + 1, ll_rowcount + 1)
	LOOP
	progress_type_cache[i].progress_types[j].progress_type_count = ll_count
end if

pstr_progress_types = progress_type_cache[i].progress_types[j].progress_type

return progress_type_cache[i].progress_types[j].progress_type_count


end function

public function integer progress_type (string ps_context_object, string ps_context_object_type, string ps_progress_type, ref str_progress_type pstr_progress_type);long ll_count
long i
str_progress_type lstr_progress_types[]

ll_count = progress_types(ps_context_object, ps_context_object_type, lstr_progress_types)
for i = 1 to ll_count
	if lower(lstr_progress_types[i].progress_type) = lower(ps_progress_type) then
		pstr_progress_type = lstr_progress_types[i]
		return 1
	end if
next

pstr_progress_type.progress_type = ps_progress_type
pstr_progress_type.display_flag = "N"
setnull(pstr_progress_type.display_style)
setnull(pstr_progress_type.soap_display_style)
pstr_progress_type.progress_key_required_flag = "N"
pstr_progress_type.progress_key_enumerated_flag = "N"
setnull(pstr_progress_type.progress_key_object)
pstr_progress_type.sort_sequence = 0

return 1

end function

public function integer progress_types_soap (string ps_context_object, string ps_context_object_type, ref str_progress_type pstr_progress_type[]);long ll_count
long ll_soap_count
long i
str_progress_type lstr_progress_types[]

ll_count = progress_types(ps_context_object, ps_context_object_type, lstr_progress_types)
ll_soap_count = 0

for i = 1 to ll_count
	if not isnull(lstr_progress_types[i].soap_display_style) then
		ll_soap_count += 1
		pstr_progress_type[ll_soap_count] = lstr_progress_types[i]
	end if
next

return ll_soap_count

end function

public function string consultant_field (string ps_consultant_id, string ps_field_name);string ls_find
long ll_row
string ls_null
string ls_value

setnull(ls_null)

if consultants.rowcount() <= 0 then load_consultants()

ls_find = "consultant_id='" + ps_consultant_id + "'"
ll_row = consultants.find(ls_find, 1, consultants.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	load_consultants()
	ll_row = consultants.find(ls_find, 1, consultants.rowcount())
	if ll_row <= 0 or isnull(ll_row) then
		setnull(ls_value)
		return ls_value
	end if
end if

ls_value = consultants.get_field_value(ll_row, ps_field_name)

return ls_value

end function

public function string object_icon (string ps_context_object, string ps_object_type);
CHOOSE CASE lower(ps_context_object)
	CASE "patient"
		return "button10.bmp"
	CASE "encounter"
		return encounter_type_button(ps_object_type)
	CASE "assessment"
		return assessment_type_icon_open(ps_object_type)
	CASE "treatment"
		return treatment_type_icon(ps_object_type)
	CASE "observation"
		return "button01.bmp"
	CASE "attachment"
		return "button21.bmp"
	CASE ELSE
END CHOOSE

end function

public function string encounter_type_button (string ps_encounter_type);string ls_find
long ll_row
string ls_button

if encounter_types.rowcount() <= 0 then load_encounter_types()

ls_find = "encounter_type='" + ps_encounter_type + "'"
ll_row = encounter_types.find(ls_find, 1, encounter_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_button)
else
	ls_button = encounter_types.object.button[ll_row]
end if

return ls_button

end function

public function string extension_open_command (string ps_extension);string ls_find
long ll_row
string ls_open_command

if extensions.rowcount() <= 0 then load_extensions()

ls_find = "lower(extension)='" + lower(ps_extension) + "'"
ll_row = extensions.find(ls_find, 1, extensions.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_open_command)
else
	ls_open_command = extensions.object.open_command[ll_row]
end if

return ls_open_command

end function

public function string object_type_description (string ps_context_object, string ps_object_type);
CHOOSE CASE lower(ps_context_object)
	CASE "patient", "general"
		return Wordcap(ps_object_type)
	CASE "encounter"
		return encounter_type_description(ps_object_type)
	CASE "assessment"
		return assessment_type_description(ps_object_type)
	CASE "treatment"
		return treatment_type_description(ps_object_type)
	CASE "observation"
		return Wordcap(ps_object_type)
	CASE "attachment"
		return attachment_type_description(ps_object_type)
	CASE ELSE
END CHOOSE

end function

public function string service_id (string ps_service);string ls_find
long ll_row
string ls_id

if services.rowcount() <= 0 then load_services()

ls_find = "service='" + ps_service + "'"
ll_row = services.find(ls_find, 1, services.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	load_services()
	ll_row = services.find(ls_find, 1, services.rowcount())
end if

if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_id)
else
	ls_id = services.object.id[ll_row]
end if

return ls_id

end function

public function str_c_workplan get_workplan (long pl_workplan_id);str_c_workplan lstr_workplan
long ll_rows

ll_rows = workplan.retrieve(pl_workplan_id)
if ll_rows <= 0 then
	setnull(lstr_workplan.workplan_id)
else
	lstr_workplan.workplan_id = workplan.object.workplan_id[1]
	lstr_workplan.workplan_type = workplan.object.workplan_type[1]
	lstr_workplan.treatment_type = workplan.object.treatment_type[1]
	lstr_workplan.in_office_flag = workplan.object.in_office_flag[1]
	lstr_workplan.assessment_id = workplan.object.assessment_id[1]
	lstr_workplan.procedure_id = workplan.object.procedure_id[1]
	lstr_workplan.description = workplan.object.description[1]
	lstr_workplan.encounter_description_flag = workplan.object.encounter_description_flag[1]
	lstr_workplan.specialty_id = workplan.object.specialty_id[1]
end if

return lstr_workplan


end function

public function long load_folder_selection ();long ll_rows

folder_selection.set_dataobject("dw_c_folder_selection")

ll_rows = folder_selection.retrieve()

return ll_rows

end function

public function string get_folder_selection (string ps_context_object, string ps_object_type, string ps_attachment_type, string ps_extension);string ls_folder
long ll_count
string ls_find
long ll_row
string ls_context_object
string ls_object_type
string ls_attachment_type
string ls_extension

ll_count = folder_selection.rowcount()
if ll_count <= 0 then ll_count = load_folder_selection()

setnull(ls_folder)

ps_context_object = trim(lower(ps_context_object))
if trim(ps_object_type) = "" then setnull(ps_object_type)

ls_find = "lower(context_object)='" + ps_context_object + "'"
ll_row = folder_selection.find(ls_find, 1, ll_count)
DO WHILE ll_row > 0 and ll_row <= ll_count
	ls_context_object = folder_selection.object.context_object[ll_row]
	ls_object_type = folder_selection.object.object_type[ll_row]
	ls_attachment_type = folder_selection.object.attachment_type[ll_row]
	ls_extension = folder_selection.object.extension[ll_row]
	
	if not isnull(ls_context_object) then
		if isnull(ps_context_object) or (ls_context_object <> ps_context_object) then
			ll_row = folder_selection.find(ls_find, ll_row + 1, ll_count + 1)
			continue
		end if
	end if
	
	if not isnull(ls_object_type) then
		if isnull(ps_object_type) or (ls_object_type <> ps_object_type) then
			ll_row = folder_selection.find(ls_find, ll_row + 1, ll_count + 1)
			continue
		end if
	end if
	
	if not isnull(ls_attachment_type) then
		if isnull(ps_attachment_type) or (ls_attachment_type <> ps_attachment_type) then
			ll_row = folder_selection.find(ls_find, ll_row + 1, ll_count + 1)
			continue
		end if
	end if
	
	if not isnull(ls_extension) then
		if isnull(ps_extension) or (ls_extension <> ps_extension) then
			ll_row = folder_selection.find(ls_find, ll_row + 1, ll_count + 1)
			continue
		end if
	end if
	
	ls_folder = folder_selection.object.folder[ll_row]
	exit
LOOP


return ls_folder



end function

public function str_folder_list get_folder_selections (string ps_context_object, string ps_object_type, string ps_attachment_type, string ps_extension);string ls_folder
long ll_count
string ls_find
long ll_row
string ls_context_object
string ls_object_type
string ls_attachment_type
string ls_extension
str_folder_list lstr_folders

lstr_folders.folder_count = 0

ll_count = folder_selection.rowcount()
if ll_count <= 0 then ll_count = load_folder_selection()

setnull(ls_folder)

ps_context_object = trim(lower(ps_context_object))
if trim(ps_object_type) = "" then setnull(ps_object_type)

ls_find = "lower(context_object)='" + ps_context_object + "'"
ll_row = folder_selection.find(ls_find, 1, ll_count)
DO WHILE ll_row > 0 and ll_row <= ll_count
	ls_context_object = folder_selection.object.context_object[ll_row]
	ls_object_type = folder_selection.object.object_type[ll_row]
	ls_attachment_type = folder_selection.object.attachment_type[ll_row]
	ls_extension = folder_selection.object.extension[ll_row]
	
	if not isnull(ls_context_object) then
		if isnull(ps_context_object) or (ls_context_object <> ps_context_object) then
			ll_row = folder_selection.find(ls_find, ll_row + 1, ll_count + 1)
			continue
		end if
	end if
	
	if not isnull(ls_object_type) then
		if isnull(ps_object_type) or (ls_object_type <> ps_object_type) then
			ll_row = folder_selection.find(ls_find, ll_row + 1, ll_count + 1)
			continue
		end if
	end if
	
	if not isnull(ls_attachment_type) then
		if isnull(ps_attachment_type) or (ls_attachment_type <> ps_attachment_type) then
			ll_row = folder_selection.find(ls_find, ll_row + 1, ll_count + 1)
			continue
		end if
	end if
	
	if not isnull(ls_extension) then
		if isnull(ps_extension) or (ls_extension <> ps_extension) then
			ll_row = folder_selection.find(ls_find, ll_row + 1, ll_count + 1)
			continue
		end if
	end if
	
	lstr_folders.folder_count += 1
	lstr_folders.folders[lstr_folders.folder_count].folder = folder_selection.object.folder[ll_row]
	lstr_folders.folders[lstr_folders.folder_count].context_object = folder_selection.object.context_object[ll_row]
	lstr_folders.folders[lstr_folders.folder_count].context_object_type = folder_selection.object.context_object_type[ll_row]
	lstr_folders.folders[lstr_folders.folder_count].description = folder_selection.object.description[ll_row]
	lstr_folders.folders[lstr_folders.folder_count].status = folder_selection.object.status[ll_row]
	lstr_folders.folders[lstr_folders.folder_count].sort_sequence = folder_selection.object.sort_sequence[ll_row]
	lstr_folders.folders[lstr_folders.folder_count].workplan_required_flag = folder_selection.object.workplan_required_flag[ll_row]
LOOP


return lstr_folders




end function

public function string stage_description (string ps_observation_id, long pl_stage);long ll_stage_description_count
string ls_find
long ll_row
string ls_stage_description
long ll_pos
long ll_stage

if stage_observation_id = ps_observation_id then
	ll_stage_description_count = observation_stages.rowcount()
else
	stage_observation_id = ps_observation_id
	ll_stage_description_count = observation_stages.retrieve(stage_observation_id)
end if

// search from the end to find the highest stage that's less than or equal to the specified stage
ls_find = "stage<=" + string(pl_stage)
ll_row = observation_stages.find(ls_find, ll_stage_description_count, 1)
if ll_row > 0 then
	ls_stage_description = observation_stages.object.stage_description[ll_row]
	ll_stage = observation_stages.object.stage[ll_row]
else
	ll_stage = 0
	ls_stage_description = "Stage %a%"
end if

// Substitute the absolute stage number
ll_pos = pos(ls_stage_description, "%a%")
if ll_pos > 0 then
	ls_stage_description = replace(ls_stage_description, ll_pos, 3, string(pl_stage))
end if

// Substitute the relative stage number
ll_pos = pos(ls_stage_description, "%r%")
if ll_pos > 0 then
	ls_stage_description = replace(ls_stage_description, ll_pos, 3, string(pl_stage - ll_stage + 1))
end if

return ls_stage_description

end function

public function str_property find_property (string ps_context_object, string ps_property);long i
string ls_find
long ll_row
long ll_null
long ll_rowcount
str_property lstr_property
boolean lb_is_column
u_ds_data luo_data
integer li_column

setnull(ll_null)

// First decide if the specified property is a column of the context object

CHOOSE CASE lower(ps_context_object)
	CASE "patient"
		lb_is_column = property_columns_patient.is_column(ps_property)
	CASE "encounter"
		lb_is_column = property_columns_encounter.is_column(ps_property)
	CASE "assessment"
		lb_is_column = property_columns_assessment.is_column(ps_property)
	CASE "treatment"
		lb_is_column = property_columns_treatment.is_column(ps_property)
END CHOOSE

// If it's not a column, then see if it's a c_Property record
if not lb_is_column then
	ll_rowcount = c_property.rowcount()
	if ll_rowcount <= 0 then ll_rowcount = load_c_property()
	
	ls_find = "lower(epro_object)='" + lower(ps_context_object) + "'"
	ls_find += " and lower(function_name)='" + lower(ps_property) + "'"
	
	ll_row = c_property.find(ls_find, 1, ll_rowcount)
	if ll_row > 0 then return get_property(ll_row)
end if

// If it's a column or not a c_Property record then assume it's a built-in function
setnull(lstr_property.property_id)
lstr_property.property_type = "Built In"
lstr_property.property_object = ps_context_object
lstr_property.description = ps_property
lstr_property.title = ps_property
lstr_property.function_name = ps_property
lstr_property.return_data_type = "string"
setnull(lstr_property.script_language)
setnull(lstr_property.script)
setnull(lstr_property.service)
lstr_property.status = "OK"

return lstr_property


end function

public function str_property find_property (long pl_property_id);long i
string ls_find
long ll_row
long ll_null
long ll_rowcount
str_property lstr_property

setnull(ll_null)

ll_rowcount = c_property.rowcount()
if ll_rowcount <= 0 then ll_rowcount = load_c_property()

ls_find = "property_id=" + string(pl_property_id)

ll_row = c_property.find(ls_find, 1, ll_rowcount)

return get_property(ll_row)

end function

public function long load_offices ();long ll_rows

offices.set_dataobject("dw_c_office")

ll_rows = offices.retrieve()

return ll_rows

end function

public function string office_field (string ps_office_id, string ps_field_name);string ls_find
long ll_row
string ls_null
string ls_value
string ls_city
string ls_state
string ls_zip
string ls_zip_plus4

setnull(ls_null)

if offices.rowcount() <= 0 then load_offices()

if trim(ps_office_id) = "" or isnull(ps_office_id) then ps_office_id = gnv_app.office_id

ls_find = "office_id='" + ps_office_id + "'"
ll_row = offices.find(ls_find, 1, offices.rowcount())
if ll_row <= 0 or isnull(ll_row) then return ls_null


CHOOSE CASE lower(trim(ps_field_name))
	CASE "city_state_zip"
		ls_city = offices.get_field_value(ll_row, "city")
		ls_state = offices.get_field_value(ll_row, "state")
		ls_zip = offices.get_field_value(ll_row, "zip")
		ls_zip_plus4 = offices.get_field_value(ll_row, "zip_plus4")
		if len(ls_city) > 0 then
			ls_value = ls_city
		end if
		if len(ls_state) > 0 then
			if len(ls_value) > 0 then
				ls_value += ", " + ls_state
			else
				ls_value = ls_state
			end if
		end if
		if len(ls_zip) > 0 then
			if len(ls_value) > 0 then
				ls_value += "  " + ls_zip
			else
				ls_value = ls_zip
			end if
		end if
		if len(ls_zip_plus4) > 0 then
			if len(ls_value) > 0 then
				ls_value += "-" + ls_zip_plus4
			else
				ls_value = ls_zip_plus4
			end if
		end if
	CASE ELSE
		ls_value = offices.get_field_value(ll_row, ps_field_name)
END CHOOSE


return ls_value

end function

private function str_property get_property (long pl_row);str_property lstr_property
string ls_filter
long i
string ls_temp

if pl_row > 0 then
	lstr_property.property_id = c_property.object.property_id[pl_row]
	lstr_property.property_type = c_property.object.property_type[pl_row]
	lstr_property.property_object = c_property.object.epro_object[pl_row]
	lstr_property.description = c_property.object.description[pl_row]
	lstr_property.title = c_property.object.title[pl_row]
	lstr_property.function_name = c_property.object.function_name[pl_row]
	lstr_property.return_data_type = c_property.object.return_data_type[pl_row]
	lstr_property.script_language = c_property.object.script_language[pl_row]
	lstr_property.script = c_property.object.script[pl_row]
	lstr_property.service = c_property.object.service[pl_row]
	lstr_property.status = c_property.object.status[pl_row]
	lstr_property.property_value_object = c_property.object.property_value_object[pl_row]
	lstr_property.property_value_object_key = c_property.object.property_value_object_key[pl_row]
	lstr_property.property_value_object_filter = c_property.object.property_value_object_filter[pl_row]
	ls_temp = c_property.object.property_value_object_unique[pl_row]
	lstr_property.property_value_object_unique = f_string_to_boolean(ls_temp)
	lstr_property.property_value_object_cat_fld = c_property.object.property_value_object_cat_field[pl_row]
	lstr_property.property_value_object_cat_qury = c_property.object.property_value_object_cat_query[pl_row]
	lstr_property.property_name = c_property.object.property_name[pl_row]
	lstr_property.property_help = c_property.object.property_help[pl_row]
	lstr_property.sort_sequence = c_property.object.sort_sequence[pl_row]
	
	// Now get the attributes
	ls_filter = "property_id=" + string(lstr_property.property_id)
	c_property_attribute.setfilter(ls_filter)
	c_property_attribute.filter()
	for i = 1 to c_property_attribute.rowcount()
		lstr_property.attributes.attribute[i].attribute = c_property_attribute.object.attribute[i]
		lstr_property.attributes.attribute[i].value = c_property_attribute.object.value[i]
	next
else
	// We didn't find the property so just assume it's a built-in function
	setnull(lstr_property.property_id)
	setnull(lstr_property.property_type)
	setnull(lstr_property.property_object)
	setnull(lstr_property.description)
	setnull(lstr_property.title)
	setnull(lstr_property.function_name)
	setnull(lstr_property.return_data_type)
	setnull(lstr_property.script_language)
	setnull(lstr_property.script)
	setnull(lstr_property.service)
	setnull(lstr_property.status)
	setnull(lstr_property.property_value_object)
	setnull(lstr_property.property_value_object_key)
	setnull(lstr_property.property_value_object_filter)
	setnull(lstr_property.property_value_object_unique)
	setnull(lstr_property.property_value_object_cat_fld)
	setnull(lstr_property.property_value_object_cat_qury)
	setnull(lstr_property.property_name)
	setnull(lstr_property.property_help)
	setnull(lstr_property.sort_sequence)
end if

// Set the property_domain
if len(lstr_property.property_value_object) > 0 then
	lstr_property.property_domain = lstr_property.property_value_object
	if len(lstr_property.property_value_object_key) > 0 then
		lstr_property.property_domain += "." + lstr_property.property_value_object_key
	end if
else
	lstr_property.property_domain = lstr_property.function_name
end if


return lstr_property


end function

public function str_menu_item get_menu_item (long pl_menu_id, long pl_menu_item_id);str_menu lstr_menu
str_menu_item lstr_menu_item
long i

lstr_menu = get_menu(pl_menu_id)
if lstr_menu.menu_id > 0 then
	for i = 1 to lstr_menu.menu_item_count
		if lstr_menu.menu_item[i].menu_item_id = pl_menu_item_id then return lstr_menu.menu_item[i]
	next
end if


setnull(lstr_menu_item.menu_item_id)
setnull(lstr_menu_item.menu_item_type)
setnull(lstr_menu_item.menu_item)
setnull(lstr_menu_item.context_object)
setnull(lstr_menu_item.button_title)
setnull(lstr_menu_item.button_help)
setnull(lstr_menu_item.button)
setnull(lstr_menu_item.sort_sequence)
setnull(lstr_menu_item.auto_close_flag)
setnull(lstr_menu_item.authorized_user_id)
setnull(lstr_menu_item.id)

return lstr_menu_item

end function

public function integer get_offices (ref str_c_office pstr_office[]);return get_offices(pstr_office, true)

end function

public function integer get_office (string ps_office_id, ref str_c_office pstr_office);string ls_find
long ll_row
string ls_null
string ls_value

setnull(ls_null)

if offices.rowcount() <= 0 then load_offices()

if trim(ps_office_id) = "" or isnull(ps_office_id) then ps_office_id = gnv_app.office_id

ls_find = "office_id='" + ps_office_id + "'"
ll_row = offices.find(ls_find, 1, offices.rowcount())
if ll_row <= 0 or isnull(ll_row) then return 0

pstr_office.office_id = offices.object.office_id[ll_row]
pstr_office.description = offices.object.description[ll_row]
pstr_office.address1 = offices.object.address1[ll_row]
pstr_office.address2 = offices.object.address2[ll_row]
pstr_office.city = offices.object.city[ll_row]
pstr_office.state = offices.object.state[ll_row]
pstr_office.zip = offices.object.zip[ll_row]
pstr_office.zip_plus4 = offices.object.zip_plus4[ll_row]
pstr_office.phone = offices.object.phone[ll_row]
pstr_office.fax = offices.object.fax[ll_row]
pstr_office.status = offices.object.status[ll_row]

return 1

end function

public function long service_count (string ps_user_id, string ps_office_id);string ls_find
long ll_row
long ll_count
long ll_rowcount
long ll_room_count
long ll_encounter_count
long ll_service_count
integer li_sts

li_sts = load_office_status(ll_room_count, ll_encounter_count, ll_service_count)
if li_sts < 0 then
	return -1
end if

ll_count = 0
ll_rowcount = active_services.rowcount()

ls_find = "owned_by='" + ps_user_id + "'"
ls_find += " and upper(office_id)='" + upper(ps_office_id) + "'"
ls_find += " and upper(ordered_service) <> 'MESSAGE'"
ll_row = active_services.find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	ll_count += 1
	ll_row = active_services.find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

return ll_count

end function

public function datetime last_table_update (string ps_table);return last_table_update(ps_table, false)

end function

public function str_room get_room (string ps_room_id);str_room lstr_room

SELECT room_id,
	room_name,
	room_sequence,
	room_type,
	room_status,
	computer_id,
	office_id,
	status,
	default_encounter_type,
	COALESCE(dbo.fn_get_specific_preference('SYSTEM', 'Room', room_id, 'sort'), 'Patient'),
	dirty_flag
INTO :lstr_room.room_id,
	:lstr_room.room_name,
	:lstr_room.room_sequence,
	:lstr_room.room_type,
	:lstr_room.room_status,
	:lstr_room.computer_id,
	:lstr_room.office_id,
	:lstr_room.status,
	:lstr_room.default_encounter_type,
	:lstr_room.sort,
	:lstr_room.dirty_flag
FROM o_Rooms
WHERE room_id = :ps_room_id;
if not tf_check() then setnull(lstr_room.room_id)
	

return lstr_room


end function

public function string treatment_type_field (string ps_treatment_type, string ps_field_name);string ls_find
long ll_row
string ls_description

if treatment_types.rowcount() <= 0 then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.find(ls_find, 1, treatment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_description)
else
	ls_description = treatment_types.get_field_value(ll_row, ps_field_name)
end if

return ls_description


end function

public function string menu_context_object (long pl_menu_id);str_menu lstr_menu
long i
string ls_null

setnull(ls_null)

lstr_menu = get_menu(pl_menu_id)
if lstr_menu.menu_id > 0 then
	return lstr_menu.context_object
end if


return ls_null


end function

public function string extension_edit_command (string ps_extension);string ls_find
long ll_row
string ls_edit_command

if extensions.rowcount() <= 0 then load_extensions()

ls_find = "lower(extension)='" + lower(ps_extension) + "'"
ll_row = extensions.find(ls_find, 1, extensions.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_edit_command)
else
	ls_edit_command = extensions.object.edit_command[ll_row]
end if

return ls_edit_command

end function

public function long load_display_scripts ();long ll_rows

display_scripts.set_dataobject("dw_sp_display_script_list")

ll_rows = display_scripts.retrieve()

return ll_rows

end function

public function str_location_domain find_location_domain (string ps_location_domain);long ll_rowcount
long ll_row
string ls_find
str_location_domain lstr_location_domain
long ll_index
string ls_location_domain
long ll_location_row

ll_rowcount = location_domains.rowcount()
if ll_rowcount <= 0 then ll_rowcount = load_location_domains()

ls_find = "upper(location_domain)='" + upper(ps_location_domain) + "'"
ls_find += " and status='OK'"
ll_row = location_domains.find(ls_find, 1, ll_rowcount)
if ll_row <= 0 then
	setnull(lstr_location_domain.location_domain)
	return lstr_location_domain
end if

ll_index = location_domains.object.cache_index[ll_row]
if ll_index > 0 then return location_domain_cache[ll_index]

// If we get here then we found the location_domain but it's not cached yet

// First set up the location_domain structure
lstr_location_domain.location_domain = location_domains.object.location_domain[ll_row]
lstr_location_domain.description = location_domains.object.description[ll_row]
lstr_location_domain.owner_id = location_domains.object.owner_id[ll_row]
lstr_location_domain.status = location_domains.object.status[ll_row]
lstr_location_domain.location_count = 0

// Then add all the locations
ll_rowcount = locations.rowcount()
if ll_rowcount <= 0 then ll_rowcount = load_locations()

ls_find = "upper(location_domain)='" + upper(ps_location_domain) + "'"
ls_find += " and owner_id=" + string(lstr_location_domain.owner_id)
ls_find += " and status='OK'"
ll_location_row = locations.find(ls_find, 1, ll_rowcount)
DO WHILE ll_location_row > 0 and ll_location_row <= ll_rowcount
	// Make sure we're still working on the same location_domain
	ls_location_domain = locations.object.location_domain[ll_location_row]
	if lower(ls_location_domain) <> lower(ps_location_domain) then exit
	if string(locations.object.status[ll_location_row]) = 'OK' then
		lstr_location_domain.location_count += 1
		lstr_location_domain.location[lstr_location_domain.location_count].location = locations.object.location[ll_location_row]
		lstr_location_domain.location[lstr_location_domain.location_count].description = locations.object.description[ll_location_row]
		lstr_location_domain.location[lstr_location_domain.location_count].sort_sequence = locations.object.location[ll_location_row]
		lstr_location_domain.location[lstr_location_domain.location_count].diffuse_flag = locations.object.description[ll_location_row]
		lstr_location_domain.location[lstr_location_domain.location_count].status = locations.object.location[ll_location_row]
	end if
	ll_location_row += 1
LOOP

// Add the location_domain to the cache
location_domain_cache_count += 1
location_domain_cache[location_domain_cache_count] = lstr_location_domain
location_domains.object.cache_index[ll_row] = location_domain_cache_count

return lstr_location_domain



end function

public function long load_location_domains ();long ll_rows

location_domains.set_dataobject("dw_data_location_domains")

ll_rows = location_domains.retrieve()

return ll_rows

end function

public function str_c_attachment_extension extension (string ps_file);string ls_find
long ll_row
string ls_drive
string ls_directory
string ls_filename
string ls_extension
str_c_attachment_extension lstr_extension

if extensions.rowcount() <= 0 then load_extensions()

if lower(left(ps_file, 7)) = "http://" or lower(left(ps_file, 8)) = "https://" then
	ls_extension = "url"
else
	if pos(ps_file, ".") > 0 then
		f_parse_filepath(ps_file, ls_drive, ls_directory, ls_filename, ls_extension)
	else
		ls_extension = ps_file
	end if
end if

ls_find = "lower(extension)='" + lower(ls_extension) + "'"
ll_row = extensions.find(ls_find, 1, extensions.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	if lower(ls_extension) = "url" or lower(ls_extension) = "htm" then
		lstr_extension.extension = ls_extension
		lstr_extension.description = upper(ls_extension)
		lstr_extension.button = "button21.bmp"
		lstr_extension.default_attachment_type = "URL"
		lstr_extension.default_storage_flag = "D"
		lstr_extension.component_id = "ATCH_GENERIC"
		lstr_extension.display_control = "Browser"
		lstr_extension.open_command = "Browser"
		lstr_extension.edit_command = "Shell Edit"
		lstr_extension.print_command = "Shell Print"
	else
		lstr_extension.extension = ls_extension
		lstr_extension.description = upper(ls_extension) + " File"
		lstr_extension.button = "button21.bmp"
		lstr_extension.default_attachment_type = "FILE"
		lstr_extension.default_storage_flag = "D"
		lstr_extension.component_id = "ATCH_GENERIC"
		lstr_extension.display_control = "ActiveX"
		lstr_extension.open_command = "Shell Open"
		lstr_extension.edit_command = "Shell Edit"
		lstr_extension.print_command = "Shell Print"
	end if
else
	lstr_extension.extension = extensions.object.extension[ll_row]
	lstr_extension.description = extensions.object.description[ll_row]
	lstr_extension.button = extensions.object.button[ll_row]
	lstr_extension.default_attachment_type = extensions.object.default_attachment_type[ll_row]
	lstr_extension.default_storage_flag = extensions.object.default_storage_flag[ll_row]
	lstr_extension.component_id = extensions.object.component_id[ll_row]
	lstr_extension.display_control = extensions.object.display_control[ll_row]
	lstr_extension.open_command = extensions.object.open_command[ll_row]
	lstr_extension.edit_command = extensions.object.edit_command[ll_row]
	lstr_extension.print_command = extensions.object.print_command[ll_row]
end if

return lstr_extension

end function

public function string office_address (string ps_office_id);string ls_temp
string ls_address

ls_address = ""

ls_temp = office_field(ps_office_id, "address1")
if len(ls_temp) > 0 then ls_address += ls_temp

ls_temp = office_field(ps_office_id, "address2")
if len(ls_temp) > 0 then
	if len(ls_address) > 0 then ls_address += ", "
	ls_address += ls_temp
end if

ls_temp = office_field(ps_office_id, "city")
if len(ls_temp) > 0 then
	if len(ls_address) > 0 then ls_address += ", "
	ls_address += ls_temp
end if

ls_temp = office_field(ps_office_id, "state")
if len(ls_temp) > 0 then
	if len(ls_address) > 0 then ls_address += ", "
	ls_address += ls_temp
end if

ls_temp = office_field(ps_office_id, "zip")
if len(ls_temp) > 0 then
	if len(ls_address) > 0 then ls_address += "  "
	ls_address += ls_temp
end if

ls_temp = office_field(ps_office_id, "zip_plus4")
if len(ls_temp) > 0 then
	if len(ls_address) > 0 then ls_address += "-"
	ls_address += ls_temp
end if

return ls_address


end function

public function string get_preference_d (string ps_preference_type, string ps_preference_id);//string ls_preference
//string ls_preference_d
//
//ls_preference = get_preference(ps_preference_type, ps_preference_id)
//if isnull(ls_preference) then return ls_preference
//
//ls_preference_d = common_thread.eprolibnet4.decryptstring(ls_preference, common_thread.key())
//if ls_preference_d = "" then setnull(ls_preference_d)
//
//return ls_preference_d
//

return get_preference(ps_preference_type, ps_preference_id)

end function

public function str_maintenance_rule get_maintenance_rule (long pl_maintenance_rule_id);long icount
str_maintenance_rule lstr_maintenance_rule
string ls_find
long i
u_ds_data luo_data

// Make sure it's not null
if isnull(pl_maintenance_rule_id) then
	log.log(this, "u_list_data.get_maintenance_rule:0009", "Null maintenance rule id", 4)
	setnull(lstr_maintenance_rule.maintenance_rule_id)
	return lstr_maintenance_rule
end if

// Any script calling this method is really asking for the active maintenance_rule with the same [id] as
// the specified maintenance_rule_id.

SELECT max(w2.maintenance_rule_id)
INTO :lstr_maintenance_rule.maintenance_rule_id
FROM c_maintenance_rule w1
	INNER JOIN c_maintenance_rule w2
	ON w1.id = w2.id
WHERE w1.maintenance_rule_id = :pl_maintenance_rule_id
AND w2.status = 'OK';
if not tf_check() then
	setnull(lstr_maintenance_rule.maintenance_rule_id)
	return lstr_maintenance_rule
end if
// If we didn't find an active maintenance_rule then just use the specified maintenance_rule
if isnull(lstr_maintenance_rule.maintenance_rule_id) then lstr_maintenance_rule.maintenance_rule_id = pl_maintenance_rule_id

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_c_maintenance_rule")
icount = luo_data.retrieve(lstr_maintenance_rule.maintenance_rule_id)
if icount = 0 then
	log.log(this, "u_list_data.get_maintenance_rule:0035", "Maintenance rule not found (" + string(lstr_maintenance_rule.maintenance_rule_id) + ")", 4)
	setnull(lstr_maintenance_rule.maintenance_rule_id)
	return lstr_maintenance_rule
elseif icount < 0 then
	log.log(this, "u_list_data.get_maintenance_rule:0039", "Error getting maintenance rule", 4)
	setnull(lstr_maintenance_rule.maintenance_rule_id)
	return lstr_maintenance_rule
end if

lstr_maintenance_rule.assessment_flag = luo_data.object.assessment_flag[1]
lstr_maintenance_rule.sex = luo_data.object.sex[1]
lstr_maintenance_rule.race = luo_data.object.race[1]
lstr_maintenance_rule.description = luo_data.object.description[1]
lstr_maintenance_rule.age_range_id = luo_data.object.age_range_id[1]
lstr_maintenance_rule.interval = luo_data.object.interval[1]
lstr_maintenance_rule.interval_unit = luo_data.object.interval_unit[1]
lstr_maintenance_rule.warning_days = luo_data.object.warning_days[1]
lstr_maintenance_rule.status = luo_data.object.status[1]
lstr_maintenance_rule.last_updated = luo_data.object.last_updated[1]
lstr_maintenance_rule.id = luo_data.object.id[1]
lstr_maintenance_rule.owner_id = luo_data.object.owner_id[1]

return lstr_maintenance_rule

end function

public function string assessment_acuteness (string ps_assessment_id);string ls_acuteness
long ll_row

ll_row = find_assessment(ps_assessment_id)
if ll_row <= 0 then
	// If we can't find the assessment just assume acute
	setnull(ls_acuteness)
else
	ls_acuteness = assessment_definition.object.acuteness[ll_row]
end if

return ls_acuteness

end function

public function str_c_xml_class get_xml_class (string ps_xml_class);integer li_sts
str_c_xml_class lstr_xml_class

li_sts = xml_class(ps_xml_class, lstr_xml_class)
if li_sts <= 0 then
	setnull(lstr_xml_class.xml_class)
end if

return lstr_xml_class

end function

public function long load_vial_types ();long ll_rows

vial_type.set_dataobject("dw_vial_type_list")

ll_rows = vial_type.retrieve()

return ll_rows

end function

public function string vial_type_description (string ps_vial_type);string ls_find
long ll_row
string ls_description

// If we're passed in a null, then return null
setnull(ls_description)
if isnull(ps_vial_type) then return ls_description

// If there aren't any records then load them
if vial_type.rowcount() <= 0 then load_vial_types()

// Construct the find string
ls_find = "upper(vial_type)='" + upper(ps_vial_type) + "'"

// Find the record
ll_row = vial_type.find(ls_find, 1, vial_type.rowcount())
if ll_row > 0 then
	ls_description = vial_type.object.description[ll_row]
end if

return ls_description


end function

public function str_c_xml_code_list xml_lookup_code_by_epro (string ps_epro_domain, string ps_epro_id, long pl_owner_id);str_c_xml_code_list lstr_codes
string ls_auto_create
long i

if len(ps_epro_domain) > 0 and len(ps_epro_id) > 0 then
	lstr_codes.code_count = code_by_epro.retrieve(ps_epro_domain, ps_epro_id, pl_owner_id)
else
	lstr_codes.code_count = 0
end if

for i = 1 to lstr_codes.code_count
	lstr_codes.code[i].code_id = code_by_epro.object.code_id[i]
	lstr_codes.code[i].owner_id = code_by_epro.object.owner_id[i]
	lstr_codes.code[i].code_domain = code_by_epro.object.code_domain[i]
	lstr_codes.code[i].code_version = code_by_epro.object.code_version[i]
	lstr_codes.code[i].code = code_by_epro.object.code[i]
	lstr_codes.code[i].epro_domain = code_by_epro.object.epro_domain[i]
	lstr_codes.code[i].epro_id = code_by_epro.object.epro_id[i]
	lstr_codes.code[i].unique_flag = code_by_epro.object.unique_flag[i]
	lstr_codes.code[i].created = code_by_epro.object.created[i]
	lstr_codes.code[i].created_by = code_by_epro.object.created_by[i]
	lstr_codes.code[i].last_updated = code_by_epro.object.last_updated[i]
next

return lstr_codes


end function

public function boolean get_preference_boolean (string ps_preference_type, string ps_preference_id, boolean pb_default_value);string ls_preference

ls_preference = get_preference(ps_preference_type, ps_preference_id)
if isnull(ls_preference) then return pb_default_value

return f_string_to_boolean(ls_preference)


end function

public function string encounter_type_coding_mode (string ps_encounter_type);string ls_find
long ll_row
string ls_coding_mode

if encounter_types.rowcount() <= 0 then load_encounter_types()

ls_find = "encounter_type='" + ps_encounter_type + "'"
ll_row = encounter_types.find(ls_find, 1, encounter_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_coding_mode)
else
	ls_coding_mode = encounter_types.object.coding_mode[ll_row]
end if

return ls_coding_mode

end function

public function string encounter_type_new_list_id (string ps_encounter_type);string ls_find
long ll_row
string ls_new_list_id

if encounter_types.rowcount() <= 0 then load_encounter_types()

ls_find = "encounter_type='" + ps_encounter_type + "'"
ll_row = encounter_types.find(ls_find, 1, encounter_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_new_list_id)
else
	ls_new_list_id = encounter_types.object.coding_new_list_id[ll_row]
end if

return ls_new_list_id

end function

public function string encounter_type_est_list_id (string ps_encounter_type);string ls_find
long ll_row
string ls_est_list_id

if encounter_types.rowcount() <= 0 then load_encounter_types()

ls_find = "encounter_type='" + ps_encounter_type + "'"
ll_row = encounter_types.find(ls_find, 1, encounter_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_est_list_id)
else
	ls_est_list_id = encounter_types.object.coding_est_list_id[ll_row]
end if

return ls_est_list_id

end function

private function integer get_menu_items (ref str_menu pstr_menu);long i

// Get the menu items
pstr_menu.menu_item_count = menu_items.retrieve(pstr_menu.menu_id)
if pstr_menu.menu_item_count < 0 then
	log.log(this, "u_list_data.get_menu_items:0006", "Error retrieving menu items (" + string(pstr_menu.menu_id) + ")", 4)
	return -1
end if

for i = 1 to pstr_menu.menu_item_count
	pstr_menu.menu_item[i].menu_item_id = menu_items.object.menu_item_id[i]
	pstr_menu.menu_item[i].menu_item_type = menu_items.object.menu_item_type[i]
	pstr_menu.menu_item[i].menu_item = menu_items.object.menu_item[i]
	pstr_menu.menu_item[i].context_object = menu_items.object.context_object[i]
	pstr_menu.menu_item[i].button_title = menu_items.object.button_title[i]
	pstr_menu.menu_item[i].button_help = menu_items.object.button_help[i]
	pstr_menu.menu_item[i].button = menu_items.object.button[i]
	pstr_menu.menu_item[i].sort_sequence = menu_items.object.sort_sequence[i]
	pstr_menu.menu_item[i].auto_close_flag = menu_items.object.auto_close_flag[i]
	pstr_menu.menu_item[i].authorized_user_id = menu_items.object.authorized_user_id[i]
	pstr_menu.menu_item[i].id = menu_items.object.id[i]
next

return pstr_menu.menu_item_count


end function

public function long consultant_owner_id (string ps_consultant_id);string ls_find
long ll_row
long ll_owner_id

if consultants.rowcount() <= 0 then load_consultants()

ls_find = "consultant_id='" + ps_consultant_id + "'"
ll_row = consultants.find(ls_find, 1, consultants.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	load_consultants()
	ll_row = consultants.find(ls_find, 1, consultants.rowcount())
	if ll_row <= 0 or isnull(ll_row) then
		setnull(ll_owner_id)
		return ll_owner_id
	end if
end if

ll_owner_id = consultants.object.owner_id[ll_row]

return ll_owner_id

end function

public function string consultant_from_owner_id (long pl_owner_id);string ls_find
long ll_row
string ls_consultant_id

if consultants.rowcount() <= 0 then load_consultants()

ls_find = "owner_id=" + string(pl_owner_id)
ll_row = consultants.find(ls_find, 1, consultants.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	load_consultants()
	ll_row = consultants.find(ls_find, 1, consultants.rowcount())
	if ll_row <= 0 or isnull(ll_row) then
		setnull(ls_consultant_id)
		return ls_consultant_id
	end if
end if

ls_consultant_id = consultants.object.consultant_id[ll_row]

return ls_consultant_id

end function

public subroutine check_table_update ();long ll_rowcount1
u_ds_data luo_data
long i
string ls_table_name1
string ls_table_name2
long ll_rowcount2
boolean lb_same

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_c_table_update")
ll_rowcount1 = luo_data.retrieve()
ll_rowcount2 = table_update.rowcount()
if isnull(ll_rowcount2) then ll_rowcount2 = 0

for i = 1 to ll_rowcount1
	lb_same = false
	ls_table_name1 = luo_data.object.table_name[i]
	
	// If the cache and the latest retrieve don't have the same number of
	// rows, then assume all tables have been updated
	if ll_rowcount1 = ll_rowcount2 then
		ls_table_name2 = table_update.object.table_name[i]
		
		if ls_table_name1 = ls_table_name2 then
			if luo_data.object.last_updated[i] = table_update.object.last_updated[i] then
				lb_same = true
			end if
		end if
	end if
	
	if not lb_same then
		clear_cache(ls_table_name1)
	end if
next

if isvalid(table_update) then
	DESTROY table_update
end if
table_update = luo_data

return


end subroutine

public function str_menu get_menu (long pl_menu_id, boolean pb_authorized_only);long ll_rowcount
str_menu lstr_menu
string ls_find
str_popup_return popup_return
str_popup popup
w_menu_display lw_menu_display
long i
integer li_sts

// Search the menu cache
for i = 1 to menu_cache_count
	if pl_menu_id = menu_cache[i].menu_id then
		if config_mode then
			// if we're in config mode then we want to make sure we have the latest
			// menu items if they've changed
			li_sts = get_menu_items(menu_cache[i])
		end if

	  return menu_cache[i]
	end if
next

// Any script calling this method is really asking for the active menu with the same [id] as
// the specified menu_id.
SELECT max(w2.menu_id)
INTO :lstr_menu.menu_id
FROM c_menu w1
	INNER JOIN c_menu w2
	ON w1.id = w2.id
WHERE w1.menu_id = :pl_menu_id
AND w2.status = 'OK';
if not tf_check() then
	setnull(lstr_menu.menu_id)
	return lstr_menu
end if
// If we didn't find an active menu then just use the specified menu
if isnull(lstr_menu.menu_id) then lstr_menu.menu_id = pl_menu_id


lstr_menu.menu_item_count = 0

SELECT description,
		specialty_id,
		context_object
INTO :lstr_menu.description,
		:lstr_menu.specialty_id,
		:lstr_menu.context_object
FROM c_Menu
WHERE menu_id = :lstr_menu.menu_id;
if not tf_check() then
	// Return the empty menu
	setnull(lstr_menu.menu_id)
	setnull(lstr_menu.description)
	setnull(lstr_menu.specialty_id)
	setnull(lstr_menu.context_object)
	return lstr_menu
end if


li_sts = get_menu_items(lstr_menu)
if li_sts < 0 then
	log.log(this, "u_list_data.get_menu:0062", "Error getting menu items (" + string(lstr_menu.menu_id) + ")", 4)
	// Return the empty menu
	setnull(lstr_menu.menu_id)
	setnull(lstr_menu.description)
	setnull(lstr_menu.specialty_id)
	setnull(lstr_menu.context_object)
	return lstr_menu
end if

// Add menu to cache
menu_cache_count += 1
menu_cache[menu_cache_count] = lstr_menu

// If we're supposed to only show the authorized menu items, then
// call the user object to filter the menu
if pb_authorized_only and not isnull(current_user) then
	current_user.check_menu(lstr_menu)
end if

return lstr_menu


end function

public function string treatment_type_id (string ps_treatment_type);string ls_find
long ll_row
string ls_id

if treatment_types.rowcount() <= 0 then load_treatment_types()

ls_find = "lower(treatment_type)='" + lower(ps_treatment_type) + "'"
ll_row = treatment_types.find(ls_find, 1, treatment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_id)
else
	ls_id = treatment_types.object.id[ll_row]
end if

return ls_id

end function

public function string assessment_property (string ps_assessment_id, string ps_property);string ls_value
long ll_row

ll_row = find_assessment(ps_assessment_id)
if ll_row <= 0 then
	setnull(ls_value)
else
	ls_value = assessment_definition.get_field_value(ll_row, ps_property)
end if

return ls_value

end function

public function str_priorities get_priorities ();integer li_sts

if priorities.priority_count > 0 then return priorities

li_sts = load_priorities()

return priorities

end function

public function string priority_bitmap (integer pi_priority);string ls_null

setnull(ls_null)

if isnull(pi_priority) or pi_priority <= 0 then return ls_null

if priorities.priority_count <= 0 then load_priorities()

if pi_priority <= priorities.priority_count then return priorities.priority[pi_priority].bitmap

return ls_null

end function

public function integer load_priorities ();string ls_temp

priorities.priority_count = 0
DO WHILE true
	ls_temp = domain_item_description("Workplan Item Priority", string(priorities.priority_count + 1))
	if isnull(ls_temp) then exit
	
	priorities.priority_count += 1
	priorities.priority[priorities.priority_count].priority = priorities.priority_count
	priorities.priority[priorities.priority_count].description = ls_temp
	priorities.priority[priorities.priority_count].bitmap = datalist.domain_item_bitmap("Workplan Item Priority", string(priorities.priority_count))
	
	// For now we'll hard-code the beeps
	if priorities.priority_count = 3 then
		ls_temp = get_preference("PREFERENCES", "High Priority Sound")
		if len(ls_temp) > 0 then
			priorities.priority[priorities.priority_count].sound_file = ls_temp
		else
			priorities.priority[priorities.priority_count].sound_file = "1 beep"
		end if
	elseif priorities.priority_count = 4 then
		ls_temp = get_preference("PREFERENCES", "Urgent Priority Sound")
		if len(ls_temp) > 0 then
			priorities.priority[priorities.priority_count].sound_file = ls_temp
		else
			priorities.priority[priorities.priority_count].sound_file = "2 beep"
		end if
	else
		priorities.priority[priorities.priority_count].sound_file = ""
	end if
LOOP

return priorities.priority_count

end function

public function string priority_sound_file (integer pi_priority);string ls_null

setnull(ls_null)

if isnull(pi_priority) or pi_priority <= 0 then return ls_null

if priorities.priority_count <= 0 then load_priorities()

if pi_priority <= priorities.priority_count then return priorities.priority[pi_priority].sound_file

return ls_null

end function

public function string assessment_type_property (string ps_assessment_type, string ps_property);string ls_find
long ll_row
string ls_temp

if assessment_types.rowcount() <= 0 then load_assessment_types()

ls_find = "assessment_type='" + ps_assessment_type + "'"
ll_row = assessment_types.find(ls_find, 1, assessment_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(ls_temp)
else
	ls_temp = assessment_types.get_field_value(ll_row, ps_property)
end if

return ls_temp

end function

public function datetime last_table_update (string ps_table, boolean pb_reselect_now);long ll_count
string ls_find
long ll_row
datetime ldt_table_update

ll_count = table_update.rowcount()
if ll_count <= 0 then
	check_table_update( )
	ll_count = table_update.rowcount()
end if

ls_find = "lower(table_name)='" + lower(ps_table) + "'"
ll_row = table_update.find(ls_find, 1, ll_count)
if ll_row > 0 then
	if pb_reselect_now then
		table_update.reselectrow(ll_row)
	end if
	ldt_table_update = table_update.object.last_updated[ll_row]
else
	// If we didn't find a record then create one
	ldt_table_update = datetime(today(), now())
end if

return ldt_table_update


end function

public function long load_xml_class ();long ll_rows

xml_class.set_dataobject("dw_c_xml_class_data")

ll_rows = xml_class.retrieve()

return ll_rows

end function

public function integer xml_class (string ps_xml_class, ref str_c_xml_class pstr_c_xml_class);long ll_count
string ls_find
long ll_row

if isnull(ps_xml_class) then
	log.log(this, "u_list_data.xml_class:0006", "Null xml_class", 4)
	setnull(pstr_c_xml_class.xml_class)
	return -1
end if

ll_count = xml_class.rowcount()
if ll_count <= 0 then
	ll_count = load_xml_class()
end if

ls_find = "xml_class='" + ps_xml_class + "'"
ll_row = xml_class.find(ls_find, 1, ll_count)
if ll_row > 0 then
	pstr_c_xml_class.xml_class = xml_class.object.xml_class[ll_row]
	pstr_c_xml_class.description = xml_class.object.description[ll_row]
	pstr_c_xml_class.render_transform_material_id = xml_class.object.render_transform_material_id[ll_row]
	pstr_c_xml_class.render_transform_extension = xml_class.object.render_transform_extension[ll_row]
	pstr_c_xml_class.handler_component_id = xml_class.object.handler_component_id[ll_row]
	pstr_c_xml_class.creator_component_id = xml_class.object.creator_component_id[ll_row]
	pstr_c_xml_class.root_context_object = xml_class.object.root_context_object[ll_row]
	pstr_c_xml_class.created = xml_class.object.created[ll_row]
	pstr_c_xml_class.created_by = xml_class.object.created_by[ll_row]
	pstr_c_xml_class.id = xml_class.object.id[ll_row]
	pstr_c_xml_class.creator_display_script_id = xml_class.object.creator_display_script_id[ll_row]
	pstr_c_xml_class.handler_display_script_id = xml_class.object.handler_display_script_id[ll_row]
	pstr_c_xml_class.root_element = xml_class.object.root_element[ll_row]
	pstr_c_xml_class.file_extension = xml_class.object.file_extension[ll_row]
	pstr_c_xml_class.config_object = xml_class.object.config_object[ll_row]
	pstr_c_xml_class.xml_schema = xml_class.object.xml_schema[ll_row]
else
	log.log(this, "u_list_data.xml_class:0036", "xml_class not found (" + ps_xml_class + ")", 4)
	return -1
end if


return 1

end function

public function long xml_class_config_object_creator_script (string ps_config_object);long ll_count
long ll_display_script_id
string ls_find
long ll_row

if isnull(ps_config_object) then
	log.log(this, "u_list_data.xml_class_config_object_creator_script:0007", "Null config_object", 4)
	return -1
end if

ll_count = xml_class.rowcount()
if ll_count <= 0 then
	ll_count = load_xml_class()
end if

ls_find = "config_object='" + ps_config_object + "'"
ll_row = xml_class.find(ls_find, 1, ll_count)
if ll_row > 0 then
	ll_display_script_id = xml_class.object.creator_display_script_id[ll_row]
else
	return 0
end if


return ll_display_script_id

end function

public function long load_config_object_types ();long ll_rows
string ls_sql

ls_sql = "SELECT * FROM c_Config_Object_Type"
ll_rows = c_config_object_type.load_query(ls_sql)

return ll_rows


end function

public function str_config_object_type config_object_type_from_key_name (string ps_config_object_key);string ls_find
long ll_row
long ll_rowcount
integer li_temp

ll_rowcount = c_config_object_type.rowcount()
if ll_rowcount <= 0 then
	ll_rowcount = load_config_object_types( )
end if

ls_find = "lower(config_object_key) = right('" + lower(ps_config_object_key) + "', len(config_object_key))"
ll_row = c_config_object_type.find( ls_find, 1, ll_rowcount)

return config_object_type(ll_row)


end function

private function str_config_object_type config_object_type (long pl_row);str_config_object_type lstr_config_object_type
integer li_temp

if pl_row > 0 then
	lstr_config_object_type.config_object_type = c_config_object_type.object.config_object_type[pl_row]
	lstr_config_object_type.description = c_config_object_type.object.description[pl_row]
	lstr_config_object_type.config_object_key = c_config_object_type.object.config_object_key[pl_row]
	lstr_config_object_type.creator_xml_script_guid = c_config_object_type.object.creator_xml_script_guid[pl_row]
	lstr_config_object_type.creator_xml_script_id = c_config_object_type.object.creator_xml_script_id[pl_row]
	li_temp = c_config_object_type.object.version_control[pl_row]
	if li_temp = 0 then
		lstr_config_object_type.version_control = false
	else
		lstr_config_object_type.version_control = true
	end if
	lstr_config_object_type.object_encoding_method = c_config_object_type.object.object_encoding_method[pl_row]
	li_temp = c_config_object_type.object.auto_install_flag[pl_row]
	if li_temp = 0 then
		lstr_config_object_type.auto_install = false
	else
		lstr_config_object_type.auto_install = true
	end if
	li_temp = c_config_object_type.object.concurrent_install_flag[pl_row]
	if li_temp = 0 then
		lstr_config_object_type.concurrent_install = false
	else
		lstr_config_object_type.concurrent_install = true
	end if
else
	setnull(lstr_config_object_type.config_object_type)
end if

return lstr_config_object_type


end function

public function str_config_object_type get_config_object_type (string ps_config_object_type);string ls_find
long ll_row
long ll_rowcount

ll_rowcount = c_config_object_type.rowcount()
if ll_rowcount <= 0 then
	ll_rowcount = load_config_object_types( )
end if

ls_find = "lower(config_object_type)='" + lower(ps_config_object_type) + "'"
ll_row = c_config_object_type.find( ls_find, 1, ll_rowcount)
return config_object_type(ll_row)



end function

public function long load_attachment_locations ();long ll_rows

attachment_location.set_dataobject("dw_c_attachment_location")

ll_rows = attachment_location.retrieve()

return ll_rows

end function

public function long get_attachment_location_assignment (string ps_cpr_id);long ll_rows
long ll_row
long i
long ll_attachment_location_id
string ls_find


ll_rows = attachment_location.rowcount()
if ll_rows <= 0 then
	ll_rows = load_attachment_locations( )
end if

ls_find = "'" + ps_cpr_id + "' LIKE assignment_code OR ISNULL(assignment_code)"
ll_row = attachment_location.find(ls_find, 1, ll_rows)
if ll_row > 0 then
	ll_attachment_location_id = attachment_location.object.attachment_location_id[ll_row]
else
	setnull(ll_attachment_location_id)
end if


return ll_attachment_location_id


	

end function

public function str_attachment_location get_attachment_location (long pl_attachment_location_id);str_attachment_location lstr_attachment_location
string ls_find
long ll_row
long ll_rows


ll_rows = attachment_location.rowcount()
if ll_rows <= 0 then
	ll_rows = load_attachment_locations( )
end if

ls_find = "attachment_location_id=" + string(pl_attachment_location_id)
ll_row = attachment_location.find(ls_find, 1, ll_rows)
if ll_row > 0 then
	lstr_attachment_location.attachment_location_id = attachment_location.object.attachment_location_id[ll_row]
	lstr_attachment_location.attachment_server = attachment_location.object.attachment_server[ll_row]
	lstr_attachment_location.attachment_share = attachment_location.object.attachment_share[ll_row]
	lstr_attachment_location.assignment_code = attachment_location.object.assignment_code[ll_row]
	lstr_attachment_location.sort_sequence = attachment_location.object.sort_sequence[ll_row]
	lstr_attachment_location.status = attachment_location.object.status[ll_row]
else
	setnull(lstr_attachment_location.attachment_location_id)
end if



return lstr_attachment_location
end function

public function integer display_script (long pl_display_script_id, ref str_display_script pstr_display_script, boolean pb_include_disabled_commands);long ll_display_script_id
string ls_find
long ll_row
long ll_rowcount
datetime ldt_last_updated

if isnull(pl_display_script_id) then
	log.log(this, "u_list_data.display_script:0008", "null display_script_id", 4)
	return -1
end if

SELECT TOP 1 d2.display_script_id, d2.last_updated
INTO :ll_display_script_id, :ldt_last_updated
FROM c_Display_Script d1
	INNER JOIN c_Display_Script d2
	ON d1.id = d2.id
WHERE d1.display_script_id = :pl_display_script_id
ORDER BY d2.status DESC, d2.display_script_id DESC;
if not tf_check() then return -1

// We've got the desired display_script_id, now get the structure
return display_script_actual(ll_display_script_id, ldt_last_updated, pstr_display_script, pb_include_disabled_commands)


end function

private function integer display_script_actual (long pl_display_script_id, datetime pdt_last_updated, ref str_display_script pstr_display_script, boolean pb_include_disabled_commands);long i
long ll_attribute_count
str_display_script lstr_script
long ll_row
long ll_last_row
string ls_find
string ls_attribute
string ls_value
long ll_cache_index
long ll_attribute_sequence

if isnull(pl_display_script_id) then
	log.log(this, "u_list_data.display_script_actual:0013", "null display_script_id", 4)
	return -1
end if

// This method retrieves the display script structure for the specified display_script_id
// WITHOUT translating it to the currently active one.

ll_cache_index = 0

// We've got the desired display_script_id, now see if it's cached
for i = 1 to display_script_count
	if display_script_cache[i].display_script_id = pl_display_script_id then
			ll_cache_index = i
			// We found the display_script cached, but make sure the cached entry is up to date
			if display_script_cache[i].last_updated < pdt_last_updated then exit
			
			// If the called didn't want the disabled commands then remove them
			if pb_include_disabled_commands then
				pstr_display_script = display_script_cache[i]
			else
				pstr_display_script = display_script_remove_disabled_commands(display_script_cache[i])
			end if
			
			// The cached entry was up to date so return success
			return 1
	end if
next

// If we get here then we didn't have the display script cached, so look it up
SELECT context_object,
	display_script,
	description,
	example,
	status,
	last_updated,
	updated_by,
	CAST(id AS varchar(40)),
	owner_id,
	CAST(parent_config_object_id AS varchar(40)),
	CAST(original_id AS varchar(40)),
	script_type,
	default_root_element
INTO :lstr_script.context_object,
	:lstr_script.display_script,
	:lstr_script.description,
	:lstr_script.example,
	:lstr_script.status,
	:lstr_script.last_updated,
	:lstr_script.updated_by,
	:lstr_script.id,
	:lstr_script.owner_id,
	:lstr_script.parent_config_object_id,
	:lstr_script.original_id,
	:lstr_script.script_type,
	:lstr_script.default_root_element
FROM c_Display_Script
WHERE display_script_id = :pl_display_script_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "u_list_data.display_script_actual:0072", "display_script_id not found (" + string(pl_display_script_id) + ")", 4)
	return -1
end if

lstr_script.display_script_id = pl_display_script_id

lstr_script.display_command_count = display_script_commands.retrieve(pl_display_script_id)
ll_attribute_count = display_script_command_attributes.retrieve(pl_display_script_id)
ll_row = 0
ll_last_row = 0

for i = 1 to lstr_script.display_command_count
	lstr_script.display_command[i].display_script_id = display_script_commands.object.display_script_id[i]
	lstr_script.display_command[i].display_command_id = display_script_commands.object.display_command_id[i]
	lstr_script.display_command[i].context_object = display_script_commands.object.context_object[i]
	lstr_script.display_command[i].display_command = display_script_commands.object.display_command[i]
	lstr_script.display_command[i].sort_sequence = display_script_commands.object.sort_sequence[i]
	lstr_script.display_command[i].status = display_script_commands.object.status[i]
	lstr_script.display_command[i].id = display_script_commands.object.id[i]
	lstr_script.display_command[i].command_component_id = display_script_commands.object.command_component_id[i]
	
	// The attributes are sorted the same as the commands so we don't have to start at the beginning each time
	ls_find = "display_command_id=" + string(lstr_script.display_command[i].display_command_id)
	ll_row = display_script_command_attributes.find(ls_find, ll_last_row + 1, ll_attribute_count + 1)
	DO WHILE ll_row > 0 and ll_row <= ll_attribute_count
		ls_attribute = display_script_command_attributes.object.attribute[ll_row]
		ls_value = display_script_command_attributes.object.value[ll_row]
		ll_attribute_sequence = display_script_command_attributes.object.attribute_sequence[ll_row]
		
		// The datawindow will only hold 8000 characters, so if the value is over 8000 characters, then make sure
		// we have the whole thing
		if len(ls_value) >= 8000 then
			SELECT long_value
			INTO :ls_value
			FROM c_Display_Script_Cmd_Attribute
			WHERE display_script_id = :pl_display_script_id
			AND display_command_id = :lstr_script.display_command[i].display_command_id
			AND attribute_sequence = :ll_attribute_sequence;
			if not tf_check() then return -1
		end if
		f_attribute_add_attribute(lstr_script.display_command[i].attributes, ls_attribute, ls_value)
		ll_last_row = ll_row
		ll_row = display_script_command_attributes.find(ls_find, ll_row + 1, ll_attribute_count + 1)
	LOOP
	
	// Copy the attributes so callers will always have access to the original set
	lstr_script.display_command[i].original_attributes = lstr_script.display_command[i].attributes
next

if ll_cache_index <= 0 then
	display_script_count += 1
	ll_cache_index = display_script_count
end if

display_script_cache[ll_cache_index] = lstr_script


// If the called didn't want the disabled commands then remove them
if pb_include_disabled_commands then
	pstr_display_script = lstr_script
else
	pstr_display_script = display_script_remove_disabled_commands(lstr_script)
end if

return 1


end function

public function str_display_script display_script_remove_disabled_commands (str_display_script pstr_display_script);str_display_script lstr_display_script
long i

// First copy everything
lstr_display_script = pstr_display_script

// Then copy just the active commands
lstr_display_script.display_command_count = 0
for i = 1 to pstr_display_script.display_command_count
	if upper(pstr_display_script.display_command[i].status) = "OK" then
		lstr_display_script.display_command_count += 1
		lstr_display_script.display_command[lstr_display_script.display_command_count] = pstr_display_script.display_command[i]
	end if
next

return lstr_display_script


end function

public function str_wp_item_list office_other_office_my_services (string ps_user_id);integer li_sts
long ll_room_count
long ll_encounter_count
long ll_wp_item_count
str_wp_item_list lstr_service_list
string ls_service_find
long ll_service_row

li_sts = load_office_status(ll_room_count, ll_encounter_count, ll_wp_item_count)
if li_sts < 0 then
	lstr_service_list.wp_item_count = -1
	return lstr_service_list
end if


// Loop through the services which should appear on this tab
// See if there are any patients in this room
ls_service_find = "owned_by='" + ps_user_id + "'"
ls_service_find += " and office_id<>'" +  gnv_app.office_id + "'"
ls_service_find += " and in_office_flag = 'Y'"
ll_service_row = active_services.find(ls_service_find, 1, ll_wp_item_count)
DO WHILE ll_service_row > 0 and ll_service_row <= ll_wp_item_count
	lstr_service_list.wp_item_count += 1
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].patient_workplan_id = active_services.object.patient_workplan_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].patient_workplan_item_id = active_services.object.patient_workplan_item_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].cpr_id = active_services.object.cpr_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].encounter_id = active_services.object.encounter_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].ordered_service = active_services.object.ordered_service[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].followup_workplan_id = active_services.object.followup_workplan_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].description = active_services.object.description[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].ordered_by = active_services.object.ordered_by[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].ordered_for = active_services.object.ordered_for[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].priority = active_services.object.priority[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].dispatch_date = active_services.object.dispatch_date[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].owned_by = active_services.object.owned_by[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].begin_date = active_services.object.begin_date[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].status = active_services.object.status[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].room_id = active_services.object.room_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].observation_id = active_services.object.observation_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].result_sequence = active_services.object.result_sequence[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].escalation_date = active_services.object.escalation_date[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].expiration_date = active_services.object.expiration_date[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].minutes = active_services.object.minutes[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].user_id = active_services.object.user_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].computer_id = active_services.object.computer_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].patient_location = active_services.object.patient_location[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].office_id = active_services.object.office_id[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].result = active_services.object.result[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].result_date_time = active_services.object.result_date_time[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].location = active_services.object.location[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].location_description = active_services.object.location_description[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].result_value = active_services.object.result_value[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].result_unit = active_services.object.result_unit[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].result_amount_flag = active_services.object.result_amount_flag[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].print_result_flag = active_services.object.print_result_flag[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].print_result_separator = active_services.object.print_result_separator[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].abnormal_flag = active_services.object.abnormal_flag[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].abnormal_nature = active_services.object.abnormal_nature[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].severity = active_services.object.severity[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].unit_preference = active_services.object.unit_preference[ll_service_row]
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].display_mask = active_services.object.display_mask[ll_service_row]
	
	lstr_service_list.wp_item[lstr_service_list.wp_item_count].encounter = office_encounter(lstr_service_list.wp_item[lstr_service_list.wp_item_count].cpr_id, &
																												lstr_service_list.wp_item[lstr_service_list.wp_item_count].encounter_id)
	
	// Get the next service in this group
	ll_service_row = active_services.find(ls_service_find, ll_service_row + 1, ll_wp_item_count + 1)
LOOP


return lstr_service_list


end function

private function str_encounter_description office_encounter (string ps_cpr_id, long pl_encounter_id);str_encounter_description lstr_encounter
string ls_encounter_find
long ll_encounter_row
long ll_encounter_count

ll_encounter_count = open_encounters.rowcount()

ls_encounter_find = "cpr_id='" + ps_cpr_id + "'"
ls_encounter_find += " and encounter_id=" + string(pl_encounter_id)
ll_encounter_row = open_encounters.find(ls_encounter_find, 1, ll_encounter_count)
if ll_encounter_row > 0 then
	return office_encounter(ll_encounter_row)
end if

setnull(lstr_encounter.cpr_id)
setnull(lstr_encounter.encounter_id)

return lstr_encounter


end function

public function string authority_type_description (string ps_authority_type);
// Ultimately look up in c_Authority_Type
// For now just return the authority type unless it's payor which is misspelled
if lower(ps_authority_type) = "payor" then
	return "Payer"
else
	return wordcap(ps_authority_type)
end if

end function

public function integer get_offices (ref str_c_office pstr_office[], boolean pb_active_only);long ll_row
long ll_office_count
long i

if offices.rowcount() <= 0 then load_offices()

ll_office_count = offices.rowcount()
ll_row = 0

for i = 1 to ll_office_count
	if not pb_active_only or upper(offices.object.status[i]) = "OK" then
		ll_row += 1
		pstr_office[ll_row].office_id = offices.object.office_id[i]
		pstr_office[ll_row].description = offices.object.description[i]
		pstr_office[ll_row].address1 = offices.object.address1[i]
		pstr_office[ll_row].address2 = offices.object.address2[i]
		pstr_office[ll_row].city = offices.object.city[i]
		pstr_office[ll_row].state = offices.object.state[i]
		pstr_office[ll_row].zip = offices.object.zip[i]
		pstr_office[ll_row].zip_plus4 = offices.object.zip_plus4[i]
		pstr_office[ll_row].phone = offices.object.phone[i]
		pstr_office[ll_row].fax = offices.object.fax[i]
		pstr_office[ll_row].status = offices.object.status[i]
		pstr_office[ll_row].office_nickname = offices.object.office_nickname[i]
	end if
next

return ll_row

end function

public function str_epro_object_definition epro_object_definition (string ps_epro_object);long i
str_epro_object_definition lstr_epro_object_definition
long ll_rowcount
string ls_find
long ll_row
string ls_query

ll_rowcount = epro_object.rowcount()
if ll_rowcount = 0 then
	ll_rowcount = epro_object.retrieve()
end if

ls_find = "lower(epro_object)='" + lower(ps_epro_object) + "'"

ll_row = epro_object.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	lstr_epro_object_definition.epro_object = epro_object.object.epro_object[ll_row]
	lstr_epro_object_definition.object_type = epro_object.object.object_type[ll_row]
	lstr_epro_object_definition.description = epro_object.object.description[ll_row]
	lstr_epro_object_definition.default_which_object = epro_object.object.default_which_object[ll_row]
	ls_query = epro_object.object.base_table_query[ll_row]
	if len(ls_query) > 0 then
		lstr_epro_object_definition.base_tablename = ls_query
	else
		lstr_epro_object_definition.base_tablename = epro_object.object.base_tablename[ll_row]
	end if
	lstr_epro_object_definition.base_table_key_column = epro_object.object.base_table_key_column[ll_row]
	lstr_epro_object_definition.base_table_filter = epro_object.object.base_table_filter[ll_row]
	lstr_epro_object_definition.base_table_sort = epro_object.object.base_table_sort[ll_row]
	lstr_epro_object_definition.object_help = epro_object.object.object_help[ll_row]
	lstr_epro_object_definition.default_display_property_name = epro_object.object.default_display_property_name[ll_row]
else
	setnull(lstr_epro_object_definition.epro_object)
	setnull(lstr_epro_object_definition.object_type)
	setnull(lstr_epro_object_definition.description)
	setnull(lstr_epro_object_definition.default_which_object)
	setnull(lstr_epro_object_definition.base_tablename)
	setnull(lstr_epro_object_definition.base_table_key_column)
	setnull(lstr_epro_object_definition.base_table_filter)
	setnull(lstr_epro_object_definition.base_table_sort)
	setnull(lstr_epro_object_definition.object_help)
	setnull(lstr_epro_object_definition.default_display_property_name)
end if


return lstr_epro_object_definition

end function

public function integer find_epro_object_property (string ps_epro_object, string ps_property_name, ref str_property pstr_property);long i
string ls_find
long ll_row
long ll_null
long ll_rowcount

setnull(ll_null)

if isnull(ps_epro_object) or trim(ps_epro_object) = "" then
	log.log(this, "u_list_data.find_epro_object_property:0010", "Null epro object", 4)
	return -1
end if

if isnull(ps_property_name) or trim(ps_property_name) = "" then
	log.log(this, "u_list_data.find_epro_object_property:0015", "Null property", 4)
	return -1
end if

// Fixed Properties
CHOOSE CASE lower(ps_property_name)
	CASE "objectordinal", "objectname", "objectdescription", "objecttype","objecthelp"
		pstr_property = get_fixed_property(ps_epro_object, ps_property_name)
		return 1
END CHOOSE


ll_rowcount = c_property.rowcount()
if ll_rowcount <= 0 then ll_rowcount = load_c_property()

ls_find = "lower(epro_object)='" + lower(ps_epro_object) + "'"
ls_find += " and lower(property_name)='" + lower(ps_property_name) + "'"

ll_row = c_property.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	pstr_property = get_property(ll_row)
	return 1
end if

// We didn't find it using the property name, but maybe it's an internal reference so look for the property in function_name
ls_find = "lower(epro_object)='" + lower(ps_epro_object) + "'"
ls_find += " and lower(function_name)='" + lower(ps_property_name) + "'"

ll_row = c_property.find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	pstr_property = get_property(ll_row)
	return 1
end if

log.log(this, "u_list_data.find_epro_object_property:0049", "epro object property not found (" + ps_epro_object + ", " + ps_property_name + ")", 4)

return -1



end function

public function string xml_lookup_code (string ps_epro_domain, string ps_epro_id, long pl_owner_id, string ps_code_domain);long i
string ls_code
long ll_count

if len(ps_epro_domain) > 0 and len(ps_epro_id) > 0 then
	ll_count = code_by_epro.retrieve(ps_epro_domain, ps_epro_id, pl_owner_id)
else
	ll_count = 0
end if

setnull(ls_code)

for i = 1 to ll_count
	if lower(string(code_by_epro.object.code_domain[i])) = lower(ps_code_domain) then
		ls_code = code_by_epro.object.code[i]
		exit
	end if
next

return ls_code



end function

public function long xml_add_mapping (str_c_xml_code pstr_c_xml_code);
long ll_code_id
integer li_replace_flag


// Validate required fields
if isnull(pstr_c_xml_code.owner_id) then
	log.log(this, "u_list_data.xml_add_mapping:0008", "No owner_id", 4)
	return -1
end if

if isnull(pstr_c_xml_code.code_domain) or trim(pstr_c_xml_code.code_domain) = "" then
	log.log(this, "u_list_data.xml_add_mapping:0013", "No code_domain", 4)
	return -1
end if

if isnull(pstr_c_xml_code.code) or trim(pstr_c_xml_code.code) = "" then
	log.log(this, "u_list_data.xml_add_mapping:0018", "No code", 4)
	return -1
end if

if isnull(pstr_c_xml_code.epro_domain) or trim(pstr_c_xml_code.epro_domain) = "" then
	log.log(this, "u_list_data.xml_add_mapping:0023", "No epro_domain", 4)
	return -1
end if

if isnull(pstr_c_xml_code.epro_id) or trim(pstr_c_xml_code.epro_id) = "" then
	log.log(this, "u_list_data.xml_add_mapping:0028", "No epro_id", 4)
	return -1
end if

if isnull(pstr_c_xml_code.created_by) or trim(pstr_c_xml_code.created_by) = "" then
	pstr_c_xml_code.created_by = current_scribe.user_id
end if

if trim(pstr_c_xml_code.code_version) = "" then setnull(pstr_c_xml_code.code_version)

ll_code_id = sqlca.xml_add_mapping( pstr_c_xml_code.owner_id, &
												pstr_c_xml_code.code_domain, &
												pstr_c_xml_code.code_version, &
												pstr_c_xml_code.code, &
												pstr_c_xml_code.code_description, &
												pstr_c_xml_code.epro_domain, &
												pstr_c_xml_code.epro_id, &
												pstr_c_xml_code.epro_description, &
												pstr_c_xml_code.epro_owner_id, &
												pstr_c_xml_code.created_by)
if not tf_check() then return -1

if ll_code_id > 0 then
	return ll_code_id
else
	return -1
end if


end function

public function string xml_lookup_epro_id (long pl_owner_id, string ps_code_domain, string ps_code_version, string ps_code, string ps_description, string ps_epro_domain);string ls_epro_id
string ls_null
long ll_sts

setnull(ls_null)

ll_sts = sqlca.xml_lookup_epro_id(pl_owner_id, ps_code_domain, ls_null, ps_code, ps_description, ps_epro_domain, current_scribe.user_id, ls_epro_id)
if not tf_check() then return ls_null

if ll_sts <= 0 then return ls_null

return ls_epro_id

end function

public function string xml_lookup_epro_id (long pl_owner_id, string ps_code_domain, string ps_code, string ps_description, string ps_epro_domain);string  ls_code_version

setnull(ls_code_version)

return xml_lookup_epro_id(pl_owner_id, &
									ps_code_domain, &
									ls_code_version, &
									ps_code, &
									ps_description, &
									ps_epro_domain)


end function

public function integer xml_remove_mapping (str_c_xml_code pstr_c_xml_code, boolean pb_remove_all);long ll_code_id
integer li_remove_all

if pb_remove_all then
	li_remove_all = 1
else
	li_remove_all = 0
end if

// Validate required fields
if isnull(pstr_c_xml_code.owner_id) then
	log.log(this, "u_list_data.xml_remove_mapping:0012", "No owner_id", 4)
	return -1
end if

if isnull(pstr_c_xml_code.code_domain) or trim(pstr_c_xml_code.code_domain) = "" then
	log.log(this, "u_list_data.xml_remove_mapping:0017", "No code_domain", 4)
	return -1
end if

if isnull(pstr_c_xml_code.code) or trim(pstr_c_xml_code.code) = "" then
	log.log(this, "u_list_data.xml_remove_mapping:0022", "No code", 4)
	return -1
end if

if isnull(pstr_c_xml_code.epro_domain) or trim(pstr_c_xml_code.epro_domain) = "" then
	log.log(this, "u_list_data.xml_remove_mapping:0027", "No epro_domain", 4)
	return -1
end if

if (isnull(pstr_c_xml_code.epro_id) or trim(pstr_c_xml_code.epro_id) = "") and not pb_remove_all then
	log.log(this, "u_list_data.xml_remove_mapping:0032", "No epro_id", 4)
	return -1
end if

if trim(pstr_c_xml_code.code_version) = "" then setnull(pstr_c_xml_code.code_version)

ll_code_id = sqlca.xml_remove_mapping( pstr_c_xml_code.owner_id, &
											pstr_c_xml_code.code_domain, &
											pstr_c_xml_code.code_version, &
											pstr_c_xml_code.code, &
											pstr_c_xml_code.epro_domain, &
											pstr_c_xml_code.epro_id, &
											current_scribe.user_id, &
											li_remove_all )
if not tf_check() then return -1

return 1


end function

public function str_c_xml_code_list xml_get_epro_ids (long pl_owner_id, string ps_code_domain, string ps_code_version, string ps_code);str_c_xml_code_list lstr_codes
long i
u_ds_data luo_data

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_c_xml_code_get_epro_ids")

if len(ps_code_domain) > 0 and len(ps_code) > 0 then
	lstr_codes.code_count = luo_data.retrieve(pl_owner_id, ps_code_domain, ps_code_version, ps_code)
else
	lstr_codes.code_count = 0
end if

for i = 1 to lstr_codes.code_count
	lstr_codes.code[i].code_id = luo_data.object.code_id[i]
	lstr_codes.code[i].owner_id = luo_data.object.owner_id[i]
	lstr_codes.code[i].code_domain = luo_data.object.code_domain[i]
	lstr_codes.code[i].code_version = luo_data.object.code_version[i]
	lstr_codes.code[i].code = luo_data.object.code[i]
	lstr_codes.code[i].epro_domain = luo_data.object.epro_domain[i]
	lstr_codes.code[i].epro_id = luo_data.object.epro_id[i]
	lstr_codes.code[i].unique_flag = luo_data.object.unique_flag[i]
	lstr_codes.code[i].created = luo_data.object.created[i]
	lstr_codes.code[i].created_by = luo_data.object.created_by[i]
	lstr_codes.code[i].last_updated = luo_data.object.last_updated[i]
next

DESTROY luo_data

return lstr_codes

end function

public function integer set_preference (string ps_preference_type, string ps_preference_level, string ps_preference_key, string ps_preference_id, string ps_preference_value);// update_preference()
// This method updates the specified preference in the database
//
// Parameter					Description
// ======================	=========================================
// ps_preference_type		Type of Preference
// ps_preference_level		Scope of the preference.  Valid values are:
//												Global
//												Office
//												Computer
//												Specialty
//												User
// ps_preference_key			Preference key specific to preference_level.  For global preferences, always use "Global"
// ps_preference_id			Preference ID
// ps_preference_value		Preference Value
//
//
// Returns:
//		1		Success
//		-1		Failure
//
//
string ls_find
long ll_row
string ls_encrypted
string ls_preference_value_e
string ls_preference_value_d

// See if this preference is encrypted
if len(ps_preference_value) > 0 then
	ls_find = "upper(preference_id)='" + upper(ps_preference_id) + "'"
	ll_row = preferences.find(ls_find, 1, preferences.rowcount())
	if ll_row > 0 then
		ls_encrypted = preferences.object.encrypted[ll_row]
		if f_string_to_boolean(ls_encrypted) then
			ls_preference_value_e = common_thread.eprolibnet4.encryptstring(ps_preference_value, common_thread.key())
			if ls_preference_value_e = "" then
				setnull(ls_preference_value_e)
			end if
		else
			ls_preference_value_e = ps_preference_value
		end if
	else
		ls_preference_value_e = ps_preference_value
	end if
else
	ls_preference_value_e = ps_preference_value
end if

sqlca.sp_set_preference(ps_preference_type, ps_preference_level, ps_preference_key, ps_preference_id, ls_preference_value_e)
if not sqlca.check() then return -1

// Reload the user preferences in case something changed
if not isnull(current_user) then
	current_user.get_preferences()
end if


return 1

end function

private function str_property get_fixed_property (string ps_object, string ps_property);str_property lstr_property
string ls_filter
long i
string ls_temp

setnull(lstr_property.property_id)
lstr_property.property_type = "Built In"
lstr_property.property_object = ps_object
lstr_property.description = ps_property
setnull(lstr_property.title)
lstr_property.function_name = ps_property
lstr_property.return_data_type = "string"
setnull(lstr_property.script_language)
setnull(lstr_property.script)
setnull(lstr_property.service)
lstr_property.status = "OK"
setnull(lstr_property.property_value_object)
setnull(lstr_property.property_value_object_key)
setnull(lstr_property.property_value_object_filter)
setnull(lstr_property.property_value_object_unique)
setnull(lstr_property.property_value_object_cat_fld)
setnull(lstr_property.property_value_object_cat_qury)
lstr_property.property_name = ps_property
lstr_property.property_help = ps_property
setnull(lstr_property.sort_sequence)
	
// Set the property_domain
if len(lstr_property.property_value_object) > 0 then
	lstr_property.property_domain = lstr_property.property_value_object
	if len(lstr_property.property_value_object_key) > 0 then
		lstr_property.property_domain += "." + lstr_property.property_value_object_key
	end if
else
	lstr_property.property_domain = lstr_property.function_name
end if

return lstr_property


end function

public function str_room_type room_type (string ps_room_type);str_room_type lstr_room_type
string ls_find
long ll_row

if room_types.rowcount() <= 0 then load_room_types()

ls_find = "room_type='" + ps_room_type + "'"
ll_row = room_types.find(ls_find, 1, room_types.rowcount())
if ll_row <= 0 or isnull(ll_row) then
	setnull(lstr_room_type.room_type)
else
	lstr_room_type.room_type = room_types.object.room_type[ll_row]
	lstr_room_type.description = room_types.object.description[ll_row]
	lstr_room_type.button = room_types.object.button[ll_row]
	lstr_room_type.dirty_button = room_types.object.dirty_button[ll_row]
end if


return lstr_room_type

end function

public function long load_room_types ();long ll_rows

room_types.set_dataobject("dw_c_room_type")

ll_rows = room_types.retrieve()

return ll_rows

end function

public function string age_range_description (long pl_age_range_id);string ls_description

SELECT description
INTO :ls_description
FROM c_Age_Range
WHERE age_range_id = :pl_age_range_id;
if not tf_check() then
	setnull(ls_description)
elseif sqlca.sqlnrows <> 1 then
	setnull(ls_description)
end if


return ls_description

	
	
end function

on u_list_data.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_list_data.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;long ll_count

table_update = CREATE u_ds_data
attachment_location = CREATE u_ds_data
attachment_types = CREATE u_ds_data
assessment_definition = CREATE u_ds_data
assessment_types = CREATE u_ds_data
c_config_object_type = CREATE u_ds_data
chart_page_attributes = CREATE u_ds_data
consultants = CREATE u_ds_data
display_script_selection = CREATE u_ds_data
display_scripts = CREATE u_ds_data
display_script_commands = CREATE u_ds_data
display_script_command_attributes = CREATE u_ds_data
encounter_types = CREATE u_ds_data
epro_object = CREATE u_ds_data
extensions = CREATE u_ds_data
em_component_level = CREATE u_ds_data
em_type_level = CREATE u_ds_data
external_source_types = CREATE u_ds_data
external_observations = CREATE u_ds_data
folder_selection = CREATE u_ds_data
treatment_types = CREATE u_ds_data
treatment_type_list = CREATE u_ds_data
treatment_type_list_def = CREATE u_ds_data
observation_types = CREATE u_ds_data
observation_categories = CREATE u_ds_data
observation_tree = CREATE u_ds_data
observations = CREATE u_ds_data
observation_results = CREATE u_ds_data
preferences = CREATE u_ds_data
progress_types = CREATE u_ds_data
specialties = CREATE u_ds_data
c_Property = CREATE u_ds_data
c_Property_Attribute = CREATE u_ds_data
offices = CREATE u_ds_data
property_types = CREATE u_ds_data
location_domains = CREATE u_ds_data
locations = CREATE u_ds_data
domain_items = CREATE u_ds_data
procedure_types = CREATE u_ds_data
qualifier_domains = CREATE u_ds_data
qualifier_domain_categories = CREATE u_ds_data
room_types = CREATE u_ds_data
services = CREATE u_ds_data
menus = CREATE u_ds_data
menu_items = CREATE u_ds_data
menu_items.set_dataobject("dw_c_menu_item")
exam_definition = CREATE u_ds_data
exam_default_results = CREATE u_ds_data
visit_level = CREATE u_ds_data
visit_level_rule = CREATE u_ds_data
visit_level_rule_item = CREATE u_ds_data
vial_type = CREATE u_ds_data
workplan = CREATE u_ds_data
workplan.set_dataobject("dw_c_workplan")

// Property column reference
property_columns_patient = CREATE u_ds_data
property_columns_encounter = CREATE u_ds_data
property_columns_assessment = CREATE u_ds_data
property_columns_treatment = CREATE u_ds_data
property_columns_patient.set_dataobject("dw_p_patient")
property_columns_encounter.set_dataobject("dw_encounter_data")
property_columns_assessment.set_dataobject("dw_assessment_data")
property_columns_treatment.set_dataobject("dw_treatment_data")

// Clinical data cache
clinical_data_cache = CREATE u_clinical_data_cache

// Epro Object data cache
epro_object_data_cache = CREATE u_epro_object_data_cache

xml_class = CREATE u_ds_data

observation_find = CREATE u_ds_data
datafind = CREATE u_ds_data
observation_tree_lookup = CREATE u_ds_data

observation_find.set_dataobject("dw_sp_find_observation")
observations.set_dataobject("dw_c_observation_cache")
assessment_definition.set_dataobject("dw_c_assessment_definition")
observation_results.set_dataobject("dw_c_observation_result")
observation_tree.set_dataobject("dw_c_observation_tree")
observation_tree_lookup.set_dataobject("dw_observation_tree_cache")

observation_stages = CREATE u_ds_data
observation_stages.set_dataobject("dw_c_observation_stage")
setnull(stage_observation_id)

open_encounters = CREATE u_ds_data
open_encounters.set_dataobject("dw_sp_open_encounters")
active_services = CREATE u_ds_data
active_services.set_dataobject("dw_sp_active_services_35")
office_rooms = CREATE u_ds_data
office_rooms.set_dataobject("dw_office_rooms")
setnull(office_last_refresh)

display_scripts.set_dataobject("dw_sp_display_script_list")
display_script_commands.set_dataobject("dw_c_display_script_command")
display_script_command_attributes.set_dataobject("dw_c_display_script_cmd_attribute")

code_by_epro = CREATE u_ds_data
code_by_epro.set_dataobject("dw_xml_code_lookup_code")

vial_type.set_dataobject("dw_vial_type_list")

preferences.set_dataobject("dw_c_preference")
ll_count = preferences.retrieve()

epro_object.set_dataobject("dw_epro_object_data")
ll_count = epro_object.retrieve()

return


end event

