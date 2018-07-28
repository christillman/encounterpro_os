CREATE FUNCTION fn_em_type_rules_element_details (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_em_component varchar(24),
	@ps_em_type varchar(24))

RETURNS @em_type_rules_data TABLE (
	context_object varchar(24) NOT NULL,
	context_object_type varchar(24) NOT NULL,
	context_object_type_description varchar(40) NOT NULL,
	object_key int NOT NULL,
	description varchar(80) NOT NULL,
	observation_sequence int NOT NULL,
	observation_id varchar(24) NOT NULL,
	observation_description varchar(80) NOT NULL,
	parent_observation_sequence int NULL,
	em_category varchar(24) NOT NULL,
	em_element varchar(40) NOT NULL)


AS
BEGIN
DECLARE @ls_em_documentation_guide varchar(24),
	@ls_em_component varchar(24),
	@ls_em_type varchar(24),
	@ll_em_type_level int,
	@ll_rule_id int,
	@ll_item_sequence int,
	@ls_em_category varchar(24),
	@ll_min_element_count int,
	@ll_min_category_count int,
	@ll_min_elements_per_category int,
	@ls_actual_new_flag char(1),
	@ls_new_flag char(1),
	@li_item_count smallint,
	@li_actual_element_count smallint,
	@li_actual_category_count smallint,
	@ll_actual_encounter_complexity int,
	@ll_actual_encounter_risk_level int,
	@ll_actual_encounter_results int,
	@ll_ordered_encounter_results int,
	@ll_reviewed_encounter_results int,
	@ll_total_encounter_results int,
	@ls_count_physical char(1)

DECLARE @patient_observations TABLE (
	cpr_id varchar(12) NOT NULL,
	observation_sequence int NOT NULL,
	observation_id varchar(24) NOT NULL,
	parent_observation_sequence int NULL,
	treatment_id int NULL,
	result_count int NULL)

DECLARE @em_elements TABLE (
	em_component varchar(24) NOT NULL,
	em_type varchar(24) NOT NULL,
	em_category varchar(24) NOT NULL,
	em_element varchar(40) NOT NULL)

-- Get a list of the observations for this encounter
INSERT INTO @em_type_rules_data (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	observation_sequence ,
	observation_id ,
	observation_description ,
	parent_observation_sequence ,
	em_category ,
	em_element )
SELECT 'Treatment' ,
	t.treatment_type,
	tt.description,
	t.treatment_id,
	t.treatment_description,
	p.observation_sequence ,
	p.observation_id ,
	p.description,
	p.parent_observation_sequence ,
	e.em_category ,
	e.em_element 
FROM fn_patient_observations(@ps_cpr_id, @pl_encounter_id, DEFAULT) as o
	INNER JOIN em_observation_element as e WITH (NOLOCK)
	ON o.observation_id = e.observation_id
	INNER JOIN p_Observation p
	ON p.cpr_id = @ps_cpr_id
	AND p.observation_sequence = o.observation_sequence
	INNER JOIN p_Treatment_Item t
	ON t.cpr_id = @ps_cpr_id
	AND t.treatment_id = p.treatment_id
	INNER JOIN c_Treatment_Type tt
	ON t.treatment_type = tt.treatment_type
WHERE e.em_component = @ps_em_component
AND e.em_type = @ps_em_type


RETURN
END

