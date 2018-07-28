CREATE PROCEDURE sp_display_script_list
AS

DECLARE @scripts TABLE (
	id uniqueidentifier NULL,
	display_script_id int NOT NULL,
	use_display_script_id int NULL,
	last_updated datetime  NULL)

-- First put in the display scripts and their current versions using the id field and
-- looking for the 'OK' status
INSERT INTO @scripts (
	id,
	display_script_id)
SELECT d1.id, d1.display_script_id
FROM c_Display_Script d1

-- First put in the display scripts and their current versions using the id field and
-- looking for the 'OK' status
UPDATE s
SET use_display_script_id = x.display_script_id
FROM @scripts s
	INNER JOIN (SELECT id, max(display_script_id) as display_script_id
				FROM c_Display_Script
				WHERE status = 'OK'
				GROUP BY id) x
	ON s.id = x.id

UPDATE s
SET use_display_script_id = display_script_id
FROM @scripts s
WHERE s.use_display_script_id IS NULL

UPDATE s
SET last_updated = d.last_updated
FROM @scripts s
	INNER JOIN c_Display_Script d
	ON s.use_display_script_id = d.display_script_id

SELECT display_script_id,
	use_display_script_id,
	last_updated
FROM @scripts
ORDER BY display_script_id

