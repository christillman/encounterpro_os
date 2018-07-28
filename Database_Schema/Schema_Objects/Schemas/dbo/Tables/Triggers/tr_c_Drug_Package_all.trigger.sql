CREATE TRIGGER tr_c_Drug_Package_all ON dbo.c_Drug_Package
FOR INSERT, UPDATE, DELETE
AS

UPDATE c_Table_Update
SET last_updated = getdate()
WHERE table_name = 'c_Drug_Definition'

