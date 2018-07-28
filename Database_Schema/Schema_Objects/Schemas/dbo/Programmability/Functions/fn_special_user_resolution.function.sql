CREATE FUNCTION fn_special_user_resolution (
	@ps_ordered_for varchar(24),
	@ps_cpr_id varchar(12),
	@pl_encounter_id int)

RETURNS varchar(24)

AS
BEGIN
DECLARE @ls_user_id varchar(24),
		@ls_attending_doctor varchar(24),
		@ll_relation_sequence int

SET @ls_user_id = NULL

-- If it's not a special user, then just return the user
IF NOT EXISTS (SELECT 1 FROM c_User WHERE user_id = @ps_ordered_for AND actor_class = 'special')
	RETURN @ps_ordered_for

IF @ps_ordered_for = '#PATIENT_PROVIDER'
	BEGIN
	SELECT @ls_user_id = primary_provider_id
	FROM p_Patient
	WHERE cpr_id = @ps_cpr_id
	END
	
	
IF @ps_ordered_for = '#ENCOUNTER_OWNER'
	BEGIN
	SELECT @ls_user_id = attending_doctor
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	END


IF @ps_ordered_for = '#ENCOUNTER_SUPERVISOR'
	BEGIN
	SELECT @ls_user_id = supervising_doctor,
		@ls_attending_doctor = attending_doctor
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	
	IF @ls_user_id IS NULL
		BEGIN
		SELECT @ls_user_id = supervisor_user_id
		FROM c_User
		WHERE [user_id] = @ls_attending_doctor
		
		IF @ls_user_id IS NULL
			SET @ls_user_id = @ls_attending_doctor
		END
	END

IF @ps_ordered_for = '#PATIENT'
	BEGIN
	SET @ls_user_id = '##' + @ps_cpr_id
	END

IF @ps_ordered_for = '#PARENT'
	BEGIN
	SELECT @ll_relation_sequence = max(relation_sequence)
	FROM p_Patient_Relation
	WHERE cpr_id = @ps_cpr_id
	AND guardian_flag = 'Y'
	AND status = 'OK'
	
	IF @ll_relation_sequence IS NULL
		SET @ls_user_id = '##' + @ps_cpr_id
	ELSE
		SELECT @ls_user_id = '##' + relation_cpr_id
		FROM p_Patient_Relation
		WHERE cpr_id = @ps_cpr_id
		AND relation_sequence = @ll_relation_sequence
	END

IF @ps_ordered_for = '#REFERFROM'
	BEGIN
	SET @ls_user_id = dbo.fn_patient_object_property(@ps_cpr_id, 'Encounter', @pl_encounter_id, 'referring_provider_id')
	IF @ls_user_id IS NULL
		SELECT @ls_user_id = referring_provider_id
		FROM p_Patient
		WHERE cpr_id = @ps_cpr_id
	END

IF @ps_ordered_for = '#REFERTO'
	BEGIN
	SET @ls_user_id = dbo.fn_patient_object_property(@ps_cpr_id, 'Encounter', @pl_encounter_id, 'referred_to_provider_id')
	IF @ls_user_id IS NULL
		SET @ls_user_id = dbo.fn_patient_object_property(@ps_cpr_id, 'Patient', NULL, 'referred_to_provider_id')
	END


RETURN @ls_user_id 

END

