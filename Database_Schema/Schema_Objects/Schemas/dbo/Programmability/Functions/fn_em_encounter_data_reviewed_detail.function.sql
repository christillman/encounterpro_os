CREATE FUNCTION fn_em_encounter_data_reviewed_detail (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer)

RETURNS @data_reviewed TABLE (
	context_object varchar(24) NOT NULL,
	context_object_type varchar(24) NOT NULL,
	context_object_type_description varchar(40) NOT NULL,
	object_key int NOT NULL,
	description varchar(80) NOT NULL,
	review_type varchar(16) NOT NULL,
	review_count int NOT NULL)

AS

BEGIN

DECLARE @patient_observations TABLE (
	cpr_id varchar(12) NOT NULL,
	observation_sequence int NOT NULL,
	observation_id varchar(24) NOT NULL,
	parent_observation_sequence int NULL,
	treatment_id int NULL,
	result_count int NULL)

DECLARE @reviewed_treatments TABLE (
	treatment_id int NOT NULL,
	result_count int NOT NULL)

DECLARE 	@ls_count_physical char(1)

SET @ls_count_physical = dbo.fn_get_preference('PREFERENCES', 'E&M Count Physical Results', NULL, NULL)
IF @ls_count_physical IS NULL
	SET @ls_count_physical = 'N'

IF LEFT(@ls_count_physical, 1) IN ('T', 'Y')
	SET @ls_count_physical = 'Y'
ELSE
	SET @ls_count_physical = 'N'

-- Get a list of the observations for this encounter
INSERT INTO @patient_observations (
	cpr_id ,
	observation_sequence ,
	observation_id ,
	parent_observation_sequence ,
	treatment_id,
	result_count )
SELECT o.cpr_id ,
	o.observation_sequence ,
	o.observation_id ,
	o.parent_observation_sequence ,
	o.treatment_id,
	o.result_count
FROM fn_patient_observations(@ps_cpr_id, @pl_encounter_id, DEFAULT) as o

-- Add up the result_count from all the observations, but exclude those observations
-- which are mapped to history taking bullets
INSERT INTO @data_reviewed (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	review_type ,
	review_count )
SELECT 'Treatment',
		t.treatment_type,
		tt.description,
		t.treatment_id,
		t.treatment_description,
		'Actual Results',
		x.result_count
FROM p_Treatment_Item t
	INNER JOIN c_Treatment_Type tt
	ON t.treatment_type = tt.treatment_type
	INNER JOIN (SELECT o.treatment_id, sum(o.result_count) AS result_count
				FROM @patient_observations o
				WHERE NOT EXISTS (
					SELECT 1
					FROM em_Observation_Element e
					WHERE o.observation_id = e.observation_id
					AND @ls_count_physical = 'N')
				GROUP BY o.treatment_id
				) x
	ON t.cpr_id = @ps_cpr_id
	AND t.treatment_id = x.treatment_id
	AND x.result_count > 0
		

-- Add up the result_count from all the treatments which were ordered but for which no
-- results were recorded
INSERT INTO @data_reviewed (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	review_type ,
	review_count )
SELECT 'Treatment',
		t.treatment_type,
		tt.description,
		t.treatment_id,
		t.treatment_description,
		'Ordered Results',
		x.result_count
FROM p_Treatment_Item t
	INNER JOIN c_Treatment_Type tt
	ON t.treatment_type = tt.treatment_type
	INNER JOIN (SELECT t.treatment_id, sum(o.result_count) AS result_count
				FROM p_Treatment_Item t WITH (NOLOCK)
					INNER JOIN c_Observation o WITH (NOLOCK)
					ON t.observation_id = o.observation_id
				WHERE t.cpr_id = @ps_cpr_id
				AND t.open_encounter_id = @pl_encounter_id
				AND NOT EXISTS (
					SELECT p.observation_sequence
					FROM @patient_observations p
					WHERE p.cpr_id = t.cpr_id
					AND p.treatment_id = t.treatment_id)
				AND NOT EXISTS (
					SELECT 1
					FROM em_Observation_Element e
					WHERE o.observation_id = e.observation_id
					AND @ls_count_physical = 'N')
				GROUP BY t.treatment_id
				) x
	ON t.cpr_id = @ps_cpr_id
	AND t.treatment_id = x.treatment_id
	AND x.result_count > 0

	
-- Add up the result_count from all the treatments which were reviewed but for which no
-- results were recorded
-- Get the actual encounter risk_level
INSERT INTO @reviewed_treatments (
	treatment_id,
	result_count)
SELECT treatment_id, 
	result_count = count(*)
FROM dbo.fn_encounter_reviewed_results_detail (@ps_cpr_id, @pl_encounter_id)
GROUP BY treatment_id

INSERT INTO @data_reviewed (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	review_type ,
	review_count )
SELECT 'Treatment',
		t.treatment_type,
		tt.description,
		t.treatment_id,
		t.treatment_description,
		'Reviewed Results',
		x.result_count
FROM @reviewed_treatments x
	INNER JOIN p_Treatment_Item t
	ON t.cpr_id = @ps_cpr_id
	AND t.treatment_id = x.treatment_id
	INNER JOIN c_Treatment_Type tt
	ON t.treatment_type = tt.treatment_type
WHERE x.result_count > 0



RETURN
END

