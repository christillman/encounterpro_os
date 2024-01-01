
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_child_observations]
Print 'Drop Procedure [dbo].[sp_get_child_observations]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_child_observations]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_child_observations]
GO

-- Create Procedure [dbo].[sp_get_child_observations]
Print 'Create Procedure [dbo].[sp_get_child_observations]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_child_observations (
	@ps_observation_id varchar(24))
AS

SELECT o.observation_id,
	o.collection_location_domain ,
	o.perform_location_domain ,
	o.collection_procedure_id ,
	o.perform_procedure_id ,
	o.description ,
	o.composite_flag ,
	o.exclusive_flag ,
	o.in_context_flag,
	t.branch_id,
	t.sort_sequence ,
	selected_flag = 0
FROM c_Observation o
JOIN c_Observation_Tree t ON t.child_observation_id = o.observation_id
WHERE t.parent_observation_id = @ps_observation_id
AND o.status = 'OK'


GO
GRANT EXECUTE
	ON [dbo].[sp_get_child_observations]
	TO [cprsystem]
GO

