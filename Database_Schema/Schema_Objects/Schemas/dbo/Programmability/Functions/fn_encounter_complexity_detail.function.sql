CREATE FUNCTION fn_encounter_complexity_detail (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer)

RETURNS @complexity TABLE (
	context_object varchar(24) NOT NULL,
	context_object_type varchar(24) NOT NULL,
	context_object_type_description varchar(40) NOT NULL,
	object_key int NOT NULL,
	description varchar(80) NOT NULL,
	complexity_source varchar(16) NOT NULL,
	base_complexity int NOT NULL,
	factor dec(6,3) NOT NULL,
	complexity int NOT NULL)

AS

BEGIN

DECLARE @ll_default_assessment_complexity int,
	@ll_default_treatment_complexity int,
	@ldc_existing_scale dec(6,3)

-- Get the scale that we'll use the weight the existing assessments
SET @ldc_existing_scale = CAST(dbo.fn_get_global_preference('CODING', 'existing_assessment_scale') AS dec(6,3))
IF @ldc_existing_scale IS NULL
	SET @ldc_existing_scale = CAST('0.5' AS dec(6,3))

SET @ll_default_assessment_complexity = CAST(dbo.fn_get_global_preference('CODING', 'default_assessment_complexity') AS int)
IF @ll_default_assessment_complexity IS NULL
	SET @ll_default_assessment_complexity = 400

SET @ll_default_treatment_complexity = CAST(dbo.fn_get_global_preference('CODING', 'default_treatment_complexity') AS int)
IF @ll_default_treatment_complexity IS NULL
	SET @ll_default_treatment_complexity = 200

-- First add up the complexities of the diagnoses created during the encounter
INSERT INTO @complexity (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	complexity_source ,
	base_complexity ,
	factor ,
	complexity)
SELECT 'Assessment',
	d.assessment_type,
	CAST(at.description AS varchar(40)),
	p.problem_id,
	COALESCE(p.assessment, 'Assessment #' + CAST(a.problem_id AS varchar(12))),
	CASE WHEN d.complexity IS NULL THEN 
				CASE WHEN at.complexity IS NULL THEN 'Default' ELSE 'Assessment Type' END
				ELSE 'Assessment' END,
	COALESCE(d.complexity, at.complexity, @ll_default_assessment_complexity ),
	CAST(1 AS dec(6,3)),
	CAST(COALESCE(d.complexity, at.complexity, @ll_default_assessment_complexity ) AS int)
FROM p_Encounter_Assessment a WITH (NOLOCK)
	INNER JOIN p_Assessment p WITH (NOLOCK)
	ON a.cpr_id = p.cpr_id 
	AND a.problem_id = p.problem_id
	INNER JOIN c_Assessment_Definition d WITH (NOLOCK)
	ON a.assessment_id = d.assessment_id
	INNER JOIN c_Assessment_Type at WITH (NOLOCK)
	ON at.assessment_type = d.assessment_type
WHERE a.cpr_id = @ps_cpr_id
AND a.encounter_id = @pl_encounter_id
AND a.bill_flag = 'Y'
AND p.open_encounter_id = @pl_encounter_id

-- Then add up the complexities of the diagnoses billed during the encounter
-- but not created during this encounter
INSERT INTO @complexity (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	complexity_source ,
	base_complexity ,
	factor ,
	complexity)
SELECT 'Assessment',
	d.assessment_type,
	CAST(at.description AS varchar(40)),
	p.problem_id,
	COALESCE(p.assessment, 'Assessment #' + CAST(a.problem_id AS varchar(12))),
	CASE WHEN d.complexity IS NULL THEN 
				CASE WHEN at.complexity IS NULL THEN 'Default' ELSE 'Assessment Type' END
				ELSE 'Assessment' END,
	COALESCE(d.complexity, at.complexity, @ll_default_assessment_complexity ),
	@ldc_existing_scale,
	CAST(COALESCE(d.complexity, at.complexity, @ll_default_assessment_complexity ) * @ldc_existing_scale AS int)
FROM p_Encounter_Assessment a WITH (NOLOCK)
	INNER JOIN p_Assessment p WITH (NOLOCK)
	ON a.cpr_id = p.cpr_id 
	AND a.problem_id = p.problem_id
	INNER JOIN c_Assessment_Definition d WITH (NOLOCK)
	ON a.assessment_id = d.assessment_id
	INNER JOIN c_Assessment_Type at WITH (NOLOCK)
	ON at.assessment_type = d.assessment_type
