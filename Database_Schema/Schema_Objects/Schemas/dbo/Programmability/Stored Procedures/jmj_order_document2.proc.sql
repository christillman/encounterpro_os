CREATE PROCEDURE jmj_order_document2
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int = NULL,
	@ps_context_object varchar(24),
	@pl_object_key int = NULL,
	@ps_report_id varchar(40),
	@ps_purpose varchar(40),
	@ps_dispatch_method varchar(24) = NULL,
	@ps_ordered_for varchar(24),
	@pl_patient_workplan_id int = 0,
	@ps_description varchar(80) = NULL,
	@ps_ordered_by varchar(24),
	@ps_created_by varchar(24),
	@pl_material_id int = NULL,
	@ps_create_from varchar(12) = NULL,
	@ps_send_from varchar(12) = NULL
	)
AS

-- This procedure replaces jmj_order_document because jmj_order_document did not accept [purpose] as a param.
-- Purpose is essential for assiging the default document_route

DECLARE @li_count smallint,
	@ls_object_key varchar(12),
	@ll_patient_workplan_item_id int,
	@ls_object_key_attribute varchar(24),
	@ls_material_id varchar(12),
	@ll_error int,
	@ll_rowcount int,
	@ll_last_document_id int,
	@ls_default_address_attribute varchar(64),
	@ls_default_address_value varchar(255),
	@ls_initial_status varchar(12)

IF @ps_purpose IS NULL
	SELECT @ps_purpose = a.value
	FROM c_Report_Attribute a
	WHERE a.report_id = @ps_report_id
	AND a.attribute_sequence = (SELECT max(x.attribute_sequence)
								FROM c_Report_Attribute x
								WHERE x.report_id = @ps_report_id
								AND x.attribute = 'Purpose'
								AND x.component_attribute = 'N')

IF @ps_purpose IS NULL
	BEGIN
	RAISERROR ('Document must have a purpose',16,-1)
	RETURN -1
	END

-- Get the default recipient and address
SELECT @ps_ordered_for = ordered_for,
		@ps_dispatch_method = document_route,
		@ls_default_address_attribute = address_attribute,
		@ls_default_address_value = address_value
FROM dbo.fn_document_default_recipient(@ps_cpr_id ,
										@pl_encounter_id ,
										@ps_context_object ,
										@pl_object_key ,
										@ps_report_id ,
										@ps_purpose ,
										@ps_ordered_by ,
										@ps_ordered_for ,
										@ps_dispatch_method)


IF @ps_description IS NULL
	BEGIN
	SET @ps_description = dbo.fn_patient_object_description(@ps_cpr_id, @ps_context_object, @pl_object_key)
	
	-- If the description contains a CR, truncate there
	IF CHARINDEX(CHAR(13), @ps_description) > 0
		SET @ps_description = LEFT(@ps_description, CHARINDEX(CHAR(13), @ps_description) - 1)
	END

SET @ls_initial_status = 'Ordered'

INSERT INTO p_Patient_WP_Item
	(
	patient_workplan_id,
	workplan_id,
	cpr_id,
	encounter_id,
	item_type,
	description,
	dispatch_method,
	ordered_by,
	ordered_for,
	status,
	created_by,
	context_object)
VALUES	(
	@pl_patient_workplan_id,
	0,
	@ps_cpr_id,
	@pl_encounter_id,
	'Document',
	@ps_description,
	@ps_dispatch_method,
	@ps_ordered_by,
	@ps_ordered_for,
	@ls_initial_status,
	@ps_created_by ,
	@ps_context_object)
IF @@rowcount <> 1
	BEGIN
	RAISERROR ('Could not insert record into p_Patient_WP_Item',16,-1)
	RETURN -1
	END

SELECT @ll_patient_workplan_item_id = @@identity

IF @pl_material_id IS NOT NULL
	BEGIN
	SET @ls_material_id = CAST(@pl_material_id AS varchar(12))
	EXEC sp_add_workplan_item_attribute
		@ps_cpr_id = @ps_cpr_id,
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
		@ps_attribute = 'material_id',
		@ps_value = @ls_material_id,
		@ps_created_by = @ps_created_by
	END

IF LEN(@ps_create_from) > 0
	EXEC sp_add_workplan_item_attribute
		@ps_cpr_id = @ps_cpr_id,
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
		@ps_attribute = 'create_from',
		@ps_value = @ps_create_from,
		@ps_created_by = @ps_created_by

IF LEN(@ps_send_from) > 0
	EXEC sp_add_workplan_item_attribute
		@ps_cpr_id = @ps_cpr_id,
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
		@ps_attribute = 'send_from',
		@ps_value = @ps_send_from,
		@ps_created_by = @ps_created_by

IF @ps_report_id IS NOT NULL
	EXEC sp_add_workplan_item_attribute
		@ps_cpr_id = @ps_cpr_id,
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
		@ps_attribute = 'report_id',
		@ps_value = @ps_report_id,
		@ps_created_by = @ps_created_by

EXEC sp_add_workplan_item_attribute
	@ps_cpr_id = @ps_cpr_id,
	@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
	@ps_attribute = 'context_object',
	@ps_value = @ps_context_object,
	@ps_created_by = @ps_created_by

EXEC sp_add_workplan_item_attribute
	@ps_cpr_id = @ps_cpr_id,
	@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
	@ps_attribute = 'purpose',
	@ps_value = @ps_purpose,
	@ps_created_by = @ps_created_by

IF @pl_object_key IS NOT NULL
	BEGIN
	SET @ls_object_key_attribute = CASE @ps_context_object WHEN 'Assessment' THEN 'problem_id'
															WHEN 'observation' THEN 'observation_sequence'
															ELSE @ps_context_object + '_id' END
	SET @ls_object_key = CAST(@pl_object_key AS varchar(12))
	EXEC sp_add_workplan_item_attribute
		@ps_cpr_id = @ps_cpr_id,
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
		@ps_attribute = @ls_object_key_attribute,
		@ps_value = @ls_object_key,
		@ps_created_by = @ps_created_by
	END

IF @ls_default_address_attribute IS NOT NULL AND @ls_default_address_value IS NOT NULL
	EXEC sp_add_workplan_item_attribute
		@ps_cpr_id = @ps_cpr_id,
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
		@ps_attribute = @ls_default_address_attribute,
		@ps_value = @ls_default_address_value,
		@ps_created_by = @ps_created_by


RETURN @ll_patient_workplan_item_id

