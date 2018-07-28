CREATE     FUNCTION fn_patient_observation_dates
(	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24) = 'Patient',
	@pl_object_key int = NULL,
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint = NULL,
	@ps_result_type varchar(24) = NULL
)

RETURNS @patient_observation_dates TABLE (	 
	observation_date datetime NOT NULL )

AS

BEGIN
DECLARE @temp_dates TABLE (	 
	observation_date datetime NOT NULL )

DECLARE @ll_encounter_id int,
		@ll_treatment_id int,
		@ll_observation_sequence int,
		@ls_child_observation_id varchar(24), 
		@li_child_result_sequence smallint

SET @ll_encounter_id = NULL
SET @ll_treatment_id = NULL
SET @ll_observation_sequence = NULL

IF @ps_context_object = 'Encounter'
	SET @ll_encounter_id = @pl_object_key

IF @ps_context_object = 'Treatment'
	SET @ll_treatment_id = @pl_object_key

IF @ps_context_object = 'Observation'
	SET @ll_observation_sequence = @pl_object_key

-- First get the specified results from the specified observation
IF @pi_result_sequence IS NOT NULL
	BEGIN
	INSERT INTO @temp_dates (
		observation_date )
	SELECT result_date_time
	FROM p_Observation_Result
	WHERE cpr_id = @ps_cpr_id
	AND observation_id = @ps_observation_id
	AND result_sequence = @pi_result_sequence
	AND current_flag = 'Y'
	AND (@ll_encounter_id IS NULL OR encounter_id = @ll_encounter_id)
	AND (@ll_treatment_id IS NULL OR treatment_id = @ll_treatment_id)
	AND (@ll_observation_sequence IS NULL OR observation_sequence = @ll_observation_sequence)
	END
ELSE IF @ps_result_type IS NOT NULL
	BEGIN
	INSERT INTO @temp_dates (
		observation_date )
	SELECT result_date_time
	FROM p_Observation_Result
	WHERE cpr_id = @ps_cpr_id
	AND observation_id = @ps_observation_id
	AND result_type = @ps_result_type
	AND current_flag = 'Y'
	AND (@ll_encounter_id IS NULL OR encounter_id = @ll_encounter_id)
	AND (@ll_treatment_id IS NULL OR treatment_id = @ll_treatment_id)
	AND (@ll_observation_sequence IS NULL OR observation_sequence = @ll_observation_sequence)
	END
ELSE
	BEGIN
	INSERT INTO @temp_dates (
		observation_date )
	SELECT result_date_time
	FROM p_Observation_Result
	WHERE cpr_id = @ps_cpr_id
	AND observation_id = @ps_observation_id
	AND current_flag = 'Y'
	AND (@ll_encounter_id IS NULL OR encounter_id = @ll_encounter_id)
	AND (@ll_treatment_id IS NULL OR treatment_id = @ll_treatment_id)
	AND (@ll_observation_sequence IS NULL OR observation_sequence = @ll_observation_sequence)
	END

-- If we're not after results for the specified observation, then
-- get all the results from the first level children of the specified
-- observation
IF @pi_result_sequence IS NULL AND @ps_result_type IS NULL
	BEGIN
	DECLARE lc_children CURSOR LOCAL FAST_FORWARD FOR
		SELECT child_observation_id,
				result_sequence
		FROM c_Observation_Tree
		WHERE parent_observation_id = @ps_observation_id

	OPEN lc_children

	FETCH lc_children INTO @ls_child_observation_id, @li_child_result_sequence

	WHILE @@FETCH_STATUS = 0
		BEGIN
		INSERT INTO @temp_dates (
			observation_date)
		SELECT observation_date
		FROM dbo.fn_patient_observation_dates(@ps_cpr_id ,
												@ps_context_object ,
												@pl_object_key ,
												@ls_child_observation_id ,
												@li_child_result_sequence ,
												DEFAULT )
		

		FETCH lc_children INTO @ls_child_observation_id, @li_child_result_sequence
		END

	CLOSE lc_children
	DEALLOCATE lc_children

	END




INSERT INTO @patient_observation_dates (
	observation_date )
SELECT DISTINCT observation_date
FROM @temp_dates

RETURN
END

