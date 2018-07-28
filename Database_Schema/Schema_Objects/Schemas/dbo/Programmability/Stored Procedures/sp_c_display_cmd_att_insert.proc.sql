CREATE PROCEDURE sp_c_display_cmd_att_insert (
	@pl_display_script_id int,
	@pl_display_command_id int,
	@pl_attribute_sequence int OUTPUT,
	@ps_attribute varchar(40),
	@ps_value text )
AS

DECLARE @ls_value varchar(256)

SET @ls_value = CAST(@ps_value AS varchar(256))

IF LEN(@ls_value) > 255
	BEGIN
	INSERT INTO c_Display_Script_Cmd_Attribute (
		display_script_id,
		display_command_id,
		attribute,
		long_value)
	VALUES (
		@pl_display_script_id,
		@pl_display_command_id,
		@ps_attribute,
		@ps_value)
		
	SET @pl_attribute_sequence = @@IDENTITY
	END
ELSE
	BEGIN
	INSERT INTO c_Display_Script_Cmd_Attribute (
		display_script_id,
		display_command_id,
		attribute,
		value)
	VALUES (
		@pl_display_script_id,
		@pl_display_command_id,
		@ps_attribute,
		@ps_value)
		
	SET @pl_attribute_sequence = @@IDENTITY
	END
