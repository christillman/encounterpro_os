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

-- Drop Table [dbo].[p_Treatment_Item]
Print 'Drop Table [dbo].[p_Treatment_Item]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Treatment_Item]') AND [type]='U'))
DROP TABLE [dbo].[p_Treatment_Item]
GO
-- Create Table [dbo].[p_Treatment_Item]
Print 'Create Table [dbo].[p_Treatment_Item]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Treatment_Item] (
		[cpr_id]                            [varchar](12) NOT NULL,
		[treatment_id]                      [int] IDENTITY(1, 1) NOT NULL,
		[open_encounter_id]                 [int] NOT NULL,
		[treatment_type]                    [varchar](24) NULL,
		[package_id]                        [varchar](24) NULL,
		[specialty_id]                      [varchar](24) NULL,
		[procedure_id]                      [varchar](24) NULL,
		[drug_id]                           [varchar](24) NULL,
		[material_id]                       [int] NULL,
		[observation_id]                    [varchar](24) NULL,
		[treatment_mode]                    [varchar](24) NULL,
		[begin_date]                        [datetime] NULL,
		[administration_sequence]           [smallint] NULL,
		[dose_amount]                       [real] NULL,
		[dose_unit]                         [varchar](12) NULL,
		[administer_frequency]              [varchar](12) NULL,
		[duration_amount]                   [real] NULL,
		[duration_unit]                     [varchar](16) NULL,
		[duration_prn]                      [varchar](32) NULL,
		[dispense_amount]                   [real] NULL,
		[office_dispense_amount]            [real] NULL,
		[dispense_unit]                     [varchar](12) NULL,
		[brand_name_required]               [varchar](1) NULL,
		[refills]                           [smallint] NULL,
		[treatment_description]             [varchar](80) NULL,
		[treatment_goal]                    [varchar](80) NULL,
		[location]                          [varchar](24) NULL,
		[maker_id]                          [varchar](24) NULL,
		[lot_number]                        [varchar](24) NULL,
		[expiration_date]                   [datetime] NULL,
		[send_out_flag]                     [char](1) NULL,
		[attachment_id]                     [int] NULL,
		[original_treatment_id]             [int] NULL,
		[parent_treatment_id]               [int] NULL,
		[attach_flag]                       [varchar](1) NULL,
		[referral_question]                 [varchar](12) NULL,
		[referral_question_assmnt_id]       [varchar](24) NULL,
		[ordered_by]                        [varchar](24) NULL,
		[signature_attachment_sequence]     [smallint] NULL,
		[office_id]                         [varchar](4) NULL,
		[risk_level]                        [int] NULL,
		[treatment_sequence]                [smallint] NULL,
		[treatment_status]                  [varchar](12) NULL,
		[end_date]                          [datetime] NULL,
		[close_encounter_id]                [int] NULL,
		[created]                           [datetime] NULL,
		[created_by]                        [varchar](24) NULL,
		[id]                                [uniqueidentifier] NOT NULL,
		[default_grant]                     [bit] NOT NULL,
		[vial_type]                         [varchar](24) NULL,
		[completed_by]                      [varchar](24) NULL,
		[open_flag]                         [char](1) NOT NULL,
		[specimen_id]                       [varchar](40) NULL,
		[bill_procedure]                    [bit] NOT NULL,
		[bill_observation_collect]          [bit] NOT NULL,
		[bill_observation_perform]          [bit] NOT NULL,
		[bill_children_collect]             [bit] NOT NULL,
		[bill_children_perform]             [bit] NOT NULL,
		[ordered_by_supervisor]             [varchar](24) NULL,
		[appointment_date_time]             [datetime] NULL,
		[ordered_for]                       [varchar](24) NULL,
		[key_field]                         [char](1) NULL,
		[treatment_key]                     [varchar](40) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Treatment_Item]
	ADD
	CONSTRAINT [PK_p_Treatment_Item_1__11]
	PRIMARY KEY
	CLUSTERED
	([cpr_id], [treatment_id])
	WITH FILLFACTOR=70
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Treatment_Item]
	ADD
	CONSTRAINT [DF__p_Treatme__creat__75235608]
	DEFAULT (getdate()) FOR [created]
GO
ALTER TABLE [dbo].[p_Treatment_Item]
	ADD
	CONSTRAINT [DF__p_Treatment___id__76177A41]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[p_Treatment_Item]
	ADD
	CONSTRAINT [DF__p_treatment_bill_chld_collect]
	DEFAULT ((0)) FOR [bill_children_collect]
GO
ALTER TABLE [dbo].[p_Treatment_Item]
	ADD
	CONSTRAINT [DF__p_treatment_bill_chld_perform]
	DEFAULT ((0)) FOR [bill_children_perform]
GO
ALTER TABLE [dbo].[p_Treatment_Item]
	ADD
	CONSTRAINT [DF__p_treatment_bill_obs_collect]
	DEFAULT ((1)) FOR [bill_observation_collect]
GO
ALTER TABLE [dbo].[p_Treatment_Item]
	ADD
	CONSTRAINT [DF__p_treatment_bill_obs_perform]
	DEFAULT ((1)) FOR [bill_observation_perform]
GO
ALTER TABLE [dbo].[p_Treatment_Item]
	ADD
	CONSTRAINT [DF__p_treatment_bill_proc]
	DEFAULT ((1)) FOR [bill_procedure]
GO
ALTER TABLE [dbo].[p_Treatment_Item]
	ADD
	CONSTRAINT [DF__p_treatment_default_grant]
	DEFAULT ((1)) FOR [default_grant]
GO
ALTER TABLE [dbo].[p_Treatment_Item]
	ADD
	CONSTRAINT [DF__p_treatment_open_flag]
	DEFAULT ('Y') FOR [open_flag]
GO
CREATE NONCLUSTERED INDEX [idx_cpr_id_treatment_key]
	ON [dbo].[p_Treatment_Item] ([cpr_id], [treatment_key], [key_field], [begin_date])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_treatment_key]
	ON [dbo].[p_Treatment_Item] ([treatment_type], [treatment_key], [cpr_id], [treatment_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_treatment_status]
	ON [dbo].[p_Treatment_Item] ([treatment_status], [treatment_type], [cpr_id], [treatment_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [trt_begin_date]
	ON [dbo].[p_Treatment_Item] ([treatment_type], [begin_date], [specialty_id], [treatment_status])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [trt_created_date]
	ON [dbo].[p_Treatment_Item] ([treatment_type], [created], [treatment_status])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [trt_drug_id]
	ON [dbo].[p_Treatment_Item] ([drug_id], [cpr_id], [treatment_id], [treatment_status])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [trt_observation_id]
	ON [dbo].[p_Treatment_Item] ([observation_id], [cpr_id], [treatment_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [trt_open_treatments]
	ON [dbo].[p_Treatment_Item] ([open_flag], [treatment_type], [cpr_id], [treatment_id], [open_encounter_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [trt_parent_treatment_id]
	ON [dbo].[p_Treatment_Item] ([parent_treatment_id], [cpr_id], [treatment_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [trt_treatment_id]
	ON [dbo].[p_Treatment_Item] ([treatment_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
GRANT DELETE
	ON [dbo].[p_Treatment_Item]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[p_Treatment_Item]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[p_Treatment_Item]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[p_Treatment_Item]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[p_Treatment_Item]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Treatment_Item] SET (LOCK_ESCALATION = TABLE)
GO

