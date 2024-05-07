
DECLARE @table varchar(100), @default varchar(100), @column varchar(100)
DECLARE @SQL nvarchar(max)
DECLARE crs_getdate CURSOR FOR
	select t.name, d.name, c.name
	from sys.default_constraints d
	join sys.tables t on t.object_id = d.parent_object_id
	join sys.columns c on c.object_id = d.parent_object_id and c.column_id = d.parent_column_id
	where definition like '%getdate%'
	order by t.name, d.name, c.name
OPEN crs_getdate
FETCH NEXT FROM crs_getdate INTO @table, @default, @column
WHILE (@@fetch_status = 0)
BEGIN
	SET @SQL = 'ALTER TABLE [dbo].[' + @table + ']
	DROP
	CONSTRAINT [' + @default + ']'
	exec sp_executesql @SQL
	SET @SQL = 'ALTER TABLE [dbo].[' + @table + ']
	ADD
	CONSTRAINT [' + @default + ']
	DEFAULT (dbo.get_client_datetime()) FOR [' + @column + ']'
	exec sp_executesql @SQL
	FETCH NEXT FROM crs_getdate INTO @table, @default, @column
END
CLOSE crs_getdate
DEALLOCATE crs_getdate