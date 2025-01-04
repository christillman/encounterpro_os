
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_object_description]
Print 'Drop Function [dbo].[fn_object_description]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_object_description]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_object_description]
GO

-- Create Function [dbo].[fn_object_description]
Print 'Create Function [dbo].[fn_object_description]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_object_description (
	@ps_object varchar(40),
	@ps_key varchar(40) )

RETURNS varchar(255)

AS
BEGIN
DECLARE @ls_description varchar(255)

SET @ls_description = @ps_key

IF @ps_object = 'Drug'
	BEGIN
	SELECT @ls_description = common_name
	FROM c_Drug_Definition
	WHERE drug_id = @ps_key
	
	IF @ls_description IS NULL
		SET @ls_description = @ps_key
	END

IF @ps_object = 'Consultant'
	BEGIN
	SELECT @ls_description = description
	FROM c_Consultant
	WHERE consultant_id = @ps_key
	
	IF @ls_description IS NULL
		SET @ls_description = @ps_key
	END

RETURN @ls_description 

END
GO
GRANT EXECUTE
	ON [dbo].[fn_object_description]
	TO [cprsystem]
GO

