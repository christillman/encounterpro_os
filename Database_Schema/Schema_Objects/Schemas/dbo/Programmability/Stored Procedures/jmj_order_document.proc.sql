CREATE PROCEDURE jmj_order_document
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int = NULL,
	@ps_context_object varchar(24),
	@pl_object_key int = NULL,
	@ps_report_id varchar(40),
	@ps_dispatch_method varchar(24) = NULL,
	@ps_ordered_for varchar(24),
	@pl_patient_workplan_id int = 0,
	@ps_description varchar(80) = NULL,
	@ps_ordered_by varchar(24),
	@ps_created_by varchar(24),
	@pl_material_id int = NULL
	)
AS

-- This procedure is depricated.  Use jmj_order_document2 in order to provide a [purpose] when ordering a document.



DECLARE @li_count smallint,
	@ls_object_key varchar(12),
	@ll_patient_workplan_item_id int,
	@ls_object_key_attribute varchar(24),
	@ls_material_id varchar(12)

-- If the ordered_for is not supplied, then choose a default
IF @ps_ordered_for IS NULL
	BEGIN
	SET @ps_ordered_for = '#PATIENT'
	END

IF @ps_description IS NULL
	BEGIN
	SET @ps_description = dbo.fn_patient_object_description(@ps_cpr_id, @ps_context_object, @pl_object_key)
	
	-- If the description contains a CR, truncate there
	IF CHARINDEX(CHAR(13), @ps_description) > 0
		SET @ps_description = LEFT(@ps_description, CHARINDEX(CHAR(13), @ps_description) - 1)
	END

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
	'Ordered',
	@ps_created_by ,
	@ps_context_object)
IF @@rowcount <> 1
	BEGIN
	RAISERROR ('Could not insert record into p_Patient_WP_Item',16,-1)
	ROLLBACK TRANSACTION
	RETURN
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

RETURN @ll_patient_workplan_item_id

