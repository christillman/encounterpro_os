$PBExportHeader$u_ds_patient.sru
forward
global type u_ds_patient from u_ds_base_class
end type
end forward

global type u_ds_patient from u_ds_base_class
end type
global u_ds_patient u_ds_patient

type variables
string cpr_id
str_patient patient_cache
boolean patient_cache_valid

u_ds_data p_Patient_Authority

u_ds_data p_Object_Security



end variables

forward prototypes
private function string address ()
private function string address (string ps_line_delimiter)
private function string name ()
private subroutine load_cache ()
private function str_property_value get_property (string ps_property)
private function integer get_primary_authority (string ps_authority_type, ref str_patient_authority pstr_patient_authority)
private function boolean any_allergies ()
public function integer set_patient (string ps_cpr_id)
public function str_patient get_patient ()
public function str_property_value get_property (string ps_property, str_attributes pstr_attributes)
end prototypes

private function string address ();return address("~r~n")

end function

private function string address (string ps_line_delimiter);string ls_address
string ls_city_state_zip

ls_address = ""

if len(patient_cache.address_line_1) > 0 then ls_address += patient_cache.address_line_1

if len(patient_cache.address_line_2) > 0 then
	if len(ls_address) > 0 then ls_address += ps_line_delimiter
	ls_address += patient_cache.address_line_2
end if

ls_city_state_zip = ""
if len(patient_cache.city) > 0 then
	ls_city_state_zip += patient_cache.city
end if

if len(patient_cache.state) > 0 then
	if len(ls_city_state_zip) > 0 then ls_city_state_zip += ", "
	ls_city_state_zip += patient_cache.state
end if

if len(patient_cache.zip) > 0 then
	if len(ls_city_state_zip) > 0 then ls_city_state_zip += "  "
	ls_city_state_zip += patient_cache.zip
end if

if len(ls_city_state_zip) > 0 then
	if len(ls_address) > 0 then ls_address += ps_line_delimiter
	ls_address += ls_city_state_zip
end if

return ls_address


end function

private function string name ();string ls_name

ls_name = f_pretty_name_formatted( patient_cache.first_name, & 
												patient_cache.middle_name, & 
												patient_cache.last_name, & 
												patient_cache.nickname, & 
												patient_cache.name_suffix, & 
												patient_cache.name_prefix, & 
												patient_cache.degree, & 
												"Full")

return ls_name

end function

private subroutine load_cache ();datetime ldt_date_of_birth
long ll_attachment_location_id
integer li_sort_sequence
str_attachment_location lstr_attachment_location
integer li_test_patient

patient_cache.cpr_id = object.cpr_id[1]
patient_cache.race = object.race[1]
ldt_date_of_birth = object.date_of_birth[1]
patient_cache.sex = object.sex[1]
patient_cache.primary_language = object.primary_language[1]
patient_cache.marital_status = object.marital_status[1]
patient_cache.billing_id = object.billing_id[1]
patient_cache.ssn = object.ssn[1]
patient_cache.first_name = object.first_name[1]
patient_cache.last_name = object.last_name[1]
patient_cache.degree = object.degree[1]
patient_cache.name_prefix = object.name_prefix[1]
patient_cache.middle_name = object.middle_name[1]
patient_cache.name_suffix = object.name_suffix[1]
patient_cache.attachment_id = object.attachment_id[1]
patient_cache.primary_provider_id = object.primary_provider_id[1]
patient_cache.secondary_provider_id = object.secondary_provider_id[1]
patient_cache.last_update = object.last_update[1]
patient_cache.phone_number = object.phone_number[1]
patient_cache.patient_id = object.patient_id[1]
patient_cache.date_of_conception = object.date_of_conception[1]
patient_cache.patient_status = object.patient_status[1]
patient_cache.created = object.created[1]
patient_cache.created_by = object.created_by[1]
patient_cache.modified_by = object.modified_by[1]
patient_cache.office_id = object.office_id[1]
patient_cache.locked_by = object.locked_by[1]
patient_cache.attachment_location_id = object.attachment_location_id[1]
patient_cache.attachment_path = object.attachment_path[1]
patient_cache.referring_provider_id = object.referring_provider_id[1]
patient_cache.email_address = object.email_address[1]
patient_cache.nickname = object.nickname[1]
patient_cache.maiden_name = object.maiden_name[1]
patient_cache.address_line_1 = object.address_line_1[1]
patient_cache.address_line_2 = object.address_line_2[1]
patient_cache.city = object.city[1]
patient_cache.state = object.state[1]
patient_cache.zip = object.zip[1]
patient_cache.country = object.country[1]
ll_attachment_location_id = object.attachment_location_id[1]
li_test_patient = object.test_patient[1]

