CREATE PROCEDURE jmj_uncancel_encounter
	(
	@ls_cpr_id varchar(12),
	@ll_encounter_id int
	)
AS

DECLARE @ls_progress_type varchar(24),
		@ls_progress_key varchar(40),
		@ls_progress varchar(255)
SET @ls_progress_key = NULL
SET @ls_progress = NULL
SET @ls_progress_type = 'Uncancelled'
	EXECUTE sp_Set_Encounter_Progress
		@ps_cpr_id = @ls_cpr_id,
		@pl_encounter_id = @ll_encounter_id,
		@ps_progress_type = @ls_progress_type,
		@ps_progress_key = @ls_progress_key,
		@ps_progress = @ls_progress,
		@ps_user_id = '#SYSTEM',
		@ps_created_by = '#SYSTEM'

