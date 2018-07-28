CREATE PROCEDURE sp_get_encounter_observations
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_observation_id varchar(24)
	)
AS


-- Get the root records
SELECT treatment_id, 
	observation_sequence,
	observed_by,
	service,
	observation_tag,
	created
FROM p_Observation
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND observation_id = @ps_observation_id


