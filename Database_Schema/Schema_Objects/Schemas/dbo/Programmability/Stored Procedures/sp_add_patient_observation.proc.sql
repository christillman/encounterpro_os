CREATE PROCEDURE sp_add_patient_observation
	(
	@ps_cpr_id varchar(12),
	@ps_observation_id varchar(24),
	@pl_parent_observation_sequence int = NULL,
	@pl_treatment_id int = NULL,
	@pl_encounter_id int = NULL,
	@ps_observed_by varchar(24),
	@ps_created_by varchar(24),
	@pl_observation_sequence int OUTPUT
	)
AS

SELECT @pl_observation_sequence = max(observation_sequence)
FROM p_Observation
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id
AND encounter_id = @pl_encounter_id
AND parent_observation_sequence = @pl_parent_observation_sequence
AND observation_id = @ps_observation_id

IF @pl_observation_sequence IS NULL
	BEGIN
	INSERT INTO p_Observation (
		cpr_id,
		observation_id,
		description,
		treatment_id,
		encounter_id,
		parent_observation_sequence,
		composite_flag,
		observed_by,
		created,
		created_by)
	SELECT @ps_cpr_id,
		@ps_observation_id,
		description,
		@pl_treatment_id,
		@pl_encounter_id,
		@pl_parent_observation_sequence,
		composite_flag,
		@ps_observed_by,
		getdate(),
		@ps_created_by
	FROM c_Observation
	WHERE observation_id = @ps_observation_id

	SELECT @pl_observation_sequence = @@IDENTITY
	END

