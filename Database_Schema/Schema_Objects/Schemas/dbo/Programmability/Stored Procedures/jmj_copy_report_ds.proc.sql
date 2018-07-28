CREATE PROCEDURE jmj_copy_report_ds (
	@ps_copy_from_report_id varchar(40) ,
	@ps_new_description varchar(80) ,
	@ps_created_by varchar(24) )
AS

DECLARE @ll_return int ,
		@ls_report_id varchar(36) 

SET @ll_return = 1

EXECUTE @ll_return = jmj_copy_report
		@ps_copy_from_report_id = @ps_copy_from_report_id,
		@ps_new_description = @ps_new_description,
		@ps_created_by = @ps_created_by,
		@ps_report_id = @ls_report_id OUTPUT

IF @ll_return <= 0
	RETURN @ll_return

SELECT report_id = @ls_report_id
FROM c_1_Record

RETURN @ll_return

