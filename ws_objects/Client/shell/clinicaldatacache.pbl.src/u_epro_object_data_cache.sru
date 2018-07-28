$PBExportHeader$u_epro_object_data_cache.sru
forward
global type u_epro_object_data_cache from nonvisualobject
end type
type str_treatment_type_treatment_key_field from structure within u_epro_object_data_cache
end type
end forward

type str_treatment_type_treatment_key_field from structure
	string		treatment_type
	string		treatment_key_field
end type

global type u_epro_object_data_cache from nonvisualobject
end type
global u_epro_object_data_cache u_epro_object_data_cache

type variables
private long epro_object_count
private string epro_object[]
private string epro_object_filter[]
private u_ds_epro_object_cache epro_object_data[]

private long last_epro_object


end variables

forward prototypes
public subroutine clear_cache ()
public function integer find_object_key (str_epro_object_definition pstr_epro_object, string ps_epro_object_key, str_property_specification pstr_property_specification, str_complete_context pstr_context, ref str_property_value pstr_property_value)
private function integer get_data_cache (str_epro_object_definition pstr_epro_object, ref u_ds_epro_object_cache puo_cache_data)
private function integer new_object_cache (str_epro_object_definition pstr_epro_object)
public function integer get_property (str_epro_object_definition pstr_epro_object, str_property_specification pstr_property, string ps_epro_object_key, str_complete_context pstr_context, ref str_property_value pstr_property_value)
public function integer get_property (str_epro_object_definition pstr_epro_object, str_property pstr_property, string ps_epro_object_key, str_complete_context pstr_context, ref str_property_value pstr_property_value)
public function integer get_property (str_epro_object_definition pstr_epro_object, string ps_property, string ps_epro_object_key, str_complete_context pstr_context, ref str_property_value pstr_property_value)
end prototypes

public subroutine clear_cache ();long i

for i = 1 to epro_object_count
	DESTROY epro_object_data[i]
next

last_epro_object = 0
epro_object_count = 0

end subroutine

public function integer find_object_key (str_epro_object_definition pstr_epro_object, string ps_epro_object_key, str_property_specification pstr_property_specification, str_complete_context pstr_context, ref str_property_value pstr_property_value);//str_property_value lstr_object_key
integer li_sts
u_ds_epro_object_cache luo_data_parent
u_ds_epro_object_cache luo_data_target
string ls_null
str_property_value lstr_temp_property_value
string ls_key_value

setnull(ls_null)

// See if the key in hand is the same as the foreign key
if upper(pstr_property_specification.property.function_name) = "NA" then
	ls_key_value = ""
elseif lower(pstr_epro_object.base_table_key_column) <> lower(pstr_property_specification.property.function_name) then
	// Get a data cache for the target object
	li_sts = get_data_cache(pstr_epro_object, luo_data_parent)
	if li_sts <= 0 then return -1
	// Use the specified property value along with the property specification to look up the target object record
	li_sts = luo_data_parent.get_property_value(ps_epro_object_key, pstr_property_specification, pstr_context, lstr_temp_property_value)
	if li_sts <= 0 then return li_sts
	
	ls_key_value = lstr_temp_property_value.value
else
	ls_key_value = ps_epro_object_key
end if
	

// Get a data cache for the target object
li_sts = get_data_cache(pstr_property_specification.referenced_epro_object, luo_data_target)
if li_sts <= 0 then return -1

luo_data_target.set_parent_epro_object(pstr_epro_object, ls_key_value)

// Use the specified property value along with the property specification to look up the target object record
li_sts = luo_data_target.resolve_object_reference(ls_key_value, pstr_property_specification, pstr_context, pstr_property_value)
if li_sts <= 0 then return li_sts


return 1

end function

private function integer get_data_cache (str_epro_object_definition pstr_epro_object, ref u_ds_epro_object_cache puo_cache_data);integer li_sts
long i
boolean lb_found
string ls_epro_object
string ls_epro_object_filter
string ls_virtual_table_state

ls_epro_object = lower(pstr_epro_object.epro_object)

