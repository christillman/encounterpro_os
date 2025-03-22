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

-- Drop Table [dbo].[p_Attachment]
Print 'Drop Table [dbo].[p_Attachment]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Attachment]') AND [type]='U'))
DROP TABLE [dbo].[p_Attachment]
GO
-- Create Table [dbo].[p_Attachment]
Print 'Create Table [dbo].[p_Attachment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Attachment] (
		[attachment_id]                [int] IDENTITY(1, 1) NOT NULL,
		[cpr_id]                       [varchar](12) NULL,
		[encounter_id]                 [int] NULL,
		[problem_id]                   [int] NULL,
		[treatment_id]                 [int] NULL,
		[observation_sequence]         [int] NULL,
		[attachment_type]              [varchar](24) NULL,
		[attachment_tag]               [varchar](80) NULL,
		[attachment_file_path]         [varchar](128) NULL,
		[attachment_file]              [varchar](128) NULL,
		[extension]                    [varchar](24) NULL,
		[attachment_text]              [nvarchar](max) NULL,
		[attachment_image]             [varbinary](max) NULL,
		[storage_flag]                 [char](1) NULL,
		[attachment_date]              [datetime] NULL,
		[attachment_folder]            [varchar](40) NULL,
		[box_id]                       [int] NULL,
		[item_id]                      [int] NULL,
		[attached_by]                  [varchar](24) NULL,
		[created]                      [datetime] NULL,
		[created_by]                   [varchar](24) NULL,
		[status]                       [varchar](12) NULL,
		[id]                           [uniqueidentifier] NOT NULL,
		[context_object]               [varchar](24) NULL,
		[object_key]                   [int] NULL,
		[default_grant]                [bit] NOT NULL,
		[interpreted]                  [bit] NOT NULL,
		[owner_id]                     [int] NULL,
		[interfaceserviceid]           [int] NULL,
		[transportsequence]            [int] NULL,
		[patient_workplan_item_id]     [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Attachment]
	ADD
	CONSTRAINT [PK_p_Attachment_40]
	PRIMARY KEY
	NONCLUSTERED
	([attachment_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Attachment]
	ADD
	CONSTRAINT [DF__p_Attachm__statu__541767F8]
	DEFAULT ('OK') FOR [status]
GO
ALTER TABLE [dbo].[p_Attachment]
	ADD
	CONSTRAINT [DF__p_Attachment__id__550B8C31]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[p_Attachment]
	ADD
	CONSTRAINT [DF__p_attachment_default_grant]
	DEFAULT ((1)) FOR [default_grant]
GO
ALTER TABLE [dbo].[p_Attachment]
	ADD
	CONSTRAINT [DF__p_attachment_interpreted]
	DEFAULT ((0)) FOR [interpreted]
GO
ALTER TABLE [dbo].[p_Attachment]
	ADD
	CONSTRAINT [DF_p_att_created_40]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
CREATE CLUSTERED INDEX [idx_cpr_id]
	ON [dbo].[p_Attachment] ([cpr_id], [attachment_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 70) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[p_Attachment] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[p_Attachment] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[p_Attachment] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[p_Attachment] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[p_Attachment] TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Attachment] SET (LOCK_ESCALATION = TABLE)
GO

