HA$PBExportHeader$u_component_document.sru
forward
global type u_component_document from u_component_observation
end type
end forward

global type u_component_document from u_component_observation
end type
global u_component_document u_component_document

type variables

str_external_observation_attachment document[]
long document_count

string temp_stored_proc
long temp_stored_proc_argument_count

end variables

forward prototypes
public function integer configure_document ()
public function integer xx_configure_document ()
public function string get_test_case ()
protected function string xx_get_test_case ()
public function string xx_get_document_elements ()
public function integer get_document_elements (ref str_document_elements pstr_document_elements)
public function integer document_context_objects_info (ref str_document_context_objects_info pstr_info)
public function integer clear_document_context_objects ()
public function integer set_document_context_objects () throws exception
public function integer create_document () throws exception
public function integer create_temp_stored_proc (string ps_sql)
public function integer drop_temp_stored_proc ()
public function str_complete_context document_context ()
end prototypes

public function integer configure_document ();return xx_configure_document()

end function

public function integer xx_configure_document ();return 0

end function

public function string get_test_case ();return xx_get_test_case()


end function

protected function string xx_get_test_case ();string ls_null

setnull(ls_null)

return ls_null

end function

public function string xx_get_document_elements ();return ""


end function

public function integer get_document_elements (ref str_document_elements pstr_document_elements);string ls_document_element_xml
integer li_sts

ls_document_element_xml = xx_get_document_elements()
if isnull(ls_document_element_xml) then return -1
if trim(ls_document_element_xml) = "" then return 0

li_sts = f_get_document_elements_from_xml(ls_document_element_xml, pstr_document_elements)
if li_sts <= 0 then return -1

return 1


end function

public function integer document_context_objects_info (ref str_document_context_objects_info pstr_info);string ls_sql
integer li_sts
string ls_temp_proc_name

// Get the collection script
pstr_info.selection_script = get_attribute("context_object_selection_script")
if isnull(pstr_info.selection_script) or trim(pstr_info.selection_script) = "" then return 0

pstr_info.selection_script_substituted = f_attribute_value_substitute_string(pstr_info.selection_script, f_get_complete_context(), get_attributes())

get_attribute("include_previously_sent", pstr_info.include_previously_sent)

// Before we can process the script we need to determine the max record count, interfaceserviceid and document_patient_workplan_item_id
get_attribute("document_patient_workplan_item_id", pstr_info.doc_patient_workplan_item_id)
if isnull(pstr_info.doc_patient_workplan_item_id) then
	log.log(this, "set_document_dontext_objects()", "document_patient_workplan_item_id attribute not found", 4)
	return -1
end if

pstr_info.interfaceserviceid = sqlca.fn_document_interfaceserviceid(pstr_info.doc_patient_workplan_item_id)
if not tf_check() then return -1
if isnull(pstr_info.interfaceserviceid) then
	log.log(this, "set_document_dontext_objects()", "Unable to determine interfaceserviceid", 4)
	return -1
end if

// Make sure max_record_count is positive
get_attribute("max_record_count", pstr_info.max_record_count)
if isnull(pstr_info.max_record_count) then
	pstr_info.max_record_count = datalist.get_preference_int("Preferences", "document_default_max_record_count", 10000)
end if
if pstr_info.max_record_count <= 0 then
	pstr_info.max_record_count = 10000
end if

SELECT count(*)
INTO :pstr_info.current_record_count
FROM dbo.c_component_interface_object_log
WHERE interfaceserviceid = :pstr_info.interfaceserviceid
AND document_patient_workplan_item_id = :pstr_info.doc_patient_workplan_item_id;
if not tf_check() then return -1

return 1

end function

public function integer clear_document_context_objects ();string ls_sql
integer li_sts
string ls_temp_proc_name
str_document_context_objects_info lstr_info
long ll_needed_count

li_sts = document_context_objects_info(lstr_info)
if li_sts < 0 then return -1

DELETE dbo.c_component_interface_object_log
WHERE interfaceserviceid = :lstr_info.interfaceserviceid
AND document_patient_workplan_item_id = :lstr_info.doc_patient_workplan_item_id;
if not tf_check() then return -1

return 1



end function

public function integer set_document_context_objects () throws exception;string ls_sql
integer li_sts
string ls_temp_proc_name
str_document_context_objects_info lstr_info
long ll_needed_count
exception le_exception

