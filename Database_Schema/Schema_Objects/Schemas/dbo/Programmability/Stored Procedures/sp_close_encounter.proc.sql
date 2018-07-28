CREATE PROCEDURE sp_close_encounter
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24)
	)
AS
DECLARE @ll_patient_workplan_id int,
	@ls_encounter_status varchar(8)

DECLARE lc_open_wps INSENSITIVE CURSOR FOR
	SELECT patient_workplan_id
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND in_office_flag = 'Y'
	AND status = 'Current'

OPEN lc_open_wps 

FETCH lc_open_wps INTO @ll_patient_workplan_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE sp_set_workplan_status
		@ps_cpr_id = @ps_cpr_id,
		@pl_encounter_id = @pl_encounter_id,
		@pl_patient_workplan_id = @ll_patient_workplan_id,
		@ps_progress_type = 'Completed',
		@ps_completed_by = @ps_user_id,
		@ps_created_by = @ps_created_by		

	FETCH lc_open_wps INTO @ll_patient_workplan_id
	END

CLOSE lc_open_wps

DEALLOCATE lc_open_wps

-- If the encounter_status is still 'OPEN', then that means that none
-- of the encounter workplans closed the encounter when they were closed.  If
-- that's the case, then just close the encounter now.
SELECT @ls_encounter_status = encounter_status
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

IF @ls_encounter_status = 'OPEN'
	INSERT INTO p_Patient_Encounter_Progress (
		cpr_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		created,
		created_by)
	VALUES (
		@ps_cpr_id,
		@pl_encounter_id,
		@ps_user_id,
		getdate(),
		'Closed',
		getdate(),
		@ps_created_by)


