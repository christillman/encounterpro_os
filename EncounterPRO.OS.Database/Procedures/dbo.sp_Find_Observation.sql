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
SET QUOTED_IDENTIFIER OFF
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


GO
GRANT EXECUTE
	ON [dbo].[sp_Find_Observation]
	TO [cprsystem]
GO

