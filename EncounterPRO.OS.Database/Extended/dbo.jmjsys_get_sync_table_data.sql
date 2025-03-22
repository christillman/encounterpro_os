DROP PROCEDURE [jmjsys_get_sync_table_data]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_get_sync_table_data] (
	@ps_tablename varchar(64),
	@ps_sync_tablename varchar(128) = NULL,
	@ps_ids_only char(1) = 'N',
	@ps_new_flag char(1) = 'N',
	@ps_updated_flag char(1) = 'N',
	@ps_all_flag char(1) = 'Y',
	@ps_id_column_name varchar(64) = 'ID',
	@ps_temp_tablename varchar(128) OUTPUT,
	@ps_primary_key_where_clause varchar(4000) OUTPUT,
	@ps_update_set_clause varchar(4000) OUTPUT,
	@ps_insert_column_list varchar(4000) OUTPUT,
	@ps_select_column_list varchar(4000) OUTPUT,
	@pdt_since_datestamp datetime = NULL
)
AS

SET NOCOUNT ON

-- Creates temp tables and copies data from the EproUpdates database
-- If @ps_ids_only, @ps_new_flag, or @ps_updated_flag is 'Y', then we expect
-- the designated to have an [id] uniqueidentifier column.  An error will be returned if it doesn't
--
-- The @ps_temp_tablename OUTPUT param will return the prefix of the temp tablenames in which
-- the desired data has been placed.  The table will only exist if the corresponding
-- flag was set to 'Y'.  To get the actual temp tablename, use the following logic
-- 
-- For New Records:		@ps_temp_tablename + '_New'
-- For Updated Records:	@ps_temp_tablename + '_Updated'
-- For All Records:		@ps_temp_tablename
--
-- If @ps_ids_only = 'Y', then the specified temp tables will be created with only one column:
--		[id] uniqueidentifier
-- This is useful to limit the amount of data copied initially if extra logic will be needed to process in
-- the final sync data

DECLARE @ls_columnname varchar (64) ,
	@li_column_identity smallint ,
	@li_column_nullable smallint ,
	@li_column_primary_key smallint ,
	@ls_column_definition varchar(64),
	@ls_sql varchar(4000),
	@ls_column_create varchar(255),
	@ll_error int,
	@ls_error varchar(255),
	@ls_default_constraint_name varchar (64) ,
	@ls_default_constraint_text varchar (64) ,
	@ll_tableid int ,
	@ls_temp_tablename_new varchar(128) ,
	@ls_temp_tablename_updated varchar(128) ,
	@ls_temp_tablename_ids varchar(128) ,
	@ll_counter int,
	@ll_loop_counter int,
	@ll_max_loop_counter int,
	@ll_max_records int,
	@lui_ID_List uniqueidentifier,
	@lui_ID uniqueidentifier,
	@ls_ID_IN_List varchar(4000),
	@ls_ID_Column_Exists char(1),
	@ls_owner_id_Column_Exists char(1),
	@ls_subscriber_owner_id_Column_Exists char(1),
	@ls_last_updated_column varchar(64),
	@ls_column_list_ids varchar(4000) ,
	@ls_column_list_ids_create varchar(4000) ,
	@ls_column_list_create varchar(4000) ,
	@ls_column_list varchar(4000) ,
	@ls_database_mode varchar(16) ,
	@ls_sync_database varchar(64) ,
	@ll_new_rows int,
	@ll_customer_id int,
	@ls_created_Column_Exists char(1),
	@ll_my_schema_id int,
	@ls_my_schema_name sysname

DECLARE @columns TABLE (
	[columnname] [varchar] (64) NOT NULL ,
	[column_sequence] [int] NOT NULL ,
	[column_datatype] varchar(32) NOT NULL ,
	[column_length] int NOT NULL ,
	[column_identity] bit NOT NULL ,
	[column_nullable] bit NOT NULL ,
	[column_primary_key] bit NOT NULL DEFAULT (0) ,
	[column_definition] [varchar] (64) NOT NULL ,
	[default_constraint] bit NOT NULL ,
	[default_constraint_name] [varchar] (64) NULL ,
	[default_constraint_text] [varchar] (64) NULL ,
	[modification_level] [int] NOT NULL ,
	[last_updated] [datetime] NOT NULL )

DECLARE @columns_available TABLE (
	columnname varchar(64) NOT NULL)


SELECT @ls_my_schema_name = COALESCE(default_schema_name, 'dbo')
FROM sys.database_principals where name = USER

SELECT @ll_my_schema_id = schema_id
FROM sys.schemas
WHERE name = @ls_my_schema_name

