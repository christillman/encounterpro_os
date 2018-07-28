CREATE FUNCTION fn_document_default_recipient (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_context_object varchar(50),
	@pl_object_key int,
	@ps_report_id varchar(40),
	@ps_purpose varchar(40),
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24) = NULL,
	@ps_document_route varchar(24) = NULL )

RETURNS @defaults TABLE (
	ordered_for varchar(24) NULL,
	document_route varchar(24) NULL,
	address_attribute varchar(64) NULL,
	address_value varchar(255) NULL)


AS
BEGIN

DECLARE @ll_status int,
		@ll_sum int,
		@ll_last_document_id int,
		@ll_error int,
		@ll_rowcount int,
		@ls_default_ordered_for varchar(24),
		@ls_default_document_route varchar(24),
		@ls_default_address_attribute varchar(64),
		@ls_default_address_value varchar(255),
		@ls_communication_type varchar(24),
		@ls_recipient_actor_class varchar(24),
		@ls_office_id varchar(4),
		@ll_computer_id int,
		@ls_room_id varchar(12)

SET @ls_default_ordered_for = @ps_ordered_for
SET @ls_default_document_route = @ps_document_route

INSERT INTO @defaults (
	ordered_for,
	document_route,
	address_attribute,
	address_value)
VALUES (
	@ls_default_ordered_for,
	@ls_default_document_route,
	NULL,
	NULL)

DECLARE @care_team TABLE (
	user_id varchar(24) NOT NULL,
	actor_class varchar(24) NULL,
	primary_actor bit NOT NULL)

SELECT @ls_recipient_actor_class = actor_class
FROM c_User
WHERE user_id = @ps_ordered_for

-------------------------------------------------------------------------------------
-- Default ordered_for
-------------------------------------------------------------------------------------
IF @ls_default_ordered_for IS NULL
	IF @ps_purpose LIKE '%REPORT'
		BEGIN
		SET @ls_default_ordered_for = '#PATIENT'
		END
	ELSE
		BEGIN
		SET @ll_last_document_id = NULL
		-- First check for a previous document for this context object with this purpose
		SELECT @ll_last_document_id = max(i.patient_workplan_item_id)
		FROM p_Patient_WP_Item i WITH (NOLOCK)
			INNER JOIN p_Patient_WP_Item_Attribute a
			ON a.patient_workplan_item_id = i.patient_workplan_item_id
		WHERE 	i.cpr_id = @ps_cpr_id
		AND 	i.item_type = 'Document'
		AND i.status IN ('Sent', 'Completed')
		AND (i.encounter_id = @pl_object_key OR @ps_context_object <> 'Encounter')
		AND (i.treatment_id = @pl_object_key OR @ps_context_object <> 'Treatment')
		AND a.attribute = 'Purpose'
		AND a.value_short = @ps_purpose

		SELECT @ll_error = @@ERROR,
				@ll_rowcount = @@ROWCOUNT

		IF @ll_error <> 0
			RETURN

		IF @ll_last_document_id IS NOT NULL
			BEGIN
			SELECT @ls_default_ordered_for = ordered_for,
					@ls_default_document_route = dispatch_method -- If we get ordered_for from a previous document, then pick up the route too
			FROM p_Patient_WP_Item
			WHERE patient_workplan_item_id = @ll_last_document_id
			END

		-- If we still don't have a default, pick a recipient from the care team if there is a valid one
		IF @ls_default_ordered_for IS NULL
			BEGIN
			SELECT TOP 1 @ls_default_ordered_for = ct.user_id
			FROM dbo.fn_patient_care_team_list(@ps_cpr_id) ct
				INNER JOIN c_Actor_Class_Purpose ap
				ON ct.actor_class = ap.actor_class
			WHERE ap.purpose = @ps_purpose
			ORDER BY ct.primary_actor desc, ap.sort_sequence asc

			SELECT @ll_error = @@ERROR,
					@ll_rowcount = @@ROWCOUNT

			IF @ll_error <> 0
				RETURN
			END
		END

-- If we get here and we still don't have a default ordered_for, then default to the ordered_by
IF @ls_default_ordered_for IS NULL
	SET @ls_default_ordered_for = @ps_ordered_by

