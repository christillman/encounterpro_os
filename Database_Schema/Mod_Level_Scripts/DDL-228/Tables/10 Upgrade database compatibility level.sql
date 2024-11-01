

DECLARE @SQL nvarchar(max)
DECLARE @name varchar(100)
DECLARE to_upgrade CURSOR FOR
SELECT name FROM sys.databases WHERE COMPATIBILITY_LEVEL < 150;

OPEN to_upgrade
FETCH NEXT FROM to_upgrade INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN
	SET @SQL = '
	USE master
	ALTER DATABASE ' + @name + ' SET COMPATIBILITY_LEVEL = 150
	USE ' + @name + '
	'
	exec sp_executeSQL @SQL
	FETCH NEXT FROM to_upgrade INTO @name
END

CLOSE to_upgrade
DEALLOCATE to_upgrade
