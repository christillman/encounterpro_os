CREATE PROCEDURE dbo.config_install_object (
	@pui_config_object_id uniqueidentifier,
	@pl_version int
	)
AS
--
-- Returns:
-- -1 An error occured
--

DECLARE @ll_error int,
		@ll_rowcount int,
		@lx_xml xml,
		@ls_config_object_id varchar(40) ,
		@ls_config_object_type varchar(24) ,
		@ll_owner_id int ,
		@ll_doc int,
		@ls_status varchar(12),
		@ls_object_encoding_method varchar(12)


SET @ls_config_object_id = CAST(@pui_config_object_id AS varchar(40))

-- Make sure the config object exists
SELECT @ls_config_object_type = config_object_type,
		@ll_owner_id = owner_id
FROM c_Config_Object
WHERE config_object_id = @pui_config_object_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount <> 1
	BEGIN
	RAISERROR ('The config object does not exist (%s)',16,-1, @ls_config_object_id)
	RETURN -1
	END
	

-- Make sure the config object exists
SELECT @ls_status = status,
		@ls_object_encoding_method = object_encoding_method,
		@lx_xml = CAST(CAST(objectdata AS varbinary(max)) AS xml)
FROM c_Config_Object_version
WHERE config_object_id = @pui_config_object_id
AND version = @pl_version

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount <> 1
	BEGIN
	RAISERROR ('The config object version does not exist (%s, %d)',16,-1, @ls_config_object_id, @pl_version)
	RETURN -1
	END

-- If this object was not encoded with SQL then it will be up to EncounterPRO to call the appropriate installer
IF @ls_object_encoding_method <> 'SQL'
	RETURN 0

-- Enumerate the supported SQL installers
IF @ls_config_object_type = 'Vaccine Schedule'
	BEGIN
	EXECUTE dbo.config_install_vaccine_schedule
		@pui_config_object_id = @pui_config_object_id,
		@pl_version = @pl_version
		
	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN -1

	RETURN 1
	END

RAISERROR ('The config object type does not have a supported SQL installer (%s)',16,-1, @ls_config_object_type)

RETURN 0

