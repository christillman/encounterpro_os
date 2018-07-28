CREATE TRIGGER tr_c_vaccine_all ON dbo.c_vaccine
FOR INSERT, UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE c_Table_Update
SET last_updated = getdate()
WHERE table_name = 'c_vaccine'

