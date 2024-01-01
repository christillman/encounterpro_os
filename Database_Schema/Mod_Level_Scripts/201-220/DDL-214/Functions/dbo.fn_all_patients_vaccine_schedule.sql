
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_all_patients_vaccine_schedule]
Print 'Drop Function [dbo].[fn_all_patients_vaccine_schedule]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_all_patients_vaccine_schedule]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_all_patients_vaccine_schedule]
GO

-- Create Function [dbo].[fn_all_patients_vaccine_schedule]
Print 'Create Function [dbo].[fn_all_patients_vaccine_schedule]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_all_patients_vaccine_schedule (
	@pdt_current_date datetime)

RETURNS @schedule TABLE (
	cpr_id varchar(12) NOT NULL,
	disease_group varchar(24) NOT NULL,
	disease_id int NOT NULL,
	description varchar(80) NOT NULL,
	disease_sort_sequence int NOT NULL,
	dose_number int NOT NULL,
	dose_date datetime NOT NULL,
	dose_status varchar(24) NOT NULL,
	dose_text varchar(255) NULL)

AS

BEGIN


DECLARE @temp_schedule TABLE (
	cpr_id varchar(12) NOT NULL,
	disease_group varchar(24) NOT NULL,
	disease_id int NOT NULL,
	description varchar(80) NOT NULL,
	disease_sort_sequence int NOT NULL,
	dose_number int NOT NULL,
	dose_date datetime NOT NULL,
	dose_status varchar(24) NOT NULL,
	dose_text varchar(255) NULL)

DECLARE @patient_groups TABLE (
	cpr_id varchar(12) NOT NULL,
	disease_group varchar(24) NOT NULL,
	description varchar(80) NOT NULL,
	sort_sequence int NOT NULL,
	ineligible bit NOT NULL default(0)
	)

DECLARE @patient_diseases TABLE (
	cpr_id varchar(12) NOT NULL,
	disease_group varchar(24) NOT NULL,
	disease_id int NOT NULL,
	description varchar(80) NOT NULL,
	sort_sequence int NOT NULL,
	no_vaccine_after_disease char(1) NOT NULL,
	first_dose_date datetime NULL,
	last_dose_date datetime NULL,
	next_dose_number int NOT NULL DEFAULT (1),
	disease_problem_id int NULL,
	disease_diagnosis_date datetime NULL,
	assessment varchar(80)
	)

DECLARE @actual TABLE (
	cpr_id varchar(12) NOT NULL,
	disease_id int NOT NULL,
	dose_sequence int IDENTITY(1,1) NOT NULL,
	dose_number int NULL,
	dose_date datetime NOT NULL,
	dose_description varchar(80))

-- Start with all the disease groups
INSERT INTO @patient_groups (
	cpr_id ,
	disease_group ,
	description ,
	sort_sequence )
SELECT p.cpr_id,
	g.disease_group,
	g.description,
	g.sort_sequence
FROM p_Patient p WITH (NOLOCK)
	CROSS JOIN c_Disease_Group g
WHERE p.patient_status = 'Active'
AND g.status = 'OK'

-- Mark the groups where the patient is not eligible
UPDATE x
SET ineligible = 1
FROM @patient_groups x
	INNER JOIN c_Disease_Group g
	ON x.disease_group = g.disease_group
	INNER JOIN p_Patient p
	ON x.cpr_id = p.cpr_id
WHERE g.age_range IS NOT NULL
AND dbo.fn_age_range_compare(g.age_range, p.date_of_birth, @pdt_current_date) <> 0

UPDATE x
SET ineligible = 1
FROM @patient_groups x
	INNER JOIN c_Disease_Group g
	ON x.disease_group = g.disease_group
	INNER JOIN p_Patient p
	ON x.cpr_id = p.cpr_id
WHERE g.sex IS NOT NULL
AND p.sex <> g.sex


-- Get the individual disease per patient
INSERT INTO @patient_diseases (
	cpr_id ,
	disease_group ,
	disease_id ,
	description ,
	sort_sequence ,
	no_vaccine_after_disease )
SELECT g.cpr_id,
	g.disease_group,
	i.disease_id,
	d.description,
	i.sort_sequence,
	CASE d.no_vaccine_after_disease WHEN 'Y' THEN 'Y' ELSE 'N' END
FROM @patient_groups g
	INNER JOIN c_Disease_Group_Item i
	ON g.disease_group = i.disease_group
	INNER JOIN c_Disease d
	ON i.disease_id = d.disease_id
WHERE d.status = 'OK'

-- Find the diseases that have been diagnosed
UPDATE p
SET disease_problem_id = x.problem_id
FROM @patient_diseases p
	INNER JOIN (SELECT a.cpr_id, d.disease_id, problem_id = min(a.problem_id)
				FROM p_Assessment a WITH (NOLOCK)
					INNER JOIN c_Disease_Assessment d
					ON a.assessment_id = d.assessment_id
				WHERE a.current_flag = 'Y'
				AND ISNULL(a.assessment_status, 'OPEN') <> 'Cancelled'
				GROUP BY a.cpr_id, d.disease_id) x
	ON p.cpr_id = x.cpr_id
	AND p.disease_id = x.disease_id

UPDATE p
SET disease_diagnosis_date = a.begin_date,
	assessment = a.assessment
FROM @patient_diseases p
	INNER JOIN p_Assessment a WITH (NOLOCK)
	ON p.cpr_id = a.cpr_id
	AND p.disease_problem_id = a.problem_id
	AND a.current_flag = 'Y'

