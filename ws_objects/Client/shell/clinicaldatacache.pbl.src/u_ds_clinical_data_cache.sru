$PBExportHeader$u_ds_clinical_data_cache.sru
forward
global type u_ds_clinical_data_cache from u_ds_data
end type
type str_treatment_type_treatment_key_field from structure within u_ds_clinical_data_cache
end type
end forward

type str_treatment_type_treatment_key_field from structure
	string		treatment_type
	string		treatment_key_field
end type

global type u_ds_clinical_data_cache from u_ds_data
end type
global u_ds_clinical_data_cache u_ds_clinical_data_cache

type variables
private string context_object

private string cpr_id
private long object_key

private boolean cache_valid
private time cache_timestamp

private long property_count
private string property[]

private string context_tablename
private long context_table_columncount
private string context_table_columnnames[]
private string linked_tablename
private string linked_columnname
private string sql_base
private string dw_syntax


long max_cache_age = 6

// treatment_type_key cache
private integer treatment_type_key_count
private str_treatment_type_treatment_key_field treatment_type_key[]

private u_ds_data p_Object_Security
private u_ds_data treatment_assessments

private str_treatment_description treatment_struct
private boolean struct_cache_valid


end variables

forward prototypes
public function integer load_clinical_data (string ps_cpr_id, string ps_context_object, long pl_object_key)
public function integer initialize (string ps_context_object)
public subroutine clear_cache ()
public function str_property_value get_property (string ps_property)
public function integer modify_property (string ps_property, string ps_new_value)
public function string get_treatment_key (long pl_row)
public function str_access_control_list get_access_control_list ()
public function integer get_treatment (str_treatment_description pstr_treatment)
private function integer get_treatment_assessments (ref long pl_problem_id[])
end prototypes

public function integer load_clinical_data (string ps_cpr_id, string ps_context_object, long pl_object_key);string ls_cpr_id
long ll_object_key
string ls_sql
integer li_sts
long ll_count

if isnull(ps_cpr_id) or isnull(ps_context_object) then return 0

if isnull(context_object) or lower(context_object) <> lower(ps_context_object) then
	li_sts = initialize(ps_context_object)
	if li_sts < 0 then return -1
end if

// if we don't have a row, then we must not be valid
if rowcount() > 0 then
	// First see if the patient matches
	if secondsafter(cache_timestamp, now()) > max_cache_age then
		cache_valid = false
	else
		ls_cpr_id = object.cpr_id[1]
		if isnull(ls_cpr_id) then
			cache_valid = false
		elseif lower(ls_cpr_id) <> lower(ps_cpr_id) then
			cache_valid = false
		end if
	end if
	
	
	// Then see if the object_key matches 
	CHOOSE CASE lower(ps_context_object)
		CASE "encounter"
			if isnull(pl_object_key) then return 0
			ll_object_key = object.encounter_id[1]
			if isnull(ll_object_key) then
				cache_valid = false
			elseif ll_object_key <> pl_object_key then
				cache_valid = false
			end if
		CASE "assessment"
			if isnull(pl_object_key) then return 0
			ll_object_key = object.assessment_id[1]
			if isnull(ll_object_key) then
				cache_valid = false
			elseif ll_object_key <> pl_object_key then
				cache_valid = false
			end if
		CASE "treatment"
			if isnull(pl_object_key) then return 0
			ll_object_key = object.treatment_id[1]
			if isnull(ll_object_key) then
				cache_valid = false
			elseif ll_object_key <> pl_object_key then
				cache_valid = false
			end if
		CASE "attachment"
			if isnull(pl_object_key) then return 0
			ll_object_key = object.attachment_id[1]
			if isnull(ll_object_key) then
				cache_valid = false
			elseif ll_object_key <> pl_object_key then
				cache_valid = false
			end if
	END CHOOSE
else
	cache_valid = false
end if

// if the cache is valid then just return
if cache_valid then return 1

ls_sql = sql_base
ls_sql += " WHERE a.cpr_id = '" + ps_cpr_id + "'"

CHOOSE CASE lower(context_object)
	CASE "patient"
	CASE "encounter"
		ls_sql += " AND a.encounter_id=" + string(pl_object_key)
	CASE "assessment"
		ls_sql += " AND a.problem_id=" + string(pl_object_key)
		ls_sql += " AND a.current_flag='Y'"
	CASE "treatment"
		ls_sql += " AND a.treatment_id=" + string(pl_object_key)
	CASE "attachment"
		ls_sql += " AND a.attachment_id=" + string(pl_object_key)
	CASE ELSE
		return -1
END CHOOSE

settransobject(sqlca)
setsqlselect(ls_sql)
ll_count = retrieve()
if ll_count < 0 then return -1
if ll_count = 0 then return 0

// reset the cache timestamp
cache_timestamp = now()

