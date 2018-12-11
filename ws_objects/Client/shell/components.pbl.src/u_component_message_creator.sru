$PBExportHeader$u_component_message_creator.sru
forward
global type u_component_message_creator from u_component_base_class
end type
end forward

global type u_component_message_creator from u_component_base_class
end type
global u_component_message_creator u_component_message_creator

type variables
string message_type
string message_file
string message_description

str_message_part parts[]
long part_count

// instance variables used to reduce the number of lookups
// to perform the diagnosis_sequence workaround
// (see fkey_where_clause())
string diagnosis_sequence_where_clause
integer diagnosis_sequence_cache

end variables

forward prototypes
protected function integer xx_create_message ()
public function integer create_message (ref string ps_message_file, string ps_message_type, integer pi_attribute_count, str_attribute pstra_attributes[])
private function integer load_parts ()
private function integer get_message_file ()
protected function integer process_parts ()
protected function integer archive_parts ()
public subroutine fix_query (ref string ps_query)
protected function integer process_fkeys (integer pi_part)
private function integer load_fkeys (ref str_message_part pstr_part)
private function integer initialize_message (integer pi_count, string lsa_attributes[], string lsa_values[])
private function string fkey_where_clause (u_ds_data puo_data, str_message_fkey pstr_fkey, long pl_row)
protected function integer copy_fkeys_from_message (str_message_part pstr_part, integer pi_fkey, u_ds_data puo_data)
protected function integer copy_fkeys_from_database (str_message_part pstr_part, integer pi_fkey, u_ds_data puo_data)
protected function integer copy_fkeys_from_both (str_message_part pstr_part, integer pi_fkey, u_ds_data puo_data)
protected function integer process_part_special (str_message_part pstr_part, string ps_query)
public function integer get_attachment_files ()
end prototypes

protected function integer xx_create_message ();string lsa_attributes[]
string lsa_values[]
integer li_count
integer li_sts

li_count = get_attributes(lsa_attributes, lsa_values)
	
if ole_class then
	return ole.create_message(message_file, message_type, li_count, lsa_attributes, lsa_values)
else
	// This is the default message processing to do if xx_create_message is not overridden by a decendent class
	li_sts = db_connect(message_file)
	if li_sts <= 0 then
		mylog.log(this, "u_component_message_creator.xx_create_message:0014", "Unable to connect to message database (" + message_file + ")", 4)
		return -1
	end if
	
	li_sts = initialize_message(li_count, lsa_attributes, lsa_values)
	if li_sts <= 0 then
		mylog.log(this, "u_component_message_creator.xx_create_message:0020", "Error initializing message", 4)
		return -1
	end if

	li_sts = process_parts()
	if li_sts <= 0 then
		mylog.log(this, "u_component_message_creator.xx_create_message:0026", "Error processing parts", 4)
		return -1
	end if

	li_sts = archive_parts()
	if li_sts <= 0 then
		mylog.log(this, "u_component_message_creator.xx_create_message:0032", "Error archiving parts into message file (" + message_file + ")", 4)
		return -1
	end if

	return 1
end if


end function

public function integer create_message (ref string ps_message_file, string ps_message_type, integer pi_attribute_count, str_attribute pstra_attributes[]);integer li_sts
string ls_temp
string ls_template_location
string ls_message_location
string ls_template_file
string ls_filename
string ls_extension
long ll_message_number

mylog.log(this, "u_component_message_creator.create_message:0010", "Creating Message (" + ps_message_type + ")", 2)

// Record parameters
message_type = ps_message_type
//add_attributes(pi_attribute_count, pstra_attributes)

// Determine the message file
li_sts = get_message_file()
if li_sts < 0 then
	mylog.log(this, "u_component_message_creator.create_message:0019", "Error getting message file", 4)
	return -1
end if

// Load message parts
li_sts = load_parts()
if li_sts < 0 then
	mylog.log(this, "u_component_message_creator.create_message:0026", "Error loading message parts", 4)
	return -1
end if

// Finally, create the message
li_sts = xx_create_message()
if li_sts <= 0 then return li_sts

// If all went well, return the message file spec to the caller
ps_message_file = message_file

mylog.log(this, "u_component_message_creator.create_message:0037", "Successfully created message (" + ps_message_type + ")", 2)

return 1

end function

private function integer load_parts ();long i
long j
long ll_fkeys
integer li_sts
string ls_query
string ls_part_query
long ll_message_part_sequence
u_ds_data luo_parts
u_ds_data luo_fkeys

luo_parts = CREATE u_ds_data
luo_parts.set_database(cprdb)

luo_fkeys = CREATE u_ds_data
luo_fkeys.set_dataobject("dw_fkey_altkeys", cprdb)

ls_query = "SELECT message_part_sequence, part_type, part_table, part_order FROM c_Message_Part WHERE message_type = '" + message_type + "' ORDER BY part_order, message_part_sequence"
part_count = luo_parts.load_query(ls_query)
if part_count < 0 then return -1

for i = 1 to part_count
	parts[i].message_part_sequence = luo_parts.object.message_part_sequence[i]
	parts[i].part_type = luo_parts.object.part_type[i]
	parts[i].part_table = luo_parts.object.part_table[i]
	SELECT part_query
	INTO :parts[i].part_query
	FROM c_Message_Part
	WHERE message_type = :message_type
	AND message_part_sequence = :parts[i].message_part_sequence
	USING cprdb;
	if not cprdb.check() then return -1
	
	li_sts = load_fkeys(parts[i])
	if li_sts < 0 then return -1
next

DESTROY luo_parts
DESTROY luo_fkeys

return 1

end function

private function integer get_message_file ();integer li_sts
string ls_temp
string ls_template_location
string ls_message_location
string ls_template_file
string ls_filename
string ls_extension
long ll_message_number

// Get template file from database
SELECT template_file, description
INTO :ls_template_file, :message_description
FROM c_Message_Definition
WHERE message_type = :message_type
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_message_creator.get_message_file:0018", "Message type not found (" + message_type + ")", 4)
	return -1
end if

if isnull(ls_template_file) then
	ls_template_file = "generic_message.mdb"
end if

f_split_string(ls_template_file, ".", ls_filename, ls_extension)

ls_message_location = temp_path
if not mylog.of_directoryexists(ls_message_location) then
	mylog.log(this, "u_component_message_creator.get_message_file:0030", "Error getting temp path "+ls_message_location, 4)
	return -1
