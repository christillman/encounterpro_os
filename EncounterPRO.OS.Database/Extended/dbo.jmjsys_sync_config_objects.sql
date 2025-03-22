DROP PROCEDURE [jmjsys_sync_config_objects]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_sync_config_objects] 
AS

SET NOCOUNT ON

DECLARE @ls_tablename varchar(64),
	@ls_sync_tablename varchar(128),
	@ls_sync_type varchar(24),
	@ls_temp_tablename varchar(128) ,
	@ls_primary_key_where_clause varchar(4000) ,
	@ls_insert_column_list varchar(4000) ,
	@ls_select_column_list varchar(4000) ,
	@ls_update_set_clause varchar(4000) ,
	@ls_sql varchar(4000),
	@ll_error int

SET @ls_tablename = 'c_Config_Object_Library'
SET @ls_sync_tablename = 'c_Config_Object'

-- Put a marker in the log
PRINT 'Special Sync Starting: ' + @ls_tablename + '   ' + CAST(dbo.get_client_datetime() AS varchar(20))

EXECUTE jmjsys_get_sync_table_data
	@ps_tablename = @ls_tablename,
	@ps_sync_tablename = @ls_sync_tablename,
	@ps_ids_only = 'N',
	@ps_new_flag = 'N',
	@ps_updated_flag = 'N',
	@ps_all_flag = 'Y',
	@ps_temp_tablename = @ls_temp_tablename OUTPUT,
	@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
	@ps_update_set_clause = @ls_update_set_clause OUTPUT,
	@ps_insert_column_list = @ls_insert_column_list OUTPUT,
	@ps_select_column_list = @ls_select_column_list OUTPUT


-- Process new records but ignore records with primary key collisions
SET @ls_sql = 'INSERT INTO ' + @ls_tablename + '(' + @ls_insert_column_list + ')'
SET @ls_sql = @ls_sql + ' SELECT ' + @ls_select_column_list
SET @ls_sql = @ls_sql + ' FROM ' + @ls_temp_tablename + ' x'
IF LEN(@ls_primary_key_where_clause) > 0
	BEGIN
	SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ls_tablename + ' t '
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
	SET @ls_sql = @ls_sql + ' FROM ' + @ls_tablename + ' t '
	SET @ls_sql = @ls_sql + 'INNER JOIN ' + @ls_temp_tablename + ' x '
	SET @ls_sql = @ls_sql + 'ON x.config_object_id = t.config_object_id '

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1
END

-- Disable any config objects in the library that didn't exist
-- Process update records
IF LEN(@ls_update_set_clause) > 0
	BEGIN
	SET @ls_sql = 'UPDATE t SET status = ''NA'''
	SET @ls_sql = @ls_sql + ' FROM ' + @ls_tablename + ' t '
	SET @ls_sql = @ls_sql + ' WHERE config_object_id NOT IN (SELECT config_object_id FROM ' + @ls_temp_tablename + ' ) '

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1
END

-- Put a marker in the log
PRINT 'Special Sync Successful: ' + @ls_tablename + '   ' + CAST(dbo.get_client_datetime() AS varchar(20))

RETURN 1

GO
GRANT EXECUTE ON [jmjsys_sync_config_objects] TO [cprsystem] AS [dbo]
GO
