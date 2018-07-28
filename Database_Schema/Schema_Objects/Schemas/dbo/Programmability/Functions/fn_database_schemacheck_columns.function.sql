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
