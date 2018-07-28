CREATE FUNCTION fn_pretty_address (
	@ps_address_line_1 varchar(40),
	@ps_address_line_2 varchar(40),
	@ps_city varchar(40),
	@ps_state varchar(2),
	@ps_zip varchar(10),
	@ps_country varchar(20))

RETURNS varchar(80)

AS
BEGIN
DECLARE @ls_pretty_address varchar(80),
		@ls_city_state_zip varchar(60),
		@ls_line_delimiter varchar(8)

SET @ls_pretty_address = ''
SET @ls_line_delimiter = '  '

IF LEN(@ps_address_line_1) > 0 
	SET @ls_pretty_address = @ls_pretty_address + @ps_address_line_1

IF LEN(@ps_address_line_2) > 0
	BEGIN
	IF LEN(@ls_pretty_address) > 0
		SET @ls_pretty_address = @ls_pretty_address + @ls_line_delimiter
	SET @ls_pretty_address = @ls_pretty_address + @ps_address_line_2
	END

SET @ls_city_state_zip = ''

IF LEN(@ps_city) > 0
	SET @ls_city_state_zip = @ls_city_state_zip + @ps_city


IF LEN(@ps_state) > 0
	BEGIN
	IF LEN(@ls_city_state_zip) > 0
		SET @ls_city_state_zip = @ls_city_state_zip + ', '
	SET @ls_city_state_zip = @ls_city_state_zip + @ps_state
	END


IF LEN(@ps_zip) > 0
	BEGIN
	IF LEN(@ls_city_state_zip) > 0
		SET @ls_city_state_zip = @ls_city_state_zip + '  '
	SET @ls_city_state_zip = @ls_city_state_zip + @ps_zip
	END


IF LEN(@ls_city_state_zip) > 0
	BEGIN
	IF LEN(@ls_pretty_address) > 0 
		SET @ls_pretty_address = @ls_pretty_address + @ls_line_delimiter
	SET @ls_pretty_address = @ls_pretty_address + @ls_city_state_zip
	END



RETURN @ls_pretty_address 

END

