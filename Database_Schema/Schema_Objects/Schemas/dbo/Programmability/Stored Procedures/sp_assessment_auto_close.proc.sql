CREATE PROCEDURE sp_assessment_auto_close (
		@ps_user_id varchar(24) = NULL,
		@ps_created_by varchar(24)  = NULL)	
AS

DECLARE @ls_cpr_id varchar(12),
		@ll_problem_id int,
		@ll_open_encounter_id int,
		@li_diagnosis_sequence integer,
		@ldt_end_date datetime

DECLARE @close_candidates TABLE (
	cpr_id varchar(12) NOT NULL,
	problem_id int NOT NULL,
	diagnosis_sequence smallint NOT NULL,
	open_encounter_id int NULL,
	begin_date datetime NULL,
	auto_close_interval_amount smallint NULL,
	auto_close_interval_unit varchar(24) NULL,
	last_touch_date datetime NULL,
	expected_end_date datetime NULL )

IF @ps_user_id IS NULL
	SET @ps_user_id = '#SYSTEM'

IF @ps_created_by IS NULL
	SET @ps_user_id = '#SYSTEM'

-- First, construct a table of the open diagnoses with auto-close intervals specified
INSERT INTO @close_candidates (
	cpr_id,
	problem_id,
	diagnosis_sequence,
	open_encounter_id,
	begin_date,
	auto_close_interval_amount,
	auto_close_interval_unit,
	last_touch_date )
SELECT a.cpr_id,
	a.problem_id,
	a.diagnosis_sequence,
	a.open_encounter_id,
	a.begin_date,
	d.auto_close_interval_amount,
	d.auto_close_interval_unit,
	a.begin_date
FROM p_Assessment a WITH (NOLOCK)
	INNER JOIN c_Assessment_Definition d WITH (NOLOCK)
	ON a.assessment_id = d.assessment_id
WHERE d.auto_close = 'D'
AND d.auto_close_interval_amount IS NOT NULL
AND d.auto_close_interval_unit IS NOT NULL
AND a.assessment_status IS NULL

-- Set the last touch date from the assessment progress notes
DECLARE @assessment_progress TABLE (
	cpr_id varchar(12) NOT NULL,
	problem_id int NOT NULL,
	progress_date_time datetime NOT NULL)

INSERT INTO @assessment_progress (
	cpr_id ,
	problem_id ,
	progress_date_time )
SELECT ap.cpr_id ,
	ap.problem_id ,
	max(ap.progress_date_time) as progress_date_time
FROM @close_candidates cc
	INNER JOIN p_Assessment_Progress ap WITH (NOLOCK)
	ON cc.cpr_id = ap.cpr_id
	AND cc.problem_id = ap.problem_id
GROUP BY ap.cpr_id ,
	ap.problem_id

UPDATE cc
SET last_touch_date = CASE WHEN ap.progress_date_time > cc.last_touch_date THEN ap.progress_date_time ELSE cc.last_touch_date END
FROM @close_candidates cc
	INNER JOIN @assessment_progress ap
	ON cc.cpr_id = ap.cpr_id
	AND cc.problem_id = ap.problem_id
	

-- Set the last touch date from the treatments
DECLARE @treatment TABLE (
	cpr_id varchar(12) NOT NULL,
	problem_id int NOT NULL,
	begin_date datetime NOT NULL)

INSERT INTO @treatment (
	cpr_id ,
	problem_id ,
	begin_date )
SELECT pat.cpr_id ,
	pat.problem_id ,
	max(t.begin_date) as begin_date
FROM @close_candidates cc
	INNER JOIN p_Assessment_Treatment pat WITH (NOLOCK)
	ON cc.cpr_id = pat.cpr_id
	AND cc.problem_id = pat.problem_id
	INNER JOIN p_Treatment_Item t WITH (NOLOCK)
	ON pat.cpr_id = t.cpr_id
	AND pat.treatment_id = t.treatment_id
GROUP BY pat.cpr_id ,
	pat.problem_id

UPDATE cc
SET last_touch_date = CASE WHEN t.begin_date > cc.last_touch_date THEN t.begin_date ELSE cc.last_touch_date END
FROM @close_candidates cc
	INNER JOIN @treatment t
	ON cc.cpr_id = t.cpr_id
	AND cc.problem_id = t.problem_id

-- Update the expected_end_date
UPDATE @close_candidates
SET expected_end_date = CASE auto_close_interval_unit
							WHEN 'YEAR' THEN dateadd(year, auto_close_interval_amount, last_touch_date)
							WHEN 'MONTH' THEN dateadd(month, auto_close_interval_amount, last_touch_date)
							WHEN 'DAY' THEN dateadd(day, auto_close_interval_amount, last_touch_date)
							END

-- Then close the assessments where the expected_end_date has arrived
DECLARE lc_assessment CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
	SELECT
		cpr_id,
		problem_id,
		open_encounter_id,
		diagnosis_sequence,
		expected_end_date
	FROM @close_candidates
	WHERE getdate() >= expected_end_date
	UNION
	SELECT
		 p.cpr_id
		,p.problem_id
		,p.open_encounter_id
		,p.diagnosis_sequence
		,e.discharge_date
	from p_assessment p WITH (NOLOCK)
	inner join c_assessment_definition a WITH (NOLOCK)
	on p.assessment_id = a.assessment_id
	inner join p_patient_encounter e WITH (NOLOCK)
	on p.cpr_id = e.cpr_id
	and p.open_encounter_id = e.encounter_id
	where p.assessment_status is null
	and a.auto_close = 'Y'
	and e.encounter_status = 'CLOSED'
	

OPEN lc_assessment

FETCH lc_assessment INTO @ls_cpr_id,
						@ll_problem_id,
						@ll_open_encounter_id,
						@li_diagnosis_sequence,
						@ldt_end_date

WHILE @@FETCH_STATUS = 0
	BEGIN
	
	EXECUTE sp_set_assessment_progress
		@ps_cpr_id = @ls_cpr_id,
		@pl_problem_id = @ll_problem_id,
		@pl_encounter_id = @ll_open_encounter_id,
		@pdt_progress_date_time = @ldt_end_date,
		@pi_diagnosis_sequence = @li_diagnosis_sequence,
		@ps_progress_type = 'Closed',
		@ps_progress_key = 'Closed',
		@ps_progress = 'Auto Closed',
		@ps_user_id = @ps_user_id,
		@ps_created_by = @ps_created_by

	FETCH lc_assessment INTO @ls_cpr_id,
							@ll_problem_id,
							@ll_open_encounter_id,
							@li_diagnosis_sequence,
							@ldt_end_date
	END

