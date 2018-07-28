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

-- Drop Function [dbo].[fn_patient_object_workplans]
Print 'Drop Function [dbo].[fn_patient_object_workplans]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_object_workplans]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_object_workplans]
GO

-- Create Function [dbo].[fn_patient_object_workplans]
Print 'Create Function [dbo].[fn_patient_object_workplans]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_patient_object_workplans (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int )

RETURNS @workplans TABLE (
	[patient_workplan_id] [int] NOT NULL ,
	[cpr_id] [varchar] (12) NULL ,
	[workplan_id] [int] NOT NULL ,
	[workplan_type] [varchar] (12) NOT NULL ,
	[in_office_flag] [char] (1) NULL ,
	[mode] [varchar] (32) NULL ,
	[last_step_dispatched] [smallint] NULL ,
	[last_step_date] [datetime] NULL ,
	[encounter_id] [int] NULL ,
	[problem_id] [int] NULL ,
	[treatment_id] [int] NULL ,
	[observation_sequence] [int] NULL ,
	[attachment_id] [int] NULL ,
	[description] [varchar] (80) NULL ,
	[ordered_by] [varchar] (24) NOT NULL ,
	[owned_by] [varchar] (24) NULL ,
	[parent_patient_workplan_item_id] [int] NULL ,
	[status] [varchar] (12) NULL ,
	[created_by] [varchar] (24) NOT NULL ,
	[created] [datetime] NULL ,
	[id] [uniqueidentifier] NOT NULL )

AS

BEGIN

IF @ps_context_object = 'Patient'
	INSERT INTO @workplans (	
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] )
	SELECT 
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] 
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND workplan_type = 'Patient'
--	AND workplan_id > 0
	AND treatment_id IS NULL
	AND problem_id IS NULL
	AND attachment_id IS NULL
	
IF @ps_context_object = 'Encounter'
	INSERT INTO @workplans (	
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] )
	SELECT 
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] 
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND workplan_type = 'Encounter'
--	AND workplan_id > 0
	AND encounter_id = @pl_object_key
	
IF @ps_context_object = 'Assessment'
	INSERT INTO @workplans (	
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] )
	SELECT 
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] 
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_object_key
	AND workplan_type IN ('Patient', 'Assessment')
--	AND workplan_id > 0
	AND treatment_id IS NULL
	AND attachment_id IS NULL

IF @ps_context_object = 'Treatment'
	INSERT INTO @workplans (	
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] )
	SELECT 
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] 
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_object_key
	AND workplan_type IN ('Patient', 'Treatment')
--	AND workplan_id > 0
	UNION
	SELECT 
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] 
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_object_key
	AND workplan_type IN ('Referral', 'Followup')

IF @ps_context_object = 'Attachment'
	INSERT INTO @workplans (	
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] )
	SELECT 
		[patient_workplan_id] ,
		[cpr_id] ,
		[workplan_id] ,
		[workplan_type] ,
		[in_office_flag] ,
		[mode] ,
		[last_step_dispatched] ,
		[last_step_date] ,
		[encounter_id] ,
		[problem_id] ,
		[treatment_id] ,
		[observation_sequence] ,
		[attachment_id] ,
		[description] ,
		[ordered_by] ,
		[owned_by] ,
		[parent_patient_workplan_item_id] ,
		[status] ,
		[created_by] ,
		[created] ,
		[id] 
	FROM p_Patient_WP
	WHERE cpr_id = @ps_cpr_id
	AND attachment_id = @pl_object_key
	AND workplan_type = 'Attachment'
--	AND workplan_id > 0


RETURN
END

GO
GRANT SELECT
	ON [dbo].[fn_patient_object_workplans]
	TO [cprsystem]
GO

