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

-- Drop Procedure [dbo].[jmj_modify_references]
Print 'Drop Procedure [dbo].[jmj_modify_references]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_modify_references]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_modify_references]
GO

-- Create Procedure [dbo].[jmj_modify_references]
Print 'Create Procedure [dbo].[jmj_modify_references]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_modify_references (
	@pl_reference_id int,
	@pl_new_reference_id int,
	@ps_object_key varchar(64))
AS

-- This stored procedure creates a local copy of the specified reference and returns the new reference_id
DECLARE @ls_tablename varchar(64),
		@ls_columnname varchar(64),
		@ll_count int,
		@ll_error int,
		@ls_sql nvarchar(max),
		@ll_IsPrimaryKey int

DECLARE lc_refs CURSOR LOCAL FAST_FORWARD FOR
	SELECT tablename, columnname
	FROM c_Database_Column WITH (NOLOCK)
	WHERE columnname LIKE '%' + @ps_object_key

BEGIN TRANSACTION

OPEN lc_refs

FETCH lc_refs INTO @ls_tablename, @ls_columnname

WHILE @@FETCH_STATUS = 0
	BEGIN
	SELECT @ll_IsPrimaryKey = ObjectProperty(Object_id(si.name),  'IsPrimaryKey')
	FROM sysobjects o
		INNER JOIN syscolumns cl
		ON o.id = cl.id
		INNER JOIN sysindexes si
		ON o.id = si.id
		INNER JOIN sysindexkeys sk
		ON si.id = sk.id
		AND si.indid = sk.indid
		AND sk.colid = cl.colid
	WHERE o.name = @ls_tablename
	AND cl.name = @ls_columnname
	AND o.type = 'U'

	IF @@ROWCOUNT = 1 AND @ll_IsPrimaryKey = 0
		BEGIN
		SET @ls_sql = 'UPDATE ' + @ls_tablename 
		SET @ls_sql = @ls_sql + ' SET ' + @ls_columnname + ' = ' + CAST(@pl_new_reference_id AS varchar(12))
		SET @ls_sql = @ls_sql + ' WHERE ' + @ls_columnname + ' = ' + CAST(@pl_reference_id AS varchar(12))

		EXECUTE (@ls_sql)
		SET @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN -1
		END

	FETCH lc_refs INTO @ls_tablename, @ls_columnname
	END

CLOSE lc_refs
DEALLOCATE lc_refs


COMMIT TRANSACTION

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_modify_references]
	TO [cprsystem]
GO

