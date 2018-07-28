CREATE PROCEDURE jmj_observation_allergen_list (
	@ps_observation_id varchar(24) )

AS


SELECT DISTINCT d.drug_id, d.common_name, CAST(0 AS int) as selected_flag
FROM c_XML_Code x
	INNER JOIN c_Drug_Definition d
	ON x.epro_id = d.drug_id
WHERE x.code = @ps_observation_id
AND x.owner_id = 0
AND x.code_domain = 'allergen_observation_id'
AND x.epro_domain = 'allergen_drug_id'


