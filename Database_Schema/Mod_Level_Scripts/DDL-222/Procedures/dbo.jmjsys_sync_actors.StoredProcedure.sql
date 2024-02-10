DROP PROCEDURE [jmjsys_sync_actors]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_sync_actors]
AS

SET NOCOUNT ON

DECLARE @ls_actor_tablename varchar(64),
	@ls_actor_address_tablename varchar(64),
	@ls_actor_communication_tablename varchar(64),
	@ls_actor_progress_tablename varchar(64),
	@ls_actor_progress_sync_tablename varchar(64),
	@ls_actor_Route_Purpose_tablename varchar(128) ,
	@ls_actor_sync_tablename varchar(64),
	@ls_actor_temp_tablename varchar(128) ,
	@ls_actor_address_temp_tablename varchar(128) ,
	@ls_actor_communication_temp_tablename varchar(128) ,
	@ls_actor_progress_temp_tablename varchar(128) ,
	@ls_actor_Route_Purpose_temp_tablename varchar(128) ,
	@ls_primary_key_where_clause varchar(4000) ,
	@ls_insert_column_list varchar(4000) ,
	@ls_select_column_list varchar(4000) ,
	@ls_update_set_clause varchar(4000) ,
	@ls_sql varchar(4000),
	@ll_error int,
	@ldt_datestamp datetime,
	@ls_sync_tablename varchar(64),
	@ldt_sync_datetime datetime

-- Make sure it's OK to sync the actors by checking the sync mod level for c_User
IF NOT EXISTS(SELECT 1 FROM c_Database_Table t CROSS JOIN c_Database_Status s WHERE t.tablename = 'c_User' AND t.sync_modification_level <= s.modification_level)
	RETURN 1

SET @ls_actor_tablename = 'c_User'
SET @ls_actor_sync_tablename = 'c_Actor'
SET @ls_actor_address_tablename = 'c_Actor_Address'
SET @ls_actor_communication_tablename = 'c_Actor_Communication'
SET @ls_actor_progress_tablename = 'c_User_Progress'
SET @ls_actor_progress_sync_tablename = 'c_Actor_Progress'
SET @ls_actor_Route_Purpose_tablename = 'c_Actor_Route_Purpose'

-- Put a marker in the log
PRINT 'Special Sync Starting: ' + @ls_actor_tablename + '   ' + CAST(getdate() AS varchar(20))

EXECUTE jmjsys_get_sync_table_data
	@ps_tablename = @ls_actor_tablename ,
	@ps_sync_tablename = @ls_actor_sync_tablename,
	@ps_ids_only = 'N',
	@ps_new_flag = 'Y',
	@ps_updated_flag = 'Y',
	@ps_all_flag = 'N',
	@ps_temp_tablename = @ls_actor_temp_tablename OUTPUT,
	@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
	@ps_update_set_clause = @ls_update_set_clause OUTPUT,
	@ps_insert_column_list = @ls_insert_column_list OUTPUT,
	@ps_select_column_list = @ls_select_column_list OUTPUT

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Make sure the [user_id] field is set and unique for new records
SET @ls_sql = 'UPDATE x SET [user_id] = dbo.fn_new_user_id(x.owner_id, x.user_full_name, x.user_id)'
SET @ls_sql = @ls_sql + ' FROM ' + @ls_actor_temp_tablename + '_new x '
SET @ls_sql = @ls_sql + ' WHERE x.user_id IS NULL'
SET @ls_sql = @ls_sql + ' OR EXISTS(SELECT 1 FROM c_User u WHERE x.user_id = u.user_id)'

-- Execute the [user_id] prep script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Process new records but ignore records with primary key collisions
SET @ls_sql = 'INSERT INTO ' + @ls_actor_tablename + '(user_status, ' + @ls_insert_column_list + ')'
SET @ls_sql = @ls_sql + ' SELECT ''Actor'' as user_status, ' + @ls_select_column_list
SET @ls_sql = @ls_sql + ' FROM ' + @ls_actor_temp_tablename + '_new x'
SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ls_actor_tablename + ' t '
SET @ls_sql = @ls_sql + 'WHERE ' + @ls_primary_key_where_clause + ')'

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1