cpr_id = ps_cpr_id
object_key = pl_object_key

return 1


end function

public function integer initialize (string ps_context_object);long i, j
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

context_object = ps_context_object

CHOOSE CASE lower(context_object)
	CASE "patient"
		context_tablename = "p_Patient"
		setnull(linked_tablename)
	CASE "encounter"
		context_tablename = "p_Patient_Encounter"
		setnull(linked_tablename)
	CASE "assessment"
		context_tablename = "p_Assessment"
		linked_tablename = "c_Assessment_Definition"
		linked_columnname = "assessment_id"
	CASE "treatment"
		context_tablename = "p_Treatment_Item"
		linked_tablename = "c_Treatment_Type"
		linked_columnname = "treatment_type"
	CASE "attachment"
		context_tablename = "p_Attachment"
		setnull(linked_tablename)
	CASE ELSE
		return -1
END CHOOSE

// Get the column list from the context table
ls_column_list = ""
context_table_columncount = sqlca.table_column_list(context_tablename, context_table_columnnames)
if context_table_columncount <= 0 then
	log.log(this, "u_ds_clinical_data_cache.initialize:0041", "Error getting column list for table (" + context_tablename + ")", 4)
	return -1
end if
for i = 1 to context_table_columncount
	if i > 1 then ls_column_list += ", "
	ls_column_list += "a." + context_table_columnnames[i]
next

// If we're linked to a table, get the column list from that
if len(linked_tablename) > 0 then
	ll_linked_column_count = sqlca.table_column_list(linked_tablename, lsa_linked_columns)
	for i = 1 to ll_linked_column_count
		ls_this_columnname = lsa_linked_columns[i]
		// First make sure the column is not already in the list
		for j = 1 to context_table_columncount
			// If the linked table column matches a column in the context table, then prefix the tablename to the column alias
			if lower(ls_this_columnname) = lower(context_table_columnnames[j]) then
				ls_this_columnname = linked_tablename + "_" + ls_this_columnname
				exit
			end if
		next
		ls_column_list += ", "
		ls_column_list += "b." + lsa_linked_columns[i] + " as " + ls_this_columnname
	next
end if

sql_base = "SELECT " + ls_column_list + " FROM " + context_tablename + " a "
if len(linked_tablename) > 0 then
	sql_base += " INNER JOIN " + linked_tablename + " b "
	sql_base += " ON a." + linked_columnname + " = b." + linked_columnname
end if


ls_sql = sql_base + " WHERE a.cpr_id = '" + cpr_id + "'"

ls_syntax = sqlca.SyntaxFromSQL(ls_sql, "", ls_error_string)

if len(ls_error_string) > 0 then
	log.log(this, "u_ds_clinical_data_cache.initialize:0079", "Error getting syntax: SQL=" + ls_sql + ", ERROR=" + ls_error_string, 4)
	return -1
end if

dw_syntax = ls_syntax

// Create the datastore
Create(dw_syntax, ls_error_create)
if Len(ls_error_create) > 0 THEN
	if isnull(ls_error_create) then ls_error_create = "<Null>"
	log.log(this, "u_ds_clinical_data_cache.initialize:0089", "Error creating datastore (" + ls_error_create + ")", 4)
	return -1
end if


return 1

end function

public subroutine clear_cache ();cache_valid = false

end subroutine

public function str_property_value get_property (string ps_property);str_property_value lstr_property_value
string ls_null
integer li_column_id
string ls_value
string ls_coltype
long ll_pos
long ll_length
string ls_progress_type
string ls_progress_key

setnull(ls_null)

li_column_id = column_id(ps_property)

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
	lstr_property_value.data = object.data[1, li_column_id]
	
	// Convert the data to a string
	CHOOSE CASE ClassName(lstr_property_value.data)
		CASE "string"
			lstr_property_value.value = string(lstr_property_value.data)
			if (ll_length = 80 and len(lstr_property_value.value) = 80) then
				lstr_property_value.value = f_get_progress_value(cpr_id, &
																context_object, &
																object_key, &
																"Modify", &
																ps_property)
			end if
		CASE "integer"
			lstr_property_value.value = string(integer(lstr_property_value.data))
		CASE "long"
			lstr_property_value.value = string(long(lstr_property_value.data))
		CASE "datetime"
			lstr_property_value.value = string(datetime(lstr_property_value.data))
			if right(lstr_property_value.value, 9) = " 00:00:00" then
				lstr_property_value.value = left(lstr_property_value.value, len(lstr_property_value.value) - 9)
			end if
		CASE "date"
			lstr_property_value.value = string(date(lstr_property_value.data))
		CASE "time"
			lstr_property_value.value = string(time(lstr_property_value.data))
		CASE "real"
			lstr_property_value.value = string(real(lstr_property_value.data))
		CASE ELSE
			lstr_property_value.value = string(lstr_property_value.data)
	END CHOOSE
	
	
