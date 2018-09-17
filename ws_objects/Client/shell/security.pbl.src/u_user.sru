$PBExportHeader$u_user.sru
forward
global type u_user from nonvisualobject
end type
end forward

global type u_user from nonvisualobject
end type
global u_user u_user

type variables
string user_id
string user_full_name
string user_short_name
string user_initial
long color
string primary_office_id
string email_address
string username
string npi
string actor_class
boolean clinical_access_flag
string upin
string certification_number
string actor_type
long actor_id
boolean show_hm = false
boolean show_documents = false

// OK or NA - this comes from [user_status] if
// the actor_class is "User" and comes from [status] otherwise
string user_status

//integer service_count
//u_service service[]
//string primary_flag[]
//
//integer privilege_count
//string privilege_id[]

//integer preference_count
//str_preference preferences[]

string first_name
string middle_name
string last_name
string degree
string name_prefix
string name_suffix
string dea_number
string license_number
string supervisor_user_id
string certified
string billing_id
long billing_code
string license_flag

// Organization fields
string organization_contact
string organization_director
string title

// Information System fields
string information_system_type
string information_system_version


datetime activate_date
datetime modified
string modified_by
datetime created
string created_by

string specialty_id

u_user supervisor

boolean sticky_logon
// Sticky logon states
//		true = Stay logged on until user explicitely logs off
//		false = log user off 
//		null = don't log user off and don't refresh main screen
boolean sticky_logon_prompt

long address_count
str_actor_address address[]

long communication_count
str_actor_communication communication[]


end variables

forward prototypes
public function integer check_drug (string ps_drug_id, string ps_package_id)
public function string get_preference (string ps_preference_type, string ps_preference_id)
public function integer start_todo_item (long pl_todo_item_id)
public subroutine complete_todo_item (long pl_todo_item_id, string ps_status)
public function integer doing_service ()
public function integer not_doing_service ()
public subroutine set_supervisor (u_user puo_user)
public function boolean check_privilege (string ps_privilege_id)
public function boolean check_service (string ps_service)
public function string common_list_id ()
public subroutine complete_service ()
public function integer check_logon ()
public subroutine get_preferences ()
public function integer change_office (string ps_new_office_id)
public function string provider_name (boolean pb_include_dea)
public function string provider_name ()
public subroutine check_menu (ref str_menu pstr_menu)
public function integer get_addresses ()
public function integer get_communications ()
public function long get_address_index (string ps_description)
public function long get_communication_index (string ps_communication_type, string ps_communication_name)
public function integer update_old ()
public function integer update_communication (integer pi_comm_index, string ps_communication_value, string ps_note)
public function integer update_address (integer pi_address_index, string ps_address_line_1, string ps_address_line_2, string ps_city, string ps_state, string ps_zip, string ps_country)
public function integer update_address (integer pi_address_index)
public function integer update_communication (integer pi_comm_index)
public function integer set_communication_value (string ps_communication_type, string ps_communication_name, string ps_communication_value)
public function string get_communication_value (string ps_communication_type, string ps_communication_name)
public subroutine logoff (boolean pb_shutting_down)
end prototypes

public function integer check_drug (string ps_drug_id, string ps_package_id);integer li_sort_order
string ls_prescription_flag
real lr_default_dispense_amount
string ls_default_dispense_unit
string ls_take_as_directed
integer li_sts

if current_user.certified = "Y" then return 1

li_sts = tf_get_drug_package(ps_drug_id, &
										ps_package_id, &
										li_sort_order, &
										ls_prescription_flag, &
										lr_default_dispense_amount, &
										ls_default_dispense_unit, &
										ls_take_as_directed )
if li_sts <= 0 then return -1

if ls_prescription_flag = "Y" and isnull(supervisor) then return 0

return 1

end function

public function string get_preference (string ps_preference_type, string ps_preference_id);integer i
string ls_null


//for i = 1 to preference_count
//	if preferences[i].preference_type = ps_preference_type &
//	 and preferences[i].preference_id = ps_preference_id then
//	 	return preferences[i].preference_value
//	end if
//next

setnull(ls_null)
return ls_null


end function

public function integer start_todo_item (long pl_todo_item_id);datetime ldt_now

ldt_now = datetime(today(), now())