if len(pstr_epro_object.base_tablename) > 0 then
	ls_epro_object_filter = lower(pstr_epro_object.base_table_filter)
	if isnull(ls_epro_object_filter) then ls_epro_object_filter = ""
else
	// virtual table
	ls_epro_object_filter = ""
	if len(pstr_epro_object.base_table_filter) > 0 then
		ls_virtual_table_state = pstr_epro_object.base_table_filter
	end if
end if

// If the last one referenced matches then use it
lb_found = false
if last_epro_object > 0 and last_epro_object <= epro_object_count then
	if ls_epro_object = epro_object[last_epro_object] and ls_epro_object_filter = epro_object_filter[last_epro_object] then
		puo_cache_data = epro_object_data[last_epro_object]
		puo_cache_data.set_virtual_table_state(ls_virtual_table_state)
		lb_found = true
	end if
end if

if not lb_found then
	for i = 1 to epro_object_count
		if ls_epro_object = epro_object[i] and ls_epro_object_filter = epro_object_filter[i] then
			puo_cache_data = epro_object_data[i]
			puo_cache_data.set_virtual_table_state(ls_virtual_table_state)
			last_epro_object = i
			lb_found = true
		end if
	next
end if

if not lb_found then
	// not found so create a new one
	li_sts = new_object_cache(pstr_epro_object)
	if li_sts <= 0 then return -1
	
	last_epro_object = epro_object_count
	puo_cache_data = epro_object_data[epro_object_count]
	puo_cache_data.set_virtual_table_state(ls_virtual_table_state)
end if

return 1

end function

private function integer new_object_cache (str_epro_object_definition pstr_epro_object);

epro_object_count++
epro_object[epro_object_count] = lower(pstr_epro_object.epro_object)

if len(pstr_epro_object.base_tablename) > 0 then
	if isnull(pstr_epro_object.base_table_filter) then
		epro_object_filter[epro_object_count] = ""
	else
		epro_object_filter[epro_object_count] = lower(pstr_epro_object.base_table_filter)
	end if
else
	epro_object_filter[epro_object_count] = ""
end if
epro_object_data[epro_object_count] = CREATE u_ds_epro_object_cache

epro_object_data[epro_object_count].initialize(pstr_epro_object)

return 1

end function

public function integer get_property (str_epro_object_definition pstr_epro_object, str_property_specification pstr_property, string ps_epro_object_key, str_complete_context pstr_context, ref str_property_value pstr_property_value);integer li_sts
u_ds_epro_object_cache luo_data
string ls_null

setnull(ls_null)

li_sts = get_data_cache(pstr_epro_object, luo_data)
if li_sts <= 0 then return -1

return luo_data.get_property_value(ps_epro_object_key, pstr_property, pstr_context, pstr_property_value)


end function

public function integer get_property (str_epro_object_definition pstr_epro_object, str_property pstr_property, string ps_epro_object_key, str_complete_context pstr_context, ref str_property_value pstr_property_value);str_property_specification lstr_property_specification

// Initialize property
setnull(lstr_property_specification.which_object.which_object_string)
setnull(lstr_property_specification.which_object.object_identifier)
setnull(lstr_property_specification.which_object.filter_statement)
setnull(lstr_property_specification.which_object.ordinal)
setnull(lstr_property_specification.which_object.object_key)
lstr_property_specification.property = pstr_property

return get_property(pstr_epro_object, lstr_property_specification, ps_epro_object_key, pstr_context, pstr_property_value)


end function

public function integer get_property (str_epro_object_definition pstr_epro_object, string ps_property, string ps_epro_object_key, str_complete_context pstr_context, ref str_property_value pstr_property_value);str_property lstr_property
integer li_sts

li_sts = datalist.find_epro_object_property(pstr_epro_object.epro_object, ps_property, lstr_property)
if li_sts <= 0 then 	return -1

return get_property(pstr_epro_object, lstr_property, ps_epro_object_key, pstr_context, pstr_property_value)


end function

on u_epro_object_data_cache.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_epro_object_data_cache.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