end if
if right(ls_message_location, 1) <> "\" then ls_message_location += "\"

// Construct the filename using a component counter
ll_message_number = next_component_counter("file_number")
if ll_message_number <= 0 or isnull(ll_message_number) then
	mylog.log(this, "u_component_message_creator.get_message_file:0038", "Error getting next file number", 4)
	return -1
end if
message_file = message_type + "_" + gnv_app.office_id + "_OUT_" + string(ll_message_number) + "." + ls_extension

if right(ls_message_location, 1) = "\" then
	message_file = ls_message_location + message_file
else
	message_file = ls_message_location + "\" + message_file
end if

return 1
end function

protected function integer process_parts ();integer li_sts
string ls_drive
string ls_directory
string ls_filename
string ls_extension
string ls_path
string ls_query

integer i
u_ds_data luo_data

f_parse_filepath(message_file, ls_drive, ls_directory, ls_filename, ls_extension)
ls_path = ls_drive + ls_directory + "\"

luo_data = CREATE u_ds_data

for i = 1 to part_count
	mylog.log(this, "u_component_message_creator.process_parts:0018", "Processing part (" + string(parts[i].message_part_sequence) + ", " + parts[i].part_table + ")", 1)
	ls_query = parts[i].part_query
	if not isnull(ls_query) then fix_query(ls_query)
	CHOOSE CASE parts[i].part_type
		CASE "TABLE"
			li_sts = luo_data.save_table_to_table(cprdb, mydb, parts[i].part_table, ls_query)
		CASE "QUERY"
			li_sts = luo_data.save_query_to_table(cprdb, mydb, ls_query, parts[i].part_table)
		CASE "SYNTAX"
			li_sts = luo_data.save_syntax_to_table(cprdb, mydb, ls_query, parts[i].part_table)
		CASE "SPECIAL"
			li_sts = process_part_special(parts[i],ls_query)
		CASE ELSE
			mylog.log(this, "u_component_message_creator.process_parts:0031", parts[i].part_type + " Part Type is not supported", 3)
			continue
	END CHOOSE
	
	if li_sts < 0 then
		mylog.log(this, "u_component_message_creator.process_parts:0036", "Error loading data for part(" + string(parts[i].message_part_sequence) + ", " + parts[i].part_table + ")", 4)
		return -1
	end if
	
	if parts[i].part_type <> "SPECIAL" then
		li_sts = process_fkeys(i)
		if li_sts < 0 then
			mylog.log(this, "u_component_message_creator.process_parts:0043", "Error processing fkeys for part(" + string(parts[i].message_part_sequence) + ", " + parts[i].part_table + ")", 4)
			return -1
		end if
	end if
next
			
return 1

end function

protected function integer archive_parts ();
return 1

end function

public subroutine fix_query (ref string ps_query);string ls_temp
long ll_pos1
long ll_pos2
string ls_token
string ls_value

// Sub out dereferenced percents
ps_query = f_string_substitute(ps_query, "\%", "~!~!")

// Now find pairs of percents
ll_pos1 = 1
DO
	ll_pos1 = pos(ps_query, "%", ll_pos1)
	if ll_pos1 <= 0 then exit
	ll_pos2 = pos(ps_query, "%", ll_pos1 + 1)
	if ll_pos2 <= 0 then exit
	
	ls_token = mid(ps_query, ll_pos1 + 1, ll_pos2 - ll_pos1 - 1)
	
	ls_value = get_attribute(ls_token)
	if isnull(ls_value) then
		mylog.log(this, "u_component_message_creator.fix_query:0022", "Query token not found (" + ls_token + ")", 3)
		ls_value = ""
	end if
	
	ps_query = f_string_substitute(ps_query, "%" + ls_token + "%", ls_value)
	
	ll_pos1 += len(ls_value)
LOOP WHILE true

// Sub back dereferenced percents
ps_query = f_string_substitute(ps_query, "~!~!", "%")


end subroutine

protected function integer process_fkeys (integer pi_part);string ls_billing_id
string ls_treatment_type
str_message_fkey lstar_fkeys[]
u_ds_data luo_data
u_ds_data luo_key_data
integer i, j
long ll_rows
string ls_where_clause
string ls_query
string ls_altkey_field
any la_key
integer li_col
integer li_sts

luo_data = CREATE u_ds_data
luo_data.set_database(mydb)

luo_key_data = CREATE u_ds_data

ll_rows = luo_data.load_query("select * from " + parts[pi_part].part_table)
if ll_rows < 0 then
	mylog.log(this, "u_component_message_creator.process_fkeys:0022", "Error loading message records (" + parts[pi_part].part_table + ")", 4)
	return -1
end if
	
if lower(parts[pi_part].part_table) = "p_patient" then
	for i = 1 to ll_rows
		ls_billing_id = luo_data.object.billing_id[i]
		if isnull(ls_billing_id) then
			mylog.log(this, "u_component_message_creator.process_fkeys:0030", "Patient has no billing_id.  Patient will be skipped. (" + string(luo_data.object.cpr_id[i]) + ")", 3)
			luo_data.deleterow(i)
			i -= 1
			ll_rows -= 1
		end if
	next
end if

// For each fkey, load the records from the message table and look up the foreign key
for i = 1 to parts[pi_part].fkey_count
	mylog.log(this, "u_component_message_creator.process_fkeys:0040", "Processing fkeys for table (" + parts[pi_part].fkey[i].target_table + ")", 1)
	CHOOSE CASE upper(parts[pi_part].fkey[i].target_location)
		CASE "MESSAGE"
			li_sts = copy_fkeys_from_message(parts[pi_part], i, luo_data)
			if li_sts < 0 then return -1
		CASE "DATABASE"
			li_sts = copy_fkeys_from_database(parts[pi_part], i, luo_data)
			if li_sts < 0 then return -1
		CASE ELSE
			li_sts = copy_fkeys_from_both(parts[pi_part], i, luo_data)
			if li_sts < 0 then return -1
	END CHOOSE
next

DESTROY luo_data
DESTROY luo_key_data

return 1

end function

private function integer load_fkeys (ref str_message_part pstr_part);long i
integer li_sts
string ls_query
string ls_fkey_query
long ll_message_fkey_sequence
u_ds_data luo_data

