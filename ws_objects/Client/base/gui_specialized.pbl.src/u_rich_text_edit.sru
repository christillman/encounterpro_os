$PBExportHeader$u_rich_text_edit.sru
forward
global type u_rich_text_edit from u_richtextedit
end type
type str_command_info from structure within u_rich_text_edit
end type
type str_current_progress from structure within u_rich_text_edit
end type
type str_object_menu from structure within u_rich_text_edit
end type
type str_reentry_state from structure within u_rich_text_edit
end type
end forward

type str_command_info from structure
	str_c_display_script_command		command
	long		parent_command_index
	str_charrange		footprint
	boolean		error
	string		error_text
end type

type str_current_progress from structure
	string		context_object
	long		object_key
	str_progress		progress
end type

type str_object_menu from structure
	integer		object_id
	long		menu_id
	str_attributes		attributes
end type

type str_reentry_state from structure
	str_display_script		display_script
	long		last_index
	str_encounter_description		encounter
	str_assessment_description		assessment
	str_treatment_description		treatment
	str_font_settings		font_settings
end type

global type u_rich_text_edit from u_richtextedit
event lbuttondown pbm_renlbuttondown
event scrollto ( long pl_scrollto )
event signature_captured ( str_captured_signature pstr_captured_signature )
end type
global u_rich_text_edit u_rich_text_edit

type variables
boolean debug_mode
w_display_script_config editor_window

u_ds_data treatment_workplans
u_ds_data treatment_workplan_items
integer treatment_workplan_count
long workplans_treatment_id = 0

u_ds_data encounter_workplans
u_ds_data encounter_workplan_items
integer encounter_workplan_count
long workplans_encounter_id = 0

// Record the first context so we can do a refresh
long first_display_script_id
str_encounter_description first_encounter
str_assessment_description first_assessment
str_treatment_description first_treatment

// Record the latest context
str_complete_context last_context
str_encounter_description last_encounter
str_assessment_description last_assessment
str_treatment_description last_treatment

// Current operation
string current_context_object
long current_object_key

boolean nested = false

integer rtf_id

protected str_attributes report_attributes
protected str_attributes original_report_attributes

integer error_retries_max = 5

string reader_user_id

// header/footer controlled by attributes passed in as report attributes
boolean print_header = true
boolean print_footer = true
long header_display_script_id = 0
long footer_display_script_id = 0

integer signature_object_id
str_capture_signature_request capture_signature_request
str_captured_signature captured_signature

// processing flags set by screen where control is painted
boolean process_local = false
boolean process_header_footer = true
boolean auto_redraw_off = true

str_font_settings default_menu_font_settings

private str_command_info command[]
private long command_count
private long parent_command_index

str_c_display_script_command parent_display_script_command

private str_current_progress current_progress

private long object_menu_count
private str_object_menu object_menu[]

// private error message area for catching errors that don't throw exceptions
private boolean command_error
private string command_error_text

private str_font_settings error_font_settings

private boolean breakpoint_set
private str_c_display_script_command breakpoint
private boolean is_on_break
private str_reentry_state reentry_state

// To locate the rte control, to replace text etc.
// ulong        hWin  
// hWin = Handle ( this )  
// hWin = FindWindowEx ( hWin, 0, "Ter24Class", 0 )  
// (see https://www.brucearmstrong.org/2017/08/spell-checking-in-new-powerbuilder-2017.html )
 

end variables

forward prototypes
public function string workplan_item_attribute (u_ds_data puo_workplan_items, string ps_which_item, string ps_attribute)
public function string treatment_workplan_attribute (long pl_treatment_id, string ps_attribute)
public function string treatment_workplan_item_attribute (long pl_treatment_id, string ps_which_item, string ps_attribute)
public function string encounter_workplan_attribute (long pl_encounter_id, string ps_attribute)
public function string encounter_workplan_item_attribute (long pl_encounter_id, string ps_which_item, string ps_attribute)
public subroutine display_encounter (long pl_encounter_id)
public subroutine display_treatment (long pl_treatment_id)
public function integer load_treatment_workplans (long pl_treatment_id)
public function integer load_encounter_workplans (long pl_encounter_id)
public function string workplan_attribute (u_ds_data puo_workplan, string ps_attribute)
public subroutine display_script_command (str_c_display_script_command pstr_command, str_encounter_description pstr_encounter, str_assessment_description pstr_assessment, str_treatment_description pstr_treatment)
public function long display_script_command_general (str_c_display_script_command pstr_command)
public function long display_script_command_assessment (str_c_display_script_command pstr_command, str_assessment_description pstr_assessment)
public function long display_script_command_encounter (str_c_display_script_command pstr_command, str_encounter_description pstr_encounter)
public function long display_script_command_patient (str_c_display_script_command pstr_command)
public function long display_script_command_treatment (str_c_display_script_command pstr_command, str_treatment_description pstr_treatment)
public function string display_script (long pl_display_script_id, str_encounter_description pstr_encounter, str_assessment_description pstr_assessment, str_treatment_description pstr_treatment)
public subroutine display_script (long pl_display_script_id)
public subroutine display_treatment (long pl_treatment_id, long pl_display_script_id)
public subroutine display_encounter (long pl_encounter_id, long pl_display_script_id)
public subroutine redisplay ()
public function integer display_user_signature_stamp (string ps_user_id, long pl_width_inches, long pl_height_inches)
public function integer display_observation_results (u_ds_observation_results puo_results, string ps_result_type, string ps_abnormal_flag, string ps_format)
public function integer display_encounter_observation (str_encounter_description pstr_encounter, string ps_observation_id, string ps_result_type, boolean pb_continuous, boolean pb_latest_only)
public function integer display_encounter_services (str_encounter_description pstr_encounter, string ps_service, string ps_which, string ps_format)
public function integer display_services (u_ds_data puo_data, string ps_service, string ps_which, string ps_format)
public function integer display_treatment_services (str_treatment_description pstr_treatment, string ps_service, string ps_which, string ps_format)
public function integer display_workplan (long pl_patient_workplan_id, string ps_format)
public function integer display_progress_old (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_progress_display_style, boolean pb_current_only)
public function integer display_user_property (string ps_user_id, string ps_property, long pl_bitmap_width_inches, long pl_bitmap_height_inches)
public function integer display_encounter_objects (boolean pb_since_last_encounter)
public subroutine display_assessment (str_assessment_description pstr_assessment, long pl_display_script_id)
public function integer display_attachments (string ps_folder, string ps_attachment_type, string ps_attachment_tag, string ps_extension, long pl_bitmap_width_inches, long pl_bitmap_height_inches, boolean pb_page_break)
public function boolean if_query (string ps_query)
public function integer display_treatment_followup_items (long pl_treatment_id, string ps_empty_phrase)
public function integer display_encounter_owner_treatments (str_encounter_description pstr_encounter, string ps_treatment_type, long pl_display_script_id, string ps_which, string ps_sort_column, string ps_sort_direction)
public function integer display_encounter_treatments (str_encounter_description pstr_encounter, string ps_treatment_type, long pl_display_script_id, string ps_treatment_status, boolean pb_owner_flag, boolean pb_show_previous, boolean pb_show_new, boolean pb_show_created_in_plan, string ps_sort_column, string ps_sort_direction)
public function integer display_patient_encounters (string ps_encounter_type, long pl_display_script_id, string ps_sort_column, string ps_sort_direction)
public function integer display_patient_treatments (string ps_treatment_type, long pl_display_script_id, string ps_which, datetime pdt_begin_date, datetime pdt_end_date, string ps_header_phrase, string ps_footer_phrase, string ps_sort_column, string ps_sort_direction)
public function integer display_encounter_assessments (str_encounter_description pstr_encounter, string ps_assessment_type, string ps_exclude_assessment_type, string ps_acuteness, long pl_display_script_id, boolean pb_billed_only, boolean pb_show_previous, boolean pb_show_new, string ps_assessment_status, string ps_header_phrase, string ps_footer_phrase, string ps_sort_column, string ps_sort_direction)
public function integer display_patient_assessments (string ps_assessment_type, string ps_exclude_assessment_type, string ps_acuteness, long pl_display_script_id, string ps_which, string ps_header_phrase, string ps_footer_phrase, string ps_sort_column, string ps_sort_direction)
public function integer display_patient_health_maintenance (string ps_header_phrase, string ps_footer_phrase, string ps_empty_phrase, string ps_body_format, boolean pb_use_colors)
public function integer display_encounter_observations (str_encounter_description pstr_encounter, string ps_observation_type, long pl_display_script_id, boolean pb_show_previous, boolean pb_show_new, string ps_sort_column, string ps_sort_direction)
public function integer display_encounter_owner_observations (str_encounter_description pstr_encounter, string ps_observation_type, long pl_display_script_id, boolean pb_show_previous, boolean pb_show_new, string ps_sort_column, string ps_sort_direction)
public function boolean is_provider (string ps_user_id)
public function integer display_patient_services (string ps_service, string ps_which, string ps_format)
public function integer display_immunization_status (long pl_encounter_id, boolean pb_show_reason)
public function string get_last_progress_property (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_progress_property)
public subroutine set_report_attributes (str_attributes pstr_attributes)
public subroutine display_script_from_attributes (str_attributes pstr_attributes, long pl_display_script_id)
public subroutine add_hot_text (string ps_text, long pl_menu_id)
public function string display_script_local (long pl_display_script_id, str_encounter_description pstr_encounter, str_assessment_description pstr_assessment, str_treatment_description pstr_treatment, long pl_width, long pl_height)
private subroutine display_assessment_treatments (str_assessment_description pstr_assessment, string ps_treatment_type, boolean pb_current_only, long pl_display_script_id, string ps_sort_column, string ps_sort_direction, boolean pb_attached_treatments_only)
public function integer display_sql_query (string ps_sql, boolean pb_show_headings, boolean pb_show_lines)
public function integer display_sql_query_renorm (string ps_sql, string ps_column_1_title, boolean pb_include_row_total, boolean pb_include_row_average, boolean pb_include_column_total, boolean pb_include_column_average, str_rtf_table_attributes pstr_table_attributes, string ps_data_display_format)
public function integer add_property (str_property_value pstr_property, boolean pb_include_formatting, long pl_menu_id, string ps_context_object, long pl_object_key)
public function integer display_datawindowobject (string ps_dwsyntax, string ps_sql)
public function integer display_messages (string ps_cpr_id, string ps_context_object, long pl_object_key)
public function integer display_progress (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_progress_display_style, boolean pb_current_only, long pl_display_script_id)
public function integer display_patient_alerts (string ps_which, string ps_status)
public function integer display_document (str_c_display_script_command pstr_command, long pl_object_key)
public subroutine add_object_menu (integer pi_object_id, long pl_menu_id)
public function integer display_attachment (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, long pl_bitmap_width_inches, long pl_bitmap_height_inches, string ps_placement, boolean pb_text_flow_around, long pl_xpos, long pl_ypos, boolean pb_page_break, string ps_which, boolean pb_sort_descending, string ps_caption, boolean pb_carriage_return, long pl_menu_id)
public function integer add_property_attachment (str_property_value ps_property_value, long pl_bitmap_width_inches, long pl_bitmap_height_inches, string ps_placement, boolean pb_text_flow_around, long pl_xpos, long pl_ypos, string ps_caption, boolean pb_carriage_return, long pl_menu_id)
private subroutine display_treatment_treatments (str_treatment_description pstr_treatment, string ps_treatment_type, long pl_display_script_id, string ps_sort_column, string ps_sort_direction, boolean pb_include_deleted)
public subroutine log_error (string ps_error_text)
public subroutine set_breakpoint (str_c_display_script_command pstr_breakpoint)
public subroutine clear_breakpoint ()
private function string display_script_a (long pl_display_script_id, str_encounter_description pstr_encounter, str_assessment_description pstr_assessment, str_treatment_description pstr_treatment, boolean pb_is_reentry)
public subroutine display_script_reentry ()
public function long select_next_command (long pl_last_command_index, str_c_display_script_command pstr_command)
public function boolean breakpoint (ref str_c_display_script_command pstr_command)
public subroutine open_editor (str_c_display_script_command_stack pstr_stack)
public subroutine open_editor ()
public function str_c_display_script_command_stack command_stack_for_charposition (str_charposition pstr_charposition)
end prototypes

public function string workplan_item_attribute (u_ds_data puo_workplan_items, string ps_which_item, string ps_attribute);string ls_item
long ll_row
string ls_user_id
datetime ldt_datetime
string ls_service
string ls_step_number
string ls_item_number
string ls_temp
string ls_find
string ls_value

setnull(ls_item)

ps_attribute = lower(trim(ps_attribute))

if isnull(ps_which_item) then return ls_item

f_split_string(ps_which_item, ",", ls_service, ls_temp)
f_split_string(ls_temp, ",", ls_step_number, ls_item_number)

ls_service = lower(trim(ls_service))
ls_step_number = lower(trim(ls_step_number))
ls_item_number = lower(trim(ls_item_number))

ls_find = "lower(ordered_service)='" + ls_service + "'"
if ls_step_number <> "" and ls_item_number <> "" then
	ls_find += " and step_number=" + ls_step_number
	ls_find += " and item_number=" + ls_item_number
end if

ll_row = puo_workplan_items.find(ls_find, 1, puo_workplan_items.rowcount())
if ll_row <= 0 then return ls_item

ls_value = puo_workplan_items.get_field_value(ll_row, ps_attribute)

ls_item = f_property_value_display(ps_attribute, ls_value)

return ls_item

end function

public function string treatment_workplan_attribute (long pl_treatment_id, string ps_attribute);
load_treatment_workplans(pl_treatment_id)

return workplan_attribute(treatment_workplans, ps_attribute)

end function

public function string treatment_workplan_item_attribute (long pl_treatment_id, string ps_which_item, string ps_attribute);
load_treatment_workplans(pl_treatment_id)

return workplan_item_attribute(treatment_workplan_items, ps_which_item, ps_attribute)

end function

public function string encounter_workplan_attribute (long pl_encounter_id, string ps_attribute);
load_encounter_workplans(pl_encounter_id)

return workplan_attribute(encounter_workplans, ps_attribute)

end function

public function string encounter_workplan_item_attribute (long pl_encounter_id, string ps_which_item, string ps_attribute);
load_encounter_workplans(pl_encounter_id)

return workplan_item_attribute(encounter_workplan_items, ps_which_item, ps_attribute)

end function

public subroutine display_encounter (long pl_encounter_id);long ll_display_script_id

setnull(ll_display_script_id)

display_encounter(pl_encounter_id, ll_display_script_id)

end subroutine

public subroutine display_treatment (long pl_treatment_id);long ll_display_script_id

setnull(ll_display_script_id)

display_treatment(pl_treatment_id, ll_display_script_id)

end subroutine

public function integer load_treatment_workplans (long pl_treatment_id);long ll_patient_workplan_id
long ll_count

if isnull(treatment_workplans) or not isvalid(treatment_workplans) then
	treatment_workplans = CREATE u_ds_data
	treatment_workplans.set_dataobject("dw_treatment_workplans")
end if

if isnull(treatment_workplan_items) or not isvalid(treatment_workplan_items) then
	treatment_workplan_items = CREATE u_ds_data
end if

if workplans_treatment_id <> pl_treatment_id then
	treatment_workplan_count = treatment_workplans.retrieve(current_patient.cpr_id, pl_treatment_id)
	
	treatment_workplan_items.set_dataobject("dw_p_patient_wp_item")

	if treatment_workplan_count >= 1 then
		ll_patient_workplan_id = treatment_workplans.object.patient_workplan_id[1]
		ll_count = treatment_workplan_items.retrieve(ll_patient_workplan_id)
		if ll_count < 0 then
			log_error("Error retrieving treatment workplans")
		end if
	end if
	
	workplans_treatment_id = pl_treatment_id
end if

return treatment_workplan_count

end function

public function integer load_encounter_workplans (long pl_encounter_id);long ll_count
long ll_patient_workplan_id

if isnull(encounter_workplans) or not isvalid(encounter_workplans) then
	encounter_workplans = CREATE u_ds_data
	encounter_workplans.set_dataobject("dw_encounter_workplan")
end if

if isnull(encounter_workplan_items) or not isvalid(encounter_workplan_items) then
	encounter_workplan_items = CREATE u_ds_data
end if

if pl_encounter_id <> workplans_encounter_id then
	encounter_workplan_count = encounter_workplans.retrieve(current_patient.cpr_id, pl_encounter_id)
	
	encounter_workplan_items.set_dataobject("dw_p_patient_wp_item")

	if encounter_workplan_count >= 1 then
		ll_patient_workplan_id = encounter_workplans.object.patient_workplan_id[1]
		ll_count = encounter_workplan_items.retrieve(ll_patient_workplan_id)
		if ll_count < 0 then
			log_error("Error retrieving workplans")
		end if
	end if
	
	workplans_encounter_id = pl_encounter_id
end if

return encounter_workplan_count

end function

public function string workplan_attribute (u_ds_data puo_workplan, string ps_attribute);long ll_row
string ls_value

setnull(ls_value)

if puo_workplan.rowcount() <= 0 then return ls_value

ll_row = 1

ps_attribute = lower(trim(ps_attribute))

ls_value = puo_workplan.get_field_value(ll_row, ps_attribute)

return ls_value

end function

public subroutine display_script_command (str_c_display_script_command pstr_command, str_encounter_description pstr_encounter, str_assessment_description pstr_assessment, str_treatment_description pstr_treatment);integer li_argument
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
string ls_context_object
long ll_null
long ll_command_index
long ll_parent_command_index
long ll_temp_indentl

setnull(ll_null)
setnull(ls_text)

//ll_temp_indentl = object.indentl

// Check each of the command attributes for runtime substitution
f_attribute_value_substitute_multiple(pstr_command.attributes, last_context, report_attributes)

current_context_object = pstr_command.context_object


command_count += 1
ll_command_index = command_count
command[ll_command_index].command = pstr_command
command[ll_command_index].parent_command_index = parent_command_index
command[ll_command_index].footprint.from_position = charposition()

// Save the previous parent command index
ll_parent_command_index = parent_command_index

// Set the parent command index to this command
parent_command_index = command_count

command_error = false
command_error_text = ""

TRY
	CHOOSE CASE lower(current_context_object)
		CASE "treatment"
			// Make sure we have a treatment
			if isnull(pstr_treatment.treatment_id) then return
			current_object_key = pstr_treatment.treatment_id
			display_script_command_treatment(pstr_command, pstr_treatment)
		CASE "assessment"
			// Make sure we have an assessment
			if isnull(pstr_assessment.problem_id) then return
			current_object_key = pstr_assessment.problem_id
			display_script_command_assessment(pstr_command, pstr_assessment)
		CASE "encounter"
			// Make sure we have an encounter
			if isnull(pstr_encounter.encounter_id) then return
			current_object_key = pstr_encounter.encounter_id
			display_script_command_encounter(pstr_command, pstr_encounter)
		CASE "patient"
			// Make sure we have a patient
			if isnull(current_patient) then return
			if isnull(current_patient.cpr_id) then return
			setnull(current_object_key)
			display_script_command_patient(pstr_command)
		CASE "general"
			setnull(current_object_key)
			display_script_command_general(pstr_command)
		CASE ELSE
	END CHOOSE
CATCH (throwable  lo_error )
	command_error = true
	command_error_text = lo_error.text
END TRY

if command_error then
	if isnull(command_error_text) or trim(command_error_text) = "" then command_error_text = "Error"
	command[ll_command_index].error = command_error
	command[ll_command_index].error_text = command_error_text
	
	if config_mode then add_text(command_error_text, error_font_settings)
end if

command_error = false
command_error_text = ""

//ll_temp_indentl = object.indentl


// Save the final footprint end
command[ll_command_index].footprint.to_position = charposition()
// The charposition() actually returns the character after the insertion point but we want the character before the insertion point, unless the insertion point is before the first character already.
if command[ll_command_index].footprint.to_position.char_position > 1 then
	command[ll_command_index].footprint.to_position.char_position -= 1
end if

// Restore the previous parent command index
parent_command_index = ll_parent_command_index

end subroutine

public function long display_script_command_general (str_c_display_script_command pstr_command);boolean lb_include_row_total
boolean lb_include_row_average
boolean lb_include_column_total
boolean lb_include_column_average
string ls_data_display_format
string ls_column_1_title
str_rtf_table_attributes lstr_grid_table_attributes
string ls_attribute_name
string ls_attribute_value
boolean lb_text_flow_around
string ls_operator
string ls_text
string ls_argument
long ll_linelength
long ll_currentline
long ll_last_nonempty_line
integer li_sts
boolean lb_found
str_observation_comment lstr_comment
integer li_blank_lines
string ls_context_object
integer li_lines
long i
integer li_spaces
integer li_characters
long ll_property_id
boolean lb_include_formatting
str_property_value lstr_property_value
string ls_temp
str_grid lstr_grid
string ls_query
u_ds_data luo_data
boolean lb_show_headings
boolean lb_show_lines
string ls_empty_phrase
string ls_header_phrase
string ls_footer_phrase
long ll_curpos
string ls_property
long ll_null
string ls_office_id
string ls_field_name
long ll_menu_id
str_service_info lstr_service
string ls_fielddata
string ls_image_file
long ll_width
long ll_height
long ll_material_id
str_patient_material lstr_material
string ls_placement
long ll_xpos
long ll_ypos
long ll_display_script_id
string ls_left_side
string ls_right_side
string ls_right_side_2
string ls_temp1
string ls_temp2
long ll_rows
string ls_format
long ll_textboxid
str_attributes lstr_attributes
integer li_object_id
string ls_capture_from_user
string ls_capture_title
string ls_capture_prompt
boolean lb_allow_user_change
string ls_caption
long ll_color
str_charposition lstr_startpos

setnull(ls_text)
setnull(ll_null)

lstr_startpos = charposition()

ll_menu_id = long(f_attribute_find_attribute(pstr_command.attributes, "menu_id"))

CHOOSE CASE lower(pstr_command.display_command)
	CASE "background color"
		ll_color = long(f_attribute_find_attribute(pstr_command.attributes, "background_color"))
		if not isnull(ll_color) then
			//set_backcolor(ll_color)
			// automatically change the text backcolor to the new page backcolor
			set_text_back_color(ll_color)
		end if
	CASE "background image"
		ll_material_id = long(f_attribute_find_attribute(pstr_command.attributes, "image_material_id"))
		
		if ll_material_id > 0 then
			ls_image_file = f_get_patient_material_file(ll_material_id)
			if not isnull(ls_image_file) then
				set_background_image(ls_image_file)
			end if
		end if

	CASE "blank line"
		li_lines = integer(f_attribute_find_attribute(pstr_command.attributes, "lines"))
		blank_lines(li_lines)
	CASE "body"
		blank_lines(0)
		set_detail()
		return 1
	CASE "capture signature"
		ll_material_id = long(f_attribute_find_attribute(pstr_command.attributes, "prompt_image_material_id"))
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
		ls_placement = f_attribute_find_attribute(pstr_command.attributes, "placement")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "text_flow_around")
		if isnull(ls_temp) then ls_temp = "True"
		lb_text_flow_around = f_string_to_boolean(ls_temp)
		ll_xpos = long(f_attribute_find_attribute(pstr_command.attributes, "xposition"))
		ll_ypos = long(f_attribute_find_attribute(pstr_command.attributes, "yposition"))
		ls_capture_from_user = f_attribute_find_attribute(pstr_command.attributes, "capture_from_user")
		ls_capture_title = f_attribute_find_attribute(pstr_command.attributes, "capture_title")
		ls_capture_prompt = f_attribute_find_attribute(pstr_command.attributes, "capture_prompt")
		lb_allow_user_change = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "allow_user_change"))

		if ll_material_id > 0 then
			ls_image_file = f_get_patient_material_file(ll_material_id)
			if not isnull(ls_image_file) then
				li_object_id = add_image(ls_image_file, ll_width, ll_height, ls_placement, lb_text_flow_around, ll_xpos, ll_ypos)
				if li_object_id <= 0 then return 0
				
				signature_object_id = li_object_id
				
				capture_signature_request.capture_from_user = ls_capture_from_user
				capture_signature_request.capture_title = ls_capture_title
				capture_signature_request.capture_prompt = ls_capture_prompt
				capture_signature_request.allow_user_change = lb_allow_user_change
				capture_signature_request.render_width = ll_width
				capture_signature_request.render_height = ll_height
				
				return 1
			else
				return 0
			end if
		else
			return 0
		end if
	CASE "compare"
		ls_left_side = f_attribute_find_attribute(pstr_command.attributes, "left_side")
		ls_right_side = f_attribute_find_attribute(pstr_command.attributes, "right_side")
		ls_right_side_2 = f_attribute_find_attribute(pstr_command.attributes, "right_side_2")
		ls_operator = f_attribute_find_attribute(pstr_command.attributes, "operator")
		if isnull(ls_operator) then ls_operator = "="

		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "display_text")

		if f_string_compare_2(ls_left_side, ls_right_side, ls_right_side_2, ls_operator) then
			if not isnull(ll_display_script_id) then
				display_script(ll_display_script_id, last_encounter, last_assessment, last_treatment)
			end if
			if len(ls_argument) > 0 then
				ls_text = ls_argument
			end if
		end if
	CASE "cr"
		li_lines = integer(f_attribute_find_attribute(pstr_command.attributes, "lines"))
		if isnull(li_lines) or li_lines <= 0 then li_lines = 1
		if li_lines > 50 then li_lines = 50

		for i = 1 to li_lines
			add_cr()
		next
		return li_lines
	CASE "cr if line not empty"
		ll_linelength = linelength()
		if ll_linelength > 0 then
			add_cr()
			return 1
		else
			return 0
		end if
	CASE "date"
		ls_text = string(today())
	CASE "document"
		li_sts = display_document(pstr_command, ll_null)
		if li_sts <= 0 then return li_sts
	CASE "execute query"
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))

		// Substitute tokens in the query
		ls_query = f_attribute_value_substitute_string(ls_query, last_context, report_attributes)
		
		luo_data = CREATE u_ds_data
		ll_rows = luo_data.load_query(ls_query)
		if ll_rows > 0 then
//			lstr_grid = luo_data.get_grid()
			
			if not isnull(ls_header_phrase) then
				add_text(ls_header_phrase)
				add_cr()
			end if
			
			for i = 1 to ll_rows
				lstr_attributes = luo_data.get_attributes_from_row(i)
				display_script_from_attributes(lstr_attributes, ll_display_script_id)
			next
			
			if not isnull(ls_footer_phrase) then
				add_cr()
				add_text(ls_footer_phrase)
			end if
		elseif ll_rows < 0 then
			ls_temp = "Error processing query.  "
			ls_temp += "display_script_id=" + string(pstr_command.display_script_id)
			ls_temp += ", display_command_id=" + string(pstr_command.display_command_id)
			ls_temp += ", query=" + ls_query
			log.log(this, "u_rich_text_edit.display_script_command_general:0216", ls_temp, 4)
			add_text("<Query Error>")
		else
			add_text(ls_empty_phrase)
		end if
		
		if f_char_position_compare(charposition(), lstr_startpos) = 0 then
			return 0
		end if
		return 1
	CASE "execute script"
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		display_script(ll_display_script_id, last_encounter, last_assessment, last_treatment)
	CASE "footer"
		set_footer()
		return 1
	CASE "format"
		ls_format = f_attribute_find_attribute(pstr_command.attributes, "format")
		if lower(ls_format) = "redraw off" then
//			set_redraw(false)
		elseif lower(ls_format) = "redraw on" then
//			set_redraw(true)
		else
			apply_formatting(ls_format)
		end if
		return 1
	CASE "header"
		set_header()
		return 1
	CASE "image"
		ll_material_id = long(f_attribute_find_attribute(pstr_command.attributes, "image_material_id"))
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
		ls_placement = f_attribute_find_attribute(pstr_command.attributes, "placement")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "text_flow_around")
		if isnull(ls_temp) then ls_temp = "True"
		lb_text_flow_around = f_string_to_boolean(ls_temp)
		ll_xpos = long(f_attribute_find_attribute(pstr_command.attributes, "xposition"))
		ll_ypos = long(f_attribute_find_attribute(pstr_command.attributes, "yposition"))

		if ll_material_id > 0 then
			ls_image_file = f_get_patient_material_file(ll_material_id)
			if not isnull(ls_image_file) then
				add_image(ls_image_file, ll_width, ll_height, ls_placement, lb_text_flow_around, ll_xpos, ll_ypos)
				return 1
			else
				return 0
			end if
		else
			return 0
		end if
	CASE "office"
		ls_office_id = f_attribute_find_attribute(pstr_command.attributes, "office_id")
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		if isnull(ls_property) then ls_property = "description"
		ls_text = datalist.office_field(ls_office_id, ls_property)
	CASE "page"
		add_page_break()
		return 1
	CASE "print"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "print_string")
		
		// Interpret string literal directives (e.g. ~t, ~n, etc)
		ls_temp = f_string_set_special_characters(ls_argument)
		
		if len(ls_temp) > 0 then ls_text = ls_temp
	CASE "property"
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "include_formatting")
		if isnull(ls_temp) then
			lb_include_formatting = true
		else
			lb_include_formatting = f_string_to_boolean(ls_temp)
		end if
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		lstr_property_value = f_get_property("General", ls_property, ll_null, report_attributes)
		li_sts = add_property(lstr_property_value, lb_include_formatting, ll_menu_id, "General", ll_null)
		return li_sts
	CASE "query"
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		lb_show_headings = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_headings"))
		lb_show_lines = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_lines"))

		// Substitute tokens in the query
		ls_query = f_attribute_value_substitute_string(ls_query, last_context, report_attributes)
		
		if not isnull(ls_header_phrase) then
			add_text(ls_header_phrase)
			add_cr()
		end if
		
		if isnull(ls_query) or trim(ls_query) = "" then
			log.log(this, "u_rich_text_edit.display_script_command_general:0310", "No Query", 3)
			li_sts = 0
		else
			li_sts = display_sql_query(ls_query, lb_show_headings, lb_show_lines)
			if li_sts < 0 then
				ls_temp = "Error processing query.  "
				ls_temp += "display_script_id=" + string(pstr_command.display_script_id)
				ls_temp += ", display_command_id=" + string(pstr_command.display_command_id)
				ls_temp += ", query=" + ls_query
				log.log(this, "u_rich_text_edit.display_script_command_general:0319", ls_temp, 4)
				add_text("<Query Error>")
			end if
		end if
		
		if li_sts = 0 then
			add_text(ls_empty_phrase)
		elseif li_sts > 0 then
			if not isnull(ls_footer_phrase) then
				add_cr()
				add_text(ls_footer_phrase)
			end if
		end if

		if f_char_position_compare(charposition(), lstr_startpos) = 0 then
			return 0
		end if
		return 1
	CASE "query grid"
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		lb_include_row_total = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "include_row_total"))
		lb_include_row_average = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "include_row_average"))
		lb_include_column_total = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "include_column_total"))
		lb_include_column_average = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "include_column_average"))
		lb_show_lines = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_lines"))
		ls_column_1_title = f_attribute_find_attribute(pstr_command.attributes, "column_1_title")
		ls_data_display_format = f_attribute_find_attribute(pstr_command.attributes, "data_display_format")
		if isnull(ls_data_display_format) then
			ls_data_display_format = "0.##"
		end if

		// Substitute tokens in the query
		ls_query = f_attribute_value_substitute_string(ls_query, last_context, report_attributes)
		
		if not isnull(ls_header_phrase) then
			add_text(ls_header_phrase)
			add_cr()
		end if
		
		lstr_grid_table_attributes.suppress_lines = NOT lb_show_lines
		
		li_sts = display_sql_query_renorm(ls_query, ls_column_1_title, lb_include_row_total, lb_include_row_average, lb_include_column_total, lb_include_column_average, lstr_grid_table_attributes, ls_data_display_format)
		
		if li_sts < 0 then
			ls_temp = "Error processing query.  "
			ls_temp += "display_script_id=" + string(pstr_command.display_script_id)
			ls_temp += ", display_command_id=" + string(pstr_command.display_command_id)
			ls_temp += ", query=" + ls_query
			log.log(this, "u_rich_text_edit.display_script_command_general:0370", ls_temp, 4)
			add_text("<Query Error>")
		elseif li_sts = 0 then
			add_text(ls_empty_phrase)
		else
			if not isnull(ls_footer_phrase) then
				add_cr()
				add_text(ls_footer_phrase)
			end if
		end if
			
		if f_char_position_compare(charposition(), lstr_startpos) = 0 then
			return 0
		end if
		return 1
	CASE "remove character"
		li_characters = integer(f_attribute_find_attribute(pstr_command.attributes, "characters"))
		if isnull(li_characters) or li_characters <= 0 then li_characters = 1
		if li_characters > 1000 then li_characters = 1000
		delete_last_chars(li_characters)
		return li_characters
	CASE "remove line"
		li_lines = integer(f_attribute_find_attribute(pstr_command.attributes, "lines"))
		if isnull(li_lines) or li_lines <= 0 then li_lines = 1
		if li_lines > 50 then li_lines = 50

		for i = 1 to li_lines
			delete_this_line()
		next
		return li_lines
	CASE "set attribute"
		ls_attribute_name = f_attribute_find_attribute(pstr_command.attributes, "attribute_name")
		ls_attribute_value = f_attribute_find_attribute(pstr_command.attributes, "attribute_value")
		f_attribute_add_attribute(report_attributes, ls_attribute_name, ls_attribute_value)
	CASE "space"
		li_spaces = integer(f_attribute_find_attribute(pstr_command.attributes, "spaces"))
		if isnull(li_spaces) or li_spaces <= 0 then li_spaces = 1
		if li_spaces > 1000 then li_spaces = 1000
		
		ls_text = fill(" ", li_spaces)
	CASE "tab"
		add_tab()
		return 1
	CASE "text box"
		// MSC 2/1/06 This command doesn't work.  I could get the text frame to appear but
		// I can't get it to populate with text without messing up the report.  We'll revisit
		// it in a later build.
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
		ls_placement = f_attribute_find_attribute(pstr_command.attributes, "placement")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "text_flow_around")
		if isnull(ls_temp) then ls_temp = "True"
		lb_text_flow_around = f_string_to_boolean(ls_temp)
		ll_xpos = long(f_attribute_find_attribute(pstr_command.attributes, "xposition"))
		ll_ypos = long(f_attribute_find_attribute(pstr_command.attributes, "yposition"))
		lb_show_lines = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_lines"))

		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "display_text")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_format = f_attribute_find_attribute(pstr_command.attributes, "format")

