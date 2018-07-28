


CREATE PROCEDURE jmjrpt_patient_takehome_meds
	@ps_cpr_id varchar(12)
AS
Declare @cprid varchar(12)
Select @cprid = @ps_cpr_id

SELECT  distinct cd.common_name as Common_name
	,cd.generic_name as Generic_name
	,Cast(cp.administer_per_dose AS varchar(10)) + cp.administer_unit as Package	
	,pt.dose_amount as Dose_amount
	,cu.description as Dose_unit
	,caf.description as Frequency
FROM p_treatment_item pt WITH (NOLOCK)
inner join c_drug_definition cd WITH (NOLOCK) 
ON cd.drug_id = pt.drug_id
left outer join c_unit cu WITH (NOLOCK) 
ON cu.unit_id = pt.dose_unit
left outer join c_package cp WITH (NOLOCK) 
ON cp.package_id = pt.package_id
left outer join c_administration_frequency caf WITH (NOLOCK) 
ON caf.administer_frequency = pt.administer_frequency
WHERE pt.cpr_id = @cprid
AND treatment_type = 'MEDICATION'
AND Isnull(treatment_status,'Open') = 'Open'
ORDER BY  cd.common_name