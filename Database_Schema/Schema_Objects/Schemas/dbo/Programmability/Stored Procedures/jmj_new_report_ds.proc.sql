CREATE PROCEDURE jmj_new_report_ds (
	@ps_description varchar(80) ,
	@ps_report_type varchar(24) ,
	@ps_report_category varchar(24) = NULL,
	@ps_component_id varchar(24) ,
	@ps_machine_component_id varchar(24) = NULL,
	@ps_created_by varchar(24) ,
	@pl_owner_id int = NULL ,
	@ps_status varchar(12) )
AS

DECLARE @ll_return int,
		@ls_report_id varchar(36)

EXECUTE @ll_return = jmj_new_report
		@ps_description = @ps_description,
		@ps_report_type = @ps_report_type,
		@ps_report_category = @ps_report_category,
		@ps_component_id = @ps_component_id,
		@ps_machine_component_id = @ps_machine_component_id,
		@ps_created_by = @ps_created_by,
		@pl_owner_id = @pl_owner_id,
		@ps_status = @ps_status,
		@ps_report_id = @ls_report_id OUTPUT

IF @ll_return <= 0
	RETURN @ll_return

SELECT report_id = @ls_report_id
FROM c_1_Record

RETURN @ll_return

