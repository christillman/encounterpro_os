CREATE PROCEDURE jmj_log_database_maintenance (
		@ps_action varchar(24),
		@ps_completion_status varchar(12),
		@ps_action_argument varchar(255) = NULL,
		@ps_build varchar(12) = NULL,
		@ps_comment varchar(255) = NULL
		)
AS

DECLARE	@ls_server varchar(40),
		@ls_database_name varchar(40),
		@ll_db_revision int,
		@ls_logon_id varchar(40),
		@ls_computername varchar(40)

SELECT @ll_db_revision = modification_level,
	@ls_server = CAST(ServerProperty('ServerName') AS varchar(40)),
	@ls_database_name = db_name(db_id()),
	@ls_computername = CAST(HOST_NAME() AS varchar(40)),
	@ls_logon_id = system_user
FROM c_database_status

-- See if the logon_id has a domain
IF CHARINDEX('\', @ls_logon_id) > 0
	SET @ls_logon_id = SUBSTRING(@ls_logon_id, CHARINDEX('\', @ls_logon_id) + 1, 40)

INSERT INTO [dbo].[c_Database_Maintenance] (
		logon_id,
		computername,
		server,
		database_name,
		action,
		completion_status,
		action_date,
		action_argument,
		build,
		db_revision,
		comment)
 VALUES (
		@ls_logon_id ,
		@ls_computername ,
		@ls_server ,
		@ls_database_name ,
		@ps_action ,
		@ps_completion_status ,
		getdate() ,
		@ps_action_argument ,
		@ps_build ,
		@ll_db_revision ,
		@ps_comment)


