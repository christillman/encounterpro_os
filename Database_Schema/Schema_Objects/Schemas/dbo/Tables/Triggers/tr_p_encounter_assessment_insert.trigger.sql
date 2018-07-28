CREATE TRIGGER tr_p_encounter_assessment_insert ON dbo.p_Encounter_Assessment
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_cpr_id varchar(12),
		 @ll_encouter_id int,
		 @ll_assessment_sequence int

DECLARE lc_assmt CURSOR LOCAL FAST_FORWARD FOR
	SELECT p.cpr_id, p.encounter_id, max(p.assessment_sequence)
	FROM p_Encounter_Assessment p
		INNER JOIN inserted i
		ON i.cpr_id = p.cpr_id
		AND i.encounter_id = p.encounter_id
	WHERE i.assessment_sequence IS NULL
	GROUP BY p.cpr_id, p.encounter_id

OPEN lc_assmt

FETCH lc_assmt INTO @ls_cpr_id, @ll_encouter_id, @ll_assessment_sequence
WHILE @@FETCH_STATUS = 0
	BEGIN
	IF @ll_assessment_sequence IS NULL
		SET @ll_assessment_sequence = 1
	ELSE
		SET @ll_assessment_sequence = @ll_assessment_sequence + 1
	
	UPDATE p
	SET assessment_sequence = @ll_assessment_sequence
	FROM p_Encounter_Assessment p
		INNER JOIN inserted i
		ON i.cpr_id = p.cpr_id
		AND i.encounter_id = p.encounter_id
		AND i.problem_id = p.problem_id
	WHERE i.cpr_id = @ls_cpr_id
	AND i.encounter_id = @ll_encouter_id
	AND i.assessment_sequence IS NULL
	
	FETCH lc_assmt INTO @ls_cpr_id, @ll_encouter_id, @ll_assessment_sequence
	END

CLOSE lc_assmt
DEALLOCATE lc_assmt


