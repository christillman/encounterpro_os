CREATE TRIGGER b_Appointment_Type_insert_update ON b_Appointment_Type
FOR
	 INSERT
	,UPDATE
AS

DECLARE @ll_pms_owner_id int,
		@ls_IDDomain varchar(40), 
		@ls_IDValue varchar(80),
		@ls_encounter_type varchar(24),
		@ls_created_by varchar(24),
		@ls_appointment_text varchar(50)


IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(encounter_type)
	BEGIN
	SET @ls_created_by = COALESCE(dbo.fn_current_epro_user(), '#SYSTEM')

	SET @ls_IDDomain = 'encountertype'

	SELECT 	@ll_pms_owner_id = send_via_addressee
	FROM c_Document_Route
	WHERE document_route = dbo.fn_get_global_preference('Preferences', 'default_billing_system')

	IF @@ROWCOUNT = 1
		BEGIN
		DECLARE lc_mappings CURSOR LOCAL FAST_FORWARD FOR
			SELECT i.appointment_type, i.appointment_text, i.encounter_type
			FROM inserted i
			WHERE i.encounter_type IS NOT NULL

		OPEN lc_mappings

		FETCH lc_mappings INTO @ls_IDValue, @ls_appointment_text, @ls_encounter_type
		WHILE @@FETCH_STATUS = 0
			BEGIN
			
			EXECUTE xml_add_code	@pl_owner_id = @ll_pms_owner_id ,
									@ps_code_domain = @ls_IDDomain ,
									@ps_code_version = NULL ,
									@ps_code = @ls_IDValue ,
									@ps_epro_domain = 'encounter_type' ,
									@ps_epro_id = @ls_encounter_type ,
									@ps_created_by = @ls_created_by ,
									@pi_replace_flag = 1,
									@ps_description = @ls_appointment_text

			FETCH lc_mappings INTO @ls_IDValue, @ls_appointment_text, @ls_encounter_type
			END

		END

	END



