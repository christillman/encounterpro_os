


CREATE PROCEDURE jmjrpt_patient_imm_elsewhere
	@ps_cpr_id varchar(12)
AS
Declare @cpr_id varchar(12)
Select @cpr_id = @ps_cpr_id
SELECT convert(varchar(10),b.begin_date,101)As ReportDate,
treatment_description, 
maker_id, 
lot_number,
convert(varchar(10),b.expiration_date,101) As Expiration,
cl.description As location,
pp2.progress_value AS Site,
cu2.user_short_name AS Entered_by 
FROM p_treatment_item b WITH (NOLOCK)
INNER JOIN 
p_treatment_progress pp WITH (NOLOCK)
ON  pp.cpr_id = b.cpr_id 
AND pp.treatment_id = b.treatment_id
AND progress_type = 'CLOSED'
INNER JOIN 
p_patient_encounter a WITH (NOLOCK)
ON a.encounter_id =  b.open_encounter_id 
AND a.cpr_id = b.cpr_id 
Left Outer JOIN c_location cl with (NOLOCK)
ON b.location = cl.location
Left Outer JOIN 
p_treatment_progress pp2 WITH (NOLOCK)
ON  pp2.cpr_id = b.cpr_id 
AND pp2.treatment_id = b.treatment_id
AND pp2.progress_type = 'PROPERTY'
AND pp2.progress_key = 'Place Administered'
Left Outer JOIN c_user cu2 with (NOLOCK)
ON pp.user_id = cu2.user_id
WHERE a.cpr_id = @cpr_id 
and treatment_type = 'IMMUNIZATION' 
and treatment_description is not null 
and procedure_id is null
and IsNull(treatment_status,'Open') = 'CLOSED'
order by treatment_description asc,b.begin_date desc