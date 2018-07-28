CREATE PROCEDURE sp_new_display_script (
	@ps_context_object varchar(24),
	@ps_display_script varchar(40),
	@ps_description varchar(128),
	@ps_created_by varchar(24),
	@ps_script_type varchar(24) = 'RTF',
	@ps_parent_config_object_id varchar(38) = NULL)
AS

DECLARE @ll_display_script_id int

INSERT INTO c_Display_Script (
	script_type,
	context_object,
	display_script,
	description,
	status,
	updated_by,
	parent_config_object_id)
VALUES (
	@ps_script_type,
	@ps_context_object,
	@ps_display_script,
	@ps_description,
	'OK',
	@ps_created_by,
	@ps_parent_config_object_id)
	
SET @ll_display_script_id = SCOPE_IDENTITY()

RETURN(@ll_display_script_id)