UPDATE u_Todo_List
SET start_date_time = :ldt_now
WHERE user_id = :user_id
AND todo_item_id = :pl_todo_item_id;
if not tf_check() then return -1

return 1

end function

public subroutine complete_todo_item (long pl_todo_item_id, string ps_status);datetime ldt_now

ldt_now = datetime(today(), now())

UPDATE u_Todo_List
SET end_date_time = :ldt_now,
	 status = :ps_status
WHERE user_id = :user_id
AND todo_item_id = :pl_todo_item_id;
if not tf_check() then return


end subroutine

public function integer doing_service ();

UPDATE o_Users
SET in_service = "Y"
WHERE user_id = :user_Id
AND computer_id = :gnv_app.computer_id;
if not tf_check() then return -1

if sqlca.sqlcode = 100 then return 0

if isvalid(w_main) then w_main.doing_service()


return 1

end function

public function integer not_doing_service ();

UPDATE o_Users
SET in_service = "N"
WHERE user_id = :user_Id
AND computer_id = :gnv_app.computer_id;
if not tf_check() then return -1

if sqlca.sqlcode = 100 then return 0

if isvalid(w_main) then w_main.not_doing_service()

return 1

end function

public subroutine set_supervisor (u_user puo_user);supervisor = puo_user

if isnull(puo_user) or not isvalid(puo_user) then
	setnull(supervisor_user_id)
else
	supervisor_user_id = puo_user.user_id
end if


end subroutine

public function boolean check_privilege (string ps_privilege_id);return user_list.is_user_privileged(user_id, ps_privilege_id)

end function

public function boolean check_service (string ps_service);return user_list.is_user_service(user_id, ps_service)

end function

public function string common_list_id ();////////////////////////////////////////////////////////////////////////////////////
//
// Description: If the user dont have his own personal list, check whether he
//              has the specialty list. If not pull the defaults '$'.
//
// Return : String
//
//
// Created By: Sumathi Chinnasamy                               On: 07/09/01
//
//
/////////////////////////////////////////////////////////////////////////////////////

If Isnull(specialty_id) Then
	Return '$'
Else
	Return specialty_id
End If

end function

public subroutine complete_service ();string ls_services_waiting
integer li_choice
str_popup popup


if left(user_id, 8) = "Patient " then
	logoff(false)
	return
elseif isnull(sticky_logon) then
	return
elseif not sticky_logon then
	if sticky_logon_prompt then
		popup.title = "You have completed a service and are about to be logged out of EncounterPRO"
		popup.data_row_count = 4
		popup.items[1] = "Log Out"
		popup.items[2] = "Stay Logged On"
		popup.items[3] = "1" // Default answer
		popup.items[4] = "5" // Timeout in seconds
		openwithparm(w_pop_choices_2, popup)
		li_choice = message.doubleparm
		if li_choice = 2 then sticky_logon = true
	end if
	
	if not sticky_logon then logoff(false)
	return
end if

if isvalid(w_main) then w_main.tab_main.refresh()

end subroutine

public function integer check_logon ();long ll_count
integer li_sts

// If either user object is null then set both null
if isnull(current_user) then
	setnull(current_scribe)
	return 0
end if

if isnull(current_scribe) then
	setnull(current_user)
	return 0
end if

// See if there's a record in o_Users for this user on this computer
SELECT count(*)
INTO :ll_count
FROM o_users (nolock)
WHERE user_id = :current_scribe.user_id
AND computer_id = :gnv_app.computer_id;
if not tf_check() then return -1

if ll_count = 0 then
	// We didn't find the logon record so report a warning
	log.log(this, "u_user.check_logon:0025", "User '" + user_full_name + "' is not logged in at computer # " + string(gnv_app.computer_id), 3)
	
	// If we're not working on a service, then log the user out
	if isnull(current_service) then logoff(false)
end if


li_sts = f_check_system_status()
if li_sts <= 0 then
	// If we're not working on a service, then shut down
	if isnull(current_service) then
		logoff(true)
	end if
	return -1
end if


return 1

end function

public subroutine get_preferences ();string ls_temp
integer li_sts
integer li_temp

ls_temp = datalist.get_preference("PREFERENCES", "auto_patient_select")
auto_patient_select = f_string_to_boolean(ls_temp)

ls_temp = datalist.get_preference("PREFERENCES", "auto_room_select")
auto_room_select = f_string_to_boolean(ls_temp)

