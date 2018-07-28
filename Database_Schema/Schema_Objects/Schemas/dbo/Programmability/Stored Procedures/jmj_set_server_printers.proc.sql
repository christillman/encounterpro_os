CREATE PROCEDURE jmj_set_server_printers (
	@pl_computer_id integer)
AS

DECLARE @ls_allow_flag char(1),
		@ls_temp varchar(255)

IF @pl_computer_id IS NULL
	RETURN

IF @pl_computer_id <= 0
	RETURN

-- Delete any duplicate printers that already exist
DELETE p1
FROM o_Computer_Printer p1
	INNER JOIN o_Computer_Printer p2
	ON p1.computer_id = p2.computer_id
	AND p1.printer = p2.printer
	AND p1.printer_sequence < p2.printer_sequence
WHERE p1.computer_id = 0

DECLARE @new_printers TABLE (
	printer varchar(128) NOT NULL,
	max_printer_sequence int NOT NULL)

-- Get single record per printer
INSERT INTO @new_printers (
	printer,
	max_printer_sequence )
SELECT op1.printer,
	max(op1.printer_sequence)
FROM o_Computer_Printer op1
WHERE computer_id = @pl_computer_id
AND NOT EXISTS (
	SELECT 1
	FROM o_Computer_Printer op2
	WHERE op2.computer_id = 0
	AND op1.printer = op2.printer)
GROUP BY op1.printer

-- Insert into server printers list
INSERT INTO o_Computer_Printer (
   computer_id
   ,printer
   ,driver
   ,port
   ,display_name)
SELECT DISTINCT 0
			   ,op1.printer
			   ,op1.driver
			   ,op1.port
			   ,op1.display_name
FROM o_Computer_Printer op1
	INNER JOIN @new_printers x
	ON op1.computer_id = @pl_computer_id
	AND op1.printer = x.printer
	AND op1.printer_sequence = x.max_printer_sequence
WHERE op1.printer NOT LIKE '%(from%in session%'

UPDATE op1
SET last_discovered = getdate()
FROM o_Computer_Printer op1
	INNER JOIN o_Computer_Printer op2
	ON op1.printer = op2.printer
WHERE op1.computer_id = 0
AND op2.computer_id = @pl_computer_id

----------------------------------------------------------
-- Remove old printers that don't exist anymore
----------------------------------------------------------
DELETE op1
FROM o_Computer_Printer op1
WHERE op1.computer_id = 0
AND last_discovered < DATEADD(week, -1, getdate())

DELETE po
FROM o_Computer_Printer_Office po
WHERE NOT EXISTS (
	SELECT 1
	FROM o_Computer_Printer op1
	WHERE op1.computer_id = 0
	AND op1.printer = po.printer)

----------------------------------------------------------
-- Make sure the office records exist
----------------------------------------------------------
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
SELECT p.computer_id ,
	p.printer ,
	o.office_id,
	@ls_allow_flag
FROM o_Computer_Printer p
	CROSS JOIN c_Office o
WHERE p.computer_id = 0
AND NOT EXISTS (
	SELECT 1
	FROM o_Computer_Printer_Office op
	WHERE p.computer_id = op.computer_id
	AND p.printer = op.printer
	AND o.office_id = op.office_id)


