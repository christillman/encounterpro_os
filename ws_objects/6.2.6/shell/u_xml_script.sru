HA$PBExportHeader$u_xml_script.sru
forward
global type u_xml_script from userobject
end type
type str_config_object from structure within u_xml_script
end type
end forward

type str_config_object from structure
	string		config_object
	string		config_object_id
end type

global type u_xml_script from userobject
end type
global u_xml_script u_xml_script

type variables
string reader_user_id

// Record the latest context
str_complete_context last_context

pbdom_document XML_Document
pbdom_element current_element
pbdom_element root_element

pbdom_element actors_element
string actor_user_id[]
long actor_count = 0

str_attributes document_attributes

string xml_date_format
string xml_time_format
string xml_date_time_separator

//str_c_xml_class xml_class

boolean nested = false

private pbdom_element config_element
private pbdom_element last_config_element
private long config_object_count
private str_config_object config_objects[]

string formfield_attribute_name = "FormField"


boolean auto_date_format
end variables

forward prototypes
private function integer create_xml (long pl_display_script_id, pbdom_element po_current_element)
public subroutine substitute_context (ref string ps_string)
private subroutine create_xml_command (str_c_display_script_command pstr_command)
public subroutine add_amount_unit (string ps_tag, real pr_amount, string ps_unit_id)
public subroutine add_object_id (pbdom_element po_parent_element, string ps_jmj_domain, string ps_epro_id, string ps_code_domain, long pl_owner_id)
public subroutine add_note (string ps_tag, string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key)
public subroutine add_actor (pbdom_element po_parent_element, string ps_tag, string ps_user_id, string ps_code_domain, long pl_owner_id)
public subroutine add_actor (pbdom_element po_parent_element, string ps_tag, string ps_user_id)
private function integer create_xml (long pl_display_script_id, pbdom_element po_current_element, string ps_cpr_id, string ps_context_object, long pl_object_key)
private function long create_xml_command_perform (str_c_display_script_command pstr_command, long pl_object_key)
public subroutine add_patient_id (pbdom_element po_parent_element, string ps_jmj_domain, string ps_epro_id)
public subroutine add_druginfo (pbdom_element po_parent_element, string ps_tag, string ps_which)
public function string xml_date_time (string ps_date)
public subroutine add_object_id (pbdom_element po_parent_element, string ps_jmj_domain, string ps_epro_id, string ps_code_domain, string ps_code_value, long pl_owner_id)
public subroutine run_xml_script_from_attributes (str_attributes pstr_attributes, long pl_xml_script_id, pbdom_element po_current_element)
public function pbdom_element add_element (pbdom_element po_current_element, string ps_tag, string ps_value)
public function boolean if_query (string ps_query)
public function long add_config_object (string ps_config_object_type, string ps_attribute, string ps_config_object_id)
public function pbdom_element add_element (pbdom_element po_current_element, string ps_tag, string ps_value, string ps_attribute_name, string ps_attribute_value)
public function string xml_date_time (datetime pdt_datetime)
public function string xml_date (date pd_date)
public function string xml_time (time pt_time)
public subroutine add_unit (pbdom_element po_parent_element, string ps_tag, string ps_unit_id)
public function integer add_observation_result (pbdom_element po_parent_element, string ps_tag, str_p_observation_result pstr_result, string ps_result_unit, boolean pb_formatted, boolean pb_amount_only, boolean pb_display_location, boolean pb_display_unit, string ps_attribute_name, string ps_attribute_value)
public function integer add_observation_result (pbdom_element po_parent_element, string ps_cpr_id, long pl_object_key, string ps_context_object, string ps_tag, string ps_observation_id, integer pi_result_sequence, string ps_result_type, date pd_observation_date, string ps_result_unit, boolean pb_formatted, boolean pb_amount_only, boolean pb_display_location, boolean pb_display_unit, string ps_attribute_name, string ps_attribute_value)
public function boolean if_observation_result (string ps_cpr_id, long pl_object_key, string ps_context_object, string ps_observation_id, integer pi_result_sequence, string ps_result_type, date pd_observation_date, string ps_result_unit, string ps_operation, string ps_from_value, string ps_to_value)
public function integer add_observation (pbdom_element po_parent_element, string ps_cpr_id, long pl_object_key, string ps_context_object, string ps_tag, string ps_observation_id, integer pi_result_sequence, string ps_result_type, date pd_observation_date)
private function integer add_task (pbdom_element po_parent_element, string ps_tag, long pl_patient_workplan_item_id, str_context pstr_context)
private function integer add_datafile (pbdom_element po_parent_element, string ps_tag, str_patient_material pstr_material)
private function integer add_systemsettings (pbdom_element po_parent_element, string ps_tag, long pl_patient_workplan_item_id, str_context pstr_context)
public function integer create_xml_from_attributes (string ps_root_element, str_context pstr_context, str_attributes pstr_attributes, ref string ps_xml)
public function integer create_xml (long pl_patient_workplan_item_id, long pl_xml_script_id, string ps_root_element, str_context pstr_context, str_attributes pstr_attributes, str_patient_materials pstr_materials, ref u_xml_document po_xml)
public function integer create_xml (string ps_xml_class, str_attributes pstr_attributes, ref u_xml_document po_xml)
public function integer create_xml (long pl_xml_script_id, str_attributes pstr_attributes, ref u_xml_document po_xml)
end prototypes

private function integer create_xml (long pl_display_script_id, pbdom_element po_current_element);string ls_context_object
long ll_object_key
string ls_cpr_id

// Don't change the context
setnull(ls_cpr_id)
setnull(ls_context_object)
setnull(ll_object_key)

return create_xml(pl_display_script_id, &
						po_current_element, &
						ls_cpr_id, &
						ls_context_object, &
						ll_object_key)


end function

public subroutine substitute_context (ref string ps_string);str_attributes lstr_attributes

lstr_attributes = document_attributes

f_attribute_add_attributes(lstr_attributes, f_context_to_attributes(last_context))

ps_string = f_string_substitute_attributes(ps_string, lstr_attributes)


end subroutine

private subroutine create_xml_command (str_c_display_script_command pstr_command);integer li_argument
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
		if isnull(last_context.cpr_id) then return
		setnull(ll_command_object_key)
	CASE "general"
		setnull(ll_command_object_key)
	CASE ELSE
END CHOOSE

// Check each of the command attributes for runtime substitution
f_attribute_value_substitute_multiple(pstr_command.attributes, last_context, document_attributes)

create_xml_command_perform(pstr_command, ll_command_object_key)


end subroutine

public subroutine add_amount_unit (string ps_tag, real pr_amount, string ps_unit_id);string ls_value
u_unit luo_unit
PBDOM_Element lo_element
PBDOM_Element lo_element2
PBDOM_Element lo_element3


// Create the child element
lo_element = CREATE PBDOM_Element
lo_element.setname(ps_tag)

current_element.addcontent(lo_element)

luo_unit = unit_list.find_unit(ps_unit_id)
if isnull(luo_unit) then return

// Create the amount element
lo_element2 = CREATE PBDOM_Element
lo_element2.setname("Amount")

ls_value = luo_unit.pretty_amount(pr_amount)
if len(ls_value) > 0 then
	lo_element2.addcontent(ls_value)
end if

lo_element.addcontent(lo_element2)

add_unit(lo_element, "Unit", ps_unit_id)

end subroutine

public subroutine add_object_id (pbdom_element po_parent_element, string ps_jmj_domain, string ps_epro_id, string ps_code_domain, long pl_owner_id);string ls_code_value

setnull(ls_code_value)

add_object_id(po_parent_element, ps_jmj_domain, ps_epro_id, ps_code_domain, ls_code_value, pl_owner_id)


end subroutine

public subroutine add_note (string ps_tag, string ps_context_object, long pl_object_key, string ps_progress_type, string ps_progress_key);string ls_value
PBDOM_Element lo_element
PBDOM_Element lo_element2
PBDOM_Element lo_element3
str_progress_list lstr_progress

if isnull(ps_tag) or isnull(ps_context_object) or isnull(ps_progress_type) or isnull(ps_progress_key) then return

// Create the child element
lo_element = CREATE PBDOM_Element
lo_element.setname(ps_tag)

current_element.addcontent(lo_element)


// Create the type element
lo_element2 = CREATE PBDOM_Element
lo_element2.setname("NoteType")

lo_element2.addcontent(ps_progress_type)

lo_element.addcontent(lo_element2)

// Create the type element
lo_element2 = CREATE PBDOM_Element
lo_element2.setname("NoteKey")

lo_element2.addcontent(ps_progress_key)

lo_element.addcontent(lo_element2)


// Create the note
lstr_progress = f_get_progress(last_context.cpr_id, ps_context_object, pl_object_key, ps_progress_type, ps_progress_key)
if lstr_progress.progress_count > 0 then
	if lstr_progress.progress[lstr_progress.progress_count].attachment_id > 0 then
		// Add the AttachmentType elements here
	else
		ls_value = lstr_progress.progress[lstr_progress.progress_count].progress
		if len(ls_value) > 0 then
			lo_element2 = CREATE PBDOM_Element
			lo_element2.setname("NoteText")
		
			lo_element2.addcontent(ls_value)
		
			lo_element.addcontent(lo_element2)
		end if
		ls_value = xml_date_time(lstr_progress.progress[lstr_progress.progress_count].progress_date_time)
		if len(ls_value) > 0 then
			lo_element2 = CREATE PBDOM_Element
			lo_element2.setname("NoteDate")
		
			lo_element2.addcontent(ls_value)
		
			lo_element.addcontent(lo_element2)
		end if
		ls_value = lstr_progress.progress[lstr_progress.progress_count].user_id
		if len(ls_value) > 0 then
			add_actor(lo_element, "NoteBy", ls_value)
		end if
	end if
end if


end subroutine

public subroutine add_actor (pbdom_element po_parent_element, string ps_tag, string ps_user_id, string ps_code_domain, long pl_owner_id);string ls_value
PBDOM_Element lo_element
PBDOM_Element lo_element2
PBDOM_Element lo_element3
string ls_jmj_domain
long ll_ActorID
boolean lb_found
long i
string ls_null
long ll_null
u_user luo_user
u_ds_data luo_data
long ll_count
long ll_owner_id
string ls_code_domain
string ls_code_value
string ls_temp
string ls_owner_id
boolean lb_address_found
boolean lb_type_found
boolean lb_value_found

setnull(ls_null)
setnull(ll_null)

luo_data = CREATE u_ds_data

if isnull(ps_user_id) or trim(ps_user_id) = "" then return
luo_user = user_list.find_user(ps_user_id)
if isnull(luo_user) then
	log.log(this, "add_actor()", "Invalid user_id (" + ps_user_id + ")", 4)
	return
end if

ls_jmj_domain = "user_id"


// Find the actor if it already exists
lb_found = false
for i = 1 to actor_count
	if lower(ps_user_id) = lower(actor_user_id[i]) then
		ll_ActorID = i
		lb_found = true
	end if
next
if not lb_found then
	actor_count += 1
	actor_user_id[actor_count] = ps_user_id
	ll_ActorID = actor_count

	// Make sure we have a parent
	if not isvalid(actors_element) or isnull(actors_element) then
		// Create the child element
		actors_element = CREATE PBDOM_Element
		actors_element.setname("Actors")
		
		// Add the element to the current element
		root_element.addcontent(actors_element)
