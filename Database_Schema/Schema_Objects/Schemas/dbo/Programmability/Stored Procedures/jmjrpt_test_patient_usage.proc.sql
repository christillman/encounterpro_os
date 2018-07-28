

CREATE PROCEDURE jmjrpt_test_patient_usage
	@ps_begin_date varchar(10),
	@ps_end_date varchar(10),
        @ps_observation_id varchar(24) 
AS
Declare @begin_date varchar(10), @end_date varchar(10),@observation_id varchar(24)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Select @observation_id = @ps_observation_id
SELECT pp.last_name + ', ' + pp.first_name As Patient
,pp.billing_id AS Bill_ID
,Convert(varchar(10),i.result_expected_date,101) AS Date
FROM p_observation i WITH (NOLOCK), p_patient pp WITH (NOLOCK)
WHERE observation_id = @observation_id 
AND i.result_expected_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
AND pp.cpr_id = i.cpr_id
order by Patient,Date asc