CREATE FUNCTION fn_check_document_route_errors (
	@pl_patient_workplan_item_id int,
	@ps_ordered_for varchar(24),
	@ps_document_route varchar(24))

RETURNS @route_errors TABLE (
	error_id int NOT NULL,
	severity int NOT NULL,
	severity_text varchar(12) NOT NULL,
	error_text varchar(1024) NOT NULL,
	allow_override char(1) DEFAULT ('Y'))
AS

BEGIN


DECLARE @ls_context_object varchar(24),
		@ll_object_key int,
		@ls_purpose varchar(24),
		@ls_cpr_id varchar(12),
		@ls_dea_schedule varchar(6),
		@lr_dispense_amount real,
		@ls_dispense_unit varchar(12),
		@ls_purpose_context_object varchar(24)

SET @ls_context_object = dbo.fn_wp_item_context_object(@pl_patient_workplan_item_id)
SET @ll_object_key = dbo.fn_wp_item_object_key(@pl_patient_workplan_item_id)

SELECT @ls_cpr_id = cpr_id
FROM p_Patient_WP_Item_Attribute
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

SELECT @ls_purpose = CAST(value as varchar(24))
FROM p_Patient_WP_Item_Attribute
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
AND attribute_sequence = (SELECT MAX(attribute_sequence) FROM p_Patient_WP_Item_Attribute WHERE patient_workplan_item_id = @pl_patient_workplan_item_id AND attribute = 'purpose')

-- If there is a purpose, make sure it is consistent with the context object
IF @ls_purpose IS NOT NULL
	BEGIN
	SELECT @ls_purpose_context_object = context_object
	FROM c_Document_Purpose
	WHERE purpose = @ls_purpose
	
	IF @@ROWCOUNT = 0
		INSERT INTO @route_errors (
			error_id,
			severity,
			severity_text,
			error_text)
		VALUES (
			1001,
			3,
			dbo.fn_domain_item_description('ErrorSeverity', 3),
			'Invalid Purpose (' + @ls_purpose + ')')

	IF @ls_purpose_context_object <> @ls_context_object
		BEGIN
		INSERT INTO @route_errors (
			error_id,
			severity,
			severity_text,
			error_text)
		VALUES (
			1001,
			3,
			dbo.fn_domain_item_description('ErrorSeverity', 3),
			'Document Purpose (' + @ls_purpose + ') is not compatible with document context (' + @ls_context_object + ')')

		-- We won't even process if the purpose context object is wrong, so go ahead and exit here
		RETURN
		END
	END


--------------------------------------------------------------------------------
-- SureScripts checks
--------------------------------------------------------------------------------

IF @ps_document_route = 'SureScripts'
	BEGIN
	IF @ls_purpose IS NULL
		INSERT INTO @route_errors (
			error_id,
			severity,
			severity_text,
			error_text)
		VALUES (
			1001,
			3,
			dbo.fn_domain_item_description('ErrorSeverity', 3),
			'All documents sent via SureScripts must have a Purpose')

	IF @ls_purpose = 'NewRX'
		BEGIN
		SELECT @ls_dea_schedule = dd.dea_schedule,
				@lr_dispense_amount = t.dispense_amount,
				@ls_dispense_unit = t.dispense_unit
		FROM p_Treatment_Item t
			LEFT OUTER JOIN c_Drug_Definition dd
			ON t.drug_id = dd.drug_id
		WHERE cpr_id = @ls_cpr_id
		AND treatment_id = @ll_object_key

		IF dbo.fn_patient_object_progress_value(@ls_cpr_id, @ls_context_object, 'Instructions', @ll_object_key, 'Dosing Instructions') IS NULL
		  AND dbo.fn_patient_object_progress_value(@ls_cpr_id, @ls_context_object, 'Instructions', @ll_object_key, 'Patient Instructions') IS NULL
			INSERT INTO @route_errors (
				error_id,
				severity,
				severity_text,
				error_text)
			VALUES (
				1001,
				3,
				dbo.fn_domain_item_description('ErrorSeverity', 3),
				'This prescription does not have any dosing instructions')

		IF dbo.fn_patient_object_progress_value(@ls_cpr_id, @ls_context_object, 'Instructions', @ll_object_key, 'Admin Instructions') IS NULL
			INSERT INTO @route_errors (
				error_id,
				severity,
				severity_text,
				error_text)
			VALUES (
				1001,
				3,
				dbo.fn_domain_item_description('ErrorSeverity', 3),
				'This prescription does not have any administration instructions')

		IF @lr_dispense_amount IS NULL OR @ls_dispense_unit IS NULL
			INSERT INTO @route_errors (
				error_id,
				severity,
				severity_text,
				error_text)
			VALUES (
				1001,
				3,
				dbo.fn_domain_item_description('ErrorSeverity', 3),
				'This prescription does not have a dispense amount/unit specified')

		IF @ls_dea_schedule = 'I'
			INSERT INTO @route_errors (
				error_id,
				severity,
				severity_text,
				error_text,
				allow_override)
			VALUES (
				1001,
				3,
				dbo.fn_domain_item_description('ErrorSeverity', 3),
				'Schedule I Drugs may not be prescribed',
				'N')

		IF @ls_dea_schedule IN ('II', 'III', 'IV', 'V')
			INSERT INTO @route_errors (
				error_id,
				severity,
				severity_text,
				error_text,
				allow_override)
			VALUES (
				1001,
				3,
				dbo.fn_domain_item_description('ErrorSeverity', 3),
				'Prescriptions for Schedule II-V drugs may not be sent electronically.  The prescription must printed and signed by the provider.',
				'N')





		END
	END



RETURN

END

