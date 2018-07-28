CREATE TRIGGER tr_p_Encounter_Charge_delete ON dbo.p_Encounter_Charge
FOR DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

DELETE p_Encounter_Assessment_Charge
FROM deleted
WHERE p_Encounter_Assessment_Charge.cpr_id = deleted.cpr_id
AND p_Encounter_Assessment_Charge.encounter_id = deleted.encounter_id
AND p_Encounter_Assessment_Charge.encounter_charge_id = deleted.encounter_charge_id
