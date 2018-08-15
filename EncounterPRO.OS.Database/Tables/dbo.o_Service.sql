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

-- Drop Table [dbo].[o_Service]
Print 'Drop Table [dbo].[o_Service]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[o_Service]') AND [type]='U'))
DROP TABLE [dbo].[o_Service]
GO
-- Create Table [dbo].[o_Service]
Print 'Create Table [dbo].[o_Service]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[o_Service] (
		[service]                        [varchar](24) NOT NULL,
		[description]                    [varchar](80) NULL,
		[button]                         [varchar](64) NULL,
		[icon]                           [varchar](64) NULL,
		[general_flag]                   [char](1) NULL,
		[patient_flag]                   [char](1) NULL,
		[encounter_flag]                 [char](1) NULL,
		[assessment_flag]                [char](1) NULL,
		[treatment_flag]                 [char](1) NULL,
		[observation_flag]               [char](1) NULL,
		[attachment_flag]                [char](1) NULL,
		[close_flag]                     [char](1) NULL,
		[signature_flag]                 [char](1) NULL,
		[owner_flag]                     [char](1) NULL,
		[visible_flag]                   [char](1) NULL,
		[secure_flag]                    [char](1) NULL,
		[component_id]                   [varchar](24) NULL,
		[order_url]                      [varchar](128) NULL,
		[perform_url]                    [varchar](128) NULL,
		[mf_order_url]                   [varchar](128) NULL,
		[mf_perform_url]                 [varchar](128) NULL,
		[status]                         [varchar](12) NULL,
		[id]                             [uniqueidentifier] NOT NULL,
		[owner_id]                       [int] NOT NULL,
		[last_updated]                   [datetime] NOT NULL,
		[definition]                     [varchar](80) NULL,
		[default_expiration_time]        [int] NULL,
		[default_expiration_unit_id]     [varchar](24) NULL,
		[default_context_object]         [varchar](24) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [PK_o_Service_01]
	PRIMARY KEY
	CLUSTERED
	([service])
	WITH FILLFACTOR=90
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__assmnt_6B99EBCE]
	DEFAULT ('N') FOR [assessment_flag]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__attch__6C8E1007]
	DEFAULT ('N') FOR [attachment_flag]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__close__65E11278]
	DEFAULT ('N') FOR [close_flag]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__encou__68BD7F23]
	DEFAULT ('N') FOR [encounter_flag]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__gener__6AA5C795]
	DEFAULT ('N') FOR [general_flag]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__last___5EA4A76D]
	DEFAULT (getdate()) FOR [last_updated]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__obser__6C8E1007]
	DEFAULT ('N') FOR [observation_flag]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__owner__514AAC4F]
	DEFAULT ((-1)) FOR [owner_id]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__owner__67C95AEA]
	DEFAULT ('N') FOR [owner_flag]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__patie__69B1A35C]
	DEFAULT ('N') FOR [patient_flag]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__secur__6E765879]
	DEFAULT ('N') FOR [secure_flag]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__signa__66D536B1]
	DEFAULT ('N') FOR [signature_flag]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__treat__6B99EBCE]
	DEFAULT ('N') FOR [treatment_flag]
GO
ALTER TABLE [dbo].[o_Service]
	ADD
	CONSTRAINT [DF__o_Service__visib__6D823440]
	DEFAULT ('Y') FOR [visible_flag]
GO
ALTER TABLE [dbo].[o_Service]
	ADD CONSTRAINT [DF__o_Service__id]
	DEFAULT (newid()) FOR [id]
GO
GRANT DELETE
	ON [dbo].[o_Service]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[o_Service]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[o_Service]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[o_Service]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[o_Service]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[o_Service] SET (LOCK_ESCALATION = TABLE)
GO

