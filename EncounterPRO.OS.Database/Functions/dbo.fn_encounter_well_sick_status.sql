
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_encounter_well_sick_status]
Print 'Drop Function [dbo].[fn_encounter_well_sick_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_encounter_well_sick_status]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_encounter_well_sick_status]
GO

-- Create Function [dbo].[fn_encounter_well_sick_status]
Print 'Create Function [dbo].[fn_encounter_well_sick_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_encounter_well_sick_status (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int
	)

RETURNS @well_sick_status TABLE (
	well_flag char(1) NOT NULL,
	sick_flag char(1) NOT NULL)
AS

BEGIN
DECLARE @ls_well_flag char(1),
		@ls_sick_flag char(1)

SET @ls_well_flag = 'N'
SET @ls_sick_flag = 'N'


IF EXISTS (SELECT 1
			FROM p_Encounter_Assessment a
				INNER JOIN c_Assessment_Definition d
				ON a.assessment_id = d.assessment_id
			WHERE a.cpr_id = @ps_cpr_id
			AND a.encounter_id = @pl_encounter_id
			AND d.assessment_type = 'WELL'
			AND a.bill_flag = 'Y')
	SET @ls_well_flag = 'Y'
 
IF EXISTS (SELECT 1
			FROM p_Encounter_Assessment a
				INNER JOIN c_Assessment_Definition d
				ON a.assessment_id = d.assessment_id
			WHERE a.cpr_id = @ps_cpr_id
			AND a.encounter_id = @pl_encounter_id
			AND d.assessment_type NOT IN ('WELL', 'VACCINE')
			AND a.bill_flag = 'Y')
	SET @ls_sick_flag = 'Y'

IF @ls_well_flag = 'N'
	SET @ls_sick_flag = 'Y'

	
INSERT INTO @well_sick_status (
	well_flag,
	sick_flag
	)
VALUES (
	@ls_well_flag,
	@ls_sick_flag)

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_encounter_well_sick_status] TO [cprsystem]
GO

