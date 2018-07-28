CREATE TRIGGER tr_c_display_script_command_update ON dbo.c_display_script_command
FOR UPDATE
AS

UPDATE d
SET last_updated = getdate()
FROM c_display_script as d
	INNER JOIN inserted as i
		ON d.display_script_id = i.display_script_id

