CREATE TRIGGER tr_o_user_service_lock_update ON dbo.o_User_Service_Lock
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE s
SET user_id = i.user_id,
	computer_id = i.computer_id
FROM o_Active_Services s
	INNER JOIN inserted i
	ON s.patient_workplan_item_id = i.patient_workplan_item_id

