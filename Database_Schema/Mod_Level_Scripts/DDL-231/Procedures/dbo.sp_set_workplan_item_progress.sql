﻿
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_set_workplan_item_progress]
Print 'Drop Procedure [dbo].[sp_set_workplan_item_progress]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_set_workplan_item_progress]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_set_workplan_item_progress]
GO

-- Create Procedure [dbo].[sp_set_workplan_item_progress]
Print 'Create Procedure [dbo].[sp_set_workplan_item_progress]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_set_workplan_item_progress
	(
	@pl_patient_workplan_item_id int,
	@ps_user_id varchar(24),
	@ps_progress_type varchar(24),
	@pdt_progress_date_time datetime = NULL,
	@ps_created_by varchar(24),
	@pl_computer_id int = NULL
	)
AS

DECLARE @ll_encounter_id int,
	@ll_patient_workplan_id int,
	@ls_cpr_id varchar(12),
	@ls_cancel_workplan_flag varchar(1),
	@ll_treatment_id int,
	@ls_patient_wp_status varchar(12),
	@ls_workplan_status varchar(12),
	@li_step_number smallint,
	@li_next_step_number smallint,
	@li_count smallint,
	@ll_cons_patient_workplan_item_id int,
	@ls_wp_in_office_flag char(1),
	@li_last_step_dispatched smallint,
	@ls_workplan_type varchar(12)

-- Get some info from the workplan item table and take an update lock
SELECT  @ls_cpr_id = cpr_id,
	@ll_patient_workplan_id = patient_workplan_id,
	@li_step_number = step_number,
	@ls_cancel_workplan_flag = cancel_workplan_flag
FROM p_Patient_WP_Item (UPDLOCK)
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @ll_patient_workplan_id IS NULL
	BEGIN
	RAISERROR ('No such workplan item (%d)',16,-1, @pl_patient_workplan_item_id)
	ROLLBACK TRANSACTION
	RETURN
	END

-- Get some info from the workplan table and take an update lock
SELECT @ll_encounter_id = encounter_id,
	@ll_treatment_id = treatment_id,
	@ls_wp_in_office_flag = in_office_flag,
	@ls_patient_wp_status = status,
	@ls_workplan_type = workplan_type
FROM p_Patient_WP (UPDLOCK)
WHERE patient_workplan_id = @ll_patient_workplan_id

IF @ls_workplan_type IS NULL
	BEGIN
	RAISERROR ('Workplan not found for item (%d)',16,-1, @ll_patient_workplan_id)
	ROLLBACK TRANSACTION
	RETURN
	END

IF @pdt_progress_date_time IS NULL
	SET @pdt_progress_date_time = dbo.get_client_datetime()

INSERT INTO p_Patient_WP_Item_Progress (
	cpr_id,
	patient_workplan_id,
	patient_workplan_item_id,
	encounter_id,
	user_id,
	progress_date_time,
	progress_type,
	created_by,
	computer_id)
VALUES (
	@ls_cpr_id,
	@ll_patient_workplan_id,
	@pl_patient_workplan_item_id,
	@ll_encounter_id,
	@ps_user_id,
	@pdt_progress_date_time,
	@ps_progress_type,
	@ps_created_by,
	@pl_computer_id)

IF @@rowcount <> 1
BEGIN
RAISERROR ('Could not insert record into p_Patient_Wp_Item_Progress',16,-1)
ROLLBACK TRANSACTION
RETURN
END

-- If this is not a terminal state, then we're done
IF @ps_progress_type NOT IN ('COMPLETED', 'CANCELLED', 'SKIPPED', 'DOLATER')
	RETURN

-- If we're cancelling the workplan_item, see if it's supposed to cancel the workplan too
IF @ls_cancel_workplan_flag = 'Y'  and @ps_progress_type = 'CANCELLED' and @ls_patient_wp_status NOT IN ('COMPLETED','CANCELLED')
	EXECUTE sp_set_workplan_status
		@ps_cpr_id = @ls_cpr_id,
		@pl_encounter_id = @ll_encounter_id,
		@pl_treatment_id = @ll_treatment_id,
		@pl_patient_workplan_id = @ll_patient_workplan_id,
		@ps_progress_type = @ps_progress_type,
		@pdt_progress_date_time = @pdt_progress_date_time,
		@ps_created_by = @ps_created_by