WHERE a.cpr_id = @ps_cpr_id
AND a.encounter_id = @pl_encounter_id
AND a.bill_flag = 'Y'
AND p.open_encounter_id <> @pl_encounter_id

-- Then add up the complexities of the treatments created during the encounter
-- For treatments with procedure_ids
INSERT INTO @complexity (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	complexity_source ,
	base_complexity ,
	factor ,
	complexity)
SELECT 'Treatment',
	t.treatment_type,
	CAST(tt.description AS varchar(40)),
	t.treatment_id,
	COALESCE(t.treatment_description, 'Treatment #' + CAST(t.treatment_id AS varchar(12))),
	CASE WHEN p.complexity IS NULL THEN 
					CASE WHEN tt.complexity IS NULL THEN 'Default' ELSE 'Treatment Type' END
						ELSE 'Procedure' END,
	COALESCE(p.complexity, COALESCE(tt.complexity, @ll_default_treatment_complexity) ),
	CAST(1 AS dec(6,3)),
	CAST(COALESCE(p.complexity, COALESCE(tt.complexity, @ll_default_treatment_complexity) ) AS int)
FROM p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN c_Treatment_Type tt WITH (NOLOCK)
	ON t.treatment_type = tt.treatment_type
	INNER JOIN c_Procedure p WITH (NOLOCK)
	ON t.procedure_id = p.procedure_id
WHERE t.cpr_id = @ps_cpr_id
AND t.open_encounter_id = @pl_encounter_id
AND (t.treatment_status IS NULL or t.treatment_status <> 'CANCELLED')
AND t.procedure_id IS NOT NULL

-- For treatments with observation_ids and no procedure_ids
INSERT INTO @complexity (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	complexity_source ,
	base_complexity ,
	factor ,
	complexity)
SELECT 'Treatment',
	t.treatment_type,
	CAST(tt.description AS varchar(40)),
	t.treatment_id,
	COALESCE(t.treatment_description, 'Treatment #' + CAST(t.treatment_id AS varchar(12))),
	CASE WHEN p.complexity IS NULL THEN 
					CASE WHEN tt.complexity IS NULL THEN 'Default' ELSE 'Treatment Type' END
						ELSE 'Procedure' END,
	COALESCE(p.complexity, COALESCE(tt.complexity, @ll_default_treatment_complexity) ),
	CAST(1 AS dec(6,3)),
	CAST(COALESCE(p.complexity, COALESCE(tt.complexity, @ll_default_treatment_complexity) ) AS int)
FROM p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN c_Treatment_Type tt WITH (NOLOCK)
	ON t.treatment_type = tt.treatment_type
	INNER JOIN c_Observation o
	ON t.observation_id = o.observation_id
	LEFT OUTER JOIN c_Procedure p WITH (NOLOCK)
	ON o.perform_procedure_id = p.procedure_id
WHERE t.cpr_id = @ps_cpr_id
AND t.open_encounter_id = @pl_encounter_id
AND (t.treatment_status IS NULL or t.treatment_status <> 'CANCELLED')
AND t.procedure_id IS NULL
AND t.observation_id IS NOT NULL

-- Then add up the complexities of the treatments created during the encounter
-- For treatments without procedure_ids
INSERT INTO @complexity (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	complexity_source ,
	base_complexity ,
	factor ,
	complexity)
SELECT 'Treatment',
	t.treatment_type,
	CAST(tt.description AS varchar(40)),
	t.treatment_id,
	COALESCE(t.treatment_description, 'Treatment #' + CAST(t.treatment_id AS varchar(12))),
	CASE WHEN tt.complexity IS NULL THEN 'Default' ELSE 'Treatment Type' END,
	COALESCE(tt.complexity, @ll_default_treatment_complexity),
	CAST(1 AS dec(6,3)),
	CAST(COALESCE(tt.complexity, @ll_default_treatment_complexity) AS int)
FROM p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN c_Treatment_Type tt WITH (NOLOCK)
	ON t.treatment_type = tt.treatment_type
WHERE t.cpr_id = @ps_cpr_id
AND t.open_encounter_id = @pl_encounter_id
AND (t.treatment_status IS NULL or t.treatment_status <> 'CANCELLED')
AND t.procedure_id IS NULL
AND t.observation_id IS NULL

RETURN
END

