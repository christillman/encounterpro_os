
-- Because the getdate replacement is used in defaults, it can't be changed
-- unless the defaults are dropped first
--alter table o_log drop constraint DF_o_log_log_date_time_21

DECLARE @ls_tablename varchar (64) ,
	@ls_columnname varchar (64) ,
	@ls_default_constraint_name varchar (64) ,
	@ls_default_constraint_definition varchar(64),
	@ls_sql nvarchar(max)

DROP TABLE IF EXISTS #columns
CREATE TABLE #columns (
	[tablename] [varchar] (64) NOT NULL ,
	[columnname] [varchar] (64) NOT NULL ,
	[default_constraint_name] [varchar] (64) NULL ,
	[default_constraint_definition] [varchar] (64) NULL
	)

INSERT INTO #columns (
	tablename ,
	columnname ,
	default_constraint_name ,
	default_constraint_definition
	)
SELECT  
	o.name as tablename,
	c.name as columnname,
	d.name as default_constraint_name, 
	d.definition as default_constraint_definition
	FROM sys.default_constraints d
	INNER JOIN sys.objects o
	ON d.parent_object_id = o.object_id
	INNER JOIN sys.columns c
	ON o.object_id = c.object_id
	AND d.parent_column_id = c.column_id
	AND (d.definition like '%get_client_datetime%'
		OR d.definition like '%getdate%')
	WHERE o.type = 'U'
	AND o.name != 'o_log'

DECLARE lc_columns CURSOR LOCAL FAST_FORWARD FOR
SELECT 
	tablename ,
	columnname ,
	default_constraint_name ,
	default_constraint_definition
FROM #columns

OPEN lc_columns

FETCH lc_columns 
INTO @ls_tablename, 
	@ls_columnname, 
	@ls_default_constraint_name,
	@ls_default_constraint_definition

WHILE @@FETCH_STATUS = 0
	BEGIN

		SET @ls_sql = 'ALTER TABLE ' + @ls_tablename + ' DROP CONSTRAINT ' + @ls_default_constraint_name

		--PRINT @ls_sql
		EXECUTE (@ls_sql)

	FETCH lc_columns 
	INTO @ls_tablename, 
		@ls_columnname, 
		@ls_default_constraint_name,
		@ls_default_constraint_definition
	END

CLOSE lc_columns
DEALLOCATE lc_columns


GO
CREATE OR ALTER FUNCTION [dbo].[get_client_datetime]()
RETURNS DATETIME
WITH SCHEMABINDING
AS
BEGIN
RETURN (SELECT TOP 1 CAST(SYSDATETIMEOFFSET() AT TIME ZONE /* IsNull(timezone, */'E. Africa Standard Time' /*)*/ AS datetime)
	FROM dbo.c_Database_Status)
END
-- select dbo.get_client_datetime()
GO

GRANT EXECUTE ON [dbo].[get_client_datetime] TO [cprsystem]
GO

-- select * from sys.time_zone_info
DECLARE @ls_tablename varchar (64) ,
	@ls_columnname varchar (64) ,
	@ls_default_constraint_name varchar (64) ,
	@ls_default_constraint_definition varchar(64),
	@ls_sql nvarchar(max)

DECLARE lc_columns CURSOR LOCAL FAST_FORWARD FOR
SELECT 
	tablename ,
	columnname ,
	default_constraint_name ,
	default_constraint_definition
FROM #columns

OPEN lc_columns

FETCH lc_columns 
INTO @ls_tablename, 
	@ls_columnname, 
	@ls_default_constraint_name,
	@ls_default_constraint_definition

WHILE @@FETCH_STATUS = 0
	BEGIN

		SET @ls_sql = 'ALTER TABLE [dbo].[' + @ls_tablename + '] ADD '
		SET @ls_sql = @ls_sql + 'CONSTRAINT [DF_' + @ls_tablename + '_' + @ls_columnname +'] DEFAULT '
		SET @ls_sql = @ls_sql + '([dbo].[get_client_datetime]())' + ' FOR [' + @ls_columnname + ']'

		--PRINT @ls_sql
		EXECUTE (@ls_sql)

	FETCH lc_columns 
	INTO @ls_tablename, 
		@ls_columnname, 
		@ls_default_constraint_name,
		@ls_default_constraint_definition
	END

CLOSE lc_columns
DEALLOCATE lc_columns
/*
ALTER TABLE [dbo].[o_Log]
	ADD
	CONSTRAINT [DF_o_log_log_date_time_21]
	DEFAULT (dbo.get_client_datetime()) FOR [log_date_time]
*/
GO