-- Now, check to see if any other workplan items were consolidated into this one
-- and, if so, complete them too
DECLARE lc_cons_items CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
	SELECT patient_workplan_item_id
	FROM p_Patient_WP_Item
	WHERE dispatched_patient_workplan_item_id = @pl_patient_workplan_item_id
	AND status = 'CONSOLIDATED'

OPEN lc_cons_items

FETCH NEXT FROM lc_cons_items INTO @ll_cons_patient_workplan_item_id
WHILE @@fetch_status = 0
	BEGIN
	EXECUTE sp_set_workplan_item_progress
		@pl_patient_workplan_item_id = @ll_cons_patient_workplan_item_id,
		@ps_user_id = @ps_user_id,
		@ps_progress_type = @ps_progress_type,
		@pdt_progress_date_time = @pdt_progress_date_time,
		@ps_created_by = @ps_created_by

	FETCH NEXT FROM lc_cons_items INTO @ll_cons_patient_workplan_item_id
	END

CLOSE lc_cons_items
DEALLOCATE lc_cons_items

-- Check the status of workplan
SELECT @ls_workplan_status = status
FROM p_Patient_WP
WHERE patient_workplan_id = @ll_patient_workplan_id
IF @ls_workplan_status IS NULL
	BEGIN
	RAISERROR ('Workplan (%d) Status not set',16,-1, @ll_patient_workplan_id)
	ROLLBACK TRANSACTION
	RETURN
	END

-- If the workplan is still pending then we're done
IF @ls_workplan_status = 'Pending' OR @ll_patient_workplan_id = 0
	RETURN

-- If the step number is positive, then we need to see if we should automatically
-- dispatch the next step
IF @li_step_number > 0 and @ll_patient_workplan_id > 0
	BEGIN
	-- First get the last_step_dispatched for this workplan
	SELECT @li_last_step_dispatched = last_step_dispatched
	FROM p_Patient_WP
	WHERE patient_workplan_id = @ll_patient_workplan_id
	
	-- We only need to dispatch another step if the last_step_dispatched is positive
	IF @li_last_step_dispatched > 0
		BEGIN
		-- Count the number of dispatched but not completed items left in this step
		SELECT @li_count = count(*)
		FROM p_Patient_WP_Item
		WHERE cpr_id = @ls_cpr_id
		AND patient_workplan_id = @ll_patient_workplan_id
		AND status IN ('DISPATCHED', 'STARTED')
		AND step_number = @li_step_number
		AND step_flag = 'Y'

		-- If there are no more incomplete service items in this step, then dispatch the next step
		IF @li_count = 0
			BEGIN
			-- Find out what the next step number is (not counting the "Final Step" # 999)
			SELECT @li_next_step_number = min(step_number)
			FROM p_Patient_WP_Item
			WHERE patient_workplan_id = @ll_patient_workplan_id
			AND step_number > @li_step_number
			AND step_number < 999

			IF @li_next_step_number > 0
				BEGIN
				-- See if the next step has been dispatched yet
				SELECT @li_count = count(*)
				FROM p_Patient_WP_Item
				WHERE patient_workplan_id = @ll_patient_workplan_id
				AND step_number = @li_next_step_number
				AND status IS NOT NULL

				-- If the next step has not been dispatched yet, then dispatch it
				IF @li_count = 0
					EXECUTE sp_dispatch_workplan_step
						@ps_cpr_id = @ls_cpr_id,
						@pl_patient_workplan_id = @ll_patient_workplan_id,
						@pi_step_number = @li_next_step_number,
						@ps_dispatched_by = @ps_user_id,
						@ps_created_by = @ps_created_by
				END
			END
		END
	END
	
EXECUTE sp_check_workplan_status
	@pl_patient_workplan_id = @ll_patient_workplan_id,
	@ps_user_id = @ps_user_id,
	@ps_created_by = @ps_created_by
GO
GRANT EXECUTE
	ON [dbo].[sp_set_workplan_item_progress]
	TO [cprsystem]
GO

