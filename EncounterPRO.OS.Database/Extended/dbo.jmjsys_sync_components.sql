DROP PROCEDURE [jmjsys_sync_components]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_sync_components] 
AS

SET NOCOUNT ON

DECLARE @ls_tablename varchar(64),
		@ls_sync_tablename varchar(128) ,
		@ls_temp_tablename varchar(128) ,
		@ls_primary_key_where_clause varchar(4000) ,
		@ls_insert_column_list varchar(4000) ,
		@ls_select_column_list varchar(4000) ,
		@ls_update_set_clause varchar(4000) ,
		@ls_sql varchar(4000),
		@ll_id_exists int,
		@ll_owner_id_exists int,
		@ll_error int,
		@ls_where varchar(4000),
		@ls_database_mode varchar(16),
		@li_beta_flag smallint


-- Get the new component definitions
EXECUTE jmjsys_sync_table @ps_tablename = 'c_Component_Definition', @ps_sync_type = 'New and Updated'
IF @ll_error <> 0
	RETURN -1


-- Get the new component definitions
EXECUTE jmjsys_sync_table @ps_tablename = 'c_Component_Interface', @ps_sync_type = 'New and Updated'
IF @ll_error <> 0
	RETURN -1

-- Get the new component definitions
EXECUTE jmjsys_sync_table @ps_tablename = 'c_component_interface_route', @ps_sync_type = 'New and Updated'
IF @ll_error <> 0
	RETURN -1

-- Get the new component definitions
EXECUTE jmjsys_sync_table @ps_tablename = 'c_component_interface_route_property', @ps_sync_type = 'New and Updated'
IF @ll_error <> 0
	RETURN -1

----------------------------------------------------------------------
-- Sync the document routes
----------------------------------------------------------------------
-- For document routes, we will allow local routes where the route name begins with 'Local.'

SET @ls_tablename = 'c_Document_Route'
SET @ls_sync_tablename = @ls_tablename

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

-- Delete any records where the property_id and ID don't match
SET @ls_sql = 'DELETE t '
SET @ls_sql = @ls_sql + ' FROM ' + @ls_tablename + ' t '
SET @ls_sql = @ls_sql + ' INNER JOIN ' + @ls_temp_tablename + ' x'
SET @ls_sql = @ls_sql + ' ON t.document_route = x.document_route '
SET @ls_sql = @ls_sql + ' WHERE t.id <> x.id '
SET @ls_sql = @ls_sql + ' AND t.document_route NOT LIKE ''Local.%'''

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Delete any records that aren't local and don't exist anymore
SET @ls_sql = 'DELETE t '
SET @ls_sql = @ls_sql + ' FROM ' + @ls_tablename + ' t '
SET @ls_sql = @ls_sql + ' WHERE t.document_route NOT LIKE ''Local.%'''
SET @ls_sql = @ls_sql + ' AND NOT EXISTS (SELECT 1 FROM ' + @ls_temp_tablename + ' x '
SET @ls_sql = @ls_sql + '                   WHERE t.document_route = x.document_route)'

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Generate new guids for locally owned properties where the ID matches one of ours
-- This happens when someone copy/pastes records in access
SET @ls_sql = 'UPDATE t '
SET @ls_sql = @ls_sql + ' SET id = newid()'
SET @ls_sql = @ls_sql + ' FROM ' + @ls_tablename + ' t '
SET @ls_sql = @ls_sql + ' INNER JOIN ' + @ls_temp_tablename + ' x '
SET @ls_sql = @ls_sql + ' ON t.id = x.id '
SET @ls_sql = @ls_sql + ' WHERE t.document_route LIKE ''Local.%'''

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Process update records
SET @ls_sql = 'UPDATE t SET ' + @ls_update_set_clause
SET @ls_sql = @ls_sql + ' FROM ' + @ls_tablename + ' t '
SET @ls_sql = @ls_sql + 'INNER JOIN ' + @ls_temp_tablename + ' x '
SET @ls_sql = @ls_sql + 'ON x.id = t.id '

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Process new records 
SET @ls_sql = @ls_sql + ' INSERT INTO ' + @ls_tablename + '(' + @ls_insert_column_list + ')'
SET @ls_sql = @ls_sql + ' SELECT ' + @ls_select_column_list
SET @ls_sql = @ls_sql + ' FROM ' + @ls_temp_tablename + ' x'
SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ls_tablename + ' t '
SET @ls_sql = @ls_sql + '                   WHERE t.id = x.id)'

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1



