
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
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[jmj_upload_config_object] (
	@pui_config_object_id varchar(40) ,
	@pl_version int ,
	@ps_user_id [varchar] (24) )
AS

--DECLARE @ll_count int,
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

--IF @@ERROR <> 0
--	RETURN -2

--IF @ls_status IS NULL
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

--IF @@ERROR <> 0
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
--	dbo.get_client_datetime() ,
--	objectdata ,
--	@ps_user_id
--FROM c_Config_Object_Version
--WHERE config_object_id = @lui_config_object_id
--AND version = @pl_version

--IF @@ERROR <> 0
--	RETURN -2

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_upload_config_object]
	TO [public]
GO