//		ll_textboxid = add_text_box(ll_width, ll_height, ls_placement, lb_text_flow_around, ll_xpos, ll_ypos, lb_show_lines, ls_format, ls_argument )
		if ll_textboxid <= 0 then return 0  // Adding the text box failed
		
//		set_text_box_text(ll_textboxid, ls_argument)
//
//		// Set subsequent commands to affect the text box
//		li_sts = set_text_box(ll_textboxid)
//		if li_sts <= 0 then return 0
//		
//		// Apply the specified formatting to the text box
//		if len(ls_format) > 0 then
//			apply_formatting(ls_format)
//		end if
//		
//		if ll_display_script_id > 0 then
//			// Call the display script
//			display_script(ll_display_script_id, last_encounter, last_assessment, last_treatment)
//		elseif len(ls_argument) > 0 then
//			add_hot_text(ls_argument, ll_menu_id)
//		end if
//
//		// Set subsequent commands to affect the main control
//		set_text_box(0)
		
		return 1
	CASE "time"
		ls_text = string(now())
END CHOOSE

if len(ls_text) > 0 then
	if ll_menu_id > 0 then
		// Prepare the field data string
		lstr_service.service = "Menu"
		f_attribute_add_attribute(lstr_service.attributes, "menu_id", string(ll_menu_id))

		if last_encounter.encounter_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "encounter_id", string(last_encounter.encounter_id))
		end if

		if last_assessment.problem_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "problem_id", string(last_assessment.problem_id))
		end if

		if last_treatment.treatment_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(last_treatment.treatment_id))
		end if

		ls_fielddata = f_service_to_field_data(lstr_service)
		add_field( ls_text, ls_fielddata, false)
	else
		add_text(ls_text)
	end if
end if


if f_char_position_compare(charposition(), lstr_startpos) = 0 then return 0
return 1


end function

public function long display_script_command_assessment (str_c_display_script_command pstr_command, str_assessment_description pstr_assessment);string ls_operator
integer li_sts
string ls_text
string ls_treatment_type
long ll_display_script_id
string ls_argument
string ls_progress_type
boolean lb_current_only
string ls_progress_display_style
string ls_progress_key
long ll_width
long ll_height
string ls_property
string ls_condition
boolean lb_condition
long ll_else_display_script_id
boolean lb_flag
boolean lb_include_formatting
str_property_value lstr_property_value
string ls_temp
str_grid lstr_grid
string ls_query
u_ds_data luo_data
boolean lb_show_headings
boolean lb_show_lines
string ls_empty_phrase
str_attributes lstr_attributes
string ls_header_phrase
string ls_footer_phrase
long ll_linelength
boolean lb_page_break
string ls_which
string ls_true_phrase
string ls_false_phrase
boolean lb_condition2
string ls_sort_column
string ls_sort_direction
long ll_menu_id
str_service_info lstr_service
string ls_fielddata
string ls_progress_property
string ls_user_property
boolean lb_use_supervisor
string ls_user_id
string ls_supervisor_user_id
string ls_left_side
string ls_right_side
string ls_right_side_2
string ls_temp1
string ls_temp2
long ll_xpos
long ll_ypos
boolean lb_text_flow_around
string ls_placement
string ls_result_type
string ls_abnormal_flag
string ls_observation_id
string ls_format
string ls_prefix
long ll_count
str_rtf_table_attributes lstr_table_attributes
u_ds_observation_results luo_results
boolean lb_attached_treatments_only
string ls_attached_observations_only
boolean lb_sort_descending
string ls_caption
boolean lb_carriage_return
str_charposition lstr_startpos
str_charposition lstr_curpos

setnull(ls_text)
		
lstr_startpos = charposition()

ll_menu_id = long(f_attribute_find_attribute(pstr_command.attributes, "menu_id"))

CHOOSE CASE lower(pstr_command.display_command)
	CASE "attachment"
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		ls_progress_type = f_attribute_find_attribute(pstr_command.attributes, "progress_type")
		if isnull(ls_progress_type) then ls_progress_type = "Attachment"
		ls_progress_key = f_attribute_find_attribute(pstr_command.attributes, "progress_key")
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
		ls_placement = f_attribute_find_attribute(pstr_command.attributes, "placement")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "text_flow_around")
		if isnull(ls_temp) then ls_temp = "True"
		lb_text_flow_around = f_string_to_boolean(ls_temp)
		ll_xpos = long(f_attribute_find_attribute(pstr_command.attributes, "xposition"))
		ll_ypos = long(f_attribute_find_attribute(pstr_command.attributes, "yposition"))
		ls_which = f_attribute_find_attribute(pstr_command.attributes, "which_attachment")
		lb_page_break = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "page_break"))
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "sort_direction")
		if isnull(ls_temp) then 
			lb_sort_descending = false
		elseif lower(left(ls_temp, 1)) = "d" then
			lb_sort_descending = true
		else
			lb_sort_descending = false
		end if
		// The caption should use the original attributes and re-interpret any embedded tokens.  This is to make sure
		// that any attachment tokens get resolved correctly now that we have an attachment context
		ls_caption = f_attribute_find_attribute(pstr_command.original_attributes, "caption")
		lb_carriage_return = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "carriage_return"))
		
		if len(ls_property) > 0 then
			lstr_property_value = f_get_patient_property(last_context.cpr_id, pstr_assessment.problem_id, "Assessment", ls_property, report_attributes)
			li_sts = add_property_attachment(lstr_property_value, &
											ll_width, &
											ll_height, &
											ls_placement, &
											lb_text_flow_around, &
											ll_xpos, &
											ll_ypos, &
											ls_caption, &
											lb_carriage_return, &
											ll_menu_id)
		else
			li_sts = display_attachment(pstr_command.context_object, &
											pstr_assessment.problem_id, &
											ls_progress_type, &
											ls_progress_key, &
											ll_width, &
											ll_height, &
											ls_placement, &
											lb_text_flow_around, &
											ll_xpos, &
											ll_ypos, &
											lb_page_break, &
											ls_which, &
											lb_sort_descending, &
											ls_caption, &
											lb_carriage_return, &
											ll_menu_id)
			if li_sts <= 0 then return li_sts
		end if
	CASE "begin date"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "date_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then
			ls_text = string(date(pstr_assessment.begin_date))
		else
			ls_text = string(date(pstr_assessment.begin_date), ls_argument)
		end if
	CASE "begin date time"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "date_time_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then 
			ls_text = string(pstr_assessment.begin_date)
		else
			ls_text = string(pstr_assessment.begin_date, ls_argument)
		end if
	CASE "begin time"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "time_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then 
			ls_text = string(time(pstr_assessment.begin_date))
		else
			ls_text = string(time(pstr_assessment.begin_date), ls_argument)
		end if
	CASE "compare"
		ls_left_side = f_attribute_find_attribute(pstr_command.attributes, "left_side")
		ls_right_side = f_attribute_find_attribute(pstr_command.attributes, "right_side")
		ls_right_side_2 = f_attribute_find_attribute(pstr_command.attributes, "right_side_2")
		ls_operator = f_attribute_find_attribute(pstr_command.attributes, "operator")
		if isnull(ls_operator) then ls_operator = "="

		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_true_phrase = f_attribute_find_attribute(pstr_command.attributes, "display_text")

		if f_string_compare_2(ls_left_side, ls_right_side, ls_right_side_2, ls_operator) then
			if not isnull(ll_display_script_id) then
				display_script(ll_display_script_id, last_encounter, last_assessment, last_treatment)
			end if
			if len(ls_true_phrase) > 0 then
				ls_text = ls_true_phrase
			end if
		end if
	CASE "description"
		lb_flag = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "full_flag"))
		if lb_flag then
			ls_text = f_assessment_description(pstr_assessment)
		else
			ls_text = pstr_assessment.assessment
		end if
	CASE "diagnosed by"
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		lb_use_supervisor = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "supervisor"))
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
		
		// Use the treatment workplan owner by default
		ls_user_id = pstr_assessment.diagnosed_by
		if lb_use_supervisor then
			// If we want the supervisor then see if the user has a supervisor
			ls_supervisor_user_id = user_list.supervisor_user_id(ls_user_id)
			if not isnull(ls_supervisor_user_id) then ls_user_id = ls_supervisor_user_id
		end if
		
		li_sts = display_user_property(ls_user_id, ls_property, ll_width, ll_height)
	CASE "document"
		li_sts = display_document(pstr_command, pstr_assessment.problem_id)
		if li_sts <= 0 then return li_sts
	CASE "end date"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "date_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then 
			ls_text = string(date(pstr_assessment.end_date))
		else
			ls_text = string(date(pstr_assessment.end_date), ls_argument)
		end if
	CASE "end date time"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "date_time_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then
			ls_text = string(pstr_assessment.end_date)
		else
			ls_text = string(pstr_assessment.end_date, ls_argument)
		end if
	CASE "end time"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "time_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then 
			ls_text = string(time(pstr_assessment.end_date))
		else
			ls_text = string(time(pstr_assessment.end_date), ls_argument)
		end if
	CASE "execute script"
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		display_script(ll_display_script_id, last_encounter, last_assessment, last_treatment)
	CASE "icon"
	CASE "if"
		ls_condition = f_attribute_find_attribute(pstr_command.attributes, "condition")
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ls_true_phrase = f_attribute_find_attribute(pstr_command.attributes, "true_phrase")
		ls_false_phrase = f_attribute_find_attribute(pstr_command.attributes, "false_phrase")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ll_else_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "else_display_script_id"))
		
		if len(ls_condition) > 0 then
			lb_condition = current_patient.assessments.if_condition(pstr_assessment.problem_id, ls_condition)
		else
			lb_condition = true
		end if
		
		if len(ls_query) > 0 then
			ls_query = f_string_substitute(ls_query, "%cpr_id%", current_patient.cpr_id)
			ls_query = f_string_substitute(ls_query, "%encounter_id%", string(last_encounter.encounter_id))
			ls_query = f_string_substitute(ls_query, "%problem_id%", string(pstr_assessment.problem_id))
			ls_query = f_string_substitute(ls_query, "%treatment_id%", string(last_treatment.treatment_id))
			lb_condition2 = if_query(ls_query)
		else
			lb_condition2 = true
		end if
		
		if lb_condition and lb_condition2 then
			add_text(ls_true_phrase)
			display_script(ll_display_script_id, last_encounter, pstr_assessment, last_treatment)
		else
			add_text(ls_false_phrase)
			display_script(ll_else_display_script_id, last_encounter, pstr_assessment, last_treatment)
		end if
	CASE "messages"
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")

		li_sts = display_messages(current_patient.cpr_id, "Assessment", pstr_assessment.problem_id)

		if li_sts <= 0 then
			if ls_empty_phrase <> "" then
				ls_text = ls_empty_phrase
			else
				return 0
			end if
		end if
	CASE "observations"
		ls_result_type = f_attribute_find_attribute(pstr_command.attributes, "result_type")
		if isnull(ls_result_type) then ls_result_type = "PERFORM"
		ls_abnormal_flag = f_attribute_find_attribute(pstr_command.attributes, "abnormal_flag")
		if isnull(ls_abnormal_flag) then ls_abnormal_flag = "N"
		ls_observation_id = f_attribute_find_attribute(pstr_command.attributes, "observation_id")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		ls_format = f_attribute_find_attribute(pstr_command.attributes, "format")
		ls_prefix = f_attribute_find_attribute(pstr_command.attributes, "prefix")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "attached_observations_only")
		if isnull(ls_temp) or f_string_to_boolean(ls_temp) then
			ls_attached_observations_only = "Y"
		else
			ls_attached_observations_only = "N"
		end if
		
		if isnull(ls_format) then ls_format = "Roots"
		
		luo_results = CREATE u_ds_observation_results
		
		if lower(ls_format) = "dates" then
			luo_results.set_dataobject("dw_sp_obstree_assessment_dates")
			ll_count = luo_results.retrieve(current_patient.cpr_id, ls_observation_id, pstr_assessment.problem_id, ls_attached_observations_only)
		else
			luo_results.set_dataobject("dw_sp_obstree_assessment")
			ll_count = luo_results.retrieve(current_patient.cpr_id, ls_observation_id, pstr_assessment.problem_id, ls_attached_observations_only)
		end if
		
		if ll_count > 0 then
			CHOOSE CASE lower(ls_format)
				CASE "roots"
					luo_results.display_roots(ls_result_type, ls_abnormal_flag, this)
				CASE "dates"
					luo_results.display_grid_date(ls_result_type, ls_abnormal_flag, lstr_table_attributes, this)
				CASE "list"
					luo_results.display_list(ls_result_type, ls_abnormal_flag, ls_prefix, this)
			END CHOOSE
		end if
		
		DESTROY luo_results
		
		if f_char_position_compare(charposition(), lstr_startpos) = 0 then
			add_text(ls_empty_phrase)
			return 0
		end if
		
		return 1
	CASE "progress"
		lb_current_only = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "current_only"))
		ls_progress_display_style = f_attribute_find_attribute(pstr_command.attributes, "progress_display_style")
		ls_progress_type = f_attribute_find_attribute(pstr_command.attributes, "progress_type")
		ls_progress_key = f_attribute_find_attribute(pstr_command.attributes, "progress_key")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))

		li_sts = display_progress(pstr_command.context_object, &
											pstr_assessment.problem_id, &
											ls_progress_type, &
											ls_progress_key, &
											ls_progress_display_style, &
											lb_current_only, &
											ll_display_script_id)
		return li_sts
	CASE "progress property"
		ls_progress_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		ls_progress_type = f_attribute_find_attribute(pstr_command.attributes, "progress_type")
		ls_progress_key = f_attribute_find_attribute(pstr_command.attributes, "progress_key")
		ls_user_property = f_attribute_find_attribute(pstr_command.attributes, "user_property")
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))

		ls_temp = get_last_progress_property(pstr_command.context_object, &
														pstr_assessment.problem_id, &
														ls_progress_type, &
														ls_progress_key, &
														ls_progress_property)

		if lower(ls_progress_property) = "user_id" or lower(ls_progress_property) = "created_by" then
			if isnull(ls_user_property) then
				ls_user_property = "user_full_name"
			end if
			li_sts = display_user_property(ls_temp, ls_user_property, ll_width, ll_height)
		else
			ls_text = ls_temp
		end if
	CASE "property"
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "include_formatting")
		if isnull(ls_temp) then
			lb_include_formatting = true
		else
			lb_include_formatting = f_string_to_boolean(ls_temp)
		end if
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		lstr_property_value = f_get_property("Assessment", ls_property, pstr_assessment.problem_id, report_attributes)
		li_sts = add_property(lstr_property_value, lb_include_formatting, ll_menu_id, "assessment", pstr_assessment.problem_id)
		return li_sts
	CASE "query"
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		lb_show_headings = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_headings"))
		lb_show_lines = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_lines"))
		
		// Substitute tokens in the query
		lstr_attributes = report_attributes
		f_attribute_add_attribute(lstr_attributes, "cpr_id", current_patient.cpr_id)
		f_attribute_add_attribute(lstr_attributes, "problem_id", string(pstr_assessment.problem_id))
		ls_query = f_string_substitute_attributes(ls_query, lstr_attributes)
		
		if not isnull(ls_header_phrase) then
			add_text(ls_header_phrase)
			add_cr()
		end if
		
		if isnull(ls_query) or trim(ls_query) = "" then
			log.log(this, "u_rich_text_edit.display_script_command_assessment:0384", "No Query", 3)
			li_sts = 0
		else
			li_sts = display_sql_query(ls_query, lb_show_headings, lb_show_lines)
			if li_sts < 0 then
				ls_temp = "Error processing query.  "
				ls_temp += "display_script_id=" + string(pstr_command.display_script_id)
				ls_temp += ", display_command_id=" + string(pstr_command.display_command_id)
				ls_temp += ", query=" + ls_query
				log.log(this, "u_rich_text_edit.display_script_command_assessment:0393", ls_temp, 4)
				add_text("<Query Error>")
			end if
		end if
		
		if li_sts = 0 then
			add_text(ls_empty_phrase)
		elseif li_sts > 0 then
			if not isnull(ls_footer_phrase) then
				add_cr()
				add_text(ls_footer_phrase)
			end if
		end if

		if f_char_position_compare(charposition(), lstr_startpos) = 0 then
			return 0
		end if
		return 1
	CASE "treatments"
		lb_current_only = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "current_only"))
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		ls_treatment_type = f_attribute_find_attribute(pstr_command.attributes, "treatment_type")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_sort_column = f_attribute_find_attribute(pstr_command.attributes, "sort_column")
		ls_sort_direction = f_attribute_find_attribute(pstr_command.attributes, "sort_direction")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "attached_treatments_only")
		if isnull(ls_temp) or f_string_to_boolean(ls_temp) then
			lb_attached_treatments_only = True
		else
			lb_attached_treatments_only = False
		end if
		
		if not isnull(ls_header_phrase) then
			add_text(ls_header_phrase)
			add_cr()
		end if

		lstr_curpos = charposition()
		
		// If the assessment was rediagnosed in this encounter then don't show any treatments
		if pstr_assessment.close_encounter_id = last_encounter.encounter_id &
			and lower(pstr_assessment.assessment_status) = "rediagnosed" then
		else
			display_assessment_treatments(pstr_assessment, ls_treatment_type, lb_current_only, ll_display_script_id, ls_sort_column, ls_sort_direction, lb_attached_treatments_only)
		end if
		
		// If we didn't add any treatments then remove the header
		if f_char_position_compare(charposition(), lstr_curpos) = 0 then
			delete_from_position(lstr_startpos)
			add_text(ls_empty_phrase)
		elseif not isnull(ls_footer_phrase) then
			if linelength() > 0 then add_cr()
			add_text(ls_footer_phrase)
		end if

		if f_char_position_compare(charposition(), lstr_startpos) = 0 then return 0
		return 1
END CHOOSE

if len(ls_text) > 0 then
	if ll_menu_id > 0 then
		// Prepare the field data string
		lstr_service.service = "Menu"
		f_attribute_add_attribute(lstr_service.attributes, "menu_id", string(ll_menu_id))

		if last_encounter.encounter_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "encounter_id", string(last_encounter.encounter_id))
		end if

		if pstr_assessment.problem_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "problem_id", string(pstr_assessment.problem_id))
		end if

		if last_treatment.treatment_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(last_treatment.treatment_id))
		end if

		ls_fielddata = f_service_to_field_data(lstr_service)
		add_field( ls_text, ls_fielddata, false)
	else
		add_text(ls_text)
	end if
end if

if f_char_position_compare(charposition(), lstr_startpos) = 0 then return 0
return 1


end function

public function long display_script_command_encounter (str_c_display_script_command pstr_command, str_encounter_description pstr_encounter);string ls_operator
string ls_observation_id
string ls_text
string ls_formatted_flag
string ls_assessment_type
string ls_treatment_type
string ls_observation_type
long ll_display_script_id
string ls_empty_phrase
string ls_owner_flag
integer i
integer li_sts
str_observation_comment lstr_comment
string ls_supervisor_user_id
boolean lb_continuous
long ll_width
long ll_height
string ls_argument
string ls_service
integer li_step_number
long ll_item_number
boolean lb_owner_flag
boolean lb_formatted_flag
string ls_progress_key
long ll_selstart
boolean lb_billed_only
boolean lb_show_previous
boolean lb_show_new
string ls_treatment_status
string ls_progress_display_style
string ls_progress_type
string ls_property
string ls_condition
boolean lb_condition
long ll_else_display_script_id
string ls_temp
string ls_field_name
string ls_result_type
boolean lb_latest_only
string ls_format
string ls_which_services
boolean lb_current_only
boolean lb_include_formatting
str_property_value lstr_property_value
str_grid lstr_grid
string ls_query
u_ds_data luo_data
boolean lb_show_headings
boolean lb_show_lines
str_attributes lstr_attributes
string ls_header_phrase
string ls_footer_phrase
string ls_assessment_status
boolean lb_page_break
boolean lb_use_supervisor
string ls_user_id
boolean pb_show_created_in_plan
boolean lb_since_last_encounter
string ls_which
boolean lb_condition2
string ls_true_phrase
string ls_false_phrase
string ls_sort_column
string ls_sort_direction
string ls_acuteness
string ls_exclude_assessment_type
long ll_menu_id
str_service_info lstr_service
string ls_fielddata
string ls_progress_property
string ls_user_property
string ls_left_side
string ls_right_side
string ls_right_side_2
string ls_temp1
string ls_temp2
long ll_xpos
long ll_ypos
boolean lb_text_flow_around
string ls_placement
boolean lb_sort_descending
string ls_caption
boolean lb_carriage_return
str_charposition lstr_startpos
str_charposition lstr_curpos

setnull(ls_text)

lstr_startpos = charposition()

ll_menu_id = long(f_attribute_find_attribute(pstr_command.attributes, "menu_id"))