else
	// If we don't recognize the property as a column, then look for it as an extended property
	f_split_string(ps_property, ".", ls_progress_type, ls_progress_key)
	if ls_progress_key = "" then
		ls_progress_key = ls_progress_type
		ls_progress_type = "Property"
	end if
	
	// If we don't recognize the property as a column, then look for it as an extended property
	lstr_property_value.value = f_get_progress_value(cpr_id, context_object, object_key, ls_progress_type, ls_progress_key)
end if

lstr_property_value.display_value = f_property_value_display(ps_property, lstr_property_value.value)

return lstr_property_value

end function

public function integer modify_property (string ps_property, string ps_new_value);integer li_sts
string ls_progress_type
long ll_attachment_id
datetime ldt_progress_date_time
long ll_risk_level
long ll_patient_workplan_item_id
str_attributes lstr_attributes
str_property_value lstr_property_value
boolean lb_found
long i

setnull(ll_attachment_id)
setnull(ldt_progress_date_time)
setnull(ll_risk_level)
setnull(ll_patient_workplan_item_id)

// See if property is a context table column
lb_found = false
for i = 1 to context_table_columncount
	if lower(ps_property) = lower(context_table_columnnames[i]) then
		lb_found = true
		exit
	end if
next

if lb_found then
	ls_progress_type = "Modify"
else
	ls_progress_type = "Property"
end if

lstr_property_value = get_property(ps_property)

if f_is_modified(lstr_property_value.value, ps_new_value) then
	li_sts = f_set_progress(cpr_id, &
									context_object, &
									object_key, &
									ls_progress_type, &
									ps_property, &
									ps_new_value, &
									ldt_progress_date_time, &
									ll_risk_level, &
									ll_attachment_id, &
									ll_patient_workplan_item_id)
	if li_sts < 0 then return -1
end if

return 1




end function

public function string get_treatment_key (long pl_row);string ls_treatment_type
string ls_treatment_key_field
boolean lb_found
integer i
string ls_treatment_key
string ls_null
string ls_coltype

setnull(ls_null)

if isnull(pl_row) or pl_row <= 0 then return ls_null

ls_treatment_type = upper(object.treatment_type[pl_row])

lb_found = false
for i = 1 to treatment_type_key_count
	if treatment_type_key[i].treatment_type = ls_treatment_type then
		lb_found = true
		ls_treatment_key_field = treatment_type_key[i].treatment_key_field
		exit
	end if
next

// If we didn't find it in the cache then query the database
if not lb_found then
	ls_treatment_key_field = sqlca.fn_treatment_type_treatment_key(ls_treatment_type)
	if not tf_check() then return ls_null
	
	if len(ls_treatment_key_field) > 0 then
		// Save it in the cache
		treatment_type_key_count += 1
		treatment_type_key[treatment_type_key_count].treatment_type = ls_treatment_type
		treatment_type_key[treatment_type_key_count].treatment_key_field = ls_treatment_key_field
	else
		return ls_null
	end if
end if


ls_coltype = describe(ls_treatment_key_field + ".ColType")
CHOOSE CASE lower(left(ls_coltype, 5))
	CASE "char ", "char("
		ls_treatment_key = getitemstring(pl_row, ls_treatment_key_field)
	CASE "date"
		ls_treatment_key = string(getitemdate(pl_row, ls_treatment_key_field))
	CASE "datet"
		ls_treatment_key = string(getitemdatetime(pl_row, ls_treatment_key_field))
	CASE "decim"
		ls_treatment_key = string(getitemdecimal(pl_row, ls_treatment_key_field))
	CASE "int"
		ls_treatment_key = string(getitemnumber(pl_row, ls_treatment_key_field))
	CASE "long"
		ls_treatment_key = string(getitemnumber(pl_row, ls_treatment_key_field))
	CASE "numbe"
		ls_treatment_key = string(getitemnumber(pl_row, ls_treatment_key_field))
	CASE "real"
		ls_treatment_key = string(getitemnumber(pl_row, ls_treatment_key_field))
	CASE "time"
		ls_treatment_key = string(getitemtime(pl_row, ls_treatment_key_field))
	CASE "times"
		ls_treatment_key = string(getitemtime(pl_row, ls_treatment_key_field))
	CASE "ulong"
		ls_treatment_key = string(getitemnumber(pl_row, ls_treatment_key_field))
END CHOOSE

return ls_treatment_key

end function

public function str_access_control_list get_access_control_list ();long ll_rowcount
long i
str_access_control_list lstr_list
str_access_control_item lstr_item
string ls_access_flag

ll_rowcount = p_object_security.retrieve(cpr_id, context_object, object_key)

lstr_list.access_count = 0

