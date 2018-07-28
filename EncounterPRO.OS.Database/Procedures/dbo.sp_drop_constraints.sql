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

-- Drop Procedure [dbo].[sp_drop_constraints]
Print 'Drop Procedure [dbo].[sp_drop_constraints]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_drop_constraints]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_drop_constraints]
GO

-- Create Procedure [dbo].[sp_drop_constraints]
Print 'Create Procedure [dbo].[sp_drop_constraints]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_drop_constraints (
	@ps_table varchar(64),
	@pb_keep_triggers bit = 1 )
AS

-- MSC changed default keep_triggers to 1 because most common usage is to rebuild the constraints only
-- and we don't want to remove the triggers unless the caller explicitely requests that.

--- Drop All Constraints Which Reference table
DECLARE @ConstraintName sysname,
	@TableName sysname,
	@IndexName sysname,
	@IndexString nvarchar (357)

DECLARE lc_other_constraint CURSOR LOCAL FAST_FORWARD FOR
	select soct.name, soc.name
	from sysreferences sr WITH (NOLOCK),
		sysobjects soc WITH (NOLOCK),
		sysobjects sort WITH (NOLOCK), 
		sysobjects soct WITH (NOLOCK), 
		sysconstraints sc WITH (NOLOCK)
	where sc.constid  = sr.constid
	and sc.id = soct.id
	and sc.constid = soc.id
	and sr.rkeyid = sort.id
	and sort.name = @ps_table
OPEN lc_other_constraint
FETCH NEXT FROM lc_other_constraint INTO @TableName, @ConstraintName
WHILE (@@fetch_status = 0)
BEGIN
	EXEC ('ALTER TABLE ' + @TableName + ' DROP CONSTRAINT ' + @ConstraintName)
	FETCH NEXT FROM lc_other_constraint INTO @TableName, @ConstraintName
END
DEALLOCATE lc_other_constraint


--- Drop All Constraints on table itself
/* DROP Foreign Key Constraints First*/
DECLARE lc_constraint CURSOR LOCAL FAST_FORWARD FOR
	select so.name
	from sysconstraints sc WITH (NOLOCK)
		LEFT OUTER JOIN sysreferences sr WITH (NOLOCK)
		ON sc.constid = sr.constid
		INNER JOIN sysobjects so WITH (NOLOCK)
		ON sc.constid = so.id
		INNER JOIN sysobjects so2 WITH (NOLOCK)
		ON sc.id = so2.id
	where so2.name = @ps_table
	order by isnull(sr.fkeyid,0) desc
OPEN lc_constraint
FETCH NEXT FROM lc_constraint INTO @ConstraintName
WHILE (@@fetch_status = 0)
BEGIN
	EXEC ('ALTER TABLE ' + @ps_table + ' DROP CONSTRAINT ' + @ConstraintName)
	FETCH NEXT FROM lc_constraint INTO @ConstraintName
END
DEALLOCATE lc_constraint


IF @pb_keep_triggers = 0
	BEGIN
	-- Drop triggers
	DECLARE @Trigger sysname
	DECLARE lc_triggers CURSOR FOR
		select o.name
		from sysobjects o WITH (NOLOCK), 
			sysobjects d WITH (NOLOCK)
		where o.type = 'TR'
		and d.type = 'U'
		and o.deltrig = d.id
		and d.name = @ps_table
	OPEN lc_triggers
	FETCH NEXT FROM lc_triggers INTO @Trigger
	WHILE (@@fetch_status = 0)
	BEGIN
		IF EXISTS (	SELECT *
				FROM sysobjects WITH (NOLOCK)
				WHERE id = object_id(@Trigger)
				AND sysstat & 0xf = 8
				)
		BEGIN
			EXEC ('DROP TRIGGER ' + @Trigger)
		END
		FETCH NEXT FROM lc_triggers INTO @Trigger
	END
	DEALLOCATE lc_triggers
	END

-- Drop simple indexes

DECLARE lc_indexes CURSOR FOR
SELECT
	 si.name
FROM
	 sysindexes si WITH (NOLOCK)
	,sysobjects so WITH (NOLOCK)
WHERE
	so.id = si.id
AND	so.xtype = 'U'
AND	si.indid BETWEEN 1 and 254
AND 	si.name NOT LIKE '/_WA/_Sys/_%' ESCAPE '/'
AND	so.name = @ps_table
ORDER BY
	si.name

OPEN lc_indexes

FETCH NEXT FROM lc_indexes INTO @IndexName

WHILE (@@fetch_status = 0)
BEGIN
	SET @IndexString = 'DROP INDEX '+ @ps_table + '.' + @IndexName

	EXEC ( @IndexString )

	FETCH NEXT FROM lc_indexes INTO @IndexName
END

DEALLOCATE lc_indexes
GO
GRANT EXECUTE
	ON [dbo].[sp_drop_constraints]
	TO [cprsystem]
GO