//		log.log(this, "add_actor()", "No Actor element defined", 4)
//		return
	end if

	// Create the child element
	lo_element = CREATE PBDOM_Element
	lo_element.setname("Actor")
	lo_element.setattribute( "ActorID", string(ll_ActorID))
	actors_element.addcontent(lo_element)

	// Create the name element
	lo_element2 = CREATE PBDOM_Element
	lo_element2.setname("Name")
	
	lo_element2.addcontent(luo_user.user_full_name)
	
	lo_element.addcontent(lo_element2)
	
	// Create the Object ID block for the user_id.  Leave the code domain empty.
	add_object_id(lo_element, "user_id", ps_user_id, ls_null, ls_null, ll_null)
	
	// Create the Object ID block for the specified alternate domain
	if len(ps_code_domain) > 0 and not isnull(pl_owner_id) then
		add_object_id(lo_element, ls_jmj_domain, ps_user_id, ps_code_domain, pl_owner_id)
	end if
	
	luo_data.set_dataobject( "dw_actor_ids")
	ll_count = luo_data.retrieve(ps_user_id)
	for i = 1 to ll_count
		ls_code_domain = luo_data.object.progress_key[i]
		ls_code_value = luo_data.object.progress_value[i]
		ll_owner_id = luo_data.object.owner_id[i]
		if len(ls_code_domain) > 0 and len(ls_code_value) > 0 and ll_owner_id >= 0 then
			add_object_id(lo_element, "user_id", ps_user_id, ls_code_domain, ls_code_value, ll_owner_id)
		end if
	next
	
	// Create the ActorClass element
	lo_element2 = CREATE PBDOM_Element
	lo_element2.setname("ActorClass")
	
	lo_element2.addcontent(luo_user.actor_class)
	
	lo_element.addcontent(lo_element2)
	
	
	//////////////////////////////////////////////////////////////////////////////////
	// Add the Address blocks
	//////////////////////////////////////////////////////////////////////////////////
	luo_data.set_dataobject( "dw_actor_addresses")
	ll_count = luo_data.retrieve(ps_user_id)
	for i = 1 to ll_count
		lo_element2 = CREATE PBDOM_Element
		lo_element2.setname("Address")
		lb_address_found = false
		
		ls_temp = luo_data.object.description[i]
		if len(ls_temp) > 0 then
			add_element(lo_element2, "Description", ls_temp)
			lb_address_found = true
		end if
		ls_temp = luo_data.object.Address_Line_1[i]
		if len(ls_temp) > 0 then
			add_element(lo_element2, "AddressLine1", ls_temp)
			lb_address_found = true
		end if
		ls_temp = luo_data.object.Address_Line_2[i]
		if len(ls_temp) > 0 then
			add_element(lo_element2, "AddressLine2", ls_temp)
			lb_address_found = true
		end if
		ls_temp = luo_data.object.city[i]
		if len(ls_temp) > 0 then
			add_element(lo_element2, "City", ls_temp)
			lb_address_found = true
		end if
		ls_temp = luo_data.object.state[i]
		if len(ls_temp) > 0 then
			add_element(lo_element2, "State", ls_temp)
			lb_address_found = true
		end if
		ls_temp = luo_data.object.zip[i]
		if len(ls_temp) > 0 then
			add_element(lo_element2, "Zip", ls_temp)
			lb_address_found = true
		end if
		ls_temp = luo_data.object.country[i]
		if len(ls_temp) > 0 then
			add_element(lo_element2, "Country", ls_temp)
			lb_address_found = true
		end if
		// If any elements were added to the address then add the address to the Actor block
		if lb_address_found then
			lo_element.addcontent(lo_element2)
		end if
	next		
	
	//////////////////////////////////////////////////////////////////////////////////
	// Add the Communication blocks
	//////////////////////////////////////////////////////////////////////////////////
	luo_data.set_dataobject( "dw_actor_communications")
	ll_count = luo_data.retrieve(ps_user_id)
	for i = 1 to ll_count
		lo_element2 = CREATE PBDOM_Element
		lo_element2.setname("Communication")
		lb_type_found = false
		lb_value_found = false
		
		ls_temp = luo_data.object.communication_type[i]
		if len(ls_temp) > 0 then
			add_element(lo_element2, "Type", ls_temp)
			lb_type_found = true
		end if
		ls_temp = luo_data.object.communication_name[i]
		if len(ls_temp) > 0 then
			add_element(lo_element2, "Name", ls_temp)
		end if
		
		// Add the relative priority, but don't count it as a found element
		add_element(lo_element2, "Priority", string(i))
		
		ls_temp = luo_data.object.communication_value[i]
		if len(ls_temp) > 0 then
			add_element(lo_element2, "Value", ls_temp)
			lb_value_found = true
		end if
		ls_temp = luo_data.object.note[i]
		if len(ls_temp) > 0 then
			add_element(lo_element2, "Note", ls_temp)
		end if
		// If we have a type AND a value, then add the communication block
		if lb_type_found AND lb_value_found then
			lo_element.addcontent(lo_element2)
		end if
	next		
end if

// Finally, if a tag is specified, add it to the current_element and set its value to the ActorID
if len(ps_tag) > 0 then
	if isnull(po_parent_element) or not isvalid(po_parent_element) then po_parent_element = current_element
	
	lo_element2 = CREATE PBDOM_Element
	lo_element2.setname(ps_tag)
	
	lo_element2.addcontent(string(ll_ActorID))
	
	po_parent_element.addcontent(lo_element2)
end if

DESTROY luo_data

end subroutine

public subroutine add_actor (pbdom_element po_parent_element, string ps_tag, string ps_user_id);string ls_code_domain
long ll_owner_id

setnull(ls_code_domain)
setnull(ll_owner_id)

add_actor(po_parent_element, ps_tag, ps_user_id, ls_code_domain, ll_owner_id)

end subroutine

private function integer create_xml (long pl_display_script_id, pbdom_element po_current_element, string ps_cpr_id, string ps_context_object, long pl_object_key);integer li_sts
long i
str_display_script lstr_display_script
pbdom_element lo_last_current_element
str_complete_context lstr_prev_context
integer li_index
boolean lb_nested

if not nested then
	root_element = po_current_element
end if

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
	log.log(this, "create_xml", "Error getting display_script structure", 4)
	return -1
end if

if not lb_nested and cpr_mode = "CLIENT" then
	li_index = f_please_wait_open()
	f_please_wait_progress_bar(li_index, 0, lstr_display_script.display_command_count)
end if

// Perform the commands
for i = 1 to lstr_display_script.display_command_count
	create_xml_command(lstr_display_script.display_command[i])
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

private function long create_xml_command_perform (str_c_display_script_command pstr_command, long pl_object_key);string ls_null
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
PBDOM_Element lo_preserve_current_element
PBDOM_Element lo_child_element
u_ds_data luo_data
long ll_encounter_id
long ll_problem_id
long ll_treatment_id
str_attributes lstr_attributes
str_property_value lstr_property_value
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
string ls_formfield
string ls_true_value
string ls_false_value
boolean lb_make_current
string ls_current_tag
string ls_root_tag
datetime ldt_datetime
string ls_date_format
string ls_nested_cpr_id
long ll_null
string ls_sqlprocname
string ls_syntax
string ls_error_string
boolean lb_latest_only
string ls_observation_id
string ls_result_type
boolean lb_formatted_flag
integer li_result_sequence
boolean lb_amount_only
boolean lb_display_location
boolean lb_display_unit
boolean lb_preserve_current_element
string ls_result_unit
string ls_context_object
long ll_object_key
datetime ldt_observation_date
string ls_property_date_attribute
date ld_property_date
string ls_left
string ls_right
boolean lb_respect_encounter_context
string ls_disease_group
long ll_disease_id
long ll_treatment_ordinal
long ll_start
long ll_end
string ls_treatment_property
string ls_operation
string ls_from_value
string ls_to_value
date ld_observation_date
string ls_ordinal_attribute_name

setnull(ls_null)
setnull(ll_null)

// Set the state-flag that will instruct the add_element method to automatically detect and convert dates to XML date format
auto_date_format = true

ll_xml_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "xml_script_id"))
ls_tag = f_attribute_find_attribute(pstr_command.attributes, "tag")
ls_value = f_attribute_find_attribute(pstr_command.attributes, "value")
ls_property = f_attribute_find_attribute(pstr_command.attributes, "property")
ls_formfield = f_attribute_find_attribute(pstr_command.attributes, "formfield")

ls_ordinal_attribute_name = f_attribute_find_attribute(pstr_command.attributes, "ordinal_attribute_name")

ls_temp = f_attribute_find_attribute(pstr_command.attributes, "preserve_current_element")
if isnull(ls_temp) then
	lb_preserve_current_element = true
else
	lb_preserve_current_element = f_string_to_boolean(ls_temp)
end if

setnull(ld_property_date)
ls_property_date_attribute = f_attribute_find_attribute(pstr_command.attributes, "property_date_attribute")
if not isnull(ls_property_date_attribute) then
	if left(ls_property_date_attribute, 1) <> "%" then ls_property_date_attribute = "%" + ls_property_date_attribute + "%"
	ls_temp = f_attribute_value_substitute_context(ls_property_date_attribute, last_context, document_attributes)
	f_split_string(ls_temp, " ", ls_left, ls_right) 
	if isdate(ls_left) then
		ld_property_date = date(ls_left)
	end if
end if

lo_preserve_current_element = current_element

setnull(ls_element_value)

CHOOSE CASE lower(pstr_command.display_command)
	CASE "actors"
		// Make sure we don't already have one
		if isvalid(actors_element) and not isnull(actors_element) then return 0
		
		// Create the actors parent element
		actors_element = CREATE PBDOM_Element
		if len(ls_tag) > 0 then
			actors_element.setname(ls_tag)
		else
			actors_element.setname("Actors")
		end if
		
		// Add the element to the current element
		current_element.addcontent(actors_element)
	CASE "addactor"
		ls_code_domain = f_attribute_find_attribute(pstr_command.attributes, "code_domain")
		ll_owner_id = long(f_attribute_find_attribute(pstr_command.attributes, "owner_id"))

		setnull(ls_user_id)
		
		// Look for the user_id in the general properties
		if len(ls_property) > 0 then
			lstr_property_value = f_get_patient_property(last_context.cpr_id, pl_object_key, pstr_command.context_object, ls_property, lstr_attributes)
			if len(lstr_property_value.value) > 0 then
				ls_user_id = lstr_property_value.value
			end if
			
			// Look for the user_id in the document attributes
			if isnull(ls_user_id) then
				ls_user_id = f_attribute_find_attribute(document_attributes, ls_property)
			end if
		end if

		// If we still don't have a user_id then use the "value"
		if isnull(ls_user_id) then
			ls_user_id = ls_value
		end if

		// If we still don't gave a user_id then we can't generate the actor
		if isnull(ls_user_id) then return 0

		add_actor(current_element, ls_tag, ls_user_id, ls_code_domain, ll_owner_id)
	CASE "add config object"
		ls_config_object = f_attribute_find_attribute(pstr_command.attributes, "config_object_type")
		ls_config_object_key_name = f_attribute_find_attribute(pstr_command.attributes, "config_object_key")
		ls_config_object_id = f_attribute_find_attribute(pstr_command.attributes, "config_object_id")

		ll_config_object_index = add_config_object(ls_config_object, ls_config_object_key_name, ls_config_object_id)
		
		// If a tag is specified then create a child element for each row returned
		if len(ls_tag) > 0 then
			lo_element = add_element(current_element, ls_tag, ls_value)
		else
			lo_element = current_element
		end if
		
		if ll_config_object_index > 0 and len(ls_tag) > 0 then
			lo_element.setattribute("object_index", string(ll_config_object_index))
		end if
	CASE "amountunit"
		ls_amount_field = f_attribute_find_attribute(pstr_command.attributes, "amount_field")
		ls_unit_field = f_attribute_find_attribute(pstr_command.attributes, "unit_field")
		
		if len(ls_amount_field) > 0 and len(ls_unit_field) > 0 and len(ls_tag) > 0 then
			lr_amount = real(f_get_patient_property_value(last_context.cpr_id, pl_object_key, pstr_command.context_object, ls_amount_field, lstr_attributes))
			ls_unit_id = f_get_patient_property_value(last_context.cpr_id, pl_object_key, pstr_command.context_object, ls_unit_field, lstr_attributes)
			
			add_amount_unit( ls_tag, lr_amount, ls_unit_id)
		end if
		
	CASE "assessments"
		ls_sql = f_attribute_find_attribute(pstr_command.attributes, "sql_query")
		
		substitute_context(ls_sql)
		
		luo_data = CREATE u_ds_data
		luo_data.set_dataobject("dw_xml_object_select")
		luo_data.setsqlselect(ls_sql)
		ll_count = luo_data.retrieve()
		if ll_count < 0 then
			log.log(this, "create_xml_command_patient()", "Error retrieving assessments", 4)
			return -1
		end if
		
		for i = 1 to ll_count
			ll_problem_id = luo_data.object.object_id[i]
			
			if len(ls_tag) > 0 then
				// Create the child element
				lo_element = CREATE PBDOM_Element
				lo_element.setname(ls_tag)
				
				// If a value is specified then set it
				if len(ls_value) > 0 then
					lo_element.addcontent(ls_value)
				end if
				
				// Add the problem_id as an attribute
				lo_element.setattribute("problem_id", string(ll_problem_id))
				
				// Add the element to the current element
				current_element.addcontent(lo_element)
			else
				lo_element = current_element
			end if
			
			if ll_xml_script_id > 0 then
				// Add the ordinal attribute
				if isnull(ls_ordinal_attribute_name) then 	ls_ordinal_attribute_name = "assessment_number"
				f_attribute_add_attribute(document_attributes, ls_ordinal_attribute_name, string(i))
				// Build the assessment sub tree
				li_sts = create_xml(ll_xml_script_id, lo_element, last_context.cpr_id, "Assessment", ll_problem_id)
				if lb_preserve_current_element then current_element = lo_preserve_current_element
			end if
		next
	CASE "attribute"
		ls_name = f_attribute_find_attribute(pstr_command.attributes, "name")
		current_element.setattribute(ls_name, ls_value)
	CASE "compare"
		ls_left_side = f_attribute_find_attribute(pstr_command.attributes, "left_side")
		ls_right_side = f_attribute_find_attribute(pstr_command.attributes, "right_side")
		ls_operator = f_attribute_find_attribute(pstr_command.attributes, "operator")
		if isnull(ls_operator) then ls_operator = "="

		if f_string_compare(ls_left_side, ls_right_side, ls_operator) then
			// If a tag is specified then create a child element
			if len(ls_tag) > 0 then
				lo_element = add_element(current_element, ls_tag, ls_value, formfield_attribute_name, ls_formfield)
			else
				lo_element = current_element
			end if
			
			// If an xml script was specified then call it	
			if not isnull(ll_xml_script_id) then
				li_sts = create_xml(ll_xml_script_id, lo_element)
				if lb_preserve_current_element then current_element = lo_preserve_current_element
			end if
		end if
	CASE "config objects"
		// Make sure we don't already have one
		if isvalid(config_element) and not isnull(config_element) then return 0
		
		// Create the child element
		config_element = CREATE PBDOM_Element
		if len(ls_tag) > 0 then
			config_element.setname(ls_tag)
		else
			config_element.setname("ConfigObjects")
		end if
		
		// Add the element to the current element
		current_element.addcontent(config_element)
	CASE "druginfo"
		ls_which = f_attribute_find_attribute(pstr_command.attributes, "which_info")
		add_druginfo(current_element, ls_tag, ls_which)
		
	CASE "element"
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "make_current")
		lb_make_current = f_string_to_boolean(ls_temp)
		if len(ls_tag) > 0 then
			lo_element = add_element(current_element, ls_tag, ls_value, formfield_attribute_name, ls_formfield)
			
			// If a nested display is specified then recursively call "create_xml()"
			if ll_xml_script_id > 0 then
				li_sts = create_xml(ll_xml_script_id, lo_element)
				if lb_preserve_current_element then current_element = lo_preserve_current_element
			elseif lb_make_current then
				current_element = lo_element
			end if
		end if
	CASE "execute query"
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "create_elements")
		lb_create_elements = f_string_to_boolean(ls_temp)
		
		if isnull(ls_query) or ls_query = "" then return 0

		// Substitute tokens in the query
		ls_query = f_attribute_value_substitute_string(ls_query, last_context, document_attributes)
		
		// Construct a temp procedure for the SQL Query
		ls_sqlprocname = "#tmpxmlproc_execute_query" + "_" + string(pstr_command.display_script_id) + "_" + string(pstr_command.display_command_id)
		
		ls_sql = "DROP PROCEDURE " + ls_sqlprocname
		EXECUTE IMMEDIATE :ls_sql;
		
		ls_sql = "CREATE PROCEDURE " + ls_sqlprocname + " AS " + ls_query
		EXECUTE IMMEDIATE :ls_sql;
		if not tf_check() then return -1

