
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_assessment_icd10]
Print 'Drop Procedure [dbo].[sp_get_assessment_icd10]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_assessment_icd10]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_assessment_icd10]
GO

-- Create Procedure [dbo].[sp_get_assessment_icd10]
Print 'Create Procedure [dbo].[sp_get_assessment_icd10]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_get_assessment_icd10 (
	@ps_cpr_id varchar(12),
	@ps_assessment_id varchar(24)
	--, @ps_insurance_id varchar(24) OUTPUT,
	--@ps_icd10_code varchar(12) OUTPUT
	)
AS
DECLARE @li_authority_sequence smallint
	, @ls_insurance_id varchar(24)
	, @ls_icd10_code varchar(12)
	, @ls_asst_description varchar(80)
	
SELECT @ls_insurance_id = NULL,
	@ls_icd10_code = NULL
-- Assume that minimal sequence number is primary insurance carrier
SELECT @li_authority_sequence = min(authority_sequence)
FROM p_Patient_Authority WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id

IF @li_authority_sequence IS NOT NULL
	SELECT @ls_insurance_id = i.authority_id,
		@ls_icd10_code = i.icd10_code
	FROM c_Assessment_Coding i
	JOIN p_Patient_Authority pi WITH (NOLOCK) ON pi.authority_id = i.authority_id
	WHERE pi.cpr_id = @ps_cpr_id
	AND pi.authority_sequence = @li_authority_sequence
	AND i.assessment_id = @ps_assessment_id

IF @ls_insurance_id IS NULL
	SELECT @ls_icd10_code = icd10_code,@ls_asst_description=description
	FROM c_Assessment_Definition
	WHERE assessment_id = @ps_assessment_id

SELECT @ls_insurance_id AS insurance_id, @ls_icd10_code AS icd10_code,@ls_asst_description as asst_description

GO
GRANT EXECUTE
	ON [dbo].[sp_get_assessment_icd10]
	TO [cprsystem]
GO

