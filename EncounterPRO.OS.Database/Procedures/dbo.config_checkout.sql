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

-- Drop Procedure [dbo].[config_checkout]
Print 'Drop Procedure [dbo].[config_checkout]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_checkout]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_checkout]
GO

-- Create Procedure [dbo].[config_checkout]
Print 'Create Procedure [dbo].[config_checkout]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE config_checkout (
	@pui_config_object_id varchar(40) ,
	@ps_version_description text ,
	@ps_checked_out_by varchar(24) )
AS
-- Make sure config object is not already checked out.  If not then assign new version number.
-- If a record does not already exist in c_Config_Object, then return -99
--
-- Returns:
-- -1 An error occured
-- -2 The specified config object is not locally owned
-- -3 The specified config object does not have a version record
-- -4 The specified config object is already checked out by %s
-- -5 The last version is not in a state that can be checked out (%s)
-- -99 The specified config object does not exist
--


DECLARE @ll_installed_version int,
		@ll_last_version int,
		@ll_next_version int,
		@ll_owner_id int,
		@ll_customer_id int,
		@ll_last_version_status varchar(12),
		@ls_last_checked_out_by varchar(24),
		@ls_user_full_name varchar(64),
		@ls_checkout_status varchar(12),
		@lui_config_object_id uniqueidentifier 

SET @lui_config_object_id = CAST(@pui_config_object_id AS uniqueidentifier)



SET @ls_checkout_status = 'CheckedOut'

SELECT @ll_installed_version = installed_version,
		@ll_owner_id = owner_id
FROM c_Config_Object
WHERE config_object_id = @lui_config_object_id

IF @@ROWCOUNT = 0
	RETURN -99

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

-- If the config object is not owned by the local database, then return an error
IF @ll_owner_id <> @ll_customer_id
	BEGIN
	RAISERROR ('The specified config object is not locally owned',16,-1)
	RETURN -2
	END

SELECT @ll_last_version = max(version)
FROM c_Config_Object_Version
WHERE config_object_id = @lui_config_object_id

IF @@ERROR <> 0
	RETURN -1

IF @ll_last_version IS NULL
	BEGIN
	RAISERROR ('The specified config object does not have a version record',16,-1)
	RETURN -3
	END

SELECT @ll_last_version_status = status,
		@ls_last_checked_out_by = created_by
FROM c_Config_Object_Version
WHERE config_object_id = @lui_config_object_id
AND version = @ll_last_version

IF @@ERROR <> 0
	RETURN -1

IF @ll_last_version_status NOT IN ('CheckedIn', 'Cancelled')
	BEGIN
	IF @ll_last_version_status = @ls_checkout_status
		BEGIN
		IF @ls_last_checked_out_by = @ps_checked_out_by
			BEGIN
			-- In this case, the user already has the last version checked out, so just return the last version
			RETURN @ll_last_version
			END
		ELSE
			BEGIN
			SELECT @ls_user_full_name = user_full_name
			FROM c_User
			WHERE user_id = @ls_last_checked_out_by
			-- In this case, the latest version is already checked out by someone else
			-- so take over the checkout and log what was done
			UPDATE c_Config_Object_Version
			SET checked_out_by = @ps_checked_out_by
			WHERE config_object_id = @lui_config_object_id
			AND version = @ll_last_version

			UPDATE c_Config_Object
			SET checked_out_by = @ps_checked_out_by,
				checked_out_date_time = getdate()
			WHERE config_object_id = @lui_config_object_id

			RETURN @ll_last_version
			END
		END
	-- Any other case of the previous version not checked in
	RAISERROR ('The last version is not in a state that can be checked out (%s)',16,-1, @ll_last_version_status)
	RETURN -5
	END

-- If we get here then we're ready to create the new version record

SET @ll_next_version = @ll_last_version + 1

INSERT INTO c_Config_Object_Version (
	config_object_id ,
	version ,
	description ,
	version_description ,
	config_object_type ,
	owner_id ,
	created ,
	created_by ,
	status ,
	status_date_time ,
	created_from_version,
	checked_out_by,
	object_encoding_method )
SELECT config_object_id,
	@ll_next_version,
	description,
	@ps_version_description,
	config_object_type ,
	owner_id ,
	getdate(),
	@ps_checked_out_by,
	@ls_checkout_status,
	getdate(),
	@ll_installed_version,
	@ps_checked_out_by,
	object_encoding_method
FROM c_Config_Object_Version
WHERE config_object_id = @lui_config_object_id
AND version = @ll_last_version

IF @@ERROR <> 0
	RETURN -1

-- The trigger will update the latest_version and latest_version_status fields, but we
-- know here that the installed version is the same as the latest version, so update
-- those fields here
UPDATE c_Config_Object
SET installed_version = latest_version,
	installed_version_date = latest_version_date,
	installed_version_status = latest_version_status
WHERE config_object_id = @lui_config_object_id

IF @@ERROR <> 0
	RETURN -1

RETURN @ll_next_version

GO
GRANT EXECUTE
	ON [dbo].[config_checkout]
	TO [cprsystem]
GO