//		/////////////////////////////////////////////////////////////////////////////////////
//		// Construct the datawindow and retrieve the rows
//		ls_syntax = sqlca.SyntaxFromSQL("EXECUTE " + ls_sqlprocname, "", ls_error_string)
//		if len(ls_error_string) > 0 then
//			log.log(this, "get_dw_syntax()", "Error getting syntax: SQL=" + ls_sql + ", ERROR=" + ls_error_string, 4)
//			return -1
//		end if
//
//		luo_data = CREATE u_ds_data
//		luo_data.Create(ls_syntax, ls_error_string)
//		if Len(ls_error_string) > 0 THEN
//			if isnull(ls_error_string) then ls_error_string = "<Null>"
//			log.log(this, "load_query()", "Error creating datastore (" + ls_error_string + ")", 4)
//			return -1
//		end if
//		
//		// Retrieve the data
//		luo_data.settransobject(sqlca)
//		ll_rows = luo_data.retrieve()
//		if ll_rows < 0 then
//			log.log(this, "load_query()", "Error executing query (" + ls_sql + ", " + sqlca.sqlerrtext + ")", 4)
//			return -1
//		end if
//		/////////////////////////////////////////////////////////////////////////////////////

		luo_data = CREATE u_ds_data
		ll_rows = luo_data.load_query("EXECUTE " + ls_sqlprocname)
		if ll_rows > 0 then
			if luo_data.column_id("attribute") > 0 and luo_data.column_id("value") > 0 then
				lb_attribute_query = true
			else
				lb_attribute_query = false
			end if
			for i = 1 to ll_rows
				// See if the attribute value is a foreign key to another config object
				setnull(ll_config_object_index)
				if lb_attribute_query then
					ls_attribute_attribute = luo_data.object.attribute[i]
					ls_attribute_value = luo_data.object.value[i]
					ll_config_object_index = add_config_object(ls_null, ls_attribute_attribute, ls_attribute_value)
				end if
				
				lstr_attributes = luo_data.get_attributes_from_row(i)
				
				// If a tag is specified then create a child element for each row returned
				if len(ls_tag) > 0 then
					lo_element = add_element(current_element, ls_tag, ls_value)
				else
					lo_element = current_element
				end if
				
				// If the create_elements flag is on then create a child element for each column returned in the query
				if lb_create_elements then
					for j = 1 to lstr_attributes.attribute_count
						if len(lstr_attributes.attribute[j].attribute) > 0 and len(lstr_attributes.attribute[j].value) > 0 then
							lo_child_element = add_element(lo_element, lstr_attributes.attribute[j].attribute, lstr_attributes.attribute[j].value)
							if ll_config_object_index > 0 and lower(lstr_attributes.attribute[j].attribute) = "value" then
								lo_child_element.setattribute("object_index", string(ll_config_object_index))
							end if
						end if
					next
				else
					// if we're not creating elements for each attribute, then push the attribute into the document attrtibutes
					f_attribute_add_attributes(document_attributes, lstr_attributes)
				end if
				
				// If a script is provided, then run the script for each row in the query
				if ll_xml_script_id > 0 then
					// Add the ordinal attribute
					if isnull(ls_ordinal_attribute_name) then 	ls_ordinal_attribute_name = "query_row_number"
					f_attribute_add_attribute(document_attributes, ls_ordinal_attribute_name, string(i))
					run_xml_script_from_attributes(lstr_attributes, ll_xml_script_id, lo_element)
				end if
			next
		elseif ll_rows < 0 then
			ls_temp = "Error processing query.  "
			ls_temp += "display_script_id=" + string(pstr_command.display_script_id)
			ls_temp += ", display_command_id=" + string(pstr_command.display_command_id)
			ls_temp += ", query=" + ls_query
			log.log(this, "display_script_command_general()", ls_temp, 4)
		end if
	CASE "if element"
		ls_condition = f_attribute_find_attribute(pstr_command.attributes, "condition")
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ls_true_value = f_attribute_find_attribute(pstr_command.attributes, "true_value")
		ls_false_value = f_attribute_find_attribute(pstr_command.attributes, "false_value")
		
		if len(ls_condition) > 0 then
			lb_condition = datalist.clinical_data_cache.if_condition(last_context.cpr_id, pstr_command.context_object, pl_object_key, ls_condition)
		else
			lb_condition = true
		end if
		
		if len(ls_query) > 0 then
			lb_condition2 = if_query(ls_query)
		else
			lb_condition2 = true
		end if
		
		// Normally one would supply either a conditional statement or a SQL query.  If both were supplied they are ANDed together.
		if lb_condition and lb_condition2 then
			lo_element = add_element(current_element, ls_tag, ls_true_value, formfield_attribute_name, ls_formfield)
		else
			lo_element = add_element(current_element, ls_tag, ls_false_value, formfield_attribute_name, ls_formfield)
		end if
		if isvalid(lo_element) and lb_make_current then
			current_element = lo_element
		end if
		
	CASE "if observation result"
		ls_observation_id = f_attribute_find_attribute(pstr_command.attributes, "observation_id")
		ls_result_type = f_attribute_find_attribute(pstr_command.attributes, "result_type")
		if isnull(ls_result_type) then ls_result_type = "PERFORM"
		li_result_sequence = integer(f_attribute_find_attribute(pstr_command.attributes, "result_sequence"))
		ls_result_unit = f_attribute_find_attribute(pstr_command.attributes, "result_unit")

		ls_operation = f_attribute_find_attribute(pstr_command.attributes, "operation")
		ls_from_value = f_attribute_find_attribute(pstr_command.attributes, "from_value")
		ls_to_value = f_attribute_find_attribute(pstr_command.attributes, "to_value")

		ls_true_value = f_attribute_find_attribute(pstr_command.attributes, "true_value")
		ls_false_value = f_attribute_find_attribute(pstr_command.attributes, "false_value")

		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "respect_encounter_context")
		if isnull(ls_temp) then
			lb_respect_encounter_context = true
		else
			lb_respect_encounter_context = f_string_to_boolean(ls_temp)
		end if

		// See if we should respect the encounter context, meaning get the patient observation on or before the encounter date.
		if lb_respect_encounter_context and isnull(ld_property_date) and last_context.encounter_id > 0 then
			lstr_property_value = f_get_property("Encounter", "encounter_date", last_context.encounter_id, lstr_attributes)
			f_split_string(lstr_property_value.value, " ", ls_left, ls_right) 
			if isdate(ls_left) then
				ld_property_date = date(ls_left)
			end if
		end if

		lb_condition = if_observation_result( last_context.cpr_id, &
													pl_object_key, &
													pstr_command.context_object, &
													ls_observation_id, &
													li_result_sequence, &
													ls_result_type, &
													ld_property_date, &
													ls_result_unit, &
													ls_operation, &
													ls_from_value, &
													ls_to_value)

		
		// Normally one would supply either a conditional statement or a SQL query.  If both were supplied they are ANDed together.
		if lb_condition then
			lo_element = add_element(current_element, ls_tag, ls_true_value, formfield_attribute_name, ls_formfield)
		else
			lo_element = add_element(current_element, ls_tag, ls_false_value, formfield_attribute_name, ls_formfield)
		end if
		if isvalid(lo_element) and lb_make_current then
			current_element = lo_element
		end if
		
	CASE "if script"
		ls_condition = f_attribute_find_attribute(pstr_command.attributes, "condition")
		ls_query = f_attribute_find_attribute(pstr_command.attributes, "query")
		ll_else_xml_script_id = long(f_attribute_find_attribute(pstr_command.attributes, "else_xml_script_id"))
		
		if len(ls_condition) > 0 then
			lb_condition = datalist.clinical_data_cache.if_condition(last_context.cpr_id, pstr_command.context_object, pl_object_key, ls_condition)
		else
			lb_condition = true
		end if
		
		if len(ls_query) > 0 then
			lb_condition2 = if_query(ls_query)
		else
			lb_condition2 = true
		end if
		
		if lb_condition and lb_condition2 then
			if ll_xml_script_id > 0 then
				// If a tag is specified then create a child element
				if len(ls_tag) > 0 then
					lo_element = add_element(current_element, ls_tag, ls_value)
				else
					lo_element = current_element
				end if
				
				li_sts = create_xml(ll_xml_script_id, current_element)
				if lb_preserve_current_element then current_element = lo_preserve_current_element
			end if
		else
			if ll_else_xml_script_id > 0 then
				// If a tag is specified then create a child element
				if len(ls_tag) > 0 then
					lo_element = add_element(current_element, ls_tag, ls_value)
				else
					lo_element = current_element
				end if
				
				li_sts = create_xml(ll_else_xml_script_id, current_element)
				if lb_preserve_current_element then current_element = lo_preserve_current_element
			end if
		end if
	CASE "immunizations"
		ls_disease_group = f_attribute_find_attribute(pstr_command.attributes, "disease_group")
		ll_disease_id = long(f_attribute_find_attribute(pstr_command.attributes, "disease_id"))
		ls_treatment_property = f_attribute_find_attribute(pstr_command.attributes, "treatment_property")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "treatment_ordinal")
		if isnumber(ls_temp) then
			ll_treatment_ordinal = long(ls_temp)
		else
			setnull(ll_treatment_ordinal)
		end if
		
		luo_data = CREATE u_ds_data
		if len(ls_disease_group) > 0 then
			luo_data.set_dataobject("dw_disease_group_immunization_treatments")
			ll_count = luo_data.retrieve(last_context.cpr_id, ls_disease_group)
		elseif not isnull(ll_disease_id) then
			luo_data.set_dataobject("dw_disease_immunization_treatments")
			ll_count = luo_data.retrieve(last_context.cpr_id, ll_disease_id)
		else
			return 0
		end if
		if ll_count < 0 then
			log.log(this, "create_xml_command_patient()", "Error retrieving assessments", 4)
			return -1
		end if
		
		ll_end = ll_count
		if ll_treatment_ordinal > 0 then
			ll_start = ll_treatment_ordinal
			if ll_treatment_ordinal <= ll_count then
				ll_end = ll_treatment_ordinal
			end if
		else
			ll_start = 1
		end if
		for i = ll_start to ll_end
			ll_treatment_id = luo_data.object.treatment_id[i]
			
			if len(ls_tag) > 0 then
				if len(ls_treatment_property) > 0 then
					lstr_property_value = f_get_patient_property(last_context.cpr_id, ll_treatment_id, "Treatment", ls_treatment_property, lstr_attributes)
					if len(lstr_property_value.value) > 0 then
						ls_value = lstr_property_value.value
					end if
				end if
				
				lo_element = add_element(current_element, ls_tag, ls_value, formfield_attribute_name, ls_formfield)

				// Add the problem_id as an attribute
