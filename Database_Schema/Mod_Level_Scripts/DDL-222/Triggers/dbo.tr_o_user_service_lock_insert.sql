
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_o_user_service_lock_insert]
Print 'Drop Trigger [dbo].[tr_o_user_service_lock_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_o_user_service_lock_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_o_user_service_lock_insert]
GO

-- Create Trigger [dbo].[tr_o_user_service_lock_insert]
Print 'Create Trigger [dbo].[tr_o_user_service_lock_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_o_user_service_lock_insert ON dbo.o_User_Service_Lock
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE o_Users
SET in_service = 'Y'
FROM inserted
WHERE inserted.user_id = o_Users.user_id
AND inserted.computer_id = o_Users.computer_id
AND o_users.in_service <> 'Y'

UPDATE s
SET [user_id] = i.user_id,
	computer_id = i.computer_id
FROM o_Active_Services s
	INNER JOIN inserted i
	ON s.patient_workplan_item_id = i.patient_workplan_item_id

GO

