CREATE PROCEDURE sp_set_workplan_status
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@pl_treatment_id int = NULL,
	@pl_patient_workplan_id int,
	@ps_progress_type varchar(24),
	@pdt_progress_date_time datetime = NULL,
	@ps_completed_by varchar(24) = NULL,
	@ps_owned_by varchar(24) = NULL,
	@ps_created_by varchar(24)
	)
AS

DECLARE @ll_patient_workplan_item_id int,
	@ll_parent_patient_workplan_item_id int,
	@ll_encounter_patient_workplan_id int,
	@ls_encounter_status varchar(12),
	@ls_treatment_status varchar(12),
	@ls_treatment_progress varchar(12),
	@ls_close_flag varchar(1),
	@ls_cancel_flag varchar(1),
	@ldt_discharge_date datetime,
	@ls_wp_item_status varchar(12)

-- Don't do anything if we don't have a patient_workplan_id
IF @pl_patient_workplan_id IS NULL OR @pl_patient_workplan_id = 0
	RETURN

-- If completed_by isn't specified, then use 'owned_by'
SET @ps_completed_by = COALESCE(@ps_completed_by, @ps_owned_by)
-- If neither completed_by or owned_by were specified, then use created_by
SET @ps_completed_by = COALESCE(@ps_completed_by, @ps_created_by)

SET @pdt_progress_date_time = COALESCE(@pdt_progress_date_time, getdate())

-- Update the status of patient workplan table and replace the encounter_id
-- if the current encounter_id is null.  If an owned_by value was passed in, then
-- apply it; otherwise leave the owned by as is.
UPDATE p_Patient_WP
SET status = @ps_progress_type,
	encounter_id = COALESCE(encounter_id, @pl_encounter_id),
	owned_by = COALESCE(@ps_owned_by, owned_by)
WHERE patient_workplan_id = @pl_patient_workplan_id

IF @@rowcount <> 1
	BEGIN
	RAISERROR ('No such workplan (%d)',16,-1, @pl_patient_workplan_id)
	ROLLBACK TRANSACTION
	RETURN
	END

-- If we're setting the status = 'Current' then set the workplan items which 
-- still have a null encounter_id to the workplan's encounter_id
IF @ps_progress_type = 'Current'
	UPDATE p_Patient_WP_Item
	SET encounter_id = p_Patient_WP.encounter_id
	FROM p_Patient_WP
	WHERE p_Patient_WP_Item.patient_workplan_id = p_Patient_WP.patient_workplan_id
	AND p_Patient_WP.patient_workplan_id = @pl_patient_workplan_id

-- If we're not completing or cancelling the workplan then we're done
IF @ps_progress_type NOT IN ('Completed', 'Cancelled')
	RETURN


-- Get the parent patient workplan item id & treatment id 
-- also get the patient encounter workplan id to decide whether to close encounter

SELECT @ll_parent_patient_workplan_item_id = pwp.parent_patient_workplan_item_id,
	@pl_treatment_id = pwp.treatment_id,
	@ll_encounter_patient_workplan_id = pe.patient_workplan_id,
	@ls_encounter_status = pe.encounter_status
FROM p_Patient_WP pwp
	LEFT OUTER JOIN p_Patient_Encounter pe
	ON 	pwp.cpr_id = pe.cpr_id
	AND	pwp.patient_workplan_id = pe.patient_workplan_id
WHERE pwp.patient_workplan_id = @pl_patient_workplan_id

SET @ls_wp_item_status = 'Cancelled'

-- Close/Cancel all the workplan items which are still pending
INSERT INTO p_Patient_WP_Item_Progress (
	cpr_id,
	patient_workplan_id,
	patient_workplan_item_id,
	encounter_id,
	user_id,
	progress_date_time,
	progress_type,
	created_by)
SELECT cpr_id,
	patient_workplan_id,
	patient_workplan_item_id,
	encounter_id,
	@ps_completed_by,
	@pdt_progress_date_time,
	@ls_wp_item_status,
	@ps_created_by
FROM p_Patient_WP_Item
WHERE patient_workplan_id = @pl_patient_workplan_id
AND (status NOT IN('COMPLETED', 'CANCELLED', 'Skipped') OR status IS NULL)


-- Update treatment status based on workplan close & cancel flag of treatment_type table
-- and Check the treatment status to avoid looping .  

SELECT @ls_treatment_status = t.treatment_status,
		@ls_close_flag = tt.workplan_close_flag,
		@ls_cancel_flag = tt.workplan_cancel_flag
FROM p_patient_wp wp
	INNER JOIN p_treatment_item t
	ON wp.cpr_id = t.cpr_id
	AND wp.treatment_id = t.treatment_id
	INNER JOIN c_Treatment_Type tt
	ON tt.treatment_type = t.treatment_type
WHERE wp.patient_workplan_id = @pl_patient_workplan_id

-- If there's a valid treatment record and auto workplan update is allowed then update treatment status
IF @@rowcount = 1 AND ((@ps_progress_type = 'COMPLETED' AND @ls_close_flag = 'Y') OR (@ps_progress_type = 'CANCELLED' AND @ls_cancel_flag = 'Y'))

BEGIN
	IF (@ls_treatment_status NOT IN('CLOSED','CANCELLED') OR @ls_treatment_status IS NULL )
		AND NOT EXISTS (SELECT 1
						FROM p_Patient_WP
						WHERE cpr_id = @ps_cpr_id
						AND treatment_id = @pl_treatment_id
						AND patient_workplan_id <> @pl_patient_workplan_id
						AND status = 'Current')
	BEGIN
		-- Send the treatment progress as 'CLOSED' when a workplan is completed

		IF @ps_progress_type = 'COMPLETED' 
			SET @ls_treatment_progress = 'CLOSED'
		ELSE
			SET @ls_treatment_progress = 'CANCELLED'

		EXECUTE sp_set_treatment_progress
			@ps_cpr_id = @ps_cpr_id,
			@pl_treatment_id = @pl_treatment_id,
			@pl_encounter_id = @pl_encounter_id,
			@ps_progress_type = @ls_treatment_progress,
			@ps_progress_key = NULL,
			@ps_progress = NULL,
			@pdt_progress_date_time = @pdt_progress_date_time,
			@ps_user_id = @ps_created_by,
			@ps_created_by = @ps_created_by 
	END
		
END

-- If this workplan is an item in another workplan, then set the status of that item
IF @ps_progress_type IN ('COMPLETED','CANCELLED') AND (@ll_parent_patient_workplan_item_id > 0)
	EXECUTE sp_complete_workplan_item
		@pl_patient_workplan_item_id = @ll_parent_patient_workplan_item_id,
		@ps_completed_by = @ps_completed_by,
		@ps_progress_type = @ps_progress_type,
		@pdt_progress_date_time = NULL,
		@ps_created_by = @ps_created_by


-- Call sp_check_workplan_status to see if any associated objects need to be changed
EXECUTE sp_check_workplan_status
	@pl_patient_workplan_id = @pl_patient_workplan_id,
	@ps_user_id = @ps_completed_by,
	@ps_created_by = @ps_created_by

