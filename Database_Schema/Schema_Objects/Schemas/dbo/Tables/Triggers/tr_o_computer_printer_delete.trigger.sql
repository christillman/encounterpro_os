CREATE TRIGGER tr_o_computer_printer_delete ON dbo.o_computer_printer
FOR DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

DELETE op
FROM o_Computer_Printer_Office op
	INNER JOIN deleted d
	ON d.computer_id = op.computer_id
	AND d.printer = op.printer

