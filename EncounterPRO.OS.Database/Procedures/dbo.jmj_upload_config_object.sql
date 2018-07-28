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

-- Drop Procedure [dbo].[jmj_upload_config_object]
Print 'Drop Procedure [dbo].[jmj_upload_config_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_upload_config_object]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_upload_config_object]
GO

-- Create Procedure [dbo].[jmj_upload_config_object]
Print 'Create Procedure [dbo].[jmj_upload_config_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[jmj_upload_config_object] (
	@pui_config_object_id varchar(40) ,
	@pl_version int ,
	@ps_user_id [varchar] (24) )
AS

--DECLARE @ll_count int,
--		@ll_error int,
--		@ls_status varchar(12),
--		@lui_config_object_id uniqueidentifier ,
--		@ls_release_status varchar(12),
--		@ll_customer_id int

--IF @pui_config_object_id IS NULL
--	BEGIN
--	RAISERROR ('Null config_object_id',16,-1)
--	RETURN -2
--	END

--IF @pl_version IS NULL
--	BEGIN
--	RAISERROR ('Null version number',16,-1)
--	RETURN -2
--	END

--SET @lui_config_object_id = CAST(@pui_config_object_id AS uniqueidentifier)

--SELECT @ls_status = status
--FROM c_Config_Object_Version
--WHERE config_object_id = @lui_config_object_id
--AND version = @pl_version

--SELECT @ll_count = @@ROWCOUNT,
--		@ll_error = @@ERROR

--IF @ll_error <> 0
--	RETURN -2

--IF @ll_count = 0
--	BEGIN
--	RAISERROR ('The specified config object does not exist (%s, %d)',16,-1, @pui_config_object_id, @pl_version)
--	RETURN -2
--	END

--IF @ls_status <> 'CheckedIn'
--	BEGIN
--	RAISERROR ('The config object must be checked in before it can be uploaded (%s, %d)',16,-1, @pui_config_object_id, @pl_version)
--	RETURN -2
--	END


--SELECT @ll_customer_id = customer_id
--FROM c_Database_Status

--SET @ls_release_status = CASE WHEN @ll_customer_id < 1000 THEN 'Testing' ELSE 'Shareware' END

---- See if we need to create the parent object record
--SELECT @ll_count = count(*)
--FROM jmjtech.eproupdates.dbo.c_Config_Object
--WHERE config_object_id = @lui_config_object_id

--SELECT @ll_error = @@ERROR

--IF @ll_error <> 0
--	RETURN -2

--IF @ll_count = 0
--	INSERT INTO jmjtech.eproupdates.dbo.c_Config_Object (
--		config_object_id ,
--		config_object_type ,
--		context_object ,
--		description ,
--		long_description ,
--		config_object_category ,
--		owner_id ,
--		owner_description ,
--		created ,
--		created_by ,
--		status ,
--		copyright_status ,
--		copyable ,
--		license_data ,
--		license_status ,
--		license_expiration_date )
--	SELECT config_object_id ,
--		config_object_type ,
--		context_object ,
--		description ,
--		long_description ,
--		config_object_category ,
--		owner_id ,
--		owner_description ,
--		created ,
--		created_by ,
--		status ,
--		copyright_status ,
--		copyable ,
--		license_data ,
--		license_status ,
--		license_expiration_date
--	FROM c_Config_Object
--	WHERE config_object_id = @lui_config_object_id


--INSERT INTO jmjtech.eproupdates.dbo.c_Config_Object_Version (
--	config_object_id ,
--	version ,
--	description ,
--	version_description ,
--	config_object_type ,
--	owner_id ,
--	created ,
--	created_by ,
--	created_from_version ,
--	status ,
--	status_date_time ,
--	release_status ,
--	release_status_date_time ,
--	objectdata ,
--	uploaded_by )
--SELECT config_object_id ,
--	version ,
--	description ,
--	version_description ,
--	config_object_type ,
--	owner_id ,
--	created ,
--	created_by ,
--	created_from_version ,
--	'OK' ,
--	status_date_time ,
--	@ls_release_status ,
--	getdate() ,
--	objectdata ,
--	@ps_user_id
--FROM c_Config_Object_Version
--WHERE config_object_id = @lui_config_object_id
--AND version = @pl_version

--SELECT @ll_count = @@ROWCOUNT,
--		@ll_error = @@ERROR

--IF @ll_error <> 0
--	RETURN -2

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_upload_config_object]
	TO [public]
GO

