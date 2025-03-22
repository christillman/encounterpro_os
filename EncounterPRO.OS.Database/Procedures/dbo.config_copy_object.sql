
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[config_copy_object]
Print 'Drop Procedure [dbo].[config_copy_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_copy_object]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_copy_object]
GO

-- Create Procedure [dbo].[config_copy_object]
Print 'Create Procedure [dbo].[config_copy_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE config_copy_object (
	@pui_copy_from_config_object_id uniqueidentifier ,
	@pl_copy_from_version int ,
	@ps_new_description varchar(80) ,
	@ps_created_by varchar(24) ,
	@ps_new_config_object_id varchar(40) OUTPUT )
AS

DECLARE @ll_return int ,
		@ll_error int ,
		@ll_rowcount int,
		@version_found int, 
		@config_object_type_found varchar(24),
		@ls_config_object_type varchar(24),
		@ls_version_description varchar(255),
		@ls_copy_from_config_object_id varchar(40),
		@ls_new_config_object_id varchar(40),
		@lui_new_config_object_id uniqueidentifier,
		@ll_new_version int,
		@ls_context_object varchar(24),
		@ll_owner_id int,
		@ls_config_object_category varchar(80),
		@ls_copyright_status varchar(24) ,
		@ls_copyable char(1) ,
		@ls_license_data varchar(2000) ,
		@ls_license_status varchar(24) ,
		@ls_object_encoding_method varchar(12)


IF @pui_copy_from_config_object_id IS NULL
	BEGIN
	RAISERROR ('NULL config object id',16,-1)
	RETURN -1
	END

SET @ls_copy_from_config_object_id = CAST(@pui_copy_from_config_object_id AS varchar(40))

SET @ps_new_config_object_id = NULL

-- Validate config object
SELECT @ls_config_object_type = o.config_object_type,
		@ls_version_description = 'Copied from ' + o.[description],
		@ls_context_object = context_object,
		@ls_config_object_category = config_object_category
FROM dbo.c_Config_Object o
WHERE o.config_object_id = @pui_copy_from_config_object_id

IF @@ERROR <> 0
	RETURN -1

IF @ls_config_object_type IS NULL
	BEGIN
	RAISERROR ('Cannot find config object (%s)',16,-1, @ls_copy_from_config_object_id)
	RETURN -1
	END

-- Validate config object version
SELECT @ls_object_encoding_method = v.object_encoding_method, @version_found = v.version
FROM dbo.c_Config_Object_Version v
WHERE v.config_object_id = @pui_copy_from_config_object_id
AND v.version = @pl_copy_from_version

IF @@ERROR <> 0
	RETURN -1

IF @version_found IS NULL
	BEGIN
	RAISERROR ('Cannot find config object version (%s, %d)',16,-1, @ls_copy_from_config_object_id, @pl_copy_from_version)
	RETURN -1
	END

IF @ls_object_encoding_method IS NULL
	BEGIN
	SELECT @ls_object_encoding_method = t.object_encoding_method, @config_object_type_found = t.config_object_type
	FROM dbo.c_Config_Object_Type t
	WHERE t.config_object_type = @ls_config_object_type

	IF @@ERROR <> 0
		RETURN -1

	IF @config_object_type_found IS NULL
		BEGIN
		RAISERROR ('Cannot find config object type (%s)',16,-1, @ls_config_object_type)
		RETURN -1
		END
	END

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

SET @lui_new_config_object_id = newid()
SET @ls_new_config_object_id = CAST(@lui_new_config_object_id AS varchar(40))
SET @ll_new_version = 1
SET @ls_copyright_status = 'Owner'
SET @ls_copyable = 'Y'
SET @ls_license_data = NULL
SET @ls_license_status = NULL

-- Create the object/version records if they don't already exist
EXECUTE config_create_object_version
	@pui_config_object_id = @lui_new_config_object_id ,
	@ps_config_object_type = @ls_config_object_type ,
	@ps_context_object = @ls_context_object ,
	@pl_owner_id = @ll_owner_id ,
	@ps_description = @ps_new_description ,
	@ps_config_object_category = @ls_config_object_category ,
	@pl_version = @ll_new_version ,
	@ps_created_by = @ps_created_by ,
	@ps_status = 'CheckedIn',
	@ps_version_description = @ls_version_description ,
	@ps_copyright_status = @ls_copyright_status,
	@ps_copyable = @ls_copyable,
	@ps_license_data = @ls_license_data,
	@ps_license_status = @ls_license_status,
	@ps_object_encoding_method = @ls_object_encoding_method

-- Transfer the long description
UPDATE o
SET long_description = x.long_description
FROM c_Config_Object o
	CROSS JOIN c_Config_Object x
WHERE o.config_object_id = @lui_new_config_object_id
AND x.config_object_id = @pui_copy_from_config_object_id

-- Transfer the version info that couldn't be stored in local variables
UPDATE v
SET objectdata = x.objectdata,
	release_status = x.release_status,
	release_status_date_time = x.release_status_date_time
FROM c_Config_Object_Version v
	CROSS JOIN c_Config_Object_Version x
WHERE v.config_object_id = @lui_new_config_object_id
AND v.version = @ll_new_version
AND x.config_object_id = @pui_copy_from_config_object_id
AND x.version = @pl_copy_from_version

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount <> 1
	BEGIN
	RAISERROR ('Cannot find copied config object version (%s, %d)',16,-1, @ls_new_config_object_id, @ll_new_version)
	RETURN -1
	END

SET @ps_new_config_object_id = CAST(@lui_new_config_object_id AS varchar(40))

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[config_copy_object]
	TO [cprsystem]
GO

