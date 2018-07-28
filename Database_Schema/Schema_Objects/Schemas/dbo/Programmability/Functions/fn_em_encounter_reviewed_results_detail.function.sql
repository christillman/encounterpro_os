CREATE FUNCTION fn_em_encounter_reviewed_results_detail (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer)

RETURNS @reviewed_results TABLE (
	treatment_id int NOT NULL,
	observation_sequence int NOT NULL,
	location_result_sequence int NOT NULL)

AS

BEGIN

DECLARE @ll_encounter_results int

DECLARE @reviewed_treatments TABLE (
	treatment_id int NOT NULL,
	progress_date_time datetime NOT NULL )


SET @ll_encounter_results = 0

-- Get a list of the distinct treatments which were reviewed by the encounter_owner.
-- Get the latest timestamp associated with each treatment
INSERT INTO @reviewed_treatments (
	treatment_id,
	progress_date_time )
SELECT t.treatment_id,
	max(t.progress_date_time) as progress_date_time
FROM p_Treatment_Progress t WITH (NOLOCK)
	INNER JOIN p_Patient_Encounter e WITH (NOLOCK)
	ON t.cpr_id = e.cpr_id
	AND t.encounter_id = e.encounter_id
	AND t.user_id = e.attending_doctor
WHERE t.cpr_id = @ps_cpr_id
AND t.encounter_id = @pl_encounter_id
AND progress_type = 'REVIEWED'
AND e.cpr_id = @ps_cpr_id
AND e.encounter_id = @pl_encounter_id
GROUP BY t.treatment_id

-- Get a list of the results which were created prior to the review date_time
INSERT INTO @reviewed_results (
	treatment_id,
	observation_sequence,
	location_result_sequence )
SELECT r.treatment_id,
	r.observation_sequence,
	r.location_result_sequence
FROM p_Observation_Result r WITH (NOLOCK)
	INNER JOIN @reviewed_treatments t
	ON r.cpr_id = @ps_cpr_id
	AND r.treatment_id = t.treatment_id
WHERE r.result_date_time <= t.progress_date_time
AND	r.current_flag = 'Y'

RETURN

END

