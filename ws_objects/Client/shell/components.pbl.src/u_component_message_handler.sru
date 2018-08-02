$PBExportHeader$u_component_message_handler.sru
forward
global type u_component_message_handler from u_component_base_class
end type
end forward

global type u_component_message_handler from u_component_base_class
end type
global u_component_message_handler u_component_message_handler

type variables
long message_id
string message_file
string error_file
string message_type
long subscription_id
string message_office_id

str_message_part parts[]
long part_count

string message_cpr_id
long message_encounter_id

end variables

forward prototypes
public function integer handle_message (long pl_message_id)
private function integer get_message_file ()
protected function integer xx_handle_message ()
private function integer unarchive_parts ()
private function integer process_parts ()
private function integer load_fkeys (ref str_message_part pstr_part)
private function integer load_parts ()
private function integer translate_and_save_part (ref str_message_part pstr_part)
private function integer translate_x_part (ref str_message_part pstr_part)
public function integer add_missing_data (str_message_part pstr_part, u_ds_data puo_data, u_ds_data puo_key_data, long pl_row, integer pi_fkey)
public function integer add_missing_x_data (str_message_part pstr_part, u_ds_data puo_data, u_ds_data puo_key_data, long pl_row)
private function integer translate_c_part (ref str_message_part pstr_part)
public function integer add_missing_c_data (str_message_part pstr_part, u_ds_data puo_data, u_ds_data puo_key_data, long pl_row)
private function string prikey_where_clause (u_ds_data puo_data, string ps_table, long pl_row)
private function string fkey_where_clause (u_ds_data puo_data, string ps_table, ref str_message_fkey pstr_fkey, long pl_row, string ps_dbms)
private function integer find_key_in_data (u_ds_data puo_data, u_ds_data puo_key_data, str_message_fkey pstr_fkey, string ps_find_string)
private function string altkey_where_clause (u_ds_data puo_data, str_message_part pstr_part, long pl_row)
public function integer check_record_unique (u_ds_data puo_data, str_message_part pstr_part, integer pi_row)
private function integer do_special_part (str_message_part pstr_part)
public function integer save_attachment_files ()
private function string altkey_where_clause (u_ds_data puo_data, string ps_table, long pl_row)
private function string altkey_where_clause (u_ds_data puo_data, string ps_table, long pl_row, string ps_dbms)
end prototypes

public function integer handle_message (long pl_message_id);integer li_sts
datetime ldt_now
string ls_temp
string ls_template_location
string ls_message_location
string ls_template_file
string ls_filename
string ls_extension
long ll_message_number

// Record parameter
message_id = pl_message_id

if isnull(message_id) then
	mylog.log(this, "u_component_message_handler.handle_message.0015", "Null message_id", 4)
	return -1
end if

mylog.log(this, "u_component_message_handler.handle_message.0015", "Handling Message (" + string(message_id) + ")", 2)

// Get message type
SELECT message_type, subscription_id
INTO :message_type, :subscription_id
FROM o_Message_Log
WHERE message_id = :message_id
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_message_handler.handle_message.0015", "message_id not found (" + string(message_id) + ")", 4)
	return -1
end if

// get the message office id
SELECT office_id
INTO :message_office_id
FROM o_Message_Subscription
WHERE subscription_id = :subscription_id
USING cprdb;

// Determine the message file
li_sts = get_message_file()
if li_sts <= 0 then
	mylog.log(this, "u_component_message_handler.handle_message.0043", "Error getting message file", 4)
end if

if li_sts > 0 then
	// Finally, create the message
	li_sts = xx_handle_message()
	
	if li_sts < 0 then
		filedelete(error_file)
		mylog.file_rename(message_file, error_file)
	else
		filedelete(message_file)
	end if
end if

if li_sts <= 0 then
	mylog.log(this, "u_component_message_handler.handle_message.0015", "Error Handling Message (" + string(message_id) + ")", 4)
	ldt_now = datetime(today(), now())
	UPDATE o_Message_Log
	SET status = 'HANDLEERROR',
		tries = tries + 1,
		message_date_time = :ldt_now
	WHERE message_id = :message_id
	USING cprdb;
	if not cprdb.check() then return -1
	return -1
else
	mylog.log(this, "u_component_message_handler.handle_message.0015", "Successfully Handled Message (" + string(message_id) + ")", 2)
	UPDATE o_Message_Log
	SET status = 'RECEIVED'
	WHERE message_id = :message_id
	USING cprdb;
	if not cprdb.check() then return -1
end if

return 1



end function

private function integer get_message_file ();integer li_sts
string ls_temp
string ls_message_location
string ls_template_file
string ls_filename
string ls_extension
string ls_compression_type
blob lblb_message
string ls_message_suffix
string ls_inifilename,ls_iniextension,ls_drive,ls_directory

ls_compression_type = "NONE"

// Get template file from database
SELECT template_file
INTO :ls_template_file
FROM c_Message_Definition
WHERE message_type = :message_type
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_message_handler.handle_message.0043", "Message type not found (" + message_type + ")", 4)
	return -1
end if

if isnull(ls_template_file) then
	ls_template_file = ".dat"
end if

f_split_string(ls_template_file, ".", ls_filename, ls_extension)
f_parse_filepath(ini_file,ls_drive,ls_directory,ls_inifilename,ls_iniextension)

ls_message_location = ls_drive + ls_directory
if right(ls_message_location, 1) <> "\" then ls_message_location += "\"
ls_message_location += "Messages"

if not mylog.of_directoryexists(ls_message_location) then
	mylog.log(this, "u_component_message_handler.get_message_file.0038", "Error getting temp path "+ls_message_location, 4)
	return -1
end if
if right(ls_message_location, 1) <> "\" then ls_message_location += "\"

ls_message_suffix = string(message_id) + "_" + string(today(), "yymmdd") + string(now(), "hhmmss")

message_file = message_type + "_IN_" + ls_message_suffix + "." + ls_extension
message_file = ls_message_location + message_file
error_file = ls_message_location + message_type +"_IN" + ls_message_suffix+".err"

// Now save the messsage into a file
SELECTBLOB message
INTO :lblb_message
FROM o_Message_Log
WHERE message_id = :message_id
USING cprdb;
if not cprdb.check() then return -1

li_sts = mylog.file_write(lblb_message, message_file)
if li_sts <= 0 then
	mylog.log(this, "u_component_message_handler.get_message_file.0059", "Error writing message file", 4)
	return -1
end if

return 1
end function

protected function integer xx_handle_message ();integer li_sts

if ole_class then
	return ole.handle_message(message_id, message_file)
else
	setnull(message_cpr_id)
	setnull(message_encounter_id)
	// Load message parts
	li_sts = load_parts()
	if li_sts < 0 then
		mylog.log(this, "u_component_message_handler.handle_message.0043", "Error loading message parts", 4)
		return -1
	end if

	// This is the default message processing to do if xx_create_message is not overridden by a decendent class
	li_sts = db_connect(message_file)
	if li_sts <= 0 then
		mylog.log(this, "u_component_message_handler.xx_handle_message.0018", "Unable to connect to message database (" + message_file + ")", 4)
		return -1
	end if
	
	li_sts = process_parts()
	if li_sts <= 0 then
		db_disconnect()
		mylog.log(this, "u_component_message_handler.xx_handle_message.0018", "Error processing parts", 4)
		return -1
	end if

	db_disconnect()
	
	return 1
end if


end function

private function integer unarchive_parts ();return 1

end function

private function integer process_parts ();integer li_sts
integer i

// First, perform some cleanup to try to prevent some handling problems

// We have had some instances of messages coming in without a needed p_Attachment_List record
// There isn't any information in this record which we can't construct from
// the p_Attachment_Header record, so lets create any missing records
INSERT INTO p_Attachment_List
	(
	cpr_id,
	attachment_id,
	encounter_id,
	attachment_date,
	created,
	created_by,
	p_patient_encounter_encounter_date,
	p_patient_encounter_attending_doctor,
	p_patient_billing_id)
SELECT DISTINCT
	cpr_id,
	attachment_id,
	encounter_id,
	attachment_date,
	created,
	created_by,
	p_patient_encounter_encounter_date,
	p_patient_encounter_attending_doctor,
	p_patient_billing_id
FROM p_Attachment_Header
WHERE attachment_id NOT IN (SELECT attachment_id FROM p_Attachment_List)
USING mydb;
if not mydb.check() then
	mylog.log(this, "u_component_message_handler.process_parts.0034", "Error Error checking p_Attachment_List records", 4)
	return -1
end if


