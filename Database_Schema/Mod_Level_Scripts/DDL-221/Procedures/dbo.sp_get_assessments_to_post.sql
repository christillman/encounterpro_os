
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_assessments_to_post]
Print 'Drop Procedure [dbo].[sp_get_assessments_to_post]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_assessments_to_post]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_assessments_to_post]
GO

-- Create Procedure [dbo].[sp_get_assessments_to_post]
Print 'Create Procedure [dbo].[sp_get_assessments_to_post]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_get_assessments_to_post    Script Date: 8/17/98 4:16:37 PM ******/
CREATE PROCEDURE sp_get_assessments_to_post (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int)
AS
SELECT	p_Encounter_Assessment.problem_id,
	p_Encounter_Assessment.assessment_sequence,
	p_Assessment.assessment_id 
FROM p_Encounter_Assessment (NOLOCK)
	JOIN p_Assessment (NOLOCK) ON p_Encounter_Assessment.problem_id = p_Assessment.problem_id
WHERE p_Encounter_Assessment.cpr_id = @ps_cpr_id
AND p_Encounter_Assessment.encounter_id = @pl_encounter_id
AND p_Assessment.cpr_id = @ps_cpr_id
AND p_Encounter_Assessment.assessment_billing_id is null
AND p_Encounter_Assessment.bill_flag = 'Y'
AND NOT EXISTS (SELECT *
		FROM p_Assessment a2
		WHERE a2.cpr_id = @ps_cpr_id
		AND a2.problem_id = p_Assessment.problem_id
		AND a2.diagnosis_sequence > p_Assessment.diagnosis_sequence)
ORDER BY p_Encounter_Assessment.assessment_sequence,
	p_Encounter_Assessment.problem_id

GO
GRANT EXECUTE
	ON [dbo].[sp_get_assessments_to_post]
	TO [cprsystem]
GO

