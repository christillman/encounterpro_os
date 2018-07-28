CREATE TRIGGER tr_c_Database_Script_Log_insert ON dbo.c_Database_Script_Log
FOR INSERT
AS

UPDATE cds
SET last_executed = i.executed_date_time,
	last_completion_status = i.completion_status
FROM c_Database_Script cds
	INNER JOIN inserted i
	ON cds.script_id = i.script_id

