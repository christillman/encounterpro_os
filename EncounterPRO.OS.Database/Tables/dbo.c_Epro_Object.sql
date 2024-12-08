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

-- Drop Table [dbo].[c_Epro_Object]
Print 'Drop Table [dbo].[c_Epro_Object]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Epro_Object]') AND [type]='U'))
DROP TABLE [dbo].[c_Epro_Object]
GO
-- Create Table [dbo].[c_Epro_Object]
Print 'Create Table [dbo].[c_Epro_Object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Epro_Object] (
		[epro_object]                       [varchar](24) NOT NULL,
		[object_type]                       [varchar](24) NOT NULL,
		[description]                       [varchar](40) NOT NULL,
		[default_which_object]              [varchar](255) NULL,
		[base_tablename]                    [varchar](64) NULL,
		[base_table_key_column]             [varchar](64) NULL,
		[base_table_filter]                 [varchar](255) NULL,
		[base_table_sort]                   [varchar](255) NULL,
		[default_display_property_name]     [varchar](64) NULL,
		[object_help]                       [varchar](1024) NULL,
		[id]                                [uniqueidentifier] NOT NULL,
		[last_updated]                      [datetime] NOT NULL,
		[base_table_query]                  [nvarchar](max) NULL,
		[default_ordinal]                   [nchar](10) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Epro_Object]
	ADD
	CONSTRAINT [PK_c_Epro_Object_50]
	PRIMARY KEY
	CLUSTERED
	([epro_object])
	WITH FILLFACTOR=70
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Epro_Object]
	ADD
	CONSTRAINT [DF__c_Epro_Object_id_4]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[c_Epro_Object]
	ADD
	CONSTRAINT [DF__c_Epro_Object_last_updated_4]
	DEFAULT (dbo.get_client_datetime()) FOR [last_updated]
GO
GRANT SELECT ON [dbo].[c_Epro_Object] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Epro_Object] SET (LOCK_ESCALATION = TABLE)
GO

