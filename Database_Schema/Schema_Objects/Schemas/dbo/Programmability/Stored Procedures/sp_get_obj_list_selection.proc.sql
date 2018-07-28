CREATE PROCEDURE dbo.sp_get_obj_list_selection (
	@ps_user_id varchar(24),
	@ps_root_category varchar(24),
	@ps_observation_id varchar(24) OUTPUT)
AS
--SELECT @ps_observation_id = observation_id
--FROM u_Observation_Tree_Defaults
--WHERE user_id = @ps_user_id
--AND root_category = @ps_root_category
--IF @@ROWCOUNT = 1
--	RETURN
--SELECT @ps_observation_id = observation_id
--FROM u_Observation_Tree_Defaults
--WHERE user_id = '!DEFAULT'
--AND root_category = @ps_root_category
--IF @@ROWCOUNT = 1
--	RETURN
SELECT @ps_observation_id = min(observation_id)
FROM c_Observation_Tree_Root
WHERE root_category = @ps_root_category


