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

-- Drop Table [dbo].[p_Patient]
Print 'Drop Table [dbo].[p_Patient]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[p_Patient]') AND [type]='U'))
DROP TABLE [dbo].[p_Patient]
GO
-- Create Table [dbo].[p_Patient]
Print 'Create Table [dbo].[p_Patient]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[p_Patient] (
		[cpr_id]                     [varchar](12) NOT NULL,
		[race]                       [varchar](24) NULL,
		[date_of_birth]              [datetime] NULL,
		[sex]                        [varchar](1) NULL,
		[primary_language]           [varchar](12) NULL,
		[marital_status]             [varchar](1) NULL,
		[billing_id]                 [varchar](24) NULL,
		[ssn]                        [varchar](24) NULL,
		[first_name]                 [varchar](20) NULL,
		[last_name]                  [varchar](40) NULL,
		[degree]                     [varchar](12) NULL,
		[name_prefix]                [varchar](12) NULL,
		[middle_name]                [varchar](20) NULL,
		[name_suffix]                [varchar](12) NULL,
		[maiden_name]                [varchar](40) NULL,
		[attachment_id]              [int] NULL,
		[primary_provider_id]        [varchar](24) NULL,
		[secondary_provider_id]      [varchar](24) NULL,
		[last_update]                [datetime] NULL,
		[phone_number]               [varchar](32) NULL,
		[patient_id]                 [int] NULL,
		[date_of_conception]         [datetime] NULL,
		[patient_status]             [varchar](24) NOT NULL,
		[created]                    [datetime] NULL,
		[created_by]                 [varchar](24) NULL,
		[modified_by]                [varchar](24) NULL,
		[office_id]                  [varchar](4) NULL,
		[locked_by]                  [varchar](24) NULL,
		[attachment_location_id]     [int] NULL,
		[attachment_path]            [varchar](128) NULL,
		[referring_provider_id]      [varchar](24) NULL,
		[address_line_1]             [varchar](40) NULL,
		[address_line_2]             [varchar](40) NULL,
		[state]                      [varchar](2) NULL,
		[zip]                        [varchar](10) NULL,
		[country]                    [varchar](2) NULL,
		[secondary_phone_number]     [varchar](16) NULL,
		[email_address]              [varchar](40) NULL,
		[religion]                   [varchar](12) NULL,
		[nationality]                [varchar](12) NULL,
		[financial_class]            [varchar](40) NULL,
		[city]                       [varchar](40) NULL,
		[employer]                   [varchar](40) NULL,
		[employeeID]                 [varchar](24) NULL,
		[department]                 [varchar](10) NULL,
		[shift]                      [varchar](10) NULL,
		[job_description]            [varchar](24) NULL,
		[start_date]                 [datetime] NULL,
		[termination_date]           [datetime] NULL,
		[employment_status]          [varchar](24) NULL,
		[id]                         [uniqueidentifier] NOT NULL,
		[default_grant]              [bit] NOT NULL,
		[nickname]                   [varchar](20) NULL,
		[phone_number_7digit]        [varchar](8) NULL,
		[test_patient]               [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Patient]
	ADD
	CONSTRAINT [PK_p_Patient_1_40]
	PRIMARY KEY
	CLUSTERED
	([cpr_id])
	WITH FILLFACTOR=80
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[p_Patient]
	ADD
	CONSTRAINT [DF__p_Patient__test___795274BB]
	DEFAULT ((0)) FOR [test_patient]
GO
ALTER TABLE [dbo].[p_Patient]
	ADD
	CONSTRAINT [DF__p_patient_default_grant]
	DEFAULT ((1)) FOR [default_grant]
GO
ALTER TABLE [dbo].[p_Patient]
	ADD
	CONSTRAINT [DF_p_patient_40]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
ALTER TABLE [dbo].[p_Patient]
	ADD
	CONSTRAINT [DF_p_Patient_id_40]
	DEFAULT (newid()) FOR [id]
GO
CREATE NONCLUSTERED INDEX [idx_billing_id]
	ON [dbo].[p_Patient] ([billing_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_dob]
	ON [dbo].[p_Patient] ([date_of_birth], [cpr_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_last_name]
	ON [dbo].[p_Patient] ([last_name])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_phone_number]
	ON [dbo].[p_Patient] ([phone_number], [cpr_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_ssn]
	ON [dbo].[p_Patient] ([ssn])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
GRANT DELETE
	ON [dbo].[p_Patient]
	TO [cprsystem]
GO
GRANT INSERT
	ON [dbo].[p_Patient]
	TO [cprsystem]
GO
GRANT REFERENCES
	ON [dbo].[p_Patient]
	TO [cprsystem]
GO
GRANT SELECT
	ON [dbo].[p_Patient]
	TO [cprsystem]
GO
GRANT UPDATE
	ON [dbo].[p_Patient]
	TO [cprsystem]
GO
ALTER TABLE [dbo].[p_Patient] SET (LOCK_ESCALATION = TABLE)
GO

