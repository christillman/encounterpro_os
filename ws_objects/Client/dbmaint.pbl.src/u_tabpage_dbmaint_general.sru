$PBExportHeader$u_tabpage_dbmaint_general.sru
forward
global type u_tabpage_dbmaint_general from u_tabpage
end type
type cb_check_epie from commandbutton within u_tabpage_dbmaint_general
end type
type st_mode_title from statictext within u_tabpage_dbmaint_general
end type
type st_check_remote_title from statictext within u_tabpage_dbmaint_general
end type
type st_5 from statictext within u_tabpage_dbmaint_general
end type
type st_security_strength from statictext within u_tabpage_dbmaint_general
end type
type st_security_status_title from statictext within u_tabpage_dbmaint_general
end type
type rb_new from radiobutton within u_tabpage_dbmaint_general
end type
type rb_old from radiobutton within u_tabpage_dbmaint_general
end type
type cb_sync_data from commandbutton within u_tabpage_dbmaint_general
end type
type cb_reset_database_objects from commandbutton within u_tabpage_dbmaint_general
end type
type st_sessions_total from statictext within u_tabpage_dbmaint_general
end type
type st_sessions_not_logged_in from statictext within u_tabpage_dbmaint_general
end type
type st_sessions_logged_in from statictext within u_tabpage_dbmaint_general
end type
type st_total_clients_title from statictext within u_tabpage_dbmaint_general
end type
type st_not_logged_in_title from statictext within u_tabpage_dbmaint_general
end type
type st_logged_in_title from statictext within u_tabpage_dbmaint_general
end type
type st_epro_disabled from statictext within u_tabpage_dbmaint_general
end type
type st_epro_enabled from statictext within u_tabpage_dbmaint_general
end type
type st_epro_status_title from statictext within u_tabpage_dbmaint_general
end type
type st_beta_no from statictext within u_tabpage_dbmaint_general
end type
type st_beta_yes from statictext within u_tabpage_dbmaint_general
end type
type st_1 from statictext within u_tabpage_dbmaint_general
end type
type cb_reset_remote_server from commandbutton within u_tabpage_dbmaint_general
end type
type st_remote_server from statictext within u_tabpage_dbmaint_general
end type
type cb_check_remote_server from commandbutton within u_tabpage_dbmaint_general
end type
type st_database_mode from statictext within u_tabpage_dbmaint_general
end type
type cb_reset_security from commandbutton within u_tabpage_dbmaint_general
end type
type st_security_set from statictext within u_tabpage_dbmaint_general
end type
type cb_sales_demo_prep from commandbutton within u_tabpage_dbmaint_general
end type
type gb_security from groupbox within u_tabpage_dbmaint_general
end type
type gb_remote_service from groupbox within u_tabpage_dbmaint_general
end type
type gb_database_mode from groupbox within u_tabpage_dbmaint_general
end type
type gb_maintenance from groupbox within u_tabpage_dbmaint_general
end type
type gb_client_sessions from groupbox within u_tabpage_dbmaint_general
end type
end forward

global type u_tabpage_dbmaint_general from u_tabpage
integer width = 2894
string text = "General"
cb_check_epie cb_check_epie
st_mode_title st_mode_title
st_check_remote_title st_check_remote_title
st_5 st_5
st_security_strength st_security_strength
st_security_status_title st_security_status_title
rb_new rb_new
rb_old rb_old
cb_sync_data cb_sync_data
cb_reset_database_objects cb_reset_database_objects
st_sessions_total st_sessions_total
st_sessions_not_logged_in st_sessions_not_logged_in
st_sessions_logged_in st_sessions_logged_in
st_total_clients_title st_total_clients_title
st_not_logged_in_title st_not_logged_in_title
st_logged_in_title st_logged_in_title
st_epro_disabled st_epro_disabled
st_epro_enabled st_epro_enabled
st_epro_status_title st_epro_status_title
st_beta_no st_beta_no
st_beta_yes st_beta_yes
st_1 st_1
cb_reset_remote_server cb_reset_remote_server
st_remote_server st_remote_server
cb_check_remote_server cb_check_remote_server
st_database_mode st_database_mode
cb_reset_security cb_reset_security
st_security_set st_security_set
cb_sales_demo_prep cb_sales_demo_prep
gb_security gb_security
gb_remote_service gb_remote_service
gb_database_mode gb_database_mode
gb_maintenance gb_maintenance
gb_client_sessions gb_client_sessions
end type
global u_tabpage_dbmaint_general u_tabpage_dbmaint_general

