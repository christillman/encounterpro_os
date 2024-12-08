DROP PROCEDURE [jmjsys_database_fix_table]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_database_fix_table]
	(
	@ps_tablename varchar(64)
	)
AS

DECLARE @ll_modification_level int,
		@ll_count int,
		@ll_rowcount int,
		@ll_error int,
		@ls_temp_table varchar(128),
		@ls_table_suffix varchar(32),
		@ls_columnname varchar (64) ,
		@li_column_identity smallint ,
		@li_column_nullable smallint ,
		@ls_column_definition varchar(64),
		@ll_is_identity int,
		@ls_sql_create_temp_table varchar(4000),
		@ls_sql_insert_temp_table varchar(4000),
		@ls_sql_temp varchar(4000),
		@ls_column_list varchar(4000),
		@ls_renamed_table varchar(128)

DECLARE @results TABLE (
	sql_rowcount int NULL,
	sql_error int NULL)

SELECT @ll_modification_level = modification_level
FROM c_Database_Status

-- Make sure table exists in c_database_table
SELECT @ll_count = count(*)
FROM c_Database_Table
WHERE tablename = @ps_tablename

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_rowcount <> 1 or @ll_error <> 0
	BEGIN
	RAISERROR ('Error validating tablename (%s)',16,-1, @ps_tablename)
	RETURN -1
	END

IF @ll_count <> 1
	BEGIN
	RAISERROR ('Invalid tablename (%s)',16,-1, @ps_tablename)
	RETURN -1
	END

SET @ls_table_suffix = CONVERT(varchar(32), dbo.get_client_datetime(), 121)
SET @ls_table_suffix = REPLACE(@ls_table_suffix, ' ', '')
SET @ls_table_suffix = REPLACE(@ls_table_suffix, ':', '')
SET @ls_table_suffix = REPLACE(@ls_table_suffix, '.', '')
SET @ls_table_suffix = REPLACE(@ls_table_suffix, '-', '')

SET @ls_temp_table = 'tmpjmjfixing_' + @ps_tablename + '_' + @ls_table_suffix

SET @ls_renamed_table = 'tmpjmjfixed_' + @ps_tablename + '_' + @ls_table_suffix

SET @ll_is_identity = 0

-- Construct the new table
DECLARE lc_columns CURSOR LOCAL FAST_FORWARD FOR
	SELECT cc.columnname,
			cc.column_identity,
			cc.column_nullable,
			cc.column_definition
	FROM c_database_column cc
	WHERE tablename = @ps_tablename
	ORDER BY cc.column_sequence

OPEN lc_columns

FETCH lc_columns INTO @ls_columnname, @li_column_identity, @li_column_nullable, @ls_column_definition

SET @ls_sql_create_temp_table = 'CREATE TABLE [dbo].[' + @ls_temp_table + ']( '

SET @ls_column_list = ''

WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @ls_sql_create_temp_table = @ls_sql_create_temp_table + '[' + @ls_columnname + '] ' + @ls_column_definition + ' '
	IF @li_column_identity <> 0
		BEGIN
		SET @ls_sql_create_temp_table = @ls_sql_create_temp_table + 'IDENTITY (1, 1) '
		SET @ll_is_identity = 1
		END
	IF @li_column_nullable = 0
		SET @ls_sql_create_temp_table = @ls_sql_create_temp_table + 'NOT NULL '
	ELSE
		SET @ls_sql_create_temp_table = @ls_sql_create_temp_table + 'NULL '
	SET @ls_sql_create_temp_table = @ls_sql_create_temp_table + ', '

	IF EXISTS (SELECT 1
				FROM sys.objects o
				INNER JOIN sys.columns c
				ON c.object_id = o.object_id
				WHERE o.name = @ps_tablename
				AND c.name = @ls_columnname)
		BEGIN
		-- Column exists in the actual table
		IF @ls_column_list = ''
			SET @ls_column_list = @ls_columnname
		ELSE
			SET @ls_column_list = @ls_column_list + ', ' + @ls_columnname
		END
	ELSE
		BEGIN
		-- Column does not exist in the actual table
		IF @li_column_nullable = 0
			BEGIN
			-- If the column does not exist in the actual table and it is no nullable, then we
			-- have an error condition and we cannot continue
			RAISERROR ('Error: Column %s.%s does not exist and is not nullable',16,-1, @ps_tablename, @ls_columnname)
			RETURN -1
			END
		END


	FETCH lc_columns INTO @ls_columnname, @li_column_identity, @li_column_nullable, @ls_column_definition
	END

