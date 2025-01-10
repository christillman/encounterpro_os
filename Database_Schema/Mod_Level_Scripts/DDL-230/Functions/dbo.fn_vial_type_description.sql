
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_vial_type_description]
Print 'Drop Function [dbo].[fn_vial_type_description]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_vial_type_description]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_vial_type_description]
GO

-- Create Function [dbo].[fn_vial_type_description]
Print 'Create Function [dbo].[fn_vial_type_description]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_vial_type_description (
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

IF @ll_full_strength_ratio IS NULL
	RETURN NULL

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
GO
GRANT EXECUTE
	ON [dbo].[fn_vial_type_description]
	TO [cprsystem]
GO

