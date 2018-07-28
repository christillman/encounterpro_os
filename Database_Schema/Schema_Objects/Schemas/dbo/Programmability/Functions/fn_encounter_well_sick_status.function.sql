CREATE FUNCTION fn_encounter_well_sick_status (
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

