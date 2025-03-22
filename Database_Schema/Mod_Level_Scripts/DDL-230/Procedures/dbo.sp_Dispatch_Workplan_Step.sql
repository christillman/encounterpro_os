
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Dispatch_Workplan_Step]
Print 'Drop Procedure [dbo].[sp_Dispatch_Workplan_Step]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Dispatch_Workplan_Step]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Dispatch_Workplan_Step]
GO

-- Create Procedure [dbo].[sp_Dispatch_Workplan_Step]
Print 'Create Procedure [dbo].[sp_Dispatch_Workplan_Step]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_Dispatch_Workplan_Step
	(
	@ps_cpr_id varchar(12) = NULL,
	@pl_patient_workplan_id int,
	@pi_step_number smallint,
	@ps_dispatched_by varchar(24),
	@pl_encounter_id int = NULL,
	@ps_created_by varchar(24)
	)
AS

DECLARE @ll_encounter_id int,
	@ll_patient_workplan_item_id int,
	@li_next_step_number smallint,
	@li_count smallint,
	@ls_item_type varchar(12),
	@ldt_progress_date_time datetime,
	@ll_this_workplan_id int,
	@ls_this_workplan_type varchar(12),
	@ls_this_in_office_flag char(1),
	@ls_ordered_in_office_flag char(1),
	@ll_item_number int,
	@ls_workplan_type varchar(12),
	@ls_room_id varchar(24),
	@ls_room_type varchar(24),
	@ll_age_range_id int,
	@ls_new_flag char(1),
	@ls_sex char(1),
	@ls_workplan_owner varchar(24),
	@ls_this_new_flag char(1),
	@ls_this_sex char(1),
	@ls_this_workplan_owner varchar(24),
	@ls_skip char(1),
	@ll_ordered_workplan_id int,
	@ls_ordered_workplan_type varchar(12),
	@ll_treatment_id int,
	@ls_description varchar(80),
	@ls_office_id varchar(4),
	@ll_new_patient_workplan_id int,
	@ls_mode varchar(32),
	@ls_modes varchar(255),
	@li_found smallint,
	@li_temp_item_number smallint,
	@ls_ordered_treatment_type varchar(24),
	@ll_step_delay int,
	@ls_step_delay_unit varchar(24),
	@ls_delay_from_flag char(1),
	@li_last_step_dispatched smallint,
	@ldt_last_step_date datetime,
	@ldt_workplan_date datetime,
	@ldt_start_date datetime,
	@ll_event_id int,
	@ls_temp varchar(40),
	@ll_escalation_time int,
	@ls_escalation_unit_id varchar(24),
	@ll_expiration_time int,
	@ls_expiration_unit_id varchar(24),
	@ldt_escalation_date datetime,
	@ldt_expiration_date datetime,
	@ls_ordered_for varchar(24),
	@ls_consolidate_flag char(1),
	@ll_dispatched_patient_workplan_item_id int,
	@ls_in_office_flag char(1),
	@ls_abnormal_flag char(1),
	@li_severity smallint,
	@ll_workplan_treatment_id int,
	@lb_mutually_exclusive_items bit,
	@ls_payer_authority_id varchar(24),
	@ls_payer_authority_category varchar(24),
	@ls_item_authority_id varchar(24),
	@ls_item_authority_category varchar(24)

