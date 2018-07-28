

CREATE PROCEDURE jmjrpt_test_sum_usage_by_super
	@ps_begin_date varchar(10),
	@ps_end_date varchar(10),
    @ps_observation_id varchar(24) 
AS
Declare @begin_date varchar(10), @end_date varchar(10),@observation_id varchar(24)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Select @observation_id = @ps_observation_id
SELECT i.treatment_description,
cu.user_full_name AS Supervisor,
Count(i.treatment_description) As Sum_Test
FROM p_treatment_item i WITH (NOLOCK)
INNER JOIN p_patient_encounter a WITH (NOLOCK) ON
            a.cpr_id = i.cpr_id 
AND         a.encounter_id = i.open_encounter_id
Left Outer join c_user cu with (nolock)
on a.supervising_doctor = cu.user_id
WHERE observation_id = @observation_id 
and i.treatment_status = 'CLOSED'
AND i.begin_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
group by cu.user_full_name,i.treatment_description
order by cu.user_full_name asc