
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_Order_Workplan_Treatment]
Print 'Drop Procedure [dbo].[sp_Order_Workplan_Treatment]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Order_Workplan_Treatment]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Order_Workplan_Treatment]
GO

-- Create Procedure [dbo].[sp_Order_Workplan_Treatment]
Print 'Create Procedure [dbo].[sp_Order_Workplan_Treatment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_Order_Workplan_Treatment
	(
	@ps_cpr_id varchar(12),
	@pl_patient_workplan_id int,
	@pl_patient_workplan_item_id int,
	@ps_treatment_type varchar(24),
	@pl_encounter_id int,
	@ps_description varchar(80) = NULL,
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24) = NULL,
	@ps_created_by varchar(24),
	@pl_treatment_id int OUTPUT
	)
AS

DECLARE @ll_ordered_patient_workplan_id int,
	@ll_followup_patient_workplan_id int,
	@ls_attribute varchar(64),
	@ls_value varchar(255),
	@lr_dispense_amount real,
	@lr_office_dispense_amount real,
	@ls_dispense_unit varchar(12),
	@lr_duration_amount real,
	@ls_duration_prn varchar(32),
	@ls_duration_unit varchar(16),
	@ls_administer_frequency varchar(12),
	@ls_brand_name_required varchar(1),
	@lr_refills real,
	@ls_observation_id varchar(24),
	@ls_send_out_flag char(1),
	@ll_material_id int,
	@ls_treatment_mode varchar(24),
	@ls_procedure_id varchar(24),
	@ls_treatment_goal varchar(80),
	@ls_specialty_id varchar(24),
	@ls_patient_instructions varchar(255),
	@ls_pharmacist_instructions varchar(255),
	@ls_attach_flag varchar(1),
	@ls_referral_question varchar(12),
	@ls_referral_question_assmnt_id varchar(24),
	@ls_composite_flag char(1),
	@ll_ordered_workplan_id int ,
	@ll_followup_workplan_id int ,
	@ls_treatment_description varchar(80),
	@ldt_expiration_dt datetime,
	@ls_wp_item_description varchar(80),
	@ls_observation_description varchar(80),
	@ls_location varchar(24),
	@ls_maker_id varchar(24),
	@ls_lot_number varchar(24),
	@ls_treatment_office_id varchar(4),
	@ls_collection_procedure_id varchar(24),
	@ls_perform_procedure_id varchar(24),
	@ls_encounter_status varchar(8),
	@ldt_begin_date datetime,
	@ldt_encounter_date datetime,
	@ll_existing_treatment_id int,
	@ls_progress_value varchar(40)

DECLARE lc_treatment_atts CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
	SELECT attribute, value
	FROM p_Patient_WP_Item_Attribute
	WHERE cpr_id = @ps_cpr_id
	AND patient_workplan_id = @pl_patient_workplan_id
	AND patient_workplan_item_id = @pl_patient_workplan_item_id

-- Initialize p_Treatment_Item fields
SET	@lr_dispense_amount = NULL
SET	@lr_office_dispense_amount = NULL
SET	@ls_dispense_unit = NULL
SET	@lr_duration_amount = NULL
SET	@ls_duration_prn = NULL
SET	@ls_duration_unit = NULL
SET	@ls_administer_frequency = NULL
SET	@ls_brand_name_required = NULL
SET	@lr_refills = NULL
SET	@ls_observation_id = NULL
SET	@ls_send_out_flag = NULL
SET	@ll_material_id = NULL
SET	@ls_treatment_mode = NULL
SET	@ls_procedure_id = NULL
SET	@ls_treatment_goal = NULL
SET	@ls_specialty_id = NULL
SET	@ls_patient_instructions = NULL
SET	@ls_pharmacist_instructions = NULL
SET	@ls_attach_flag = NULL
SET	@ls_referral_question = NULL
SET	@ls_referral_question_assmnt_id = NULL
SET	@ls_treatment_description = NULL
SET	@ldt_expiration_dt = NULL
SET	@ls_observation_description = NULL
SET	@ls_location = NULL
SET	@ls_maker_id = NULL
SET	@ls_lot_number = NULL
SET	@ls_treatment_office_id = NULL

SELECT @ls_wp_item_description = description,
	@ll_ordered_workplan_id = ordered_workplan_id,
	@ll_followup_workplan_id = followup_workplan_id,
	@ll_existing_treatment_id = treatment_id
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

OPEN lc_treatment_atts

