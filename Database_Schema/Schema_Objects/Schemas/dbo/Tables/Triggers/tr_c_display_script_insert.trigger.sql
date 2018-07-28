CREATE TRIGGER tr_c_display_script_insert ON dbo.c_display_script
FOR INSERT
AS

UPDATE c_display_script
SET owner_id = c_Database_Status.customer_id
FROM c_display_script
	INNER JOIN inserted
	ON c_display_script.display_script_id = inserted.display_script_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

