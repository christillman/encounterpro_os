


CREATE PROCEDURE jmjrpt_Patients_with_Dx
        @ps_assessment_id varchar(24)   
	,@ps_begin_date varchar(10)
	,@ps_end_date varchar(10)
AS
Declare @begin_date varchar(10)
Declare @end_date varchar(10)
Declare @assessment_id varchar(24)
Select @begin_date = @ps_begin_date
Select @end_date = @ps_end_date
Select @assessment_id = @ps_assessment_id
SELECT distinct 
p_Patient.billing_id As Bill_Id,
p_Patient.last_name + ',' +p_Patient.first_name AS Patient,
IsNULL(c_user.user_short_name,'') as Diagnosed_by, 
convert(varchar(10),p_Assessment.begin_date,101) AS Begin_Dx,
convert(varchar(10),p_Assessment.end_date,101) AS End_Dx,
IsNULL(p_Assessment.assessment_status,'Open') as Status
FROM
p_Assessment(NOLOCK),
p_Patient(NOLOCK),
p_Patient_Encounter(NOLOCK),
c_user(NOLOCK)
WHERE
p_Patient.cpr_id = p_Assessment.cpr_id AND
Isnull(p_Assessment.assessment_status,'Open') <> 'CANCELLED' AND
p_Assessment.assessment_id = @assessment_id AND
c_user.user_id = p_Assessment.diagnosed_by AND
p_Assessment.open_encounter_id = p_patient_encounter.encounter_id AND
p_Assessment.cpr_id = p_patient_encounter.cpr_id AND
p_patient_encounter.encounter_date BETWEEN @begin_date AND DATEADD(day,1,@end_date)
ORDER BY
Bill_Id,Patient,Begin_Dx,End_Dx,Status,Diagnosed_by