
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_assessments]
Print 'Drop Procedure [dbo].[sp_get_assessments]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_assessments]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_assessments]
GO

-- Create Procedure [dbo].[sp_get_assessments]
Print 'Create Procedure [dbo].[sp_get_assessments]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.sp_get_assessments    Script Date: 8/17/98 4:16:37 PM ******/
CREATE PROCEDURE sp_get_assessments
(@ps_cpr_id varchar(12))
AS
SELECT p_Assessment.problem_id,
p_Assessment.diagnosis_sequence,
p_Assessment.assessment_id,
	 p_Assessment.assessment_type,
c_Assessment_Definition.assessment_category_id,
c_Assessment_Definition.description,
c_Assessment_Definition.icd10_code,
c_Assessment_Definition.auto_close,
p_Assessment.open_encounter_id,
p_Assessment.attachment_id,
p_Assessment.begin_date
FROM c_Assessment_Definition (NOLOCK)
JOIN p_Assessment (NOLOCK) ON c_Assessment_Definition.assessment_id = p_Assessment.assessment_id
WHERE p_Assessment.cpr_id = @ps_cpr_id
ORDER BY p_Assessment.problem_id

GO
GRANT EXECUTE
	ON [dbo].[sp_get_assessments]
	TO [cprsystem]
GO

