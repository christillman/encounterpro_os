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

-- Drop Procedure [dbo].[jmj_upload_module]
Print 'Drop Procedure [dbo].[jmj_upload_module]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_upload_module]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_upload_module]
GO

-- Create Procedure [dbo].[jmj_upload_module]
Print 'Create Procedure [dbo].[jmj_upload_module]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[jmj_upload_module] (
	@ps_module_type [varchar] (24) ,
	@ps_context_object [varchar] (24) ,
	@ps_object_id [varchar] (36) ,
	@ps_module_data [nvarchar](max) ,
	@ps_user_id [varchar] (24) )
AS

--DECLARE @lui_module_id uniqueidentifier ,
--		@ls_module_name [varchar] (80) ,
--		@ll_module_owner_id [int] ,
--		@ls_module_category [varchar] (24) ,
--		@ll_version [int] ,
--		@ll_min_build [int] ,
--		@ll_last_version [int] ,
--		@ll_current_owner_id [int] ,
--		@ll_last_owner_id [int] ,
--		@ls_long_description [varchar] (8000)

--SELECT @ll_module_owner_id = customer_id
--FROM c_Database_Status


--IF @ps_module_type = 'Report'
--	BEGIN
--	SET @lui_module_id = CAST(@ps_object_id AS uniqueidentifier)
	
--	SELECT @ls_module_name = CAST(description AS varchar(80)),
--			@ls_module_category = report_category,
--			@ll_version = version ,
--			@ll_current_owner_id = owner_id ,
--			@ls_long_description = CAST(long_description AS varchar(8000))
--	FROM c_Report_Definition
--	WHERE report_id = @ps_object_id
	
--	SET @ll_min_build = 40000
--	END

--IF @ll_module_owner_id <> @ll_current_owner_id
--	BEGIN
--	RAISERROR ('Cannot export module that is not locally owned.  Make a copy of the module and export the copy.',16,-1)
--	RETURN
--	END


--SELECT @ll_last_version = MAX(version),
--		@ll_last_owner_id = MAX(module_owner_id)
--FROM jmjtech.eproupdates.dbo.m_Module_Library
--WHERE module_id = @lui_module_id

--IF @ll_module_owner_id <> @ll_last_owner_id
--	BEGIN
--	RAISERROR ('A version of this module has already been uploaded by another owner.  Make a copy of the module and export the copy.',16,-1)
--	RETURN
--	END


--IF @ll_version IS NULL
--	BEGIN
--	IF @ll_last_version IS NULL
--		SET @ll_version = 1
--	ELSE
--		SET @ll_version = @ll_last_version + 1
--	END

--UPDATE jmjtech.eproupdates.dbo.m_Module_Library
--SET status = 'NA'
--WHERE module_id = @lui_module_id
--AND version = @ll_version

--INSERT INTO jmjtech.eproupdates.dbo.m_Module_Library (
--	[module_id] ,
--	[module_type] ,
--	[context_object] ,
--	[module_name] ,
--	[module_owner_id] ,
--	[version] ,
--	[min_build] ,
--	[module_data] ,
--	[module_category] ,
--	[created_by],
--	[long_description])
--VALUES (
--	@lui_module_id ,
--	@ps_module_type ,
--	@ps_context_object ,
--	@ls_module_name ,
--	@ll_module_owner_id ,
--	@ll_version ,
--	@ll_min_build ,
--	@ps_module_data ,
--	@ls_module_category ,
--	CAST(@ll_module_owner_id AS varchar(12)) + '/' + @ps_user_id,
--	@ls_long_description	)




GO
GRANT EXECUTE
	ON [dbo].[jmj_upload_module]
	TO [public]
GO