type variables
boolean login_set


end variables

forward prototypes
public function integer initialize ()
public function integer check_security ()
public function integer set_security_application_role ()
public function integer set_login ()
public function integer clear_login ()
public subroutine refresh ()
public subroutine refresh_user_counts ()
end prototypes

public function integer initialize ();integer li_sts

start_timer(1)

return 1

end function

public function integer check_security ();integer li_count
u_ds_data luo_data
long ll_isapprole
string ls_sys

sqlca.check_database()

// Make sure the cprsystem role exists
if sqlca.is_approle_set then
	st_security_set.text = "Approle OK"
	
	ls_sys = sqlca.sysapp(false)
	if len(ls_sys) = 12 then
		rb_old.checked = true
	else
		rb_new.checked = true
	end if
else
	st_security_set.text = "Approle Not Set"
end if

DESTROY luo_data

return 1


end function

public function integer set_security_application_role ();long ll_count
integer li_sts
string ls_login
string ls_password
string ls_password_e
string ls_user
string ls_role
string ls_null
integer li_count
string ls_sql
string ls_temp
long ll_isapprole
long ll_issqlrole
long ll_sts
integer li_index
boolean lb_approle_exists

DECLARE lsp_droprole PROCEDURE FOR dbo.sp_droprole
         @rolename = :ls_role
USING sqlca;

DECLARE lsp_droprolemember PROCEDURE FOR dbo.sp_droprolemember
         @rolename = :ls_role,
			@membername = :ls_login
USING sqlca;

DECLARE lsp_addapprole PROCEDURE FOR dbo.sp_addapprole
         @rolename = :ls_role,
			@password = :ls_password
USING sqlca;

DECLARE lsp_grantdbaccess PROCEDURE FOR dbo.sp_grantdbaccess
         @loginame = :ls_login
USING sqlca;

DECLARE lsp_dropuser PROCEDURE FOR dbo.sp_dropuser
         @name_in_db = :ls_user
USING sqlca;

setnull(ls_null)

li_index = f_please_wait_open( )

ls_role = sqlca.application_role
ls_login = "jmjtech"
ls_user = "jmjtech"

if rb_new.checked then
	// Generate a new random password every time this method is invoked
	ls_password = f_strong_pw(32)
else
	ls_password = sqlca.sysapp(true)
end if


// Drop the existing role if it exists
lb_approle_exists = false

SELECT issqlrole, isapprole
INTO :ll_issqlrole, :ll_isapprole
FROM sysusers
WHERE name = 'CPRSystem';
if sqlca.sqlnrows = 1 then
	if ll_isapprole = 1 then
		lb_approle_exists = true
	else
		// If the role is not an application role then drop the role and recreate it
		EXECUTE lsp_droprolemember;
		EXECUTE lsp_droprole;
		if not sqlca.check() then
			f_please_wait_close(li_index)
			openwithparm(w_pop_message, "Dropping the sql role failed.")
			return -1
		end if
	end if
end if

if not lb_approle_exists then
	// Create the application role
	ls_sql = "CREATE APPLICATION ROLE " + sqlca.application_role
	ls_sql += " WITH PASSWORD = '" + ls_password + "'"
	EXECUTE IMMEDIATE :ls_sql USING sqlca;
	if not sqlca.check() then
		f_please_wait_close(li_index)
		openwithparm(w_pop_message, "Creating the application role failed.")
		return -1
	end if
end if

// Make sure the Schema exists
SELECT count(*)
INTO :ll_count
FROM sys.schemas
WHERE name = :sqlca.application_role;
if not sqlca.check() then
	f_please_wait_close(li_index)
	openwithparm(w_pop_message, "Checking schema failed.")
	return -1
end if

if ll_count = 0 then
	ls_sql = "CREATE SCHEMA " + sqlca.application_role
	ls_sql += " AUTHORIZATION " + sqlca.application_role
	EXECUTE IMMEDIATE :ls_sql USING sqlca;
	if not sqlca.check() then
		f_please_wait_close(li_index)
		openwithparm(w_pop_message, "Dropping the application role failed.")
		return -1
	end if