luo_data = CREATE u_ds_data

luo_data.set_dataobject("dw_part_fkey_altkeys", cprdb)
pstr_part.fkey_count = luo_data.retrieve(message_type, pstr_part.message_part_sequence)

if pstr_part.fkey_count < 0 then return -1

for i = 1 to pstr_part.fkey_count
	pstr_part.fkey[i].message_fkey_sequence = luo_data.object.message_fkey_sequence[i]
	pstr_part.fkey[i].target_table = luo_data.object.target_table[i]
	pstr_part.fkey[i].target_location = luo_data.object.target_location[i]
	pstr_part.fkey[i].required_flag = "N"
	
	pstr_part.fkey[i].fkey1 = luo_data.object.fkey1[i]
	pstr_part.fkey[i].fkey2 = luo_data.object.fkey2[i]
	pstr_part.fkey[i].fkey3 = luo_data.object.fkey3[i]
	pstr_part.fkey[i].fkey4 = luo_data.object.fkey4[i]
	pstr_part.fkey[i].fkey5 = luo_data.object.fkey5[i]
	pstr_part.fkey[i].fkey6 = luo_data.object.fkey6[i]
	
	pstr_part.fkey[i].target_key1 = luo_data.object.target_key1[i]
	pstr_part.fkey[i].target_key2 = luo_data.object.target_key2[i]
	pstr_part.fkey[i].target_key3 = luo_data.object.target_key3[i]
	pstr_part.fkey[i].target_key4 = luo_data.object.target_key4[i]
	pstr_part.fkey[i].target_key5 = luo_data.object.target_key5[i]
	pstr_part.fkey[i].target_key6 = luo_data.object.target_key6[i]
	
	pstr_part.fkey[i].alt_key1 = luo_data.object.alt_key1[i]
	pstr_part.fkey[i].alt_key2 = luo_data.object.alt_key2[i]
	pstr_part.fkey[i].alt_key3 = luo_data.object.alt_key3[i]
	pstr_part.fkey[i].alt_key4 = luo_data.object.alt_key4[i]
	pstr_part.fkey[i].alt_key5 = luo_data.object.alt_key5[i]
	pstr_part.fkey[i].alt_key6 = luo_data.object.alt_key6[i]

	pstr_part.fkey[i].alt_key_list = pstr_part.fkey[i].alt_key1
	if not isnull(pstr_part.fkey[i].alt_key2) then pstr_part.fkey[i].alt_key_list += ", " + pstr_part.fkey[i].alt_key2
	if not isnull(pstr_part.fkey[i].alt_key3) then pstr_part.fkey[i].alt_key_list += ", " + pstr_part.fkey[i].alt_key3
	if not isnull(pstr_part.fkey[i].alt_key4) then pstr_part.fkey[i].alt_key_list += ", " + pstr_part.fkey[i].alt_key4
	if not isnull(pstr_part.fkey[i].alt_key5) then pstr_part.fkey[i].alt_key_list += ", " + pstr_part.fkey[i].alt_key5
	if not isnull(pstr_part.fkey[i].alt_key6) then pstr_part.fkey[i].alt_key_list += ", " + pstr_part.fkey[i].alt_key6
	
	pstr_part.fkey[i].target_key_list = pstr_part.fkey[i].target_key1
	if not isnull(pstr_part.fkey[i].target_key2) then pstr_part.fkey[i].target_key_list += ", " + pstr_part.fkey[i].target_key2
	if not isnull(pstr_part.fkey[i].target_key3) then pstr_part.fkey[i].target_key_list += ", " + pstr_part.fkey[i].target_key3
	if not isnull(pstr_part.fkey[i].target_key4) then pstr_part.fkey[i].target_key_list += ", " + pstr_part.fkey[i].target_key4
	if not isnull(pstr_part.fkey[i].target_key5) then pstr_part.fkey[i].target_key_list += ", " + pstr_part.fkey[i].target_key5
	if not isnull(pstr_part.fkey[i].target_key6) then pstr_part.fkey[i].target_key_list += ", " + pstr_part.fkey[i].target_key6
next

luo_data.set_dataobject("dw_common_fkey_altkeys", cprdb)
pstr_part.fkey_count = luo_data.retrieve(message_type, pstr_part.message_part_sequence)

if pstr_part.fkey_count < 0 then return -1


for i = 1 to pstr_part.fkey_count
	pstr_part.fkey[i].message_fkey_sequence = luo_data.object.fkey_sequence[i]
	pstr_part.fkey[i].target_table = luo_data.object.target_table[i]
	pstr_part.fkey[i].target_location = "BOTH"
	pstr_part.fkey[i].required_flag = luo_data.object.required_flag[i]
	
	pstr_part.fkey[i].fkey1 = luo_data.object.fkey1[i]
	pstr_part.fkey[i].fkey2 = luo_data.object.fkey2[i]
	pstr_part.fkey[i].fkey3 = luo_data.object.fkey3[i]
	pstr_part.fkey[i].fkey4 = luo_data.object.fkey4[i]
	pstr_part.fkey[i].fkey5 = luo_data.object.fkey5[i]
	pstr_part.fkey[i].fkey6 = luo_data.object.fkey6[i]
	
	pstr_part.fkey[i].target_key1 = luo_data.object.target_key1[i]
	pstr_part.fkey[i].target_key2 = luo_data.object.target_key2[i]
	pstr_part.fkey[i].target_key3 = luo_data.object.target_key3[i]
	pstr_part.fkey[i].target_key4 = luo_data.object.target_key4[i]
	pstr_part.fkey[i].target_key5 = luo_data.object.target_key5[i]
	pstr_part.fkey[i].target_key6 = luo_data.object.target_key6[i]
	
	pstr_part.fkey[i].alt_key1 = luo_data.object.alt_key1[i]
	pstr_part.fkey[i].alt_key2 = luo_data.object.alt_key2[i]
	pstr_part.fkey[i].alt_key3 = luo_data.object.alt_key3[i]
	pstr_part.fkey[i].alt_key4 = luo_data.object.alt_key4[i]
	pstr_part.fkey[i].alt_key5 = luo_data.object.alt_key5[i]
	pstr_part.fkey[i].alt_key6 = luo_data.object.alt_key6[i]

	pstr_part.fkey[i].alt_key_list = pstr_part.fkey[i].alt_key1
	if not isnull(pstr_part.fkey[i].alt_key2) then pstr_part.fkey[i].alt_key_list += ", " + pstr_part.fkey[i].alt_key2
	if not isnull(pstr_part.fkey[i].alt_key3) then pstr_part.fkey[i].alt_key_list += ", " + pstr_part.fkey[i].alt_key3
	if not isnull(pstr_part.fkey[i].alt_key4) then pstr_part.fkey[i].alt_key_list += ", " + pstr_part.fkey[i].alt_key4
	if not isnull(pstr_part.fkey[i].alt_key5) then pstr_part.fkey[i].alt_key_list += ", " + pstr_part.fkey[i].alt_key5
	if not isnull(pstr_part.fkey[i].alt_key6) then pstr_part.fkey[i].alt_key_list += ", " + pstr_part.fkey[i].alt_key6
	
	pstr_part.fkey[i].target_key_list = pstr_part.fkey[i].target_key1
	if not isnull(pstr_part.fkey[i].target_key2) then pstr_part.fkey[i].target_key_list += ", " + pstr_part.fkey[i].target_key2
	if not isnull(pstr_part.fkey[i].target_key3) then pstr_part.fkey[i].target_key_list += ", " + pstr_part.fkey[i].target_key3
	if not isnull(pstr_part.fkey[i].target_key4) then pstr_part.fkey[i].target_key_list += ", " + pstr_part.fkey[i].target_key4
	if not isnull(pstr_part.fkey[i].target_key5) then pstr_part.fkey[i].target_key_list += ", " + pstr_part.fkey[i].target_key5
	if not isnull(pstr_part.fkey[i].target_key6) then pstr_part.fkey[i].target_key_list += ", " + pstr_part.fkey[i].target_key6
