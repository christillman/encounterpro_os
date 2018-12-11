$PBExportHeader$u_config_object_manager.sru
forward
global type u_config_object_manager from oleobject
end type
end forward

global type u_config_object_manager from oleobject
end type
global u_config_object_manager u_config_object_manager

forward prototypes
public function integer initialize_com ()
end prototypes

public function integer initialize_com ();integer li_sts
string ls_com_class

ls_com_class = "EPConfigObjects.ConfigObjectManager"

li_sts = connecttonewobject(ls_com_class)
if li_sts <> 0 then
	log.log(this, "u_config_object_manager.initialize_com:0008", "Error connecting to com source (" + ls_com_class + ", " + string(li_sts) + ")", 4)
	return -1
end if


TRY
	if lower(sqlca.connected_using) = "windows" then
		this.Initialize(sqlca.servername , &
						sqlca.database , &
						"", &
						"", &
						true, &
						sqlca.application_role , &
						sqlca.sys(sqlca.application_role))
	else
		this.Initialize(sqlca.servername , &
						sqlca.database , &
						sqlca.logid, &
						sqlca.logpass, &
						false, &
						sqlca.application_role , &
						sqlca.sys(sqlca.application_role))
	end if
CATCH (throwable lt_error)
	log.log(this, "u_config_object_manager.initialize_com:0032", "Error calling Initialize (" + lt_error.text + ")", 4)
	return -1
END TRY


//public void Initialize(string SqlServer, string SqlDatabase,
//            string SqlUser, string SqlPassword, bool TrustedConnection,
//            string SqlAppRole, string SqlAppRolePassword)

// ProgID is EPConfigObjects.ConfigObjectManager

// Initialize		Initialization method for ConfigObjectManager.  Nothing will work properly
//					until this method is called.
//
// <param name="SqlServer">Name of the SQL instance in ActiveDirectory
// or IP[:port] for a remote server</param>
// <param name="SqlDatabase">Name of the EncounterPRO database</param>
// <param name="SqlUser">Only for MSSQL authentication; pass
// null or empty string when using Windows authentication</param>
// <param name="SqlPassword">Only for MSSQL authentication; pass
// null or empty string when using Windows authentication</param>
// <param name="TrustedConnection">True for Windows authentication;
// false for MSSQL authentication</param>
// <param name="SqlAppRole">Name of application role to activate; 
// if not using application role, pass null or empty string</param>
// <param name="SqlAppRolePassword">Password for application role;
// if not using application role, pass null or empty string</param>
//        public void Initialize(string SqlServer, string SqlDatabase,
//            string SqlUser, string SqlPassword, bool TrustedConnection,
//            string SqlAppRole, string SqlAppRolePassword)
//
// GetConfigObjectXml     Produces XML for the specified EncounterPRO Config Object.
//
// <param name="ObjectType"></param>
// <param name="ObjectId"></param>
//        public string GetConfigObjectXml(string ObjectType, string ObjectId)



return 1

end function

on u_config_object_manager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_config_object_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

