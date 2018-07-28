CREATE PROCEDURE sp_delete_procedure_definition (
	@ps_procedure_id varchar(24) )
AS
UPDATE c_Procedure
SET status = 'NA'
WHERE procedure_id = @ps_procedure_id

DELETE FROM u_Assessment_Treat_definition 
WHERE EXISTS (
	SELECT definition_id
	FROM u_Assessment_treat_def_attrib
	WHERE u_Assessment_treat_def_attrib.definition_id = u_Assessment_Treat_definition.definition_id
	AND attribute = 'procedure_id'
	AND value = @ps_procedure_id
	)

DELETE FROM u_Top_20
WHERE item_id = @ps_procedure_id
AND top_20_code like '%PROCEDURE%'