for i = 1 to part_count
	mylog.log(this, "u_component_message_handler.process_parts.0034", "Translating part(" + string(parts[i].message_part_sequence) + ", " + parts[i].part_table + ", " + parts[i].part_unique + ")", 1)
	if parts[i].part_type = "SPECIAL" then
		li_sts = do_special_part(parts[i])
		if li_sts < 0 then
			mylog.log(this, "u_component_message_handler.process_parts.0034", "Error doing special part(" + string(parts[i].message_part_sequence) + ", " + parts[i].part_table + ")", 4)
			return -1
		end if
	elseif parts[i].part_unique = "X" then
		li_sts = translate_x_part(parts[i])
		if li_sts < 0 then
			mylog.log(this, "u_component_message_handler.process_parts.0034", "Error translating x part(" + string(parts[i].message_part_sequence) + ", " + parts[i].part_table + ")", 4)
			return -1
		end if
	elseif parts[i].part_unique = "C" then
		li_sts = translate_c_part(parts[i])
		if li_sts < 0 then
			mylog.log(this, "u_component_message_handler.process_parts.0034", "Error translating C part(" + string(parts[i].message_part_sequence) + ", " + parts[i].part_table + ")", 4)
			return -1
		end if
	else
		li_sts = translate_and_save_part(parts[i])
		if li_sts < 0 then
			mylog.log(this, "u_component_message_handler.process_parts.0034", "Error translating fkeys for part(" + string(parts[i].message_part_sequence) + ", " + parts[i].part_table + ")", 4)
			return -1
		end if
	end if
next
			
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

private function integer load_parts ();long i
long j
long ll_rows
integer li_sts
string ls_query
string ls_part_query
string ls_sep
long ll_message_part_sequence
u_ds_data luo_parts
u_ds_data luo_fkeys
u_ds_data luo_altkeys

luo_parts = CREATE u_ds_data
luo_parts.set_database(cprdb)

luo_fkeys = CREATE u_ds_data
luo_fkeys.set_dataobject("dw_fkey_altkeys", cprdb)

luo_altkeys = CREATE u_ds_data
luo_altkeys.set_database(cprdb)

ls_query = "SELECT message_part_sequence, part_type, part_table, part_order, part_unique FROM c_Message_Part WHERE message_type = '" + message_type + "' ORDER BY part_order, message_part_sequence"
part_count = luo_parts.load_query(ls_query)
if part_count < 0 then return -1

for i = 1 to part_count
	parts[i].message_part_sequence = luo_parts.object.message_part_sequence[i]
	parts[i].part_type = luo_parts.object.part_type[i]
	parts[i].part_table = luo_parts.object.part_table[i]
	parts[i].part_unique = luo_parts.object.part_unique[i]
	SELECT part_query
	INTO :parts[i].part_query
	FROM c_Message_Part
	WHERE message_type = :message_type
	AND message_part_sequence = :parts[i].message_part_sequence
	USING cprdb;
	if not cprdb.check() then return -1
	
	li_sts = load_fkeys(parts[i])
	if li_sts < 0 then return -1

	parts[i].primary_key_list = ""
	parts[i].alt_key_list = ""

	ll_rows = luo_altkeys.load_query("select * from c_Table_Altkey where cpr_table = '" + parts[i].part_table + "'") 
	if ll_rows < 0 then
		mylog.log(this, "u_component_message_handler.load_parts.0047", "error getting altkeys", 4)
		return -1
	elseif ll_rows = 0 then
		setnull(parts[i].primary_key1)
		setnull(parts[i].primary_key2)
		setnull(parts[i].primary_key3)
		setnull(parts[i].primary_key4)
		setnull(parts[i].primary_key5)
		setnull(parts[i].primary_key6)

		setnull(parts[i].alt_key1)
		setnull(parts[i].alt_key2)
		setnull(parts[i].alt_key3)
		setnull(parts[i].alt_key4)
		setnull(parts[i].alt_key5)
		setnull(parts[i].alt_key6)
	else
		ls_sep = ""
		parts[i].primary_key1 = luo_altkeys.object.primary_key1[1]
		if not isnull(parts[i].primary_key1) then
			parts[i].primary_key_list += ls_sep + parts[i].primary_key1
			ls_sep = ", "
		end if

		parts[i].primary_key2 = luo_altkeys.object.primary_key2[1]
		if not isnull(parts[i].primary_key2) then
			parts[i].primary_key_list += ls_sep + parts[i].primary_key2
			ls_sep = ", "
		end if

		parts[i].primary_key3 = luo_altkeys.object.primary_key3[1]
		if not isnull(parts[i].primary_key3) then
			parts[i].primary_key_list += ls_sep + parts[i].primary_key3
			ls_sep = ", "
		end if

		parts[i].primary_key4 = luo_altkeys.object.primary_key4[1]
		if not isnull(parts[i].primary_key4) then
			parts[i].primary_key_list += ls_sep + parts[i].primary_key4
			ls_sep = ", "
		end if

		parts[i].primary_key5 = luo_altkeys.object.primary_key5[1]
		if not isnull(parts[i].primary_key5) then
			parts[i].primary_key_list += ls_sep + parts[i].primary_key5
			ls_sep = ", "
		end if

		parts[i].primary_key6 = luo_altkeys.object.primary_key6[1]
		if not isnull(parts[i].primary_key6) then
			parts[i].primary_key_list += ls_sep + parts[i].primary_key6
			ls_sep = ", "
		end if

		
		ls_sep = ""
		parts[i].alt_key1 = luo_altkeys.object.alt_key1[1]
		if not isnull(parts[i].alt_key1) then
			parts[i].alt_key_list += ls_sep + parts[i].alt_key1
			ls_sep = ", "
		end if

		parts[i].alt_key2 = luo_altkeys.object.alt_key2[1]
		if not isnull(parts[i].alt_key2) then
			parts[i].alt_key_list += ls_sep + parts[i].alt_key2
			ls_sep = ", "
		end if

		parts[i].alt_key3 = luo_altkeys.object.alt_key3[1]
		if not isnull(parts[i].alt_key3) then
			parts[i].alt_key_list += ls_sep + parts[i].alt_key3
			ls_sep = ", "
		end if

		parts[i].alt_key4 = luo_altkeys.object.alt_key4[1]
		if not isnull(parts[i].alt_key4) then
			parts[i].alt_key_list += ls_sep + parts[i].alt_key4
			ls_sep = ", "
		end if

		parts[i].alt_key5 = luo_altkeys.object.alt_key5[1]
		if not isnull(parts[i].alt_key5) then
			parts[i].alt_key_list += ls_sep + parts[i].alt_key5
			ls_sep = ", "
		end if

		parts[i].alt_key6 = luo_altkeys.object.alt_key6[1]
		if not isnull(parts[i].alt_key6) then
			parts[i].alt_key_list += ls_sep + parts[i].alt_key6
			ls_sep = ", "
		end if

	end if
	
	if parts[i].primary_key_list = "" then setnull(parts[i].primary_key_list)
	if parts[i].alt_key_list = "" then setnull(parts[i].alt_key_list)

next

DESTROY luo_parts
DESTROY luo_fkeys
DESTROY luo_altkeys

return 1

end function

private function integer translate_and_save_part (ref str_message_part pstr_part);u_ds_data luo_data
u_ds_data luo_key_data
integer i, j
long ll_rows
string ls_where_clause
string ls_cpr_query
string ls_msg_query
string ls_dw_query
any la_key
string ls_treatment_type
integer li_col
integer li_sts
string ls_billing_id
string ls_cpr_id
long ll_temp
long ll_original_rows
boolean lb_xlate_where

luo_data = CREATE u_ds_data
luo_data.set_database(mydb)

luo_key_data = CREATE u_ds_data
luo_key_data.set_database(cprdb)

ll_rows = luo_data.load_query("select * from " + pstr_part.part_table)
if ll_rows < 0 then
	mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "Error loading message records (" + pstr_part.part_table + ")", 4)
	return -1
end if

ll_original_rows = ll_rows

// Set luo_data to the cpr database for the key translations
luo_data.set_database(cprdb)

