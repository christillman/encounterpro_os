
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[config_create_object]
Print 'Drop Procedure [dbo].[config_create_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_create_object]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_create_object]
GO

-- Create Procedure [dbo].[config_create_object]
Print 'Create Procedure [dbo].[config_create_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE config_create_object (
	@pui_config_object_id varchar(40) ,
	@ps_config_object_type varchar(24) ,
	@ps_description varchar(80) = NULL,
	@ps_long_description varchar(max) = NULL,
	@ps_config_object_category varchar(80) ,
	@pi_objectdata image ,
	@ps_created_by varchar(24) )
AS
-- 
-- This procedure is for use by a checkout or export process that needs to create the root
-- config object record that might not already exist
--
-- Returns:
-- -1 An error occured
-- -2 The specified config object is not locally owned
-- -3 The specified config object already has a version record
--


DECLARE @ll_next_version int,
		@ll_owner_id int,
		@ll_customer_id int,
		@ll_last_version_status varchar(12),
		@ls_last_checked_out_by varchar(24),
		@ls_user_full_name varchar(64),
		@ls_context_object varchar(24),
		@lui_config_object_id uniqueidentifier 

SET @lui_config_object_id = CAST(@pui_config_object_id AS uniqueidentifier)

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SET @ll_owner_id = dbo.fn_config_object_owner(@ps_config_object_type, @lui_config_object_id)
SET @ls_context_object = dbo.fn_config_object_context_object(@lui_config_object_id)

-- If the config object is not owned by the local database, then return an error
IF @ll_owner_id <> @ll_customer_id
	BEGIN
	RAISERROR ('The specified config object is not locally owned',16,-1)
	RETURN -2
	END

IF @ps_description IS NULL
	SET @ps_description = dbo.fn_config_object_description(@lui_config_object_id)

EXECUTE config_create_object_version
	@pui_config_object_id = @lui_config_object_id ,
	@ps_config_object_type = @ps_config_object_type ,
	@ps_context_object = @ls_context_object ,
	@pl_owner_id = @ll_owner_id ,
	@ps_description = @ps_description ,
	@ps_long_description = @ps_long_description ,
	@ps_config_object_category = @ps_config_object_category ,
	@pl_version = 1 ,
	@pi_objectdata = @pi_objectdata ,
	@ps_created_by = @ps_created_by 

IF @@ERROR <> 0
	RETURN -2

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[config_create_object]
	TO [cprsystem]
GO

