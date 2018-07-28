

CREATE PROCEDURE jmjrpt_test_sum_usage
	@ps_begin_date varchar(10),
	@ps_end_date varchar(10),
        @ps_observation_id varchar(24) 
AS
Declare @begin_date varchar(10), @end_date varchar(10),@observation_id varchar(24)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Select @observation_id = @ps_observation_id
SELECT treatment_description,
Count(treatment_description) As Sum_Test
FROM p_treatment_item i WITH (NOLOCK)
WHERE observation_id = @observation_id 
and i.treatment_status = 'CLOSED'
AND i.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
group by treatment_description
order by treatment_description asc