
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_modify_references]
Print 'Drop Procedure [dbo].[jmj_modify_references]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_modify_references]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_modify_references]
GO

-- Create Procedure [dbo].[jmj_modify_references]
Print 'Create Procedure [dbo].[jmj_modify_references]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_modify_references (
	@pl_reference_id int,
	@pl_new_reference_id int,
	@ps_object_key varchar(64))
AS

-- This stored procedure creates a local copy of the specified reference and returns the new reference_id
DECLARE @ls_tablename varchar(64),
		@ls_columnname varchar(64),
		@ls_sql nvarchar(max),
		@ll_IsPrimaryKey int

DECLARE lc_refs CURSOR LOCAL FAST_FORWARD FOR
	SELECT tablename, columnname
	FROM c_Database_Column WITH (NOLOCK)
	WHERE columnname LIKE '%' + @ps_object_key

BEGIN TRANSACTION

OPEN lc_refs

FETCH lc_refs INTO @ls_tablename, @ls_columnname

WHILE @@FETCH_STATUS = 0
	BEGIN
	SELECT @ll_IsPrimaryKey = i.is_primary_key
	FROM sys.objects o
	INNER JOIN sys.indexes i ON i.object_id = o.object_id
	INNER JOIN sys.index_columns ic ON ic.object_id=i.object_id AND ic.index_id = i.index_id
	INNER JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id = ic.column_id
	WHERE o.name COLLATE DATABASE_DEFAULT = @ls_tablename
		AND c.name COLLATE DATABASE_DEFAULT = @ls_columnname
		AND o.type = 'U'

	IF @ll_IsPrimaryKey = 0
		BEGIN
		SET @ls_sql = 'UPDATE ' + @ls_tablename 
		SET @ls_sql = @ls_sql + ' SET ' + @ls_columnname + ' = ' + CAST(@pl_new_reference_id AS varchar(12))
		SET @ls_sql = @ls_sql + ' WHERE ' + @ls_columnname + ' = ' + CAST(@pl_reference_id AS varchar(12))

		EXECUTE (@ls_sql)
		
		IF @@ERROR <> 0
			RETURN -1
		END

	FETCH lc_refs INTO @ls_tablename, @ls_columnname
	END

CLOSE lc_refs
DEALLOCATE lc_refs


COMMIT TRANSACTION

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_modify_references]
	TO [cprsystem]
GO

