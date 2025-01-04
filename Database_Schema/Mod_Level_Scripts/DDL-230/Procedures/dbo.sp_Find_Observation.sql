
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Find_Observation]
Print 'Drop Procedure [dbo].[sp_Find_Observation]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Find_Observation]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Find_Observation]
GO

-- Create Procedure [dbo].[sp_Find_Observation]
Print 'Create Procedure [dbo].[sp_Find_Observation]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_Find_Observation
	@ps_observation_id varchar(24)
AS

DECLARE @ll_count int,
		@ll_iterations int,
		@ll_max_iterations int

DECLARE  @tmp_find_observation TABLE
(	observation_id varchar(24) NOT NULL,
	depth smallint NOT NULL DEFAULT (0)
)

INSERT INTO @tmp_find_observation 
(	observation_id)
VALUES
(@ps_observation_id)

SET @ll_count = 1
SET @ll_iterations = 0
SET @ll_max_iterations = 1

WHILE @ll_count > 0 AND @ll_iterations < @ll_max_iterations
	BEGIN
	UPDATE @tmp_find_observation
	SET depth = depth + 1

	INSERT INTO @tmp_find_observation
	(observation_id )
	SELECT t.child_observation_id
	FROM 	c_Observation_Tree t WITH (NOLOCK)
	JOIN @tmp_find_observation o ON o.observation_id = t.parent_observation_id
	WHERE o.depth = 1
	AND NOT EXISTS (
		SELECT observation_id
		FROM @tmp_find_observation x
		WHERE t.child_observation_id = x.observation_id)

	SELECT @ll_count = @@ROWCOUNT
	
	SET @ll_iterations = @ll_iterations + 1

	END

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
JOIN @tmp_find_observation t ON t.observation_id = c.observation_id


GO
GRANT EXECUTE
	ON [dbo].[sp_Find_Observation]
	TO [cprsystem]
GO

