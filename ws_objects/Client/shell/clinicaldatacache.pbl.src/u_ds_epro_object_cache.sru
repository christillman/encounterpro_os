$PBExportHeader$u_ds_epro_object_cache.sru
forward
global type u_ds_epro_object_cache from u_ds_data
end type
type str_treatment_type_treatment_key_field from structure within u_ds_epro_object_cache
end type
type str_exception_property from structure within u_ds_epro_object_cache
end type
end forward

type str_treatment_type_treatment_key_field from structure
	string		treatment_type
	string		treatment_key_field
end type

type str_exception_property from structure
	string		property_name
	string		property_datatype
	long		cache_column_length
	string		property_select_column
end type

global type u_ds_epro_object_cache from u_ds_data
end type
global u_ds_epro_object_cache u_ds_epro_object_cache

type variables
private str_epro_object_definition epro_object
private str_epro_object_definition parent_epro_object
private string reference_object_key
//private str_complete_context current_context
private string current_key_value
private string current_key_field
private str_edas_which_object current_which_object

private boolean cache_valid
private time cache_timestamp
private long cache_row

private string select_columns
private string dw_syntax
private string where_clause
private string order_by_clause


private u_ds_data column_data

long max_cache_age = 6

private long property_count
private str_epro_object_property property[]

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// The virtual_table boolean indicates whether this cache represents an actual database table/view.  If
// not, then all fields must be handled by the appropriate edas_property_handler_xxxx method.
private boolean virtual_table

// The virtual_table_state is a way of passing in extra values from the "Object" property that refered
// to this virtual table.  The first value passed in is always the value of the Object property itself.
// Extra values may be specified in the referring property's [property_value_object_filter] column using the form:
//      %<EproObject>.<columnname>%[,%<EproObject>.<columnname>%][,%<EproObject>.<columnname>%]...
// The <EproObject> must match the parent object of the referring Object property.  The <columnname> is
// evaluated in the context of the referring object and may be an EDAS property in <EproObject> or a physical column in the
// corresponding physical table.
private string virtual_table_state
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

end variables

forward prototypes
public subroutine clear_cache ()
public function string apply_context (string ps_string, str_complete_context pstr_context)
public function integer initialize (str_epro_object_definition pstr_epro_object)
public function integer resolve_object_reference (string ps_reference_key_value, str_property_specification pstr_property, str_complete_context pstr_context, ref str_property_value pstr_referenced_object_key_value)
private function integer get_cache_property_value (string ps_property, str_complete_context pstr_context, ref str_property_value pstr_property_value)
public function integer edas_property_handler_root (string ps_property, ref str_property_value pstr_property_value)
public function integer edas_property_handler_address (string ps_property, ref str_property_value pstr_property_value)
public function integer edas_property_handler_amountunit (string ps_property, string ps_amount, string ps_unit_id, ref str_property_value pstr_property_value)
public function integer edas_property_handler_assessment (string ps_property, ref str_property_value pstr_property_value)
public function integer edas_property_handler_communication (string ps_property, ref str_property_value pstr_property_value)
public function integer edas_property_handler_drug (string ps_property, ref str_property_value pstr_property_value)
public function integer edas_property_handler_duration (string ps_property, string ps_amount, string ps_filter, ref str_property_value pstr_property_value)
public function integer edas_property_handler_patient (string ps_property, ref str_property_value pstr_property_value)
public function integer edas_property_handler_treatment (string ps_property, ref str_property_value pstr_property_value)
public function integer get_property_value (string ps_epro_object_key, str_property_specification pstr_property, str_complete_context pstr_context, ref str_property_value pstr_property_value)
public function integer edas_property_handler_datetime (string ps_property, string ps_datetime, ref str_property_value pstr_property_value)
private function integer get_cache_property_value_column (string ps_property, ref string ps_value)
public subroutine set_virtual_table_state (string ps_virtual_table_state)
public function integer edas_property_handler_attachment (string ps_property, str_complete_context pstr_context, ref str_property_value pstr_property_value)
private function integer get_cache_property_value_binary (long pl_property_index, ref blob pbl_value, ref string ps_filetype)
private function integer get_cache_property_value_text (long pl_property_index, ref string ps_value)
private function integer get_cache_property_value_column (long pl_property_index, ref string ps_value)
public function integer edas_property_handler_userstamp (string ps_property, ref str_property_value pstr_property_value)
public function integer edas_property_handler_number (string ps_property, string ps_number, ref str_property_value pstr_property_value)
public function integer edas_property_handler_string (string ps_property, string ps_string, ref str_property_value pstr_property_value)
public function integer edas_property_handler_boolean (string ps_property, string ps_flag, ref str_property_value pstr_property_value)
public function integer edas_property_handler_text (string ps_property, string ps_text, ref str_property_value pstr_property_value)
public function integer edas_property_handler_binary (string ps_property, string ps_data, ref str_property_value pstr_property_value)
public function integer edas_property_handler_gender (string ps_property, string ps_gender, ref str_property_value pstr_property_value)
public function integer edas_property_handler_drugadministration (string ps_property, ref str_property_value pstr_property_value)
public function integer edas_property_handler_trttypeselect (string ps_property, ref str_property_value pstr_property_value)
public function integer edas_property_handler_result (string ps_property, ref str_property_value pstr_property_value)
public function boolean is_table_query ()
public subroutine set_parent_epro_object (str_epro_object_definition pstr_parent_epro_object, string ps_reference_object_key)
end prototypes

public subroutine clear_cache ();cache_valid = false

end subroutine

public function string apply_context (string ps_string, str_complete_context pstr_context);string ls_new_string
string ls_value

ls_new_string = ps_string

if len(pstr_context.cpr_id) > 0 then
	ls_value = pstr_context.cpr_id
else
	ls_value = ""
end if
ls_new_string = f_string_substitute(ls_new_string, "%cpr_id%", ls_value)

if pstr_context.encounter_id > 0 then
	ls_value = string(pstr_context.encounter_id)
else
	ls_value = "0"
end if
ls_new_string = f_string_substitute(ls_new_string, "%encounter_id%", ls_value)

if pstr_context.problem_id > 0 then
	ls_value = string(pstr_context.problem_id)
else
	ls_value = "0"
end if
ls_new_string = f_string_substitute(ls_new_string, "%problem_id%", ls_value)

if pstr_context.treatment_id > 0 then
	ls_value = string(pstr_context.treatment_id)
else
	ls_value = "0"
end if
ls_new_string = f_string_substitute(ls_new_string, "%treatment_id%", ls_value)

if pstr_context.observation_sequence > 0 then
	ls_value = string(pstr_context.observation_sequence)
else
	ls_value = "0"
end if
ls_new_string = f_string_substitute(ls_new_string, "%observation_sequence%", ls_value)

if pstr_context.attachment_id > 0 then
	ls_value = string(pstr_context.attachment_id)
else
	ls_value = "0"
end if
ls_new_string = f_string_substitute(ls_new_string, "%attachment_id%", ls_value)

if pstr_context.customer_id > 0 then
	ls_value = string(pstr_context.customer_id)
else
	ls_value = "-1"
end if
ls_new_string = f_string_substitute(ls_new_string, "%customer_id%", ls_value)

if len(pstr_context.office_id) > 0 then
	ls_value = pstr_context.office_id
else
	ls_value = ""
end if
ls_new_string = f_string_substitute(ls_new_string, "%office_id%", ls_value)

if len(pstr_context.user_id) > 0 then
	ls_value = pstr_context.user_id
else
	ls_value = ""
end if
ls_new_string = f_string_substitute(ls_new_string, "%user_id%", ls_value)

if len(pstr_context.scribe_user_id) > 0 then
	ls_value = pstr_context.scribe_user_id
else
	ls_value = ""
end if
ls_new_string = f_string_substitute(ls_new_string, "%scribe_user_id%", ls_value)

if pstr_context.document_id > 0 then
	ls_value = string(pstr_context.document_id)
else
	ls_value = "0"
end if
ls_new_string = f_string_substitute(ls_new_string, "%document_id%", ls_value)

if pstr_context.service_id > 0 then
	ls_value = string(pstr_context.service_id)
else
	ls_value = "0"
end if
ls_new_string = f_string_substitute(ls_new_string, "%service_id%", ls_value)

if len(pstr_context.other_object_key_field) > 0 then
	if len(pstr_context.other_object_key_value) > 0 then
		ls_value = pstr_context.other_object_key_value
	else
		ls_value = ""
	end if
end if
ls_new_string = f_string_substitute(ls_new_string, "%" + pstr_context.other_object_key_field + "%", ls_value)


return ls_new_string

end function

public function integer initialize (str_epro_object_definition pstr_epro_object);long i, j
string ls_syntax
string ls_error_string
string ls_temp
integer li_sts
string ls_sql
long ll_linked_column_count
string lsa_linked_columns[]
string ls_column_list
string ls_error_create
string ls_this_columnname
long ll_column_count
str_complete_context lstr_context
string ls_from_table

epro_object = pstr_epro_object

setnull(current_key_field)
setnull(current_key_value)

// If we don't have a base table then we're done
if isnull(epro_object.base_tablename) or epro_object.base_tablename = "" then
	virtual_table = true
	return 1
else
	virtual_table = false
end if

column_data = CREATE u_ds_data
column_data.set_dataobject("dw_fn_epro_object_properties")
property_count = column_data.retrieve(epro_object.epro_object)
if property_count <= 0 then return -1