//				lo_element.setattribute("treatment_id", string(ll_treatment_id))
			else
				lo_element = current_element
			end if
			
			if ll_xml_script_id > 0 then
				// Add the ordinal attribute
				if isnull(ls_ordinal_attribute_name) then 	ls_ordinal_attribute_name = "immunization_number"
				f_attribute_add_attribute(document_attributes, ls_ordinal_attribute_name, string(i))
				// Build the assessment sub tree
				li_sts = create_xml(ll_xml_script_id, lo_element, last_context.cpr_id, "Treatment", ll_treatment_id)
				if lb_preserve_current_element then current_element = lo_preserve_current_element
			end if
		next
	CASE "note"
		ls_progress_type = f_attribute_find_attribute(pstr_command.attributes, "progress_type")
		ls_progress_key = f_attribute_find_attribute(pstr_command.attributes, "progress_key")
		
		add_note(ls_tag, pstr_command.context_object, pl_object_key, ls_progress_type, ls_progress_key)
	CASE "objectid"
		ls_jmj_domain = f_attribute_find_attribute(pstr_command.attributes, "jmj_domain")
		ls_jmj_domain_2 = f_attribute_find_attribute(pstr_command.attributes, "jmj_domain_2")
		ls_code_domain = f_attribute_find_attribute(pstr_command.attributes, "code_domain")
		ll_owner_id = long(f_attribute_find_attribute(pstr_command.attributes, "owner_id"))

		ls_epro_id = f_get_patient_property_value(last_context.cpr_id, pl_object_key, pstr_command.context_object, ls_jmj_domain, lstr_attributes)
		
		if len(ls_jmj_domain_2) > 0 then
			ls_epro_id += "|" + f_get_patient_property_value(last_context.cpr_id, pl_object_key, pstr_command.context_object, ls_jmj_domain_2, lstr_attributes)
			ls_jmj_domain += "|" + ls_jmj_domain_2
		end if
		
		add_object_id(current_element, ls_jmj_domain, ls_epro_id, ls_code_domain, ll_owner_id)
		
	CASE "observation"
		lb_latest_only = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "latest_only"))
		ls_observation_id = f_attribute_find_attribute(pstr_command.attributes, "observation_id")
		ls_result_type = f_attribute_find_attribute(pstr_command.attributes, "result_type")
		if isnull(ls_result_type) then ls_result_type = "PERFORM"
		li_result_sequence = integer(f_attribute_find_attribute(pstr_command.attributes, "result_sequence"))
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "observation_date")
		if isnull(ls_temp) then
			setnull(ld_observation_date)
		else
			f_split_string(ls_temp, " ", ls_left, ls_right)
			if isdate(ls_left) then
				ld_observation_date = date(ls_left)
			else
				setnull(ld_observation_date)
			end if
		end if

		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "respect_encounter_context")
		if isnull(ls_temp) then
			lb_respect_encounter_context = true
		else
			lb_respect_encounter_context = f_string_to_boolean(ls_temp)
		end if

		// See if we should respect the encounter context, meaning get the patient observation on or before the encounter date.
		if lb_respect_encounter_context and isnull(ld_observation_date) and last_context.encounter_id > 0 then
			lstr_property_value = f_get_property("Encounter", "encounter_date", last_context.encounter_id, lstr_attributes)
			f_split_string(lstr_property_value.value, " ", ls_left, ls_right) 
			if isdate(ls_left) then
				ld_observation_date = date(ls_left)
			end if
		end if

		If isnull(ls_observation_id) or trim(ls_observation_id) = "" Then
			li_sts = 0
		Else
			li_sts = add_observation( current_element, &
											last_context.cpr_id, &
											pl_object_key, &
											pstr_command.context_object, &
											ls_tag, &
											ls_observation_id, &
											li_result_sequence, &
											ls_result_type, &
											ld_observation_date)
		End If
	CASE "observation dates"
		// Determines a distinct set of dates (not including times) when any of a set of specified observations/results were collected
		// for the current context.  Then a specified xml script is called for each date.
		ls_observation_id = f_attribute_find_attribute(pstr_command.attributes, "observation_id")
		ls_result_type = f_attribute_find_attribute(pstr_command.attributes, "result_type")
		li_result_sequence = integer(f_attribute_find_attribute(pstr_command.attributes, "result_sequence"))
		lb_latest_only = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "latest_only"))
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "observation_date")
		if isnull(ls_temp) then
			setnull(ld_observation_date)
		else
			f_split_string(ls_temp, " ", ls_left, ls_right)
			if isdate(ls_left) then
				ld_observation_date = date(ls_left)
			else
				setnull(ld_observation_date)
			end if
		end if

		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "respect_encounter_context")
		if isnull(ls_temp) then
			lb_respect_encounter_context = true
		else
			lb_respect_encounter_context = f_string_to_boolean(ls_temp)
		end if

		// See if we should respect the encounter context, meaning get the patient observation on or before the encounter date.
		if lb_respect_encounter_context and isnull(ld_observation_date) and last_context.encounter_id > 0 then
			lstr_property_value = f_get_property("Encounter", "encounter_date", last_context.encounter_id, lstr_attributes)
			f_split_string(lstr_property_value.value, " ", ls_left, ls_right) 
			if isdate(ls_left) then
				ld_observation_date = date(ls_left)
			end if
		end if

		luo_data = CREATE u_ds_data
		luo_data.set_dataobject("dw_fn_patient_observation_dates")
		ll_count = luo_data.retrieve(last_context.cpr_id, ls_context_object, ll_object_key, ls_observation_id, li_result_sequence, ls_result_type)
		if ll_count < 0 then
			log.log(this, "create_xml_command_patient()", "Error retrieving assessments", 4)
			return -1
		end if

		// Find the latest observation date on or before the specified date
		if not isnull(ld_observation_date) then
			ll_end = 0
			for i = 1 to ll_count
				ldt_observation_date = luo_data.object.observation_date[i]
				if date(ldt_observation_date) <= ld_observation_date then
					ll_end = i
				else
					exit
				end if
			next
		else
			ll_end = ll_count
		end if
		
		// If the latest_only flag is set then get only the latest date
		if lb_latest_only and ll_end > 0 then
			ll_start = ll_end
		else
			ll_start = 1
		end if
		
		for i = ll_start to ll_end
			// Set the observation_date attribute for each call to the nested script
			ldt_observation_date = luo_data.object.observation_date[i]
			f_attribute_add_attribute(document_attributes, "observation_date", string(date(ldt_observation_date)))
			
			if len(ls_tag) > 0 then
				lo_element = add_element(current_element, ls_tag, ls_value, formfield_attribute_name, ls_formfield)
			else
				lo_element = current_element
			end if
		
			if ll_xml_script_id > 0 then
				// Add the ordinal attribute
				if isnull(ls_ordinal_attribute_name) then 	ls_ordinal_attribute_name = "observation_date_number"
				f_attribute_add_attribute(document_attributes, ls_ordinal_attribute_name, string(i))
				// Build the assessment sub tree
				li_sts = create_xml(ll_xml_script_id, lo_element)
				if lb_preserve_current_element then current_element = lo_preserve_current_element
			end if
		next
		
	CASE "observation result"
		ls_observation_id = f_attribute_find_attribute(pstr_command.attributes, "observation_id")
		li_result_sequence = integer(f_attribute_find_attribute(pstr_command.attributes, "result_sequence"))
		ls_result_unit = f_attribute_find_attribute(pstr_command.attributes, "result_unit")
		lb_formatted_flag = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "formatted"))
		lb_amount_only = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "amount_only"))
		lb_display_location = f_string_to_boolean(f_attribute_find_attribute(pstr_command.attributes, "display_location"))
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "display_unit")
		if isnull(ls_temp) then
			lb_display_unit = true
		else
			lb_display_unit = f_string_to_boolean(ls_temp)
		end if
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "observation_date")
		if isnull(ls_temp) then
			setnull(ld_observation_date)
		else
			f_split_string(ls_temp, " ", ls_left, ls_right)
			if isdate(ls_left) then
				ld_observation_date = date(ls_left)
			else
				setnull(ld_observation_date)
			end if
		end if
		
		
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "respect_encounter_context")
		if isnull(ls_temp) then
			lb_respect_encounter_context = true
		else
			lb_respect_encounter_context = f_string_to_boolean(ls_temp)
		end if

		// See if we should respect the encounter context, meaning get the patient observation on or before the encounter date.
		if lb_respect_encounter_context and isnull(ld_observation_date) and last_context.encounter_id > 0 then
			lstr_property_value = f_get_property("Encounter", "encounter_date", last_context.encounter_id, lstr_attributes)
			f_split_string(lstr_property_value.value, " ", ls_left, ls_right) 
			if isdate(ls_left) then
				ld_observation_date = date(ls_left)
			end if
		end if

		If isnull(ls_observation_id) or trim(ls_observation_id) = "" Then
			li_sts = 0
		Else
			li_sts = add_observation_result( current_element, &
													last_context.cpr_id, &
													pl_object_key, &
													pstr_command.context_object, &
													ls_tag, &
													ls_observation_id, &
													li_result_sequence, &
													ls_result_type, &
													ld_observation_date, &
													ls_result_unit, &
													lb_formatted_flag, &
													lb_amount_only, &
													lb_display_location, &
													lb_display_unit, &
													formfield_attribute_name, &
													ls_formfield)
		End If
	CASE "patientid"
		ls_epro_id = f_get_patient_property_value(last_context.cpr_id, pl_object_key, pstr_command.context_object, ls_property, lstr_attributes)
		
		add_patient_id(current_element, ls_property, ls_epro_id)
		
	CASE "property", "property date"
		ls_date_format = f_attribute_find_attribute(pstr_command.attributes, "date_format")
		ls_temp = f_attribute_find_attribute(pstr_command.attributes, "make_current")
		lb_make_current = f_string_to_boolean(ls_temp)
		lstr_attributes = document_attributes
		f_attribute_add_attribute(lstr_attributes, "property_date", string(ld_property_date))
		if len(ls_tag) > 0 and len(ls_property) > 0 then
			// If a value is specified then set it
			lstr_property_value = f_get_patient_property(last_context.cpr_id, pl_object_key, pstr_command.context_object, ls_property, lstr_attributes)
			if len(lstr_property_value.value) > 0 then
				ls_element_value = lstr_property_value.value
			end if
			
			if len(ls_element_value) > 0 and lower(pstr_command.display_command) = "property date" then
				// Turn off auto date formatting because we will format the date right here
				auto_date_format = false
				
				ldt_datetime = f_string_to_datetime(ls_element_value)
				if not isnull(ldt_datetime) then
					if lower(ls_date_format) = "xml" then
						ls_element_value = xml_date_time(ls_element_value)
					elseif len(ls_date_format) > 0 then
						ls_element_value = string(ldt_datetime, ls_date_format)
					else
						if time(ldt_datetime) = time("00:00:00") then
							ls_element_value = string(date(ldt_datetime))
						else
							ls_element_value = string(ldt_datetime)
						end if
					end if
				end if
			end if
			
			lo_element = add_element(current_element, ls_tag, ls_element_value, formfield_attribute_name, ls_formfield)
			if len(lstr_property_value.value) > 0 then
				lo_element.setattribute("value", lstr_property_value.value)
			end if
			if len(lstr_property_value.datatype) > 0 then
				lo_element.setattribute("datatype", lstr_property_value.datatype)
			end if
			if len(lstr_property_value.filetype) > 0 then
				lo_element.setattribute("filetype", lstr_property_value.filetype)
			end if
			if len(lstr_property_value.encoding) > 0 then
				lo_element.setattribute("encoding", lstr_property_value.encoding)
			end if

			// If a nested display is specified then recursively call "create_xml()"
			if ll_xml_script_id > 0 then
				li_sts = create_xml(ll_xml_script_id, lo_element)
				if lb_preserve_current_element then current_element = lo_preserve_current_element
			elseif lb_make_current then
				current_element = lo_element
			end if
		else
			log.log(this, "create_xml_command_patient()", "No tag", 4)
			return -1
		end if
	CASE "root"
		current_element = root_element
	CASE "script"
		// If a nested display is specified then recursively call "create_xml()"
		if ll_xml_script_id > 0 then
			li_sts = create_xml(ll_xml_script_id, current_element)
			if lb_preserve_current_element then current_element = lo_preserve_current_element
		end if
	CASE "set patient"
		// Set the patient to a different cpr_id and call an xml script
		ls_nested_cpr_id = f_attribute_find_attribute(pstr_command.attributes, "nested_cpr_id")
		if len(ls_tag) > 0 and ll_xml_script_id > 0 then
			lo_element = add_element(current_element, ls_tag, ls_value, formfield_attribute_name, ls_formfield)
			li_sts = create_xml(ll_xml_script_id, lo_element, ls_nested_cpr_id, "Patient", ll_null)
			if lb_preserve_current_element then current_element = lo_preserve_current_element
		end if
	CASE "treatments"
		ls_sql = f_attribute_find_attribute(pstr_command.attributes, "sql_query")
		
		substitute_context(ls_sql)
		
		luo_data = CREATE u_ds_data
		luo_data.set_dataobject("dw_xml_object_select")
		luo_data.setsqlselect(ls_sql)
		ll_count = luo_data.retrieve()
		if ll_count < 0 then
			log.log(this, "create_xml_command_patient()", "Error retrieving treatments", 4)
			return -1
		end if
		
		for i = 1 to ll_count
			ll_treatment_id = luo_data.object.object_id[i]
			
			if len(ls_tag) > 0 then
				// Create the child element
				lo_element = CREATE PBDOM_Element
				lo_element.setname(ls_tag)
				
				// If a value is specified then set it
				if len(ls_value) > 0 then
					lo_element.addcontent(ls_value)
				end if
				
				// Add the treatment_id as an attribute
				lo_element.setattribute("treatment_id", string(ll_treatment_id))
				
				// Add the element to the current element
				current_element.addcontent(lo_element)
			else
				lo_element = current_element
			end if
			
			if ll_xml_script_id > 0 then
				// Add the ordinal attribute
				if isnull(ls_ordinal_attribute_name) then 	ls_ordinal_attribute_name = "treatment_number"
				f_attribute_add_attribute(document_attributes, ls_ordinal_attribute_name, string(i))
				// Build the treatment sub tree
				li_sts = create_xml(ll_xml_script_id, lo_element, last_context.cpr_id, "Treatment", ll_treatment_id)
				if lb_preserve_current_element then current_element = lo_preserve_current_element
			end if
		next
	CASE "up"
		ls_root_tag = root_element.getname()
		ls_current_tag = current_element.getname()
		if ls_root_tag = ls_current_tag then return 1
		current_element = current_element.getparent()
