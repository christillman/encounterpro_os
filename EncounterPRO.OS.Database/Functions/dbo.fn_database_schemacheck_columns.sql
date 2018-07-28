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

-- Drop Function [dbo].[fn_database_schemacheck_columns]
Print 'Drop Function [dbo].[fn_database_schemacheck_columns]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_database_schemacheck_columns]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_database_schemacheck_columns]
GO

-- Create Function [dbo].[fn_database_schemacheck_columns]
Print 'Create Function [dbo].[fn_database_schemacheck_columns]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_database_schemacheck_columns ()

RETURNS @columninfo TABLE (
	[tablename] [varchar](64) NOT NULL,
	[columnname] [varchar](64) NOT NULL,
	[column_property] [varchar](24) NOT NULL,
	[schema_column_property_value] [varchar](64) NOT NULL,
	[actual_column_property_value] [varchar](64) NOT NULL,
	[severity] [int] NOT NULL
)

AS
BEGIN

DECLARE @ll_modification_level int

SELECT @ll_modification_level = modification_level
FROM c_Database_Status

INSERT INTO @columninfo (
	[tablename],
	[columnname],
	[column_property],
	[schema_column_property_value],
	[actual_column_property_value],
	[severity])
select dc.tablename,
	dc.columnname, 
	'column_datatype',
	dc.column_datatype,
	t.name,
	3
from c_database_column dc
	inner join sys.objects o
	on dc.tablename = o.name
	inner join sys.columns c
	on c.object_id = o.object_id
	and dc.columnname = c.name
	left outer join sys.default_constraints d
	on c.object_id = d.parent_object_id
	and c.column_id = d.parent_column_id
	inner join sys.types t
	on c.user_type_id = t.user_type_id
where dc.column_datatype <> t.name
and dc.modification_level <= @ll_modification_level

INSERT INTO @columninfo (
	[tablename],
	[columnname],
	[column_property],
	[schema_column_property_value],
	[actual_column_property_value],
	[severity])
select dc.tablename,
	dc.columnname, 
	'column_length',
	CAST(dc.column_length AS varchar(12)),
	CAST(c.max_length AS varchar(12)),
	3
from c_database_column dc
	inner join sys.objects o
	on dc.tablename = o.name
	inner join sys.columns c
	on c.object_id = o.object_id
	and dc.columnname = c.name
	left outer join sys.default_constraints d
	on c.object_id = d.parent_object_id
	and c.column_id = d.parent_column_id
	inner join sys.types t
	on c.user_type_id = t.user_type_id
where dc.column_length <> c.max_length
and dc.modification_level <= @ll_modification_level

INSERT INTO @columninfo (
	[tablename],
	[columnname],
	[column_property],
	[schema_column_property_value],
	[actual_column_property_value],
	[severity])
select dc.tablename,
	dc.columnname, 
	'column_identity',
	CASE dc.column_identity WHEN 0 THEN 'False' ELSE 'True' END,
	CASE c.is_identity WHEN 0 THEN 'False' ELSE 'True' END,
	3
from c_database_column dc
	inner join sys.objects o
	on dc.tablename = o.name
	inner join sys.columns c
	on c.object_id = o.object_id
	and dc.columnname = c.name
	left outer join sys.default_constraints d
	on c.object_id = d.parent_object_id
	and c.column_id = d.parent_column_id
	inner join sys.types t
	on c.user_type_id = t.user_type_id
where dc.column_identity <> c.is_identity
and dc.modification_level <= @ll_modification_level
and left(dc.tablename, 2) <> 'v_' -- ignore identity errors on views

INSERT INTO @columninfo (
	[tablename],
	[columnname],
	[column_property],
	[schema_column_property_value],
	[actual_column_property_value],
	[severity])
select dc.tablename,
	dc.columnname, 
	'column_nullable',
	CASE dc.column_nullable WHEN 0 THEN 'False' ELSE 'True' END,
	CASE c.is_nullable WHEN 0 THEN 'False' ELSE 'True' END,
	3
from c_database_column dc
	inner join sys.objects o
	on dc.tablename = o.name
	inner join sys.columns c
	on c.object_id = o.object_id
	and dc.columnname = c.name
	left outer join sys.default_constraints d
	on c.object_id = d.parent_object_id
	and c.column_id = d.parent_column_id
	inner join sys.types t
	on c.user_type_id = t.user_type_id
where dc.column_nullable <> c.is_nullable
and dc.modification_level <= @ll_modification_level

INSERT INTO @columninfo (
	[tablename],
	[columnname],
	[column_property],
	[schema_column_property_value],
	[actual_column_property_value],
	[severity])
select dc.tablename,
	dc.columnname, 
	'default_constraint',
	CASE dc.default_constraint WHEN 0 THEN 'False' ELSE 'True' END,
	CASE WHEN d.name IS NULL THEN 'False' ELSE 'True' END,
	3
from c_database_column dc
	inner join sys.objects o
	on dc.tablename = o.name
	inner join sys.columns c
	on c.object_id = o.object_id
	and dc.columnname = c.name
	left outer join sys.default_constraints d
	on c.object_id = d.parent_object_id
	and c.column_id = d.parent_column_id
	inner join sys.types t
	on c.user_type_id = t.user_type_id
where dc.default_constraint <> CASE WHEN d.name IS NULL THEN 0 ELSE 1 END
and dc.modification_level <= @ll_modification_level


INSERT INTO @columninfo (
	[tablename],
	[columnname],
	[column_property],
	[schema_column_property_value],
	[actual_column_property_value],
	[severity])
select dc.tablename,
	dc.columnname, 
	'default_constraint_text',
	dc.default_constraint_text,
	d.definition,
	2
from c_database_column dc
	inner join sys.objects o
	on dc.tablename = o.name
	inner join sys.columns c
	on c.object_id = o.object_id
	and dc.columnname = c.name
	left outer join sys.default_constraints d
	on c.object_id = d.parent_object_id
	and c.column_id = d.parent_column_id
	inner join sys.types t
	on c.user_type_id = t.user_type_id
where dc.default_constraint_text <> d.definition
and dc.modification_level <= @ll_modification_level

INSERT INTO @columninfo (
	[tablename],
	[columnname],
	[column_property],
	[schema_column_property_value],
	[actual_column_property_value],
	[severity])
select dc.tablename,
	dc.columnname, 
	'existence',
	'True',
	'False',
	3
from c_database_column dc
WHERE NOT EXISTS (
	SELECT 1
	FROM sys.objects o
	inner join sys.columns c
	on c.object_id = o.object_id
	WHERE dc.tablename = o.name
	and dc.columnname = c.name)
and dc.modification_level <= @ll_modification_level

INSERT INTO @columninfo (
	[tablename],
	[columnname],
	[column_property],
	[schema_column_property_value],
	[actual_column_property_value],
	[severity])
SELECT o.name,
	c.name, 
	'existence',
	'False',
	'True',
	3
FROM sys.objects o
	INNER JOIN sys.columns c
	ON c.object_id = o.object_id
	INNER JOIN c_Database_Table t
	ON o.name = t.tablename
WHERE NOT EXISTS (
	SELECT 1
	FROM c_database_column dc
	WHERE dc.tablename = o.name
	AND dc.columnname = c.name
	AND dc.modification_level <= @ll_modification_level
	)

RETURN
END
GO
GRANT SELECT
	ON [dbo].[fn_database_schemacheck_columns]
	TO [cprsystem]
GO