CHOOSE CASE lower(pstr_command.display_command)
	CASE "assessments"
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "show_previous")
		if isnull(ls_temp) then
			// show_previous defaults to true
			lb_show_previous = true
		else
			lb_show_previous = f_string_to_boolean(ls_temp)
		end if
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "show_new")
		if isnull(ls_temp) then
			// show_new defaults to true
			lb_show_new = true
		else
			lb_show_new = f_string_to_boolean(ls_temp)
		end if
		
		ls_assessment_status = f_attribute_find_attribute(pstr_command.attributes, "assessment_status")
		lb_billed_only = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "billed_only"))
		ls_assessment_type = f_attribute_find_attribute(pstr_command.attributes, "assessment_type")
		ls_exclude_assessment_type = f_attribute_find_attribute(pstr_command.attributes, "exclude_assessment_type")
		ls_acuteness = f_attribute_find_attribute(pstr_command.attributes, "acuteness")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_sort_column = f_attribute_find_attribute(pstr_command.attributes, "sort_column")
		ls_sort_direction = f_attribute_find_attribute(pstr_command.attributes, "sort_direction")

		li_sts = display_encounter_assessments(pstr_encounter, &
															ls_assessment_type, &
															ls_exclude_assessment_type, &
															ls_acuteness, &
															ll_display_script_id, &
															lb_billed_only, &
															lb_show_previous, &
															lb_show_new, &
															ls_assessment_status, &
															ls_header_phrase, &
															ls_footer_phrase, &
															ls_sort_column, &
															ls_sort_direction)
		if li_sts <= 0 then
			if len(ls_empty_phrase) > 0 then
				add_text(ls_empty_phrase)
				return 1
			else
				return 0
			end if
		end if
	CASE "attachment"
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		ls_progress_type = f_attribute_find_attribute(pstr_command.attributes, "progress_type")
		if isnull(ls_progress_type) then ls_progress_type = "Attachment"
		ls_progress_key = f_attribute_find_attribute(pstr_command.attributes, "progress_key")
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
		ls_placement = f_attribute_find_attribute(pstr_command.attributes, "placement")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "text_flow_around")
		if isnull(ls_temp) then ls_temp = "True"
		lb_text_flow_around = f_string_to_boolean(ls_temp)
		ll_xpos = long(f_attribute_find_attribute(pstr_command.attributes, "xposition"))
		ll_ypos = long(f_attribute_find_attribute(pstr_command.attributes, "yposition"))
		ls_which = f_attribute_find_attribute(pstr_command.attributes, "which_attachment")
		lb_page_break = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "page_break"))
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "sort_direction")
		if isnull(ls_temp) then 
			lb_sort_descending = false
		elseif lower(left(ls_temp, 1)) = "d" then
			lb_sort_descending = true
		else
			lb_sort_descending = false
		end if
		// The caption should use the original attributes and re-interpret any embedded tokens.  This is to make sure
		// that any attachment tokens get resolved correctly now that we have an attachment context
		ls_caption = f_attribute_find_attribute(pstr_command.original_attributes, "caption")
		lb_carriage_return = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "carriage_return"))
		
		if len(ls_property) > 0 then
			lstr_property_value = f_get_patient_property(last_context.cpr_id, pstr_encounter.encounter_id, "Encounter", ls_property, report_attributes)
			li_sts = add_property_attachment(lstr_property_value, &
											ll_width, &
											ll_height, &
											ls_placement, &
											lb_text_flow_around, &
											ll_xpos, &
											ll_ypos, &
											ls_caption, &
											lb_carriage_return, &
											ll_menu_id)
		else
			li_sts = display_attachment(pstr_command.context_object, &
											pstr_encounter.encounter_id, &
											ls_progress_type, &
											ls_progress_key, &
											ll_width, &
											ll_height, &
											ls_placement, &
											lb_text_flow_around, &
											ll_xpos, &
											ll_ypos, &
											lb_page_break, &
											ls_which, &
											lb_sort_descending, &
											ls_caption, &
											lb_carriage_return, &
											ll_menu_id)
			if li_sts <= 0 then return li_sts
		end if
	CASE "compare"
		ls_left_side = f_attribute_find_attribute(pstr_command.attributes, "left_side")
		ls_right_side = f_attribute_find_attribute(pstr_command.attributes, "right_side")
		ls_right_side_2 = f_attribute_find_attribute(pstr_command.attributes, "right_side_2")
		ls_operator = f_attribute_find_attribute(pstr_command.attributes, "operator")
		if isnull(ls_operator) then ls_operator = "="

		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_true_phrase = f_attribute_find_attribute(pstr_command.attributes, "display_text")

		if f_string_compare_2(ls_left_side, ls_right_side, ls_right_side_2, ls_operator) then
			if not isnull(ll_display_script_id) then
				display_script(ll_display_script_id, last_encounter, last_assessment, last_treatment)
			end if
			if len(ls_true_phrase) > 0 then
				ls_text = ls_true_phrase
			end if
		end if
	CASE "description"
		ls_text = pstr_encounter.description
	CASE "discharge date"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "date_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then
			ls_text = string(date(pstr_encounter.discharge_date))
		else
			ls_text = string(date(pstr_encounter.discharge_date), ls_argument)
		end if
	CASE "discharge date time"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "date_time_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then
			ls_text = string(pstr_encounter.discharge_date)
		else
			ls_text = string(pstr_encounter.discharge_date, ls_argument)
		end if
	CASE "discharge time"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "time_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then
			ls_text = string(time(pstr_encounter.discharge_date))
		else
			ls_text = string(time(pstr_encounter.discharge_date), ls_argument)
		end if
	CASE "document"
		li_sts = display_document(pstr_command, pstr_encounter.encounter_id)
		if li_sts <= 0 then return li_sts
	CASE "encounter date"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "date_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then
			ls_text = string(date(pstr_encounter.encounter_date))
		else
			ls_text = string(date(pstr_encounter.encounter_date), ls_argument)
		end if
	CASE "encounter date time"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "date_time_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then
			ls_text = string(pstr_encounter.encounter_date)
		else
			ls_text = string(pstr_encounter.encounter_date, ls_argument)
		end if
	CASE "encounter time"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "time_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then
			ls_text = string(time(pstr_encounter.encounter_date))
		else
			ls_text = string(time(pstr_encounter.encounter_date), ls_argument)
		end if
	CASE "execute script"
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		display_script(ll_display_script_id, last_encounter, last_assessment, last_treatment)
	CASE "if"
		ls_condition = f_attribute_find_attribute(pstr_command.attributes, "condition")
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ls_true_phrase = f_attribute_find_attribute(pstr_command.attributes, "true_phrase")
		ls_false_phrase = f_attribute_find_attribute(pstr_command.attributes, "false_phrase")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ll_else_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "else_display_script_id"))
		
		if len(ls_condition) > 0 then
			lb_condition = current_patient.encounters.if_condition(pstr_encounter.encounter_id, ls_condition)
		else
			lb_condition = true
		end if
		
		if len(ls_query) > 0 then
			ls_query = f_string_substitute(ls_query, "%cpr_id%", current_patient.cpr_id)
			ls_query = f_string_substitute(ls_query, "%encounter_id%", string(pstr_encounter.encounter_id))
			ls_query = f_string_substitute(ls_query, "%problem_id%", string(last_assessment.problem_id))
			ls_query = f_string_substitute(ls_query, "%treatment_id%", string(last_treatment.treatment_id))
			lb_condition2 = if_query(ls_query)
		else
			lb_condition2 = true
		end if
		
		if lb_condition and lb_condition2 then
			add_text(ls_true_phrase)
			display_script(ll_display_script_id, pstr_encounter, last_assessment, last_treatment)
		else
			add_text(ls_false_phrase)
			display_script(ll_else_display_script_id, pstr_encounter, last_assessment, last_treatment)
		end if
	CASE "messages"
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")

		li_sts = display_messages(current_patient.cpr_id, "Encounter", pstr_encounter.encounter_id)

		if li_sts <= 0 then
			if ls_empty_phrase <> "" then
				ls_text = ls_empty_phrase
			else
				return 0
			end if
		end if
	CASE "objects"
		lb_since_last_encounter = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "since_last_encounter"))
		li_sts = display_encounter_objects(lb_since_last_encounter)
	CASE "observation"
		lb_latest_only = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "latest_only"))
		ls_observation_id = f_attribute_find_attribute(pstr_command.attributes, "observation_id")
		ls_result_type = f_attribute_find_attribute(pstr_command.attributes, "result_type")
		if isnull(ls_result_type) then ls_result_type = "PERFORM"
		lb_formatted_flag = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "formatted"))
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		If isnull(ls_observation_id) or trim(ls_observation_id) = "" Then
			li_sts = 0
		Else
			lb_continuous = not lb_formatted_flag
			li_sts = display_encounter_observation(pstr_encounter, ls_observation_id, ls_result_type, lb_continuous, lb_latest_only)
		End If
		if li_sts <= 0 then
			if ls_empty_phrase <> "" then
				ls_text = ls_empty_phrase
			else
				return 0
			end if
		end if
	CASE "observation treatments"
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "show_previous")
		if isnull(ls_temp) then
			// show_previous defaults to true
			lb_show_previous = true
		else
			lb_show_previous = f_string_to_boolean(ls_temp)
		end if
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "show_new")
		if isnull(ls_temp) then
			// show_new defaults to true
			lb_show_new = true
		else
			lb_show_new = f_string_to_boolean(ls_temp)
		end if
		ls_observation_type = f_attribute_find_attribute(pstr_command.attributes, "observation_type")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		lb_owner_flag = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "owner"))
		ls_sort_column = f_attribute_find_attribute(pstr_command.attributes, "sort_column")
		ls_sort_direction = f_attribute_find_attribute(pstr_command.attributes, "sort_direction")
		If lb_owner_flag Then // if treatments by encounter owner
			li_sts = display_encounter_owner_observations(pstr_encounter, &
																		ls_observation_type, &
																		ll_display_script_id, &
																		lb_show_previous, &
																		lb_show_new, &
																		ls_sort_column, &
																		ls_sort_direction)
		Else
			li_sts = display_encounter_observations(pstr_encounter, &
																	ls_observation_type, &
																	ll_display_script_id, &
																	lb_show_previous, &
																	lb_show_new, &
																	ls_sort_column, &
																	ls_sort_direction)
		End If
		if li_sts <= 0 then
			if ls_empty_phrase <> "" then
				ls_text = ls_empty_phrase
			else
				return 0
			end if
		end if
	CASE "owned by"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "supervisor")
		if f_string_to_boolean(ls_argument) then
			if isnull(pstr_encounter.supervising_doctor) then
				ls_supervisor_user_id = user_list.supervisor_user_id(pstr_encounter.attending_doctor)
			else
				ls_supervisor_user_id = pstr_encounter.supervising_doctor
			end if
			if isnull(ls_supervisor_user_id) then
				ls_text = user_list.user_full_name(pstr_encounter.attending_doctor)
			else
				ls_text = user_list.user_full_name(ls_supervisor_user_id)
			end if
		else
			ls_text = user_list.user_full_name(pstr_encounter.attending_doctor)
		end if
	CASE "owned by property"
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		lb_use_supervisor = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "supervisor"))
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
		
		// Use the attending_doctor by default
		ls_user_id = pstr_encounter.attending_doctor
		if lb_use_supervisor then
			// If we want the supervisor then see if the encounter has a specific supervisor
			if isnull(pstr_encounter.supervising_doctor) then
				ls_supervisor_user_id = user_list.supervisor_user_id(pstr_encounter.attending_doctor)
				if not isnull(ls_supervisor_user_id) then ls_user_id = ls_supervisor_user_id
			else
				ls_user_id = pstr_encounter.supervising_doctor
			end if
		end if
		
		li_sts = display_user_property(ls_user_id, ls_property, ll_width, ll_height)
		
	CASE "progress"
		lb_current_only = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "current_only"))
		ls_progress_display_style = f_attribute_find_attribute(pstr_command.attributes, "progress_display_style")
		ls_progress_type = f_attribute_find_attribute(pstr_command.attributes, "progress_type")
		ls_progress_key = f_attribute_find_attribute(pstr_command.attributes, "progress_key")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))

		li_sts = display_progress(pstr_command.context_object, &
											pstr_encounter.encounter_id, &
											ls_progress_type, &
											ls_progress_key, &
											ls_progress_display_style, &
											lb_current_only, &
											ll_display_script_id)
		return li_sts
	CASE "progress property"
		ls_progress_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		ls_progress_type = f_attribute_find_attribute(pstr_command.attributes, "progress_type")
		ls_progress_key = f_attribute_find_attribute(pstr_command.attributes, "progress_key")
		ls_user_property = f_attribute_find_attribute(pstr_command.attributes, "user_property")
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))

		ls_temp = get_last_progress_property(pstr_command.context_object, &
														pstr_encounter.encounter_id, &
														ls_progress_type, &
														ls_progress_key, &
														ls_progress_property)

		if lower(ls_progress_property) = "user_id" or lower(ls_progress_property) = "created_by" then
			li_sts = display_user_property(ls_temp, ls_user_property, ll_width, ll_height)
		else
			ls_text = ls_temp
		end if
	CASE "property"
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "include_formatting")
		if isnull(ls_temp) then
			lb_include_formatting = true
		else
			lb_include_formatting = f_string_to_boolean(ls_temp)
		end if
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		lstr_property_value = f_get_property("Encounter", ls_property, pstr_encounter.encounter_id, report_attributes)
		li_sts = add_property(lstr_property_value, lb_include_formatting, ll_menu_id, "encounter", pstr_encounter.encounter_id)
		return li_sts
	CASE "query"
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		lb_show_headings = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_headings"))
		lb_show_lines = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_lines"))

		// Substitute tokens in the query
		lstr_attributes = report_attributes
		f_attribute_add_attribute(lstr_attributes, "cpr_id", current_patient.cpr_id)
		f_attribute_add_attribute(lstr_attributes, "encounter_id", string(pstr_encounter.encounter_id))
		ls_query = f_string_substitute_attributes(ls_query, lstr_attributes)
		
		if not isnull(ls_header_phrase) then
			add_text(ls_header_phrase)
			add_cr()
		end if
		
		if isnull(ls_query) or trim(ls_query) = "" then
			log.log(this, "u_rich_text_edit.display_script_command_encounter:0482", "No Query", 3)
			li_sts = 0
		else
			li_sts = display_sql_query(ls_query, lb_show_headings, lb_show_lines)
			if li_sts < 0 then
				ls_temp = "Error processing query.  "
				ls_temp += "display_script_id=" + string(pstr_command.display_script_id)
				ls_temp += ", display_command_id=" + string(pstr_command.display_command_id)
				ls_temp += ", query=" + ls_query
				log.log(this, "u_rich_text_edit.display_script_command_encounter:0491", ls_temp, 4)
				add_text("<Query Error>")
			end if
		end if
		
		if li_sts = 0 then
			add_text(ls_empty_phrase)
		elseif li_sts > 0 then
			if not isnull(ls_footer_phrase) then
				add_cr()
				add_text(ls_footer_phrase)
			end if
		end if

		if f_char_position_compare(charposition(), lstr_startpos) = 0 then
			return 0
		end if
		return 1
	CASE "referring provider"
		ls_field_name = f_attribute_find_attribute(pstr_command.attributes, "field_name")
		if isnull(ls_field_name) then ls_field_name = "description"
		ls_text = datalist.consultant_field(pstr_encounter.referring_doctor, ls_field_name)
	CASE "referring provider address"
		ls_text = datalist.consultant_address(pstr_encounter.referring_doctor)
	CASE "referring provider phone"
		ls_text = datalist.consultant_phone(pstr_encounter.referring_doctor)
	CASE "service owned by"
		ls_service = f_attribute_find_attribute(pstr_command.attributes, "service")
		li_step_number = integer(f_attribute_find_attribute(pstr_command.attributes, "step_number"))
		ll_item_number = long(f_attribute_find_attribute(pstr_command.attributes, "item_number"))
		ls_argument = ls_service
		if not isnull(li_step_number) and not isnull(ll_item_number) then
			ls_argument += "," + string(li_step_number) + "," + string(ll_item_number)
		end if
		ls_text = encounter_workplan_item_attribute(pstr_encounter.encounter_id, ls_argument, "owned_by")
	CASE "service performed by"
		ls_service = f_attribute_find_attribute(pstr_command.attributes, "service")
		li_step_number = integer(f_attribute_find_attribute(pstr_command.attributes, "step_number"))
		ll_item_number = long(f_attribute_find_attribute(pstr_command.attributes, "item_number"))
		ls_argument = ls_service
		if not isnull(li_step_number) and not isnull(ll_item_number) then
			ls_argument += "," + string(li_step_number) + "," + string(ll_item_number)
		end if
		ls_text = encounter_workplan_item_attribute(pstr_encounter.encounter_id, ls_argument, "completed_by")
	CASE "service performed when"
		ls_service = f_attribute_find_attribute(pstr_command.attributes, "service")
		li_step_number = integer(f_attribute_find_attribute(pstr_command.attributes, "step_number"))
		ll_item_number = long(f_attribute_find_attribute(pstr_command.attributes, "item_number"))
		ls_argument = ls_service
		if not isnull(li_step_number) and not isnull(ll_item_number) then
			ls_argument += "," + string(li_step_number) + "," + string(ll_item_number)
		end if
		ls_text = encounter_workplan_item_attribute(pstr_encounter.encounter_id, ls_argument, "end_date")
	CASE "service property"
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		ls_service = f_attribute_find_attribute(pstr_command.attributes, "service")
		li_step_number = integer(f_attribute_find_attribute(pstr_command.attributes, "step_number"))
		ll_item_number = long(f_attribute_find_attribute(pstr_command.attributes, "item_number"))
		ls_argument = ls_service
		if not isnull(li_step_number) and not isnull(ll_item_number) then
			ls_argument += "," + string(li_step_number) + "," + string(ll_item_number)
		end if
		ls_text = encounter_workplan_item_attribute(pstr_encounter.encounter_id, ls_argument, ls_property)
	CASE "services"
		ls_service = f_attribute_find_attribute(pstr_command.attributes, "service")
		ls_which_services = f_attribute_find_attribute(pstr_command.attributes, "which_services")
		ls_format = f_attribute_find_attribute(pstr_command.attributes, "format")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		li_sts = display_encounter_services(pstr_encounter, ls_service, ls_which_services, ls_format)

		if li_sts <= 0 then
			if ls_empty_phrase <> "" then
				ls_text = ls_empty_phrase
			else
				return 0
			end if
		end if
	CASE "treatments"
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "show_previous")
		if isnull(ls_temp) then
			// show_previous defaults to true
			lb_show_previous = true
		else
			lb_show_previous = f_string_to_boolean(ls_temp)
		end if
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "show_new")
		if isnull(ls_temp) then
			// show_new defaults to true
			lb_show_new = true
		else
			lb_show_new = f_string_to_boolean(ls_temp)
		end if
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "show_created_in_plan")
		if isnull(ls_temp) then
			// Default is true
			pb_show_created_in_plan = true
		else
			pb_show_created_in_plan = f_string_to_boolean(ls_temp)
		end if
		ls_treatment_status = f_attribute_find_attribute(pstr_command.attributes, "treatment_status")
		ls_treatment_type = f_attribute_find_attribute(pstr_command.attributes, "treatment_type")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		lb_owner_flag = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "owner"))
		ls_sort_column = f_attribute_find_attribute(pstr_command.attributes, "sort_column")
		ls_sort_direction = f_attribute_find_attribute(pstr_command.attributes, "sort_direction")
		
		
		if not isnull(ls_header_phrase) then
			add_text(ls_header_phrase)
			add_cr()
		end if

		lstr_curpos = charposition()
		
		li_sts = display_encounter_treatments(pstr_encounter, ls_treatment_type, ll_display_script_id, ls_treatment_status, lb_owner_flag, lb_show_previous, lb_show_new, pb_show_created_in_plan, ls_sort_column, ls_sort_direction)
		
		// If we didn't add any treatments then remove the header
		if f_char_position_compare(charposition(), lstr_curpos) = 0 then
			delete_from_position(lstr_startpos)
			add_text(ls_empty_phrase)
		elseif not isnull(ls_footer_phrase) then
			if linelength() > 0 then add_cr()
			add_text(ls_footer_phrase)
		end if

		if f_char_position_compare(charposition(), lstr_startpos) = 0 then return 0
		return 1
	CASE "type"
		ls_text = datalist.encounter_type_description(pstr_encounter.encounter_type)
END CHOOSE

if len(ls_text) > 0 then
	if ll_menu_id > 0 then
		// Prepare the field data string
		lstr_service.service = "Menu"
		f_attribute_add_attribute(lstr_service.attributes, "menu_id", string(ll_menu_id))

		if pstr_encounter.encounter_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "encounter_id", string(pstr_encounter.encounter_id))
		end if

		if last_assessment.problem_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "problem_id", string(last_assessment.problem_id))
		end if

		if last_treatment.treatment_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(last_treatment.treatment_id))
		end if

		ls_fielddata = f_service_to_field_data(lstr_service)
		add_field( ls_text, ls_fielddata, false)
	else
		add_text(ls_text)
	end if
end if


if f_char_position_compare(charposition(), lstr_startpos) = 0 then return 0
return 1


end function

public function long display_script_command_patient (str_c_display_script_command pstr_command);string ls_operator
string ls_text
integer li_sts
string ls_male
string ls_female
string ls_encounter_type
string ls_assessment_type
string ls_treatment_type
long ll_display_script_id
string ls_empty_phrase
string ls_which
string ls_argument
string ls_observation_id
string ls_progress_display_style
string ls_progress_type
string ls_progress_key
long ll_object_key
long ll_width
long ll_height
string ls_property
long ll_else_display_script_id
string ls_condition
boolean lb_condition
string ls_result_type
string ls_format
u_ds_observation_results luo_results
long ll_count
string ls_abnormal_flag
integer li_result_sequence
string ls_location
string ls_indirect_flag
str_rtf_table_attributes lstr_table_attributes
string ls_field_name
boolean lb_current_only
boolean lb_include_formatting
str_property_value lstr_property_value
string ls_temp
string ls_prefix
boolean lb_amount_only
boolean lb_display_unit
str_grid lstr_grid
string ls_query
u_ds_data luo_data
boolean lb_show_headings
boolean lb_show_lines
str_attributes lstr_attributes
string ls_header_phrase
string ls_footer_phrase
boolean lb_page_break
long ll_null
datetime ldt_begin_date
datetime ldt_end_date
boolean lb_include_race
long ll_age_amount
string ls_age_unit
string ls_separator
string ls_case
string ls_old
string ls_race
string ls_person
string ls_folder
string ls_attachment_type
string ls_attachment_tag
string ls_extension
boolean lb_condition2
string ls_true_phrase
string ls_false_phrase
boolean lb_display_result
boolean lb_display_location
string ls_sort_column
string ls_sort_direction
string ls_acuteness
string ls_exclude_assessment_type
boolean lb_use_colors
long ll_menu_id
str_service_info lstr_service
string ls_fielddata
string ls_service
string ls_which_services
boolean lb_show_reason
string ls_progress_property
string ls_user_property
boolean lb_use_supervisor
string ls_user_id
string ls_supervisor_user_id
string ls_left_side
string ls_right_side
string ls_status
string ls_right_side_2
string ls_temp1
string ls_temp2
long ll_xpos
long ll_ypos
boolean lb_text_flow_around
string ls_placement
boolean lb_sort_descending
string ls_caption
boolean lb_carriage_return
string ls_name_format
str_charposition lstr_startpos
str_charposition lstr_curpos

str_observation_comment lstr_comment

setnull(ll_null)
setnull(ll_object_key)
setnull(ls_text)
setnull(ls_which)
setnull(ls_treatment_type)
setnull(ll_display_script_id)
setnull(ls_empty_phrase)

lstr_startpos = charposition()

ll_menu_id = long(f_attribute_find_attribute(pstr_command.attributes, "menu_id"))

CHOOSE CASE lower(pstr_command.display_command)
	CASE "age"
		ls_text = f_pretty_age(current_patient.date_of_birth, today())
	CASE "alerts"
		ls_which = f_attribute_find_attribute(pstr_command.attributes, "which_alerts") // Alert, Reminder, All (Default)
		ls_status = f_attribute_find_attribute(pstr_command.attributes, "alert_status") // Open (Default), Closed, All
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		
		li_sts = display_patient_alerts(ls_which, ls_status)
		if li_sts <= 0 then
			ls_text = ls_empty_phrase
		end if
	CASE "assessments"
		ls_which = f_attribute_find_attribute(pstr_command.attributes, "assessment_status")
		ls_assessment_type = f_attribute_find_attribute(pstr_command.attributes, "assessment_type")
		ls_exclude_assessment_type = f_attribute_find_attribute(pstr_command.attributes, "exclude_assessment_type")
		ls_acuteness = f_attribute_find_attribute(pstr_command.attributes, "acuteness")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		ls_sort_column = f_attribute_find_attribute(pstr_command.attributes, "sort_column")
		ls_sort_direction = f_attribute_find_attribute(pstr_command.attributes, "sort_direction")

		li_sts = display_patient_assessments(ls_assessment_type, &
														ls_exclude_assessment_type, &
														ls_acuteness, &
														ll_display_script_id, &
														ls_which, &
														ls_header_phrase, &
														ls_footer_phrase, &
														ls_sort_column, &
														ls_sort_direction)
		if li_sts <= 0 and ls_empty_phrase <> "" then ls_text = ls_empty_phrase
	CASE "attachment"
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		ls_progress_type = f_attribute_find_attribute(pstr_command.attributes, "progress_type")
		ls_progress_key = f_attribute_find_attribute(pstr_command.attributes, "progress_key")
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
		ls_placement = f_attribute_find_attribute(pstr_command.attributes, "placement")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "text_flow_around")
		if isnull(ls_temp) then ls_temp = "True"
		lb_text_flow_around = f_string_to_boolean(ls_temp)
		ll_xpos = long(f_attribute_find_attribute(pstr_command.attributes, "xposition"))
		ll_ypos = long(f_attribute_find_attribute(pstr_command.attributes, "yposition"))
		ls_which = f_attribute_find_attribute(pstr_command.attributes, "which_attachment")
		lb_page_break = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "page_break"))
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "sort_direction")
		if isnull(ls_temp) then 
			lb_sort_descending = false
		elseif lower(left(ls_temp, 1)) = "d" then
			lb_sort_descending = true
		else
			lb_sort_descending = false
		end if
		// The caption should use the original attributes and re-interpret any embedded tokens.  This is to make sure
		// that any attachment tokens get resolved correctly now that we have an attachment context
		ls_caption = f_attribute_find_attribute(pstr_command.original_attributes, "caption")
		lb_carriage_return = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "carriage_return"))

		if len(ls_property) > 0 then
			lstr_property_value = f_get_patient_property(last_context.cpr_id, ll_null, "Patient", ls_property, report_attributes)
			li_sts = add_property_attachment(lstr_property_value, &
											ll_width, &
											ll_height, &
											ls_placement, &
											lb_text_flow_around, &
											ll_xpos, &
											ll_ypos, &
											ls_caption, &
											lb_carriage_return, &
											ll_menu_id)
		else
			li_sts = display_attachment(pstr_command.context_object, &
											ll_null, &
											ls_progress_type, &
											ls_progress_key, &
											ll_width, &
											ll_height, &
											ls_placement, &
											lb_text_flow_around, &
											ll_xpos, &
											ll_ypos, &
											lb_page_break, &
											ls_which, &
											lb_sort_descending, &
											ls_caption, &
											lb_carriage_return, &
											ll_menu_id)
			if li_sts <= 0 then return li_sts
		end if
	CASE "billing id"
		ls_text = current_patient.billing_id
	CASE "compare"
		ls_left_side = f_attribute_find_attribute(pstr_command.attributes, "left_side")
		ls_right_side = f_attribute_find_attribute(pstr_command.attributes, "right_side")
		ls_right_side_2 = f_attribute_find_attribute(pstr_command.attributes, "right_side_2")
		ls_operator = f_attribute_find_attribute(pstr_command.attributes, "operator")
		if isnull(ls_operator) then ls_operator = "="

		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_true_phrase = f_attribute_find_attribute(pstr_command.attributes, "display_text")

		if f_string_compare_2(ls_left_side, ls_right_side, ls_right_side_2, ls_operator) then
			if not isnull(ll_display_script_id) then
				display_script(ll_display_script_id, last_encounter, last_assessment, last_treatment)
			end if
			if len(ls_true_phrase) > 0 then
				ls_text = ls_true_phrase
			end if
		end if
	CASE "date of birth"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "date_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then
			ls_text = string(date(current_patient.date_of_birth))
		else
			ls_text = string(date(current_patient.date_of_birth), ls_argument)
		end if
	CASE "description"
		if isnull(current_patient.date_of_birth) then return 0
		
		lb_include_race = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "include_race"))
		ls_male = f_attribute_find_attribute(pstr_command.attributes, "male")
		ls_female = f_attribute_find_attribute(pstr_command.attributes, "female")
		ls_separator = f_attribute_find_attribute(pstr_command.attributes, "separator")
		ls_case = f_attribute_find_attribute(pstr_command.attributes, "description_case")
		
		if isnull(ls_separator) then ls_separator = " "
		if isnull(ls_male) or trim(ls_male) = "" then ls_male = "male"
		if isnull(ls_female) or trim(ls_female) = "" then ls_female = "female"
		if isnull(ls_case) then ls_case = "lower"
		
		ls_old = "old"
		ls_person = "person"
		
		ls_race = current_patient.race
		
		f_pretty_age_unit(current_patient.date_of_birth, today(), ll_age_amount, ls_age_unit)

		if ll_age_amount = 8 or ll_age_amount = 11 or ll_age_amount = 18 or (ll_age_amount >= 80 and ll_age_amount < 90) then
			ls_text = "an"
		else
			ls_text = "a"
		end if
		
		// Now set the case
		CHOOSE CASE lower(ls_case)
			CASE "upper"
				ls_text = upper(ls_text)
				ls_age_unit = upper(ls_age_unit)
				ls_old = upper(ls_old)
				ls_race = upper(ls_race)
				ls_male = upper(ls_male)
				ls_female = upper(ls_female)
				ls_person = upper(ls_person)
			CASE "wordcap"
				ls_text = wordcap(ls_text)
				ls_age_unit = wordcap(ls_age_unit)
				ls_old = wordcap(ls_old)
				ls_race = wordcap(ls_race)
				ls_male = wordcap(ls_male)
				ls_female = wordcap(ls_female)
				ls_person = wordcap(ls_person)
			CASE ELSE
				ls_text = lower(ls_text)
				ls_age_unit = lower(ls_age_unit)
				ls_old = lower(ls_old)
				ls_race = lower(ls_race)
				ls_male = lower(ls_male)
				ls_female = lower(ls_female)
				ls_person = lower(ls_person)
		END CHOOSE

		ls_text += " " + string(ll_age_amount) + ls_separator + ls_age_unit + ls_separator + ls_old
		
		if lb_include_race and not isnull(ls_race) then
			ls_text += " " + ls_race
		end if
		
		if lower(current_patient.sex) = 'm' then
			ls_text += " " + ls_male
		elseif lower(current_patient.sex) = 'f' then
			ls_text += " " + ls_female
		else
			ls_text = " " + ls_person
		end if
		
		
	CASE "document"
		li_sts = display_document(pstr_command, ll_null)
		if li_sts <= 0 then return li_sts
	CASE "encounters"
		ls_indirect_flag = f_attribute_find_attribute(pstr_command.attributes, "indirect_flag")
		ls_encounter_type = f_attribute_find_attribute(pstr_command.attributes, "encounter_type")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		ls_sort_column = f_attribute_find_attribute(pstr_command.attributes, "sort_column")
		ls_sort_direction = f_attribute_find_attribute(pstr_command.attributes, "sort_direction")
		li_sts = display_patient_encounters(ls_encounter_type, ll_display_script_id, ls_sort_column, ls_sort_direction)
		if li_sts <= 0 and ls_empty_phrase <> "" then ls_text = ls_empty_phrase
	CASE "execute script"
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		display_script(ll_display_script_id, last_encounter, last_assessment, last_treatment)
	CASE "first name"
		ls_text = current_patient.first_name
	CASE "full name"
		ls_text = current_patient.name("Full")
	CASE "health maintenance"
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		ls_format = f_attribute_find_attribute(pstr_command.attributes, "body_format")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "use_colors")
		if isnull(ls_temp) then ls_temp = "True"
		lb_use_colors = f_string_to_boolean(ls_temp)
		li_sts = display_patient_health_maintenance(ls_header_phrase, ls_footer_phrase, ls_empty_phrase, ls_format, lb_use_colors)
	CASE "if"
		ls_condition = f_attribute_find_attribute(pstr_command.attributes, "condition")
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ls_true_phrase = f_attribute_find_attribute(pstr_command.attributes, "true_phrase")
		ls_false_phrase = f_attribute_find_attribute(pstr_command.attributes, "false_phrase")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ll_else_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "else_display_script_id"))
		
		if len(ls_condition) > 0 then
			lb_condition = current_patient.if_condition(ls_condition)
		else
			lb_condition = true
		end if
		
		if len(ls_query) > 0 then
			ls_query = f_string_substitute(ls_query, "%cpr_id%", current_patient.cpr_id)
			ls_query = f_string_substitute(ls_query, "%encounter_id%", string(last_encounter.encounter_id))
			ls_query = f_string_substitute(ls_query, "%problem_id%", string(last_assessment.problem_id))
			ls_query = f_string_substitute(ls_query, "%treatment_id%", string(last_treatment.treatment_id))
			lb_condition2 = if_query(ls_query)
		else
			lb_condition2 = true
		end if
		
		if lb_condition and lb_condition2 then
			add_text(ls_true_phrase)
			display_script(ll_display_script_id, last_encounter, last_assessment, last_treatment)
		else
			add_text(ls_false_phrase)
			display_script(ll_else_display_script_id, last_encounter, last_assessment, last_treatment)
		end if
	CASE "immunizations"
		lb_show_reason = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_reason"))
		display_immunization_status(ll_null, lb_show_reason)
	CASE "last name"
		ls_text = current_patient.last_name
	CASE "list name"
		ls_text = current_patient.name("List")
	CASE "messages"
		ls_service = "MESSAGE"
		ls_which_services = "all"
		ls_format = "message"
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		li_sts = display_patient_services(ls_service, ls_which_services, ls_format)

		if li_sts <= 0 then
			if ls_empty_phrase <> "" then
				ls_text = ls_empty_phrase
			else
				return 0
			end if
		end if
	CASE "middle initial"
		ls_text = upper(left(current_patient.middle_name, 1))
	CASE "middle name"
		ls_text = current_patient.middle_name
	CASE "name"
		ls_name_format = f_attribute_find_attribute(pstr_command.attributes, "name_format")
		ls_text = current_patient.name(ls_name_format)
	CASE "observations"
		ls_result_type = f_attribute_find_attribute(pstr_command.attributes, "result_type")
		if isnull(ls_result_type) then ls_result_type = "PERFORM"
		ls_abnormal_flag = f_attribute_find_attribute(pstr_command.attributes, "abnormal_flag")
		if isnull(ls_abnormal_flag) then ls_abnormal_flag = "N"
		ls_observation_id = f_attribute_find_attribute(pstr_command.attributes, "observation_id")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		ls_format = f_attribute_find_attribute(pstr_command.attributes, "format")
		ls_prefix = f_attribute_find_attribute(pstr_command.attributes, "prefix")
		
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "begin_date")
		ldt_begin_date = f_string_to_datetime(ls_temp)
		
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "end_date")
		ldt_end_date = f_string_to_datetime(ls_temp)

		if isnull(ls_format) then ls_format = "Roots"
		
		luo_results = CREATE u_ds_observation_results
		
		if lower(ls_format) = "dates" then
			luo_results.set_dataobject("dw_sp_obstree_patient_dates")
			ll_count = luo_results.retrieve(current_patient.cpr_id, ls_observation_id, ldt_begin_date, ldt_end_date)
		else
			luo_results.set_dataobject("dw_sp_obstree_patient")
			ll_count = luo_results.retrieve(current_patient.cpr_id, ls_observation_id, ldt_begin_date, ldt_end_date)
		end if
		
		if ll_count > 0 then
			CHOOSE CASE lower(ls_format)
				CASE "roots"
					luo_results.display_roots(ls_result_type, ls_abnormal_flag, this)
				CASE "dates"
					luo_results.display_grid_date(ls_result_type, ls_abnormal_flag, lstr_table_attributes, this)
				CASE "list"
					luo_results.display_list(ls_result_type, ls_abnormal_flag, ls_prefix, this)
			END CHOOSE
		end if
		
		DESTROY luo_results
		
		if f_char_position_compare(charposition(), lstr_startpos) = 0 then
			add_text(ls_empty_phrase)
			return 0
		end if
		
		return 1
	CASE "phone number"
		ls_text = current_patient.phone_number
	CASE "primary provider"
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		if isnull(ls_property) then ls_property = "user_full_name"
		lb_use_supervisor = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "supervisor"))
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
		
		// Use the treatment workplan owner by default
		ls_user_id = current_patient.primary_provider_id
		if lb_use_supervisor then
			// If we want the supervisor then see if the user has a supervisor
			ls_supervisor_user_id = user_list.supervisor_user_id(ls_user_id)
			if not isnull(ls_supervisor_user_id) then ls_user_id = ls_supervisor_user_id
		end if
		
		li_sts = display_user_property(ls_user_id, ls_property, ll_width, ll_height)
		
	CASE "progress"
		lb_current_only = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "current_only"))
		ls_progress_display_style = f_attribute_find_attribute(pstr_command.attributes, "progress_display_style")
		ls_progress_type = f_attribute_find_attribute(pstr_command.attributes, "progress_type")
		ls_progress_key = f_attribute_find_attribute(pstr_command.attributes, "progress_key")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))

		li_sts = display_progress(pstr_command.context_object, &
											ll_object_key, &
											ls_progress_type, &
											ls_progress_key, &
											ls_progress_display_style, &
											lb_current_only, &
											ll_display_script_id)
		return li_sts
	CASE "progress property"
		ls_progress_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		ls_progress_type = f_attribute_find_attribute(pstr_command.attributes, "progress_type")
		ls_progress_key = f_attribute_find_attribute(pstr_command.attributes, "progress_key")
		ls_user_property = f_attribute_find_attribute(pstr_command.attributes, "user_property")
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))

		ls_temp = get_last_progress_property(pstr_command.context_object, &
														ll_null, &
														ls_progress_type, &
														ls_progress_key, &
														ls_progress_property)

		if lower(ls_progress_property) = "user_id" or lower(ls_progress_property) = "created_by" then
			li_sts = display_user_property(ls_temp, ls_user_property, ll_width, ll_height)
		else
			ls_text = ls_temp
		end if
	CASE "property"
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "include_formatting")
		if isnull(ls_temp) then
			lb_include_formatting = true
		else
			lb_include_formatting = f_string_to_boolean(ls_temp)
		end if
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		lstr_property_value = f_get_property("Patient", ls_property, ll_null, report_attributes)
		li_sts = add_property(lstr_property_value, lb_include_formatting, ll_menu_id, "Patient", ll_null)
		return li_sts
	CASE "query"
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		lb_show_headings = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_headings"))
		lb_show_lines = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_lines"))
		
		// Substitute tokens in the query
		lstr_attributes = report_attributes
		f_attribute_add_attribute(lstr_attributes, "cpr_id", current_patient.cpr_id)
		ls_query = f_string_substitute_attributes(ls_query, lstr_attributes)
		
		if not isnull(ls_header_phrase) then
			add_text(ls_header_phrase)
			add_cr()
		end if
		
		if isnull(ls_query) or trim(ls_query) = "" then
			log.log(this, "u_rich_text_edit.display_script_command_patient:0523", "No Query", 3)
			li_sts = 0
		else
			li_sts = display_sql_query(ls_query, lb_show_headings, lb_show_lines)
			if li_sts < 0 then
				ls_temp = "Error processing query.  "
				ls_temp += "display_script_id=" + string(pstr_command.display_script_id)
				ls_temp += ", display_command_id=" + string(pstr_command.display_command_id)
				ls_temp += ", query=" + ls_query
				log.log(this, "u_rich_text_edit.display_script_command_patient:0532", ls_temp, 4)
				add_text("<Query Error>")
			end if
		end if
		
		if li_sts = 0 then
			add_text(ls_empty_phrase)
		elseif li_sts > 0 then
			if not isnull(ls_footer_phrase) then
				add_cr()
				add_text(ls_footer_phrase)
			end if
		end if

		if f_char_position_compare(charposition(), lstr_startpos) = 0 then
			return 0
		end if
		return 1
	CASE "race"
		ls_text = current_patient.race
	CASE "referring provider"
		ls_field_name = f_attribute_find_attribute(pstr_command.attributes, "field_name")
		if isnull(ls_field_name) then ls_field_name = "description"
		ls_text = datalist.consultant_field(current_patient.referring_provider_id, ls_field_name)
	CASE "referring provider address"
		ls_text = datalist.consultant_address(current_patient.referring_provider_id)
	CASE "referring provider phone"
		ls_text = datalist.consultant_phone(current_patient.referring_provider_id)
	CASE "result"
		ls_result_type = f_attribute_find_attribute(pstr_command.attributes, "result_type")
		if isnull(ls_result_type) then ls_result_type = "PERFORM"
		ls_abnormal_flag = f_attribute_find_attribute(pstr_command.attributes, "abnormal_flag")
		if isnull(ls_abnormal_flag) then ls_abnormal_flag = "N"
		ls_observation_id = f_attribute_find_attribute(pstr_command.attributes, "observation_id")
		li_result_sequence = integer(f_attribute_find_attribute(pstr_command.attributes, "result_sequence"))
		ls_location = f_attribute_find_attribute(pstr_command.attributes, "location")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")

		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "display_result")
		if isnull(ls_temp) then
			// check the "amount_only" attribute for backward compatibility
			lb_display_result = not f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "amount_only"))
		else
			lb_display_result = f_string_to_boolean(ls_temp)
		end if
		
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "display_location")
		if isnull(ls_temp) then
			lb_display_location = true
		else
			lb_display_location = f_string_to_boolean(ls_temp)
		end if
		
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "display_unit")
		if isnull(ls_temp) then
			lb_display_unit = true
		else
			lb_display_unit = f_string_to_boolean(ls_temp)
		end if
		
		luo_results = CREATE u_ds_observation_results
		
		luo_results.set_dataobject("dw_sp_obstree_patient")
		ll_count = luo_results.retrieve(current_patient.cpr_id, ls_observation_id)

		luo_results.display_observation_result(ls_observation_id, ls_result_type, ls_abnormal_flag, ls_location, li_result_sequence, lb_display_result, lb_display_location, lb_display_unit, this)
		
		DESTROY luo_results
		
		if f_char_position_compare(charposition(), lstr_startpos) = 0 then
			add_text(ls_empty_phrase)
			return 0
		end if
		
		return 1
	CASE "services"
		ls_service = f_attribute_find_attribute(pstr_command.attributes, "service")
		ls_which_services = f_attribute_find_attribute(pstr_command.attributes, "which_services")
		ls_format = f_attribute_find_attribute(pstr_command.attributes, "format")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		li_sts = display_patient_services(ls_service, ls_which_services, ls_format)

		if li_sts <= 0 then
			if ls_empty_phrase <> "" then
				ls_text = ls_empty_phrase
			else
				return 0
			end if
		end if
	CASE "sex"
		ls_male = f_attribute_find_attribute(pstr_command.attributes, "male")
		ls_female = f_attribute_find_attribute(pstr_command.attributes, "female")
		if isnull(ls_male) or trim(ls_male) = "" then ls_male = "Male"
		if isnull(ls_female) or trim(ls_female) = "" then ls_female = "Female"
		if lower(current_patient.sex) = 'm' then
			ls_text = ls_male
		elseif lower(current_patient.sex) = 'f' then
			ls_text = ls_female
		else
			ls_text = upper(current_patient.sex)
		end if
	CASE "ssn"
		ls_text = current_patient.ssn
	CASE "treatments"
		ls_which = f_attribute_find_attribute(pstr_command.attributes, "treatment_status")
		ls_treatment_type = f_attribute_find_attribute(pstr_command.attributes, "treatment_type")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		ls_sort_column = f_attribute_find_attribute(pstr_command.attributes, "sort_column")
		ls_sort_direction = f_attribute_find_attribute(pstr_command.attributes, "sort_direction")
		
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "begin_date")
		ldt_begin_date = f_string_to_datetime(ls_temp)

		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "end_date")
		ldt_end_date = f_string_to_datetime(ls_temp)

		li_sts = display_patient_treatments(ls_treatment_type, ll_display_script_id, ls_which, ldt_begin_date, ldt_end_date, ls_header_phrase, ls_footer_phrase, ls_sort_column, ls_sort_direction)
		if li_sts <= 0 and ls_empty_phrase <> "" then ls_text = ls_empty_phrase
