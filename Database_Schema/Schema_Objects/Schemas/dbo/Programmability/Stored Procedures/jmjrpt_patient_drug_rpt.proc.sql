

CREATE PROCEDURE jmjrpt_patient_drug_rpt
	@ps_drug_id varchar(24)
AS
Declare @drug_id varchar(24)
Select @drug_id= @ps_drug_id
SELECT
 p.last_name
,p.first_name
,p.billing_id
,p.phone_number
,i.begin_date
,max(e.encounter_date) AS last_encounter      
FROM p_treatment_Item I WITH (NOLOCK) 
INNER JOIN P_patient p  WITH (NOLOCK) ON 
p.cpr_id = i.cpr_id
LEFT OUTER JOIN p_Patient_Encounter e WITH (NOLOCK)
ON i.cpr_id = e.cpr_id
WHERE
i.treatment_status is NULL
AND i.drug_id = @drug_id
AND e.encounter_status <> 'CANCELED'
AND  e.indirect_flag = 'D'
GROUP BY
 p.last_name
,p.first_name
,p.billing_id
,p.phone_number
,i.begin_date
ORDER BY
 p.last_name
,p.first_name