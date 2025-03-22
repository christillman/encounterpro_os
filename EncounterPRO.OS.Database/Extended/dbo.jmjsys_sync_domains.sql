DROP PROCEDURE [jmjsys_sync_domains]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_sync_domains]
AS

SET NOCOUNT ON

DECLARE @ls_domain_tablename varchar(64),
	@ls_domain_temp_tablename varchar(128) ,
	@ls_primary_key_where_clause varchar(4000) ,
	@ls_insert_column_list varchar(4000) ,
	@ls_select_column_list varchar(4000) ,
	@ls_update_set_clause varchar(4000) ,
	@ls_sql varchar(4000),
	@ll_error int


-- Get the data for all the new and updated c_Domain records	
SET @ls_domain_tablename = 'c_Domain'

-- Put a marker in the log
PRINT 'Special Sync Starting: ' + @ls_domain_tablename + '   ' + CAST(dbo.get_client_datetime() AS varchar(20))

EXECUTE jmjsys_get_sync_table_data
	@ps_tablename = @ls_domain_tablename ,
	@ps_ids_only = 'N',
	@ps_new_flag = 'N',
	@ps_updated_flag = 'N',
	@ps_all_flag = 'Y',
	@ps_temp_tablename = @ls_domain_temp_tablename OUTPUT,
	@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
	@ps_update_set_clause = @ls_update_set_clause OUTPUT,
	@ps_insert_column_list = @ls_insert_column_list OUTPUT,
	@ps_select_column_list = @ls_select_column_list OUTPUT

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1




-- UPDATE existing records
SET @ls_sql = 'UPDATE t SET ' + @ls_update_set_clause
SET @ls_sql = @ls_sql + ' FROM ' + @ls_domain_tablename + ' t '
SET @ls_sql = @ls_sql + ' INNER JOIN ' + @ls_domain_temp_tablename + ' x '
SET @ls_sql = @ls_sql + ' ON ' + @ls_primary_key_where_clause
SET @ls_sql = @ls_sql + ' INNER JOIN c_Domain_Master m '
SET @ls_sql = @ls_sql + ' ON t.domain_id = m.domain_id'

EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1




-- INSERT new records
SET @ls_sql = 'INSERT INTO ' + @ls_domain_tablename + '(' + @ls_insert_column_list + ')'
SET @ls_sql = @ls_sql + ' SELECT ' + @ls_select_column_list
SET @ls_sql = @ls_sql + ' FROM ' + @ls_domain_temp_tablename + ' x'
SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ls_domain_tablename + ' t '
SET @ls_sql = @ls_sql + 'WHERE ' + @ls_primary_key_where_clause + ')'

EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1




-- DELETE records that aren't in the master anymore
SET @ls_sql = 'DELETE t ' 
SET @ls_sql = @ls_sql + ' FROM ' + @ls_domain_tablename + ' t '
SET @ls_sql = @ls_sql + ' INNER JOIN c_Domain_Master m '
SET @ls_sql = @ls_sql + ' ON t.domain_id = m.domain_id '
SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ls_domain_temp_tablename + ' x '
SET @ls_sql = @ls_sql +                     'WHERE ' + @ls_primary_key_where_clause + ')'

EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1


-- Put a marker in the log
PRINT 'Special Sync Successful: ' + @ls_domain_tablename + '   ' + CAST(dbo.get_client_datetime() AS varchar(20))



RETURN 1

GO
