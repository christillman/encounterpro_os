CREATE FUNCTION fn_vial_type_description (
	@ps_vial_type varchar(24) )

RETURNS varchar(80)

AS
BEGIN
DECLARE @ls_description varchar(80),
	@ll_full_strength_ratio int,
	@ls_dilute_from_vial_type varchar(24),
	@ll_dilute_ratio int,
	@ls_full_strength_string varchar(24),
	@ls_full_strength_commas varchar(24),
	@ll_groups int,
	@ll_counter int,
	@ll_groupstart int

-- Get info about the vial type
SELECT @ll_full_strength_ratio = full_strength_ratio,
	@ls_dilute_from_vial_type = dilute_from_vial_type,
	@ll_dilute_ratio = dilute_ratio
FROM c_Vial_Type
WHERE vial_type = @ps_vial_type

IF @@ROWCOUNT <> 1
	BEGIN
	SET @ls_description = NULL
	RETURN @ls_description
	END

SET @ls_full_strength_string = CAST(@ll_full_strength_ratio AS varchar(24))
IF LEN(@ls_full_strength_string) >= 4
	BEGIN
	SET @ls_full_strength_commas = ''
	SET @ll_groups = (LEN(@ls_full_strength_string) - 1) / 3
	SET @ll_counter = 1
	WHILE @ll_counter <= @ll_groups
		BEGIN
		IF @ll_counter > 1
			SET @ls_full_strength_commas = ',' + @ls_full_strength_commas
		SET @ll_groupstart = LEN(@ls_full_strength_string) - (3 * @ll_counter) + 1
		SET @ls_full_strength_commas = SUBSTRING(@ls_full_strength_string, @ll_groupstart, 3) + @ls_full_strength_commas

		SET @ll_counter = @ll_counter + 1
		END
	IF LEN(@ls_full_strength_string) > (3 * @ll_groups)
		SET @ls_full_strength_commas = SUBSTRING(@ls_full_strength_string, 1, LEN(@ls_full_strength_string) - (3 * @ll_groups)) + ',' + @ls_full_strength_commas
	END
ELSE
	SET @ls_full_strength_commas = @ls_full_strength_string

SET @ls_description = '1:' + @ls_full_strength_commas
SET @ls_description = @ls_description + ' ' + @ps_vial_type

RETURN @ls_description 

END
