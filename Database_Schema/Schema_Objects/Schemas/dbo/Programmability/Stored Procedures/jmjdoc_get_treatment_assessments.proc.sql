CREATE  PROCEDURE jmjdoc_get_treatment_assessments (
	@ps_cpr_id varchar(24),
	@pl_encounter_id int,
	@pl_charge_id int
)

AS

-- Extract the assessments associated with a given charge record


SELECT ac.problem_id as problemid,
      COALESCE(ea.icd_9_code,a.icd_9_code) as icd9code
FROM p_Encounter_Assessment_Charge ac
    INNER JOIN p_Encounter_Assessment ea
  	ON ac.cpr_id = ea.cpr_id
	AND ac.encounter_id = ea.encounter_id
	AND ac.problem_id = ea.problem_id
INNER JOIN c_Assessment_Definition a
	ON ea.assessment_id = a.assessment_id
WHERE ac.cpr_id = @ps_cpr_id
AND ac.encounter_id = @pl_encounter_id
AND ac.encounter_charge_id = @pl_charge_id
AND ac.bill_flag = 'Y'
ORDER BY ea.assessment_sequence ASC,ea.created ASC

