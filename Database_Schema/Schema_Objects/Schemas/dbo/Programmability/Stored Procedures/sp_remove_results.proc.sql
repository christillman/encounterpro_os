CREATE PROCEDURE sp_remove_results (
	@ps_cpr_id varchar(12),
	@pl_observation_sequence int,
	@ps_location varchar(24),
	@pi_result_sequence smallint,
	@pl_encounter_id integer,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24) )
AS

DECLARE @ll_child_observation_sequence int

-- First recursively call this stored procedure for each child observation
DECLARE lc_children CURSOR LOCAL FAST_FORWARD FOR
	SELECT observation_sequence
	FROM p_Observation
	WHERE cpr_id = @ps_cpr_id
	AND parent_observation_sequence = @pl_observation_sequence

OPEN lc_children

FETCH lc_children INTO @ll_child_observation_sequence
WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE sp_remove_results
		@ps_cpr_id = @ps_cpr_id,
		@pl_observation_sequence = @ll_child_observation_sequence,
		@ps_location = @ps_location,
		@pi_result_sequence = @pi_result_sequence,
		@pl_encounter_id = @pl_encounter_id,
		@ps_user_id = @ps_user_id,
		@ps_created_by =  @ps_created_by

	FETCH lc_children INTO @ll_child_observation_sequence
	END

-- Then "delete" then results and comments for this observation_sequence
INSERT INTO [dbo].[p_Observation_Result_Progress]
           ([cpr_id]
           ,[observation_sequence]
           ,[location_result_sequence]
           ,[encounter_id]
           ,[treatment_id]
           ,[user_id]
           ,[progress_date_time]
           ,[progress_type]
           ,[progress_key]
           ,[progress_value]
           ,[created_by])
SELECT cpr_id,
	observation_sequence,
	location_result_sequence,
	encounter_id,
	treatment_id,
	@ps_user_id,
	getdate(),
	'Modify',
	'current_flag',
	'N',
	@ps_created_by
FROM p_Observation_Result
WHERE cpr_id = @ps_cpr_id
AND observation_sequence = @pl_observation_sequence
AND current_flag = 'Y'
AND (@ps_location IS NULL OR @ps_location = location)
AND (@pi_result_sequence IS NULL OR @pi_result_sequence = result_sequence)


