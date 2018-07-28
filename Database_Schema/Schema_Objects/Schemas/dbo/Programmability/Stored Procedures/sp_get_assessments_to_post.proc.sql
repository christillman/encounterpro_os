/****** Object:  Stored Procedure dbo.sp_get_assessments_to_post    Script Date: 7/25/2000 8:44:14 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments_to_post    Script Date: 2/16/99 12:00:44 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments_to_post    Script Date: 10/26/98 2:20:31 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments_to_post    Script Date: 10/4/98 6:28:05 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments_to_post    Script Date: 9/24/98 3:05:59 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_assessments_to_post    Script Date: 8/17/98 4:16:37 PM ******/
CREATE PROCEDURE sp_get_assessments_to_post (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int)
AS
SELECT	p_Encounter_Assessment.problem_id,
	p_Encounter_Assessment.assessment_sequence,
	p_Assessment.assessment_id FROM p_Encounter_Assessment (NOLOCK),
	p_Assessment (NOLOCK)
WHERE p_Encounter_Assessment.cpr_id = @ps_cpr_id
AND p_Encounter_Assessment.encounter_id = @pl_encounter_id
AND p_Assessment.cpr_id = @ps_cpr_id
AND p_Encounter_Assessment.problem_id = p_Assessment.problem_id
AND p_Encounter_Assessment.assessment_billing_id is null
AND p_Encounter_Assessment.bill_flag = 'Y'
AND NOT EXISTS (SELECT *
		FROM p_Assessment a2
		WHERE a2.cpr_id = @ps_cpr_id
		AND a2.problem_id = p_Assessment.problem_id
		AND a2.diagnosis_sequence > p_Assessment.diagnosis_sequence)
ORDER BY p_Encounter_Assessment.assessment_sequence,
	p_Encounter_Assessment.problem_id

