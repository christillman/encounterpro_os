$PBExportHeader$u_ds_data.sru
forward
global type u_ds_data from datastore
end type
end forward

global type u_ds_data from datastore
end type
global u_ds_data u_ds_data

type variables
u_sqlca mydb
boolean retain_rows = false

end variables

forward prototypes
public subroutine set_dataobject (string ps_dataobject)
public subroutine set_dataobject (string ps_dataobject, u_sqlca puo_sqlca)
public function integer save_query_to_file (string ps_query, string ps_file)
public function integer save_table_to_file (string ps_table, string ps_file)
public function integer save_to_file (string ps_file)
public function integer save_table_to_file (string ps_table, string ps_where_clause, string ps_file)
public subroutine set_database (u_sqlca puo_sqlca)
public function integer save_to_file (string ps_file, boolean pb_include_column_names)
public function integer save_table_to_table (u_sqlca puo_from_db, u_sqlca puo_to_db, string ps_table, string ps_where_clause)
public function integer save_query_to_table (u_sqlca puo_from_db, u_sqlca puo_to_db, string ps_query, string ps_table)
public function integer save_syntax_to_file (string ps_syntax, string ps_file)
public function integer save_syntax_to_table (u_sqlca puo_from_db, u_sqlca puo_to_db, string ps_syntax, string ps_table)
public function integer load_from_file (string ps_query, string ps_file)
public function integer save_to_table (string ps_table, boolean pb_exists)
public function integer generate_new_keys (string ps_table)
public function integer replace_table (string ps_table)
public function string gen_unique_key (string ps_table, string ps_field, string ps_description)
public function integer delete_record (string ps_table, long pl_row)
public function string where_clause_item (string ps_field, long pl_row)
public function integer generate_new_key (string ps_table, long pl_row)
public function string where_clause_item (string ps_field, long pl_row, u_sqlca puo_target_db)
public function string where_clause_item (string ps_field, long pl_row, string ps_dbms)
public function integer save_to_table (string ps_table, long pl_row)
public function integer load_table_from_file (string ps_table, string ps_file, boolean pb_delete_first)
public function integer load_table_from_file (string ps_table, string ps_file)
public function string where_clause_clause (string ps_dw_field, long pl_row, string ps_dbms, string ps_db_field)
public function string get_attribute (string ps_attribute)
public function boolean is_column (string ps_column)
public function integer column_id (string ps_column)
public function string get_field_value (long pl_row, string ps_field_name)
public function string get_field_display (long pl_row, string ps_field_name)
public function string get_field_display (long pl_row, string ps_context_object, string ps_field_name)
public function string get_field_value (long pl_row, integer pi_column_id)
public function str_grid get_grid ()
public function str_attributes get_attributes_from_row (long pl_row)
public function str_property_value get_property (string ps_property, long pl_row)
public function integer create_from_query (string ps_query)
public function long load_query (string ps_query, boolean pb_retain_rows)
public function long load_query (string ps_query)
public function long load_query (string ps_query, ref pbdom_document po_xml_document, string ps_root_element_name, string ps_row_element_name)
end prototypes

public subroutine set_dataobject (string ps_dataobject);set_dataobject(ps_dataobject, sqlca)

end subroutine

public subroutine set_dataobject (string ps_dataobject, u_sqlca puo_sqlca);dataobject = ps_dataobject
mydb = puo_sqlca

settransobject(mydb)


end subroutine

public function integer save_query_to_file (string ps_query, string ps_file);string ls_error_syntaxfromSQL, ls_error_create
string ls_new_syntax
string ls_sts
integer li_sts
integer i
string ls_column_count
integer li_column_count
string ls_sql
string ls_column_list


// First generate a datastore syntax from the query
sqlca.begin_transaction(this, "save_query_to_file()")
ls_new_syntax = sqlca.SyntaxFromSQL(ps_query, "", ls_error_syntaxfromSQL)
sqlca.commit_transaction()

if Len(ls_error_syntaxfromSQL) > 0 THEN
	log.log(this, "u_ds_data.save_query_to_file:0018", "Error getting query syntax (" + ls_error_syntaxfromSQL + ")", 4)
	return -1
end if

// Create the datastore
Create(ls_new_syntax, ls_error_create)
if Len(ls_error_create) > 0 THEN
	log.log(this, "u_ds_data.save_query_to_file:0025", "Error creating datastore (" + ls_error_create + ")", 4)
	return -1
end if

// Retrieve the data
li_sts = settransobject(mydb)
ls_sql = getsqlselect()
li_sts = retrieve()
if li_sts < 0 then
	log.log(this, "u_ds_data.save_query_to_file:0034", "Error executing query (" + ps_query + ")", 4)
	return li_sts
end if

// Finally, save the data to the text file
li_sts = saveas(ps_file, text!, false)
if li_sts > 0 then
	log.log(this, "u_ds_data.save_query_to_file:0041", "Query data saved to file (" + ps_query + ", " + ps_file + ")", 1)
else
	log.log(this, "u_ds_data.save_query_to_file:0043", "Error saving query to file (" + ps_query + ", " + ps_file + ")", 4)
end if

return li_sts


end function

public function integer save_table_to_file (string ps_table, string ps_file);return save_table_to_file(ps_table, "", ps_file)

end function

public function integer save_to_file (string ps_file);return save_to_file(ps_file, false)

end function

public function integer save_table_to_file (string ps_table, string ps_where_clause, string ps_file);string ls_error_syntaxfromSQL, ls_error_create
string ls_new_syntax
string ls_sts
integer li_sts
integer i
string ls_column_count
integer li_column_count
string ls_sql
string ls_column_list
string ls_query

if isnull(ps_where_clause) then ps_where_clause = ""

// First generate a wildcard query to get the column names
ls_query = "SELECT * from " + ps_table
sqlca.begin_transaction(this, "save_table_to_file()")
ls_new_syntax = sqlca.SyntaxFromSQL(ls_query, "", ls_error_syntaxfromSQL)
sqlca.commit_transaction()

if Len(ls_error_syntaxfromSQL) > 0 THEN
	log.log(this, "u_ds_data.save_table_to_file:0021", "Error getting query syntax (" + ls_error_syntaxfromSQL + ")", 4)
	return -1
else
	// Create the datastore with the wildcard
	Create(ls_new_syntax, ls_error_create)
	if Len(ls_error_create) > 0 THEN
		log.log(this, "u_ds_data.save_table_to_file:0027", "Error creating datastore (" + ls_error_create + ")", 4)
		return -1
	end if
	
	// Now build a new query from the columns in the table
	ls_column_count = Object.DataWindow.Column.Count
	li_column_count = integer(ls_column_count)
	if li_column_count <= 0 then return 0
	for i = 1 to li_column_count
		if i > 1 then ls_column_list += ", "
		ls_column_list += describe("#" + string(i) + ".name")
	next
	
	// Now build a new query with the column names and the where-clause
	ls_query = "SELECT " + ls_column_list + " from " + ps_table + " " + ps_where_clause

	// Now rerun syntaxfromsql with the new query
	ls_new_syntax = sqlca.SyntaxFromSQL(ls_query, "", ls_error_syntaxfromSQL)
	if Len(ls_error_syntaxfromSQL) > 0 THEN
		log.log(this, "u_ds_data.save_table_to_file:0046", "Error getting new query syntax (" + ls_error_syntaxfromSQL + ")", 4)
		return -1
	else
		// Now recreate then datastore and retrieve the data
		Create(ls_new_syntax, ls_error_create)
		if Len(ls_error_create) > 0 THEN
			log.log(this, "u_ds_data.save_table_to_file:0052", "Error creating new datastore (" + ls_error_create + ")", 4)
			return -1
		end if
		li_sts = settransobject(mydb)
		ls_sql = getsqlselect()
		li_sts = retrieve()
		if li_sts < 0 then
			log.log(this, "u_ds_data.save_table_to_file:0059", "Error executing query (" + ls_query + ")", 4)
			return li_sts
		end if

		// Finally, save the data to the text file
		li_sts = saveas(ps_file, text!, false)
		if li_sts > 0 then
			log.log(this, "u_ds_data.save_table_to_file:0066", "Table data saved to file (" + ps_table + ", " + ps_file + ")", 1)
		else
			log.log(this, "u_ds_data.save_table_to_file:0068", "Error saving table to file (" + ps_table + ", " + ps_file + ")", 4)
		end if
	end if
