


CREATE PROCEDURE jmjrpt_observation_em
	@ps_observation_id varchar(24)     
AS
Declare @observation_id varchar(24)
Select @observation_id = @ps_observation_id
SELECT distinct co.description,co.composite_flag,COALESCE(eoe.em_component,eoe1.em_component) AS EM_Component,COALESCE(emt.description,emt1.description) AS EM_Type
FROM c_observation co WITH (NOLOCK)
Left outer join em_Observation_element eoe WITH (NOLOCK) ON
eoe.observation_id = co.observation_id
Left outer join em_type emt WITH (NOLOCK) ON
emt.em_component = eoe.em_component
AND emt.em_type = eoe.em_type
Left outer join c_Observation_Tree WITH (NOLOCK) ON 
c_Observation_Tree.parent_observation_id = co.observation_id
Left outer join c_Observation c_Observation_1 WITH (NOLOCK) ON 
c_Observation_Tree.child_observation_id = c_Observation_1.observation_id
Left outer join em_Observation_element eoe1 WITH (NOLOCK) ON
eoe1.observation_id = c_Observation_Tree.child_observation_id
Left outer join em_type emt1 WITH (NOLOCK) ON
emt1.em_component = eoe1.em_component
AND emt1.em_type = eoe1.em_type
WHERE co.observation_id = @observation_id