li_sts = document_context_objects_info(lstr_info)
if li_sts < 0 then
	le_exception = CREATE exception
	le_exception.text = "Error getting document context info"
	THROW le_exception
end if
if li_sts = 0 then
	// This document doesn't use a context_objects script
	return 0
end if

// If we already have enough records then return success
if lstr_info.current_record_count >= lstr_info.max_record_count then
	return 1
end if

if lstr_info.current_record_count >  0 then
	ll_needed_count = lstr_info.max_record_count - lstr_info.current_record_count
else
	ll_needed_count = lstr_info.max_record_count
end if

// if we have a script then we assume it will return 3 columns: cpr_id, context_object, object_key

// First create a temporary stored procedure with the SQL as the body with any substitution tokens taken care of
ls_temp_proc_name = sqlca.temp_proc_name()

ls_sql = "CREATE PROCEDURE " + ls_temp_proc_name + " AS " + lstr_info.selection_script_substituted
li_sts = sqlca.execute_string(ls_sql)
if li_sts < 0 then
	le_exception = CREATE exception
	le_exception.text = "Error creating temporary stored procedure"
	if len(sqlca.sqlerrtext) > 0 then
		le_exception.text += ": " + sqlca.sqlerrtext
	end if
	
	THROW le_exception
end if

// Then build a sql script which captures the results of the stored procedure and saves them in c_component_interface_object_log
ls_sql = ""
ls_sql += "~r~nDECLARE @objects TABLE ("
ls_sql += "~r~n	cpr_id varchar(12) NOT NULL,"
ls_sql += "~r~n	context_object varchar(24) NOT NULL,"
ls_sql += "~r~n	object_key int NOT NULL)"
ls_sql += "~r~n"
ls_sql += "~r~nINSERT INTO @objects"
ls_sql += "~r~nEXECUTE " + ls_temp_proc_name
ls_sql += "~r~n"
ls_sql += "~r~nINSERT INTO dbo.c_component_interface_object_log ("
ls_sql += "~r~n	interfaceserviceid"
ls_sql += "~r~n	,cpr_id"
ls_sql += "~r~n	,context_object"
ls_sql += "~r~n	,object_key"
ls_sql += "~r~n	,document_patient_workplan_item_id)"
ls_sql += "~r~nSELECT TOP(" + string(ll_needed_count) + ") "
ls_sql += "~r~n	" + string(lstr_info.interfaceserviceid)
ls_sql += "~r~n	,cpr_id"
ls_sql += "~r~n	,context_object"
ls_sql += "~r~n	,object_key"
ls_sql += "~r~n	," + string(lstr_info.doc_patient_workplan_item_id)
ls_sql += "~r~nFROM @objects x"
ls_sql += "~r~nWHERE NOT EXISTS ("
ls_sql += "~r~n	SELECT 1"
ls_sql += "~r~n	FROM dbo.c_component_interface_object_log l"
ls_sql += "~r~n	WHERE l.interfaceServiceId = " + string(lstr_info.interfaceServiceId)
if lstr_info.include_previously_sent then
	ls_sql += "~r~n	AND l.document_patient_workplan_item_id = " + string(lstr_info.doc_patient_workplan_item_id)
end if
ls_sql += "~r~n	AND l.cpr_id = x.cpr_id"
ls_sql += "~r~n	AND l.context_object = x.context_object"
ls_sql += "~r~n	AND l.object_key = x.object_key )"
ls_sql += "~r~n"

// Execute the sql script
li_sts = sqlca.execute_string(ls_sql)
if li_sts < 0 then
	le_exception = CREATE exception
	le_exception.text = "Error executing temporary stored procedure"
	if len(sqlca.sqlerrtext) > 0 then
		le_exception.text += ": " + sqlca.sqlerrtext
	end if
	THROW le_exception
end if

// Drop the temp proc
ls_sql = "DROP PROCEDURE " + ls_temp_proc_name
li_sts = sqlca.execute_string(ls_sql)


return 1



end function

public function integer create_document () throws exception;integer li_sts
long i, j
exception le_exception

document_count = 0

li_sts = do_source()
if do_source_status < 0 then
	le_exception = CREATE exception
	le_exception.text = "Error Calling Document Component"
	THROW le_exception
end if

// Now post the attachments
for i = 1 to observation_count
	// Now post the attachments
	for j = 1 to observations[i].attachment_list.attachment_count
		document_count++
		document[document_count] = observations[i].attachment_list.attachments[j]
	next
next

