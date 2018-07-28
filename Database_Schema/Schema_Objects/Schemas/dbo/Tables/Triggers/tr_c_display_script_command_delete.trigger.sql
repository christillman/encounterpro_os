CREATE TRIGGER tr_c_display_script_command_delete ON dbo.c_display_script_command
FOR DELETE
AS

UPDATE d
SET last_updated = getdate()
FROM c_display_script as d
	INNER JOIN deleted as x
		ON d.display_script_id = x.display_script_id