END CHOOSE


return 1


end function

public subroutine add_patient_id (pbdom_element po_parent_element, string ps_jmj_domain, string ps_epro_id);string ls_value
PBDOM_Element lo_element
PBDOM_Element lo_element2

// Create the child element
lo_element = CREATE PBDOM_Element
lo_element.setname("PatientID")

po_parent_element.addcontent(lo_element)

// Create the owner id element
lo_element2 = CREATE PBDOM_Element
lo_element2.setname("OwnerID")

lo_element2.addcontent(string(sqlca.customer_id))

lo_element.addcontent(lo_element2)

// Create the IDDomain element
lo_element2 = CREATE PBDOM_Element
lo_element2.setname("PatientIDDomain")

lo_element2.addcontent(ps_jmj_domain)

lo_element.addcontent(lo_element2)

// Create the IDValue element
lo_element2 = CREATE PBDOM_Element
lo_element2.setname("PatientID")

if len(ps_epro_id) > 0 then
	lo_element2.addcontent(ps_epro_id)
end if

lo_element.addcontent(lo_element2)


end subroutine

public subroutine add_druginfo (pbdom_element po_parent_element, string ps_tag, string ps_which);str_treatment_description lstr_treatment
integer li_sts
string ls_value
PBDOM_Element lo_element

if isnull(last_context.cpr_id) then return

li_sts = datalist.clinical_data_cache.get_treatment(last_context.cpr_id, last_context.treatment_id, lstr_treatment)
if li_sts <= 0 then return

CHOOSE CASE lower(ps_which)
	CASE "admin"
		ls_value = drugdb.treatment_admin_description(lstr_treatment)
	CASE "dispense"
		ls_value = drugdb.treatment_dispense_description(lstr_treatment)
	CASE "dosing"
		ls_value = drugdb.treatment_dosing_description(lstr_treatment)
	CASE "drug"
		ls_value = drugdb.treatment_drug_description(lstr_treatment)
	CASE "sig"
		ls_value = drugdb.treatment_drug_sig(lstr_treatment)
	CASE "refill"
		ls_value = drugdb.treatment_refill_description(lstr_treatment)
END CHOOSE

if isnull(ls_value) or trim(ls_value) = "" then return

lo_element = CREATE PBDOM_Element
lo_element.setname(ps_tag)

lo_element.addcontent(ls_value)

po_parent_element.addcontent(lo_element)


end subroutine

public function string xml_date_time (string ps_date);string ls_left
string ls_right
date ld_date
time lt_time
string ls_date
string ls_time

f_split_string(ps_date, " ", ls_left, ls_right)

if isdate(ls_left) then
	ld_date = date(ls_left)
else
	return ps_date
end if

ls_date = xml_date(ld_date)

if istime(ls_right) then
	lt_time = time(ls_right)
	ls_time = xml_time(lt_time)
	
	if isnull(xml_date_time_separator) or trim(xml_date_time_separator) = "" then
		xml_date_time_separator = datalist.get_preference("PREFERENCES", "XML Date Time Separator", " ")
	end if
	
	if len(ls_time) > 0 then ls_time = xml_date_time_separator + ls_time
else
	ls_time = ""
end if

return ls_date + ls_time




end function

public subroutine add_object_id (pbdom_element po_parent_element, string ps_jmj_domain, string ps_epro_id, string ps_code_domain, string ps_code_value, long pl_owner_id);string ls_value
PBDOM_Element lo_element
PBDOM_Element lo_element2

// Create the child element
lo_element = CREATE PBDOM_Element
lo_element.setname("ObjectID")

po_parent_element.addcontent(lo_element)

// Create the owner id element
if pl_owner_id >= 0 then
	lo_element2 = CREATE PBDOM_Element
	lo_element2.setname("OwnerID")
	
	lo_element2.addcontent(string(pl_owner_id))
	
	lo_element.addcontent(lo_element2)
end if



// Create the IDDomain element
if len(ps_code_domain) > 0 then
	lo_element2 = CREATE PBDOM_Element
	lo_element2.setname("IDDomain")
	
	lo_element2.addcontent(ps_code_domain)
	
	lo_element.addcontent(lo_element2)
	
	// If we're missing the value then look it up
	if isnull(ps_code_value) and not isnull(ps_jmj_domain) and not isnull(ps_epro_id) then
		ps_code_value = sqlca.fn_lookup_code(ps_jmj_domain, ps_epro_id, ps_code_domain, pl_owner_id)
	end if
	
	if len(ps_code_value) > 0 then
		lo_element2 = CREATE PBDOM_Element
		lo_element2.setname("IDValue")
		
		lo_element2.addcontent(ps_code_value)
		
		lo_element.addcontent(lo_element2)
	end if
end if

if len(ps_jmj_domain) > 0 then
	if len(ps_epro_id) > 0 then
		// Create the JMJDomain element
		lo_element2 = CREATE PBDOM_Element
		lo_element2.setname("CustomerID")
		
		lo_element2.addcontent(string(sqlca.customer_id))
		
		lo_element.addcontent(lo_element2)
	end if
	
	// Create the JMJDomain element
	lo_element2 = CREATE PBDOM_Element
	lo_element2.setname("JMJDomain")
	
	lo_element2.addcontent(ps_jmj_domain)
	
	lo_element.addcontent(lo_element2)
	
	// If we're missing the epro id then look it up
	if isnull(ps_epro_id) and not isnull(ps_code_domain) and not isnull(ps_code_value) then
		ps_epro_id = sqlca.fn_lookup_epro_id(pl_owner_id, ps_code_domain, ps_code_value, ps_jmj_domain)
	end if
	
	if len(ps_epro_id) > 0 then
		lo_element2 = CREATE PBDOM_Element
		lo_element2.setname("JMJValue")
		
		lo_element2.addcontent(ps_epro_id)
		
		lo_element.addcontent(lo_element2)
	end if
end if

end subroutine

public subroutine run_xml_script_from_attributes (str_attributes pstr_attributes, long pl_xml_script_id, pbdom_element po_current_element);integer li_sts
long i
long ll_object_key
str_attributes lstr_document_attributes_save
string ls_cpr_id
string ls_context_object

str_encounter_description lstr_encounter
str_assessment_description lstr_assessment
str_treatment_description lstr_treatment

if isnull(pl_xml_script_id) then return

ls_cpr_id = last_context.cpr_id
setnull(ls_context_object)

for i = 1 to pstr_attributes.attribute_count
	CHOOSE CASE lower(pstr_attributes.attribute[i].attribute)
		CASE "cpr_id"
			ls_cpr_id = pstr_attributes.attribute[i].value
			ls_context_object = "patient"
			setnull(ll_object_key)
		CASE "encounter_id"
			ls_context_object = "encounter"
			ll_object_key = long(pstr_attributes.attribute[i].value)
		CASE "problem_id"
			ls_context_object = "assessment"
			ll_object_key = long(pstr_attributes.attribute[i].value)
		CASE "treatment_id"
			ls_context_object = "treatment"
			ll_object_key = long(pstr_attributes.attribute[i].value)
		CASE "observation_sequence"
			ls_context_object = "observation"
			ll_object_key = long(pstr_attributes.attribute[i].value)
		CASE "attachment_id"
			ls_context_object = "attachment"
			ll_object_key = long(pstr_attributes.attribute[i].value)
	END CHOOSE
next

// push the attributes into the report_attributes, but save the report_attributes and restore them later
lstr_document_attributes_save = document_attributes
f_attribute_add_attributes(document_attributes, pstr_attributes)

// Display the specified script
if isnull(ls_context_object) then
	create_xml(pl_xml_script_id, po_current_element)
else
	create_xml(pl_xml_script_id, po_current_element, ls_cpr_id, ls_context_object, ll_object_key)
end if

// restore the attributes
document_attributes = lstr_document_attributes_save


end subroutine

public function pbdom_element add_element (pbdom_element po_current_element, string ps_tag, string ps_value);string ls_attribute_name
string ls_attribute_value

setnull(ls_attribute_name)
setnull(ls_attribute_value)

return add_element(po_current_element, ps_tag, ps_value,ls_attribute_name, ls_attribute_value)

end function

public function boolean if_query (string ps_query);boolean lb_return
long ll_value

DECLARE lc_sql_cursor DYNAMIC CURSOR FOR SQLSA ;

PREPARE SQLSA FROM :ps_query ;
if not tf_check() then return false

OPEN DYNAMIC lc_sql_cursor;
if not tf_check() then return false

// See if there were any rows
if sqlca.sqlnrows > 0 then
	// If we had rows, then look at the first column in the first row
	FETCH lc_sql_cursor INTO :ll_value ;
	if not tf_check() then return false
	
	// If it's greater than 0 then it's true
	if ll_value > 0 then
		lb_return = true
	else
		lb_return = false
	end if
else
	// No rows means false
	lb_return = false
end if

CLOSE lc_sql_cursor ;

return lb_return



end function

public function long add_config_object (string ps_config_object_type, string ps_attribute, string ps_config_object_id);long ll_config_object_index
long i
PBDOM_Element lo_config_object
string ls_object_key_save
str_config_object_type lstr_config_object_type

// Don't bother if we don't have an ID
if isnull(ps_config_object_id) or trim(ps_config_object_id) = "" then return 0


// First determine the config object from the config_object_id (if needed)
if len(ps_config_object_type) > 0 then
	lstr_config_object_type = datalist.get_config_object_type(ps_config_object_type)
	if isnull(lstr_config_object_type.config_object_type) then return 0
else
	lstr_config_object_type = datalist.config_object_type_from_key_name(ps_attribute)
	if len(lstr_config_object_type.config_object_type) > 0 then
		ps_config_object_type = lstr_config_object_type.config_object_type
	else
		return 0
	end if
end if

// Next, see if this config object has already been extracted
for i = 1 to config_object_count
	if ps_config_object_type = config_objects[i].config_object and ps_config_object_id = config_objects[i].config_object_id then
		return i
	end if
next

// Didn't find it so let's export it

// If we don't have a script id then don't bother
if isnull(lstr_config_object_type.creator_xml_script_id) or lstr_config_object_type.creator_xml_script_id = 0 then return 0

