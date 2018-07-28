--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

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
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_is_observation_loop (
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
	FROM @tmp_parents p, @tmp_children c
	WHERE p.observation_id = c.observation_id

IF @li_loop <> 0
	SET @li_loop = 1

RETURN @li_loop

END

GO
GRANT EXECUTE
	ON [dbo].[fn_is_observation_loop]
	TO [cprsystem]
GO

