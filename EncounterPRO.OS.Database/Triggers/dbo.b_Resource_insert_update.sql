
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[b_Resource_insert_update]
Print 'Drop Trigger [dbo].[b_Resource_insert_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[b_Resource_insert_update]') AND [type]='TR'))
DROP TRIGGER [dbo].[b_Resource_insert_update]
GO

-- Create Trigger [dbo].[b_Resource_insert_update]
Print 'Create Trigger [dbo].[b_Resource_insert_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER b_Resource_insert_update ON b_Resource
FOR
	 INSERT
	,UPDATE
AS

-- Make sure the [user_id] is valid
IF EXISTS (SELECT 1
		FROM inserted
		WHERE [user_id] NOT IN (SELECT [user_id] FROM c_User)
		AND [user_id] NOT IN (SELECT role_id FROM c_Role) )
	BEGIN
		RAISERROR ( 'Invalid User ID', 16, 1 )
		ROLLBACK TRAN
	END

-- Make sure the case matches the actual key
UPDATE b
SET [user_id] = u.user_id
FROM b_Resource b
	INNER JOIN inserted i
	ON b.resource = i.resource
	AND b.resource_sequence = i.resource_sequence
	INNER JOIN c_User u
	ON b.user_id = u.user_id

UPDATE b
SET [user_id] = r.role_id
FROM b_Resource b
	INNER JOIN inserted i
	ON b.resource = i.resource
	AND b.resource_sequence = i.resource_sequence
	INNER JOIN c_Role r
	ON b.user_id = r.role_id

GO