-- Remove the [user_id] field from the update list, but get cases where the clause is at the end or not at the end
SET @ls_update_set_clause = REPLACE(@ls_update_set_clause, 'user_id = t.user_id,', '')
SET @ls_update_set_clause = REPLACE(@ls_update_set_clause, ', [user_id] = t.user_id', '')

-- Process update records
SET @ls_sql = 'UPDATE t SET ' + @ls_update_set_clause
SET @ls_sql = @ls_sql + ' FROM ' + @ls_actor_tablename + ' t '
SET @ls_sql = @ls_sql + 'INNER JOIN ' + @ls_actor_temp_tablename + '_updated x '
SET @ls_sql = @ls_sql + 'ON x.ID = t.ID '
SET @ls_sql = @ls_sql + 'WHERE t.owner_id = x.owner_id'

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Put a marker in the log
PRINT 'Special Sync Successful: ' + @ls_actor_tablename + '   ' + CAST(getdate() AS varchar(20))

-------------------------------------------------------------------
-- Sync the actor address records
-------------------------------------------------------------------
SET @ls_sync_tablename = 'Sync ' + @ls_actor_address_tablename
SET @ldt_sync_datetime = getdate()

SELECT @ldt_datestamp = last_updated
FROM c_Table_Update
WHERE table_name = @ls_sync_tablename

-- Put a marker in the log
PRINT 'Special Sync Starting: ' + @ls_actor_address_tablename + '   ' + CAST(getdate() AS varchar(20))

EXECUTE jmjsys_get_sync_table_data
	@ps_tablename = @ls_actor_address_tablename ,
	@ps_ids_only = 'N',
	@ps_new_flag = 'Y',
	@ps_updated_flag = 'N',
	@ps_all_flag = 'N',
	@ps_temp_tablename = @ls_actor_address_temp_tablename OUTPUT,
	@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
	@ps_update_set_clause = @ls_update_set_clause OUTPUT,
	@ps_insert_column_list = @ls_insert_column_list OUTPUT,
	@ps_select_column_list = @ls_select_column_list OUTPUT,
	@pdt_since_datestamp = @ldt_datestamp

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Process address that have their ID in the new or updates actor temp table
SET @ls_sql =           ' INSERT INTO ' + @ls_actor_address_tablename + '(actor_id, ' + @ls_insert_column_list + ')'
SET @ls_sql = @ls_sql + ' SELECT u.actor_id, ' + @ls_select_column_list
SET @ls_sql = @ls_sql + ' FROM ' + @ls_actor_address_temp_tablename + '_new x'
SET @ls_sql = @ls_sql + ' INNER JOIN c_User u ON x.c_actor_id = u.id'

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

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

-- Put a marker in the log
PRINT 'Special Sync Successful: ' + @ls_actor_address_tablename + '   ' + CAST(getdate() AS varchar(20))


-------------------------------------------------------------------
-- Sync the actor communication records
-------------------------------------------------------------------
SET @ls_sync_tablename = 'Sync ' + @ls_actor_communication_tablename
SET @ldt_sync_datetime = getdate()

SELECT @ldt_datestamp = last_updated
FROM c_Table_Update
WHERE table_name = @ls_sync_tablename

-- Put a marker in the log
PRINT 'Special Sync Starting: ' + @ls_actor_communication_tablename + '   ' + CAST(getdate() AS varchar(20))