// Create the root for the new config object and put it into the document
lo_config_object = CREATE PBDOM_Element
lo_config_object.setname(ps_config_object_type)

config_object_count += 1
config_objects[config_object_count].config_object = ps_config_object_type
config_objects[config_object_count].config_object_id = ps_config_object_id

ll_config_object_index = config_object_count

lo_config_object.setattribute("object_index", string(ll_config_object_index))

// Make sure we have a parent
if not isvalid(config_element) or isnull(config_element) then
	log.log(this, "add_config_object()", "No config element defined", 4)
	return 0
end if

// New config objects need to be added before the last config object so the references will
// work when the XML is read.
if isnull(last_config_element) then
	config_element.addcontent(lo_config_object)
else
	config_element.insertcontent(lo_config_object, last_config_element)
end if

last_config_element = lo_config_object


// Now, add the config object content

// Save the current state of this key
ls_object_key_save = f_attribute_find_attribute(document_attributes, ps_attribute)
f_attribute_add_attribute(document_attributes, ps_attribute, ps_config_object_id)

this.create_xml(lstr_config_object_type.creator_xml_script_id, lo_config_object)

// Restore the current state of this key
f_attribute_add_attribute(document_attributes, ps_attribute, ls_object_key_save)

return ll_config_object_index

end function

public function pbdom_element add_element (pbdom_element po_current_element, string ps_tag, string ps_value, string ps_attribute_name, string ps_attribute_value);pbdom_element lo_element

// Create the child element
lo_element = CREATE PBDOM_Element
lo_element.setname(ps_tag)

if len(ps_attribute_name) > 0 and not isnull(ps_attribute_value) then
	lo_element.setattribute(ps_attribute_name, ps_attribute_value)
end if

if auto_date_format then
	if lower(left(ps_tag, 4)) = "date" &
		or lower(right(ps_tag, 4)) = "date" &
		or lower(right(ps_tag, 9)) = "date_time" &
		or lower(ps_tag) = "last_updated" then
		ps_value = xml_date_time(ps_value)
	end if
end if

if len(ps_value) > 0 then
	lo_element.addcontent(ps_value)
end if

// Add the element to the current element
po_current_element.addcontent(lo_element)

return lo_element

end function

public function string xml_date_time (datetime pdt_datetime);string ls_date
string ls_time

ls_date = xml_date(date(pdt_datetime))
ls_time = xml_time(time(pdt_datetime))

if len(ls_time) > 0 then
	if isnull(xml_date_time_separator) or trim(xml_date_time_separator) = "" then
		xml_date_time_separator = datalist.get_preference("PREFERENCES", "XML Date Time Separator", " ")
	end if

	ls_time = xml_date_time_separator + ls_time
end if

return ls_date + ls_time




end function

public function string xml_date (date pd_date);string ls_left
string ls_right
string ls_date

if isnull(xml_date_format) or trim(xml_date_format) = "" then
	xml_date_format = datalist.get_preference("PREFERENCES", "XML Date Format", "yyyymmdd")
end if

ls_date = string(pd_date, xml_date_format)

return ls_date





end function

public function string xml_time (time pt_time);string ls_time

if isnull(xml_time_format) or trim(xml_time_format) = "" then
	xml_time_format = datalist.get_preference("PREFERENCES", "XML Time Format", "hh:mm:ss")
end if

ls_time = string(pt_time, xml_time_format)

return ls_time


end function

public subroutine add_unit (pbdom_element po_parent_element, string ps_tag, string ps_unit_id);string ls_value
u_unit luo_unit
PBDOM_Element lo_element
PBDOM_Element lo_element2
string lsa_suffixes[]
long ll_count
long i

luo_unit = unit_list.find_unit(ps_unit_id)
if isnull(luo_unit) then return

// Create the child element
lo_element = CREATE PBDOM_Element
lo_element.setname(ps_tag)
// Add the description here for backwards compatibility
lo_element.addcontent(luo_unit.description)

po_parent_element.addcontent(lo_element)


// UnitID
lo_element2 = CREATE PBDOM_Element
lo_element2.setname("UnitID")
lo_element2.addcontent(ps_unit_id)

lo_element.addcontent(lo_element2)

// description
lo_element2 = CREATE PBDOM_Element
lo_element2.setname("Unit")
lo_element2.addcontent(luo_unit.description)

lo_element.addcontent(lo_element2)

// Unit Type
lo_element2 = CREATE PBDOM_Element
lo_element2.setname("UnitAmountType")
lo_element2.addcontent(luo_unit.unit_type)

lo_element.addcontent(lo_element2)

// Plural Flag
lo_element2 = CREATE PBDOM_Element
lo_element2.setname("PluralRule")
lo_element2.addcontent(luo_unit.plural_flag)

lo_element.addcontent(lo_element2)

// Print Unit
lo_element2 = CREATE PBDOM_Element
lo_element2.setname("PrintUnit")
lo_element2.addcontent(f_boolean_to_string(f_string_to_boolean(luo_unit.print_unit)))

lo_element.addcontent(lo_element2)

// Display Mask
lo_element2 = CREATE PBDOM_Element
lo_element2.setname("DisplayTemplate")
lo_element2.addcontent(luo_unit.display_mask)

lo_element.addcontent(lo_element2)

// Prefix
if len(luo_unit.prefix) > 0 then
	lo_element2 = CREATE PBDOM_Element
	lo_element2.setname("Prefix")
	lo_element2.addcontent(luo_unit.prefix)
	
	lo_element.addcontent(lo_element2)
end if

if len(luo_unit.major_unit_display_suffix) > 0 then
	// major_unit_display_suffix
	lo_element2 = CREATE PBDOM_Element
	lo_element2.setname("MajorUnitDisplaySuffix")
	lo_element2.addcontent(luo_unit.major_unit_display_suffix)
	
	lo_element.addcontent(lo_element2)
end if
	
if len(luo_unit.minor_unit_display_suffix) > 0 then
	// minor_unit_display_suffix
	lo_element2 = CREATE PBDOM_Element
	lo_element2.setname("MinorUnitDisplaySuffix")
	lo_element2.addcontent(luo_unit.minor_unit_display_suffix)
	
	lo_element.addcontent(lo_element2)
end if
	
if len(luo_unit.major_unit_input_suffixes) > 0 then
	// major_unit_input_suffixes
	ll_count = f_parse_string(luo_unit.major_unit_input_suffixes, ",", lsa_suffixes)
	for i = 1 to ll_count
		lo_element2 = CREATE PBDOM_Element
		lo_element2.setname("MajorUnitInputSuffix")
		lo_element2.addcontent(lsa_suffixes[i])
		
		lo_element.addcontent(lo_element2)
	next
end if
	
if len(luo_unit.minor_unit_input_suffixes) > 0 then
	// minor_unit_input_suffixes
	ll_count = f_parse_string(luo_unit.minor_unit_input_suffixes, ",", lsa_suffixes)
	for i = 1 to ll_count
		lo_element2 = CREATE PBDOM_Element
		lo_element2.setname("MinorUnitInputSuffix")
		lo_element2.addcontent(lsa_suffixes[i])
		
		lo_element.addcontent(lo_element2)
	next
end if
	
if not isnull(luo_unit.multiplier) then
	// multiplier
	lo_element2 = CREATE PBDOM_Element
	lo_element2.setname("MajorMinorMultiplier")
	lo_element2.addcontent(string(luo_unit.multiplier))
	
	lo_element.addcontent(lo_element2)
end if
	
if not isnull(luo_unit.display_minor_units) then
	// display_minor_units
	lo_element2 = CREATE PBDOM_Element
	lo_element2.setname("DisplayMinorUnits")
	lo_element2.addcontent(f_boolean_to_string(luo_unit.display_minor_units))
	
	lo_element.addcontent(lo_element2)
end if


end subroutine

public function integer add_observation_result (pbdom_element po_parent_element, string ps_tag, str_p_observation_result pstr_result, string ps_result_unit, boolean pb_formatted, boolean pb_amount_only, boolean pb_display_location, boolean pb_display_unit, string ps_attribute_name, string ps_attribute_value);str_treatment_description lstr_treatment
integer li_sts
string ls_value
string ls_display_value
string ls_display_unit
string ls_unit_preference
PBDOM_Element lo_element
u_ds_data luo_results
u_unit luo_unit

if isnull(ps_tag) or trim(ps_tag) = "" then ps_tag = "Result"
lo_element = CREATE PBDOM_Element
lo_element.setname(ps_tag)

if pb_formatted then
	ls_display_value = pstr_result.result_value
	ls_display_unit = pstr_result.result_unit
	ls_unit_preference = pstr_result.unit_preference
	
	// If the caller wants to display the result in a specific unit then try to convert
	if len(ps_result_unit) > 0 then
		luo_unit = unit_list.find_unit(pstr_result.result_unit)
		if not isnull(luo_unit) then
			ls_value = luo_unit.convert( ps_result_unit, pstr_result.result_value)
			if len(ls_value) > 0 then 
				ls_display_value = ls_value
				ls_display_unit = ps_result_unit
				ls_unit_preference = "NOCONVERSION"
			end if
		end if
	end if

	ls_value = f_pretty_result( pstr_result.result, &
										pstr_result.location, &
										pstr_result.location_description, &
										ls_display_value, &
										ls_display_unit, &
										pstr_result.result_amount_flag, &
										pstr_result.print_result_flag, &
										pstr_result.print_result_separator, &
										pstr_result.abnormal_flag, &
										ls_unit_preference, &
										pstr_result.display_mask, &
										pb_amount_only, &
										pb_display_location, &
										pb_display_unit )
	lo_element.addcontent(ls_value)
else
	TRY
		if len(pstr_result.location_description) > 0 then add_element( lo_element, "Location", pstr_result.location_description)
		if not isnull(pstr_result.result_sequence) then add_element( lo_element, "result_definition_id", string(pstr_result.result_sequence))
		if not isnull(pstr_result.result_date_time) then add_element( lo_element, "ResultDate", xml_date_time(pstr_result.result_date_time))
		if len(pstr_result.result_type) > 0 then add_element( lo_element, "ResultType", pstr_result.result_type)
		if len(pstr_result.result) > 0 then add_element( lo_element, "Result", pstr_result.result)
		if len(pstr_result.result_value) > 0 then add_element( lo_element, "ResultValue", pstr_result.result_value)
		if len(pstr_result.result_unit) > 0 then add_unit( lo_element, "ResultUnit", pstr_result.result_unit)
		if len(pstr_result.abnormal_flag) > 0 then add_element( lo_element, "AbnormalFflag", pstr_result.abnormal_flag)
		if len(pstr_result.abnormal_nature) > 0 then add_element( lo_element, "AbnormalNature", pstr_result.abnormal_nature)
		if not isnull(pstr_result.severity) then add_element( lo_element, "Severity", string(pstr_result.severity))
		if len(pstr_result.observed_by) > 0 then add_actor( lo_element, "ObservedBy", pstr_result.observed_by)
		if len(pstr_result.normal_range) > 0 then add_element( lo_element, "ReferenceRange", pstr_result.normal_range)
		add_element( lo_element, "ResultStatus", "F")
	CATCH (throwable lo_error)
		log.log(this, "create_xml()", "Error adding result elements (" + lo_error.text + ")", 4)
		return -1
	END TRY
end if

if len(ps_attribute_name) > 0 and not isnull(ps_attribute_value) then
	lo_element.setattribute(ps_attribute_name, ps_attribute_value)
end if

po_parent_element.addcontent(lo_element)

return 1

end function

public function integer add_observation_result (pbdom_element po_parent_element, string ps_cpr_id, long pl_object_key, string ps_context_object, string ps_tag, string ps_observation_id, integer pi_result_sequence, string ps_result_type, date pd_observation_date, string ps_result_unit, boolean pb_formatted, boolean pb_amount_only, boolean pb_display_location, boolean pb_display_unit, string ps_attribute_name, string ps_attribute_value);str_p_observation_result lstr_results[]
integer li_sts
long ll_result_count
long i
long ll_idx

// First add the results for this observation
ll_result_count = datalist.clinical_data_cache.get_results(ps_cpr_id, &
															ps_context_object, &
															pl_object_key, &
															ps_observation_id, &
															pi_result_sequence, &
															ps_result_type, &
															lstr_results)


ll_idx = 0

if isnull(pd_observation_date) then
	ll_idx = ll_result_count
else
	for i = 1 to ll_result_count
		if date(lstr_results[i].result_date_time) <= pd_observation_date then
			ll_idx = i
		else
			exit
		end if
	next
end if

