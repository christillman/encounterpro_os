/****** Object:  Stored Procedure dbo.sp_rebuild_constraints    Script Date: 4/25/2003 10:08:56 AM ******/
CREATE    PROCEDURE sp_rebuild_constraints
	 @ps_TableName SYSNAME		
AS

IF @ps_TableName IS NULL or @ps_TableName = ''
	SET @ps_TableName = '%'

EXECUTE jmj_set_constraints

DECLARE @scriptLen INT
DECLARE @currentPos INT
DECLARE @nextTmpScriptLen INT
DECLARE @tmpScript VARCHAR(8000)
DECLARE @ls_error NVARCHAR(255)
DECLARE @ld_start_time DATETIME
DECLARE @ld_running_time DATETIME
DECLARE @ll_running_duration INT
DECLARE @ll_duration INT
DECLARE @ls_dump_log_sql varchar(1000)

SET @ls_dump_log_sql = 'BACKUP LOG ' + db_name(db_id()) + ' WITH NO_LOG'

SELECT @ld_start_time = getdate()
SELECT @ll_running_duration = DATEDIFF(minute, @ld_start_time, getdate())

SELECT @ls_error = 'Beginning Rebuild_Constraints job with Parameter: ' + @ps_TableName
SET @ls_error = REPLACE(@ls_Error, '%', '%%')
INSERT INTO o_log (
	severity ,
	caller ,
	message ,
	id
	)
	VALUES ('INFORMATION', 'Rebuild_Constraints', @ls_error, newid())

DECLARE TableCursor CURSOR LOCAL FAST_FORWARD FOR
	SELECT t.tablename,
			t.index_script
	FROM c_Database_Table t WITH (NOLOCK)
		INNER JOIN sysobjects o WITH (NOLOCK)
		ON t.tablename = o.name
	WHERE o.type = 'U'
	AND t.tablename LIKE @ps_TableName
	AND	t.tablename <> 'c_database_table'
	ORDER BY t.tablename


DECLARE
	 @TableName SYSNAME
	,@IndexScript VARCHAR (8000)
	,@ll_error int


OPEN TableCursor

FETCH NEXT FROM TableCursor
INTO
	 @TableName
	,@IndexScript

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @ld_running_time = getdate()
	PRINT 'Rebuilding constraints for ' + @TableName
	SELECT @ls_error = 'Start rebuilding constraints for ' + @TableName
	PRINT @ls_error
	INSERT INTO o_log (
		severity ,
		caller ,
		message ,
		id
		)
		VALUES ('INFORMATION', 'Rebuild_Constraints', @ls_error, newid())
	
	
	
	
	-- Take an exclusive table lock on this table
	BEGIN TRANSACTION
--	EXEC('DECLARE @tmplock INT SELECT @tmplock = 1 FROM ' + @TableName + ' WITH (TABLOCKX) WHERE 1 = 2')

	-- Drop the constraints but keep the triggers
	EXEC sp_drop_constraints @TableName, 1
	SET @IndexScript = REPLACE(@IndexScript, '
', ' ')
	SET @IndexScript = LTRIM(@IndexScript)
	SET @IndexScript = RTRIM(@IndexScript)
	SET @scriptLen = LEN(@IndexScript)
--	PRINT '   scriptLen = ' + CONVERT(VARCHAR(5), @scriptLen)
	SET @currentPos = 1
	SET @nextTmpScriptLen = PATINDEX('%[ 
]GO[ 
]%', SUBSTRING(@IndexScript, @currentPos, @scriptLen-@currentPos))
	WHILE @currentPos < @scriptLen+1
	BEGIN
		IF @nextTmpScriptLen = 0
		BEGIN
			SET @nextTmpScriptLen = PATINDEX('%[ 
]GO', SUBSTRING(@IndexScript, @currentPos, @scriptLen-@currentPos))
		END
		IF @nextTmpScriptLen = 0
		BEGIN
			SET @nextTmpScriptLen = (@scriptLen - @currentPos)
		END
		IF @nextTmpScriptLen > 0
		BEGIN
--			PRINT '   ' + CONVERT(VARCHAR(5), @currentPos) + '-' + CONVERT(VARCHAR(5), @currentPos+@nextTmpScriptLen) + ' of ' + CONVERT(VARCHAR(5), @scriptLen)
			SET @tmpScript = SUBSTRING(@IndexScript, @currentPos, @nextTmpScriptLen-1)
			EXEC(@tmpScript)
			SET @ll_error = @@ERROR
			IF @ll_error <> 0
				BEGIN
					SELECT @ls_error = 'Error # ' + CAST(@ll_error AS varchar(16)) + ' occured while processing table ' + @TableName
					PRINT @ls_error
					RAISERROR (@ls_error, 19, 1)
					ROLLBACK TRANSACTION
					PRINT @ls_error
					INSERT INTO o_log (
						severity ,
						caller ,
						message ,
						id
						)
						VALUES ('ERROR', 'Rebuild_Constraints', @ls_error, newid())
					RETURN
				END
		END
		SET @currentPos = (@currentPos + @nextTmpScriptLen+4)
		IF(@currentPos<@scriptLen+1)
		BEGIN
			SET @nextTmpScriptLen = PATINDEX('%[ 
]GO[ 
]%', SUBSTRING(@IndexScript, @currentPos, @scriptLen-@currentPos))
		END
	END
	
	-- Release table lock
	COMMIT TRANSACTION
	SELECT @ll_running_duration = DATEDIFF(minute, @ld_running_time, getdate())
	SELECT @ls_error = 'Finished rebuilding constraints for ' + @TableName + '.  Duration: ' + CAST(@ll_running_duration AS VARCHAR) + ' minute(s).' 
	PRINT @ls_error
	INSERT INTO o_log (
		severity ,
		caller ,
		message ,
		id
		)
		VALUES ('INFORMATION', 'Rebuild_Constraints', @ls_error, newid())

	FETCH NEXT FROM TableCursor
	INTO
		 @TableName
		,@IndexScript
END

CLOSE TableCursor

DEALLOCATE TableCursor
SELECT @ll_running_duration = DATEDIFF(minute, @ld_start_time, getdate())
SELECT @ls_error = 'Finished Rebuild_Constraints job with Parameter: ' + @ps_TableName + '.  Total Estimated Duration: ' + CAST(@ll_running_duration AS VARCHAR) + ' minutes.'
SET @ls_error = REPLACE(@ls_Error, '%', '%%')
INSERT INTO o_log (
	severity ,
	caller ,
	message ,
	id
	)
	VALUES ('INFORMATION', 'Rebuild_Constraints', @ls_error, newid())