EXECUTE jmjsys_get_sync_table_data
	@ps_tablename = @ls_actor_communication_tablename ,
	@ps_ids_only = 'N',
	@ps_new_flag = 'Y',
	@ps_updated_flag = 'N',
	@ps_all_flag = 'N',
	@ps_temp_tablename = @ls_actor_communication_temp_tablename OUTPUT,
	@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
	@ps_update_set_clause = @ls_update_set_clause OUTPUT,
	@ps_insert_column_list = @ls_insert_column_list OUTPUT,
	@ps_select_column_list = @ls_select_column_list OUTPUT

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Change any primary email addresses to secondary email addresses if they exist for a different actor
SET @ls_sql =           ' UPDATE x SET communication_name = ''Email2'' '
SET @ls_sql = @ls_sql + ' FROM ' + @ls_actor_communication_temp_tablename + '_new x'
SET @ls_sql = @ls_sql + ' INNER JOIN ' + @ls_actor_communication_temp_tablename + '_new y'
SET @ls_sql = @ls_sql + '       ON x.communication_type = y.communication_type'
SET @ls_sql = @ls_sql + '       AND x.communication_name = y.communication_name'
SET @ls_sql = @ls_sql + '       AND x.communication_value = y.communication_value'
SET @ls_sql = @ls_sql + ' WHERE x.communication_type = ''Email'' '
SET @ls_sql = @ls_sql + ' AND x.communication_name = ''Email'' '
SET @ls_sql = @ls_sql + ' AND x.communication_value IS NOT NULL '
SET @ls_sql = @ls_sql + ' AND x.communication_sequence > y.communication_sequence '

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Change any primary email addresses to secondary email addresses if they exist for a different actor
SET @ls_sql =           ' UPDATE x SET communication_name = ''Email2'' '
SET @ls_sql = @ls_sql + ' FROM ' + @ls_actor_communication_temp_tablename + '_new x'
SET @ls_sql = @ls_sql + ' INNER JOIN c_User u ON x.communication_value = u.email_address'
SET @ls_sql = @ls_sql + ' WHERE x.communication_type = ''Email'' '
SET @ls_sql = @ls_sql + ' AND x.communication_name = ''Email'' '
SET @ls_sql = @ls_sql + ' AND x.c_actor_id <> u.id '

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Process communication that have their ID in the new or updates actor temp table
SET @ls_sql =           ' INSERT INTO ' + @ls_actor_communication_tablename + '(actor_id, ' + @ls_insert_column_list + ')'
SET @ls_sql = @ls_sql + ' SELECT u.actor_id, ' + @ls_select_column_list
SET @ls_sql = @ls_sql + ' FROM ' + @ls_actor_communication_temp_tablename + '_new x'
SET @ls_sql = @ls_sql + ' INNER JOIN c_User u ON x.c_actor_id = u.id'


-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

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

-- Put a marker in the log
PRINT 'Special Sync Successful: ' + @ls_actor_communication_tablename + '   ' + CAST(getdate() AS varchar(20))

-------------------------------------------------------------------
-- Sync the actor property records
-------------------------------------------------------------------

-- Put a marker in the log
PRINT 'Special Sync Starting: ' + @ls_actor_progress_tablename + '   ' + CAST(getdate() AS varchar(20))

EXECUTE jmjsys_get_sync_table_data
	@ps_tablename = @ls_actor_progress_tablename ,
	@ps_sync_tablename = @ls_actor_progress_sync_tablename ,
	@ps_ids_only = 'N',
	@ps_new_flag = 'Y',
	@ps_updated_flag = 'N',
	@ps_all_flag = 'N',
	@ps_temp_tablename = @ls_actor_progress_temp_tablename OUTPUT,
	@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
	@ps_update_set_clause = @ls_update_set_clause OUTPUT,
	@ps_insert_column_list = @ls_insert_column_list OUTPUT,
	@ps_select_column_list = @ls_select_column_list OUTPUT

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Process new records
SET @ls_sql = 'INSERT INTO ' + @ls_actor_progress_tablename + '(user_id, ' + @ls_insert_column_list + ')'
SET @ls_sql = @ls_sql + ' SELECT u.user_id, ' + @ls_select_column_list
SET @ls_sql = @ls_sql + ' FROM ' + @ls_actor_progress_temp_tablename + '_new x'
SET @ls_sql = @ls_sql + '     INNER JOIN c_User u ON u.id = x.c_actor_id '

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1


-- Put a marker in the log
PRINT 'Special Sync Successful: ' + @ls_actor_progress_tablename + '   ' + CAST(getdate() AS varchar(20))

-------------------------------------------------------------------
-- Sync the actor Route-Purpose records
-------------------------------------------------------------------

-- Put a marker in the log
PRINT 'Special Sync Starting: ' + @ls_actor_Route_Purpose_tablename + '   ' + CAST(getdate() AS varchar(20))