-- If th table is c_Component_Param, then the id column is param_id
IF @ps_tablename = 'c_Component_Param' AND @ps_id_column_name = 'ID'
	BEGIN
	SET @ps_id_column_name = 'param_id'
	END

-- Set the maximum number of ID values to put into
-- and IN (id1, id2, ...) clause for getting new and updated records from EproUpdates
SET @ll_max_records = 75

-- If the sync tablename wasn't supplied then assume it is the same as the local tablename
IF @ps_sync_tablename IS NULL
	SET @ps_sync_tablename = @ps_tablename

-- First, make sure the local table is up to date
IF @ps_tablename <> 'c_Config_Object_Library' OR user = 'dbo'
	BEGIN
	EXECUTE jmjsys_set_table_columns @ps_which_table = @ps_tablename
	SET @ll_error = @@ERROR
	IF @ll_error <> 0
		RETURN
	END

SELECT @ls_database_mode = database_mode,
		@ll_customer_id = customer_id
FROM c_Database_Status

---------------------------------------------------------------------------------------------
-- Next, get a list of the columns that are common to both the sync table and the local table
---------------------------------------------------------------------------------------------
-- If the sync tablename was not supplied, set it to be the same as the local tablename.
IF @ps_sync_tablename IS NULL
	SET @ps_sync_tablename = @ps_tablename

-- Determine which database to get sync data from
IF @ls_database_mode = 'Testing'
	BEGIN
	SET @ls_sync_database = 'EproUpdates_Testing'

	-- Get the columns available in the sync table
	SELECT @ll_tableid = id
	FROM jmjtech.EproUpdates_Testing.dbo.sysobjects
	WHERE name = @ps_sync_tablename
	AND type IN ('U', 'V')
	
	IF @@ROWCOUNT = 1
		BEGIN
		INSERT INTO @columns_available (
			columnname)
		SELECT name
		FROM jmjtech.EproUpdates_Testing.dbo.syscolumns
		WHERE id = @ll_tableid
		END
	ELSE
		BEGIN
		SET @ls_sync_database = 'EproUpdates'

		-- Get the columns available in the sync table
		SELECT @ll_tableid = id
		FROM jmjtech.EproUpdates.dbo.sysobjects
		WHERE name = @ps_sync_tablename
		AND type IN ('U', 'V')

		IF @@ROWCOUNT = 1
			BEGIN
			INSERT INTO @columns_available (
				columnname)
			SELECT name
			FROM jmjtech.EproUpdates.dbo.syscolumns
			WHERE id = @ll_tableid
			END
		ELSE
			BEGIN
			RAISERROR ('Sync table not found in sync database (%s)',16,-1, @ps_sync_tablename)
			RETURN
			END
		END
	END
ELSE
	BEGIN
	SET @ls_sync_database = 'EproUpdates'
	
	-- Get the columns available in the sync table
	SELECT @ll_tableid = id
	FROM jmjtech.EproUpdates.dbo.sysobjects
	WHERE name = @ps_sync_tablename
	AND type IN ('U', 'V')

	IF @@ROWCOUNT = 1
		BEGIN
		INSERT INTO @columns_available (
			columnname)
		SELECT name
		FROM jmjtech.EproUpdates.dbo.syscolumns
		WHERE id = @ll_tableid
		END
	ELSE
		BEGIN
		RAISERROR ('Sync table not found in sync database (%s)',16,-1, @ps_sync_tablename)
		RETURN
		END
	END

-- Get the column details for every column that is both in the sync table and in the local table
INSERT INTO @columns (
	columnname ,
	column_sequence ,
	column_datatype ,
	column_length ,
	column_identity ,
	column_nullable ,
	column_definition ,
	default_constraint ,
	default_constraint_name ,
	default_constraint_text ,
	modification_level ,
	last_updated )
SELECT c.columnname ,
	c.column_sequence ,
	c.column_datatype ,
	c.column_length ,
	c.column_identity ,
	c.column_nullable ,
	c.column_definition ,
	c.default_constraint ,
	c.default_constraint_name ,
	c.default_constraint_text ,
	c.modification_level,
	c.last_updated
FROM c_Database_Column c
	INNER JOIN @columns_available x
	ON c.columnname = x.columnname
	INNER JOIN sysobjects o
	ON o.name = c.tablename
	INNER JOIN syscolumns cl
	ON o.id = cl.id
	AND cl.name = c.columnname
WHERE c.tablename = @ps_tablename
AND o.type = 'U'

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN

IF EXISTS(SELECT 1 FROM @columns WHERE columnname = @ps_id_column_name)
	SET @ls_ID_Column_Exists = 'Y'