END CHOOSE

if len(ls_text) > 0 then
	if ll_menu_id > 0 then
		// Prepare the field data string
		lstr_service.service = "Menu"
		f_attribute_add_attribute(lstr_service.attributes, "menu_id", string(ll_menu_id))

		if last_encounter.encounter_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "encounter_id", string(last_encounter.encounter_id))
		end if

		if last_assessment.problem_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "problem_id", string(last_assessment.problem_id))
		end if

		if last_treatment.treatment_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(last_treatment.treatment_id))
		end if

		ls_fielddata = f_service_to_field_data(lstr_service)
		add_field( ls_text, ls_fielddata, false)
	else
		add_text(ls_text)
	end if
end if


if f_char_position_compare(charposition(), lstr_startpos) = 0 then return 0
return 1


end function

public function long display_script_command_treatment (str_c_display_script_command pstr_command, str_treatment_description pstr_treatment);string ls_operator
string ls_abnormal_flag
string ls_comment_display_style
string ls_progress_display_style
string ls_text
string ls_temp
string ls_temp1
string ls_temp2
string ls_temp3
string ls_find
integer li_count
integer i
integer li_sts
str_drug_definition lstr_drug
str_observation_comment lstr_comment
string ls_mode
string ls_observation_id
string ls_observation_tag
string ls_argument
string ls_service
integer li_step_number
long ll_item_number
boolean lb_flag
string ls_comment_title
string ls_root_observation_id
string ls_exclude_observation_tag
string ls_progress_type
string ls_progress_key
long ll_width
long ll_height
string ls_property
string ls_condition
long ll_display_script_id
boolean lb_condition
long ll_else_display_script_id
string ls_result_type
string ls_format
u_ds_observation_results luo_results
long ll_count
string ls_empty_phrase
integer li_result_sequence
string ls_location
string ls_consultant_id
string ls_field_name
string ls_root_observation_tag
string ls_child_observation_id
string ls_child_observation_tag
boolean lb_current_only
string ls_null
boolean lb_include_formatting
str_property_value lstr_property_value
string ls_which_services
string ls_workplan_type
long ll_patient_workplan_id
string ls_prefix
boolean lb_amount_only
boolean lb_display_unit
str_grid lstr_grid
string ls_query
u_ds_data luo_data
boolean lb_show_headings
boolean lb_show_lines
str_attributes lstr_attributes
string ls_header_phrase
string ls_footer_phrase
boolean lb_page_break
str_encounter_description lstr_encounter
boolean lb_use_supervisor
string ls_user_id
string ls_supervisor_user_id
boolean lb_include_comments
boolean lb_include_attachments
string ls_which
boolean lb_condition2
string ls_true_phrase
string ls_false_phrase
boolean lb_display_result
boolean lb_display_location
string ls_treatment_type
string ls_sort_column
string ls_sort_direction
boolean lb_show_common_name
boolean lb_show_package
boolean lb_show_dosing
boolean lb_show_admin
boolean lb_show_dispense
boolean lb_show_refills
boolean lb_latest_root_only
long ll_menu_id
str_service_info lstr_service
string ls_fielddata
string ls_drug
string ls_abnormal_font_settings
str_font_settings lstr_abnormal_font_settings
str_font_settings lstr_comment_font_settings
string ls_which_user
string ls_progress_property
string ls_user_property
string ls_left_side
string ls_right_side
string ls_right_side_2
long ll_xpos
long ll_ypos
boolean lb_text_flow_around
string ls_placement
long ll_problem_id[]
long ll_problem_id_count
str_assessment_description lstr_assessment_description
string ls_comment_font_settings
boolean lb_sort_descending
string ls_caption
boolean lb_carriage_return
boolean lb_formatted_numbers
boolean lb_show_actor_full
boolean lb_include_deleted
str_charposition lstr_startpos
str_charposition lstr_curpos

str_rtf_table_attributes lstr_table_attributes

setnull(ls_null)
setnull(ls_text)

lstr_startpos = charposition()

ll_menu_id = long(f_attribute_find_attribute(pstr_command.attributes, "menu_id"))

CHOOSE CASE lower(pstr_command.display_command)
	CASE "assessment"
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))

		ll_problem_id_count = current_patient.treatments.get_treatment_assessments(pstr_treatment.treatment_id, ll_problem_id)
		if ll_problem_id_count > 0 then
			li_sts = current_patient.assessments.assessment(lstr_assessment_description, ll_problem_id[1])
			if li_sts > 0 then
				if isnull(ll_display_script_id) then
					ls_text = lstr_assessment_description.assessment
				else
					display_assessment(lstr_assessment_description, ll_display_script_id)
				end if
			end if
		end if
		
	CASE "assessments"
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))

		ll_problem_id_count = current_patient.treatments.get_treatment_assessments(pstr_treatment.treatment_id, ll_problem_id)
		for i = 1 to ll_problem_id_count
			li_sts = current_patient.assessments.assessment(lstr_assessment_description, ll_problem_id[i])
			if li_sts > 0 then
				if isnull(ll_display_script_id) then
					if len(ls_text) > 0 then
						ls_text += "~r~n"
					else
						ls_text = ""
					end if
					ls_text += lstr_assessment_description.assessment
				else
					display_assessment(lstr_assessment_description, ll_display_script_id)
				end if
			end if
		next		
	CASE "attachment"
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		ls_progress_type = f_attribute_find_attribute(pstr_command.attributes, "progress_type")
		ls_progress_key = f_attribute_find_attribute(pstr_command.attributes, "progress_key")
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
		ls_placement = f_attribute_find_attribute(pstr_command.attributes, "placement")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "text_flow_around")
		if isnull(ls_temp) then ls_temp = "True"
		lb_text_flow_around = f_string_to_boolean(ls_temp)
		ll_xpos = long(f_attribute_find_attribute(pstr_command.attributes, "xposition"))
		ll_ypos = long(f_attribute_find_attribute(pstr_command.attributes, "yposition"))
		ls_which = f_attribute_find_attribute(pstr_command.attributes, "which_attachment")
		lb_page_break = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "page_break"))
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "sort_direction")
		if isnull(ls_temp) then 
			lb_sort_descending = false
		elseif lower(left(ls_temp, 1)) = "d" then
			lb_sort_descending = true
		else
			lb_sort_descending = false
		end if
		// The caption should use the original attributes and re-interpret any embedded tokens.  This is to make sure
		// that any attachment tokens get resolved correctly now that we have an attachment context
		ls_caption = f_attribute_find_attribute(pstr_command.original_attributes, "caption")
		lb_carriage_return = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "carriage_return"))
		
		if len(ls_property) > 0 then
			lstr_property_value = f_get_patient_property(last_context.cpr_id, pstr_treatment.treatment_id, "Treatment", ls_property, report_attributes)
			li_sts = add_property_attachment(lstr_property_value, &
											ll_width, &
											ll_height, &
											ls_placement, &
											lb_text_flow_around, &
											ll_xpos, &
											ll_ypos, &
											ls_caption, &
											lb_carriage_return, &
											ll_menu_id)
		else
			li_sts = display_attachment(pstr_command.context_object, &
												pstr_treatment.treatment_id, &
												ls_progress_type, &
												ls_progress_key, &
												ll_width, &
												ll_height, &
												ls_placement, &
												lb_text_flow_around, &
												ll_xpos, &
												ll_ypos, &
												lb_page_break, &
												ls_which, &
												lb_sort_descending, &
												ls_caption, &
												lb_carriage_return, &
												ll_menu_id)
			if li_sts <= 0 then return li_sts
		end if
	CASE "audit results"
		
		luo_results = CREATE u_ds_observation_results
		
		luo_results.set_dataobject("dw_sp_obstree_treatment_audit")
		ll_count = luo_results.retrieve(current_patient.cpr_id, &
													pstr_treatment.treatment_id)
		
		luo_results.display_audit(this)
		
		DESTROY luo_results
		
		if f_char_position_compare(charposition(), lstr_startpos) = 0 then
			add_text("No Results")
			return 0
		end if
		
		return 1
	CASE "begin date"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "date_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then
			ls_text = string(date(pstr_treatment.begin_date))
		else
			ls_text = string(date(pstr_treatment.begin_date), ls_argument)
		end if
	CASE "begin date time"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "date_time_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then 
			ls_text = string(pstr_treatment.begin_date)
		else
			ls_text = string(pstr_treatment.begin_date, ls_argument)
		end if
	CASE "begin time"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "time_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then 
			ls_text = string(time(pstr_treatment.begin_date))
		else
			ls_text = string(time(pstr_treatment.begin_date), ls_argument)
		end if
	CASE "child treatments"
		ls_treatment_type = f_attribute_find_attribute(pstr_command.attributes, "treatment_type")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		ls_sort_column = f_attribute_find_attribute(pstr_command.attributes, "sort_column")
		ls_sort_direction = f_attribute_find_attribute(pstr_command.attributes, "sort_direction")
		lb_include_deleted = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "include_deleted"))
		
		if not isnull(ls_header_phrase) then
			add_text(ls_header_phrase)
			add_cr()
		end if

		lstr_curpos = charposition()
		
		display_treatment_treatments(pstr_treatment, ls_treatment_type, ll_display_script_id, ls_sort_column, ls_sort_direction, lb_include_deleted)
		
		// If we didn't add any treatments then remove the header
		if f_char_position_compare(charposition(), lstr_curpos) = 0 then
			delete_from_position(lstr_startpos)
			add_text(ls_empty_phrase)
		elseif not isnull(ls_footer_phrase) then
			if linelength() > 0 then add_cr()
			add_text(ls_footer_phrase)
		end if

		if f_char_position_compare(charposition(), lstr_startpos) = 0 then return 0
		return 1
		
	CASE "comments"
		ls_comment_display_style = f_attribute_find_attribute(pstr_command.attributes, "comment_display_style")
		ls_observation_id = f_attribute_find_attribute(pstr_command.attributes, "observation_id")
		ls_observation_tag = f_attribute_find_attribute(pstr_command.attributes, "observation_tag")
		ls_comment_title = f_attribute_find_attribute(pstr_command.attributes, "comment_title")
		
		CHOOSE CASE lower(ls_comment_display_style)
			CASE "no title"
				if not isnull(ls_observation_id) then
					li_sts = current_patient.treatments.get_comment(pstr_treatment.treatment_id, ls_observation_id, ls_comment_title, lstr_comment)
				elseif not isnull(ls_observation_tag) then
					li_sts = current_patient.treatments.get_tagged_comment(pstr_treatment.treatment_id, ls_observation_tag, ls_comment_title, lstr_comment)
				else
					li_sts = current_patient.treatments.get_comment(pstr_treatment.treatment_id, pstr_treatment.observation_id, ls_comment_title, lstr_comment)
				end if
				
				if li_sts > 0 then
					ls_text = lstr_comment.comment
				end if
			CASE ELSE
				if not isnull(ls_observation_id) then
					li_sts = current_patient.treatments.get_comment(pstr_treatment.treatment_id, ls_observation_id, ls_comment_title, lstr_comment)
				elseif not isnull(ls_observation_tag) then
					li_sts = current_patient.treatments.get_tagged_comment(pstr_treatment.treatment_id, ls_observation_tag, ls_comment_title, lstr_comment)
				else
					li_sts = current_patient.treatments.get_comment(pstr_treatment.treatment_id, pstr_treatment.observation_id, ls_comment_title, lstr_comment)
				end if
				
				if li_sts > 0 then
					if isnull(lstr_comment.comment_title) then
						ls_text = ""
					else
						ls_text = lstr_comment.comment_title + "~t"
					end if
					ls_text += lstr_comment.comment
				end if
		END CHOOSE
	CASE "compare"
		ls_left_side = f_attribute_find_attribute(pstr_command.attributes, "left_side")
		ls_right_side = f_attribute_find_attribute(pstr_command.attributes, "right_side")
		ls_right_side_2 = f_attribute_find_attribute(pstr_command.attributes, "right_side_2")
		ls_operator = f_attribute_find_attribute(pstr_command.attributes, "operator")
		if isnull(ls_operator) then ls_operator = "="

		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ls_true_phrase = f_attribute_find_attribute(pstr_command.attributes, "display_text")

		if f_string_compare_2(ls_left_side, ls_right_side, ls_right_side_2, ls_operator) then
			if not isnull(ll_display_script_id) then
				display_script(ll_display_script_id, last_encounter, last_assessment, last_treatment)
			end if
			if len(ls_true_phrase) > 0 then
				ls_text = ls_true_phrase
			end if
		end if
	CASE "consultant"
		ls_consultant_id = current_patient.treatments.get_property_value( pstr_treatment.treatment_id, "consultant_id")
		ls_field_name = f_attribute_find_attribute(pstr_command.attributes, "field_name")
		if isnull(ls_field_name) then ls_field_name = "description"
		ls_text = datalist.consultant_field(ls_consultant_id, ls_field_name)
	CASE "description"
		lb_flag = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "full_flag"))
		if lb_flag then
			ls_text = f_treatment_full_description(pstr_treatment, last_encounter)
		else
			ls_text = pstr_treatment.treatment_description
		end if
	CASE "document"
		li_sts = display_document(pstr_command, pstr_treatment.treatment_id)
		if li_sts <= 0 then return li_sts
	CASE "drug"
		// Default the show_common_name attribute to "True"
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "show_common_name")
		if isnull(ls_temp) then ls_temp = "True"
		lb_show_common_name = f_string_to_boolean(ls_temp)
		
		lb_show_package = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_package"))
		lb_show_dosing = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_dosing"))
		lb_show_admin = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_admin"))
		lb_show_dispense = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_dispense"))
		lb_show_refills = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_refills"))

		if lb_show_common_name then
			ls_temp = drugdb.treatment_drug_description(pstr_treatment)
			if len(ls_temp) > 0 then
				ls_drug += ls_temp
			end if
		end if
		
		if lb_show_package then
			ls_temp = drugdb.package_description(pstr_treatment.package_id)
			if len(ls_temp) > 0 then
				if len(ls_drug) > 0 then ls_drug += ", "
				ls_drug += ls_temp
			end if
		end if
		
		if lb_show_dosing then
			ls_temp = drugdb.treatment_dosing_description(pstr_treatment)
			if len(ls_temp) > 0 then
				if len(ls_drug) > 0 then ls_drug += " "
				ls_drug += ls_temp
			end if
		end if
		
		if lb_show_admin then
			ls_temp = drugdb.treatment_admin_description(pstr_treatment)
			if len(ls_temp) > 0 then
				if len(ls_drug) > 0 then ls_drug += " "
				ls_drug += ls_temp
			end if
		end if
		
		if lb_show_dispense then
			ls_temp = drugdb.treatment_dispense_description(pstr_treatment)
			if len(ls_temp) > 0 then
				if len(ls_drug) > 0 then ls_drug += " "
				ls_drug += ls_temp
			end if
		end if
		
		if lb_show_refills then
			ls_temp = drugdb.treatment_refill_description(pstr_treatment)
			if len(ls_temp) > 0 then
				if len(ls_drug) > 0 then ls_drug += " "
				ls_drug += ls_temp
			end if
		end if
		
		if len(ls_drug) > 0 then ls_text = ls_drug
		
	CASE "end date"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "date_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then 
			ls_text = string(date(pstr_treatment.end_date))
		else
			ls_text = string(date(pstr_treatment.end_date), ls_argument)
		end if
	CASE "end datetime"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "date_time_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then
			ls_text = string(pstr_treatment.end_date)
		else
			ls_text = string(pstr_treatment.end_date, ls_argument)
		end if
	CASE "end time"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "time_format")
		if isnull(ls_argument) or trim(ls_argument) = "" then 
			ls_text = string(time(pstr_treatment.end_date))
		else
			ls_text = string(time(pstr_treatment.end_date), ls_argument)
		end if
	CASE "execute script"
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		display_script(ll_display_script_id, last_encounter, last_assessment, last_treatment)
	CASE "followup items"
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		display_treatment_followup_items(pstr_treatment.treatment_id, ls_empty_phrase)
	CASE "if"
		ls_condition = f_attribute_find_attribute(pstr_command.attributes, "condition")
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ls_true_phrase = f_attribute_find_attribute(pstr_command.attributes, "true_phrase")
		ls_false_phrase = f_attribute_find_attribute(pstr_command.attributes, "false_phrase")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		ll_else_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "else_display_script_id"))
		
		if len(ls_condition) > 0 then
			lb_condition = current_patient.treatments.if_condition(pstr_treatment.treatment_id, ls_condition)
		else
			lb_condition = true
		end if
		
		if len(ls_query) > 0 then
			ls_query = f_string_substitute(ls_query, "%cpr_id%", current_patient.cpr_id)
			ls_query = f_string_substitute(ls_query, "%encounter_id%", string(last_encounter.encounter_id))
			ls_query = f_string_substitute(ls_query, "%problem_id%", string(last_assessment.problem_id))
			ls_query = f_string_substitute(ls_query, "%treatment_id%", string(pstr_treatment.treatment_id))
			lb_condition2 = if_query(ls_query)
		else
			lb_condition2 = true
		end if
		
		if lb_condition and lb_condition2 then
			add_text(ls_true_phrase)
			display_script(ll_display_script_id, last_encounter, last_assessment, pstr_treatment)
		else
			add_text(ls_false_phrase)
			display_script(ll_else_display_script_id, last_encounter, last_assessment, pstr_treatment)
		end if
	CASE "messages"
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")

		li_sts = display_messages(current_patient.cpr_id, "Treatment", pstr_treatment.treatment_id)

		if li_sts <= 0 then
			if ls_empty_phrase <> "" then
				ls_text = ls_empty_phrase
			else
				return 0
			end if
		end if
	CASE "open encounter"
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))
		li_sts = current_patient.encounters.encounter(lstr_encounter, pstr_treatment.open_encounter_id)
		if li_sts > 0 then
			display_script(ll_display_script_id, lstr_encounter, last_assessment, pstr_treatment)
		else
			return 0
		end if
	CASE "ordered by"
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		if isnull(ls_property) then ls_property = "user_full_name"
		lb_use_supervisor = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "supervisor"))
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
		
		// Use the treatment workplan owner by default
		ls_user_id = pstr_treatment.ordered_by
		if lb_use_supervisor then
			// If we want the supervisor then see if the user has a supervisor
			ls_supervisor_user_id = user_list.supervisor_user_id(ls_user_id)
			if not isnull(ls_supervisor_user_id) then ls_user_id = ls_supervisor_user_id
		end if
		
		li_sts = display_user_property(ls_user_id, ls_property, ll_width, ll_height)
		
	CASE "owned by"
		ls_user_id = treatment_workplan_attribute(pstr_treatment.treatment_id, "owned_by")
		ls_text = user_list.user_full_name(ls_user_id)
	CASE "owned by property"
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		if isnull(ls_property) then ls_property = "user_full_name"
		lb_use_supervisor = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "supervisor"))
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
		
		// Use the treatment workplan owner by default
		ls_user_id = treatment_workplan_attribute(pstr_treatment.treatment_id, "owned_by")
		if lb_use_supervisor then
			// If we want the supervisor then see if the user has a supervisor
			ls_supervisor_user_id = user_list.supervisor_user_id(ls_user_id)
			if not isnull(ls_supervisor_user_id) then ls_user_id = ls_supervisor_user_id
		end if
		
		li_sts = display_user_property(ls_user_id, ls_property, ll_width, ll_height)
		
	CASE "progress"
		lb_current_only = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "current_only"))
		ls_progress_display_style = f_attribute_find_attribute(pstr_command.attributes, "progress_display_style")
		ls_progress_type = f_attribute_find_attribute(pstr_command.attributes, "progress_type")
		ls_progress_key = f_attribute_find_attribute(pstr_command.attributes, "progress_key")
		ls_which = f_attribute_find_attribute(pstr_command.attributes, "which_attachment")
		ll_display_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "display_script_id"))

		li_sts = display_progress(pstr_command.context_object, &
											pstr_treatment.treatment_id, &
											ls_progress_type, &
											ls_progress_key, &
											ls_progress_display_style, &
											lb_current_only, &
											ll_display_script_id)
		return li_sts
	CASE "progress property"
		/////////////////////////////////////////////////
		// Check state of current_progress
		// If it's consistent with this context then use it instead of going to the database
		/////////////////////////////////////////////////
		ls_progress_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		ls_progress_type = f_attribute_find_attribute(pstr_command.attributes, "progress_type")
		ls_progress_key = f_attribute_find_attribute(pstr_command.attributes, "progress_key")
		ls_user_property = f_attribute_find_attribute(pstr_command.attributes, "user_property")
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))

		ls_temp = get_last_progress_property(pstr_command.context_object, &
														pstr_treatment.treatment_id, &
														ls_progress_type, &
														ls_progress_key, &
														ls_progress_property)

		if lower(ls_progress_property) = "user_id" or lower(ls_progress_property) = "created_by" then
			li_sts = display_user_property(ls_temp, ls_user_property, ll_width, ll_height)
		else
			ls_text = ls_temp
		end if
	CASE "property"
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "include_formatting")
		if isnull(ls_temp) then
			lb_include_formatting = true
		else
			lb_include_formatting = f_string_to_boolean(ls_temp)
		end if
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		lstr_property_value = f_get_patient_property(last_context.cpr_id, pstr_treatment.treatment_id, "Treatment", ls_property, report_attributes)
		li_sts = add_property(lstr_property_value, lb_include_formatting, ll_menu_id, "Treatment", pstr_treatment.treatment_id)
		return li_sts
	CASE "query"
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ls_header_phrase = f_attribute_find_attribute(pstr_command.attributes, "header_phrase")
		ls_footer_phrase = f_attribute_find_attribute(pstr_command.attributes, "footer_phrase")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		lb_show_headings = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_headings"))
		lb_show_lines = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_lines"))

		// Substitute tokens in the query
		lstr_attributes = report_attributes
		f_attribute_add_attribute(lstr_attributes, "cpr_id", current_patient.cpr_id)
		f_attribute_add_attribute(lstr_attributes, "treatment_id", string(pstr_treatment.treatment_id))
		ls_query = f_string_substitute_attributes(ls_query, lstr_attributes)
		
		if not isnull(ls_header_phrase) then
			add_text(ls_header_phrase)
			add_cr()
		end if
		
		if isnull(ls_query) or trim(ls_query) = "" then
			log.log(this, "u_rich_text_edit.display_script_command_treatment:0607", "No Query", 3)
			li_sts = 0
		else
			li_sts = display_sql_query(ls_query, lb_show_headings, lb_show_lines)
			if li_sts < 0 then
				ls_temp = "Error processing query.  "
				ls_temp += "display_script_id=" + string(pstr_command.display_script_id)
				ls_temp += ", display_command_id=" + string(pstr_command.display_command_id)
				ls_temp += ", query=" + ls_query
				log.log(this, "u_rich_text_edit.display_script_command_treatment:0616", ls_temp, 4)
				add_text("<Query Error>")
			end if
		end if
		
		if li_sts = 0 then
			add_text(ls_empty_phrase)
		elseif li_sts > 0 then
			if not isnull(ls_footer_phrase) then
				add_cr()
				add_text(ls_footer_phrase)
			end if
		end if

		if f_char_position_compare(charposition(), lstr_startpos) = 0 then
			return 0
		end if
		return 1
	CASE "reviewed by"
		lb_current_only = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "current_only"))
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		setnull(ll_display_script_id)
		
		li_sts = display_progress(pstr_command.context_object, &
											pstr_treatment.treatment_id, &
											"Reviewed", &
											ls_null, &
											"Reviewed By", &
											lb_current_only, &
											ll_display_script_id)
		if li_sts = 0 then
			add_text(ls_empty_phrase)
		end if
		return li_sts
	CASE "result"
		ls_result_type = f_attribute_find_attribute(pstr_command.attributes, "result_type")
		if isnull(ls_result_type) then ls_result_type = "PERFORM"
		ls_abnormal_flag = f_attribute_find_attribute(pstr_command.attributes, "abnormal_flag")
		if isnull(ls_abnormal_flag) then ls_abnormal_flag = "N"
		ls_observation_id = f_attribute_find_attribute(pstr_command.attributes, "observation_id")
		li_result_sequence = integer(f_attribute_find_attribute(pstr_command.attributes, "result_sequence"))
		ls_location = f_attribute_find_attribute(pstr_command.attributes, "location")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "display_result")
		if isnull(ls_temp) then
			// check the "amount_only" attribute for backward compatibility
			lb_display_result = not f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "amount_only"))
		else
			lb_display_result = f_string_to_boolean(ls_temp)
		end if
		
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "display_location")
		if isnull(ls_temp) then
			lb_display_location = true
		else
			lb_display_location = f_string_to_boolean(ls_temp)
		end if
		
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "display_unit")
		if isnull(ls_temp) then
			lb_display_unit = true
		else
			lb_display_unit = f_string_to_boolean(ls_temp)
		end if
		
		luo_results = CREATE u_ds_observation_results
		
		// If we have a child observation_id and not a root, then assume the treatment root
		if not isnull(ls_child_observation_id) and isnull(ls_root_observation_id) then
			ls_root_observation_id = pstr_treatment.observation_id
		end if
		
		luo_results.set_dataobject("dw_sp_obstree_treatment")
		ll_count = luo_results.retrieve(current_patient.cpr_id, &
													pstr_treatment.treatment_id)
		
		luo_results.display_observation_result(ls_observation_id, ls_result_type, ls_abnormal_flag, ls_location, li_result_sequence, lb_display_result, lb_display_location, lb_display_unit, this)
		
		DESTROY luo_results
		
		if f_char_position_compare(charposition(), lstr_startpos) = 0 then
			add_text(ls_empty_phrase)
			return 0
		end if
		
		return 1
	CASE "results"
		ls_result_type = f_attribute_find_attribute(pstr_command.attributes, "result_type")
		if isnull(ls_result_type) then ls_result_type = "PERFORM"
		ls_abnormal_flag = f_attribute_find_attribute(pstr_command.attributes, "abnormal_flag")
		if isnull(ls_abnormal_flag) then ls_abnormal_flag = "N"
		ls_root_observation_id = f_attribute_find_attribute(pstr_command.attributes, "root_observation_id")
		ls_root_observation_tag = f_attribute_find_attribute(pstr_command.attributes, "root_observation_tag")
		ls_child_observation_id = f_attribute_find_attribute(pstr_command.attributes, "child_observation_id")
		ls_child_observation_tag = f_attribute_find_attribute(pstr_command.attributes, "child_observation_tag")
		ls_exclude_observation_tag = f_attribute_find_attribute(pstr_command.attributes, "exclude_observation_tag")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		ls_abnormal_font_settings = f_attribute_find_attribute(pstr_command.attributes, "abnormal_font_settings")
		if isnull(ls_abnormal_font_settings) then ls_abnormal_font_settings = "bold"
		ls_format = f_attribute_find_attribute(pstr_command.attributes, "format")
		if isnull(ls_format) then ls_format = "Roots"
		ls_prefix = f_attribute_find_attribute(pstr_command.attributes, "prefix")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "include_comments")
		if isnull(ls_temp) then
			lb_include_comments = true
		else
			lb_include_comments = f_string_to_boolean(ls_temp)
		end if
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "include_attachments")
		if isnull(ls_temp) then
			lb_include_attachments = true
		else
			lb_include_attachments = f_string_to_boolean(ls_temp)
		end if
		ls_comment_font_settings = f_attribute_find_attribute(pstr_command.attributes, "comment_font_settings")
		if isnull(ls_comment_font_settings) then
			ls_comment_font_settings = "fn=courier new"
		end if
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "formatted_numbers")  // 
		if isnull(ls_temp) then
			lb_formatted_numbers = true
		else
			lb_formatted_numbers = f_string_to_boolean(ls_temp)
		end if
		lb_show_actor_full = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "show_actor_full"))
		
		lb_latest_root_only = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "latest_root_only"))
		
		luo_results = CREATE u_ds_observation_results
		
		// If we have a child observation_id and not a root, then assume the treatment root
		if not isnull(ls_child_observation_id) and isnull(ls_root_observation_id) then
			ls_root_observation_id = pstr_treatment.observation_id
		end if
		
		luo_results.formatted_numbers = lb_formatted_numbers
		
		luo_results.set_dataobject("dw_sp_obstree_treatment_all")
		ll_count = luo_results.retrieve(current_patient.cpr_id, &
													pstr_treatment.treatment_id, &
													ls_root_observation_id, &
													ls_root_observation_tag, &
													ls_child_observation_id, &
													ls_child_observation_tag, &
													ls_exclude_observation_tag)
		
		if ll_count > 0 then
			CHOOSE CASE lower(ls_format)
				CASE "roots"
					luo_results.display_roots(ls_result_type, ls_abnormal_flag, lb_include_comments, lb_include_attachments, this)
				CASE "grid"
					luo_results.display_grid_stage(ls_result_type, ls_abnormal_flag, lstr_table_attributes, this)
				CASE "lab"
					lstr_abnormal_font_settings = f_interpret_font_settings(ls_abnormal_font_settings)
					lstr_comment_font_settings = f_interpret_font_settings(ls_comment_font_settings)
					luo_results.display_grid_lab(ls_result_type, ls_abnormal_flag, lstr_abnormal_font_settings, lstr_comment_font_settings, lstr_table_attributes, this, lb_show_actor_full, lb_latest_root_only)
				CASE "list"
					luo_results.display_list(ls_result_type, ls_abnormal_flag, ls_prefix, this)
			END CHOOSE
		end if
		
		DESTROY luo_results
		
		if f_char_position_compare(charposition(), lstr_startpos) = 0 then
			add_text(ls_empty_phrase)
			return 0
		end if
		
		return 1
	CASE "service owned by"
		ls_service = f_attribute_find_attribute(pstr_command.attributes, "service")
		li_step_number = integer(f_attribute_find_attribute(pstr_command.attributes, "step_number"))
		ll_item_number = long(f_attribute_find_attribute(pstr_command.attributes, "item_number"))
		ls_argument = ls_service
		if not isnull(li_step_number) and not isnull(ll_item_number) then
			ls_argument += "," + string(li_step_number) + "," + string(ll_item_number)
		end if
		ls_text = treatment_workplan_item_attribute(pstr_treatment.treatment_id, ls_argument, "owned_by")
	CASE "service performed by"
		ls_service = f_attribute_find_attribute(pstr_command.attributes, "service")
		li_step_number = integer(f_attribute_find_attribute(pstr_command.attributes, "step_number"))
		ll_item_number = long(f_attribute_find_attribute(pstr_command.attributes, "item_number"))
		ls_argument = ls_service
		if not isnull(li_step_number) and not isnull(ll_item_number) then
			ls_argument += "," + string(li_step_number) + "," + string(ll_item_number)
		end if
		ls_text = treatment_workplan_item_attribute(pstr_treatment.treatment_id, ls_argument, "completed_by")
	CASE "service performed when"
		ls_service = f_attribute_find_attribute(pstr_command.attributes, "service")
		li_step_number = integer(f_attribute_find_attribute(pstr_command.attributes, "step_number"))
		ll_item_number = long(f_attribute_find_attribute(pstr_command.attributes, "item_number"))
		ls_argument = ls_service
		if not isnull(li_step_number) and not isnull(ll_item_number) then
			ls_argument += "," + string(li_step_number) + "," + string(ll_item_number)
		end if
		ls_text = treatment_workplan_item_attribute(pstr_treatment.treatment_id, ls_argument, "end_date")
	CASE "service property"
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
		ls_service = f_attribute_find_attribute(pstr_command.attributes, "service")
		li_step_number = integer(f_attribute_find_attribute(pstr_command.attributes, "step_number"))
		ll_item_number = long(f_attribute_find_attribute(pstr_command.attributes, "item_number"))
		ls_argument = ls_service
		if not isnull(li_step_number) and not isnull(ll_item_number) then
			ls_argument += "," + string(li_step_number) + "," + string(ll_item_number)
		end if
		ls_text = treatment_workplan_item_attribute(pstr_treatment.treatment_id, ls_argument, ls_property)
	CASE "services"
		ls_service = f_attribute_find_attribute(pstr_command.attributes, "service")
		ls_which_services = f_attribute_find_attribute(pstr_command.attributes, "which_services")
		ls_format = f_attribute_find_attribute(pstr_command.attributes, "format")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")

		li_sts = display_treatment_services(pstr_treatment, ls_service, ls_which_services, ls_format)

		if li_sts <= 0 then
			if ls_empty_phrase <> "" then
				ls_text = ls_empty_phrase
			else
				return 0
			end if
		end if
	CASE "status"
		ls_argument = f_attribute_find_attribute(pstr_command.attributes, "delimiters")
		if not isnull(pstr_treatment.treatment_status) then
			ls_text = wordcap(pstr_treatment.treatment_status)
			if len(ls_argument) >= 2 then
				ls_text = left(ls_argument, 1) + ls_text + mid(ls_argument, 2, 1)
			end if
		end if
	CASE "type"
		ls_text = datalist.treatment_type_description(pstr_treatment.treatment_type)
	CASE "user signature"
		ls_which_user = f_attribute_find_attribute(pstr_command.attributes, "which_user")
		ls_property = f_attribute_find_attribute(pstr_command.attributes, "user_property")
		lb_use_supervisor = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "supervisor"))
		ll_width = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
		ll_height = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
		
		// Use the treatment workplan owner by default
		lstr_property_value = f_get_property("Treatment", ls_which_user, pstr_treatment.treatment_id, report_attributes)
		ls_user_id = lstr_property_value.value
		if isnull(ls_user_id) then return 0
		
		if lb_use_supervisor then
			// If we want the supervisor then see if the user has a supervisor
			ls_supervisor_user_id = user_list.supervisor_user_id(ls_user_id)
			if not isnull(ls_supervisor_user_id) then ls_user_id = ls_supervisor_user_id
		end if
		
		li_sts = display_user_property(ls_user_id, ls_property, ll_width, ll_height)
		
	CASE "workplan"
		ls_workplan_type = f_attribute_find_attribute(pstr_command.attributes, "workplan_type")
		if isnull(ls_workplan_type) then ls_workplan_type = "Treatment"
		ls_format = f_attribute_find_attribute(pstr_command.attributes, "format")
		ls_empty_phrase = f_attribute_find_attribute(pstr_command.attributes, "empty_phrase")
		
		SELECT min(patient_workplan_id)
		INTO :ll_patient_workplan_id
		FROM p_Patient_WP
		WHERE cpr_id = :current_patient.cpr_id
		AND treatment_id = :pstr_treatment.treatment_id
		AND workplan_type = :ls_workplan_type;
		if not tf_check() then return -1
		if ll_patient_workplan_id > 0 then
			li_sts = display_workplan(ll_patient_workplan_id, ls_format)
		else
			li_sts = 0
		end if

		if li_sts <= 0 then
			if ls_empty_phrase <> "" then
				ls_text = ls_empty_phrase
			else
				return 0
			end if
		end if
