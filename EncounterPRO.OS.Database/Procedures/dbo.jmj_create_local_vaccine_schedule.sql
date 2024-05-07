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

-- Drop Procedure [dbo].[jmj_create_local_vaccine_schedule]
Print 'Drop Procedure [dbo].[jmj_create_local_vaccine_schedule]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_create_local_vaccine_schedule]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_create_local_vaccine_schedule]
GO

-- Create Procedure [dbo].[jmj_create_local_vaccine_schedule]
Print 'Create Procedure [dbo].[jmj_create_local_vaccine_schedule]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.jmj_create_local_vaccine_schedule (
	@ps_new_config_object_id varchar(40) OUTPUT )
AS

DECLARE @lui_new_config_object_id uniqueidentifier,
		@ll_customer_id int,
		@ls_description varchar(80),
		@ll_rowcount int,
		@ll_error int,
		@ll_version int,
		@ls_new_config_object_id varchar(40),
		@ll_domain_sequence int

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SET @ls_description = 'Local Vaccine Schedule'

SELECT @lui_new_config_object_id = config_object_id
FROM c_Config_object
WHERE owner_id = @ll_customer_id
AND description = @ls_description

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 1
	BEGIN
	SET @ps_new_config_object_id = CAST(@lui_new_config_object_id AS varchar(40))
	RETURN 1
	END

SET @lui_new_config_object_id = newid()
SET @ls_new_config_object_id = CAST(@lui_new_config_object_id AS varchar(40))

SELECT @ll_domain_sequence = max(domain_sequence)
FROM c_Domain
WHERE domain_id = 'Config Vaccine Schedule'

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

BEGIN TRANSACTION

INSERT INTO [dbo].[c_Config_Object]
	([config_object_id]
	,[config_object_type]
	,[context_object]
	,[description]
	,[installed_version]
	,[installed_version_date]
	,[installed_version_status]
	,[latest_version]
	,[latest_version_date]
	,[latest_version_status]
	,[owner_id]
	,[owner_description]
	,[created]
	,[created_by]
	,[status])
VALUES (
	@lui_new_config_object_id
	,'Vaccine Schedule'
	,'General'
	,@ls_description
	,1
	,dbo.get_client_datetime()
	,'checkedin'
	,1
	,dbo.get_client_datetime()
	,'checkedin'
	,@ll_customer_id
	,dbo.fn_owner_description(@ll_customer_id)
	,dbo.get_client_datetime()
	,dbo.fn_current_epro_user()
	,'OK'
	)

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

SET @ll_version = 1

INSERT INTO [dbo].[c_Config_Object_Version]
	([config_object_id]
	,[version]
	,[description]
	,[version_description]
	,[config_object_type]
	,[owner_id]
	,[created]
	,[created_by]
	,[status]
	,[status_date_time]
	,[object_encoding_method])
VALUES (
	@lui_new_config_object_id
	,@ll_version
	,@ls_description
	,'Initial Local Version'
	,'Vaccine Schedule'
	,@ll_customer_id
	,dbo.get_client_datetime()
	,dbo.fn_current_epro_user()
	,'CheckedIn'
	,dbo.get_client_datetime()
	,'SQL'
	)

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE v
SET objectdata = CAST(dbo.fn_config_image(config_object_id) AS varbinary(max))
FROM dbo.c_Config_Object_Version v
WHERE config_object_id = @lui_new_config_object_id
AND version = @ll_version

SELECT @ll_rowcount = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

IF @ll_domain_sequence IS NULL
	BEGIN
	SET @ll_domain_sequence = 1

	INSERT INTO c_Domain (
		domain_id,
		domain_sequence,
		domain_item)
	VALUES (
		'Config Vaccine Schedule',
		@ll_domain_sequence,
		@ls_new_config_object_id)

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END
	END
ELSE
	BEGIN
	UPDATE c_Domain
	SET domain_item = @ls_new_config_object_id
	WHERE domain_id = 'Config Vaccine Schedule'
	AND domain_sequence = @ll_domain_sequence

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END
	END

COMMIT TRANSACTION

SET @ps_new_config_object_id = CAST(@lui_new_config_object_id AS varchar(40))

RETURN 1
GO
GRANT EXECUTE
	ON [dbo].[jmj_create_local_vaccine_schedule]
	TO [cprsystem]
GO

