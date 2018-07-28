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