for j = 1 to ll_rows
	// For each fkey in reverse order, load the records from the message table and look up the foreign key
	for i = pstr_part.fkey_count to 1 step -1
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
		if lower(pstr_part.fkey[i].target_table) = "c_drug_definition" and lower(pstr_part.part_table) = "p_treatment_item" then
			ls_treatment_type = luo_data.object.treatment_type[j]
			if ls_treatment_type = "IMMUNIZATION" or ls_treatment_type = "PASTIMMUN" then continue
		end if
		
		// Now check for a foreign key from p_treatment_item into c_Vaccine
		if lower(pstr_part.fkey[i].target_table) = "c_vaccine" and lower(pstr_part.part_table) = "p_treatment_item" then
			ls_treatment_type = luo_data.object.treatment_type[j]
			if ls_treatment_type <> "IMMUNIZATION" and ls_treatment_type <> "PASTIMMUN" then continue
		end if
		//
		//
		// This section lf code will be deleted when the c_drug_definition and c_vaccine tables are unified
		///////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////
		
		

		lb_xlate_where = true
		
		// Construct the alternate key lookup where-clause for this message record
		ls_where_clause = fkey_where_clause(luo_data, pstr_part.fkey[i].target_table, pstr_part.fkey[i], j, "DW")
		if isnull(ls_where_clause) then
			lb_xlate_where = false
		else
			ls_dw_query = replace(ls_where_clause, 1, 6, "")
		end if

		ls_where_clause = fkey_where_clause(luo_data, pstr_part.fkey[i].target_table, pstr_part.fkey[i], j, mydb.dbms)
		if isnull(ls_where_clause) then
			lb_xlate_where = false
		else
			ls_msg_query = "SELECT " + pstr_part.fkey[i].target_key_list + " FROM " + pstr_part.fkey[i].target_table + " " + ls_where_clause
		end if

		ls_where_clause = fkey_where_clause(luo_data, pstr_part.fkey[i].target_table, pstr_part.fkey[i], j, cprdb.dbms)
		if isnull(ls_where_clause) then
			lb_xlate_where = false
		else
			ls_cpr_query = "SELECT " + pstr_part.fkey[i].target_key_list + " FROM " + pstr_part.fkey[i].target_table + " " + ls_where_clause
		end if

		if not lb_xlate_where then
			//////////////////////////////////////////////////////////////////////////////////////////////
			// If the message arrives without a translation for p_patient_encounter, then look it up in the
			// message.  If there isn't one and only one record in p_Patient_Encounter, then abort this message.
			if lower(pstr_part.fkey[i].target_table) = "p_patient_encounter" then
				if not isnull(message_cpr_id) and not isnull(message_encounter_id) then
					// Put the encounter_id in the message database
					li_col = integer(luo_data.Describe(pstr_part.fkey[i].fkey2 + ".ID"))
					if li_col > 0 then luo_data.object.data[j, li_col] = message_encounter_id
					continue
				else
					mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "Invalid p_Patient_Encounter foreign key", 4)
					return -1
				end if
			else
				continue
			end if
			//
			//
			///////////////////////////////////////////////////////////////////////////////////////////////
			///////////////////////////////////////////////////////////////////////////////////////////////
		end if

		// Perform query
		CHOOSE CASE pstr_part.fkey[i].target_location
			CASE "DATABASE"
				luo_key_data.set_database(cprdb)
				li_sts = luo_key_data.load_query(ls_cpr_query)
				if li_sts < 0 then
					mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "Error executing lookup query (" + ls_cpr_query + ")", 4)
					return -1
				end if
			CASE ELSE
				// First look in message, then in database
				if lower(pstr_part.part_table) = lower(pstr_part.fkey[i].target_table) then
					// If we're looking in the same table we're translating, then look in the
					// datawindow instead of the message database
					luo_key_data.set_database(cprdb)
					luo_key_data.load_query("SELECT " + pstr_part.fkey[i].target_key_list + " FROM " + pstr_part.fkey[i].target_table + " WHERE 1 = 2")
					li_sts = find_key_in_data(luo_data, luo_key_data, pstr_part.fkey[i], ls_dw_query)
					if li_sts < 0 then
						mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "Error finding key in message data (" + ls_msg_query + ")", 4)
						return -1
					end if
				else
					luo_key_data.set_database(mydb)
					li_sts = luo_key_data.load_query(ls_msg_query)
					if li_sts < 0 then
						mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "Error executing lookup query (" + ls_msg_query + ")", 4)
						return -1
					end if
				end if
				if li_sts = 0 then
					luo_key_data.set_database(cprdb)
					li_sts = luo_key_data.load_query(ls_cpr_query)
					if li_sts < 0 then
						mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "Error executing lookup query (" + ls_cpr_query + ")", 4)
						return -1
					end if
				end if
		END CHOOSE
		
		// Check results
		if li_sts = 0 then
			// Key lookup not found.
			if lower(left(pstr_part.fkey[i].target_table, 2)) = "p_" then
				// If foreign key lookup fails and it should have found a "p_" table then we probably
				// have a synchronization problem.  If we can't resolve it, then we'll order a refresh of this
				// patient's chart.
				
				mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "P data not found.  Requesting chart refresh. (" + ls_cpr_query + ")", 2)
//				order_chart_refresh()
				cprdb.rollback_transaction()
				return -1
			elseif lower(left(pstr_part.fkey[i].target_table, 2)) = "c_" then
				// If foreign key lookup fails and it should have found a "c_" table then we have
				// missing data in this database.  Attempt to add the data from the message.
				li_sts = add_missing_data(pstr_part, luo_data, luo_key_data, j, i)
				if li_sts < 0 then
					mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "Error adding missing data (" + pstr_part.fkey[i].target_table + ")", 4)
					return -1
				end if
			end if
		elseif li_sts > 1 then
			// too many keys found
			mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "Foreign key lookup found multiple records (" + ls_cpr_query + ")", 1)
		end if
		
		// Now put the alternate key values back into message database
		
		if not isnull(pstr_part.fkey[i].target_key1) then
			// Get the value from the cpr database
			li_col = integer(luo_key_data.Describe(pstr_part.fkey[i].target_key1 + ".ID"))
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			li_col = integer(luo_data.Describe(pstr_part.fkey[i].fkey1 + ".ID"))
			if li_col > 0 then luo_data.object.data[j, li_col] = la_key
		end if

		if not isnull(pstr_part.fkey[i].target_key2) then
			// Get the value from the cpr database
			li_col = integer(luo_key_data.Describe(pstr_part.fkey[i].target_key2 + ".ID"))
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			li_col = integer(luo_data.Describe(pstr_part.fkey[i].fkey2 + ".ID"))
			if li_col > 0 then luo_data.object.data[j, li_col] = la_key
		end if

		if not isnull(pstr_part.fkey[i].target_key3) then
			// Get the value from the cpr database
			li_col = integer(luo_key_data.Describe(pstr_part.fkey[i].target_key3 + ".ID"))
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			li_col = integer(luo_data.Describe(pstr_part.fkey[i].fkey3 + ".ID"))
			if li_col > 0 then luo_data.object.data[j, li_col] = la_key
		end if

		if not isnull(pstr_part.fkey[i].target_key4) then
			// Get the value from the cpr database
			li_col = integer(luo_key_data.Describe(pstr_part.fkey[i].target_key4 + ".ID"))
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			li_col = integer(luo_data.Describe(pstr_part.fkey[i].fkey4 + ".ID"))
			if li_col > 0 then luo_data.object.data[j, li_col] = la_key
		end if

		if not isnull(pstr_part.fkey[i].target_key5) then
			// Get the value from the cpr database
			li_col = integer(luo_key_data.Describe(pstr_part.fkey[i].target_key5 + ".ID"))
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			li_col = integer(luo_data.Describe(pstr_part.fkey[i].fkey5 + ".ID"))
			if li_col > 0 then luo_data.object.data[j, li_col] = la_key
		end if

		if not isnull(pstr_part.fkey[i].target_key6) then
			// Get the value from the cpr database
			li_col = integer(luo_key_data.Describe(pstr_part.fkey[i].target_key6 + ".ID"))
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			li_col = integer(luo_data.Describe(pstr_part.fkey[i].fkey6 + ".ID"))
			if li_col > 0 then luo_data.object.data[j, li_col] = la_key
		end if
	next // fkey loop

	// Now worry about the keys
	if lower(pstr_part.part_table) = "p_patient" then
		// If this is the patient record, then check to see if it exists in the cpr database
		ls_billing_id = luo_data.object.billing_id[j]
		if not isnull(ls_billing_id) then
			SELECT cpr_id
			INTO :ls_cpr_id
			FROM p_Patient
			WHERE billing_id = :ls_billing_id
			USING cprdb;
			if not cprdb.check() then return -1
			if cprdb.sqlcode = 100 then
				// If the patient doesn't exist, then add to cpr database
				luo_data.generate_new_key(pstr_part.part_table, j)
				li_sts = luo_data.save_to_table(pstr_part.part_table, j)
				if li_sts < 0 then
					mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "Error adding patient record to database (" + ls_cpr_id + ")", 4)
					return -1
				end if
			elseif cprdb.sqlcode = 0 then
				// If we found the patient, then update the message database with the correct cpr_id
				luo_data.object.cpr_id[j] = ls_cpr_id
			end if
			if ll_original_rows = 1 then message_cpr_id = luo_data.object.cpr_id[j]
		else
			mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "Billing_id is null.  This patient cannot be replicated", 4)
			return -1
		end if
	else
		// Check to see if this record already exists in the cpr database
		li_sts = check_record_unique(luo_data, pstr_part, j)
		if li_sts < 0 then
			mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "Error checking unique record (" + pstr_part.part_table + ")", 4)
			return -1
		elseif li_sts > 0 then
			// If this record already exists in the database, then we shouldn't add it again.  We'll just
			// assume that this message is at least in part a duplicate (like a chart refresh) and delete this
			// record from the message.  This will cause all records with foreign key lookups to this table
			// (which are restricted to the message) to also be ignored.
			luo_data.delete_record(pstr_part.part_table, j)
			j -= 1
			ll_rows -= 1
			continue
		else
			// This row is translated and we know it doesn't exist in the cpr database, 
			// so generate a new key for the insert into the cpr database
			luo_data.set_database(cprdb)
			luo_data.generate_new_key(pstr_part.part_table, j)
			li_sts = luo_data.save_to_table(pstr_part.part_table, j)
			if li_sts < 0 then
				mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "Error saving message records (" + pstr_part.part_table + ")", 4)
				return -1
			else
				// If this is the p_patient_encounter table and there is only one encounter record
				// and it got translated, then store it in the instance variable for later use
				if lower(pstr_part.part_table) = "p_patient_encounter" and ll_original_rows = 1 then
					message_encounter_id = luo_data.object.encounter_id[j]
				end if
			end if
		end if
	end if
	if lower(pstr_part.part_table) = "p_treatment_item" then
		ll_temp = luo_data.object.treatment_id[j]
	end if
