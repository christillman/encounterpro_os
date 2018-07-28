CREATE TRIGGER tr_c_Database_Status_insert ON dbo.c_Database_Status
FOR INSERT, UPDATE
AS

IF (SELECT COUNT(*) FROM c_Database_Status) > 1
	BEGIN
	RAISERROR ('The c_Database_Status table can only contain 1 record',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

IF UPDATE(customer_id)
	BEGIN
	if @@SERVERNAME = 'techserv' AND db_name() = 'epro_40_master'
		BEGIN
		IF EXISTS(SELECT 1
					FROM inserted, deleted
					WHERE inserted.customer_id <> deleted.customer_id)
			BEGIN
			RAISERROR ('The customer_id cannot be updated in the master database',16,-1)
			ROLLBACK TRANSACTION
			RETURN
			END
		END
	END



