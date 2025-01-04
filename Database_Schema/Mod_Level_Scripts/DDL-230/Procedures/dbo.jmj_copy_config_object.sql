
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_copy_config_object]
Print 'Drop Procedure [dbo].[jmj_copy_config_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_copy_config_object]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_copy_config_object]
GO

-- Create Procedure [dbo].[jmj_copy_config_object]
Print 'Create Procedure [dbo].[jmj_copy_config_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_copy_config_object (
	@ps_copy_from_config_object_id varchar(40) ,
	@ps_new_description varchar(80) ,
	@ps_created_by varchar(24) ,
	@ps_new_config_object_id varchar(40) OUTPUT )
AS

DECLARE @ll_return int ,
		@ls_config_object_type varchar(24),
		@lui_config_object_id uniqueidentifier,
		@ls_version_description varchar(255)


IF @ps_copy_from_config_object_id IS NULL
	BEGIN
	RAISERROR ('NULL config object id',16,-1)
	RETURN -1
	END

IF LEN(@ps_copy_from_config_object_id) < 30
	BEGIN
	RAISERROR ('Config object id is not a GUID',16,-1)
	RETURN -1
	END

SET @lui_config_object_id = CAST(@ps_copy_from_config_object_id AS uniqueidentifier)
IF @@ERROR <> 0
	RETURN -1

-- Validate config object
SELECT @ls_config_object_type = o.config_object_type,
	@ls_version_description = 'Copied from ' + o.[description]
FROM dbo.c_Config_Object o
WHERE o.config_object_id = @lui_config_object_id

IF @@ERROR <> 0
	RETURN -1

IF @ls_config_object_type IS NULL
	BEGIN
	RAISERROR ('Cannot find config object (%s)',16,-1, @ps_copy_from_config_object_id)
	RETURN -1
	END

IF @ls_config_object_type = 'Report'
	BEGIN
	EXECUTE @ll_return = jmj_copy_report_or_datafile
			@ps_copy_from_report_id = @ps_copy_from_config_object_id,
			@ps_new_description = @ps_new_description,
			@ps_created_by = @ps_created_by,
			@ps_report_id = @ps_new_config_object_id OUTPUT

	IF @@ERROR <> 0
		RETURN -1

	IF @ll_return <= 0
		RETURN @ll_return
	END
ELSE IF @ls_config_object_type = 'Datafile'
	BEGIN
	EXECUTE @ll_return = jmj_copy_report_or_datafile
			@ps_copy_from_report_id = @ps_copy_from_config_object_id,
			@ps_new_description = @ps_new_description,
			@ps_created_by = @ps_created_by,
			@ps_report_id = @ps_new_config_object_id OUTPUT

	IF @@ERROR <> 0
		RETURN -1

	IF @ll_return <= 0
		RETURN @ll_return
	END
ELSE
	BEGIN
	RAISERROR ('Copying %s objects is not yet supported',16,-1, @ps_copy_from_config_object_id)
	RETURN -1
	END



/*
****************************************************************************************
The report and datafile copy proc leaves the new config object in the checked out state
****************************************************************************************
-- If success then go ahead and checkout the copy
EXECUTE dbo.config_checkout 
	@pui_config_object_id = @lui_config_object_id,
	@ps_version_description = @ls_version_description,
	@ps_checked_out_by = @ps_created_by

IF @@ERROR <> 0
	RETURN -1
****************************************************************************************
*/

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_copy_config_object]
	TO [cprsystem]
GO