ELSE
	SET @ls_ID_Column_Exists = 'N'

IF EXISTS(SELECT 1 FROM @columns WHERE columnname = 'created')
	SET @ls_created_Column_Exists = 'Y'
ELSE
	SET @ls_created_Column_Exists = 'N'

IF EXISTS(SELECT 1 FROM @columns WHERE columnname = 'owner_id')
	SET @ls_owner_id_Column_Exists = 'Y'
ELSE
	SET @ls_owner_id_Column_Exists = 'N'

IF EXISTS(SELECT 1 FROM @columns WHERE columnname = 'subscriber_owner_id')
	SET @ls_subscriber_owner_id_Column_Exists = 'Y'
ELSE
	SET @ls_subscriber_owner_id_Column_Exists = 'N'

IF @ps_ids_only = 'Y'
	BEGIN
	IF @ls_ID_Column_Exists = 'N'
		BEGIN
		RAISERROR ('If @ps_ids_only = ''Y'' then table must have an [ID] column (%s)',16,-1, @ps_tablename)
		RETURN
		END
	END

IF @ps_new_flag = 'Y'
	BEGIN
	IF @ls_ID_Column_Exists = 'N'
		BEGIN
		RAISERROR ('If @ps_new_flag = ''Y'' then table must have an [ID] column (%s)',16,-1, @ps_tablename)
		RETURN
		END
	END

IF @ps_updated_flag = 'Y'
	BEGIN
	IF @ls_ID_Column_Exists = 'N'
		BEGIN
		RAISERROR ('If @ps_updated_flag = ''Y'' then table must have an [ID] column (%s)',16,-1, @ps_tablename)
		RETURN
		END
	IF NOT EXISTS(SELECT 1 FROM @columns WHERE columnname IN ('last_updated', 'last_update', 'modified'))
		BEGIN
		RAISERROR ('If @ps_updated_flag = ''Y'' then table must have a [last_updated] column (%s)',16,-1, @ps_tablename)
		RETURN
		END
	
	SELECT @ls_last_updated_column = min(columnname)
	FROM @columns
	WHERE columnname IN ('last_updated', 'last_update', 'modified')
	END


---------------------------------------------------------------------------------------------
-- Identify the local primary key columns
---------------------------------------------------------------------------------------------
UPDATE x
SET column_primary_key = 1
--Select o.name, si.name, cl.name
FROM @columns x
	INNER JOIN sysobjects o
	ON o.name = @ps_tablename
	AND o.type = 'U'
	INNER JOIN syscolumns cl
	ON o.id = cl.id
	AND cl.name = x.columnname
	INNER JOIN sysindexes si
	ON o.id = si.id
	INNER JOIN sysindexkeys sk
	ON si.id = sk.id
	AND si.indid = sk.indid
	AND sk.colid = cl.colid
WHERE ObjectProperty(Object_id(si.name),  'IsPrimaryKey') = 1

---------------------------------------------------------------------------------------------
-- Create the temp tables to hold the table data
---------------------------------------------------------------------------------------------

-- Drop old temp tables
DECLARE lc_oldtmptables CURSOR LOCAL FOR
	SELECT	so.name
	FROM 	sys.objects so
	WHERE	so.type = 'U'
	AND so.name LIKE 'tmpjmjsync%'
	AND so.schema_id = @ll_my_schema_id
	AND so.create_date < DATEADD(day, -7, dbo.get_client_datetime())

OPEN lc_oldtmptables

FETCH lc_oldtmptables INTO @ps_temp_tablename
WHILE @@fetch_status = 0
BEGIN
	EXEC ('DROP TABLE ' + @ps_temp_tablename)
	FETCH lc_oldtmptables INTO @ps_temp_tablename
END

CLOSE lc_oldtmptables
DEALLOCATE lc_oldtmptables

-- Construct a temp table name
SET @ll_counter = 1
WHILE @ll_counter < 100
	BEGIN
	SET @ps_temp_tablename = 'tmpjmjsync_' + @ps_tablename + '_' + CAST(@ll_counter AS varchar(6))

	SET @ls_temp_tablename_new = @ps_temp_tablename + '_new'
	SET @ls_temp_tablename_updated = @ps_temp_tablename + '_updated'
	SET @ls_temp_tablename_ids = @ps_temp_tablename + '_ids'
	
	IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE type = 'U' and name = @ls_temp_tablename_new)
	AND NOT EXISTS (SELECT 1 FROM sysobjects WHERE type = 'U' and name = @ls_temp_tablename_updated)
	AND NOT EXISTS (SELECT 1 FROM sysobjects WHERE type = 'U' and name = @ls_temp_tablename_ids)
	AND NOT EXISTS (SELECT 1 FROM sysobjects WHERE type = 'U' and name = @ps_temp_tablename)
		BREAK

	SET @ll_counter = @ll_counter + 1
	END

