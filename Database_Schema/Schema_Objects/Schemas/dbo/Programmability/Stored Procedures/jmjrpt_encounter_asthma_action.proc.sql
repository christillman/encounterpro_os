


CREATE PROCEDURE jmjrpt_encounter_asthma_action
	@ps_cpr_id varchar(12),
	@pi_encounter_id integer,
        @ps_zone varchar(24) 
AS
Declare @cpr_id varchar(12), @zone varchar(24)
Declare @encounter_id integer
Select @cpr_id = @ps_cpr_id
Select @encounter_id = @pi_encounter_id
Select @zone = @ps_zone
SELECT 	
	p.drug_id
	,c.[description]
	,a.[description]
	,p.dose_amount
	,p.dose_unit
	,af.[description]
	,tp.progress_value
FROM p_treatment_item p WITH (NOLOCK)
Left outer JOIN c_package c WITH (NOLOCK)
ON c.package_id = p.package_id
Left outer JOIN c_administration_method a WITH (NOLOCK)
ON c.administer_method = a.administer_method  
Left outer JOIN c_administration_frequency af  WITH (NOLOCK) 
ON af.administer_frequency = p.administer_frequency
Left outer JOIN c_drug_package dp WITH (NOLOCK)
ON dp.drug_id = p.drug_id AND dp.package_id = p.package_id
INNER JOIN p_treatment_progress tp WITH (NOLOCK)
ON p.treatment_id = tp.treatment_id
AND progress_key = @zone
AND current_flag = 'Y'
WHERE 
p.cpr_id = @cpr_id
--AND p.open_encounter_id = @pi_encounter_id