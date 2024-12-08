DROP PROCEDURE [jmjsys_sync_table_column_info]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_sync_table_column_info] 
AS

SET NOCOUNT ON

DECLARE @ll_error int

DECLARE @Database_Table TABLE (
	[tablename] [varchar](64) NOT NULL,
	[major_release] [int] NOT NULL,
	[database_version] [varchar](4) NOT NULL,
	[last_update] [datetime] NOT NULL ,
	[id] [uniqueidentifier] NOT NULL ,
	[sync_algorithm] [varchar](24) NOT NULL ,
	[sync_modification_level] [int] NULL ,
	[parent_tablename] [varchar](64) NULL,
	[modification_level] [int] NULL )

DECLARE @columns TABLE (
	[tablename] [varchar](64) NOT NULL,
	[columnname] [varchar] (64) NOT NULL ,
	[column_sequence] [int] NOT NULL ,
	[column_datatype] varchar(32) NOT NULL ,
	[column_length] int NOT NULL ,
	[column_identity] bit NOT NULL ,
	[column_nullable] bit NOT NULL ,
	[column_definition] [varchar] (64) NOT NULL ,
	[default_constraint] bit NOT NULL ,
	[default_constraint_name] [varchar] (64) NULL ,
	[default_constraint_text] [varchar] (64) NULL ,
	[modification_level] [int] NOT NULL ,
	[last_updated] [datetime] NOT NULL )

-- Put a marker in the log
PRINT 'Special Sync Starting: Database Schema   ' + CAST(dbo.get_client_datetime() AS varchar(20))

------------------------------------------------------------------------
-- Get the table data
------------------------------------------------------------------------

INSERT INTO @Database_Table (
	[tablename] ,
	[major_release] ,
	[database_version] ,
	[last_update] ,
	[id] ,
	[sync_algorithm] ,
	[sync_modification_level] ,
	[parent_tablename] ,
	[modification_level] )
SELECT [tablename] ,
	[major_release] ,
	[database_version] ,
	[last_update] ,
	[id] ,
	[sync_algorithm] ,
	[sync_modification_level] ,
	[parent_tablename] ,
	[modification_level]
FROM jmjtech.eproupdates.dbo.c_Database_Table

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN

-- Update the existing columns
UPDATE t
SET last_update = x.last_update,
	id = x.id,
	sync_algorithm = x.sync_algorithm,
	parent_tablename = x.parent_tablename,
	modification_level = x.modification_level,
	sync_modification_level = x.sync_modification_level
FROM c_Database_Table t
	INNER JOIN @Database_Table x
	ON t.tablename = x.tablename

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN

-- Insert any missing records
INSERT INTO c_Database_Table (
	[tablename] ,
	[major_release] ,
	[database_version] ,
	[last_update] ,
	[id] ,
	[sync_algorithm] ,
	[sync_modification_level] ,
	[parent_tablename] ,
	[modification_level] )
SELECT [tablename] ,
	[major_release] ,
	[database_version] ,
	[last_update] ,
	[id] ,
	[sync_algorithm] ,
	[sync_modification_level] ,
	[parent_tablename] ,
	[modification_level]
FROM @Database_Table x
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Database_Table t
	WHERE x.tablename = t.tablename)

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Delete tables that don't exist in the sync database
DELETE t
FROM c_Database_Table t
WHERE NOT EXISTS (
	SELECT 1
	FROM @Database_Table x
	WHERE t.tablename = x.tablename)


------------------------------------------------------------------------
-- Get the column data
------------------------------------------------------------------------

INSERT INTO @columns (
	tablename ,
	columnname ,
	column_sequence ,
	column_datatype ,
	column_length ,
	column_identity ,
	column_nullable ,
	column_definition ,
	default_constraint ,
	default_constraint_name ,
	default_constraint_text ,
	modification_level ,
	last_updated )
SELECT tablename ,
	columnname ,
	column_sequence ,
	column_datatype ,
	column_length ,
	column_identity ,
	column_nullable ,
	column_definition ,
	default_constraint ,
	default_constraint_name ,
	default_constraint_text ,
	modification_level ,
	last_updated
FROM jmjtech.eproupdates.dbo.c_Database_Column

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN

INSERT INTO c_database_column (
	tablename ,
	columnname ,
	column_sequence ,
	column_datatype ,
	column_length ,
	column_identity ,
	column_nullable ,
	column_definition ,
	default_constraint ,
	default_constraint_name ,
	default_constraint_text ,
	modification_level ,
	last_updated )
SELECT tablename ,
	columnname ,
	column_sequence ,
	column_datatype ,
	column_length ,
	column_identity ,
	column_nullable ,
	column_definition ,
	default_constraint ,
	default_constraint_name ,
	default_constraint_text ,
	modification_level ,
	last_updated
FROM @columns x
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Database_Column c
	WHERE x.tablename = c.tablename
	AND x.columnname = c.columnname)

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN

UPDATE c
SET column_sequence = x.column_sequence,
	column_datatype = x.column_datatype,
	column_length = x.column_length,
	column_identity = x.column_identity,
	column_nullable = x.column_nullable,
	column_definition = x.column_definition,
	default_constraint = x.default_constraint,
	default_constraint_name = x.default_constraint_name,
	default_constraint_text = x.default_constraint_text,
	modification_level = x.modification_level,
	last_updated = x.last_updated
FROM c_Database_Column c
	INNER JOIN @columns x
	ON c.tablename = x.tablename
	AND c.columnname = x.columnname
WHERE c.last_updated < x.last_updated

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

DELETE c
FROM c_Database_Column c
WHERE NOT EXISTS (
	SELECT 1
	FROM @columns x
	WHERE c.tablename = x.tablename
	AND c.columnname = x.columnname)

SET @ll_error = @@ERROR
IF @ll_error <> 0
	RETURN -1

-- Put a marker in the log
PRINT 'Special Sync Successful: Database Schema   ' + CAST(dbo.get_client_datetime() AS varchar(20))

RETURN 1

GO
