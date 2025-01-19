
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_check_workplan_status]
Print 'Drop Procedure [dbo].[sp_check_workplan_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_check_workplan_status]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_check_workplan_status]
GO

-- Create Procedure [dbo].[sp_check_workplan_status]
Print 'Create Procedure [dbo].[sp_check_workplan_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_check_workplan_status
	(
	@pl_patient_workplan_id int,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24)
	)
AS
-- sp_check_workplan_status is called by sp_complete_workplan_item and sp_dispatch_workplan_step
-- when those procedures determine that there are no more "Step" items in the current step and
-- that there are no more steps to dispatch (not counting the "Final" step # 999)
--
-- This procedure is responsible for checking for the following conditions:
-- 	1)	The "Final" step is ready to dispatch
--	2)	The workplan is no longer an in-office workplan
--	3)	The workplan is completed
--	4)	The in-office encounter is completed
--
-- When the "Final" step gets dispatched depends on whether the workplan is an
-- in-office workplan or not.  For not-in-office workplans, the final step gets dispatched
-- when all "Step" items in all previous steps are completed.  For in-office workplans, the
-- final step gets dispatched when all in-office workplans associated with the encounter are
-- completed except for their final steps.  Note that a workplan may start out as an in-office
-- workplan and change into a not-in-office workplan.  For the purpose of dispatching the final
-- step of in-office workplans, any workplans which either started out not-in-office or
-- have become not-in-office are deemed completed.  Note also that if several in-office workplans
-- are progressing in parallel for the same encounter, then their final steps will all be dispatched
-- simultaneously when all other steps of all the in-office workplans are completed.
--
-- When all in-office items in all steps (including the final step) are completed, then if the workplan
-- still has remaining not-in-office items then the workplan will be changed into a not-in-office
-- workplan.
--
-- When all items for all steps (including the final step) of a workplan have been completed, then
-- the workplan is marked as completed.  Note that if any "required" item (cancel_workplan_flag = 'Y')
-- is ever cancelled, then the entire workplan is cancelled and any incomplete items are cancelled.
--
-- Once all in-office items in all steps for all in-office workplans (including their final steps)
-- are completed, then the associated encounter will be automatically closed.  Note that the workplans
-- themselves may not be completed.  They may still have not-in-office items pending.
--
-- 


DECLARE @ll_encounter_id int,
	@ll_treatment_id int,
	@ls_cpr_id varchar(12),
	@ls_in_office_flag char(1),
	@ls_workplan_status varchar(12),
	@ls_workplan_type varchar(12),
	@li_step_number smallint,
	@li_last_step_dispatched smallint,
	@li_count smallint,
	@ll_temp_patient_workplan_id int,
	@ll_encounter_patient_workplan_id int,
	@ls_encounter_status varchar(8),
	@li_in_count smallint,
	@li_not_in_count smallint,
	@ldt_discharge_date datetime,
	@ll_parent_patient_workplan_item_id int,
	@ll_doc_status int,
	@ls_temp varchar(255),
	@lb_default_grant bit

-- If this is the default workplan (0), then we don't need to check it
IF @pl_patient_workplan_id = 0
	RETURN

-- Get some info from the workplan table and take an update lock
SELECT @ls_cpr_id = cpr_id,
	@ll_encounter_id = encounter_id,
	@ll_treatment_id = treatment_id,
	@ls_in_office_flag = in_office_flag,
	@li_last_step_dispatched = last_step_dispatched,
	@ls_workplan_status = status,
	@ls_workplan_type = workplan_type,
	@ll_parent_patient_workplan_item_id = parent_patient_workplan_item_id
FROM p_Patient_WP (UPDLOCK)
WHERE patient_workplan_id = @pl_patient_workplan_id

IF @ls_workplan_type IS NULL
	BEGIN
	RAISERROR ('Workplan not found for item (%d)',16,-1, @pl_patient_workplan_id)
	ROLLBACK TRANSACTION
	RETURN
	END

-- Get some info from the encounter table and take an update lock
IF @ls_cpr_id IS NOT NULL AND @ll_encounter_id IS NOT NULL
	BEGIN
	SELECT @ll_encounter_patient_workplan_id = patient_workplan_id,
		@ls_encounter_status = encounter_status,
		@lb_default_grant = default_grant
	FROM p_Patient_Encounter (UPDLOCK)
	WHERE cpr_id = @ls_cpr_id
	AND encounter_id = @ll_encounter_id

	IF @lb_default_grant IS NULL
		BEGIN
		-- If the encounter doesn't exist then null out the foreign key
		UPDATE p_Patient_WP
		SET encounter_id = NULL
		WHERE patient_workplan_id = @pl_patient_workplan_id

		SET @ll_encounter_id = NULL
		END
	END

