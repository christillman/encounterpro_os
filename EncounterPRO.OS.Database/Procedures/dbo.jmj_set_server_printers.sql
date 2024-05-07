--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_set_server_printers]
Print 'Drop Procedure [dbo].[jmj_set_server_printers]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_set_server_printers]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_set_server_printers]
GO

-- Create Procedure [dbo].[jmj_set_server_printers]
Print 'Create Procedure [dbo].[jmj_set_server_printers]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
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
SET last_discovered = dbo.get_client_datetime()
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
AND last_discovered < DATEADD(week, -1, dbo.get_client_datetime())

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


GO
GRANT EXECUTE
	ON [dbo].[jmj_set_server_printers]
	TO [cprsystem]
GO

