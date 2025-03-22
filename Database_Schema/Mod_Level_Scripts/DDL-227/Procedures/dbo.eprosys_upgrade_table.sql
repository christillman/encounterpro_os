/*=============================================================
SCRIPT HEADER

VERSION:   201.00.0001
DATE:      04-06-2011 18:45:34
SERVER:    ict1

EncounterPRO Open Source Project

Copyright 2010-2011 The EncounterPRO Foundation, Inc.

This program is free software: you can redistribute it and/or modify it under the terms of 
the GNU Affero General Public License as published by the Free Software Foundation, either 
version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this 
program. If not, see http://www.gnu.org/licenses.

EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
General Public License version 3, or any later version. As such, linking the Project 
statically or dynamically with other components is making a combined work based on the 
Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
or any later version, cover the whole combination.

However, as an additional permission, the copyright holders of EncounterPRO Open Source 
Project give you permission to link the Project with independent components, regardless of 
the license terms of these independent components, provided that all of the following are true:

1. All access from the independent component to persisted data which resides
   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
   be made through a publically available database driver (e.g. ODBC, SQL 
   Native Client, etc) or through a service which itself is part of The Project.
2. The independent component does not create or rely on any code or data 
   structures within the EncounterPRO Open Source data store unless such 
   code or data structures, and all code and data structures referred to 
   by such code or data structures, are themselves part of The Project.
3. The independent component either a) runs locally on the user's computer,
   or b) is linked to at runtime by The Project’s Component Manager object 
   which in turn is called by code which itself is part of The Project.

An independent component is a component which is not derived from or based on the Project.
If you modify the Project, you may extend this additional permission to your version of 
the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
additional permission statement from your version.

DATABASE:	OS_Dev
  Procedure:  component_install_component


=============================================================*/
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[component_install_component]
Print 'Drop Procedure [dbo].[eprosys_upgrade_table]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[eprosys_upgrade_table]') AND [type]='P'))
DROP PROCEDURE [dbo].[eprosys_upgrade_table]
GO

-- Create Procedure [dbo].[component_install_component]
Print 'Create Procedure [dbo].[eprosys_upgrade_table]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[eprosys_upgrade_table] (
	@ps_tablename varchar(64),
	@pl_modification_level int )
AS

SET NOCOUNT ON

DECLARE @ls_columnname varchar (64) ,
	@li_column_identity smallint ,
	@li_column_nullable smallint ,
	@ls_column_definition varchar(64),
	@ls_sql nvarchar(max),
	@ll_error int,
	@ll_rowcount int,
	@ls_error varchar(255),
	@li_default_constraint smallint ,
	@ls_default_constraint_name varchar (64) ,
	@ls_default_constraint_text varchar (64) ,
	@ll_table_modification_level int,
	@ls_Existing_Constraint_Name varchar (64) ,
	@lb_default_constraint bit

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
IF (NOT EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[' + @ps_tablename + ']') AND [type]='U'))
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
		FROM sys.objects o
			INNER JOIN sys.columns c
			ON o.object_id = c.object_id
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
			default_constraint_text,
			default_constraint
	FROM @columns

OPEN lc_columns

FETCH lc_columns INTO @ls_columnname, @ls_default_constraint_name, @ls_default_constraint_text, @lb_default_constraint

WHILE @@FETCH_STATUS = 0
	BEGIN
	SELECT @ls_Existing_Constraint_Name = d.name
	FROM sys.default_constraints d
	INNER JOIN sys.objects o
	ON d.parent_object_id = o.object_id
	INNER JOIN sys.columns c
	ON o.object_id = c.object_id
	AND d.parent_column_id = c.column_id
	WHERE o.type = 'U'
	AND o.name = @ps_tablename
	AND c.name = @ls_columnname
	
	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT
	
	IF @ll_error <> 0
		RETURN -1

	IF @ll_rowcount = 1
		BEGIN
		SET @ls_sql = 'ALTER TABLE ' + @ps_tablename + ' DROP CONSTRAINT ' + @ls_Existing_Constraint_Name

		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR

		IF @ll_error <> 0
			RETURN -1
		END
	
	IF @lb_default_constraint = 1
		BEGIN
		SET @ls_sql = 'ALTER TABLE [dbo].[' + @ps_tablename + '] ADD '
		SET @ls_sql = @ls_sql + 'CONSTRAINT [' + @ls_default_constraint_name + '] DEFAULT ('
		SET @ls_sql = @ls_sql + @ls_default_constraint_text + ') FOR [' + @ls_columnname + ']'

		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR

		IF @ll_error <> 0
			RETURN -1
		END

	FETCH lc_columns INTO @ls_columnname, @ls_default_constraint_name, @ls_default_constraint_text, @lb_default_constraint
	END

CLOSE lc_columns
DEALLOCATE lc_columns

GO



