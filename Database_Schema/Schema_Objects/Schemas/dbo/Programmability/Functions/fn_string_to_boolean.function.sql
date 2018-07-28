CREATE FUNCTION dbo.fn_string_to_boolean (
	@ps_string varchar(255))

RETURNS bit

AS
BEGIN
DECLARE @lb_boolean bit,
		@ll_number decimal(19,6)

IF LEN(@ps_string) > 0
	BEGIN
	IF ISNUMERIC(@ps_string) = 1
		BEGIN
		IF CAST(@ps_string AS decimal(19,6)) = 0
			SET @lb_boolean = 0
		ELSE
			SET @lb_boolean = 1
		END
	ELSE
		BEGIN
		IF LEFT(@ps_string, 1) IN ('T', 'Y')
			SET @lb_boolean = 1
		ELSE
			SET @lb_boolean = 0
		END
	END
ELSE
	SET @lb_boolean = 0


RETURN @lb_boolean 

END

