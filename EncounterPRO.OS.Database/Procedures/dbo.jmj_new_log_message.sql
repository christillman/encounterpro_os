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

-- Drop Procedure [dbo].[jmj_new_log_message]
Print 'Drop Procedure [dbo].[jmj_new_log_message]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_new_log_message]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_new_log_message]
GO

-- Create Procedure [dbo].[jmj_new_log_message]
Print 'Create Procedure [dbo].[jmj_new_log_message]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_new_log_message
	(
	@ps_severity varchar(12),
	@ps_caller varchar(40),
	@ps_script varchar(40),
	@ps_message varchar(255),
	@ps_log_data text = NULL,
	@ps_created_by varchar(24) = NULL
	)
AS

DECLARE @ll_computer_id int,
		@ls_system_user varchar(40),
		@ls_computername varchar(40),
		@ll_log_id int

SET @ls_system_user = SYSTEM_USER
SET @ls_computername = HOST_NAME()

-- Look up the computer_id
SET @ll_computer_id = (SELECT max(computer_id) FROM o_Computers WHERE computername = @ls_computername AND logon_id = @ls_system_user)

IF @ps_created_by IS NULL
	BEGIN
	SET @ps_created_by = dbo.fn_current_epro_user()
	IF @ps_created_by IS NULL
		SET @ps_created_by = '#SYSTEM'
	END

INSERT INTO o_Log (
	severity,
	log_date_time,
	caller,
	script,
	message,
	computer_id,
	computername,
	windows_logon_id,
	log_data,
	user_id,
	scribe_user_id)
VALUES (
	@ps_severity,
	getdate(),
	@ps_caller,
	@ps_script,
	@ps_message,
	@ll_computer_id,
	@ls_computername,
	@ls_system_user,
	@ps_log_data,
	@ps_created_by,
	@ps_created_by)


SET @ll_log_id = SCOPE_IDENTITY()

RETURN @ll_log_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_new_log_message]
	TO [cprsystem]
GO

