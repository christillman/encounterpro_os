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

-- Drop Table [dbo].[c_Config_Object_Library]
Print 'Drop Table [dbo].[c_Config_Object_Library]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Config_Object_Library]') AND [type]='U'))
DROP TABLE [dbo].[c_Config_Object_Library]
GO
-- Create Table [dbo].[c_Config_Object_Library]
Print 'Create Table [dbo].[c_Config_Object_Library]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Config_Object_Library] (
		[config_object_id]            [uniqueidentifier] NOT NULL,
		[config_object_type]          [varchar](24) NOT NULL,
		[context_object]              [varchar](24) NOT NULL,
		[description]                 [varchar](80) NOT NULL,
		[long_description]            [text] NULL,
		[config_object_category]      [varchar](80) NULL,
		[production_version]          [int] NULL,
		[production_version_date]     [datetime] NULL,
		[beta_version]                [int] NULL,
		[beta_version_date]           [datetime] NULL,
		[testing_version]             [int] NULL,
		[testing_version_date]        [datetime] NULL,
		[owner_id]                    [int] NOT NULL,
		[owner_description]           [varchar](80) NOT NULL,
		[created]                     [datetime] NOT NULL,
		[created_by]                  [varchar](24) NOT NULL,
		[status]                      [varchar](12) NOT NULL,
		[copyright_status]            [varchar](24) NOT NULL,
		[copyable]                    [bit] NOT NULL,
		[license_data]                [varchar](2000) NULL,
		[license_status]              [varchar](24) NULL,
		[license_expiration_date]     [datetime] NULL,
		[latest_version]              [int] NULL,
		[latest_version_date]         [datetime] NULL,
		[latest_version_status]       [varchar](12) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Config_Object_Library]
	ADD
	CONSTRAINT [PK_c_Config_Object_Library]
	PRIMARY KEY
	CLUSTERED
	([config_object_id])
	WITH FILLFACTOR=70
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Config_Object_Library]
	ADD
	CONSTRAINT [DF_c_Config_Object_Library_copyable]
	DEFAULT ((1)) FOR [copyable]
GO
ALTER TABLE [dbo].[c_Config_Object_Library]
	ADD
	CONSTRAINT [DF_c_Config_Object_Library_copyright_status]
	DEFAULT ('Owner') FOR [copyright_status]
GO
ALTER TABLE [dbo].[c_Config_Object_Library]
	ADD
	CONSTRAINT [DF_c_Config_Object_Library_created]
	DEFAULT (getdate()) FOR [created]
GO
ALTER TABLE [dbo].[c_Config_Object_Library]
	ADD
	CONSTRAINT [DF_c_Config_Object_Library_owner_id]
	DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id]
GO
ALTER TABLE [dbo].[c_Config_Object_Library]
	ADD
	CONSTRAINT [DF_c_Config_Object_Library_status]
	DEFAULT ('OK') FOR [status]
GO
GRANT INSERT
	ON [dbo].[c_Config_Object_Library]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[c_Config_Object_Library]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[c_Config_Object_Library]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Config_Object_Library] SET (LOCK_ESCALATION = TABLE)
GO