END CHOOSE

if len(ls_text) > 0 then
	if ll_menu_id > 0 then
		// Prepare the field data string
		lstr_service.service = "Menu"
		f_attribute_add_attribute(lstr_service.attributes, "menu_id", string(ll_menu_id))

		if last_encounter.encounter_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "encounter_id", string(last_encounter.encounter_id))
		end if

		if last_assessment.problem_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "problem_id", string(last_assessment.problem_id))
		end if

		if pstr_treatment.treatment_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(pstr_treatment.treatment_id))
		end if

		ls_fielddata = f_service_to_field_data(lstr_service)
		add_field( ls_text, ls_fielddata, false)
	else
		add_text(ls_text)
	end if
end if


if f_char_position_compare(charposition(), lstr_startpos) = 0 then return 0
return 1


end function

public function string display_script (long pl_display_script_id, str_encounter_description pstr_encounter, str_assessment_description pstr_assessment, str_treatment_description pstr_treatment);long ll_len
string ls_error
integer li_retries
boolean lb_error
throwable lt_myerror
string ls_null
string ls_text

setnull(ls_null)

// This wrapper puts the RTF display script function inside a TRY/CATCH structure
// because of the incidents where the TX Text Control appears to breifly stop working
// at times on a terminal server.  The basic idea is that if the text control is empty,
// then we know the state of the control fairly well and we can return the control
// to that state easily.  This is important because EncounterPRO makes liberal use
// of nested rtf display scripts, and we can't very easily reset the state if the
// control isn't empty when we start a script.  That's OK though, because we think
// that for the most part when the error happens it does so on the very first
// reference to the underlying ActiveX control for a given service.


// First get the length of the text in the control so we know whether or not we can
// auto-retry on error
li_retries = 0
DO
	li_retries += 1
	lb_error = false
	TRY
		ll_len = len(get_text())
	CATCH (throwable lt_error)
		lb_error = true
		ls_error = lt_error.text
		if li_retries >= error_retries_max then
			THROW lt_error
			return ls_null
		end if
	END TRY
LOOP WHILE lb_error and li_retries <= error_retries_max


// Then, attempt to display the script, and trap any error that occurs
li_retries = 0
DO
	li_retries += 1
	lb_error = false
	TRY
		// Clear out the control if we're retrying
		if li_retries > 1 then
			clear_rtf()
		end if
		ls_text = display_script_a( pl_display_script_id, &
											pstr_encounter, &
											pstr_assessment, &
											pstr_treatment, &
											false)
	CATCH (throwable lt_error2)
		lb_error = true
		ls_error = lt_error2.text
		if li_retries >= error_retries_max OR ll_len > 0 then
			THROW lt_error2
			return ls_null
		end if
	END TRY
LOOP WHILE lb_error and li_retries <= error_retries_max and ll_len = 0

return ls_text

end function

public subroutine display_script (long pl_display_script_id);str_encounter_description lstr_encounter
str_assessment_description lstr_assessment
str_treatment_description lstr_treatment
integer li_sts
string ls_temp

// Don't do anything if we don't have a display_script_id
if isnull(pl_display_script_id) then return

// This version will normally be called from a service and the initial settings of
// encounter_id, problem_id, and treatment_id will come from the current_service object

if isnull(current_service) or isnull(current_patient) then
	setnull(lstr_encounter.encounter_id)
	setnull(lstr_assessment.problem_id)
	setnull(lstr_treatment.treatment_id)
else
	li_sts = current_patient.encounters.encounter(lstr_encounter, current_service.encounter_id)
	li_sts = current_patient.assessments.assessment(lstr_assessment, current_service.problem_id)
	li_sts = current_patient.treatments.treatment(lstr_treatment, current_service.treatment_id)
end if

if not nested then
	clear_rtf()
	
	ls_temp = f_attribute_find_attribute(report_attributes, "print_header")
	if isnull(ls_temp) then
		print_header = true
	else
		print_header = f_string_to_boolean(ls_temp)
	end if
	
	ls_temp = f_attribute_find_attribute(report_attributes, "print_footer")
	if isnull(ls_temp) then
		print_footer = true
	else
		print_footer = f_string_to_boolean(ls_temp)
	end if
	
	header_display_script_id = long(f_attribute_find_attribute(report_attributes, "header_display_script_id"))
	footer_display_script_id = long(f_attribute_find_attribute(report_attributes, "footer_display_script_id"))
	
//	ls_temp = f_attribute_find_attribute(report_attributes, "rtf_auto_redraw_off")
//	if isnull(ls_temp) then
//		ls_temp = datalist.get_preference("PREFERENCES", "rtf_auto_redraw_off")
//		if isnull(ls_temp) then
//			ls_temp = "True"
//		end if
//	end if
//	auto_redraw_off = f_string_to_boolean(ls_temp)
	
	ls_temp = f_attribute_find_attribute(report_attributes, "process_header_footer")
	if isnull(ls_temp) then ls_temp = "True"
	process_header_footer = f_string_to_boolean(ls_temp)
end if


display_script(pl_display_script_id, lstr_encounter, lstr_assessment, lstr_treatment)


end subroutine

public subroutine display_treatment (long pl_treatment_id, long pl_display_script_id);str_treatment_description lstr_treatment
str_treatment_description lstr_last_treatment
integer li_sts

// Save treatment context
lstr_last_treatment = last_treatment

li_sts = current_patient.treatments.treatment(lstr_treatment, pl_treatment_id)
if li_sts <= 0 then
	log_error("Error getting treatment data")
	return
end if

if isnull(pl_display_script_id) then
	pl_display_script_id = datalist.get_display_script_id("Treatment", lstr_treatment.treatment_type)
end if

setredraw(false)
display_script(pl_display_script_id, last_encounter, last_assessment, lstr_treatment)
setredraw(true)

// Restore treatment context
if lstr_last_treatment.treatment_id > 0 then
	last_treatment = lstr_last_treatment
end if


end subroutine

public subroutine display_encounter (long pl_encounter_id, long pl_display_script_id);str_encounter_description lstr_encounter
str_encounter_description lstr_last_encounter
integer li_sts

// Save encounter context
lstr_last_encounter = last_encounter

li_sts = current_patient.encounters.encounter(lstr_encounter, pl_encounter_id)
if li_sts <= 0 then
	log_error("Error getting encounter data")
	return
end if

if isnull(pl_display_script_id) then
	pl_display_script_id = datalist.get_display_script_id("Encounter", lstr_encounter.encounter_type)
end if

if isnull(pl_display_script_id) or pl_display_script_id <= 0 then
	log_error("No display_script_id")
	return
end if

setredraw(false)
display_script(pl_display_script_id, lstr_encounter, last_assessment, last_treatment)
setredraw(true)

// Restore encounter context
if lstr_last_encounter.encounter_id > 0 then
	last_encounter = lstr_last_encounter
end if


end subroutine

public subroutine redisplay ();str_service_info lstr_service
long ll_scrollpos
integer li_sts
str_treatment_description lstr_treatment
str_treatment_description lstr_new_treatments[]
string ls_find
long ll_count

ll_scrollpos = get_scroll_position_y()

if first_display_script_id > 0 then
	clear_rtf()
	report_attributes = original_report_attributes
	signature_object_id = 0
	command_count = 0
	parent_command_index = 0
	nested = false
	
	if first_encounter.encounter_id > 0 then
		li_sts = current_patient.encounters.encounter( first_encounter, first_encounter.encounter_id)
	end if
	if first_assessment.problem_id > 0 then
		li_sts = current_patient.assessments.assessment( first_assessment, first_assessment.problem_id)
	end if
	if first_treatment.treatment_id > 0 then
		li_sts = current_patient.treatments.treatment( lstr_treatment, first_treatment.treatment_id)
		if li_sts > 0 then
			// See if the treatment has been modified
			if upper(lstr_treatment.treatment_status) = "MODIFIED" &
			 and (isnull(first_treatment.treatment_status) or upper(first_treatment.treatment_status) <> "MODIFIED") then
			 
				// If the treatment was originally not modified and now it is modified, 
				// then find and show the newly created treatment record to reflect
				// the modifications
				ls_find = "original_treatment_id=" + string(first_treatment.treatment_id)
				ll_count = current_patient.treatments.get_treatments(ls_find, lstr_new_treatments)
				if ll_count > 0 then
					// Substitute in the latest modified treatment
					lstr_treatment = lstr_new_treatments[ll_count]
				end if
			end if
			first_treatment = lstr_treatment
		end if
	end if
	display_script(first_display_script_id, first_encounter, first_assessment, first_treatment)
end if

select_text(f_charposition(0, 0))

this.event POST scrollto(ll_scrollpos)




end subroutine

public function integer display_user_signature_stamp (string ps_user_id, long pl_width_inches, long pl_height_inches);any la_property
string ls_text
string ls_temp_file
blob lbl_signature_file

ls_temp_file = user_list.user_signature_stamp(ps_user_id)
if isnull(ls_temp_file) then return 0

add_image(ls_temp_file, pl_width_inches, pl_height_inches)

return 1

end function

public function integer display_observation_results (u_ds_observation_results puo_results, string ps_result_type, string ps_abnormal_flag, string ps_format);integer li_sts

li_sts = 0

CHOOSE CASE lower(ps_format)
	CASE "standard"
		li_sts = puo_results.display_roots(ps_result_type, ps_abnormal_flag, this)
		if li_sts < 0 then log_error("Error displaying observations")
	CASE "grid"
	CASE "list"
END CHOOSE

return li_sts


end function

public function integer display_encounter_observation (str_encounter_description pstr_encounter, string ps_observation_id, string ps_result_type, boolean pb_continuous, boolean pb_latest_only);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: show the latest observation for this encounter
//
//
// Created By: Mark Copenhaver										Creation dt: 7/12/2002
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

u_ds_data luo_data
u_ds_observation_results luo_results
integer li_sts
long ll_count
long ll_observation_sequence
long i
long ll_result_count
boolean lb_first_result

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_sp_get_encounter_observations")
ll_count = luo_data.retrieve(current_patient.cpr_id, pstr_encounter.encounter_id, ps_observation_id)
if ll_count < 0 then
	log_error("Error getting encounter observations")
	DESTROY luo_data
	return 0
end if
if ll_count = 0 then
	// No encounter observations so we're done
	DESTROY luo_data
	return 0
end if

luo_results = CREATE u_ds_observation_results
luo_results.set_dataobject("dw_sp_obstree_observation")

lb_first_result = true

// Read from the end because the datawindow is in reverse order
for i = ll_count to 1 step -1
	if pb_latest_only and i < ll_count then continue
	
	ll_observation_sequence = luo_data.object.observation_sequence[i]
	
	ll_result_count = luo_results.retrieve(current_patient.cpr_id, ll_observation_sequence)
	if ll_result_count > 0 then
		if not lb_first_result then blank_lines(0)
		li_sts = luo_results.display_observation_sequence(ll_observation_sequence, ps_result_type, "Y", pb_continuous, this)
		if li_sts > 0 then lb_first_result = false
	end if
next

DESTROY luo_data
DESTROY luo_results

if isnull(ll_observation_sequence) or lb_first_result then return 0

return 1

end function

public function integer display_encounter_services (str_encounter_description pstr_encounter, string ps_service, string ps_which, string ps_format);u_ds_data luo_data
long ll_count
integer li_sts

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_services_for_encounter")
ll_count = luo_data.retrieve(current_patient.cpr_id, pstr_encounter.encounter_id)


li_sts = display_services(luo_data, ps_service, ps_which, ps_format)
if li_sts < 0 then
	log_error("Error displaying services")
end if

DESTROY luo_data

return li_sts

end function

public function integer display_services (u_ds_data puo_data, string ps_service, string ps_which, string ps_format);string ls_filter
long ll_count
str_grid lstr_grid
integer i
string ls_text
integer li_sts
long ll_color
string ls_user_id
string ls_fielddata
str_service_info lstr_service
string ls_status
string ls_active_service_flag
string ls_description
string ls_ordered_for
string ls_owned_by
string ls_service
long ll_patient_workplan_item_id

CHOOSE CASE lower(ps_which)
	CASE "active"
		ls_filter = "active_service_flag='Y'"
	CASE "completed"
		ls_filter = "lower(status)='completed'"
	CASE "pending"
		ls_filter = "isnull(status) or lower(status)='pending'"
	CASE "cancelled"
		ls_filter = "lower(status)='cancelled'"
	CASE ELSE
		ls_filter = "isnull(status) or lower(status)<>'cancelled'"
END CHOOSE

if not isnull(ps_service) then
	ls_filter = "(" + ls_filter + ")"
	ls_filter += " and lower(ordered_service)='" + lower(ps_service) + "'"
end if

puo_data.setfilter(ls_filter)
li_sts = puo_data.filter()

ll_count = puo_data.rowcount()
if ll_count <= 0 then return ll_count

CHOOSE CASE lower(ps_format)
	CASE "list"
		for i = 1 to ll_count
			if i > 1 then add_cr()
			ls_active_service_flag = puo_data.object.active_service_flag[i]
			ls_description = puo_data.get_field_display(i, "service", "description")
			
			if ls_active_service_flag = "Y" then
				lstr_service.service = "SERVICE"
				f_attribute_add_attribute(lstr_service.attributes, "patient_workplan_item_id", string(long(puo_data.object.patient_workplan_item_id[i])))
				ls_fielddata = f_service_to_field_data(lstr_service)
				add_field(ls_text, ls_fielddata)
			else
				add_text(ls_description)
			end if
		next
	CASE "status list"
		for i = 1 to ll_count
			if i > 1 then add_cr()
			ls_active_service_flag = puo_data.object.active_service_flag[i]
			ls_description = puo_data.get_field_display(i, "service", "description")
			ls_status = puo_data.object.status[i]
			if isnull(ls_status) then
				ls_status = "Pending"
			else
				ls_status = wordcap(ls_status)
			end if
			
			ls_description += " (" + ls_status + ")"
			
			if ls_active_service_flag = "Y" then
				lstr_service.service = "SERVICE"
				f_attribute_add_attribute(lstr_service.attributes, "patient_workplan_item_id", string(long(puo_data.object.patient_workplan_item_id[i])))
				ls_fielddata = f_service_to_field_data(lstr_service)
				add_field(ls_text, ls_fielddata)
			else
				add_text(ls_description)
			end if
		next
	CASE "grid"
		// Initialize the row count
		lstr_grid.row_count = ll_count
		
		// Turn off the title column
		lstr_grid.table_attributes.suppress_title_column = true
		
		// Example:  12:01 12:33 Display Results by Treatment  Completed  Dr. Familia
		lstr_grid.column_count = 5
		lstr_grid.column_title[1] = "Dispatched"
		lstr_grid.column_title[2] = "Completed"
		lstr_grid.column_title[3] = "Service"
		lstr_grid.column_title[4] = "Status"
		lstr_grid.column_title[5] = "Owner"
		for i = 1 to lstr_grid.row_count
			lstr_grid.grid_row[i].column[1].column_text = puo_data.get_field_display(i, "service", "dispatch_time")
			lstr_grid.grid_row[i].column[2].column_text = puo_data.get_field_display(i, "service", "end_time")
			lstr_grid.grid_row[i].column[3].column_text = puo_data.get_field_display(i, "service", "description")
			lstr_grid.grid_row[i].column[4].column_text = puo_data.get_field_display(i, "service", "status")
			lstr_grid.grid_row[i].column[5].column_text = puo_data.get_field_display(i, "service", "owned_by")
		next
		
		add_grid(lstr_grid)
	CASE "message", "task"
		// Show services in reverse chronological order
		for i = ll_count to 1 step -1
			blank_lines(1)
			set_margins(0, 0, 0)
			ll_patient_workplan_item_id = puo_data.object.patient_workplan_item_id[i]
			ls_service = puo_data.object.ordered_service[i]
			
			if lower(ps_format) = "task" or lower(ls_service) <> "message" then
				// "Task" format
				set_bold(true)
				ls_text = puo_data.get_field_display(i, "service", "dispatch_date")
				if not isnull(ls_text) then
					ls_text = "Task created on " + ls_text
					lstr_service.service = "!servicemenu"
					f_attribute_add_attribute(lstr_service.attributes, "patient_workplan_item_id", string(long(puo_data.object.patient_workplan_item_id[i])))
					ls_fielddata = f_service_to_field_data(lstr_service)
					add_field(ls_text, ls_fielddata)
					add_cr()
				end if
				set_bold(false)
				set_margins(150, 0, 0)
				ll_patient_workplan_item_id = puo_data.object.patient_workplan_item_id[i]
				ls_text = f_get_service_messages(ll_patient_workplan_item_id, true)
				add_text(ls_text)
			else
				// "Message" format
				ls_user_id = puo_data.object.ordered_by[i]
				if not isnull(ls_user_id) then
					add_text("From: ")
					set_text_back_color(user_list.user_color(ls_user_id))
					add_text(user_list.user_full_name(ls_user_id))
					unset_text_back_color()
					add_text("  ")
				end if
				
				ls_ordered_for = puo_data.object.ordered_for[i]
				if not isnull(ls_ordered_for) then
					add_text("To: ")
					set_text_back_color(user_list.user_color(ls_ordered_for))
					add_text(user_list.user_full_name(ls_ordered_for))
					unset_text_back_color()
					add_text("  ")
				end if
		
				ls_text = puo_data.get_field_display(i, "service", "dispatch_date")
				if not isnull(ls_text) then
					add_text("Dispatched: ")
					add_text(ls_text)
					add_text("  ")
				end if
		
				ls_status = puo_data.get_field_display(i, "service", "status")
				if not isnull(ls_status) then
					add_text("Status: ")
					add_text(ls_status)
					add_text("  ")
				end if
		
				ls_text = puo_data.get_field_display(i, "service", "end_date")
				if not isnull(ls_text) then
					add_text(ls_text)
					add_text("  ")
				end if
				
				// Print another line if the ordered-for isn't the owned-by
				ls_owned_by = puo_data.object.owned_by[i]
				if ls_owned_by <> ls_ordered_for and lower(ls_status) <> "skipped" then
					blank_lines(0)
					if lower(ls_status) = "completed" then
						add_text("Completed By: ")
					elseif lower(ls_status) = "cancelled" then
						add_text("Cancelled By: ")
					else
						add_text("Owned By: ")
					end if
					
					set_text_back_color(user_list.user_color(ls_owned_by))
					add_text(user_list.user_full_name(ls_owned_by))
					unset_text_back_color()
					add_text("  ")
				end if				
		
				ls_text = puo_data.get_field_display(i, "service", "description")
				if not isnull(ls_text) then
					blank_lines(0)
					
					add_text("Subject: ")
					
					lstr_service.service = "SERVICE"
					f_attribute_add_attribute(lstr_service.attributes, "patient_workplan_item_id", string(long(puo_data.object.patient_workplan_item_id[i])))
					ls_fielddata = f_service_to_field_data(lstr_service)
					add_field(ls_text, ls_fielddata)
				end if
		
				ls_text = puo_data.get_field_display(i, "service", "message")
				if not isnull(ls_text) then
					blank_lines(0)
					add_text("Message: ")
					add_text(ls_text)
				end if
		
				ls_text = puo_data.get_field_display(i, "service", "disposition")
				if not isnull(ls_text) then
					blank_lines(0)
					add_text("Disposition: ")
					add_text(ls_text)
				end if
				blank_lines(0)
			end if
		next
		add_cr()
		set_margins(0, 0, 0)
	CASE "details"
	CASE "workplan"
END CHOOSE


return 1

end function

public function integer display_treatment_services (str_treatment_description pstr_treatment, string ps_service, string ps_which, string ps_format);u_ds_data luo_data
long ll_count
integer li_sts


luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_services_for_treatment")
ll_count = luo_data.retrieve(current_patient.cpr_id, pstr_treatment.treatment_id)

li_sts = display_services(luo_data, ps_service, ps_which, ps_format)
if li_sts < 0 then
	log_error("Error displaying services")
end if

DESTROY luo_data

return li_sts

end function

public function integer display_workplan (long pl_patient_workplan_id, string ps_format);u_ds_data luo_data
long ll_count
integer li_sts
string ls_null

setnull(ls_null)

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_p_patient_wp_item")
ll_count = luo_data.retrieve(pl_patient_workplan_id)
if ll_count <= 0 then return ll_count

li_sts = display_services(luo_data, ls_null, "All", ps_format)

DESTROY luo_data

return li_sts


end function

public function integer display_progress_old (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_progress_display_style, boolean pb_current_only);str_progress_list lstr_progress
integer li_sts
string ls_display_style
long i
string ls_fieldtext
string ls_fielddata
str_service_info lstr_service
string ls_temp
long ll_current_encounter_id
boolean lb_found
string ls_user_id

ll_current_encounter_id = last_encounter.encounter_id

lstr_progress = f_get_progress(current_patient.cpr_id, ps_context_object, pl_object_key, ps_progress_type, ps_progress_key)
if lstr_progress.progress_count <= 0 then return 0

f_sort_progress(lstr_progress)

lb_found = false

for i = 1 to lstr_progress.progress_count
	// Skip progress not if it's not for the current encounter and the current_only flag is set
	if pb_current_only and not isnull(ll_current_encounter_id) then
		if lstr_progress.progress[i].encounter_id <> ll_current_encounter_id then continue
	end if
	
	if lb_found then add_cr()
	lb_found = true
	
	// Determine which display_style to use
	if isnull(ps_progress_display_style) then
		ls_display_style = lstr_progress.progress[i].progress_type_properties.display_style
	else
		ls_display_style = ps_progress_display_style
	end if
	
	CHOOSE CASE lower(ls_display_style)
		CASE "dates"