next

DESTROY luo_data

return 1

end function

private function integer initialize_message (integer pi_count, string lsa_attributes[], string lsa_values[]);u_ds_data luo_data
integer i
long ll_row
integer li_sts
datetime ldt_now
string ls_version
integer li_build

ls_version = f_database_version()
li_build = integer(gnv_app.build)

luo_data = CREATE u_ds_data
luo_data.set_database(mydb)

// We just want the structure of the message_attribute table
luo_data.load_query("select * from message_attribute where 1 = 2")

for i = 1 to pi_count
	ll_row = luo_data.insertrow(0)
	luo_data.object.attribute[i] = lsa_attributes[i]
	luo_data.object.attribute_value[i] = lsa_values[i]
next

li_sts = luo_data.save_to_table("message_attribute", false)
if li_sts < 0 then return -1

ldt_now = datetime(today(), now())

update message_header
set message_type = :message_type,
	description = :message_description,
	sender_office_id = :gnv_app.office_id,
	sender = :office_description,
	created = :ldt_now,
	version = :ls_version,
	build = :li_build
USING mydb;
if not mydb.check() then return -1


DESTROY luo_data

setnull(diagnosis_sequence_where_clause)

return 1

end function

private function string fkey_where_clause (u_ds_data puo_data, str_message_fkey pstr_fkey, long pl_row);string ls_type
string ls_item
string ls_delim
integer li_col
integer li_sts
string ls_where_clause
u_ds_data luo_data
string ls_sql
integer li_diagnosis_sequence

if not isnull(pstr_fkey.fkey1) then
	ls_item = puo_data.where_clause_item(pstr_fkey.fkey1, pl_row)
	if ls_item = "!" then
		setnull(ls_where_clause)
		return ls_where_clause
	end if
	ls_where_clause = "WHERE " + pstr_fkey.target_key1 + " = " + ls_item
else
	mylog.log(this, "u_component_message_creator.fkey_where_clause:0019", "First fkey is null", 4)
	setnull(ls_where_clause)
	return ls_where_clause
end if

if not isnull(pstr_fkey.fkey2) then
	ls_item = puo_data.where_clause_item(pstr_fkey.fkey2, pl_row)
	if ls_item = "!" then
		setnull(ls_where_clause)
		return ls_where_clause
	end if
	ls_where_clause += " AND " + pstr_fkey.target_key2 + " = " + ls_item
end if

if not isnull(pstr_fkey.fkey3) then
	ls_item = puo_data.where_clause_item(pstr_fkey.fkey3, pl_row)
	if ls_item = "!" then
		setnull(ls_where_clause)
		return ls_where_clause
	end if
	ls_where_clause += " AND " + pstr_fkey.target_key3 + " = " + ls_item
end if

if not isnull(pstr_fkey.fkey4) then
	ls_item = puo_data.where_clause_item(pstr_fkey.fkey4, pl_row)
	if ls_item = "!" then
		setnull(ls_where_clause)
		return ls_where_clause
	end if
	ls_where_clause += " AND " + pstr_fkey.target_key4 + " = " + ls_item
end if

if not isnull(pstr_fkey.fkey5) then
	ls_item = puo_data.where_clause_item(pstr_fkey.fkey5, pl_row)
	if ls_item = "!" then
		setnull(ls_where_clause)
		return ls_where_clause
	end if
	ls_where_clause += " AND " + pstr_fkey.target_key5 + " = " + ls_item
end if

if not isnull(pstr_fkey.fkey6) then
	ls_item = puo_data.where_clause_item(pstr_fkey.fkey6, pl_row)
	if ls_item = "!" then
		setnull(ls_where_clause)
		return ls_where_clause
	end if
	ls_where_clause += " AND " + pstr_fkey.target_key6 + " = " + ls_item
end if