----------------------------------------------------------------------
-- Sync the properties
----------------------------------------------------------------------

-- For properties, we will allow local properties with property_id > 1000000
-- and we will preserve the property_id value because some references to properties still use
-- the property_id instead of the property object/name

SET @ls_tablename = 'c_Property'
SET @ls_sync_tablename = @ls_tablename

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

-- Delete any records where the property_id and ID don't match
SET @ls_sql = 'DELETE t '
SET @ls_sql = @ls_sql + ' FROM ' + @ls_tablename + ' t '
SET @ls_sql = @ls_sql + ' INNER JOIN ' + @ls_temp_tablename + ' x'
SET @ls_sql = @ls_sql + ' ON t.property_id = x.property_id '
SET @ls_sql = @ls_sql + ' WHERE t.id <> x.id '
SET @ls_sql = @ls_sql + ' AND t.property_id < 1000000'

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Delete any records where the property_id and ID don't match
SET @ls_sql = 'DELETE t '
SET @ls_sql = @ls_sql + ' FROM ' + @ls_tablename + ' t '
SET @ls_sql = @ls_sql + ' INNER JOIN ' + @ls_temp_tablename + ' x'
SET @ls_sql = @ls_sql + ' ON t.id = x.id '
SET @ls_sql = @ls_sql + ' WHERE t.property_id <> x.property_id '
SET @ls_sql = @ls_sql + ' AND t.property_id < 1000000'

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Delete any records where the property_names match but the property_ids do not
SET @ls_sql = 'DELETE t '
SET @ls_sql = @ls_sql + ' FROM ' + @ls_tablename + ' t '
SET @ls_sql = @ls_sql + ' INNER JOIN ' + @ls_temp_tablename + ' x'
SET @ls_sql = @ls_sql + ' ON t.epro_object = x.epro_object '
SET @ls_sql = @ls_sql + ' AND t.property_name = x.property_name '
SET @ls_sql = @ls_sql + ' WHERE t.property_id <> x.property_id '

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Disable any records where the property_id isn't valid
SET @ls_sql = 'UPDATE t '
SET @ls_sql = @ls_sql + ' SET status = ''NA'''
SET @ls_sql = @ls_sql + ' FROM ' + @ls_tablename + ' t '
SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS ('
SET @ls_sql = @ls_sql + ' SELECT 1 FROM ' + @ls_temp_tablename + ' x '
SET @ls_sql = @ls_sql + ' WHERE t.property_id = x.property_id ) '
SET @ls_sql = @ls_sql + ' AND t.property_id < 1000000'

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Generate new guids for locally owned properties where the ID matches one of ours
-- This happens when someone copy/pastes records in access
SET @ls_sql = 'UPDATE t '
SET @ls_sql = @ls_sql + ' SET id = newid()'
SET @ls_sql = @ls_sql + ' FROM ' + @ls_tablename + ' t '
SET @ls_sql = @ls_sql + ' INNER JOIN ' + @ls_temp_tablename + ' x '
SET @ls_sql = @ls_sql + ' ON t.id = x.id '
SET @ls_sql = @ls_sql + ' WHERE t.property_id > 1000000'

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Process new records 
SET @ls_sql = 'SET IDENTITY_INSERT c_Property ON '
SET @ls_sql = @ls_sql + ' INSERT INTO ' + @ls_tablename + '(' + 'property_id, ' + @ls_insert_column_list + ')'
SET @ls_sql = @ls_sql + ' SELECT ' + 'property_id, ' + @ls_select_column_list
SET @ls_sql = @ls_sql + ' FROM ' + @ls_temp_tablename + ' x'
SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ls_tablename + ' t '
SET @ls_sql = @ls_sql + '                   WHERE t.property_id = x.property_id)'
SET @ls_sql = @ls_sql + ' AND x.property_id < 1000000'
SET @ls_sql = @ls_sql + ' SET IDENTITY_INSERT c_Property OFF '

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Process update records
SET @ls_sql = 'UPDATE t SET ' + @ls_update_set_clause + ', id = x.id'
SET @ls_sql = @ls_sql + ' FROM ' + @ls_tablename + ' t '
SET @ls_sql = @ls_sql + 'INNER JOIN ' + @ls_temp_tablename + ' x '
SET @ls_sql = @ls_sql + 'ON x.property_id = t.property_id '
SET @ls_sql = @ls_sql + 'WHERE t.property_id < 1000000'

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1



----------------------------------------------------------------------
-- Sync the Component Versions
----------------------------------------------------------------------
-- Get the new component definitions

SET @ls_tablename = 'c_Component_Version'
SET @ls_sync_tablename = @ls_tablename

-- Put a marker in the log
PRINT 'Sync Starting: ' + @ls_tablename + '   ' + CAST(dbo.get_client_datetime() AS varchar(20))

EXECUTE jmjsys_get_sync_table_data
	@ps_tablename = @ls_tablename,
	@ps_sync_tablename = @ls_sync_tablename,
	@ps_ids_only = 'Y',
	@ps_new_flag = 'Y',
	@ps_updated_flag = 'Y',
	@ps_all_flag = 'N',
	@ps_temp_tablename = @ls_temp_tablename OUTPUT,
	@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
	@ps_update_set_clause = @ls_update_set_clause OUTPUT,
	@ps_insert_column_list = @ls_insert_column_list OUTPUT,
	@ps_select_column_list = @ls_select_column_list OUTPUT

SELECT @ls_database_mode = database_mode,
		@li_beta_flag = beta_flag
FROM c_Database_Status

IF @li_beta_flag = 0
	BEGIN
	IF @ls_database_mode = 'Production'
		SET @ls_where = ' AND release_status = ''Production'''
	ELSE
		SET @ls_where = ' AND release_status IN (''Production'', ''Beta'', ''Testing'')'
	END
ELSE
	BEGIN
	SET @ls_where = ' AND release_status IN (''Production'', ''Beta'')'
	END

-- Get the versions one at a time so if there's an interruption it will only need to re-get the records that failed
SET @ls_sql = '
DECLARE @lui_id uniqueidentifier

DECLARE lc_versions CURSOR LOCAL FAST_FORWARD FOR
	SELECT id
	FROM ' + @ls_temp_tablename + '_ids
	WHERE new_flag = ''Y''
	OR updated_flag = ''Y''

OPEN lc_versions

FETCH lc_versions INTO @lui_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	DELETE v
	FROM c_Component_Version v
	WHERE v.id = @lui_id

	INSERT INTO ' + @ls_tablename + '(
		' + @ls_insert_column_list + ')
	SELECT ' + @ls_select_column_list + '
	FROM jmjtech.EproUpdates.dbo.' + @ls_sync_tablename + ' x
	WHERE ID = @lui_id
	' + @ls_where + '

	FETCH lc_versions INTO @lui_id
	END

CLOSE lc_versions
DEALLOCATE lc_versions
'

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	BEGIN
	PRINT 'Sync Failed: ' + @ls_tablename + '   ' + CAST(dbo.get_client_datetime() AS varchar(20))
	RETURN 
	END
ELSE
	BEGIN
	PRINT 'Sync Successful: ' + @ls_tablename + '   ' + CAST(dbo.get_client_datetime() AS varchar(20))
	END

RETURN 1

GO
GRANT EXECUTE ON [jmjsys_sync_components] TO [cprsystem] AS [dbo]
GO
