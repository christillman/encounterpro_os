$PBExportHeader$u_component_base_class.sru
forward
global type u_component_base_class from nonvisualobject
end type
end forward

global type u_component_base_class from nonvisualobject
event timer ( )
end type
global u_component_base_class u_component_base_class

type variables
string component_id
string id
string component_class
string component_description
oleobject ole
boolean ole_class
boolean my_objects = false
boolean running = true
datetime start_time
long restart_minutes
long server_service_id
long event_id

string context_object
long object_key

// Version information
str_component_definition component_definition
str_component_version component_version

private str_attributes attributes

u_component_timer timer
u_component_manager my_component_manager

u_event_log mylog
u_sqlca mydb
u_sqlca cprdb
u_adodb_connection adodb

boolean debug_mode

oleobject com_wrapper

w_window_base service_window

// Save a copy of the dotnet component initialization params so we can create a test file if needed
string dotnet_component_wrapper_class
string dotnet_component_version
string dotnet_component_class
string dotnet_component_attributes_xml
string dotnet_credential_attributes_xml
string dotnet_context_xml
string dotnet_xml_data

end variables

forward prototypes
protected function integer base_initialize ()
protected function integer base_shutdown ()
protected function integer xx_shutdown ()
protected function integer disconnect_component ()
public subroutine set_timer ()
public subroutine set_timer (double pdb_interval)
public function integer timer_ding ()
public subroutine stop_timer ()
protected function integer xx_configure ()
protected function string fix_string (string ps_string, string ps_attribute)
protected subroutine db_disconnect ()
public function integer configure ()
public function integer shutdown ()
protected subroutine create_mydb ()
public function integer db_connect ()
public function integer db_connect (string ps_database)
public function integer connect_component ()
protected function integer xx_initialize ()
protected function boolean replace_attribute (string ps_attribute, string ps_value)
public subroutine add_attributes (str_attributes pstr_attributes)
public function string get_attribute (string ps_attribute)
public function string get_attribute (string ps_attribute, ref boolean pb_value)
public function string get_attribute (string ps_attribute, ref date pd_value)
public function string get_attribute (string ps_attribute, ref integer pi_value)
public function string get_attribute (string ps_attribute, ref long pl_value)
public function string get_attribute (string ps_attribute, ref real pr_value)
public function string get_attribute (string ps_attribute, ref string ps_value)
public function str_attributes get_attributes ()
protected function integer get_attributes (ref string psa_attributes[], ref string psa_values[])
private function string get_dbparm ()
private function string get_connectstring ()
public function string substitute_attributes (string ps_string)
public function string get_attribute (string ps_attribute, ref datetime pdt_value)
public subroutine add_attribute (string ps_attribute, string ps_value)
protected function integer load_attributes ()
public function integer initialize (u_sqlca puo_cprdb, u_event_log puo_log, string ps_component_id, integer pi_attribute_count, string psa_attribute[], string psa_value[])
public subroutine add_context_attributes ()
public function boolean is_params (string ps_id, string ps_param_mode)
public function long next_component_counter (string ps_counter_name)
public function string get_attribute (string ps_attribute, ref boolean pb_value, boolean pb_default_value)
public function integer initialize_dotnet_wrapper (str_attributes pstr_component_attributes)
public function string dotnet_create_test_case ()
public subroutine add_attribute (string ps_attribute, string ps_value, string ps_component_id)
public subroutine add_attribute (string ps_attribute, string ps_value, string ps_component_id, long pl_attribute_sequence)
end prototypes

event timer();integer li_sts
date ld_1
time lt_1
string ls_error

if not running then return

TRY
	timer.stop_timer()
	
	if not isnull(server_service_id) then
		UPDATE o_Server_Component
		SET last_run = getdate(),
			last_spid = :cprdb.spid
		WHERE service_id = :server_service_id
		USING cprdb;
		if not cprdb.check() then return
	end if
	
	li_sts = timer_ding()
CATCH (throwable lo_error)
	ls_error = "Error in timer_ding function"
	if not isnull(lo_error.text) then
		ls_error += " (" + lo_error.text + ")"
	end if
	log.log(this, "u_component_base_class.timer.0026", ls_error, 4)
	li_sts = -1
FINALLY
	// If timer_ding() returns the special value 2, then don't restart the time
	// but instead post another timer event immediately
	if li_sts = 2 then
		THIS.event POST timer()
	else
		timer.start_timer()
	end if
	
