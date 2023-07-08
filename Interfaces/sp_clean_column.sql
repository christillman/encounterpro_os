DROP PROCEDURE sp_clean_column
GO
CREATE PROCEDURE sp_clean_column (
	@table varchar(100),
	@column varchar(100)
	)
AS BEGIN

DECLARE @SQL nvarchar(1000)
SET @SQL = 
'UPDATE ' + @table + ' SET ' + @column + ' = REPLACE(' + @column + ', ''  '', '' '') WHERE ' + @column + ' like ''%  %'''
exec sp_executesql @SQL

SET @SQL = 
'UPDATE ' + @table + ' SET ' + @column + ' = REPLACE(' + @column + ', '' )'', '')'') WHERE ' + @column + ' like ''% )%'''
exec sp_executesql @SQL

SET @SQL = 
'UPDATE ' + @table + ' SET ' + @column + ' = REPLACE(' + @column + ', ''n1'', ''n 1'') WHERE ' + @column + ' like ''%n1%'''
exec sp_executesql @SQL

SET @SQL = 
'UPDATE ' + @table + ' SET ' + @column + ' = REPLACE(' + @column + ', char(160), '' '') WHERE ' + @column + ' like ''%'' + char(160) + ''%'''
exec sp_executesql @SQL

SET @SQL = 
'UPDATE ' + @table + ' SET ' + @column + ' = REPLACE(' + @column + ', char(13) + char(10), '' '') WHERE ' + @column + ' like ''%'' + char(13) + char(10) + ''%'''
exec sp_executesql @SQL

SET @SQL = 
'UPDATE ' + @table + ' SET ' + @column + ' = NULL WHERE ' + @column + ' = ''NULL'''
exec sp_executesql @SQL

SET @SQL = 
'UPDATE ' + @table + ' SET ' + @column + ' = LTRIM(RTRIM(' + @column + ')) WHERE ' + @column + ' like '' %'' OR ' + @column + ' like ''% '''
-- print @SQL
exec sp_executesql @SQL

END