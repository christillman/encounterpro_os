﻿



CREATE PROCEDURE jmjrpt_patients_byvisit_sum
    @ps_begin_date varchar(10),
    @ps_end_date varchar(10)
AS
Declare @begin_date varchar(10),@end_date varchar(10)
Select @begin_date= @ps_begin_date
Select @end_date= @ps_end_date

SELECT  cp.description AS Visit,
cp.cpt_code as CPT,
count(p_patient_encounter.encounter_id) As Count
FROM 
p_patient_encounter (NOLOCK)
,p_patient (NOLOCK)
,c_procedure cp (NOLOCK)
,p_Encounter_Charge (NOLOCK)
WHERE p_patient_encounter.encounter_status = 'CLOSED'
AND p_patient_encounter.encounter_date BETWEEN @begin_date AND DATEADD( day, 1, @end_date)
AND p_patient.cpr_id = p_patient_encounter.cpr_id
AND p_Encounter_Charge.cpr_id = p_patient_encounter.cpr_id
AND p_Encounter_Charge.encounter_id = p_patient_encounter.encounter_id
AND p_Encounter_Charge.bill_flag = 'Y' 
AND cp.procedure_id = p_Encounter_Charge.procedure_id
AND cp.procedure_category_id = 'VISIT'
group by cp.description,cp.cpt_code 
order by Visit asc