IF @ll_counter >= 100
	BEGIN
	RAISERROR ('Unable to determine unique temp table name (%s)',16,-1, @ps_tablename)
	RETURN -1
	END


-- Construct the CREATE statement
DECLARE lc_columns CURSOR LOCAL FAST_FORWARD FOR
	SELECT cc.columnname,
			cc.column_identity,
			cc.column_nullable,
			cc.column_definition,
			cc.column_primary_key
	FROM @columns cc
	ORDER BY cc.column_sequence

OPEN lc_columns

FETCH lc_columns INTO @ls_columnname, @li_column_identity, @li_column_nullable, @ls_column_definition, @li_column_primary_key

SET @ls_column_list = ''
SET @ls_column_list_create = ''
SET @ls_column_list_ids = ''
SET @ls_column_list_ids_create = ''
SET @ps_primary_key_where_clause = ''
SET @ps_insert_column_list = ''
SET @ps_update_set_clause = ''
SET @ps_select_column_list = ''

IF @ps_ids_only IS NULL OR @ps_ids_only <> 'Y'
	SET @ps_ids_only = 'N'

WHILE @@FETCH_STATUS = 0
	BEGIN
	IF @ps_ids_only = 'N' OR @ls_columnname IN (@ps_id_column_name, @ls_last_updated_column)
		BEGIN
		IF @ls_column_list = ''
			SET @ls_column_list = @ls_columnname
		ELSE
			SET @ls_column_list = @ls_column_list + ', ' + @ls_columnname

		SET @ls_column_create = '[' + @ls_columnname + '] ' + @ls_column_definition + ' '
	--	IF @li_column_identity <> 0
	--		SET @ls_column_create = @ls_column_create + 'IDENTITY (1, 1) '
		IF @li_column_nullable = 0
			SET @ls_column_create = @ls_column_create + 'NOT NULL '
		ELSE
			SET @ls_column_create = @ls_column_create + 'NULL '
			
		IF @ls_column_list_create = ''
			SET @ls_column_list_create = @ls_column_create
		ELSE
			SET @ls_column_list_create = @ls_column_list_create + ', ' + @ls_column_create
		
		-- If this is an ID column, then add it to the IDS defs
		IF @ls_columnname IN (@ps_id_column_name, @ls_last_updated_column)
			BEGIN
			IF @ls_column_list_ids = ''
				SET @ls_column_list_ids = @ls_columnname
			ELSE
				SET @ls_column_list_ids = @ls_column_list_ids + ', ' + @ls_columnname
			
			IF @ls_column_list_ids_create = ''
				SET @ls_column_list_ids_create = @ls_column_create
			ELSE
				SET @ls_column_list_ids_create = @ls_column_list_ids_create + ', ' + @ls_column_create
			END
		END

	-- Construct the INSERT column list
	IF @li_column_identity = 0
		BEGIN
		IF @ps_insert_column_list = ''
			SET @ps_insert_column_list = @ls_columnname
		ELSE
			SET @ps_insert_column_list = @ps_insert_column_list + ', ' + @ls_columnname

		IF @ps_select_column_list = ''
			SET @ps_select_column_list = 'x.' + @ls_columnname
		ELSE
			SET @ps_select_column_list = @ps_select_column_list + ', x.' + @ls_columnname
		END


	IF @li_column_primary_key = 1
		BEGIN
		IF @li_column_identity = 0
			BEGIN
			-- Construct the primary key where clause
			IF @ps_primary_key_where_clause <> ''
				SET @ps_primary_key_where_clause = @ps_primary_key_where_clause + ' AND '
				
			SET @ps_primary_key_where_clause = @ps_primary_key_where_clause + 'x.' + @ls_columnname + ' = t.' + @ls_columnname
			END
		END
	ELSE
		BEGIN
		-- If this is not a primary key column, then construct the UPDATE columns SET clause
		IF @ls_columnname <> @ps_id_column_name AND @li_column_identity = 0
			BEGIN
			IF @ps_update_set_clause <> ''
				SET @ps_update_set_clause = @ps_update_set_clause + ', '
				
			SET @ps_update_set_clause = @ps_update_set_clause + @ls_columnname + ' = x.' + @ls_columnname
			END
		END

	FETCH lc_columns INTO @ls_columnname, @li_column_identity, @li_column_nullable, @ls_column_definition, @li_column_primary_key
	END