END TRY


end event

protected function integer base_initialize ();return 1

end function

protected function integer base_shutdown ();return 1

end function

protected function integer xx_shutdown ();if ole_class and isvalid(ole) and not isnull(ole) then
	return ole.finished()
else
	return 100
end if

end function

protected function integer disconnect_component ();integer li_sts

if not ole_class then return 1

if not isvalid(ole) or isnull(ole) then
	setnull(ole)
	return 0
end if

li_sts = ole.disconnectobject()
if li_sts = 0 then
	DESTROY ole
	setnull(ole)
	return 1
end if

return li_sts

end function

public subroutine set_timer ();real lr_timer
integer li_timer_sts
string timer_pdb_interval

get_attribute("timer_interval", lr_timer)
if isnull(lr_timer) or lr_timer <= 0 then lr_timer = 10

if not isvalid(timer) or isnull(timer) then timer = CREATE u_component_timer

log.log(this, "u_component_base_class.set_timer.0010", "Setting timer (" + string(lr_timer) + ")", 1)

timer.initialize(this, double(lr_timer))

end subroutine

public subroutine set_timer (double pdb_interval);integer li_timer_sts
string timer_pdb_interval
real lr_timer

if not isvalid(timer) or isnull(timer) then timer = CREATE u_component_timer

timer.initialize(this, pdb_interval)

end subroutine

public function integer timer_ding ();mylog.log(this, "u_component_base_class.timer.0026_ding()", "ding...", 1)

if ole_class then
	return ole.timer_ding()
else
	return 100
end if

end function

public subroutine stop_timer ();if isnull(timer) or not isvalid(timer) then return

timer.stop_timer()

end subroutine

protected function integer xx_configure ();if ole_class and isvalid(ole) and not isnull(ole) then
	return ole.configure()
else
	return 100
end if

end function

protected function string fix_string (string ps_string, string ps_attribute);string ls_string
string ls_token
string ls_value

ls_value = get_attribute(ps_attribute)
if isnull(ls_value) then ls_value = ""


ls_string = f_string_substitute(ps_string, "%" + ps_attribute + "%", ls_value)

return ls_string

end function

protected subroutine db_disconnect ();mydb.dbdisconnect()

end subroutine

public function integer configure ();return xx_configure()

end function

public function integer shutdown ();
if server_service_id > 0 then mylog.log(this, "u_component_base_class.shutdown.0002", "Service shutting down(" + string(server_service_id) + ")", 2)

if isvalid(timer) and not isnull(timer) then
	timer.shutdown()
	DESTROY timer
	setnull(timer)
end if

xx_shutdown()

if ole_class then
	disconnect_component()
end if

base_shutdown()

if isvalid(mydb) and not isnull(mydb) then
	mydb.dbdisconnect()
	DESTROY mydb
	setnull(mydb)
end if

if my_objects then
	if isvalid(mylog) and not isnull(mylog) then
		mylog.shutdown()
		DESTROY mylog
		setnull(mylog)
	end if
	
	if isvalid(cprdb) and not isnull(cprdb) then
		cprdb.dbdisconnect()
		DESTROY cprdb
		setnull(cprdb)
	end if
end if

running = false

return 1

end function

protected subroutine create_mydb ();mydb = CREATE u_sqlca

end subroutine

public function integer db_connect ();string ls_database

ls_database = get_attribute("DATABASE")
if isnull(ls_database) then
	mylog.log(this, "u_component_base_class.db_connect.0005", "Unable to determine database", 4)
	return -1
end if

return db_connect(ls_database)


end function

public function integer db_connect (string ps_database);integer li_sts
string ls_dbms
string ls_servername
string ls_sys
string ls_dbparm
string ls_connectstring
string ls_logon_id

if isvalid(mydb) and not isnull(mydb) then DESTROY mydb

create_mydb()
mydb.mylog = mylog

ls_dbms = get_attribute("DBMS")
if isnull(ls_dbms) then ls_dbms = "MSS"

ls_servername = get_attribute("SERVER")

ls_connectstring = get_connectstring()

ls_dbparm = get_dbparm()

if isnull(ps_database) or trim(ps_database) = "" then
	ps_database = get_attribute("DATABASE")
	if isnull(ps_database) then
		mylog.log(this, "u_component_base_class.db_connect.0005", "Unable to determine database", 4)
		return -1
	end if
