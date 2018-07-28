CREATE PROCEDURE jmj_modify_references (
	@pl_reference_id int,
	@pl_new_reference_id int,
	@ps_object_key varchar(64))
AS

-- This stored procedure creates a local copy of the specified reference and returns the new reference_id
DECLARE @ls_tablename varchar(64),
		@ls_columnname varchar(64),
		@ll_count int,
		@ll_error int,
		@ls_sql varchar(4000),
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
	SELECT @ll_IsPrimaryKey = ObjectProperty(Object_id(si.name),  'IsPrimaryKey')
	FROM sysobjects o
		INNER JOIN syscolumns cl
		ON o.id = cl.id
		INNER JOIN sysindexes si
		ON o.id = si.id
		INNER JOIN sysindexkeys sk
		ON si.id = sk.id
		AND si.indid = sk.indid
		AND sk.colid = cl.colid
	WHERE o.name = @ls_tablename
	AND cl.name = @ls_columnname
	AND o.type = 'U'

	IF @@ROWCOUNT = 1 AND @ll_IsPrimaryKey = 0
		BEGIN
		SET @ls_sql = 'UPDATE ' + @ls_tablename 
		SET @ls_sql = @ls_sql + ' SET ' + @ls_columnname + ' = ' + CAST(@pl_new_reference_id AS varchar(12))
		SET @ls_sql = @ls_sql + ' WHERE ' + @ls_columnname + ' = ' + CAST(@pl_reference_id AS varchar(12))

		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1
		END

	FETCH lc_refs INTO @ls_tablename, @ls_columnname
	END

CLOSE lc_refs
DEALLOCATE lc_refs


COMMIT TRANSACTION

RETURN 1

