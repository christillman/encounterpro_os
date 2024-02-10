
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_o_service_schedule_update]
Print 'Drop Trigger [dbo].[tr_o_service_schedule_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_o_service_schedule_update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_o_service_schedule_update]
GO

-- Create Trigger [dbo].[tr_o_service_schedule_update]
Print 'Create Trigger [dbo].[tr_o_service_schedule_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_o_service_schedule_update ON dbo.o_service_schedule
FOR UPDATE
AS

IF UPDATE(user_id)
	BEGIN
	UPDATE a
	SET [user_id] = i.user_id
	FROM o_service_schedule_attribute a
		INNER JOIN inserted i
		ON a.service_sequence = i.service_sequence
	END


GO

