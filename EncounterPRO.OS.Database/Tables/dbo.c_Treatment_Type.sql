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

-- Drop Table [dbo].[c_Treatment_Type]
Print 'Drop Table [dbo].[c_Treatment_Type]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Treatment_Type]') AND [type]='U'))
DROP TABLE [dbo].[c_Treatment_Type]
GO
-- Create Table [dbo].[c_Treatment_Type]
Print 'Create Table [dbo].[c_Treatment_Type]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Treatment_Type] (
		[treatment_type]                            [varchar](24) NOT NULL,
		[component_id]                              [varchar](24) NULL,
		[description]                               [varchar](80) NULL,
		[in_office_flag]                            [char](1) NULL,
		[define_title]                              [varchar](20) NULL,
		[button]                                    [varchar](64) NULL,
		[icon]                                      [varchar](64) NULL,
		[sort_sequence]                             [int] NULL,
		[workplan_id]                               [int] NULL,
		[followup_flag]                             [char](1) NULL,
		[observation_type]                          [varchar](24) NULL,
		[soap_display_rule]                         [varchar](24) NULL,
		[composite_flag]                            [char](1) NULL,
		[workplan_close_flag]                       [char](1) NULL,
		[workplan_cancel_flag]                      [char](1) NULL,
		[referral_specialty_id]                     [varchar](24) NULL,
		[attachment_folder]                         [varchar](40) NULL,
		[display_format]                            [varchar](40) NULL,
		[risk_level]                                [int] NULL,
		[complexity]                                [int] NULL,
		[status]                                    [varchar](12) NULL,
		[id]                                        [uniqueidentifier] NOT NULL,
		[display_script_id]                         [int] NULL,
		[update_flag]                               [char](1) NOT NULL,
		[owner_id]                                  [int] NOT NULL,
		[last_updated]                              [datetime] NOT NULL,
		[open_menu_id]                              [int] NULL,
		[closed_menu_id]                            [int] NULL,
		[past_treatment_menu_id]                    [int] NULL,
		[bill_procedure]                            [bit] NOT NULL,
		[bill_observation_collect]                  [bit] NOT NULL,
		[bill_observation_perform]                  [bit] NOT NULL,
		[bill_children_collect]                     [bit] NOT NULL,
		[bill_children_perform]                     [bit] NOT NULL,
		[default_duplicate_check_days]              [int] NULL,
		[epro_object]                               [varchar](24) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD
	CONSTRAINT [PK___c_Treatment__type]
	PRIMARY KEY
	CLUSTERED
	([treatment_type])
	WITH FILLFACTOR=90
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD
	CONSTRAINT [DF__c_Treatme__bill_children_collect]
	DEFAULT ((0)) FOR [bill_children_collect]
GO
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD
	CONSTRAINT [DF__c_Treatme__bill_children_perform]
	DEFAULT ((0)) FOR [bill_children_perform]
GO
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD
	CONSTRAINT [DF__c_Treatme__bill_observation_collect]
	DEFAULT ((1)) FOR [bill_observation_collect]
GO
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD
	CONSTRAINT [DF__c_Treatme__bill_observation_perform]
	DEFAULT ((1)) FOR [bill_observation_perform]
GO
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD
	CONSTRAINT [DF__c_Treatme__bill_procedure]
	DEFAULT ((1)) FOR [bill_procedure]
GO
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD
	CONSTRAINT [DF__c_Treatme__follo__3F73B2D2]
	DEFAULT ('N') FOR [followup_flag]
GO
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD
	CONSTRAINT [DF__c_Treatme__last___5DB08334]
	DEFAULT (dbo.get_client_datetime()) FOR [last_updated]
GO
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD
	CONSTRAINT [DF__c_Treatme__owner__50568816]
	DEFAULT ((-1)) FOR [owner_id]
GO
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD
	CONSTRAINT [DF__c_Treatme__updat__49A98A87]
	DEFAULT ('Y') FOR [update_flag]
GO
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD
	CONSTRAINT [DF__c_Treatme__workp__4067D70B]
	DEFAULT ('N') FOR [workplan_close_flag]
GO
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD
	CONSTRAINT [DF__c_Treatme__workp__415BFB44]
	DEFAULT ('N') FOR [workplan_cancel_flag]
GO
ALTER TABLE [dbo].[c_Treatment_Type]
	ADD
	CONSTRAINT [DF__c_Treatment___id__42501F7D]
	DEFAULT (newid()) FOR [id]
GO
CREATE NONCLUSTERED INDEX [idx_c_Treatment_Type_id]
	ON [dbo].[c_Treatment_Type] ([id], [treatment_type])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Treatment_Type] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Treatment_Type] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Treatment_Type] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Treatment_Type] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Treatment_Type] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Treatment_Type] SET (LOCK_ESCALATION = TABLE)
GO