//			// Set the tab stops
//			set_tab(1, "left", 800)
//			set_tab(2, "left", 2500)
			
			// Add the date stamp
			ls_temp = string(date(lstr_progress.progress[i].progress_date_time))
			add_text(ls_temp)
			add_tab()
			
			// Add the users name
			ls_temp = user_list.user_full_name(lstr_progress.progress[i].user_id)
			add_text(ls_temp)
			add_tab()
			
			if not isnull(lstr_progress.progress[i].progress_key_description) then
				add_text(lstr_progress.progress[i].progress_key_description)
			end if
			if not isnull(lstr_progress.progress[i].progress_note_description) then
				if not isnull(lstr_progress.progress[i].progress_key_description) then add_tab()
				add_text(lstr_progress.progress[i].progress_note_description)
			end if
			if not isnull(lstr_progress.progress[i].attachment_id) then
				ls_fieldtext = current_patient.attachments.attachment_extension_description(lstr_progress.progress[i].attachment_id)
				if isnull(ls_fieldtext) or trim(ls_fieldtext) = "" then ls_fieldtext = "Attachment"
				ls_fieldtext = "<" + ls_fieldtext + ">"
				
				lstr_service.service = "ATTACHMENT"
				f_attribute_add_attribute(lstr_service.attributes, "attachment_id", string(lstr_progress.progress[i].attachment_id))
				f_attribute_add_attribute(lstr_service.attributes, "action", "display")
				ls_fielddata = f_service_to_field_data(lstr_service)
				
				add_text("  ")
				add_field(ls_fieldtext, ls_fielddata)
			end if
		CASE "reviewed by"
			ls_temp = string(lstr_progress.progress[i].progress_date_time, "hh:mm")
			add_text(ls_temp)
			add_text("  Reviewed By ")
			add_text(user_list.user_full_name(lstr_progress.progress[i].user_id))
			if not isnull(lstr_progress.progress[i].progress_key_description) then
				add_text("  ")
				add_text(lstr_progress.progress[i].progress_key_description)
			end if
			if not isnull(lstr_progress.progress[i].progress_note_description) then
				add_tab()
				add_text(lstr_progress.progress[i].progress_note_description)
			end if
			if not isnull(lstr_progress.progress[i].attachment_id) then
				ls_fieldtext = current_patient.attachments.attachment_extension_description(lstr_progress.progress[i].attachment_id)
				if isnull(ls_fieldtext) or trim(ls_fieldtext) = "" then ls_fieldtext = "Attachment"
				ls_fieldtext = "<" + ls_fieldtext + ">"
				
				lstr_service.service = "ATTACHMENT"
				f_attribute_add_attribute(lstr_service.attributes, "attachment_id", string(lstr_progress.progress[i].attachment_id))
				f_attribute_add_attribute(lstr_service.attributes, "action", "display")
				ls_fielddata = f_service_to_field_data(lstr_service)
				
				add_text("  ")
				add_field(ls_fieldtext, ls_fielddata)
			end if
		CASE "times"
			ls_temp = string(lstr_progress.progress[i].progress_date_time, "hh:mm:ss")
			add_text(ls_temp)
			if not isnull(lstr_progress.progress[i].progress_key_description) then
				add_text("  ")
				add_text(lstr_progress.progress[i].progress_key_description)
			end if
			if not isnull(lstr_progress.progress[i].progress_note_description) then
				add_tab()
				add_text(lstr_progress.progress[i].progress_note_description)
			end if
			if not isnull(lstr_progress.progress[i].attachment_id) then
				ls_fieldtext = current_patient.attachments.attachment_extension_description(lstr_progress.progress[i].attachment_id)
				if isnull(ls_fieldtext) or trim(ls_fieldtext) = "" then ls_fieldtext = "Attachment"
				ls_fieldtext = "<" + ls_fieldtext + ">"
				
				lstr_service.service = "ATTACHMENT"
				f_attribute_add_attribute(lstr_service.attributes, "attachment_id", string(lstr_progress.progress[i].attachment_id))
				f_attribute_add_attribute(lstr_service.attributes, "action", "display")
				ls_fielddata = f_service_to_field_data(lstr_service)
				
				add_text("  ")
				add_field(ls_fieldtext, ls_fielddata)
			end if
		CASE ELSE
			// Standard Display Style
			if not isnull(lstr_progress.progress[i].progress_key_description) then
				add_text(lstr_progress.progress[i].progress_key_description)
			end if
			if not isnull(lstr_progress.progress[i].progress_note_description) then
				if not isnull(lstr_progress.progress[i].progress_key_description) then add_tab()
				add_text(lstr_progress.progress[i].progress_note_description)
			end if
			if not isnull(lstr_progress.progress[i].attachment_id) then
				ls_fieldtext = current_patient.attachments.attachment_extension_description(lstr_progress.progress[i].attachment_id)
				if isnull(ls_fieldtext) or trim(ls_fieldtext) = "" then ls_fieldtext = "Attachment"
				ls_fieldtext = "<" + ls_fieldtext + ">"
				
				lstr_service.service = "ATTACHMENT"
				f_attribute_add_attribute(lstr_service.attributes, "attachment_id", string(lstr_progress.progress[i].attachment_id))
				f_attribute_add_attribute(lstr_service.attributes, "action", "display")
				ls_fielddata = f_service_to_field_data(lstr_service)
				
				add_text("  ")
				add_field(ls_fieldtext, ls_fielddata)
			end if
	END CHOOSE
next

return 1



end function

public function integer display_user_property (string ps_user_id, string ps_property, long pl_bitmap_width_inches, long pl_bitmap_height_inches);any la_property
string ls_text
string ls_temp_file
blob lbl_signature_file
string ls_resized_bitmap
long ll_width_pixels, ll_height_pixels

la_property = user_list.user_property(ps_user_id, ps_property)

CHOOSE CASE ClassName(la_property)
    CASE "blob"
		// Assume a blob is a bitmap file
		ls_temp_file = f_temp_file("bmp")
		lbl_signature_file = la_property
		log.file_write(lbl_signature_file, ls_temp_file)
		convert_inches_to_pixels(pl_bitmap_width_inches, pl_bitmap_height_inches, ll_width_pixels, ll_height_pixels)
		ls_resized_bitmap = f_resize_signature_bitmap(ls_temp_file, ll_width_pixels, ll_height_pixels, 245)
		add_image(ls_temp_file, pl_bitmap_width_inches, pl_bitmap_height_inches)
		return 1
    CASE ELSE
		ls_text = string(la_property)
		if len(ls_text) > 0 then
			add_text(ls_text)
			return 1
		else
			return 0
		end if
END CHOOSE



end function

public function integer display_encounter_objects (boolean pb_since_last_encounter);u_ds_data luo_data
long ll_count
long ll_row
long i
string ls_description
string ls_progress_type
datetime ldt_progress_created
string ls_context_object
string ls_object_type
long ll_object_key
long ll_attachment_id
string ls_current_flag
string ls_attachment_extension
string ls_fieldtext
string ls_fielddata
string ls_temp
str_service_info lstr_object_service
str_service_info lstr_attachment_service
boolean lb_found

if isnull(current_display_encounter) then
	log_error("Invalid current_display_encounter")
	log.log(this, "u_rich_text_edit.display_encounter_objects:0023", "Invalid current_display_encounter", 4)
	return -1
end if

luo_data = CREATE u_ds_data
if pb_since_last_encounter then
	luo_data.set_dataobject("dw_sp_get_objects_since_last_encounter")
else
	luo_data.set_dataobject("dw_sp_get_objects_during_encounter")
end if
ll_count = luo_data.retrieve(current_patient.cpr_id, current_display_encounter.encounter_id)
lb_found = false
if ll_count > 0 then
	for i = 1 to ll_count
		ls_context_object = luo_data.object.context_object[i]
		ll_object_key = luo_data.object.object_key[i]
		ls_object_type = luo_data.object.object_type[i]
		ll_attachment_id = luo_data.object.progress_attachment_id[i]
		ls_attachment_extension = luo_data.object.attachment_extension[i]
		ls_current_flag = luo_data.object.progress_current_flag[i]
		
		ls_description = luo_data.object.description[i]
		ls_progress_type = luo_data.object.progress_type[i]
		ldt_progress_created = luo_data.object.progress_created[i]
		ls_description = string(date(ldt_progress_created)) + "  " + ls_description + " (" + wordcap(lower(ls_progress_type)) + ")"

		if lb_found then add_cr()
		
		lstr_object_service.service = f_review_object_service(ls_context_object)
		if isnull(lstr_object_service.service) then
			add_text(ls_description)
		else
			f_attribute_add_attribute(lstr_object_service.attributes, f_object_key_attribute_name(ls_context_object), string(ll_object_key))
			ls_fielddata = f_service_to_field_data(lstr_object_service)
			add_field(ls_description, ls_fielddata)
		end if

		lb_found = true
		
		if not isnull(ll_attachment_id) then
			// Add the description
			ls_temp = current_patient.attachments.attachment_extension_description(ll_attachment_id)
			if isnull(ls_temp) or trim(ls_temp) = "" then ls_temp = "Attachment"
			ls_fieldtext = "<" + ls_temp + ">"
			
			lstr_attachment_service.service = "ATTACHMENT"
			f_attribute_add_attribute(lstr_attachment_service.attributes, "attachment_id", string(ll_attachment_id))
			f_attribute_add_attribute(lstr_attachment_service.attributes, "action", "display")
			ls_fielddata = f_service_to_field_data(lstr_attachment_service)
			add_text(" ")
			add_field(ls_fieldtext, ls_fielddata)
		end if
	next
end if


return 1


end function

public subroutine display_assessment (str_assessment_description pstr_assessment, long pl_display_script_id);integer li_sts
str_assessment_description lstr_last_assessment

// Save the last assessment
lstr_last_assessment = last_assessment

if isnull(pl_display_script_id) then
	pl_display_script_id = datalist.get_display_script_id("Assessment", pstr_assessment.assessment_type)
	if isnull(pl_display_script_id) or pl_display_script_id <= 0 then log_error("No display script_id")
end if

setredraw(false)
display_script(pl_display_script_id, last_encounter, pstr_assessment, last_treatment)
setredraw(true)

// Restore the last assessment
if lstr_last_assessment.problem_id > 0 then
	last_assessment = lstr_last_assessment
end if

end subroutine

public function integer display_attachments (string ps_folder, string ps_attachment_type, string ps_attachment_tag, string ps_extension, long pl_bitmap_width_inches, long pl_bitmap_height_inches, boolean pb_page_break);integer li_sts
long i
long ll_count
long ll_attachment_count
long ll_width_pixels
long ll_height_pixels
u_component_attachment luo_attachment
string ls_attachment_file
boolean lb_found
long ll_attachment_id
u_ds_data luo_data

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_sp_attachment_search")
ll_count = luo_data.retrieve(current_patient.cpr_id, ps_folder, ps_attachment_type, ps_attachment_tag, ps_extension)

for i = 1 to ll_count
	ll_attachment_id = luo_data.object.attachment_id[i]
	
	// Get the attachment object
	li_sts = current_patient.attachments.attachment(luo_attachment, ll_attachment_id)
	if li_sts > 0 then
		li_sts = 0
		// Calculate how big we want it
		convert_inches_to_pixels(pl_bitmap_width_inches, pl_bitmap_height_inches, ll_width_pixels, ll_height_pixels)
		
		// render it to a bitmap
		li_sts = luo_attachment.render("bmp", ls_attachment_file, ll_width_pixels, ll_height_pixels)
		if li_sts > 0 and fileexists(ls_attachment_file) then
			// Add the bitmap to the rtf control
			if lb_found and pb_page_break then add_page_break()
			add_image(ls_attachment_file, pl_bitmap_width_inches, pl_bitmap_height_inches)
			li_sts = 1
			lb_found = true
		end if
		
		component_manager.destroy_component(luo_attachment)
	else
		log_error("Error getting attachment (" + string(ll_attachment_id) + ")")
	end if
next

DESTROY luo_data

return li_sts


end function

public function boolean if_query (string ps_query);boolean lb_return
long ll_value

DECLARE lc_sql_cursor DYNAMIC CURSOR FOR SQLSA ;

PREPARE SQLSA FROM :ps_query ;
if sqlca.sqlcode <> 0 then
	log_error("Error preparing sql")
	return false
end if

OPEN DYNAMIC lc_sql_cursor;
if sqlca.sqlcode <> 0 then
	log_error("Error executing sql")
	return false
end if

// If we had rows, then look at the first column in the first row
FETCH lc_sql_cursor INTO :ll_value ;
if sqlca.sqlcode <> 0 and sqlca.sqlcode <> 100 then
	log_error("Error fetching value")
	lb_return = false
else
	// If it's greater than 0 then it's true
	if ll_value > 0 then
		lb_return = true
	else
		lb_return = false
	end if
end if

CLOSE lc_sql_cursor ;

return lb_return



end function

public function integer display_treatment_followup_items (long pl_treatment_id, string ps_empty_phrase);long ll_count
u_ds_data luo_data
string ls_followup_workplan_type
string ls_treatment_type
long ll_rows
long i
string ls_description

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_followup_workplan_items")

ls_treatment_type = current_patient.treatments.treatment_type(pl_treatment_id)
if isnull(ls_treatment_type) then return 0

ls_followup_workplan_type = datalist.treatment_type_followup_workplan_type(ls_treatment_type)
if isnull(ls_followup_workplan_type) then return 0

ll_rows = luo_data.retrieve(current_patient.cpr_id, pl_treatment_id, ls_followup_workplan_type)
ll_count = 0

for i = 1 to ll_rows
	ls_description = luo_data.object.description[i]
	if isnull(ls_description) or trim(ls_description) = "" then continue
	ll_count += 1
	add_text(ls_description)
	add_cr()
next

DESTROY luo_data

if ll_count <= 0 then
	add_text(ps_empty_phrase)
	add_cr()
end if

return 1

end function

public function integer display_encounter_owner_treatments (str_encounter_description pstr_encounter, string ps_treatment_type, long pl_display_script_id, string ps_which, string ps_sort_column, string ps_sort_direction);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: show the assessments & treatments
//
//
// Created By:Sumathi Chinnasamy										Creation dt: 1/11/2002
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_treatment_description
integer 	j, k
integer 	li_treatment_count,li_child_treatment_count
long		ll_patient_workplan_id
String	ls_owned_by
string ls_null
string ls_date
string ls_find
integer li_count

// User defined
str_treatment_description 		lstra_child_treatments[],lstra_treatments[]

setnull(ls_null)

if trim(ps_treatment_type) = "" then setnull(ps_treatment_type)

li_treatment_count = current_patient.treatments.get_encounter_treatments(pstr_encounter.encounter_id, lstra_treatments)

f_sort_treatments(li_treatment_count, lstra_treatments, ps_sort_column, ps_sort_direction)

li_count = 0

For j = 1 to li_treatment_count
	// Add treatment_type filter if specified
	if not isnull(ps_treatment_type) then
		if lower(ps_treatment_type) <> lower(lstra_treatments[j].treatment_type) then continue
	end if
	
	// Filter out closed treatments
	CHOOSE CASE lower(ps_which)
		CASE "open"
			if lstra_treatments[j].close_encounter_id = pstr_encounter.encounter_id then continue
		CASE "closed"
			if isnull(lstra_treatments[j].close_encounter_id) or lstra_treatments[j].close_encounter_id <> pstr_encounter.encounter_id then continue
	END CHOOSE

	// Check if the encounter owner owns the treatment then display it
	SELECT min(patient_workplan_id) 
	INTO :ll_patient_workplan_id 
	FROM p_Patient_Wp 
	WHERE encounter_id = :lstra_treatments[j].open_encounter_id
	AND treatment_id = :lstra_treatments[j].treatment_id;
	If not tf_check() then return -1
	
	SELECT owned_by 
	INTO :ls_owned_by
	FROM p_Patient_Wp
	WHERE patient_workplan_id = :ll_patient_workplan_id;
	If not tf_check() then return -1
	
	If ls_owned_by <> pstr_encounter.attending_doctor then continue

	// See if this object is confidential
	if not is_provider(reader_user_id) then
		if not user_list.check_access(reader_user_id, lstra_treatments[j].access_control_list) then continue
	end if
	
	li_count += 1
	display_treatment(lstra_treatments[j].treatment_id, pl_display_script_id)
Next

return li_count

end function

public function integer display_encounter_treatments (str_encounter_description pstr_encounter, string ps_treatment_type, long pl_display_script_id, string ps_treatment_status, boolean pb_owner_flag, boolean pb_show_previous, boolean pb_show_new, boolean pb_show_created_in_plan, string ps_sort_column, string ps_sort_direction);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: show the assessments & treatments
//
//
// Created By:Sumathi Chinnasamy										Creation dt: 1/11/2002
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_treatment_description
integer 	j, k
integer 	li_treatment_count,li_child_treatment_count
string ls_null
string ls_date
string ls_find
integer li_count
long		ll_patient_workplan_id
String	ls_owned_by
integer li_temp

// User defined
str_treatment_description 		lstra_child_treatments[],lstra_treatments[]

setnull(ls_null)

if trim(ps_treatment_type) = "" then setnull(ps_treatment_type)

li_treatment_count = current_patient.treatments.get_encounter_treatments(pstr_encounter.encounter_id, lstra_treatments)

f_sort_treatments(li_treatment_count, lstra_treatments, ps_sort_column, ps_sort_direction)

li_count = 0

For j = 1 to li_treatment_count
	// Add treatment_type filter if specified
	if not isnull(ps_treatment_type) then
		if lower(ps_treatment_type) <> lower(lstra_treatments[j].treatment_type) then continue
	end if
	
	// If we don't want previous treatments and this treatment was not created in this encounter then skip it
	if not pb_show_previous then
		if lstra_treatments[j].dispatch_encounter_id <> pstr_encounter.encounter_id then continue
	end if

	// If we don't want new treatments and this treatment was created in this encounter then skip it
	if not pb_show_new then
		if lstra_treatments[j].dispatch_encounter_id = pstr_encounter.encounter_id then continue
	end if
	
	// Filter out closed treatments
	CHOOSE CASE lower(ps_treatment_status)
		CASE "open"
			// skip if this treatment was closed during this encounter
			if lstra_treatments[j].close_encounter_id = pstr_encounter.encounter_id then continue
		CASE "closed"
			// skip if this treatment was not closed during this encounter
			if isnull(lstra_treatments[j].close_encounter_id) or lstra_treatments[j].close_encounter_id <> pstr_encounter.encounter_id then continue
	END CHOOSE
	
	// Filter out managed treatments
	if not pb_show_created_in_plan then
		// If the treatment was created in a previous encounter then see if there were any Assessment Associate
		// progress records in any previous encounters
		SELECT count(*)
		INTO :li_temp
		FROM p_Treatment_Progress
		WHERE cpr_id = :current_patient.cpr_id
		AND treatment_id = :lstra_treatments[j].treatment_id
		AND progress_type = 'ASSESSMENT'
		AND progress_key = 'Associate'
		AND progress_date_time < dateadd(s, 3, :lstra_treatments[j].created);
		if not tf_check() then return -1
		if li_temp > 0 then continue
	end if
		
	
	if pb_owner_flag then
		// Check if the encounter owner owns the treatment then display it
		SELECT min(patient_workplan_id) 
		INTO :ll_patient_workplan_id 
		FROM p_Patient_Wp 
		WHERE encounter_id = :lstra_treatments[j].open_encounter_id
		AND treatment_id = :lstra_treatments[j].treatment_id;
		If not tf_check() then return -1
		
		SELECT owned_by 
		INTO :ls_owned_by
		FROM p_Patient_Wp
		WHERE patient_workplan_id = :ll_patient_workplan_id;
		If not tf_check() then return -1
		
		If ls_owned_by <> pstr_encounter.attending_doctor then continue
	end if
	
	// See if this object is confidential
	if not is_provider(reader_user_id) then
		if not user_list.check_access(reader_user_id, lstra_treatments[j].access_control_list) then continue
	end if

	li_count += 1
	display_treatment(lstra_treatments[j].treatment_id, pl_display_script_id)
Next

return li_count

end function

public function integer display_patient_encounters (string ps_encounter_type, long pl_display_script_id, string ps_sort_column, string ps_sort_direction);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: show the encounters & encounters
//
//
// Created By:Sumathi Chinnasamy										Creation dt: 1/11/2002
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_encounter_description
integer 	i
integer 	li_encounter_count,li_child_encounter_count
string ls_null
string ls_date
string ls_find
str_encounter_description lstra_encounters[]

setnull(ls_null)

if trim(ps_encounter_type) = "" then setnull(ps_encounter_type)

if isnull(ps_encounter_type) then
	ls_find = "1=1"
else
	ls_find = "encounter_type='" + ps_encounter_type + "'"
end if

li_encounter_count = current_patient.encounters.encounter_list(ls_find, lstra_encounters)

f_sort_encounters(li_encounter_count, lstra_encounters, ps_sort_column, ps_sort_direction)

For i = 1 to li_encounter_count
	// See if this object is confidential
	if not is_provider(reader_user_id) then
		if not user_list.check_access(reader_user_id, lstra_encounters[i].access_control_list) then continue
	end if

	display_encounter(lstra_encounters[i].encounter_id, pl_display_script_id)
Next

return li_encounter_count

end function

public function integer display_patient_treatments (string ps_treatment_type, long pl_display_script_id, string ps_which, datetime pdt_begin_date, datetime pdt_end_date, string ps_header_phrase, string ps_footer_phrase, string ps_sort_column, string ps_sort_direction);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: show the assessments & treatments
//
//
// Created By:Sumathi Chinnasamy										Creation dt: 1/11/2002
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_treatment_description
integer 	j, k
integer 	li_treatment_count,li_child_treatment_count
string ls_null
string ls_date
string ls_find
integer li_count
date ld_date

// User defined
str_treatment_description 		lstra_child_treatments[],lstra_treatments[]

setnull(ls_null)

if trim(ps_treatment_type) = "" then setnull(ps_treatment_type)

if isnull(ps_treatment_type) then
	ls_find = "1=1"
else
	ls_find = "treatment_type='" + ps_treatment_type + "'"
end if

if not isnull(pdt_begin_date) then
	ls_date = "datetime('" + string(pdt_begin_date, "[shortdate] [time]") + "')"
	ls_find += " and begin_date >= " + ls_date
end if

if not isnull(pdt_end_date) then
	// Add one to the date and then limit to dates strictly less than it
	ld_date = relativedate(date(pdt_end_date), 1)
	ls_date = "datetime('" + string(datetime(ld_date, time("")), "[shortdate] [time]") + "')"
	ls_find += " and begin_date < " + ls_date
end if

li_treatment_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)

f_sort_treatments(li_treatment_count, lstra_treatments, ps_sort_column, ps_sort_direction)

li_count = 0

For j = 1 to li_treatment_count
	// Add treatment_type filter if specified
	if not isnull(ps_treatment_type) then
		if lower(ps_treatment_type) <> lower(lstra_treatments[j].treatment_type) then continue
	end if
	
	// Filter out closed treatments
	CHOOSE CASE lower(ps_which)
		CASE "open"
			if not isnull(lstra_treatments[j].close_encounter_id) then continue
		CASE "closed"
			if isnull(lstra_treatments[j].close_encounter_id) then continue
	END CHOOSE
	
	// See if this object is confidential
	if not is_provider(reader_user_id) then
		if not user_list.check_access(reader_user_id, lstra_treatments[j].access_control_list) then continue
	end if

	li_count += 1
	if li_count = 1 and not isnull(ps_header_phrase) then
		add_text(ps_header_phrase)
		add_cr()
	end if
	display_treatment(lstra_treatments[j].treatment_id, pl_display_script_id)
Next

if li_count > 0 and not isnull(ps_footer_phrase) then
	if linelength() > 0 then add_cr()
	add_text(ps_footer_phrase)
end if

return li_count

end function

public function integer display_encounter_assessments (str_encounter_description pstr_encounter, string ps_assessment_type, string ps_exclude_assessment_type, string ps_acuteness, long pl_display_script_id, boolean pb_billed_only, boolean pb_show_previous, boolean pb_show_new, string ps_assessment_status, string ps_header_phrase, string ps_footer_phrase, string ps_sort_column, string ps_sort_direction);long i
long ll_count
long ll_found_count
str_assessment_description lstra_assessments[]
string ls_find
string ls_date
string ls_acuteness

if trim(ps_assessment_type) = "" then setnull(ps_assessment_type)

ll_found_count = 0

ll_count = current_patient.assessments.get_encounter_assessments(pstr_encounter.encounter_id, lstra_assessments)

f_sort_assessments(ll_count, lstra_assessments, ps_sort_column, ps_sort_direction)

for i = 1 to ll_count
	// Add assessment_type filter if specified
	if not isnull(ps_assessment_type) then
		if lower(lstra_assessments[i].assessment_type) <> lower(ps_assessment_type) then continue
	end if
	
	// Skip if excluded
	if lower(lstra_assessments[i].assessment_type) = lower(ps_exclude_assessment_type) then continue
	
	// If we don't want previous assessments and this assessment was not created in this encounter then skip it
	if not pb_show_previous then
		if lstra_assessments[i].open_encounter_id <> pstr_encounter.encounter_id then continue
	end if

	// If we don't want new assessments and this assessment was created in this encounter then skip it
	if not pb_show_new then
		if lstra_assessments[i].open_encounter_id = pstr_encounter.encounter_id then continue
	end if
	
	// Filter out assessments based on acuteness
	if len(ps_acuteness) > 0 then
		ls_acuteness = datalist.assessment_acuteness(lstra_assessments[i].assessment_id)
		// skip if the acuteness of this assessment does not match the desired value
		if ls_acuteness <> ps_acuteness then continue
	end if
	
	// Filter out assessments based on status
	CHOOSE CASE lower(ps_assessment_status)
		CASE "open"
			// skip if this assessment was closed during this encounter
			if lstra_assessments[i].close_encounter_id = pstr_encounter.encounter_id then continue
		CASE "closed"
			// skip if this assessment was not closed during this encounter
			if isnull(lstra_assessments[i].close_encounter_id) &
			 or lstra_assessments[i].close_encounter_id <> pstr_encounter.encounter_id then continue
	END CHOOSE
	
	// If we only want billed assessments and this assessment isn't billed in this encounter then skip it
	if pb_billed_only then
		if not current_patient.assessments.in_encounter(lstra_assessments[i].problem_id, pstr_encounter.encounter_id) then continue
	end if
	
	// See if this object is confidential
	if not is_provider(reader_user_id) then
		if not user_list.check_access(reader_user_id, lstra_assessments[i].access_control_list) then continue
	end if
	
	ll_found_count += 1
	if ll_found_count = 1 and not isnull(ps_header_phrase) then
		add_text(ps_header_phrase)
		add_cr()
	end if
	display_assessment(lstra_assessments[i], pl_display_script_id)
next

if ll_found_count > 0 and not isnull(ps_footer_phrase) then
	if linelength() > 0 then add_cr()
	add_text(ps_footer_phrase)
end if

return ll_found_count


end function

public function integer display_patient_assessments (string ps_assessment_type, string ps_exclude_assessment_type, string ps_acuteness, long pl_display_script_id, string ps_which, string ps_header_phrase, string ps_footer_phrase, string ps_sort_column, string ps_sort_direction);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: show the assessments & assessments
//
//
// Created By:Sumathi Chinnasamy										Creation dt: 1/11/2002
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_assessment_description
integer 	j, k
integer 	li_assessment_count,li_child_assessment_count
string ls_null
string ls_date
string ls_find
integer li_count
string ls_acuteness

// User defined
str_assessment_description 		lstra_assessments[]

setnull(ls_null)

if trim(ps_assessment_type) = "" then setnull(ps_assessment_type)

if isnull(ps_assessment_type) then
	ls_find = "1=1"
else
	ls_find = "assessment_type='" + ps_assessment_type + "'"
end if

li_assessment_count = current_patient.assessments.get_assessments(ls_find, lstra_assessments)

f_sort_assessments(li_assessment_count, lstra_assessments, ps_sort_column, ps_sort_direction)

li_count = 0

For j = 1 to li_assessment_count
	// Add assessment_type filter if specified
	if not isnull(ps_assessment_type) then
		if lower(ps_assessment_type) <> lower(lstra_assessments[j].assessment_type) then continue
	end if
	
	// Skip if excluded
	if lower(lstra_assessments[j].assessment_type) = lower(ps_exclude_assessment_type) then continue
	
	// Filter out assessments based on acuteness
	if len(ps_acuteness) > 0 then
		// Skip if assessment acuteness doesn't match desired acuteness
		ls_acuteness = datalist.assessment_acuteness(lstra_assessments[j].assessment_id)
		if ls_acuteness <> ps_acuteness then continue
	end if

	// Filter out closed assessments
	CHOOSE CASE lower(ps_which)
		CASE "open"
			if not isnull(lstra_assessments[j].close_encounter_id) then continue
		CASE "closed"
			if isnull(lstra_assessments[j].close_encounter_id) then continue
	END CHOOSE
	
	// See if this object is confidential
	if not is_provider(reader_user_id) then
		if not user_list.check_access(reader_user_id, lstra_assessments[j].access_control_list) then continue
	end if

	li_count += 1
	if li_count = 1 and not isnull(ps_header_phrase) then
		add_text(ps_header_phrase)
		add_cr()
	end if
	display_assessment(lstra_assessments[j], pl_display_script_id)
Next

if li_count > 0 and not isnull(ps_footer_phrase) then
	if linelength() > 0 then add_cr()
	add_text(ps_footer_phrase)
end if

return li_count

end function

public function integer display_patient_health_maintenance (string ps_header_phrase, string ps_footer_phrase, string ps_empty_phrase, string ps_body_format, boolean pb_use_colors);u_ds_data luo_data
long ll_count
long i
string ls_description
datetime ldt_schedule_date
//str_tx_fontstate lstr_fontstate
string ls_date
long ll_color
long ll_warning_days
datetime ldt_today
str_font_settings lstr_font_settings_save
str_font_settings lstr_font_settings

lstr_font_settings = get_empty_font_settings()
ldt_today = datetime(today(), now())

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_patient_maintenance")
ll_count = luo_data.retrieve(current_patient.cpr_id)
if ll_count <= 0 then
	add_text(ps_empty_phrase)
	return 0
end if

if len(ps_header_phrase) > 0 then
	add_text(ps_header_phrase)
	add_cr()
end if

if len(ps_body_format) > 0 then
	lstr_font_settings_save = get_font_settings()
//	lstr_fontstate = get_fontstate()
	apply_formatting(ps_body_format)
end if

for i = 1 to ll_count
	ll_warning_days = luo_data.object.warning_days[i]
	ls_description = luo_data.object.description[i]
	ldt_schedule_date = luo_data.object.schedule_date[i]
	
	add_text(ls_description + "~t")
	
	if isnull(ldt_schedule_date) then
		ls_date = "Never Done"
	else
		ls_date = "Due on " + string(ldt_schedule_date, "[shortdate]")
	end if

	
	// Calculate status
	if isnull(ldt_schedule_date) then
		ll_color = color_text_error
	elseif ldt_schedule_date < ldt_today then
		ll_color = color_text_error
	else
		if daysafter(date(ldt_today), date(ldt_schedule_date)) <= ll_warning_days then
			ll_color = color_text_warning
		else
			// Don't set a color
			setnull(ll_color)
		end if
	end if

	lstr_font_settings.forecolor = ll_color
	add_text(ls_date, lstr_font_settings)
	add_cr()
next

if len(ps_body_format) > 0 then
	set_font_settings(lstr_font_settings_save)
//	set_fontstate(lstr_fontstate)
end if

if len(ps_footer_phrase) > 0 then
	add_text(ps_footer_phrase)
	add_cr()
end if

return ll_count



end function

public function integer display_encounter_observations (str_encounter_description pstr_encounter, string ps_observation_type, long pl_display_script_id, boolean pb_show_previous, boolean pb_show_new, string ps_sort_column, string ps_sort_direction);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: show the assessments & treatments
//
//
// Created By:Sumathi Chinnasamy										Creation dt: 1/11/2002
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_treatment_description
integer 	j, k
integer 	li_treatment_count,li_child_treatment_count
string ls_null
string ls_date
string ls_find
integer li_count

// User defined
str_treatment_description 		lstra_child_treatments[],lstra_treatments[]

setnull(ls_null)

if trim(ps_observation_type) = "" then setnull(ps_observation_type)

li_treatment_count = current_patient.treatments.get_encounter_treatments(pstr_encounter.encounter_id, lstra_treatments)

