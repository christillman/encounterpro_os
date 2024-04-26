
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_Patient_WP_Item_Insert]
Print 'Drop Trigger [dbo].[tr_Patient_WP_Item_Insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_Patient_WP_Item_Insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_Patient_WP_Item_Insert]
GO

-- Create Trigger [dbo].[tr_Patient_WP_Item_Insert]
Print 'Create Trigger [dbo].[tr_Patient_WP_Item_Insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE   TRIGGER tr_Patient_WP_Item_Insert ON p_Patient_WP_Item
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ll_patient_workplan_item_id int

-- Set the context object from the workplan
UPDATE wi
SET context_object = COALESCE(wi.context_object, w.context_object),
	room_id = COALESCE(wi.room_id, w.room_id)
FROM p_Patient_WP_Item wi
INNER JOIN inserted i
	ON wi.patient_workplan_item_id = i.patient_workplan_item_id
INNER JOIN p_Patient_WP w
	ON i.patient_workplan_id = w.patient_workplan_id
WHERE wi.context_object IS NULL


DECLARE lc_active_service CURSOR LOCAL FAST_FORWARD FOR
	SELECT patient_workplan_item_id
	FROM inserted i

OPEN lc_active_service

FETCH lc_active_service INTO @ll_patient_workplan_item_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE jmj_set_active_service
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id

	FETCH lc_active_service INTO @ll_patient_workplan_item_id
	END

CLOSE lc_active_service
DEALLOCATE lc_active_service

IF UPDATE( expiration_date )
BEGIN
	-- Don't allow an expiration date for messages
	UPDATE wpi
	SET expiration_date = NULL
	FROM p_Patient_WP_Item wpi
	INNER JOIN inserted i
		ON i.patient_workplan_item_id = wpi.patient_workplan_item_id
	WHERE i.item_type = 'Service'
	AND i.ordered_service = 'Message'
	AND i.expiration_date IS NOT NULL
END

GO

