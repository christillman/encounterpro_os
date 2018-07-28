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
		, @tmp_find_observation o
	WHERE o.depth = 1
	AND o.observation_id = t.parent_observation_id
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
	, @tmp_find_observation t
WHERE t.observation_id = c.observation_id


