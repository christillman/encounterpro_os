CREATE FUNCTION fn_epro_object_table_columns (
	@ps_epro_object varchar(64))

RETURNS @columns TABLE (
	[property_name] [varchar](64) NOT NULL,
	[columnname] [varchar](64) NOT NULL,
	[column_sequence] [int] NOT NULL,
	[column_datatype] [varchar](32) NOT NULL,
	[column_length] [int] NOT NULL,
	[column_identity] [bit] NOT NULL,
	[column_nullable] [bit] NOT NULL,
	[column_definition] [varchar](64) NOT NULL,
	[default_constraint] [bit] NOT NULL,
	[default_constraint_name] [varchar](64) NULL,
	[default_constraint_text] [varchar](64) NULL,
	[modification_level] [int] NOT NULL,
	[last_updated] [datetime] NOT NULL)
AS

BEGIN

INSERT INTO @columns (
		 property_name,   
         columnname,   
         column_sequence,   
         column_datatype,   
         column_length,   
         column_identity,   
         column_nullable,   
         column_definition,   
         default_constraint,   
         default_constraint_name,   
         default_constraint_text,   
         modification_level,   
         last_updated  )
SELECT p.property_name,   
		c.columnname,   
		c.column_sequence,   
		c.column_datatype,   
		c.column_length,   
		c.column_identity,   
		c.column_nullable,   
		c.column_definition,   
		c.default_constraint,   
		c.default_constraint_name,   
		c.default_constraint_text,   
		c.modification_level,   
		c.last_updated  
FROM c_Epro_Object o
	INNER JOIN c_Database_Column c
	ON o.base_tablename = c.tablename
	INNER JOIN c_Property p
	ON o.epro_object = p.epro_object
	AND c.columnname = p.function_name
	AND  p.status = 'OK' 
WHERE o.epro_object = @ps_epro_object 

INSERT INTO @columns (
		 property_name,   
         columnname,   
         column_sequence,   
         column_datatype,   
         column_length,   
         column_identity,   
         column_nullable,   
         column_definition,   
         default_constraint,   
         default_constraint_name,   
         default_constraint_text,   
         modification_level,   
         last_updated  )
SELECT c.columnname,   
		c.columnname,   
		c.column_sequence,   
		c.column_datatype,   
		c.column_length,   
		c.column_identity,   
		c.column_nullable,   
		c.column_definition,   
		c.default_constraint,   
		c.default_constraint_name,   
		c.default_constraint_text,   
		c.modification_level,   
		c.last_updated  
FROM c_Epro_Object o
	INNER JOIN c_Database_Column c
	ON o.base_tablename = c.tablename
WHERE o.epro_object = @ps_epro_object 
AND NOT EXISTS (
	SELECT 1
	FROM @Columns x
	WHERE c.columnname = x.property_name)

RETURN

END

