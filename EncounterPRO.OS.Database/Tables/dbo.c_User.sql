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

-- Drop Table [dbo].[c_User]
Print 'Drop Table [dbo].[c_User]'
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[c_User]') AND [type]='U'))
DROP TABLE [dbo].[c_User]
GO
-- Create Table [dbo].[c_User]
Print 'Create Table [dbo].[c_User]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[c_User] (
		[user_id]                        [varchar](24) NOT NULL,
		[specialty_id]                   [varchar](24) NULL,
		[user_status]                    [varchar](8) NULL,
		[user_full_name]                 [varchar](64) NULL,
		[user_short_name]                [varchar](12) NULL,
		[color]                          [int] NULL,
		[office_id]                      [varchar](4) NULL,
		[access_id]                      [varchar](12) NULL,
		[user_initial]                   [varchar](3) NULL,
		[first_name]                     [varchar](20) NULL,
		[middle_name]                    [varchar](20) NULL,
		[last_name]                      [varchar](40) NULL,
		[degree]                         [varchar](24) NULL,
		[name_prefix]                    [varchar](12) NULL,
		[name_suffix]                    [varchar](12) NULL,
		[dea_number]                     [varchar](18) NULL,
		[license_number]                 [varchar](40) NULL,
		[certification_number]           [varchar](40) NULL,
		[upin]                           [varchar](24) NULL,
		[signature_stamp]                [varbinary](max) NULL,
		[supervisor_user_id]             [varchar](24) NULL,
		[certified]                      [char](1) NULL,
		[billing_id]                     [varchar](24) NULL,
		[billing_code]                   [int] NULL,
		[license_flag]                   [char](1) NULL,
		[activate_date]                  [datetime] NULL,
		[modified]                       [datetime] NULL,
		[modified_by]                    [varchar](24) NULL,
		[created]                        [datetime] NULL,
		[created_by]                     [varchar](24) NULL,
		[email_address]                  [varchar](64) NULL,
		[id]                             [uniqueidentifier] NOT NULL,
		[actor_id]                       [int] IDENTITY(1, 1) NOT NULL,
		[actor_class]                    [varchar](24) NOT NULL,
		[information_system_type]        [varchar](24) NULL,
		[information_system_version]     [varchar](24) NULL,
		[organization_contact]           [varchar](64) NULL,
		[organization_director]          [varchar](64) NULL,
		[title]                          [varchar](64) NULL,
		[login]                          [varchar](64) NULL,
		[status]                         [varchar](12) NOT NULL,
		[username]                       [varchar](40) NULL,
		[pwdcache]                       [varchar](255) NULL,
		[npi]                            [varchar](40) NULL,
		[clinical_access_flag]           [char](1) NOT NULL,
		[owner_id]                       [int] NULL,
		[actor_type]                     [varchar](24) NULL,
		[parent_actor_user_id]           [varchar](24) NULL,
		[signature_stamp_filetype]       [varchar](24) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_User]
	ADD
	CONSTRAINT [PK_c_Users_40]
	PRIMARY KEY
	CLUSTERED
	([user_id])
	WITH FILLFACTOR=100
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[c_User]
	ADD
	CONSTRAINT [DF_c_User_actor_class_40]
	DEFAULT ('User') FOR [actor_class]
GO
ALTER TABLE [dbo].[c_User]
	ADD
	CONSTRAINT [DF_c_User_clinacc_40]
	DEFAULT ('N') FOR [clinical_access_flag]
GO
ALTER TABLE [dbo].[c_User]
	ADD
	CONSTRAINT [DF_c_User_cre_40]
	DEFAULT (dbo.get_client_datetime()) FOR [created]
GO
ALTER TABLE [dbo].[c_User]
	ADD
	CONSTRAINT [DF_c_User_id_40]
	DEFAULT (newid()) FOR [id]
GO
ALTER TABLE [dbo].[c_User]
	ADD
	CONSTRAINT [DF_c_User_mod_40]
	DEFAULT (dbo.get_client_datetime()) FOR [modified]
GO
ALTER TABLE [dbo].[c_User]
	ADD
	CONSTRAINT [DF_c_User_status_40]
	DEFAULT ('OK') FOR [status]
GO
CREATE NONCLUSTERED INDEX [idx_actor_id]
	ON [dbo].[c_User] ([actor_id])
	WITH ( PAD_INDEX = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
GRANT DELETE ON [dbo].[c_User] TO [cprsystem]
GO
GRANT INSERT ON [dbo].[c_User] TO [cprsystem]
GO
GRANT REFERENCES ON [dbo].[c_User] TO [cprsystem]
GO
GRANT SELECT ON [dbo].[c_User] TO [cprsystem]
GO
GRANT UPDATE ON [dbo].[c_User] TO [cprsystem]
GO
ALTER TABLE [dbo].[c_User] SET (LOCK_ESCALATION = TABLE)
GO

