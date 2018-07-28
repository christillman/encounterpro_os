



CREATE PROCEDURE jmjrpt_patients_with_ins
    @ps_authority_id varchar(24)
AS
Declare @authority_id varchar(24)
Select @authority_id = @ps_authority_id
Select
p_patient.last_name + ', ' + p_patient.first_name AS Patient,
billing_id as Bill_ID,
Convert(varchar(10),date_of_birth,101) As DOB
from p_patient  (NOLOCK)
inner join p_patient_authority WITH (NOLOCK) 
On p_patient_authority.cpr_id = p_patient.cpr_id
and p_patient_authority.authority_type = 'PAYOR'
and p_patient_authority.authority_id = @authority_id
and p_patient_authority.status = 'OK'
order by Patient asc,Bill_ID asc