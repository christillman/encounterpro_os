/****** Object:  Stored Procedure dbo.sp_get_assessments    Script Date: 7/25/2000 8:44:14 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments    Script Date: 2/16/99 12:00:44 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments    Script Date: 10/26/98 2:20:31 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments    Script Date: 10/4/98 6:28:05 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments    Script Date: 9/24/98 3:05:59 PM ******/
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
c_Assessment_Definition.icd_9_code,
c_Assessment_Definition.auto_close,
p_Assessment.open_encounter_id,
p_Assessment.attachment_id,
p_Assessment.begin_date
FROM c_Assessment_Definition (NOLOCK),
p_Assessment (NOLOCK) WHERE	c_Assessment_Definition.assessment_id = p_Assessment.assessment_id
AND	p_Assessment.cpr_id = @ps_cpr_id
ORDER BY p_Assessment.problem_id

