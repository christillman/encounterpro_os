CREATE PROCEDURE sp_get_default_encounter_proc (
	@ps_encounter_type varchar(24),
	@ps_new_flag char(1),
	@pl_visit_level int
	--, @ps_procedure_id varchar(24) OUTPUT
	)
AS

DECLARE @ls_procedure_id varchar(24)

IF @pl_visit_level IS NULL OR @pl_visit_level <= 0
	SET @pl_visit_level = 1

IF @pl_visit_level > 5
	SET @pl_visit_level = 5

IF @ps_new_flag = 'Y'
	SET @ps_new_flag = 'Y'
ELSE
	SET @ps_new_flag = 'N'

SELECT @ls_procedure_id = v.procedure_id
FROM c_Encounter_Type e, em_Visit_Code_Item v
WHERE e.encounter_type = @ps_encounter_type
AND e.visit_code_group = v.visit_code_group
AND v.new_flag = @ps_new_flag
AND v.visit_level = @pl_visit_level

-- If we didn't get one then try useing 'SICK' as the visit code group
IF @@ROWCOUNT <> 1
	BEGIN
	SELECT @ls_procedure_id = procedure_id
	FROM em_Visit_Code_Item
	WHERE visit_code_group = 'SICK'
	AND new_flag = @ps_new_flag
	AND visit_level = @pl_visit_level

	IF @@ROWCOUNT <> 1
		SELECT  @ls_procedure_id = NULL
	END

SELECT @ls_procedure_id AS procedure_id


