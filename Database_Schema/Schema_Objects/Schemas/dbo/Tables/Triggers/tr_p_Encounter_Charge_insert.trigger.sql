CREATE TRIGGER tr_p_Encounter_Charge_insert ON dbo.p_Encounter_Charge
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_cpr_id varchar(12),
		@ll_encounter_id int,
		@ll_encounter_charge_id int,
		@ll_sort_sequence int

DECLARE lc_sort CURSOR LOCAL FAST_FORWARD FOR
	SELECT cpr_id, encounter_id, encounter_charge_id
	FROM inserted
	WHERE sort_sequence IS NULL

OPEN lc_sort

FETCH lc_sort INTO @ls_cpr_id, @ll_encounter_id, @ll_encounter_charge_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	SELECT @ll_sort_sequence = MAX(sort_sequence)
	FROM dbo.p_Encounter_Charge
	WHERE cpr_id = @ls_cpr_id
	AND encounter_id = @ll_encounter_id

	IF @ll_sort_sequence IS NULL
		SET @ll_sort_sequence = 1

	UPDATE dbo.p_Encounter_Charge
	SET sort_sequence = @ll_sort_sequence
	WHERE cpr_id = @ls_cpr_id
	AND encounter_id = @ll_encounter_id
	AND encounter_charge_id = @ll_encounter_charge_id

	FETCH lc_sort INTO @ls_cpr_id, @ll_encounter_id, @ll_encounter_charge_id
	END

CLOSE lc_sort
DEALLOCATE lc_sort

