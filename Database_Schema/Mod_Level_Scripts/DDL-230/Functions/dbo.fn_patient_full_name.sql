
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_patient_full_name]
Print 'Drop Function [dbo].[fn_patient_full_name]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_full_name]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_full_name]
GO

-- Create Function [dbo].[fn_patient_full_name]
Print 'Create Function [dbo].[fn_patient_full_name]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_patient_full_name (
	@ps_cpr_id varchar(12) )

RETURNS varchar(80)

AS
BEGIN
DECLARE @ls_patient_full_name varchar(80),
	@ls_last_name varchar(40),
	@ls_first_name varchar(20),
	@ls_middle_name varchar(20),
	@ls_name_suffix varchar(12),
	@ls_name_prefix varchar(12),
	@ls_degree varchar(12)

IF @ps_cpr_id IS NULL
	BEGIN
	SET @ls_patient_full_name = NULL
	RETURN @ls_patient_full_name
	END

SELECT @ls_last_name = last_name,
	@ls_first_name = first_name,
	@ls_middle_name = middle_name,
	@ls_name_suffix = name_suffix,
	@ls_name_prefix = name_prefix,
	@ls_degree = degree
FROM p_Patient (NOLOCK)
WHERE cpr_id = @ps_cpr_id

IF @ls_last_name IS NULL
	RETURN NULL

SET @ls_patient_full_name = dbo.fn_pretty_name(@ls_last_name ,
											@ls_first_name ,
											@ls_middle_name ,
											@ls_name_suffix ,
											@ls_name_prefix ,
											@ls_degree )

RETURN @ls_patient_full_name 

END

GO
GRANT EXECUTE
	ON [dbo].[fn_patient_full_name]
	TO [cprsystem]
GO

