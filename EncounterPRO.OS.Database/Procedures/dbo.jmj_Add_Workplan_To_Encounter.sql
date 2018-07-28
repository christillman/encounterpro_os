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

-- Drop Procedure [dbo].[jmj_Add_Workplan_To_Encounter]
Print 'Drop Procedure [dbo].[jmj_Add_Workplan_To_Encounter]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_Add_Workplan_To_Encounter]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_Add_Workplan_To_Encounter]
GO

-- Create Procedure [dbo].[jmj_Add_Workplan_To_Encounter]
Print 'Create Procedure [dbo].[jmj_Add_Workplan_To_Encounter]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE jmj_Add_Workplan_To_Encounter
(	 @ps_cpr_id varchar(12)
	,@pl_encounter_id int = NULL
	,@pl_patient_workplan_id int
	,@ps_ordered_by varchar(24)
	,@ps_created_by varchar(24)
)
AS

DECLARE @ll_encounter_patient_workplan_id int,
		@ls_encounter_status varchar(8),
		@ll_patient_workplan_item_id int,
		@ls_encounter_workplan_status varchar(12),
		@ls_object_workplan_status varchar(12),
		@li_last_step_dispatched smallint,
		@ls_workplan_type varchar(12),
		@ls_context_object varchar(24),
		@ll_object_key int,
		@ls_context_object_type varchar(24),
		@ls_workplan_description varchar(80),
		@ls_owned_by varchar(24),
		@ls_in_office_flag char(1)

SET @ll_patient_workplan_item_id = NULL

-- Get the status of the encounter
SELECT @ll_encounter_patient_workplan_id = patient_workplan_id,
		@ls_encounter_status = encounter_status
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

-- If the encounter isn't found then don't do anything
IF @@ROWCOUNT = 0
	RETURN @ll_patient_workplan_item_id

-- If the encounter isn't open then don't do anything
IF @ls_encounter_status <> 'OPEN'
	RETURN @ll_patient_workplan_item_id

-- Get the status of the encounter workplan
SELECT @ls_encounter_workplan_status = status,
		@li_last_step_dispatched = last_step_dispatched
FROM p_Patient_WP
WHERE patient_workplan_id = @ll_encounter_patient_workplan_id

-- If the workplan isn't found then don't do anything
IF @@ROWCOUNT = 0
	RETURN @ll_patient_workplan_item_id

-- If the workplan isn't current then don't do anything
IF @ls_encounter_workplan_status <> 'Current'
	RETURN @ll_patient_workplan_item_id

-- Get the status of the object workplan
SELECT @ls_object_workplan_status = status,
		@ls_workplan_description = description,
		@ls_owned_by = owned_by,
		@ls_context_object = workplan_type,
		@ls_in_office_flag = in_office_flag,
		@ll_object_key = CASE workplan_type WHEN 'Assessment' THEN problem_id
											WHEN 'Treatment' THEN treatment_id
											WHEN 'Observation' THEN observation_sequence
											WHEN 'Attachment' THEN attachment_id
											ELSE NULL END
FROM p_Patient_WP
WHERE patient_workplan_id = @pl_patient_workplan_id

-- If the workplan isn't found then don't do anything
IF @@ROWCOUNT = 0
	RETURN @ll_patient_workplan_item_id

-- If the workplan isn't current then don't do anything
IF @ls_object_workplan_status <> 'Current'
	RETURN @ll_patient_workplan_item_id

-- If we can't find the context object type then don't do anything
SET @ls_context_object_type = dbo.fn_context_object_type(@ls_context_object, @ps_cpr_id, @ll_object_key)
IF @ls_context_object_type IS NULL
	RETURN @ll_patient_workplan_item_id


-- Create the workplan item record in the encounter workplan.  Show as already dispatched.
INSERT INTO p_Patient_WP_Item
(	 cpr_id
	,patient_workplan_id
	,encounter_id
	,workplan_id
	,step_number
	,item_type
	,in_office_flag
	,ordered_treatment_type
	,description
	,ordered_by
	,ordered_for
	,owned_by
	,step_flag
	,auto_perform_flag
	,cancel_workplan_flag
	,consolidate_flag
	,owner_flag
	,runtime_configured_flag
	,dispatch_date
	,status
	,created_by
)
VALUES (
	 @ps_cpr_id
	,@ll_encounter_patient_workplan_id
	,@pl_encounter_id
	,0
	,@li_last_step_dispatched
	,@ls_context_object
	,@ls_in_office_flag
	,@ls_context_object_type
	,@ls_workplan_description
	,@ps_ordered_by
	,@ls_owned_by
	,@ls_owned_by
	,'N'
	,'N'
	,'N'
	,'N'
	,'N'
	,'Y'
	,getdate()
	,'Dispatched'
	,@ps_created_by)

SET @ll_patient_workplan_item_id = SCOPE_IDENTITY()

UPDATE p_Patient_WP
SET parent_patient_workplan_item_id = @ll_patient_workplan_item_id
WHERE patient_workplan_id = @pl_patient_workplan_id

RETURN @ll_patient_workplan_item_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_Add_Workplan_To_Encounter]
	TO [cprsystem]
GO

