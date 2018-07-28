


CREATE PROCEDURE jmjrpt_officemeds_bydoc
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
Select count(d.common_name)AS count, d.common_name As Med
FROM p_Treatment_Item i WITH (NOLOCK)
INNER JOIN c_user usr WITH (NOLOCK) ON
	usr.user_id = i.ordered_by
INNER JOIN p_assessment_treatment at WITH (NOLOCK) ON
	i.cpr_id = at.cpr_id
AND	i.treatment_id	= at.treatment_id
INNER JOIN c_drug_definition d WITH (NOLOCK) ON
d.drug_id = i.drug_id
where treatment_type = 'OFFICEMED'
AND i.ordered_by = @user_id
AND i.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
group by d.common_name
order by Count desc