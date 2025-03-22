
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_treatment_list_set_attribute]
Print 'Drop Procedure [dbo].[jmj_treatment_list_set_attribute]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_treatment_list_set_attribute]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_treatment_list_set_attribute]
GO

-- Create Procedure [dbo].[jmj_treatment_list_set_attribute]
Print 'Create Procedure [dbo].[jmj_treatment_list_set_attribute]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_treatment_list_set_attribute (
	@pl_definition_id int,
	@ps_attribute varchar(80),
	@ps_value varchar(max))
AS

DECLARE @ls_value varchar(255),
		@ll_len_value int


SET @ll_len_value = LEN(CAST(@ps_value AS varchar(300)))

IF @ll_len_value > 255
	BEGIN
	UPDATE u_Assessment_Treat_Def_Attrib
	SET long_value = @ps_value
	WHERE definition_id = @pl_definition_id
	AND attribute = @ps_attribute
	
	IF @@ROWCOUNT = 0
		INSERT INTO u_Assessment_Treat_Def_Attrib (
			definition_id,
			attribute,
			long_value )
		VALUES (
			@pl_definition_id,
			@ps_attribute,
			@ps_value)
		
	END
ELSE
	BEGIN
	SET @ls_value = CAST(@ps_value AS varchar(255))
	
	UPDATE u_Assessment_Treat_Def_Attrib
	SET long_value = @ls_value
	WHERE definition_id = @pl_definition_id
	AND attribute = @ps_attribute
	
	IF @@ROWCOUNT = 0
		INSERT INTO u_Assessment_Treat_Def_Attrib (
			definition_id,
			attribute,
			value )
		VALUES (
			@pl_definition_id,
			@ps_attribute,
			@ls_value)
	END

IF @ps_attribute = 'treatment_description'
	BEGIN
	IF @ll_len_value > 255
		SET @ls_value = CAST(@ps_value AS varchar(252)) + '...'
	ELSE
		SET @ls_value = CAST(@ps_value AS varchar(255))
	
	UPDATE u_Assessment_Treat_definition
	SET treatment_description = @ls_value
	WHERE definition_id = @pl_definition_id
	END

GO
GRANT EXECUTE
	ON [dbo].[jmj_treatment_list_set_attribute]
	TO [cprsystem]
GO

