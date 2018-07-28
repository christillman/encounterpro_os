CREATE TRIGGER tr_c_Drug_Administration_all ON dbo.c_Drug_Administration
FOR INSERT, UPDATE, DELETE
AS

UPDATE c_Table_Update
SET last_updated = getdate()
WHERE table_name = 'c_Drug_Definition'