f_sort_treatments(li_treatment_count, lstra_treatments, ps_sort_column, ps_sort_direction)

li_count = 0

For j = 1 to li_treatment_count
	// Add observation_type filter if specified
	if not isnull(ps_observation_type) then
		if isnull(lstra_treatments[j].observation_type) OR (lower(ps_observation_type) <> lower(lstra_treatments[j].observation_type)) then continue
	end if
	
	// If we don't want previous treatments and this treatment was not created in this encounter then skip it
	if not pb_show_previous then
		if lstra_treatments[j].open_encounter_id <> pstr_encounter.encounter_id then continue
	end if

	// If we don't want new treatments and this treatment was created in this encounter then skip it
	if not pb_show_new then
		if lstra_treatments[j].open_encounter_id = pstr_encounter.encounter_id then continue
	end if
	
	li_count += 1
	display_treatment(lstra_treatments[j].treatment_id, pl_display_script_id)
Next

return li_count

end function

public function integer display_encounter_owner_observations (str_encounter_description pstr_encounter, string ps_observation_type, long pl_display_script_id, boolean pb_show_previous, boolean pb_show_new, string ps_sort_column, string ps_sort_direction);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: show the assessments & treatments
//
//
// Created By:Sumathi Chinnasamy										Creation dt: 1/11/2002
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_treatment_description
integer 	j, k
integer 	li_treatment_count,li_child_treatment_count
string ls_null
string ls_date
string ls_find
long ll_patient_workplan_id
string ls_owned_by
integer li_count

// User defined
str_treatment_description 		lstra_child_treatments[],lstra_treatments[]

setnull(ls_null)

if trim(ps_observation_type) = "" then setnull(ps_observation_type)

li_treatment_count = current_patient.treatments.get_encounter_treatments(pstr_encounter.encounter_id, lstra_treatments)

f_sort_treatments(li_treatment_count, lstra_treatments, ps_sort_column, ps_sort_direction)

li_count = 0

For j = 1 to li_treatment_count
	// Add observation_type filter if specified
	if not isnull(ps_observation_type) then
		if isnull(lstra_treatments[j].observation_type) OR (lower(ps_observation_type) <> lower(lstra_treatments[j].observation_type)) then continue
	end if

	// If we don't want previous treatments and this treatment was not created in this encounter then skip it
	if not pb_show_previous then
		if lstra_treatments[j].open_encounter_id <> pstr_encounter.encounter_id then continue
	end if

	// If we don't want new treatments and this treatment was created in this encounter then skip it
	if not pb_show_new then
		if lstra_treatments[j].open_encounter_id = pstr_encounter.encounter_id then continue
	end if
	
	// Check if the encounter owner owns the treatment then display it
	SELECT min(patient_workplan_id) 
	INTO :ll_patient_workplan_id 
	FROM p_Patient_Wp 
	WHERE encounter_id = :lstra_treatments[j].open_encounter_id
	AND treatment_id = :lstra_treatments[j].treatment_id;
	If not tf_check() then
		log_error("Error getting patient_workplan_id")
		return -1
	end if
	
	SELECT owned_by 
	INTO :ls_owned_by
	FROM p_Patient_Wp
	WHERE patient_workplan_id = :ll_patient_workplan_id;
	If not tf_check() then
		log_error("Error getting workplan owner")
		return -1
	end if
	
	If ls_owned_by <> pstr_encounter.attending_doctor then continue

	// See if this object is confidential
	if not is_provider(reader_user_id) then
		if not user_list.check_access(reader_user_id, lstra_treatments[j].access_control_list) then continue
	end if

	li_count += 1
	display_treatment(lstra_treatments[j].treatment_id, pl_display_script_id)
Next

return li_count

end function

public function boolean is_provider (string ps_user_id);if isnull(current_patient) then return false

// See if the user is the primary or secondary provider for this patient
if upper(ps_user_id) = upper(current_patient.primary_provider_id) &
 or upper(ps_user_id) = upper(current_patient.secondary_provider_id) then
	return true
end if

// See if the user owns this encounter
if isnull(last_encounter.encounter_id) then return false

if upper(ps_user_id) = upper(last_encounter.attending_doctor) then return true

return false


end function

public function integer display_patient_services (string ps_service, string ps_which, string ps_format);u_ds_data luo_data
long ll_count
integer li_sts

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_services_for_patient")
ll_count = luo_data.retrieve(current_patient.cpr_id, ps_service)


li_sts = display_services(luo_data, ps_service, ps_which, ps_format)
if li_sts < 0 then log_error("Error displaying services")

DESTROY luo_data

return li_sts

end function

public function integer display_immunization_status (long pl_encounter_id, boolean pb_show_reason);u_ds_data luo_data
long ll_count
datetime ldt_current_date
long i
str_grid lstr_grid
string ls_description
long ll_dose_number
string ls_dose_status
datetime ldt_dose_date
string ls_dose_text

ldt_current_date = datetime(today(), now())

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_jmj_patient_immunization_status")
ll_count = luo_data.retrieve(current_patient.cpr_id, ldt_current_date)

// Add data to grid structure
if pb_show_reason then
	lstr_grid.column_count = 4
else
	lstr_grid.column_count = 3
end if
lstr_grid.table_attributes.bold_headings = true
lstr_grid.column_title[1] = "Vaccine/Disease"
lstr_grid.column_title[2] = "Previous Doses"
lstr_grid.column_title[3] = "Due Next"
lstr_grid.column_title[4] = "Reason"

lstr_grid.row_count = 0

// Loop through the results in the datastore and print a different grid for each root_sequence we encounter
for i = 1 to ll_count
	lstr_grid.row_count += 1
	
	ls_description = luo_data.object.description[i]
	ll_dose_number = luo_data.object.dose_number[i]
	ls_dose_status = wordcap(luo_data.object.dose_status[i])
	ldt_dose_date = luo_data.object.dose_date[i]
	ls_dose_text = luo_data.object.dose_text[i]

	lstr_grid.grid_row[lstr_grid.row_count].column[1].column_text = luo_data.object.description[i]
	lstr_grid.grid_row[lstr_grid.row_count].column[2].column_text = string(ll_dose_number - 1)
	
	if ls_dose_status = 'Given' or ls_dose_status = 'Projected' then
		lstr_grid.grid_row[lstr_grid.row_count].column[3].column_text = string(ldt_dose_date, '[shortdate]')
	else
		lstr_grid.grid_row[lstr_grid.row_count].column[3].column_text = wordcap(ls_dose_status)
	end if

	lstr_grid.grid_row[lstr_grid.row_count].column[4].column_text = ls_dose_text
next

add_grid(lstr_grid)

return 1


end function

public function string get_last_progress_property (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_progress_property);str_progress lstr_progress
integer li_sts
string ls_text
string ls_null

setnull(ls_null)

li_sts = f_get_last_progress(current_patient.cpr_id, ps_context_object, pl_object_key, ps_progress_type, ps_progress_key, lstr_progress)
if li_sts < 0 then
	log_error("Error getting last progress")
	return ls_null
end if
if li_sts = 0 then
	return ls_null
end if

	
CHOOSE CASE lower(ps_progress_property)
	CASE "user_id"
		ls_text = lstr_progress.user_id
	CASE "progress_date_time"
		ls_text = string(lstr_progress.progress_date_time)
	CASE "progress_key"
		ls_text = lstr_progress.progress_key_description
	CASE "progress"
		ls_text = lstr_progress.progress_note_description
	CASE "created"
		ls_text = string(lstr_progress.created)
	CASE "created_by"
		ls_text = lstr_progress.created_by
END CHOOSE


return ls_text

end function

public subroutine set_report_attributes (str_attributes pstr_attributes);
original_report_attributes = pstr_attributes
report_attributes = original_report_attributes


end subroutine

public subroutine display_script_from_attributes (str_attributes pstr_attributes, long pl_display_script_id);integer li_sts
long i
long ll_object_key
str_attributes lstr_report_attributes_save

str_encounter_description lstr_encounter
str_assessment_description lstr_assessment
str_treatment_description lstr_treatment

if isnull(pl_display_script_id) then return

lstr_encounter = last_encounter
lstr_assessment = last_assessment
lstr_treatment = last_treatment


// Look for a new context in the attributes
for i = 1 to pstr_attributes.attribute_count
	li_sts = 0
	if isnumber(pstr_attributes.attribute[i].value) then
		ll_object_key = long(pstr_attributes.attribute[i].value)
		CHOOSE CASE lower(pstr_attributes.attribute[i].attribute)
			CASE "encounter_id"
				li_sts = current_patient.encounters.encounter(lstr_encounter, ll_object_key)
				if li_sts <= 0 then lstr_encounter = last_encounter
			CASE "assessment_id"
				li_sts = current_patient.assessments.assessment(lstr_assessment, ll_object_key)
				if li_sts <= 0 then lstr_assessment = last_assessment
			CASE "treatment_id"
				li_sts = current_patient.treatments.treatment(lstr_treatment, ll_object_key)
				if li_sts <= 0 then lstr_treatment = last_treatment
		END CHOOSE
	end if
	if li_sts > 0 then exit
next

// push the attributes into the report_attributes, but save the report_attributes and restore them later
lstr_report_attributes_save = report_attributes
f_attribute_add_attributes(report_attributes, pstr_attributes)

// Display the specified script
display_script(pl_display_script_id, lstr_encounter, lstr_assessment, lstr_treatment)

// restore the attributes
report_attributes = lstr_report_attributes_save


end subroutine

public subroutine add_hot_text (string ps_text, long pl_menu_id);str_service_info lstr_service
string ls_fielddata


if pl_menu_id > 0 then
	// Prepare the field data string
	lstr_service.service = "Menu"
	f_attribute_add_attribute(lstr_service.attributes, "menu_id", string(pl_menu_id))

	if last_encounter.encounter_id > 0 then
		f_attribute_add_attribute(lstr_service.attributes, "encounter_id", string(last_encounter.encounter_id))
	end if

	if last_assessment.problem_id > 0 then
		f_attribute_add_attribute(lstr_service.attributes, "problem_id", string(last_assessment.problem_id))
	end if

	if last_treatment.treatment_id > 0 then
		f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(last_treatment.treatment_id))
	end if

	ls_fielddata = f_service_to_field_data(lstr_service)
	add_field(ps_text, ls_fielddata, false)
else
	add_text(ps_text)
end if

end subroutine

public function string display_script_local (long pl_display_script_id, str_encounter_description pstr_encounter, str_assessment_description pstr_assessment, str_treatment_description pstr_treatment, long pl_width, long pl_height);string ls_text

width = pl_width
height = pl_height

clear_rtf()

display_script_a( pl_display_script_id, &
						pstr_encounter, &
						pstr_assessment, &
						pstr_treatment, &
						false)

ls_text = rich_text()

return ls_text

end function

private subroutine display_assessment_treatments (str_assessment_description pstr_assessment, string ps_treatment_type, boolean pb_current_only, long pl_display_script_id, string ps_sort_column, string ps_sort_direction, boolean pb_attached_treatments_only);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: show the assessments & treatments
//
//
// Created By:Sumathi Chinnasamy										Creation dt: 1/11/2002
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_treatment_description
integer 	j, k
integer 	li_treatment_count,li_child_treatment_count
string ls_in_office_flag
string ls_null
str_treatment_description		lstra_treatments[]

setnull(ls_null)

if trim(ps_treatment_type) = "" then setnull(ps_treatment_type)

li_treatment_count = current_patient.treatments.get_assessment_treatments(pstr_assessment.problem_id, pb_attached_treatments_only, lstra_treatments)

f_sort_treatments(li_treatment_count, lstra_treatments, ps_sort_column, ps_sort_direction)

For j = 1 to li_treatment_count
	if not isnull(last_encounter.encounter_id) and pb_current_only then
		// Don't show treatments closed before this encounter
		if date(lstra_treatments[j].end_date) < date(last_encounter.encounter_date) &
		  and not (lstra_treatments[j].close_encounter_id = last_encounter.encounter_id) then continue
	
		// Don't show treatments opened after this encounter
		if lstra_treatments[j].begin_date >= last_encounter.encounter_date And &
			lstra_treatments[j].open_encounter_id <> last_encounter.encounter_id then continue
			
		// Don't show in-office treatments unless they were actually created during this encounter
		ls_in_office_flag = datalist.treatment_type_in_office_flag(lstra_treatments[j].treatment_type)
		if ls_in_office_flag = "Y" and lstra_treatments[j].open_encounter_id <> last_encounter.encounter_id then continue
	end if
	
	if not isnull(ps_treatment_type) then
		if lstra_treatments[j].treatment_type <> ps_treatment_type then continue
	end if
	
	// See if this object is confidential
	if not is_provider(reader_user_id) then
		if not user_list.check_access(reader_user_id, lstra_treatments[j].access_control_list) then continue
	end if

	display_treatment(lstra_treatments[j].treatment_id, pl_display_script_id)
Next


end subroutine

public function integer display_sql_query (string ps_sql, boolean pb_show_headings, boolean pb_show_lines);string ls_temp
u_ds_data luo_data
integer li_sts
str_grid lstr_grid
string ls_sql
string ls_query

if isnull(ps_sql) or trim(ps_sql) = "" then
	return 0
end if

ls_sql = "DROP PROCEDURE #tmprptproc_query_grid"
EXECUTE IMMEDIATE :ls_sql;

ls_sql = "CREATE PROCEDURE #tmprptproc_query_grid AS " + ps_sql
EXECUTE IMMEDIATE :ls_sql;
if not tf_check() then
	log_error("Error executing sql")
	return -1
end if

ls_query = "EXECUTE #tmprptproc_query_grid"

luo_data = CREATE u_ds_data
li_sts = luo_data.load_query(ls_query)
if li_sts < 0 then
	log_error("Error loading sql data")
	return -1
elseif li_sts = 0 then
	return 0
end if

lstr_grid = luo_data.get_grid()

DESTROY luo_data

lstr_grid.table_attributes.suppress_headings = not pb_show_headings
lstr_grid.table_attributes.suppress_lines = not pb_show_lines
lstr_grid.table_attributes.suppress_title_column = true

add_grid(lstr_grid)

return 1

end function

public function integer display_sql_query_renorm (string ps_sql, string ps_column_1_title, boolean pb_include_row_total, boolean pb_include_row_average, boolean pb_include_column_total, boolean pb_include_column_average, str_rtf_table_attributes pstr_table_attributes, string ps_data_display_format);// This procedure display the results of the passed in query in a grid
// To query is expected to return 5 columns as follows:
//
//	RowTitle varchar(40) NOT NULL,
//	RowOrder int NOT NULL,
//	ColumnTitle varchar(40) NOT NULL,
//	ColumnOrder int NOT NULL,
//	DataValue decimal(15.3) NULL
//
// The datawindow object will sort the data by columnorder and roworder.  This should allow the query to determine the order in which the rows and columns appear in the grid
// The data value will be converted to a string using the passed in display format and then place in the grid cell matching the rowtitle and columntitle associated with the datavalue.
// If multiple datavalues are found for the same rowtitle/columntitle combination then the last one in the result set will be displayed.

u_ds_data luo_data
long ll_rowcount
long i, j
str_tx_fontstate lstr_fontstate_save
integer li_sts
str_grid lstr_grid
string ls_rowtitle
string ls_columntitle
string ls_last_columntitle
decimal ld_datavalue
long ll_row
long ll_column
string ls_sql
decimal ld_total
long ll_datacolumns
long ll_datarows
long ll_total_row
long ll_average_row
long ll_total_column
long ll_average_column
decimal ld_null
long ll_value_count
str_font_settings lstr_aggregate_font_settings

setnull(ld_null)
lstr_aggregate_font_settings = f_empty_font_settings()
lstr_aggregate_font_settings.bold = true

if isnull(ps_sql) or trim(ps_sql) = "" then
	log.log(this, "u_rich_text_edit.display_sql_query_renorm:0043", "No sql query specified", 4)
	return -1
end if


ls_sql = "DROP PROCEDURE #tmprptproc_query_grid"
EXECUTE IMMEDIATE :ls_sql;

ls_sql = "CREATE PROCEDURE #tmprptproc_query_grid AS " + ps_sql
EXECUTE IMMEDIATE :ls_sql;
if not tf_check() then
	log_error("Error executing sql")
	return -1
end if

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_rtf_query_grid_data")
ll_rowcount = luo_data.retrieve()
if ll_rowcount < 0 then
	log_error("Error retrieving data")
	log.log(this, "u_rich_text_edit.display_sql_query_renorm:0063", "Error running sql query: " + ps_sql, 4)
	return -1
end if
if ll_rowcount = 0 then
	return 0
end if


if isnull(ps_data_display_format) or trim(ps_data_display_format) = "" then
	ps_data_display_format = "0.##"
end if

// Add data to grid structure
lstr_grid.table_attributes = pstr_table_attributes
lstr_grid.table_attributes.bold_headings = true
lstr_grid.table_attributes.suppress_title_column = true

lstr_grid.column_count = 1
lstr_grid.column_title[1] = ps_column_1_title

ls_last_columntitle = ""

for i = 1 to ll_rowcount
	ls_rowtitle = luo_data.object.rowtitle[i]
	ls_columntitle = luo_data.object.columntitle[i]
	ld_datavalue = luo_data.object.datavalue[i]

	// Find the row
	ll_row = 0
	for j = 1 to lstr_grid.row_count
		if ls_rowtitle = lstr_grid.grid_row[j].column[1].column_text then
			ll_row = j
			exit
		end if
	next
	
	// If we didn't find the row then add it
	if ll_row = 0 then
		lstr_grid.row_count += 1
		lstr_grid.grid_row[lstr_grid.row_count].column[1].column_text = ls_rowtitle
		ll_row = lstr_grid.row_count
	end if

	// Find the column
	ll_column = 0
	for j = 2 to lstr_grid.column_count
		if ls_columntitle = lstr_grid.column_title[j] then
			ll_column = j
			exit
		end if
	next
	
	// If we didn't find the column then add it
	if ll_column = 0 then
		lstr_grid.column_count += 1
		lstr_grid.column_title[lstr_grid.column_count] = ls_columntitle
		ll_column = lstr_grid.column_count
	end if

	lstr_grid.grid_row[ll_row].column[ll_column].column_text = string(ld_datavalue, ps_data_display_format)
next

// Go through every cell and make sure it has
for i = 1 to lstr_grid.row_count
	for j = 1 to lstr_grid.column_count
		if upperbound(lstr_grid.grid_row[i].column) < j then
			lstr_grid.grid_row[i].column[j].column_text = ""
		end if
		
		if isnull(lstr_grid.grid_row[i].column[j].column_text) or lstr_grid.grid_row[i].column[j].column_text = "" then
			lstr_grid.grid_row[i].column[j].column_text = string(ld_null, ps_data_display_format)
		end if
	next
next


// Add the calculated columns
ll_datacolumns = lstr_grid.column_count
ll_datarows = lstr_grid.row_count
if pb_include_row_total then
	lstr_grid.column_count += 1
	ll_total_column = lstr_grid.column_count
	lstr_grid.column_title[ll_total_column] = "Total"
end if
if pb_include_row_average then
	lstr_grid.column_count += 1
	ll_average_column = lstr_grid.column_count
	lstr_grid.column_title[ll_average_column] = "Average"
end if
if pb_include_row_average or pb_include_row_total then
	for i = 1 to ll_datarows
		ld_total = 0
		ll_value_count = 0
		for j = 2 to ll_datacolumns
			if isnumber(lstr_grid.grid_row[i].column[j].column_text) then
				ll_value_count += 1
				ld_total += dec(lstr_grid.grid_row[i].column[j].column_text)
			end if
		next
		if pb_include_row_average then
			lstr_grid.grid_row[i].column[ll_average_column].column_text = string(ld_total / ll_value_count, ps_data_display_format)
		end if
		if pb_include_row_total then
			lstr_grid.grid_row[i].column[ll_total_column].column_text = string(ld_total, ps_data_display_format)
		end if
	next
end if		

// Add the calculated rows
if pb_include_column_total then
	lstr_grid.row_count += 1
	ll_total_row = lstr_grid.row_count
	lstr_grid.grid_row[ll_total_row].column[1].column_text = "Total"
	lstr_grid.grid_row[ll_total_row].column[1].font_settings = lstr_aggregate_font_settings
	lstr_grid.grid_row[ll_total_row].column[1].use_font_settings = true
end if
if pb_include_column_average then
	lstr_grid.row_count += 1
	ll_average_row = lstr_grid.row_count
	lstr_grid.grid_row[ll_average_row].column[1].column_text = "Average"
	lstr_grid.grid_row[ll_average_row].column[1].font_settings = lstr_aggregate_font_settings
	lstr_grid.grid_row[ll_average_row].column[1].use_font_settings = true
end if
if pb_include_row_average or pb_include_row_total then
	for i = 2 to lstr_grid.column_count
		ld_total = 0
		ll_value_count = 0
		for j = 1 to ll_datarows
			if isnumber(lstr_grid.grid_row[j].column[i].column_text) then
				ll_value_count += 1
				ld_total += dec(lstr_grid.grid_row[j].column[i].column_text)
			end if
		next
		if pb_include_column_average then
			lstr_grid.grid_row[ll_average_row].column[i].column_text = string(ld_total / ll_value_count, ps_data_display_format)
		end if
		if pb_include_column_total then
			lstr_grid.grid_row[ll_total_row].column[i].column_text = string(ld_total, ps_data_display_format)
		end if
	next
end if		


// If there are any rows in the grid here, then display it
if lstr_grid.row_count > 0 then
	add_grid(lstr_grid)
end if


DESTROY u_ds_data

return 1

end function

public function integer add_property (str_property_value pstr_property, boolean pb_include_formatting, long pl_menu_id, string ps_context_object, long pl_object_key);string ls_temp
long ll_fontbold
long ll_forecolor
long ll_textbkcolor
str_service_info lstr_service
string ls_fielddata
str_font_settings lstr_text_font_settings
str_font_settings lstr_menu_font_settings

ls_temp = trim(pstr_property.display_value)
if isnull(ls_temp) or ls_temp = "" then return 0

// Set the font settings from the data specified by the property
lstr_text_font_settings = get_empty_font_settings()
lstr_menu_font_settings = default_menu_font_settings
if pb_include_formatting then
	if not isnull(pstr_property.weight) then
		if pstr_property.weight > 500 then
			lstr_text_font_settings.bold = true
			lstr_menu_font_settings.bold = true
		else
			lstr_text_font_settings.bold = false
			lstr_menu_font_settings.bold = false
		end if
	end if
	if not isnull(pstr_property.textcolor) then
		lstr_text_font_settings.forecolor = pstr_property.textcolor
		lstr_menu_font_settings.forecolor = pstr_property.textcolor
	end if
	if not isnull(pstr_property.backcolor) then
		lstr_text_font_settings.textbackcolor = pstr_property.backcolor
		lstr_menu_font_settings.textbackcolor = pstr_property.backcolor
	end if
else
end if

//default_menu_font_settings

if char(ls_temp) = "{" and pos(ls_temp, "\rtf") > 0 then
	// If the display_value is already RTF, then ignore the formatting fields
	add_rtf(pstr_property.display_value)
else
	if pl_menu_id > 0 then
		// Prepare the field data string
		lstr_service.service = "Menu"
		f_attribute_add_attribute(lstr_service.attributes, "menu_id", string(pl_menu_id))

		// Set the latest context
		if last_encounter.encounter_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "encounter_id", string(last_encounter.encounter_id))
		end if

		if last_assessment.problem_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "problem_id", string(last_assessment.problem_id))
		end if

		if last_treatment.treatment_id > 0 then
			f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(last_treatment.treatment_id))
		end if

		// Overwrite with the current context if there is one
		CHOOSE CASE lower(ps_context_object)
			CASE "encounter"
				f_attribute_add_attribute(lstr_service.attributes, "encounter_id", string(pl_object_key))
			CASE "assessment"
				f_attribute_add_attribute(lstr_service.attributes, "problem_id", string(pl_object_key))
			CASE "treatment"
				f_attribute_add_attribute(lstr_service.attributes, "treatment_id", string(pl_object_key))
		END CHOOSE

		ls_fielddata = f_service_to_field_data(lstr_service)
		add_field(pstr_property.display_value, ls_fielddata, lstr_menu_font_settings)
	else
		add_text(pstr_property.display_value, lstr_text_font_settings)
	end if
end if

return 1

end function

public function integer display_datawindowobject (string ps_dwsyntax, string ps_sql);string ls_temp
u_ds_data luo_data
integer li_sts
str_grid lstr_grid
string ls_sql
string ls_error
long ll_count
string ls_tempfile

ls_sql = "DROP PROCEDURE #tmprptproc_query_grid"
EXECUTE IMMEDIATE :ls_sql;

ls_sql = "CREATE PROCEDURE #tmprptproc_query_grid AS " + ps_sql
EXECUTE IMMEDIATE :ls_sql;
if not tf_check() then
	log_error("Error executing SQL")
	return -1
end if

luo_data = CREATE u_ds_data
li_sts = luo_data.create(ps_dwsyntax , ls_error)
if li_sts <= 0 then
	log.log(this, "u_rich_text_edit.display_datawindowobject:0023", "Error creating datawindow object -- " + ls_error, 4)
	log_error("Error creating datawindow object -- " + ls_error)
	return -1
end if

li_sts = luo_data.setsqlselect("EXECUTE #tmprptproc_query_grid")
if li_sts < 0 then
	log.log(this, "u_rich_text_edit.display_datawindowobject:0030", "Error setting sql select", 4)
	log_error("Error setting sql select")
	return -1
end if

ll_count = luo_data.retrieve()
if li_sts < 0 then
	log.log(this, "u_rich_text_edit.display_datawindowobject:0037", "Error executing datawindow", 4)
	log_error("Error executing datawindow")
	return -1
end if

ls_tempfile = f_temp_file("htm")
li_sts = luo_data.saveas(ls_tempfile, HTMLTable!, true)

TRY
//	object.load(ls_tempfile, 0, 4, true)
CATCH (throwable lt_error)
	log.log(this, "u_rich_text_edit.display_datawindowobject:0048", "Error loading html into rtf control -- " + lt_error.text , 4)
	log_error("Error loading html into rtf control -- " + lt_error.text)
	return -1
END TRY

DESTROY luo_data


return 1

end function

public function integer display_messages (string ps_cpr_id, string ps_context_object, long pl_object_key);u_ds_data luo_data
long ll_count
integer li_sts
string ls_null

setnull(ls_null)

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_context_object_messages")
ll_count = luo_data.retrieve(current_patient.cpr_id, ps_context_object, pl_object_key)

li_sts = display_services(luo_data, ls_null, "All", "Message")
if li_sts < 0 then
	log_error("Error displaying services")
end if

DESTROY luo_data

return li_sts

end function

public function integer display_progress (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, string ps_progress_display_style, boolean pb_current_only, long pl_display_script_id);str_progress_list lstr_progress
integer li_sts
string ls_display_style
long i
string ls_fieldtext
string ls_fielddata
str_service_info lstr_service
string ls_temp
long ll_current_encounter_id
boolean lb_found
string ls_user_id
str_grid lstr_grid
integer ll_row
string ls_value

ll_current_encounter_id = last_encounter.encounter_id

lstr_progress = f_get_progress(current_patient.cpr_id, ps_context_object, pl_object_key, ps_progress_type, ps_progress_key)
if lstr_progress.progress_count <= 0 then return 0

f_sort_progress(lstr_progress)

ll_row = 0
lb_found = false
lstr_grid.table_attributes.suppress_headings = true
lstr_grid.table_attributes.suppress_title_column = true
lstr_grid.table_attributes.suppress_lines = true

// Determine which display_style to use
if isnull(ps_progress_display_style) then
	// If s display style wasn't passed in then use the style from the first progress note
	ls_display_style = lstr_progress.progress[1].progress_type_properties.display_style
else
	ls_display_style = ps_progress_display_style
end if
	
CHOOSE CASE lower(ls_display_style)
	CASE "dates"
		lstr_grid.column_count = 5
	CASE "reviewed by"
		lstr_grid.column_count = 3
	CASE "times"
		lstr_grid.column_count = 3
	CASE ELSE
		lstr_grid.column_count = 2
END CHOOSE


