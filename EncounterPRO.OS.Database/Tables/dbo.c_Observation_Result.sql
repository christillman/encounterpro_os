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

-- Drop Table [dbo].[c_Observation_Result]
Print 'Drop Table [dbo].[c_Observation_Result]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_Observation_Result]') AND [type]='U'))
DROP TABLE [dbo].[c_Observation_Result]
GO
-- Create Table [dbo].[c_Observation_Result]
Print 'Create Table [dbo].[c_Observation_Result]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_Observation_Result] (
		[observation_id]             [varchar](24) NOT NULL,
		[result_sequence]            [smallint] NOT NULL,
		[result_type]                [varchar](12) NULL,
		[result_unit]                [varchar](12) NULL,
		[result]                     [varchar](80) NOT NULL,
		[result_amount_flag]         [char](1) NULL,
		[print_result_flag]          [char](1) NULL,
		[severity]                   [smallint] NULL,
		[abnormal_flag]              [char](1) NULL,
		[specimen_type]              [varchar](24) NULL,
		[specimen_amount]            [decimal](18, 9) NULL,
		[external_source]            [varchar](24) NULL,
		[property_id]                [int] NULL,
		[service]                    [varchar](24) NULL,
		[print_result_separator]     [varchar](8) NULL,
		[unit_preference]            [varchar](24) NULL,
		[display_mask]               [varchar](40) NULL,
		[sort_sequence]              [smallint] NULL,
		[status]                     [varchar](12) NULL,
		[last_updated]               [datetime] NULL,
		[updated_by]                 [varchar](24) NULL,
		[id]                         [uniqueidentifier] NOT NULL,
		[property_address]           [varchar](80) NULL,
		[normal_range]               [varchar](40) NULL,
		[object_key]                 AS (([observation_id]+'|')+CONVERT([varchar](12),[result_sequence],0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Observation_Result]
	ADD
	CONSTRAINT [PK_c_Observation_Result_27]
	PRIMARY KEY
	CLUSTERED
	([observation_id], [result_sequence])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_Observation_Result]
	ADD
	CONSTRAINT [DF__c_Observa__last___3B80C458]
	DEFAULT (dbo.get_client_datetime()) FOR [last_updated]
GO
ALTER TABLE [dbo].[c_Observation_Result]
	ADD
	CONSTRAINT [DF__c_Observa__print__3A8CA01F]
	DEFAULT ('Y') FOR [print_result_flag]
GO
ALTER TABLE [dbo].[c_Observation_Result]
	ADD
	CONSTRAINT [DF__c_Observa__print__52EF04EC]
	DEFAULT ('=') FOR [print_result_separator]
GO
ALTER TABLE [dbo].[c_Observation_Result]
	ADD
	CONSTRAINT [DF__c_Observatio__id__01892CED]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[c_Observation_Result]
	ADD
	CONSTRAINT [DF_c_obs_res_severity]
	DEFAULT ((0)) FOR [severity]
GO
CREATE NONCLUSTERED INDEX [idx_result_id]
	ON [dbo].[c_Observation_Result] ([id])
	WITH ( FILLFACTOR = 90) ON [PRIMARY]
GO
GRANT DELETE
	ON [dbo].[c_Observation_Result]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[c_Observation_Result]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[c_Observation_Result]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[c_Observation_Result]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[c_Observation_Result]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[c_Observation_Result] SET (LOCK_ESCALATION = TABLE)
GO

