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

-- Drop Procedure [dbo].[sp_update_observation]
Print 'Drop Procedure [dbo].[sp_update_observation]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_update_observation]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_update_observation]
GO

-- Create Procedure [dbo].[sp_update_observation]
Print 'Create Procedure [dbo].[sp_update_observation]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_update_observation (
	@ps_observation_id varchar(24),
	@ps_collection_location_domain varchar(12) = 'NA',
	@ps_perform_location_domain varchar(12) = 'NA',
	@ps_collection_procedure_id varchar(24) = NULL,
	@ps_perform_procedure_id varchar(24) = NULL,
	@ps_description varchar(80),
	@ps_composite_flag char(1) = 'N',
	@ps_exclusive_flag char(1) = 'N',
	@ps_in_context_flag char(1) = 'N',
	@ps_location_pick_flag char(1) = 'N',
	@ps_location_bill_flag char(1) = 'N',
	@ps_observation_type varchar(24) = 'Subjective',
	@ps_default_view char(1) = NULL,
	@ps_display_style varchar(255) = NULL,
	@ps_status varchar(12) = NULL )
AS

IF @ps_status = ''
	SET @ps_status = NULL

DECLARE @ls_old_description varchar(80)

SELECT @ls_old_description = description
FROM c_Observation
WHERE observation_id = @ps_observation_id

UPDATE c_Observation
SET	description = @ps_description,
	collection_location_domain = @ps_collection_location_domain,
	perform_location_domain = @ps_perform_location_domain,
	collection_procedure_id = @ps_collection_procedure_id,
	perform_procedure_id = @ps_perform_procedure_id,
	composite_flag = @ps_composite_flag,
	exclusive_flag = @ps_exclusive_flag,
	in_context_flag = @ps_in_context_flag,
	location_pick_flag = @ps_location_pick_flag,
	location_bill_flag = @ps_location_bill_flag,
	observation_type = @ps_observation_type,
	default_view = @ps_default_view,
	display_style = @ps_display_style,
	status = COALESCE(@ps_status, status)
WHERE	observation_id = @ps_observation_id

-- update treatment list
IF @ls_old_description <> @ps_description
BEGIN
UPDATE u_Assessment_Treat_Definition
SET treatment_description = @ps_description
WHERE EXISTS (
	SELECT u_assessment_treat_def_attrib.definition_id
	FROM u_Assessment_Treat_Def_Attrib
	WHERE attribute like '%observation_id'
	AND value = @ps_observation_id
	AND u_assessment_treat_definition.definition_id = u_assessment_treat_def_attrib.definition_id
	)

-- update top 20
UPDATE u_Top_20
SET item_text = @ps_description
WHERE item_id = @ps_observation_id
AND top_20_code like 'TEST%'
END

GO
GRANT EXECUTE
	ON [dbo].[sp_update_observation]
	TO [cprsystem]
GO

