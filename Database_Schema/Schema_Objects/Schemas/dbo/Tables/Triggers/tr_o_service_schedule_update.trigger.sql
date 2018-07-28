CREATE TRIGGER tr_o_service_schedule_update ON dbo.o_service_schedule
FOR UPDATE
AS

IF UPDATE(user_id)
	BEGIN
	UPDATE a
	SET user_id = i.user_id
	FROM o_service_schedule_attribute a
		INNER JOIN inserted i
		ON a.service_sequence = i.service_sequence
	END


