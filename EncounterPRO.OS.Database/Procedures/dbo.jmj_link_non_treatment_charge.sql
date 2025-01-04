
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_link_non_treatment_charge]
Print 'Drop Procedure [dbo].[jmj_link_non_treatment_charge]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_link_non_treatment_charge]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_link_non_treatment_charge]
GO

-- Create Procedure [dbo].[jmj_link_non_treatment_charge]
Print 'Create Procedure [dbo].[jmj_link_non_treatment_charge]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_link_non_treatment_charge (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_encounter_charge_id integer,
	@ps_created_by varchar(24) )
AS

-- This procedure implements the billing algorithm rule 12 concerning non-treatment charges

DECLARE @ls_procedure_id varchar(24),
		@ls_well_flag char(1),
		@ls_sick_flag char(1),
		@ls_procedure_well_encounter_flag char(1),
		@ll_well_count int,
		@ll_sick_count int

SELECT @ls_well_flag = well_flag,
	@ls_sick_flag = sick_flag
FROM dbo.fn_encounter_well_sick_status(@ps_cpr_id, @pl_encounter_id)

SELECT @ls_procedure_id = procedure_id
FROM p_Encounter_Charge
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND encounter_charge_id = @pl_encounter_charge_id

SELECT 	@ls_procedure_well_encounter_flag = well_encounter_flag
FROM c_Procedure
WHERE procedure_id = @ls_procedure_id

IF @ls_procedure_well_encounter_flag IS NULL OR @ls_procedure_well_encounter_flag NOT IN ('Y', 'N')
	SET @ls_procedure_well_encounter_flag = 'A'

-- Remove any existing associations for this charge
DELETE p_Encounter_Assessment_Charge
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND encounter_charge_id = @pl_encounter_charge_id

SET @ll_well_count = 0
SET @ll_sick_count = 0

-- New Non-Treatment Charge
IF @ls_well_flag = 'Y' AND @ls_procedure_well_encounter_flag IN ('Y', 'A')
	BEGIN
	-- Associate charge with all assessment-billing records where c_Assessment_Type.well_encounter_flag = 'Y'
	INSERT INTO p_Encounter_Assessment_Charge (
		cpr_id,
		encounter_id,
		problem_id,
		encounter_charge_id,
		bill_flag,
		created_by)
	SELECT	pea.cpr_id,
		pea.encounter_id,
		pea.problem_id,
		@pl_encounter_charge_id,
		'Y',
		@ps_created_by
	FROM p_Encounter_Assessment pea
		INNER JOIN c_Assessment_Definition d
		ON pea.assessment_id = d.assessment_id
		INNER JOIN c_Assessment_Type t
		ON d.assessment_type = t.assessment_type
	WHERE pea.cpr_id = @ps_cpr_id
	AND pea.encounter_id = @pl_encounter_id
	AND t.well_encounter_flag = 'Y'
	AND pea.bill_flag = 'Y'
	AND pea.exclusive_link = 'N'
	
	SET @ll_well_count = @@ROWCOUNT
	END

IF @ls_sick_flag = 'Y' AND @ls_procedure_well_encounter_flag IN ('N', 'A')
	BEGIN
	-- Associate charge with all assessment-billing records where c_Assessment_Type.well_encounter_flag = 'N'
	INSERT INTO p_Encounter_Assessment_Charge (
		cpr_id,
		encounter_id,
		problem_id,
		encounter_charge_id,
		bill_flag,
		created_by)
	SELECT	pea.cpr_id,
		pea.encounter_id,
		pea.problem_id,
		@pl_encounter_charge_id,
		'Y',
		@ps_created_by
	FROM p_Encounter_Assessment pea
		INNER JOIN c_Assessment_Definition d
		ON pea.assessment_id = d.assessment_id
		INNER JOIN c_Assessment_Type t
		ON d.assessment_type = t.assessment_type
	WHERE pea.cpr_id = @ps_cpr_id
	AND pea.encounter_id = @pl_encounter_id
	AND t.well_encounter_flag = 'N'
	AND pea.bill_flag = 'Y'
	AND pea.exclusive_link = 'N'
	
	SET @ll_sick_count = @@ROWCOUNT
	END

IF @ll_well_count = 0 AND @ll_sick_count = 0
	BEGIN
	-- If there weren't any associated assessments, then
	-- add an association with all the billed assessments
	INSERT INTO p_Encounter_Assessment_Charge (
		cpr_id,
		encounter_id,
		problem_id,
		encounter_charge_id,
		bill_flag,
		created_by)
	SELECT	@ps_cpr_id,
		@pl_encounter_id,
		problem_id,
		@pl_encounter_charge_id,
		'Y',
		@ps_created_by
	FROM p_Encounter_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND bill_flag = 'Y'
	AND exclusive_link = 'N'

	SET @ll_well_count = @@ROWCOUNT
	END


RETURN @ll_well_count + @ll_sick_count

GO
GRANT EXECUTE
	ON [dbo].[jmj_link_non_treatment_charge]
	TO [cprsystem]
GO

