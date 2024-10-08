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
  Procedure:  eprosys_execute_script


=============================================================*/
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[component_install_component]
Print 'Drop Procedure [dbo].[eprosys_execute_script]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[eprosys_execute_script]') AND [type]='P'))
DROP PROCEDURE [dbo].[eprosys_execute_script]
GO

-- Create Procedure [dbo].[component_install_component]
Print 'Create Procedure [dbo].[eprosys_execute_script]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[eprosys_execute_script]
	@ps_script varchar(max),
	@pl_script_log_id int OUTPUT
AS


DECLARE @scriptLen INT
DECLARE @currentPos INT
DECLARE @nextTmpScriptLen INT
DECLARE @tmpScript VARCHAR(max)
DECLARE @ls_error NVARCHAR(255)
DECLARE @ld_start_time DATETIME
DECLARE @ll_running_duration INT
DECLARE @ll_duration INT,
		@ll_error int,
		@ll_ErrorNumber int,
		@ls_ErrorMessage nvarchar(2048),
		@ll_ErrorSeverity int,
		@ls_ErrorProcedure nvarchar(126),
		@ll_ErrorLine int

SELECT @ld_start_time = dbo.get_client_datetime()

INSERT INTO dbo.c_Database_Script_Log (
	script_id,
	executed_date_time,
	db_script,
	completion_status,
	error_index ,
	error_message ,
	end_date
	)
VALUES (
	0,
	@ld_start_time,
	@ps_script,
	'Running',
	0 ,
	NULL ,
	NULL
	)


SELECT @pl_script_log_id = SCOPE_IDENTITY()

-- Take an exclusive table lock on this table
BEGIN TRANSACTION
--	EXEC('DECLARE @tmplock INT SELECT @tmplock = 1 FROM ' + @TableName + ' WITH (TABLOCKX) WHERE 1 = 2')

-- Massage the script to get it ready to parse the GO blocks
SET @ps_script = REPLACE(@ps_script, '
', ' ')
SET @ps_script = LTRIM(@ps_script)
SET @ps_script = RTRIM(@ps_script)
SET @scriptLen = LEN(@ps_script)

-- Parse the GO blocks and run each one separately
SET @currentPos = 1
SET @nextTmpScriptLen = PATINDEX('%' + CHAR(10) + 'GO%', SUBSTRING(@ps_script, @currentPos, @scriptLen-@currentPos))
WHILE @currentPos < @scriptLen+1
BEGIN
	IF @nextTmpScriptLen = 0
	BEGIN
		SET @nextTmpScriptLen = PATINDEX('%' + CHAR(10) + 'GO%', SUBSTRING(@ps_script, @currentPos, @scriptLen-@currentPos))
	END
	IF @nextTmpScriptLen = 0
	BEGIN
		SET @nextTmpScriptLen = (@scriptLen - @currentPos)
	END
	IF @nextTmpScriptLen > 0
	BEGIN
--			PRINT '   ' + CONVERT(VARCHAR(5), @currentPos) + '-' + CONVERT(VARCHAR(5), @currentPos+@nextTmpScriptLen) + ' of ' + CONVERT(VARCHAR(5), @scriptLen)
		SET @tmpScript = SUBSTRING(@ps_script, @currentPos, @nextTmpScriptLen-1)
		BEGIN TRY
			EXEC(@tmpScript)
		END TRY
		BEGIN CATCH
			SELECT @ll_ErrorNumber = ERROR_NUMBER(),
					@ls_ErrorMessage = ERROR_MESSAGE(),
					@ll_ErrorSeverity = ERROR_SEVERITY(),
					@ls_ErrorProcedure = ERROR_PROCEDURE(),
					@ll_ErrorLine = ERROR_LINE()
			PRINT @tmpScript
			ROLLBACK TRANSACTION
			UPDATE dbo.c_Database_Script_Log
			SET completion_status = 'ERROR',
				error_index = @ll_ErrorNumber,
				error_message = @ls_ErrorMessage,
				end_date = dbo.get_client_datetime()
			WHERE script_log_id = @pl_script_log_id
			RETURN -1
		END CATCH
	END
	SET @currentPos = (@currentPos + @nextTmpScriptLen+4)
	IF(@currentPos<@scriptLen+1)
	BEGIN
		SET @nextTmpScriptLen = PATINDEX('%' + CHAR(10) + 'GO%', SUBSTRING(@ps_script, @currentPos, @scriptLen-@currentPos))
	END
END

-- Release table lock
COMMIT TRANSACTION

SELECT @ll_running_duration = DATEDIFF(second, @ld_start_time, dbo.get_client_datetime())
SELECT @ls_error = 'Successfully Executed Script'
UPDATE dbo.c_Database_Script_Log
SET completion_status = 'OK',
	error_index = 0,
	error_message = @ls_error,
	end_date = dbo.get_client_datetime()
WHERE script_log_id = @pl_script_log_id

RETURN 1