end if

return li_sts


end function

public subroutine set_database (u_sqlca puo_sqlca);mydb = puo_sqlca

settransobject(mydb)


end subroutine

public function integer save_to_file (string ps_file, boolean pb_include_column_names);integer li_sts

li_sts = saveas(ps_file, text!, pb_include_column_names)
if li_sts <= 0 then
	log.log(this, "u_ds_data.save_to_file:0005", "Error saving to file (" + ps_file + ")", 4)
end if

return li_sts


end function

public function integer save_table_to_table (u_sqlca puo_from_db, u_sqlca puo_to_db, string ps_table, string ps_where_clause);string ls_error_syntaxfromSQL, ls_error_create
string ls_new_syntax
string ls_sts
integer li_sts
integer i
string ls_column_count
string ls_sql
string ls_column_list
string ls_query
integer li_column_count
long ll_rows

if isnull(ps_where_clause) then ps_where_clause = ""

set_database(puo_from_db)

// First generate a wildcard query to get the column names
ls_query = "SELECT * from " + ps_table
sqlca.begin_transaction(this, "save_table_to_table()")
ls_new_syntax = sqlca.SyntaxFromSQL(ls_query, "", ls_error_syntaxfromSQL)
sqlca.commit_transaction()

if Len(ls_error_syntaxfromSQL) > 0 THEN
	log.log(this, "u_ds_data.save_table_to_table:0024", "Error getting query syntax (" + ls_error_syntaxfromSQL + ")", 4)
	return -1
else
	// Create the datastore with the wildcard
	Create(ls_new_syntax, ls_error_create)
	if Len(ls_error_create) > 0 THEN
		log.log(this, "u_ds_data.save_table_to_table:0030", "Error creating datastore (" + ls_error_create + ")", 4)
		return -1
	end if
	
	// Now build a new query from the columns in the table
	ls_column_count = Object.DataWindow.Column.Count
	li_column_count = integer(ls_column_count)
	if li_column_count <= 0 then return 0
	for i = 1 to li_column_count
		if i > 1 then ls_column_list += ", "
		ls_column_list += describe("#" + string(i) + ".name")
	next
	
	// Now build a new query with the column names and the where-clause
	ls_query = "SELECT " + ls_column_list + " from " + ps_table + " " + ps_where_clause

	// Now rerun syntaxfromsql with the new query
	ls_new_syntax = sqlca.SyntaxFromSQL(ls_query, "", ls_error_syntaxfromSQL)
	if Len(ls_error_syntaxfromSQL) > 0 THEN
		log.log(this, "u_ds_data.save_table_to_table:0049", "Error getting new query syntax (" + ls_error_syntaxfromSQL + ")", 4)
		return -1
	else
		// Now recreate then datastore and retrieve the data
		Create(ls_new_syntax, ls_error_create)
		if Len(ls_error_create) > 0 THEN
			log.log(this, "u_ds_data.save_table_to_table:0055", "Error creating new datastore (" + ls_error_create + ")", 4)
			return -1
		end if
		li_sts = settransobject(mydb)
		ls_sql = getsqlselect()
		ll_rows = retrieve()
		if ll_rows < 0 then
			log.log(this, "u_ds_data.save_table_to_table:0062", "Error executing query (" + ls_query + ")", 4)
			return li_sts
		end if

		Object.DataWindow.Table.UpdateTable = ps_table
		li_column_count = integer(Object.DataWindow.Column.Count)
		for i = 1 to li_column_count
			ls_sts = modify("#" + string(i) + ".identity=No")
			ls_sts = modify("#" + string(i) + ".update=Yes")
		next

		set_database(puo_to_db)
		
		for i = 1 to rowcount()
			setitemstatus(i, 0, PRIMARY!, NewModified!)
		next
		
		li_sts = update()
		if li_sts < 0 then
			log.log(this, "u_ds_data.save_table_to_table:0081", "Error saving table", 4)
			return -1
		end if
	end if
end if

return li_sts


end function

public function integer save_query_to_table (u_sqlca puo_from_db, u_sqlca puo_to_db, string ps_query, string ps_table);string ls_error_syntaxfromSQL, ls_error_create
string ls_new_syntax
string ls_sts
integer li_sts
integer i
string ls_column_count
integer li_column_count
string ls_sql
string ls_column_list

set_database(puo_from_db)

// First generate a datastore syntax from the query
sqlca.begin_transaction(this, "save_query_to_table()")
ls_new_syntax = sqlca.SyntaxFromSQL(ps_query, "", ls_error_syntaxfromSQL)
sqlca.commit_transaction()

if Len(ls_error_syntaxfromSQL) > 0 THEN
	log.log(this, "u_ds_data.save_query_to_table:0019", "Error getting query syntax (" + ls_error_syntaxfromSQL + ")", 4)
	return -1
end if

// Create the datastore
Create(ls_new_syntax, ls_error_create)
if Len(ls_error_create) > 0 THEN
	log.log(this, "u_ds_data.save_query_to_table:0026", "Error creating datastore (" + ls_error_create + ")", 4)
	return -1
end if

// Retrieve the data
li_sts = settransobject(mydb)
ls_sql = getsqlselect()
li_sts = retrieve()
if li_sts < 0 then
	log.log(this, "u_ds_data.save_query_to_table:0035", "Error executing query (" + ps_query + ")", 4)
	return li_sts
end if

// Finally, save the data
Object.DataWindow.Table.UpdateTable = ps_table
li_column_count = integer(Object.DataWindow.Column.Count)
for i = 1 to li_column_count
	ls_sts = modify("#" + string(i) + ".identity=No")
	ls_sts = modify("#" + string(i) + ".update=Yes")
next

set_database(puo_to_db)

for i = 1 to rowcount()
	setitemstatus(i, 0, PRIMARY!, NewModified!)
next

li_sts = update()
if li_sts < 0 then
	log.log(this, "u_ds_data.save_query_to_table:0055", "Error saving query to table", 4)
end if

return li_sts


end function

public function integer save_syntax_to_file (string ps_syntax, string ps_file);string ls_error_syntaxfromSQL, ls_error_create
string ls_sts
integer li_sts
integer i
string ls_column_count
integer li_column_count
string ls_sql
string ls_column_list


// Create the datastore
Create(ps_syntax, ls_error_create)
if Len(ls_error_create) > 0 THEN
	log.log(this, "u_ds_data.save_syntax_to_file:0014", "Error creating datastore (" + ls_error_create + ")", 4)
	return -1
end if

// Retrieve the data
li_sts = settransobject(mydb)
ls_sql = getsqlselect()
li_sts = retrieve()
if li_sts < 0 then
	log.log(this, "u_ds_data.save_syntax_to_file:0023", "Error executing query (" + ls_sql + ")", 4)
	return li_sts
end if

// Finally, save the data to the text file
li_sts = saveas(ps_file, text!, false)
if li_sts > 0 then
	log.log(this, "u_ds_data.save_syntax_to_file:0030", "Query data saved to file (" + ls_sql + ", " + ps_file + ")", 1)
else
	log.log(this, "u_ds_data.save_syntax_to_file:0032", "Error saving query to file (" + ls_sql + ", " + ps_file + ")", 4)
end if

return li_sts


end function

public function integer save_syntax_to_table (u_sqlca puo_from_db, u_sqlca puo_to_db, string ps_syntax, string ps_table);string ls_error_syntaxfromSQL, ls_error_create
string ls_sts
integer li_sts
integer i
string ls_column_count
integer li_column_count
string ls_sql
string ls_column_list

set_database(puo_from_db)

// Create the datastore
Create(ps_syntax, ls_error_create)
if Len(ls_error_create) > 0 THEN
	log.log(this, "u_ds_data.save_syntax_to_table:0015", "Error creating datastore (" + ls_error_create + ")", 4)
	return -1
