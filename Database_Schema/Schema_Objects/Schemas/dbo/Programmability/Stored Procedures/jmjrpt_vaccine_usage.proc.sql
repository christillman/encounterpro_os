

CREATE PROCEDURE jmjrpt_vaccine_usage
	@ps_begin_date varchar(10),
	@ps_end_date varchar(10) 
AS
Declare @begin_date varchar(10), @end_date varchar(10)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
SELECT treatment_description,
maker_id, 
lot_number,
Count(treatment_description) As Count_Vaccine
FROM p_treatment_item i WITH (NOLOCK)
WHERE treatment_type = 'IMMUNIZATION' 
and treatment_description is not null
AND i.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
AND i.treatment_status = 'CLOSED'
group by treatment_description,maker_id,lot_number
order by treatment_description asc