if ll_idx > 0 then
	add_observation_result( po_parent_element, &
									ps_tag, &
									lstr_results[ll_idx], &
									ps_result_unit, &
									pb_formatted, &
									pb_amount_only, &
									pb_display_location, &
									pb_display_unit, &
									ps_attribute_name, &
									ps_attribute_value )
end if




return 1

end function

public function boolean if_observation_result (string ps_cpr_id, long pl_object_key, string ps_context_object, string ps_observation_id, integer pi_result_sequence, string ps_result_type, date pd_observation_date, string ps_result_unit, string ps_operation, string ps_from_value, string ps_to_value);str_p_observation_result lstr_get_results[]
str_p_observation_result lstr_results[]
integer li_sts
long ll_get_result_count
long ll_result_count
long i

// First add the results for this observation
ll_get_result_count = datalist.clinical_data_cache.get_results(ps_cpr_id, &
															ps_context_object, &
															pl_object_key, &
															ps_observation_id, &
															pi_result_sequence, &
															ps_result_type, &
															lstr_get_results)


ll_result_count = 0

// if we have an observation date then remove any results not on that date
if isnull(pd_observation_date) then
	ll_result_count = ll_get_result_count
	lstr_results = lstr_get_results
else
	for i = 1 to ll_result_count
		if date(lstr_get_results[i].result_date_time) <= pd_observation_date then
			ll_result_count++
			lstr_results[ll_result_count] = lstr_get_results[i]
		else
			exit
		end if
	next
end if

// If we didn't find any result to match the criteria, then always return false
if ll_result_count <= 0 then return false

CHOOSE CASE lower(ps_operation)
	CASE "exists"
		return true
	CASE "any normal"
		// If any qualifying result is normal, return true
		for i = 1 to ll_result_count
			if upper(lstr_results[i].abnormal_flag) = "N" then return true
		next
	CASE "all normal"
		// If any qualifying result is normal, return true
		for i = 1 to ll_result_count
			if upper(lstr_results[i].abnormal_flag) <> "N" then return false
		next
		return true
	CASE "any abnormal"
		// If any qualifying result is abnormal, return true
		for i = 1 to ll_result_count
			if upper(lstr_results[i].abnormal_flag) = "Y" then return true
		next
	CASE "all abnormal"
		// If any qualifying result is abnormal, return true
		for i = 1 to ll_result_count
			if upper(lstr_results[i].abnormal_flag) <> "Y" then return true
		next
		return true
	CASE "=", "<", "<=", ">", ">="
		for i = 1 to ll_result_count
			if f_compare_result(lstr_results[i], ps_result_unit, ps_operation, ps_from_value) then return true
		next
	CASE "is between"
		for i = 1 to ll_result_count
			if f_compare_result(lstr_results[i], ps_result_unit, ">=", ps_from_value) &
			 AND f_compare_result(lstr_results[i], ps_result_unit, "<=", ps_to_value) then return true
		next
	CASE ELSE
		return false
END CHOOSE


return false


end function

public function integer add_observation (pbdom_element po_parent_element, string ps_cpr_id, long pl_object_key, string ps_context_object, string ps_tag, string ps_observation_id, integer pi_result_sequence, string ps_result_type, date pd_observation_date);str_p_observation_result lstr_results[]
integer li_sts
string ls_value
PBDOM_Element lo_element
long ll_result_count
long ll_child_count
if isnull(ps_tag) or trim(ps_tag) = "" then ps_tag = "Observation"
long i
string ls_null

setnull(ls_null)

lo_element = CREATE PBDOM_Element
lo_element.setname(ps_tag)

// First add the results for this observation
ll_result_count = datalist.clinical_data_cache.get_results(ps_cpr_id, &
															ps_context_object, &
															pl_object_key, &
															ps_observation_id, &
															pi_result_sequence, &
															ps_result_type, &
															lstr_results)


for i = 1 to ll_result_count
	// If we have a property date then only add results found on that date
	if isnull(pd_observation_date) OR pd_observation_date = date(lstr_results[i].result_date_time) then
		add_observation_result( lo_element, &
										"Result", &
										lstr_results[i], &
										ls_null, &
										false, &
										false, &
										false, &
										true, &
										ls_null, &
										ls_null)
	end if
next


// Then add the branch if there were any results found

if ll_result_count > 0 or ll_child_count > 0 then
	po_parent_element.addcontent(lo_element)
end if

return 1

end function

private function integer add_task (pbdom_element po_parent_element, string ps_tag, long pl_patient_workplan_item_id, str_context pstr_context);string ls_value
PBDOM_Element lo_element
PBDOM_Element lo_element2
PBDOM_Element lo_element3
PBDOM_Element lo_element4
string ls_null
string ls_hexbinary
setnull(ls_null)
long ll_encounter_id
long ll_treatment_id
long ll_problem_id
long ll_attachment_id
string ls_item_type
string ls_ordered_service
string ls_ordered_treatment_type
long ll_ordered_workplan_id
string ls_ordered_by
string ls_ordered_for
string ls_owned_by
string ls_dispatch_method
string ls_description
string ls_status
string ls_id
string ls_item_key
string ls_purpose
str_attributes lstr_attributes
long ll_count
long i

u_ds_data luo_data

setnull(ls_null)

lo_element = add_element(po_parent_element, ps_tag, "")
lo_element.setattribute("PatientWorkplanItemID", string(pl_patient_workplan_item_id))


SELECT	encounter_id,
			treatment_id,
			item_type,
			ordered_service,
			ordered_treatment_type,
			ordered_workplan_id,
			ordered_by,
			ordered_for,
			owned_by,
			dispatch_method,
			description,
			status,
			CAST(id AS varchar(38))
INTO   :ll_encounter_id,
		:ll_treatment_id,
		:ls_item_type,
		:ls_ordered_service,
		:ls_ordered_treatment_type,
		:ll_ordered_workplan_id,
		:ls_ordered_by,
		:ls_ordered_for,
		:ls_owned_by,
		:ls_dispatch_method,
		:ls_description,
		:ls_status,
		:ls_id
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = :pl_patient_workplan_item_id;
If not tf_check() Then Return -1

// Check to make sure everything looks right
// First, did we find a workplan item
if sqlca.sqlcode = 100 then
	log.log(this, "add_task()", "Workplan Item Record not found (" + string(pl_patient_workplan_item_id) + ")", 4)
	return -1
end if

luo_data = CREATE u_ds_data
luo_data.set_dataobject( "dw_p_patient_wp_item_attribute")
ll_count = luo_data.retrieve(pl_patient_workplan_item_id)
if ll_count < 0 then return -1

f_attribute_ds_to_str(luo_data, lstr_attributes)

CHOOSE CASE lower(ls_item_type)
	CASE "service"
		ls_item_key = ls_ordered_service
	CASE "treatment"
		ls_item_key = ls_ordered_treatment_type
	CASE "workplan"
		ls_item_key = string(ll_ordered_workplan_id)
	CASE "document"
		ls_item_key = f_attribute_find_attribute(lstr_attributes, "report_id")
	CASE ELSE
END CHOOSE

ls_purpose = f_attribute_find_attribute(lstr_attributes, "Purpose")

lo_element2 = add_element(lo_element, "ItemType", ls_item_type)
lo_element2 = add_element(lo_element, "ItemKey", ls_item_key)
lo_element2 = add_element(lo_element, "ContextObject", pstr_context.context_object)
lo_element2 = add_element(lo_element, "ObjectKey", string(pstr_context.object_key))
lo_element2 = add_element(lo_element, "Description", ls_description)
lo_element2 = add_element(lo_element, "Purpose", ls_purpose)

add_actor(lo_element, "OrderedBy", ls_ordered_by)
add_actor(lo_element, "OrderedFor", ls_ordered_for)
add_actor(lo_element, "OwnedBy", ls_owned_by)

lo_element2 = add_element(lo_element, "DispatchMethod", ls_dispatch_method)
lo_element2 = add_element(lo_element, "Status", ls_status)
lo_element2 = add_element(lo_element, "ID", ls_id)

lo_element2 = add_element(lo_element, "Attributes", ls_null)
for i = 1 to lstr_attributes.attribute_count
	lo_element3 = add_element(lo_element2, "Attribute", ls_null)
	lo_element4 = add_element(lo_element3, "Attribute", lstr_attributes.attribute[i].attribute)
	lo_element4 = add_element(lo_element3, "Value", lstr_attributes.attribute[i].value)
next


return 1

end function

private function integer add_datafile (pbdom_element po_parent_element, string ps_tag, str_patient_material pstr_material);string ls_value
PBDOM_Element lo_element
PBDOM_Element lo_element2
PBDOM_Element lo_element3
string ls_null
string ls_hexbinary
setnull(ls_null)

lo_element = add_element(po_parent_element, ps_tag, "")
lo_element.setattribute("MaterialID", string(pstr_material.material_id))

lo_element2 = add_element(lo_element, "ID", pstr_material.id)
lo_element2 = add_element(lo_element, "Version", string(pstr_material.version))
lo_element2 = add_element(lo_element, "Title", pstr_material.title)
lo_element2 = add_element(lo_element, "Attribute", pstr_material.attribute)
lo_element2 = add_element(lo_element, "Category", pstr_material.category_description)
lo_element2 = add_element(lo_element, "FileName", pstr_material.filename)
lo_element2 = add_element(lo_element, "FileType", pstr_material.extension)
lo_element2 = add_element(lo_element, "Created", string(pstr_material.created))
lo_element2 = add_element(lo_element, "OwnerID", string(pstr_material.owner_id))


if len(pstr_material.material_object) > 0 then
	ls_hexbinary = common_thread.eprolibnet4.convertbinarytohex(pstr_material.material_object)
	if isnull(ls_hexbinary) or len(ls_hexbinary) = 0 then
		log.log(this, "add_datafile()", "Error converting file data to hexbinary (" + string(pstr_material.material_id) + ")", 4)
		return -1
	end if
	lo_element2 = add_element(lo_element, "MaterialData", ls_hexbinary)
elseif len(pstr_material.url) > 0 then
	lo_element2 = add_element(lo_element, "MaterialURL", pstr_material.url)
else
	log.log(this, "add_datafile()", "Material has no data and no URL (" + string(pstr_material.material_id) + ")", 4)
	return -1
end if

return 1


end function

private function integer add_systemsettings (pbdom_element po_parent_element, string ps_tag, long pl_patient_workplan_item_id, str_context pstr_context);string ls_value
PBDOM_Element lo_element
PBDOM_Element lo_element2
PBDOM_Element lo_element3
PBDOM_Element lo_element4
string ls_null
string ls_hexbinary
setnull(ls_null)
long ll_encounter_id
long ll_treatment_id
long ll_problem_id
long ll_attachment_id
string ls_item_type
string ls_ordered_service
string ls_ordered_treatment_type
long ll_ordered_workplan_id
string ls_ordered_by
string ls_ordered_for
string ls_owned_by
string ls_dispatch_method
string ls_description
string ls_status
string ls_id
string ls_item_key
string ls_purpose
str_attributes lstr_attributes
long ll_count
long i

u_ds_data luo_data

setnull(ls_null)

lo_element = add_element(po_parent_element, ps_tag, "")

if not isnull(main_window) and isvalid(main_window) then
	lo_element2 = add_element(lo_element, "ScreenSettings", "")
	lo_element3 = add_element(lo_element2, "MainWindowX", string(main_window.x))
	lo_element3 = add_element(lo_element2, "MainWindowY", string(main_window.y))
	lo_element3 = add_element(lo_element2, "MainWindowWidth", string(main_window.width))
	lo_element3 = add_element(lo_element2, "MainWindowHeight", string(main_window.height))
	lo_element3 = add_element(lo_element2, "MainWindowBackgroundColor", string(main_window.backcolor ))
end if

lo_element2 = add_element(lo_element, "Caller", "EncounterPRO")
lo_element2 = add_element(lo_element, "CallerVersion", f_app_version())
lo_element2 = add_element(lo_element, "DatabaseModLevel", string(sqlca.modification_level))
lo_element2 = add_element(lo_element, "CustomerID", string(sqlca.customer_id))
lo_element2 = add_element(lo_element, "OfficeID", office_id)

add_actor(lo_element, "CurrentUser", current_user.user_id)
add_actor(lo_element, "CurrentScribe", current_scribe.user_id)

lo_element2 = add_element(lo_element, "ComputerID", string(computer_id))

return 1

end function

public function integer create_xml_from_attributes (string ps_root_element, str_context pstr_context, str_attributes pstr_attributes, ref string ps_xml);long i
integer li_sts
string ls_temp
pbdom_element lo_element

document_attributes = pstr_attributes

if isnull(ps_root_element) or trim(ps_root_element) = "" then
	ps_root_element = f_attribute_find_attribute(document_attributes, "root_element")
end if

// set the reader_user_id to the current user if it's not already set to a valid value
if not user_list.is_user(reader_user_id) and not user_list.is_role(reader_user_id) then
	reader_user_id = current_user.user_id
