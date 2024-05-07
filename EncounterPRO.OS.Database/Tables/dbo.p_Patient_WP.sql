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

-- Drop Table [dbo].[p_Patient_WP]
Print 'Drop Table [dbo].[p_Patient_WP]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Patient_WP]') AND [type]='U'))
DROP TABLE [dbo].[p_Patient_WP]
GO
-- Create Table [dbo].[p_Patient_WP]
Print 'Create Table [dbo].[p_Patient_WP]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Patient_WP] (
		[patient_workplan_id]                 [int] IDENTITY(1, 1) NOT NULL,
		[cpr_id]                              [varchar](12) NULL,
		[workplan_id]                         [int] NOT NULL,
		[workplan_type]                       [varchar](12) NOT NULL,
		[in_office_flag]                      [char](1) NULL,
		[mode]                                [varchar](32) NULL,
		[last_step_dispatched]                [smallint] NULL,
		[last_step_date]                      [datetime] NULL,
		[encounter_id]                        [int] NULL,
		[problem_id]                          [int] NULL,
		[treatment_id]                        [int] NULL,
		[observation_sequence]                [int] NULL,
		[attachment_id]                       [int] NULL,
		[description]                         [varchar](80) NULL,
		[ordered_by]                          [varchar](24) NOT NULL,
		[owned_by]                            [varchar](24) NULL,
		[parent_patient_workplan_item_id]     [int] NULL,
		[status]                              [varchar](12) NULL,
		[created_by]                          [varchar](24) NOT NULL,
		[created]                             [datetime] NULL,
		[id]                                  [uniqueidentifier] NOT NULL,
		[context_object]                      [varchar](24) NULL,
		[room_id]                             [varchar](12) NULL
) ON [Workflow]
GO
ALTER TABLE [dbo].[p_Patient_WP]
	ADD
	CONSTRAINT [PK_p_Patient_Workplan]
	PRIMARY KEY
	NONCLUSTERED
	([patient_workplan_id])
	WITH FILLFACTOR=100
	ON [Workflow]
GO
ALTER TABLE [dbo].[p_Patient_WP]
	ADD
	CONSTRAINT [DF__p_Patient_WP__id__2B7F66B9]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[p_Patient_WP]
	ADD
	CONSTRAINT [DF_p_Patient_Workplan_created]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
ALTER TABLE [dbo].[p_Patient_WP]
	ADD
	CONSTRAINT [DF_p_Patient_Workplan_status]
	DEFAULT ('Pending') FOR [status]
GO
CREATE NONCLUSTERED INDEX [idx_parent_WP_item_id]
	ON [dbo].[p_Patient_WP] ([parent_patient_workplan_item_id], [patient_workplan_id], [in_office_flag])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [Workflow]
GO
CREATE CLUSTERED INDEX [idx_workplan_cluster]
	ON [dbo].[p_Patient_WP] ([cpr_id], [encounter_id], [treatment_id], [patient_workplan_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_WP_cpr_trt]
	ON [dbo].[p_Patient_WP] ([cpr_id], [treatment_id], [patient_workplan_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [Workflow]
GO
CREATE NONCLUSTERED INDEX [idx_WP_treatment_id]
	ON [dbo].[p_Patient_WP] ([treatment_id], [patient_workplan_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [Workflow]
GO
GRANT DELETE
	ON [dbo].[p_Patient_WP]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[p_Patient_WP]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[p_Patient_WP]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[p_Patient_WP]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[p_Patient_WP]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Patient_WP] SET (LOCK_ESCALATION = TABLE)
GO

