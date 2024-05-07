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

-- Drop Table [dbo].[p_Assessment]
Print 'Drop Table [dbo].[p_Assessment]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Assessment]') AND [type]='U'))
DROP TABLE [dbo].[p_Assessment]
GO
-- Create Table [dbo].[p_Assessment]
Print 'Create Table [dbo].[p_Assessment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Assessment] (
		[cpr_id]                 [varchar](12) NOT NULL,
		[problem_id]             [int] NOT NULL,
		[diagnosis_sequence]     [smallint] NOT NULL,
		[open_encounter_id]      [int] NULL,
		[assessment_type]        [varchar](12) NULL,
		[assessment_id]          [varchar](24) NOT NULL,
		[assessment]             [varchar](80) NULL,
		[location]               [varchar](24) NULL,
		[begin_date]             [datetime] NULL,
		[diagnosed_by]           [varchar](24) NULL,
		[assessment_status]      [varchar](12) NULL,
		[end_date]               [datetime] NULL,
		[close_encounter_id]     [int] NULL,
		[current_flag]           [char](1) NOT NULL,
		[created]                [datetime] NULL,
		[created_by]             [varchar](24) NULL,
		[attachment_id]          [int] NULL,
		[risk_level]             [int] NULL,
		[id]                     [uniqueidentifier] NOT NULL,
		[default_grant]          [bit] NOT NULL,
		[sort_sequence]          [int] NULL,
		[acuteness]              [varchar](24) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Assessment]
	ADD
	CONSTRAINT [PK_p_Assessment_1_40]
	PRIMARY KEY
	CLUSTERED
	([cpr_id], [problem_id], [diagnosis_sequence])
	WITH FILLFACTOR=80
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Assessment]
	ADD
	CONSTRAINT [DF__p_Assessm__creat__7854C86E]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
ALTER TABLE [dbo].[p_Assessment]
	ADD
	CONSTRAINT [DF__p_assessm_curflg]
	DEFAULT ('Y') FOR [current_flag]
GO
ALTER TABLE [dbo].[p_Assessment]
	ADD
	CONSTRAINT [DF__p_assessm_default_grant]
	DEFAULT ((1)) FOR [default_grant]
GO
ALTER TABLE [dbo].[p_Assessment]
	ADD
	CONSTRAINT [DF__p_Assessment__id__7948ECA7]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[p_Assessment]
	ADD
	CONSTRAINT [DF__p_Assessment_sort_sequence]
	DEFAULT ((0)) FOR [sort_sequence]
GO
CREATE NONCLUSTERED INDEX [idx_assessment_id]
	ON [dbo].[p_Assessment] ([assessment_id], [assessment_status], [cpr_id], [problem_id], [created])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_p_assessment_guid]
	ON [dbo].[p_Assessment] ([id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
GRANT DELETE
	ON [dbo].[p_Assessment]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[p_Assessment]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[p_Assessment]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[p_Assessment]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[p_Assessment]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Assessment] SET (LOCK_ESCALATION = TABLE)
GO

