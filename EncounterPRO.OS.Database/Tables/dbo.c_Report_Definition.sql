﻿--EncounterPRO Open Source Project
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

-- Drop Table [dbo].[c_Report_Definition]
Print 'Drop Table [dbo].[c_Report_Definition]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Report_Definition]') AND [type]='U'))
DROP TABLE [dbo].[c_Report_Definition]
GO
-- Create Table [dbo].[c_Report_Definition]
Print 'Create Table [dbo].[c_Report_Definition]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Report_Definition] (
		[report_id]                [uniqueidentifier] NOT NULL,
		[description]              [varchar](80) NOT NULL,
		[report_type]              [varchar](24) NOT NULL,
		[report_category]          [varchar](24) NULL,
		[component_id]             [varchar](24) NULL,
		[sql]                      [text] NULL,
		[template]                 [image] NULL,
		[status]                   [varchar](12) NULL,
		[owner_id]                 [int] NOT NULL,
		[last_updated]             [datetime] NOT NULL,
		[id]                       [uniqueidentifier] NOT NULL,
		[machine_component_id]     [varchar](24) NULL,
		[long_description]         [text] NULL,
		[example]                  [image] NULL,
		[version]                  [int] NULL,
		[document_format]          [varchar](24) NOT NULL,
		[config_object_type]       [varchar](24) NOT NULL,
		[created_by]               [varchar](24) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Report_Definition]
	ADD
	CONSTRAINT [PK_c_Report_Definition_40]
	PRIMARY KEY
	CLUSTERED
	([report_id])
	WITH FILLFACTOR=90
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Report_Definition]
	ADD
	CONSTRAINT [DF__c_Report___last___5F98CBA6]
	DEFAULT (getdate()) FOR [last_updated]
GO
ALTER TABLE [dbo].[c_Report_Definition]
	ADD
	CONSTRAINT [DF__c_Report___owner__523ED088]
	DEFAULT ((-1)) FOR [owner_id]
GO
ALTER TABLE [dbo].[c_Report_Definition]
	ADD
	CONSTRAINT [DF__c_Report_Def__id__692235E0]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[c_Report_Definition]
	ADD
	CONSTRAINT [DF__c_Report_Def_config_obj_type_129]
	DEFAULT ('Report') FOR [config_object_type]
GO
ALTER TABLE [dbo].[c_Report_Definition]
	ADD
	CONSTRAINT [DF__c_Report_Def_created_by]
	DEFAULT ([dbo].[fn_current_epro_user]()) FOR [created_by]
GO
ALTER TABLE [dbo].[c_Report_Definition]
	ADD
	CONSTRAINT [DF__c_Report_Def_doc_format_127]
	DEFAULT ('Human') FOR [document_format]
GO
ALTER TABLE [dbo].[c_Report_Definition]
	ADD
	CONSTRAINT [DF_c_Report_Definition_report_id]
	DEFAULT (newid()) FOR [report_id]
GO
GRANT DELETE
	ON [dbo].[c_Report_Definition]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[c_Report_Definition]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[c_Report_Definition]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[c_Report_Definition]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[c_Report_Definition]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Report_Definition] SET (LOCK_ESCALATION = TABLE)
GO
