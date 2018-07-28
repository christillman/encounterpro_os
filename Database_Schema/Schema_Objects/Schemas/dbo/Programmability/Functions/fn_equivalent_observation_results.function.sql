CREATE FUNCTION fn_equivalent_observation_results (
	@ps_observation_id varchar(24),
	@pi_result_sequence smallint)

RETURNS @equivalent_results TABLE (
	observation_id varchar(24) NOT NULL,
	result_sequence smallint NOT NULL)
AS

BEGIN

DECLARE @ll_equivalence_group_id int

-------------------------------------------------------
-- Insert the original observation
-------------------------------------------------------
INSERT INTO @equivalent_results (
	observation_id,
	result_sequence)
VALUES (
	@ps_observation_id,
	@pi_result_sequence )

-------------------------------------------------------
-- Now get the equivalence observations, if any
-------------------------------------------------------
SELECT @ll_equivalence_group_id = equivalence_group_id
FROM c_Observation_Result r
	INNER JOIN c_Equivalence e
	ON r.id = e.object_id
WHERE r.observation_id = @ps_observation_id
AND r.result_sequence = @pi_result_sequence

IF @@ROWCOUNT = 1 AND @ll_equivalence_group_id IS NOT NULL
	INSERT INTO @equivalent_results (
		observation_id,
		result_sequence)
	SELECT DISTINCT r.observation_id,
					r.result_sequence
	FROM c_Equivalence e
		INNER JOIN c_Observation_Result r
		ON r.id = e.object_id
	WHERE e.equivalence_group_id = @ll_equivalence_group_id
	AND (r.observation_id <> @ps_observation_id OR r.result_sequence <> @pi_result_sequence)
	

RETURN
END

