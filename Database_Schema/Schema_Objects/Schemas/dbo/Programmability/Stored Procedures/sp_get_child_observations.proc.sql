CREATE PROCEDURE sp_get_child_observations (
	@ps_observation_id varchar(24))
AS

SELECT o.observation_id,
	o.collection_location_domain ,
	o.perform_location_domain ,
	o.collection_procedure_id ,
	o.perform_procedure_id ,
	o.description ,
	o.composite_flag ,
	o.exclusive_flag ,
	o.in_context_flag,
	t.branch_id,
	t.sort_sequence ,
	selected_flag = 0
FROM c_Observation o, c_Observation_Tree t
WHERE t.parent_observation_id = @ps_observation_id
AND t.child_observation_id = o.observation_id
AND o.status = 'OK'


