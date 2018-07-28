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

-- Drop Function [dbo].[fn_compare]
Print 'Drop Function [dbo].[fn_compare]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_compare]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_compare]
GO

-- Create Function [dbo].[fn_compare]
Print 'Create Function [dbo].[fn_compare]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_compare (
	@ps_value_1 varchar(255),
	@ps_value_2 varchar(255),
	@ps_operator varchar(24)
	)
RETURNS bit

AS
BEGIN

DECLARE @lb_return bit

SET @lb_return = 0

-- This function compares two strings and returns true or false based on the operator
DECLARE @ld_number1 decimal(19,6),
		@ld_number2 decimal(19,6),
		@lb_numeric bit,
		@lb_boolean1 bit,
		@lb_boolean2 bit,
		@lb_left_null bit,
		@lb_right_null bit,
		@lb_left_or_right_null bit

SET @lb_left_null = 0
SET @lb_right_null = 0
SET @lb_left_or_right_null = 0

IF @ps_value_1 IS NULL OR @ps_value_1 = ''
	BEGIN
	SET @lb_left_null = 1
	SET @lb_left_or_right_null = 1
	END

IF @ps_value_2 IS NULL or @ps_value_2 = ''
	BEGIN
	SET @lb_right_null = 1
	SET @lb_left_or_right_null = 1
	END

IF ISNUMERIC(@ps_value_1) = 1 and ISNUMERIC(@ps_value_2) = 1
	BEGIN
	SET @ld_number1 = CAST(@ps_value_1 AS decimal(19,6))
	SET @ld_number2 = CAST(@ps_value_2 AS decimal(19,6))
	SET @lb_numeric = 1
	END
ELSE
	SET @lb_numeric = 0

IF @ps_operator IN ('is true')
	BEGIN
	IF @lb_left_null = 1
		RETURN 0

	IF dbo.fn_string_to_boolean(@ps_value_1) = 1
		RETURN 1
	ELSE
		RETURN 0
	END

IF @ps_operator IN ('is false')
	BEGIN
	IF @lb_left_null = 1
		RETURN 0

	IF dbo.fn_string_to_boolean(@ps_value_1) = 1
		RETURN 0
	ELSE
		RETURN 1
	END

IF @ps_operator IN ('==')
	BEGIN
	IF @lb_left_or_right_null = 1
		RETURN 0

	-- This is a boolean comparison so first convert both sides to a boolean
	SET @lb_boolean1 = dbo.fn_string_to_boolean(@ps_value_1)
	SET @lb_boolean2 = dbo.fn_string_to_boolean(@ps_value_2)
	-- If the boolean form of both strings are the same then return true
	IF @lb_boolean1 = @lb_boolean2
		RETURN 1
	ELSE
		RETURN 0
	END

IF @ps_operator IN ('!==')
	BEGIN
	IF @lb_left_or_right_null = 1
		RETURN 0

	-- This is a boolean comparison so first convert both sides to a boolean
	-- This is a boolean comparison so first convert both sides to a boolean
	SET @lb_boolean1 = dbo.fn_string_to_boolean(@ps_value_1)
	SET @lb_boolean2 = dbo.fn_string_to_boolean(@ps_value_2)
	-- If the boolean form of both strings are the same then return true
	IF @lb_boolean1 = @lb_boolean2
		RETURN 0
	ELSE
		RETURN 1
	END

IF @ps_operator IN ('=', 'eq', 'equal', 'equals')
	BEGIN
	IF @lb_left_or_right_null = 1
		RETURN 0

	-- This type of compare treats two nulls as equal
	IF @ps_value_1 IS NULL AND @ps_value_2 IS NULL
		RETURN 1

	IF @ps_value_1 = @ps_value_2
		RETURN 1
	ELSE
		RETURN 0
	END

IF @ps_operator IN ('!=', '<>', 'not equal', 'not equals')
	BEGIN
	IF @lb_left_or_right_null = 1
		RETURN 0

	-- This type of compare treats two nulls as equal
	IF @ps_value_1 IS NULL AND @ps_value_2 IS NULL
		RETURN 0

	IF @ps_value_1 = @ps_value_2
		RETURN 0
	ELSE
		RETURN 1
	END

IF @ps_operator IN ('<', 'less than')
	BEGIN
	IF @lb_left_or_right_null = 1
		RETURN 0

	IF @lb_numeric = 1
		BEGIN
		IF @ld_number1 < @ld_number2
			RETURN 1
		ELSE
			RETURn 0
		END
	ELSE
		BEGIN
		IF @ps_value_1 < @ps_value_2
			RETURN 1
		ELSE
			RETURn 0
		END
	END

IF @ps_operator IN ('>', 'greater than')
	BEGIN
	IF @lb_left_or_right_null = 1
		RETURN 0

	IF @lb_numeric = 1
		BEGIN
		IF @ld_number1 > @ld_number2
			RETURN 1
		ELSE
			RETURn 0
		END
	ELSE
		BEGIN
		IF @ps_value_1 > @ps_value_2
			RETURN 1
		ELSE
			RETURn 0
		END
	END

IF @ps_operator IN ('<=', 'less than or equal')
	BEGIN
	IF @lb_left_or_right_null = 1
		RETURN 0

	IF @lb_numeric = 1
		BEGIN
		IF @ld_number1 <= @ld_number2
			RETURN 1
		ELSE
			RETURn 0
		END
	ELSE
		BEGIN
		IF @ps_value_1 <= @ps_value_2
			RETURN 1
		ELSE
			RETURn 0
		END
	END

IF @ps_operator IN ('>=', 'greater than or equal')
	BEGIN
	IF @lb_left_or_right_null = 1
		RETURN 0

	IF @lb_numeric = 1
		BEGIN
		IF @ld_number1 >= @ld_number2
			RETURN 1
		ELSE
			RETURn 0
		END
	ELSE
		BEGIN
		IF @ps_value_1 >= @ps_value_2
			RETURN 1
		ELSE
			RETURn 0
		END
	END

IF @ps_operator IN ('not exists', 'is empty', 'is null')
	BEGIN
	-- For the exists operator, we don't care what the string2 is, only that string1 is null or empty
	IF LEN(@ps_value_1) > 0
		RETURN 0
	ELSE
		RETURN 1
	END

IF @ps_operator IN ('exists', 'does not exist', 'is not empty', 'is not null')
	BEGIN
	-- For the exists operator, we don't care what the string2 is, only that string1 is not null or empty
	IF LEN(@ps_value_1) > 0
		RETURN 1
	ELSE
		RETURN 0
	END


-- If the operator was not recognized or if the case statement didn't return true, then return false
SET @lb_return = 0

RETURN @lb_return

END


GO
GRANT EXECUTE
	ON [dbo].[fn_compare]
	TO [cprsystem]
GO