// Now this sucks, but the p_Assessment table won't work completely with this scheme.
// Tables which reference p_Assessment won't necessarily know which diagnosis sequence
// to use, and the diagnosis sequences can be different at different sites.  SO, if the
// diagnosis_sequence is not included as fkey3, then we will explicitly look up the
// assessment of the original problem (i.e. the assessment with the lowest diagnosis sequence)
if lower(pstr_fkey.target_table) = "p_assessment" and isnull(pstr_fkey.fkey3) and not isnull(ls_where_clause) then
	// If the where clause matches the cached where clause, then
	// use the cached diagnosis sequence
	if ls_where_clause = diagnosis_sequence_where_clause then
		li_diagnosis_sequence = diagnosis_sequence_cache
	else
		luo_data = CREATE u_ds_data
		ls_sql = "SELECT min(diagnosis_sequence) FROM p_Assessment " + ls_where_clause
		luo_data.set_database(cprdb)
		li_sts = luo_data.load_query(ls_sql)
		if li_sts < 0 then
			log.log(this, "u_component_message_creator.fkey_where_clause:0085", "Error getting min diagnosis sequence (" + ls_where_clause + ")", 4)
			setnull(ls_where_clause)
			DESTROY luo_data
			return ls_where_clause
		elseif li_sts = 0 then
			log.log(this, "u_component_message_creator.fkey_where_clause:0090", "No min diagnosis sequence (" + ls_where_clause + ")", 4)
			setnull(ls_where_clause)
			DESTROY luo_data
			return ls_where_clause
		end if
		li_diagnosis_sequence = luo_data.object.data[1,1]
		DESTROY luo_data
		
		// The lookup was successful, so cache the diagnosis_sequence
		diagnosis_sequence_cache = li_diagnosis_sequence
		diagnosis_sequence_where_clause = ls_where_clause
	end if

	if isnull(li_diagnosis_sequence) then
		log.log(this, "u_component_message_creator.fkey_where_clause:0104", "Null min diagnosis sequence (" + ls_where_clause + ")", 4)
		setnull(ls_where_clause)
		return ls_where_clause
	end if
	ls_where_clause += " AND diagnosis_sequence = " + string(li_diagnosis_sequence)
end if
	
return ls_where_clause

end function

protected function integer copy_fkeys_from_message (str_message_part pstr_part, integer pi_fkey, u_ds_data puo_data);string ls_query
integer li_sts
string ls_sep
integer li_col
string ls_altkey_field

//UPDATE Suppliers INNER JOIN Products
//ON Suppliers.SupplierID = Products.SupplierID SET UnitPrice = UnitPrice * .95
//WHERE CompanyName = 'Tokyo Traders' AND Discontinued = No;

ls_query = "UPDATE " + pstr_part.part_table 
ls_query += " INNER JOIN " + pstr_part.fkey[pi_fkey].target_table + " ON "
ls_sep = ""

// Add the where clause
if not isnull(pstr_part.fkey[pi_fkey].fkey1) then
	ls_query += ls_sep + pstr_part.part_table + "." + pstr_part.fkey[pi_fkey].fkey1
	ls_query += " = " + pstr_part.fkey[pi_fkey].target_table + "." + pstr_part.fkey[pi_fkey].target_key1
	ls_sep = " AND "
end if

if not isnull(pstr_part.fkey[pi_fkey].fkey2) then
	ls_query += ls_sep + pstr_part.part_table + "." + pstr_part.fkey[pi_fkey].fkey2
	ls_query += " = " + pstr_part.fkey[pi_fkey].target_table + "." + pstr_part.fkey[pi_fkey].target_key2
	ls_sep = " AND "
end if

if not isnull(pstr_part.fkey[pi_fkey].fkey3) then
	ls_query += ls_sep + pstr_part.part_table + "." + pstr_part.fkey[pi_fkey].fkey3
	ls_query += " = " + pstr_part.fkey[pi_fkey].target_table + "." + pstr_part.fkey[pi_fkey].target_key3
	ls_sep = " AND "
end if

if not isnull(pstr_part.fkey[pi_fkey].fkey4) then
	ls_query += ls_sep + pstr_part.part_table + "." + pstr_part.fkey[pi_fkey].fkey4
	ls_query += " = " + pstr_part.fkey[pi_fkey].target_table + "." + pstr_part.fkey[pi_fkey].target_key4
	ls_sep = " AND "
end if

if not isnull(pstr_part.fkey[pi_fkey].fkey5) then
	ls_query += ls_sep + pstr_part.part_table + "." + pstr_part.fkey[pi_fkey].fkey5
	ls_query += " = " + pstr_part.fkey[pi_fkey].target_table + "." + pstr_part.fkey[pi_fkey].target_key5
	ls_sep = " AND "
end if

if not isnull(pstr_part.fkey[pi_fkey].fkey6) then
	ls_query += ls_sep + pstr_part.part_table + "." + pstr_part.fkey[pi_fkey].fkey6
	ls_query += " = " + pstr_part.fkey[pi_fkey].target_table + "." + pstr_part.fkey[pi_fkey].target_key6
	ls_sep = " AND "
end if

ls_query += " SET "
ls_sep = ""

////////////////////////////////
// Add the update column list
////////////////////////////////
if not isnull(pstr_part.fkey[pi_fkey].alt_key1) then
	// Check if field exists with table prefix
	ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key1
	li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
	if li_col <= 0 then
		// If we didn't find the field with the table prefix, then just use the field itself
		ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key1
		li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
	end if
	if li_col > 0 then
		ls_query += ls_sep + pstr_part.part_table + "." + ls_altkey_field + " = "
		ls_query += pstr_part.fkey[pi_fkey].target_table + "." + pstr_part.fkey[pi_fkey].alt_key1
		ls_sep = ", "
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].alt_key2) then
	// Check if field exists with table prefix
	ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key2
	li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
	if li_col <= 0 then
		// If we didn't find the field with the table prefix, then just use the field itself
		ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key2
		li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
	end if
	if li_col > 0 then
		ls_query += ls_sep + pstr_part.part_table + "." + ls_altkey_field + " = "
		ls_query += pstr_part.fkey[pi_fkey].target_table + "." + pstr_part.fkey[pi_fkey].alt_key2
		ls_sep = ", "
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].alt_key3) then
	// Check if field exists with table prefix
	ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key3
	li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
	if li_col <= 0 then
		// If we didn't find the field with the table prefix, then just use the field itself
		ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key3
		li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
	end if
	if li_col > 0 then
		ls_query += ls_sep + pstr_part.part_table + "." + ls_altkey_field + " = "
		ls_query += pstr_part.fkey[pi_fkey].target_table + "." + pstr_part.fkey[pi_fkey].alt_key3
		ls_sep = ", "
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].alt_key4) then
	// Check if field exists with table prefix
	ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key4
	li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
	if li_col <= 0 then
		// If we didn't find the field with the table prefix, then just use the field itself
		ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key4
		li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
	end if
	if li_col > 0 then
		ls_query += ls_sep + pstr_part.part_table + "." + ls_altkey_field + " = "
		ls_query += pstr_part.fkey[pi_fkey].target_table + "." + pstr_part.fkey[pi_fkey].alt_key4
		ls_sep = ", "
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].alt_key5) then
	// Check if field exists with table prefix
	ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key5
	li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
	if li_col <= 0 then
		// If we didn't find the field with the table prefix, then just use the field itself
		ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key5
		li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
	end if
	if li_col > 0 then
		ls_query += ls_sep + pstr_part.part_table + "." + ls_altkey_field + " = "
		ls_query += pstr_part.fkey[pi_fkey].target_table + "." + pstr_part.fkey[pi_fkey].alt_key5
		ls_sep = ", "
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].alt_key6) then
	// Check if field exists with table prefix
	ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key6
	li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
	if li_col <= 0 then
		// If we didn't find the field with the table prefix, then just use the field itself
		ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key6
		li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
	end if
	if li_col > 0 then
		ls_query += ls_sep + pstr_part.part_table + "." + ls_altkey_field + " = "
		ls_query += pstr_part.fkey[pi_fkey].target_table + "." + pstr_part.fkey[pi_fkey].alt_key6
		ls_sep = ", "
	end if