end if

// If the connectstring needs the database in it, the substitute it for the token %DATABASE%
ls_connectstring = f_string_substitute(ls_connectstring, "%DATABASE%", ps_database)

ls_logon_id = get_attribute("LOGON_ID")
if isnull(ls_logon_id) then ls_logon_id = logon_id

ls_sys = get_attribute("PWD")
if isnull(ls_sys) then ls_sys = mydb.sys()

li_sts = mydb.dbconnect(ls_servername, ps_database, ls_dbms, component_id, logon_id, ls_sys, ls_dbparm, ls_connectstring)

return li_sts


end function

public function integer connect_component ();integer li_sts

if isvalid(ole) and not isnull(ole) then disconnect_component()

if ole_class then
	ole = CREATE oleobject
	
	li_sts = ole.connecttonewobject(component_class)
	
	if li_sts <> 0 then
		mylog.log(this, "u_component_base_class.connect_component.0011", "Error connecting to component class (" + component_class + ", " + string(li_sts) + ")", 4)
		DESTROY ole
		setnull(ole)
		setnull(component_class)
		setnull(component_id)
		return -1
	end if	
end if

return 1



end function

protected function integer xx_initialize ();integer li_attribute_count
string lsa_attributes[]
string lsa_values[]

li_attribute_count = get_attributes(lsa_attributes, lsa_values)

if ole_class and isvalid(ole) and not isnull(ole) then
	return ole.initialize(li_attribute_count, lsa_attributes, lsa_values)
else
	return 100
end if

end function

protected function boolean replace_attribute (string ps_attribute, string ps_value);integer i

for i = 1 to attributes.attribute_count
	if attributes.attribute[i].attribute = ps_attribute then
		attributes.attribute[i].value = ps_value
		return true
	end if
next

return false




end function

public subroutine add_attributes (str_attributes pstr_attributes);long i

// Add all the attributes
for i = 1 to pstr_attributes.attribute_count
	add_attribute(	pstr_attributes.attribute[i].attribute, &
						pstr_attributes.attribute[i].value, &
						pstr_attributes.attribute[i].component_id, &
						pstr_attributes.attribute[i].attribute_sequence)
next


end subroutine

public function string get_attribute (string ps_attribute);return f_attribute_find_attribute(attributes, ps_attribute)

end function

public function string get_attribute (string ps_attribute, ref boolean pb_value);string ls_temp

ls_temp = get_attribute(ps_attribute)
pb_value = f_string_to_boolean(ls_temp)

return ls_temp

end function

public function string get_attribute (string ps_attribute, ref date pd_value);string ls_temp

ls_temp = get_attribute(ps_attribute)

if isdate(ls_temp) then
	pd_value = date(ls_temp)
else
	setnull(pd_value)
end if

return ls_temp

end function

public function string get_attribute (string ps_attribute, ref integer pi_value);string ls_temp

ls_temp = get_attribute(ps_attribute)

pi_value = long(ls_temp)

return ls_temp

end function

public function string get_attribute (string ps_attribute, ref long pl_value);string ls_temp

ls_temp = get_attribute(ps_attribute)

pl_value = long(ls_temp)

return ls_temp

end function

public function string get_attribute (string ps_attribute, ref real pr_value);string ls_temp

ls_temp = get_attribute(ps_attribute)

pr_value = long(ls_temp)

return ls_temp

end function

public function string get_attribute (string ps_attribute, ref string ps_value);
ps_value = get_attribute(ps_attribute)

return ps_value

end function

public function str_attributes get_attributes ();
return attributes

end function

protected function integer get_attributes (ref string psa_attributes[], ref string psa_values[]);integer i

for i = 1 to attributes.attribute_count
	psa_attributes[i] = attributes.attribute[i].attribute
	psa_values[i] = attributes.attribute[i].value
next

return attributes.attribute_count

end function

private function string get_dbparm ();integer i
string ls_dbparm
string ls_sc

ls_sc = ""
ls_dbparm = ""

for i = 1 to attributes.attribute_count
	if upper(left(attributes.attribute[i].attribute, 7)) = "DBPARM_" then
		ls_dbparm += ls_sc + mid(attributes.attribute[i].attribute, 8) + "=" + attributes.attribute[i].value
		ls_sc = ","
	end if
next

return ls_dbparm

end function