FETCH NEXT FROM lc_treatment_atts INTO @ls_attribute, @ls_value
WHILE (@@fetch_status<>-1)
	BEGIN
	-- Substitute the value if necessary
	SET @ls_value = dbo.fn_attribute_value_substitute(@ls_value, @ps_created_by)

	-- Map the attributes into p_Treatment_Item columns
	SET @lr_dispense_amount = CASE @ls_attribute WHEN 'dispense_amount' THEN CONVERT(real, @ls_value) ELSE @lr_dispense_amount END
	SET	@lr_office_dispense_amount = CASE @ls_attribute WHEN 'office_dispense_amount' THEN CONVERT(real, @ls_value) ELSE @lr_office_dispense_amount END
	SET	@ls_dispense_unit = CASE @ls_attribute WHEN 'dispense_unit' THEN @ls_value ELSE @ls_dispense_unit END
	SET	@lr_duration_amount = CASE @ls_attribute WHEN 'duration_amount' THEN CONVERT(real, @ls_value) ELSE @lr_duration_amount END
	SET	@ls_duration_prn = CASE @ls_attribute WHEN 'duration_prn' THEN @ls_value ELSE @ls_duration_prn END
	SET	@ls_duration_unit = CASE @ls_attribute WHEN 'duration_unit' THEN @ls_value ELSE @ls_duration_unit END
	SET	@ls_administer_frequency = CASE @ls_attribute WHEN 'administer_frequency' THEN @ls_value ELSE @ls_administer_frequency END
	SET	@ls_brand_name_required = CASE @ls_attribute WHEN 'brand_name_required' THEN @ls_value ELSE @ls_brand_name_required END
	SET	@lr_refills = CASE @ls_attribute WHEN 'refills' THEN CONVERT(real, @ls_value) ELSE @lr_refills END
	SET	@ls_observation_id = CASE @ls_attribute WHEN 'observation_id' THEN @ls_value ELSE @ls_observation_id END
	SET	@ls_send_out_flag = CASE @ls_attribute WHEN 'send_out_flag' THEN @ls_value ELSE @ls_send_out_flag END
	SET	@ll_material_id = CASE @ls_attribute WHEN 'material_id' THEN CONVERT(int, @ls_value) ELSE @ll_material_id END
	SET	@ls_treatment_mode = CASE @ls_attribute WHEN 'treatment_mode' THEN @ls_value ELSE @ls_treatment_mode END
	SET	@ls_procedure_id = CASE @ls_attribute WHEN 'procedure_id' THEN @ls_value ELSE @ls_procedure_id END
	SET	@ls_treatment_goal = CASE @ls_attribute WHEN 'treatment_goal' THEN @ls_value ELSE @ls_treatment_goal END
	SET	@ls_specialty_id = CASE @ls_attribute WHEN 'specialty_id' THEN @ls_value ELSE @ls_specialty_id END
	SET	@ls_patient_instructions = CASE @ls_attribute WHEN 'patient_instructions' THEN @ls_value ELSE @ls_patient_instructions END
	SET	@ls_pharmacist_instructions = CASE @ls_attribute WHEN 'pharmacist_instructions' THEN @ls_value ELSE @ls_pharmacist_instructions END
	SET	@ls_attach_flag = CASE @ls_attribute WHEN 'attach_flag' THEN @ls_value ELSE @ls_attach_flag END
	SET	@ls_referral_question = CASE @ls_attribute WHEN 'referral_question' THEN @ls_value ELSE @ls_referral_question END
	SET	@ls_referral_question_assmnt_id = CASE @ls_attribute WHEN 'referral_question_assmnt_id' THEN @ls_value ELSE @ls_referral_question_assmnt_id END
	SET	@ls_location = CASE @ls_attribute WHEN 'location' THEN @ls_value ELSE @ls_location END
	SET	@ls_treatment_description = CASE @ls_attribute WHEN 'treatment_description' THEN @ls_value ELSE @ls_treatment_description END
	SET	@ls_maker_id = CASE @ls_attribute WHEN 'maker_id' THEN @ls_value ELSE @ls_maker_id END
	SET	@ls_lot_number = CASE @ls_attribute WHEN 'lot_number' THEN @ls_value ELSE @ls_lot_number END
	SET	@ls_treatment_office_id = CASE @ls_attribute WHEN 'treatment_office_id' THEN @ls_value ELSE @ls_treatment_office_id END
	SET	@ldt_expiration_dt = CASE @ls_attribute WHEN 'expiration_dt' THEN CONVERT(datetime,@ls_value) ELSE @ldt_expiration_dt END

	FETCH NEXT FROM lc_treatment_atts INTO @ls_attribute, @ls_value
	END

DEALLOCATE lc_treatment_atts

-- If we have an observation_id, then get the description and composite flag
IF @ls_observation_id IS NOT NULL
	BEGIN
	SELECT @ls_composite_flag = composite_flag,
		@ls_observation_description = description
	FROM c_Observation
	WHERE observation_id = @ls_observation_id
	IF @@rowcount <> 1
		BEGIN
		RAISERROR ('Observation not in c_observation table (%s)',16,-1, @ls_observation_id)
		ROLLBACK TRANSACTION
		RETURN
		END
	END

-- Now determine the treatment_description
SET @ls_treatment_description = COALESCE(@ls_treatment_description, @ls_observation_description, @ps_description, @ls_wp_item_description)

SELECT @ls_encounter_status = encounter_status,
		@ldt_encounter_date = encounter_date
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

IF @ls_encounter_status = 'OPEN'
	BEGIN
	IF day(@ldt_encounter_date) = day(dbo.get_client_datetime()) AND month(@ldt_encounter_date) = month(dbo.get_client_datetime()) AND year(@ldt_encounter_date) = year(dbo.get_client_datetime())
		SET @ldt_begin_date = dbo.get_client_datetime()
	ELSE
		SET @ldt_begin_date = @ldt_encounter_date	
	END
