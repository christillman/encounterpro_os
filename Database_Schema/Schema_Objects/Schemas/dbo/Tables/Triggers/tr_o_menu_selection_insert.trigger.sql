CREATE TRIGGER tr_o_menu_selection_insert ON dbo.o_menu_selection
FOR INSERT
AS

UPDATE o_menu_selection
SET owner_id = c_Database_Status.customer_id
FROM o_menu_selection
	INNER JOIN inserted
	ON o_menu_selection.room_menu_selection_id = inserted.room_menu_selection_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

