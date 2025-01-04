
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_duplicate_observation]
Print 'Drop Procedure [dbo].[sp_duplicate_observation]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_duplicate_observation]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_duplicate_observation]
GO

-- Create Procedure [dbo].[sp_duplicate_observation]
Print 'Create Procedure [dbo].[sp_duplicate_observation]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_duplicate_observation
	(
	@ps_observation_id varchar(24),
	@ps_new_description varchar(80),
	@ps_user_id varchar(24),
	@ps_new_observation_id varchar(24) OUTPUT
	)
AS

DECLARE	@ls_collection_location_domain varchar(12),
		@ls_perform_location_domain varchar(12),
		@ls_collection_procedure_id varchar(24),
		@ls_perform_procedure_id varchar(24),
		@ls_composite_flag char(1),
		@ls_exclusive_flag char(1),
		@ls_in_context_flag char(1),
		@ls_location_pick_flag char(1),
		@ls_location_bill_flag char(1),
		@ls_observation_type varchar(24),
		@ls_default_view char(1),
		@ls_display_style varchar(255),
		@ll_owner_id int,
		@ls_owner_key varchar(40)

SELECT @ls_collection_location_domain = collection_location_domain,
		@ls_perform_location_domain = perform_location_domain,
		@ls_collection_procedure_id = collection_procedure_id,
		@ls_perform_procedure_id = perform_procedure_id,
		@ls_composite_flag = composite_flag,
		@ls_exclusive_flag = exclusive_flag,
		@ls_in_context_flag = in_context_flag,
		@ls_location_pick_flag = location_pick_flag,
		@ls_location_bill_flag = location_bill_flag,
		@ls_observation_type = observation_type,
		@ls_default_view = default_view,
		@ls_display_style = display_style
FROM c_Observation
WHERE observation_id = @ps_observation_id

IF @ls_observation_type IS NULL
	BEGIN
	RAISERROR ('Observation does not exist (%s)',16,-1, @ps_observation_id)
	ROLLBACK TRANSACTION
	RETURN
	END

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

SET @ls_owner_key = NULL


EXECUTE sp_new_observation_record
	@ps_observation_id = @ps_new_observation_id OUTPUT,
	@ps_collection_location_domain = @ls_collection_location_domain,
	@ps_perform_location_domain = @ls_perform_location_domain,
	@ps_collection_procedure_id = @ls_collection_procedure_id,
	@ps_perform_procedure_id = @ls_perform_procedure_id,
	@ps_description = @ps_new_description,
	@ps_composite_flag = @ls_composite_flag,
	@ps_exclusive_flag = @ls_exclusive_flag,
	@ps_in_context_flag = @ls_in_context_flag,
	@ps_location_pick_flag = @ls_location_pick_flag,
	@ps_location_bill_flag = @ls_location_bill_flag,
	@ps_observation_type = @ls_observation_type,
	@ps_default_view = @ls_default_view,
	@ps_display_style = @ls_display_style,
	@pl_owner_id = @ll_owner_id,
	@ps_owner_key = @ls_owner_key

IF @ps_new_observation_id IS NULL
	BEGIN
	RAISERROR ('Error creating new observation (%s)',16,-1, @ps_new_description)
	ROLLBACK TRANSACTION
	RETURN
	END


-- Duplicate the results
DELETE FROM c_Observation_Result
WHERE observation_id = @ps_new_observation_id

INSERT INTO c_Observation_Result (
	observation_id,
	result_sequence,
	result_type,
	result_unit,
	result,
	result_amount_flag,
	print_result_flag,
	severity,
	abnormal_flag,
	specimen_type,
	specimen_amount,
	external_source,
	property_id,
	service,
	print_result_separator,
	unit_preference,
	display_mask,
	sort_sequence,
	status )
SELECT @ps_new_observation_id,
	result_sequence,
	result_type,
	result_unit,
	result,
	result_amount_flag,
	print_result_flag,
	severity,
	abnormal_flag,
	specimen_type,
	specimen_amount,
	external_source,
	property_id,
	service,
	print_result_separator,
	unit_preference,
	display_mask,
	sort_sequence,
	status 
FROM c_Observation_Result
WHERE observation_id = @ps_observation_id
AND status = 'OK'



-- Duplicate the treatment_types
INSERT INTO c_Observation_Treatment_Type (
	observation_id,
	treatment_type)
SELECT @ps_new_observation_id,
	treatment_type
FROM c_Observation_Treatment_Type
WHERE observation_id = @ps_observation_id


-- Duplicate the categories
INSERT INTO c_Observation_Observation_Cat (
	observation_id,
	treatment_type,
	observation_category_id)
SELECT @ps_new_observation_id,
	treatment_type,
	observation_category_id
FROM c_Observation_Observation_Cat
WHERE observation_id = @ps_observation_id

-- Duplicate Specialties
INSERT INTO c_Common_Observation (
	specialty_id,
	observation_id)
SELECT specialty_id,
	@ps_new_observation_id
FROM c_Common_Observation
WHERE observation_id = @ps_observation_id


-- We've copied the c_Observation record, now copy the 1st level tree records
INSERT INTO c_Observation_Tree (
	parent_observation_id ,
	child_observation_id ,
	age_range_id ,
	sex ,
	edit_service ,
	location ,
	result_sequence ,
	result_sequence_2 ,
	description ,
	followon_severity ,
	followon_observation_id ,
	observation_tag ,
	on_results_entered ,
	unit_preference ,
	sort_sequence ,
	last_updated ,
	updated_by )
SELECT @ps_new_observation_id ,
	child_observation_id ,
	age_range_id ,
	sex ,
	edit_service ,
	location ,
	result_sequence ,
	result_sequence_2 ,
	description ,
	followon_severity ,
	followon_observation_id ,
	observation_tag ,
	on_results_entered ,
	unit_preference ,
	sort_sequence ,
	dbo.get_client_datetime() ,
	@ps_user_id
FROM c_Observation_Tree
WHERE parent_observation_id = @ps_observation_id

GO
GRANT EXECUTE
	ON [dbo].[sp_duplicate_observation]
	TO [cprsystem]
GO

