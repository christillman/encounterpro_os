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

-- Drop Procedure [dbo].[sp_init_user_therapies]
Print 'Drop Procedure [dbo].[sp_init_user_therapies]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_init_user_therapies]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_init_user_therapies]
GO

-- Create Procedure [dbo].[sp_init_user_therapies]
Print 'Create Procedure [dbo].[sp_init_user_therapies]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_init_user_therapies (
	@ps_user_id varchar(24),
	@ps_assessment_id varchar(24),
	@ps_common_list_id varchar(24),
	@pl_old_parent_definition_id int = NULL ,
	@pl_new_parent_definition_id int = NULL )
AS

DECLARE @ll_definition_id int,
		@ls_treatment_type varchar(24),
		@ls_treatment_description varchar(80),
		@ll_workplan_id int,
		@ll_followup_workplan_id int,
		@li_sort_sequence smallint,
		@ls_instructions varchar(50),
		@ls_child_flag char(1),
		@ll_new_definition_id int

-- First, get a list of all the treatment definitions for the common list
-- Note that we'll either get all the root records (parent_definition_id = NULL)
-- or we'll get all the child records for the specified parent.
DECLARE lc_defs CURSOR LOCAL FOR
SELECT	definition_id,
	treatment_type,
	treatment_description,
	workplan_id,
	followup_workplan_id,
	sort_sequence,
	instructions,
	child_flag 
FROM u_Assessment_Treat_Definition def
WHERE def.user_id = @ps_common_list_id
AND def.assessment_id = @ps_assessment_id
AND ((def.parent_definition_id is null AND @pl_old_parent_definition_id IS NULL)
	 OR (def.parent_definition_id = @pl_old_parent_definition_id) )

OPEN lc_defs

FETCH lc_defs INTO
	@ll_definition_id,
	@ls_treatment_type,
	@ls_treatment_description,
	@ll_workplan_id,
	@ll_followup_workplan_id,
	@li_sort_sequence,
	@ls_instructions,
	@ls_child_flag 

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Copy the definition record
	INSERT INTO u_Assessment_Treat_Definition (
		assessment_id,
		treatment_type,
		treatment_description,
		workplan_id,
		followup_workplan_id,
		[user_id],
		sort_sequence,
		instructions,
		parent_definition_id,
		child_flag )
	VALUES (
		@ps_assessment_id,
		@ls_treatment_type,
		@ls_treatment_description,
		@ll_workplan_id,
		@ll_followup_workplan_id,
		@ps_user_id,
		@li_sort_sequence,
		@ls_instructions,
		@pl_new_parent_definition_id,
		@ls_child_flag  )

	SET @ll_new_definition_id = @@IDENTITY

	-- Copy the attributes
	INSERT INTO u_Assessment_Treat_Def_Attrib (
		definition_id,
		attribute,
		value )
	SELECT @ll_new_definition_id,
			attribute,
			value
	FROM u_Assessment_Treat_Def_Attrib
	WHERE definition_id = @ll_definition_id
	
	-- Now recursively call this SP to get any child treatments of this treatment
	EXECUTE sp_init_user_therapies
		@ps_user_id = @ps_user_id,
		@ps_assessment_id = @ps_assessment_id,
		@ps_common_list_id = @ps_common_list_id,
		@pl_old_parent_definition_id = @ll_definition_id,
		@pl_new_parent_definition_id = @ll_new_definition_id

	FETCH lc_defs INTO
		@ll_definition_id,
		@ls_treatment_type,
		@ls_treatment_description,
		@ll_workplan_id,
		@ll_followup_workplan_id,
		@li_sort_sequence,
		@ls_instructions,
		@ls_child_flag 

	END
CLOSE lc_defs
DEALLOCATE lc_defs


GO
GRANT EXECUTE
	ON [dbo].[sp_init_user_therapies]
	TO [cprsystem]
GO

