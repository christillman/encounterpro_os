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

-- Drop Procedure [dbo].[jmj_copy_config_object]
Print 'Drop Procedure [dbo].[jmj_copy_config_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_copy_config_object]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_copy_config_object]
GO

-- Create Procedure [dbo].[jmj_copy_config_object]
Print 'Create Procedure [dbo].[jmj_copy_config_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_copy_config_object (
	@ps_copy_from_config_object_id varchar(40) ,
	@ps_new_description varchar(80) ,
	@ps_created_by varchar(24) ,
	@ps_new_config_object_id varchar(40) OUTPUT )
AS

DECLARE @ll_return int ,
		@ll_error int ,
		@ll_rowcount int,
		@ls_config_object_type varchar(24),
		@lui_config_object_id uniqueidentifier,
		@ls_version_description varchar(255)


IF @ps_copy_from_config_object_id IS NULL
	BEGIN
	RAISERROR ('NULL config object id',16,-1)
	RETURN -1
	END

IF LEN(@ps_copy_from_config_object_id) < 30
	BEGIN
	RAISERROR ('Config object id is not a GUID',16,-1)
	RETURN -1
	END

SET @lui_config_object_id = CAST(@ps_copy_from_config_object_id AS uniqueidentifier)
IF @@ERROR <> 0
	RETURN -1

-- Validate config object
SELECT @ls_config_object_type = o.config_object_type,
	@ls_version_description = 'Copied from ' + o.[description]
FROM dbo.c_Config_Object o
WHERE o.config_object_id = @lui_config_object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount <> 1
	BEGIN
	RAISERROR ('Cannot find config object (%s)',16,-1, @ps_copy_from_config_object_id)
	RETURN -1
	END

IF @ls_config_object_type = 'Report'
	BEGIN
	EXECUTE @ll_return = jmj_copy_report_or_datafile
			@ps_copy_from_report_id = @ps_copy_from_config_object_id,
			@ps_new_description = @ps_new_description,
			@ps_created_by = @ps_created_by,
			@ps_report_id = @ps_new_config_object_id OUTPUT

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN -1

	IF @ll_return <= 0
		RETURN @ll_return
	END
ELSE IF @ls_config_object_type = 'Datafile'
	BEGIN
	EXECUTE @ll_return = jmj_copy_report_or_datafile
			@ps_copy_from_report_id = @ps_copy_from_config_object_id,
			@ps_new_description = @ps_new_description,
			@ps_created_by = @ps_created_by,
			@ps_report_id = @ps_new_config_object_id OUTPUT

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN -1

	IF @ll_return <= 0
		RETURN @ll_return
	END
ELSE
	BEGIN
	RAISERROR ('Copying %s objects is not yet supported',16,-1, @ps_copy_from_config_object_id)
	RETURN -1
	END



/*
****************************************************************************************
The report and datafile copy proc leaves the new config object in the checked out state
****************************************************************************************
-- If success then go ahead and checkout the copy
EXECUTE dbo.config_checkout 
	@pui_config_object_id = @lui_config_object_id,
	@ps_version_description = @ls_version_description,
	@ps_checked_out_by = @ps_created_by

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1
****************************************************************************************
*/

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_copy_config_object]
	TO [cprsystem]
GO