private function string get_connectstring ();integer i
string ls_connect
string ls_sc

ls_sc = ""
ls_connect = ""

for i = 1 to attributes.attribute_count
	if upper(left(attributes.attribute[i].attribute, 5)) = "ODBC_" then
		ls_connect += ls_sc + mid(attributes.attribute[i].attribute, 6) + "=" + attributes.attribute[i].value
		ls_sc = ";"
	end if
next

return ls_connect

end function

public function string substitute_attributes (string ps_string);integer i
string ls_string
string ls_attribute

ls_string = ps_string

for i = 1 to attributes.attribute_count
	ls_attribute = "%" + attributes.attribute[i].attribute + "%"
	ls_string = f_string_substitute(ls_string, ls_attribute, attributes.attribute[i].value)
next

return ls_string


end function

public function string get_attribute (string ps_attribute, ref datetime pdt_value);string ls_temp
string ls_date
string ls_time

ls_temp = get_attribute(ps_attribute)

if isnull(ls_temp) then
	setnull(pdt_value)
else
	f_split_string(ls_temp, " ", ls_date, ls_time)
	
	pdt_value = datetime(date(ls_date), time(ls_time))
end if

return ls_temp

end function

public subroutine add_attribute (string ps_attribute, string ps_value);string ls_new_value

ls_new_value = f_attribute_value_substitute(context_object, object_key, ps_value)

f_attribute_add_attribute(attributes, ps_attribute, ls_new_value)

end subroutine

protected function integer load_attributes ();u_ds_data luo_data
long ll_count

luo_data = CREATE u_ds_data

luo_data.set_dataobject("dw_sp_get_component_attributes", cprdb)
ll_count = luo_data.retrieve(component_id, office_id, computer_id)
if ll_count > 0 then f_attribute_ds_to_str(luo_data, attributes)

DESTROY luo_data

return attributes.attribute_count


end function

public function integer initialize (u_sqlca puo_cprdb, u_event_log puo_log, string ps_component_id, integer pi_attribute_count, string psa_attribute[], string psa_value[]);integer li_sts
integer i

u_ds_data luo_sp_get_component_class
integer li_spdw_count

cprdb = puo_cprdb

mylog = puo_log

my_objects = false

component_id = ps_component_id
add_attribute("component_id", component_id)

for i = 1 to pi_attribute_count
	add_attribute(psa_attribute[i], psa_value[i])
next

// Add the temp_path
add_attribute("temp_filepath", temp_path)

get_attribute("service_id", server_service_id)
get_attribute("restart_minutes", restart_minutes)
get_attribute("debug_mode", debug_mode)


component_description = component_definition.description
dotnet_component_version = component_version.component_location
dotnet_component_class = component_version.component_data
dotnet_component_wrapper_class = component_definition.component_wrapper_class


li_sts = connect_component()
if li_sts <= 0 then return -1

li_sts = load_attributes()
if li_sts < 0 then return -1

li_sts = base_initialize()
if li_sts <= 0 then return -1

// check the debug_mode again after loading the attributes
get_attribute("debug_mode", debug_mode)

li_sts = xx_initialize()

return li_sts


end function

public subroutine add_context_attributes ();str_attributes lstr_attributes

lstr_attributes = f_get_context_attributes()

add_attributes(lstr_attributes)


end subroutine

public function boolean is_params (string ps_id, string ps_param_mode);return f_any_params(ps_id, ps_param_mode)

end function

public function long next_component_counter (string ps_counter_name);long ll_next_counter

DECLARE lsp_get_next_component_counter PROCEDURE FOR dbo.sp_get_next_component_counter  
         @ps_component_id = :component_id,   
         @ps_attribute = :ps_counter_name,   
         @pl_next_counter = :ll_next_counter OUT
USING cprdb;


EXECUTE lsp_get_next_component_counter;
if not cprdb.check() then return -1

FETCH lsp_get_next_component_counter INTO :ll_next_counter;
if not cprdb.check() then return -1

CLOSE lsp_get_next_component_counter;

return ll_next_counter

end function

public function string get_attribute (string ps_attribute, ref boolean pb_value, boolean pb_default_value);string ls_temp

ls_temp = get_attribute(ps_attribute)
if isnull(ls_temp) then
	pb_value = pb_default_value
else
	pb_value = f_string_to_boolean(ls_temp)
end if

return ls_temp

end function