CLOSE lc_columns
DEALLOCATE lc_columns

IF @ls_column_list = ''
	BEGIN
	IF @ps_ids_only = 'Y'
		BEGIN
		RAISERROR ('Table has no [ID] column (%s)',16,-1, @ps_tablename)
		RETURN -1
		END
	ELSE
		BEGIN
		RAISERROR ('Table has no columns (%s)',16,-1, @ps_tablename)
		RETURN -1
		END
	END

-- Add new_flag and updated_flag to the IDs temp table
SET @ls_column_list_ids_create = @ls_column_list_ids_create + ', [new_flag] char(1), [updated_flag] char(1)'


---------------------------------------------------------------------------------------------
-- Copy the data from the sync table to the temp table
---------------------------------------------------------------------------------------------

IF @ls_ID_Column_Exists = 'Y'
	BEGIN
	-- First create the IDs temp table
	SET @ls_sql = 'CREATE TABLE [' + @ls_temp_tablename_ids + ']( '
	SET @ls_sql = @ls_sql + @ls_column_list_ids_create + ')'

	-- Execute the create script
	EXECUTE (@ls_sql)
	SET @ll_error = @@ERROR
	IF @ll_error <> 0
		RETURN -1
	END

IF @ps_all_flag = 'Y'
	BEGIN
	-- First create the "All" table
	SET @ls_sql = 'CREATE TABLE [' + @ps_temp_tablename + ']( '
	SET @ls_sql = @ls_sql + @ls_column_list_create + ')'

	-- Execute the create script
	EXECUTE (@ls_sql)
	SET @ll_error = @@ERROR
	IF @ll_error <> 0
		RETURN -1
	
	
	-- Then get all the data
	SET @ls_sql = 'INSERT INTO ' + @ps_temp_tablename + ' (' + @ls_column_list + ') '
	SET @ls_sql = @ls_sql + 'SELECT ' + @ls_column_list + ' FROM jmjtech.' + @ls_sync_database + '.dbo.' + @ps_sync_tablename
	IF @ls_subscriber_owner_id_Column_Exists = 'Y'
		SET @ls_sql = @ls_sql + ' WHERE subscriber_owner_id = ' + CAST(@ll_customer_id AS varchar(12))
	ELSE IF @ls_owner_id_Column_Exists = 'Y' AND @ps_tablename <> 'c_Config_Object_Library'
		SET @ls_sql = @ls_sql + ' WHERE owner_id < 900'

	-- Execute the data transfer script
	EXECUTE (@ls_sql)
	SET @ll_error = @@ERROR
	IF @ll_error <> 0
		RETURN -1

	IF @ls_ID_Column_Exists = 'Y'
		BEGIN
		-- Then get all the ids from the local copy
		SET @ls_sql = 'INSERT INTO ' + @ls_temp_tablename_ids + ' (' + @ls_column_list_ids + ') '
		SET @ls_sql = @ls_sql + 'SELECT ' + @ls_column_list_ids + ' FROM ' + @ps_temp_tablename

		-- Execute the data transfer script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1
		END
	END
ELSE IF @ls_ID_Column_Exists = 'Y' AND @pdt_since_datestamp IS NULL
	BEGIN
	-- Since we didn't get all the data, then the IDs temp table data must come from EproUpdates 
	-- Then get all the data
	SET @ls_sql = 'INSERT INTO ' + @ls_temp_tablename_ids + ' (' + @ls_column_list_ids + ') '
	SET @ls_sql = @ls_sql + 'SELECT ' + @ls_column_list_ids + ' FROM jmjtech.' + @ls_sync_database + '.dbo.' + @ps_sync_tablename
	IF @ls_subscriber_owner_id_Column_Exists = 'Y'
		SET @ls_sql = @ls_sql + ' WHERE subscriber_owner_id = ' + CAST(@ll_customer_id AS varchar(12))
	ELSE IF @ls_owner_id_Column_Exists = 'Y' 
		BEGIN
		IF @ps_tablename = 'c_XML_Code'
			SET @ls_sql = @ls_sql + ' WHERE owner_id = 0 AND status = ''OK'''
		ELSE IF @ps_tablename <> 'c_Config_Object_Library'
			SET @ls_sql = @ls_sql + ' WHERE owner_id < 900'
		END

	-- Execute the data transfer script
	EXECUTE (@ls_sql)
	SET @ll_error = @@ERROR
	IF @ll_error <> 0
		RETURN -1
	END

