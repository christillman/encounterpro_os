CREATE VIEW dbo.v_report_display_script_command
AS
SELECT d.*
FROM dbo.fn_report_display_scripts() f
	INNER JOIN c_Display_Script_Command d
	ON d.display_script_id = f.display_script_id


