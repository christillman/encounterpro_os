CREATE PROCEDURE jmj_set_database_table_create_scripts
AS


DECLARE 	@ll_major_release int,
			@ls_database_version varchar(4),
			@ll_modification_level int

SELECT @ll_major_release = major_release,
		@ls_database_version = database_version,
		@ll_modification_level = modification_level
FROM c_Database_Status


-- Set the index script 
DECLARE @index_scripts TABLE (
	script_name varchar(255) NOT NULL,
	index_script text NULL)

-- Add the Trigger scripts
INSERT INTO @index_scripts (
	script_name ,
	index_script )
SELECT script_name,
	db_script
FROM dbo.fn_latest_scripts('TableCreate', @ll_major_release, @ls_database_version, @ll_modification_level)
WHERE script_name LIKE 'Tables\Create\dbo.%.TAB'

-- Replace any Triggers that have been overridden by a Hotfix
DECLARE @hotfix_Triggers TABLE (
	script_name varchar(255) NOT NULL,
	hotfix_release int NOT NULL,
	script_ran int NOT NULL DEFAULT (0),
	script_id int NULL)

-- Find the hotfix scripts
INSERT INTO @hotfix_Triggers (
	script_name,
	hotfix_release)
SELECT s.script_name,
	max(s.modification_level) as hotfix_release
FROM c_Database_Script s
	INNER JOIN c_Database_Modification_Dependancy d
	ON s.system_id = d.system_id
	AND s.major_release = d.major_release
	AND s.database_version = d.database_version
	AND s.modification_level = d.modification_level
WHERE s.system_id = 'Hotfix'
AND s.script_type = 'TableCreate'
AND s.major_release = @ll_major_release
AND s.database_version = @ls_database_version
AND d.min_database_modification_level <= @ll_modification_level
AND d.max_database_modification_level >= @ll_modification_level
AND s.status = 'OK'
GROUP BY s.script_name

-- Find the latest script for each Hotfix Trigger
UPDATE c
SET script_id = x.script_id
FROM @hotfix_Triggers c
	INNER JOIN (SELECT script_name, 
					hotfix_release = modification_level, 
					max(script_id) as script_id
				FROM c_Database_Script
				WHERE system_id = 'Hotfix'
				AND script_type = 'TableCreate'
				AND major_release = @ll_major_release
				AND database_version = @ls_database_version
				AND status = 'OK'
				GROUP BY script_name, modification_level) x
	ON c.script_name = x.script_name
	AND c.hotfix_release = x.hotfix_release

-- Mark the hotfix Triggers which have had their corresponding Hotfix Script executed
UPDATE c
SET script_ran = 1
FROM @hotfix_Triggers c
	INNER JOIN c_Database_Script s
	ON s.system_id = 'Hotfix'
	AND s.script_type = 'Hotfix'
	AND s.major_release = @ll_major_release
	AND s.database_version = @ls_database_version
	AND s.modification_level = c.hotfix_release
WHERE s.last_completion_status = 'OK'
AND c.script_id > 0

-- Update our script set to contain the hotfix Trigger script where it should
-- override the database system's Trigger script
UPDATE s
SET index_script = d.db_script
FROM @index_scripts s
	INNER JOIN @hotfix_Triggers c
	ON c.script_name = s.script_name
	INNER JOIN c_Database_Script d
	ON c.script_id = d.script_id
WHERE c.script_ran = 1


UPDATE @index_scripts
SET script_name = SUBSTRING(script_name, 19, LEN(script_name) - 22)

-- Finally, update the c_Database_Table table
UPDATE t
SET create_script = s.index_script
FROM c_Database_Table t
	INNER JOIN @index_scripts s
	ON s.script_name = t.tablename

INSERT INTO c_Database_Table (
	tablename,
	major_release,
	database_version,
	create_script)
SELECT s.script_name,
		@ll_major_release,
		@ls_database_version,
		s.index_script
FROM @index_scripts s
WHERE NOT EXISTS (
	SELECT 1
	FROM c_Database_Table t
	WHERE s.script_name = t.tablename)

