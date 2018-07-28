CREATE PROCEDURE jmj_log_backups
AS

SET NOCOUNT ON


-- Log the recent database backups
DECLARE	@ls_server varchar(40),
		@ls_database_name varchar(40),
		@ll_db_revision int,
		@ls_logon_id varchar(40),
		@ls_computername varchar(40)


IF NOT EXISTS (	SELECT 1
				FROM master..sysdatabases
				WHERE name = 'msdb')
	RETURN 0


SELECT @ll_db_revision = modification_level,
	@ls_server = CAST(ServerProperty('ServerName') AS varchar(40)),
	@ls_database_name = db_name(db_id()),
	@ls_computername = CAST(HOST_NAME() AS varchar(40)),
	@ls_logon_id = system_user
FROM c_database_status

-- See if the logon_id has a domain
IF CHARINDEX('\', @ls_logon_id) > 0
	SET @ls_logon_id = SUBSTRING(@ls_logon_id, CHARINDEX('\', @ls_logon_id) + 1, 40)

INSERT INTO dbo.c_Database_Maintenance (
		logon_id,
		computername,
		server,
		database_name,
		action,
		completion_status,
		action_date,
		action_argument,
		db_revision)
SELECT	@ls_logon_id,
		@ls_computername,
		@ls_server,
		@ls_database_name,
		action = CASE type WHEN 'D' THEN 'Full' Else 'Log' END + ' Backup',
		'OK',
		action_date = backup_finish_date,
		action_argument = name,
		@ll_db_revision
FROM msdb..backupset b
WHERE database_name = @ls_database_name
AND NOT EXISTS (
	SELECT 1
	FROM c_Database_Maintenance m
	WHERE m.action_date = b.backup_finish_date
	AND m.action_argument = b.name
	)


