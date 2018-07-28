


CREATE PROCEDURE jmjrpt_script_audit
	@ps_begin_date varchar(10)
	,@ps_end_date varchar(10) 
AS
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT convert(varchar(10),pt.begin_date,101) AS Issued_on
	,p.last_name + ', ' + p.first_name AS Name
	,pt.treatment_description AS Medication
	,Isnull(pt.treatment_status,'Open') As Status     
FROM p_treatment_item pt WITH (NOLOCK)
inner JOIN p_Patient p WITH (NOLOCK)
ON pt.cpr_id = p.cpr_id
WHERE pt.begin_date >= @begin_date AND
pt.begin_date < DATEADD(day, 1, @end_date)
AND treatment_type = 'MEDICATION'
AND treatment_id in 
(select treatment_id from
p_assessment_treatment with (NOLOCK))
order by Issued_on,Name,pt.treatment_description