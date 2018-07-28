CREATE PROCEDURE sp_get_observation_sources
	(
	@pl_computer_id int,
	@ps_observation_id varchar(24)
	)
AS

DECLARE @ls_composite_flag char(1)

SELECT @ls_composite_flag = composite_flag
FROM c_Observation
WHERE observation_id = @ps_observation_id

IF @@ROWCOUNT <> 1
	BEGIN
	RETURN
	END

IF @ls_composite_flag = 'Y'
	SELECT DISTINCT s.external_source,
				s.description,
				s.component_id
	FROM c_External_Source s,
		c_External_Observation o,
		c_Observation_Tree t,
		o_Computer_External_Source x
	WHERE s.external_source = o.external_source
	AND o.observation_id = t.child_observation_id
	AND t.parent_observation_id = @ps_observation_id
	AND x.external_source = s.external_source
	AND x.computer_id = @pl_computer_id
ELSE
	SELECT DISTINCT s.external_source,
				s.description,
				s.component_id
	FROM c_External_Source s,
		c_External_Observation o,
		o_Computer_External_Source x
	WHERE s.external_source = o.external_source
	AND o.observation_id = @ps_observation_id
	AND x.external_source = s.external_source
	AND x.computer_id = @pl_computer_id