end if

// Retrieve the data
li_sts = settransobject(mydb)
ls_sql = getsqlselect()
li_sts = retrieve()
if li_sts < 0 then
	log.log(this, "u_ds_data.save_syntax_to_table:0024", "Error executing query (" + ls_sql + ")", 4)
	return li_sts
end if

// Finally, save the data
Object.DataWindow.Table.UpdateTable = ps_table
li_column_count = integer(Object.DataWindow.Column.Count)
for i = 1 to li_column_count
	ls_sts = modify("#" + string(i) + ".identity=No")
	ls_sts = modify("#" + string(i) + ".update=Yes")
next

set_database(puo_to_db)

for i = 1 to rowcount()
	setitemstatus(i, 0, PRIMARY!, NewModified!)
next

li_sts = update()
if li_sts <= 0 then
	log.log(this, "u_ds_data.save_syntax_to_table:0044", "Error saving query to table (" + ls_sql + ", " + ps_table + ")", 4)
end if

return li_sts


end function

public function integer load_from_file (string ps_query, string ps_file);string ls_error_create
integer li_sts
integer i
integer li_column_count
long ll_rows

// Now Create then datastore
Create(ps_query, ls_error_create)
if Len(ls_error_create) > 0 THEN
	log.log(this, "u_ds_data.load_from_file:0010", "Error creating new datastore (" + ls_error_create + ")", 4)
	return -1
end if

// Load the data
ll_rows = importfile(ps_file)

return ll_rows


end function

public function integer save_to_table (string ps_table, boolean pb_exists);integer j
string ls_temp
string ls_sts
integer li_sts
string ls_delete
integer i
integer li_column_count
string ls_query
string ls_new_syntax
string ls_error_syntaxfromSQL, ls_error_create
string ls_column_count
string ls_name
string ls_name2
long ll_rowcount
datastore luo_tabledef

luo_tabledef = CREATE datastore
luo_tabledef.settransobject(mydb)

// First generate a wildcard query to get the column names
ls_query = "SELECT * from "

// Don't ask me why, but without this, we don't get an updateable syntax
if upper(left(sqlca.dbms, 3)) = "MSS" then ls_query += "dbo."

ls_query += ps_table

// First get a datastore syntax from the query
li_sts = sqlca.get_dw_syntax(ls_query, ls_new_syntax)
if li_sts <= 0 then
	log.log(this, "u_ds_data.save_to_table:0031", "Error getting query syntax (" + ls_error_syntaxfromSQL + ")", 4)
	return -1
end if

// Create the datastore with the wildcard
luo_tabledef.Create(ls_new_syntax, ls_error_create)
if Len(ls_error_create) > 0 THEN
	log.log(this, "u_ds_data.save_to_table:0038", "Error creating datastore (" + ls_error_create + ")", 4)
	return -1
end if
Object.DataWindow.Table.UpdateKeyInPlace = "Yes"
Object.DataWindow.Table.UpdateTable = ps_table
Object.DataWindow.Table.UpdateWhere = 0
li_column_count = integer(Object.DataWindow.Column.Count)
for i = 1 to li_column_count
	ls_name = describe("#" + string(i) + ".name")
	ls_name2 = luo_tabledef.describe(ls_name + ".name")
	if upper(ls_name) = upper(ls_name2) then
		// Found field in table def
		ls_temp = luo_tabledef.describe(ls_name + ".key")
		ls_sts = modify("#" + string(i) + ".key=" + ls_temp)
		ls_temp = luo_tabledef.describe(ls_name + ".identity")
		ls_sts = modify("#" + string(i) + ".identity=" + ls_temp)
		ls_temp = luo_tabledef.describe(ls_name + ".update")
		ls_sts = modify("#" + string(i) + ".update=" + ls_temp)
	else
		// Didn't find field in tabledef
		ls_sts = modify("#" + string(i) + ".identity=No")
		ls_sts = modify("#" + string(i) + ".update=No")
		ls_sts = modify("#" + string(i) + ".key=No")
	end if
next

DESTROY luo_tabledef

// Now fix the record and field status' to perform the desired SQL operation
resetupdate()

ll_rowcount = rowcount()

for i = 1 to ll_rowcount
	for j = 1 to li_column_count
		ls_temp = describe("#" + string(j) + ".key")
		if upper(ls_temp) = "YES" and pb_exists then
			setitemstatus(i, j, PRIMARY!, NotModified!)
		else
			setitemstatus(i, j, PRIMARY!, DataModified!)
		end if
	next
	
	if pb_exists then
		setitemstatus(i, 0, PRIMARY!, DataModified!)
	else
		setitemstatus(i, 0, PRIMARY!, NewModified!)
	end if
next

li_sts = update()
if li_sts <= 0 then
	log.log(this, "u_ds_data.save_to_table:0090", "Error saving data to table", 4)
	return -1
end if


return li_sts


end function

public function integer generate_new_keys (string ps_table);long ll_rows
integer li_sts
long i

ll_rows = rowcount()

for i = 1 to ll_rows
	li_sts = generate_new_key(ps_table, i)
	if li_sts < 0 then return -1
next

return 1

end function

public function integer replace_table (string ps_table);string ls_query
integer li_sts

ls_query = "DELETE FROM " + ps_table
li_sts = sqlca.execute_string(ls_query)
if li_sts < 0 then return -1

return save_to_table(ps_table, false)



end function

public function string gen_unique_key (string ps_table, string ps_field, string ps_description);string ls_newkey
integer li_sts
integer li_len
integer li_column_count
string ls_count
string ls_temp
string ls_temp2
string ls_query
integer i
u_ds_data luo_data

luo_data = CREATE u_ds_data
luo_data.set_database(mydb)

ls_query = "SELECT * FROM " + ps_table + " WHERE 1 = 2"
li_sts = luo_data.load_query(ls_query)
if li_sts < 0 then
	setnull(ls_newkey)
	return ls_newkey
end if

ls_temp = luo_data.describe(ps_field + ".ColType")
f_split_string(ls_temp, "(", ls_temp2, ls_temp)
if ls_temp = "" then
	setnull(ls_newkey)
	return ls_newkey
end if
f_split_string(ls_temp, ")", ls_temp, ls_temp2)
if ls_temp = "" then
	setnull(ls_newkey)
	return ls_newkey
end if
li_len = integer(ls_temp)

ls_newkey = f_gen_key_string(ps_description, li_len)

ls_query = "SELECT " + ps_field + " FROM " + ps_table + " WHERE " + ps_field + " = '" + ls_newkey + "'"
li_sts = luo_data.load_query(ls_query)
if li_sts < 0 then
	setnull(ls_newkey)
	return ls_newkey
end if

i = 1

// If the key exists, then loop using numbers at the end until we find a unique key
DO WHILE li_sts > 0
	ls_count = string(i)
	ls_newkey = left(ls_newkey, len(ls_newkey) - len(ls_count)) + ls_count
	ls_query = "SELECT " + ps_field + " FROM " + ps_table + " WHERE " + ps_field + " = '" + ls_newkey + "'"
	li_sts = luo_data.load_query(ls_query)
	if li_sts < 0 then
		setnull(ls_newkey)
		DESTROY luo_data
		return ls_newkey
	end if

	i += 1
	if i = 1000 then
		setnull(ls_newkey)
		DESTROY luo_data
		return ls_newkey
	end if
LOOP

DESTROY luo_data

return ls_newkey
end function

public function integer delete_record (string ps_table, long pl_row);integer j
string ls_temp
string ls_sts
integer li_sts
string ls_delete
integer i
integer li_column_count
string ls_query
string ls_new_syntax
string ls_error_syntaxfromSQL, ls_error_create
string ls_column_count
string ls_name
string ls_name2
string ls_type
string ls_item
string ls_delim
string ls_where
integer li_col
datastore luo_tabledef

luo_tabledef = CREATE datastore
luo_tabledef.settransobject(mydb)

// First generate a wildcard query to get the column names
ls_query = "SELECT * from " + ps_table
sqlca.begin_transaction(this, "delete_record()")
ls_new_syntax = sqlca.SyntaxFromSQL(ls_query, "", ls_error_syntaxfromSQL)
sqlca.commit_transaction()

