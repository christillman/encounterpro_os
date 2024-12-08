DROP PROCEDURE [jmjsys_set_table_columns]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_set_table_columns] (
	@ps_which_table [varchar] (64),
	@pl_modification_level int = NULL )
AS

SET NOCOUNT ON

DECLARE @ls_columnname varchar (64) ,
	@li_column_identity smallint ,
	@li_column_nullable smallint ,
	@ls_column_definition varchar(64),
	@ls_sql varchar(4000),
	@ll_error int,
	@ls_error varchar(255),
	@li_default_constraint smallint ,
	@ls_default_constraint_name varchar (64) ,
	@ls_default_constraint_text varchar (64) ,
	@ls_tablename varchar(64),
	@ll_added_count int

IF @pl_modification_level IS NULL
	SELECT @pl_modification_level = modification_level
	FROM c_Database_Status


DECLARE lc_tables CURSOR LOCAL FAST_FORWARD FOR
	SELECT t.tablename
	FROM c_database_table t
		INNER JOIN sysobjects o
		ON t.tablename = o.name
	WHERE tablename LIKE @ps_which_table
	AND o.type ='U'

OPEN lc_tables

FETCH lc_tables INTO @ls_tablename

WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @ll_added_count = 0

	DECLARE lc_columns CURSOR LOCAL FAST_FORWARD FOR
		SELECT cc.columnname,
				cc.column_identity,
				cc.column_nullable,
				cc.column_definition,
				cc.default_constraint,
				cc.default_constraint_name,
				cc.default_constraint_text
		FROM c_database_column cc
		WHERE cc.tablename = @ls_tablename
		AND modification_level <= @pl_modification_level
		AND NOT EXISTS (
			SELECT 1
			FROM sysobjects o
				INNER JOIN syscolumns c
				ON o.id = c.id
			WHERE o.name = cc.tablename
			AND c.name = cc.columnname )
		ORDER BY column_sequence

	OPEN lc_columns

	FETCH lc_columns INTO @ls_columnname, @li_column_identity, @li_column_nullable, @ls_column_definition, @li_default_constraint, @ls_default_constraint_name, @ls_default_constraint_text

	WHILE @@FETCH_STATUS = 0
		BEGIN
		SET @ls_sql = 'ALTER TABLE [dbo].[' + @ls_tablename + '] '
		SET @ls_sql = @ls_sql + 'ADD [' + @ls_columnname + '] ' + @ls_column_definition + ' '
		IF @li_column_identity <> 0
			SET @ls_sql = @ls_sql + 'IDENTITY (1, 1) '
		IF @li_column_nullable = 0
			SET @ls_sql = @ls_sql + 'NOT NULL '
		ELSE
			SET @ls_sql = @ls_sql + 'NULL '
		IF @li_default_constraint <> 0
			SET @ls_sql = @ls_sql + ' DEFAULT ' + @ls_default_constraint_text

		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR

		IF @ll_error <> 0
			RETURN -1

		PRINT 'Added column ' + @ls_columnname + ' to table ' + @ls_tablename
		SET @ll_added_count = @ll_added_count + 1

		FETCH lc_columns INTO @ls_columnname, @li_column_identity, @li_column_nullable, @ls_column_definition, @li_default_constraint, @ls_default_constraint_name, @ls_default_constraint_text
		END

	CLOSE lc_columns
	DEALLOCATE lc_columns

--	IF @ll_added_count = 0
--		PRINT 'No columns added to table ' + @ls_tablename

	FETCH lc_tables INTO @ls_tablename
	END

CLOSE lc_tables
DEALLOCATE lc_tables


GO
