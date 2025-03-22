
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_treatment_observed_by]
Print 'Drop Procedure [dbo].[sp_get_treatment_observed_by]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_treatment_observed_by]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_treatment_observed_by]
GO

-- Create Procedure [dbo].[sp_get_treatment_observed_by]
Print 'Create Procedure [dbo].[sp_get_treatment_observed_by]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_get_treatment_observed_by (
	@ps_cpr_id varchar(24),
	@pl_treatment_id int,
	@pl_encounter_id int,
	@ps_user_id varchar(24) 
	)
AS

DECLARE @ll_count int
	, @ls_last_observed_by varchar(24)
	, @ls_reviewed char(1)

SELECT TOP 1
	@ls_last_observed_by = observed_by
FROM p_Treatment_Item t
	INNER JOIN p_Observation o
	ON t.cpr_id = o.cpr_id
	AND t.treatment_id = o.treatment_id
WHERE t.cpr_id = @ps_cpr_id
AND t.treatment_id = @pl_treatment_id
AND o.parent_observation_sequence IS NULL
ORDER BY o.observation_sequence desc

SELECT @ll_count = count(*)
FROM p_Treatment_Progress
WHERE cpr_id = @ps_user_id
AND treatment_id = @pl_treatment_id
AND encounter_id = @pl_encounter_id
AND [user_id] = @ps_user_id
AND progress_type = 'REVIEWED'

IF @ll_count > 0
	SET @ls_reviewed = 'Y'
ELSE
	SET @ls_reviewed = 'N'

SELECT @ls_last_observed_by AS last_observed_by, @ls_reviewed AS reviewed

GO
GRANT EXECUTE
	ON [dbo].[sp_get_treatment_observed_by]
	TO [cprsystem]
GO