// Get the column list from the context table
ls_column_list = ""
ll_column_count = 0
for i = 1 to property_count
	property[i].property_type = column_data.object.property_type[i]
	property[i].property_column = column_data.object.property_column[i]
	property[i].property_name = column_data.object.property_name[i]
	property[i].property_datatype = lower(string(column_data.object.property_datatype[i]))
	property[i].property_formula = column_data.object.property_formula[i]
	property[i].cache_column_length = column_data.object.cache_column_length[i]
	property[i].property_id = column_data.object.property_id[i]
	property[i].exception = false
	
	property[i].property_select_expression = ""

	if lower(property[i].property_type) = "sql" then
		// Flag as an exception
		property[i].exception = true
	else
		// First calculate the SELECT expression
		if len(property[i].property_formula) > 0 then
			property[i].property_select_expression = property[i].property_formula
		elseif len(property[i].property_column) > 0 then
			property[i].property_select_expression = property[i].property_column
		else
			// If the property doesn't have a column or a formula, then flag as an exception
			property[i].exception = true
		end if
		
		// binary datatypes will be excluded from the SELECT list and retrieved when referenced
		if property[i].property_datatype = "binary" then
			// Flag as an exception
			property[i].exception = true
		end if
		
		// Text properties will only have a portion cached to the datastore.  If the actual data is longer then it will be retrieved from the database when it is referenced
		if property[i].property_datatype = "text" then
			if isnull(property[i].cache_column_length) or property[i].cache_column_length <= 0 then
				property[i].cache_column_length = 40
			end if
			property[i].property_select_expression = "CAST(" + property[i].property_select_expression + " AS varchar(" + string(property[i].cache_column_length) + "))"
			
			// Flag as an exception
			property[i].exception = true
		end if
		
	end if

	
	// Non-exceptions will map to columns in the datastore
	if len(property[i].property_select_expression) > 0 and property[i].property_datatype <> "binary" then
		ll_column_count++
		if len(ls_column_list) > 0 then ls_column_list += ", "
		ls_column_list += "[" + property[i].property_name + "]" + " = " + property[i].property_select_expression
		property[i].column_index = ll_column_count
	end if
next

select_columns = ls_column_list


ls_sql = "SELECT " + select_columns + " FROM "

// Supstitute zeros and empty strings for the context variables
ls_from_table = apply_context(epro_object.base_tablename, lstr_context)
ls_from_table = f_string_substitute(ls_from_table, '%object_identifier%', "")
ls_from_table = f_string_substitute(ls_from_table, "%reference_object_key%", "0")
ls_from_table = f_string_substitute(ls_from_table, "%parent_epro_object%", "")
ls_from_table = f_string_substitute(ls_from_table, "%" + epro_object.base_table_key_column + "%", "0")
ls_sql += ls_from_table + " a "

// Don't get any rows right now
ls_sql += " WHERE 1 = 2"

ls_syntax = sqlca.SyntaxFromSQL(ls_sql, "", ls_error_string)

if len(ls_error_string) > 0 then
	log.log(this, "u_ds_epro_object_cache.initialize:0111", "Error getting syntax: SQL=" + ls_sql + ", ERROR=" + ls_error_string, 4)
	return -1
end if

dw_syntax = ls_syntax

// Create the datastore
Create(dw_syntax, ls_error_create)
if Len(ls_error_create) > 0 THEN
	if isnull(ls_error_create) then ls_error_create = "<Null>"
	log.log(this, "u_ds_epro_object_cache.initialize:0121", "Error creating datastore (" + ls_error_create + ")", 4)
	return -1
end if


return 1

end function

public function integer resolve_object_reference (string ps_reference_key_value, str_property_specification pstr_property, str_complete_context pstr_context, ref str_property_value pstr_referenced_object_key_value);string ls_sql
integer li_sts
long ll_count
string ls_key_field
str_edas_which_object lstr_which_object
string ls_remainder
string ls_error_message
string ls_filter
string ls_where
string ls_clause
str_property_value lstr_display_value
str_property_value lstr_temp_value
string ls_from_table

// Get the field that the ps_reference_key_value refers to
ls_key_field = pstr_property.property.property_value_object_key

// Set the which_object
if isnull(pstr_property.which_object.which_object_string) and not isnull(pstr_property.referenced_epro_object.default_which_object) then
	li_sts = f_edas_parse_which_object(pstr_property.referenced_epro_object.default_which_object, &
																	lstr_which_object, &
																	ls_remainder, &
																	ls_error_message)
	if li_sts < 0 then
		log.log(this, "u_ds_epro_object_cache.resolve_object_reference:0025", "Error parsing default which_object string (" + pstr_property.referenced_epro_object.default_which_object + "): " + ls_error_message, 4)
		return -1
	end if
else
	lstr_which_object = pstr_property.which_object
end if

if isnull(ls_key_field) then
	return -1
end if

if isnull(ps_reference_key_value) then
	return -1
end if

// See if everything matches the last query
if rowcount() > 0 then
	if secondsafter(cache_timestamp, now()) > max_cache_age then
		cache_valid = false
	elseif isnull(current_key_field) then
		cache_valid = false
	elseif isnull(current_key_value) then
		cache_valid = false
	elseif lower(current_key_field) <> lower(ls_key_field) then
		cache_valid = false
	elseif current_key_value <> ps_reference_key_value then
		cache_valid = false
	elseif not f_string_compare(current_which_object.object_identifier, pstr_property.which_object.object_identifier, "=") then
		cache_valid = false
	elseif not f_string_compare(current_which_object.filter_statement, pstr_property.which_object.filter_statement, "=") then
		cache_valid = false
	end if
else
	// if we don't have a row, then we must not be valid
	cache_valid = false
end if

// if the cache is valid then just return
if cache_valid then
	ll_count = rowcount()
	if ll_count < 0 then return -1
	if ll_count = 0 then cache_valid = false
end if

if virtual_table then
	// Save the property_value_object_filter as it maintains the state of the virtual object
	virtual_table_state = apply_context(pstr_property.property.property_value_object_filter, pstr_context)

	current_key_field = ls_key_field
	current_key_value = ps_reference_key_value
	current_which_object = pstr_property.which_object

	cache_timestamp = now()
	cache_valid = true
elseif not cache_valid then
	ls_sql = "SELECT " + select_columns + " FROM "
	
	// Supstitute the context variables
	ls_from_table = epro_object.base_tablename
	if len(ps_reference_key_value) > 0 then
		ls_from_table = f_string_substitute(ls_from_table, "%" + epro_object.base_table_key_column + "%", ps_reference_key_value)
	else
		ls_from_table = f_string_substitute(ls_from_table, "%" + epro_object.base_table_key_column + "%", "0")
	end if
	if len(reference_object_key) > 0 then
		ls_from_table = f_string_substitute(ls_from_table, "%reference_object_key%", reference_object_key)
	else
		ls_from_table = f_string_substitute(ls_from_table, "%reference_object_key%", "0")
	end if
	ls_from_table = f_string_substitute(ls_from_table, "%parent_epro_object%", parent_epro_object.epro_object)
	ls_from_table = apply_context(ls_from_table, pstr_context)
	if len(lstr_which_object.object_identifier) > 0 then
		ls_from_table = f_string_substitute(ls_from_table, '%object_identifier%', lstr_which_object.object_identifier)
	else
		ls_from_table = f_string_substitute(ls_from_table, '%object_identifier%', "")
	end if
		
	ls_sql += ls_from_table + " a "

	ls_where = ""
	
	// If the table is really a query then assume that the query takes care of limiting the record set to the referenced key and don't add the reference key to the where clause
	if not is_table_query() then
		if len(ps_reference_key_value) > 0 then
			if len(ls_where) > 0 then ls_where += " AND "
			ls_where += "(a." + ls_key_field + " = '" + ps_reference_key_value + "')"
		end if
	end if
	
	ls_clause = apply_context(pstr_property.referenced_epro_object.base_table_filter, pstr_context)
	if len(ls_clause) > 0 then
		if len(ls_where) > 0 then ls_where += " AND "
		ls_where += "(" + ls_clause + ")"
	end if
	
	ls_clause = apply_context(pstr_property.property.property_value_object_filter, pstr_context)
	if len(ls_clause) > 0 then
		if len(ls_where) > 0 then ls_where += " AND "
		ls_where += "(" + ls_clause + ")"
	end if
	
	if len(lstr_which_object.object_identifier) > 0 and len(pstr_property.property.property_value_object_cat_fld) > 0 then
		ls_clause = ""
		if pos(pstr_property.property.property_value_object_cat_fld, " ") = 0 &
		  and pos(pstr_property.property.property_value_object_cat_fld, "=") = 0 then
			// Use the <field> = <value> syntax
			ls_clause = pstr_property.property.property_value_object_cat_fld + " = '" + lstr_which_object.object_identifier + "'"
		else
			// If there is any puncuation or spaces in cat_field, then assume the field contains a complete clause and that we need to substitute
			// in the value
			ls_clause = apply_context(pstr_property.property.property_value_object_cat_fld, pstr_context)
			ls_clause = f_string_substitute(ls_clause, '%object_identifier%', lstr_which_object.object_identifier)
		end if
		if len(ls_clause) > 0 then
			if len(ls_where) > 0 then ls_where += " AND "
			ls_where += "(" + ls_clause + ")"
		end if
	end if
	
	where_clause = ls_where
	
	if len(pstr_property.referenced_epro_object.base_table_sort) > 0 then
		order_by_clause = pstr_property.referenced_epro_object.base_table_sort
	else
		order_by_clause = ""
	end if

	if len(where_clause) > 0 then
		ls_sql += " WHERE " + where_clause
	end if

	if len(order_by_clause) > 0 then
		ls_sql += " ORDER BY " + order_by_clause
	end if

	settransobject(sqlca)
	setsqlselect(ls_sql)
	
	// Now apply the which_object spec
	ls_filter = ""
	ls_clause = apply_context(lstr_which_object.filter_statement, pstr_context)
	if len(ls_clause) > 0 then
		if len(ls_filter) > 0 then ls_filter += " and "
		ls_filter += "(" + ls_clause + ")"
	end if
	setfilter(ls_filter)
	
	ll_count = retrieve()
	if ll_count < 0 then return -1
	if ll_count = 0 then return 0

	current_key_field = ls_key_field
	current_key_value = ps_reference_key_value
	current_which_object = pstr_property.which_object

	cache_timestamp = now()
	cache_valid = true
