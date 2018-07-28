CREATE FUNCTION fn_last_script_run_date (
	@ps_script_type varchar(24),
	@ps_script_name varchar(255) )

RETURNS datetime

AS
BEGIN
DECLARE @ldt_last_script_run_date datetime


SELECT @ldt_last_script_run_date = max(l.executed_date_time)
FROM c_Database_Script s
	INNER JOIN c_Database_Script_Log l
	ON s.script_id = l.script_id
WHERE s.script_type = @ps_script_type
AND (s.script_name = @ps_script_name
	OR s.description = @ps_script_name)

RETURN @ldt_last_script_run_date 

END

