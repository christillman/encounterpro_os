CREATE FUNCTION fn_is_wait_service_ready (
	@pl_patient_workplan_item_id int,
	@pdt_current_date datetime )

RETURNS int

AS
BEGIN
DECLARE @ll_ready int,
		@ls_event_type varchar(24),
		@ls_wait_interval varchar(40),
		@ls_wait_progress_type varchar(24),
		@ls_wait_progress_key varchar(40),
		@ls_amount varchar(12),
		@ll_amount int,
		@ls_unit varchar(12),
		@ldt_dispatch_date datetime,
		@ls_check_date varchar(24),
		@ldt_check_date datetime,
		@ll_charindex int,
		@ls_progress_value varchar(255),
		@ls_cpr_id varchar(12),
		@ll_object_key int,
		@ls_context_object varchar(24),
		@lr_duration_amount real,
		@ls_duration_unit varchar(24),
		@ll_patient_workplan_id int

SELECT @ldt_dispatch_date = i.dispatch_date,
		@ls_cpr_id = i.cpr_id,
		@ll_patient_workplan_id = i.patient_workplan_id,
		@ls_context_object = CASE w.workplan_type WHEN 'Followup' THEN 'Treatment'
													WHEN 'Referral' THEN 'Treatment'
													ELSE w.workplan_type END,
		@ll_object_key = CASE w.workplan_type WHEN 'Followup' THEN w.treatment_id
													WHEN 'Referral' THEN w.treatment_id
													WHEN 'Encounter' THEN w.encounter_id
													WHEN 'Assessment' THEN w.problem_id
													WHEN 'Treatment' THEN w.treatment_id
													WHEN 'Attachment' THEN w.attachment_id
													WHEN 'Observation' THEN w.observation_sequence
													ELSE NULL END
FROM p_Patient_WP_Item i
	INNER JOIN p_Patient_WP w
	ON i.patient_workplan_id = w.patient_workplan_id
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

SET @ls_event_type = dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'event_type')
IF @ls_event_type IS NULL
	SET @ls_event_type = 'Wait For'

IF @ls_event_type = 'Wait For'
	BEGIN
	SET @ls_wait_interval = dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'wait_interval')
	IF @ls_wait_interval IS NULL
		BEGIN
		SELECT @lr_duration_amount = t.duration_amount,
				@ls_duration_unit = t.duration_unit
		FROM p_Patient_WP wp
			INNER JOIN p_Treatment_Item t
			ON wp.cpr_id = t.cpr_id
			AND wp.treatment_id = t.treatment_id
		WHERE wp.patient_workplan_id = @ll_patient_workplan_id
		IF @@ROWCOUNT = 1 AND @lr_duration_amount IS NOT NULL AND @ls_duration_unit IS NOT NULL
			BEGIN
			SET @ls_wait_interval = CAST(CAST(@lr_duration_amount AS int) AS varchar(8)) + ' ' + @ls_duration_unit
			END
		END
	
	
	IF @ls_wait_interval IS NULL
		SET @ls_wait_interval = '1 Minute'
	
	-- Interpret the wait interval
	SET @ll_charindex = CHARINDEX(' ', @ls_wait_interval)
	IF @ll_charindex > 1
		BEGIN
		SET @ls_amount = LEFT(@ls_wait_interval, @ll_charindex - 1)
		SET @ll_amount = CAST(@ls_amount AS int)
		
		SET @ls_unit = LEFT(RIGHT(@ls_wait_interval, LEN(@ls_wait_interval) - @ll_charindex), 2)
		END
	ELSE
		RETURN 0
	
	SET @ldt_check_date = CASE @ls_unit
		WHEN 'YE' THEN dateadd(year, @ll_amount, @ldt_dispatch_date)
		WHEN 'MO' THEN dateadd(month, @ll_amount, @ldt_dispatch_date)
		WHEN 'DA' THEN dateadd(day, @ll_amount, @ldt_dispatch_date)
		WHEN 'HO' THEN dateadd(hour, @ll_amount, @ldt_dispatch_date)
		WHEN 'SE' THEN dateadd(second, @ll_amount, @ldt_dispatch_date)
		ELSE dateadd(minute, @ll_amount, @ldt_dispatch_date)
		END

	IF @ldt_check_date <= @pdt_current_date
		RETURN 1
	ELSE
		RETURN 0

	END
ELSE IF @ls_event_type = 'Wait Until'
	BEGIN
	SET @ls_wait_interval = dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'wait_interval')
	IF @ls_wait_interval IS NULL
		SET @ls_wait_interval = '00:00'

	SET @ls_check_date = CONVERT(varchar(10), @pdt_current_date, 101) + ' ' + @ls_wait_interval
	SET @ldt_check_date = CAST(@ls_check_date AS datetime)

	IF @ldt_check_date <= @pdt_current_date
		RETURN 1
	ELSE
		RETURN 0

	END
ELSE IF @ls_event_type = 'Progress'
	BEGIN
	SET @ls_wait_progress_type = dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'wait_progress_type')
	IF @ls_wait_progress_type IS NULL
		SET @ls_wait_progress_type = 'Event'
	
	SET @ls_wait_progress_key = dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'wait_progress_key')
	IF @ls_wait_progress_key IS NULL
		SET @ls_wait_progress_key = 'Results Posted'
	
	SET @ls_progress_value = dbo.fn_patient_object_progress_value(@ls_cpr_id, @ls_context_object, @ls_wait_progress_type, @ll_object_key, @ls_wait_progress_key)
	
	IF LEN(@ls_progress_value) > 0
		RETURN 1
	ELSE
		RETURN 0

	END

RETURN 0

END

