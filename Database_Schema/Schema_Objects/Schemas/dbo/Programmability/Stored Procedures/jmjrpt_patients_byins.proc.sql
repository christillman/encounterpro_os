



CREATE PROCEDURE jmjrpt_patients_byins
    @ps_begin_date varchar(10),
    @ps_end_date varchar(10)
AS
Declare @begin_date varchar(10),@end_date varchar(10)
Select @begin_date= @ps_begin_date
Select @end_date= @ps_end_date

select c_authority.name AS Insurance,
Convert(varchar(10),encounter_date,101) As RecordDate,
p_patient.last_name + ', ' + p_patient.first_name AS Patient
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
order by insurance asc,recorddate asc,patient asc