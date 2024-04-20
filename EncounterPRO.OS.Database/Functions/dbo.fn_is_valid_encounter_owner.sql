CREATE FUNCTION fn_is_valid_encounter_owner (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int	)

RETURNS int

AS

BEGIN

DECLARE	@ls_check_license varchar(255),
		@ll_user_license_level int,
		@ls_bill_flag char(1),
		@ls_attending_doctor varchar(24),
		@ls_supervising_doctor varchar(24),
		@ll_provider_user_license_level int

SET @ll_provider_user_license_level = 5427823

SET @ls_check_license = dbo.fn_get_preference('SYSTEM', 'Workflow Model', NULL, NULL)
IF @ls_check_license IS NULL OR @ls_check_license <> 'Standard'
	RETURN 1

SELECT @ls_bill_flag = bill_flag,
		@ls_attending_doctor = attending_doctor,
		@ls_supervising_doctor = supervising_doctor
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

IF @@ROWCOUNT <> 1
	RETURN -1

-- If the owner is still a role, then we'll check later
IF LEFT(@ls_attending_doctor, 1) <> '!' AND @ls_bill_flag = 'Y'
	BEGIN
	SET @ll_user_license_level = dbo.fn_user_license_level(@ls_attending_doctor)
	IF @ll_user_license_level <> @ll_provider_user_license_level
		BEGIN
		-- The owner couldn't own the encounter so check the supervisor
		IF @ls_supervising_doctor IS NULL
			BEGIN
			-- If the encounter supervisor is null then check the owner's supervisor
			SELECT @ls_supervising_doctor = supervisor_user_id
			FROM c_User
			WHERE user_id = @ls_attending_doctor
			IF @ls_supervising_doctor IS NULL
				RETURN -1
			ELSE
				BEGIN
				-- If the owner's supervisor is not null then check the owner's supervisor
				SET @ll_user_license_level = dbo.fn_user_license_level(@ls_supervising_doctor)
				IF @ll_user_license_level <> @ll_provider_user_license_level
					RETURN -1
				END
			END
		ELSE
			BEGIN
			SET @ll_user_license_level = dbo.fn_user_license_level(@ls_supervising_doctor)
			IF @ll_user_license_level <> @ll_provider_user_license_level
				RETURN -1
			END
		END
	END

RETURN 1

END


GO
GRANT EXECUTE ON [dbo].[fn_is_valid_encounter_owner] TO [cprsystem]
GO
