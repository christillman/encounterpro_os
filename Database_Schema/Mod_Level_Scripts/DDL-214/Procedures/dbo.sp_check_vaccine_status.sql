
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_check_vaccine_status]
Print 'Drop Procedure [dbo].[sp_check_vaccine_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_check_vaccine_status]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_check_vaccine_status]
GO

-- Create Procedure [dbo].[sp_check_vaccine_status]
Print 'Create Procedure [dbo].[sp_check_vaccine_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_check_vaccine_status (
	@ps_cpr_id varchar(12),
	@pl_disease_id int,
	@pi_status smallint OUTPUT,
	@pdt_due_date_time datetime OUTPUT )
AS
DECLARE @li_vaccine_count smallint,
	@li_schedule_count smallint,
	@li_assessment_count smallint,
	@ldt_warning_date datetime,
	@ldt_date_of_birth datetime,
	@ldt_age datetime,
	@li_warning_days smallint,
	@lc_no_vaccine_after_disease char(1)
SELECT @lc_no_vaccine_after_disease = no_vaccine_after_disease
FROM c_Disease WITH (NOLOCK)
WHERE disease_id = @pl_disease_id
IF @lc_no_vaccine_after_disease = 'Y'
	BEGIN
	SELECT @li_assessment_count = count(problem_id)
	FROM 	p_Assessment a WITH (NOLOCK)
		, c_Disease_Assessment d WITH (NOLOCK)
	WHERE a.cpr_id = @ps_cpr_id
	AND a.assessment_id = d.assessment_id
	AND d.disease_id = @pl_disease_id
	IF @li_assessment_count > 0
		BEGIN
		SELECT	@pdt_due_date_time = null,
			@pi_status = 0
		RETURN
		END
	END
		
SELECT @ldt_date_of_birth = date_of_birth
FROM p_Patient WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
SELECT @li_vaccine_count = count(*)
FROM 	p_Treatment_Item WITH (NOLOCK)
JOIN c_vaccine ON p_Treatment_Item.drug_id = c_vaccine.drug_id
JOIN c_vaccine_disease ON c_vaccine.vaccine_id = c_vaccine_disease.vaccine_id
WHERE p_Treatment_Item.cpr_id = @ps_cpr_id
AND p_Treatment_Item.treatment_type IN ('IMMUNIZATION', 'PASTIMMUN')
AND c_vaccine_disease.disease_id = @pl_disease_id
AND (p_Treatment_Item.treatment_status <> 'CANCELLED'
or p_Treatment_Item.treatment_status IS NULL)
SELECT @li_schedule_count = count(*)
FROM c_Immunization_Schedule WITH (NOLOCK)
WHERE disease_id = @pl_disease_id
IF @li_schedule_count = 0
	SELECT	@pdt_due_date_time = null,
		@pi_status = null
ELSE IF @li_vaccine_count >= @li_schedule_count
	SELECT	@pdt_due_date_time = null,
		@pi_status = 0
ELSE
	BEGIN
	SELECT	@ldt_age = age,
		@li_warning_days = warning_days
	FROM c_Immunization_Schedule WITH (NOLOCK)
	WHERE disease_id = @pl_disease_id 	AND schedule_sequence = @li_vaccine_count + 1
	SELECT @pdt_due_date_time = dateadd(day, datediff(day, '1/1/1980', @ldt_age), @ldt_date_of_birth)
	SELECT @ldt_warning_date = dateadd(day, -@li_warning_days, @pdt_due_date_time)
	IF @ldt_warning_date > getdate()
		SELECT	@pi_status = 1
	ELSE IF @pdt_due_date_time > getdate()
		SELECT	@pi_status = 2
	ELSE
		SELECT	@pi_status = 3
	END

GO
GRANT EXECUTE
	ON [dbo].[sp_check_vaccine_status]
	TO [cprsystem]
GO

