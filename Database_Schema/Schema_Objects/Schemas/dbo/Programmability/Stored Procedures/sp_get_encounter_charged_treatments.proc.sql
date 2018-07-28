CREATE PROCEDURE sp_get_encounter_charged_treatments (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int
)
AS

DECLARE @charges TABLE (
	treatment_id int NOT NULL,
	bill_flag char(1) NOT NULL )

INSERT INTO @charges (
	treatment_id,
	bill_flag )
SELECT DISTINCT treatment_id, 
		'Y'
FROM p_Encounter_Charge 
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND treatment_id IS NOT NULL

UPDATE ch
SET bill_flag = 'N'
FROM @charges ch
WHERE NOT EXISTS (
	SELECT 1
	FROM p_Encounter_Charge c
		INNER JOIN p_Encounter_Assessment_Charge ac
		ON c.cpr_id = ac.cpr_id
		AND c.encounter_id = ac.encounter_id
		AND c.encounter_charge_id = ac.encounter_charge_id
		INNER JOIN p_Encounter_Assessment a
		ON a.cpr_id = ac.cpr_id
		AND a.encounter_id = ac.encounter_id
		AND a.problem_id = ac.problem_id
	WHERE c.cpr_id = @ps_cpr_id
	AND c.encounter_id = @pl_encounter_id
	AND c.bill_flag = 'Y'
	AND ac.cpr_id = @ps_cpr_id
	AND ac.encounter_id = @pl_encounter_id
	AND ac.bill_flag = 'Y'
	AND a.cpr_id = @ps_cpr_id
	AND a.encounter_id = @pl_encounter_id
	AND a.bill_flag = 'Y'
	AND ch.treatment_id = c.treatment_id)

SELECT treatment_id,
		bill_flag
FROM @charges


