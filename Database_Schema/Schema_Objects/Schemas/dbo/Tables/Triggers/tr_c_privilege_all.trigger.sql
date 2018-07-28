CREATE TRIGGER tr_c_privilege_all ON dbo.c_privilege
FOR INSERT, UPDATE, DELETE
AS

UPDATE c_Table_Update
SET last_updated = getdate()
WHERE table_name = 'c_privilege'

