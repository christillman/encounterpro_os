

CREATE PROCEDURE jmjrpt_drug_allergy
	@ps_drug_allergy varchar(24)
     
AS
Declare @drug_allergy varchar(24)
select @drug_allergy = @ps_drug_allergy

If @drug_allergy = '%drug_allergy%'
begin
	select ca.description, cd.generic_name,cd.common_name
	from c_allergy_drug with (nolock),c_assessment_definition ca with (nolock), c_drug_definition cd with (nolock)
	where c_allergy_drug.assessment_id = ca.assessment_id
	and c_allergy_drug.drug_id = cd.drug_id
	order by ca.description, cd.generic_name
end
else
begin
	select ca.description, cd.generic_name,cd.common_name
	from c_allergy_drug with (nolock),c_assessment_definition ca with (nolock), c_drug_definition cd with (nolock)
	where c_allergy_drug.assessment_id = @drug_allergy
	AND c_allergy_drug.assessment_id = ca.assessment_id
	and c_allergy_drug.drug_id = cd.drug_id
	order by ca.description, cd.generic_name
end