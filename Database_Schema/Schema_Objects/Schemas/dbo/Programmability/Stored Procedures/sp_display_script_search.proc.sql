CREATE PROCEDURE sp_display_script_search (
	@ps_context_object varchar(24) = NULL,
	@ps_display_script varchar(40) = NULL,
	@ps_status varchar(12) = NULL,
	@ps_script_type varchar(24) = 'RTF',
	@ps_parent_config_object_id varchar(38) = NULL )
AS

DECLARE @lui_parent_config_object_id uniqueidentifier

IF @ps_parent_config_object_id IS NULL
	SET @lui_parent_config_object_id = NULL
ELSE
	SET @lui_parent_config_object_id = CAST(@ps_parent_config_object_id AS uniqueidentifier)


IF @ps_status IS NULL
	SET @ps_status = 'OK'

IF @ps_display_script IS NULL
	SET @ps_display_script = '%'

IF @ps_context_object IS NULL
	SET @ps_context_object = '%'

SELECT display_script_id,
	context_object,
	display_script,
	description,
	example,
	status,
	selected_flag=0,
	dbo.fn_config_object_description(parent_config_object_id) as config_object_description
FROM c_display_script
WHERE status like @ps_status
AND description like @ps_display_script
AND context_object like @ps_context_object
AND script_type = @ps_script_type
AND (@lui_parent_config_object_id IS NULL OR parent_config_object_id = @lui_parent_config_object_id)
