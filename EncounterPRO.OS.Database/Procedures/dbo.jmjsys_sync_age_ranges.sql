DROP PROCEDURE [jmjsys_sync_age_ranges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_sync_age_ranges]
AS

SET NOCOUNT ON

DECLARE @ls_age_range_tablename varchar(64),
	@ls_age_range_address_tablename varchar(64),
	@ls_age_range_communication_tablename varchar(64),
	@ls_age_range_progress_tablename varchar(64),
	@ls_age_range_progress_sync_tablename varchar(64),
	@ls_age_range_Route_Purpose_tablename varchar(128) ,
	@ls_age_range_sync_tablename varchar(64),
	@ls_age_range_temp_tablename varchar(128) ,
	@ls_age_range_address_temp_tablename varchar(128) ,
	@ls_age_range_communication_temp_tablename varchar(128) ,
	@ls_age_range_progress_temp_tablename varchar(128) ,
	@ls_age_range_Route_Purpose_temp_tablename varchar(128) ,
	@ls_primary_key_where_clause varchar(4000) ,
	@ls_insert_column_list varchar(4000) ,
	@ls_select_column_list varchar(4000) ,
	@ls_update_set_clause varchar(4000) ,
	@ls_sql varchar(4000),
	@ll_error int,
	@ldt_datestamp datetime,
	@ls_sync_tablename varchar(64),
	@ldt_sync_datetime datetime

-- Make sure it's OK to sync the age_ranges by checking the sync mod level for c_Age_Range
IF NOT EXISTS(SELECT 1 FROM c_Database_Table t CROSS JOIN c_Database_Status s WHERE t.tablename = 'c_Age_Range' AND t.sync_modification_level <= s.modification_level)
	RETURN 1

SET @ls_age_range_tablename = 'c_age_range'
SET @ls_age_range_sync_tablename = 'c_age_range'

EXECUTE jmjsys_get_sync_table_data
	@ps_tablename = @ls_age_range_tablename ,
	@ps_sync_tablename = @ls_age_range_sync_tablename,
	@ps_ids_only = 'N',
	@ps_new_flag = 'N',
	@ps_updated_flag = 'N',
	@ps_all_flag = 'Y',
	@ps_temp_tablename = @ls_age_range_temp_tablename OUTPUT,
	@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
	@ps_update_set_clause = @ls_update_set_clause OUTPUT,
	@ps_insert_column_list = @ls_insert_column_list OUTPUT,
	@ps_select_column_list = @ls_select_column_list OUTPUT

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Old age ranges may have a NULL ID.  If everything else matches then set the ID to the official value
SET @ls_sql = 'UPDATE a SET id = x.id '
SET @ls_sql = @ls_sql + ' FROM ' + @ls_age_range_tablename + ' a '
SET @ls_sql = @ls_sql + ' INNER JOIN ' + @ls_age_range_temp_tablename + ' x '
SET @ls_sql = @ls_sql + ' ON a.age_range_id = x.age_range_id '
SET @ls_sql = @ls_sql + ' AND a.age_range_category = x.age_range_category '
SET @ls_sql = @ls_sql + ' AND ISNULL(a.age_from, -1) = ISNULL(x.age_from, -1) '
SET @ls_sql = @ls_sql + ' AND ISNULL(a.age_from_unit, ''!NULL'') = ISNULL(x.age_from_unit, ''!NULL'') '
SET @ls_sql = @ls_sql + ' AND ISNULL(a.age_to, -1) = ISNULL(x.age_to, -1) '
SET @ls_sql = @ls_sql + ' AND ISNULL(a.age_to_unit, ''!NULL'') = ISNULL(x.age_to_unit, ''!NULL'') '
SET @ls_sql = @ls_sql + ' WHERE a.id IS NULL '

-- Execute the [user_id] prep script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1


SET @ls_sql = 
'
DECLARE @ll_age_range_id int

DECLARE lc_mismatch CURSOR LOCAL FAST_FORWARD FOR
SELECT a.age_range_id
FROM ' + @ls_age_range_temp_tablename + ' x
	INNER JOIN c_Age_Range a
	ON x.age_range_id = a.age_range_id
WHERE a.age_range_category <> x.age_range_category
OR ISNULL(a.age_from, -1) <> ISNULL(x.age_from, -1)
OR ISNULL(a.age_from_unit, ''!NULL'') <> ISNULL(x.age_from_unit, ''!NULL'')
OR ISNULL(a.age_to, -1) <> ISNULL(x.age_to, -1)
OR ISNULL(a.age_to_unit, ''!NULL'') <> ISNULL(x.age_to_unit, ''!NULL'')
OR a.id <> x.id
OR a.owner_id <> x.owner_id

OPEN lc_mismatch

FETCH lc_mismatch INTO @ll_age_range_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE sp_local_copy_age_range
		@pl_age_range_id = @ll_age_range_id

	IF @@ERROR <> 0
		RETURN

	DELETE a
	FROM c_Age_Range a
	WHERE a.age_range_id = @ll_age_range_id

	FETCH lc_mismatch INTO @ll_age_range_id
	END

CLOSE lc_mismatch
DEALLOCATE lc_mismatch
'

-- Execute the [user_id] prep script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Process new records but ignore records with primary key collisions
SET @ls_sql = 'SET IDENTITY_INSERT ' + @ls_age_range_tablename + ' ON '
SET @ls_sql = @ls_sql + ' INSERT INTO ' + @ls_age_range_tablename + '(age_range_id, ' + @ls_insert_column_list + ')'
SET @ls_sql = @ls_sql + ' SELECT age_range_id, ' + @ls_select_column_list
SET @ls_sql = @ls_sql + ' FROM ' + @ls_age_range_temp_tablename + ' x'
SET @ls_sql = @ls_sql + ' WHERE NOT EXISTS (SELECT 1 FROM ' + @ls_age_range_tablename + ' t '
SET @ls_sql = @ls_sql + 'WHERE x.age_range_id = t.age_range_id) '
SET @ls_sql = @ls_sql + ' SET IDENTITY_INSERT ' + @ls_age_range_tablename + ' OFF '

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1




RETURN 1

GO
