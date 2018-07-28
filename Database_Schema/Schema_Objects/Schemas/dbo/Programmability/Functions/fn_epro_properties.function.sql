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
	[script] [text] NULL,
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
	[property_value_object_cat_query] [text] NULL,
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

