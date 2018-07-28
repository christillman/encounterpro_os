CREATE PROCEDURE [dbo].[config_sync_library] 
AS

DECLARE @ls_temp_tablename varchar(128) ,
	@ls_primary_key_where_clause varchar(4000) ,
	@ls_insert_column_list varchar(4000) ,
	@ls_select_column_list varchar(4000) ,
	@ls_update_set_clause varchar(4000) ,
	@ls_sql varchar(4000),
	@ll_error int,
	@ll_id_exists int,
	@ll_owner_id int

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

-- First get the library entries
EXECUTE jmjsys_sync_table  
	@ps_tablename = 'c_Config_Object_Library',   
	@ps_sync_tablename = 'c_Config_Object',   
	@ps_sync_type = 'New and Updated'

SELECT @ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -1

-- Then update the release_status of the local version records

EXECUTE jmjsys_get_sync_table_data
	@ps_tablename = 'c_Config_Object_Version',
	@ps_ids_only = 'N',
	@ps_new_flag = 'N',
	@ps_updated_flag = 'N',
	@ps_all_flag = 'Y',
	@ps_temp_tablename = @ls_temp_tablename OUTPUT,
	@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
	@ps_update_set_clause = @ls_update_set_clause OUTPUT,
	@ps_insert_column_list = @ls_insert_column_list OUTPUT,
	@ps_select_column_list = @ls_select_column_list OUTPUT

-- Process update records
SET @ls_sql = 'UPDATE t SET release_status = x.release_status, release_status_date_time = x.release_status_date_time '
SET @ls_sql = @ls_sql + ' FROM c_Config_Object_Version t '
SET @ls_sql = @ls_sql + 'INNER JOIN ' + @ls_temp_tablename + ' x '
SET @ls_sql = @ls_sql + 'ON x.Config_Object_ID = t.Config_Object_ID '
SET @ls_sql = @ls_sql + 'AND x.version = t.version '
SET @ls_sql = @ls_sql + 'WHERE x.status = ''OK'' '
SET @ls_sql = @ls_sql + 'AND t.owner_id <> ' + CAST(@ll_owner_id AS varchar(8))

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1




RETURN 1

