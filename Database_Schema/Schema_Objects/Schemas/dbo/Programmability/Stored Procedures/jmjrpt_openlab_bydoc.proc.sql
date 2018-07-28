


CREATE PROCEDURE jmjrpt_openlab_bydoc
	@ps_user_id varchar(24)
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)     
AS
Declare @user_id varchar(24)
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @user_id = @ps_user_id
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT 
	 p.billing_id
	,convert(varchar(10),i.begin_date,101) AS For_Date 	
	,i.treatment_description
	,pa.assessment
	,ca.icd_9_code 
FROM	 p_Treatment_Item i WITH (NOLOCK)
INNER JOIN P_patient p WITH (NOLOCK) ON 
	p.cpr_id = i.cpr_id
INNER JOIN p_patient_encounter a WITH (NOLOCK) ON
	a.cpr_id = i.cpr_id 
AND	a.encounter_id = i.open_encounter_id
INNER JOIN c_user usr WITH (NOLOCK) ON
	usr.user_id = a.attending_doctor
INNER JOIN c_Treatment_Type t WITH (NOLOCK) ON
	i.treatment_type = t.treatment_type
LEFT OUTER JOIN p_assessment_treatment at WITH (NOLOCK) ON
	i.cpr_id = at.cpr_id
AND	i.treatment_id	= at.treatment_id
LEFT OUTER JOIN p_assessment pa WITH (NOLOCK) ON
	at.cpr_id = pa.cpr_id
AND	at.problem_id = pa.problem_id
LEFT OUTER JOIN c_assessment_definition ca WITH (NOLOCK) ON
	pa.assessment_id = ca.assessment_id
WHERE
	(i.treatment_status IS NULL OR i.treatment_status NOT IN ('CLOSED','MODIFIED','CANCELLED')) 
AND 	t.observation_type = 'Lab/Test'
AND 	a.attending_doctor = @user_id
AND 	i.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date) 
ORDER BY
	 i.begin_date