
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_is_observation_loop]
Print 'Drop Function [dbo].[fn_is_observation_loop]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_is_observation_loop]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_is_observation_loop]
GO

-- Create Function [dbo].[fn_is_observation_loop]
Print 'Create Function [dbo].[fn_is_observation_loop]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_is_observation_loop (
	@ps_parent_observation_id varchar(24),
	@ps_new_observation_id varchar(24) = NULL )

RETURNS int

AS
BEGIN

DECLARE @li_max_depth smallint,
	@li_level smallint,
	@li_max_up_level smallint,
	@li_max_down_level smallint,
	@li_loop int

SET @li_loop = 0

SELECT @li_max_depth = CONVERT(smallint, dbo.fn_get_global_preference('PREFERENCES', 'max_observation_depth'))
IF @li_max_depth <= 0 OR @li_max_depth IS NULL
	SELECT @li_max_depth = 10

SELECT @li_level = 1

DECLARE @tmp_parents TABLE (
	observation_id varchar(24),
	level_up smallint)

DECLARE @tmp_children TABLE (
	observation_id varchar(24),
	level_down smallint)

-- build the parents table
SELECT @li_level = 1

INSERT INTO @tmp_parents (
	observation_id,
	level_up)
VALUES (
	@ps_parent_observation_id,
	1)

WHILE @@ROWCOUNT > 0 AND @li_level < @li_max_depth
	BEGIN
	SELECT @li_level = @li_level + 1

	INSERT INTO @tmp_parents (
		observation_id,
		level_up)
	SELECT DISTINCT t.parent_observation_id,
		@li_level
	FROM c_Observation_Tree t
		INNER JOIN @tmp_parents p
		ON t.child_observation_id = p.observation_id
	WHERE NOT EXISTS (
		SELECT x.observation_id
		FROM @tmp_parents x
		WHERE x.observation_id = t.parent_observation_id)

	END

-- Build the children table
SELECT @li_level = 1

IF @ps_new_observation_id IS NULL
	INSERT INTO @tmp_children (
		observation_id,
		level_down)
	SELECT DISTINCT t.child_observation_id,
		@li_level
	FROM c_Observation_Tree t
		INNER JOIN c_Observation o
		ON t.child_observation_id = o.observation_id
	WHERE t.parent_observation_id = @ps_parent_observation_id
	AND o.composite_flag = 'Y'
ELSE
	INSERT INTO @tmp_children (
		observation_id,
		level_down)
	VALUES (
		@ps_new_observation_id,
		@li_level)

WHILE @@ROWCOUNT > 0 AND @li_level < @li_max_depth
	BEGIN
	SELECT @li_level = @li_level + 1

	INSERT INTO @tmp_children (
		observation_id,
		level_down)
	SELECT DISTINCT t.child_observation_id,
		@li_level
	FROM c_Observation_Tree t
		INNER JOIN c_Observation o
		ON t.child_observation_id = o.observation_id
		INNER JOIN @tmp_children c
		ON t.parent_observation_id = c.observation_id
	WHERE o.composite_flag = 'Y'
	AND NOT EXISTS (
		SELECT x.observation_id
		FROM @tmp_children x
		WHERE x.observation_id = t.child_observation_id)

	END

SELECT @li_max_up_level = max(level_up)
FROM @tmp_parents

SELECT @li_max_down_level = max(level_down)
FROM @tmp_children

IF @li_max_up_level + @li_max_down_level > @li_max_depth
	SET @li_loop = 1
ELSE
	SELECT @li_loop = COUNT(*)
	FROM @tmp_parents p 
	JOIN @tmp_children c ON p.observation_id = c.observation_id

IF @li_loop <> 0
	SET @li_loop = 1

RETURN @li_loop

END

GO
GRANT EXECUTE
	ON [dbo].[fn_is_observation_loop]
	TO [cprsystem]
GO

