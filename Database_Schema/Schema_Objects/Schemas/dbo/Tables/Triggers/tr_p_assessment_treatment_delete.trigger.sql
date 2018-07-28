CREATE TRIGGER tr_p_assessment_treatment_delete ON dbo.p_assessment_treatment
FOR DELETE
AS

IF @@ROWCOUNT = 0
	RETURN


-- Set the billing to 'N' for each charge associated with both the assessment and treatment
UPDATE peac
SET bill_flag = 'N'
FROM p_Encounter_Assessment_Charge peac
	INNER JOIN p_Encounter_Charge pac
	ON peac.cpr_id = peac.cpr_id
	AND peac.encounter_id = peac.encounter_id
	AND pac.encounter_charge_id = peac.encounter_charge_id
	INNER JOIN deleted d
	ON d.cpr_id = peac.cpr_id
	AND d.encounter_id = peac.encounter_id
	AND d.problem_id = peac.problem_id
	AND d.treatment_id = pac.treatment_id
	