if document_count <= 0 then
	return 0
end if

return 1



end function

public function integer create_temp_stored_proc (string ps_sql);str_property_value lstr_property_value
string ls_temp_proc_name
string ls_sql
integer li_sts
long ll_pos
string ls_objects_magic_table
string ls_document_patient_workplan_item_id
string ls_final_sql
str_complete_context lstr_context
long ll_pos1
long ll_pos2
string ls_temp
string ls_arguments

lstr_context = document_context()

ls_objects_magic_table = "x_document_objects"
ls_document_patient_workplan_item_id = get_attribute("document_patient_workplan_item_id")

// See if the script uses the magic table x_document_objects
if isnull(ls_document_patient_workplan_item_id) then
	ll_pos = pos(lower(ps_sql), lower(ls_objects_magic_table), ll_pos)
	if ll_pos > 0 then
		log.log(this, "f_get_collection_example()", "Script refers to x_document_objects, but no document_patient_workplan_item_id is found", 4)
		return -1
	end if
end if

// First create a temporary stored procedure with the SQL as the body
ls_temp_proc_name = sqlca.temp_proc_name()

// convert reference to fn_interface_objects_to_send  to  fn_interface_objects_to_send_sample
ls_final_sql = f_string_substitute(ps_sql, ls_objects_magic_table, "dbo.fn_interface_objects_to_send(" + ls_document_patient_workplan_item_id + ")")

// Determine arguments
temp_stored_proc_argument_count = 0
ls_arguments = ""
DO WHILE true
	if temp_stored_proc_argument_count >= 8 then exit
	
	temp_stored_proc_argument_count += 1
	
	// Find the argument declaration
	ll_pos1 = pos(lower(ls_final_sql), "-- @argument" + string(temp_stored_proc_argument_count))
	if isnull(ll_pos1) or ll_pos1 <= 0 then
		// No argument declaration so we're done looking for arguments
		temp_stored_proc_argument_count -= 1
		exit
	end if

	// Find the end of the line
	ll_pos2 = pos(ls_final_sql, "~r", ll_pos1)
	if isnull(ll_pos2) or ll_pos2 <= 0 then
		// No end of line after argument so we're done looking for arguments
		temp_stored_proc_argument_count -= 1
		exit
	end if

	// Get the argument string
	ls_temp = trim(mid(ls_final_sql, ll_pos1 + 2, ll_pos2 - ll_pos1 - 2))
	if isnull(ls_temp) or len(ls_temp) <= 0 then
		// No declaration so we're done looking for arguments
		temp_stored_proc_argument_count -= 1
		exit
	end if

	if len(ls_arguments) > 0 then
		ls_arguments += ", "
	end if
	ls_arguments += ls_temp	
LOOP

ls_sql = "CREATE PROCEDURE " + ls_temp_proc_name 
if len(ls_arguments) > 0 then
	ls_sql += " (" + ls_arguments + ") "
end if
ls_sql += " AS " + ls_final_sql

EXECUTE IMMEDIATE :ls_sql;
if not tf_check() then
	return -1
end if

temp_stored_proc = ls_temp_proc_name

return 1


end function

public function integer drop_temp_stored_proc ();string ls_sql

if len(temp_stored_proc) > 0 then
	ls_sql = "DROP PROCEDURE " + temp_stored_proc
	EXECUTE IMMEDIATE :ls_sql;
	if not tf_check() then
		return -1
	end if
else
	return 0
end if

setnull(temp_stored_proc)


return 1


end function

public function str_complete_context document_context ();string ls_document_patient_workplan_item_id
str_complete_context lstr_context
long ll_patient_workplan_item_id
u_component_wp_item_document luo_wp_item_document

ls_document_patient_workplan_item_id = get_attribute("document_patient_workplan_item_id")
if isnumber(ls_document_patient_workplan_item_id) then
	// If we have a document_patient_workplan_item_id then the context of this document by definition is the context of the workplan item
	ll_patient_workplan_item_id = long(ls_document_patient_workplan_item_id)
	luo_wp_item_document = CREATE u_component_wp_item_document
	luo_wp_item_document.initialize(ll_patient_workplan_item_id)
	lstr_context =  luo_wp_item_document.context()
	DESTROY luo_wp_item_document
else
	lstr_context = f_get_complete_context_from_attributes(get_attributes())
end if


return lstr_context

end function

on u_component_document.create
call super::create
end on

on u_component_document.destroy
call super::destroy
end on

