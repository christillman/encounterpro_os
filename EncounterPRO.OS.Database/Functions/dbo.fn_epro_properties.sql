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

-- Drop Function [dbo].[fn_epro_properties]
Print 'Drop Function [dbo].[fn_epro_properties]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_epro_properties]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_epro_properties]
GO

-- Create Function [dbo].[fn_epro_properties]
Print 'Create Function [dbo].[fn_epro_properties]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_epro_properties ()

RETURNS @properties TABLE (
	[property_id] [int] NOT NULL,
	[property_type] [varchar](12) NOT NULL,
	[property_object] [varchar](12) NOT NULL,
	[description] [varchar](80) NULL,
	[title] [varchar](20) NULL,
	[function_name] [varchar](64) NULL,
	[return_data_type] [varchar](12) NULL,
	[script_language] [varchar](12) NULL,
	[script] [nvarchar](max) NULL,
	[service] [varchar](24) NULL,
	[status] [varchar](12) NULL ,
	[id] [uniqueidentifier] NULL ,
	[owner_id] [int] NOT NULL ,
	[last_updated] [datetime] NOT NULL ,
	[property_value_object] [varchar](24) NULL,
	[epro_object] [varchar](24) NULL,
	[property_value_object_filter] [varchar](255) NULL,
	[property_value_object_unique] [char] (1) NULL,
	[property_value_object_cat_field] [varchar](255) NULL,
	[property_value_object_cat_query] [nvarchar](max) NULL,
	[property_name] [varchar](64) NULL,
	[property_value_object_key] [varchar](64) NULL,
	[property_help] [varchar](1024) NULL,
	[sort_sequence] [int] NULL,
	[actual_data_type] [varchar](12) NULL)
AS

BEGIN

INSERT INTO @properties (
		property_id,   
		property_type,   
		property_object,   
		description,   
		title,   
		function_name,   
		return_data_type,   
		script_language,   
		script,   
		service,   
		status,   
		id,   
		owner_id,   
		last_updated,   
		property_value_object,   
		epro_object,   
		property_value_object_filter,   
		property_value_object_unique,
		property_value_object_cat_field,   
		property_value_object_cat_query,   
		property_name,   
		property_value_object_key,   
		property_help,   
		sort_sequence,
		actual_data_type  )
 SELECT p.property_id,   
		p.property_type,   
		p.property_object,   
		p.description,   
		p.title,   
		p.function_name,   
		p.return_data_type,   
		p.script_language,   
		p.script,   
		p.service,   
		p.status,   
		p.id,   
		p.owner_id,   
		p.last_updated,   
		p.property_value_object,   
		p.epro_object,   
		p.property_value_object_filter,   
		property_value_object_unique=CASE p.property_value_object_unique WHEN 0 THEN 'N' ELSE 'Y' END,   
		p.property_value_object_cat_field,   
		p.property_value_object_cat_query,   
		p.property_name,   
		p.property_value_object_key,   
		p.property_help,   
		p.sort_sequence,
		actual_data_type = CASE c.column_datatype WHEN 'decimal' THEN 'number'
								WHEN 'datetime' THEN 'datetime'
								WHEN 'binary' THEN 'blob'
								WHEN 'bit' THEN 'number'
								WHEN 'text' THEN 'text'
								WHEN 'image' THEN 'blob'
								WHEN 'numeric' THEN 'number'
								WHEN 'int' THEN 'number'
								WHEN 'smallint' THEN 'number'
								WHEN 'nvarchar' THEN 'string'
								WHEN 'real' THEN 'number'
								WHEN 'char' THEN 'string'
								WHEN 'varchar' THEN 'string'
								WHEN 'uniqueidentifier' THEN 'string'
								WHEN 'float' THEN 'number'
								WHEN 'money' THEN 'number' END 
FROM c_Property p
	INNER JOIN c_Epro_Object o
	ON p.epro_object = o.epro_object
	LEFT OUTER JOIN c_Database_Column c
	ON o.base_tablename = c.tablename
	AND p.function_name = c.columnname

UPDATE @properties
SET actual_data_type = return_data_type
WHERE actual_data_type IS NULL

INSERT INTO @properties (
		property_id,   
		property_type,   
		property_object,   
		description,   
		function_name,   
		return_data_type,   
		status,   
		owner_id,   
		last_updated,   
		epro_object,   
		property_name,   
		sort_sequence,
		actual_data_type)
SELECT 0,
		'Built In',
		LEFT(e.epro_object, 12),
		c.columnname,   
		c.columnname,   
		return_data_type = CASE c.column_datatype WHEN 'decimal' THEN 'number'
								WHEN 'datetime' THEN 'datetime'
								WHEN 'binary' THEN 'blob'
								WHEN 'bit' THEN 'number'
								WHEN 'text' THEN 'text'
								WHEN 'image' THEN 'blob'
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
		status = 'OK',
		owner_id = 0,
		c.last_updated,
		e.epro_object,
		c.columnname,   
		c.column_sequence + 1000,
		actual_data_type = CASE c.column_datatype WHEN 'decimal' THEN 'number'
								WHEN 'datetime' THEN 'datetime'
								WHEN 'binary' THEN 'blob'
								WHEN 'bit' THEN 'number'
								WHEN 'text' THEN 'text'
								WHEN 'image' THEN 'blob'
								WHEN 'numeric' THEN 'number'
								WHEN 'int' THEN 'number'
								WHEN 'smallint' THEN 'number'
								WHEN 'nvarchar' THEN 'string'
								WHEN 'real' THEN 'number'
								WHEN 'char' THEN 'string'
								WHEN 'varchar' THEN 'string'
								WHEN 'uniqueidentifier' THEN 'string'
								WHEN 'float' THEN 'number'
								WHEN 'money' THEN 'number' END 
FROM c_Epro_Object e
	INNER JOIN c_Database_Column c
	ON e.base_tablename = c.tablename
WHERE NOT EXISTS (
	SELECT 1
	FROM @properties x
	WHERE c.columnname = x.property_name)
/*
UPDATE @properties
SET property_value_object = return_data_type,
	property_value_object_key = return_data_type
WHERE property_value_object IS NULL
AND return_data_type IN ('datetime', 'number', 'string', 'boolean', 'binary', 'text')
AND (property_object NOT IN ('number', 'datetime', 'string', 'boolean', 'binary', 'text')
	OR property_name = 'text')
*/

RETURN

END

GO
GRANT SELECT ON [dbo].[fn_epro_properties] TO [cprsystem]
GO