end if



li_sts = mydb.execute_string(ls_query)
if li_sts < 0 then return -1

return 1



end function

protected function integer copy_fkeys_from_database (str_message_part pstr_part, integer pi_fkey, u_ds_data puo_data);string ls_treatment_type
u_ds_data luo_key_data
integer j
long ll_rows
string ls_where_clause
string ls_query
string ls_altkey_field
any la_key
integer li_col
integer li_sts

luo_key_data = CREATE u_ds_data

ll_rows = puo_data.rowcount()

// For each record in the message table
for j = 1 to ll_rows
	//////////////////////////////////////////////////////////////////////////////////////////////
	// Houston we have a problem.  We were going to unify the c_Drug_Definition and c_Vaccine tables
	// so we used p_Treatment_Item.drug_id as a foreign key for both tables.  Unfortunately we
	// didn't get the tables unified before this release so we have to decide at run time which
	// table the field really points to.  The criteria are simple: if p_Treatment_Item.treatment_type
	// is "IMMUNIZATION" or "PASTIMMUN" then drug_id is really a vaccine_id.  Otherwise drug_id
	// is really a drug_id.  In the c_Message_Fkey mapping, for now, we will list both relationships
	// but it is important that only one key translation actually take place.  So, as much as
	// I hate to do it, I'm hardcoding a temporary solution here to detect when we're using the
	// wrong foreign key and ignore it.
	//
	// Here's how:  First we see if we're working with a foreign key from p_treatment_item into
	// c_Drug_Definition
	if lower(pstr_part.fkey[pi_fkey].target_table) = "c_drug_definition" and lower(pstr_part.part_table) = "p_treatment_item" then
		ls_treatment_type = puo_data.object.treatment_type[j]
		if ls_treatment_type = "IMMUNIZATION" or ls_treatment_type = "PASTIMMUN" then continue
	end if
	
	// Now check for a foreign key from p_treatment_item into c_Vaccine
	if lower(pstr_part.fkey[pi_fkey].target_table) = "c_vaccine" and lower(pstr_part.part_table) = "p_treatment_item" then
		ls_treatment_type = puo_data.object.treatment_type[j]
		if ls_treatment_type <> "IMMUNIZATION" and ls_treatment_type <> "PASTIMMUN" then continue
	end if
	//
	//
	// This section lf code will be deleted when the c_drug_definition and c_vaccine tables are unified
	///////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////

	
	
	
	// Construct the alternate key lookup where-clause for this message record
	ls_where_clause = fkey_where_clause(puo_data, pstr_part.fkey[pi_fkey], j)
	
	// If the where_clause is null then we didn't have a complete foreign key.  Just skip it.
	if isnull(ls_where_clause) then continue
	
	// Construct query to look up alternate key from table in cpr database
	ls_query = "SELECT " + pstr_part.fkey[pi_fkey].alt_key_list + " FROM " + pstr_part.fkey[pi_fkey].target_table + " " + ls_where_clause

	// Perform query
	luo_key_data.set_database(cprdb)
	li_sts = luo_key_data.load_query(ls_query)
	
	// Check results
	if li_sts < 0 then
		// Error
		mylog.log(this, "u_component_message_creator.copy_fkeys_from_database:0066", "Error executing lookup query (" + ls_query + ")", 4)
		return -1
	elseif li_sts = 0 then
		// Key lookup not found
		mylog.log(this, "u_component_message_creator.copy_fkeys_from_database:0070", "Foerign key not found (" + ls_query + ")", 4)
		return -1
	elseif li_sts > 1 then
		// too many keys found
		mylog.log(this, "u_component_message_creator.copy_fkeys_from_database:0074", "Foerign key lookup found multiple records (" + ls_query + ")", 4)
		return -1
	end if
	
	// Now put the alternate key values back into message database
	
	if not isnull(pstr_part.fkey[pi_fkey].alt_key1) then
		// Get the value from the cpr database
		li_col = integer(luo_key_data.Describe(pstr_part.fkey[pi_fkey].alt_key1 + ".ID"))
		la_key = luo_key_data.object.data[1, li_col]
		
		// Put the value in the message database
		// First try the fieldname with the table name prefix
		ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key1
		li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
		if li_col <= 0 then
			// If we didn't find the field with the table prefix, then just use the field itself
			ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key1
			li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
		end if
		if li_col > 0 then puo_data.object.data[j, li_col] = la_key
	end if

	if not isnull(pstr_part.fkey[pi_fkey].alt_key2) then
		// Get the value from the cpr database
		li_col = integer(luo_key_data.Describe(pstr_part.fkey[pi_fkey].alt_key2 + ".ID"))
		la_key = luo_key_data.object.data[1, li_col]
		
		// Put the value in the message database
		// First try the fieldname with the table name prefix
		ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key2
		li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
		if li_col <= 0 then
			// If we didn't find the field with the table prefix, then just use the field itself
			ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key2
			li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
		end if
		if li_col > 0 then puo_data.object.data[j, li_col] = la_key
	end if

	if not isnull(pstr_part.fkey[pi_fkey].alt_key3) then
		// Get the value from the cpr database
		li_col = integer(luo_key_data.Describe(pstr_part.fkey[pi_fkey].alt_key3 + ".ID"))
		la_key = luo_key_data.object.data[1, li_col]
		
		// Put the value in the message database
		// First try the fieldname with the table name prefix
		ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key3
		li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
		if li_col <= 0 then
			// If we didn't find the field with the table prefix, then just use the field itself
			ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key3
			li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
		end if
		if li_col > 0 then puo_data.object.data[j, li_col] = la_key
	end if

	if not isnull(pstr_part.fkey[pi_fkey].alt_key4) then
		// Get the value from the cpr database
		li_col = integer(luo_key_data.Describe(pstr_part.fkey[pi_fkey].alt_key4 + ".ID"))
		la_key = luo_key_data.object.data[1, li_col]
		
		// Put the value in the message database
		// First try the fieldname with the table name prefix
		ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key4
		li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
		if li_col <= 0 then
			// If we didn't find the field with the table prefix, then just use the field itself
			ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key4
			li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
		end if
		if li_col > 0 then puo_data.object.data[j, li_col] = la_key
	end if

	if not isnull(pstr_part.fkey[pi_fkey].alt_key5) then
		// Get the value from the cpr database
		li_col = integer(luo_key_data.Describe(pstr_part.fkey[pi_fkey].alt_key5 + ".ID"))
		la_key = luo_key_data.object.data[1, li_col]
		
		// Put the value in the message database
		// First try the fieldname with the table name prefix
		ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key5
		li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
		if li_col <= 0 then
			// If we didn't find the field with the table prefix, then just use the field itself
			ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key5
			li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
		end if
		if li_col > 0 then puo_data.object.data[j, li_col] = la_key
	end if

	if not isnull(pstr_part.fkey[pi_fkey].alt_key6) then
		// Get the value from the cpr database
		li_col = integer(luo_key_data.Describe(pstr_part.fkey[pi_fkey].alt_key6 + ".ID"))
		la_key = luo_key_data.object.data[1, li_col]
		
		// Put the value in the message database
		// First try the fieldname with the table name prefix
		ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key6
		li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
		if li_col <= 0 then
			// If we didn't find the field with the table prefix, then just use the field itself
			ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key6
			li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
		end if
		if li_col > 0 then puo_data.object.data[j, li_col] = la_key
	end if
