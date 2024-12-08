DROP PROCEDURE [jmjsys_sync_params]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_sync_params]
AS

SET NOCOUNT ON

DECLARE @ls_param_tablename varchar(64),
	@ls_temp_tablename varchar(128) ,
	@ls_primary_key_where_clause varchar(4000) ,
	@ls_insert_column_list varchar(4000) ,
	@ls_select_column_list varchar(4000) ,
	@ls_update_set_clause varchar(4000) ,
	@ls_sql varchar(4000),
	@ll_error int



-- Get the data for all the new and updated c_Domain records	
SET @ls_param_tablename = 'c_Component_Param'

-- Put a marker in the log
PRINT 'Special Sync Starting: ' + @ls_param_tablename + '   ' + CAST(dbo.get_client_datetime() AS varchar(20))

EXECUTE jmjsys_get_sync_table_data
	@ps_tablename = @ls_param_tablename,
	@ps_ids_only = 'N',
	@ps_new_flag = 'N',
	@ps_updated_flag = 'N',
	@ps_all_flag = 'Y',
	@ps_id_column_name = 'param_id',
	@ps_temp_tablename = @ls_temp_tablename OUTPUT,
	@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
	@ps_update_set_clause = @ls_update_set_clause OUTPUT,
	@ps_insert_column_list = @ls_insert_column_list OUTPUT,
	@ps_select_column_list = @ls_select_column_list OUTPUT


-- Update records that already exist
SET @ls_sql = 'UPDATE t SET ' + @ls_update_set_clause
SET @ls_sql = @ls_sql + ' FROM ' + @ls_param_tablename + ' t '
SET @ls_sql = @ls_sql + 'INNER JOIN ' + @ls_temp_tablename + ' x '
SET @ls_sql = @ls_sql + 'ON x.param_id = t.param_id '
SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM c_Config_Object y '
SET @ls_sql = @ls_sql +                 ' WHERE y.config_object_id = t.id '
SET @ls_sql = @ls_sql +                 ' AND y.owner_id <> 0) '

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1


-- Insert records that don't exist yet
SET @ls_sql = 'INSERT INTO ' + @ls_param_tablename + '(' + @ls_insert_column_list + ')'
SET @ls_sql = @ls_sql + ' SELECT ' + @ls_select_column_list
SET @ls_sql = @ls_sql + ' FROM ' + @ls_temp_tablename + ' x'
SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ls_param_tablename + ' t '
SET @ls_sql = @ls_sql +                     'WHERE x.param_id = t.param_id)'
SET @ls_sql = @ls_sql + ' AND NOT EXISTS (SELECT 1 FROM c_Config_Object y '
SET @ls_sql = @ls_sql +                 ' WHERE y.config_object_id = x.id '
SET @ls_sql = @ls_sql +                 ' AND y.owner_id <> 0) '

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- DELETE records that shoudn't exist anymore
SET @ls_sql =			' DELETE t ' 
SET @ls_sql = @ls_sql + ' FROM ' + @ls_param_tablename + ' t '
SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ls_temp_tablename + ' x '
SET @ls_sql = @ls_sql +                     'WHERE x.param_id = t.param_id)'
SET @ls_sql = @ls_sql + ' AND NOT EXISTS (SELECT 1 FROM c_Config_Object y '
SET @ls_sql = @ls_sql +                 ' WHERE y.config_object_id = t.id '
SET @ls_sql = @ls_sql +                 ' AND y.owner_id <> 0) '

EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Put a marker in the log
PRINT 'Special Sync Successful: ' + @ls_param_tablename + '   ' + CAST(dbo.get_client_datetime() AS varchar(20))

RETURN 1

GO
