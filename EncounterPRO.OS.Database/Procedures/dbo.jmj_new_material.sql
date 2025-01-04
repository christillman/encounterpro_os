
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_new_material]
Print 'Drop Procedure [dbo].[jmj_new_material]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_new_material]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_new_material]
GO

-- Create Procedure [dbo].[jmj_new_material]
Print 'Create Procedure [dbo].[jmj_new_material]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_new_material
	(
	@ps_title varchar(80),
	@pl_category int = NULL,
	@ps_status varchar(12) = 'OK',
	@ps_extension varchar(24),
	@pui_id varchar(40) = NULL,
	@ps_url varchar(255) = NULL,
	@ps_created_by varchar(24),
	@ps_filename varchar(128) = NULL,
	@pl_from_material_id int = NULL,
	@pui_parent_config_object_id varchar(40) = NULL
	)
AS

DECLARE @ll_material_id int,
		@ll_owner_id int,
		@ll_version int,
		@ll_from_material_id int,
		@ll_count int,
		@ll_error int,
		@ll_latest_version int,
		@ll_latest_material_id int,
		@lui_id uniqueidentifier ,
		@lui_parent_config_object_id uniqueidentifier 

SET @lui_id = CAST(@pui_id AS uniqueidentifier)
SET @lui_parent_config_object_id = CAST(@pui_parent_config_object_id AS uniqueidentifier)


-- If the ID is specified then assume it's correct
SET @ll_version = NULL

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

IF @lui_id IS NULL
	BEGIN
	-- If the @ll_from_material_id is present then attempt to determine the ID from it
	IF @ll_from_material_id IS NULL
		BEGIN
		SET @lui_id = newid()
		SET @ll_version = 1
		END
	ELSE
		BEGIN
		SELECT @lui_id = id
		FROM c_Patient_Material
		WHERE material_id = @ll_from_material_id

		IF @@ERROR <> 0
			RETURN -1

		IF @lui_id IS NULL
			BEGIN
			SET @lui_id = newid()
			SET @ll_version = 1
			END
		END
	END

-- At this point we have an ID.  Now find the latest version and material record.
SELECT @ll_latest_version = max(version)
FROM c_Patient_Material
WHERE id = @lui_id

IF @@ERROR <> 0
	RETURN -1

IF @ll_latest_version IS NULL
	BEGIN
	SET @ll_version = 1
	SET @ll_latest_material_id = NULL
	END
ELSE
	BEGIN
	SET @ll_version = @ll_latest_version + 1
	
	SELECT @ll_latest_material_id = max(material_id)
	FROM c_Patient_Material
	WHERE id = @lui_id
	AND version = @ll_latest_version

	IF @@ERROR <> 0
		RETURN -1

	IF @ll_latest_material_id IS NULL
		BEGIN
		RAISERROR ('Latest material_id for version was not found',16,-1)
		RETURN -1
		END
	END

-- At this point we have an ID, a version, and a latest material_id.  We're ready to create the new record


-- If the latest material_id is NULL, then create the record from scratch.  Otherwise create it
-- using default values from the previous record
IF @ll_latest_material_id IS NULL
	BEGIN
	INSERT INTO c_Patient_Material (
		title ,
		category ,
		status ,
		extension ,
		created_by ,
		id,
		version,
		url,
		owner_id,
		[filename],
		parent_config_object_id
		)
	VALUES (
		@ps_title,
		@pl_category,
		@ps_status,
		@ps_extension,
		@ps_created_by,
		@lui_id,
		@ll_version,
		@ps_url,
		@ll_owner_id,
		@ps_filename,
		@lui_parent_config_object_id
		)

	IF @@ERROR <> 0
		RETURN -1
	
	SELECT @ll_material_id = SCOPE_IDENTITY()
	END

ELSE
	BEGIN
	INSERT INTO c_Patient_Material (
		title ,
		category ,
		status ,
		extension ,
		created_by ,
		id,
		version,
		url,
		owner_id,
		[filename],
		parent_config_object_id
		)
	SELECT	COALESCE(@ps_title, title) ,
			COALESCE(@pl_category, category) ,
			@ps_status ,
			COALESCE(@ps_extension, extension) ,
			@ps_created_by ,
			@lui_id,
			@ll_version,
			@ps_url,
			@ll_owner_id,
			COALESCE(@ps_filename, [filename]),
			COALESCE(@lui_parent_config_object_id, parent_config_object_id)
	FROM c_Patient_material
	WHERE material_id = @ll_latest_material_id

	IF @@ERROR <> 0
		RETURN -1

	SELECT @ll_material_id = SCOPE_IDENTITY()
	END

RETURN @ll_material_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_new_material]
	TO [cprsystem]
GO

