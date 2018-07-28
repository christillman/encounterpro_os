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

-- Drop Procedure [dbo].[config_install_object]
Print 'Drop Procedure [dbo].[config_install_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_install_object]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_install_object]
GO

-- Create Procedure [dbo].[config_install_object]
Print 'Create Procedure [dbo].[config_install_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.config_install_object (
	@pui_config_object_id uniqueidentifier,
	@pl_version int
	)
AS
--
-- Returns:
-- -1 An error occured
--

DECLARE @ll_error int,
		@ll_rowcount int,
		@lx_xml xml,
		@ls_config_object_id varchar(40) ,
		@ls_config_object_type varchar(24) ,
		@ll_owner_id int ,
		@ll_doc int,
		@ls_status varchar(12),
		@ls_object_encoding_method varchar(12)


SET @ls_config_object_id = CAST(@pui_config_object_id AS varchar(40))

-- Make sure the config object exists
SELECT @ls_config_object_type = config_object_type,
		@ll_owner_id = owner_id
FROM c_Config_Object
WHERE config_object_id = @pui_config_object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount <> 1
	BEGIN
	RAISERROR ('The config object does not exist (%s)',16,-1, @ls_config_object_id)
	RETURN -1
	END
	

-- Make sure the config object exists
SELECT @ls_status = status,
		@ls_object_encoding_method = object_encoding_method,
		@lx_xml = CAST(CAST(objectdata AS varbinary(max)) AS xml)
FROM c_Config_Object_version
WHERE config_object_id = @pui_config_object_id
AND version = @pl_version

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount <> 1
	BEGIN
	RAISERROR ('The config object version does not exist (%s, %d)',16,-1, @ls_config_object_id, @pl_version)
	RETURN -1
	END

-- If this object was not encoded with SQL then it will be up to EncounterPRO to call the appropriate installer
IF @ls_object_encoding_method <> 'SQL'
	RETURN 0

-- Enumerate the supported SQL installers
IF @ls_config_object_type = 'Vaccine Schedule'
	BEGIN
	EXECUTE dbo.config_install_vaccine_schedule
		@pui_config_object_id = @pui_config_object_id,
		@pl_version = @pl_version
		
	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN -1

	RETURN 1
	END

RAISERROR ('The config object type does not have a supported SQL installer (%s)',16,-1, @ls_config_object_type)

RETURN 0

GO
GRANT EXECUTE
	ON [dbo].[config_install_object]
	TO [cprsystem]
GO