end if	


// Set the schema and password
ls_sql = "ALTER APPLICATION ROLE " + sqlca.application_role
ls_sql += " WITH PASSWORD = '" + ls_password + "'"
ls_sql += " , DEFAULT_SCHEMA = " + sqlca.application_role
EXECUTE IMMEDIATE :ls_sql USING sqlca;
if not sqlca.check() then
	f_please_wait_close(li_index)
	openwithparm(w_pop_message, "Creating the application role failed.")
	return -1
end if

ls_password_e = common_thread.eprolibnet4.encryptstring(ls_password, common_thread.key())

INSERT INTO o_Preferences (
	preference_type,
	preference_level,
	preference_key,
	preference_id)
SELECT 'SYSTEM',
			'Global',
			'Global',
			'system_bitmap'
FROM c_1_record
WHERE NOT EXISTS (
	SELECT 1
	FROM o_Preferences
	WHERE preference_level = 'Global'
	AND preference_key = 'Global'
	AND preference_id = 'system_bitmap');
if sqlca.sqlcode <> 0 then
	f_please_wait_close(li_index)
	openwithparm(w_pop_message, "Creating the application role failed (2).")
	return -1
end if

UPDATE p
SET preference_value = :ls_password_e
FROM o_Preferences p
WHERE p.preference_level = 'Global'
AND p.preference_key = 'Global'
AND p.preference_id = 'system_bitmap';
if sqlca.sqlcode <> 0 then
	f_please_wait_close(li_index)
	openwithparm(w_pop_message, "Creating the application role failed (3).")
	return -1
end if

// Set the object permissions
li_sts = sqlca.reset_permissions()
if li_sts < 0 then
	f_please_wait_close(li_index)
	openwithparm(w_pop_message, "Executing the permissions script failed.")
	return -1
end if

f_please_wait_close(li_index)

return 1


end function

public function integer set_login ();integer li_sts
string ls_login
string ls_password
string ls_user
string ls_role
string ls_null
integer li_count
string ls_sql
string ls_temp
long ll_isapprole
long ll_issqlrole
w_pop_please_wait lw_wait


setnull(ls_null)

open(lw_wait, "w_pop_please_wait")

ls_role = sqlca.application_role
ls_login = "jmjtech"
ls_user = "jmjtech"
ls_password = sqlca.sys(ls_login)

// If SQL authentication is available then make sure the login exists
if sqlca.sql_authentication then
	SELECT count(*)
	INTO :li_count
	FROM master.dbo.syslogins
	WHERE name = :ls_login
	USING sqlca;
	if not sqlca.check() then
		close(lw_wait)
		openwithparm(w_pop_message, "Checking the login failed.")
		return -1
	end if
	
	ls_password = sqlca.sys(ls_user)
	if li_count = 0 then
		li_sts = sqlca.sp_addlogin( ls_login, ls_password)
		if li_sts <> 0 then
			close(lw_wait)
			openwithparm(w_pop_message, "Adding the login failed.")
			return -1
		end if
	else
		li_sts = sqlca.sp_password(ls_null, ls_password, ls_login)
		if li_sts <> 0 then
			close(lw_wait)
			openwithparm(w_pop_message, "Setting the login password failed.")
			return -1
		end if
	end if

	// Now drop the jmjtech user from the database and then grant access to the database
	li_sts = sqlca.sp_dropuser(ls_login)
	
	li_sts = sqlca.sp_grantdbaccess(ls_login)
	if li_sts <> 0 then
		close(lw_wait)
		openwithparm(w_pop_message, "Granting db access failed.")
		return -1
	end if
end if


// See if the cprsystem role exists
SELECT issqlrole, isapprole
INTO :ll_issqlrole, :ll_isapprole
FROM sysusers
WHERE name = 'CPRSystem';
if sqlca.sqlcode < 0 then
	close(lw_wait)
	openwithparm(w_pop_message, "Checking the role failed.")
	return -1
elseif sqlca.sqlcode = 100 then
	close(lw_wait)
	openwithparm(w_pop_message, "The login has been set but the CPRSystem Role does not exist.")
	return 1