// Now get the 
if Len(ls_error_syntaxfromSQL) > 0 THEN
	log.log(this, "u_ds_data.delete_record:0032", "Error getting query syntax (" + ls_error_syntaxfromSQL + ")", 4)
	return -1
end if

// Create the datastore with the wildcard
luo_tabledef.Create(ls_new_syntax, ls_error_create)
if Len(ls_error_create) > 0 THEN
	log.log(this, "u_ds_data.delete_record:0039", "Error creating datastore (" + ls_error_create + ")", 4)
	return -1
end if

ls_where = ""

Object.DataWindow.Table.UpdateTable = ps_table
li_column_count = integer(Object.DataWindow.Column.Count)
for i = 1 to li_column_count
	ls_name = describe("#" + string(i) + ".name")
	ls_name2 = luo_tabledef.describe(ls_name + ".name")
	if upper(ls_name) = upper(ls_name2) then
		// Found field in table def
		ls_temp = luo_tabledef.describe(ls_name + ".key")
		if upper(left(ls_temp, 1)) = "Y" then
			ls_where += "  AND " + ls_name + " = " + where_clause_item(ls_name, pl_row)
		end if
	end if
next

if not isnull(ls_where) and trim(ls_where) <> "" then
	ls_where = replace(ls_where, 1, 5, "WHERE")
	
	DESTROY luo_tabledef
	
	ls_query = "DELETE FROM " + ps_table + " " + ls_where
	li_sts = sqlca.execute_string(ls_query)
	if li_sts < 0 then return -1
	if li_sts = 0 then
		log.log(this, "u_ds_data.delete_record:0068", "No record found (" + ls_query + ")", 3)
	end if
end if

deleterow(pl_row)

return 1


end function

public function string where_clause_item (string ps_field, long pl_row);u_sqlca luo_sqlca

setnull(luo_sqlca)

return where_clause_item(ps_field, pl_row, luo_sqlca)





end function

public function integer generate_new_key (string ps_table, long pl_row);long ll_rows
string ls_result_type
//integer i
integer li_sts
string ls_cpr_id
string ls_key_id
string ls_description
string ls_newkey
long ll_key_value
integer li_diagnosis_sequence
long ll_problem_id
long ll_attachment_id
long ll_object_sequence
integer li_attachment_sequence
long ll_encounter_id
string ls_stage_id
string ls_item_type
string ls_observation_id
integer li_item_sequence

// DECLARE lsp_get_next_key PROCEDURE FOR dbo.sp_get_next_key  
//         @ps_cpr_id = :ls_cpr_id,   
//         @ps_key_id = :ls_key_id,   
//         @pl_key_value = :ll_key_value OUT
// USING mydb;


CHOOSE CASE lower(ps_table)
	CASE "c_assessment_definition"
		ls_description = object.description[pl_row]
		ls_newkey = gen_unique_key(ps_table, "assessment_id", ls_description)
		if isnull(ls_newkey) then
			log.log(this, "u_ds_data.generate_new_key:0033", "Error generating new key (" + ps_table + ")", 4)
			return -1
		end if
		object.assessment_id[pl_row] = ls_newkey
		object.status[pl_row] = "NA"
//	CASE "c_development_item"
		// table doesn't exist in Epro_OS
//		ls_stage_id = object.stage_id[pl_row]
//		ls_item_type = object.item_type[pl_row]
//		SELECT max(item_sequence)
//		INTO :li_item_sequence
//		FROM c_Development_Item
//		WHERE stage_id = :ls_stage_id
//		AND item_type = :ls_item_type
//		USING mydb;
//		if not sqlca.check() then return -1
//
//		if isnull(li_item_sequence) then li_item_sequence = 0
//		object.item_sequence[pl_row] = li_item_sequence + pl_row
//	CASE "c_development_stage"
//		ls_description = object.description[pl_row]
//		ls_newkey = gen_unique_key(ps_table, "stage_id", ls_description)
//		if isnull(ls_newkey) then
//			log.log(this, "u_ds_data.generate_new_key:0055", "Error generating new key (" + ps_table + ")", 4)
//			return -1
//		end if
//		object.stage_id[pl_row] = ls_newkey
	CASE "c_drug_definition"
		ls_description = object.common_name[pl_row]
		ls_newkey = gen_unique_key(ps_table, "drug_id", ls_description)
		if isnull(ls_newkey) then
			log.log(this, "u_ds_data.generate_new_key:0063", "Error generating new key (" + ps_table + ")", 4)
			return -1
		end if
		object.drug_id[pl_row] = ls_newkey
		object.status[pl_row] = "NA"
	CASE "c_drug_maker"
		ls_description = object.maker_name[pl_row]
		ls_newkey = gen_unique_key(ps_table, "maker_id", ls_description)
		if isnull(ls_newkey) then
			log.log(this, "u_ds_data.generate_new_key:0072", "Error generating new key (" + ps_table + ")", 4)
			return -1
		end if
		object.maker_id[pl_row] = ls_newkey
//	CASE "c_history_questionnaire"
		// table doesn't exist in Epro_OS
//		SELECT max(history_questionnaire_id)
//		INTO :li_item_sequence
//		FROM c_History_Questionnaire
//		USING mydb;
//		if not sqlca.check() then return -1
//
//		if isnull(li_item_sequence) then li_item_sequence = 0
//		object.history_questionnaire_id[pl_row] = li_item_sequence + pl_row
	CASE "c_location"
		ls_description = object.description[pl_row]
		ls_newkey = gen_unique_key(ps_table, "location", ls_description)
		if isnull(ls_newkey) then
			log.log(this, "u_ds_data.generate_new_key:0089", "Error generating new key (" + ps_table + ")", 4)
			return -1
		end if
		object.location[pl_row] = ls_newkey
		object.status[pl_row] = "NA"
	CASE "c_observation"
		ls_description = object.description[pl_row]
		ls_newkey = gen_unique_key(ps_table, "observation_id", ls_description)
		if isnull(ls_newkey) then
			log.log(this, "u_ds_data.generate_new_key:0098", "Error generating new key (" + ps_table + ")", 4)
			return -1
		end if
		object.observation_id[pl_row] = ls_newkey
		object.status[pl_row] = "NA"
	CASE "c_observation_category"
		ls_description = object.description[pl_row]
		ls_newkey = gen_unique_key(ps_table, "observation_category_id", ls_description)
		if isnull(ls_newkey) then
			log.log(this, "u_ds_data.generate_new_key:0107", "Error generating new key (" + ps_table + ")", 4)
			return -1
		end if
		object.observation_category_id[pl_row] = ls_newkey
	CASE "c_observation_result"
		ls_observation_id = object.observation_id[pl_row]
		ls_result_type = object.result_type[pl_row]
		SELECT max(result_sequence)
		INTO :li_item_sequence
		FROM c_Observation_Result
		WHERE observation_id = :ls_observation_id
		AND result_type = :ls_result_type
		USING mydb;
		if not sqlca.check() then return -1

		if isnull(li_item_sequence) then li_item_sequence = 0
		object.result_sequence[pl_row] = li_item_sequence + pl_row
	CASE "c_package"
		ls_description = object.description[pl_row]
		ls_newkey = gen_unique_key(ps_table, "package_id", ls_description)
		if isnull(ls_newkey) then
			log.log(this, "u_ds_data.generate_new_key:0128", "Error generating new key (" + ps_table + ")", 4)
			return -1
		end if
		object.package_id[pl_row] = ls_newkey
	CASE "c_procedure"
		ls_description = object.description[pl_row]
		ls_newkey = gen_unique_key(ps_table, "procedure_id", ls_description)
		if isnull(ls_newkey) then
			log.log(this, "u_ds_data.generate_new_key:0136", "Error generating new key (" + ps_table + ")", 4)
			return -1
		end if

		object.procedure_id[pl_row] = ls_newkey
		object.status[pl_row] = "NA"
	CASE "c_specialty"
		ls_description = object.description[pl_row]
		ls_newkey = gen_unique_key(ps_table, "specialty_id", ls_description)
		if isnull(ls_newkey) then
			log.log(this, "u_ds_data.generate_new_key:0146", "Error generating new key (" + ps_table + ")", 4)
			return -1
		end if
		object.specialty_id[pl_row] = ls_newkey
	CASE "c_vaccine"
		ls_description = object.description[pl_row]
		ls_newkey = gen_unique_key(ps_table, "vaccine_id", ls_description)
		if isnull(ls_newkey) then
			log.log(this, "u_ds_data.generate_new_key:0154", "Error generating new key (" + ps_table + ")", 4)
			return -1
		end if
		object.vaccine_id[pl_row] = ls_newkey
		object.status[pl_row] = "NA"
	CASE "p_assessment"
		ls_cpr_id = object.cpr_id[pl_row]
		// First check to see if we have a valid diagnosis sequence
		li_diagnosis_sequence = object.diagnosis_sequence[pl_row]
		
		// If not, then assume this is a new diagnosis and set the diagnosis_sequence to 1
		if isnull(li_diagnosis_sequence) or li_diagnosis_sequence <= 0 then
			li_diagnosis_sequence = 1
			object.diagnosis_sequence[pl_row] = li_diagnosis_sequence
		end if
		
		// If this is a new diagnosis, then generate a new problem_id
		if li_diagnosis_sequence = 1 then
			ls_key_id = "PROBLEM_ID"
			mydb.sp_get_next_key   ( &
         ls_cpr_id,    &
         ls_key_id,    &
         ref ll_key_value) ;
