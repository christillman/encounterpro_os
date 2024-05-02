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

-- Drop Procedure [dbo].[config_object_versions]
Print 'Drop Procedure [dbo].[config_object_versions]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_object_versions]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_object_versions]
GO

-- Create Procedure [dbo].[config_object_versions]
Print 'Create Procedure [dbo].[config_object_versions]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE config_object_versions (
	@ps_config_object_id varchar(40) ,
	@ps_min_release_status varchar(12) = 'Production',
	@ps_list_type varchar(12) = 'All')
AS
-- ps_list_type =	"Upgrade" - show only versions greater than the installed version
--						"Revert" - show only versions less than the installed version
--						"All" - show all versions



--DECLARE @lui_config_object_id uniqueidentifier,
--		@ll_max_release_status_number int,
--		@ll_installed_version int,
--		@ll_min_version int,
--		@ll_max_version int,
--		@ll_owner_id int,
--		@ll_customer_id int

--DECLARE @object TABLE (
--	[version] [int] NOT NULL ,
--	[version_description] [text] NULL ,
--	[release_status] [varchar] (24) NOT NULL ,
--	[release_status_date_time] [datetime] NULL ,
--	[downloaded] [int] NOT NULL DEFAULT (0) )

--DECLARE @release_status TABLE (
--	[release_status] [varchar] (12) NOT NULL )

--IF @ps_config_object_id IS NULL OR @ps_config_object_id = ''
--	RETURN 0

--SET @lui_config_object_id = CAST(@ps_config_object_id AS uniqueidentifier)

--SELECT @ll_customer_id = customer_id
--FROM c_Database_Status

--SELECT @ll_installed_version = installed_version,
--		@ll_owner_id = owner_id
--FROM c_Config_Object
--WHERE config_object_id = @lui_config_object_id

--IF @ll_installed_version IS NULL AND @ps_list_type IN ('Upgrade', 'Revert')
--	BEGIN
--	SET @ll_min_version = NULL
--	SET @ll_max_version = NULL
--	END
--ELSE IF @ps_list_type = 'Upgrade'
--	BEGIN
--	SET @ll_min_version = @ll_installed_version + 1
--	SET @ll_max_version = 999999
--	END
--ELSE IF @ps_list_type = 'Revert'
--	BEGIN
--	SET @ll_min_version = 0
--	SET @ll_max_version = @ll_installed_version - 1
--	END
--ELSE
--	BEGIN
--	SET @ll_min_version = 0
--	SET @ll_max_version = 999999
--	END


---- Set up the list of release status' that we want
--SET @ll_max_release_status_number = 1

--INSERT INTO @release_status (release_status)
--VALUES ('Production')

--INSERT INTO @release_status (release_status)
--VALUES ('Shareware')

--IF @ps_min_release_status IN ('Beta', 'Testing')
--	BEGIN
--	SET @ll_max_release_status_number = 2
	
--	INSERT INTO @release_status (release_status)
--	VALUES ('Beta')
--	END

--IF @ps_min_release_status = 'Testing'
--	BEGIN
--	SET @ll_max_release_status_number = 3
	
--	INSERT INTO @release_status (release_status)
--	VALUES ('Testing')
--	END


--INSERT INTO @object (
--	version ,
--	version_description ,
--	release_status ,
--	release_status_date_time ,
--	downloaded )
--SELECT version ,
--	version_description ,
--	release_status ,
--	release_status_date_time ,
--	1
--FROM c_Config_Object_Version
--WHERE config_object_id = @lui_config_object_id
--AND release_status IN (SELECT release_status FROM @release_status)
--AND version >= @ll_min_version
--AND version <= @ll_max_version


--INSERT INTO @object (
--	version ,
--	version_description ,
--	release_status ,
--	release_status_date_time )
--SELECT version ,
--	version_description ,
--	release_status ,
--	release_status_date_time 
--FROM jmjtech.EproUpdates.dbo.c_Config_Object_Version lv
--WHERE config_object_id = @lui_config_object_id
--AND release_status_number <= @ll_max_release_status_number
--AND status = 'OK'
--AND version >= @ll_min_version
--AND version <= @ll_max_version
--AND NOT EXISTS (
--	SELECT 1
--	FROM @object o
--	WHERE o.version = lv.version )

--SELECT version ,
--	version_description ,
--	release_status ,
--	release_status_date_time ,
--	downloaded ,
--	selected_flag=0 ,
--	local_owner_flag = CASE WHEN @ll_customer_id = @ll_owner_id THEN 1 ELSE 0 END
--FROM @object

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[config_object_versions]
	TO [cprsystem]
GO

