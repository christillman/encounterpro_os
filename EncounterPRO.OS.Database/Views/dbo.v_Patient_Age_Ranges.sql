
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop View [dbo].[v_Patient_Age_Ranges]
Print 'Drop View [dbo].[v_Patient_Age_Ranges]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[v_Patient_Age_Ranges]') AND [type]='V'))
DROP VIEW [dbo].[v_Patient_Age_Ranges]
GO
-- Create View [dbo].[v_Patient_Age_Ranges]
Print 'Create View [dbo].[v_Patient_Age_Ranges]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW v_Patient_Age_Ranges (cpr_id, age_range_id, age_range_category, description) AS
select p_Patient.cpr_id, c_Age_Range.age_range_id, c_Age_Range.age_range_category, c_Age_Range.description
FROM p_Patient
JOIN c_Age_Range
ON dbo.get_client_datetime() >= CASE c_Age_Range.age_from_unit
			WHEN 'YEAR' THEN dateadd(year, c_Age_Range.age_from, p_Patient.date_of_birth)
			WHEN 'MONTH' THEN dateadd(month, c_Age_Range.age_from, p_Patient.date_of_birth)
			WHEN 'DAY' THEN dateadd(day, c_Age_Range.age_from, p_Patient.date_of_birth)
			END
AND (c_Age_Range.age_to_unit IS NULL
	OR dbo.get_client_datetime() < CASE c_Age_Range.age_to_unit
			WHEN 'YEAR' THEN dateadd(year, c_Age_Range.age_to, p_Patient.date_of_birth)
			WHEN 'MONTH' THEN dateadd(month, c_Age_Range.age_to, p_Patient.date_of_birth)
			WHEN 'DAY' THEN dateadd(day, c_Age_Range.age_to, p_Patient.date_of_birth)
			END )
GO
GRANT SELECT
	ON [dbo].[v_Patient_Age_Ranges]
	TO [cprsystem]
GO

