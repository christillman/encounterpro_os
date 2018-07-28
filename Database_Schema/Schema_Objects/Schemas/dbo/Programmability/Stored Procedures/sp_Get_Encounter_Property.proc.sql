CREATE PROCEDURE sp_Get_Encounter_Property (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_progress_type varchar(24) = 'PROPERTY',
	@ps_progress_key varchar(40)
	)
AS

DECLARE @ll_encounter_progress_sequence int
	, @ls_progress varchar(2048)

SELECT @ll_encounter_progress_sequence = MAX(encounter_progress_sequence)
FROM p_Patient_Encounter_Progress
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND progress_type = @ps_progress_type
AND progress_key = @ps_progress_key

IF @ll_encounter_progress_sequence IS NULL
	SELECT @ls_progress = NULL
ELSE
	SELECT @ls_progress = COALESCE(progress_value, CONVERT(varchar(2048), progress))
	FROM p_Patient_Encounter_Progress
	WHERE cpr_id = @ps_cpr_id
	AND encounter_progress_sequence = @ll_encounter_progress_sequence

SELECT @ls_progress AS progress

