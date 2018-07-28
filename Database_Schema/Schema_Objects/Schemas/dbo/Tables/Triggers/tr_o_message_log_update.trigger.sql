CREATE TRIGGER tr_o_message_log_update ON dbo.o_Message_Log
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

IF UPDATE( status)
BEGIN
	UPDATE o_Message_Log
	SET message_ack_datetime = getdate()
	FROM inserted
	WHERE inserted.message_id = o_Message_Log.message_id
	AND inserted.status in ('SENT','ACK_REJECT','NEVERSENT')
		
-- Acknowledgement received
	UPDATE p_patient_encounter
	SET billing_posted = 'A'
	FROM inserted
	WHERE inserted.status = 'SENT'
	AND inserted.encounter_id = p_patient_encounter.encounter_id
	AND inserted.cpr_id = p_patient_encounter.cpr_id

-- bill is sent
	UPDATE p_patient_encounter
	SET billing_posted = 'Y'
	FROM inserted
	WHERE inserted.status = 'ACK_WAIT'
	AND inserted.encounter_id = p_patient_encounter.encounter_id
	AND inserted.cpr_id = p_patient_encounter.cpr_id
	
-- bill is rejected by PMS
	UPDATE p_patient_encounter
	SET billing_posted = 'E'
	FROM inserted
	WHERE inserted.status in ('ACK_REJECT')
	AND inserted.encounter_id = p_patient_encounter.encounter_id
	AND inserted.cpr_id = p_patient_encounter.cpr_id

	UPDATE p_patient_encounter
	SET billing_posted = 'N'
	FROM inserted
	WHERE inserted.status in ('NEVERSENT')
	AND inserted.encounter_id = p_patient_encounter.encounter_id
	AND inserted.cpr_id = p_patient_encounter.cpr_id

END
