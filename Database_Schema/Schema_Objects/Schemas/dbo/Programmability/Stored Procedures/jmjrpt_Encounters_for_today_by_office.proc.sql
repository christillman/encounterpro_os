

CREATE PROCEDURE jmjrpt_Encounters_for_today_by_office 
         @ps_office_id varchar(24)     
AS
Declare @office_id varchar(24)
Select @office_id = @ps_office_id
SELECT c_user.user_short_name As Provider
       ,p_patient.first_name + ', ' + p_patient.last_name AS Name
       ,c_encounter_type.description As Type
       ,p_patient_encounter.encounter_description as chief_complaint
FROM
p_patient_encounter(NOLOCK)
inner join p_patient with (NOLOCK)
ON p_patient_encounter.cpr_id = p_patient.cpr_id
inner join c_encounter_type with (NOLOCK)
ON p_patient_encounter.encounter_type = c_encounter_type.encounter_type
inner join c_Office with (NOLOCK)
ON p_patient_encounter.office_id = c_Office.office_id
inner join c_user with (NOLOCK)
ON p_patient_encounter.attending_doctor = c_user.user_id
WHERE
p_patient_encounter.office_id = @office_id
AND DATEDIFF(day, p_patient_encounter.encounter_date, getdate()) = 0
ORDER BY
Provider,Name,Type