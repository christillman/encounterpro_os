DROP PROCEDURE [jmjsys_sync_diseases]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_sync_diseases]
AS

SET NOCOUNT ON

DECLARE @ls_disease_tablename varchar(64),
	@ls_disease_address_tablename varchar(64),
	@ls_disease_communication_tablename varchar(64),
	@ls_disease_progress_tablename varchar(64),
	@ls_disease_progress_sync_tablename varchar(64),
	@ls_disease_Route_Purpose_tablename varchar(128) ,
	@ls_disease_sync_tablename varchar(64),
	@ls_disease_temp_tablename varchar(128) ,
	@ls_disease_address_temp_tablename varchar(128) ,
	@ls_disease_communication_temp_tablename varchar(128) ,
	@ls_disease_progress_temp_tablename varchar(128) ,
	@ls_disease_Route_Purpose_temp_tablename varchar(128) ,
	@ls_primary_key_where_clause varchar(4000) ,
	@ls_insert_column_list varchar(4000) ,
	@ls_select_column_list varchar(4000) ,
	@ls_update_set_clause varchar(4000) ,
	@ls_sql varchar(4000),
	@ll_error int,
	@ldt_datestamp datetime,
	@ls_sync_tablename varchar(64),
	@ldt_sync_datetime datetime

-- Make sure it's OK to sync the diseases by checking the sync mod level for c_disease
IF NOT EXISTS(SELECT 1 FROM c_Database_Table t CROSS JOIN c_Database_Status s WHERE t.tablename = 'c_disease' AND t.sync_modification_level <= s.modification_level)
	RETURN 1

SET @ls_disease_tablename = 'c_disease'
SET @ls_disease_sync_tablename = 'c_disease'

-- Put a marker in the log
PRINT 'Special Sync Starting: ' + @ls_disease_tablename + '   ' + CAST(dbo.get_client_datetime() AS varchar(20))

EXECUTE jmjsys_get_sync_table_data
	@ps_tablename = @ls_disease_tablename ,
	@ps_sync_tablename = @ls_disease_sync_tablename,
	@ps_ids_only = 'N',
	@ps_new_flag = 'N',
	@ps_updated_flag = 'N',
	@ps_all_flag = 'Y',
	@ps_temp_tablename = @ls_disease_temp_tablename OUTPUT,
	@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
	@ps_update_set_clause = @ls_update_set_clause OUTPUT,
	@ps_insert_column_list = @ls_insert_column_list OUTPUT,
	@ps_select_column_list = @ls_select_column_list OUTPUT

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1


SET @ls_sql = 
'
DECLARE @ll_disease_id int,
		@ls_description varchar(80),
		@ll_actual_disease_id int

DECLARE lc_mismatch CURSOR LOCAL FAST_FORWARD FOR
SELECT a.disease_id, a.description
FROM ' + @ls_disease_temp_tablename + ' x
	INNER JOIN c_disease a
	ON x.disease_id = a.disease_id
WHERE a.description <> x.description

OPEN lc_mismatch

FETCH lc_mismatch INTO @ll_disease_id, @ls_description

WHILE @@FETCH_STATUS = 0
	BEGIN
	SELECT @ll_actual_disease_id = disease_id
	FROM ' + @ls_disease_temp_tablename + ' 
	WHERE description = @ls_description

	IF @@ROWCOUNT = 1
		BEGIN
		EXECUTE jmj_modify_references
			@pl_reference_id = @ll_disease_id,
			@pl_new_reference_id = @ll_actual_disease_id,
			@ps_object_key = ''disease_id''

		IF @@ERROR <> 0
			RETURN
		END
	ELSE
		BEGIN
		EXECUTE sp_local_copy_disease
			@pl_disease_id = @ll_disease_id

		IF @@ERROR <> 0
			RETURN
		END

	DELETE a
	FROM c_disease a
	WHERE a.disease_id = @ll_disease_id

	FETCH lc_mismatch INTO @ll_disease_id, @ls_description
	END

CLOSE lc_mismatch
DEALLOCATE lc_mismatch
'

-- Execute the [user_id] prep script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

SET @ls_sql = 'UPDATE t SET ' + @ls_update_set_clause
SET @ls_sql = @ls_sql + ' FROM ' + @ls_disease_tablename + ' t '
SET @ls_sql = @ls_sql + 'INNER JOIN ' + @ls_disease_temp_tablename + ' x '
SET @ls_sql = @ls_sql + 'ON x.disease_id = t.disease_id '

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1


-- Process new records but ignore records with primary key collisions
SET @ls_sql = @ls_sql + ' INSERT INTO ' + @ls_disease_tablename + '(' + @ls_insert_column_list + ')'
SET @ls_sql = @ls_sql + ' SELECT ' + @ls_select_column_list
SET @ls_sql = @ls_sql + ' FROM ' + @ls_disease_temp_tablename + ' x'
SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ls_disease_tablename + ' t '
SET @ls_sql = @ls_sql + 'WHERE x.disease_id = t.disease_id) '

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1


-- Put a marker in the log
PRINT 'Special Sync Successful: ' + @ls_disease_tablename + '   ' + CAST(dbo.get_client_datetime() AS varchar(20))


RETURN 1

GO
