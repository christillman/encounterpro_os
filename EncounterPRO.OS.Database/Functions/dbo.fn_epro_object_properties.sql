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

-- Drop Function [dbo].[fn_epro_object_properties]
Print 'Drop Function [dbo].[fn_epro_object_properties]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_epro_object_properties]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_epro_object_properties]
GO

-- Create Function [dbo].[fn_epro_object_properties]
Print 'Create Function [dbo].[fn_epro_object_properties]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_epro_object_properties (
	@ps_epro_object varchar(64))

RETURNS @columns TABLE (
	[property_name] [varchar](64) NOT NULL,
	[property_datatype] [varchar](12) NOT NULL,
	[property_column] [varchar](64) NULL,
	[property_formula] [text] NULL,
	[cache_column_length] [int] NULL,
	[property_id] [int] NULL,
	[property_type] [varchar] (12) NOT NULL)
AS

BEGIN

DECLARE @ll_pos int,
		@ls_function varchar(64),
		@ls_base_tablename varchar(64),
		@ls_epro_object varchar(1024)

SET @ls_function = NULL
SET @ls_base_tablename = NULL

SELECT @ls_epro_object = COALESCE(base_tablename, base_table_query)
FROM c_Epro_Object
WHERE epro_object = @ps_epro_object

IF CHARINDEX('(', @ls_epro_object) > 0
	SET @ls_function = LEFT(@ls_epro_object, CHARINDEX('(', @ls_epro_object) - 1)
ELSE
	SET @ls_base_tablename = @ls_epro_object

-- First add the properties listed in c_Property where the property type is 'SQL', 'built in', or 'object'
INSERT INTO @columns (
		 property_name,   
		 property_datatype,   
		 property_column,   
		 property_formula,
		 property_id,
		 property_type)   
SELECT p.property_name,   
		property_datatype = COALESCE(
							CASE c.column_datatype WHEN 'decimal' THEN 'number'
								WHEN 'datetime' THEN 'datetime'
								WHEN 'binary' THEN 'binary'
								WHEN 'bit' THEN 'number'
								WHEN 'text' THEN 'text'
								WHEN 'image' THEN 'binary'
								WHEN 'numeric' THEN 'number'
								WHEN 'int' THEN 'number'
								WHEN 'smallint' THEN 'number'
								WHEN 'nvarchar' THEN 'string'
								WHEN 'real' THEN 'number'
								WHEN 'char' THEN 'string'
								WHEN 'varchar' THEN 'string'
								WHEN 'uniqueidentifier' THEN 'string'
								WHEN 'float' THEN 'number'
								WHEN 'money' THEN 'number' END ,
							p.return_data_type),
		c.columnname,
		p.script,
		p.property_id,
		p.property_type
FROM c_Epro_Object o
	INNER JOIN c_Property p
	ON o.epro_object = p.epro_object
	CROSS JOIN c_Database_Status s
	LEFT OUTER JOIN c_Database_Column c
	ON o.base_tablename = c.tablename
	AND c.columnname = p.function_name
	AND s.modification_level >= c.modification_level
WHERE o.epro_object = @ps_epro_object 
AND p.property_type IN ('SQL', 'built in', 'object')
AND  p.status = 'OK' 

UPDATE x
SET cache_column_length = CAST(a.value AS int)
FROM @columns x
	INNER JOIN c_Property_Attribute a
	ON x.property_id = a.property_id
WHERE a.attribute = 'cache_column_length'
AND ISNUMERIC(a.value) = 1



-- Then add the columns from c_Database_Table that were not listed as properties.  This gives Epro internal
-- access to all the columns in the table.
INSERT INTO @columns (
		 property_name,   
		 property_datatype,   
		 property_column,
		 property_type)
SELECT c.columnname,   
		property_datatype = CASE c.column_datatype WHEN 'decimal' THEN 'number'
								WHEN 'datetime' THEN 'datetime'
								WHEN 'binary' THEN 'binary'
								WHEN 'bit' THEN 'number'
								WHEN 'text' THEN 'text'
								WHEN 'image' THEN 'binary'
								WHEN 'numeric' THEN 'number'
								WHEN 'int' THEN 'number'
								WHEN 'smallint' THEN 'number'
								WHEN 'nvarchar' THEN 'string'
								WHEN 'real' THEN 'number'
								WHEN 'char' THEN 'string'
								WHEN 'varchar' THEN 'string'
								WHEN 'uniqueidentifier' THEN 'string'
								WHEN 'float' THEN 'number'
								WHEN 'money' THEN 'number' END ,
		c.columnname,
		'TableColumn'
FROM c_Epro_Object o
	CROSS JOIN c_Database_Status s
	INNER JOIN c_Database_Column c
	ON o.base_tablename = c.tablename
	AND s.modification_level >= c.modification_level
WHERE o.epro_object = @ps_epro_object 
AND NOT EXISTS (
	SELECT 1
	FROM @Columns x
	WHERE c.columnname = x.property_name)


-- If the tablename is really a UDF, then the columns won't exist in the c_Database_Column table.  In this case
-- flag the columns that exist in the function so that the object cache will know how to select them
IF LEN(@ls_function) > 0
	BEGIN
	UPDATE x
	SET property_column = p.function_name
	FROM @columns x
		INNER JOIN c_Property p
		ON x.property_id = p.property_id
		INNER JOIN sys.columns c
		ON c.object_id = object_id(@ls_function)
		AND c.name = p.function_name
	WHERE property_column IS NULL

	-- Add the columns of the UDF that were not in c_Property
	INSERT INTO @columns (
			 property_name,   
			 property_datatype,   
			 property_column,
			 property_type)
	SELECT c.name,   
			property_datatype = CASE t.name WHEN 'decimal' THEN 'number'
									WHEN 'datetime' THEN 'datetime'
									WHEN 'binary' THEN 'binary'
									WHEN 'bit' THEN 'number'
									WHEN 'text' THEN 'text'
									WHEN 'image' THEN 'binary'
									WHEN 'numeric' THEN 'number'
									WHEN 'int' THEN 'number'
									WHEN 'smallint' THEN 'number'
									WHEN 'nvarchar' THEN 'string'
									WHEN 'real' THEN 'number'
									WHEN 'char' THEN 'string'
									WHEN 'varchar' THEN 'string'
									WHEN 'uniqueidentifier' THEN 'string'
									WHEN 'float' THEN 'number'
									WHEN 'money' THEN 'number' 
									ELSE 'string' END ,
			c.name,
			'TableColumn'
	FROM c_Epro_Object o
		CROSS JOIN sys.columns c
		INNER JOIN sys.types t
		ON c.system_type_id = t.system_type_id
	WHERE c.object_id = object_id(@ls_function)
	AND o.epro_object = @ps_epro_object 
	AND NOT EXISTS (
		SELECT 1
		FROM @Columns x
		WHERE c.name = x.property_name)
	END


RETURN

END
GO
GRANT SELECT
	ON [dbo].[fn_epro_object_properties]
	TO [cprsystem]
GO

