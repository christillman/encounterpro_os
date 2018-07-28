

CREATE PROCEDURE jmjrpt_vaccine_sum_usage
	@ps_begin_date varchar(10),
	@ps_end_date varchar(10) 
AS
Declare @begin_date varchar(10), @end_date varchar(10)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT treatment_description,
Count(treatment_description) As Sum_Vaccine
FROM p_treatment_item i WITH (NOLOCK)
WHERE treatment_type = 'IMMUNIZATION' 
and treatment_description is not null
and i.treatment_status = 'CLOSED'
AND i.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
group by treatment_description
order by treatment_description asc