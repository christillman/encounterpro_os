CREATE PROCEDURE sp_get_assessments_treatments (
	@ps_cpr_id varchar(12)
	)
AS
SELECT
	 p_Assessment.diagnosis_sequence
	,p_Assessment.assessment_type
	,p_Assessment.assessment_id
	,p_Assessment.assessment
	,p_Assessment.begin_date as assessment_begin_date
	,p_Assessment.assessment_status
	,p_Assessment.end_date as assessment_end_date
	,p_Assessment.close_encounter_id as assessment_close_encounter_id
	,p_Assessment.cpr_id
	,p_Assessment.problem_id
	,p_Assessment.open_encounter_id as assessment_open_encounter_id
	,p_Assessment.diagnosed_by
	,CONVERT(int, NULL) as attachment_id
	,p_Assessment_Treatment.treatment_id
	,b.open_encounter_id as treatment_open_encounter_id
	,b.treatment_type
	,b.treatment_description
	,b.treatment_status
	,b.end_date  as treatment_end_date
	,b.close_encounter_id as treatment_close_encounter_id
	,b.begin_date as treatment_begin_date
	,c_Assessment_Type.icon_open
	,c_Assessment_Type.icon_closed
	,selected_flag=0
	,treatment_icon=convert(varchar(128), '')
FROM p_Assessment WITH (NOLOCK)
INNER JOIN c_Assessment_Type
ON p_Assessment.assessment_type = c_Assessment_Type.assessment_type 
LEFT OUTER JOIN p_Assessment_Treatment WITH (NOLOCK)
ON	p_Assessment.cpr_id = p_Assessment_Treatment.cpr_id
AND	p_Assessment.problem_id = p_Assessment_Treatment.problem_id
LEFT OUTER JOIN p_treatment_item b WITH (NOLOCK)
ON 	p_Assessment_Treatment.treatment_id = b.treatment_id
and 	p_Assessment_Treatment.cpr_id = b.cpr_id    
WHERE
	p_Assessment.cpr_id = @ps_cpr_id
order by
	p_assessment_treatment.treatment_id  
     