else
	if ll_isapprole = 0 then
		// If the role is not an application role then add the login to the role

		// First drop the user from the role
		li_sts = sqlca.sp_droprolemember(ls_role, ls_login)
		if li_sts <> 0 then
			close(lw_wait)
			openwithparm(w_pop_message, "Dropping the role membership failed.")
			return -1
		end if
		
		// Then add the user back to the role
		li_sts = sqlca.sp_addrolemember(ls_role, ls_login)
		if li_sts <> 0 then
			close(lw_wait)
			openwithparm(w_pop_message, "Adding the role membership failed.")
			return -1
		end if
	end if
end if

close(lw_wait)

return 1


end function

public function integer clear_login ();integer li_sts
string ls_login
string ls_password
string ls_user
string ls_role
string ls_null
integer li_count
u_ds_data luo_data
string ls_sql
string ls_temp
long ll_isapprole
w_pop_please_wait lw_wait

DECLARE lsp_droplogin PROCEDURE FOR dbo.sp_droplogin  
         @loginame = :ls_login
USING sqlca;

DECLARE lsp_dropuser PROCEDURE FOR dbo.sp_dropuser
         @name_in_db = :ls_user
USING sqlca;

setnull(ls_null)

open(lw_wait, "w_pop_please_wait")

ls_role = sqlca.application_role
ls_login = "jmjtech"
ls_user = "jmjtech"
ls_password = sqlca.sys(ls_role)

// If SQL authentication is available then make sure the login exists
if sqlca.sql_authentication then
	EXECUTE lsp_dropuser;
	
	EXECUTE lsp_droplogin;
	if sqlca.sqlcode < 0 then
		openwithparm(w_pop_message, sqlca.sqlerrtext)
		close(lw_wait)
		return -1
	end if
end if

close(lw_wait)

return 1


end function

public subroutine refresh ();long ll_total
integer li_sts

li_sts = check_security()

if sqlca.check_remote_server() then
	st_remote_server.text = "Set"
else
	st_remote_server.text = "Not Set"
end if

if len(sqlca.actual_database_mode) > 0 then
	st_database_mode.text = wordcap(sqlca.actual_database_mode)
else
	st_database_mode.text = "None"
end if

if sqlca.beta_flag then
	st_beta_yes.backcolor = color_object_selected	
	st_beta_no.backcolor = color_object
else
	st_beta_yes.backcolor = color_object
	st_beta_no.backcolor = color_object_selected
end if

if sqlca.database_status = "OK" then
	st_epro_enabled.backcolor = color_object_selected	
	st_epro_disabled.backcolor = color_object
else
	st_epro_enabled.backcolor = color_object
	st_epro_disabled.backcolor = color_object_selected
end if

if sqlca.is_dbmode("Demonstration") then
	cb_sales_demo_prep.visible = true
else
	cb_sales_demo_prep.visible = false
end if

if sqlca.modification_level >= 132 then
	cb_sync_data.visible = true
else
	cb_sync_data.visible = false
end if

refresh_user_counts()


end subroutine

public subroutine refresh_user_counts ();long ll_total
long ll_logged_in
integer li_sts

if sqlca.sql_version <= 8 then
	// user counts are only available with sql2005 and later
	st_sessions_total.text = "NA"
	st_sessions_logged_in.text = "NA"
	st_sessions_not_logged_in.text = "NA"
	return
end if


select count(*)
into :ll_total
from sys.sysprocesses p
	inner join sys.databases d
	on p.dbid = d.database_id
	inner join sys.database_principals u
	on p.uid = u.principal_id
where d.name = :sqlca.database
and u.name = :sqlca.application_role;
if not tf_check() then setnull(ll_total)

st_sessions_total.text = string(ll_total)



select count(*)
into :ll_logged_in
from sys.sysprocesses p
	inner join sys.databases d
	on p.dbid = d.database_id
	inner join sys.database_principals u
	on p.uid = u.principal_id
	inner join o_computers c
	on c.computername = p.hostname
	and c.logon_id = p.nt_username
	inner join o_users l
	on l.computer_id = c.computer_id
where d.name = :sqlca.database
and u.name = :sqlca.application_role;
if not tf_check() then setnull(ll_logged_in)

st_sessions_logged_in.text = string(ll_logged_in)
st_sessions_not_logged_in.text = string(ll_total - ll_logged_in)







end subroutine

