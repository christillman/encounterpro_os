--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_rebuild_constraints]
Print 'Drop Procedure [dbo].[sp_rebuild_constraints]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_rebuild_constraints]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_rebuild_constraints]
GO

-- Create Procedure [dbo].[sp_rebuild_constraints]
Print 'Create Procedure [dbo].[sp_rebuild_constraints]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
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

SELECT @ld_start_time = dbo.get_client_datetime()
SELECT @ll_running_duration = DATEDIFF(minute, @ld_start_time, dbo.get_client_datetime())

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
	SELECT @ld_running_time = dbo.get_client_datetime()
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
	SELECT @ll_running_duration = DATEDIFF(minute, @ld_running_time, dbo.get_client_datetime())
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
SELECT @ll_running_duration = DATEDIFF(minute, @ld_start_time, dbo.get_client_datetime())
SELECT @ls_error = 'Finished Rebuild_Constraints job with Parameter: ' + @ps_TableName + '.  Total Estimated Duration: ' + CAST(@ll_running_duration AS VARCHAR) + ' minutes.'
SET @ls_error = REPLACE(@ls_Error, '%', '%%')
INSERT INTO o_log (
	severity ,
	caller ,
	message ,
	id
	)
	VALUES ('INFORMATION', 'Rebuild_Constraints', @ls_error, newid())


GO
GRANT EXECUTE
	ON [dbo].[sp_rebuild_constraints]
	TO [cprsystem]
GO

