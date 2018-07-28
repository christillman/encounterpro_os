CREATE PROCEDURE sp_c_display_cmd_att_update (
	@pl_display_script_id int,
	@pl_display_command_id int,
	@pl_attribute_sequence int,
	@ps_attribute varchar(40),
	@ps_value text )
AS

DECLARE @ls_value varchar(256)

SET @ls_value = CAST(@ps_value AS varchar(256))

IF LEN(@ls_value) > 255
	BEGIN
	UPDATE c_Display_Script_Cmd_Attribute
	SET value = NULL,
		long_value = @ps_value
	WHERE display_script_id = @pl_display_script_id
	AND display_command_id = @pl_display_command_id
	AND attribute_sequence = @pl_attribute_sequence
	END
ELSE
	BEGIN
	UPDATE c_Display_Script_Cmd_Attribute
	SET value = @ps_value,
		long_value = NULL
	WHERE display_script_id = @pl_display_script_id
	AND display_command_id = @pl_display_command_id
	AND attribute_sequence = @pl_attribute_sequence
	END



