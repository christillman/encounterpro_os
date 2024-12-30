
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_immunization_next_dose_date]
Print 'Drop Function [dbo].[fn_immunization_next_dose_date]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_immunization_next_dose_date]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_immunization_next_dose_date]
GO

-- Create Function [dbo].[fn_immunization_next_dose_date]
Print 'Create Function [dbo].[fn_immunization_next_dose_date]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_immunization_next_dose_date (
	@pl_disease_id int,
	@pl_dose_number int,
	@pdt_date_of_birth datetime,
	@pdt_current_date datetime,
	@pdt_first_dose_date datetime,
	@pdt_last_dose_date datetime)

RETURNS @next_dose TABLE (
	next_dose_date datetime NOT NULL,
	next_dose_schedule_sequence int NOT NULL,
	next_dose_text varchar(255) NULL )

AS
BEGIN

DECLARE @ldt_due_date datetime,
		@ll_due_dose_schedule_sequence int,
		@ls_due_dose_text varchar(255),
		@ldt_min_age datetime,
		@ldt_min_wait_date datetime,
		@ldt_rule_date datetime,
		@ll_next_dose_schedule_sequence int,
		@ls_next_dose_text varchar(255)

SET @ldt_due_date = NULL

DECLARE lc_dose_rules CURSOR LOCAL FAST_FORWARD FOR
	SELECT min_age.adjusted_date as min_age,
			min_wait.adjusted_date as min_wait_date,
			s.dose_schedule_sequence,
			s.dose_text
	FROM c_Immunization_Dose_Schedule s
		INNER JOIN c_Age_Range a ON s.patient_age_range_id = a.age_range_id		
		LEFT JOIN c_Age_Range fst ON s.first_dose_age_range_id = fst.age_range_id	
		LEFT JOIN c_Age_Range lst ON s.last_dose_age_range_id = lst.age_range_id			
	CROSS JOIN o_Office oo
	JOIN c_Office co ON co.office_id = oo.office_id
	CROSS APPLY dbo.itvf_date_add_interval(@pdt_date_of_birth, a.age_from, a.age_from_unit) min_age
	CROSS APPLY dbo.itvf_date_add_interval(@pdt_last_dose_date, s.last_dose_interval_amount, s.last_dose_interval_unit_id) min_wait
	CROSS APPLY dbo.itvf_age_in_range_as_at(a.age_from, a.age_from_unit, a.age_to, a.age_to_unit, @pdt_date_of_birth, @pdt_current_date) patient_age
	CROSS APPLY dbo.itvf_age_in_range_as_at(fst.age_from, fst.age_from_unit, fst.age_to, fst.age_to_unit, @pdt_date_of_birth, @pdt_first_dose_date) first_dose
	CROSS APPLY dbo.itvf_age_in_range_as_at(lst.age_from, lst.age_from_unit, lst.age_to, lst.age_to_unit, @pdt_date_of_birth, @pdt_last_dose_date) last_dose
	WHERE s.valid_in LIKE '%' + co.country + ';%'
	AND patient_age.is_in_range <= 0
	AND first_dose.is_in_range = 0
	AND last_dose.is_in_range = 0
	ORDER BY s.sort_sequence

OPEN lc_dose_rules

FETCH lc_dose_rules INTO @ldt_min_age, @ldt_min_wait_date, @ll_next_dose_schedule_sequence, @ls_next_dose_text

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- The due-date for this rule is the greater of the min-age and the min-wait-date
	IF @ldt_min_wait_date IS NULL OR @ldt_min_age >= @ldt_min_wait_date
		SET @ldt_rule_date = @ldt_min_age

	IF @ldt_min_age IS NULL OR @ldt_min_age < @ldt_min_wait_date
		SET @ldt_rule_date = @ldt_min_wait_date

	
	-- Then find the earliest due-date of all the rules for this dose
	IF @ldt_due_date IS NULL OR @ldt_rule_date < @ldt_due_date
		BEGIN
		SET @ldt_due_date = @ldt_rule_date
		SET @ll_due_dose_schedule_sequence = @ll_next_dose_schedule_sequence
		SET @ls_due_dose_text = @ls_next_dose_text
		END
	
	FETCH lc_dose_rules INTO @ldt_min_age, @ldt_min_wait_date, @ll_next_dose_schedule_sequence, @ls_next_dose_text
	END

CLOSE lc_dose_rules
DEALLOCATE lc_dose_rules

IF @ldt_due_date IS NULL OR @ll_due_dose_schedule_sequence IS NULL
	RETURN

INSERT INTO @next_dose (
	next_dose_date ,
	next_dose_schedule_sequence,
	next_dose_text )
VALUES (
	@ldt_due_date,
	@ll_due_dose_schedule_sequence,
	@ls_due_dose_text)

RETURN

END
GO
GRANT SELECT ON [dbo].[fn_immunization_next_dose_date] TO [cprsystem]
GO

