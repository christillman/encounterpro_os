CREATE TRIGGER tr_c_Menu_Item_Delete ON dbo.c_Menu_Item
FOR DELETE
AS

DELETE FROM c_Menu_Item_Attribute
FROM deleted
WHERE deleted.menu_id = c_menu_item_attribute.menu_id
AND deleted.menu_item_id = c_menu_item_attribute.menu_item_id