-- If this workplan is already completed or cancelled, then we don't need to check it again
IF @ls_workplan_status IN ('Completed', 'Cancelled')
	RETURN

-- Count the remaining in-office items
SELECT @li_in_count = count(*)
FROM p_Patient_WP_Item
WHERE patient_workplan_id = @pl_patient_workplan_id
AND in_office_flag = 'Y'
AND COALESCE(status, 'Pending') IN ('Pending', 'Dispatched', 'Started')

-- Count the remaining not-in-office items
SELECT @li_not_in_count = count(*)
FROM p_Patient_WP_Item
WHERE patient_workplan_id = @pl_patient_workplan_id
AND in_office_flag = 'N'
AND COALESCE(status, 'Pending') IN ('Pending', 'Dispatched', 'Started')

-- If there are no pending workplan items of any kind, then this workplan is done
IF @li_in_count = 0 AND @li_not_in_count = 0
	BEGIN
	SET @ls_workplan_status = 'Completed'

	EXECUTE sp_set_workplan_status
		@ps_cpr_id = @ls_cpr_id,
		@pl_encounter_id = @ll_encounter_id,
		@pl_treatment_id = @ll_treatment_id,
		@pl_patient_workplan_id = @pl_patient_workplan_id,
		@ps_progress_type = @ls_workplan_status,
		@ps_completed_by = @ps_user_id,
		@ps_created_by = @ps_created_by		
	END

-- If this is an in-office workplan then check to see if we should convert it to not-in-office
-- and/or dispatch the last step.
IF @ls_in_office_flag = 'Y'
	BEGIN
	-- First, if we don't have a valid encounter, then we have an error condition so cancel the workplan
	IF @ls_cpr_id IS NULL OR @ll_encounter_id IS NULL
		BEGIN
		SET @ls_workplan_status = 'xCancelled'

		EXECUTE sp_set_workplan_status
			@ps_cpr_id = @ls_cpr_id,
			@pl_encounter_id = @ll_encounter_id,
			@pl_treatment_id = @ll_treatment_id,
			@pl_patient_workplan_id = @pl_patient_workplan_id,
			@ps_progress_type = @ls_workplan_status,
			@ps_completed_by = @ps_user_id,
			@ps_created_by = @ps_created_by

		RETURN
		END

	-- If there are no in-office items remaining, then convert the workplan into a not-in-office workplan
	IF @li_in_count = 0 AND @ls_workplan_status NOT IN ('Completed', 'Cancelled')
		BEGIN
		SET @ls_in_office_flag = 'N'

		UPDATE p_Patient_WP
		SET in_office_flag = @ls_in_office_flag
		WHERE patient_workplan_id = @pl_patient_workplan_id
		
--		-- If there is an in-office workplan step waiting on this workplan to complete, go ahead and complete it
		IF @ll_parent_patient_workplan_item_id IS NOT NULL
			BEGIN
			IF EXISTS(SELECT in_office_flag 
						FROM p_Patient_WP_Item 
						WHERE patient_workplan_item_id = @ll_parent_patient_workplan_item_id
						AND in_office_flag = 'Y')
				BEGIN
				EXECUTE sp_complete_workplan_item
						@pl_patient_workplan_item_id = @ll_parent_patient_workplan_item_id,
						@ps_completed_by = @ps_user_id,
						@ps_created_by = @ps_created_by
				END
			END
		END
		
	-- If we haven't dispatched the last step yet,
	-- then check to see if we should dispatch the last step now
	IF @li_last_step_dispatched < 999
		BEGIN
		SELECT @li_count = count(*)
		FROM p_Patient_WP w WITH (NOLOCK)
			INNER LOOP JOIN p_Patient_WP_Item i WITH (NOLOCK)
			ON w.patient_workplan_id = i.patient_workplan_id
		WHERE w.cpr_id = @ls_cpr_id
		AND w.encounter_id = @ll_encounter_id
		AND i.in_office_flag = 'Y'
		AND COALESCE(i.step_number, 0) < 999
		AND COALESCE(i.status, 'Pending') IN ('Pending', 'Dispatched', 'Started')
		AND i.item_type = 'Service'

		-- If there are no more in-office services for the associated encounter, then
		-- dispatch the last step of all associated in-office workplans.  Note that
		-- if this workplan has been converted into a not-in-office workplan then
		-- it will not be included in the cursor select.
		IF @li_count = 0
			BEGIN
			DECLARE lc_in_office_wp CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
				SELECT patient_workplan_id
				FROM p_Patient_WP
				WHERE cpr_id = @ls_cpr_id
				AND encounter_id = @ll_encounter_id
				AND in_office_flag = 'Y'
				AND last_step_dispatched < 999
	
			OPEN lc_in_office_wp
	
			FETCH NEXT FROM lc_in_office_wp INTO @ll_temp_patient_workplan_id
	
			WHILE @@FETCH_STATUS = 0
				BEGIN
				EXECUTE sp_dispatch_workplan_step
					@ps_cpr_id = @ls_cpr_id,
					@pl_patient_workplan_id = @ll_temp_patient_workplan_id,
					@pi_step_number = 999,
					@ps_dispatched_by = @ps_user_id,
					@ps_created_by = @ps_created_by
	
				FETCH NEXT FROM lc_in_office_wp INTO @ll_temp_patient_workplan_id
				END
			END

		END
	
	END