end if

if not virtual_table then
	// Populate the collection
	pstr_referenced_object_key_value.referenced_object_collection.object_key_count = ll_count
	for cache_row = 1 to ll_count
		li_sts = get_cache_property_value(pstr_property.referenced_epro_object.base_table_key_column, pstr_context, lstr_temp_value)
		if li_sts <= 0 then return li_sts
		pstr_referenced_object_key_value.referenced_object_collection.object_key[cache_row] = lstr_temp_value.value
	next
	
	// Now set the cache_row based on the desired ordinal and the recent set count
	if lstr_which_object.ordinal < 0 then
		// Always count backwards from the last instance
		cache_row = ll_count + lstr_which_object.ordinal + 1
	elseif lstr_which_object.ordinal > 0 then
		if lstr_which_object.recent_set_count <= ll_count then
			// There are enough rows to fill the "recent set", so count forwards from the first of the "recent set"
			cache_row = (ll_count - lstr_which_object.recent_set_count) + lstr_which_object.ordinal
		else
			// Either we don't have a "recent set" or there are not enough instances, so just count forwards from the first instance
			cache_row = lstr_which_object.ordinal
		end if
	else
		// If no ordinal is supplied then get the last record
		cache_row = ll_count
	end if
	
	if cache_row > ll_count or cache_row < 1 then
		// The ordinal asked for isn't in the range of available ordinals
		return 0
	end if
end if

// Get the value of the key column for the selected instance
li_sts = get_cache_property_value(pstr_property.referenced_epro_object.base_table_key_column, pstr_context, pstr_referenced_object_key_value)
if li_sts <= 0 then return li_sts

// Get the display value for the selected instance
if len(pstr_property.referenced_epro_object.default_display_property_name) > 0 then
	li_sts = get_cache_property_value(pstr_property.referenced_epro_object.default_display_property_name, pstr_context, lstr_display_value)
	if li_sts > 0 then
		pstr_referenced_object_key_value.display_value = lstr_display_value.value
	end if
end if

return 1



end function

private function integer get_cache_property_value (string ps_property, str_complete_context pstr_context, ref str_property_value pstr_property_value);string ls_temp
long i
string ls_null
integer li_column_id
string ls_value
string ls_coltype
long ll_pos
long ll_length
string ls_progress_type
string ls_progress_key
any la_value
integer li_sts
string ls_cpr_id
long ll_object_key
str_attributes lstr_attributes
long ll_property_index
string ls_filetype
string ls_encoding
blob lbl_value

setnull(ls_null)
setnull(ls_filetype)
setnull(ls_encoding)


// Fixed Properties
CHOOSE CASE lower(ps_property)
	CASE "objectordinal"
		pstr_property_value.value = string(cache_row)
		return 1
	CASE "objectname"
		pstr_property_value.value = epro_object.epro_object
		return 1
	CASE "objectdescription"
		pstr_property_value.value = epro_object.description
		return 1
	CASE "objecttype"
		pstr_property_value.value = epro_object.object_type
		return 1
	CASE "objecthelp"
		pstr_property_value.value = epro_object.object_help
		return 1
END CHOOSE

