

CREATE PROCEDURE jmjrpt_assessment_age
	@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
	,@ps_dob_begin_date varchar(10)
	,@ps_dob_end_date varchar(10)
AS
Declare @begin_date varchar(10),@end_date varchar(10)
Declare @dob_begin_date varchar(10),@dob_end_date varchar(10)
Select @begin_date= @ps_begin_date
Select @end_date= @ps_end_date
Select @dob_begin_date= @ps_dob_begin_date
Select @dob_end_date= @ps_dob_end_date
SELECT count(pa.assessment) AS Count,pa.assessment,ca.icd_9_code  
FROM p_assessment pa WITH (NOLOCK)
INNER JOIN p_patient pp WITH (NOLOCK) ON
	pp.cpr_id = pa.cpr_id
LEFT OUTER JOIN c_assessment_definition ca WITH (NOLOCK) ON
	pa.assessment_id = ca.assessment_id 
AND Isnull(pa.assessment_status,'Open') <> 'CANCELLED'
AND pp.date_of_birth BETWEEN @dob_begin_date AND DATEADD( day, 1, @dob_end_date)
where pa.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
group by pa.assessment,ca.icd_9_code
order by Count desc

