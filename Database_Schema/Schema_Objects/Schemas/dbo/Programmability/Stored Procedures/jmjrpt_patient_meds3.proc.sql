


CREATE PROCEDURE jmjrpt_patient_meds3
	@ps_cpr_id varchar(12)
AS
Declare @cpr_id varchar(12)
Select @cpr_id = @ps_cpr_id
SELECT distinct cd.common_name
FROM p_treatment_item pt WITH (NOLOCK)
inner join c_drug_definition cd WITH (NOLOCK) ON
cd.drug_id = pt.drug_id 
WHERE cpr_id = @cpr_id 
AND treatment_type = 'MEDICATION'
AND isnull(treatment_status,'Open') not in ('CLOSED','CANCELLED')  
AND treatment_id not in 
(select treatment_id from
p_assessment_treatment with (NOLOCK))