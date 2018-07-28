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

-- Drop Trigger [dbo].[tr_c_config_object_version_insert_update]
Print 'Drop Trigger [dbo].[tr_c_config_object_version_insert_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_config_object_version_insert_update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_config_object_version_insert_update]
GO

-- Create Trigger [dbo].[tr_c_config_object_version_insert_update]
Print 'Create Trigger [dbo].[tr_c_config_object_version_insert_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_c_config_object_version_insert_update ON dbo.c_config_object_version
FOR INSERT, UPDATE
AS

DECLARE @lui_config_object_id uniqueidentifier,
		@ll_latest_version int,
		@ll_installed_version int,
		@ls_status varchar(12),
		@ll_owner_id int,
		@ll_customer_id int

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

DECLARE lc_objects CURSOR LOCAL FAST_FORWARD FOR
	SELECT DISTINCT config_object_id
	FROM inserted

OPEN lc_objects

FETCH lc_objects INTO @lui_config_object_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	SELECT @ll_latest_version = MAX(version)
	FROM c_config_object_version
	WHERE config_object_id = @lui_config_object_id
	AND status <> 'Cancelled'

	SELECT @ll_installed_version = installed_version,
			@ll_owner_id = owner_id
	FROM c_config_object
	WHERE config_object_id = @lui_config_object_id

	IF @ll_latest_version IS NULL
		BEGIN
		UPDATE o
		SET latest_version = NULL,
			latest_version_date = NULL,
			latest_version_status = NULL,
			checked_out_by = NULL,
			checked_out_date_time = NULL,
			checked_out_from_version = NULL
		FROM c_config_object o
		WHERE config_object_id = @lui_config_object_id
		END
	ELSE
		BEGIN
		UPDATE o
		SET latest_version = v.version,
			latest_version_date = v.status_date_time,
			latest_version_status = v.status
		FROM c_config_object o
			INNER JOIN c_config_object_version v
			ON o.config_object_id = v.config_object_id
		WHERE v.config_object_id = @lui_config_object_id
		AND v.version = @ll_latest_version

		SELECT @ls_status = status
		FROM c_config_object_version
		WHERE config_object_id = @lui_config_object_id
		AND version = @ll_latest_version

		IF @ls_status = 'CheckedOut'
			BEGIN
			UPDATE o
			SET checked_out_by = v.checked_out_by,
				checked_out_date_time = v.status_date_time,
				checked_out_from_version = v.created_from_version
			FROM c_config_object o
				INNER JOIN c_config_object_version v
				ON o.config_object_id = v.config_object_id
			WHERE v.config_object_id = @lui_config_object_id
			AND v.version = @ll_latest_version

			-- The checked out version is always the installed version
			SET @ll_installed_version = @ll_latest_version
			END
		ELSE
			BEGIN
			UPDATE o
			SET checked_out_by = NULL,
				checked_out_date_time = NULL,
				checked_out_from_version = NULL
			FROM c_config_object o
			WHERE config_object_id = @lui_config_object_id

			-- If the object is locally owned then the latest version is the installed version
			IF @ll_owner_id = @ll_customer_id AND @ll_installed_version IS NULL
				SET @ll_installed_version = @ll_latest_version
			END
		END

		UPDATE o
		SET installed_version = v.version,
			installed_version_date = v.status_date_time,
			installed_version_status = v.status
		FROM c_config_object o
			INNER JOIN c_config_object_version v
			ON o.config_object_id = v.config_object_id
		WHERE v.config_object_id = @lui_config_object_id
		AND v.version = @ll_installed_version

		FETCH lc_objects INTO @lui_config_object_id
	END

CLOSE lc_objects
DEALLOCATE lc_objects
GO

