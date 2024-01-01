
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Get_Patient_Age_Range]
Print 'Drop Procedure [dbo].[sp_Get_Patient_Age_Range]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Get_Patient_Age_Range]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Get_Patient_Age_Range]
GO

-- Create Procedure [dbo].[sp_Get_Patient_Age_Range]
Print 'Create Procedure [dbo].[sp_Get_Patient_Age_Range]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_Get_Patient_Age_Range (
	@ps_cpr_id varchar(12),
	@ps_age_range_category varchar(24) = NULL,
	@pl_age_range_id int OUTPUT )
AS

DECLARE @ll_temp int

-- Calculate the patient's stage
select c_Age_Range.age_range_id, c_Age_Range.description, c_Age_Range.sort_sequence,
	CASE age_from_unit
		WHEN 'YEAR' THEN dateadd(year, c_Age_Range.age_from, p_Patient.date_of_birth)
		WHEN 'MONTH' THEN dateadd(month, c_Age_Range.age_from, p_Patient.date_of_birth)
		WHEN 'DAY' THEN dateadd(day, c_Age_Range.age_from, p_Patient.date_of_birth)
		END as patient_age_from,
	CASE age_to_unit
		WHEN 'YEAR' THEN dateadd(year, c_Age_Range.age_to, p_Patient.date_of_birth)
		WHEN 'MONTH' THEN dateadd(month, c_Age_Range.age_to, p_Patient.date_of_birth)
		WHEN 'DAY' THEN dateadd(day, c_Age_Range.age_to, p_Patient.date_of_birth)
		END as patient_age_to
INTO #tmp_patient_ages
FROM c_Age_Range
CROSS JOIN p_Patient
WHERE p_Patient.cpr_id = @ps_cpr_id
AND (c_Age_Range.age_range_category = @ps_age_range_category
	OR @ps_age_range_category IS NULL)

SELECT @ll_temp = min(sort_sequence)
FROM #tmp_patient_ages
WHERE (patient_age_from <= getdate() OR patient_age_from IS NULL)
AND (patient_age_to > getdate() OR patient_age_to IS NULL)

SELECT @pl_age_range_id = min(age_range_id)
FROM #tmp_patient_ages
WHERE (patient_age_from <= getdate() OR patient_age_from IS NULL)
AND (patient_age_to > getdate() OR patient_age_to IS NULL)
AND sort_sequence = @ll_temp

GO
GRANT EXECUTE
	ON [dbo].[sp_Get_Patient_Age_Range]
	TO [cprsystem]
GO