next // row loop

// Finally, save all these changes back to the message database
luo_data.set_database(mydb)
li_sts = luo_data.replace_table(pstr_part.part_table)
if li_sts < 0 then
	mylog.log(this, "u_component_message_handler.translate_and_save_part.0027", "Error replacing message records (" + pstr_part.part_table + ")", 4)
	return -1
end if

DESTROY luo_data
DESTROY luo_key_data

return 1

end function

private function integer translate_x_part (ref str_message_part pstr_part);// An 'X' part needs to be kept completely in sync, even the primary keys.  This would normally
// be taken care of by a replication engine, but there is no guarantee that replication has taken
// place before this message arrives.  Relevent 'X' data shipped with the message will be checked against
// the target database and added if necessary.  We will only perform inserts here and only check
// the primary key.  If other data changes in these records we assume that the replication process
// will eventually take care of it so all we need are the primary keys to preserve the referential
// integrity of the other message parts.

u_ds_data luo_data
u_ds_data luo_key_data
integer i
long ll_rows
string ls_where_clause
string ls_query
any la_key
string ls_treatment_type
integer li_col
integer li_sts
string ls_temp

luo_data = CREATE u_ds_data
luo_data.set_database(mydb)

luo_key_data = CREATE u_ds_data
luo_key_data.set_database(cprdb)

ll_rows = luo_data.load_query("select * from " + pstr_part.part_table)
if ll_rows < 0 then
	mylog.log(this, "u_component_message_handler.translate_x_part.0029", "Error loading message records (" + pstr_part.part_table + ")", 4)
	return -1
end if

// Here's another hard-coded work-around.  The c_provider table is really an extension of the
// c_User table, but they haven't been unified yet.  The c_Provider table will never be the target
// of a key translation, and new records will be handled when the c_User table detects new
// records.  Therefore, we don't need to do anything here
if lower(pstr_part.part_table) = "c_provider_id" then return 1
///////////////////////////////////////////////////////////////////////////////////////////////

for i = 1 to ll_rows
	// Construct the alternate key lookup where-clause for this message record
	ls_where_clause = prikey_where_clause(luo_data, pstr_part.part_table, i)
	if isnull(ls_where_clause) then
		mylog.log(this, "u_component_message_handler.translate_x_part.0029", "Unable to get where_clause", 3)
		continue
	end if
	
	// Construct query to look up primary key from alternate key of table in cpr database
	ls_query = "SELECT " + pstr_part.primary_key_list + " FROM " + pstr_part.part_table + " " + ls_where_clause

	li_sts = luo_key_data.load_query(ls_query)
	
	// Check results
	if li_sts < 0 then
		// Error
		mylog.log(this, "u_component_message_handler.translate_x_part.0029", "Error executing lookup query (" + ls_query + ")", 4)
		return -1
	elseif li_sts = 0 then
		// If foreign key lookup fails and it should have found a "c_" table then we have
		// missing data in this database.  Attempt to add the data from the message.
		li_sts = add_missing_x_data(pstr_part, luo_data, luo_key_data, i)
		if li_sts < 0 then
			mylog.log(this, "u_component_message_handler.translate_x_part.0029", "Error adding missing data (" + pstr_part.part_table + ")", 4)
			return -1
		end if
	elseif li_sts > 1 then
		// too many keys found
		mylog.log(this, "u_component_message_handler.translate_x_part.0029", "Primary key lookup found multiple records (" + ls_query + ")", 1)
	end if
	
	// If all went well and we found one row, then just loop to the next row
next

DESTROY luo_data
DESTROY luo_key_data

return 1

end function

public function integer add_missing_data (str_message_part pstr_part, u_ds_data puo_data, u_ds_data puo_key_data, long pl_row, integer pi_fkey);string ls_column
string ls_query
integer li_sts
any la_key
integer li_col
u_ds_data luo_data

if pi_fkey <= 0 then
	mylog.log(this, "u_component_message_handler.add_missing_data.0009", "Invalid fkey index", 4)
	return -1
else
	ls_query = "SELECT * FROM " + pstr_part.fkey[pi_fkey].target_table + " WHERE 1 = 2"
end if

luo_data = CREATE u_ds_data
luo_data.set_database(cprdb)

li_sts = luo_data.load_query(ls_query)
if li_sts < 0 then
	mylog.log(this, "u_component_message_handler.add_missing_data.0009", "Error creating empty datastore", 4)
	return -1
end if

luo_data.insertrow(0)

if not isnull(pstr_part.fkey[pi_fkey].alt_key1) then
	// Get the value
	ls_column = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key1
	li_col = integer(puo_data.Describe(ls_column + ".ID"))
	if li_col <= 0 then
		ls_column = pstr_part.fkey[pi_fkey].alt_key1
		li_col = integer(puo_data.Describe(ls_column + ".ID"))
	end if
	if li_col > 0 then
		la_key = puo_data.object.data[pl_row, li_col]
		
		// Put the value in the new datastore
		li_col = integer(luo_data.Describe(pstr_part.fkey[pi_fkey].alt_key1 + ".ID"))
		if li_col > 0 then luo_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].alt_key2) then
	// Get the value
	ls_column = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key2
	li_col = integer(puo_data.Describe(ls_column + ".ID"))
	if li_col <= 0 then
		ls_column = pstr_part.fkey[pi_fkey].alt_key2
		li_col = integer(puo_data.Describe(ls_column + ".ID"))
	end if
	if li_col > 0 then
		la_key = puo_data.object.data[pl_row, li_col]
		
		// Put the value in the new datastore
		li_col = integer(luo_data.Describe(pstr_part.fkey[pi_fkey].alt_key2 + ".ID"))
		if li_col > 0 then luo_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].alt_key3) then
	// Get the value
	ls_column = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key3
	li_col = integer(puo_data.Describe(ls_column + ".ID"))
	if li_col <= 0 then
		ls_column = pstr_part.fkey[pi_fkey].alt_key3
		li_col = integer(puo_data.Describe(ls_column + ".ID"))
	end if
	if li_col > 0 then
		la_key = puo_data.object.data[pl_row, li_col]
		
		// Put the value in the new datastore
		li_col = integer(luo_data.Describe(pstr_part.fkey[pi_fkey].alt_key3 + ".ID"))
		if li_col > 0 then luo_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].alt_key4) then
	// Get the value
	ls_column = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key4
	li_col = integer(puo_data.Describe(ls_column + ".ID"))
	if li_col <= 0 then
		ls_column = pstr_part.fkey[pi_fkey].alt_key4
		li_col = integer(puo_data.Describe(ls_column + ".ID"))
	end if
	if li_col > 0 then
		la_key = puo_data.object.data[pl_row, li_col]
		
		// Put the value in the new datastore
		li_col = integer(luo_data.Describe(pstr_part.fkey[pi_fkey].alt_key4 + ".ID"))
		if li_col > 0 then luo_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].alt_key5) then
	// Get the value
	ls_column = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key5
	li_col = integer(puo_data.Describe(ls_column + ".ID"))
	if li_col <= 0 then
		ls_column = pstr_part.fkey[pi_fkey].alt_key5
		li_col = integer(puo_data.Describe(ls_column + ".ID"))
	end if
	if li_col > 0 then
		la_key = puo_data.object.data[pl_row, li_col]
		
		// Put the value in the new datastore
		li_col = integer(luo_data.Describe(pstr_part.fkey[pi_fkey].alt_key5 + ".ID"))
		if li_col > 0 then luo_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].alt_key6) then
	// Get the value
	ls_column = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].alt_key6
	li_col = integer(puo_data.Describe(ls_column + ".ID"))
	if li_col <= 0 then
		ls_column = pstr_part.fkey[pi_fkey].alt_key6
		li_col = integer(puo_data.Describe(ls_column + ".ID"))
	end if
	if li_col > 0 then
		la_key = puo_data.object.data[pl_row, li_col]
		
		// Put the value in the new datastore
		li_col = integer(luo_data.Describe(pstr_part.fkey[pi_fkey].alt_key6 + ".ID"))
		if li_col > 0 then luo_data.object.data[1, li_col] = la_key
	end if