public function integer initialize_dotnet_wrapper (str_attributes pstr_component_attributes);integer li_sts
str_attributes lstr_attributes
string ls_access_level
u_xml_script lo_xml
str_context lstr_context
string ls_message

lstr_context = f_current_context()

if isnull(dotnet_component_wrapper_class) or trim(dotnet_component_wrapper_class) = "" then
	log.log(this, "u_component_base_class.initialize_dotnet_wrapper.0011", "Error! NULL component_wrapper_class", 4)
	return -1
end if

// We COM doesn't like nulls
if isnull(dotnet_component_version) then dotnet_component_version = ""
if isnull(dotnet_component_class) then dotnet_component_class = ""

ls_access_level = get_attribute("access_level")
if isnull(ls_access_level) then
	ls_access_level = "Service"
end if

com_wrapper = CREATE oleobject
if debug_mode then
	log.log(this, "u_component_base_class.initialize_dotnet_wrapper.0011", "Attempting to instantiate com object (" + dotnet_component_wrapper_class + ")", 2)
end if
li_sts = com_wrapper.connecttonewobject(dotnet_component_wrapper_class)
if li_sts = 0 then
	if debug_mode then
		log.log(this, "u_component_base_class.initialize_dotnet_wrapper.0011", "instantiation successful (" + dotnet_component_wrapper_class + ")", 2)
	end if
else
	log.log(this, "u_component_base_class.initialize_dotnet_wrapper.0011", "Error connecting to com source (" + dotnet_component_wrapper_class + ", " + string(li_sts) + ")", 4)
	return -1
end if


// Get the XML document for the component attributes
if not isnull(service_window) and isvalid(service_window) then
	f_attribute_add_attribute(pstr_component_attributes, "CallbackWindowHandle", string(handle(service_window)))
end if

lo_xml = CREATE u_xml_script
li_sts = lo_xml.create_xml_from_attributes("ComponentAttributes", &
														lstr_context, &
														pstr_component_attributes,&
														dotnet_component_attributes_xml)
if li_sts < 0 or isnull(dotnet_component_attributes_xml) then
	log.log(this, "u_component_base_class.initialize_dotnet_wrapper.0011", "Error getting context attributes", 4)
	return -1
end if

// Get the XML document for the credentials
lstr_attributes.attribute_count = 0
sqlca.add_credentials(ls_access_level, lstr_attributes)
dotnet_credential_attributes_xml = f_attributes_to_xml_for_component("CredentialAttributes", lstr_attributes)
if isnull(dotnet_credential_attributes_xml) then
	log.log(this, "u_component_base_class.initialize_dotnet_wrapper.0011", "Error getting credential attributes", 4)
	return -1
end if

// Get the XML document for the context
dotnet_context_xml = f_get_context_xml(lstr_context)

TRY
	com_wrapper.ConnectClass(dotnet_component_version, &
									dotnet_component_class, &
									dotnet_component_attributes_xml, &
									dotnet_credential_attributes_xml, &
									dotnet_context_xml)
CATCH (oleruntimeerror lt_error)
	ls_message = "Error calling ConnectClass~r~n"
	ls_message += dotnet_component_version + "~r~n" + dotnet_component_class + "~r~n"
	ls_message += lt_error.text + "~r~n" + lt_error.description
	log.log(this, "u_component_base_class.initialize_dotnet_wrapper.0011", ls_message, 4)
	dotnet_create_test_case()
	return -1
END TRY

if debug_mode then
	dotnet_create_test_case()
end if



return 1


end function

public function string dotnet_create_test_case ();return f_create_dotnet_test_case(this)

end function

public subroutine add_attribute (string ps_attribute, string ps_value, string ps_component_id);string ls_new_value

ls_new_value = f_attribute_value_substitute(context_object, object_key, ps_value)

f_attribute_add_attribute2(attributes, ps_attribute, ls_new_value, ps_component_id)

end subroutine

public subroutine add_attribute (string ps_attribute, string ps_value, string ps_component_id, long pl_attribute_sequence);string ls_new_value

ls_new_value = f_attribute_value_substitute(context_object, object_key, ps_value)

f_attribute_add_attribute3(attributes, ps_attribute, ls_new_value, ps_component_id, pl_attribute_sequence)

end subroutine

on u_component_base_class.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_component_base_class.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;start_time = datetime(today(),now())
setnull(object_key)
context_object = "General"

end event

