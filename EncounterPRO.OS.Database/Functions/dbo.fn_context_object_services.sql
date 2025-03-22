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

-- Drop Function [dbo].[fn_context_object_services]
Print 'Drop Function [dbo].[fn_context_object_services]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_context_object_services]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_context_object_services]
GO

-- Create Function [dbo].[fn_context_object_services]
Print 'Create Function [dbo].[fn_context_object_services]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_context_object_services (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int)

RETURNS @services TABLE (
	[patient_workplan_id] [int] NOT NULL,
	[patient_workplan_item_id] [int] NOT NULL,
	[cpr_id] [varchar](12) NULL,
	[encounter_id] [int] NULL,
	[workplan_id] [int] NOT NULL,
	[item_number] [int] NULL,
	[step_number] [smallint] NULL,
	[item_type] [varchar](12) NOT NULL,
	[ordered_service] [varchar](24) NULL,
	[active_service_flag] [char](1) ,
	[in_office_flag] [char](1) NULL ,
	[ordered_treatment_type] [varchar](24) NULL,
	[ordered_workplan_id] [int] NULL,
	[followup_workplan_id] [int] NULL,
	[description] [varchar](80) NULL,
	[ordered_by] [varchar](24) NOT NULL,
	[ordered_for] [varchar](24) NULL,
	[priority] [smallint] NULL,
	[step_flag] [char](1) NULL,
	[auto_perform_flag] [char](1) NULL,
	[cancel_workplan_flag] [char](1) NULL,
	[dispatch_date] [datetime] NULL,
	[dispatch_method] [varchar](24) NULL,
	[consolidate_flag] [char](1) NULL,
	[owner_flag] [char](1) NULL,
	[runtime_configured_flag] [char](1) NULL ,
	[observation_tag] [varchar](12) NULL,
	[dispatched_patient_workplan_item_id] [int] NULL,
	[owned_by] [varchar](24) NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[escalation_date] [datetime] NULL,
	[expiration_date] [datetime] NULL,
	[completed_by] [varchar](24) NULL,
	[room_id] [varchar](12) NULL,
	[status] [varchar](12) NULL,
	[retries] [smallint] NULL,
	[folder] [varchar](40) NULL,
	[created_by] [varchar](24) NOT NULL,
	[created] [datetime] NULL ,
	[id] [uniqueidentifier] NOT NULL ,
	[treatment_id] [int] NULL ,
	[problem_id] [int] NULL ,
	[attachment_id] [int] NULL ,
	[context_object] [varchar] (24) NULL )

AS

BEGIN

IF @ps_context_object = 'Encounter'
	INSERT INTO @services (
		   [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object] )
	SELECT [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object]
	FROM p_Patient_WP_Item
	WHERE cpr_id = @ps_cpr_id
	AND context_object = @ps_context_object
	AND encounter_id = @pl_object_key
	AND status NOT IN ('Cancelled', 'skipped')
	AND item_type = 'Service'

IF @ps_context_object = 'Assessment'
	INSERT INTO @services (
		   [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object] )
	SELECT [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object]
	FROM p_Patient_WP_Item
	WHERE cpr_id = @ps_cpr_id
	AND context_object = @ps_context_object
	AND problem_id = @pl_object_key
	AND status NOT IN ('Cancelled', 'skipped')
	AND item_type = 'Service'

IF @ps_context_object = 'Treatment'
	INSERT INTO @services (
		   [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object] )
	SELECT [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object]
	FROM p_Patient_WP_Item
	WHERE cpr_id = @ps_cpr_id
	AND context_object = @ps_context_object
	AND treatment_id = @pl_object_key
	AND status NOT IN ('Cancelled', 'skipped')
	AND item_type = 'Service'

IF @ps_context_object = 'Attachment'
	INSERT INTO @services (
		   [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object] )
	SELECT [patient_workplan_id]
		  ,[patient_workplan_item_id]
		  ,[cpr_id]
		  ,[encounter_id]
		  ,[workplan_id]
		  ,[item_number]
		  ,[step_number]
		  ,[item_type]
		  ,[ordered_service]
		  ,[active_service_flag]
		  ,[in_office_flag]
		  ,[ordered_treatment_type]
		  ,[ordered_workplan_id]
		  ,[followup_workplan_id]
		  ,[description]
		  ,[ordered_by]
		  ,[ordered_for]
		  ,[priority]
		  ,[step_flag]
		  ,[auto_perform_flag]
		  ,[cancel_workplan_flag]
		  ,[dispatch_date]
		  ,[dispatch_method]
		  ,[consolidate_flag]
		  ,[owner_flag]
		  ,[runtime_configured_flag]
		  ,[observation_tag]
		  ,[dispatched_patient_workplan_item_id]
		  ,[owned_by]
		  ,[begin_date]
		  ,[end_date]
		  ,[escalation_date]
		  ,[expiration_date]
		  ,[completed_by]
		  ,[room_id]
		  ,[status]
		  ,[retries]
		  ,[folder]
		  ,[created_by]
		  ,[created]
		  ,[id]
		  ,[treatment_id]
			,[problem_id]
			,[attachment_id]
			,[context_object]
	FROM p_Patient_WP_Item
	WHERE cpr_id = @ps_cpr_id
	AND context_object = @ps_context_object
	AND attachment_id = @pl_object_key
	AND status NOT IN ('Cancelled', 'skipped')
	AND item_type = 'Service'

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_context_object_services] TO [cprsystem]
GO

