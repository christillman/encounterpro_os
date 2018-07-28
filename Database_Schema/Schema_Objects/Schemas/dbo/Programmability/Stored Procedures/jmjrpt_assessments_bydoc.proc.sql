



CREATE PROCEDURE jmjrpt_assessments_bydoc
	@ps_user_id varchar(24)
    ,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10),@end_date varchar(10)
Declare @user_id varchar(24)
Select @begin_date= @ps_begin_date
Select @end_date= @ps_end_date
Select @user_id = @ps_user_id
SELECT count(pa.assessment)AS Count, pa.assessment,ca.icd_9_code AS ICD_9,
ca.risk_level as EM_Risk, ca.complexity as EM_Complexity
FROM p_assessment pa WITH (NOLOCK)
INNER JOIN c_user usr WITH (NOLOCK) ON
	usr.user_id = pa.diagnosed_by
LEFT OUTER JOIN c_assessment_definition ca WITH (NOLOCK) ON
	pa.assessment_id = ca.assessment_id
where Isnull(pa.assessment_status,'Open') <> 'CANCELLED'
AND usr.user_id = @user_id
AND pa.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
group by pa.assessment,ca.icd_9_code,ca.risk_level,ca.complexity 
order by Count desc,pa.assessment asc