// See if we have a custom property handler for this property
CHOOSE CASE lower(epro_object.epro_object)
	CASE "address"
		li_sts = edas_property_handler_address( ps_property, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "amountunit"
		li_sts = edas_property_handler_amountunit( ps_property, &
																current_key_value, &
																virtual_table_state, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		else
			return 0
		end if
	CASE "assessment"
		li_sts = edas_property_handler_assessment( ps_property, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "attachment", "patientattachment", "encounterattachment", "assessmentattachment", "treatmentattachment", "resultattachment"
		li_sts = edas_property_handler_attachment( ps_property, &
																pstr_context, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "binary"
		li_sts = edas_property_handler_binary( ps_property, &
																current_key_value, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "boolean"
		li_sts = edas_property_handler_boolean( ps_property, &
																current_key_value, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "communication"
		li_sts = edas_property_handler_communication( ps_property, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "datetime"
		li_sts = edas_property_handler_datetime( ps_property, &
																current_key_value, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "drugadministration"
		li_sts = edas_property_handler_drugadministration( ps_property, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "duration"
		li_sts = edas_property_handler_duration( ps_property, &
																current_key_value, &
																virtual_table_state, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		else
			return 0
		end if
	CASE "formatteddate"
	CASE "formatteddatetime"
	CASE "formattedtime"
	CASE "gender"
		li_sts = edas_property_handler_gender( ps_property, &
																current_key_value, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "number"
		li_sts = edas_property_handler_number( ps_property, &
																current_key_value, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "patient"
		ls_cpr_id = object.cpr_id[cache_row]
		
		li_sts = edas_property_handler_patient( ps_property, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "result"
		li_sts = edas_property_handler_result( ps_property, &
															pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "root"
//		// First see if the property name matches a context variable
		ls_temp = apply_context("%" + ps_property + "%", pstr_context)
		if len(ls_temp) > 0 and left(ls_temp, 1) <> "%" then
			pstr_property_value.value = ls_temp
			return 1
		end if
		
		li_sts = edas_property_handler_root( ps_property, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "string"
		li_sts = edas_property_handler_string( ps_property, &
																current_key_value, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "text"
		li_sts = edas_property_handler_text( ps_property, &
																current_key_value, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "treatment"
		ls_cpr_id = object.cpr_id[cache_row]
		ll_object_key = object.treatment_id[cache_row]
		
		li_sts = edas_property_handler_treatment( ps_property, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "treatmenttypeselect"
		li_sts = edas_property_handler_trttypeselect( ps_property, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
	CASE "userstamp"
		li_sts = edas_property_handler_userstamp( ps_property, &
																pstr_property_value )
		if li_sts > 0 then
			return 1
		end if
END CHOOSE

// Find the property
ll_property_index = 0
for i = 1 to property_count
	if lower(ps_property) = lower(property[i].property_name) then
		ll_property_index = i
		exit
	end if
next

if ll_property_index > 0 then
	if property[i].exception then
		// Handle the exception
		CHOOSE CASE lower(property[ll_property_index].property_datatype)
			CASE "binary"
				li_sts = get_cache_property_value_binary(ll_property_index, lbl_value, ls_filetype)
				if li_sts <= 0 then
					// If we don't recognize the property as a column, then log an error
					log.log(this, "u_ds_epro_object_cache.get_cache_property_value:0217", "Error handling binary property (" + epro_object.epro_object + ", " + ps_property + ")", 3)
					return 0
				end if
				if isnull(lbl_value) or len(lbl_value) <= 0 then
					setnull(pstr_property_value.value)
				else
					pstr_property_value.value = common_thread.eprolibnet4.convertbinarytohex(lbl_value)
					pstr_property_value.datatype = property[ll_property_index].property_datatype
					pstr_property_value.filetype = ls_filetype
					pstr_property_value.encoding = "hex"
				end if
			CASE "text"
				li_sts = get_cache_property_value_text(ll_property_index, ls_value)
				if li_sts <= 0 then
					// If we don't recognize the property as a column, then log an error
					log.log(this, "u_ds_epro_object_cache.get_cache_property_value:0232", "Error handling special property (" + epro_object.epro_object + ", " + ps_property + ")", 3)
					return 0
				end if
				pstr_property_value.value = ls_value
				pstr_property_value.datatype = property[ll_property_index].property_datatype
				pstr_property_value.filetype = ls_filetype
				pstr_property_value.encoding = ls_encoding
			CASE "string", "number"
				// String and Number exceptions are missing columns.  If this is a primary "p" table then assume that we want the property
				// saved in the associated progress table
				CHOOSE CASE lower(epro_object.base_tablename)
					CASE "p_patient"
						ls_cpr_id = object.cpr_id[cache_row]
						setnull(ll_object_key)
						ls_value = sqlca.fn_patient_object_progress_value(ls_cpr_id, "Patient", "Property", ll_object_key, property[ll_property_index].property_name)
						if not tf_check() then return -1
					CASE "p_patient_encounter"
						ls_cpr_id = object.cpr_id[cache_row]
						ll_object_key = object.encounter_id[cache_row]
						ls_value = sqlca.fn_patient_object_progress_value(ls_cpr_id, "Encounter", "Property", ll_object_key, property[ll_property_index].property_name)
						if not tf_check() then return -1
					CASE "p_assessment"
						ls_cpr_id = object.cpr_id[cache_row]
						ll_object_key = object.problem_id[cache_row]
						ls_value = sqlca.fn_patient_object_progress_value(ls_cpr_id, "Assessment", "Property", ll_object_key, property[ll_property_index].property_name)
						if not tf_check() then return -1
					CASE "p_treatment"
						ls_cpr_id = object.cpr_id[cache_row]
						ll_object_key = object.treatment_id[cache_row]
						ls_value = sqlca.fn_patient_object_progress_value(ls_cpr_id, "Treatment", "Property", ll_object_key, property[ll_property_index].property_name)
						if not tf_check() then return -1
					CASE ELSE
						// If we don't recognize the property as a column, then log an error
						log.log(this, "u_ds_epro_object_cache.get_cache_property_value:0265", "Unhandled Exception (" + property[ll_property_index].property_datatype + ") getting epro object property data (" + epro_object.epro_object + ", " + ps_property + ")", 3)
						return 0
				END CHOOSE
				pstr_property_value.value = ls_value
				pstr_property_value.datatype = property[ll_property_index].property_datatype
			CASE ELSE
				// If we don't recognize the property as a column, then log an error
				log.log(this, "u_ds_epro_object_cache.get_cache_property_value:0272", "Unhandled Exception getting epro object property data (" + epro_object.epro_object + ", " + ps_property + ")", 3)
				return 0
		END CHOOSE
	else
		// See if it's a column
		li_sts = get_cache_property_value_column(ll_property_index, ls_value)
		if li_sts <= 0 then
			// If we don't recognize the property as a column, then log an error
			log.log(this, "u_ds_epro_object_cache.get_cache_property_value:0280", "Error getting epro object property data (" + epro_object.epro_object + ", " + ps_property + ")", 3)
			return 0
		else
			pstr_property_value.value = ls_value
			pstr_property_value.datatype = property[ll_property_index].property_datatype
		end if
	end if
else
	// If we don't recognize the property, then log an error
	log.log(this, "u_ds_epro_object_cache.get_cache_property_value:0289", "Invalid epro object property (" + epro_object.epro_object + ", " + ps_property + ")", 3)
	return 0
end if

return 1



end function

public function integer edas_property_handler_root (string ps_property, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
datetime ldt_datetime
integer li_sts

setnull(ls_null)

CHOOSE CASE lower(ps_property)
	CASE "currentdate"
		pstr_property_value.value = string(today())
		return 1
	CASE "currenttime"
		pstr_property_value.value = string(now())
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_address (string ps_property, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
datetime ldt_datetime
integer li_sts

setnull(ls_null)

CHOOSE CASE lower(ps_property)
	CASE "address"
		pstr_property_value.value = f_pretty_address(this.object.address_line_1[cache_row], &
																	this.object.address_line_2[cache_row], &
																	this.object.city[cache_row], &
																	this.object.state[cache_row], &
																	this.object.zip[cache_row], &
																	"~r~n")
		return 1
	CASE "address1line"
		pstr_property_value.value = f_pretty_address(this.object.address_line_1[cache_row], &
																	this.object.address_line_2[cache_row], &
																	this.object.city[cache_row], &
																	this.object.state[cache_row], &
																	this.object.zip[cache_row], &
																	" ")
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_amountunit (string ps_property, string ps_amount, string ps_unit_id, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
datetime ldt_datetime
integer li_sts
u_unit luo_unit

setnull(ls_null)

CHOOSE CASE lower(ps_property)
	CASE "amount"
		pstr_property_value.value = ps_amount
		return 1
	CASE "prettyamount"
		luo_unit = unit_list.find_unit(ps_unit_id)
		if isnumber(ps_amount) and not isnull(luo_unit) then
			pstr_property_value.value = luo_unit.pretty_amount(ps_amount)
		else
			pstr_property_value.value = ps_amount
		end if
		return 1
	CASE "prettyamountunit"
		luo_unit = unit_list.find_unit(ps_unit_id)
		if not isnull(luo_unit) then
			pstr_property_value.value = luo_unit.pretty_amount_unit(ps_amount)
		else
			pstr_property_value.value = ps_amount
		end if
		return 1
	CASE "prettyunit"
		luo_unit = unit_list.find_unit(ps_unit_id)
		if not isnull(luo_unit) then
			pstr_property_value.value = luo_unit.pretty_unit(ps_amount)
		else
			pstr_property_value.value = ls_null
		end if
		return 1
	CASE "unit"
		pstr_property_value.value = ps_unit_id
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_assessment (string ps_property, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
datetime ldt_datetime
integer li_sts
string ls_temp

setnull(ls_null)

CHOOSE CASE lower(ps_property)
	CASE "status"
		ls_temp = this.object.assessment_status[cache_row]
		if isnull(ls_temp) or lower(ls_temp) = "open" then
			pstr_property_value.value = "Open"
		else
			pstr_property_value.value = wordcap(ls_temp)
		end if
		return 1
	CASE "fulldescription"
		ldt_datetime = this.object.begin_date[cache_row]
		ls_temp = string(date(ldt_datetime))
		ldt_datetime = this.object.end_date[cache_row]
		if not isnull(ldt_datetime) then
			ls_temp += " - " + string(date(ldt_datetime))
		end if
		pstr_property_value.value = ls_temp + " " + string(this.object.assessment[cache_row]) 
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_communication (string ps_property, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
datetime ldt_datetime
integer li_sts
string ls_temp

setnull(ls_null)

CHOOSE CASE lower(ps_property)
	CASE "communicationitem"
		ls_temp = this.object.communication_name[cache_row]
		if len(ls_temp) > 0 then
			ls_temp += ": "
		else
			ls_temp = ""
		end if
		pstr_property_value.value = ls_temp + string(this.object.communication_value[cache_row])
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_drug (string ps_property, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
datetime ldt_datetime
integer li_sts
real lr_amount
string ls_unit_id
string ls_prn
u_unit luo_unit

setnull(ls_null)

CHOOSE CASE lower(ps_property)
	CASE "defaultduration"
		lr_amount = this.object.default_duration_amount[cache_row]
		ls_unit_id = this.object.default_duration_unit[cache_row]
		ls_prn = this.object.default_duration_prn[cache_row]
		If isnull(ls_prn) then
			If lr_amount > 0 and not isnull(ls_unit_id) then
				pstr_property_value.value = f_pretty_amount_unit(lr_amount, ls_unit_id)
			Elseif lr_amount = -1 then
				pstr_property_value.value = "Indefinite"
			End if
		Else
			pstr_property_value.value = "PRN " + string(this.object.default_duration_prn[cache_row])
		End if
		return 1
	CASE "maxdose"
		lr_amount = this.object.max_dose_per_day[cache_row]
		ls_unit_id = this.object.max_dose_unit[cache_row]
		pstr_property_value.value = f_pretty_amount(lr_amount, ls_unit_id, luo_unit)
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_duration (string ps_property, string ps_amount, string ps_filter, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
datetime ldt_datetime
integer li_sts
u_unit luo_unit
boolean lb_indefinite
boolean lb_prn
string ls_unit_id
string ls_prn

setnull(ls_null)

f_split_string(ps_filter, ",", ls_unit_id, ls_prn)

// First check for the existence of the PRN
lb_prn = false
lb_indefinite = false
if len(ls_prn) > 0 then
	lb_prn = true
else
	if isnumber(ps_amount) then
		if long(ps_amount) = -1 then
			lb_indefinite = true
		end if
	end if
end if

CHOOSE CASE lower(ps_property)
	CASE "amount"
		if lb_indefinite or lb_prn then
			pstr_property_value.value = ls_null
		else
			pstr_property_value.value = ps_amount
		end if
		return 1
	CASE "description"
		if lb_indefinite then
			pstr_property_value.value = "Indefinite"
		elseif lb_prn then
			pstr_property_value.value = ls_prn
		else
			luo_unit = unit_list.find_unit(ls_unit_id)
			if not isnull(luo_unit) then
				pstr_property_value.value = luo_unit.pretty_amount_unit(ps_amount)
			else
				pstr_property_value.value = ps_amount
			end if
		end if
		return 1
	CASE "prettyamount"
		if lb_indefinite or lb_prn then
			pstr_property_value.value = ls_null
		else
			luo_unit = unit_list.find_unit(ls_unit_id)
			if isnumber(ps_amount) and not isnull(luo_unit) then
				pstr_property_value.value = luo_unit.pretty_amount(ps_amount)
			else
				pstr_property_value.value = ps_amount
			end if
		end if
		return 1
	CASE "prettyunit"
		if lb_indefinite or lb_prn then
			pstr_property_value.value = ls_null
		else
			luo_unit = unit_list.find_unit(ls_unit_id)
			if not isnull(luo_unit) then
				pstr_property_value.value = luo_unit.pretty_unit(ps_amount)
			else
				pstr_property_value.value = ls_null
			end if
		end if
		return 1
	CASE "prn"
		if lb_prn then
			pstr_property_value.value = ls_prn
		else
			pstr_property_value.value = ls_null
		end if
	CASE "unit"
		if lb_indefinite or lb_prn then
			pstr_property_value.value = ls_null
		else
			pstr_property_value.value = ls_unit_id
		end if
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_patient (string ps_property, ref str_property_value pstr_property_value);real lr_amount
string ls_unit
u_unit luo_unit
string ls_prn
str_progress lstr_progress
u_user luo_user
string ls_null
integer li_sts
real lr_duration_amount
string ls_duration_unit
string ls_duration_prn
datetime ldt_appointment_date_time
string ls_temp
string ls_progress_type
string ls_progress_key
integer li_column_id
string ls_date
date ld_date
u_user luo_provider
long ll_count
string ls_cpr_id  

setnull(ls_null)

if isnull(cache_row) or cache_row <= 0 then return 0

ls_cpr_id = this.object.cpr_id[cache_row]

CHOOSE CASE lower(ps_property)
	CASE "address"
		pstr_property_value.value = f_pretty_address( this.object.address_line_1[cache_row], &
																	this.object.address_line_2[cache_row], &
																	this.object.city[cache_row], &
																	this.object.state[cache_row], &
																	this.object.zip[cache_row], &
																	"~r~n")
		return 1
	CASE "address1line"
		pstr_property_value.value = f_pretty_address( this.object.address_line_1[cache_row], &
																	this.object.address_line_2[cache_row], &
																	this.object.city[cache_row], &
																	this.object.state[cache_row], &
																	this.object.zip[cache_row], &
																	" ")
		return 1
	CASE "age"
		pstr_property_value.value = f_pretty_age(date(datetime(this.object.date_of_birth[cache_row])), today())
		return 1
	CASE "allergies"
		SELECT count(*)
		INTO :ll_count
		FROM p_Assessment
		WHERE cpr_id = :ls_cpr_id
		AND assessment_type='ALLERGY'
		AND assessment_status IS NULL;
		if not tf_check() then return -1
		if ll_count > 0 then
			pstr_property_value.value = "Allergies"
			pstr_property_value.textcolor = COLOR_RED
			pstr_property_value.weight = 700
		else
			pstr_property_value.value = "No Allergies"
			pstr_property_value.textcolor = COLOR_BLACK
			pstr_property_value.weight = 400
		end if
		return 1
	CASE "date_of_birth", "dob"
		pstr_property_value.value = string(date(datetime(this.object.date_of_birth[cache_row])), "[shortdate]")
		return 1
	CASE "full_name", "fullname"
		pstr_property_value.value = f_pretty_name(this.object.last_name[cache_row], &
																this.object.first_name[cache_row], &
																this.object.middle_name[cache_row], &
																"", &
																"", &
																"")
		ls_temp = this.object.nickname[cache_row]
		if len(ls_temp) > 0 then
			pstr_property_value.value += " (" + ls_temp + ")"
		end if
		return 1
	CASE "primary_office", "primaryofficename"
		pstr_property_value.value = datalist.office_description(this.object.office_id[cache_row])
		return 1
	CASE "primary_guardian", "primaryguardianname"
		SELECT TOP 1 relation_cpr_id,  dbo.fn_patient_full_name(relation_cpr_id)
		INTO :pstr_property_value.value, :pstr_property_value.display_value
		FROM dbo.fn_patient_relations(:ls_cpr_id, 'Primary Guardian');
		if not tf_check() then
			return 1
		end if
		return 1
	CASE "primary_provider", "primaryprovidername"
		luo_provider = user_list.find_user(this.object.primary_provider_id[cache_row])
		if not isnull(luo_provider) then
			pstr_property_value.value = luo_provider.user_short_name
			pstr_property_value.backcolor = luo_provider.color
		else
			setnull(pstr_property_value.value)
		end if
		return 1
	CASE "primary_payor", "primarypayorname"
		SELECT c.name
		INTO :pstr_property_value.value
		FROM p_Patient_Authority a
			INNER JOIN c_Authority c
			ON a.authority_id = c.authority_id
		WHERE a.cpr_id = :ls_cpr_id
		AND a.authority_type = 'Payor'
		AND a.authority_sequence = 1;		
		if not tf_check() then return -1

		return 1
	CASE "sex_male_female", "sexmalefemale"
		if upper(this.object.sex[cache_row]) = "F" then
			pstr_property_value.value = "female"
		else
			pstr_property_value.value = "male"
		end if
		return 1
END CHOOSE

return 0


end function

public function integer edas_property_handler_treatment (string ps_property, ref str_property_value pstr_property_value);real lr_amount
string ls_unit
u_unit luo_unit
string ls_prn
str_progress lstr_progress
u_user luo_user
string ls_null
integer li_sts
real lr_duration_amount
string ls_duration_unit
string ls_duration_prn
datetime ldt_appointment_date_time
string ls_temp
string ls_progress_type
string ls_progress_key
integer li_column_id
long ll_count
integer li_severity
string ls_package_id
string ls_dosage_form
str_attributes lstr_attributes
string ls_ordered_by
string ls_cpr_id
long ll_treatment_id

setnull(ls_null)

if isnull(cache_row) or cache_row <= 0 then return 0

ls_cpr_id = this.object.cpr_id[cache_row]
ll_treatment_id = this.object.treatment_id[cache_row]

CHOOSE CASE lower(ps_property)
	CASE "abnormal_results"
		SELECT count(*)
		INTO :ll_count
		FROM p_Observation
		WHERE cpr_id = :ls_cpr_id
		AND treatment_id = :ll_treatment_id
		AND parent_observation_sequence IS NULL
		AND abnormal_flag = 'Y';
		if not tf_check() then return -1
		if ll_count > 0 then
			pstr_property_value.value = "Y"
		else
			pstr_property_value.value = "N"
		end if
//	CASE "administer_frequency_description"
//		ls_temp = this.object.administer_frequency[cache_row]
//		pstr_property_value.value = drugdb.administration_frequency_property(ls_temp, "description")
//		pstr_property_value.display_value = pstr_property_value.value
//	CASE "administer_method"
//		ls_temp = this.object.package_id[cache_row]
//		pstr_property_value.value = drugdb.get_package_property(ls_temp, "administer_method")
//		pstr_property_value.display_value = pstr_property_value.value
//	CASE "administer_method_description"
//		ls_temp = this.object.package_id[cache_row]
//		pstr_property_value.value = drugdb.get_package_property(ls_temp, "method_description")
//		pstr_property_value.display_value = pstr_property_value.value
//	CASE "appointment_date"
//		ldt_appointment_date_time = this.object.appointment_date_time[cache_row]
//		pstr_property_value.value = string(date(ldt_appointment_date_time))
//		pstr_property_value.display_value = pstr_property_value.value
//	CASE "appointment_time"
//		ldt_appointment_date_time = this.object.appointment_date_time[cache_row]
//		pstr_property_value.value = string(time(ldt_appointment_date_time), "hh:mm")
//		pstr_property_value.display_value = pstr_property_value.value
//	CASE "dispense"
//		lr_amount = this.object.dispense_amount[cache_row]
//		ls_unit = this.object.dispense_unit[cache_row]
//		luo_unit = unit_list.find_unit(ls_unit)
//		if not isnull(luo_unit) then
//			pstr_property_value.value = luo_unit.pretty_amount_unit(lr_amount)
//			pstr_property_value.display_value = pstr_property_value.value
//		end if
//	CASE "dose"
//		lr_amount = this.object.dose_amount[cache_row]
//		ls_unit = this.object.dose_unit[cache_row]
//		luo_unit = unit_list.find_unit(ls_unit)
//		if not isnull(luo_unit) then
//			pstr_property_value.value = luo_unit.pretty_amount_unit(lr_amount)
//			pstr_property_value.display_value = pstr_property_value.value
//		end if
	CASE "drug_sig_brief", "drugsigbrief"
		f_attribute_add_attribute(lstr_attributes, "drug_id", string(this.object.drug_id[cache_row]))
		ls_package_id = this.object.package_id[cache_row]
		f_attribute_add_attribute(lstr_attributes, "package_id", ls_package_id)
		f_attribute_add_attribute(lstr_attributes, "dose_amount", string(real(this.object.dose_amount[cache_row])))
		f_attribute_add_attribute(lstr_attributes, "dose_unit", string(this.object.dose_unit[cache_row]))
		f_attribute_add_attribute(lstr_attributes, "administer_frequency", string(this.object.administer_frequency[cache_row]))
		f_attribute_add_attribute(lstr_attributes, "duration_amount", string(real(this.object.duration_amount[cache_row])))
		f_attribute_add_attribute(lstr_attributes, "duration_unit", string(this.object.duration_unit[cache_row]))
		f_attribute_add_attribute(lstr_attributes, "duration_prn", string(this.object.duration_prn[cache_row]))
		f_attribute_add_attribute(lstr_attributes, "administration_sequence", string(integer(this.object.administration_sequence[cache_row])))
		if not isnull(ls_package_id) then
			// If we have a package_id then the dosage_form comes from the package
			// Just leave it null because the sig function only needs a dosage_form if there is no package
			setnull(ls_dosage_form)
		else
			// If we don't have a package_id, then the dosage_form comes from a treatment property
			ls_dosage_form = sqlca.fn_patient_object_property(ls_cpr_id, "Treatment", ll_treatment_id, "dosage_form")
		end if
		f_attribute_add_attribute(lstr_attributes, "dosage_form", ls_dosage_form)
		pstr_property_value.value = f_drug_treatment_sig(lstr_attributes)
		pstr_property_value.display_value = pstr_property_value.value
	CASE "drug_sig_full", "drugsigfull"
		f_attribute_add_attribute(lstr_attributes, "drug_id", string(this.object.drug_id[cache_row]))
		ls_package_id = this.object.package_id[cache_row]
		f_attribute_add_attribute(lstr_attributes, "package_id", ls_package_id)
		f_attribute_add_attribute(lstr_attributes, "dose_amount", string(real(this.object.dose_amount[cache_row])))
		f_attribute_add_attribute(lstr_attributes, "dose_unit", string(this.object.dose_unit[cache_row]))
		f_attribute_add_attribute(lstr_attributes, "administer_frequency", string(this.object.administer_frequency[cache_row]))
		f_attribute_add_attribute(lstr_attributes, "duration_amount", string(real(this.object.duration_amount[cache_row])))
		f_attribute_add_attribute(lstr_attributes, "duration_unit", string(this.object.duration_unit[cache_row]))
		f_attribute_add_attribute(lstr_attributes, "duration_prn", string(this.object.duration_prn[cache_row]))
		f_attribute_add_attribute(lstr_attributes, "administration_sequence", string(integer(this.object.administration_sequence[cache_row])))
		if not isnull(ls_package_id) then
			// If we have a package_id then the dosage_form comes from the package
			// Just leave it null because the sig function only needs a dosage_form if there is no package
			setnull(ls_dosage_form)
		else
			// If we don't have a package_id, then the dosage_form comes from a treatment property
			ls_dosage_form = sqlca.fn_patient_object_property(ls_cpr_id, "Treatment", ll_treatment_id, "dosage_form")
		end if
		f_attribute_add_attribute(lstr_attributes, "dosage_form", ls_dosage_form)
		ls_temp = f_get_progress_value(ls_cpr_id, "Treatment", ll_treatment_id, "Instructions", "Pharmacist Instructions")
		if len(ls_temp) > 0 then
			f_attribute_add_attribute(lstr_attributes, "pharmacist_instructions", ls_temp)
		end if
		ls_temp = f_get_progress_value(ls_cpr_id, "Treatment", ll_treatment_id, "Instructions", "Patient Instructions")
		if len(ls_temp) > 0 then
			f_attribute_add_attribute(lstr_attributes, "patient_instructions", ls_temp)
		end if
		f_attribute_add_attribute(lstr_attributes, "dispense_amount", string(real(this.object.dispense_amount[cache_row])))
		f_attribute_add_attribute(lstr_attributes, "dispense_unit", string(this.object.dispense_unit[cache_row]))
		f_attribute_add_attribute(lstr_attributes, "refills", string(integer(this.object.refills[cache_row])))
		f_attribute_add_attribute(lstr_attributes, "brand_name_required", string(this.object.brand_name_required[cache_row]))
		pstr_property_value.value = f_drug_treatment_sig(lstr_attributes)
		pstr_property_value.display_value = pstr_property_value.value
//	CASE "duration"
//		lr_amount = this.object.duration_amount[cache_row]
//		ls_unit = this.object.duration_unit[cache_row]
//		ls_prn = this.object.duration_prn[cache_row]
//		luo_unit = unit_list.find_unit(ls_unit)
//		if isnull(luo_unit) then
//			pstr_property_value.value = ls_prn
//		else
//			pstr_property_value.value = luo_unit.pretty_amount_unit(lr_amount)
//		end if
//		pstr_property_value.display_value = pstr_property_value.value
	CASE "followup_when", "referral_when", "followupwhen", "referralwhen"
		lr_duration_amount = this.object.duration_amount[cache_row]
		ls_duration_unit = this.object.duration_unit[cache_row]
		ls_duration_prn = this.object.duration_prn[cache_row]
		ldt_appointment_date_time = this.object.appointment_date_time[cache_row]
		
		pstr_property_value.value = f_appointment_string(ldt_appointment_date_time, lr_duration_amount, ls_duration_unit, ls_duration_prn)
		pstr_property_value.display_value = pstr_property_value.value
	CASE "last_observed_by", "lastobservedby"
		ls_temp = sqlca.fn_treatment_last_observed_by(ls_cpr_id, ll_treatment_id)
		if len(ls_temp) > 0 then
			pstr_property_value.value = ls_temp
			pstr_property_value.display_value = user_list.user_full_name(pstr_property_value.value)
		else
			pstr_property_value.value = ""
			pstr_property_value.display_value = ""
		end if
	CASE "last_ordered_by", "lastorderedby"
		SELECT top 1 ordered_by
		INTO :ls_ordered_by
		FROM dbo.fn_patient_treatment_orders(:ls_cpr_id, :ll_treatment_id)
		ORDER BY order_sequence desc;
		if not tf_check() then return -1
		if sqlca.sqlnrows <> 1 then return -1	

		luo_user = user_list.find_user(ls_ordered_by)
		if not isnull(luo_user) then
			pstr_property_value.value = luo_user.user_id
			pstr_property_value.display_value = luo_user.user_full_name
		else
			pstr_property_value.value = ""
			pstr_property_value.display_value = ""
		end if
	CASE "max_result_severity"
		SELECT max(severity)
		INTO :li_severity
		FROM p_Observation
		WHERE cpr_id = :ls_cpr_id
		AND treatment_id = :ll_treatment_id
		AND parent_observation_sequence IS NULL;
		if not tf_check() then return -1
		if li_severity >= 0 then
			pstr_property_value.value = string(li_severity)
			pstr_property_value.display_value = datalist.domain_item_description("RESULTSEVERITY", pstr_property_value.value)
		else
			pstr_property_value.value = ""
			pstr_property_value.display_value = ""
		end if
	CASE "office_dispense"
		lr_amount = this.object.office_dispense_amount[cache_row]
		ls_unit = this.object.dispense_unit[cache_row]
		luo_unit = unit_list.find_unit(ls_unit)
		if not isnull(luo_unit) then
			pstr_property_value.value = luo_unit.pretty_amount_unit(lr_amount)
			pstr_property_value.display_value = pstr_property_value.value
		end if
	CASE ELSE
		return 0
END CHOOSE

return 1


end function

public function integer get_property_value (string ps_epro_object_key, str_property_specification pstr_property, str_complete_context pstr_context, ref str_property_value pstr_property_value);string ls_cpr_id
long ll_object_key
string ls_sql
integer li_sts
long ll_count
string ls_from_table

// This form of get_property_value is for when we have a single-part key and the key value in hand.  In this case we don't need any
// which_object or filter interpretation

if isnull(ps_epro_object_key) then
	return -1
end if

if rowcount() > 0 then
	// First see if the current object key matches
	if secondsafter(cache_timestamp, now()) > max_cache_age then
		cache_valid = false
	elseif isnull(current_key_value) then
		cache_valid = false
	elseif current_key_value <> ps_epro_object_key then
		cache_valid = false
	end if
else
// if we don't have a row, then we must not be valid
	cache_valid = false
end if

// if the cache is valid then just return
if virtual_table then
	if len(pstr_property.property.property_value_object_filter) > 0 then
		virtual_table_state = apply_context(pstr_property.property.property_value_object_filter, pstr_context)
	end if

	// reset the cache timestamp
	setnull(current_which_object.object_identifier)
	setnull(current_which_object.filter_statement)
	setnull(current_which_object.ordinal)
	setnull(current_which_object.which_object_string)
	
	current_key_field = epro_object.base_table_key_column
	current_key_value = ps_epro_object_key
	
	cache_timestamp = now()
	cache_row = 1
	cache_valid = true
elseif not cache_valid then 
	where_clause = epro_object.base_table_key_column + " = '" + ps_epro_object_key + "'"
	
	ls_sql = "SELECT " + select_columns + " FROM "
	
	// Supstitute the context variables
	ls_from_table = apply_context(epro_object.base_tablename, pstr_context)
	// Substitute the key from the referencing object
	if len(ps_epro_object_key) > 0 then
		ls_from_table = f_string_substitute(ls_from_table, "%" + epro_object.base_table_key_column + "%", ps_epro_object_key)
	else
		ls_from_table = f_string_substitute(ls_from_table, "%" + epro_object.base_table_key_column + "%", "0")
	end if
	if len(reference_object_key) > 0 then
		ls_from_table = f_string_substitute(ls_from_table, "%reference_object_key%", reference_object_key)
	else
		ls_from_table = f_string_substitute(ls_from_table, "%reference_object_key%", "0")
	end if
	ls_from_table = f_string_substitute(ls_from_table, "%parent_epro_object%", parent_epro_object.epro_object)
	if len(pstr_property.referer_object_identifier) > 0 then
		ls_from_table = f_string_substitute(ls_from_table, "%object_identifier%", pstr_property.referer_object_identifier)
	else
		ls_from_table = f_string_substitute(ls_from_table, "%object_identifier%", "")
	end if
	
	ls_sql += ls_from_table + " a "

	ls_sql += " WHERE " + where_clause
	
	settransobject(sqlca)
	setsqlselect(ls_sql)
	ll_count = retrieve()
	if ll_count < 0 then return -1
	if ll_count = 0 then return 0

	// reset the cache timestamp
	setnull(current_which_object.object_identifier)
	setnull(current_which_object.filter_statement)
	setnull(current_which_object.ordinal)
	setnull(current_which_object.which_object_string)
	
	current_key_field = epro_object.base_table_key_column
	current_key_value = ps_epro_object_key
	
	cache_timestamp = now()
	cache_row = 1
	cache_valid = true
end if

return get_cache_property_value(pstr_property.property.property_name, pstr_context, pstr_property_value)




end function

public function integer edas_property_handler_datetime (string ps_property, string ps_datetime, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
datetime ldt_datetime
integer li_sts

setnull(ls_null)

ldt_datetime = f_string_to_datetime(ps_datetime)

CHOOSE CASE lower(ps_property)
	CASE "date"
		pstr_property_value.value = string(date(ldt_datetime))
		return 1
	CASE "datetime"
		if time(ldt_datetime) = time("00:00:00") then
			pstr_property_value.value = string(date(ldt_datetime))
		else
			pstr_property_value.value = string(ldt_datetime)
		end if
		return 1
	CASE "time"
		pstr_property_value.value = string(time(ldt_datetime))
		return 1
END CHOOSE

return 0

end function

private function integer get_cache_property_value_column (string ps_property, ref string ps_value);long i

for i = 1 to property_count
	if lower(property[i].property_name) = lower(ps_property) then
		return get_cache_property_value_column(i, ps_value)
	end if
next


return 0


end function

public subroutine set_virtual_table_state (string ps_virtual_table_state);

virtual_table_state = ps_virtual_table_state

end subroutine

public function integer edas_property_handler_attachment (string ps_property, str_complete_context pstr_context, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
datetime ldt_datetime
integer li_sts
str_property_value lstr_property_value
long ll_property_index
blob lbl_value
blob lbl_image_data
string ls_filetype
string ls_image_filetype
long i
integer li_width
integer li_height
long ll_length
integer li_return

setnull(ls_null)
setnull(li_width)
setnull(li_height)

li_return = 0

CHOOSE CASE lower(ps_property)
	CASE "attachmentimage"
		// First find the property index of the AttachmentData property
		ll_property_index = 0
		for i = 1 to property_count
			if lower(property[i].property_name) = lower("AttachmentData") then
				ll_property_index = i
				exit
			end if
		next
		if ll_property_index = 0 then
			// If we don't recognize the property as a column, then log an error
			log.log(this, "u_ds_epro_object_cache.edas_property_handler_attachment:0039", "AttachmentData property not found and is needed to calculate AttachmentImage property (" + epro_object.epro_object + ", " + ps_property + ")", 3)
			return 0
		end if

		li_sts = get_cache_property_value_binary(ll_property_index, lbl_value, ls_filetype)
		if li_sts <= 0 then
			// If we don't recognize the property as a column, then log an error
			log.log(this, "u_ds_epro_object_cache.edas_property_handler_attachment:0046", "Error handling binary property (" + epro_object.epro_object + ", " + ps_property + ")", 3)
			return 0
		end if
		
		ll_length = len(lbl_value)
		if ll_length <= 0 then return 0
		
		// If we get here then we found the AttachmentData and we have the blob in hand.
		// If the filetype is not provided, then assume that it's already an bitmap
		if len(ls_filetype) > 0 then
			f_render_file_as_image(ls_filetype, lbl_value, ls_image_filetype, lbl_image_data, li_width, li_height)
		else
			lbl_image_data = lbl_value
			ls_image_filetype = "bmp"
		end if

		pstr_property_value.value = common_thread.eprolibnet4.convertbinarytohex(lbl_image_data)
		pstr_property_value.datatype = "binary"
		pstr_property_value.filetype = ls_image_filetype
		pstr_property_value.encoding = "hex"

		li_return = 1
END CHOOSE

return li_return


end function

private function integer get_cache_property_value_binary (long pl_property_index, ref blob pbl_value, ref string ps_filetype);string ls_null
integer li_sts
string ls_value
string ls_select
string ls_filetype

setnull(ls_null)

// DECLARE jmj_set_property_exception_value PROCEDURE FOR jmj_set_property_exception_value  
//         @pl_spid = :sqlca.spid,   
//         @ps_datatype = 'binary',   
//         @ps_select = :ls_select  ;


ls_select = "SELECT value = " + property[pl_property_index].property_select_expression
ls_select += " FROM " + epro_object.base_tablename + " a "
ls_select += " WHERE " + where_clause

sqlca.jmj_set_property_exception_value(sqlca.spid, 'binary', ls_select);
//EXECUTE jmj_set_property_exception_value;
if not tf_check() then return -1

SELECTBLOB property_value_binary
INTO :pbl_value
FROM x_Property_Exception
WHERE spid = :sqlca.spid;
if not tf_check() then return -1

// Now encode the blob into printable characters
li_sts = get_cache_property_value_column("extension", ls_filetype)
if li_sts > 0 and len(ls_filetype) > 0 then
	ps_filetype = ls_filetype
elseif li_sts = 0 then
	li_sts = get_cache_property_value_column(property[pl_property_index].property_column + "_filetype", ls_filetype)
	if li_sts > 0 and len(ls_filetype) > 0 then
		ps_filetype = ls_filetype
	elseif li_sts = 0 then
		li_sts = get_cache_property_value_column("filetype", ls_filetype)
		if li_sts > 0 and len(ls_filetype) > 0 then
			ps_filetype = ls_filetype
		end if
	end if
end if


return 1


end function

private function integer get_cache_property_value_text (long pl_property_index, ref string ps_value);string ls_null
integer li_sts
blob lbl_property_value
string ls_value
string ls_select
string ls_filetype
boolean lb_get_whole_value

setnull(ls_null)

// DECLARE jmj_set_property_exception_value PROCEDURE FOR jmj_set_property_exception_value  
//         @pl_spid = :sqlca.spid,   
//         @ps_datatype = 'text',   
//         @ps_select = :ls_select  ;

if len(property[pl_property_index].property_formula) > 0 then
	ls_select = "SELECT value = " + property[pl_property_index].property_formula
else
	ls_select = "SELECT value = " + property[pl_property_index].property_column
end if
ls_select += " FROM " + epro_object.base_tablename + " a "
ls_select += " WHERE " + where_clause


// First get the cached value
lb_get_whole_value = false
li_sts = get_cache_property_value_column(property[pl_property_index].property_name, ls_value)
if li_sts <= 0 then
	if li_sts = 0 and len(property[pl_property_index].property_formula) > 0 then
		// there is a formula and no column, so just assume we need to call jmj_set_property_exception_value
		lb_get_whole_value = true
	else
		// If we don't recognize the property as a column, then log an error
		log.log(this, "u_ds_epro_object_cache.get_cache_property_value_text:0034", "Invalid epro object property (" + epro_object.epro_object + ", " + property[pl_property_index].property_name + ")", 3)
		return 0
	end if
elseif len(ls_value) = property[pl_property_index].cache_column_length then
	lb_get_whole_value = true
end if

// if the length of the property value happens to be exactly the length of the cached column, then we assume that there is a larger value out there for us to get
if lb_get_whole_value then
	sqlca.jmj_set_property_exception_value(sqlca.spid, 'text', ls_select);
//	EXECUTE jmj_set_property_exception_value;
	if not tf_check() then return -1

	// Get the value directly using embedded SQL because we are limited to only 32767 bytes if we get it through a datawindow column
	SELECT property_value_text
	INTO :ps_value
	FROM x_Property_Exception
	WHERE spid = :sqlca.spid;
	if not tf_check() then return -1
else
	ps_value = ls_value
end if	


return 1


end function

private function integer get_cache_property_value_column (long pl_property_index, ref string ps_value);string ls_null
integer li_column_id
string ls_coltype
long ll_pos
long ll_length
string ls_progress_type
string ls_progress_key
any la_value
integer li_sts

setnull(ls_null)


li_column_id = column_id(property[pl_property_index].property_name)

if li_column_id > 0 then
	// Get the column type
	ls_coltype = trim(upper(Describe("#" + string(li_column_id) + ".ColType")))
	
	// strip off the size
	ll_pos = pos(ls_coltype, "(")
	if ll_pos > 0 then
		ll_length = integer(mid(ls_coltype, ll_pos + 1, len(ls_coltype) - ll_pos - 1))
		ls_coltype = left(ls_coltype, ll_pos - 1)
	end if

	// Get the column data
	la_value = object.data[cache_row, li_column_id]
	
	// Convert the data to a string
	CHOOSE CASE ClassName(la_value)
		CASE "string"
			ps_value = string(la_value)
		CASE "integer"
			ps_value = string(integer(la_value))
		CASE "long"
			ps_value = string(long(la_value))
		CASE "datetime"
			ps_value = string(datetime(la_value))
			if right(ps_value, 9) = " 00:00:00" then
				ps_value = left(ps_value, len(ps_value) - 9)
			end if
		CASE "date"
			ps_value = string(date(la_value))
		CASE "time"
			ps_value = string(time(la_value))
		CASE "real"
			ps_value = string(real(la_value))
		CASE ELSE
			ps_value = string(la_value)
	END CHOOSE
	return 1
end if

return 0


end function

public function integer edas_property_handler_userstamp (string ps_property, ref str_property_value pstr_property_value);integer li_sts
long ll_property_index
string ls_value
long i
long ll_length
string ls_extension
string ls_data

CHOOSE CASE lower(ps_property)
	CASE "userstampdata"
		// First find the property index of the AttachmentData property
		ll_property_index = 0
		for i = 1 to property_count
			if lower(property[i].property_name) = lower("UserStampData") then
				ll_property_index = i
				exit
			end if
		next
		if ll_property_index = 0 then
			// If we don't recognize the property as a column, then log an error
			log.log(this, "u_ds_epro_object_cache.edas_property_handler_userstamp:0021", "UserStampData property not found (" + epro_object.epro_object + ", " + ps_property + ")", 3)
			return 0
		end if

		li_sts = get_cache_property_value_text(ll_property_index, ls_value)
		if li_sts <= 0 then
			// If we don't recognize the property as a column, then log an error
			log.log(this, "u_ds_epro_object_cache.edas_property_handler_userstamp:0028", "Error getting image data (" + epro_object.epro_object + ", " + ps_property + ")", 3)
			return 0
		end if
		
		ll_length = len(ls_value)
		if ll_length <= 0 then return 0
		
		// we might have embedded the file type into the file data
		f_split_string(ls_value, ".", ls_extension, ls_data)
		if len(ls_data) > 0 then
			pstr_property_value.value = ls_data
			pstr_property_value.filetype = ls_extension
		else
			pstr_property_value.value = ls_value
			pstr_property_value.filetype = "bmp"
		end if
			
		pstr_property_value.datatype = "binary"
		pstr_property_value.encoding = "hex"

		return 1
END CHOOSE

return 0


end function

public function integer edas_property_handler_number (string ps_property, string ps_number, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
decimal ld_number
integer li_sts

setnull(ls_null)

if not isnumber(ps_number) then
	pstr_property_value.value = ps_number
	return 1
end if

ld_number = dec(ps_number)

CHOOSE CASE lower(ps_property)
	CASE "number"
		pstr_property_value.value = ps_number
		return 1
	CASE "text"
		pstr_property_value.value = string(ld_number)
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_string (string ps_property, string ps_string, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
integer li_sts

setnull(ls_null)


CHOOSE CASE lower(ps_property)
	CASE "string"
		pstr_property_value.value = ps_string
		return 1
	CASE "uppercase"
		pstr_property_value.value = upper(ps_string)
		return 1
	CASE "lowercase"
		pstr_property_value.value = lower(ps_string)
		return 1
	CASE "cap"
		pstr_property_value.value = upper(left(ps_string, 1)) + lower(mid(ps_string, 2))
		return 1
	CASE "wordcap"
		pstr_property_value.value = wordcap(ps_string)
		return 1
	CASE "length"
		pstr_property_value.value = string(len(ps_string))
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_boolean (string ps_property, string ps_flag, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
decimal ld_number
integer li_sts
boolean lb_flag

setnull(ls_null)

if isnull(ps_flag) or trim(ps_flag) = "" then return 0

lb_flag = f_string_to_boolean(ps_flag)

CHOOSE CASE lower(ps_property)
	CASE "boolean"
		pstr_property_value.value = ps_flag
		return 1
	CASE "yesno"
		if lb_flag then
			pstr_property_value.value = "Yes"
		else
			pstr_property_value.value = "No"
		end if
		return 1
	CASE "truefalse"
		if lb_flag then
			pstr_property_value.value = "True"
		else
			pstr_property_value.value = "False"
		end if
		return 1
	CASE "yn"
		if lb_flag then
			pstr_property_value.value = "Y"
		else
			pstr_property_value.value = "N"
		end if
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_text (string ps_property, string ps_text, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
decimal ld_number
integer li_sts

setnull(ls_null)

if isnull(ps_text) or trim(ps_text) = "" then
	setnull(pstr_property_value.value)
	return 1
end if

CHOOSE CASE lower(ps_property)
	CASE "length"
		pstr_property_value.value = string(len(ps_text))
		return 1
	CASE "text"
		pstr_property_value.value = ps_text
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_binary (string ps_property, string ps_data, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
decimal ld_number
integer li_sts

setnull(ls_null)


CHOOSE CASE lower(ps_property)
	CASE "length"
		pstr_property_value.value = string(len(ps_data)/2)
		return 1
	CASE "hex"
		// For now Hex is the only option and the data will get to here encoded in Hex, so just return it
		pstr_property_value.value = ps_data
		return 1
	CASE "binary"
		pstr_property_value.datatype = "binary"
		pstr_property_value.encoding = "hex"
		pstr_property_value.value = ps_data
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_gender (string ps_property, string ps_gender, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
integer li_sts

setnull(ls_null)


CHOOSE CASE lower(ps_property)
	CASE "gender" // virtual key
		pstr_property_value.value = ps_gender
		return 1
	CASE "boygirl"
		CHOOSE CASE upper(ps_gender)
			CASE "M"
				pstr_property_value.value = "Boy"
			CASE "F"
				pstr_property_value.value = "Girl"
		END CHOOSE
		return 1
	CASE "malefemale"
		CHOOSE CASE upper(ps_gender)
			CASE "M"
				pstr_property_value.value = "Male"
			CASE "F"
				pstr_property_value.value = "Female"
		END CHOOSE
		return 1
	CASE "manwoman"
		CHOOSE CASE upper(ps_gender)
			CASE "M"
				pstr_property_value.value = "Man"
			CASE "F"
				pstr_property_value.value = "Woman"
		END CHOOSE
		return 1
	CASE "mf"
		CHOOSE CASE upper(ps_gender)
			CASE "M"
				pstr_property_value.value = "M"
			CASE "F"
				pstr_property_value.value = "F"
		END CHOOSE
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_drugadministration (string ps_property, ref str_property_value pstr_property_value);// This function interprets the passed in value as a key of the specified object type.
// The specified property of that object type is looked up and passed back to the caller
any la_property
string ls_null
long ll_object_key
string ls_supervisor
datetime ldt_datetime
integer li_sts
real lr_administer_amount
string ls_administrer_unit
string ls_administer_frequency
u_unit luo_unit
string ls_mult_by_what
string ls_calc_per
string ls_description

setnull(ls_null)

CHOOSE CASE lower(ps_property)
	CASE "description"
		lr_administer_amount = this.object.administer_amount[cache_row]
		ls_administrer_unit = this.object.administer_unit[cache_row]
		ls_administer_frequency = this.object.administer_frequency[cache_row]
		ls_mult_by_what = this.object.mult_by_what[cache_row]
		ls_calc_per = this.object.calc_per[cache_row]
		ls_description = this.object.description[cache_row]
		
		pstr_property_value.value = f_pretty_amount_unit(lr_administer_amount, ls_administrer_unit)
	
		if not (isnull(ls_mult_by_what) or ls_mult_by_what = "") then 
			pstr_property_value.value = pstr_property_value.value + "/" + ls_mult_by_what + "/" + ls_calc_per
		end if
	
		pstr_property_value.value = pstr_property_value.value + "  " + ls_administer_frequency
		if not isnull(ls_description) then
			pstr_property_value.value = pstr_property_value.value + "~n" + ls_description
		end if
	
		return 1
END CHOOSE

return 0

end function

public function integer edas_property_handler_trttypeselect (string ps_property, ref str_property_value pstr_property_value);
if len(current_key_value) > 0 then
	pstr_property_value.value = current_key_value
	return 1
else
	return 0
end if


end function

public function integer edas_property_handler_result (string ps_property, ref str_property_value pstr_property_value);u_unit luo_unit
string ls_null
string ls_result_unit
string ls_result
string ls_result_amount_flag
string ls_abnormal_flag
string ls_result_value
string ls_result_item
string ls_pretty_result
string ls_location_description
string ls_location
datetime ldt_result_date_time
string ls_print_result_flag
string ls_print_result_separator
string ls_unit_preference
string ls_display_mask
string ls_default_view
string ls_observation_id
integer li_result_sequence
string ls_result_unit_preference

setnull(ls_null)

ls_pretty_result = ""

if isnull(cache_row) or cache_row <= 0 then return 0

CHOOSE CASE lower(ps_property)
	CASE "prettyresult", "prettymetricresult", "prettyenglishresult"
//		SELECT count(*)
//		INTO :ll_count
//		FROM p_Observation
//		WHERE cpr_id = :current_context.cpr_id
//		AND treatment_id = :current_context.treatment_id
//		AND parent_observation_sequence IS NULL
//		AND abnormal_flag = 'Y';
//		if not tf_check() then return -1
//		if ll_count > 0 then
//			pstr_property_value.value = "Y"
//		else
//			pstr_property_value.value = "N"
//		end if

		// Result
		ls_observation_id = this.object.observation_id[cache_row]
		li_result_sequence = this.object.result_sequence[cache_row]
		ldt_result_date_time = this.object.result_date_time[cache_row]
		ls_result = this.object.result[cache_row]
		ls_location = this.object.location[cache_row]
		ls_result_value = this.object.result_value[cache_row]
		ls_result_unit = this.object.result_unit[cache_row]
		ls_abnormal_flag = this.object.abnormal_flag[cache_row]
		
//		// ObservationDefinition
//		ls_default_view = this.object.default_view[cache_row]
//		// ResultDefinition
//		ls_result_amount_flag = this.object.result_amount_flag[cache_row]
//		ls_print_result_flag = this.object.print_result_flag[cache_row]
//		ls_print_result_separator = this.object.print_result_separator[cache_row]
//		ls_unit_preference = this.object.unit_preference[cache_row]
//		ls_display_mask = this.object.display_mask[cache_row]
		SELECT 		r.result_amount_flag,
						r.print_result_flag,
						r.print_result_separator,
						r.unit_preference,
						r.display_mask,
						o.default_view
		INTO			:ls_result_amount_flag,
						:ls_print_result_flag,
						:ls_print_result_separator,
						:ls_result_unit_preference,
						:ls_display_mask,
						:ls_default_view
		FROM c_Observation_Result r
			INNER JOIN c_Observation o
			ON r.observation_id = o.observation_id
		WHERE r.observation_id = :ls_observation_id
		AND r.result_sequence = :li_result_sequence;
		if not tf_check() then return -1

//		// Location
//		ls_location_description = this.object.location_description[cache_row]
		SELECT 		description
		INTO			:ls_location_description
		FROM c_Location
		WHERE location = :ls_location;
		if not tf_check() then return -1

		if isnull(ls_print_result_separator) then ls_print_result_separator = "="
		
		if lower(ps_property) = "prettymetricresult" then
			ls_unit_preference = "METRIC"
		elseif lower(ps_property) = "prettyenglishresult" then
			ls_unit_preference = "ENGLISH"
		else
			ls_unit_preference = ls_result_unit_preference
		end if
		
		if f_string_to_boolean(ls_result_amount_flag) then
			// If we have an an amount then only the amount goes in the value
			if not isnull(ls_result_value) and trim(ls_result_value) <> "" then
				luo_unit = unit_list.find_unit(ls_result_unit)
				if isnull(luo_unit) then
					ls_pretty_result = ""
				else
					ls_pretty_result = luo_unit.pretty_amount_unit(ls_result_value, ls_unit_preference, ls_display_mask)
				end if	
			end if
			
			// If we have a result value, then see if we should prepend the result title
			if len(ls_pretty_result) > 0 then
				// Get the result title
				if f_string_to_boolean(ls_print_result_flag) and len(ls_result) > 0 then
					ls_pretty_result = ls_result + ls_print_result_separator + ls_pretty_result
				end if
			else
				setnull(ls_pretty_result)
			end if
		else
			ls_pretty_result = ls_result
		end if
		
		pstr_property_value.value = ls_pretty_result
	CASE "resultamount"
		ls_result_value = this.object.result_value[cache_row]
		if isnumber(ls_result_value) then
			pstr_property_value.value = ls_result_value
		end if
	CASE ELSE
		return 0
END CHOOSE

return 1


end function

public function boolean is_table_query ();
if pos(epro_object.base_tablename, " ") > 0 then return true
if pos(epro_object.base_tablename, ".") > 0 then return true
if pos(epro_object.base_tablename, "(") > 0 then return true

return false

end function

public subroutine set_parent_epro_object (str_epro_object_definition pstr_parent_epro_object, string ps_reference_object_key);
parent_epro_object = pstr_parent_epro_object

reference_object_key = ps_reference_object_key


end subroutine

on u_ds_epro_object_cache.create
call super::create
end on

on u_ds_epro_object_cache.destroy
call super::destroy
end on

