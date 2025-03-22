
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_equivalent_observation_results]
Print 'Drop Function [dbo].[fn_equivalent_observation_results]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_equivalent_observation_results]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_equivalent_observation_results]
GO

-- Create Function [dbo].[fn_equivalent_observation_results]
Print 'Create Function [dbo].[fn_equivalent_observation_results]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_equivalent_observation_results (
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

IF @ll_equivalence_group_id IS NOT NULL
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

GO
GRANT SELECT ON [dbo].[fn_equivalent_observation_results] TO [cprsystem]
GO

