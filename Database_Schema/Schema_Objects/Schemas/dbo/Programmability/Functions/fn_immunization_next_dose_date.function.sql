CREATE FUNCTION fn_immunization_next_dose_date (
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
	SELECT min_age = dbo.fn_date_add_interval(@pdt_date_of_birth, a.age_from, a.age_from_unit),
			min_wait_date = dbo.fn_date_add_interval(@pdt_last_dose_date, last_dose_interval_amount, last_dose_interval_unit_id),
			s.dose_schedule_sequence,
			s.dose_text
	FROM c_Immunization_Dose_Schedule s
		INNER JOIN c_Age_Range a
		ON s.patient_age_range_id = a.age_range_id
	WHERE s.disease_id = @pl_disease_id
	AND s.dose_number = @pl_dose_number
	AND dbo.fn_age_range_compare(s.patient_age_range_id, @pdt_date_of_birth, @pdt_current_date) <= 0
	AND (first_dose_age_range_id IS NULL OR dbo.fn_age_range_compare(s.first_dose_age_range_id, @pdt_date_of_birth, @pdt_first_dose_date) = 0)
	AND (last_dose_age_range_id IS NULL OR dbo.fn_age_range_compare(s.last_dose_age_range_id, @pdt_date_of_birth, @pdt_last_dose_date) = 0)
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