end if


li_sts = luo_data.generate_new_keys(pstr_part.fkey[pi_fkey].target_table)
if li_sts < 0 then
	mylog.log(this, "u_component_message_handler.add_missing_data.0009", "Error generating new primary keys (" + pstr_part.fkey[pi_fkey].target_table + ")", 4)
	return -1
end if

li_sts = luo_data.save_to_table(pstr_part.fkey[pi_fkey].target_table, false)
if li_sts < 0 then
	mylog.log(this, "u_component_message_handler.add_missing_data.0009", "Error saving message records (" + pstr_part.fkey[pi_fkey].target_table + ")", 4)
	return -1
end if


// Now that we've generated new keys, put them in the puo_key_data so they can be recorded
if not isnull(pstr_part.fkey[pi_fkey].target_key1) then
	// Get the value
	ls_column = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].target_key1
	li_col = integer(puo_data.Describe(ls_column + ".ID"))
	if li_col <= 0 then
		ls_column = pstr_part.fkey[pi_fkey].target_key1
		li_col = integer(puo_data.Describe(ls_column + ".ID"))
	end if
	if li_col > 0 then
		la_key = puo_data.object.data[pl_row, li_col]

		// Put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_part.fkey[pi_fkey].target_key1 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].target_key2) then
	// Get the value
	ls_column = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].target_key2
	li_col = integer(puo_data.Describe(ls_column + ".ID"))
	if li_col <= 0 then
		ls_column = pstr_part.fkey[pi_fkey].target_key2
		li_col = integer(puo_data.Describe(ls_column + ".ID"))
	end if
	if li_col > 0 then
		la_key = puo_data.object.data[pl_row, li_col]

		// Put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_part.fkey[pi_fkey].target_key2 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].target_key3) then
	// Get the value
	ls_column = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].target_key3
	li_col = integer(puo_data.Describe(ls_column + ".ID"))
	if li_col <= 0 then
		ls_column = pstr_part.fkey[pi_fkey].target_key3
		li_col = integer(puo_data.Describe(ls_column + ".ID"))
	end if
	if li_col > 0 then
		la_key = puo_data.object.data[pl_row, li_col]

		// Put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_part.fkey[pi_fkey].target_key3 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].target_key4) then
	// Get the value
	ls_column = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].target_key4
	li_col = integer(puo_data.Describe(ls_column + ".ID"))
	if li_col <= 0 then
		ls_column = pstr_part.fkey[pi_fkey].target_key4
		li_col = integer(puo_data.Describe(ls_column + ".ID"))
	end if
	if li_col > 0 then
		la_key = puo_data.object.data[pl_row, li_col]

		// Put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_part.fkey[pi_fkey].target_key4 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].target_key5) then
	// Get the value
	ls_column = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].target_key5
	li_col = integer(puo_data.Describe(ls_column + ".ID"))
	if li_col <= 0 then
		ls_column = pstr_part.fkey[pi_fkey].target_key5
		li_col = integer(puo_data.Describe(ls_column + ".ID"))
	end if
	if li_col > 0 then
		la_key = puo_data.object.data[pl_row, li_col]

		// Put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_part.fkey[pi_fkey].target_key5 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.fkey[pi_fkey].target_key6) then
	// Get the value
	ls_column = pstr_part.fkey[pi_fkey].target_table + "_" + pstr_part.fkey[pi_fkey].target_key6
	li_col = integer(puo_data.Describe(ls_column + ".ID"))
	if li_col <= 0 then
		ls_column = pstr_part.fkey[pi_fkey].target_key6
		li_col = integer(puo_data.Describe(ls_column + ".ID"))
	end if
	if li_col > 0 then
		la_key = puo_data.object.data[pl_row, li_col]

		// Put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_part.fkey[pi_fkey].target_key6 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[1, li_col] = la_key
	end if
end if



DESTROY luo_data

return 1


end function

public function integer add_missing_x_data (str_message_part pstr_part, u_ds_data puo_data, u_ds_data puo_key_data, long pl_row);string ls_query
string ls_syntax
string ls_error_create
string ls_old_user_id
string ls_new_user_id
integer li_sts
integer li_col
any la_key
u_ds_data luo_data


luo_data = CREATE u_ds_data

ls_syntax = puo_data.object.datawindow.syntax

luo_data.create(ls_syntax, ls_error_create)
if Len(ls_error_create) > 0 THEN
	mydb.mylog.log(this, "u_component_message_handler.add_missing_x_data.0018", "Error creating datastore (" + ls_error_create + ")", 4)
	return -1
end if

luo_data.object.data[1] = puo_data.object.data[pl_row]

luo_data.set_database(cprdb)

li_sts = luo_data.save_to_table(pstr_part.part_table, false)
if li_sts < 0 then
	mylog.log(this, "u_component_message_handler.add_missing_x_data.0028", "Error saving message records (" + pstr_part.part_table + ")", 4)
	return -1
end if

DESTROY luo_data

return 1


end function

private function integer translate_c_part (ref str_message_part pstr_part);u_ds_data luo_data
u_ds_data luo_key_data
integer i
long ll_rows
string ls_where_clause
string ls_query
any la_key
string ls_treatment_type
integer li_col
integer li_sts
string ls_temp
long ll_row

luo_data = CREATE u_ds_data
luo_data.set_database(mydb)

luo_key_data = CREATE u_ds_data
luo_key_data.set_database(cprdb)

ll_rows = luo_data.load_query("select * from " + pstr_part.part_table)
if ll_rows < 0 then
	mylog.log(this, "u_component_message_handler.translate_c_part.0022", "Error loading message records (" + pstr_part.part_table + ")", 4)
	return -1
end if

// Here's another hard-coded work-around.  The c_provider table is really an extension of the
// c_User table, but they haven't been unified yet.  The c_Provider table will never be the target
// of a key translation, and new records will be handled when the c_User table detects new
// records.  Therefore, we don't need to do anything here
if lower(pstr_part.part_table) = "c_provider_id" then return 1
///////////////////////////////////////////////////////////////////////////////////////////////

for i = 1 to ll_rows
	if i > 1 then
		// Construct the alternate key lookup find clause for this message record
		ls_where_clause = altkey_where_clause(luo_data, pstr_part.part_table, i, "DW")
		ll_row = luo_data.find(ls_where_clause, 1, i - 1)
		if ll_row > 0 then
			luo_data.deleterow(i)
			ll_rows -= 1
			continue
		end if
	end if
	
	// Construct the alternate key lookup where-clause for this message record
	ls_where_clause = altkey_where_clause(luo_data, pstr_part.part_table, i)
	
	// Construct query to look up primary key from alternate key of table in cpr database
	ls_query = "SELECT " + pstr_part.primary_key_list + " FROM " + pstr_part.part_table + " " + ls_where_clause

	luo_key_data.set_database(cprdb)
	li_sts = luo_key_data.load_query(ls_query)
	
	// Check results
	if li_sts < 0 then
		// Error
		mylog.log(this, "u_component_message_handler.translate_c_part.0022", "Error executing lookup query (" + ls_query + ")", 4)
		return -1
	elseif li_sts = 0 then
		// If foreign key lookup fails and it should have found a "c_" table then we have
		// missing data in this database.  Attempt to add the data from the message.
		li_sts = add_missing_c_data(pstr_part, luo_data, luo_key_data, i)
		if li_sts < 0 then
			mylog.log(this, "u_component_message_handler.translate_c_part.0022", "Error adding missing data (" + pstr_part.part_table + ")", 4)
			return -1
		end if
	elseif li_sts > 1 then
		// too many keys found
		mylog.log(this, "u_component_message_handler.translate_c_part.0022", "Foreign key lookup found multiple records (" + ls_query + ")", 1)
	end if
	
	// Now put the alternate key values back into message database
	
	if not isnull(pstr_part.primary_key1) then
		// Get the value from the cpr database
		li_col = integer(luo_key_data.Describe(pstr_part.primary_key1 + ".ID"))
		if li_col > 0 then
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			li_col = integer(luo_data.Describe(pstr_part.primary_key1 + ".ID"))
			if li_col > 0 then luo_data.object.data[i, li_col] = la_key
		end if
	end if

	if not isnull(pstr_part.primary_key2) then
		// Get the value from the cpr database
		li_col = integer(luo_key_data.Describe(pstr_part.primary_key2 + ".ID"))
		if li_col > 0 then
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			li_col = integer(luo_data.Describe(pstr_part.primary_key2 + ".ID"))
			if li_col > 0 then luo_data.object.data[i, li_col] = la_key
		end if
	end if

	if not isnull(pstr_part.primary_key3) then
		// Get the value from the cpr database
		li_col = integer(luo_key_data.Describe(pstr_part.primary_key3 + ".ID"))
		if li_col > 0 then
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			li_col = integer(luo_data.Describe(pstr_part.primary_key3 + ".ID"))
			if li_col > 0 then luo_data.object.data[i, li_col] = la_key
		end if
	end if

	if not isnull(pstr_part.primary_key4) then
		// Get the value from the cpr database
		li_col = integer(luo_key_data.Describe(pstr_part.primary_key4 + ".ID"))
		if li_col > 0 then
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			li_col = integer(luo_data.Describe(pstr_part.primary_key4 + ".ID"))
			if li_col > 0 then luo_data.object.data[i, li_col] = la_key
		end if
	end if

	if not isnull(pstr_part.primary_key5) then
		// Get the value from the cpr database
		li_col = integer(luo_key_data.Describe(pstr_part.primary_key5 + ".ID"))
		if li_col > 0 then
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			li_col = integer(luo_data.Describe(pstr_part.primary_key5 + ".ID"))
			if li_col > 0 then luo_data.object.data[i, li_col] = la_key
		end if
	end if

	if not isnull(pstr_part.primary_key6) then
		// Get the value from the cpr database
		li_col = integer(luo_key_data.Describe(pstr_part.primary_key6 + ".ID"))
		if li_col > 0 then
			la_key = luo_key_data.object.data[1, li_col]
			
			// Put the value in the message database
			li_col = integer(luo_data.Describe(pstr_part.primary_key6 + ".ID"))
			if li_col > 0 then luo_data.object.data[i, li_col] = la_key
		end if
	end if

