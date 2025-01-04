
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
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.jmj_create_local_vaccine_schedule (
	@ps_new_config_object_id varchar(40) OUTPUT )
AS

DECLARE @lui_new_config_object_id uniqueidentifier,
		@ll_customer_id int,
		@ls_description varchar(80),
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

IF @@ERROR <> 0
	RETURN

IF @lui_new_config_object_id IS NOT NULL
	BEGIN
	SET @ps_new_config_object_id = CAST(@lui_new_config_object_id AS varchar(40))
	RETURN 1
	END

SET @lui_new_config_object_id = newid()
SET @ls_new_config_object_id = CAST(@lui_new_config_object_id AS varchar(40))

SELECT @ll_domain_sequence = max(domain_sequence)
FROM c_Domain
WHERE domain_id = 'Config Vaccine Schedule'

IF @@ERROR <> 0
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

IF @@ERROR <> 0
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

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

UPDATE v
SET objectdata = CAST(dbo.fn_config_image(config_object_id) AS varbinary(max))
FROM dbo.c_Config_Object_Version v
WHERE config_object_id = @lui_new_config_object_id
AND version = @ll_version

IF @@ERROR <> 0
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

	IF @@ERROR <> 0
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

	IF @@ERROR <> 0
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

