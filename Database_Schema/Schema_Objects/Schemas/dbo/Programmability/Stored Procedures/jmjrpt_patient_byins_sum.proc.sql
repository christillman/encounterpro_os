﻿


CREATE PROCEDURE jmjrpt_patient_byins_sum
	@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Declare @Count_sum decimal(10,3)

select c_authority.name,
count(p_patient_encounter.encounter_id) As Count
from 
p_patient_encounter(NOLOCK)
,p_patient  (NOLOCK)
left outer join p_patient_authority WITH (NOLOCK) 
On p_patient_authority.cpr_id = p_patient.cpr_id
and p_patient_authority.authority_type = 'PAYOR'
left outer join c_authority WITH (NOLOCK)
On c_authority.authority_id = p_patient_authority.authority_id
where p_patient_encounter.encounter_status = 'CLOSED'
and p_patient.cpr_id = p_patient_encounter.cpr_id
AND p_patient_encounter.encounter_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
Group by c_authority.name
order by c_authority.name