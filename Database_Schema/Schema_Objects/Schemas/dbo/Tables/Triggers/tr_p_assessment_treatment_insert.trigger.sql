CREATE TRIGGER tr_p_assessment_treatment_insert ON dbo.p_assessment_treatment
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN





DECLARE @ls_cpr_id varchar(12) ,
		@ll_problem_id int ,
		@ll_treatment_id int ,
		@ll_encounter_id int,
		@ls_created_by varchar(24),
		@ls_bill_flag char(1)

SET @ls_bill_flag = NULL

-- Add a billing record if one doesn't already exist
DECLARE lc_assessments CURSOR LOCAL STATIC FORWARD_ONLY TYPE_WARNING FOR
	SELECT DISTINCT cpr_id ,
			encounter_id,
			problem_id,
			treatment_id,
			created_by
	FROM inserted

OPEN lc_assessments

FETCH lc_assessments INTO @ls_cpr_id, @ll_encounter_id, @ll_problem_id, @ll_treatment_id, @ls_created_by

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Remove the existing billing associations that are for this treatment and this encounter,
	-- but do not have the assessment clinically associated
	DELETE a
	FROM p_Encounter_Assessment_Charge a
		INNER JOIN p_Encounter_Charge c
		ON a.cpr_id = c.cpr_id
		AND a.encounter_id = c.encounter_id
		AND a.encounter_charge_id = c.encounter_charge_id
	WHERE c.cpr_id = @ls_cpr_id
	AND c.encounter_id = @ll_encounter_id
	AND c.treatment_id = @ll_treatment_id
	AND a.problem_id NOT IN (
		SELECT problem_id
		FROM p_assessment_treatment
		WHERE cpr_id = @ls_cpr_id
		AND treatment_id = @ll_treatment_id)

	EXECUTE sp_set_assessment_billing
				@ps_cpr_id = @ls_cpr_id,
				@pl_encounter_id = @ll_encounter_id,
				@pl_problem_id = @ll_problem_id,
				@ps_bill_flag  = @ls_bill_flag,
				@ps_created_by = @ls_created_by
	
	FETCH lc_assessments INTO @ls_cpr_id, @ll_encounter_id, @ll_problem_id, @ll_treatment_id, @ls_created_by
	END

CLOSE lc_assessments
DEALLOCATE lc_assessments


-- Create the billing association if it doesn't already exist
INSERT INTO p_Encounter_Assessment_Charge (
	cpr_id,
	encounter_id,
	problem_id,
	encounter_charge_id,
	bill_flag,
	created,
	created_by)
SELECT c.cpr_id,
	c.encounter_id,
	i.problem_id,
	c.encounter_charge_id,
	c.bill_flag,
	i.created,
	i.created_by
FROM inserted i
	INNER JOIN p_Encounter_Charge c
	ON i.cpr_id = c.cpr_id
	AND i.encounter_id = c.encounter_id
	AND i.treatment_id = c.treatment_id
WHERE NOT EXISTS (
	SELECT 1
	FROM p_Encounter_Assessment_Charge c2
	WHERE c2.cpr_id = c.cpr_id
	AND c2.encounter_id = c.encounter_id
	AND c2.problem_id = i.problem_id
	AND c2.encounter_charge_id = c.encounter_charge_id )
	