next

// Now save the message records back to the message database
li_sts = puo_data.replace_table(pstr_part.part_table)
if li_sts < 0 then
	mylog.log(this, "u_component_message_creator.copy_fkeys_from_database:0186", "Error saving message records (" + pstr_part.part_table + ")", 4)
	return -1
end if

DESTROY luo_key_data

return 1

end function

protected function integer copy_fkeys_from_both (str_message_part pstr_part, integer pi_fkey, u_ds_data puo_data);string ls_treatment_type
u_ds_data luo_key_data
integer j
long ll_rows
string ls_where_clause
string ls_query
string ls_altkey_field
any la_key
integer li_col
integer li_sts
boolean lb_found_key

luo_key_data = CREATE u_ds_data

ll_rows = puo_data.rowcount()

// For each record in the message table
for j = 1 to ll_rows
	// We assume we found a foreign key
	lb_found_key = true
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	// Houston we have a problem.  We were going to unify the c_Drug_Definition and c_Vaccine tables
	// so we used p_Treatment_Item.drug_id as a foreign key for both tables.  Unfortunately we
	// didn't get the tables unified before this release so we have to decide at run time which
	// table the field really points to.  The criteria are simple: if p_Treatment_Item.treatment_type
	// is "IMMUNIZATION" or "PASTIMMUN" then drug_id is really a vaccine_id.  Otherwise drug_id
	// is really a drug_id.  In the c_Message_Fkey mapping, for now, we will list both relationships
	// but it is important that only one key translation actually take place.  So, as much as
	// I hate to do it, I'm hardcoding a temporary solution here to detect when we're using the
	// wrong foreign key and ignore it.
	//
	// Here's how:  First we see if we're working with a foreign key from p_treatment_item into
	// c_Drug_Definition
	if lower(pstr_part.fkey[pi_fkey].target_table) = "c_drug_definition" and lower(pstr_part.part_table) = "p_treatment_item" then
		ls_treatment_type = puo_data.object.treatment_type[j]
		if ls_treatment_type = "IMMUNIZATION" or ls_treatment_type = "PASTIMMUN" then continue
	end if
	
	// Now check for a foreign key from p_treatment_item into c_Vaccine
	if lower(pstr_part.fkey[pi_fkey].target_table) = "c_vaccine" and lower(pstr_part.part_table) = "p_treatment_item" then
		ls_treatment_type = puo_data.object.treatment_type[j]
		if ls_treatment_type <> "IMMUNIZATION" and ls_treatment_type <> "PASTIMMUN" then continue
	end if
	//
	//
	// This section lf code will be deleted when the c_drug_definition and c_vaccine tables are unified
	///////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////

	
	
	
	// Construct the alternate key lookup where-clause for this message record
	ls_where_clause = fkey_where_clause(puo_data, pstr_part.fkey[pi_fkey], j)
	
	// If the where_clause is null then we didn't have a complete foreign key.  Just skip it.
	if isnull(ls_where_clause) then continue
	
	// Construct query to look up alternate key from table in cpr database
	ls_query = "SELECT " + pstr_part.fkey[pi_fkey].alt_key_list + " FROM " + pstr_part.fkey[pi_fkey].target_table + " " + ls_where_clause

	// Perform query
	luo_key_data.set_database(mydb)
	li_sts = luo_key_data.load_query(ls_query)
	if li_sts = 0 then
		luo_key_data.set_database(cprdb)
		li_sts = luo_key_data.load_query(ls_query)
	end if
	
	// Check results
	if li_sts < 0 then
		// Error
		mylog.log(this, "u_component_message_creator.copy_fkeys_from_both:0074", "Error executing lookup query (" + ls_query + ")", 4)
		return -1
	elseif li_sts = 0 then
		// Key lookup not found
		// When we fail to find the target of a foreign key lookup, then we have an orphan record.
		// If this is a required foreign key then the orphan record won't show up in the chart and
		// can safely be ignored.  If the foreign key is not required then the foreign key should be nullified.
		mylog.log(this, "u_component_message_creator.copy_fkeys_from_both:0081", "Foerign key not found (" + ls_query + ")", 3)
		if pstr_part.fkey[pi_fkey].required_flag = "Y" then
			continue
		else
			lb_found_key = false
		end if
	elseif li_sts > 1 then
		// too many keys found
		mylog.log(this, "u_component_message_creator.copy_fkeys_from_both:0089", "Foerign key lookup found multiple records (" + ls_query + ")", 4)
		return -1
	end if
	
	// Now put the alternate key values back into message database
	if lb_found_key then
		if not isnull(pstr_part.fkey[pi_fkey].alt_key1) then
			// Get the value from the cpr database
			li_col = integer(luo_key_data.Describe(pstr_part.fkey[pi_fkey].alt_key1 + ".ID"))
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			// First try the fieldname with the table name prefix
			ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key1
			li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
			if li_col <= 0 then
				// If we didn't find the field with the table prefix, then just use the field itself
				ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key1
				li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
			end if
			if li_col > 0 then puo_data.object.data[j, li_col] = la_key
		end if
	
		if not isnull(pstr_part.fkey[pi_fkey].alt_key2) then
			// Get the value from the cpr database
			li_col = integer(luo_key_data.Describe(pstr_part.fkey[pi_fkey].alt_key2 + ".ID"))
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			// First try the fieldname with the table name prefix
			ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key2
			li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
			if li_col <= 0 then
				// If we didn't find the field with the table prefix, then just use the field itself
				ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key2
				li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
			end if
			if li_col > 0 then puo_data.object.data[j, li_col] = la_key
		end if
	
		if not isnull(pstr_part.fkey[pi_fkey].alt_key3) then
			// Get the value from the cpr database
			li_col = integer(luo_key_data.Describe(pstr_part.fkey[pi_fkey].alt_key3 + ".ID"))
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			// First try the fieldname with the table name prefix
			ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key3
			li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
			if li_col <= 0 then
				// If we didn't find the field with the table prefix, then just use the field itself
				ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key3
				li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
			end if
			if li_col > 0 then puo_data.object.data[j, li_col] = la_key
		end if
	
		if not isnull(pstr_part.fkey[pi_fkey].alt_key4) then
			// Get the value from the cpr database
			li_col = integer(luo_key_data.Describe(pstr_part.fkey[pi_fkey].alt_key4 + ".ID"))
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			// First try the fieldname with the table name prefix
			ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key4
			li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
			if li_col <= 0 then
				// If we didn't find the field with the table prefix, then just use the field itself
				ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key4
				li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
			end if
			if li_col > 0 then puo_data.object.data[j, li_col] = la_key
		end if
	
		if not isnull(pstr_part.fkey[pi_fkey].alt_key5) then
			// Get the value from the cpr database
			li_col = integer(luo_key_data.Describe(pstr_part.fkey[pi_fkey].alt_key5 + ".ID"))
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			// First try the fieldname with the table name prefix
			ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key5
			li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
			if li_col <= 0 then
				// If we didn't find the field with the table prefix, then just use the field itself
				ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key5
				li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
			end if
			if li_col > 0 then puo_data.object.data[j, li_col] = la_key
		end if
	
		if not isnull(pstr_part.fkey[pi_fkey].alt_key6) then
			// Get the value from the cpr database
			li_col = integer(luo_key_data.Describe(pstr_part.fkey[pi_fkey].alt_key6 + ".ID"))
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			// First try the fieldname with the table name prefix
			ls_altkey_field = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key6
			li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
			if li_col <= 0 then
				// If we didn't find the field with the table prefix, then just use the field itself
				ls_altkey_field = pstr_part.fkey[pi_fkey].alt_key6
				li_col = integer(puo_data.Describe(ls_altkey_field + ".ID"))
			end if
			if li_col > 0 then puo_data.object.data[j, li_col] = la_key
		end if
	end if
