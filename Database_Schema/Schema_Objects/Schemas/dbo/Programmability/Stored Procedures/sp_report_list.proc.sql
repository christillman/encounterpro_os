CREATE PROCEDURE sp_report_list (
	@ps_report_type varchar(24) )
AS
-- This procedure returns a list of reports of the given report type
-- The report_id is converted to varchar(36) so it can be used by a PowerBuilder Datawindow

SELECT CONVERT(varchar(36), report_id) as report_id,
	description,
	report_category,
	component_id,
	selected_flag = 0
FROM c_Report_Definition
WHERE report_type = @ps_report_type
AND status = 'OK'
ORDER BY description asc