next

luo_data.set_database(mydb)
li_sts = luo_data.replace_table(pstr_part.part_table)
if li_sts < 0 then
	mylog.log(this, "u_component_message_handler.translate_c_part.0022", "Error saving message records (" + pstr_part.part_table + ")", 4)
	return -1
end if

DESTROY luo_data
DESTROY luo_key_data

return 1

end function

public function integer add_missing_c_data (str_message_part pstr_part, u_ds_data puo_data, u_ds_data puo_key_data, long pl_row);string ls_query
string ls_syntax
string ls_error_create
string ls_old_user_id
string ls_new_user_id
integer li_sts
integer li_col
any la_key
u_ds_data luo_data


luo_data = CREATE u_ds_data

ls_syntax = puo_data.object.datawindow.syntax

luo_data.create(ls_syntax, ls_error_create)
if Len(ls_error_create) > 0 THEN
	mydb.mylog.log(this, "u_component_message_handler.add_missing_c_data.0018", "Error creating datastore (" + ls_error_create + ")", 4)
	return -1
end if

luo_data.object.data[1] = puo_data.object.data[pl_row]

puo_key_data.reset()
puo_key_data.insertrow(0)


luo_data.set_database(cprdb)

li_sts = luo_data.generate_new_keys(pstr_part.part_table)
if li_sts < 0 then
	mylog.log(this, "u_component_message_handler.add_missing_c_data.0032", "Error generating new primary keys (" + pstr_part.part_table + ")", 4)
	return -1
end if

li_sts = luo_data.save_to_table(pstr_part.part_table, false)
if li_sts < 0 then
	mylog.log(this, "u_component_message_handler.add_missing_c_data.0032", "Error saving message records (" + pstr_part.part_table + ")", 4)
	return -1
end if

if not isnull(pstr_part.primary_key1) then
	// Get the value
	li_col = integer(luo_data.Describe(pstr_part.primary_key1 + ".ID"))
	if li_col > 0 then
		la_key = luo_data.object.data[1, li_col]
		
		// And put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_part.primary_key1 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.primary_key2) then
	// Get the value
	li_col = integer(luo_data.Describe(pstr_part.primary_key2 + ".ID"))
	if li_col > 0 then
		la_key = luo_data.object.data[1, li_col]
		
		// And put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_part.primary_key2 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.primary_key3) then
	// Get the value
	li_col = integer(luo_data.Describe(pstr_part.primary_key3 + ".ID"))
	if li_col > 0 then
		la_key = luo_data.object.data[1, li_col]
		
		// And put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_part.primary_key3 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.primary_key4) then
	// Get the value
	li_col = integer(luo_data.Describe(pstr_part.primary_key4 + ".ID"))
	if li_col > 0 then
		la_key = luo_data.object.data[1, li_col]
		
		// And put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_part.primary_key4 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.primary_key5) then
	// Get the value
	li_col = integer(luo_data.Describe(pstr_part.primary_key5 + ".ID"))
	if li_col > 0 then
		la_key = luo_data.object.data[1, li_col]
		
		// And put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_part.primary_key5 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[1, li_col] = la_key
	end if
end if

if not isnull(pstr_part.primary_key6) then
	// Get the value
	li_col = integer(luo_data.Describe(pstr_part.primary_key6 + ".ID"))
	if li_col > 0 then
		la_key = luo_data.object.data[1, li_col]
		
		// And put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_part.primary_key6 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[1, li_col] = la_key
	end if
end if


DESTROY luo_data

return 1


end function

private function string prikey_where_clause (u_ds_data puo_data, string ps_table, long pl_row);string ls_type
string ls_item
string ls_delim
integer li_col
string ls_where_clause
string ls_primary_key1
string ls_primary_key2
string ls_primary_key3
string ls_primary_key4
string ls_primary_key5
string ls_primary_key6
long ll_rows
u_ds_data luo_altkeys

luo_altkeys = CREATE u_ds_data
luo_altkeys.set_database(cprdb)
ll_rows = luo_altkeys.load_query("select * from c_Table_Altkey where cpr_table = '" + ps_table + "'") 
if ll_rows < 0 then
	mylog.log(this, "u_component_message_handler.load_parts.0047", "error getting altkeys", 4)
	setnull(ls_where_clause)
	return ls_where_clause
elseif ll_rows = 0 then
	mylog.log(this, "u_component_message_handler.load_parts.0047", "c_Table_Altkey record not found (" + ps_table + ")", 4)
	setnull(ls_where_clause)
	return ls_where_clause
end if

ls_primary_key1 = luo_altkeys.object.primary_key1[1]
ls_primary_key2 = luo_altkeys.object.primary_key2[1]
ls_primary_key3 = luo_altkeys.object.primary_key3[1]
ls_primary_key4 = luo_altkeys.object.primary_key4[1]
ls_primary_key5 = luo_altkeys.object.primary_key5[1]
ls_primary_key6 = luo_altkeys.object.primary_key6[1]

DESTROY luo_altkeys

if not isnull(ls_primary_key1) then
	ls_item = puo_data.where_clause_item(ls_primary_key1, pl_row)
	if isnull(ls_item) then
		mylog.log(this, "u_component_message_handler.prikey_where_clause.0040", "Null primary key field (" + ps_table + ", " + ls_primary_key1 + ")", 4)
		setnull(ls_where_clause)
		return ls_where_clause
	end if
	ls_where_clause += "WHERE " + ls_primary_key1 + " = " + ls_item
else
	mylog.log(this, "u_component_message_handler.load_parts.0047", "First primary_key is null", 4)
	setnull(ls_where_clause)
	return ls_where_clause
end if

if not isnull(ls_primary_key2) then
	ls_item = puo_data.where_clause_item(ls_primary_key2, pl_row)
	if isnull(ls_item) then
		mylog.log(this, "u_component_message_handler.prikey_where_clause.0040", "Null primary key field (" + ps_table + ", " + ls_primary_key2 + ")", 4)
		setnull(ls_where_clause)
		return ls_where_clause
	end if
	ls_where_clause += " AND " + ls_primary_key2 + " = " + ls_item
end if

if not isnull(ls_primary_key3) then
	ls_item = puo_data.where_clause_item(ls_primary_key3, pl_row)
	if isnull(ls_item) then
		mylog.log(this, "u_component_message_handler.prikey_where_clause.0040", "Null primary key field (" + ps_table + ", " + ls_primary_key3 + ")", 4)
		setnull(ls_where_clause)
		return ls_where_clause
	end if
	ls_where_clause += " AND " + ls_primary_key3 + " = " + ls_item
end if

if not isnull(ls_primary_key4) then
	ls_item = puo_data.where_clause_item(ls_primary_key4, pl_row)
	if isnull(ls_item) then
		mylog.log(this, "u_component_message_handler.prikey_where_clause.0040", "Null primary key field (" + ps_table + ", " + ls_primary_key4 + ")", 4)
		setnull(ls_where_clause)
		return ls_where_clause
	end if
	ls_where_clause += " AND " + ls_primary_key4 + " = " + ls_item
end if

if not isnull(ls_primary_key5) then
	ls_item = puo_data.where_clause_item(ls_primary_key5, pl_row)
	if isnull(ls_item) then
		mylog.log(this, "u_component_message_handler.prikey_where_clause.0040", "Null primary key field (" + ps_table + ", " + ls_primary_key5 + ")", 4)
		setnull(ls_where_clause)
		return ls_where_clause
	end if
	ls_where_clause += " AND " + ls_primary_key5 + " = " + ls_item
end if

