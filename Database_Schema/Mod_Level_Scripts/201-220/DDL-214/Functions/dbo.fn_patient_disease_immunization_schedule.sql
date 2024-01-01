
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_patient_disease_immunization_schedule]
Print 'Drop Function [dbo].[fn_patient_disease_immunization_schedule]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_disease_immunization_schedule]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_disease_immunization_schedule]
GO

-- Create Function [dbo].[fn_patient_disease_immunization_schedule]
Print 'Create Function [dbo].[fn_patient_disease_immunization_schedule]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_patient_disease_immunization_schedule (
	@ps_cpr_id varchar(12),
	@pl_disease_id int,
	@pdt_current_date datetime )

RETURNS @schedule TABLE (
	dose_number int NOT NULL,
	dose_date datetime NOT NULL,
	dose_status varchar(24) NOT NULL,
	dose_text varchar(255) NULL)

AS

BEGIN

IF @ps_cpr_id IS NULL
	RETURN

IF @pl_disease_id IS NULL
	RETURN

DECLARE @ll_dose_count int,
		@ll_next_dose_number int,
		@ldt_first_dose_date datetime,
		@ldt_last_dose_date datetime,
		@ldt_date_of_birth datetime,
		@ls_no_vaccine_after_disease char(1),
		@ldt_disease_diagnosis_date datetime,
		@ls_assessment varchar(80)

SET @pdt_current_date = convert(datetime, convert(varchar,@pdt_current_date, 112))

SELECT @ldt_date_of_birth = date_of_birth
FROM p_Patient
WHERE cpr_id = @ps_cpr_id

IF @@ROWCOUNT = 0
	RETURN

IF @ldt_date_of_birth IS NULL
	RETURN

SELECT @ls_no_vaccine_after_disease = no_vaccine_after_disease
FROM c_Disease
WHERE disease_id = @pl_disease_id

IF @@ROWCOUNT = 0
	RETURN

SET @ldt_disease_diagnosis_date = NULL
IF @ls_no_vaccine_after_disease = 'Y'
	BEGIN
	-- If the patient has had this disease then they are not eligible for any more immunizations
	SELECT @ldt_disease_diagnosis_date = min(a.begin_date)
	FROM p_Assessment a
		INNER JOIN c_Disease_Assessment d
		ON a.assessment_id = d.assessment_id
	WHERE a.cpr_id = @ps_cpr_id
	AND d.disease_id = @pl_disease_id
	AND ISNULL(a.assessment_status, 'OPEN') <> 'Cancelled'

	IF @ldt_disease_diagnosis_date IS NOT NULL
		BEGIN
		SELECT @ls_assessment = min(assessment)
		FROM p_Assessment a
			INNER JOIN c_Disease_Assessment d
			ON a.assessment_id = d.assessment_id
		WHERE a.cpr_id = @ps_cpr_id
		AND d.disease_id = @pl_disease_id
		AND ISNULL(a.assessment_status, 'OPEN') <> 'Cancelled'
		AND begin_date = @ldt_disease_diagnosis_date

		IF @ls_assessment IS NULL
			SET @ls_assessment = 'disease'

		END
	END


DECLARE @actual TABLE (
	dose_number int IDENTITY(1,1) NOT NULL,
	dose_date datetime NOT NULL,
	dose_description varchar(80))


INSERT INTO @actual (
	dose_date ,
	dose_description)
SELECT t.begin_date,
	t.treatment_description
FROM p_Treatment_Item t WITH (NOLOCK)
JOIN c_vaccine v ON t.drug_id = v.drug_id
JOIN c_vaccine_disease vd ON v.vaccine_id = vd.vaccine_id
WHERE t.cpr_id = @ps_cpr_id
AND t.treatment_type = 'IMMUNIZATION'
AND vd.disease_id = @pl_disease_id
AND ISNULL(t.treatment_status, 'OPEN') <> 'CANCELLED'
ORDER BY t.begin_date

SET @ll_dose_count = @@ROWCOUNT

INSERT INTO @schedule (
	dose_number ,
	dose_date ,
	dose_status ,
	dose_text )
SELECT dose_number ,
	dose_date ,
	'Given',
	dose_description
FROM @actual

IF @ll_dose_count > 0
	BEGIN
	SELECT @ldt_first_dose_date = dose_date
	FROM @actual
	WHERE dose_number = 1
	
	SELECT @ldt_last_dose_date = dose_date
	FROM @actual
	WHERE dose_number = @ll_dose_count
	END
ELSE
	BEGIN
	SET @ldt_first_dose_date = NULL
	SET @ldt_last_dose_date = NULL
	END

SET @ll_next_dose_number = @ll_dose_count + 1

IF @ldt_disease_diagnosis_date IS NOT NULL
	BEGIN
	INSERT INTO @schedule (
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text )
	VALUES (
		@ll_next_dose_number,
		@ldt_disease_diagnosis_date,
		'Ineligible',
		'Patient has been diagnosed with ' + @ls_assessment
		)
	END
ELSE
	BEGIN
	INSERT INTO @schedule (
		dose_number ,
		dose_date ,
		dose_status ,
		dose_text )
	SELECT dose_number,
			dose_date,
			CASE WHEN dose_date = @pdt_current_date THEN 'Give Now' ELSE 'Projected' END,
			dose_text
	FROM dbo.fn_immunization_schedule (
		@pl_disease_id ,
		@ll_next_dose_number,
		@ldt_date_of_birth ,
		@pdt_current_date ,
		@ldt_first_dose_date ,
		@ldt_last_dose_date)
	END

RETURN
END

GO
GRANT SELECT
	ON [dbo].[fn_patient_disease_immunization_schedule]
	TO [cprsystem]
GO

