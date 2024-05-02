
UPDATE c_Database_Status
SET client_link = 
'https:' + '//github.com/christillman/encounterpro_os/releases/download/v224/GreenOlive_EHR_Install_224.exe'

EXEC sp_updatestats

declare @db varchar(50) = db_name();
-- EXEC dbo.usp_AdaptiveIndexDefrag @dbScope = @db

DBCC SHRINKFILE (1, 500)
DBCC SHRINKFILE (2, 10)
