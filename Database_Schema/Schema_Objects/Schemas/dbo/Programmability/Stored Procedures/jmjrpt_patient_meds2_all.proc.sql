


CREATE PROCEDURE jmjrpt_patient_meds2_all
	@ps_cpr_id varchar(12)
AS
Declare @cpr_id varchar(12)
Select @cpr_id = @ps_cpr_id
SELECT distinct pt.treatment_description AS Medication_reported_by_Patient,
convert(varchar(10),max(e.encounter_date),101) AS Reported_on
,ISNULL(pt.treatment_status,'OPEN') As Status      
FROM p_treatment_item pt WITH (NOLOCK)
inner JOIN p_Patient_Encounter e WITH (NOLOCK)
ON pt.cpr_id = e.cpr_id
WHERE pt.cpr_id = @cpr_id
AND treatment_type = 'MEDICATION'
AND (Isnull(pt.treatment_status,'OPEN') = 'OPEN') 
or pt.treatment_status IN ('MODIFIED','CLOSED','CANCELLED')
AND e.encounter_status <> 'CANCELED'
AND treatment_id not in 
(select treatment_id from
p_assessment_treatment with (NOLOCK))
group by pt.treatment_description,pt.treatment_status