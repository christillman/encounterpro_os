CREATE FUNCTION fn_equivalent_observations (
	@ps_observation_id varchar(24))

RETURNS @equivalent_observations TABLE (
	observation_id varchar(24) NOT NULL)
AS

BEGIN

DECLARE @ll_equivalence_group_id int


-------------------------------------------------------
-- Insert the original observation
-------------------------------------------------------
INSERT INTO @equivalent_observations (
	observation_id )
VALUES (
	@ps_observation_id)

-------------------------------------------------------
-- Now get the equivalence observations, if any
-------------------------------------------------------
SELECT @ll_equivalence_group_id = equivalence_group_id
FROM c_Observation o
	INNER JOIN c_Equivalence e
	ON o.id = e.object_id
WHERE o.observation_id = @ps_observation_id

IF @@ROWCOUNT = 1 AND @ll_equivalence_group_id IS NOT NULL
	INSERT INTO @equivalent_observations (
		observation_id )
	SELECT DISTINCT observation_id
	FROM c_Equivalence e
		INNER JOIN c_Observation o
		ON o.id = e.object_id
	WHERE e.equivalence_group_id = @ll_equivalence_group_id
	AND o.observation_id <> @ps_observation_id
	

RETURN
END

