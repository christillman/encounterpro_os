DROP PROCEDURE [jmjsys_daily_sync]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_daily_sync] (
	@ps_keep_temp_tables char(1) = 'N'
	)
AS

SET NOCOUNT ON

DECLARE @ll_error int,
		@ll_modification_level int,
		@ll_iterations int,
		@ll_rowcount int,
		@ls_tablename varchar(64),
		@ls_sync_algorithm varchar(24),
		@ls_cleanup_temp_files varchar(255),
		@tmptable varchar(128),
		@ll_my_schema_id int

SELECT @ll_my_schema_id = schema_id
FROM sys.schemas
WHERE name = (select COALESCE(default_schema_name, 'dbo') from sys.database_principals where name = USER)


SELECT @ll_modification_level = modification_level
FROM c_Database_Status

IF @ps_keep_temp_tables IS NULL
	BEGIN
	SET @ls_cleanup_temp_files = dbo.fn_get_global_preference('SERVERCONFIG', 'Cleanup Temp Files')
	IF @ls_cleanup_temp_files IS NULL
		SET @ls_cleanup_temp_files = 'Yes'
	END
ELSE IF @ps_keep_temp_tables IN ('Y', 'T')
	SET @ls_cleanup_temp_files = 'N'
ELSE
	SET @ls_cleanup_temp_files = 'Y'


-- Put a marker in the log
PRINT 'Daily Sync Started @ ' + CAST(dbo.get_client_datetime() AS varchar(20)) + '   Mod Level: ' + CAST(@ll_modification_level AS varchar(12)) + ', Cleanup Temp Files = ' + @ls_cleanup_temp_files

IF LEFT(@ls_cleanup_temp_files, 1) IN ('T', 'Y')
	BEGIN
	DECLARE lc_tmptables CURSOR LOCAL FAST_FORWARD FOR
		SELECT	DISTINCT so.name
		FROM 	sys.objects so
		WHERE	so.type = 'U'
		AND so.name LIKE 'tmpjmjsync%'
		AND so.schema_id = @ll_my_schema_id


	OPEN lc_tmptables

	FETCH lc_tmptables INTO @tmptable
	WHILE @@fetch_status = 0
	BEGIN
		EXEC ('DROP TABLE ' + @tmptable)
		FETCH lc_tmptables INTO @tmptable
	END

	CLOSE lc_tmptables
	DEALLOCATE lc_tmptables
	END

-------------------------------------------------------------------------------
-- First sync the database table/column info
-------------------------------------------------------------------------------
EXECUTE jmjsys_sync_table_column_info

SET @ll_error = @@ERROR
IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Sync Content',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END


-------------------------------------------------------------------------------
-- Then sync all the tables that are driven by c_Database_Table.sync_algorithm
-------------------------------------------------------------------------------

DECLARE @synctables TABLE (
	tablename varchar(64) NOT NULL,
	parent_tablename varchar(64) NULL,
	heirarchy_level int NOT NULL DEFAULT (0))

INSERT INTO @synctables (
	tablename ,
	parent_tablename )
SELECT tablename ,
	parent_tablename
FROM c_Database_Table
WHERE sync_algorithm IN ('New and Updated', 'New Only', 'Full Sync')
AND sync_modification_level <= @ll_modification_level

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Sync Content',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

-- Set the heirarchy_level so that parents are always sync'd before their children
SET @ll_iterations = 0
SET @ll_rowcount = 1
WHILE @ll_rowcount > 0
	BEGIN
	SET @ll_iterations = @ll_iterations + 1
	IF @ll_iterations > 100
		BREAK

	UPDATE x1
	SET heirarchy_level = x2.heirarchy_level + 1
	FROM @synctables x1
		INNER JOIN @synctables x2
		ON x1.tablename = x2.parent_tablename
	WHERE x1.heirarchy_level = x2.heirarchy_level

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		BEGIN
		EXECUTE jmj_log_database_maintenance
				@ps_action = 'Sync Content',
				@ps_completion_status = 'Error'
		
		RETURN -1
		END
	END

-- Now sync the tables
DECLARE lc_sync CURSOR LOCAL FAST_FORWARD FOR
	SELECT t.tablename, t.sync_algorithm
	FROM c_Database_Table t
		INNER JOIN @synctables x
		ON t.tablename = x.tablename
	ORDER BY x.heirarchy_level desc, t.tablename

OPEN lc_sync

FETCH lc_sync INTO @ls_tablename, @ls_sync_algorithm
WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE jmjsys_sync_table @ps_tablename = @ls_tablename,
								@ps_sync_type = @ls_sync_algorithm

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		BEGIN
		EXECUTE jmj_log_database_maintenance
				@ps_action = 'Sync Content',
				@ps_completion_status = 'Error'
		
		RETURN -1
		END

	FETCH lc_sync INTO @ls_tablename, @ls_sync_algorithm
	END

CLOSE lc_sync
DEALLOCATE lc_sync


-- Sync c_Domain and c_Domain_Master

EXECUTE jmjsys_sync_domains

SET @ll_error = @@ERROR
IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Sync Content',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

-- Sync the component tables

EXECUTE jmjsys_sync_components

SET @ll_error = @@ERROR
IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Sync Content',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

-- Sync the config objects

EXECUTE jmjsys_sync_config_objects

SET @ll_error = @@ERROR
IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Sync Content',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END


-- Sync the cached preference values
EXECUTE jmjsys_sync_cached_preferences

SET @ll_error = @@ERROR
IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Sync Content',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

-- Sync the params
EXECUTE jmjsys_sync_params

SET @ll_error = @@ERROR
IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Sync Content',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

-- Sync the actors
EXECUTE jmjsys_sync_actors

SET @ll_error = @@ERROR
IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Sync Content',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

-- Sync the diseases
EXECUTE jmjsys_sync_diseases

SET @ll_error = @@ERROR
IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Sync Content',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END

-- Sync the codes
EXECUTE jmjsys_sync_codes

SET @ll_error = @@ERROR
IF @ll_error <> 0
	BEGIN
	EXECUTE jmj_log_database_maintenance
			@ps_action = 'Sync Content',
			@ps_completion_status = 'Error'
	
	RETURN -1
	END


EXECUTE jmj_log_database_maintenance
		@ps_action = 'Sync Content',
		@ps_completion_status = 'OK'


IF LEFT(@ls_cleanup_temp_files, 1) IN ('T', 'Y')
	BEGIN
	DECLARE lc_tmptables CURSOR LOCAL FAST_FORWARD FOR
		SELECT	DISTINCT so.name
		FROM 	sys.objects so
		WHERE	so.type = 'U'
		AND so.name LIKE 'tmpjmjsync%'
		AND so.schema_id = @ll_my_schema_id

	OPEN lc_tmptables

	FETCH lc_tmptables INTO @tmptable
	WHILE @@fetch_status = 0
	BEGIN
		EXEC ('DROP TABLE ' + @tmptable)
		FETCH lc_tmptables INTO @tmptable
	END

	CLOSE lc_tmptables
	DEALLOCATE lc_tmptables
	END

-- Put a marker in the log
PRINT 'Daily Sync Completed @ ' + CAST(dbo.get_client_datetime() AS varchar(20))

RETURN 1

GO
