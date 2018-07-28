CREATE PROCEDURE sp_get_report_printer (
	@ps_report_id varchar(40),
	@ps_office_id varchar(4),
	@pl_computer_id int,
	@ps_room_id varchar(12) )
AS


SELECT printer = dbo.fn_report_default_printer (@ps_report_id,
												@ps_office_id,
												@pl_computer_id,
												@ps_room_id)
FROM c_1_Record


