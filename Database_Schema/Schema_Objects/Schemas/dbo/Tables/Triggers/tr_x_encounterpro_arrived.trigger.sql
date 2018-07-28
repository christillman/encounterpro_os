


CREATE TRIGGER [tr_x_encounterpro_arrived] ON [dbo].[x_encounterpro_Arrived]
FOR UPDATE
AS

IF NOT EXISTS(SELECT 1 FROM p_Patient_Encounter_Progress p (NOLOCK),inserted i 
			  WHERE p.cpr_id = i.cpr_id
			  AND p.encounter_id = i.encounter_id
			  AND progress_key = 'VisitNumber'
			  AND progress_value = i.visitnumber_id
			  AND current_flag  = 'Y')
BEGIN
	
INSERT INTO p_Patient_Encounter_Progress (
	cpr_id,
	encounter_id,
	progress_type,
	progress_key,
	progress_value ,
	user_id,
	created_by) SELECT
	i.cpr_id,
	i.encounter_id,
	'Property',
	'VisitNumber',
	i.visitnumber_id,
	'#SYSTEM',
	'#SYSTEM'
	FROM inserted i
	WHERE i.encounter_id > 0


IF EXISTS(SELECT 1 FROM o_Preferences WHERE preference_id='Save VisitNumber In EncounterBillingNote' and (upper(left(preference_value,1))='Y' OR upper(left(preference_value,1))='T'))
BEGIN
	UPDATE p 
	SET p.billing_note =    CASE WHEN i.visitnumber_id IS NULL THEN p.billing_note
											ELSE CASE WHEN p.billing_note IS NULL THEN 'Billing System VisitNumber: ' + i.visitnumber_id
																ELSE CAST(p.billing_note AS varchar(255)) + '\r\n' + 'Billing System VisitNumber: ' + i.visitnumber_id
																END
											END
	FROM p_Patient_Encounter p WITH (NOLOCK)
		INNER JOIN inserted i 
		ON p.cpr_id = i.cpr_id 
		AND p.encounter_id = i.encounter_id 
	WHERE i.encounter_id > 0 
END


END

