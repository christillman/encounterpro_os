CREATE TRIGGER tr_c_Database_Modification_Dependancy_insert ON dbo.c_Database_Modification_Dependancy
FOR INSERT
AS

UPDATE c
SET modification_level = CAST(CAST(i.version AS float) AS int)
FROM inserted i
	INNER JOIN c_Database_Modification_Dependancy c
	ON i.system_id = c.system_id
	AND i.major_release = c.major_release
	AND i.database_version = c.database_version
	AND i.version = c.version
WHERE ISNUMERIC(i.version) > 0
AND i.modification_level = 0


