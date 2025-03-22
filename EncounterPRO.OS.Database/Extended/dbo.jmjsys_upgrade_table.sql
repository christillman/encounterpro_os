DROP PROCEDURE [jmjsys_upgrade_table]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_upgrade_table] (
	@ps_tablename varchar(64),
	@pl_modification_level int )
AS

SET NOCOUNT ON

DECLARE @ls_columnname varchar (64) ,
	@li_column_identity smallint ,
	@li_column_nullable smallint ,
	@ls_column_definition varchar(64),
	@ls_sql varchar(4000),
	@ll_error int,
	@ll_rowcount int,
	@ls_error varchar(255),
	@li_default_constraint smallint ,
	@ls_default_constraint_name varchar (64) ,
	@ls_default_constraint_text varchar (64) ,
	@ll_table_modification_level int

DECLARE @columns TABLE (
	[columnname] [varchar] (64) NOT NULL ,
	[column_sequence] [int] NOT NULL ,
	[column_datatype] varchar(32) NOT NULL ,
	[column_length] int NOT NULL ,
	[column_identity] bit NOT NULL ,
	[column_nullable] bit NOT NULL ,
	[column_definition] [varchar] (64) NOT NULL ,
	[default_constraint] bit NOT NULL ,
	[default_constraint_name] [varchar] (64) NULL ,
	[default_constraint_text] [varchar] (64) NULL ,
	[modification_level] [int] NOT NULL ,
	[last_updated] [datetime] NOT NULL )

SELECT @ll_table_modification_level = modification_level
FROM c_Database_Table
WHERE tablename = @ps_tablename

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount <> 1
	BEGIN
	RAISERROR ('Invalid tablename',16,-1)
	RETURN -1
	END

IF @pl_modification_level IS NULL OR @pl_modification_level < 100
	BEGIN
	RAISERROR ('Invalid modification_level',16,-1)
	RETURN -1
	END

IF @ll_table_modification_level > @pl_modification_level
	BEGIN
	RAISERROR ('Table is not valid for this mod level (%s, %d)',16,-1, @ps_tablename, @pl_modification_level)
	RETURN -1
	END

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
SELECT columnname ,
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
	last_updated
FROM dbo.c_Database_Column
WHERE tablename = @ps_tablename
AND modification_level <= @pl_modification_level

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1


-- See if the table exists
if not exists (select * from dbo.sysobjects where id = object_id('dbo.' + @ps_tablename) and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	BEGIN
	DECLARE lc_columns CURSOR LOCAL FAST_FORWARD FOR
		SELECT cc.columnname,
				cc.column_identity,
				cc.column_nullable,
				cc.column_definition
		FROM @columns cc
		ORDER BY cc.column_sequence

	OPEN lc_columns

	FETCH lc_columns INTO @ls_columnname, @li_column_identity, @li_column_nullable, @ls_column_definition

	SET @ls_sql = 'CREATE TABLE [dbo].[' + @ps_tablename + ']( '

	WHILE @@FETCH_STATUS = 0
		BEGIN
		SET @ls_sql = @ls_sql + '[' + @ls_columnname + '] ' + @ls_column_definition + ' '
		IF @li_column_identity <> 0
			SET @ls_sql = @ls_sql + 'IDENTITY (1, 1) '
		IF @li_column_nullable = 0
			SET @ls_sql = @ls_sql + 'NOT NULL '
		ELSE
			SET @ls_sql = @ls_sql + 'NULL '
		SET @ls_sql = @ls_sql + ', '

		FETCH lc_columns INTO @ls_columnname, @li_column_identity, @li_column_nullable, @ls_column_definition
		END

	CLOSE lc_columns
	DEALLOCATE lc_columns

	-- Remove the comma and add a paren
	SET @ls_sql = LEFT(@ls_sql, LEN(@ls_sql) - 2)

	SET @ls_sql = @ls_sql + ')'

	-- Execute the create script
	EXECUTE (@ls_sql)
	SET @ll_error = @@ERROR

	IF @ll_error <> 0
		BEGIN
		PRINT 'Error Creating Table ' + @ps_tablename
		PRINT @ls_sql
		RETURN -1
		END

	PRINT 'Created Table ' + @ps_tablename

	EXECUTE sp_rebuild_constraints @ps_tablename

	END -- Create table

-- Now make sure all the columns are there
DECLARE lc_columns CURSOR LOCAL FAST_FORWARD FOR
	SELECT cc.columnname,
			cc.column_identity,
			cc.column_nullable,
			cc.column_definition,
			cc.default_constraint,
			cc.default_constraint_name,
			cc.default_constraint_text
	FROM @columns cc
	WHERE NOT EXISTS (
		SELECT 1
		FROM sysobjects o
			INNER JOIN syscolumns c
			ON o.id = c.id
		WHERE o.name = @ps_tablename
		AND c.name = cc.columnname )
	ORDER BY cc.column_sequence

OPEN lc_columns

FETCH lc_columns INTO @ls_columnname, @li_column_identity, @li_column_nullable, @ls_column_definition, @li_default_constraint, @ls_default_constraint_name, @ls_default_constraint_text

WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @ls_sql = 'ALTER TABLE [dbo].[' + @ps_tablename + '] '
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

	FETCH lc_columns INTO @ls_columnname, @li_column_identity, @li_column_nullable, @ls_column_definition, @li_default_constraint, @ls_default_constraint_name, @ls_default_constraint_text
	END

CLOSE lc_columns
DEALLOCATE lc_columns


-- Then, make sure all the default constraints are there
DECLARE lc_columns CURSOR LOCAL FAST_FORWARD FOR
	SELECT columnname,
			default_constraint_name,
			default_constraint_text
	FROM @columns
	WHERE default_constraint = 1

OPEN lc_columns

FETCH lc_columns INTO @ls_columnname, @ls_default_constraint_name, @ls_default_constraint_text

WHILE @@FETCH_STATUS = 0
	BEGIN
	IF EXISTS (
		SELECT 1
		FROM sysobjects o
			INNER JOIN syscolumns c
			ON o.id = c.id
		WHERE o.name = @ps_tablename
		AND c.name = @ls_columnname)
	AND NOT EXISTS (SELECT 1
					FROM sysobjects o
						INNER JOIN syscolumns c
						ON o.id = c.id
						INNER JOIN sysconstraints d
						ON o.id = d.id
						AND c.colid = d.colid
						AND c.cdefault = d.constid
					WHERE o.name = @ps_tablename
					AND c.name = @ls_columnname)
		BEGIN
		SET @ls_sql = 'ALTER TABLE [dbo].[' + @ps_tablename + '] ADD '
		SET @ls_sql = @ls_sql + 'CONSTRAINT [' + @ls_default_constraint_name + '] DEFAULT ('
		SET @ls_sql = @ls_sql + @ls_default_constraint_text + ') FOR [' + @ls_columnname + ']'

		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR

		IF @ll_error <> 0
			RETURN -1
		END
	FETCH lc_columns INTO @ls_columnname, @ls_default_constraint_name, @ls_default_constraint_text
	END

CLOSE lc_columns
DEALLOCATE lc_columns

EXECUTE sp_rebuild_constraints @ps_tablename

GO
