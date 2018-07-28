


CREATE PROCEDURE jmjrpt_flow_rpt
	@ps_cpr_id varchar(12)
	,@ps_observation_id varchar(24)
AS
Declare @cpr_id varchar(12)
Declare @observation_id varchar(24)
Select @cpr_id = @ps_cpr_id
Select @observation_id = @ps_observation_id
SELECT convert(varchar(10),p_Observation_Result.result_date_time,101) AS RecordDate,
c_Observation_1.description,p_Observation_Result.result_value,
p_Observation_Result.result AS UOM
FROM c_Observation WITH (NOLOCK)
INNER JOIN c_Observation_Tree ON c_Observation.observation_id = c_Observation_Tree.parent_observation_id
INNER JOIN c_Observation c_Observation_1 ON dbo.c_Observation_Tree.child_observation_id = c_Observation_1.observation_id
INNER JOIN p_Observation_Result ON c_Observation_1.observation_id = p_Observation_Result.observation_id
WHERE (c_Observation.observation_id = @observation_id)
AND (p_Observation_Result.cpr_id = @cpr_id)
AND (p_Observation_Result.result_type = 'PERFORM')
ORDER BY p_Observation_Result.result_date_time desc