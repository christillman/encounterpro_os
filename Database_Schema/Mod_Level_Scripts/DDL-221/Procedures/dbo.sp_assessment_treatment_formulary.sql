
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_assessment_treatment_formulary]
Print 'Drop Procedure [dbo].[sp_assessment_treatment_formulary]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_assessment_treatment_formulary]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_assessment_treatment_formulary]
GO

-- Create Procedure [dbo].[sp_assessment_treatment_formulary]
Print 'Create Procedure [dbo].[sp_assessment_treatment_formulary]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_assessment_treatment_formulary (
	@ps_cpr_id varchar(12),
	@ps_assessment_id varchar(24) )
AS

DECLARE @ls_icd10_code varchar(12),
	@ls_authority_id varchar(24)

SELECT @ls_icd10_code = icd10_code
FROM c_Assessment_Definition
WHERE assessment_id = @ps_assessment_id

SELECT @ls_authority_id = authority_id
FROM p_Patient_Authority
WHERE cpr_id = @ps_cpr_id
AND authority_sequence = 1

SELECT DISTINCT af.treatment_type,
	af.treatment_key, 
	f.formulary_code, 
	f.formulary_type, 
	f.title, 
	f.description,
	f.button,
	f.icon,
	f.negative_flag,
	f.sort_sequence
FROM c_Authority_Formulary af 
	JOIN c_Formulary f ON af.formulary_code = f.formulary_code
WHERE af.authority_id = @ls_authority_id
AND @ls_icd10_code LIKE (af.icd10_code + '%')

GO
GRANT EXECUTE
	ON [dbo].[sp_assessment_treatment_formulary]
	TO [cprsystem]
GO