UPDATE @defaults
SET ordered_for = @ls_default_ordered_for


-------------------------------------------------------------------------------------
-- Default document route
-------------------------------------------------------------------------------------
IF @ls_default_document_route IS NULL
	BEGIN
	SELECT TOP 1 @ls_default_document_route = document_route
	FROM dbo.fn_document_available_routes(@ps_ordered_by, @ls_default_ordered_for, @ps_purpose, @ps_cpr_id)
	WHERE is_valid = 1
	ORDER BY sort_sequence, document_route desc

	END

-- If we get here and we still don't have a default route, then use 'Printer'
IF @ls_default_document_route IS NULL
	SET @ls_default_document_route = 'Printer'

UPDATE @defaults
SET document_route = @ls_default_document_route



-------------------------------------------------------------------------------------
-- Default address attribute
-------------------------------------------------------------------------------------
IF @ls_default_address_attribute IS NULL
	BEGIN
	IF @ls_default_document_route = 'Printer'
		BEGIN
		-- The address attribute for a printer is 'Printer'
		SET @ls_default_address_attribute = 'Printer'
		END
	ELSE
		BEGIN
		-- Get the default communication value for this communication type.  If there isn't a communication type then we don't need one
		SELECT @ls_communication_type = communication_type
		FROM c_Document_Route
		WHERE document_route = @ls_default_document_route

		SELECT @ll_error = @@ERROR,
				@ll_rowcount = @@ROWCOUNT

		IF @ll_error <> 0
			RETURN

		IF @ll_rowcount = 0
			RETURN

		IF @ls_communication_type IS NULL
			RETURN

		SET @ls_default_address_attribute = @ls_communication_type
		END
	END

-- If we get here and we still don't have a default route, then just return
IF @ls_default_address_attribute IS NULL
	RETURN
ELSE
	UPDATE @defaults
	SET address_attribute = @ls_default_address_attribute



-------------------------------------------------------------------------------------
-- Default address value
-------------------------------------------------------------------------------------
IF @ls_default_address_value IS NULL
	BEGIN
	IF @ls_default_document_route = 'Printer'
		BEGIN
		-- First get the office, computer and room_id
		SELECT @ls_office_id = office_id,
				@ll_computer_id = computer_id
		FROM dbo.fn_current_epro_user_context()

		SELECT @ls_room_id = patient_location
		FROM p_Patient_Encounter
		WHERE cpr_id = @ps_cpr_id
		AND encounter_id = @pl_encounter_id

		-- Get the default printer
		SET @ls_default_address_value = dbo.fn_report_default_printer (@ps_report_id,
																		@ls_office_id,
																		@ll_computer_id,
																		@ls_room_id)

		END
	ELSE
		BEGIN
		IF @ls_recipient_actor_class = 'Patient'
			BEGIN
			SELECT TOP 1 @ls_default_address_value = COALESCE(progress_value, CAST(progress AS varchar(255)))
			FROM p_Patient_Progress
			WHERE cpr_id = @ps_cpr_id
			AND progress_type = 'Communication ' + @ls_default_address_attribute
			AND current_flag = 'Y'
			ORDER BY progress_key
			END
		ELSE IF @ls_communication_type IS NOT NULL
			BEGIN
			-- Get the first communication value for the route-specified communication_type
			-- Give preference to the communication_name that matched the route name, if any
			SELECT TOP 1 @ls_default_address_value = c.communication_value
			FROM c_User u
				INNER JOIN c_Actor_Communication c
				ON u.actor_id = c.actor_id
			WHERE u.user_id = @ls_default_ordered_for
			AND c.communication_type = @ls_communication_type
			AND c.status = 'OK'
			ORDER BY	CASE WHEN c.communication_name = @ls_default_document_route THEN 1 ELSE 2 END,
						c.sort_sequence,
						c.communication_name
			END
		END
	END
-- If we get here and we still don't have a default route, then just return
IF @ls_default_address_value IS NULL
	RETURN
ELSE
	UPDATE @defaults
	SET address_value = @ls_default_address_value


RETURN
END
