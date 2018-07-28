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

-- Drop Procedure [dbo].[jmj_get_database_reset_scripts]
Print 'Drop Procedure [dbo].[jmj_get_database_reset_scripts]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_get_database_reset_scripts]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_get_database_reset_scripts]
GO

-- Create Procedure [dbo].[jmj_get_database_reset_scripts]
Print 'Create Procedure [dbo].[jmj_get_database_reset_scripts]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_get_database_reset_scripts (
	@pl_db_major_release int,
	@ps_db_database_version varchar(4),
	@pl_db_modification_level int)

AS

DECLARE @latest_scripts TABLE (
	[script_id] [int] NOT NULL ,
	[script_type] [varchar] (24) NOT NULL ,
	[system_id] [varchar] (24) NULL ,
	[major_release] [int] NOT NULL ,
	[database_version] [varchar] (4) NOT NULL ,
	[script_name] [varchar] (255) NOT NULL ,
	[description] [varchar] (255) NOT NULL ,
	[db_script] [text] NULL ,
	[last_executed] [datetime] NULL ,
	[last_completion_status] [varchar] (12) NULL ,
	[status] [varchar] (12) NOT NULL ,
	[id] [uniqueidentifier] NOT NULL ,
	[modification_level] [int] NULL ,
	[sort_sequence] [int] NULL ,
	[comment] [text] NULL,
	[allow_users] [bit] NOT NULL )


DECLARE @ll_major_release int,
		@ls_database_version varchar(4),
		@ll_modification_level int,
		@ls_database_reset_system_id varchar(24),
		@ls_database_reset_script_type varchar(24)

SET @ls_database_reset_system_id = 'Database Reset'
SET @ls_database_reset_script_type = 'Database Reset'
 
SELECT	@ll_major_release = major_release,
		@ls_database_version = database_version,
		@ll_modification_level = modification_level
FROM dbo.fn_latest_system_version_for_db_version (	@ls_database_reset_system_id,
													@pl_db_major_release ,
													@ps_db_database_version ,
													@pl_db_modification_level )


INSERT INTO @latest_scripts (
	[script_id] ,
	[script_type] ,
	[system_id] ,
	[major_release] ,
	[database_version] ,
	[script_name] ,
	[description] ,
	[db_script] ,
	[last_executed] ,
	[last_completion_status] ,
	[status] ,
	[id] ,
	[modification_level] ,
	[sort_sequence] ,
	[comment],
	[allow_users] )
SELECT s.script_id ,
	s.script_type ,
	s.system_id ,
	s.major_release ,
	s.database_version ,
	s.script_name ,
	s.description ,
	s.db_script ,
	s.last_executed ,
	s.last_completion_status ,
	s.status ,
	s.id ,
	s.modification_level ,
	s.sort_sequence ,
	s.comment,
	s.allow_users
FROM dbo.fn_latest_scripts(@ls_database_reset_script_type,
	@ll_major_release ,
	@ls_database_version ,
	@ll_modification_level ) s

INSERT INTO @latest_scripts (
	[script_id] ,
	[script_type] ,
	[system_id] ,
	[major_release] ,
	[database_version] ,
	[script_name] ,
	[description] ,
	[db_script] ,
	[last_executed] ,
	[last_completion_status] ,
	[status] ,
	[id] ,
	[modification_level] ,
	[sort_sequence] ,
	[comment],
	[allow_users] )
SELECT s.script_id ,
	s.script_type ,
	s.system_id ,
	s.major_release ,
	s.database_version ,
	s.script_name ,
	s.description ,
	s.db_script ,
	s.last_executed ,
	s.last_completion_status ,
	s.status ,
	s.id ,
	s.modification_level ,
	s.sort_sequence ,
	s.comment,
	s.allow_users
FROM dbo.fn_latest_scripts('Hotfix',
							@pl_db_major_release ,
							@ps_db_database_version ,
							NULL) s

-- Now add the latest specific object scripts
INSERT INTO @latest_scripts (
	[script_id] ,
	[script_type] ,
	[system_id] ,
	[major_release] ,
	[database_version] ,
	[script_name] ,
	[description] ,
	[db_script] ,
	[last_executed] ,
	[last_completion_status] ,
	[status] ,
	[id] ,
	[modification_level] ,
	[sort_sequence] ,
	[comment],
	[allow_users] )
SELECT s.script_id ,
	s.script_type ,
	s.system_id ,
	s.major_release ,
	s.database_version ,
	s.script_name ,
	s.description ,
	s.db_script ,
	s.last_executed ,
	s.last_completion_status ,
	s.status ,
	s.id ,
	s.modification_level ,
	s.sort_sequence ,
	s.comment,
	s.allow_users
FROM dbo.fn_latest_scripts('Database View',
							@pl_db_major_release ,
							@ps_db_database_version ,
							@pl_db_modification_level) s

INSERT INTO @latest_scripts (
	[script_id] ,
	[script_type] ,
	[system_id] ,
	[major_release] ,
	[database_version] ,
	[script_name] ,
	[description] ,
	[db_script] ,
	[last_executed] ,
	[last_completion_status] ,
	[status] ,
	[id] ,
	[modification_level] ,
	[sort_sequence] ,
	[comment],
	[allow_users] )
SELECT s.script_id ,
	s.script_type ,
	s.system_id ,
	s.major_release ,
	s.database_version ,
	s.script_name ,
	s.description ,
	s.db_script ,
	s.last_executed ,
	s.last_completion_status ,
	s.status ,
	s.id ,
	s.modification_level ,
	s.sort_sequence ,
	s.comment,
	s.allow_users
FROM dbo.fn_latest_scripts('Database Function',
							@pl_db_major_release ,
							@ps_db_database_version ,
							@pl_db_modification_level) s

-- Now add the latest specific object scripts
INSERT INTO @latest_scripts (
	[script_id] ,
	[script_type] ,
	[system_id] ,
	[major_release] ,
	[database_version] ,
	[script_name] ,
	[description] ,
	[db_script] ,
	[last_executed] ,
	[last_completion_status] ,
	[status] ,
	[id] ,
	[modification_level] ,
	[sort_sequence] ,
	[comment],
	[allow_users] )
SELECT s.script_id ,
	s.script_type ,
	s.system_id ,
	s.major_release ,
	s.database_version ,
	s.script_name ,
	s.description ,
	s.db_script ,
	s.last_executed ,
	s.last_completion_status ,
	s.status ,
	s.id ,
	s.modification_level ,
	s.sort_sequence ,
	s.comment,
	s.allow_users
FROM dbo.fn_latest_scripts('Database Procedure',
							@pl_db_major_release ,
							@ps_db_database_version ,
							@pl_db_modification_level) s


-- Make sure all the columns exist
--EXECUTE jmjsys_set_table_columns '%'

-- Make sure all the defaults exist
--EXECUTE jmjsys_set_table_defaults '%'


SELECT 	[script_id] ,
	[script_type] ,
	[system_id] ,
	[major_release] ,
	[database_version] ,
	[script_name] ,
	[description] ,
	[db_script] ,
	[last_executed] ,
	[last_completion_status] ,
	[status] ,
	[id] ,
	[modification_level] ,
	[sort_sequence] ,
	[comment],
	[allow_users]
FROM @latest_scripts
GO
GRANT EXECUTE
	ON [dbo].[jmj_get_database_reset_scripts]
	TO [cprsystem]
GO

