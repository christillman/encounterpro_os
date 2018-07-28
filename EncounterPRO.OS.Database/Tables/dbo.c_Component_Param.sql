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

-- Drop Table [dbo].[c_Component_Param]
Print 'Drop Table [dbo].[c_Component_Param]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Component_Param]') AND [type]='U'))
DROP TABLE [dbo].[c_Component_Param]
GO
-- Create Table [dbo].[c_Component_Param]
Print 'Create Table [dbo].[c_Component_Param]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[c_Component_Param] (
		[id]                 [uniqueidentifier] NOT NULL,
		[param_sequence]     [int] IDENTITY(1, 1) NOT NULL,
		[param_class]        [varchar](40) NOT NULL,
		[param_mode]         [varchar](12) NULL,
		[sort_sequence]      [smallint] NULL,
		[param_title]        [varchar](80) NULL,
		[token1]             [varchar](40) NULL,
		[token2]             [varchar](40) NULL,
		[token3]             [varchar](40) NULL,
		[token4]             [varchar](40) NULL,
		[initial1]           [varchar](128) NULL,
		[initial2]           [varchar](128) NULL,
		[initial3]           [varchar](128) NULL,
		[initial4]           [varchar](128) NULL,
		[required_flag]      [char](1) NULL,
		[helptext]           [text] NULL,
		[query]              [text] NULL,
		[min_build]          [int] NULL,
		[last_updated]       [datetime] NOT NULL,
		[param_id]           [uniqueidentifier] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Component_Param]
	ADD
	CONSTRAINT [PK_Comp_params_40]
	PRIMARY KEY
	CLUSTERED
	([id], [param_sequence])
	WITH FILLFACTOR=90
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Component_Param]
	ADD
	CONSTRAINT [DF__c_Component_Param_last_updated_5]
	DEFAULT (getdate()) FOR [last_updated]
GO
ALTER TABLE [dbo].[c_Component_Param]
	ADD
	CONSTRAINT [DF__c_Component_Param_param_id_5]
	DEFAULT (newid()) FOR [param_id]
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_param_id]
	ON [dbo].[c_Component_Param] ([param_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_param_sequence]
	ON [dbo].[c_Component_Param] ([param_sequence])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
GRANT DELETE
	ON [dbo].[c_Component_Param]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[c_Component_Param]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[c_Component_Param]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[c_Component_Param]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[c_Component_Param]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Component_Param] SET (LOCK_ESCALATION = TABLE)
GO

