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

-- Drop Procedure [dbo].[config_sync_library]
Print 'Drop Procedure [dbo].[config_sync_library]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_sync_library]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_sync_library]
GO

-- Create Procedure [dbo].[config_sync_library]
Print 'Create Procedure [dbo].[config_sync_library]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[config_sync_library] 
AS

DECLARE @ls_temp_tablename varchar(128) ,
	@ls_primary_key_where_clause varchar(4000) ,
	@ls_insert_column_list varchar(4000) ,
	@ls_select_column_list varchar(4000) ,
	@ls_update_set_clause varchar(4000) ,
	@ls_sql varchar(4000),
	@ll_error int,
	@ll_id_exists int,
	@ll_owner_id int

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

-- First get the library entries
EXECUTE jmjsys_sync_table  
	@ps_tablename = 'c_Config_Object_Library',   
	@ps_sync_tablename = 'c_Config_Object',   
	@ps_sync_type = 'New and Updated'

SELECT @ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -1

-- Then update the release_status of the local version records

EXECUTE jmjsys_get_sync_table_data
	@ps_tablename = 'c_Config_Object_Version',
	@ps_ids_only = 'N',
	@ps_new_flag = 'N',
	@ps_updated_flag = 'N',
	@ps_all_flag = 'Y',
	@ps_temp_tablename = @ls_temp_tablename OUTPUT,
	@ps_primary_key_where_clause = @ls_primary_key_where_clause OUTPUT,
	@ps_update_set_clause = @ls_update_set_clause OUTPUT,
	@ps_insert_column_list = @ls_insert_column_list OUTPUT,
	@ps_select_column_list = @ls_select_column_list OUTPUT

-- Process update records
SET @ls_sql = 'UPDATE t SET release_status = x.release_status, release_status_date_time = x.release_status_date_time '
SET @ls_sql = @ls_sql + ' FROM c_Config_Object_Version t '
SET @ls_sql = @ls_sql + 'INNER JOIN ' + @ls_temp_tablename + ' x '
SET @ls_sql = @ls_sql + 'ON x.Config_Object_ID = t.Config_Object_ID '
SET @ls_sql = @ls_sql + 'AND x.version = t.version '
SET @ls_sql = @ls_sql + 'WHERE x.status = ''OK'' '
SET @ls_sql = @ls_sql + 'AND t.owner_id <> ' + CAST(@ll_owner_id AS varchar(8))

-- Execute the data transfer script
EXECUTE (@ls_sql)
SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1




RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[config_sync_library]
	TO [public]
GO

