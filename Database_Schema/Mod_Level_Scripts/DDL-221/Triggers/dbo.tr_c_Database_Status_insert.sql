
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_c_Database_Status_insert]
Print 'Drop Trigger [dbo].[tr_c_Database_Status_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_c_Database_Status_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_c_Database_Status_insert]
GO

-- Create Trigger [dbo].[tr_c_Database_Status_insert]
Print 'Create Trigger [dbo].[tr_c_Database_Status_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
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
					FROM inserted
					JOIN deleted
					ON inserted.customer_id <> deleted.customer_id)
			BEGIN
			RAISERROR ('The customer_id cannot be updated in the master database',16,-1)
			ROLLBACK TRANSACTION
			RETURN
			END
		END
	END



GO