patient_cache.date_of_birth = date(ldt_date_of_birth)
patient_cache.time_of_birth = time(ldt_date_of_birth)


if isnull(ll_attachment_location_id) then
	ll_attachment_location_id = datalist.get_attachment_location_assignment(cpr_id)

	if ll_attachment_location_id > 0 then
		UPDATE p_Patient
		SET attachment_location_id = :ll_attachment_location_id
		WHERE cpr_id = :cpr_id;
		if not tf_check() then return
	end if
end if

lstr_attachment_location = datalist.get_attachment_location(ll_attachment_location_id)

patient_cache.attachment_server = lstr_attachment_location.attachment_server
patient_cache.attachment_share = lstr_attachment_location.attachment_share

if li_test_patient = 0 then
	patient_cache.test_patient = false
else
	patient_cache.test_patient = true
end if

patient_cache_valid = true


end subroutine

private function str_property_value get_property (string ps_property);string ls_null
long ll_row
integer li_column_id
long ll_property_id
string ls_coltype
integer li_length
integer li_pos
str_property_value lstr_property_value
str_property lstr_property
str_attributes lstr_attributes
long ll_object_key
string ls_progress_type
string ls_progress_key

setnull(ls_null)
setnull(ll_object_key)

lstr_property_value = f_empty_property_value()

if rowcount() < 1 then
	return lstr_property_value
else
	ll_row = 1
end if

// First see if the property is a column
li_column_id = column_id(ps_property)

if li_column_id > 0 then
	// Get the column type
	ls_coltype = trim(upper(Describe(ps_property + ".ColType")))
	
	// strip off the size
	li_pos = pos(ls_coltype, "(")
	if li_pos > 0 then
		li_length = integer(mid(ls_coltype, li_pos + 1, len(ls_coltype) - li_pos - 1))
		ls_coltype = left(ls_coltype, li_pos - 1)
	end if
	
	CHOOSE CASE ls_coltype
		CASE "CHAR"
			lstr_property_value.value = object.data[ll_row, li_column_id]
			// To handle the description-lengthening, see if the length is 80 and all 80 bytes are used
			if li_length = 80 and len(lstr_property_value.value) = 80 then
				// If so, then get the value from the database
				lstr_property_value.value = f_get_progress_value(current_patient.cpr_id, &
																context_object, &
																ll_object_key, &
																"Modify", &
																ps_property)
			end if
		CASE "DATE"
			lstr_property_value.value = string(date(object.data[ll_row, li_column_id]))
		CASE "DATETIME"
			lstr_property_value.value = string(datetime(object.data[ll_row, li_column_id]))
		CASE "DECIMAL"
			lstr_property_value.value = string(dec(object.data[ll_row, li_column_id]))
		CASE "INT"
			lstr_property_value.value = string(integer(object.data[ll_row, li_column_id]))
		CASE "LONG"
			lstr_property_value.value = string(long(object.data[ll_row, li_column_id]))
		CASE "NUMBER"
			lstr_property_value.value = string(object.data[ll_row, li_column_id])
		CASE "REAL"
			lstr_property_value.value = string(real(object.data[ll_row, li_column_id]))
		CASE "TIME"
			lstr_property_value.value = string(time(object.data[ll_row, li_column_id]))
		CASE "TIMESTAMP"
			lstr_property_value.value = string(object.data[ll_row, li_column_id])
		CASE "ULONG"
			lstr_property_value.value = string(object.data[ll_row, li_column_id])
		CASE ELSE
			lstr_property_value.value = string(object.data[ll_row, li_column_id])
	END CHOOSE
	
else
	// If we don't recognize the property as a column, then look for it as an extended property
	f_split_string(ps_property, ".", ls_progress_type, ls_progress_key)
	if ls_progress_key = "" then
		ls_progress_key = ls_progress_type
		ls_progress_type = "Property"
	end if
	
	lstr_property_value.value = f_get_progress_value(current_patient.cpr_id, context_object, ll_object_key, ls_progress_type, ls_progress_key)
end if

lstr_property_value.display_value = f_property_value_display(ps_property, lstr_property_value.value)

return lstr_property_value

end function

private function integer get_primary_authority (string ps_authority_type, ref str_patient_authority pstr_patient_authority);
SELECT a.cpr_id, a.authority_type, a.authority_sequence, a.authority_id, c.name
INTO :pstr_patient_authority.cpr_id,
		:pstr_patient_authority.authority_type,
		:pstr_patient_authority.authority_sequence,
		:pstr_patient_authority.authority_id,
		:pstr_patient_authority.authority_name
FROM p_Patient_Authority a
	INNER JOIN c_Authority c
	ON a.authority_id = c.authority_id
