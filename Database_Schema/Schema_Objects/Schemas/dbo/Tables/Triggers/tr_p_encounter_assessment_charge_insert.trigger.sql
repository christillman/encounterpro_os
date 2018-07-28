CREATE TRIGGER tr_p_encounter_assessment_charge_insert ON dbo.p_Encounter_Assessment_Charge
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

UPDATE c
SET billing_sequence = a.assessment_sequence
FROM dbo.p_Encounter_Assessment_Charge c
	INNER JOIN inserted i
	ON c.cpr_id = i.cpr_id
	AND c.encounter_id = i.encounter_id
	INNER JOIN dbo.p_Encounter_Assessment a
	ON c.cpr_id = a.cpr_id
	AND c.encounter_id = a.encounter_id
	AND c.problem_id = a.problem_id
WHERE c.billing_sequence IS NULL



