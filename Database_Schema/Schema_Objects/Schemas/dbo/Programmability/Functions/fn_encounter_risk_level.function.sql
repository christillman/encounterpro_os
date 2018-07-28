CREATE FUNCTION fn_encounter_risk_level (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer)

RETURNS int

AS

BEGIN

DECLARE @ll_risk_level int,
	@ll_encounter_risk_level int,
	@ll_default_assessment_risk_level int,
	@ll_default_treatment_risk_level int,
	@ldc_existing_scale dec(6,3)

SET @ll_encounter_risk_level = 0

-- First get the highest risk level of the assessments created and billed during the encounter
SELECT @ll_risk_level = max(COALESCE(p.risk_level, d.risk_level))
FROM p_Encounter_Assessment a WITH (NOLOCK)
	INNER JOIN p_Assessment p WITH (NOLOCK)
	ON a.cpr_id = p.cpr_id 
	AND a.problem_id = p.problem_id
	AND a.encounter_id = p.open_encounter_id
	INNER JOIN c_Assessment_Definition d WITH (NOLOCK)
	ON a.assessment_id = d.assessment_id
WHERE a.cpr_id = @ps_cpr_id
AND a.encounter_id = @pl_encounter_id
AND a.bill_flag = 'Y'
AND p.cpr_id = @ps_cpr_id
AND p.open_encounter_id = @pl_encounter_id

IF @ll_risk_level > @ll_encounter_risk_level
	SET @ll_encounter_risk_level = @ll_risk_level

-- First get the highest risk level of the assessment progress notes made during the encounter
SELECT @ll_risk_level = max(p.risk_level)
FROM p_Encounter_Assessment a WITH (NOLOCK)
	INNER JOIN p_Assessment_progress p WITH (NOLOCK)
	ON a.cpr_id = p.cpr_id 
	AND a.problem_id = p.problem_id
	AND a.encounter_id = p.encounter_id
WHERE a.cpr_id = @ps_cpr_id
AND a.encounter_id = @pl_encounter_id
AND a.bill_flag = 'Y'
AND p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id

IF @ll_risk_level > @ll_encounter_risk_level
	SET @ll_encounter_risk_level = @ll_risk_level


-- Then get the max risk_level of the treatments created during the encounter
-- For treatments with procedure_ids
SELECT @ll_risk_level = max(COALESCE(t.risk_level, COALESCE(p.risk_level, tt.risk_level)))
FROM p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN c_Treatment_Type tt WITH (NOLOCK)
	ON t.treatment_type = tt.treatment_type
	LEFT OUTER JOIN c_Procedure p WITH (NOLOCK)
	ON t.procedure_id = p.procedure_id
WHERE t.cpr_id = @ps_cpr_id
AND t.open_encounter_id = @pl_encounter_id
AND (t.treatment_status IS NULL or t.treatment_status <> 'CANCELLED')

IF @ll_risk_level > @ll_encounter_risk_level
	SET @ll_encounter_risk_level = @ll_risk_level

-- Then get the max risk_level of the treatments progress notes created during the encounter
SELECT @ll_risk_level = max(t.risk_level)
FROM p_Treatment_Progress t WITH (NOLOCK)
WHERE t.cpr_id = @ps_cpr_id
AND t.encounter_id = @pl_encounter_id

IF @ll_risk_level > @ll_encounter_risk_level
	SET @ll_encounter_risk_level = @ll_risk_level


RETURN @ll_encounter_risk_level
END

