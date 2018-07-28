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

-- Drop Procedure [dbo].[config_new_config_object]
Print 'Drop Procedure [dbo].[config_new_config_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_new_config_object]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_new_config_object]
GO

-- Create Procedure [dbo].[config_new_config_object]
Print 'Create Procedure [dbo].[config_new_config_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE config_new_config_object (
	@ps_config_object_id varchar(40) ,
	@ps_config_object_type varchar(24) ,
	@ps_context_object varchar(24),
	@ps_description varchar(80) ,
	@ps_long_description text = NULL,
	@ps_config_object_category varchar(80) ,
	@pl_owner_id int ,
	@ps_created_by varchar(24) 
	)
AS
--
-- Returns:
-- -1 An error occured
--


DECLARE @ll_count int,
		@ll_error int,
		@ldt_created datetime,
		@lui_config_object_id uniqueidentifier ,
		@ll_current_owner_id int

SET @lui_config_object_id = CAST(@ps_config_object_id AS uniqueidentifier)

IF @ps_created_by IS NULL
	SET @ps_created_by = dbo.fn_current_epro_user()

SET @ldt_created = getdate()


SELECT @ll_current_owner_id = owner_id
FROM c_Config_Object
WHERE config_object_id = @lui_config_object_id

SELECT @ll_count = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -1

IF @ll_count = 0
	BEGIN
	-- If the parent config object record does not exist then create it
	INSERT INTO c_Config_Object (
		config_object_id ,
		config_object_type ,
		context_object ,
		description ,
		long_description ,
		config_object_category ,
		owner_id ,
		owner_description,
		created ,
		created_by ,
		status 
		)
	VALUES (
		@lui_config_object_id,
		@ps_config_object_type ,
		@ps_context_object ,
		@ps_description ,
		@ps_long_description ,
		@ps_config_object_category ,
		@pl_owner_id ,
		dbo.fn_owner_description(@pl_owner_id),
		getdate() ,
		@ps_created_by ,
		'OK' 
		)

	SELECT @ll_count = @@ROWCOUNT,
			@ll_error = @@ERROR

	IF @ll_error <> 0
		RETURN -1
	END


RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[config_new_config_object]
	TO [cprsystem]
GO

