CREATE PROCEDURE config_log (
	@pui_config_object_id uniqueidentifier ,
	@ps_config_object_type varchar(24) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_operation varchar(24) ,
	@ps_property varchar(64) ,
	@ps_from_value varchar(80) ,
	@ps_to_value varchar(80) 
	)
AS

DECLARE	@ls_performed_by varchar(24) ,
		@ll_computer_id int 

IF @ps_config_object_type IS NULL OR @ps_description IS NULL
	SELECT @ps_config_object_type = COALESCE(@ps_config_object_type, object_type),
		@ps_description = COALESCE(@ps_description, description)
	FROM dbo.fn_object_info(@pui_config_object_id)


SELECT @ls_performed_by = logged_in_user_id,
		@ll_computer_id = computer_id
FROM dbo.fn_current_epro_user_context()

INSERT INTO [dbo].[c_Config_Log]
           ([config_object_id]
           ,[config_object_type]
           ,[description]
           ,[operation]
           ,[property]
           ,[from_value]
           ,[to_value]
           ,[performed_by]
           ,[computer_id])
     VALUES (
			@pui_config_object_id ,
			@ps_config_object_type ,
			@ps_description ,
			@ps_operation ,
			@ps_property ,
			@ps_from_value ,
			@ps_to_value ,
			@ls_performed_by ,
			@ll_computer_id )

