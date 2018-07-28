CREATE PROCEDURE sp_xml_add_observation (
	@ps_cpr_id varchar(12),
	@ps_description varchar(80),
	@pl_treatment_id int,
	@pl_encounter_id int,
   	@pdt_result_expected_date datetime,
	@pl_parent_observation_sequence int,
	@pl_owner_id int,
	@ps_event_id varchar(40),
   	@ps_observed_by varchar(24),
   	@ps_created_by varchar(24),
   	@ps_observation_id varchar(24) ,
	@ps_observation_tag varchar(12) = NULL )
AS

DECLARE @ls_cpr_id varchar(12),
		@ll_observation_sequence int,
		@ls_treatment_observation_id varchar(24)

-- Treat empty string as null for event_id
IF @ps_event_id = ''
	SET @ps_event_id = NULL

IF @pl_owner_id IS NULL
	SELECT @pl_owner_id = customer_id
	FROM c_Database_Status

IF @ps_observed_by = ''
	SET @ps_observed_by = NULL

IF @ps_created_by = ''
	SET @ps_created_by = NULL

-- Use Observed_by as created_by if created_by wasn't supplied
SET @ps_created_by = COALESCE(@ps_created_by, @ps_observed_by)

-- if not sent try to find root observation otherwise create a new one[observation id is used from trt rec]
IF @pl_parent_observation_sequence <= 0 
	SELECT @pl_parent_observation_sequence = null

SELECT @ls_treatment_observation_id = observation_id
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('Cannot find treatment (%s, %d)',16,-1, @ps_cpr_id, @pl_treatment_id)
	ROLLBACK TRANSACTION
	RETURN
	END

-- Ignore the passed in observation_id
SET @ps_observation_id = NULL

--look up observation_id
IF @ps_observation_id IS NULL
	EXECUTE sp_new_observation_record
		@ps_description = @ps_description,
		@pl_owner_id = @pl_owner_id,
		@ps_observation_id = @ps_observation_id OUTPUT


IF @pl_parent_observation_sequence IS NULL
	BEGIN
	-- If this is a root observation and the treatment doesn't have
	-- an observation_id, then update the treatment
	IF @ls_treatment_observation_id IS NULL
		EXECUTE sp_set_treatment_progress
			@ps_cpr_id = @ps_cpr_id,
			@pl_treatment_id = @pl_treatment_id,
			@pl_encounter_id = @pl_encounter_id,
			@ps_progress_type = 'Modify',
			@ps_progress_key = 'observation_id',
			@ps_progress = @ps_observation_id,
			@ps_user_id = @ps_observed_by,
			@ps_created_by = @ps_created_by
	
	SELECT @ll_observation_sequence = max(observation_sequence)
	FROM p_Observation
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_treatment_id
	AND parent_observation_sequence IS NULL
	AND observation_id = @ps_observation_id
	AND ISNULL(observation_tag, '<NULL>') = ISNULL(@ps_observation_tag, '<NULL>')
	AND (@ps_event_id IS NULL OR ISNULL(event_id, '<NULL>') = ISNULL(@ps_event_id, '<NULL>'))
	
	IF @ll_observation_sequence IS NOT NULL
		return @ll_observation_sequence
	END
ELSE
	BEGIN
	SELECT @ll_observation_sequence = max(observation_sequence)
	FROM p_Observation
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_treatment_id
	AND parent_observation_sequence = @pl_parent_observation_sequence
	AND observation_id = @ps_observation_id
	
	IF @ll_observation_sequence IS NOT NULL
		return @ll_observation_sequence
	END

INSERT INTO p_Observation
	    (
	    cpr_id,
	    observation_id,
	    description,
	    treatment_id,
	    encounter_id,
	    observation_tag,
		event_id,
	    result_expected_date,
	    parent_observation_sequence,
	    observed_by,
	    created_by
	    )
VALUES (
	    @ps_cpr_id,
	    @ps_observation_id,
	    @ps_description,
	    @pl_treatment_id,
	    @pl_encounter_id,
	    @ps_observation_tag,
		@ps_event_id,
	    @pdt_result_expected_date,
	    @pl_parent_observation_sequence,
	    @ps_observed_by,
	    @ps_created_by
	    )

SET @ll_observation_sequence = SCOPE_IDENTITY()

return @ll_observation_sequence

