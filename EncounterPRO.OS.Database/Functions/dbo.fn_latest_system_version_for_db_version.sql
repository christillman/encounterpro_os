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

-- Drop Function [dbo].[fn_latest_system_version_for_db_version]
Print 'Drop Function [dbo].[fn_latest_system_version_for_db_version]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_latest_system_version_for_db_version]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_latest_system_version_for_db_version]
GO

-- Create Function [dbo].[fn_latest_system_version_for_db_version]
Print 'Create Function [dbo].[fn_latest_system_version_for_db_version]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_latest_system_version_for_db_version (
	@ps_system_id varchar(24),
	@pl_db_major_release int,
	@ps_db_database_version varchar(4),
	@pl_db_modification_level int )

RETURNS @latestversion TABLE (
	[major_release] [int] ,
	[database_version] [varchar] (4) ,
	[modification_level] [int] )

AS

BEGIN

DECLARE @dbversions TABLE (
	[major_release] [int] ,
	[database_version] [varchar] (4) ,
	[modification_level] [int] )

DECLARE @ll_major_release int,
		@ls_database_version varchar(4),
		@ll_modification_level int

-- If nulls were passed in then use the current database version
SELECT @pl_db_major_release = ISNULL(@pl_db_major_release, major_release),
	@ps_db_database_version = ISNULL(@ps_db_database_version, database_version),
	@pl_db_modification_level = ISNULL(@pl_db_modification_level, modification_level)
FROM c_Database_Status

-- First get the max major release
SELECT @ll_major_release = max(major_release)
FROM c_Database_Modification_Dependancy
WHERE system_id = @ps_system_id
AND min_database_modification_level <= @pl_db_modification_level
AND (max_database_modification_level IS NULL OR max_database_modification_level >= @pl_db_modification_level)

-- Then get the max database version (minor release)
IF @ll_major_release IS NOT NULL
	SELECT @ls_database_version = max(database_version)
	FROM c_Database_Modification_Dependancy
	WHERE system_id = @ps_system_id
	AND min_database_modification_level <= @pl_db_modification_level
	AND (max_database_modification_level IS NULL OR max_database_modification_level >= @pl_db_modification_level)
	AND major_release = @ll_major_release

IF @ll_major_release IS NOT NULL 
	AND @ls_database_version IS NOT NULL
	-- Then get the max modification level (extended release)
	SELECT @ll_modification_level = max(modification_level)
	FROM c_Database_Modification_Dependancy
	WHERE system_id = @ps_system_id
	AND min_database_modification_level <= @pl_db_modification_level
	AND (max_database_modification_level IS NULL OR max_database_modification_level >= @pl_db_modification_level)
	AND major_release = @ll_major_release
	AND database_version = @ls_database_version

IF @ll_major_release IS NOT NULL 
	AND @ls_database_version IS NOT NULL 
	AND @ll_modification_level IS NOT NULL
	-- Now get the list of scripts and IDs for this bootstrap release
	INSERT INTO @latestversion (
		[major_release] , 
		[database_version] , 
		[modification_level] )
	VALUES (
		@ll_major_release, 
		@ls_database_version , 
		@ll_modification_level )


RETURN
END

GO
GRANT SELECT ON [dbo].[fn_latest_system_version_for_db_version] TO [cprsystem]
GO

