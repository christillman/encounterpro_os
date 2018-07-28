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

-- Drop Procedure [dbo].[jmj_log_database_maintenance]
Print 'Drop Procedure [dbo].[jmj_log_database_maintenance]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_log_database_maintenance]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_log_database_maintenance]
GO

-- Create Procedure [dbo].[jmj_log_database_maintenance]
Print 'Create Procedure [dbo].[jmj_log_database_maintenance]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_log_database_maintenance (
		@ps_action varchar(24),
		@ps_completion_status varchar(12),
		@ps_action_argument varchar(255) = NULL,
		@ps_build varchar(12) = NULL,
		@ps_comment varchar(255) = NULL
		)
AS

DECLARE	@ls_server varchar(40),
		@ls_database_name varchar(40),
		@ll_db_revision int,
		@ls_logon_id varchar(40),
		@ls_computername varchar(40)

SELECT @ll_db_revision = modification_level,
	@ls_server = CAST(ServerProperty('ServerName') AS varchar(40)),
	@ls_database_name = db_name(db_id()),
	@ls_computername = CAST(HOST_NAME() AS varchar(40)),
	@ls_logon_id = system_user
FROM c_database_status

-- See if the logon_id has a domain
IF CHARINDEX('\', @ls_logon_id) > 0
	SET @ls_logon_id = SUBSTRING(@ls_logon_id, CHARINDEX('\', @ls_logon_id) + 1, 40)

INSERT INTO [dbo].[c_Database_Maintenance] (
		logon_id,
		computername,
		server,
		database_name,
		action,
		completion_status,
		action_date,
		action_argument,
		build,
		db_revision,
		comment)
 VALUES (
		@ls_logon_id ,
		@ls_computername ,
		@ls_server ,
		@ls_database_name ,
		@ps_action ,
		@ps_completion_status ,
		getdate() ,
		@ps_action_argument ,
		@ps_build ,
		@ll_db_revision ,
		@ps_comment)


GO
GRANT EXECUTE
	ON [dbo].[jmj_log_database_maintenance]
	TO [cprsystem]
GO

