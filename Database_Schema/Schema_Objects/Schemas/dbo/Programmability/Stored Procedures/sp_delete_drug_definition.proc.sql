CREATE PROCEDURE sp_delete_drug_definition (
	@ps_drug_id varchar(24) )
AS
UPDATE c_Drug_Definition
SET status = 'NA'
WHERE drug_id = @ps_drug_id
DELETE FROM u_Top_20
WHERE item_id = @ps_drug_id
AND top_20_code like 'MEDICATION%'
DELETE FROM u_Top_20
WHERE item_id = @ps_drug_id
AND top_20_code like 'OFFICEMED%'
DELETE FROM u_Assessment_Treat_definition
WHERE EXISTS (
	SELECT definition_id
	FROM u_Assessment_treat_def_attrib
	WHERE attribute = 'drug_id'
	AND value = @ps_drug_id
	AND u_assessment_treat_def_attrib.definition_id = u_assessment_treat_definition.definition_id
	)