next

// Now save the message records back to the message database
li_sts = puo_data.replace_table(pstr_part.part_table)
if li_sts < 0 then
	mylog.log(this, "u_component_message_creator.copy_fkeys_from_both:0202", "Error saving message records (" + pstr_part.part_table + ")", 4)
	return -1
end if

DESTROY luo_key_data

return 1

end function

protected function integer process_part_special (str_message_part pstr_part, string ps_query);integer li_sts
u_ds_data luo_data

luo_data = CREATE u_ds_data

CHOOSE CASE pstr_part.part_table
	CASE "Attachment_Files"
		li_sts = luo_data.save_query_to_table(mydb, mydb, ps_query, pstr_part.part_table)
		if li_sts < 0 then
			mylog.log(this, "u_component_message_creator.process_part_special:0010", "Error getting attachment file records", 4)
			return -1
		end if
		
		li_sts = get_attachment_files()
		if li_sts < 0 then
			mylog.log(this, "u_component_message_creator.process_part_special:0016", "Error getting attachment files", 4)
			return -1
		end if
		
END CHOOSE

DESTROY luo_data

return 1

end function

public function integer get_attachment_files ();integer li_sts
long ll_rows
long ll_msg_attachment_file_key
string ls_cpr_id
string ls_object_file
string ls_object_type
long i
u_ds_data luo_data
u_attachment_file_holder luo_file

luo_file = CREATE u_attachment_file_holder

luo_file.initialize(mylog)

luo_data = CREATE u_ds_data
luo_data.set_database(mydb)

ll_rows = luo_data.load_query("select cpr_id, object_file, object_type, msg_attachment_file_key from attachment_files")
if ll_rows < 0 then return -1

for i = 1 to ll_rows
	ll_msg_attachment_file_key = luo_data.object.msg_attachment_file_key[i]
	ls_cpr_id = luo_data.object.cpr_id[i]
	ls_object_file = luo_data.object.object_file[i]
	ls_object_type = luo_data.object.object_type[i]
	
	li_sts = luo_file.get_file(ls_cpr_id, ls_object_file, ls_object_type)
	if li_sts < 0 then return -1
	
	if li_sts > 0 then
		UPDATEBLOB Attachment_Files
		SET attachment_file = :luo_file.attachment_file
		WHERE msg_attachment_file_key = :ll_msg_attachment_file_key
		USING mydb;
		if not mydb.check() then return -1
	end if
next

DESTROY luo_file
DESTROY luo_data


return 1

end function

on u_component_message_creator.create
call super::create
end on

on u_component_message_creator.destroy
call super::destroy
end on

