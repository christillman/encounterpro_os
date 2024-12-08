
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_parse_string]
Print 'Drop Function [dbo].[fn_parse_string]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_parse_string]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_parse_string]
GO

-- Create Function [dbo].[fn_parse_string]
Print 'Create Function [dbo].[fn_parse_string]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_parse_string (
	@ps_string varchar(4000),
	@ps_delimiter varchar(40) )

RETURNS @items TABLE (
	[item_number] int NOT NULL IDENTITY (1, 1),
	[item] [varchar] (255) NOT NULL)
AS

BEGIN

DECLARE @ls_string varchar(4000),
		@ls_item varchar(255),
		@ll_pos int

IF @ps_string IS NULL OR @ps_delimiter IS NULL
	RETURN

SET @ls_string = @ps_string

WHILE LEN(@ls_string) > 0
	BEGIN
	SET @ll_pos = PATINDEX('%' + @ps_delimiter + '%', @ls_string)

	IF @ll_pos > 0
		BEGIN
		IF @ll_pos = 0
			SET @ls_item = ''
		ELSE
			SET @ls_item = CAST(LEFT(@ls_string, @ll_pos - 1) AS varchar(255))

		SET @ls_string = SUBSTRING (@ls_string ,LEN(@ls_item) + LEN(@ps_delimiter) + 1, LEN(@ls_string) )

		END
	ELSE
		BEGIN
		-- Pattern was not found, so the rest of the string is the last item
		SET @ls_item = CAST(@ls_string AS varchar(255))
		SET @ls_string = ''
		END

	INSERT INTO @items (
		item)
	VALUES (
		@ls_item)

	END


RETURN

END

GO
GRANT SELECT ON [dbo].[fn_parse_string] TO [cprsystem]
GO

