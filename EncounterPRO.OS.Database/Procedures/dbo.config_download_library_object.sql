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

-- Drop Procedure [dbo].[config_download_library_object]
Print 'Drop Procedure [dbo].[config_download_library_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_download_library_object]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_download_library_object]
GO

-- Create Procedure [dbo].[config_download_library_object]
Print 'Create Procedure [dbo].[config_download_library_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[config_download_library_object] (
	@pui_config_object_id varchar(40) ,
	@pl_version int,
	@ps_created_by varchar(24) )
AS

--DECLARE @ll_count int,
--		@ll_error int,
--		@ls_config_object_id varchar(38),
--		@ls_config_object_type varchar(24),
--		@ls_context_object varchar(24),
--		@ll_owner_id int,
--		@ls_description varchar(80),
--		@ls_config_object_category varchar(80),
--		@lui_config_object_id uniqueidentifier ,
--		@ls_copyright_status varchar(24) ,
--		@lb_copyable bit ,
--		@ls_copyable char(1) ,
--		@ls_license_data varchar(2000) ,
--		@ls_license_status varchar(24) 

--SET @lui_config_object_id = CAST(@pui_config_object_id AS uniqueidentifier)


--DECLARE @object TABLE (
--	config_object_id uniqueidentifier NOT NULL,
--	config_object_type varchar(24) NOT NULL,
--	context_object varchar(24) NOT NULL,
--	description varchar(80) NOT NULL,
--	long_description varchar(max) NULL,
--	config_object_category varchar(80) NULL,
--	owner_id int NOT NULL,
--	status varchar(12) NOT NULL,
--	copyright_status varchar(24) NOT NULL ,
--	copyable bit NOT NULL ,
--	license_data varchar(2000) NULL,
--	license_status varchar(24) NULL
--	)

--DECLARE @object_version TABLE (
--		config_object_id uniqueidentifier NOT NULL,
--		version int NOT NULL,
--		description varchar(80) NOT NULL,
--		version_description varchar(max) NULL,
--		config_object_type varchar(24) NOT NULL,
--		owner_id int NOT NULL,
--		objectdata image NULL,
--		release_status varchar(12) NULL,
--		release_status_date_time datetime NULL
--	)

--IF @lui_config_object_id IS NULL
--	BEGIN
--	RAISERROR ('Null config_object_id',16,-1)
--	RETURN -2
--	END

--IF @pl_version IS NULL
--	BEGIN
--	RAISERROR ('Null version number',16,-1)
--	RETURN -2
--	END

--SET @ls_config_object_id = CAST(@lui_config_object_id AS varchar(38))

---- Populate the temp tables
--INSERT INTO @object (
--	config_object_id ,
--	config_object_type ,
--	context_object ,
--	description ,
--	long_description ,
--	config_object_category ,
--	owner_id ,
--	status ,
--	copyright_status ,
--	copyable ,
--	license_data ,
--	license_status )
--SELECT config_object_id ,
--	config_object_type ,
--	context_object ,
--	description ,
--	long_description ,
--	config_object_category ,
--	owner_id ,
--	status ,
--	copyright_status ,
--	copyable ,
--	license_data ,
--	license_status 
--FROM jmjtech.eproupdates.dbo.c_Config_Object
--WHERE config_object_id = @lui_config_object_id

--SELECT @ll_count = @@ROWCOUNT,
--		@ll_error = @@ERROR

--IF @ll_error <> 0
--	RETURN -1

--IF @ll_count = 0
--	BEGIN
--	RAISERROR ('The specified config object was not found in the library (%s)',16,-1, @ls_config_object_id)
--	RETURN -1
--	END

--INSERT INTO @object_version (
--	config_object_id ,
--	version ,
--	description ,
--	version_description ,
--	config_object_type ,
--	owner_id ,
--	objectdata ,
--	release_status ,
--	release_status_date_time )
--SELECT config_object_id ,
--	version ,
--	description ,
--	version_description ,
--	config_object_type ,
--	owner_id ,
--	objectdata ,
--	release_status ,
--	release_status_date_time 
--FROM jmjtech.eproupdates.dbo.c_Config_Object_Version
--WHERE config_object_id = @lui_config_object_id
--AND version = @pl_version
--AND status = 'OK'

--SELECT @ll_count = @@ROWCOUNT,
--		@ll_error = @@ERROR

--IF @ll_error <> 0
--	RETURN -1

--IF @ll_count = 0
--	BEGIN
--	RAISERROR ('The specified config object version was not found in the library (%s, %d)',16,-1, @ls_config_object_id, @pl_version)
--	RETURN -1
--	END

---- Get object data into local variables
--SELECT 	@ls_config_object_type = config_object_type,
--		@ls_context_object = context_object,
--		@ll_owner_id = owner_id,
--		@ls_description = description,
--		@ls_config_object_category = config_object_category,
--		@ls_copyright_status = copyright_status,
--		@lb_copyable = copyable,
--		@ls_license_data = license_data,
--		@ls_license_status = license_status
--FROM @object

--SELECT @ll_count = @@ROWCOUNT,
--		@ll_error = @@ERROR

--IF @ll_error <> 0
--	RETURN -1

--IF @lb_copyable = 0
--	SET @ls_copyable = 'N'
--ELSE
--	SET @ls_copyable = 'Y'

---- Create the object/version records if they don't already exist
--EXECUTE config_create_object_version
--	@pui_config_object_id = @lui_config_object_id ,
--	@ps_config_object_type = @ls_config_object_type ,
--	@ps_context_object = @ls_context_object ,
--	@pl_owner_id = @ll_owner_id ,
--	@ps_description = @ls_description ,
--	@ps_config_object_category = @ls_config_object_category ,
--	@pl_version = @pl_version ,
--	@ps_created_by = @ps_created_by ,
--	@ps_status = 'CheckedIn',
--	@ps_copyright_status = @ls_copyright_status,
--	@ps_copyable = @ls_copyable,
--	@ps_license_data = @ls_license_data,
--	@ps_license_status = @ls_license_status

--SELECT @ll_error = @@ERROR

--IF @ll_error <> 0
--	RETURN -1


---- Update the varchar(max) and image columns
--UPDATE o
--SET long_description = x.long_description
--FROM c_Config_Object o
--	INNER JOIN @object x
--	ON o.config_object_id = x.config_object_id

--SELECT @ll_error = @@ERROR

--IF @ll_error <> 0
--	RETURN -1

--UPDATE v
--SET version_description = x.version_description,
--	objectdata = x.objectdata,
--	release_status = x.release_status,
--	release_status_date_time = x.release_status_date_time
--FROM c_Config_Object_Version v
--	INNER JOIN @object_version x
--	ON v.config_object_id = x.config_object_id
--	AND v.version = x.version

--SELECT @ll_error = @@ERROR

--IF @ll_error <> 0
--	RETURN -1

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[config_download_library_object]
	TO [public]
GO

