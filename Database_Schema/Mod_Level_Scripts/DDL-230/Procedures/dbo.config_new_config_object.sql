
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[config_new_config_object]
Print 'Drop Procedure [dbo].[config_new_config_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_new_config_object]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_new_config_object]
GO

-- Create Procedure [dbo].[config_new_config_object]
Print 'Create Procedure [dbo].[config_new_config_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE config_new_config_object (
	@ps_config_object_id varchar(40) ,
	@ps_config_object_type varchar(24) ,
	@ps_context_object varchar(24),
	@ps_description varchar(80) ,
	@ps_long_description varchar(max) = NULL,
	@ps_config_object_category varchar(80) ,
	@pl_owner_id int ,
	@ps_created_by varchar(24) 
	)
AS
--
-- Returns:
-- -1 An error occured
--


DECLARE @ldt_created datetime,
		@lui_config_object_id uniqueidentifier ,
		@ll_current_owner_id int

SET @lui_config_object_id = CAST(@ps_config_object_id AS uniqueidentifier)

IF @ps_created_by IS NULL
	SET @ps_created_by = dbo.fn_current_epro_user()

SET @ldt_created = dbo.get_client_datetime()


SELECT @ll_current_owner_id = owner_id
FROM c_Config_Object
WHERE config_object_id = @lui_config_object_id

IF @@ERROR <> 0
	RETURN -1

IF @ll_current_owner_id IS NULL
	BEGIN
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
		status 
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
		'OK' 
		)

	IF @@ERROR <> 0
		RETURN -1
	END


RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[config_new_config_object]
	TO [cprsystem]
GO

