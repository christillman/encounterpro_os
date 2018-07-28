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

-- Drop Table [dbo].[c_Component_Version]
Print 'Drop Table [dbo].[c_Component_Version]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Component_Version]') AND [type]='U'))
DROP TABLE [dbo].[c_Component_Version]
GO
-- Create Table [dbo].[c_Component_Version]
Print 'Create Table [dbo].[c_Component_Version]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Component_Version] (
		[component_id]                 [varchar](24) NOT NULL,
		[version]                      [int] NOT NULL,
		[description]                  [varchar](80) NOT NULL,
		[version_description]          [text] NULL,
		[component_type]               [varchar](24) NOT NULL,
		[component_class]              [varchar](128) NULL,
		[component_location]           [varchar](255) NULL,
		[component_data]               [varchar](255) NULL,
		[owner_id]                     [int] NOT NULL,
		[created]                      [datetime] NOT NULL,
		[created_by]                   [varchar](24) NOT NULL,
		[status]                       [varchar](12) NOT NULL,
		[status_date_time]             [datetime] NOT NULL,
		[release_status]               [varchar](12) NULL,
		[release_status_date_time]     [datetime] NULL,
		[min_build]                    [int] NOT NULL,
		[min_modification_level]       [int] NOT NULL,
		[objectdata]                   [image] NULL,
		[id]                           [uniqueidentifier] NOT NULL,
		[installer]                    [varchar](24) NOT NULL,
		[independence]                 [varchar](24) NOT NULL,
		[system_id]                    [nvarchar](48) NOT NULL,
		[build]                        [int] NOT NULL,
		[build_name]                   [nvarchar](128) NOT NULL,
		[compile]                      [int] NOT NULL,
		[compile_name]                 [nvarchar](128) NOT NULL,
		[test_begin_date]              [datetime] NULL,
		[beta_begin_date]              [datetime] NULL,
		[release_date]                 [datetime] NULL,
		[build_status]                 [varchar](12) NOT NULL,
		[notes]                        [text] NULL,
		[max_modification_level]       [int] NULL,
		[last_updated]                 [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [PK_c_Component_Version]
	PRIMARY KEY
	CLUSTERED
	([component_id], [version])
	WITH FILLFACTOR=70
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF__c_Compone__build__6FC90A81]
	DEFAULT ((0)) FOR [build]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF__c_Compone__build__70BD2EBA]
	DEFAULT ('Unknown') FOR [build_name]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF__c_Compone__build__73999B65]
	DEFAULT ('Unknown') FOR [build_status]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF__c_Compone__compi__71B152F3]
	DEFAULT ((0)) FOR [compile]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF__c_Compone__compi__72A5772C]
	DEFAULT ('Unknown') FOR [compile_name]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF__c_Compone__indep__6DE0C20F]
	DEFAULT ('Unknown') FOR [independence]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF__c_Compone__insta__6CEC9DD6]
	DEFAULT ('NA') FOR [installer]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF__c_Compone__last___748DBF9E]
	DEFAULT (getdate()) FOR [last_updated]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF__c_Compone__syste__6ED4E648]
	DEFAULT ('Unknown') FOR [system_id]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF_c_Component_Version_created]
	DEFAULT (getdate()) FOR [created]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF_c_Component_Version_owner_id]
	DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF_c_Component_Version_rel_status]
	DEFAULT ('Production') FOR [release_status]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF_c_Component_Version_status]
	DEFAULT ('CheckedIn') FOR [status]
GO
ALTER TABLE [dbo].[c_Component_Version]
	ADD
	CONSTRAINT [DF_c_Component_Version_version]
	DEFAULT ((1)) FOR [version]
GO
GRANT INSERT
	ON [dbo].[c_Component_Version]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[c_Component_Version]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[c_Component_Version]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Component_Version] SET (LOCK_ESCALATION = TABLE)
GO

