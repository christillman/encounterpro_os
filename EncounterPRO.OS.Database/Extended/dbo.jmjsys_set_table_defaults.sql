DROP PROCEDURE [jmjsys_set_table_defaults]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_set_table_defaults] (
	@ps_which_table [varchar] (64) )
AS

SET NOCOUNT ON

DECLARE @ls_columnname varchar (64) ,
	@ls_default_constraint_name varchar (64) ,
	@ls_default_constraint_text varchar (64) ,
	@ls_sql varchar(4000),
	@ll_error int,
	@ls_error varchar(255),
	@ls_tablename varchar(64)


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

	DECLARE lc_columns CURSOR LOCAL FAST_FORWARD FOR
		SELECT columnname,
				default_constraint_name,
				default_constraint_text
		FROM c_database_column
		WHERE tablename = @ls_tablename
		AND default_constraint = 1

	OPEN lc_columns

	FETCH lc_columns INTO @ls_columnname, @ls_default_constraint_name, @ls_default_constraint_text

	WHILE @@FETCH_STATUS = 0
		BEGIN
		IF EXISTS (
			SELECT 1
			FROM sysobjects o
				INNER JOIN syscolumns c
				ON o.id = c.id
			WHERE o.name = @ls_tablename
			AND c.name = @ls_columnname)
		AND NOT EXISTS (
			SELECT 1
			FROM sysobjects o
				INNER JOIN syscolumns c
				ON o.id = c.id
				INNER JOIN sysconstraints d
				ON o.id = d.id
				AND c.colid = d.colid
				AND c.cdefault = d.constid
			WHERE o.name = @ls_tablename
			AND c.name = @ls_columnname)
			BEGIN
			SET @ls_sql = 'ALTER TABLE [dbo].[' + @ls_tablename + '] ADD '
			SET @ls_sql = @ls_sql + 'CONSTRAINT [' + @ls_default_constraint_name + '] DEFAULT ('
			SET @ls_sql = @ls_sql + @ls_default_constraint_text + ') FOR [' + @ls_columnname + ']'

			EXECUTE (@ls_sql)
			SET @ll_error = @@ERROR

			IF @ll_error = 0
				BEGIN
				SET @ls_error = 'Successfully added default constraint for ' + @ls_tablename + '.' + @ls_columnname
				INSERT INTO o_log (severity, caller, [message])
				VALUES ('WARNING', 'Set Table Defaults', @ls_error)
				END
			ELSE
				BEGIN
				SET @ls_error = 'Error attempting to add default constraint for ' + @ls_tablename + '.' + @ls_columnname
				INSERT INTO o_log (severity, caller, [message])
				VALUES ('WARNING', 'Set Table Defaults', @ls_error)
				RETURN -1
				END
			END

		FETCH lc_columns INTO @ls_columnname, @ls_default_constraint_name, @ls_default_constraint_text
		END

	CLOSE lc_columns
	DEALLOCATE lc_columns

	FETCH lc_tables INTO @ls_tablename
	END

CLOSE lc_tables
DEALLOCATE lc_tables


GO
