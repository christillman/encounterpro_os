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

-- Drop Procedure [dbo].[sp_get_workplan_step_details]
Print 'Drop Procedure [dbo].[sp_get_workplan_step_details]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_workplan_step_details]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_workplan_step_details]
GO

-- Create Procedure [dbo].[sp_get_workplan_step_details]
Print 'Create Procedure [dbo].[sp_get_workplan_step_details]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_get_workplan_step_details (
	@pi_workplan_id int,
	@pi_step_number int )
AS

  SELECT c_Workplan_Item.workplan_id,   
         c_Workplan_Item.item_number,   
         c_Workplan_Item.step_number,   
         c_Workplan_Item.item_type,   
         c_Workplan_Item.ordered_service,   
         c_Workplan_Item.ordered_treatment_type,   
         c_Workplan_Item.ordered_workplan_id,   
         c_Workplan_Item.ordered_for,   
         c_Workplan_Item.description,   
         c_Workplan_Item.button_title,   
         c_Workplan_Item.button_help,   
         c_Workplan_Item.age_range_id,   
         c_Workplan_Item.sex,   
         c_Workplan_Item.new_flag,   
         selected_flag=0,   
         temp_item_number=0,   
         c_Workplan_Item.modes,   
         c_User.user_short_name,   
         c_User.color as user_color,   
         c_Role.color as role_color,   
         c_Role.role_name,   
         c_Domain.domain_item_description as special_description,   
         c_Workplan_Item.escalation_time,   
         c_Workplan_Item.escalation_unit_id,   
         c_Workplan_Item.expiration_time,   
         c_Workplan_Item.expiration_unit_id,   
         c_Workplan_Item.in_office_flag,   
         c_Treatment_Type.description as treatment_type_description,   
         o_Service.description as service_description,   
         c_Workplan_Item.priority,   
         c_Workplan_Item.sort_sequence,   
         c_Workplan_Item.step_flag,   
         c_Workplan_Item.auto_perform_flag,   
         c_Treatment_Type.followup_flag,   
         c_Workplan_Item.followup_workplan_id,   
         c_Workplan_Item.cancel_workplan_flag,   
         c_Workplan_Item.consolidate_flag,   
         c_Workplan_Item.owner_flag,   
         c_Workplan_Item.runtime_configured_flag,   
         c_Workplan_Item.abnormal_flag,   
         c_Workplan_Item.severity,   
         c_Workplan_Item.observation_tag  
    FROM c_Workplan_Item LEFT OUTER JOIN c_User ON c_Workplan_Item.ordered_for = c_User.user_id LEFT OUTER JOIN c_Role ON c_Workplan_Item.ordered_for = c_Role.role_id LEFT OUTER JOIN c_Treatment_Type ON c_Workplan_Item.ordered_treatment_type = c_Treatment_Type.treatment_type LEFT OUTER JOIN o_Service ON c_Workplan_Item.ordered_service = o_Service.service LEFT OUTER JOIN c_Domain ON ( c_Workplan_Item.ordered_for = c_Domain.domain_item  AND c_Domain.domain_id = 'ORDERED_FOR_SPECIAL' ) 
   WHERE ( c_Workplan_Item.workplan_id = @pi_workplan_id ) AND  
         ( c_Workplan_Item.step_number = @pi_step_number )   


GO
GRANT EXECUTE
	ON [dbo].[sp_get_workplan_step_details]
	TO [cprsystem]
GO