ELSE
	SET @ldt_begin_date = dbo.get_client_datetime()

-- See if the treatment already exists
IF @ll_existing_treatment_id > 0
	BEGIN
	SET @pl_treatment_id = @ll_existing_treatment_id
	END
ELSE
	BEGIN
	INSERT INTO p_Treatment_Item (
		cpr_id,
		open_encounter_id,
		treatment_type,
		ordered_by,
		created_by,
		begin_date,
		dispense_amount,
		office_dispense_amount,
		dispense_unit,
		duration_amount,
		duration_prn,
		duration_unit,
		administer_frequency,
		brand_name_required,
		refills,
		send_out_flag,
		material_id,
		treatment_mode,
		procedure_id,
		observation_id,
		treatment_description,
		treatment_goal,
		specialty_id,
		attach_flag,
		location,
		maker_id,
		lot_number,
		expiration_date,
		office_id,
		referral_question,
		referral_question_assmnt_id )
	VALUES (
		@ps_cpr_id,
		@pl_encounter_id,
		@ps_treatment_type,
		@ps_ordered_by,
		@ps_created_by,
		@ldt_begin_date,
		@lr_dispense_amount,
		@lr_office_dispense_amount,
		@ls_dispense_unit,
		@lr_duration_amount,
		@ls_duration_prn,
		@ls_duration_unit,
		@ls_administer_frequency,
		@ls_brand_name_required,
		@lr_refills,
		@ls_send_out_flag,
		@ll_material_id,
		@ls_treatment_mode,
		@ls_procedure_id,
		@ls_observation_id,
		@ls_treatment_description,
		@ls_treatment_goal,
		@ls_specialty_id,
		@ls_attach_flag,
		@ls_location,
		@ls_maker_id,
		@ls_lot_number,
		@ldt_expiration_dt,
		@ls_treatment_office_id,
		@ls_referral_question,
		@ls_referral_question_assmnt_id )

	SET @pl_treatment_id = SCOPE_IDENTITY()

	-- Add the "Created" progress record
	EXECUTE sp_set_treatment_progress
		@ps_cpr_id = @ps_cpr_id,
		@pl_treatment_id = @pl_treatment_id,
		@pl_encounter_id = @pl_encounter_id,
		@ps_progress_type = 'Created',
		@ps_user_id = @ps_ordered_by,
		@ps_created_by = @ps_created_by 

	IF LEN(@ls_patient_instructions) > 0
		EXECUTE sp_set_treatment_progress
			@ps_cpr_id = @ps_cpr_id,
			@pl_treatment_id = @pl_treatment_id,
			@pl_encounter_id = @pl_encounter_id,
			@ps_progress_type = 'INSTRUCTIONS',
			@ps_progress = @ls_patient_instructions,
			@ps_user_id = @ps_ordered_by,
			@ps_created_by = @ps_created_by

	IF LEN(@ls_pharmacist_instructions) > 0
		EXECUTE sp_set_treatment_progress
			@ps_cpr_id = @ps_cpr_id,
			@pl_treatment_id = @pl_treatment_id,
			@pl_encounter_id = @pl_encounter_id,
			@ps_progress_type = 'PHARMACISTINSTRUCTIONS',
			@ps_progress = @ls_pharmacist_instructions,
			@ps_user_id = @ps_ordered_by,
			@ps_created_by = @ps_created_by
	END

-- Which encounter was this treatment dispatched in?
SELECT @ls_treatment_mode = treatment_mode
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id

-- Set the billing if the encounter is open
IF @ls_encounter_status = 'OPEN'
	EXECUTE sp_add_treatment_charges
			@ps_cpr_id = @ps_cpr_id,
			@pl_encounter_id = @pl_encounter_id,
			@pl_treatment_id = @pl_treatment_id,
			@ps_created_by = @ps_created_by

-- Now order the workplan associated with this treatment
EXECUTE sp_Order_Treatment_Workplans
	@ps_cpr_id = @ps_cpr_id,
	@pl_treatment_id = @pl_treatment_id,
	@ps_treatment_type = @ps_treatment_type,
	@ps_treatment_mode = @ls_treatment_mode,
	@pl_ordered_workplan_id = @ll_ordered_workplan_id,
	@pl_followup_workplan_id = @ll_followup_workplan_id,
	@pl_encounter_id = @pl_encounter_id,
	@ps_description = @ls_treatment_description,
	@ps_ordered_by = @ps_ordered_by,
	@ps_ordered_for = @ps_ordered_for,
	@pl_parent_patient_workplan_item_id = @pl_patient_workplan_item_id,
	@ps_created_by = @ps_created_by,
	@pl_ordered_patient_workplan_id = @ll_ordered_patient_workplan_id OUTPUT,
	@pl_followup_patient_workplan_id = @ll_ordered_patient_workplan_id OUTPUT


GO
GRANT EXECUTE
	ON [dbo].[sp_Order_Workplan_Treatment]
	TO [cprsystem]
GO