// 	EXECUTE lsp_get_next_key;
			if not sqlca.check() then return -1
//			FETCH lsp_get_next_key INTO :ll_problem_id;
//			if not sqlca.check() then return -1
//			CLOSE lsp_get_next_key;
//			
			object.problem_id[pl_row] = ll_problem_id
		else
			ll_problem_id = object.problem_id[pl_row]

			SELECT max(diagnosis_sequence)
			INTO :li_diagnosis_sequence
			FROM p_Assessment
			WHERE cpr_id = :ls_cpr_id
			AND problem_id = :ll_problem_id
			USING mydb;
			if not sqlca.check() then return -1
			
			if isnull(li_diagnosis_sequence) then
				li_diagnosis_sequence = 1
			else
				li_diagnosis_sequence += 1
			end if
			
			object.diagnosis_sequence[pl_row] = li_diagnosis_sequence
		end if
			
	CASE "p_assessment_progress"
//	CASE "p_attachment_header"
		// table doesn't exist in Epro_OS
//		ls_cpr_id = object.cpr_id[pl_row]
//		ll_attachment_id = object.attachment_id[pl_row]
//
//		SELECT max(attachment_sequence)
//		INTO :li_attachment_sequence
//		FROM p_Attachment_Header
//		WHERE cpr_id = :ls_cpr_id
//		AND attachment_id = :ll_attachment_id
//		USING mydb;
//		if not sqlca.check() then return -1
//		
//		if isnull(li_attachment_sequence) then
//			li_attachment_sequence = 1
//		else
//			li_attachment_sequence += 1
//		end if
//		
//		object.attachment_sequence[pl_row] = li_attachment_sequence
//	CASE "p_attachment_list"
//		ls_cpr_id = object.cpr_id[pl_row]
//		ls_key_id = "ATTACHMENT_ID"
//		mydb.sp_get_next_key   ( &
//         ls_cpr_id,    &
//         ls_key_id,    &
//         ref ll_key_value) ;
//// 	EXECUTE lsp_get_next_key;
//		if not sqlca.check() then return -1
////		FETCH lsp_get_next_key INTO :ll_attachment_id;
////		if not sqlca.check() then return -1
////		CLOSE lsp_get_next_key;
////		
//		object.attachment_id[pl_row] = ll_attachment_id
//	CASE "p_attachment_object"
		// table doesn't exist in Epro_OS
//		ls_cpr_id = object.cpr_id[pl_row]
//		ll_attachment_id = object.attachment_id[pl_row]
//		li_attachment_sequence = object.attachment_sequence[pl_row]
//
//		SELECT max(object_sequence)
//		INTO :ll_object_sequence
//		FROM p_Attachment_Object
//		WHERE cpr_id = :ls_cpr_id
//		AND attachment_id = :ll_attachment_id
//		AND attachment_sequence = :li_attachment_sequence
//		USING mydb;
//		if not sqlca.check() then return -1
//		
//		if isnull(ll_object_sequence) then
//			ll_object_sequence = 1
//		else
//			ll_object_sequence += 1
//		end if
//		
//		object.object_sequence[pl_row] = ll_object_sequence
//	CASE "p_development"
//	CASE "p_development_stage"
//	CASE "p_encounter_log"
	CASE "p_family_history"
	CASE "p_family_illness"
//	CASE "p_history"
//	CASE "p_history_questionnaire"
	CASE "p_letter"
	CASE "p_material_used"
//	CASE "p_objective"
//	CASE "p_objective_result"
	CASE "p_patient"
		ls_cpr_id = object.billing_id[pl_row]
		ls_newkey = gen_unique_key(ps_table, "cpr_id", ls_cpr_id)
		if isnull(ls_newkey) then
			log.log(this, "u_ds_data.generate_new_key:0266", "Error generating new key (" + ps_table + ")", 4)
			return -1
		end if
		object.cpr_id[pl_row] = ls_newkey
	CASE "p_patient_encounter"
		ls_cpr_id = object.cpr_id[pl_row]
		ls_key_id = "ENCOUNTER_ID"
		mydb.sp_get_next_key   ( &
         ls_cpr_id,    &
         ls_key_id,    &
         ref ll_key_value) ;
// 	EXECUTE lsp_get_next_key;
		if not sqlca.check() then return -1
//		FETCH lsp_get_next_key INTO :ll_encounter_id;
//		if not sqlca.check() then return -1
//		CLOSE lsp_get_next_key;
//		
		object.encounter_id[pl_row] = ll_encounter_id
//	CASE "p_patient_insurance"
	CASE "p_treatment_item"
	CASE "p_treatment_progress"
END CHOOSE

return 1

end function

public function string where_clause_item (string ps_field, long pl_row, u_sqlca puo_target_db);string ls_dbms
string ls_null

setnull(ls_null)

if isnull(ps_field) or trim(ps_field) = "" then return ls_null

if isnull(puo_target_db) or not isvalid(puo_target_db) then
	setnull(ls_dbms)
else
	ls_dbms = upper(left(puo_target_db.dbms, 3))
end if

return where_clause_item(ps_field, pl_row, ls_dbms)


end function

public function string where_clause_item (string ps_field, long pl_row, string ps_dbms);integer li_pos
string ls_left
string ls_right
string ls_type
integer li_col
string ls_item
string ls_delim
string ls_null

setnull(ls_null)

if isnull(ps_field) or trim(ps_field) = "" then return ls_null

ls_type = UPPER(left(Describe(ps_field + ".ColType"), 4))
li_col = integer(Describe(ps_field + ".ID"))
if li_col <= 0 then return "!"
if ls_type = "NUMB" then
	ls_item = string(object.data[pl_row, li_col])
	ls_delim = ""
elseif ls_type = "LONG" then
	ls_item = string(object.data[pl_row, li_col])
	ls_delim = ""
elseif ls_type = "CHAR" then
	ls_item = object.data[pl_row, li_col]
	ls_delim = "'"
elseif ls_type = "DATE" then
	ls_item = string(object.data[pl_row, li_col], "[shortdate] [time]")
	if isnull(ls_item) or trim(ls_item) = "" then
		setnull(ls_item)
	else
		CHOOSE CASE upper(left(ps_dbms, 3))
			CASE "ODB"
				ls_delim = "#"
			CASE "MSS"
				ls_delim = "'"
			CASE "DW"
				ls_delim = ""
				f_split_string(ls_item, " ", ls_left, ls_right)
				ls_item = 'datetime(date("' + ls_left + '"), time("' + ls_right + '"))'
			CASE ELSE
				ls_delim = "'"
		END CHOOSE
	end if