ls_temp = datalist.get_preference("PREFERENCES", "config_mode")
config_mode = f_string_to_boolean(ls_temp)

ls_temp = datalist.get_preference("PREFERENCES", "rtf_debug_mode")
rtf_debug_mode = f_string_to_boolean(ls_temp)

ls_temp = datalist.get_preference("PREFERENCES", "sticky_logon_prompt")
if isnull(ls_temp) then
	sticky_logon_prompt = true
else
	sticky_logon_prompt = f_string_to_boolean(ls_temp)
end if


// mark 10/9/02 we don't support the idle event now
//ls_temp = datalist.get_preference("SYSTEM", "idle_logoff")
//if isnull(ls_temp) then
//	idle(0)
//else
//	idle(integer(ls_temp))
//end if

li_temp = datalist.get_preference_int("SYSTEM", "display_log_level")
if isnull(li_temp) then
	log.displayloglevel = integer(datalist.get_preference("SYSTEM", "DisplayLogLevel", "5"))
	if log.displayloglevel <= 0 then log.displayloglevel = 5
	if log.displayloglevel > 5 then log.displayloglevel = 5
else
	log.displayloglevel = li_temp
end if

default_encounter_type = datalist.get_preference("PREFERENCES", "default_encounter_type", "SICK")

original_unit_preference = datalist.get_preference("PREFERENCES", "unit", "METRIC")
unit_preference = original_unit_preference

date_format_string = datalist.get_preference("PREFERENCES", "date_format_string", "[shortdate]")

encounter_gravityprompt = datalist.get_preference("PREFERENCES", "encounter_gravityprompt", "The information in this encounter record is accurate to the best of my knowledge")

COLOR_BACKGROUND = datalist.get_preference_int("PREFERENCES", "color_background", COLOR_EPRO_BLUE)


ls_temp = datalist.get_preference("PREFERENCES", "abnormal_result_font_settings")
if isnull(ls_temp) then ls_temp = "bold"
abnormal_result_font_settings = f_interpret_font_settings(ls_temp)

show_hm = datalist.get_preference_boolean("SECURITY", "Show Health Maintenance Tab", common_thread.show_hm)

show_documents = check_privilege("Office Documents")

end subroutine

public function integer change_office (string ps_new_office_id);

UPDATE o_Users
SET office_id = :ps_new_office_id
WHERE user_id = :user_Id
AND computer_id = :gnv_app.computer_id;
if not tf_check() then return -1

if sqlca.sqlcode = 100 then return 0

gnv_app.office_id = ps_new_office_id

return 1

end function

public function string provider_name (boolean pb_include_dea);string ls_name

ls_name = f_pretty_name_fml(last_name, first_name, middle_name, name_suffix, name_prefix, degree)

if pb_include_dea and not isnull(dea_number) then
	ls_name += " ( DEA#: " + dea_number + " )"
end if

return ls_name


end function

public function string provider_name ();return provider_name(false)



end function

public subroutine check_menu (ref str_menu pstr_menu);long i, j
boolean lb_ok

// See if user is a superuser
if user_list.is_superuser(user_id) then return

for i = pstr_menu.menu_item_count to 1 step -1
	// First see if the user is authorized to use this service
	if pstr_menu.menu_item[i].menu_item_type = "SERVICE" then
		lb_ok = user_list.is_user_service(user_id, pstr_menu.menu_item[i].menu_item)
	else
		lb_ok = true
	end if

	// If the user is authorized to use the service, see if the user is
	// authorized to use this menu item
	if lb_ok then
		if isnull(pstr_menu.menu_item[i].authorized_user_id) then
			// Null authorized_user_id means anyone can use it
			lb_ok = true
		else
			if lower(pstr_menu.menu_item[i].authorized_user_id) = lower(user_id) then
				// An exact match on the user_id means this user can use it
				lb_ok = true
			elseif user_list.is_user_role(user_id, pstr_menu.menu_item[i].authorized_user_id) then
				// If authorized_user_id specifies a role that the user is in,
				// then the user can use the menu item
				lb_ok = true
			else
				// Non-null authorized_user_id and no match on user_id or role means
				// this user cannot use this menu item
				lb_ok = false
			end if
		end if
	end if

	// If the menu item is not OK for this user, then remove it
	if not lb_ok then
		for j = i to pstr_menu.menu_item_count - 1
			pstr_menu.menu_item[j] = pstr_menu.menu_item[j + 1]
		next
		pstr_menu.menu_item_count -= 1
	end if
