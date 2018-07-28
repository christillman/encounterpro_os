CREATE TRIGGER tr_c_user_all ON dbo.c_user
FOR INSERT, UPDATE, DELETE
AS

-- Set the last_updated field
UPDATE c_Table_Update
SET last_updated = getdate()
WHERE table_name = 'c_User'


