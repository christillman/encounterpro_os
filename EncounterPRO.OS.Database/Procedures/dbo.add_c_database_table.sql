
-- Drop Procedure [dbo].[add_c_database_table]
Print 'Drop Procedure [dbo].[add_c_database_table]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[add_c_database_table]') AND [type]='P'))
	DROP PROCEDURE [dbo].[add_c_database_table]
GO

/*
SELECT distinct 'exec add_c_database_table ''' + o.name + ''''
FROM sys.tables o
LEFT JOIN c_Database_Table t
	ON t.tablename = o.name
WHERE t.tablename IS NULL
order by 1
*/

-- Create Procedure [dbo].[add_c_database_table]
Print 'Create Procedure [dbo].[add_c_database_table]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE add_c_database_table (@ps_tablename varchar(50))

AS

DECLARE @ll_modification_level int

SELECT @ll_modification_level = modification_level
FROM c_Database_Status

DELETE FROM [c_Database_Table] 
WHERE [tablename] = @ps_tablename

INSERT INTO [c_Database_Table] (
		[tablename]
      ,[major_release]
      ,[database_version]
	  ,[last_update]
	  ,[modification_level]
	  )
VALUES (
	@ps_tablename
	,'4'
	,'05'
	,getdate()
	,@ll_modification_level + 1
	)

DELETE FROM [c_Database_Column] 
WHERE [tablename] = @ps_tablename

INSERT INTO [c_Database_Column]
           ([tablename]
           ,[columnname]
           ,[column_sequence]
           ,[column_datatype]
           ,[column_length]
           ,[column_identity]
           ,[column_nullable]
           ,[column_definition]
           ,[default_constraint]
           ,[default_constraint_name]
           ,[default_constraint_text]
           ,[modification_level]
           ,[last_updated])
select o.name,
	c.name,
	c.column_id,
	t.name,
	c.max_length,
	c.is_identity,
	c.is_nullable,
	t.name + case when t.name = 'varchar' then '(' + convert(varchar(4),c.max_length) + ')' else '' end,
	CASE WHEN d.name IS NULL THEN 0 ELSE 1 END,
	d.name,
	d.definition,
	@ll_modification_level + 1,
	getdate()
from sys.objects o
	inner join sys.columns c
	on c.object_id = o.object_id
	left outer join sys.default_constraints d
	on c.object_id = d.parent_object_id
	and c.column_id = d.parent_column_id
	inner join sys.types t
	on c.user_type_id = t.user_type_id
where o.name = @ps_tablename

GO
