CREATE PROCEDURE sp_close_past_encounters (
	@ps_flag varchar(1),
	@pi_days int,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24))
AS

DECLARE @ls_cpr_id varchar(12),
	@ll_encounter_id int

IF @ps_flag = 'S' -- Encounters started
	DECLARE lc_open_encounters CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
		SELECT cpr_id,
			encounter_id
		FROM p_Patient_Encounter e
		WHERE encounter_status = 'OPEN'
		AND  encounter_date < dateadd(day, -@pi_days, getdate())
		AND EXISTS (
			SELECT e.patient_workplan_id
			FROM p_patient_wp_item
			WHERE step_number is not null
			AND patient_workplan_id = e.patient_workplan_id
			AND status = 'COMPLETED'
			)
IF @ps_flag = 'N' -- encounter not started and still in waiting room
	DECLARE lc_open_encounters CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
		SELECT cpr_id,
			encounter_id
		FROM p_Patient_Encounter e
			INNER JOIN o_Rooms r
			on e.patient_location = r.room_id
		WHERE encounter_status = 'OPEN'
		AND  encounter_date < dateadd(day, -@pi_days, getdate())
		AND r.room_type = '$WAITING'
		AND NOT EXISTS (
			SELECT e.patient_workplan_id
			FROM p_patient_wp_item
			WHERE step_number is not null
			AND patient_workplan_id = e.patient_workplan_id
			AND status = 'COMPLETED'
			)

OPEN lc_open_encounters

FETCH lc_open_encounters INTO
	@ls_cpr_id,
	@ll_encounter_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE sp_close_encounter
		@ps_cpr_id = @ls_cpr_id,
		@pl_encounter_id = @ll_encounter_id,
		@ps_user_id = @ps_user_id,
		@ps_created_by = @ps_created_by

	FETCH lc_open_encounters INTO
		@ls_cpr_id,
		@ll_encounter_id
	END

CLOSE lc_open_encounters

DEALLOCATE lc_open_encounters


