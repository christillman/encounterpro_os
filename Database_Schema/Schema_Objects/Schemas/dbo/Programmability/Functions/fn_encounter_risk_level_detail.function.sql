CREATE FUNCTION fn_encounter_risk_level_detail (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer)

RETURNS @risk TABLE (
	context_object varchar(24) NOT NULL,
	context_object_type varchar(24) NOT NULL,
	context_object_type_description varchar(40) NOT NULL,
	object_key int NOT NULL,
	description varchar(80) NOT NULL,
	risk_action varchar(24) NOT NULL,
	risk_source varchar(24) NOT NULL,
	risk_level int NOT NULL)

AS

BEGIN

-- First get the highest risk level of the assessments created and billed during the encounter
--SELECT @ll_risk_level = max(COALESCE(p.risk_level, d.risk_level))
INSERT INTO @risk (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	risk_action ,
	risk_source ,
	risk_level )
SELECT DISTINCT
	'Assessment',
	ISNULL(p.assessment_type, 'SICK'),
	CAST(ISNULL(t.description, 'Sick') AS varchar(40)),
	p.problem_id,
	p.assessment,
	'Assessment Touched',
	CASE WHEN p.risk_level IS NULL THEN 'Assessment Default' ELSE 'Assessment' END,
	COALESCE(p.risk_level, d.risk_level)
FROM p_Encounter_Assessment a WITH (NOLOCK)
	INNER JOIN p_Assessment p WITH (NOLOCK)
	ON a.cpr_id = p.cpr_id 
	AND a.problem_id = p.problem_id
	AND a.encounter_id = p.open_encounter_id
	INNER JOIN c_Assessment_Definition d WITH (NOLOCK)
	ON a.assessment_id = d.assessment_id
	LEFT OUTER JOIN c_Assessment_Type t WITH (NOLOCK)
	ON p.assessment_type = t.assessment_type
WHERE a.cpr_id = @ps_cpr_id
AND a.encounter_id = @pl_encounter_id
AND a.bill_flag = 'Y'
AND p.cpr_id = @ps_cpr_id
AND p.open_encounter_id = @pl_encounter_id
AND COALESCE(p.risk_level, d.risk_level) > 0


-- First get the highest risk level of the assessment progress notes made during the encounter
--SELECT @ll_risk_level = max(p.risk_level)
INSERT INTO @risk (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	risk_action ,
	risk_source ,
	risk_level )
SELECT DISTINCT
	'Assessment',
	ISNULL(pa.assessment_type, 'SICK'),
	CAST(ISNULL(t.description, 'Sick') AS varchar(40)),
	pa.problem_id,
	pa.assessment,
	'Assessment Progress',
	'Assessment Progress',
	p.risk_level
FROM p_Encounter_Assessment a WITH (NOLOCK)
	INNER JOIN p_Assessment_progress p WITH (NOLOCK)
	ON a.cpr_id = p.cpr_id 
	AND a.problem_id = p.problem_id
	AND a.encounter_id = p.encounter_id
	INNER JOIN p_Assessment pa WITH (NOLOCK)
	ON a.cpr_id = pa.cpr_id 
	AND a.problem_id = pa.problem_id
	LEFT OUTER JOIN c_Assessment_Type t WITH (NOLOCK)
	ON pa.assessment_type = t.assessment_type
WHERE a.cpr_id = @ps_cpr_id
AND a.encounter_id = @pl_encounter_id
AND a.bill_flag = 'Y'
AND p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id
AND pa.current_flag = 'Y'
AND p.risk_level > 0



-- Then get the max risk_level of the treatments created during the encounter
-- For treatments with procedure_ids
--SELECT @ll_risk_level = max(COALESCE(t.risk_level, COALESCE(p.risk_level, tt.risk_level)))
INSERT INTO @risk (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	risk_action ,
	risk_source ,
	risk_level )
SELECT DISTINCT
	'Treatment',
	t.treatment_type,
	CAST(tt.description AS varchar(40)),
	t.treatment_id,
	t.treatment_description,
	'Treatment Ordered',
	CASE WHEN t.risk_level IS NULL 
			THEN	CASE WHEN p.risk_level IS NULL 
							THEN 'Treatment Type Default' 
							ELSE 'Procedure Default' END
			ELSE	'Treatment' END,
	COALESCE(t.risk_level, COALESCE(p.risk_level, tt.risk_level))
FROM p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN c_Treatment_Type tt WITH (NOLOCK)
	ON t.treatment_type = tt.treatment_type
	LEFT OUTER JOIN c_Procedure p WITH (NOLOCK)
	ON t.procedure_id = p.procedure_id
WHERE t.cpr_id = @ps_cpr_id
AND t.open_encounter_id = @pl_encounter_id
AND (t.treatment_status IS NULL or t.treatment_status <> 'CANCELLED')
AND COALESCE(t.risk_level, COALESCE(p.risk_level, tt.risk_level)) > 0

-- Then get the max risk_level of the treatments progress notes created during the encounter
--SELECT @ll_risk_level = max(p.risk_level)
INSERT INTO @risk (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	risk_action ,
	risk_source ,
	risk_level )
SELECT DISTINCT
	'Treatment',
	t.treatment_type,
	CAST(tt.description AS varchar(40)),
	t.treatment_id,
	t.treatment_description,
	'Treatment Progress',
	'Treatment Progress',
	p.risk_level
FROM p_Treatment_Progress p WITH (NOLOCK)
	INNER JOIN p_Treatment_Item t WITH (NOLOCK)
	ON p.cpr_id = t.cpr_id
	AND p.treatment_id = t.treatment_id
	INNER JOIN c_Treatment_Type tt WITH (NOLOCK)
	ON t.treatment_type = tt.treatment_type
WHERE p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id
AND p.risk_level > 0

RETURN
END

