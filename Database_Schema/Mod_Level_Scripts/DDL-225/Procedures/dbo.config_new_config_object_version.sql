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

-- Drop Procedure [dbo].[config_new_config_object_version]
Print 'Drop Procedure [dbo].[config_new_config_object_version]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_new_config_object_version]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_new_config_object_version]
GO

-- Create Procedure [dbo].[config_new_config_object_version]
Print 'Create Procedure [dbo].[config_new_config_object_version]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[config_new_config_object_version] (
	@ps_config_object_id varchar(40) ,
	@pl_version int ,
	@pi_objectdata image = NULL,
	@pl_created_from_version int ,
	@ps_created_by varchar(24) ,
	@ps_status varchar(12) = NULL ,
	@pdt_status_date_time datetime ,
	@ps_version_description text = NULL ,
	@ps_release_status varchar(12) = NULL ,
	@pdt_release_status_date_time datetime
	)
AS
--
-- Returns:
-- -1 An error occured
--
RETURN 1

DECLARE @ll_count int,
		@ll_error int,
		@ls_current_status varchar(12),
		@ldt_checked_in datetime,
		@ldt_created datetime,
		@ls_checked_out_by varchar(12),
		@lui_config_object_id uniqueidentifier ,
		@lb_copyable bit,
		@ls_description varchar(80),
		@ls_config_object_type varchar(24),
		@ll_owner_id int

SET @lui_config_object_id = CAST(@ps_config_object_id AS uniqueidentifier)

IF @ps_created_by IS NULL
	SET @ps_created_by = dbo.fn_current_epro_user()

SET @ldt_created = dbo.get_client_datetime()

-- If the status is NULL then set it based on whether or not @pi_objectdata is NULL
IF @ps_status IS NULL
	BEGIN
	IF @pi_objectdata IS NULL
		BEGIN
		SET @ps_status = 'CheckedOut'
		SET @ldt_checked_in = NULL
		END
	ELSE
		BEGIN
		SET @ps_status = 'CheckedIn'
		SET @ldt_checked_in = @ldt_created
		END
	END

IF @ps_status = 'CheckedOut'
	SET @ls_checked_out_by = @ps_created_by
ELSE
	SET @ls_checked_out_by = NULL



SELECT @ls_description = description,
		@ls_config_object_type = config_object_type,
		@ll_owner_id = owner_id
FROM c_Config_Object
WHERE config_object_id = @lui_config_object_id

SELECT @ll_count = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -4

SELECT @ls_current_status = status
FROM c_Config_Object_Version
WHERE config_object_id = @lui_config_object_id
AND version = @pl_version

SELECT @ll_count = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -4

IF @ll_count = 1 AND @ls_current_status = 'CheckedOut'
	BEGIN
	RAISERROR ('The specified config object version already exists and is checked out',16,-1)
	RETURN -7
	END

IF @ll_count = 0
	BEGIN

	-- Create the new version record
	INSERT INTO c_Config_Object_Version (
		config_object_id ,
		version ,
		description ,
		version_description ,
		config_object_type ,
		owner_id ,
		created ,
		created_by ,
		checked_in ,
		objectdata,
		status,
		status_date_time,
		checked_out_by )
	VALUES (
		@lui_config_object_id,
		@pl_version,
		@ls_description,
		@ps_version_description ,
		@ls_config_object_type ,
		@ll_owner_id ,
		@ldt_created,
		@ps_created_by,
		@ldt_checked_in,
		@pi_objectdata,
		@ps_status,
		@ldt_created,
		@ls_checked_out_by
		)

	SELECT @ll_count = @@ROWCOUNT,
			@ll_error = @@ERROR

	IF @ll_error <> 0
		RETURN -5
	END
ELSE
	BEGIN
	UPDATE v
	SET description = @ls_description,
		config_object_type = @ls_config_object_type,
		created = dbo.get_client_datetime(),
		created_by = @ps_created_by,
		objectdata = @pi_objectdata,
		status = @ps_status,
		version_description = @ps_version_description,
		owner_id = @ll_owner_id,
		checked_in = @ldt_checked_in,
		status_date_time = @ldt_created,
		checked_out_by = @ls_checked_out_by
	FROM c_Config_Object_Version v
	WHERE v.config_object_id = @lui_config_object_id
	AND v.version = @pl_version

	SELECT @ll_count = @@ROWCOUNT,
			@ll_error = @@ERROR

	IF @ll_error <> 0
		RETURN -6
	END



RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[config_new_config_object_version]
	TO [cprsystem]
GO