WHILE @pi_step_number > 0
	BEGIN
	SET @ldt_progress_date_time = dbo.get_client_datetime()

	-- Get some info from the workplan table
	SELECT @ps_cpr_id = COALESCE(cpr_id, @ps_cpr_id),
		@ll_encounter_id = COALESCE(encounter_id, @pl_encounter_id),
		@ls_this_workplan_type = workplan_type,
		@ls_this_in_office_flag = in_office_flag,
		@ll_this_workplan_id = workplan_id,
		@ls_this_workplan_owner = owned_by,
		@ls_mode = mode,
		@li_last_step_dispatched = last_step_dispatched,
		@ldt_last_step_date = last_step_date,
		@ldt_workplan_date = created,
		@ls_in_office_flag = COALESCE(in_office_flag, 'N'),
		@ll_workplan_treatment_id = treatment_id
	FROM p_Patient_WP (UPDLOCK)
	WHERE patient_workplan_id = @pl_patient_workplan_id

	IF @ll_this_workplan_id IS NULL
		BEGIN
		RAISERROR ('Workplan not found (%s, %d)',16,-1, @ps_cpr_id, @pl_patient_workplan_id)
		ROLLBACK TRANSACTION
		RETURN
		END

	-- Make sure we have a "this" encounter_id
	SET @pl_encounter_id = COALESCE(@pl_encounter_id, @ll_encounter_id)


	-- Get the office_id and take an update lock on the encounter table
	SELECT @ls_office_id = office_id
	FROM p_Patient_Encounter (UPDLOCK)
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @ll_encounter_id

	IF @ls_office_id IS NULL
		SELECT @ls_office_id = office_id
		FROM o_Office

	-- Update the workplan status, sending the new encounter_id if it's not null
	EXECUTE sp_set_workplan_status
		@ps_cpr_id = @ps_cpr_id,
		@pl_encounter_id = @pl_encounter_id,
		@pl_patient_workplan_id = @pl_patient_workplan_id,
		@ps_progress_type = 'Current',
		@pdt_progress_date_time = @ldt_progress_date_time,
		@ps_created_by = @ps_created_by

	-- Update the workplan record to indicate what step we're dispatching.  Use a negative
	-- number to indicate that we're in a dispatch loop so other procs don't need to
	-- dispatch subsequent steps
	UPDATE p_Patient_WP
	SET last_step_dispatched = -@pi_step_number
	WHERE patient_workplan_id = @pl_patient_workplan_id

	IF @@rowcount <> 1
		BEGIN
		RAISERROR ('Error Updating Workplan (%s, %d)',16,-1, @ps_cpr_id, @pl_patient_workplan_id)
		ROLLBACK TRANSACTION
		RETURN
		END


	SELECT @ls_room_type = room_type,
		@ll_step_delay = step_delay,
		@ls_step_delay_unit = step_delay_unit,
		@ls_delay_from_flag = delay_from_flag,
		@lb_mutually_exclusive_items = mutually_exclusive_items
	FROM c_Workplan_Step
	WHERE workplan_id = @ll_this_workplan_id
	AND step_number = @pi_step_number

	IF @lb_mutually_exclusive_items IS NULL
		SET @ls_room_type = NULL
		SET @ll_step_delay = NULL
		SET @ls_step_delay_unit = NULL
		SET @ls_delay_from_flag = NULL


	-- Get the new room from the c_Workplan_Step table
	SELECT @ls_room_id = room_id
	FROM c_Workplan_Step_Room
	WHERE workplan_id = @ll_this_workplan_id
	AND step_number = @pi_step_number
	AND office_id = @ls_office_id

	IF @ls_room_id IS NULL
		SET @ls_room_id = @ls_room_type


	-- Now, if this is not an in_office workplan, decide if we should even dispatch this step now
	IF @ls_this_in_office_flag = 'N'
		BEGIN
		IF @ll_step_delay IS NOT NULL AND @ls_step_delay_unit IS NOT NULL AND @ls_delay_from_flag IS NOT NULL
			BEGIN
			-- First, find out what the from time is

			-- If the flag is 'Start of Step' then set the workplan date variable to the step date
			IF @ls_delay_from_flag = 'S'
				SET @ldt_workplan_date = @ldt_last_step_date

			SET @ldt_start_date = CASE @ls_step_delay_unit
				WHEN 'YEAR' THEN dateadd(year, @ll_step_delay, @ldt_workplan_date)
				WHEN 'MONTH' THEN dateadd(month, @ll_step_delay, @ldt_workplan_date)
				WHEN 'DAY' THEN dateadd(day, @ll_step_delay, @ldt_workplan_date)
				WHEN 'HOUR' THEN dateadd(hour, @ll_step_delay, @ldt_workplan_date)
				WHEN 'MINUTE' THEN dateadd(minute, @ll_step_delay, @ldt_workplan_date)
				END
		
			IF @ldt_start_date > dbo.get_client_datetime()
				BEGIN
				-- We can't start the step yet, so queue an event to start it later
				EXECUTE sp_queue_event
						@ps_event = 'DISPATCH_WORKPLAN_STEP',
						@pdt_start_date = @ldt_start_date,
						@pl_event_id = @ll_event_id OUTPUT
				EXECUTE sp_queue_event_set_attribute
						@pl_event_id = @ll_event_id,
						@ps_attribute = 'CPR_ID',
						@ps_value = @ps_cpr_id
				SET @ls_temp = convert(varchar(40), @pl_patient_workplan_id)
				EXECUTE sp_queue_event_set_attribute
						@pl_event_id = @ll_event_id,
						@ps_attribute = 'PATIENT_WORKPLAN_ID',
						@ps_value = @ls_temp
				SET @ls_temp = convert(varchar(40), @pi_step_number)
				EXECUTE sp_queue_event_set_attribute
						@pl_event_id = @ll_event_id,
						@ps_attribute = 'STEP_NUMBER',
						@ps_value = @ls_temp
				EXECUTE sp_queue_event_set_ready
						@pl_event_id = @ll_event_id
		
				RETURN
				END		
		
			END
		END

	-- Get the patient's sex
	SELECT @ls_this_sex = sex
	FROM p_Patient
	WHERE cpr_id = @ps_cpr_id

	-- Get the patient's payer info
	SELECT @ls_payer_authority_id = pa.authority_id,
		@ls_payer_authority_category = a.authority_category
	FROM p_Patient_Authority pa
		INNER JOIN c_Authority a
		ON pa.authority_id = a.authority_id
	WHERE pa.cpr_id = @ps_cpr_id
	AND pa.authority_type = 'PAYOR'
	AND pa.authority_sequence = 1
	
	-- Get the new_flag
	SELECT @ls_this_new_flag = new_flag
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @ll_encounter_id

	-- Create temp table 
	DECLARE @treatments_and_workplans TABLE  
	(	patient_workplan_id int NOT NULL,
		step_number smallint NOT NULL,
		cpr_id varchar(12) NULL,
		temp_item_number int NOT NULL,
		item_type varchar(12) NULL,
		patient_workplan_item_id int NULL,
		ordered_treatment_type varchar(24) NULL,
		ordered_workplan_id int NULL,
		description varchar(80) NULL,
		dispatch_time datetime NULL,
		ordered_for varchar(24) NULL
	)

	-- Initialize temp counter
	SET @li_temp_item_number = 0

	DECLARE lc_next_item CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
		SELECT patient_workplan_item_id,
			item_type,
			item_number,
			ordered_for,
			description,
			consolidate_flag
		FROM p_Patient_WP_Item
		WHERE patient_workplan_id = @pl_patient_workplan_id
		AND status IS NULL
		AND step_number = @pi_step_number

	OPEN lc_next_item

	FETCH NEXT FROM lc_next_item INTO @ll_patient_workplan_item_id, @ls_item_type, @ll_item_number, @ls_ordered_for, @ls_description, @ls_consolidate_flag
	WHILE (@@fetch_status<>-1)
		BEGIN
		SET @ls_skip = 'N'
		SET @ldt_escalation_date = NULL
		SET @ldt_expiration_date = NULL

		-- Make sure this item meets the specified criteria, if any
		SELECT @ll_age_range_id = age_range_id,
			@ls_sex = sex,
			@ls_new_flag = new_flag,
			@ls_workplan_owner = workplan_owner,
			@ls_modes = modes,
			@ll_escalation_time = escalation_time,
			@ls_escalation_unit_id = escalation_unit_id,
			@ll_expiration_time = expiration_time,
			@ls_expiration_unit_id = expiration_unit_id,
			@ls_abnormal_flag = abnormal_flag,
			@li_severity = severity
			-- Remove [authority_id] and [authority_category] columns which were added in the 6.1.1 design but excluded in releases 
			-- and from further development in the open source version (because the change wasn't complete).
			-- @ls_item_authority_id = authority_id,
			-- @ls_item_authority_category = authority_category
		FROM c_Workplan_Item
		WHERE workplan_id = @ll_this_workplan_id
		AND item_number = @ll_item_number

		IF @@ROWCOUNT = 1
			BEGIN
			IF @ll_age_range_id IS NOT NULL
				IF NOT EXISTS(SELECT cpr_id
						FROM v_Patient_Age_Ranges
						WHERE cpr_id = @ps_cpr_id
						AND age_range_id = @ll_age_range_id)
					SET @ls_skip = 'Y'
					
			IF @ls_sex IS NOT NULL and @ls_sex <> @ls_this_sex
				SET @ls_skip = 'Y'
				
			IF @ls_new_flag IS NOT NULL and @ls_new_flag <> @ls_this_new_flag
				SET @ls_skip = 'Y'
				
			IF @ls_workplan_owner IS NOT NULL
				BEGIN
				IF @ls_workplan_owner <> @ls_this_workplan_owner AND @ls_this_workplan_owner NOT IN (SELECT [user_id] FROM c_User_Role WHERE role_id = @ls_workplan_owner)
					SET @ls_skip = 'Y'
				END
				
			IF @ls_modes IS NOT NULL
				BEGIN
				SET @li_found = charindex(@ls_mode,  @ls_modes)
				IF @li_found IS NULL OR @li_found <= 0
					SET @ls_skip = 'Y'
				END

			IF @ls_escalation_unit_id IS NOT NULL AND @ll_escalation_time IS NOT NULL
				SET @ldt_escalation_date = CASE @ls_escalation_unit_id
					WHEN 'YEAR' THEN dateadd(year, @ll_escalation_time, @ldt_progress_date_time)
					WHEN 'MONTH' THEN dateadd(month,@ll_escalation_time, @ldt_progress_date_time)
					WHEN 'DAY' THEN dateadd(day, @ll_escalation_time, @ldt_progress_date_time)
					WHEN 'HOUR' THEN dateadd(hour, @ll_escalation_time, @ldt_progress_date_time)
					WHEN 'MINUTE' THEN dateadd(minute, @ll_escalation_time, @ldt_progress_date_time)
					END

			IF @ls_expiration_unit_id IS NOT NULL AND @ll_expiration_time IS NOT NULL
				SET @ldt_expiration_date = CASE @ls_expiration_unit_id
					WHEN 'YEAR' THEN dateadd(year, @ll_expiration_time, @ldt_progress_date_time)
					WHEN 'MONTH' THEN dateadd(month, @ll_expiration_time, @ldt_progress_date_time)
					WHEN 'DAY' THEN dateadd(day, @ll_expiration_time, @ldt_progress_date_time)
					WHEN 'HOUR' THEN dateadd(hour, @ll_expiration_time, @ldt_progress_date_time)
					WHEN 'MINUTE' THEN dateadd(minute, @ll_expiration_time, @ldt_progress_date_time)
					END

			-- Earlier versions of encounterpro automatically set the abnormal_flag to 'N'
			-- Now that we're turning on support for this criteria, we want the default state
			-- to be Null which means <Any>.  To prevent unintentional skipping, we're using
			-- a domain of '0', '1' for the c_Workplan_Item.abnormal_flag field meaning
			-- "No abnormal results present" and "Abnormal results present" respectively.
			IF @ls_abnormal_flag IN ('0', '1') AND @ll_workplan_treatment_id IS NOT NULL
				-- If the workplan_item calls for an abnormal result, then skip if there isn't one
				BEGIN
				IF @ls_abnormal_flag = '0'
					BEGIN
					IF EXISTS (SELECT observation_sequence
								FROM p_Observation
								WHERE cpr_id = @ps_cpr_id
								AND treatment_id = @ll_workplan_treatment_id
								AND parent_observation_sequence IS NULL
								AND abnormal_flag = 'Y')
						BEGIN
						SET @ls_skip = 'Y'
						END
					END
				ELSE
					BEGIN
					-- abnormal_flag = '1'
					IF NOT EXISTS (SELECT observation_sequence
									FROM p_Observation
									WHERE cpr_id = @ps_cpr_id
									AND treatment_id = @ll_workplan_treatment_id
									AND parent_observation_sequence IS NULL
									AND abnormal_flag = 'Y')
						BEGIN
						SET @ls_skip = 'Y'
						END
					END
				END
			IF @li_severity IS NOT NULL AND @ll_workplan_treatment_id IS NOT NULL
					-- If severity is specified, then only skip if there's no actual severity
					-- greater than or equal to the specified severity 
					BEGIN
					IF NOT EXISTS (SELECT observation_sequence
							FROM p_Observation
							WHERE cpr_id = @ps_cpr_id
							AND treatment_id = @ll_workplan_treatment_id
							AND parent_observation_sequence IS NULL
							AND severity >= @li_severity)
						BEGIN
						SET @ls_skip = 'Y'
						END
					END
			END
		-- If item is not flagged to be skipped, then order it
		IF @ls_skip = 'N'
			BEGIN
			IF @ls_item_type = 'Service'
				BEGIN
				IF @ldt_escalation_date IS NOT NULL
					INSERT INTO p_Patient_WP_Item_Progress (
						cpr_id,
						patient_workplan_id,
						patient_workplan_item_id,
						encounter_id,
						user_id,
						progress_date_time,
						progress_type,
						created_by)
					VALUES (
						@ps_cpr_id,
						@pl_patient_workplan_id,
						@ll_patient_workplan_item_id,
						@ll_encounter_id,
						@ps_dispatched_by,
						@ldt_escalation_date,
						'ESCALATE',
						@ps_created_by)

				IF @ldt_expiration_date IS NOT NULL
					INSERT INTO p_Patient_WP_Item_Progress (
						cpr_id,
						patient_workplan_id,
						patient_workplan_item_id,
						encounter_id,
						user_id,
						progress_date_time,
						progress_type,
						created_by)
					VALUES (
						@ps_cpr_id,
						@pl_patient_workplan_id,
						@ll_patient_workplan_item_id,
						@ll_encounter_id,
						@ps_dispatched_by,
						@ldt_expiration_date,
						'EXPIRE',
						@ps_created_by)

				-- If the consolidate flag is 'Y' then we should not dispatch this workplan item
				-- if a similar one has already been dispatched.  Instead, link this workplan
				-- item to the existing one and update the status to 'CONSOLIDATED'
				IF @ls_consolidate_flag = 'Y'
					SELECT @ll_dispatched_patient_workplan_item_id = min(c.patient_workplan_item_id)
					FROM p_Patient_WP_Item t
					JOIN p_Patient_WP_Item c 
						ON c.cpr_id = t.cpr_id
						AND c.encounter_id = t.encounter_id
						AND c.item_type = t.item_type
						AND c.ordered_service = t.ordered_service
						AND c.ordered_for = t.ordered_for
					WHERE t.patient_workplan_item_id = @ll_patient_workplan_item_id
					AND c.consolidate_flag = 'Y'
					AND c.status = 'DISPATCHED'
				ELSE
					SET @ll_dispatched_patient_workplan_item_id = NULL

				IF @ll_dispatched_patient_workplan_item_id IS NULL
					INSERT INTO p_Patient_WP_Item_Progress (
						cpr_id,
						patient_workplan_id,
						patient_workplan_item_id,
						encounter_id,
						user_id,
						progress_date_time,
						progress_type,
						created_by)
					VALUES (
						@ps_cpr_id,
						@pl_patient_workplan_id,
						@ll_patient_workplan_item_id,
						@ll_encounter_id,
						@ps_dispatched_by,
						@ldt_progress_date_time,
						'DISPATCHED',
						@ps_created_by)
				ELSE
					BEGIN
					INSERT INTO p_Patient_WP_Item_Progress (
						cpr_id,
						patient_workplan_id,
						patient_workplan_item_id,
						encounter_id,
						user_id,
						progress_date_time,
						progress_type,
						created_by)
					VALUES (
						@ps_cpr_id,
						@pl_patient_workplan_id,
						@ll_patient_workplan_item_id,
						@ll_encounter_id,
						@ps_dispatched_by,
						@ldt_progress_date_time,
						'CONSOLIDATED',
						@ps_created_by)

					UPDATE p_Patient_WP_Item
					SET dispatched_patient_workplan_item_id = @ll_dispatched_patient_workplan_item_id
					WHERE patient_workplan_item_id = @ll_patient_workplan_item_id
					END
				END
			ELSE
				-- Treatment or Workplan items
				BEGIN
				IF @ls_item_type = 'Treatment'
					SELECT @ls_ordered_treatment_type = ordered_treatment_type,
						@ls_ordered_in_office_flag = in_office_flag,
						@ls_ordered_workplan_type = 'Treatment',
						@ll_treatment_id = NULL
					FROM p_Patient_WP_Item
					WHERE p_Patient_WP_Item.patient_workplan_item_id = @ll_patient_workplan_item_id
				ELSE IF @ls_item_type = 'Workplan'
					SELECT @ll_ordered_workplan_id = c_Workplan.workplan_id,
						@ls_ordered_in_office_flag = c_Workplan.in_office_flag,
						@ls_ordered_workplan_type = c_Workplan.workplan_type,
						@ll_treatment_id = NULL
					FROM c_Workplan
					JOIN p_Patient_WP_Item ON p_Patient_WP_Item.ordered_workplan_id = c_Workplan.workplan_id
					WHERE p_Patient_WP_Item.patient_workplan_item_id = @ll_patient_workplan_item_id
		
				-- Dispatch the workplan if there's not an in_office_flag mismatch
				IF @ls_ordered_in_office_flag <> 'Y' OR @ls_this_in_office_flag = 'Y'
					BEGIN
					IF @ls_consolidate_flag = 'Y'
						BEGIN
						IF @ls_item_type = 'Treatment'
							SELECT @ll_dispatched_patient_workplan_item_id = min(c.patient_workplan_item_id)
							FROM p_Patient_WP_Item t
							JOIN p_Patient_WP_Item c 
								ON c.cpr_id = t.cpr_id
								AND c.encounter_id = t.encounter_id
								AND c.item_type = t.item_type
								AND c.ordered_treatment_type = t.ordered_treatment_type
								AND c.ordered_for = t.ordered_for
							WHERE t.patient_workplan_item_id = @ll_patient_workplan_item_id
							AND c.status = 'DISPATCHED'
						ELSE
							SELECT @ll_dispatched_patient_workplan_item_id = min(c.patient_workplan_item_id)
							FROM p_Patient_WP_Item t
							JOIN p_Patient_WP_Item c 
								ON c.cpr_id = t.cpr_id
								AND c.encounter_id = t.encounter_id
								AND c.item_type = t.item_type
								AND c.ordered_workplan_id = t.ordered_workplan_id
								AND c.ordered_for = t.ordered_for
							WHERE t.patient_workplan_item_id = @ll_patient_workplan_item_id
							AND c.status = 'DISPATCHED'
						END
					ELSE
						SET @ll_dispatched_patient_workplan_item_id = NULL

					IF @ll_dispatched_patient_workplan_item_id IS NULL
						BEGIN
						-- Log item as dispatched
						INSERT INTO p_Patient_WP_Item_Progress (
							cpr_id,
							patient_workplan_id,
							patient_workplan_item_id,
							encounter_id,
							user_id,
							progress_date_time,
							progress_type,
							created_by)
						VALUES (
							@ps_cpr_id,
							@pl_patient_workplan_id,
							@ll_patient_workplan_item_id,
							@ll_encounter_id,
							@ps_dispatched_by,
							@ldt_progress_date_time,
							'DISPATCHED',
							@ps_created_by)
		
						-- Since we can't call this procedure recursively from within a cursor, save the
						-- values in a temp table and call the stored procedures after the cursor is deallocated
						SET @li_temp_item_number = @li_temp_item_number + 1
		
						INSERT INTO @treatments_and_workplans (
							patient_workplan_id,
							step_number,
							cpr_id,
							temp_item_number,
							item_type,
							patient_workplan_item_id,
							ordered_treatment_type,
							ordered_workplan_id,
							description,
							ordered_for,
							dispatch_time)
						VALUES (
							@pl_patient_workplan_id,
							@pi_step_number,
							@ps_cpr_id,
							@li_temp_item_number,
							@ls_item_type,
							@ll_patient_workplan_item_id,
							@ls_ordered_treatment_type,
							@ll_ordered_workplan_id,
							@ls_description,
							@ls_ordered_for,
							dbo.get_client_datetime() )
						END
					ELSE
						BEGIN
						-- Log item as consolidated
						INSERT INTO p_Patient_WP_Item_Progress (
							cpr_id,
							patient_workplan_id,
							patient_workplan_item_id,
							encounter_id,
							user_id,
							progress_date_time,
							progress_type,
							created_by)
						VALUES (
							@ps_cpr_id,
							@pl_patient_workplan_id,
							@ll_patient_workplan_item_id,
							@ll_encounter_id,
							@ps_dispatched_by,
							@ldt_progress_date_time,
							'CONSOLIDATED',
							@ps_created_by)

						-- Update foreign key to consolidated workplan item
						UPDATE p_Patient_WP_Item
						SET dispatched_patient_workplan_item_id = @ll_dispatched_patient_workplan_item_id
						WHERE patient_workplan_item_id = @ll_patient_workplan_item_id
						END
					END
				END
				-- If the mutually exclusive flag is set then exit this loop as soon as a single workplan item is not skipped
				IF @lb_mutually_exclusive_items = 1
					BREAK
			END -- If not skipped
		ELSE
			-- Log item as skipped
			INSERT INTO p_Patient_WP_Item_Progress (
				cpr_id,
				patient_workplan_id,
				patient_workplan_item_id,
				encounter_id,
				user_id,
				progress_date_time,
				progress_type,
				created_by)
			VALUES (
				@ps_cpr_id,
				@pl_patient_workplan_id,
				@ll_patient_workplan_item_id,
				@ll_encounter_id,
				@ps_dispatched_by,
				@ldt_progress_date_time,
				'SKIPPED',
				@ps_created_by)
			
		
		FETCH NEXT FROM lc_next_item INTO @ll_patient_workplan_item_id, @ls_item_type, @ll_item_number, @ls_ordered_for, @ls_description, @ls_consolidate_flag
		END

	DEALLOCATE lc_next_item

	-- Now order the treatments and workplans
	SET @li_count = 1

	WHILE @li_count <= @li_temp_item_number
		BEGIN
		SELECT 	@ls_item_type = item_type,
				@ll_patient_workplan_item_id = patient_workplan_item_id,
				@ls_ordered_treatment_type = ordered_treatment_type,
				@ll_ordered_workplan_id = ordered_workplan_id,
				@ls_description = description,
				@ls_ordered_for = ordered_for
		FROM @treatments_and_workplans
		WHERE patient_workplan_id = @pl_patient_workplan_id
		AND step_number = @pi_step_number
		AND temp_item_number = @li_count

		-- The "ordered_for" value of the treatment or workplan will be whoever
		-- ended up owning the spawning workplan item after it was dispatched
		SELECT @ls_ordered_for = owned_by
		FROM p_Patient_WP_Item
		WHERE patient_workplan_item_id = @ll_patient_workplan_item_id

		-- If the dispatcher is in the "ordered_for" role, then make the dispatcher the "ordered_for"
		IF EXISTS(SELECT [user_id] FROM c_User_Role WHERE [user_id] = @ps_dispatched_by AND role_id = @ls_ordered_for)
			SELECT @ls_ordered_for = @ps_dispatched_by
			FROM p_Patient_WP
			WHERE patient_workplan_id = @pl_patient_workplan_id

		IF @ls_item_type = 'Treatment'
			-- Order Treatment
			EXECUTE sp_Order_Workplan_Treatment
				@ps_cpr_id = @ps_cpr_id,
				@pl_patient_workplan_id = @pl_patient_workplan_id,
				@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
				@ps_treatment_type = @ls_ordered_treatment_type,
				@pl_encounter_id = @pl_encounter_id,
				@ps_description = @ls_description,
				@ps_ordered_by = @ps_dispatched_by,
				@ps_ordered_for = @ls_ordered_for,
				@ps_created_by = @ps_created_by,
				@pl_treatment_id = @ll_treatment_id OUTPUT
		ELSE IF @ls_item_type = 'Workplan'
			-- Order workplan
			EXECUTE sp_Order_Workplan
				@ps_cpr_id = @ps_cpr_id,
				@pl_workplan_id = @ll_ordered_workplan_id,
				@pl_encounter_id = @pl_encounter_id,
				@pl_treatment_id = @ll_treatment_id,
				@ps_description = @ls_description,
				@ps_ordered_by = @ps_dispatched_by,
				@ps_ordered_for = @ls_ordered_for,
				@pl_parent_patient_workplan_item_id = @ll_patient_workplan_item_id,
				@ps_created_by = @ps_created_by,
				@pl_patient_workplan_id = @ll_new_patient_workplan_id OUTPUT

		SET @li_count = @li_count + 1
		END


	-- Update the new room
	IF @ll_encounter_id IS NOT NULL AND @ls_room_id IS NOT NULL
		IF EXISTS(SELECT room_id FROM o_Rooms WHERE room_id = @ls_room_id)
			UPDATE p_Patient_Encounter
			SET patient_location = @ls_room_id
			WHERE cpr_id = @ps_cpr_id
			AND encounter_id = @ll_encounter_id
		ELSE
			UPDATE p_Patient_Encounter
			SET next_patient_location = @ls_room_id
			WHERE cpr_id = @ps_cpr_id
			AND encounter_id = @ll_encounter_id

	-- Update the last_step info on the workplan record
	IF @li_last_step_dispatched < @pi_step_number OR @li_last_step_dispatched IS NULL
		BEGIN
		SET @ldt_last_step_date = dbo.get_client_datetime()
		UPDATE p_Patient_WP
		SET last_step_dispatched = @pi_step_number,
			last_step_date = @ldt_last_step_date
		WHERE patient_workplan_id = @pl_patient_workplan_id

		IF @@rowcount <> 1
			BEGIN
			RAISERROR ('Error Updating Workplan (%s, %d)',16,-1, @ps_cpr_id, @pl_patient_workplan_id)
			ROLLBACK TRANSACTION
			RETURN
			END

		END

	-- If this is an in-office workplan, then count the items dispatched in this step
	-- which count towards the step completion and are not in-office
	IF @ls_this_in_office_flag = 'Y'
		BEGIN
		SELECT @li_count = count(*)
		FROM p_Patient_WP_Item
		WHERE patient_workplan_id = @pl_patient_workplan_id
		AND status IN ('DISPATCHED', 'STARTED')
		AND step_number = @pi_step_number
		AND in_office_flag = 'N'
		AND step_flag = 'Y'

		-- If we found any, that means that the workplan has turned into a not-in-office workplan.
		-- In this case, lets call sp_check_workplan_status even though we know we're not closing
		-- the workplan yet
		IF @li_count > 0
			BEGIN
			EXECUTE sp_check_workplan_status
				@pl_patient_workplan_id = @pl_patient_workplan_id,
				@ps_user_id = @ps_dispatched_by,
				@ps_created_by = @ps_created_by
			END
		END

	-- Assume we're not going to dispatch any more steps
	SET @li_next_step_number = 0

	-- Count the items dispatched in this step which count towards the step completion
	SELECT @li_count = count(*)
	FROM p_Patient_WP_Item
	WHERE patient_workplan_id = @pl_patient_workplan_id
	AND status IN ('DISPATCHED', 'STARTED', 'CONSOLIDATED')
	AND step_number = @pi_step_number
	AND step_flag = 'Y'

	-- If there are no service items in this step, then recursively dispatch the next step
	IF @li_count = 0
		BEGIN
		-- Find out what the next step number is (not counting the "Final Step" # 999)
		SELECT @li_next_step_number = min(step_number)
		FROM p_Patient_WP_Item
		WHERE patient_workplan_id = @pl_patient_workplan_id
		AND step_number > @pi_step_number
		AND step_number < 999

		IF @li_next_step_number > 0
			BEGIN
			-- See if the next step has already been dispatched
			SELECT @li_count = count(*)
			FROM p_Patient_WP_Item
			WHERE patient_workplan_id = @pl_patient_workplan_id
			AND step_number = @li_next_step_number
			AND status IS NOT NULL
			
			-- If the next step has already been dispatched, then don't dispatch it again
			IF @li_count > 0
				SET @li_next_step_number = 0
			END
		
		END
		
		SET @pi_step_number = @li_next_step_number
		
	END -- While @pi_step_number > 0 while loop

-- After we're done dispatching steps for this workplan, check it's status
EXECUTE sp_check_workplan_status
	@pl_patient_workplan_id = @pl_patient_workplan_id,
	@ps_user_id = @ps_dispatched_by,
	@ps_created_by = @ps_created_by
		

GO
GRANT EXECUTE
	ON [dbo].[sp_Dispatch_Workplan_Step]
	TO [cprsystem]
GO