for i = 1 to lstr_progress.progress_count
	// Skip if we're getting all progress types and the display_flag is not 'Y'
	if isnull(ps_progress_type) and upper(lstr_progress.progress[i].progress_type_properties.display_flag) <> "Y" then
		continue
	end if
	
	// Skip progress not if it's not for the current encounter and the current_only flag is set
	if pb_current_only and not isnull(ll_current_encounter_id) then
		if lstr_progress.progress[i].encounter_id <> ll_current_encounter_id then continue
	end if
	
	lb_found = true
	
	ll_row += 1
	lstr_grid.row_count = ll_row

	if pl_display_script_id > 0 then
		current_progress.context_object = ps_context_object
		current_progress.object_key = pl_object_key
		current_progress.progress = lstr_progress.progress[i]
		
		display_script(pl_display_script_id, last_encounter, last_assessment, last_treatment)
	else
		CHOOSE CASE lower(ls_display_style)
			CASE "value"
				ls_value = lstr_progress.progress[i].progress_note_description
			CASE "dates"
				// Add the date stamp
				lstr_grid.grid_row[ll_row].column[1].column_text = string(date(lstr_progress.progress[i].progress_date_time))
				
				// Add the users name
				lstr_grid.grid_row[ll_row].column[2].column_text = user_list.user_short_name(lstr_progress.progress[i].user_id)
				
				// Add the key
				lstr_grid.grid_row[ll_row].column[3].column_text = wordcap(lstr_progress.progress[i].progress_type)
				
				// Add the key
				lstr_grid.grid_row[ll_row].column[4].column_text = lstr_progress.progress[i].progress_key_description
				
				// Add the description
				ls_fieldtext = ""
				ls_fielddata = ""
				if not isnull(lstr_progress.progress[i].progress_note_description) then
					ls_fieldtext = lstr_progress.progress[i].progress_note_description
				end if
				if not isnull(lstr_progress.progress[i].attachment_id) then
					ls_temp = current_patient.attachments.attachment_extension_description(lstr_progress.progress[i].attachment_id)
					if isnull(ls_temp) or trim(ls_temp) = "" then ls_temp = "Attachment"
					ls_fieldtext += " <" + ls_temp + ">"
					
					lstr_service.service = "ATTACHMENT"
					f_attribute_add_attribute(lstr_service.attributes, "attachment_id", string(lstr_progress.progress[i].attachment_id))
					f_attribute_add_attribute(lstr_service.attributes, "action", "display")
					ls_fielddata = f_service_to_field_data(lstr_service)
				end if
				lstr_grid.grid_row[ll_row].column[5].column_text = ls_fieldtext
				lstr_grid.grid_row[ll_row].column[5].field_data = ls_fielddata
			CASE "reviewed by"
				// Add the time stamp
				lstr_grid.grid_row[ll_row].column[1].column_text = string(lstr_progress.progress[i].progress_date_time, "hh:mm")
				
				// Add the user
				ls_temp = wordcap(lstr_progress.progress[i].progress_type) + " By "
				ls_temp += user_list.user_full_name(lstr_progress.progress[i].user_id)
				lstr_grid.grid_row[ll_row].column[2].column_text = ls_temp
				
				// Add the description
				ls_fieldtext = ""
				ls_fielddata = ""
				if not isnull(lstr_progress.progress[i].progress_note_description) then
					ls_fieldtext = lstr_progress.progress[i].progress_note_description
				end if
				if not isnull(lstr_progress.progress[i].attachment_id) then
					ls_temp = current_patient.attachments.attachment_extension_description(lstr_progress.progress[i].attachment_id)
					if isnull(ls_temp) or trim(ls_temp) = "" then ls_temp = "Attachment"
					ls_fieldtext += " <" + ls_temp + ">"
					
					lstr_service.service = "ATTACHMENT"
					f_attribute_add_attribute(lstr_service.attributes, "attachment_id", string(lstr_progress.progress[i].attachment_id))
					f_attribute_add_attribute(lstr_service.attributes, "action", "display")
					ls_fielddata = f_service_to_field_data(lstr_service)
				end if
				lstr_grid.grid_row[ll_row].column[3].column_text = ls_fieldtext
				lstr_grid.grid_row[ll_row].column[3].field_data = ls_fielddata
			CASE "times"
				// Add the time stamp
				lstr_grid.grid_row[ll_row].column[1].column_text = string(lstr_progress.progress[i].progress_date_time, "hh:mm")
	
				// Add the key
				lstr_grid.grid_row[ll_row].column[2].column_text = lstr_progress.progress[i].progress_key_description
				
				// Add the description
				ls_fieldtext = ""
				ls_fielddata = ""
				if not isnull(lstr_progress.progress[i].progress_note_description) then
					ls_fieldtext = lstr_progress.progress[i].progress_note_description
				end if
				if not isnull(lstr_progress.progress[i].attachment_id) then
					ls_temp = current_patient.attachments.attachment_extension_description(lstr_progress.progress[i].attachment_id)
					if isnull(ls_temp) or trim(ls_temp) = "" then ls_temp = "Attachment"
					ls_fieldtext += " <" + ls_temp + ">"
					
					lstr_service.service = "ATTACHMENT"
					f_attribute_add_attribute(lstr_service.attributes, "attachment_id", string(lstr_progress.progress[i].attachment_id))
					f_attribute_add_attribute(lstr_service.attributes, "action", "display")
					ls_fielddata = f_service_to_field_data(lstr_service)
				end if
				lstr_grid.grid_row[ll_row].column[3].column_text = ls_fieldtext
				lstr_grid.grid_row[ll_row].column[3].field_data = ls_fielddata
			CASE ELSE
				// Standard Display Style
				
				// Add the title
				lstr_grid.grid_row[ll_row].column[1].column_text = lstr_progress.progress[i].progress_key_description
				
				// Add the description
				ls_fieldtext = ""
				ls_fielddata = ""
				if not isnull(lstr_progress.progress[i].progress_note_description) then
					ls_fieldtext = lstr_progress.progress[i].progress_note_description
				end if
				if not isnull(lstr_progress.progress[i].attachment_id) then
					ls_temp = current_patient.attachments.attachment_extension_description(lstr_progress.progress[i].attachment_id)
					if isnull(ls_temp) or trim(ls_temp) = "" then ls_temp = "Attachment"
					ls_fieldtext += " <" + ls_temp + ">"
					
					lstr_service.service = "ATTACHMENT"
					f_attribute_add_attribute(lstr_service.attributes, "attachment_id", string(lstr_progress.progress[i].attachment_id))
					f_attribute_add_attribute(lstr_service.attributes, "action", "display")
					ls_fielddata = f_service_to_field_data(lstr_service)
				end if
				lstr_grid.grid_row[ll_row].column[2].column_text = ls_fieldtext
				lstr_grid.grid_row[ll_row].column[2].field_data = ls_fielddata
		END CHOOSE
	end if
next

if lb_found then
	if lower(ls_display_style) = "value" then
		add_text(ls_value)
	else
		add_grid(lstr_grid)
	end if
	return 1
else
	return 0
end if




end function

public function integer display_patient_alerts (string ps_which, string ps_status);u_ds_data luo_data
long ll_count
long i
integer li_alert_count
string ls_alert
string ls_alert_category
string ls_alert_status
string ls_which_alert_category
string ls_which_alert_status

if lower(ps_status) = "active" then
	ls_which_alert_status = "Open"
elseif lower(ps_status) = "closed" then
	ls_which_alert_status = "Closed"
else
	ls_which_alert_status = "%"
end if

if isnull(ps_which) then
	ls_which_alert_category = "all"
elseif lower(ps_which) = "alerts" then
	ls_which_alert_category = "alert"
elseif lower(ps_which) = "reminders" then
	ls_which_alert_category = "reminder"
else
	ls_which_alert_category = "all"
end if

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_p_chart_alert")
ll_count = luo_data.retrieve(current_patient.cpr_id, "%", ls_which_alert_status)

li_alert_count = 0

for i = 1 to ll_count
	ls_alert_category = luo_data.object.alert_category_id[i]
	ls_alert = luo_data.object.alert_text[i]
	ls_alert_status = luo_data.object.alert_status[i]
	
	// Ignoew blank alerts
	if isnull(ls_alert) or trim(ls_alert) = "" then continue
	
	// See if we should display this kind of alert
	if ls_which_alert_category <> "all" and ls_which_alert_category <> lower(ls_alert_category) then continue
	
	li_alert_count += 1
	
	if li_alert_count > 1 then
		add_cr()
	end if
	
	add_text(ls_alert)
next


return li_alert_count


end function

public function integer display_document (str_c_display_script_command pstr_command, long pl_object_key);long ll_width_pixels
long ll_height_pixels
string ls_document_file
string ls_rtf
string ls_temp
string ls_report_id
str_external_observation_attachment lstr_document
integer li_sts
string ls_document_component_id
string ls_text
string ls_crlf
long ll_pos
long ll_menu_id
integer li_object_id
string ls_rendered_file_type
blob lbl_rendered_file
long ll_desired_width_pixels
long ll_desired_height_pixels

//////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Get the display attributes
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
long ll_bitmap_width_inches
long ll_bitmap_height_inches
string ls_placement
string ls_caption
boolean lb_text_flow_around
boolean lb_carriage_return
long ll_xpos
long ll_ypos
ll_bitmap_width_inches = long(f_attribute_find_attribute(pstr_command.attributes, "width"))
ll_bitmap_height_inches = long(f_attribute_find_attribute(pstr_command.attributes, "height"))
ls_placement = f_attribute_find_attribute(pstr_command.attributes, "placement")
ls_temp = f_attribute_find_attribute(pstr_command.attributes, "text_flow_around")
if isnull(ls_temp) then ls_temp = "True"
lb_text_flow_around = f_string_to_boolean(ls_temp)
ll_xpos = long(f_attribute_find_attribute(pstr_command.attributes, "xposition"))
ll_ypos = long(f_attribute_find_attribute(pstr_command.attributes, "yposition"))
// The caption should use the original attributes and re-interpret any embedded tokens.  This is to make sure
// that any attachment tokens get resolved correctly now that we have an attachment context
ls_caption = f_attribute_find_attribute(pstr_command.original_attributes, "caption")
lb_carriage_return = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "carriage_return"))


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Get the document
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ls_report_id = f_attribute_find_attribute(pstr_command.attributes, "report_id")
if isnull(ls_report_id) then
	ls_document_component_id = f_attribute_find_attribute(pstr_command.attributes, "document_component_id")
	if isnull(ls_document_component_id) then
		log.log(this, "u_rich_text_edit.display_document:0056", "document command must have a report_id or document_component_id attribute", 4)
		return -1
	else
		li_sts = f_create_document(ls_document_component_id, &
											pstr_command.attributes, &
											lstr_document)
	end if
else
	li_sts = f_run_report( ls_report_id, &
								last_context, &
								pstr_command.attributes, &
								"Human", &
								false, &
								lstr_document )
end if
if li_sts < 0 then
	log_error("Error getting document")
	return li_sts
end if

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Add the document to the rtf control
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
li_sts = add_document(lstr_document.attachment, lstr_document.extension, pstr_command.attributes)
if li_sts < 0 then return li_sts


// Interpret and display the caption
ls_caption = f_attribute_value_substitute_string(ls_caption, last_context, report_attributes)
if len(ls_caption) > 0 then
	add_text(ls_caption)
end if

if lb_carriage_return then
	add_cr()
end if

return li_sts


end function

public subroutine add_object_menu (integer pi_object_id, long pl_menu_id);

if pl_menu_id > 0 and pi_object_id > 0 then
	object_menu_count++
	object_menu[object_menu_count].object_id = pi_object_id
	object_menu[object_menu_count].menu_id = pl_menu_id
	object_menu[object_menu_count].attributes = f_context_to_attributes(last_context)
end if

	
end subroutine

public function integer display_attachment (string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key, long pl_bitmap_width_inches, long pl_bitmap_height_inches, string ps_placement, boolean pb_text_flow_around, long pl_xpos, long pl_ypos, boolean pb_page_break, string ps_which, boolean pb_sort_descending, string ps_caption, boolean pb_carriage_return, long pl_menu_id);str_progress_list lstr_progress
integer li_sts
long i
long ll_idx
long ll_attachment_count
long ll_width_pixels
long ll_height_pixels
u_component_attachment luo_attachment
string ls_attachment_file
boolean lb_found
blob lbl_attachment
string ls_rtf
long ll_step
boolean lb_reverse
string ls_this_attribute_caption
str_complete_context lstr_my_context
integer li_object_id
string ls_rendered_file_type
blob lbl_rendered_file
long ll_desired_width_pixels
long ll_desired_height_pixels
string ls_text
string ls_crlf
long ll_pos
str_attributes lstr_attributes

f_attribute_add_attribute(lstr_attributes, "width", string(pl_bitmap_width_inches))
f_attribute_add_attribute(lstr_attributes, "height", string(pl_bitmap_height_inches))
f_attribute_add_attribute(lstr_attributes, "placement", ps_placement)
f_attribute_add_attribute(lstr_attributes, "text_flow_around", f_boolean_to_string(pb_text_flow_around))
f_attribute_add_attribute(lstr_attributes, "xposition", string(pl_xpos))
f_attribute_add_attribute(lstr_attributes, "yposition", string(pl_ypos))

// Get the progress records
lstr_progress = f_get_progress_list(current_patient.cpr_id, ps_context_object, pl_object_key, ps_progress_type, ps_progress_key, "Y")

// Make sure there's at least one
if lstr_progress.progress_count <= 0 then return 0

lb_found = false
CHOOSE CASE upper(ps_which)
	CASE "LAST"
		// Search the progress records in reverse order if we want the last attachment
		lb_reverse = true
	CASE ELSE
		lb_reverse = pb_sort_descending
END CHOOSE

for ll_idx = 1 to lstr_progress.progress_count
	if lb_reverse then
		i = lstr_progress.progress_count - ll_idx + 1
	else
		i = ll_idx
	end if
	// Make sure it's an attachment
	if isnull(lstr_progress.progress[i].attachment_id) then continue
	
	// Get the attachment object
	li_sts = current_patient.attachments.attachment(luo_attachment, lstr_progress.progress[i].attachment_id)
	if li_sts > 0 then
		li_sts = luo_attachment.get_attachment_blob(lbl_attachment)
		if li_sts > 0 then
			li_sts = add_document(lbl_attachment, luo_attachment.extension, lstr_attributes)
			if li_sts > 0 then lb_found = true
		end if
		
		component_manager.destroy_component(luo_attachment)
		
		// Interpret and display the caption
		lstr_my_context = last_context
		lstr_my_context.attachment_id = lstr_progress.progress[i].attachment_id
		ls_this_attribute_caption = f_attribute_value_substitute_string(ps_caption, lstr_my_context, report_attributes)
		if len(ls_this_attribute_caption) > 0 then
			add_text(ls_this_attribute_caption)
		end if
		
		if pb_carriage_return then
			add_cr()
		end if
		
		// If we found an attachment and we're only looking for the first or last attachment, then we're done
		if lb_found and (upper(ps_which) = "FIRST" or upper(ps_which) = "LAST") then exit
	else
		log_error("Error getting attachment (" + string(lstr_progress.progress[i].attachment_id) + ")")
	end if
next

return li_sts


end function

public function integer add_property_attachment (str_property_value ps_property_value, long pl_bitmap_width_inches, long pl_bitmap_height_inches, string ps_placement, boolean pb_text_flow_around, long pl_xpos, long pl_ypos, string ps_caption, boolean pb_carriage_return, long pl_menu_id);integer li_sts
long i
long ll_idx
long ll_attachment_count
long ll_width_pixels
long ll_height_pixels
string ls_attachment_file
blob lbl_property_data
string ls_rtf
long ll_step
string ls_this_attribute_caption
str_complete_context lstr_my_context
integer li_object_id
string ls_rendered_file_type
blob lbl_rendered_file
string ls_text
string ls_crlf
long ll_pos
str_attributes lstr_attributes

f_attribute_add_attribute(lstr_attributes, "width", string(pl_bitmap_width_inches))
f_attribute_add_attribute(lstr_attributes, "height", string(pl_bitmap_height_inches))
f_attribute_add_attribute(lstr_attributes, "placement", ps_placement)
f_attribute_add_attribute(lstr_attributes, "text_flow_around", f_boolean_to_string(pb_text_flow_around))
f_attribute_add_attribute(lstr_attributes, "xposition", string(pl_xpos))
f_attribute_add_attribute(lstr_attributes, "yposition", string(pl_ypos))

// If it's not a blob then don't do anything
if isnull(ps_property_value.encoding) or ps_property_value.encoding = "" then return 0

// Get the property in blob form
CHOOSE CASE lower(ps_property_value.encoding)
	CASE "hex"
		lbl_property_data = common_thread.eprolibnet4.converthextobinary(ps_property_value.value)
	CASE ELSE
		// Assume hex
		lbl_property_data = common_thread.eprolibnet4.converthextobinary(ps_property_value.value)
END CHOOSE

li_sts = add_document(lbl_property_data, ps_property_value.filetype, lstr_attributes)
if li_sts < 0 then return li_sts

// Interpret and display the caption
lstr_my_context = last_context
ls_this_attribute_caption = f_attribute_value_substitute_string(ps_caption, lstr_my_context, report_attributes)
if len(ls_this_attribute_caption) > 0 then
	add_text(ls_this_attribute_caption)
end if

if pb_carriage_return then
	add_cr()
end if

return li_sts

end function

private subroutine display_treatment_treatments (str_treatment_description pstr_treatment, string ps_treatment_type, long pl_display_script_id, string ps_sort_column, string ps_sort_direction, boolean pb_include_deleted);///////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: show the assessments & treatments
//
//
// Created By:Sumathi Chinnasamy										Creation dt: 1/11/2002
//
// Modified By:															Modified On:
///////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_treatment_description
integer 	j, k
integer 	li_treatment_count,li_child_treatment_count
string ls_in_office_flag
string ls_null
str_treatment_description		lstra_treatments[]
string ls_find

setnull(ls_null)

ls_find = "parent_treatment_id = " + string(pstr_treatment.treatment_id)

if len(ps_treatment_type) > 0 then
	ls_find += " and treatment_type = '" + ps_treatment_type + "'"
end if

if not pb_include_deleted then
	ls_find += " and (isnull(treatment_status) OR lower(treatment_status) <> 'cancelled')"
end if

li_treatment_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)

f_sort_treatments(li_treatment_count, lstra_treatments, ps_sort_column, ps_sort_direction)

For j = 1 to li_treatment_count
	display_treatment(lstra_treatments[j].treatment_id, pl_display_script_id)
Next


end subroutine

public subroutine log_error (string ps_error_text);
command_error = true
command_error_text = ps_error_text


end subroutine

public subroutine set_breakpoint (str_c_display_script_command pstr_breakpoint);breakpoint = pstr_breakpoint
breakpoint_set = true

end subroutine

public subroutine clear_breakpoint ();breakpoint_set = false

end subroutine

private function string display_script_a (long pl_display_script_id, str_encounter_description pstr_encounter, str_assessment_description pstr_assessment, str_treatment_description pstr_treatment, boolean pb_is_reentry);integer li_sts
long i
str_display_script lstr_display_script
//str_tx_fontstate lstr_fontstate
str_font_settings lstr_font_settings
string ls_df
boolean lb_nested
string ls_rtf
ulong ll_hCursor
long ll_temp_indentl
long ll_first_command_index

is_on_break = false

if pb_is_reentry then
	lstr_display_script = reentry_state.display_script
	ll_first_command_index = reentry_state.last_index + 1
	lstr_font_settings = reentry_state.font_settings
	lb_nested = false
else
	ll_first_command_index = 1
	
	// Don't do anything if we don't have a display_script_id
	if isnull(pl_display_script_id) then
		return ls_rtf
	end if
	
	// set the reader_user_id to the current user if it's not already set to a valid value
	if not user_list.is_user(reader_user_id) and not user_list.is_role(reader_user_id) then
		reader_user_id = current_user.user_id
	end if
	
	// Save the font state so we can reset it later
	//lstr_fontstate = current_fontstate
	lstr_font_settings = get_font_settings()
	reset_fontstate()
	
	lb_nested = nested
	nested = true
	
	// Make sure the non-patient context is set
	last_context.customer_id = sqlca.customer_id
	last_context.office_id = gnv_app.office_id
	last_context.user_id = current_user.user_id
	last_context.scribe_user_id = current_scribe.user_id
	
	
	if not isnull(current_patient) then
		last_context.cpr_id = current_patient.cpr_id
	end if
	
	if isnull(pstr_encounter.encounter_id) then
		// If no encounter context was passed in and there is no last_encounter, then set the last_encounter to the current service encounter context, if there is one.
		if isnull(last_encounter.encounter_id) and not isnull(current_service) then
			if current_service.encounter_id > 0 then
				li_sts = current_patient.encounters.encounter(last_encounter, current_service.encounter_id)
			end if
		end if
	else
		last_encounter = pstr_encounter
		last_context.encounter_id = last_encounter.encounter_id
	end if
	if not isnull(pstr_assessment.problem_id) then
		last_assessment = pstr_assessment
		last_context.problem_id = last_assessment.problem_id
	end if
	if not isnull(pstr_treatment.treatment_id) then
		last_treatment = pstr_treatment
		last_context.treatment_id = last_treatment.treatment_id
	end if
	
	// Get the display script commands
	li_sts = datalist.display_script(pl_display_script_id,lstr_display_script)
	if li_sts <= 0 then
		log_error("Error getting display script (" + string(pl_display_script_id) + ")")
		return ls_rtf
	end if
	
	if not lb_nested then
		//if auto_redraw_off then set_redraw(false)
		// initialize some state
		signature_object_id = 0
		command_count = 0
		parent_command_index = 0
	
		// First see if we should initialize the encounter structure
		if not isnull(current_patient) then
			if isnull(pstr_encounter.encounter_id) then
				if not isnull(current_display_encounter) then
					current_patient.encounters.encounter(pstr_encounter, current_display_encounter.encounter_id)
				elseif not isnull(current_service) then
					if not isnull(current_service.encounter_id) then
						current_patient.encounters.encounter(pstr_encounter, current_service.encounter_id)
					end if
				end if
			end if
		end if
		// Save the state
		first_display_script_id = lstr_display_script.display_script_id
		first_encounter = last_encounter
		first_assessment = pstr_assessment
		first_treatment = pstr_treatment
	end if
	
	if rtf_debug_mode then
		ls_df = "<" + string(lstr_display_script.display_script_id) + " "
		if isnull(current_patient) then
			ls_df += "null"
		else
			ls_df += current_patient.cpr_id
		end if
		ls_df += "/"
		if isnull(pstr_encounter.encounter_id) then
			ls_df += "null"
		else
			ls_df += string(pstr_encounter.encounter_id)
		end if
		ls_df += "/"
		if isnull(pstr_assessment.problem_id) then
			ls_df += "null"
		else
			ls_df += string(pstr_assessment.problem_id)
		end if
		ls_df += "/"
		if isnull(pstr_treatment.treatment_id) then
			ls_df += "null"
		else
			ls_df += string(pstr_treatment.treatment_id)
		end if
		ls_df += ">"
		
		add_text(ls_df)
	end if
	SetPointer(HourGlass!)
	
	if not lb_nested then
		f_progress_initialize(1, lstr_display_script.display_command_count)
	end if
end if  // End not-reentry section

// If we're in debug mode and the editor window isn't open yet, then open the editor window instead of running the script
if (gnv_app.cpr_mode = "CLIENT") and debug_mode and (not isvalid(editor_window) or isnull(editor_window)) then
	open_editor()
	return ls_rtf
end if

for i = ll_first_command_index to lstr_display_script.display_command_count
	display_script_command(lstr_display_script.display_command[i], pstr_encounter, pstr_assessment, pstr_treatment)
	if not lb_nested then
		if breakpoint_set and (lstr_display_script.display_command[i].display_script_id = breakpoint.display_script_id AND lstr_display_script.display_command[i].display_command_id = breakpoint.display_command_id) then
			// Breakpoint found
			reentry_state.display_script = lstr_display_script
			reentry_state.last_index = i
			reentry_state.encounter = pstr_encounter
			reentry_state.assessment = pstr_assessment
			reentry_state.treatment = pstr_treatment
			reentry_state.font_settings = lstr_font_settings
			is_on_break = true
			
			SetPointer(Arrow!)
			//if auto_redraw_off then set_redraw(true)
			this.setredraw(true)
			return ls_rtf
		end if

		yield()
		f_progress_set(i)
	end if
next

if not lb_nested then
	f_progress_close()

	if process_header_footer then
		// Add the header
		if print_header and header_display_script_id > 0 then
			set_header()
			display_script(header_display_script_id, pstr_encounter, pstr_assessment, pstr_treatment)
			
			// Then restore the control back to the default state
			set_detail()
		end if
		
		// Add the footer
		if print_footer and page_mode() then
			set_footer()
			if footer_display_script_id > 0 then
				display_script(footer_display_script_id, pstr_encounter, pstr_assessment, pstr_treatment)
			else
				apply_formatting("fontsize=8,tabs=3000/5000/7000,margins=0/0/0")
				if not isnull(current_patient) then
					if not isnull(current_patient.billing_id) then
						add_text(current_patient.billing_id + "  ")
					end if
					add_text(current_patient.name())
				end if
				add_tab()
				add_text("Printed On ")
				add_date_time()
				add_tab()
				add_page_number("Page: ")
	//			add_text(" ")
	//			add_text(" ")
	//			add_cr()
	//			add_text("Display Script #" + string(pl_display_script_id))
			end if
			
			// Then restore the control back to the default state
			set_detail()
		end if
	end if

	SetPointer(Arrow!)
end if

// Now reset the fontstate so any changes made within the executed display format
// don't affect any display_script calling this one
//ll_temp_indentl = object.indentl
set_font_settings(lstr_font_settings)
//current_fontstate = lstr_fontstate
reset_fontstate()
//ll_temp_indentl = object.indentl

nested = lb_nested

return ls_rtf

end function

public subroutine display_script_reentry ();if not is_on_break then return

display_script_a(reentry_state.display_script.display_script_id, reentry_state.encounter, reentry_state.assessment, reentry_state.treatment, true)


return


end subroutine

public function long select_next_command (long pl_last_command_index, str_c_display_script_command pstr_command);long i

if isnull(pl_last_command_index) or pl_last_command_index <= 0 then
	pl_last_command_index = 1
end if

for i = pl_last_command_index to command_count
	if pstr_command.display_script_id = command[i].command.display_script_id and pstr_command.display_command_id = command[i].command.display_command_id then
		select_text(command[i].footprint)
		return i
	end if
next

// If we get here then clear any selected text
select_text(charposition())

return 0

end function

public function boolean breakpoint (ref str_c_display_script_command pstr_command);if is_on_break then
	pstr_command = breakpoint
	return true
end if

return false

end function

public subroutine open_editor (str_c_display_script_command_stack pstr_stack);str_popup popup
string ls_parent_config_object_id

if isvalid(editor_window) and not isnull(editor_window) then
	editor_window.show()
	return
end if

if isnull(current_service) then
	setnull(ls_parent_config_object_id)
else
	ls_parent_config_object_id = current_service.get_attribute("report_id")
end if

popup.items[1] = string(first_display_script_id)
popup.items[2] = f_boolean_to_string(true)
popup.items[3] = ls_parent_config_object_id
popup.data_row_count = 3
popup.objectparm = pstr_stack
popup.objectparm1 = this

openwithparm(editor_window, popup, "w_display_script_config")

return

end subroutine

public subroutine open_editor ();str_c_display_script_command_stack lstr_stack

open_editor(lstr_stack)

return


end subroutine

public function str_c_display_script_command_stack command_stack_for_charposition (str_charposition pstr_charposition);long i, j
str_c_display_script_command_stack lstr_stack
str_c_display_script_command_stack lstr_stack2

// If we found a clicked character, see if it fall within the footprint of any of the commands that were executed
if pstr_charposition.char_position >= 0 then
	for i = command_count to 1 step -1
		if f_char_position_in_range(pstr_charposition, command[i].footprint) then
			// we found the command, so build a stack of the command and its ancestors
			lstr_stack.command_count = 1
			lstr_stack.command[lstr_stack.command_count] = command[i].command
			lstr_stack.footprint[lstr_stack.command_count] = command[i].footprint
			j = command[i].parent_command_index
			do while j > 0
				lstr_stack.command_count += 1
				lstr_stack.command[lstr_stack.command_count] = command[j].command
				lstr_stack.footprint[lstr_stack.command_count] = command[j].footprint
				j = command[j].parent_command_index
			loop
			exit
		end if
	next
end if

// we built the stack backwards starting with the deepest command, but we want to return the stack with the 1st level command first,
// so reverse the order
lstr_stack2.command_count = lstr_stack.command_count
for i = 1 to lstr_stack.command_count
	lstr_stack2.command[i] = lstr_stack.command[lstr_stack.command_count - i + 1]
	lstr_stack2.footprint[i] = lstr_stack.footprint[lstr_stack.command_count - i + 1]
next

return lstr_stack2


end function

on u_rich_text_edit.create
call super::create
end on

on u_rich_text_edit.destroy
call super::destroy
end on

event constructor;
setnull(last_encounter.encounter_id)
setnull(last_assessment.problem_id)
setnull(last_treatment.treatment_id)

default_menu_font_settings = f_empty_font_settings()
default_menu_font_settings.underline = true
default_menu_font_settings.forecolor = color_dark_blue

error_font_settings = f_interpret_font_settings("bold,fc=red")

initialize()

end event

event field_clicked;call super::field_clicked;str_service_info lstr_service
long ll_scrollpos
long ll_patient_workplan_item_id

ll_scrollpos = get_scroll_position_y()

lstr_service = f_field_data_to_service(ps_field_data)

CHOOSE CASE lower(lstr_service.service)
	CASE "!servicemenu"
		ll_patient_workplan_item_id = long(f_attribute_find_attribute(lstr_service.attributes, "patient_workplan_item_id"))
		if ll_patient_workplan_item_id > 0 then
			f_display_service_menu(ll_patient_workplan_item_id)
		end if
	CASE ELSE
		service_list.do_service( lstr_service)
END CHOOSE

redisplay()

//this.function POST set_scroll_position_y(ll_scrollpos)

end event

event mousedown;call super::mousedown;str_popup popup
w_window_base lw_window
string ls_parent_config_object_id
str_charposition lstr_charposition
//long ll_char
long i
long j
long ll_x_inches
long ll_y_inches
str_c_display_script_command_stack lstr_stack
str_c_display_script_command_stack lstr_stack2

//// only respond to a right button click
//if button <> 2 then return
//
//if not config_mode or isnull(first_display_script_id) or first_display_script_id = 0 then return
//
//// find the character that was clicked
//convert_pixels_to_inches( ocx_x, ocx_y, ll_x_inches, ll_y_inches)
//lstr_charposition = character_at_position(ll_x_inches, ll_y_inches)
//
//// If we found a clicked character, see if it fall within the footprint of any of the commands that were executed
//if lstr_charposition.char_position >= 0 then
//	for i = command_count to 1 step -1
//		if f_char_position_in_range(lstr_charposition, command[i].footprint) then
//			// we found the command, so build a stack of the command and its ancestors
//			lstr_stack.command_count = 1
//			lstr_stack.command[lstr_stack.command_count] = command[i].command
//			j = command[i].parent_command_index
//			do while j > 0
//				lstr_stack.command_count += 1
//				lstr_stack.command[lstr_stack.command_count] = command[j].command
//				j = command[j].parent_command_index
//			loop
//			exit
//		end if
//	next
//end if
//
//// we built the stack from the bottom up but the editor wants it from the top down, so reverse the stack
//lstr_stack2.command_count = lstr_stack.command_count
//for i = 1 to lstr_stack.command_count
//	lstr_stack2.command[i] = lstr_stack.command[lstr_stack.command_count - i + 1]
//next
//
//if isnull(current_service) then
//	setnull(ls_parent_config_object_id)
//else
//	ls_parent_config_object_id = current_service.get_attribute("report_id")
//end if
//
//popup.items[1] = string(first_display_script_id)
//popup.items[2] = f_boolean_to_string(true)
//popup.items[3] = ls_parent_config_object_id
//popup.data_row_count = 3
//popup.objectparm = lstr_stack2
//
//openwithparm(lw_window, popup, "w_display_script_config")
//
//redisplay()
//
////event objectclicked;call super::objectclicked;str_captured_signature lstr_captured_signature
////integer li_sts
////string ls_temp_file
////str_popup popup
////str_popup_return popup_return
////long i
////
////if signature_object_id = objectid then
////	if len(captured_signature.captured_signature_file) > 0 then
////		popup.data_row_count = 2
////		popup.items[1] = "Show Properties"
////		popup.items[2] = "Recapture Signature"
////		openwithparm(w_pop_pick, popup)
////		popup_return = message.powerobjectparm
////		if popup_return.item_count <> 1 then return
////		
////		if popup_return.item_indexes[1] = 1 then
//////			openwithparm(w_signature_property_display, captured_signature)
////			return
////		end if
////	end if
////	
////	
////	// Capture a signature
////	li_sts = f_capture_signature(capture_signature_request, lstr_captured_signature)
////	if li_sts <= 0 then return
////	
////	// Replace the prompt image with the captured signature rendering
////	ls_temp_file = f_temp_file(lstr_captured_signature.signature_render_file_type)
////	li_sts = log.file_write(lstr_captured_signature.signature_render_file, ls_temp_file)
////	if li_sts <= 0 then
////		log.log(this, "u_rich_text_edit:mous", "Error writing rendered signature to file", 4)
////		return
////	end if
////	
////	captured_signature = lstr_captured_signature
////	
////	li_sts = replace_image(signature_object_id, ls_temp_file, capture_signature_request.render_width, capture_signature_request.render_height)
////	if li_sts <= 0 then return
////	
////	// trigger the captured_signature event so the container window
////	// can save the document if necessary
////	this.event POST signature_captured(captured_signature)
////else
////	for i = 1 to object_menu_count
////		if objectid = object_menu[i].object_id then
////			f_display_menu_with_attributes(object_menu[i].menu_id, true, object_menu[i].attributes)
////		end if
////	next
////end if
////
////
////
////end event
//
end event

event rbuttondown;call super::rbuttondown;str_charposition lstr_charposition
long i, j
str_c_display_script_command_stack lstr_stack

if not config_mode or isnull(first_display_script_id) or first_display_script_id = 0 then return

// It's not easy to see where the cursor was when the right mouse button was clicked, so for now let's use the insertion point.  This means that the user
// must first click the left mouse button to set the insertion point at the desired location and then click the right mouse button to bring up the RTF Script Editor with that
// command highlighted
lstr_charposition = charposition()

lstr_stack = command_stack_for_charposition(lstr_charposition)

open_editor(lstr_stack)

redisplay()


end event