else
	ls_item = string(object.data[pl_row, li_col])
	ls_delim = "'"
end if

// Empty strings should be treated as null
if trim(ls_item) = "" then setnull(ls_item)

if not isnull(ls_item) then
	// fix any single quotes by doubling them
	li_pos = 1
	DO
		li_pos = pos(ls_item, "'", li_pos)
		if li_pos > 0 then
			ls_item = replace(ls_item, li_pos, 1, "''")
			li_pos += 2
		end if
	LOOP WHILE li_pos > 0
	
	ls_item = ls_delim + ls_item + ls_delim
end if


return ls_item
end function

public function integer save_to_table (string ps_table, long pl_row);integer j
string ls_temp
string ls_sts
integer li_sts
string ls_delete
integer i
integer li_column_count
string ls_query
string ls_new_syntax
string ls_error_syntaxfromSQL, ls_error_create
string ls_column_count
string ls_name
string ls_name2
integer li_col
integer li_identity_column
string ls_identity_column
any la_value
u_ds_data luo_data

setnull(ls_identity_column)

luo_data = CREATE u_ds_data

// First generate a wildcard query to get the column names
ls_query = "SELECT * from "

// Don't ask me why, but without this, we don't get an updateable syntax
if upper(left(sqlca.dbms, 3)) = "MSS" then ls_query += "dbo."

ls_query += ps_table

// First get a datastore syntax from the query
li_sts = sqlca.get_dw_syntax(ls_query, ls_new_syntax)
if li_sts <= 0 then
	log.log(this, "u_ds_data.save_to_table:0035", "Error getting query syntax (" + sqlca.dbms + ", " + ls_error_syntaxfromSQL + ")", 4)
	return -1
end if

// Create the datastore with the wildcard
luo_data.Create(ls_new_syntax, ls_error_create)
if Len(ls_error_create) > 0 THEN
	log.log(this, "u_ds_data.save_to_table:0042", "Error creating datastore (" + ls_error_create + ")", 4)
	return -1
end if

luo_data.insertrow(0)

luo_data.Object.DataWindow.Table.UpdateKeyInPlace = "Yes"
luo_data.Object.DataWindow.Table.UpdateTable = ps_table
luo_data.Object.DataWindow.Table.UpdateWhere = 0

li_column_count = integer(luo_data.Object.DataWindow.Column.Count)
for i = 1 to li_column_count
	ls_name = luo_data.describe("#" + string(i) + ".name")
	if lower(left(luo_data.describe("#" + string(i) + ".identity"), 1)) = "y" then
		li_identity_column = i
		ls_identity_column = ls_name
	end if
	li_col = integer(describe(ls_name + ".ID"))
	if li_col > 0 then
		la_value = object.data[pl_row, i]
		luo_data.object.data[1, li_col] = la_value
	end if
next

setitemstatus(1, 0, PRIMARY!, NewModified!)

luo_data.set_database(mydb)
li_sts = luo_data.update()
if li_sts <= 0 then
	log.log(this, "u_ds_data.save_to_table:0071", "Error saving data to table", 4)
	return -1
end if

// If we have an identity column then update this object with the new value
if not isnull(ls_identity_column) then
	ls_query = "SELECT max(" + ls_identity_column + ") FROM " + ps_table
	li_sts = luo_data.load_query(ls_query)
	if li_sts <= 0 then
		log.log(this, "u_ds_data.save_to_table:0080", "Error getting identity column value", 4)
		return -1
	end if
	la_value = luo_data.object.data[1, 1]
	object.data[pl_row, li_identity_column] = la_value
end if

DESTROY luo_data

return li_sts


end function

public function integer load_table_from_file (string ps_table, string ps_file, boolean pb_delete_first);string ls_error_syntaxfromSQL, ls_error_create
string ls_new_sql, ls_new_syntax
string ls_sts
string ls_sql
integer li_sts
integer i
integer li_column_count
string ls_column_count
string ls_column_list
integer li_count
boolean lb_identity

SELECT count(*)
INTO :li_count
FROM sysobjects o, syscolumns c
WHERE o.name = :ps_table
AND c.id = o.id
AND c.status - 128 >= 0
USING mydb;
if not sqlca.check() then
	log.log(this, "u_ds_data.load_table_from_file:0021", "Error getting count " + ps_table,  4)
	return -1
end if

if li_count > 0 then
	lb_identity = true
else
	lb_identity = false
end if

ls_new_sql = "SELECT * from " + ps_table
// Don't ask me why! The next syntaxfromsql won't work without this!
sqlca.begin_transaction(this, "load_table_from_file()")
ls_new_syntax = sqlca.SyntaxFromSQL(ls_new_sql, "", ls_error_syntaxfromSQL)
sqlca.commit_transaction()

if Len(ls_error_syntaxfromSQL) > 0 THEN
	log.log(this, "u_ds_data.load_table_from_file:0038", "Error getting query syntax (" + ls_error_syntaxfromSQL + ")", 4)
	return -1
else
	// Create the datastore with the wildcard
	Create(ls_new_syntax, ls_error_create)
	if Len(ls_error_create) > 0 THEN
		log.log(this, "u_ds_data.load_table_from_file:0044", "Error with create the datastore (" + ls_error_create + ")", 4)
		return -1
	end if
	
	// Now build a new query from the columns in the table
	ls_column_count = Object.DataWindow.Column.Count
	li_column_count = integer(ls_column_count)
	if li_column_count <= 0 then return 0
	for i = 1 to li_column_count
		if i > 1 then ls_column_list += ", "
		ls_column_list += describe("#" + string(i) + ".name")
	next
	ls_new_sql = "SELECT " + ls_column_list + " from " + ps_table

	// Now rerun syntaxfromsql with the new query
	ls_new_syntax = sqlca.SyntaxFromSQL(ls_new_sql, "", ls_error_syntaxfromSQL)
	if Len(ls_error_syntaxfromSQL) > 0 THEN
		log.log(this, "u_ds_data.load_table_from_file:0061", "Error getting query syntax (" + ls_error_syntaxfromSQL + ")", 4)
		return -1
	else
		// Now recreate then datastore
		Create(ls_new_syntax, ls_error_create)
		if Len(ls_error_create) > 0 THEN
			log.log(this, "u_ds_data.load_table_from_file:0067", "Error with create the datastore (" + ls_error_create + ")", 4)
			return -1
		end if
		Object.DataWindow.Table.UpdateTable = ps_table
		li_column_count = integer(Object.DataWindow.Column.Count)
		for i = 1 to li_column_count
			ls_sts = modify("#" + string(i) + ".identity=No")
			ls_sts = modify("#" + string(i) + ".update=Yes")
		next
		importfile(ps_file)
		log.log(this, "u_ds_data.load_table_from_file:0077", string(rowcount()) + ps_file, 4)
		settransobject(mydb)
		if lb_identity then
			ls_sql = "SET IDENTITY_INSERT " + ps_table + " ON"
			li_sts = sqlca.execute_string(ls_sql)
			if li_sts <= 0 then
				log.log(this, "u_ds_data.load_table_from_file:0083", "Error with set_identity_insert " + ps_file, 4)
				return li_sts
			end if
		end if
		
		if pb_delete_first then
			ls_sql = "DELETE " + ps_table
			li_sts = sqlca.execute_string(ls_sql)
			if li_sts <= 0 then
				log.log(this, "u_ds_data.load_table_from_file:0092","Delete First error " + ps_file, 4)
				return li_sts
			end if
		end if

		li_sts = update()
		if li_sts <= 0 then
			log.log(this, "u_ds_data.load_table_from_file:0099", "Update Error " + ps_file, 4)
		end if

	end if
end if

if lb_identity then
	ls_sql = "SET IDENTITY_INSERT " + ps_table + " OFF"
	sqlca.execute_string(ls_sql)
end if

return li_sts


end function

public function integer load_table_from_file (string ps_table, string ps_file);return load_table_from_file(ps_table, ps_file, false)
end function

public function string where_clause_clause (string ps_dw_field, long pl_row, string ps_dbms, string ps_db_field);integer li_pos
string ls_left
string ls_right
string ls_type
integer li_col
string ls_item
string ls_delim
string ls_null
string ls_db_field

