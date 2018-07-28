CREATE TRIGGER tr_c_Menu_Item_change ON dbo.c_Menu_Item
FOR INSERT, UPDATE, DELETE
AS

EXECUTE sp_Table_Update 'c_Menu'

