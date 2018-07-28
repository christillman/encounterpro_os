CREATE TRIGGER tr_c_role_all ON dbo.c_role
FOR INSERT, UPDATE, DELETE
AS

UPDATE c_Table_Update
SET last_updated = getdate()
WHERE table_name = 'c_role'

