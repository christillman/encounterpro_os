CREATE TRIGGER tr_u_display_script_selection_insert ON dbo.u_display_script_selection
FOR INSERT
AS

UPDATE u_display_script_selection
SET owner_id = c_Database_Status.customer_id
FROM u_display_script_selection
	INNER JOIN inserted
	ON u_display_script_selection.display_script_selection_id = inserted.display_script_selection_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

