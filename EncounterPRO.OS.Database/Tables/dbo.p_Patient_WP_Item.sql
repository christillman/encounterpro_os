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

-- Drop Table [dbo].[p_Patient_WP_Item]
Print 'Drop Table [dbo].[p_Patient_WP_Item]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Patient_WP_Item]') AND [type]='U'))
DROP TABLE [dbo].[p_Patient_WP_Item]
GO
-- Create Table [dbo].[p_Patient_WP_Item]
Print 'Create Table [dbo].[p_Patient_WP_Item]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Patient_WP_Item] (
		[patient_workplan_id]                     [int] NOT NULL,
		[patient_workplan_item_id]                [int] IDENTITY(1, 1) NOT NULL,
		[cpr_id]                                  [varchar](12) NULL,
		[encounter_id]                            [int] NULL,
		[workplan_id]                             [int] NOT NULL,
		[item_number]                             [int] NULL,
		[step_number]                             [smallint] NULL,
		[item_type]                               [varchar](12) NOT NULL,
		[ordered_service]                         [varchar](24) NULL,
		[active_service_flag]                     [char](1) NOT NULL,
		[in_office_flag]                          [char](1) NULL,
		[ordered_treatment_type]                  [varchar](24) NULL,
		[ordered_workplan_id]                     [int] NULL,
		[followup_workplan_id]                    [int] NULL,
		[description]                             [varchar](80) NULL,
		[ordered_by]                              [varchar](24) NOT NULL,
		[ordered_for]                             [varchar](24) NULL,
		[priority]                                [smallint] NULL,
		[step_flag]                               [char](1) NULL,
		[auto_perform_flag]                       [char](1) NULL,
		[cancel_workplan_flag]                    [char](1) NULL,
		[dispatch_date]                           [datetime] NULL,
		[dispatch_method]                         [varchar](24) NULL,
		[consolidate_flag]                        [char](1) NULL,
		[owner_flag]                              [char](1) NULL,
		[runtime_configured_flag]                 [char](1) NULL,
		[observation_tag]                         [varchar](12) NULL,
		[dispatched_patient_workplan_item_id]     [int] NULL,
		[owned_by]                                [varchar](24) NULL,
		[begin_date]                              [datetime] NULL,
		[end_date]                                [datetime] NULL,
		[escalation_date]                         [datetime] NULL,
		[expiration_date]                         [datetime] NULL,
		[completed_by]                            [varchar](24) NULL,
		[room_id]                                 [varchar](12) NULL,
		[status]                                  [varchar](12) NULL,
		[retries]                                 [smallint] NULL,
		[folder]                                  [varchar](40) NULL,
		[created_by]                              [varchar](24) NOT NULL,
		[created]                                 [datetime] NULL,
		[id]                                      [uniqueidentifier] NOT NULL,
		[treatment_id]                            [int] NULL,
		[problem_id]                              [int] NULL,
		[attachment_id]                           [int] NULL,
		[context_object]                          [varchar](24) NULL
) ON [Workflow]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item]
	ADD
	CONSTRAINT [PK_p_Patient_WP_Item]
	PRIMARY KEY
	NONCLUSTERED
	([patient_workplan_item_id])
	WITH FILLFACTOR=70
	ON [Workflow]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item]
	ADD
	CONSTRAINT [DF__p_Patient__in_of__2D67AF2B]
	DEFAULT ('N') FOR [in_office_flag]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item]
	ADD
	CONSTRAINT [DF__p_Patient__runti__2E5BD364]
	DEFAULT ('N') FOR [runtime_configured_flag]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item]
	ADD
	CONSTRAINT [DF__p_Patient_WP__id__2F4FF79D]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item]
	ADD
	CONSTRAINT [DF_p_Patient_Workplan_Item_created]
	DEFAULT (getdate()) FOR [created]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item]
	ADD
	CONSTRAINT [DF_ppwi_active_service_flag_b12]
	DEFAULT ('N') FOR [active_service_flag]
GO
CREATE NONCLUSTERED INDEX [idx_active_services]
	ON [dbo].[p_Patient_WP_Item] ([active_service_flag], [in_office_flag], [patient_workplan_item_id], [ordered_service], [owned_by])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 50) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_cpr_id]
	ON [dbo].[p_Patient_WP_Item] ([cpr_id], [encounter_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_dispatched_patient_workplan_id]
	ON [dbo].[p_Patient_WP_Item] ([dispatched_patient_workplan_item_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_item_owner]
	ON [dbo].[p_Patient_WP_Item] ([owned_by], [in_office_flag], [ordered_service], [patient_workplan_item_id], [status], [active_service_flag])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_ordered_by]
	ON [dbo].[p_Patient_WP_Item] ([ordered_by], [ordered_service], [dispatch_date])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_ordered_for]
	ON [dbo].[p_Patient_WP_Item] ([ordered_for], [ordered_service], [status], [folder])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_owned_by_date]
	ON [dbo].[p_Patient_WP_Item] ([owned_by], [dispatch_date], [active_service_flag], [ordered_service])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_workplan_item_id]
	ON [dbo].[p_Patient_WP_Item] ([patient_workplan_id], [patient_workplan_item_id], [item_number])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE CLUSTERED INDEX [idx_wp_item_cluster]
	ON [dbo].[p_Patient_WP_Item] ([cpr_id], [patient_workplan_item_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_wp_item_guid]
	ON [dbo].[p_Patient_WP_Item] ([id], [patient_workplan_item_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_wpi_context_object]
	ON [dbo].[p_Patient_WP_Item] ([cpr_id], [context_object], [encounter_id], [treatment_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_wpi_documents]
	ON [dbo].[p_Patient_WP_Item] ([item_type], [status], [patient_workplan_item_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [Workflow]
GO
GRANT DELETE
	ON [dbo].[p_Patient_WP_Item]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[p_Patient_WP_Item]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[p_Patient_WP_Item]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[p_Patient_WP_Item]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[p_Patient_WP_Item]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Patient_WP_Item] SET (LOCK_ESCALATION = TABLE)
GO

