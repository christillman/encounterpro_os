CREATE TRIGGER tr_o_user_service_all ON dbo.o_user_service
FOR INSERT, UPDATE, DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE c_Table_Update
SET last_updated = getdate()
WHERE table_name = 'o_user_service'

