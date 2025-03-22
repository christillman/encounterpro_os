
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_treatment_type_treatment_key]
Print 'Drop Function [dbo].[fn_treatment_type_treatment_key]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_treatment_type_treatment_key]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_treatment_type_treatment_key]
GO

-- Create Function [dbo].[fn_treatment_type_treatment_key]
Print 'Create Function [dbo].[fn_treatment_type_treatment_key]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_treatment_type_treatment_key (
	@ps_treatment_type varchar(24) )

RETURNS varchar(64)

AS
BEGIN
DECLARE @ls_component_id varchar(24),
		@ls_treatment_key varchar(64)

SELECT @ls_component_id = component_id
FROM c_Treatment_Type
WHERE treatment_type = @ps_treatment_type

SET @ls_treatment_key = CASE @ls_component_id
		WHEN 'TREAT_IMMUNIZATION' THEN 'drug_id'
		WHEN 'TREAT_MATERIAL' THEN 'material_id'
		WHEN 'TREAT_MEDICATION' THEN 'drug_id'
		WHEN 'TREAT_OFFICEMED' THEN 'drug_id'
		WHEN 'TREAT_PROCEDURE' THEN 'procedure_id'
		WHEN 'TREAT_TEST' THEN 'observation_id'
		WHEN 'TREAT_ACTIVITY' THEN 'treatment_description'
		ELSE 'treatment_type' END

RETURN @ls_treatment_key 

END

GO
GRANT EXECUTE
	ON [dbo].[fn_treatment_type_treatment_key]
	TO [cprsystem]
GO