setnull(ls_null)
ls_db_field = ps_db_field

if isnull(ps_dw_field) or trim(ps_dw_field) = "" then return ls_null

ls_type = UPPER(left(Describe(ps_dw_field + ".ColType"), 4))
li_col = integer(Describe(ps_dw_field + ".ID"))
if li_col <= 0 then return "!"
if ls_type = "NUMB" then
	ls_item = string(object.data[pl_row, li_col])
	ls_delim = ""
elseif ls_type = "LONG" then
	ls_item = string(object.data[pl_row, li_col])
	ls_delim = ""
elseif ls_type = "CHAR" then
	ls_item = object.data[pl_row, li_col]
	ls_delim = "'"
elseif ls_type = "DATE" then
	ls_item = string(object.data[pl_row, li_col], "[shortdate] [time]")
	if isnull(ls_item) or trim(ls_item) = "" then
		setnull(ls_item)
	else
		CHOOSE CASE upper(left(ps_dbms, 3))
			CASE "ODB"
				ls_delim = "#"
			CASE "MSS"
				ls_delim = "'"
				ls_db_field = "convert(datetime,convert(varchar(20), " + ps_db_field + ", 113))"
			CASE "DW"
				ls_delim = ""
				f_split_string(ls_item, " ", ls_left, ls_right)
				ls_item = 'datetime(date("' + ls_left + '"), time("' + ls_right + '"))'
			CASE ELSE
				ls_delim = "'"
		END CHOOSE
	end if
else
	ls_item = string(object.data[pl_row, li_col])
	ls_delim = "'"
end if

// Empty strings should be treated as null
if trim(ls_item) = "" then setnull(ls_item)

if not isnull(ls_item) then
	// fix any single quotes by doubling them
	li_pos = 1
	DO
		li_pos = pos(ls_item, "'", li_pos)
		if li_pos > 0 then
			ls_item = replace(ls_item, li_pos, 1, "''")
			li_pos += 2
		end if
	LOOP WHILE li_pos > 0
	
	ls_item = ls_delim + ls_item + ls_delim
	
	// Add field
	ls_item = ls_db_field + " = " + ls_item
end if


return ls_item

end function

public function string get_attribute (string ps_attribute);long ll_rows
long ll_row
string ls_find
string ls_value

ll_rows = rowcount()

ls_find = "lower(attribute)='" + lower(ps_attribute) + "'"
ll_row = find(ls_find, 1, ll_rows)
if ll_row > 0 then
	ls_value = object.value[ll_row]
	return ls_value
end if

setnull(ls_value)
return ls_value

end function

public function boolean is_column (string ps_column);string ls_column

if isnull(ps_column) then return false

ps_column = trim(lower(ps_column))
ls_column = describe(ps_column + ".name")
if lower(ls_column) = ps_column then return true

return false


end function

public function integer column_id (string ps_column);integer li_id

if isnull(ps_column) then return 0
ps_column = trim(lower(ps_column))

li_id = integer(describe(ps_column + ".id"))
if isnull(li_id) or li_id <= 0 then return 0

return li_id


end function

public function string get_field_value (long pl_row, string ps_field_name);string ls_null
integer li_column_id

li_column_id = column_id(ps_field_name)

return get_field_value(pl_row, li_column_id)


end function

public function string get_field_display (long pl_row, string ps_field_name);string ls_value

ls_value = get_field_value(pl_row, ps_field_name)

return f_property_value_display(ps_field_name, ls_value)


end function

public function string get_field_display (long pl_row, string ps_context_object, string ps_field_name);string ls_pretty_text
long ll_patient_workplan_item_id

setnull(ls_pretty_text)

// If this context has special fields, process them
CHOOSE CASE lower(ps_context_object)
	CASE "service"
		// Now convert to a pretty value
		CHOOSE CASE lower(ps_field_name)
			CASE "dispatch_time"
				ls_pretty_text = string(time(datetime(object.dispatch_date[pl_row])), "hh:mm")
			CASE "begin_time"
				ls_pretty_text = string(time(datetime(object.begin_date[pl_row])), "hh:mm")
			CASE "end_time"
				ls_pretty_text = string(time(datetime(object.end_date[pl_row])), "hh:mm")
			CASE "message"
				ll_patient_workplan_item_id = object.patient_workplan_item_id[pl_row]
				SELECT value
				INTO :ls_pretty_text
				FROM dbo.fn_workplan_item_attribute(:ll_patient_workplan_item_id, 'message');
			CASE "disposition"
				ll_patient_workplan_item_id = object.patient_workplan_item_id[pl_row]
				SELECT value
				INTO :ls_pretty_text
				FROM dbo.fn_workplan_item_attribute(:ll_patient_workplan_item_id, 'disposition');
			CASE ELSE
				// If this is not a special field then process through the common routine
				return get_field_display(pl_row, ps_field_name)
		END CHOOSE
	CASE ELSE
		// If this context has no special fields then process through the common routine
		return get_field_display(pl_row, ps_field_name)
END CHOOSE

return ls_pretty_text

end function

public function string get_field_value (long pl_row, integer pi_column_id);string ls_null
string ls_value
string ls_coltype
integer li_pos
integer li_length

setnull(ls_null)

if isnull(pl_row) or pl_row <= 0 or pl_row > rowcount() then return ls_null

if isnull(pi_column_id) or pi_column_id <= 0 then return ls_null

// Get the column type
ls_coltype = trim(upper(Describe("#" + string(pi_column_id) + ".ColType")))

// strip off the size
li_pos = pos(ls_coltype, "(")
if li_pos > 0 then
	li_length = integer(mid(ls_coltype, li_pos + 1, len(ls_coltype) - li_pos - 1))
	ls_coltype = left(ls_coltype, li_pos - 1)
end if

CHOOSE CASE ls_coltype
	CASE "CHAR"
		ls_value = object.data[pl_row, pi_column_id]
	CASE "DATE"
		ls_value = string(date(object.data[pl_row, pi_column_id]))
	CASE "DATETIME"
		ls_value = string(datetime(object.data[pl_row, pi_column_id]))
	CASE "DECIMAL"
		ls_value = string(dec(object.data[pl_row, pi_column_id]))
	CASE "INT"
		ls_value = string(integer(object.data[pl_row, pi_column_id]))
	CASE "LONG"
		ls_value = string(long(object.data[pl_row, pi_column_id]))
	CASE "NUMBER"
		ls_value = string(object.data[pl_row, pi_column_id])
	CASE "REAL"
		ls_value = string(real(object.data[pl_row, pi_column_id]))
	CASE "TIME"
		ls_value = string(time(object.data[pl_row, pi_column_id]))
	CASE "TIMESTAMP"
		ls_value = string(object.data[pl_row, pi_column_id])
	CASE "ULONG"
		ls_value = string(object.data[pl_row, pi_column_id])
	CASE ELSE
		ls_value = string(object.data[pl_row, pi_column_id])
END CHOOSE

return ls_value

end function

public function str_grid get_grid ();str_grid lstr_grid
long i
integer j
string ls_value
string ls_field_name[]

lstr_grid.row_count = rowcount()
lstr_grid.column_count = integer(Object.DataWindow.Column.Count)

for i = 1 to lstr_grid.column_count
	ls_field_name[i] = describe("#" + string(i) + ".name")
	lstr_grid.column_title[i] = wordcap(f_string_substitute(ls_field_name[i], "_", " "))
next

for i = 1 to lstr_grid.row_count
	for j = 1 to lstr_grid.column_count
		ls_value = get_field_value(i, j)
		if isnull(ls_value) then
			lstr_grid.grid_row[i].column[j].column_text = ""
		else
			lstr_grid.grid_row[i].column[j].column_text = f_property_value_display(ls_field_name[j], ls_value)
		end if
	next
next

return lstr_grid

end function

public function str_attributes get_attributes_from_row (long pl_row);str_attributes lstr_attributes
long i
string ls_value
string ls_attribute_name
long ll_rowcount
long ll_columncount

ll_rowcount = rowcount()
ll_columncount = integer(Object.DataWindow.Column.Count)

