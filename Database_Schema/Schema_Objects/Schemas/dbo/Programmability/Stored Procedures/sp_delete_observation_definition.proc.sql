CREATE procedure sp_delete_observation_definition (
	@ps_observation_id varchar(24) )
AS
UPDATE c_observation
SET status = 'NA'
WHERE observation_id = @ps_observation_id

DELETE FROM u_Assessment_Treat_definition 
WHERE EXISTS (
	SELECT definition_id
	FROM u_Assessment_treat_def_attrib
	WHERE u_Assessment_treat_def_attrib.definition_id = u_Assessment_Treat_definition.definition_id
	AND attribute = 'observation_id'
	AND value = @ps_observation_id
	)

DELETE FROM u_Top_20
WHERE item_id = @ps_observation_id
AND top_20_code like 'TEST%'

