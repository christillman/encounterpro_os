CREATE TRIGGER tr_c_display_script_command_insert ON dbo.c_display_script_command
FOR INSERT
AS

UPDATE d
SET last_updated = getdate()
FROM c_display_script as d
	INNER JOIN inserted as i
		ON d.display_script_id = i.display_script_id