on u_tabpage_dbmaint_general.create
int iCurrent
call super::create
this.cb_check_epie=create cb_check_epie
this.st_mode_title=create st_mode_title
this.st_check_remote_title=create st_check_remote_title
this.st_5=create st_5
this.st_security_strength=create st_security_strength
this.st_security_status_title=create st_security_status_title
this.rb_new=create rb_new
this.rb_old=create rb_old
this.cb_sync_data=create cb_sync_data
this.cb_reset_database_objects=create cb_reset_database_objects
this.st_sessions_total=create st_sessions_total
this.st_sessions_not_logged_in=create st_sessions_not_logged_in
this.st_sessions_logged_in=create st_sessions_logged_in
this.st_total_clients_title=create st_total_clients_title
this.st_not_logged_in_title=create st_not_logged_in_title
this.st_logged_in_title=create st_logged_in_title
this.st_epro_disabled=create st_epro_disabled
this.st_epro_enabled=create st_epro_enabled
this.st_epro_status_title=create st_epro_status_title
this.st_beta_no=create st_beta_no
this.st_beta_yes=create st_beta_yes
this.st_1=create st_1
this.cb_reset_remote_server=create cb_reset_remote_server
this.st_remote_server=create st_remote_server
this.cb_check_remote_server=create cb_check_remote_server
this.st_database_mode=create st_database_mode
this.cb_reset_security=create cb_reset_security
this.st_security_set=create st_security_set
this.cb_sales_demo_prep=create cb_sales_demo_prep
this.gb_security=create gb_security
this.gb_remote_service=create gb_remote_service
this.gb_database_mode=create gb_database_mode
this.gb_maintenance=create gb_maintenance
this.gb_client_sessions=create gb_client_sessions
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_check_epie
this.Control[iCurrent+2]=this.st_mode_title
this.Control[iCurrent+3]=this.st_check_remote_title
this.Control[iCurrent+4]=this.st_5
this.Control[iCurrent+5]=this.st_security_strength
this.Control[iCurrent+6]=this.st_security_status_title
this.Control[iCurrent+7]=this.rb_new
this.Control[iCurrent+8]=this.rb_old
this.Control[iCurrent+9]=this.cb_sync_data
this.Control[iCurrent+10]=this.cb_reset_database_objects
this.Control[iCurrent+11]=this.st_sessions_total
this.Control[iCurrent+12]=this.st_sessions_not_logged_in
this.Control[iCurrent+13]=this.st_sessions_logged_in
this.Control[iCurrent+14]=this.st_total_clients_title
this.Control[iCurrent+15]=this.st_not_logged_in_title
this.Control[iCurrent+16]=this.st_logged_in_title
this.Control[iCurrent+17]=this.st_epro_disabled
this.Control[iCurrent+18]=this.st_epro_enabled
this.Control[iCurrent+19]=this.st_epro_status_title
this.Control[iCurrent+20]=this.st_beta_no
this.Control[iCurrent+21]=this.st_beta_yes
this.Control[iCurrent+22]=this.st_1
this.Control[iCurrent+23]=this.cb_reset_remote_server
this.Control[iCurrent+24]=this.st_remote_server
this.Control[iCurrent+25]=this.cb_check_remote_server
this.Control[iCurrent+26]=this.st_database_mode
this.Control[iCurrent+27]=this.cb_reset_security
this.Control[iCurrent+28]=this.st_security_set
this.Control[iCurrent+29]=this.cb_sales_demo_prep
this.Control[iCurrent+30]=this.gb_security
this.Control[iCurrent+31]=this.gb_remote_service
this.Control[iCurrent+32]=this.gb_database_mode
this.Control[iCurrent+33]=this.gb_maintenance
this.Control[iCurrent+34]=this.gb_client_sessions
end on

