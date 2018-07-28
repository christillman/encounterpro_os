CREATE FUNCTION fn_report_default_printer (
	@ps_report_id varchar(40),
	@ps_office_id varchar(4),
	@pl_computer_id int,
	@ps_room_id varchar(12) )

RETURNS varchar(64)

AS
BEGIN

DECLARE @ll_sort_sequence int,
		@ll_report_printer_sequence int,
		@luid_report_id uniqueidentifier,
		@ls_default_printer varchar(64)

SET @luid_report_id = CAST(@ps_report_id AS uniqueidentifier)

SELECT @ll_sort_sequence = min(ISNULL(sort_sequence, 0))
FROM o_Report_Printer
WHERE report_id = @luid_report_id
AND (office_id IS NULL OR office_id = @ps_office_id)
AND (computer_id IS NULL OR computer_id = @pl_computer_id)
AND (room_id IS NULL OR room_id = @ps_room_id)

SELECT @ll_report_printer_sequence = min(report_printer_sequence)
FROM o_Report_Printer
WHERE report_id = @luid_report_id
AND (office_id IS NULL OR office_id = @ps_office_id)
AND (computer_id IS NULL OR computer_id = @pl_computer_id)
AND (room_id IS NULL OR room_id = @ps_room_id)
AND ISNULL(sort_sequence, 0) = @ll_sort_sequence

SELECT @ls_default_printer = printer
FROM o_Report_Printer
WHERE report_id = @luid_report_id
AND report_printer_sequence = @ll_report_printer_sequence


RETURN @ls_default_printer
END
