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

-- Drop Table [dbo].[p_Patient_Encounter]
Print 'Drop Table [dbo].[p_Patient_Encounter]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Patient_Encounter]') AND [type]='U'))
DROP TABLE [dbo].[p_Patient_Encounter]
GO
-- Create Table [dbo].[p_Patient_Encounter]
Print 'Create Table [dbo].[p_Patient_Encounter]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Patient_Encounter] (
		[cpr_id]                     [varchar](12) NOT NULL,
		[encounter_id]               [int] IDENTITY(1, 1) NOT NULL,
		[encounter_type]             [varchar](24) NULL,
		[encounter_status]           [varchar](8) NULL,
		[encounter_date]             [datetime] NULL,
		[encounter_description]      [varchar](80) NULL,
		[patient_workplan_id]        [int] NULL,
		[indirect_flag]              [char](1) NULL,
		[patient_class]              [char](1) NULL,
		[patient_location]           [varchar](12) NULL,
		[next_patient_location]      [varchar](12) NULL,
		[admission_type]             [char](1) NULL,
		[attending_doctor]           [varchar](24) NULL,
		[referring_doctor]           [varchar](24) NULL,
		[supervising_doctor]         [varchar](24) NULL,
		[ambulatory_status]          [varchar](2) NULL,
		[vip_indicator]              [char](1) NULL,
		[charge_price_ind]           [varchar](2) NULL,
		[courtesy_code]              [varchar](2) NULL,
		[discharge_disp]             [varchar](8) NULL,
		[discharge_date]             [datetime] NULL,
		[admit_reason]               [varchar](12) NULL,
		[attachment_id]              [int] NULL,
		[new_flag]                   [char](1) NULL,
		[billing_note]               [text] NULL,
		[encounter_billing_id]       [int] NULL,
		[billing_posted]             [char](1) NULL,
		[bill_flag]                  [char](1) NULL,
		[billing_hold_flag]          [char](1) NULL,
		[office_id]                  [varchar](4) NULL,
		[end_date]                   [datetime] NULL,
		[stone_flag]                 [char](1) NULL,
		[created]                    [datetime] NULL,
		[created_by]                 [varchar](24) NULL,
		[appointment_time]           [datetime] NULL,
		[est_appointment_length]     [smallint] NULL,
		[workers_comp_flag]          [char](1) NULL,
		[coding_component_id]        [varchar](24) NULL,
		[billing_calc_date]          [datetime] NULL,
		[id]                         [uniqueidentifier] NOT NULL,
		[default_grant]              [bit] NOT NULL,
		[billing_provider_id]        [varchar](24) NULL,
		[encounter_location]         [varchar](24) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Patient_Encounter]
	ADD
	CONSTRAINT [PK_p_Patient_Encounter_1__12]
	PRIMARY KEY
	CLUSTERED
	([cpr_id], [encounter_id])
	WITH FILLFACTOR=70
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Patient_Encounter]
	ADD
	CONSTRAINT [DF__p_encounter_default_grant]
	DEFAULT ((1)) FOR [default_grant]
GO
ALTER TABLE [dbo].[p_Patient_Encounter]
	ADD
	CONSTRAINT [DF__p_Patient_En__id__2E26C93A]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[p_Patient_Encounter]
	ADD
	CONSTRAINT [DF_p_encounter_bill_flag_21]
	DEFAULT ('Y') FOR [bill_flag]
GO
ALTER TABLE [dbo].[p_Patient_Encounter]
	ADD
	CONSTRAINT [DF_p_encounter_bill_hold_21]
	DEFAULT ('') FOR [billing_hold_flag]
GO
ALTER TABLE [dbo].[p_Patient_Encounter]
	ADD
	CONSTRAINT [DF_p_encounter_bill_post_21]
	DEFAULT ('') FOR [billing_posted]
GO
ALTER TABLE [dbo].[p_Patient_Encounter]
	ADD
	CONSTRAINT [DF_p_encounter_created_21]
	DEFAULT (getdate()) FOR [created]
GO
ALTER TABLE [dbo].[p_Patient_Encounter]
	ADD
	CONSTRAINT [DF_p_encounter_stone_21]
	DEFAULT ('') FOR [stone_flag]
GO
CREATE NONCLUSTERED INDEX [idx_encounter_date]
	ON [dbo].[p_Patient_Encounter] ([encounter_date], [office_id], [encounter_id], [encounter_status], [patient_location])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_encounter_status]
	ON [dbo].[p_Patient_Encounter] ([encounter_status], [office_id], [cpr_id], [encounter_id], [encounter_date], [billing_posted], [attending_doctor], [patient_location], [patient_workplan_id], [referring_doctor], [new_flag], [encounter_description], [encounter_type])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
GRANT DELETE
	ON [dbo].[p_Patient_Encounter]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[p_Patient_Encounter]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[p_Patient_Encounter]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[p_Patient_Encounter]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[p_Patient_Encounter]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Patient_Encounter] SET (LOCK_ESCALATION = TABLE)
GO

