CREATE PROCEDURE sp_set_assmnt_charge_billing (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_problem_id integer,
	@pl_encounter_charge_id integer,
	@ps_bill_flag char(1),
	@ps_created_by varchar(24) )
AS

DECLARE @ls_bill_flag char(1)

-- First make sure the assessment is billed
EXECUTE sp_set_assessment_billing
	@ps_cpr_id = @ps_cpr_id,
	@pl_encounter_id = @pl_encounter_id,
	@pl_problem_id = @pl_problem_id,
	@ps_bill_flag = NULL,
	@ps_created_by = @ps_created_by

-- See what the current bill flag is for the assessment charge record
SELECT @ls_bill_flag = bill_flag
FROM p_Encounter_Assessment_Charge
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND problem_id = @pl_problem_id
AND encounter_charge_id = @pl_encounter_charge_id

IF @@ROWCOUNT = 0
	BEGIN
	-- If there isn't an assessment charge record, then create one
	INSERT INTO p_Encounter_Assessment_Charge (
		cpr_id,
		encounter_id,
		problem_id,
		encounter_charge_id,
		bill_flag,
		created_by )
	VALUES (
		@ps_cpr_id,
		@pl_encounter_id,
		@pl_problem_id,
		@pl_encounter_charge_id,
		@ps_bill_flag,
		@ps_created_by )
	END
ELSE
	IF @ls_bill_flag <> @ps_bill_flag
		UPDATE p_Encounter_Assessment_Charge
		SET bill_flag = @ps_bill_flag
		WHERE cpr_id = @ps_cpr_id
		AND encounter_id = @pl_encounter_id
		AND problem_id = @pl_problem_id
		AND encounter_charge_id = @pl_encounter_charge_id

