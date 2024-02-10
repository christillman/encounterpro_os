
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_o_user_service_lock_delete]
Print 'Drop Trigger [dbo].[tr_o_user_service_lock_delete]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_o_user_service_lock_delete]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_o_user_service_lock_delete]
GO

-- Create Trigger [dbo].[tr_o_user_service_lock_delete]
Print 'Create Trigger [dbo].[tr_o_user_service_lock_delete]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_o_user_service_lock_delete ON dbo.o_User_Service_Lock
FOR DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE o_Users
SET in_service = 'N'
FROM deleted
WHERE deleted.user_id = o_Users.user_id
AND deleted.computer_id = o_Users.computer_id
AND o_users.in_service <> 'N'
AND NOT EXISTS (
	SELECT patient_workplan_item_id
	FROM o_User_Service_Lock l
	WHERE l.user_id = deleted.user_id
	AND l.computer_id = deleted.computer_id)

UPDATE s
SET [user_id] = NULL,
	computer_id = NULL
FROM o_Active_Services s
	INNER JOIN deleted d
	ON s.patient_workplan_item_id = d.patient_workplan_item_id

GO

