


CREATE PROCEDURE jmjrpt_patient_meds1
	@ps_cpr_id varchar(12)
AS
Declare @cpr_id varchar(12)
Select @cpr_id = @ps_cpr_id
SELECT distinct (COALESCE(pt.treatment_description,ptpi.progress_value)) As Medications_Prescribed_by_this_office,ptp.progress_value As Refill,
convert(varchar(10),max(pt.begin_date),101) AS Last_Prescribed      
FROM p_treatment_item pt WITH (NOLOCK)
inner JOIN p_Patient_Encounter e WITH (NOLOCK)
ON pt.cpr_id = e.cpr_id
Left Outer JOIN p_treatment_progress ptp WITH (NOLOCK)
ON pt.cpr_id = ptp.cpr_id
AND pt.treatment_id = ptp.treatment_id
AND ptp.progress_type = 'Refill'
Left Outer JOIN p_treatment_progress ptpi WITH (NOLOCK)
ON pt.cpr_id = ptpi.cpr_id
AND ptpi.progress_type = 'Instructions'
WHERE pt.cpr_id = @cpr_id 
AND pt.treatment_type = 'MEDICATION'
AND Isnull(pt.treatment_status,'Open') = 'Open' 
--or pt.treatment_status = '' or pt.treatment_status = 'MODIFIED'
AND Isnull(e.encounter_status,'Open') not like 'CANCEL%'
--AND pt.treatment_id in 
--(select treatment_id from
--p_assessment_treatment with (NOLOCK))
group by pt.treatment_description,ptpi.progress_value,ptp.progress_value
order by Medications_Prescribed_by_this_office