-- Get the actual immunizations given by patient/disease
INSERT INTO @actual (
	cpr_id ,
	disease_id ,
	dose_date ,
	dose_description)
SELECT t.cpr_id,
	d.disease_id,
	t.begin_date,
	t.treatment_description
FROM p_Treatment_Item t WITH (NOLOCK)
JOIN c_vaccine v ON t.drug_id = v.drug_id
JOIN c_vaccine_disease vd ON v.vaccine_id = vd.vaccine_id
JOIN c_Disease d ON d.disease_id = vd.disease_id
WHERE t.treatment_type = 'IMMUNIZATION'
AND ISNULL(t.treatment_status, 'OPEN') <> 'CANCELLED'
ORDER BY t.cpr_id, d.disease_id, t.begin_date

UPDATE a
SET dose_number = a.dose_sequence - x.min_dose_sequence + 1
FROM @actual a
	INNER JOIN (SELECT cpr_id, disease_id, min_dose_sequence = min(dose_sequence)
				FROM @actual
				GROUP BY cpr_id, disease_id) x
	ON a.cpr_id = x.cpr_id
	AND a.disease_id = x.disease_id


UPDATE p
SET first_dose_date = x.min_dose_date,
	last_dose_date = x.max_dose_date,
	next_dose_number = x.max_dose_number + 1
FROM @patient_diseases p
	INNER JOIN (SELECT cpr_id, disease_id, min_dose_date = min(dose_date), max_dose_date = max(dose_date), max_dose_number = max(dose_number)
				FROM @actual
				GROUP BY cpr_id, disease_id) x
	ON p.cpr_id = x.cpr_id
	AND p.disease_id = x.disease_id



----------------------------------------------------------------------------------
-- Construct the patient schedules
----------------------------------------------------------------------------------

-- Add the actual vaccinations
INSERT INTO @temp_schedule (
	cpr_id ,
	disease_group ,
	disease_id ,
	description ,
	disease_sort_sequence ,
	dose_number ,
	dose_date ,
	dose_status ,
	dose_text )
SELECT 
	a.cpr_id ,
	p.disease_group ,
	a.disease_id ,
	p.description ,
	p.sort_sequence ,
	a.dose_number ,
	a.dose_date ,
	'Given' ,
	a.dose_description
FROM @actual a
	INNER JOIN @patient_diseases p
	ON a.cpr_id = p.cpr_id
	AND a.disease_id = p.disease_id

-- Add a record for the diseases that are no longer eligibile because the patient has had the disease
INSERT INTO @temp_schedule (
	cpr_id ,
	disease_group ,
	disease_id ,
	description ,
	disease_sort_sequence ,
	dose_number ,
	dose_date ,
	dose_status ,
	dose_text )
SELECT 
	p.cpr_id ,
	p.disease_group ,
	p.disease_id ,
	p.description ,
	p.sort_sequence ,
	p.next_dose_number ,
	p.disease_diagnosis_date ,
	'Ineligible' ,
	'Patient has been diagnosed with ' + p.assessment
FROM @patient_diseases p
WHERE p.no_vaccine_after_disease = 'Y'
AND p.disease_diagnosis_date IS NOT NULL


--where ineligible = 1
/*
DECLARE lc_diseases CURSOR LOCAL FAST_FORWARD FOR
	SELECT d.disease_id, d.description, COALESCE(i.sort_sequence, d.sort_sequence, i.disease_id)
	FROM c_Disease_Group_Item i
		INNER JOIN c_Disease d
		ON d.disease_id = i.disease_id
	WHERE disease_group = @ps_disease_group

OPEN lc_diseases

FETCH lc_diseases INTO @ll_disease_id, @ls_description, @ll_sort_sequence

WHILE @@FETCH_STATUS = 0
	BEGIN

	INSERT INTO @temp_schedule (
		disease_id ,
		description ,
		disease_sort_sequence ,
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text )
	SELECT @ll_disease_id ,
		@ls_description ,
		@ll_sort_sequence ,
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text
	FROM dbo.fn_patient_disease_immunization_schedule(@ps_cpr_id, @ll_disease_id, @pdt_current_date)
	
	IF @ll_date_count IS NULL
		BEGIN
		INSERT INTO @schedule (
			disease_id ,
			description ,
			disease_sort_sequence ,
			dose_number ,
			dose_date ,
			dose_status ,
			dose_text )
		SELECT 0 ,
			@ps_disease_group ,
			0 ,
			dose_number ,
			dose_date ,
			dose_status ,
			dose_text
		FROM @temp_schedule
		
		SET @ll_date_count = @@ROWCOUNT
		END
	ELSE
		BEGIN
		IF @ll_date_count <> (SELECT count(*)
							FROM @temp_schedule t
								INNER JOIN @schedule s
								ON t.dose_number = s.dose_number
								AND t.dose_date = s.dose_date
								AND t.dose_status = s.dose_status
							WHERE t.disease_id = @ll_disease_id)
			BEGIN
			SET @ll_all_same = 0
			END
		END
	
	
	FETCH lc_diseases INTO @ll_disease_id, @ls_description, @ll_sort_sequence
	END

CLOSE lc_diseases
DEALLOCATE lc_diseases

IF @ll_all_same = 0
	BEGIN
	DELETE FROM @schedule
	
	INSERT INTO @schedule (
		disease_id ,
		description ,
		disease_sort_sequence ,
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text )
	SELECT disease_id ,
		description ,
		disease_sort_sequence ,
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text
	FROM @temp_schedule
	END

*/

RETURN
END

GO
GRANT SELECT
	ON [dbo].[fn_all_patients_vaccine_schedule]
	TO [cprsystem]
GO

