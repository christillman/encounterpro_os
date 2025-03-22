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

-- Drop Table [dbo].[c_Observation]
Print 'Drop Table [dbo].[c_Observation]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Observation]') AND [type]='U'))
DROP TABLE [dbo].[c_Observation]
GO
-- Create Table [dbo].[c_Observation]
Print 'Create Table [dbo].[c_Observation]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Observation] (
		[observation_id]                 [varchar](24) NOT NULL,
		[collection_location_domain]     [varchar](12) NULL,
		[perform_location_domain]        [varchar](12) NULL,
		[collection_procedure_id]        [varchar](24) NULL,
		[perform_procedure_id]           [varchar](24) NULL,
		[specimen_type]                  [varchar](24) NULL,
		[description]                    [varchar](120) NULL,
		[narrative_phrase]               [nvarchar](max) NULL,
		[observation_type]               [varchar](24) NOT NULL,
		[composite_flag]                 [char](1) NULL,
		[exclusive_flag]                 [char](1) NULL,
		[location_pick_flag]             [char](1) NULL,
		[location_bill_flag]             [char](1) NULL,
		[in_context_flag]                [char](1) NULL,
		[display_only_flag]              [char](1) NULL,
		[display_style]                  [varchar](255) NULL,
		[material_id]                    [int] NULL,
		[default_view]                   [char](1) NULL,
		[legal_notice]                   [nvarchar](max) NULL,
		[sort_sequence]                  [int] NULL,
		[result_count]                   [int] NULL,
		[status]                         [varchar](12) NULL,
		[last_updated]                   [datetime] NULL,
		[updated_by]                     [varchar](24) NULL,
		[id]                             [uniqueidentifier] NOT NULL,
		[owner_id]                       [int] NOT NULL,
		[definition]                     [varchar](120) NULL,
		[owner_key]                      [varchar](40) NULL,
		[observation_key]                [int] IDENTITY(1, 1) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Observation]
	ADD
	CONSTRAINT [PK_c_Observation_40]
	PRIMARY KEY
	CLUSTERED
	([observation_id])
	WITH FILLFACTOR=90
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Observation]
	ADD
	CONSTRAINT [DF__c_Observa__displ__31F75A1E]
	DEFAULT ('N') FOR [display_only_flag]
GO
ALTER TABLE [dbo].[c_Observation]
	ADD
	CONSTRAINT [DF__c_Observa__in_co__665613C4]
	DEFAULT ('N') FOR [in_context_flag]
GO
ALTER TABLE [dbo].[c_Observation]
	ADD
	CONSTRAINT [DF__c_Observa__last___32EB7E57]
	DEFAULT (dbo.get_client_datetime()) FOR [last_updated]
GO
ALTER TABLE [dbo].[c_Observation]
	ADD
	CONSTRAINT [DF__c_Observa__obser__310335E5]
	DEFAULT ('Subjective') FOR [observation_type]
GO
ALTER TABLE [dbo].[c_Observation]
	ADD
	CONSTRAINT [DF__c_Observa__owner__4D7A1B6B]
	DEFAULT ((-1)) FOR [owner_id]
GO
ALTER TABLE [dbo].[c_Observation]
	ADD
	CONSTRAINT [DF__c_Observatio__id__33DFA290]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[c_Observation]
	ADD
	CONSTRAINT [DF_c_Observat_composite]
	DEFAULT ('N') FOR [composite_flag]
GO
ALTER TABLE [dbo].[c_Observation]
	ADD
	CONSTRAINT [DF_c_Observat_exclusive]
	DEFAULT ('N') FOR [exclusive_flag]
GO
ALTER TABLE [dbo].[c_Observation]
	ADD
	CONSTRAINT [DF_c_Observat_status_1__14]
	DEFAULT ('OK') FOR [status]
GO
CREATE NONCLUSTERED INDEX [collection_proc]
	ON [dbo].[c_Observation] ([collection_procedure_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_c_Observation_id]
	ON [dbo].[c_Observation] ([id], [owner_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_owner_description]
	ON [dbo].[c_Observation] ([description], [owner_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_owner_key]
	ON [dbo].[c_Observation] ([owner_key], [owner_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [perform_proc]
	ON [dbo].[c_Observation] ([perform_procedure_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_Observation] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_Observation] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_Observation] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_Observation] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_Observation] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Observation] SET (LOCK_ESCALATION = TABLE)
GO

CREATE NONCLUSTERED INDEX [ix_c_Observation_last_updated]
ON [dbo].[c_Observation] ([last_updated])
