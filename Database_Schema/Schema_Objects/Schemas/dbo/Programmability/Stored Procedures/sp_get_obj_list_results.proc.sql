CREATE PROCEDURE sp_get_obj_list_results (
	@ps_cpr_id varchar(12),
	@ps_obj_list_id varchar(24),
	@pdt_from_date datetime )
AS
SELECT p_Patient_Encounter.encounter_id,
	p_Patient_Encounter.encounter_date,
	p_Observation_Result.observation_id,
	p_Observation_Result.result_sequence,
	p_Observation_Result.location,
	convert(real,p_Observation_Result.result_value) as result_amount,
	p_Observation_Result.result_unit,
	1 as item_index
FROM p_Observation_Result (NOLOCK),
	c_Observation_Tree (NOLOCK),
	p_Patient_Encounter (NOLOCK)
WHERE p_Observation_Result.result_sequence = c_Observation_Tree.result_sequence
AND p_Observation_Result.location = c_Observation_Tree.location
AND p_Observation_Result.observation_id = c_Observation_Tree.child_observation_id
AND c_Observation_Tree.parent_observation_id = @ps_obj_list_id
AND p_Observation_Result.encounter_id = p_Patient_Encounter.encounter_id
AND p_Observation_Result.cpr_id = p_Patient_Encounter.cpr_id
AND p_Patient_Encounter.cpr_id = @ps_cpr_id
AND p_Patient_Encounter.encounter_date >= @pdt_from_date
UNION
SELECT p_Patient_Encounter.encounter_id,
	p_Patient_Encounter.encounter_date,
	p_Observation_Result.observation_id,
	p_Observation_Result.result_sequence,
	p_Observation_Result.location,
	convert(real,p_Observation_Result.result_value) as result_amount,
	p_Observation_Result.result_unit,
	2 as item_index
FROM p_Observation_Result (NOLOCK),
	c_Observation_Tree (NOLOCK),
	p_Patient_Encounter (NOLOCK)
WHERE p_Observation_Result.result_sequence = c_Observation_Tree.result_sequence_2
AND p_Observation_Result.location = c_Observation_Tree.location
AND p_Observation_Result.observation_id = c_Observation_Tree.child_observation_id
AND c_Observation_Tree.parent_observation_id = @ps_obj_list_id
AND p_Observation_Result.encounter_id = p_Patient_Encounter.encounter_id
AND p_Observation_Result.cpr_id = p_Patient_Encounter.cpr_id
AND p_Patient_Encounter.cpr_id = @ps_cpr_id
AND p_Patient_Encounter.encounter_date >= @pdt_from_date

