CREATE PROCEDURE sp_new_display_script_command (
	@pl_display_script_id int,
	@ps_context_object varchar(24),
	@ps_display_command varchar(40),
	@pl_sort_sequence int,
	@ps_status varchar(8))
AS

DECLARE @ll_display_command_id int

INSERT INTO c_Display_Script_Command (
	display_script_id,
	context_object,
	display_command,
	sort_sequence,
	status,
	id)
VALUES (
	@pl_display_script_id ,
	@ps_context_object ,
	@ps_display_command ,
	@pl_sort_sequence ,
	@ps_status ,
	newid())

	
SET @ll_display_command_id = SCOPE_IDENTITY()

RETURN(@ll_display_command_id)