if not isnull(ls_primary_key6) then
	ls_item = puo_data.where_clause_item(ls_primary_key6, pl_row)
	if isnull(ls_item) then
		mylog.log(this, "u_component_message_handler.prikey_where_clause.0040", "Null primary key field (" + ps_table + ", " + ls_primary_key6 + ")", 4)
		setnull(ls_where_clause)
		return ls_where_clause
	end if
	ls_where_clause += " AND " + ls_primary_key6 + " = " + ls_item
end if


return ls_where_clause

end function

private function string fkey_where_clause (u_ds_data puo_data, string ps_table, ref str_message_fkey pstr_fkey, long pl_row, string ps_dbms);string ls_type
string ls_item
string ls_delim
integer li_col
string ls_column
string ls_where_clause

ls_where_clause = ""

if not isnull(pstr_fkey.alt_key1) then
	ls_column = ps_table + "_" + pstr_fkey.alt_key1
	// First check for the column with the table prefix
	ls_item = puo_data.where_clause_clause(ls_column, pl_row, ps_dbms, pstr_fkey.alt_key1)
	// If not found, then check for the field by itself
	if isnull(ls_item) or ls_item = "!" then ls_item = puo_data.where_clause_clause(pstr_fkey.alt_key1, pl_row, ps_dbms, pstr_fkey.alt_key1)
	if isnull(ls_item) or ls_item = "!" then
		// Fkey field in alt key must not be null
		setnull(ls_where_clause)
		return ls_where_clause
	else
		ls_where_clause += " AND " + ls_item
	end if
else
	mylog.log(this, "u_component_message_handler.fkey_where_clause.0024", "First fkey is null", 4)
	setnull(ls_where_clause)
	return ls_where_clause
end if

if not isnull(pstr_fkey.alt_key2) then
	ls_column = ps_table + "_" + pstr_fkey.alt_key2
	// First check for the column with the table prefix
	ls_item = puo_data.where_clause_clause(ls_column, pl_row, ps_dbms, pstr_fkey.alt_key2)
	// If not found, then check for the field by itself
	if isnull(ls_item) or ls_item = "!" then ls_item = puo_data.where_clause_clause(pstr_fkey.alt_key2, pl_row, ps_dbms, pstr_fkey.alt_key2)
	if isnull(ls_item) or ls_item = "!" then
		// Fkey field in alt key must not be null
		setnull(ls_where_clause)
		return ls_where_clause
	else
		ls_where_clause += " AND " + ls_item
	end if
end if

if not isnull(pstr_fkey.alt_key3) then
	ls_column = ps_table + "_" + pstr_fkey.alt_key3
	// First check for the column with the table prefix
	ls_item = puo_data.where_clause_clause(ls_column, pl_row, ps_dbms, pstr_fkey.alt_key3)
	// If not found, then check for the field by itself
	if isnull(ls_item) or ls_item = "!" then ls_item = puo_data.where_clause_clause(pstr_fkey.alt_key3, pl_row, ps_dbms, pstr_fkey.alt_key3)
	if isnull(ls_item) or ls_item = "!" then
		// Fkey field in alt key must not be null
		setnull(ls_where_clause)
		return ls_where_clause
	else
		ls_where_clause += " AND " + ls_item
	end if
end if

if not isnull(pstr_fkey.alt_key4) then
	ls_column = ps_table + "_" + pstr_fkey.alt_key4
	// First check for the column with the table prefix
	ls_item = puo_data.where_clause_clause(ls_column, pl_row, ps_dbms, pstr_fkey.alt_key4)
	// If not found, then check for the field by itself
	if isnull(ls_item) or ls_item = "!" then ls_item = puo_data.where_clause_clause(pstr_fkey.alt_key4, pl_row, ps_dbms, pstr_fkey.alt_key4)
	if isnull(ls_item) or ls_item = "!" then
		// Fkey field in alt key must not be null
		setnull(ls_where_clause)
		return ls_where_clause
	else
		ls_where_clause += " AND " + ls_item
	end if
end if

if not isnull(pstr_fkey.alt_key5) then
	ls_column = ps_table + "_" + pstr_fkey.alt_key5
	// First check for the column with the table prefix
	ls_item = puo_data.where_clause_clause(ls_column, pl_row, ps_dbms, pstr_fkey.alt_key5)
	// If not found, then check for the field by itself
	if isnull(ls_item) or ls_item = "!" then ls_item = puo_data.where_clause_clause(pstr_fkey.alt_key5, pl_row, ps_dbms, pstr_fkey.alt_key5)
	if isnull(ls_item) or ls_item = "!" then
		// Fkey field in alt key must not be null
		setnull(ls_where_clause)
		return ls_where_clause
	else
		ls_where_clause += " AND " + ls_item
	end if
end if

if not isnull(pstr_fkey.alt_key6) then
	ls_column = ps_table + "_" + pstr_fkey.alt_key6
	// First check for the column with the table prefix
	ls_item = puo_data.where_clause_clause(ls_column, pl_row, ps_dbms, pstr_fkey.alt_key6)
	// If not found, then check for the field by itself
	if isnull(ls_item) or ls_item = "!" then ls_item = puo_data.where_clause_clause(pstr_fkey.alt_key6, pl_row, ps_dbms, pstr_fkey.alt_key6)
	if isnull(ls_item) or ls_item = "!" then
		// Fkey field in alt key must not be null
		setnull(ls_where_clause)
		return ls_where_clause
	else
		ls_where_clause += " AND " + ls_item
	end if
end if

ls_where_clause = replace(ls_where_clause, 1, 4, "WHERE")

return ls_where_clause

end function

private function integer find_key_in_data (u_ds_data puo_data, u_ds_data puo_key_data, str_message_fkey pstr_fkey, string ps_find_string);long ll_row
long ll_key_row
integer li_col
any la_key

// Find record in datastore
ll_row = puo_data.find(ps_find_string, 1, puo_data.rowcount())
if ll_row <= 0 then return 0

// If we found one, then transfer the target_key values to the puo_key_data datastore
puo_key_data.reset()
ll_key_row = puo_key_data.insertrow(0)

if not isnull(pstr_fkey.target_key1) then
	// Get the value
	li_col = integer(puo_data.Describe(pstr_fkey.target_key1 + ".ID"))
	if li_col > 0 then
		la_key = puo_data.object.data[ll_row, li_col]
		
		// And put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_fkey.target_key1 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[ll_key_row, li_col] = la_key
	end if
end if

if not isnull(pstr_fkey.target_key2) then
	// Get the value
	li_col = integer(puo_data.Describe(pstr_fkey.target_key2 + ".ID"))
	if li_col > 0 then
		la_key = puo_data.object.data[ll_row, li_col]
		
		// And put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_fkey.target_key2 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[ll_key_row, li_col] = la_key
	end if
end if

if not isnull(pstr_fkey.target_key3) then
	// Get the value
	li_col = integer(puo_data.Describe(pstr_fkey.target_key3 + ".ID"))
	if li_col > 0 then
		la_key = puo_data.object.data[ll_row, li_col]
		
		// And put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_fkey.target_key3 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[ll_key_row, li_col] = la_key
	end if
end if

if not isnull(pstr_fkey.target_key4) then
	// Get the value
	li_col = integer(puo_data.Describe(pstr_fkey.target_key4 + ".ID"))
	if li_col > 0 then
		la_key = puo_data.object.data[ll_row, li_col]
		
		// And put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_fkey.target_key4 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[ll_key_row, li_col] = la_key
	end if
end if

if not isnull(pstr_fkey.target_key5) then
	// Get the value
	li_col = integer(puo_data.Describe(pstr_fkey.target_key5 + ".ID"))
	if li_col > 0 then
		la_key = puo_data.object.data[ll_row, li_col]
		
		// And put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_fkey.target_key5 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[ll_key_row, li_col] = la_key
	end if
end if

if not isnull(pstr_fkey.target_key6) then
	// Get the value
	li_col = integer(puo_data.Describe(pstr_fkey.target_key6 + ".ID"))
	if li_col > 0 then
		la_key = puo_data.object.data[ll_row, li_col]
		
		// And put the value in the key datastore
		li_col = integer(puo_key_data.Describe(pstr_fkey.target_key6 + ".ID"))
		if li_col > 0 then puo_key_data.object.data[ll_key_row, li_col] = la_key
	end if
end if

return 1

end function

private function string altkey_where_clause (u_ds_data puo_data, str_message_part pstr_part, long pl_row);string ls_type
string ls_item
string ls_delim
integer li_col
string ls_where_clause
long ll_rows

ls_where_clause = ""

if not isnull(pstr_part.alt_key1) then
	ls_item = puo_data.where_clause_item(pstr_part.alt_key1, pl_row)
	if not isnull(ls_item) then ls_where_clause += " AND " + pstr_part.alt_key1 + " = " + ls_item
else
	setnull(ls_where_clause)
	return ls_where_clause
end if

