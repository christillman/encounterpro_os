
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_cache_recent_observations]
Print 'Drop Procedure [dbo].[sp_cache_recent_observations]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_cache_recent_observations]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_cache_recent_observations]
GO

-- Create Procedure [dbo].[sp_cache_recent_observations]
Print 'Create Procedure [dbo].[sp_cache_recent_observations]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_cache_recent_observations
AS

WITH recent as (
	SELECT observation_id, created as last_updated
	FROM p_Observation
	WHERE created > dateadd(year,-1,dbo.get_client_datetime())
	UNION
	SELECT observation_id, last_updated
	FROM c_Observation
	WHERE last_updated > dateadd(year,-1,dbo.get_client_datetime())
	)
SELECT c.observation_id ,
	c.collection_location_domain ,
	c.perform_location_domain ,
	c.collection_procedure_id ,
	c.perform_procedure_id ,
	c.specimen_type ,
	c.description ,
	c.observation_type ,
	c.composite_flag ,
	c.exclusive_flag ,
	c.location_pick_flag ,
	c.location_bill_flag ,
	c.in_context_flag ,
	c.display_only_flag ,
	c.default_view ,
	c.material_id ,
	c.sort_sequence ,
	c.status ,
	c.last_updated ,
	c.updated_by,
	c.narrative_phrase ,
	c.display_style,
	CONVERT(int, NULL) as tree_index,
	CONVERT(int, NULL) as results_index
FROM 	c_Observation c WITH (NOLOCK)
WHERE c.observation_id IN (
	SELECT TOP 1000 observation_id
	FROM recent p 
	GROUP BY observation_id
	ORDER BY max(p.last_updated) desc
	)

GO
GRANT EXECUTE
	ON [dbo].[sp_cache_recent_observations]
	TO [cprsystem]
GO

