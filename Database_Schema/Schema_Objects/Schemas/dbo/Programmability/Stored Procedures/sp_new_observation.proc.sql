CREATE PROCEDURE sp_new_observation (
	@ps_collection_location_domain varchar(12) = 'NA',
	@ps_perform_location_domain varchar(12) = 'NA',
	@ps_collection_procedure_id varchar(24) = NULL,
	@ps_perform_procedure_id varchar(24) = NULL,
	@ps_description varchar(80),
	@ps_composite_flag char(1) = 'N',
	@ps_exclusive_flag char(1) = 'N',
	@ps_in_context_flag char(1) = 'N',
	@ps_location_pick_flag char(1) = 'N',
	@ps_location_bill_flag char(1) = 'N',
	@ps_observation_type varchar(24) = 'Subjective',
	@ps_default_view char(1) = NULL,
	@ps_display_style varchar(255) = NULL )
AS

DECLARE @ls_observation_id varchar(24)

EXECUTE sp_new_observation_record
	@ps_observation_id = @ls_observation_id OUTPUT,
	@ps_collection_location_domain = @ps_collection_location_domain,
	@ps_perform_location_domain = @ps_perform_location_domain,
	@ps_collection_procedure_id = @ps_collection_procedure_id,
	@ps_perform_procedure_id = @ps_perform_procedure_id,
	@ps_description = @ps_description,
	@ps_composite_flag = @ps_composite_flag,
	@ps_exclusive_flag = @ps_exclusive_flag,
	@ps_in_context_flag = @ps_in_context_flag,
	@ps_location_pick_flag = @ps_location_pick_flag,
	@ps_location_bill_flag = @ps_location_bill_flag,
	@ps_observation_type = @ps_observation_type,
	@ps_default_view = @ps_default_view,
	@ps_display_style = @ps_display_style,
	@pl_owner_id = NULL,
	@ps_owner_key = NULL

SELECT @ls_observation_id AS observation_id

