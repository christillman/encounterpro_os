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

-- Drop Table [dbo].[p_Observation_Result]
Print 'Drop Table [dbo].[p_Observation_Result]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Observation_Result]') AND [type]='U'))
DROP TABLE [dbo].[p_Observation_Result]
GO
-- Create Table [dbo].[p_Observation_Result]
Print 'Create Table [dbo].[p_Observation_Result]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Observation_Result] (
		[cpr_id]                        [varchar](12) NOT NULL,
		[observation_sequence]          [int] NOT NULL,
		[location_result_sequence]      [int] IDENTITY(1, 1) NOT NULL,
		[location]                      [varchar](24) NOT NULL,
		[observation_id]                [varchar](24) NOT NULL,
		[result_sequence]               [smallint] NOT NULL,
		[treatment_id]                  [int] NULL,
		[encounter_id]                  [int] NULL,
		[result_date_time]              [datetime] NULL,
		[attachment_id]                 [int] NULL,
		[result_type]                   [varchar](12) NOT NULL,
		[result]                        [varchar](80) NULL,
		[result_value]                  [varchar](40) NULL,
		[result_unit]                   [varchar](12) NULL,
		[abnormal_flag]                 [char](1) NULL,
		[abnormal_nature]               [varchar](8) NULL,
		[severity]                      [smallint] NULL,
		[observed_by]                   [varchar](24) NULL,
		[current_flag]                  [char](1) NOT NULL,
		[root_observation_sequence]     [int] NULL,
		[created]                       [datetime] NULL,
		[created_by]                    [varchar](24) NULL,
		[id]                            [uniqueidentifier] NOT NULL,
		[normal_range]                  [varchar](40) NULL,
		[long_result_value]             [nvarchar](max) NULL,
		[object_key]                    AS (([observation_id]+'|')+CONVERT([varchar](12),[result_sequence],0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Observation_Result]
	ADD
	CONSTRAINT [PK_p_Observation_Result_1__12]
	PRIMARY KEY
	CLUSTERED
	([cpr_id], [observation_sequence], [location_result_sequence])
	WITH FILLFACTOR=70
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Observation_Result]
	ADD
	CONSTRAINT [DF__p_Obs_result_abnflg]
	DEFAULT ('N') FOR [abnormal_flag]
GO
ALTER TABLE [dbo].[p_Observation_Result]
	ADD
	CONSTRAINT [DF__p_Obs_result_curflg]
	DEFAULT ('Y') FOR [current_flag]
GO
ALTER TABLE [dbo].[p_Observation_Result]
	ADD
	CONSTRAINT [DF__p_Observa__resul__50B0EB68]
	DEFAULT ('PERFORM') FOR [result_type]
GO
ALTER TABLE [dbo].[p_Observation_Result]
	ADD
	CONSTRAINT [DF__p_Observa__resul_location]
	DEFAULT ('NA') FOR [location]
GO
ALTER TABLE [dbo].[p_Observation_Result]
	ADD
	CONSTRAINT [DF__p_Observa__resul_result_sequence]
	DEFAULT ((0)) FOR [result_sequence]
GO
ALTER TABLE [dbo].[p_Observation_Result]
	ADD
	CONSTRAINT [DF__p_Observatio__id__51A50FA1]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[p_Observation_Result]
	ADD
	CONSTRAINT [DF_p_obs_rslt_created_21]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
CREATE NONCLUSTERED INDEX [idx_location_result_sequence]
	ON [dbo].[p_Observation_Result] ([location_result_sequence])
	WITH ( FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_observation_id_result_sequence]
	ON [dbo].[p_Observation_Result] ([cpr_id], [observation_id], [result_sequence])
	WITH ( FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_observations_results]
	ON [dbo].[p_Observation_Result] ([observation_id], [result_sequence], [cpr_id], [location_result_sequence], [current_flag], [result_date_time])
	WITH ( FILLFACTOR = 90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_root_obs_sequence]
	ON [dbo].[p_Observation_Result] ([cpr_id], [root_observation_sequence])
	WITH ( FILLFACTOR = 90) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[p_Observation_Result] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[p_Observation_Result] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[p_Observation_Result] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[p_Observation_Result] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[p_Observation_Result] TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Observation_Result] SET (LOCK_ESCALATION = TABLE)
GO