if not isnull(pstr_part.alt_key2) then
	ls_item = puo_data.where_clause_item(pstr_part.alt_key2, pl_row)
	if not isnull(ls_item) then ls_where_clause += " AND " + pstr_part.alt_key2 + " = " + ls_item
end if

if not isnull(pstr_part.alt_key3) then
	ls_item = puo_data.where_clause_item(pstr_part.alt_key3, pl_row)
	if not isnull(ls_item) then ls_where_clause += " AND " + pstr_part.alt_key3 + " = " + ls_item
end if

if not isnull(pstr_part.alt_key4) then
	ls_item = puo_data.where_clause_item(pstr_part.alt_key4, pl_row)
	if not isnull(ls_item) then ls_where_clause += " AND " + pstr_part.alt_key4 + " = " + ls_item
end if

if not isnull(pstr_part.alt_key5) then
	ls_item = puo_data.where_clause_item(pstr_part.alt_key5, pl_row)
	if not isnull(ls_item) then ls_where_clause += " AND " + pstr_part.alt_key5 + " = " + ls_item
end if

if not isnull(pstr_part.alt_key6) then
	ls_item = puo_data.where_clause_item(pstr_part.alt_key6, pl_row)
	if not isnull(ls_item) then ls_where_clause += " AND " + pstr_part.alt_key6 + " = " + ls_item
end if

if trim(ls_where_clause) = "" then
	setnull(ls_where_clause)
	return ls_where_clause
end if

ls_where_clause = replace(ls_where_clause, 1, 4, "WHERE")

return ls_where_clause

end function

public function integer check_record_unique (u_ds_data puo_data, str_message_part pstr_part, integer pi_row);string ls_where_clause
string ls_query
u_ds_data luo_exists
long ll_rows

ls_where_clause = altkey_where_clause(puo_data, pstr_part, pi_row)
if isnull(ls_where_clause) then return 0

ls_query = "SELECT * FROM " + pstr_part.part_table + " " + ls_where_clause

luo_exists = CREATE u_ds_data
luo_exists.set_database(cprdb)
ll_rows = luo_exists.load_query(ls_query)

DESTROY luo_exists

return ll_rows

end function

private function integer do_special_part (str_message_part pstr_part);integer li_sts

CHOOSE CASE pstr_part.part_table
	CASE "Attachment_Files"
		li_sts = save_attachment_files()
		if li_sts < 0 then
			mylog.log(this, "u_component_message_handler.do_special_part.0007", "Error getting attachment files", 4)
			return -1
		end if
		
END CHOOSE

return 1


return 1

end function

public function integer save_attachment_files ();integer li_sts
long ll_rows
long ll_msg_attachment_file_key
string ls_cpr_id
string ls_object_file
string ls_object_type
blob lblb_file
long i
string ls_connectstring
u_ds_data luo_data
u_attachment_file_holder luo_file
u_sqlca luo_message

luo_file = CREATE u_attachment_file_holder

luo_file.initialize(mylog)

luo_data = CREATE u_ds_data
luo_data.set_database(mydb)

ll_rows = luo_data.load_query("select cpr_id, object_file, object_type, msg_attachment_file_key from attachment_files")

if ll_rows < 0 then return -1

/////////////////////////////////////////////////////////////////////////////////////
// Don't ask me why, but it seems that if we do a SELECTBLOB from mydb it always
// asks for a new DSN.  This is bad.  It also seems that if we create another connection
// to the message file then SELECTBLOB works.  Oh well.
luo_message = CREATE u_sqlca

ls_connectstring = "DRIVER={Microsoft Access Driver (*.mdb)}"
ls_connectstring += ";DBQ=" + message_file
luo_message.dbms = "odbc"
luo_message.database = message_file
luo_message.logid = "sa"
luo_message.logpass = ""
luo_message.dbparm = "Connectstring='" + ls_connectstring + "'"

CONNECT USING luo_message; 

if luo_message.SQLCode = 0 then
luo_message.connected = true
else
	mylog.log(this, "u_component_message_handler.save_attachment_files.0044", "Error connecting to message database (" + luo_message.sqlerrtext + ")", 4)
	return -1
end if
////////////////////////////////////////////////////////////////////////////////////////////////

for i = 1 to ll_rows
	ll_msg_attachment_file_key = luo_data.object.msg_attachment_file_key[i]
	ls_cpr_id = luo_data.object.cpr_id[i]
	ls_object_file = luo_data.object.object_file[i]
	ls_object_type = luo_data.object.object_type[i]
	
	SELECTBLOB attachment_file
	INTO :lblb_file
	FROM Attachment_Files
	WHERE msg_attachment_file_key = :ll_msg_attachment_file_key
	USING luo_message;
	if not luo_message.check() then return -1
	if luo_message.sqlcode = 100 then continue

	if isnull(lblb_file) then continue

	luo_file.attachment_file = lblb_file
	li_sts = luo_file.save_file(ls_cpr_id, ls_object_file, ls_object_type)
	if li_sts < 0 then return -1
next

luo_message.dbdisconnect()

DESTROY luo_message
DESTROY luo_file
DESTROY luo_data

return 1

end function

private function string altkey_where_clause (u_ds_data puo_data, string ps_table, long pl_row);string ls_null

setnull(ls_null)

return altkey_where_clause(puo_data, ps_table, pl_row, ls_null)

end function

private function string altkey_where_clause (u_ds_data puo_data, string ps_table, long pl_row, string ps_dbms);string ls_type
string ls_item
string ls_delim
integer li_col
string ls_where_clause
string ls_alt_key1
string ls_alt_key2
string ls_alt_key3
string ls_alt_key4
string ls_alt_key5
string ls_alt_key6
long ll_rows
u_ds_data luo_altkeys

luo_altkeys = CREATE u_ds_data
luo_altkeys.set_database(cprdb)
ll_rows = luo_altkeys.load_query("select * from c_Table_Altkey where cpr_table = '" + ps_table + "'") 
if ll_rows < 0 then
	mylog.log(this, "u_component_message_handler.load_parts.0047", "error getting altkeys", 4)
	setnull(ls_where_clause)
	return ls_where_clause
elseif ll_rows = 0 then
	mylog.log(this, "u_component_message_handler.load_parts.0047", "c_Table_Altkey record not found (" + ps_table + ")", 4)
	setnull(ls_where_clause)
	return ls_where_clause
end if

ls_alt_key1 = luo_altkeys.object.alt_key1[1]
ls_alt_key2 = luo_altkeys.object.alt_key2[1]
ls_alt_key3 = luo_altkeys.object.alt_key3[1]
ls_alt_key4 = luo_altkeys.object.alt_key4[1]
ls_alt_key5 = luo_altkeys.object.alt_key5[1]
ls_alt_key6 = luo_altkeys.object.alt_key6[1]

DESTROY luo_altkeys

ls_where_clause = ""

if not isnull(ls_alt_key1) then
	ls_item = puo_data.where_clause_item(ls_alt_key1, pl_row, ps_dbms)
	if not isnull(ls_item) then ls_where_clause += " AND " + ls_alt_key1 + " = " + ls_item
else
	mylog.log(this, "u_component_message_handler.load_parts.0047", "First alt_key is null", 4)
	setnull(ls_where_clause)
	return ls_where_clause
end if

if not isnull(ls_alt_key2) then
	ls_item = puo_data.where_clause_item(ls_alt_key2, pl_row, ps_dbms)
	if not isnull(ls_item) then ls_where_clause += " AND " + ls_alt_key2 + " = " + ls_item
end if

if not isnull(ls_alt_key3) then
	ls_item = puo_data.where_clause_item(ls_alt_key3, pl_row, ps_dbms)
	if not isnull(ls_item) then ls_where_clause += " AND " + ls_alt_key3 + " = " + ls_item
end if

if not isnull(ls_alt_key4) then
	ls_item = puo_data.where_clause_item(ls_alt_key4, pl_row, ps_dbms)
	if not isnull(ls_item) then ls_where_clause += " AND " + ls_alt_key4 + " = " + ls_item
end if

if not isnull(ls_alt_key5) then
	ls_item = puo_data.where_clause_item(ls_alt_key5, pl_row, ps_dbms)
	if not isnull(ls_item) then ls_where_clause += " AND " + ls_alt_key5 + " = " + ls_item
end if

if not isnull(ls_alt_key6) then
	ls_item = puo_data.where_clause_item(ls_alt_key6, pl_row, ps_dbms)
	if not isnull(ls_item) then ls_where_clause += " AND " + ls_alt_key6 + " = " + ls_item
end if

if trim(ls_where_clause) = "" then
	setnull(ls_where_clause)
	return ls_where_clause
end if

if ps_dbms = "DW" then
	ls_where_clause = replace(ls_where_clause, 1, 5, "")
else
	ls_where_clause = replace(ls_where_clause, 1, 4, "WHERE")
end if

return ls_where_clause

end function

on u_component_message_handler.create
call super::create
end on

on u_component_message_handler.destroy
call super::destroy
end on