on u_tabpage_dbmaint_general.destroy
call super::destroy
destroy(this.cb_check_epie)
destroy(this.st_mode_title)
destroy(this.st_check_remote_title)
destroy(this.st_5)
destroy(this.st_security_strength)
destroy(this.st_security_status_title)
destroy(this.rb_new)
destroy(this.rb_old)
destroy(this.cb_sync_data)
destroy(this.cb_reset_database_objects)
destroy(this.st_sessions_total)
destroy(this.st_sessions_not_logged_in)
destroy(this.st_sessions_logged_in)
destroy(this.st_total_clients_title)
destroy(this.st_not_logged_in_title)
destroy(this.st_logged_in_title)
destroy(this.st_epro_disabled)
destroy(this.st_epro_enabled)
destroy(this.st_epro_status_title)
destroy(this.st_beta_no)
destroy(this.st_beta_yes)
destroy(this.st_1)
destroy(this.cb_reset_remote_server)
destroy(this.st_remote_server)
destroy(this.cb_check_remote_server)
destroy(this.st_database_mode)
destroy(this.cb_reset_security)
destroy(this.st_security_set)
destroy(this.cb_sales_demo_prep)
destroy(this.gb_security)
destroy(this.gb_remote_service)
destroy(this.gb_database_mode)
destroy(this.gb_maintenance)
destroy(this.gb_client_sessions)
end on

event timer_ding;refresh_user_counts()

end event

type cb_check_epie from commandbutton within u_tabpage_dbmaint_general
integer x = 1870
integer y = 420
integer width = 567
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Check EpIE"
end type

event clicked;integer li_sts
long ll_sts
long rVal
real amount
string ls_templog
string ls_usr
string ls_pwd_e
string ls_pwd
string ls_options
string ls_ipaddr
long i
any la_rtn
long lLog
string ls_customer_id
string ls_results_xml
u_xml_document pbdom_doc
u_xml_document pbdom_new_doc
PBDOM_ELEMENT pbdom_root
PBDOM_ELEMENT pbdom_element_array[]
string ls_root
SoapConnection conn // Define SoapConnection
EpieGateway_service EpIE_Gateway // Declare proxy
epiegateway_credentialsheader credentials
long ll_null
string ls_null
string ls_error

setnull(ls_null)
setnull(ll_null)

conn = create SoapConnection  //Instantiated connection

ls_usr = sqlca.fn_get_preference( "SYSTEM", "epie_user", ls_null, ll_null)
ls_pwd_e = sqlca.fn_get_preference( "SYSTEM", "epie_pwd", ls_null, ll_null)
ls_pwd = common_thread.eprolibnet4.decryptstring(ls_pwd_e, common_thread.key())

ll_sts = conn.SetSoapLogFile (ls_templog) 

rVal = Conn.CreateInstance(EpIE_Gateway, "EpieGateway_service")
if rVal <> 0 then
	log.log(this, "xx_initialize()", "Creating SOAP proxy failed (" + string(rVal) + ")", 4)
	destroy conn
	return -1
end if

credentials = CREATE epiegateway_credentialsheader
credentials.user = ls_usr
credentials.password = ls_pwd
setnull(credentials.actor)
setnull(credentials.encodedmustunderstand)
setnull(credentials.encodedmustunderstand12)
setnull(credentials.encodedrelay)
setnull(credentials.role)

EpIE_Gateway.setcredentialsheadervalue(credentials)

ls_customer_id = string(sqlca.customer_id)

// Get Message Bag
ls_results_xml = ""
TRY
	ls_results_xml = EpIE_Gateway.getcustomerepieinterface(sqlca.customer_id)
	ls_error = ""
CATCH ( SoapException lt_error )
	log.log(this, "xx_do_source()", "Error calling EpIE download gateway (" + lt_error.text + ")", 4)
	ls_error = lt_error.text
	ls_results_xml = ""
END TRY

if len(ls_results_xml) > 0 then
	openwithparm(w_pop_message, "The EpIE gateway is available")
elseif len(ls_error) > 0 then
	openwithparm(w_pop_message, "The EpIE gateway is NOT available (" + ls_error + ")")
else
	openwithparm(w_pop_message, "The EpIE gateway did not return an error but did not return any data")
end if

end event

type st_mode_title from statictext within u_tabpage_dbmaint_general
integer x = 137
integer y = 916
integer width = 215
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Mode:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_check_remote_title from statictext within u_tabpage_dbmaint_general
integer x = 1618
integer y = 336
integer width = 215
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Check:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within u_tabpage_dbmaint_general
integer x = 1618
integer y = 208
integer width = 215
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_security_strength from statictext within u_tabpage_dbmaint_general
integer x = 169
integer y = 336
integer width = 279
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Strength:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_security_status_title from statictext within u_tabpage_dbmaint_general
integer x = 233
integer y = 200
integer width = 215
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_new from radiobutton within u_tabpage_dbmaint_general
integer x = 485
integer y = 416
integer width = 649
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Version 5"
end type