CLOSE lc_columns
DEALLOCATE lc_columns

-- Remove the comma and add a paren
SET @ls_sql_create_temp_table = LEFT(@ls_sql_create_temp_table, LEN(@ls_sql_create_temp_table) - 2)
SET @ls_sql_create_temp_table = @ls_sql_create_temp_table + ')'

IF @ll_is_identity > 0
	SET @ls_sql_insert_temp_table = 'SET IDENTITY_INSERT ' + @ls_temp_table + ' ON 
'
ELSE
	SET @ls_sql_insert_temp_table = ''
SET @ls_sql_insert_temp_table = @ls_sql_insert_temp_table + 'INSERT INTO [dbo].[' + @ls_temp_table + ']( '
SET @ls_sql_insert_temp_table = @ls_sql_insert_temp_table + @ls_column_list
SET @ls_sql_insert_temp_table = @ls_sql_insert_temp_table + ') SELECT ' + @ls_column_list
SET @ls_sql_insert_temp_table = @ls_sql_insert_temp_table + ' FROM ' + @ps_tablename
IF @ll_is_identity > 0
	SET @ls_sql_insert_temp_table = @ls_sql_insert_temp_table + '
SET IDENTITY_INSERT ' + @ls_temp_table + ' OFF 
'



--print @ls_sql_create_temp_table
--print @ls_sql_insert_temp_table



BEGIN TRANSACTION

-- Check existence of table and collect exclusive table lock
SET @ls_sql_temp = '
DECLARE @ll_count int

SELECT @ll_count = count(*)
FROM ' +  @ps_tablename + ' WITH (TABLOCKX)

SELECT @@ROWCOUNT, @@ERROR
'

DELETE @results

INSERT INTO @results (sql_rowcount, sql_error)
EXECUTE (@ls_sql_temp)

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	BEGIN
	RAISERROR ('Error checking tablename:  %s',16,-1, @ls_sql_temp)
	ROLLBACK TRANSACTION
	RETURN -1
	END


EXECUTE (@ls_sql_create_temp_table)

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	BEGIN
	RAISERROR ('Error creating temp table:  %s',16,-1, @ls_sql_create_temp_table)
	ROLLBACK TRANSACTION
	RETURN -1
	END

EXECUTE (@ls_sql_insert_temp_table)

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	BEGIN
	RAISERROR ('Error inserting records into temp table:  %s',16,-1, @ls_sql_insert_temp_table)
	ROLLBACK TRANSACTION
	RETURN -1
	END


-- Rename the table
SET @ls_sql_temp = 'sp_rename ''' + @ps_tablename + ''', ''' + @ls_renamed_table + ''''
EXECUTE (@ls_sql_temp)

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	BEGIN
	RAISERROR ('Error renaming table:  %s',16,-1, @ls_sql_temp)
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Rename the temp table
SET @ls_sql_temp = 'sp_rename ''' + @ls_temp_table + ''', ''' + @ps_tablename + ''''
EXECUTE (@ls_sql_temp)

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	BEGIN
	RAISERROR ('Error renaming table:  %s',16,-1, @ls_sql_temp)
	ROLLBACK TRANSACTION
	RETURN -1
	END

COMMIT TRANSACTION

-- Drop the constraints on the old table
SET @ls_sql_temp = 'sp_drop_constraints ''' + @ls_renamed_table + ''''
EXECUTE (@ls_sql_temp)

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	BEGIN
	RAISERROR ('Error dropping constraints:  %s',16,-1, @ls_sql_temp)
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Rebuild the constraints on the new table
SET @ls_sql_temp = 'sp_rebuild_constraints ''' + @ps_tablename + ''''
EXECUTE (@ls_sql_temp)

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	BEGIN
	RAISERROR ('Error rebuilding constraints:  %s',16,-1, @ls_sql_temp)
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Delete the temp table
SET @ls_sql_temp = 'DROP TABLE ' + @ls_renamed_table
EXECUTE (@ls_sql_temp)

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	BEGIN
	RAISERROR ('Error dropping table:  %s',16,-1, @ls_sql_temp)
	ROLLBACK TRANSACTION
	RETURN -1
	END


GO
GRANT EXECUTE ON [jmjsys_database_fix_table] TO [cprsystem] AS [dbo]
GO
