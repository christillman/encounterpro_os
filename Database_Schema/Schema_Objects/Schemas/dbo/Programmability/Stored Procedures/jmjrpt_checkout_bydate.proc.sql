

CREATE PROCEDURE jmjrpt_checkout_bydate @ps_discharge_date varchar(10)
AS
Declare @dischargedate varchar(10)
Select @dischargedate = @ps_discharge_date
SELECT   co.description As Location,
       	 (p.last_name + ',' + p.first_name) As Patient,
         p.billing_id As Bill_ID,
	     user_short_name AS Provider,
         pe.billing_posted AS Post,
         pe.bill_flag As Bill,
         ce.description         
FROM p_Patient_Encounter pe (NOLOCK),
	 p_patient p (NOLOCK),
     c_office co (NOLOCK),
	 c_encounter_type ce (NOLOCK),
     c_User (NOLOCK)
  	WHERE 
	encounter_status = 'CLOSED'
	AND pe.discharge_date BETWEEN @dischargedate AND DATEADD( day, 1, @dischargedate)
	AND p.cpr_id = pe.cpr_id
    AND co.office_id = pe.office_id
    AND pe.attending_doctor = c_User.user_id 
    AND ce.encounter_type = pe.encounter_type 
    order by pe.office_id,pe.attending_doctor,pe.encounter_type