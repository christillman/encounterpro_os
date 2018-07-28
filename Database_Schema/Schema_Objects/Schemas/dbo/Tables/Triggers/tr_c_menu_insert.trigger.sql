CREATE TRIGGER tr_c_menu_insert ON dbo.c_menu
FOR INSERT
AS

UPDATE c_menu
SET owner_id = c_Database_Status.customer_id
FROM c_menu
	INNER JOIN inserted
	ON c_menu.menu_id = inserted.menu_id
	CROSS JOIN c_Database_Status
WHERE inserted.owner_id = -1

