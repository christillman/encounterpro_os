CREATE FUNCTION fn_em_encounter_visit_level (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer)

RETURNS int

AS
BEGIN
DECLARE @ll_visit_level int,
		@ls_level varchar(255),
		@ls_em_doc_guide varchar(24)

SET @ll_visit_level = NULL

-- Make sure we have input params
IF @ps_cpr_id IS NULL
	RETURN @ll_visit_level

IF @pl_encounter_id IS NULL
	RETURN @ll_visit_level

-- See if there is a user-selected visit level
SET @ls_level = dbo.fn_patient_object_progress_value(@ps_cpr_id, 'Encounter', 'Property', @pl_encounter_id, 'EM_ENCOUNTER_LEVEL')
IF ISNUMERIC(@ls_level) = 1
	BEGIN
	SET @ll_visit_level = CAST(@ls_level AS int)
	IF @ll_visit_level > 0
		RETURN @ll_visit_level
	END

-- See if there is a recorded calculated visit level
SET @ls_level = dbo.fn_patient_object_progress_value(@ps_cpr_id, 'Encounter', 'Property', @pl_encounter_id, 'Calculated EM Encounter Level')
IF ISNUMERIC(@ls_level) = 1
	BEGIN
	SET @ll_visit_level = CAST(@ls_level AS int)
	IF @ll_visit_level > 0
		RETURN @ll_visit_level
	END

-- We didn't find a user set level or a recorded calculated level.  Before we recalculate the level from scratch, let's see
-- if we can figure out the level from the billed visit code
SELECT @ll_visit_level = MAX(visit_level)
FROM p_Patient_Encounter e
	INNER JOIN c_Encounter_Type et
	ON e.encounter_type = et.encounter_type
	INNER JOIN em_visit_code_item i
	ON et.visit_code_group = i.visit_code_group
	AND e.new_flag = i.new_flag
	INNER JOIN p_Encounter_Charge c
	ON e.cpr_id = c.cpr_id
	AND e.encounter_id = c.encounter_id
	AND i.procedure_id = c.procedure_id
WHERE e.cpr_id = @ps_cpr_id
AND e.encounter_id = @pl_encounter_id
AND c.procedure_type = 'PRIMARY'
AND c.bill_flag = 'Y'

IF @ll_visit_level > 0
	RETURN @ll_visit_level


-- We need to recalculate the visit level.  First we need to know which doc guide to use.
SET @ls_em_doc_guide = dbo.fn_patient_object_progress_value(@ps_cpr_id, 'Encounter', 'Property', @pl_encounter_id, 'em_documentation_guide')
IF @ls_em_doc_guide IS NULL
	SET @ls_em_doc_guide = dbo.fn_get_preference('BILLING', 'em_documentation_guide', DEFAULT, DEFAULT)

IF @ls_em_doc_guide IS NULL
	SET @ls_em_doc_guide = '1997 E&M'

SELECT @ll_visit_level = MAX(visit_level)
FROM dbo.fn_em_visit_rules_passed (@ps_cpr_id, @pl_encounter_id, @ls_em_doc_guide)
WHERE passed_flag = 'Y'

IF @ll_visit_level > 0
	RETURN @ll_visit_level

RETURN 1

END

