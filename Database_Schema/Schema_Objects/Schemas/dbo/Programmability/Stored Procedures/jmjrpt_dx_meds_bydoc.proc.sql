


CREATE PROCEDURE jmjrpt_dx_meds_bydoc
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
SELECT pa.assessment,ca.icd_9_code,count(pa.assessment)AS Count,d.common_name AS Rx
FROM p_Treatment_Item i WITH (NOLOCK)
INNER JOIN c_user usr WITH (NOLOCK) ON
	usr.user_id = i.ordered_by
INNER JOIN c_drug_definition d WITH (NOLOCK) ON
d.drug_id = i.drug_id
INNER JOIN p_assessment_treatment at WITH (NOLOCK) ON
	i.cpr_id = at.cpr_id
AND	i.treatment_id	= at.treatment_id
INNER JOIN p_assessment pa WITH (NOLOCK) ON
	at.cpr_id = pa.cpr_id
AND	at.problem_id = pa.problem_id
INNER JOIN c_assessment_definition ca WITH (NOLOCK) ON
	pa.assessment_id = ca.assessment_id
where i.treatment_type in ('MEDICATION','OFFICEMED')
AND i.ordered_by = @user_id
AND i.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
group by pa.assessment,ca.icd_9_code,d.common_name
order by pa.assessment asc, Count desc