-- If the associated encounter is still open, check to see if we should close it
IF @ls_encounter_status = 'OPEN' AND @li_in_count = 0
	BEGIN
	-- If there are no in-office items at all remaining for this workplan, then we might need
	-- to close the encounter.  To find out, count the number
	-- of remaining items for all in-office workplans associated with this encounter.
	SELECT @li_count = count(*)
	FROM p_Patient_WP w WITH (NOLOCK)
		INNER LOOP JOIN p_Patient_WP_Item i WITH (NOLOCK)
		ON w.patient_workplan_id = i.patient_workplan_id
	WHERE w.cpr_id = @ls_cpr_id
	AND w.encounter_id = @ll_encounter_id
	AND i.in_office_flag = 'Y'
	AND i.item_type = 'Service'
	AND COALESCE(i.status, 'Pending') IN ('Pending', 'Dispatched', 'Started')

	-- If there are no in-office items remaining for the entire encounter, then
	-- close the encounter
	IF @li_count = 0
		BEGIN
		SET @ls_temp = dbo.fn_get_preference('WORKFLOW', 'Auto Document Management Service', NULL, NULL)

		IF LEFT(@ls_temp, 1) IN ('T', 'Y')
			SET @ll_doc_status = dbo.fn_patient_object_document_status(@ls_cpr_id, 'Encounter', @ll_encounter_id)
		ELSE
			SET @ll_doc_status = 0

		IF @ll_doc_status = 2
			BEGIN
			SET @ls_temp = dbo.fn_get_preference('WORKFLOW', 'Auto Document Management Ordered For', NULL, NULL)
			SET @ls_temp = COALESCE(CAST(@ls_temp AS varchar(24)), '!CliniSupp')
			SET @ll_encounter_patient_workplan_id = COALESCE(@ll_encounter_patient_workplan_id, @pl_patient_workplan_id)

			EXECUTE sp_order_workplan_item	@ps_cpr_id = @ls_cpr_id,
											@pl_encounter_id = @ll_encounter_id,
											@pl_patient_workplan_id = @ll_encounter_patient_workplan_id,
											@ps_ordered_service = 'Manage Documents',
											@ps_in_office_flag = 'Y',
											@ps_auto_perform_flag = 'N',
											@ps_description = 'Manage Documents',
											@ps_ordered_by = @ps_created_by,
											@ps_ordered_for = @ls_temp,
											@ps_created_by = @ps_created_by
			END
		ELSE
			BEGIN
			INSERT INTO p_Patient_Encounter_Progress (
				cpr_id,
				encounter_id,
				user_id,
				progress_date_time,
				progress_type,
				created,
				created_by)
			VALUES (
				@ls_cpr_id,
				@ll_encounter_id,
				@ps_user_id,
				dbo.get_client_datetime(),
				'Closed',
				dbo.get_client_datetime(),
				@ps_created_by)
			END
		END
	END


-- If this workplan is still an in-office workplan, then either we found pending items,
-- or we dispatched the final step.  Either way we're done now.
IF @ls_in_office_flag = 'Y'
	RETURN


-- If we get to here then we must have a not-in-office workplan.  The only thing we have to worry about
-- is dispatching the final step.

-- If the workplan is already closed or we've already dispatched the final step then we're done
IF @ls_workplan_status IN ('Completed', 'Cancelled') OR @li_last_step_dispatched >= 999
	RETURN

-- Count how many pending items there are, not counting the final step
SELECT @li_count = count(*)
FROM p_Patient_WP_Item WITH (NOLOCK)
WHERE patient_workplan_id = @pl_patient_workplan_id
AND COALESCE(step_number, 0) < 999
AND COALESCE(status, 'Pending') IN ('Pending', 'Dispatched', 'Started')

-- If there are no pending items other than final step items, then dispatch the final step
IF @li_count = 0
	EXECUTE sp_dispatch_workplan_step
		@ps_cpr_id = @ls_cpr_id,
		@pl_patient_workplan_id = @pl_patient_workplan_id,
		@pi_step_number = 999,
		@ps_dispatched_by = @ps_user_id,
		@ps_created_by = @ps_created_by



GO
GRANT EXECUTE
	ON [dbo].[sp_check_workplan_status]
	TO [cprsystem]
GO

