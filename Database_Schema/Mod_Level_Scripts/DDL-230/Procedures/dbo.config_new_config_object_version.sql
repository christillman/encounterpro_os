
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
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[config_new_config_object_version] (
	@ps_config_object_id varchar(40) ,
	@pl_version int ,
	@pi_objectdata image = NULL,
	@pl_created_from_version int ,
	@ps_created_by varchar(24) ,
	@ps_status varchar(12) = NULL ,
	@pdt_status_date_time datetime ,
	@ps_version_description varchar(max) = NULL ,
	@ps_release_status varchar(12) = NULL ,
	@pdt_release_status_date_time datetime
	)
AS
--
-- Returns:
-- -1 An error occured
--
RETURN 1

DECLARE @ls_current_status varchar(12),
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

IF @@ERROR <> 0
	RETURN -4

SELECT @ls_current_status = status
FROM c_Config_Object_Version
WHERE config_object_id = @lui_config_object_id
AND version = @pl_version

IF @@ERROR <> 0
	RETURN -4

IF @ls_current_status = 'CheckedOut'
	BEGIN
	RAISERROR ('The specified config object version already exists and is checked out',16,-1)
	RETURN -7
	END

IF @ls_current_status IS NULL
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

	IF @@ERROR <> 0
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

	IF @@ERROR <> 0
		RETURN -6
	END



RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[config_new_config_object_version]
	TO [cprsystem]
GO