type rb_old from radiobutton within u_tabpage_dbmaint_general
integer x = 485
integer y = 328
integer width = 448
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Version 4"
end type

type cb_sync_data from commandbutton within u_tabpage_dbmaint_general
integer x = 1349
integer y = 1036
integer width = 416
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sync Content"
end type

event clicked;str_popup_return popup_return
integer li_sts
integer li_idx

openwithparm(w_pop_yes_no, "Are you sure you want to sync the common data tables?  This may take several minutes.")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

li_idx = f_please_wait_open()
sqlca.jmjsys_daily_sync()
if not tf_check() then
	openwithparm(w_pop_message, "Sync Data Failed.")
else
	openwithparm(w_pop_message, "Sync Data Succeeded.")
end if

f_please_wait_close(li_idx)


end event

type cb_reset_database_objects from commandbutton within u_tabpage_dbmaint_general
integer x = 1202
integer y = 1236
integer width = 704
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reset Database Objects"
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_choice

openwithparm(w_pop_yes_no, "Are you sure you want to reset the database objects?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

popup.data_row_count = 2
popup.title = "Resetting the database objects may hang if any ACCESS tables are open, or if anyone is holding locks on any of the database tables."
popup.items[1] = "Reset Database Objects"
popup.items[2] = "Cancel"
openwithparm(w_pop_choices_2, popup)
ll_choice = message.doubleparm
if ll_choice = 2 then return

li_sts = sqlca.reset_database_objects()
if li_sts <= 0 then
	openwithparm(w_pop_message, "Resetting Database Objects Failed.")
else
	openwithparm(w_pop_message, "Resetting Database Objects Succeeded.")
end if


end event

type st_sessions_total from statictext within u_tabpage_dbmaint_general
integer x = 2519
integer y = 1048
integer width = 265
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_sessions_not_logged_in from statictext within u_tabpage_dbmaint_general
integer x = 2519
integer y = 956
integer width = 265
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_sessions_logged_in from statictext within u_tabpage_dbmaint_general
integer x = 2519
integer y = 864
integer width = 265
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_total_clients_title from statictext within u_tabpage_dbmaint_general
integer x = 2126
integer y = 1052
integer width = 370
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Total"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_not_logged_in_title from statictext within u_tabpage_dbmaint_general
integer x = 2126
integer y = 960
integer width = 370
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Not Logged In"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_logged_in_title from statictext within u_tabpage_dbmaint_general
integer x = 2126
integer y = 868
integer width = 370
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Logged In"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_epro_disabled from statictext within u_tabpage_dbmaint_general
integer x = 1797
integer y = 852
integer width = 155
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return popup_return


openwithparm(w_pop_yes_no, "Are you sure you want to disable this installation?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


openwithparm(w_pop_yes_no, "Disabling this installation will force all users to exit EncounterPRO.  Are you sure you want to disable this installation?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


sqlca.set_database_status("NA")

refresh()


end event

type st_epro_enabled from statictext within u_tabpage_dbmaint_general
integer x = 1595
integer y = 852
integer width = 155
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return popup_return


openwithparm(w_pop_yes_no, "Are you sure you want to enable this installation?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

sqlca.set_database_status("OK")

refresh()


end event

type st_epro_status_title from statictext within u_tabpage_dbmaint_general
integer x = 1138
integer y = 864
integer width = 411
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Allow Clients:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_beta_no from statictext within u_tabpage_dbmaint_general
integer x = 736
integer y = 1044
integer width = 210
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return popup_return
string ls_release_status
string ls_mod_level

if not sqlca.beta_flag then
	openwithparm(w_pop_message, "This installation is already NOT a beta site.")
	return
end if

openwithparm(w_pop_yes_no, "Are you sure you want to make this installation a non-beta site?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

// Make sure the local mod level is not higher than the latest production mod level.  If it is then this site must remain a "beta site"
// until the local mod level is released to production.  This is because databases can never go backwards in mod level
ls_mod_level = string(sqlca.modification_level)
SELECT min(release_status)
INTO :ls_release_status
FROM c_Component_Version v
WHERE v.component_id = 'Database'
AND compile_name = :ls_mod_level;
if not tf_check() then return
if sqlca.sqlnrows = 0 then
	// If no version found then assume production
	ls_release_status = "Production"
end if

if lower(sqlca.database_status) = "production" and lower(ls_release_status) <> "production" then
	openwithparm(w_pop_message, "You may not turn off the beta status until the current mod level is released to production")
	return 
end if

sqlca.set_beta_status(false)

parent_tab.initialize()

refresh()


end event

type st_beta_yes from statictext within u_tabpage_dbmaint_general
integer x = 498
integer y = 1044
integer width = 210
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup_return popup_return


openwithparm(w_pop_yes_no, "Are you sure you want to make this installation a beta site?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return


sqlca.set_beta_status(true)

parent_tab.initialize()

refresh()


end event

type st_1 from statictext within u_tabpage_dbmaint_general
integer x = 110
integer y = 1056
integer width = 361
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Beta Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_reset_remote_server from commandbutton within u_tabpage_dbmaint_general
integer x = 1870
integer y = 536
integer width = 645
integer height = 88
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reset Remote Server"
end type

event clicked;integer li_sts
string ls_message

li_sts = sqlca.set_remote_server()
if li_sts > 0 then
	ls_message = "Remote Server Set"
else
	ls_message = "Remote Server Not Set.  Check event viewer for error messages."
end if

openwithparm(w_pop_message, ls_message)

refresh()

end event

type st_remote_server from statictext within u_tabpage_dbmaint_general
integer x = 1870
integer y = 192
integer width = 722
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Not Set"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_check_remote_server from commandbutton within u_tabpage_dbmaint_general
integer x = 1870
integer y = 328
integer width = 567
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Check Remote Server"
end type

event clicked;integer li_sts
string ls_message
string ls_temp

SELECT current_version
INTO :ls_temp
FROM jmjtech.epro_40_synch.dbo.c_Database_System
WHERE system_id = 'Database';
if not tf_check() then
	ls_message = "Error contacting remote server.  See event viewer for error messages."
elseif sqlca.sqlcode = 100 then
	ls_message = "Error Retrieving Information From Remote Server"
else
	ls_message = "Remote Server Available"
end if

openwithparm(w_pop_message, ls_message)

refresh()

end event

type st_database_mode from statictext within u_tabpage_dbmaint_general
integer x = 379
integer y = 904
integer width = 567
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Demonstration"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_reset_security from commandbutton within u_tabpage_dbmaint_general
integer x = 485
integer y = 536
integer width = 645
integer height = 88
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reset Security"
end type

event clicked;integer li_sts

li_sts = set_security_application_role()
if li_sts < 0 then
	openwithparm(w_pop_message, "Set Security Failed")
else
	openwithparm(w_pop_message, "Set Security Succeeded")
end if


check_security()

end event

type st_security_set from statictext within u_tabpage_dbmaint_general
integer x = 485
integer y = 184
integer width = 722
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_sales_demo_prep from commandbutton within u_tabpage_dbmaint_general
integer x = 82
integer y = 1312
integer width = 558
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Sales Demo Prep"
end type

event clicked;integer li_sts

DECLARE lsp_sales_demo_prep PROCEDURE FOR dbo.sp_sales_demo_prep  ;

EXECUTE lsp_sales_demo_prep;
if not tf_check() then
	openwithparm(w_pop_message, "Sales Demo Prep Failed")
	return
end if


openwithparm(w_pop_message, "Sales Demo Prep Succeeded")


end event

type gb_security from groupbox within u_tabpage_dbmaint_general
integer x = 137
integer y = 88
integer width = 1143
integer height = 580
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Security"
end type

type gb_remote_service from groupbox within u_tabpage_dbmaint_general
integer x = 1522
integer y = 96
integer width = 1143
integer height = 580
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Remote Server"
end type

type gb_database_mode from groupbox within u_tabpage_dbmaint_general
integer x = 78
integer y = 756
integer width = 937
integer height = 496
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Database Mode"
end type

type gb_maintenance from groupbox within u_tabpage_dbmaint_general
integer x = 1083
integer y = 756
integer width = 946
integer height = 648
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Maintenance/Troubleshooting"
end type

type gb_client_sessions from groupbox within u_tabpage_dbmaint_general
integer x = 2098
integer y = 756
integer width = 731
integer height = 428
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Client Sessions"
end type

