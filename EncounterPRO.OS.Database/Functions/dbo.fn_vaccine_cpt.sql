
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_vaccine_cpt]
Print 'Drop Function [dbo].[fn_vaccine_cpt]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_vaccine_cpt]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_vaccine_cpt]
GO

-- Create Function [dbo].[fn_vaccine_cpt]
Print 'Create Function [dbo].[fn_vaccine_cpt]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_vaccine_cpt (
	@ps_drug_id varchar(12))

RETURNS varchar(24)

AS
BEGIN
DECLARE @ls_procedure_id varchar(24),
		@ls_cpt_code varchar(24),
		@ll_error int,
		@ll_rowcount int

SELECT @ls_procedure_id = procedure_id
FROM c_Drug_Definition
WHERE drug_id = @ps_drug_id

IF @@ERROR <> 0
	RETURN @ls_cpt_code

IF @ls_procedure_id IS NULL
	RETURN @ls_cpt_code

SELECT @ls_cpt_code = cpt_code
FROM c_Procedure
where procedure_id = @ls_procedure_id


RETURN @ls_cpt_code

END

GO
GRANT EXECUTE
	ON [dbo].[fn_vaccine_cpt]
	TO [cprsystem]
GO

