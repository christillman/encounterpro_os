

CREATE PROCEDURE jmjrpt_observation_sum_usage
	@ps_begin_date varchar(10),
	@ps_end_date varchar(10),
        @ps_observation_id varchar(24) 
AS
Declare @begin_date varchar(10), @end_date varchar(10),@observation_id varchar(24)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Select @observation_id = @ps_observation_id
SELECT description,
Count(description) As Sum_Test
FROM p_observation i WITH (NOLOCK)
WHERE observation_id = @observation_id 
AND i.result_expected_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
Group BY description