end if

// Initialize the last_context structure
last_context = f_get_complete_context_from_attributes(pstr_attributes)

if isnull(ps_root_element) or trim(ps_root_element) = "" then
	ps_root_element = "ComponentAttributes"
end if

// we can't have spaces in the element name so remove them	
ps_root_element = f_string_substitute(ps_root_element, " ", "")

TRY
	xml_document = CREATE PBDOM_Document
	xml_document.newdocument(ps_root_element)
	current_element = xml_document.Getrootelement()
CATCH (throwable lo_error)
	log.log(this, "create_xml()", "Error creating document (" + lo_error.text + ")", 4)
	return -1
END TRY

// Double check here that we have a valid document and current element
if isnull(xml_document) or not isvalid(xml_document) then
	log.log(this, "create_xml()", "Invalid document", 4)
	return -1
end if

if isnull(current_element) or not isvalid(current_element) then
	log.log(this, "create_xml()", "Invalid current element", 4)
	return -1
end if

// Add the attribute elements
for i = 1 to pstr_attributes.attribute_count
	lo_element = add_element(current_element, "Attribute", pstr_attributes.attribute[i].value)
	lo_element.setattribute("name",  pstr_attributes.attribute[i].attribute)
next

ps_xml = f_xml_document_string(xml_document)

return 1

end function

public function integer create_xml (long pl_patient_workplan_item_id, long pl_xml_script_id, string ps_root_element, str_context pstr_context, str_attributes pstr_attributes, str_patient_materials pstr_materials, ref u_xml_document po_xml);long i
long ll_set
integer li_sts
string ls_temp
pbdom_element lo_element
string ls_document_field_map
long ll_attribute_sequence
blob lbl_field_map
string ls_report_id
long ll_mapping_item_count
string lsa_mapping_item[]
string ls_element
string ls_property
str_property_value lstr_property_value
string ls_formfield
str_document_elements lstr_document_elements
string ls_beginning

// See if we have a document field map
setnull(ls_document_field_map)
ls_report_id = f_attribute_find_attribute(pstr_attributes, "report_id")
if len(ls_report_id) > 0 then
	// If we have a field mapping it might be bigger than 255 characters so get the big version
	// from the c_Report_Attribute table
	SELECT max(attribute_sequence)
	INTO :ll_attribute_sequence
	FROM c_Report_Attribute
	WHERE report_id = :ls_report_id
	AND attribute = 'document_field_map'
	AND DATALENGTH(objectdata) > 0;
	if not tf_check() then return -1
	
	if ll_attribute_sequence > 0 then
		SELECTBLOB objectdata
		INTO :lbl_field_map
		FROM c_Report_Attribute
		WHERE report_id = :ls_report_id
		AND attribute_sequence = :ll_attribute_sequence;
		if not tf_check() then return -1
		
		ls_document_field_map = f_blob_to_string(lbl_field_map)
	end if
end if

document_attributes = pstr_attributes

if isnull(ps_root_element) or trim(ps_root_element) = "" then
	ps_root_element = f_attribute_find_attribute(document_attributes, "root_element")
end if

// set the reader_user_id to the current user if it's not already set to a valid value
if not user_list.is_user(reader_user_id) and not user_list.is_role(reader_user_id) then
	reader_user_id = current_user.user_id
end if

// Initialize the last_context structure
last_context = f_get_complete_context_from_attributes(pstr_attributes)

if (isnull(ps_root_element) or trim(ps_root_element) = "") and pl_xml_script_id > 0 then
	SELECT COALESCE(default_root_element, display_script)
	INTO :ps_root_element
	FROM c_Display_Script
	WHERE display_script_id = :pl_xml_script_id;
	if not tf_check() then return -1
end if

if (isnull(ps_root_element) or trim(ps_root_element) = "") then
	ps_root_element = "JMJ"
end if

// we can't have spaces in the element name so remove them	
ps_root_element = f_string_substitute(ps_root_element, " ", "")

TRY
	xml_document = CREATE PBDOM_Document
	xml_document.newdocument(ps_root_element)
	current_element = xml_document.Getrootelement()
CATCH (throwable lo_error)
	log.log(this, "create_xml()", "Error creating document (" + lo_error.text + ")", 4)
	return -1
END TRY

// Double check here that we have a valid document and current element
if isnull(xml_document) or not isvalid(xml_document) then
	log.log(this, "create_xml()", "Invalid document", 4)
	return -1
end if

if isnull(current_element) or not isvalid(current_element) then
	log.log(this, "create_xml()", "Invalid current element", 4)
	return -1
end if

// Create the actors parent element
actors_element = CREATE PBDOM_Element
actors_element.setname("Actors")
current_element.addcontent(actors_element)

// Add the Task block
if not isnull(pl_patient_workplan_item_id) then
	li_sts = add_task( current_element, &
							"Task", &
							pl_patient_workplan_item_id, &
							pstr_context)
	if li_sts < 0 then
		log.log(this, "create_xml()", "Error adding task block", 4)
		return -1
	end if
end if

li_sts = add_systemsettings( current_element, &
						"SystemSettings", &
						pl_patient_workplan_item_id, &
						pstr_context)
if li_sts < 0 then
	log.log(this, "create_xml()", "Error adding task block", 4)
	return -1
end if

// Scan the attributes for materials and add the file data
for i = 1 to pstr_materials.material_count
	li_sts = add_datafile(current_element, "DataFile", pstr_materials.material[i])
next

// Add the data element
current_element = add_element(current_element, "Data", "")

// If there are field mappings, then add them now
if len(ls_document_field_map) > 0 then
	// See if it's XML data
	ls_beginning = left(trim(ls_document_field_map), 8)
	if pos(ls_beginning, "<") > 0 and (pos(ls_document_field_map, "</") > 0 or pos(ls_document_field_map, "/>") > 0) then
		// Convert the previous mapping to structures
		li_sts = f_get_document_elements_from_xml(ls_document_field_map, lstr_document_elements)
		if li_sts < 0 then
			log.log(this, "create_xml()", "Unable to read document element mappings", 4)
		else
			// Transfer any previous mappings to the new mapping
			for ll_set = 1 to lstr_document_elements.element_set_count
				for i = 1 to lstr_document_elements.element_set[ll_set].element_count
					ls_formfield = lstr_document_elements.element_set[ll_set].element[i].element
					if len(ls_formfield) > 0 then
						lstr_property_value = f_resolve_field_mapping(lstr_document_elements.element_set[ll_set].element[i], &
																					f_get_complete_context(), &
																					pstr_attributes)
						if len(lstr_property_value.display_value) > 0 then
							ls_element = "DataElement"
							lo_element = add_element(current_element, ls_element, lstr_property_value.display_value)
							lo_element.setattribute("FormField", ls_formfield)
							if len(lstr_property_value.value) > 0 then
								lo_element.setattribute("value", lstr_property_value.value)
							end if
							if len(lstr_property_value.datatype) > 0 then
								lo_element.setattribute("datatype", lstr_property_value.datatype)
							end if
							if len(lstr_property_value.filetype) > 0 then
								lo_element.setattribute("filetype", lstr_property_value.filetype)
							end if
							if len(lstr_property_value.encoding) > 0 then
								lo_element.setattribute("encoding", lstr_property_value.encoding)
							end if
						end if
					end if
				next
			next
		end if
	end if
end if

// If there is an XML Script, execute it now
if pl_xml_script_id > 0 then
	
	// Initialize the Actors element
	setnull(actors_element)
	setnull(config_element)
	setnull(last_config_element)
	config_object_count = 0
	actor_count = 0
	nested = false
	
	li_sts = create_xml(pl_xml_script_id, current_element, pstr_context.cpr_id, pstr_context.context_object, pstr_context.object_key)
	if li_sts <= 0 then return -1
end if

po_xml = CREATE u_xml_document
li_sts = po_xml.initialize(xml_document)
if li_sts < 0 then return -1

return 1

end function

public function integer create_xml (string ps_xml_class, str_attributes pstr_attributes, ref u_xml_document po_xml);integer li_sts
string ls_temp
long ll_xml_script_id
string ls_root_element
str_c_xml_class lstr_xml_class

document_attributes = pstr_attributes

ls_root_element = f_attribute_find_attribute(document_attributes, "root_element")

if isnull(ps_xml_class) then
	log.log(this, "create_xml()", "No xml_class attribute found", 4)
	return -1
else
	lstr_xml_class = datalist.get_xml_class(ps_xml_class)
	if isnull(lstr_xml_class.xml_class) then
		log.log(this, "create_xml()", "XML class not found (" + ps_xml_class + ")", 4)
		return -1
	end if
	if isnull(ls_root_element) then ls_root_element = lstr_xml_class.root_element
	ll_xml_script_id = lstr_xml_class.creator_display_script_id
end if


// Don't do anything if we don't have a display_script_id
if isnull(ll_xml_script_id) then return 0

// set the reader_user_id to the current user if it's not already set to a valid value
if not user_list.is_user(reader_user_id) and not user_list.is_role(reader_user_id) then
	reader_user_id = current_user.user_id
end if

// Initialize the last_context structure
last_context = f_get_complete_context_from_attributes(pstr_attributes)

if isnull(ls_root_element) or trim(ls_root_element) = "" then
	SELECT COALESCE(default_root_element, display_script)
	INTO :ls_root_element
	FROM c_Display_Script
	WHERE display_script_id = :ll_xml_script_id;
	if not tf_check() then return -1
end if

// we can't have spaces in the element name so remove them	
ls_root_element = f_string_substitute(ls_root_element, " ", "")

TRY
	xml_document = CREATE PBDOM_Document
	xml_document.newdocument(ls_root_element)
	current_element = xml_document.Getrootelement()
CATCH (throwable lo_error)
	log.log(this, "create_xml()", "Error creating document (" + lo_error.text + ")", 4)
	return -1
END TRY

// Double check here that we have a valid document and current element
if isnull(xml_document) or not isvalid(xml_document) then
	log.log(this, "create_xml()", "Invalid document", 4)
	return -1
end if

if isnull(current_element) or not isvalid(current_element) then
	log.log(this, "create_xml()", "Invalid current element", 4)
	return -1
end if

// Initialize the Actors element
setnull(actors_element)
setnull(config_element)
setnull(last_config_element)
config_object_count = 0
actor_count = 0
nested = false

li_sts = create_xml(ll_xml_script_id, current_element)
if li_sts <= 0 then return -1

po_xml = CREATE u_xml_document
li_sts = po_xml.initialize(xml_document)
if li_sts < 0 then return -1

return 1

end function

public function integer create_xml (long pl_xml_script_id, str_attributes pstr_attributes, ref u_xml_document po_xml);integer li_sts
string ls_temp
string ls_root_element

document_attributes = pstr_attributes

ls_root_element = f_attribute_find_attribute(document_attributes, "root_element")

if isnull(pl_xml_script_id) or pl_xml_script_id <= 0 then
	log.log(this, "create_xml()", "No XML script", 4)
	return -1
end if


// set the reader_user_id to the current user if it's not already set to a valid value
if not user_list.is_user(reader_user_id) and not user_list.is_role(reader_user_id) then
	reader_user_id = current_user.user_id
end if

// Initialize the last_context structure
last_context = f_get_complete_context_from_attributes(pstr_attributes)

if isnull(ls_root_element) or trim(ls_root_element) = "" then
	SELECT COALESCE(default_root_element, display_script)
	INTO :ls_root_element
	FROM c_Display_Script
	WHERE display_script_id = :pl_xml_script_id;
	if not tf_check() then return -1
end if

// we can't have spaces in the element name so remove them	
ls_root_element = f_string_substitute(ls_root_element, " ", "")

TRY
	xml_document = CREATE PBDOM_Document
	xml_document.newdocument(ls_root_element)
	current_element = xml_document.Getrootelement()
CATCH (throwable lo_error)
	log.log(this, "create_xml()", "Error creating document (" + lo_error.text + ")", 4)
	return -1
END TRY

// Double check here that we have a valid document and current element
if isnull(xml_document) or not isvalid(xml_document) then
	log.log(this, "create_xml()", "Invalid document", 4)
	return -1
end if

if isnull(current_element) or not isvalid(current_element) then
	log.log(this, "create_xml()", "Invalid current element", 4)
	return -1
end if

// Initialize the Actors element
setnull(actors_element)
setnull(config_element)
setnull(last_config_element)
config_object_count = 0
actor_count = 0
nested = false

li_sts = create_xml(pl_xml_script_id, current_element)
if li_sts <= 0 then return -1

po_xml = CREATE u_xml_document
li_sts = po_xml.initialize(xml_document)
if li_sts < 0 then return -1

return 1

end function

on u_xml_script.create
end on

on u_xml_script.destroy
end on

