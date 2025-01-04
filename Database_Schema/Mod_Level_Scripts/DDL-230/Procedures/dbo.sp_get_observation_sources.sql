
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_observation_sources]
Print 'Drop Procedure [dbo].[sp_get_observation_sources]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_observation_sources]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_observation_sources]
GO

-- Create Procedure [dbo].[sp_get_observation_sources]
Print 'Create Procedure [dbo].[sp_get_observation_sources]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
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

IF @ls_composite_flag = 'Y'
	SELECT DISTINCT s.external_source,
				s.description,
				s.component_id
	FROM c_External_Source s
		JOIN c_External_Observation o ON s.external_source = o.external_source
		JOIN c_Observation_Tree t ON o.observation_id = t.child_observation_id
		JOIN o_Computer_External_Source x ON x.external_source = s.external_source
	WHERE t.parent_observation_id = @ps_observation_id
	AND x.computer_id = @pl_computer_id
ELSE
	SELECT DISTINCT s.external_source,
				s.description,
				s.component_id
	FROM c_External_Source s
		JOIN c_External_Observation o ON s.external_source = o.external_source
		JOIN o_Computer_External_Source x ON x.external_source = s.external_source
	WHERE o.observation_id = @ps_observation_id
	AND x.computer_id = @pl_computer_id


GO
GRANT EXECUTE
	ON [dbo].[sp_get_observation_sources]
	TO [cprsystem]
GO