next






end subroutine

public function integer get_addresses ();u_ds_data luo_data
long i

luo_data = CREATE u_ds_data
luo_data.set_dataobject( "dw_actor_addresses")
address_count = luo_data.retrieve(user_id)
if address_count < 0 then return -1
for i = 1 to address_count
	address[i].actor_id = luo_data.object.actor_id[i]
	address[i].address_sequence = luo_data.object.address_sequence[i]
	address[i].description = luo_data.object.description[i]
	address[i].address_line_1 = luo_data.object.address_line_1[i]
	address[i].address_line_2 = luo_data.object.address_line_2[i]
	address[i].city = luo_data.object.city[i]
	address[i].state = luo_data.object.state[i]
	address[i].zip = luo_data.object.zip[i]
	address[i].country = luo_data.object.country[i]
	address[i].status = luo_data.object.status[i]
	address[i].created_by = luo_data.object.created_by[i]
	address[i].created = luo_data.object.created[i]
next

DESTROY luo_data

return 1

end function

public function integer get_communications ();u_ds_data luo_data
long i

luo_data = CREATE u_ds_data
luo_data.set_dataobject( "dw_actor_communications")
communication_count = luo_data.retrieve(user_id)
if communication_count < 0 then return -1
for i = 1 to communication_count
	communication[i].actor_id = luo_data.object.actor_id[i]
	communication[i].communication_sequence = luo_data.object.communication_sequence[i]
	communication[i].communication_type = luo_data.object.communication_type[i]
	communication[i].communication_name = luo_data.object.communication_name[i]
	communication[i].communication_value = luo_data.object.communication_value[i]
	communication[i].note = luo_data.object.note[i]
	communication[i].sort_sequence = luo_data.object.sort_sequence[i]
	communication[i].status = luo_data.object.status[i]
	communication[i].created = luo_data.object.created[i]
	communication[i].created_by = luo_data.object.created_by[i]
next

DESTROY luo_data

return 1

end function

public function long get_address_index (string ps_description);long i

// Find the address index
for i = 1 to address_count
	if lower(address[i].description) = lower(ps_description) then return i
next

address_count += 1
address[address_count].actor_id = actor_id
address[address_count].description = ps_description
setnull(address[address_count].address_line_1)
setnull(address[address_count].address_line_2)
setnull(address[address_count].city)
setnull(address[address_count].state)
setnull(address[address_count].zip)
setnull(address[address_count].country)
setnull(address[address_count].status)
setnull(address[address_count].created)
setnull(address[address_count].created_by)

return address_count

end function

public function long get_communication_index (string ps_communication_type, string ps_communication_name);long i

// Find the communication index
for i = 1 to communication_count
	if lower(communication[i].communication_type) = lower(ps_communication_type) &
	  and lower(communication[i].communication_name) = lower(ps_communication_name) then return i
next

communication_count += 1
communication[communication_count].actor_id = actor_id
communication[communication_count].communication_type = ps_communication_type
communication[communication_count].communication_name = ps_communication_name
setnull(communication[communication_count].communication_value)
setnull(communication[communication_count].note)
setnull(communication[communication_count].sort_sequence)
setnull(communication[communication_count].status)
setnull(communication[communication_count].created)
setnull(communication[communication_count].created_by)

return communication_count

end function

public function integer update_old ();
//return user_list.update_user(this)
return -1
end function

public function integer update_communication (integer pi_comm_index, string ps_communication_value, string ps_note);
if isnull(pi_comm_index) then return 0

if pi_comm_index <= 0 or pi_comm_index > communication_count then
	log.log(this, "u_user.update_communication:0005", "Invalid index", 4)
	return -1
end if

communication[pi_comm_index].communication_value = ps_communication_value
communication[pi_comm_index].note = ps_note

return update_communication(pi_comm_index)

end function

public function integer update_address (integer pi_address_index, string ps_address_line_1, string ps_address_line_2, string ps_city, string ps_state, string ps_zip, string ps_country);
if isnull(pi_address_index) then return 0

if pi_address_index <= 0 or pi_address_index > address_count then
	log.log(this, "u_user.update_address:0005", "Invalid index", 4)
	return -1