EXECUTE jmjsys_get_sync_table_data
	@ps_tablename = @ls_actor_Route_Purpose_tablename ,
	@ps_ids_only = 'N',
	@ps_new_flag = 'Y',
	@ps_updated_flag = 'N',
	@ps_all_flag = 'N',
	@ps_temp_tablename = @ls_actor_Route_Purpose_temp_tablename OUTPUT,
	@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
	@ps_update_set_clause = @ls_update_set_clause OUTPUT,
	@ps_insert_column_list = @ls_insert_column_list OUTPUT,
	@ps_select_column_list = @ls_select_column_list OUTPUT

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Process new records
SET @ls_sql = 'INSERT INTO ' + @ls_actor_Route_Purpose_tablename + '(actor_id, ' + @ls_insert_column_list + ')'
SET @ls_sql = @ls_sql + ' SELECT u.actor_id, ' + @ls_select_column_list
SET @ls_sql = @ls_sql + ' FROM ' + @ls_actor_Route_Purpose_temp_tablename + '_new x'
SET @ls_sql = @ls_sql + '     INNER JOIN c_User u ON u.id = x.c_actor_id '


-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Put a marker in the log
PRINT 'Special Sync Successful: ' + @ls_actor_Route_Purpose_tablename + '   ' + CAST(getdate() AS varchar(20))


-------------------------------------------------------------------
-- Make sure this practice is registered in EproUpdates
-------------------------------------------------------------------

DECLARE @puid_actor_id uniqueidentifier,
	@ll_owner_id INTEGER,
	@ls_actor_class VARCHAR(12),
	@ls_status VARCHAR(12),
	@ls_user_id VARCHAR(24) ,
	@ls_user_full_name VARCHAR(64) ,
	@ls_specialty_id varchar(24) ,
	@ls_first_name varchar(20) ,
	@ls_middle_name varchar(20) ,
	@ls_last_name varchar(20) ,
	@ls_dea_number varchar(18) ,
	@ls_license_number varchar(40) ,
	@ls_upin varchar(24) ,
	@ls_npi varchar(40) ,
	@ls_practice_user_id varchar(24),
	@ls_id varchar(255)

SET @ls_practice_user_id = dbo.fn_practice_user_id()

IF @ls_practice_user_id IS NOT NULL
	BEGIN
	SELECT @puid_actor_id = id,
		@ll_owner_id = owner_id,
		@ls_actor_class = actor_class,
		@ls_status = status,
		@ls_user_id = user_id,
		@ls_user_full_name = user_full_name,
		@ls_specialty_id = specialty_id,
		@ls_first_name = first_name,
		@ls_middle_name = middle_name ,
		@ls_last_name = last_name ,
		@ls_dea_number = dea_number ,
		@ls_license_number = license_number ,
		@ls_upin = upin ,
		@ls_npi = npi
	FROM c_User
	WHERE [user_id] = @ls_practice_user_id

	EXECUTE jmjsys_add_actor
		@puid_actor_id = @puid_actor_id,
		@pl_owner_id = @ll_owner_id,
		@ps_actor_class = @ls_actor_class,
		@ps_actor_name = @ls_user_full_name,
		@ps_status = @ls_status,
		@ps_user_id = @ls_user_id,
		@ps_user_full_name = @ls_user_full_name,
		@ps_specialty_id = @ls_specialty_id,
		@ps_first_name = @ls_first_name,
		@ps_middle_name = @ls_middle_name,
		@ps_last_name = @ls_last_name,
		@ps_dea_number = @ls_dea_number,
		@ps_license_number = @ls_license_number,
		@ps_upin = @ls_upin,
		@ps_npi = @ls_npi

	-- Make sure the practice is registered for EproLink transactions
	SET @ls_id = dbo.fn_user_property (@ls_practice_user_id, 'ID', '1^EncounterPRO_ID')
	IF @ls_id IS NULL OR @ls_id <> CAST(@ll_owner_id AS varchar(255))
		BEGIN
		SET @ls_id = CAST(@ll_owner_id AS varchar(255))

		EXECUTE sp_Set_User_Progress
			@ps_user_id = @ls_practice_user_id,
			@ps_progress_user_id = '#SYSTEM',
			@ps_progress_type = 'ID',
			@ps_progress_key = '1^EncounterPRO_ID',
			@ps_progress = @ls_id,
			@ps_created_by = '#SYSTEM'
		END
	END

RETURN 1

GO
