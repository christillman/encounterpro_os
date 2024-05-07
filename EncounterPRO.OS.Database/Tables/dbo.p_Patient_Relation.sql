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

-- Drop Table [dbo].[p_Patient_Relation]
Print 'Drop Table [dbo].[p_Patient_Relation]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Patient_Relation]') AND [type]='U'))
DROP TABLE [dbo].[p_Patient_Relation]
GO
-- Create Table [dbo].[p_Patient_Relation]
Print 'Create Table [dbo].[p_Patient_Relation]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Patient_Relation] (
		[cpr_id]                          [varchar](12) NOT NULL,
		[relation_sequence]               [int] IDENTITY(1, 1) NOT NULL,
		[relation_cpr_id]                 [varchar](12) NOT NULL,
		[relationship]                    [varchar](24) NOT NULL,
		[maternal_sibling_flag]           [char](1) NOT NULL,
		[paternal_sibling_flag]           [char](1) NOT NULL,
		[parent_flag]                     [char](1) NOT NULL,
		[guardian_flag]                   [char](1) NOT NULL,
		[guarantor_flag]                  [char](1) NOT NULL,
		[payor_flag]                      [char](1) NOT NULL,
		[created]                         [datetime] NOT NULL,
		[created_by]                      [varchar](24) NOT NULL,
		[modified]                        [datetime] NULL,
		[modified_by]                     [varchar](24) NULL,
		[status]                          [varchar](8) NOT NULL,
		[status_date]                     [datetime] NOT NULL,
		[primary_decision_maker_flag]     [char](1) NOT NULL,
		[relation_order]                  [int] NULL,
		[attachment_id]                   [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Patient_Relation]
	ADD
	CONSTRAINT [PK_p_Patient_Relation]
	PRIMARY KEY
	CLUSTERED
	([cpr_id], [relation_sequence])
	WITH FILLFACTOR=80
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Patient_Relation]
	ADD
	CONSTRAINT [DF__p_Patient_Relation_created]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
ALTER TABLE [dbo].[p_Patient_Relation]
	ADD
	CONSTRAINT [DF__p_Patient_Relation_guarantor_flag]
	DEFAULT ('N') FOR [guarantor_flag]
GO
ALTER TABLE [dbo].[p_Patient_Relation]
	ADD
	CONSTRAINT [DF__p_Patient_Relation_guardian_flag]
	DEFAULT ('N') FOR [guardian_flag]
GO
ALTER TABLE [dbo].[p_Patient_Relation]
	ADD
	CONSTRAINT [DF__p_Patient_Relation_mat_sib_flag]
	DEFAULT ('N') FOR [maternal_sibling_flag]
GO
ALTER TABLE [dbo].[p_Patient_Relation]
	ADD
	CONSTRAINT [DF__p_Patient_Relation_parent_flag]
	DEFAULT ('N') FOR [parent_flag]
GO
ALTER TABLE [dbo].[p_Patient_Relation]
	ADD
	CONSTRAINT [DF__p_Patient_Relation_pat_sib_flag]
	DEFAULT ('N') FOR [paternal_sibling_flag]
GO
ALTER TABLE [dbo].[p_Patient_Relation]
	ADD
	CONSTRAINT [DF__p_Patient_Relation_payor_flag]
	DEFAULT ('N') FOR [payor_flag]
GO
ALTER TABLE [dbo].[p_Patient_Relation]
	ADD
	CONSTRAINT [DF__p_Patient_Relation_pri_decision_mkr_flag]
	DEFAULT ('N') FOR [primary_decision_maker_flag]
GO
ALTER TABLE [dbo].[p_Patient_Relation]
	ADD
	CONSTRAINT [DF__p_Patient_Relation_status]
	DEFAULT ('OK') FOR [status]
GO
ALTER TABLE [dbo].[p_Patient_Relation]
	ADD
	CONSTRAINT [DF__p_Patient_Relation_status_date]
	DEFAULT (dbo.get_client_datetime()) FOR [status_date]
GO
GRANT DELETE
	ON [dbo].[p_Patient_Relation]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[p_Patient_Relation]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[p_Patient_Relation]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[p_Patient_Relation]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Patient_Relation] SET (LOCK_ESCALATION = TABLE)
GO

