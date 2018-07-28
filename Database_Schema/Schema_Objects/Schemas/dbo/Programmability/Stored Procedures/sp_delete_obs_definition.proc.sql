CREATE PROCEDURE sp_delete_obs_definition (
	@ps_observation_id varchar(24) )
AS
UPDATE c_Observation
SET status = "NA"
WHERE observation_id = @ps_observation_id
DELETE FROM u_Top_20
WHERE item_id = @ps_observation_id
AND top_20_code like 'TEST%'

