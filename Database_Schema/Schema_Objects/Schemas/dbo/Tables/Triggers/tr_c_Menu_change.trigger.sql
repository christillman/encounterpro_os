CREATE TRIGGER tr_c_Menu_change ON dbo.c_Menu
FOR INSERT, UPDATE, DELETE
AS

EXECUTE sp_Table_Update 'c_Menu'

