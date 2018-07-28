CREATE PROCEDURE jmj_new_datafile (
	@ps_description varchar(80) ,
	@ps_context_object varchar(24) ,
	@ps_component_id varchar(24) ,
	@ps_created_by varchar(24) ,
	@ps_status varchar(12) ,
	@ps_long_description text = NULL ,
	@ps_report_id varchar(40) OUTPUT )
AS

DECLARE @ll_return int

EXECUTE @ll_return = jmj_new_document_config_object
	@ps_config_object_type = 'Datafile',
	@ps_description = @ps_description,
	@ps_context_object = @ps_context_object,
	@ps_component_id = @ps_component_id,
	@ps_created_by = @ps_created_by,
	@ps_status = @ps_status,
	@ps_long_description = @ps_long_description,
	@ps_report_id = @ps_report_id OUTPUT


RETURN @ll_return

