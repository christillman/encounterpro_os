CREATE TRIGGER tr_p_encounter_assessment_delete ON dbo.p_Encounter_Assessment
FOR DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

DELETE p_Encounter_Assessment_Charge
FROM deleted
WHERE deleted.cpr_id = p_Encounter_Assessment_Charge.cpr_id
AND deleted.encounter_id = p_Encounter_Assessment_Charge.encounter_id
AND deleted.problem_id = p_Encounter_Assessment_Charge.problem_id