if int(object.default_grant[1]) = 0 then
	lstr_list.default_grant = false
else
	lstr_list.default_grant = true
end if

for i = 1 to ll_rowcount
	ls_access_flag = p_object_security.object.access_flag[i]
	if upper(ls_access_flag) = "G" then
		lstr_item.grant_access = true
	else
		lstr_item.grant_access = false
	end if
	lstr_item.user_id = p_object_security.object.user_id[i]
	
	// Add the item to the list
	lstr_list.access_count += 1
	lstr_list.access_list[lstr_list.access_count] = lstr_item
next


return lstr_list


end function

public function integer get_treatment (str_treatment_description pstr_treatment);string ls_description
integer li_sts

if struct_cache_valid then
	pstr_treatment = treatment_struct
	return 1
end if

treatment_struct = f_empty_treatment()

treatment_struct.treatment_id = object.treatment_id[1]
treatment_struct.treatment_type = object.treatment_type[1]
treatment_struct.treatment_description = object.treatment_description[1]
treatment_struct.begin_date = object.begin_date[1]
treatment_struct.end_date = object.end_date[1]
treatment_struct.treatment_status = object.treatment_status[1]
treatment_struct.open_encounter_id = object.open_encounter_id[1]
treatment_struct.close_encounter_id = object.close_encounter_id[1]
treatment_struct.parent_treatment_id = object.parent_treatment_id[1]
treatment_struct.observation_id = object.observation_id[1]
// Check for previous bug that set observation_id to empty string
if trim(treatment_struct.observation_id) = "" then setnull(treatment_struct.observation_id)
treatment_struct.drug_id = object.drug_id[1]
treatment_struct.package_id = object.package_id[1]
treatment_struct.specialty_id = object.specialty_id[1]
treatment_struct.procedure_id = object.procedure_id[1]
treatment_struct.location = object.location[1]
treatment_struct.ordered_by = object.ordered_by[1]
treatment_struct.material_id = object.material_id[1]
treatment_struct.treatment_mode = object.treatment_mode[1]
treatment_struct.observation_type = object.observation_type[1]
treatment_struct.created = object.created[1]
treatment_struct.created_by = object.created_by[1]


treatment_struct.dose_amount = object.dose_amount[1]
treatment_struct.dose_unit = object.dose_unit[1]
treatment_struct.duration_amount = object.duration_amount[1]
treatment_struct.duration_unit = object.duration_unit[1]
treatment_struct.duration_prn = object.duration_prn[1]
treatment_struct.dispense_amount = object.dispense_amount[1]
treatment_struct.office_dispense_amount = object.office_dispense_amount[1]
treatment_struct.dispense_unit = object.dispense_unit[1]
treatment_struct.administration_sequence = object.administration_sequence[1]
treatment_struct.administer_frequency = object.administer_frequency[1]
treatment_struct.refills = object.refills[1]
treatment_struct.brand_name_required = object.brand_name_required[1]
treatment_struct.maker_id = object.maker_id[1]
treatment_struct.lot_number = object.lot_number[1]
treatment_struct.expiration_date = object.expiration_date[1]
treatment_struct.specimen_id = object.specimen_id[1]
treatment_struct.ordered_by_supervisor = object.ordered_by_supervisor[1]
treatment_struct.appointment_date_time = object.appointment_date_time[1]
treatment_struct.ordered_for = object.ordered_for[1]
treatment_struct.completed_by = object.completed_by[1]

treatment_struct.treatment_key = get_treatment_key(1)

treatment_struct.problem_count = get_treatment_assessments(treatment_struct.problem_ids)

// if the treatment description is 80 characters long then it may be more, so get the 
// progress record if there is one
if len(treatment_struct.treatment_description) = 80 then
	ls_description = f_get_progress_value(cpr_id, &
											"Treatment", &
											treatment_struct.treatment_id, &
											"Modify", &
											"treatment_description")
	if left(ls_description, 80) = treatment_struct.treatment_description then
		treatment_struct.treatment_description = ls_description
	end if
end if

treatment_struct.access_control_list = get_access_control_list()

struct_cache_valid = true

return 1

end function

private function integer get_treatment_assessments (ref long pl_problem_id[]);long ll_at_count
long i

ll_at_count = treatment_assessments.retrieve(cpr_id, object_key)

for i = 1 to ll_at_count
	pl_problem_id[i] = treatment_assessments.object.problem_id[i]
next

return ll_at_count




end function

on u_ds_clinical_data_cache.create
call super::create
end on

on u_ds_clinical_data_cache.destroy
call super::destroy
end on

event constructor;call super::constructor;p_Object_Security = CREATE u_ds_data
p_Object_Security.set_dataobject("dw_p_object_security")

treatment_assessments = CREATE u_ds_data
treatment_assessments.set_dataobject("dw_assessment_treatment_data_1")

end event