WHERE a.cpr_id = :cpr_id
AND a.authority_type = :ps_authority_type
AND a.authority_sequence = 1;
if not tf_check() then return -1

return 1

end function

private function boolean any_allergies ();long ll_count

SELECT count(*)
INTO :ll_count
FROM p_Assessment
WHERE cpr_id = :cpr_id
AND assessment_type='ALLERGY'
AND assessment_status IS NULL;
if not tf_check() then return false

if ll_count > 0 then return true

return false

end function

public function integer set_patient (string ps_cpr_id);integer li_sts

patient_cache_valid = false

set_dataobject("dw_p_patient")
li_sts = retrieve(ps_cpr_id)
if li_sts < 0 then return -1

cpr_id = ps_cpr_id

return li_sts

end function

public function str_patient get_patient ();str_patient lstr_patient

if isnull(cpr_id) then
	log.log(this, "u_ds_patient.get_patient.0004", "cpr_id has not been set", 4)
	setnull(lstr_patient.cpr_id)
	return lstr_patient
end if

if not patient_cache_valid then
	load_cache( )
end if

return patient_cache

end function

public function str_property_value get_property (string ps_property, str_attributes pstr_attributes);string ls_null
long ll_row
integer li_column_id
long ll_null
long ll_property_id
str_property_value lstr_property_value
u_user luo_provider
integer li_sts
str_patient_authority lstr_authority
str_property lstr_property
str_attributes lstr_attributes
string ls_date
date ld_date
string ls_guardian_cpr_id

if isnull(cpr_id) then
	log.log(this, "u_ds_patient.get_property.0017", "cpr_id has not been set", 4)
	lstr_property_value = f_empty_property_value()
	return lstr_property_value
end if

setnull(ls_null)
setnull(ll_null)

setnull(lstr_property_value.value)
setnull(lstr_property_value.textcolor)
setnull(lstr_property_value.backcolor)
setnull(lstr_property_value.weight)

if not patient_cache_valid then
	load_cache()
end if

CHOOSE CASE lower(ps_property)
	CASE "address"
		lstr_property_value.value = address()
	CASE "address1line"
		lstr_property_value.value = address(" ")
	CASE "age"
		ls_date = f_attribute_find_attribute(pstr_attributes, "property_date")
		if isdate(ls_date) then
			ld_date = date(ls_date)
		else
			ld_date = today()
		end if
		lstr_property_value.value = f_pretty_age(patient_cache.date_of_birth, ld_date)
	CASE "date_of_birth"
		lstr_property_value.value = string(patient_cache.date_of_birth, "[shortdate]")
	CASE "full_name"
		lstr_property_value.value = name()
	CASE "primary_office"
		lstr_property_value.value = datalist.office_description(patient_cache.office_id)
	CASE "phone_number"
		lstr_property_value.value = patient_cache.phone_number
	CASE "primary_guardian"
		SELECT TOP 1 relation_cpr_id,  dbo.fn_patient_full_name(relation_cpr_id)
		INTO :lstr_property_value.value, :lstr_property_value.display_value
		FROM dbo.fn_patient_relations(:cpr_id, 'Primary Guardian');
		if not tf_check() then
			lstr_property_value = f_empty_property_value()
			return lstr_property_value
		end if
	CASE "primary_provider"
		luo_provider = user_list.find_user(patient_cache.primary_provider_id)
		if not isnull(luo_provider) then
			lstr_property_value.value = luo_provider.user_short_name
			lstr_property_value.backcolor = luo_provider.color
		else
			setnull(lstr_property_value.value)
		end if
	CASE "primary_payor"
		li_sts = get_primary_authority("Payor", lstr_authority)
		if li_sts > 0 then
			lstr_property_value.value = lstr_authority.authority_name
		else
			setnull(lstr_property_value.value)
		end if
	CASE "sex_male_female"
		if upper(patient_cache.sex) = "F" then
			lstr_property_value.value = "female"
		else
			lstr_property_value.value = "male"
		end if
	CASE "allergies"
		if any_allergies() then
			lstr_property_value.value = "Allergies"
			lstr_property_value.textcolor = COLOR_RED
			lstr_property_value.weight = 700
		else
			lstr_property_value.value = "No Allergies"
			lstr_property_value.textcolor = COLOR_BLACK
			lstr_property_value.weight = 400
		end if
	CASE ELSE
		lstr_property_value = get_property(ps_property)
END CHOOSE
// Get the pretty display value
lstr_property_value.display_value = f_property_value_display(ps_property, lstr_property_value.value)

return lstr_property_value

end function

on u_ds_patient.create
call super::create
end on

on u_ds_patient.destroy
call super::destroy
end on

event constructor;call super::constructor;setnull(cpr_id)
context_object = "Patient"

end event