for i = 1 to ll_columncount
	ls_attribute_name = describe("#" + string(i) + ".name")
	ls_value = get_field_value(pl_row, i)
	f_attribute_add_attribute(lstr_attributes, ls_attribute_name, ls_value)
next

return lstr_attributes

end function

public function str_property_value get_property (string ps_property, long pl_row);string ls_null
integer li_column_id
long ll_property_id
string ls_coltype
integer li_length
integer li_pos
str_property_value lstr_property_value
str_property lstr_property
str_attributes lstr_attributes
string ls_progress_type
string ls_progress_key

setnull(ls_null)
lstr_property_value = f_empty_property_value()

if isnull(pl_row) or pl_row <= 0 then return lstr_property_value

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
			lstr_property_value.value = object.data[pl_row, li_column_id]
			lstr_property_value.datatype = "string"
		CASE "DATE"
			lstr_property_value.value = string(date(object.data[pl_row, li_column_id]))
			lstr_property_value.datatype = "datetime"
		CASE "DATETIME"
			lstr_property_value.value = string(datetime(object.data[pl_row, li_column_id]))
			lstr_property_value.datatype = "datetime"
		CASE "DECIMAL"
			lstr_property_value.value = string(dec(object.data[pl_row, li_column_id]))
			lstr_property_value.datatype = "number"
		CASE "INT"
			lstr_property_value.value = string(integer(object.data[pl_row, li_column_id]))
			lstr_property_value.datatype = "number"
		CASE "LONG"
			lstr_property_value.value = string(long(object.data[pl_row, li_column_id]))
			lstr_property_value.datatype = "number"
		CASE "NUMBER"
			lstr_property_value.value = string(object.data[pl_row, li_column_id])
			lstr_property_value.datatype = "number"
		CASE "REAL"
			lstr_property_value.value = string(real(object.data[pl_row, li_column_id]))
			lstr_property_value.datatype = "number"
		CASE "TIME"
			lstr_property_value.value = string(time(object.data[pl_row, li_column_id]))
			lstr_property_value.datatype = "string"
		CASE "TIMESTAMP"
			lstr_property_value.value = string(object.data[pl_row, li_column_id])
			lstr_property_value.datatype = "datetime"
		CASE "ULONG"
			lstr_property_value.value = string(object.data[pl_row, li_column_id])
			lstr_property_value.datatype = "number"
		CASE ELSE
			lstr_property_value.value = string(object.data[pl_row, li_column_id])
			lstr_property_value.datatype = "string"
	END CHOOSE
end if	

lstr_property_value.display_value = f_property_value_display(ps_property, lstr_property_value.value)

return lstr_property_value

end function

public function integer create_from_query (string ps_query);string ls_error_syntaxfromSQL
string ls_error_create
string ls_new_syntax
integer li_sts

// This procedure assumes that mydb is already set

// An empty query just returns no rows
if isnull(ps_query) or trim(ps_query) = "" then return 0

// First get a datastore syntax from the query
li_sts = sqlca.get_dw_syntax(ps_query, ls_new_syntax)
if li_sts <= 0 then
	if isnull(ls_error_syntaxfromSQL) then ls_error_syntaxfromSQL = "<Null>"
	log.log(this, "u_ds_data.create_from_query:0015", "Error getting query syntax (" + sqlca.dbms + ", " + ls_error_syntaxfromSQL + ")", 4)
	return -1
end if

// Create the datastore
Create(ls_new_syntax, ls_error_create)
if Len(ls_error_create) > 0 THEN
	if isnull(ls_error_create) then ls_error_create = "<Null>"
	log.log(this, "u_ds_data.create_from_query:0023", "Error creating datastore (" + ls_error_create + ")", 4)
	return -1
end if

return 1

end function

public function long load_query (string ps_query, boolean pb_retain_rows);string ls_error_syntaxfromSQL, ls_error_create
string ls_new_syntax
string ls_sts
integer i
long ll_rows
string ls_column_count
integer li_column_count
string ls_sql
string ls_column_list
integer li_sts

// This procedure assumes that mydb is already set

// An empty query just returns no rows
if isnull(ps_query) or trim(ps_query) = "" then return 0

// First get a datastore syntax from the query
li_sts = sqlca.get_dw_syntax(ps_query, ls_new_syntax)
if li_sts <= 0 then
	if isnull(ls_error_syntaxfromSQL) then ls_error_syntaxfromSQL = "<Null>"
	log.log(this, "u_ds_data.load_query:0021", "Error getting query syntax (" + sqlca.dbms + ", " + ls_error_syntaxfromSQL + "), "+ps_query, 4)
	return -1
end if

// Create the datastore
Create(ls_new_syntax, ls_error_create)
if Len(ls_error_create) > 0 THEN
	if isnull(ls_error_create) then ls_error_create = "<Null>"
	log.log(this, "u_ds_data.load_query:0029", "Error creating datastore (" + ls_error_create + ")", 4)
	return -1
end if

// Retrieve the data
settransobject(sqlca)
ls_sql = getsqlselect()
retain_rows = pb_retain_rows
ll_rows = retrieve()
if ll_rows < 0 then
	log.log(this, "u_ds_data.load_query:0039", "Error executing query (" + ps_query + ", " + sqlca.sqlerrtext + ")", 4)
	return ll_rows
end if

return ll_rows


end function

public function long load_query (string ps_query);return load_query(ps_query, false)

end function

public function long load_query (string ps_query, ref pbdom_document po_xml_document, string ps_root_element_name, string ps_row_element_name);long ll_count
string ls_dw_xml
u_ds_data luo_data
long i
long ll_rows
PBDOM_BUILDER pbdombuilder_new
PBDOM_ELEMENT lo_root
PBDOM_ELEMENT lo_datafile
PBDOM_ELEMENT lo_rows[]
string ls_xml
PBDOM_DOCUMENT lo_local_document

ll_count = load_query(ps_query, false)
if ll_count <= 0 then return ll_count

ls_dw_xml = object.datawindow.data.xml


TRY
	pbdombuilder_new = CREATE PBDOM_BUILDER
	lo_local_document = pbdombuilder_new.buildfromstring(ls_dw_xml)
	lo_root = lo_local_document.GetRootElement()
	if len(ps_root_element_name) > 0 then
		lo_root.setname(ps_root_element_name)
	end if
	
	if len(ps_row_element_name) > 0 then
		if lo_root.getchildelements(lo_rows) then
			ll_count = upperbound(lo_rows)
			for i = 1 to ll_count
				lo_rows[i].setname(ps_row_element_name)
			next
		end if
	end if
	
	// For some unknown the lo_local_document could not be passed back and the browsed successfully.  The workaround is to create a new document from the edited local document and pass back the new document
	ls_xml = lo_local_document.SaveDocumentIntoString()
	po_xml_document = pbdombuilder_new.buildfromstring(ls_xml)
CATCH (PBDOM_EXCEPTION pbdom_except)
	log.log(this, "u_ds_data.load_query:0040", "XML Error: " + string(pbdom_except.GetExceptionCode()) + "~r~nText : " + pbdom_except.Text, 4)
	return -1
CATCH (throwable lo_error)
	log.log(this, "u_ds_data.load_query:0043", "XML Error: " + lo_error.Text, 4)
	return -1
end try


return 1


end function

on u_ds_data.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_ds_data.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event dberror;string ls_message

tf_check()

ls_message = "DATAWINDOW SQL ERROR = (" + string(sqldbcode) + ") " + sqlerrtext
ls_message += "~r~nDataobject = " + dataobject
ls_message += "~r~nSQL Statement = " + sqlsyntax

log.log(this,  classname() + ":dberror", ls_message, 3)

return 1


end event

event sqlpreview;string ls_sql
integer li_sts

ls_sql = sqlsyntax
li_sts = 0

return li_sts

end event

event retrievestart;if retain_rows then
	retain_rows = false
	return 2
end if

end event

event updatestart;mydb.begin_transaction(this, "updatestart")

end event

event updateend;mydb.commit_transaction()

end event

event constructor;mydb = sqlca
end event

