
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[config_create_object_version]
Print 'Drop Procedure [dbo].[config_create_object_version]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_create_object_version]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_create_object_version]
GO

-- Create Procedure [dbo].[config_create_object_version]
Print 'Create Procedure [dbo].[config_create_object_version]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE config_create_object_version (
	@pui_config_object_id varchar(40) ,
	@ps_config_object_type varchar(24) ,
	@ps_context_object varchar(24),
	@pl_owner_id int ,
	@ps_description varchar(80) ,
	@ps_long_description varchar(max) = NULL,
	@ps_config_object_category varchar(80) ,
	@pl_version int ,
	@pi_objectdata image = NULL,
	@ps_created_by varchar(24) ,
	@ps_status varchar(12) = NULL ,
	@ps_version_description varchar(max) = NULL ,
	@ps_copyright_status varchar(24) = NULL ,
	@ps_copyable char(1) = NULL ,
	@ps_object_encoding_method varchar(12) = NULL ,
	@ps_license_data varchar(2000) = NULL ,
	@ps_license_status varchar(24) = NULL
	)
AS
--
-- Returns:
-- -1 An error occured
--


DECLARE @ll_owner_id int,
		@ls_status varchar(12),
		@ldt_checked_in datetime,
		@ldt_created datetime,
		@ls_checked_out_by varchar(12),
		@lui_config_object_id uniqueidentifier ,
		@lb_copyable bit

SET @lui_config_object_id = CAST(@pui_config_object_id AS uniqueidentifier)

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


IF @ps_copyright_status IS NULL
	SET @ps_copyright_status = 'Owner'

IF @ps_copyable IN ('Y', 'T')
	SET @lb_copyable = 1
ELSE
	SET @lb_copyable = 0

IF @ps_object_encoding_method IS NULL
	SELECT @ps_object_encoding_method = COALESCE(object_encoding_method, 'ComObjMgr')
	FROM c_Config_Object_Type
	WHERE config_object_type = @ps_config_object_type

SELECT @ll_owner_id = owner_id
FROM c_Config_Object
WHERE config_object_id = @lui_config_object_id

IF @@ERROR <> 0
	RETURN -2

IF @ll_owner_id IS NULL
	BEGIN
	-- Make sure the object doesn't exist in the base tables already owned by someone else
	SET @ll_owner_id = dbo.fn_config_object_owner(@ps_config_object_type, @lui_config_object_id)
	IF @ll_owner_id IS NOT NULL AND @ll_owner_id <> @pl_owner_id
		BEGIN
		RAISERROR ('The specified config object already exists and is owned by someone else (%d)',16,-1, @ll_owner_id)
		RETURN -3
		END


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
		status ,
		copyright_status ,
		copyable ,
		license_data ,
		license_status 
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
		dbo.get_client_datetime() ,
		@ps_created_by ,
		'OK' ,
		@ps_copyright_status ,
		@lb_copyable ,
		@ps_license_data ,
		@ps_license_status 
		)

	IF @@ERROR <> 0
		RETURN -3
	END

SELECT @ls_status = status
FROM c_Config_Object_Version
WHERE config_object_id = @lui_config_object_id
AND version = @pl_version

IF @@ERROR <> 0
	RETURN -4

IF @ls_status = 'CheckedOut'
	BEGIN
	RAISERROR ('The specified config object version already exists and is checked out',16,-1)
	RETURN -7
	END

IF @ls_status IS NULL
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
		checked_out_by ,
		object_encoding_method)
	VALUES (
		@lui_config_object_id,
		@pl_version,
		@ps_description,
		@ps_version_description ,
		@ps_config_object_type ,
		@pl_owner_id ,
		@ldt_created,
		@ps_created_by,
		@ldt_checked_in,
		@pi_objectdata,
		@ps_status,
		@ldt_created,
		@ls_checked_out_by ,
		@ps_object_encoding_method)

	IF @@ERROR <> 0
		RETURN -5
	END
ELSE
	BEGIN
	UPDATE v
	SET description = @ps_description,
		config_object_type = @ps_config_object_type,
		created = dbo.get_client_datetime(),
		created_by = @ps_created_by,
		objectdata = @pi_objectdata,
		status = @ps_status,
		version_description = @ps_version_description,
		owner_id = @pl_owner_id,
		checked_in = @ldt_checked_in,
		status_date_time = @ldt_created,
		checked_out_by = @ls_checked_out_by,
		object_encoding_method = @ps_object_encoding_method
	FROM c_Config_Object_Version v
	WHERE v.config_object_id = @lui_config_object_id
	AND v.version = @pl_version

	IF @@ERROR <> 0
		RETURN -6
	END

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[config_create_object_version]
	TO [cprsystem]
GO

