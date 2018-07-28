

CREATE PROCEDURE jmjrpt_Encounters_for_today_by_provider
         @ps_user_id varchar(24)     
AS
Declare @user_id varchar(24)
Select @user_id = @ps_user_id
SELECT c_Office.description As Office
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
WHERE
p_patient_encounter.attending_doctor = @user_id
AND DATEDIFF(day, p_patient_encounter.encounter_date, getdate()) = 0
ORDER BY
c_Office.office_id,Name,Type