
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_hm_metric_observation_results]
Print 'Drop Function [dbo].[fn_hm_metric_observation_results]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_hm_metric_observation_results]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_hm_metric_observation_results]
GO

-- Create Function [dbo].[fn_hm_metric_observation_results]
Print 'Create Function [dbo].[fn_hm_metric_observation_results]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_hm_metric_observation_results (
	@ps_observation_id varchar(24))

RETURNS @results TABLE (
	result_sequence smallint NOT NULL,
	result varchar(80) NOT NULL,
	sort_sequence int NULL)


AS
BEGIN

INSERT INTO @results (
	result_sequence ,
	result ,
	sort_sequence )
SELECT r.result_sequence,   
		r.result,   
		r.sort_sequence
FROM c_Observation o1
	INNER JOIN c_Equivalence e1
	ON o1.id = e1.object_id
	INNER JOIN c_Equivalence e2
	ON e1.equivalence_group_id = e2.equivalence_group_id
	INNER JOIN c_Observation o2
	ON e2.object_id = o2.id
	INNER JOIN c_Observation_Result r
	ON o2.observation_id = r.observation_id
	INNER JOIN c_Unit u
	ON r.result_unit = u.unit_id
WHERE o1.observation_id = @ps_observation_id
AND r.status = 'OK'
AND r.result_type = 'PERFORM'
AND u.unit_type = 'Number'

IF @@ROWCOUNT = 0
	INSERT INTO @results (
		result_sequence ,
		result ,
		sort_sequence )
	SELECT r.result_sequence,   
			r.result,   
			r.sort_sequence
	FROM c_Observation_Result r
		INNER JOIN c_Unit u
		ON r.result_unit = u.unit_id
	WHERE r.observation_id = @ps_observation_id
	AND r.status = 'OK'
	AND r.result_type = 'PERFORM'
	AND u.unit_type = 'Number'
	


RETURN
END
GO
GRANT SELECT ON [dbo].[fn_hm_metric_observation_results] TO [cprsystem]
GO

