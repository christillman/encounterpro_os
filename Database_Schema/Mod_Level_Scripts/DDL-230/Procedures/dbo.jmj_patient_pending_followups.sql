
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_patient_pending_followups]
Print 'Drop Procedure [dbo].[jmj_patient_pending_followups]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_patient_pending_followups]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_patient_pending_followups]
GO

-- Create Procedure [dbo].[jmj_patient_pending_followups]
Print 'Create Procedure [dbo].[jmj_patient_pending_followups]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
-- This procedure returns the treatments which represent the pending followups for the
-- specified patient.

CREATE PROCEDURE jmj_patient_pending_followups (
	@ps_cpr_id varchar(12))
AS

DECLARE @followups TABLE (
	cpr_id varchar(12) NOT NULL ,
	treatment_id int NOT NULL ,
	begin_date datetime NULL ,
	treatment_description varchar(80) NULL ,
	duration_amount real NULL ,
	duration_unit varchar(24) NULL ,
	duration_prn varchar(32) NULL ,
	treatment_goal varchar(80) NULL ,
	ordered_for varchar(24) NULL ,
	appointment_date_time datetime NULL,
	encounter_type varchar(24) NULL,
	followup_date datetime NULL,
	selected_flag int NOT NULL DEFAULT (0))

DECLARE @ldt_follwup_cutoff datetime,
		@ls_followup_check_date_range varchar(255),
		@ls_amount varchar(255),
		@ls_unit varchar(255),
		@ll_count int,
		@ll_amount int,
		@ldt_today datetime,
		@ll_space int

INSERT INTO @followups (
	cpr_id ,
	treatment_id ,
	begin_date ,
	treatment_description ,
	duration_amount ,
	duration_unit ,
	duration_prn ,
	treatment_goal ,
	ordered_for ,
	appointment_date_time,
	followup_date )
SELECT t.cpr_id ,
	t.treatment_id ,
	t.begin_date ,
	t.treatment_description ,
	t.duration_amount ,
	t.duration_unit ,
	t.duration_prn ,
	t.treatment_goal ,
	t.ordered_for ,
	t.appointment_date_time ,
	t.appointment_date_time
FROM p_Treatment_Item t
WHERE t.cpr_id = @ps_cpr_id
AND t.treatment_type = 'FOLLOWUP'
AND t.open_flag = 'Y'

-- Set the default cutoff
SET @ldt_today = dbo.fn_date_truncate(getdate(), 'Day')

SET @ldt_follwup_cutoff = NULL

SET @ls_followup_check_date_range = dbo.fn_get_preference('WORKFLOW', 'followup_check_date_range', DEFAULT, DEFAULT)

IF @ls_followup_check_date_range IS NOT NULL
	BEGIN
	SET @ll_space = CHARINDEX(' ', @ls_followup_check_date_range) 
	IF @ll_space > 1
		BEGIN
		SET @ls_amount = LEFT(@ls_followup_check_date_range, @ll_space - 1)
		SET @ls_unit = SUBSTRING(@ls_followup_check_date_range, @ll_space + 1, LEN(@ls_followup_check_date_range) - @ll_space)
		IF ISNUMERIC(@ls_amount) = 1 AND LEN(@ls_unit) > 1
			BEGIN
			SET @ll_amount = CAST(@ls_amount AS int)
			SET @ldt_follwup_cutoff = CASE @ls_unit
						WHEN 'YEAR' THEN dateadd(year, -@ll_amount, @ldt_today)
						WHEN 'MONTH' THEN dateadd(month, -@ll_amount, @ldt_today)
						WHEN 'WEEK' THEN dateadd(week, -@ll_amount, @ldt_today)
						WHEN 'DAY' THEN dateadd(day, -@ll_amount, @ldt_today) END
			END
		END
	END

IF @ldt_follwup_cutoff IS NULL
	SET @ldt_follwup_cutoff = dateadd(day, -30, @ldt_today)

UPDATE @followups
SET followup_date = CASE duration_unit
			WHEN 'YEAR' THEN dateadd(year, duration_amount, begin_date)
			WHEN 'MONTH' THEN dateadd(month, duration_amount, begin_date)
			WHEN 'WEEK' THEN dateadd(week, duration_amount, begin_date)
			WHEN 'DAY' THEN dateadd(day, duration_amount, begin_date)
			END
WHERE followup_date IS NULL

UPDATE @followups
SET followup_date = begin_date
WHERE followup_date IS NULL

DELETE @followups
WHERE followup_date < @ldt_follwup_cutoff

-- Delete any followup that has a followup workplan that has already been dispatched
DELETE x
FROM @followups x
	INNER JOIN p_Patient_WP w
	ON x.cpr_id = w.cpr_id
	AND x.treatment_id = w.treatment_id
WHERE w.workplan_type = 'Followup'
AND w.context_object = 'Treatment'
AND w.status <> 'pending'

UPDATE x
SET encounter_type = p.progress_value
FROM @followups x
	INNER JOIN p_Treatment_Progress p
	ON x.cpr_id = p.cpr_id
	AND x.treatment_id = p.treatment_id
WHERE p.progress_type = 'PROPERTY'
AND p.progress_key = 'encounter_type'
AND p.current_flag = 'Y'

SELECT 	cpr_id,
	treatment_id ,
	begin_date ,
	treatment_description ,
	duration_amount ,
	duration_unit ,
	duration_prn ,
	treatment_goal ,
	ordered_for ,
	appointment_date_time ,
	encounter_type ,
	followup_date ,
	selected_flag
FROM @followups
GO
GRANT EXECUTE
	ON [dbo].[jmj_patient_pending_followups]
	TO [cprsystem]
GO

