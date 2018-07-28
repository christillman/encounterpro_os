CREATE TRIGGER tr_c_Drug_Definition_all ON dbo.c_Drug_Definition
FOR INSERT, UPDATE, DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE c_Table_Update
SET last_updated = getdate()
WHERE table_name = 'c_Drug_Definition'