IF @ps_new_flag = 'Y'
	BEGIN
	-- First create the "New" table
	SET @ls_sql = 'CREATE TABLE [' + @ls_temp_tablename_new + ']( '
	SET @ls_sql = @ls_sql + @ls_column_list_create + ')'

	-- Execute the create script
	EXECUTE (@ls_sql)
	SET @ll_error = @@ERROR
	IF @ll_error <> 0
		RETURN -1
	
	IF @ls_created_Column_Exists = 'Y' AND @pdt_since_datestamp IS NOT NULL AND @ps_all_flag = 'N'
		BEGIN
		-- Use "Since Datestamp" logic

		-- Get all the records where the [created] field is greater than the datestamp
		SET @ls_sql = 'INSERT INTO ' + @ls_temp_tablename_new + ' (' + @ls_column_list + ') '
		SET @ls_sql = @ls_sql + 'SELECT ' + @ls_column_list
		SET @ls_sql = @ls_sql + ' FROM jmjtech.' + @ls_sync_database + '.dbo.' + @ps_sync_tablename
		SET @ls_sql = @ls_sql + ' WHERE created > CAST(''' + CONVERT(varchar(40), @pdt_since_datestamp, 126) + ''' AS datetime)'
		
		-- Execute the UPDATE script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1
		
		END
	ELSE
		BEGIN
		-- Update the new_flag in the IDs table
		SET @ls_sql = 'UPDATE x SET new_flag = ''Y'''
		SET @ls_sql = @ls_sql + 'FROM ' + @ls_temp_tablename_ids + ' x '
		SET @ls_sql = @ls_sql + 'WHERE NOT EXISTS ( SELECT 1 FROM ' + @ps_tablename + ' t '
		SET @ls_sql = @ls_sql + 'WHERE t.' + @ps_id_column_name + ' = x.' + @ps_id_column_name + ')'
		
		-- Execute the UPDATE script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1
		
		-- Generate a new list ID
		SET @lui_ID_List = newid()

		-- Add the new ID values to x_ID_Lists
		SET @ls_sql = 'INSERT INTO x_ID_Lists (IDList, ID) SELECT ''' + CAST(@lui_ID_List AS varchar(38))
		SET @ls_sql = @ls_sql + ''', ' + @ps_id_column_name + ' FROM ' + @ls_temp_tablename_ids
		SET @ls_sql = @ls_sql + ' WHERE new_flag = ''Y'''
		
		-- Execute the SQL script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1

		-- Count the new rows
		SET @ll_new_rows = (SELECT count(*) FROM x_ID_Lists WHERE IDList = @lui_ID_List)

		IF CAST(CAST(SERVERPROPERTY('ProductVersion') AS char(1)) AS int) = 8 OR @ll_new_rows > 1000
			BEGIN

			-- Then get the new data
			SET @ls_sql = 'INSERT INTO ' + @ls_temp_tablename_new + ' (' + @ls_column_list + ') '
			SET @ls_sql = @ls_sql + 'SELECT ' + @ls_column_list
			IF @ps_all_flag = 'Y'
				SET @ls_sql = @ls_sql + ' FROM ' + @ps_temp_tablename
			ELSE
				SET @ls_sql = @ls_sql + ' FROM jmjtech.' + @ls_sync_database + '.dbo.' + @ps_sync_tablename
			IF @ls_subscriber_owner_id_Column_Exists = 'Y'
				SET @ls_sql = @ls_sql + ' WHERE subscriber_owner_id = ' + CAST(@ll_customer_id AS varchar(12))

			-- Execute the data transfer script
			EXECUTE (@ls_sql)
			SET @ll_error = @@ERROR
			IF @ll_error <> 0
				RETURN -1

			-- Delete the "got" IDs
			SET @ls_sql = 'DELETE FROM ' + @ls_temp_tablename_new 
			SET @ls_sql = @ls_sql + ' WHERE ' + @ps_id_column_name 
			SET @ls_sql = @ls_sql + ' NOT IN (SELECT ID FROM x_id_lists WHERE IDList = ''' + CAST(@lui_ID_List AS varchar(38)) + ''')'

			-- Execute the data transfer script
			EXECUTE (@ls_sql)
			SET @ll_error = @@ERROR
			IF @ll_error <> 0
				RETURN -1
				
			END -- IF SQL 2000
		ELSE
			BEGIN
			SET @ll_loop_counter = 0
			SELECT @ll_max_loop_counter = (COUNT(*) / @ll_max_records) + 1
			FROM x_ID_Lists
			WHERE IDList = @lui_ID_List
			
			WHILE EXISTS (SELECT ID FROM x_ID_Lists WHERE IDList = @lui_ID_List)
				BEGIN
				
				DECLARE lc_new_ids CURSOR LOCAL FAST_FORWARD FOR
					SELECT ID
					FROM x_ID_Lists
					WHERE IDList = @lui_ID_List
			
				OPEN lc_new_ids
				
				FETCH lc_new_ids INTO @lui_ID
				
				SET @ll_counter = 1
				SET @ls_ID_IN_List = ''
				
				WHILE @@FETCH_STATUS = 0
					BEGIN
					IF @ls_ID_IN_List = ''
						SET @ls_ID_IN_List = '''' + CAST(@lui_ID AS varchar(38)) + ''''
					ELSE
						SET @ls_ID_IN_List = @ls_ID_IN_List + ', ''' + CAST(@lui_ID AS varchar(38)) + ''''
					
					SET @ll_counter = @ll_counter + 1
					IF @ll_counter > @ll_max_records
						BREAK
					
					FETCH lc_new_ids INTO @lui_ID
					END
				
				CLOSE lc_new_ids
				DEALLOCATE lc_new_ids


				-- Then get the new data
				SET @ls_sql = 'INSERT INTO ' + @ls_temp_tablename_new + ' (' + @ls_column_list + ') '
				SET @ls_sql = @ls_sql + 'SELECT ' + @ls_column_list
				IF @ps_all_flag = 'Y'
					SET @ls_sql = @ls_sql + ' FROM ' + @ps_temp_tablename
				ELSE
					SET @ls_sql = @ls_sql + ' FROM jmjtech.' + @ls_sync_database + '.dbo.' + @ps_sync_tablename
				SET @ls_sql = @ls_sql + ' WHERE ' + @ps_id_column_name + ' IN (' + @ls_ID_IN_List + ')'
				IF @ls_subscriber_owner_id_Column_Exists = 'Y'
					SET @ls_sql = @ls_sql + ' AND subscriber_owner_id = ' + CAST(@ll_customer_id AS varchar(12))

				-- Execute the data transfer script
				EXECUTE (@ls_sql)
				SET @ll_error = @@ERROR
				IF @ll_error <> 0
					RETURN -1

				-- Delete the "got" IDs
				SET @ls_sql = 'DELETE FROM x_ID_Lists WHERE IDList = ''' + CAST(@lui_ID_List AS varchar(38))
				SET @ls_sql = @ls_sql + ''' AND ID IN (' + @ls_ID_IN_List + ')'

				-- Execute the data transfer script
				EXECUTE (@ls_sql)
				SET @ll_error = @@ERROR
				IF @ll_error <> 0
					RETURN -1
				
				-- Check against an endless loop
				SET @ll_loop_counter = @ll_loop_counter + 1
				IF @ll_loop_counter > @ll_max_loop_counter
					BEGIN
					RAISERROR ('New Records Loop maximum exceeded',16,-1, @ps_tablename)
					RETURN -1
					END
					
				END -- While ID records still exist
			END -- IF SQL 2005 or later
		END -- Not using "Since Datestamp" logic
	END -- new_flag = 'Y'


IF @ps_updated_flag = 'Y'
	BEGIN
	-- First create the "Updated" table
	SET @ls_sql = 'CREATE TABLE [' + @ls_temp_tablename_updated + ']( '
	SET @ls_sql = @ls_sql + @ls_column_list_create + ')'

	-- Execute the create script
	EXECUTE (@ls_sql)
	SET @ll_error = @@ERROR
	IF @ll_error <> 0
		RETURN -1
	
	
	IF @ls_created_Column_Exists = 'Y' AND @pdt_since_datestamp IS NOT NULL AND @ps_all_flag = 'N'
		BEGIN
		-- Since Datestamp logic

		-- Then get the updated data
		SET @ls_sql = 'INSERT INTO ' + @ls_temp_tablename_updated + ' (' + @ls_column_list + ') '
		SET @ls_sql = @ls_sql + 'SELECT ' + @ls_column_list
		SET @ls_sql = @ls_sql + ' FROM jmjtech.' + @ls_sync_database + '.dbo.' + @ps_sync_tablename
		SET @ls_sql = @ls_sql + ' WHERE ' + @ls_last_updated_column + ' > CAST(''' + CONVERT(varchar(40), @pdt_since_datestamp, 126) + ''' AS datetime)'
		IF @ls_subscriber_owner_id_Column_Exists = 'Y'
			SET @ls_sql = @ls_sql + ' AND subscriber_owner_id = ' + CAST(@ll_customer_id AS varchar(12))

		-- Execute the data transfer script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1

		END
	ELSE
		BEGIN
		-- Update the new_flag in the IDs table
		SET @ls_sql = 'UPDATE x SET updated_flag = ''Y'''
		SET @ls_sql = @ls_sql + 'FROM ' + @ls_temp_tablename_ids + ' x '
		SET @ls_sql = @ls_sql + 'INNER JOIN ' + @ps_tablename + ' t '
		SET @ls_sql = @ls_sql + 'ON t.' + @ps_id_column_name + ' = x.' + @ps_id_column_name + ' '
		SET @ls_sql = @ls_sql + 'WHERE t.' + @ls_last_updated_column + ' < x.' + @ls_last_updated_column
		
		-- Execute the UPDATE script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1
		
		-- Generate a new list ID
		SET @lui_ID_List = newid()

		-- Add the new ID values to x_ID_Lists
		SET @ls_sql = 'INSERT INTO x_ID_Lists (IDList, ID) SELECT ''' + CAST(@lui_ID_List AS varchar(38))
		SET @ls_sql = @ls_sql + ''', ' + @ps_id_column_name + ' FROM ' + @ls_temp_tablename_ids
		SET @ls_sql = @ls_sql + ' WHERE updated_flag = ''Y'''
		
		-- Execute the SQL script
		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1
		
		SET @ll_loop_counter = 0
		SELECT @ll_max_loop_counter = (COUNT(*) / @ll_max_records) + 1
		FROM x_ID_Lists
		WHERE IDList = @lui_ID_List
		
		WHILE EXISTS (SELECT ID FROM x_ID_Lists WHERE IDList = @lui_ID_List)
			BEGIN
			
			DECLARE lc_new_ids CURSOR LOCAL FAST_FORWARD FOR
				SELECT ID
				FROM x_ID_Lists
				WHERE IDList = @lui_ID_List
		
			OPEN lc_new_ids
			
			FETCH lc_new_ids INTO @lui_ID
			
			SET @ll_counter = 1
			SET @ls_ID_IN_List = ''
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
				IF @ls_ID_IN_List = ''
					SET @ls_ID_IN_List = '''' + CAST(@lui_ID AS varchar(38)) + ''''
				ELSE
					SET @ls_ID_IN_List = @ls_ID_IN_List + ', ''' + CAST(@lui_ID AS varchar(38)) + ''''
				
				SET @ll_counter = @ll_counter + 1
				IF @ll_counter > @ll_max_records
					BREAK
				
				FETCH lc_new_ids INTO @lui_ID
				END
			
			CLOSE lc_new_ids
			DEALLOCATE lc_new_ids


			-- Then get the updated data
			SET @ls_sql = 'INSERT INTO ' + @ls_temp_tablename_updated + ' (' + @ls_column_list + ') '
			SET @ls_sql = @ls_sql + 'SELECT ' + @ls_column_list
			IF @ps_all_flag = 'Y'
				SET @ls_sql = @ls_sql + ' FROM ' + @ps_temp_tablename
			ELSE
				SET @ls_sql = @ls_sql + ' FROM jmjtech.' + @ls_sync_database + '.dbo.' + @ps_sync_tablename
			SET @ls_sql = @ls_sql + ' WHERE ' + @ps_id_column_name + ' IN (' + @ls_ID_IN_List + ')'
			IF @ls_subscriber_owner_id_Column_Exists = 'Y'
				SET @ls_sql = @ls_sql + ' AND subscriber_owner_id = ' + CAST(@ll_customer_id AS varchar(12))

			-- Execute the data transfer script
			EXECUTE (@ls_sql)
			SET @ll_error = @@ERROR
			IF @ll_error <> 0
				RETURN -1

			-- Delete the "got" IDs
			SET @ls_sql = 'DELETE FROM x_ID_Lists WHERE IDList = ''' + CAST(@lui_ID_List AS varchar(38))
			SET @ls_sql = @ls_sql + ''' AND ID IN (' + @ls_ID_IN_List + ')'

			-- Execute the data transfer script
			EXECUTE (@ls_sql)
			SET @ll_error = @@ERROR
			IF @ll_error <> 0
				RETURN -1
			
			-- Check against an endless loop
			SET @ll_loop_counter = @ll_loop_counter + 1
			IF @ll_loop_counter > @ll_max_loop_counter
				BEGIN
				RAISERROR ('New Records Loop maximum exceeded',16,-1, @ps_tablename)
				RETURN -1
				END
				
			END -- While ID records still exist
		END -- Not using "Since Datestamnp" logic
	END -- updated_flag = 'Y'





RETURN 1

GO
