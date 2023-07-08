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

-- Drop Function [dbo].[fn_pretty_phone]
Print 'Drop Function [dbo].[fn_pretty_phone]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_pretty_phone]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_pretty_phone]
GO

-- Create Function [dbo].[fn_pretty_phone]
Print 'Create Function [dbo].[fn_pretty_phone]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_pretty_phone (
	@ps_phone_number varchar(32))

RETURNS varchar(32)

AS
BEGIN

-- To enable, comment the following line
RETURN @ps_phone_number

DECLARE @ls_pretty_phone varchar(32),
		@ls_char char(1),
		@ll_charnum int,
		@ls_digits varchar(15),
		@ls_area varchar(6),
		@ls_number varchar(8),
		@ls_rest varchar(32)

SET @ll_charnum = 0
SET @ls_digits = ''
SET @ls_rest = ''

WHILE @ll_charnum < LEN(@ps_phone_number)
	BEGIN
	SET @ll_charnum = @ll_charnum + 1
	SET @ls_char = SUBSTRING(@ps_phone_number, @ll_charnum, 1)
	
	-- After we have all 10 digits plus punctuation, or when we hit an 'x', just tack the rest on verbatim		
	IF LEN(@ls_digits) = 10 OR @ls_char = 'x'
		BEGIN
		SET @ls_rest = SUBSTRING(@ps_phone_number, @ll_charnum, LEN(@ps_phone_number))
		BREAK
		END

	-- If we have a digit, then add it to the digits variable
	IF @ls_char >= '0' AND @ls_char <= '9'
		SET @ls_digits = @ls_digits + @ls_char
	END

IF LEN(@ls_digits) = 0
	BEGIN
	SET @ls_area = ''
	SET @ls_number = ''
	END
ELSE IF LEN(@ls_digits) <= 7
	BEGIN
	SET @ls_area = ''
	SET @ls_number = SUBSTRING(@ls_digits, 1, 3) + '-' + SUBSTRING(@ls_digits, 4, 4)
	END
ELSE
	BEGIN
	SET @ls_area = '(' + LEFT(@ls_digits, 3) + ') '
	SET @ls_number = SUBSTRING(@ls_digits, 4, 3) + '-' + SUBSTRING(@ls_digits, 7, 4)
	END

SET @ls_pretty_phone = RTRIM(@ls_area + @ls_number + ' ' + @ls_rest)

IF LEN(@ls_pretty_phone) = 0
	SET @ls_pretty_phone = NULL

RETURN @ls_pretty_phone

END

GO
GRANT EXECUTE
	ON [dbo].[fn_pretty_phone]
	TO [cprsystem]
GO

