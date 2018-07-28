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

-- Drop Procedure [dbo].[config_cancel_checkout]
Print 'Drop Procedure [dbo].[config_cancel_checkout]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_cancel_checkout]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_cancel_checkout]
GO

-- Create Procedure [dbo].[config_cancel_checkout]
Print 'Create Procedure [dbo].[config_cancel_checkout]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE config_cancel_checkout (
	@pui_config_object_id uniqueidentifier ,
	@ps_checked_out_by varchar(24) = NULL)
AS
-- Make sure config object is not already checked out.  If not then assign new version number.
-- If a record does not already exist in c_Config_Object, then return -99
--
-- Returns:
-- -1 An error occured
-- -2 The specified config object is not locally owned
-- -3 The specified config object does not have a version record
-- -4 The specified config object is not checked out
-- -5 The specified config object is checked out by someone else (%s)
-- -99 The specified config object does not exist
--


DECLARE @ll_installed_version int,
		@ll_previous_version int,
		@ll_owner_id int,
		@ll_customer_id int,
		@ll_installed_version_status varchar(12),
		@ls_installed_version_checked_out_by varchar(24),
		@ls_user_full_name varchar(64),
		@ll_error int,
		@ll_rowcount int,
		@ls_config_object_id varchar(40),
		@ls_from_value varchar(80)

SET @ls_config_object_id = CAST(@pui_config_object_id AS varchar(40))

SELECT @ll_installed_version = installed_version,
		@ll_owner_id = owner_id
FROM c_Config_Object
WHERE config_object_id = @pui_config_object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount = 0
	BEGIN
	RAISERROR ('The specified config object does not exists (%s)',16,-1, @ls_config_object_id)
	RETURN -99
	END

IF @ll_installed_version IS NULL
	BEGIN
	RAISERROR ('The specified config object does not have an installed version)',16,-1, @ls_config_object_id)
	RETURN -1
	END

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

-- If the config object is not owned by the local database, then return an error
IF @ll_owner_id <> @ll_customer_id
	BEGIN
	RAISERROR ('The specified config object is not locally owned (%s)',16,-1, @ls_config_object_id)
	RETURN -2
	END

SELECT @ll_previous_version = created_from_version,
		@ll_installed_version_status = status,
		@ls_installed_version_checked_out_by = created_by
FROM c_Config_Object_Version
WHERE config_object_id = @pui_config_object_id
AND version = @ll_installed_version

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount = 0
	BEGIN
	RAISERROR ('The specified config object installed version does not have a version record (%s, %d)',16,-1, @ls_config_object_id, @ll_installed_version)
	RETURN -3
	END

IF @ll_previous_version IS NULL 
	BEGIN
	SELECT @ll_previous_version = max(version)
	FROM c_Config_Object_Version
	WHERE config_object_id = @pui_config_object_id
	AND status = 'CheckedIn'
	AND version < @ll_installed_version

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN -1

	IF @ll_previous_version IS NULL
		BEGIN
		RAISERROR ('Unable to determine previous version (%s, %d)',16,-1, @ls_config_object_id, @ll_installed_version)
		RETURN -1
		END
	END


IF @ll_installed_version_status <> 'CheckedOut'
	BEGIN
	RAISERROR ('The specified config object is not checked out',16,-1)
	RETURN -4
	END

-- If we get here then we're ready to cancel the checkout
BEGIN TRANSACTION

DELETE v
FROM c_Config_Object_Version v
WHERE v.config_object_id = @pui_config_object_id
AND v.version = @ll_installed_version

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE c
SET installed_version = NULL,
	installed_version_date = NULL,
	installed_version_status = NULL
FROM c_Config_Object c
WHERE c.config_object_id = @pui_config_object_id

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

SET @ls_from_value = CAST(@ll_installed_version AS varchar(80))

EXECUTE config_log
	@pui_config_object_id = @pui_config_object_id ,
	@ps_operation = 'Cancel Checkout' ,
	@ps_property = 'installed_version',
	@ps_from_value = @ls_from_value ,
	@ps_to_value = NULL


COMMIT TRANSACTION

RETURN @ll_previous_version

GO
GRANT EXECUTE
	ON [dbo].[config_cancel_checkout]
	TO [cprsystem]
GO

