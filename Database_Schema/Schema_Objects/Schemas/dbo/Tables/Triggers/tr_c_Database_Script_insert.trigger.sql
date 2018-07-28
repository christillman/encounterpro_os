CREATE TRIGGER tr_c_Database_Script_insert ON dbo.c_Database_Script
FOR INSERT
AS

UPDATE cds
SET status = 'NA'
FROM c_Database_Script cds
	INNER JOIN inserted i
	ON cds.script_id < i.script_id
	AND cds.major_release = i.major_release
	AND cds.database_version = i.database_version
	AND cds.script_type = i.script_type
	AND ISNULL(cds.modification_level, 0) = ISNULL(i.modification_level, 0)
	AND cds.script_name = i.script_name


UPDATE cds
SET system_id = CASE i.script_type
				WHEN 'Config' THEN 'Config'
				WHEN 'Hotfix' THEN 'Hotfix'
				WHEN 'Migration24' THEN 'Migration24'
				WHEN 'Migration24 Prep' THEN 'Migration24'
				WHEN 'Reports' THEN 'Reports'
				WHEN 'Utility' THEN 'Database'
				WHEN 'Database' THEN 'Database'
				WHEN 'Constraint' THEN 'Database'
				WHEN 'TableCreate' THEN 'Database' 
				ELSE NULL END
FROM c_Database_Script cds
	INNER JOIN inserted i
	ON cds.script_id = i.script_id
WHERE i.system_id IS NULL

