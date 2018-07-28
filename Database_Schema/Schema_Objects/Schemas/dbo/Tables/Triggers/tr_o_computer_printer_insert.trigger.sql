CREATE TRIGGER tr_o_computer_printer_insert ON dbo.o_computer_printer
FOR INSERT
AS

DECLARE @ls_allow_flag char(1),
		@ls_temp varchar(255)

IF @@ROWCOUNT = 0
	RETURN

UPDATE p
SET display_name = CAST(p.printer AS varchar(64))
FROM o_Computer_Printer p
	INNER JOIN inserted i
	ON p.computer_id = i.computer_id
	AND p.printer_sequence = i.printer_sequence
WHERE p.display_name IS NULL


SET @ls_temp = dbo.fn_get_preference('SYSTEM', 'New Printer Available', DEFAULT, DEFAULT)
IF @ls_temp IS NULL OR LEFT(@ls_temp, 1) IN ('Y', 'T')
	SET @ls_allow_flag = 'Y'
ELSE
	SET @ls_allow_flag = 'N'

INSERT INTO o_Computer_Printer_Office (
	computer_id ,
	printer ,
	office_id ,
	allow_flag )
SELECT i.computer_id ,
	i.printer ,
	o.office_id,
	@ls_allow_flag
FROM inserted i
	CROSS JOIN c_Office o
WHERE i.computer_id = 0
AND NOT EXISTS (
	SELECT 1
	FROM o_Computer_Printer_Office op
	WHERE i.computer_id = op.computer_id
	AND i.printer = op.printer
	AND o.office_id = op.office_id)
