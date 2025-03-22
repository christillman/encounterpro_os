DROP PROCEDURE [jmjsys_sync_table]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--
--
--
-- @ps_sync_type values:	'New and Updated'		Sync only records that are new (based on
--													guid field called "ID", and records that
--													have changed, based on datetime field called
--													'last_updated' or 'last_update' or 'modified'
--							'New Only'				Sync only records that are new.  If guid
--													field called "ID" exists, use it.  Otherwise
--													use primary key.
--							'Full Sync'				Update all records regardless of date
--													Add new records
--													Delete records that don't exist anymore
--
--

CREATE PROCEDURE [jmjsys_sync_table] (
	@ps_tablename varchar(64),
	@ps_sync_tablename varchar(128) = NULL,
	@ps_sync_type varchar(24) = 'New and Updated',
	@ps_use_datestamp char(1) = 'N',
	@ps_overwrite_collisions char(1) = 'N'
	)
AS

SET NOCOUNT ON

DECLARE @ls_temp_tablename varchar(128) ,
	@ls_primary_key_where_clause varchar(4000) ,
	@ls_insert_column_list varchar(4000) ,
	@ls_select_column_list varchar(4000) ,
	@ls_update_set_clause varchar(4000) ,
	@ls_sql varchar(4000),
	@ll_error int,
	@ll_id_exists int,
	@ll_owner_id_exists int,
	@ldt_datestamp datetime,
	@ldt_sync_datetime datetime,
	@ls_sync_tablename varchar(64)

SET @ls_sync_tablename = 'Sync ' + @ps_tablename

IF @ps_use_datestamp = 'Y'
	SELECT @ldt_datestamp = last_updated
	FROM c_Table_Update
	WHERE table_name = @ls_sync_tablename
ELSE
	SET @ldt_datestamp = NULL


-- Put a marker in the log
PRINT 'Sync Starting: ' + @ps_tablename + '   ' + CAST(dbo.get_client_datetime() AS varchar(20))

-- We only allow this sync routine for tables with an ID field
IF EXISTS (SELECT 1
				FROM c_Database_Column
				WHERE tablename = @ps_tablename
				AND columnname = 'ID')
	SET @ll_id_exists = 1
ELSE
	SET @ll_id_exists = 0


IF EXISTS (SELECT 1
				FROM c_Database_Column
				WHERE tablename = @ps_tablename
				AND columnname = 'owner_id')
	SET @ll_owner_id_exists = 1
ELSE
	SET @ll_owner_id_exists = 0

-- Get the current datetime to use as the next datestamp if this sync ends up being successful
SET @ldt_sync_datetime = dbo.get_client_datetime()

IF @ps_sync_type = 'New and Updated'
	BEGIN

	IF @ll_id_exists = 1
		BEGIN
		EXECUTE jmjsys_get_sync_table_data
			@ps_tablename = @ps_tablename,
			@ps_sync_tablename = @ps_sync_tablename,
			@ps_ids_only = 'N',
			@ps_new_flag = 'Y',
			@ps_updated_flag = 'Y',
			@ps_all_flag = 'N',
			@ps_temp_tablename = @ls_temp_tablename OUTPUT,
			@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
			@ps_update_set_clause = @ls_update_set_clause OUTPUT,
			@ps_insert_column_list = @ls_insert_column_list OUTPUT,
			@ps_select_column_list = @ls_select_column_list OUTPUT,
			@pdt_since_datestamp = @ldt_datestamp

		-- If we need to overwrite the collisions then delete them here
		IF @ps_overwrite_collisions = 'Y' AND LEN(@ls_primary_key_where_clause) > 0
			BEGIN
			-- Process new records but ignore records with primary key collisions
			SET @ls_sql = 'DELETE t '
			SET @ls_sql = @ls_sql + ' FROM ' + @ps_tablename + ' t '
			SET @ls_sql = @ls_sql + ' WHERE EXISTS (SELECT 1 FROM ' + @ls_temp_tablename + '_new x '
			SET @ls_sql = @ls_sql + '                   WHERE ' + @ls_primary_key_where_clause + ')'

			-- Execute the data transfer script
			EXECUTE (@ls_sql)
			SET @ll_error = @@ERROR
			IF @ll_error <> 0
				RETURN -1
			END

		-- Process new records but ignore records with primary key collisions
		SET @ls_sql = 'INSERT INTO ' + @ps_tablename + '(' + @ls_insert_column_list + ')'
		SET @ls_sql = @ls_sql + ' SELECT ' + @ls_select_column_list
		SET @ls_sql = @ls_sql + ' FROM ' + @ls_temp_tablename + '_new x'
		IF LEN(@ls_primary_key_where_clause) > 0
			BEGIN
			SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ps_tablename + ' t '
			SET @ls_sql = @ls_sql + '                   WHERE ' + @ls_primary_key_where_clause + ')'
			END

		-- Execute the data transfer script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1

		-- Process update records
		IF LEN(@ls_update_set_clause) > 0
			BEGIN
			SET @ls_sql = 'UPDATE t SET ' + @ls_update_set_clause
			SET @ls_sql = @ls_sql + ' FROM ' + @ps_tablename + ' t '
			SET @ls_sql = @ls_sql + 'INNER JOIN ' + @ls_temp_tablename + '_updated x '
			SET @ls_sql = @ls_sql + 'ON x.ID = t.ID '
			IF @ll_owner_id_exists = 1
				SET @ls_sql = @ls_sql + 'WHERE t.owner_id = x.owner_id'

			-- Execute the data transfer script
			EXECUTE (@ls_sql)
			SET @ll_error = @@ERROR
			IF @ll_error <> 0
				RETURN -1
			END
		END
	ELSE
		BEGIN
		EXECUTE jmjsys_get_sync_table_data
			@ps_tablename = @ps_tablename,
			@ps_sync_tablename = @ps_sync_tablename,
			@ps_ids_only = 'N',
			@ps_new_flag = 'N',
			@ps_updated_flag = 'N',
			@ps_all_flag = 'Y',
			@ps_temp_tablename = @ls_temp_tablename OUTPUT,
			@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
			@ps_update_set_clause = @ls_update_set_clause OUTPUT,
			@ps_insert_column_list = @ls_insert_column_list OUTPUT,
			@ps_select_column_list = @ls_select_column_list OUTPUT,
			@pdt_since_datestamp = @ldt_datestamp

		IF @ls_primary_key_where_clause IS NULL OR LEN(@ls_primary_key_where_clause) <= 0
			BEGIN
			RAISERROR ('Table without [ID] column must not have identity column in primary key (%s)',16,-1, @ps_tablename)
			RETURN -1
			END

		-- Process update records
		IF LEN(@ls_update_set_clause) > 0
			BEGIN
			SET @ls_sql = 'UPDATE t SET ' + @ls_update_set_clause
			SET @ls_sql = @ls_sql + ' FROM ' + @ps_tablename + ' t '
			SET @ls_sql = @ls_sql + 'INNER JOIN ' + @ls_temp_tablename + ' x '
			SET @ls_sql = @ls_sql + 'ON ' + @ls_primary_key_where_clause

			-- Execute the data transfer script
			EXECUTE (@ls_sql)
			SET @ll_error = @@ERROR
			IF @ll_error <> 0
				RETURN -1
			END
				
		-- Process new records but ignore records with primary key collisions
		SET @ls_sql = 'INSERT INTO ' + @ps_tablename + '(' + @ls_insert_column_list + ')'
		SET @ls_sql = @ls_sql + ' SELECT ' + @ls_select_column_list
		SET @ls_sql = @ls_sql + ' FROM ' + @ls_temp_tablename + ' x'
		SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ps_tablename + ' t '
		SET @ls_sql = @ls_sql + '                   WHERE ' + @ls_primary_key_where_clause + ')'

		-- Execute the data transfer script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1

		END
	END

IF @ps_sync_type = 'New Only'
	BEGIN

	IF @ll_id_exists = 1
		BEGIN
		EXECUTE jmjsys_get_sync_table_data
			@ps_tablename = @ps_tablename,
			@ps_sync_tablename = @ps_sync_tablename,
			@ps_ids_only = 'N',
			@ps_new_flag = 'Y',
			@ps_updated_flag = 'N',
			@ps_all_flag = 'N',
			@ps_temp_tablename = @ls_temp_tablename OUTPUT,
			@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
			@ps_update_set_clause = @ls_update_set_clause OUTPUT,
			@ps_insert_column_list = @ls_insert_column_list OUTPUT,
			@ps_select_column_list = @ls_select_column_list OUTPUT,
			@pdt_since_datestamp = @ldt_datestamp


		-- Process new records but ignore records with primary key collisions
		SET @ls_sql = 'INSERT INTO ' + @ps_tablename + '(' + @ls_insert_column_list + ')'
		SET @ls_sql = @ls_sql + ' SELECT ' + @ls_select_column_list
		SET @ls_sql = @ls_sql + ' FROM ' + @ls_temp_tablename + '_new x'
		IF LEN(@ls_primary_key_where_clause) > 0
			BEGIN
			SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ps_tablename + ' t '
			SET @ls_sql = @ls_sql + '                   WHERE ' + @ls_primary_key_where_clause + ')'
			END

		-- Execute the data transfer script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1
		END
	ELSE
		BEGIN
		EXECUTE jmjsys_get_sync_table_data
			@ps_tablename = @ps_tablename,
			@ps_sync_tablename = @ps_sync_tablename,
			@ps_ids_only = 'N',
			@ps_new_flag = 'N',
			@ps_updated_flag = 'N',
			@ps_all_flag = 'Y',
			@ps_temp_tablename = @ls_temp_tablename OUTPUT,
			@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
			@ps_update_set_clause = @ls_update_set_clause OUTPUT,
			@ps_insert_column_list = @ls_insert_column_list OUTPUT,
			@ps_select_column_list = @ls_select_column_list OUTPUT,
			@pdt_since_datestamp = @ldt_datestamp


		IF @ls_primary_key_where_clause IS NULL OR LEN(@ls_primary_key_where_clause) <= 0
			BEGIN
			RAISERROR ('Table without [ID] column must not have identity column in primary key (%s)',16,-1, @ps_tablename)
			RETURN -1
			END

		-- Process new records but ignore records with primary key collisions
		SET @ls_sql = 'INSERT INTO ' + @ps_tablename + '(' + @ls_insert_column_list + ')'
		SET @ls_sql = @ls_sql + ' SELECT ' + @ls_select_column_list
		SET @ls_sql = @ls_sql + ' FROM ' + @ls_temp_tablename + ' x'
		SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ps_tablename + ' t '
		SET @ls_sql = @ls_sql + '                   WHERE ' + @ls_primary_key_where_clause + ')'

		-- Execute the data transfer script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1
		END
	END

IF @ps_sync_type = 'Full Sync'
	BEGIN

	IF @ll_id_exists = 1
		BEGIN
		EXECUTE jmjsys_get_sync_table_data
			@ps_tablename = @ps_tablename,
			@ps_sync_tablename = @ps_sync_tablename,
			@ps_ids_only = 'N',
			@ps_new_flag = 'N',
			@ps_updated_flag = 'N',
			@ps_all_flag = 'Y',
			@ps_temp_tablename = @ls_temp_tablename OUTPUT,
			@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
			@ps_update_set_clause = @ls_update_set_clause OUTPUT,
			@ps_insert_column_list = @ls_insert_column_list OUTPUT,
			@ps_select_column_list = @ls_select_column_list OUTPUT,
			@pdt_since_datestamp = @ldt_datestamp


		-- Delete records that don't exist anymore
		SET @ls_sql =           'DELETE t '
		SET @ls_sql = @ls_sql + ' FROM ' + @ps_tablename + ' t '
		SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ls_temp_tablename + ' x '
		SET @ls_sql = @ls_sql + '                   WHERE x.ID = t.ID)'

		-- Execute the data transfer script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1

		-- Process update records
		IF LEN(@ls_update_set_clause) > 0
			BEGIN
			SET @ls_sql = 'UPDATE t SET ' + @ls_update_set_clause
			SET @ls_sql = @ls_sql + ' FROM ' + @ps_tablename + ' t '
			SET @ls_sql = @ls_sql + 'INNER JOIN ' + @ls_temp_tablename + ' x '
			SET @ls_sql = @ls_sql + 'ON x.ID = t.ID '
			IF @ll_owner_id_exists = 1
				SET @ls_sql = @ls_sql + 'WHERE t.owner_id = x.owner_id'

			-- Execute the data transfer script
			EXECUTE (@ls_sql)
			SET @ll_error = @@ERROR
			IF @ll_error <> 0
				RETURN -1
			END

		-- Process new records but ignore records with primary key collisions
		SET @ls_sql = 'INSERT INTO ' + @ps_tablename + '(' + @ls_insert_column_list + ')'
		SET @ls_sql = @ls_sql + ' SELECT ' + @ls_select_column_list
		SET @ls_sql = @ls_sql + ' FROM ' + @ls_temp_tablename + ' x '
		SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ps_tablename + ' t '
		SET @ls_sql = @ls_sql + '                   WHERE x.ID = t.ID)'

		-- Execute the data transfer script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1


		END
	ELSE
		BEGIN
		EXECUTE jmjsys_get_sync_table_data
			@ps_tablename = @ps_tablename,
			@ps_sync_tablename = @ps_sync_tablename,
			@ps_ids_only = 'N',
			@ps_new_flag = 'N',
			@ps_updated_flag = 'N',
			@ps_all_flag = 'Y',
			@ps_temp_tablename = @ls_temp_tablename OUTPUT,
			@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
			@ps_update_set_clause = @ls_update_set_clause OUTPUT,
			@ps_insert_column_list = @ls_insert_column_list OUTPUT,
			@ps_select_column_list = @ls_select_column_list OUTPUT,
			@pdt_since_datestamp = @ldt_datestamp

		IF @ls_primary_key_where_clause IS NULL OR LEN(@ls_primary_key_where_clause) <= 0
			BEGIN
			RAISERROR ('Table without [ID] column must not have identity column in primary key (%s)',16,-1, @ps_tablename)
			RETURN -1
			END

		-- Process update records
		IF LEN(@ls_update_set_clause) > 0
			BEGIN
			SET @ls_sql = 'UPDATE t SET ' + @ls_update_set_clause
			SET @ls_sql = @ls_sql + ' FROM ' + @ps_tablename + ' t '
			SET @ls_sql = @ls_sql + 'INNER JOIN ' + @ls_temp_tablename + ' x '
			SET @ls_sql = @ls_sql + 'ON ' + @ls_primary_key_where_clause

			-- Execute the data transfer script
			EXECUTE (@ls_sql)
			SET @ll_error = @@ERROR
			IF @ll_error <> 0
				RETURN -1
			END
				
		-- Process new records but ignore records with primary key collisions
		SET @ls_sql = 'INSERT INTO ' + @ps_tablename + '(' + @ls_insert_column_list + ')'
		SET @ls_sql = @ls_sql + ' SELECT ' + @ls_select_column_list
		SET @ls_sql = @ls_sql + ' FROM ' + @ls_temp_tablename + ' x'
		SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ps_tablename + ' t '
		SET @ls_sql = @ls_sql + '                   WHERE ' + @ls_primary_key_where_clause + ')'

		-- Execute the data transfer script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1

		-- Delete records that don't exist anymore
		SET @ls_sql =           'DELETE t '
		SET @ls_sql = @ls_sql + ' FROM ' + @ps_tablename + ' t '
		SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ls_temp_tablename + ' x '
		SET @ls_sql = @ls_sql + '                   WHERE ' + @ls_primary_key_where_clause + ')'

		-- Execute the data transfer script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1
		END
	END


UPDATE c_Table_Update
SET last_updated = @ldt_sync_datetime
WHERE table_name = @ls_sync_tablename

IF @@ROWCOUNT = 0
	BEGIN
	INSERT INTO c_Table_Update (
		table_name,
		last_updated)
	VALUES (
		@ls_sync_tablename,
		@ldt_sync_datetime)
	END


PRINT 'Sync Successful: ' + @ps_tablename + '   ' + CAST(dbo.get_client_datetime() AS varchar(20))

RETURN 1

GO
