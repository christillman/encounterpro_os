


CREATE PROCEDURE jmjrpt_patient_checkout_bydate @ps_discharge_date varchar(10)
AS
Declare @dischargedate varchar(10)
Select @dischargedate = @ps_discharge_date
SELECT 
        (p.last_name + ',' + p.first_name) As Patient,
         p.billing_id As Bill_ID,
         ce.description,
         pe.bill_flag,
         Convert(varchar(10),pe.encounter_date,101) As StartDate,
         Convert(varchar(10),pe.discharge_date,101) As CloseDate,
	(cu1.user_short_name) As Created,
	cu2.user_short_name As Attending
FROM p_Patient_Encounter pe (NOLOCK)
Inner join p_patient p with (NOLOCK)
On p.cpr_id = pe.cpr_id
Inner Join  c_encounter_type ce  with (NOLOCK)
ON ce.encounter_type = pe.encounter_type
Left Outer Join  c_User cu1  With (NOLOCK)
On cu1.user_id  = pe.created_by
Left Outer Join  c_User cu2  With (NOLOCK)
On cu2.user_id  = pe.attending_doctor
Where 
	Isnull(encounter_status,'Open') = 'CLOSED'
	AND pe.discharge_date BETWEEN @dischargedate AND DATEADD( day, 1, @dischargedate)
    order by Patient