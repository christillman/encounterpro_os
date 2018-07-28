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
SET user_id = i.user_id,
	computer_id = i.computer_id
FROM o_Active_Services s
	INNER JOIN inserted i
	ON s.patient_workplan_item_id = i.patient_workplan_item_id

