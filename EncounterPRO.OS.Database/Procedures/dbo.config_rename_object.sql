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

-- Drop Procedure [dbo].[config_rename_object]
Print 'Drop Procedure [dbo].[config_rename_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_rename_object]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_rename_object]
GO

-- Create Procedure [dbo].[config_rename_object]
Print 'Create Procedure [dbo].[config_rename_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE config_rename_object (
	@pui_config_object_id uniqueidentifier ,
	@ps_new_description varchar(80))
AS

DECLARE @ll_return int ,
		@ll_error int ,
		@ll_rowcount int,
		@ls_config_object_type varchar(24),
		@ls_config_object_id varchar(40)


IF @pui_config_object_id IS NULL
	BEGIN
	RAISERROR ('NULL config object id',16,-1)
	RETURN -1
	END

SET @ls_config_object_type = CAST(@pui_config_object_id AS varchar(40))


-- Validate config object
SELECT @ls_config_object_type = o.config_object_type
FROM dbo.c_Config_Object o
WHERE o.config_object_id = @pui_config_object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount <> 1
	BEGIN
	RAISERROR ('Cannot find config object (%s)',16,-1, @ls_config_object_type)
	RETURN -1
	END

BEGIN TRANSACTION

UPDATE o
SET description = @ps_new_description
FROM dbo.c_Config_Object o
WHERE o.config_object_id = @pui_config_object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE v
SET description = @ps_new_description
FROM dbo.c_Config_Object_Version v
WHERE v.config_object_id = @pui_config_object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ls_config_object_type = 'Report'
	BEGIN
	UPDATE r
	SET description = @ps_new_description
	FROM dbo.c_Report_Definition r
	WHERE r.report_id = @pui_config_object_id

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END

	-- If we're attaching an rtf script that was only just now created then assume that we're
	-- copying/creating an RTF report and rename the RTF script to match the report name
	UPDATE d
	SET description = r.description,
		display_script = CAST(r.description AS varchar(40))
	FROM c_Display_Script d
		INNER JOIN (SELECT report_id, display_script_id = CAST(value AS int)
					FROM dbo.c_Report_Attribute
					WHERE report_id = @pui_config_object_id
					AND attribute IN ('display_script_id', 'xml_script_id')
					AND ISNUMERIC(value) = 1
					) x
		ON d.display_script_id = x.display_script_id
		INNER JOIN c_Report_Definition r
		ON r.report_id = x.report_id
		CROSS JOIN c_Database_Status s
	WHERE s.customer_id = r.owner_id



	END

COMMIT TRANSACTION

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[config_rename_object]
	TO [cprsystem]
GO

