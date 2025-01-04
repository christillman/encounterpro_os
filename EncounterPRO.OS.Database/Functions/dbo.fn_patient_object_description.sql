
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_patient_object_description]
Print 'Drop Function [dbo].[fn_patient_object_description]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_object_description]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_object_description]
GO

-- Create Function [dbo].[fn_patient_object_description]
Print 'Create Function [dbo].[fn_patient_object_description]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_patient_object_description (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(50),
	@pl_object_key int )

RETURNS varchar(255)

AS
BEGIN
DECLARE @ls_description varchar(255),
		@ls_default_description varchar(255)

SET @ls_default_description = @ps_context_object + CAST(@pl_object_key AS varchar(12))
SET @ls_description = @ls_default_description

IF @ps_context_object = 'Patient'
	BEGIN
	SELECT @ls_description = dbo.fn_patient_full_name(cpr_id)
	FROM p_Patient
	WHERE cpr_id = @ps_cpr_id
	
	IF @ls_description IS NULL
		SET @ls_description = @ls_default_description
	END

IF @ps_context_object = 'Encounter'
	BEGIN
	SELECT @ls_description = ISNULL(encounter_description, @ls_default_description)
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_object_key
	
	IF @ls_description IS NULL
		SET @ls_description = @ls_default_description
	END

IF @ps_context_object = 'Assessment'
	BEGIN
	SELECT @ls_description = ISNULL(assessment, @ls_default_description)
	FROM p_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @pl_object_key
	
	IF @ls_description IS NULL
		SET @ls_description = @ls_default_description
	END

IF @ps_context_object = 'Treatment'
	BEGIN
	SELECT @ls_description = ISNULL(treatment_description, @ls_default_description)
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_object_key
	
	IF @ls_description IS NULL
		SET @ls_description = @ls_default_description
	END

IF @ps_context_object = 'Observation'
	BEGIN
	SELECT @ls_description = ISNULL(description, @ls_default_description)
								+ CASE WHEN observation_tag IS NULL THEN '' ELSE ' (' + observation_tag + ')' END
	FROM p_Observation
	WHERE cpr_id = @ps_cpr_id
	AND observation_sequence = @pl_object_key
	
	IF @ls_description IS NULL
		SET @ls_description = @ls_default_description
	END

RETURN @ls_description 

END
GO
GRANT EXECUTE
	ON [dbo].[fn_patient_object_description]
	TO [cprsystem]
GO