end if

address[pi_address_index].address_line_1 = ps_address_line_1
address[pi_address_index].address_line_2 = ps_address_line_2
address[pi_address_index].city = ps_city
address[pi_address_index].state = ps_state
address[pi_address_index].zip = ps_zip
address[pi_address_index].country = ps_country

return update_address(pi_address_index)

end function

public function integer update_address (integer pi_address_index);
if isnull(pi_address_index) then return 0

if pi_address_index <= 0 or pi_address_index > address_count then
	log.log(this, "u_user.update_address:0005", "Invalid index", 4)
	return -1
end if

sqlca.sp_new_actor_address( address[pi_address_index].actor_id, & 
									address[pi_address_index].description, & 
									address[pi_address_index].address_line_1, & 
									address[pi_address_index].address_line_2, & 
									address[pi_address_index].city, & 
									address[pi_address_index].state, & 
									address[pi_address_index].zip, & 
									address[pi_address_index].country, & 
									current_scribe.user_id)
if not tf_check() then return -1

return 1


end function

public function integer update_communication (integer pi_comm_index);
if isnull(pi_comm_index) then return 0

if pi_comm_index <= 0 or pi_comm_index > communication_count then
	log.log(this, "u_user.update_communication:0005", "Invalid index", 4)
	return -1
end if

sqlca.sp_new_actor_communication( communication[pi_comm_index].actor_id, & 
											communication[pi_comm_index].communication_type, & 
											communication[pi_comm_index].communication_value, & 
											communication[pi_comm_index].note, & 
											current_scribe.user_id, & 
											communication[pi_comm_index].communication_name)
if not tf_check() then return -1

return 1


end function

public function integer set_communication_value (string ps_communication_type, string ps_communication_name, string ps_communication_value);long ll_index
integer li_sts

ll_index = get_communication_index(ps_communication_type, ps_communication_name)

communication[ll_index].communication_value = ps_communication_value

update_communication(ll_index)

return 1

end function

public function string get_communication_value (string ps_communication_type, string ps_communication_name);long ll_index

ll_index = get_communication_index(ps_communication_type, ps_communication_name)

return communication[ll_index].communication_value


end function

public subroutine logoff (boolean pb_shutting_down);string ls_services_waiting

 DECLARE lsp_primary_service_check PROCEDURE FOR dbo.sp_primary_service_check  
         @ps_room_id = :viewed_room.room_id,   
         @ps_user_id = :user_id,   
         @ps_services_waiting = :ls_services_waiting OUT ;

 DECLARE lsp_user_logoff PROCEDURE FOR dbo.sp_user_logoff  
         @ps_user_id = :user_id,
			@pl_computer_id = :gnv_app.computer_id;


log.log(this, "u_user.logoff:0013", "User " + user_short_name + " logging off...", 2)
// Force this message to the o_log table
if log.dbloglevel > 2 then
	log.log_db(this, "u_user.logoff:0016", "User " + user_short_name + " logging off...", 2)
end if

// Set the display log level back to the computer/global value
log.displayloglevel = datalist.get_preference_int("SYSTEM", "display_log_level", 5)

if isnull(current_user) then
	log.log(this, "u_user.logoff:0023", "current_user is null", 3)
elseif current_user.user_id <> user_id then
	log.log(this, "u_user.logoff:0025", "current_user is " + current_user.user_short_name, 3)
end if

EXECUTE lsp_user_logoff;
if not tf_check() then return

setnull(current_user)
setnull(current_scribe)
setnull(current_patient)

sticky_logon = false

if isvalid(w_main) and not pb_shutting_down then
	w_main.tab_main.logonoff_refresh()

	if left(user_id, 8) = "Patient " then
		user_id = "!PATIENT"
		viewed_room = current_room
	else
		if not isnull(viewed_room) then
	//		EXECUTE lsp_primary_service_check;
	//		if not tf_check() then return
	//	
	//		FETCH lsp_primary_service_check INTO :ls_services_waiting;
	//		if not tf_check() then return
	//	
	//		CLOSE lsp_primary_service_check;
	//	
	//		if ls_services_waiting <> "Y" then viewed_room = current_room
		else
			viewed_room = current_room
		end if
	end if
	
	f_set_screen()
end if


end subroutine

on u_user.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_user.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

