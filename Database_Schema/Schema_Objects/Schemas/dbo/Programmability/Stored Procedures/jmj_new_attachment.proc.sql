CREATE PROCEDURE jmj_new_attachment (
	@ps_description varchar(80),
	@ps_attachment_file varchar(128),
	@ps_extension varchar(24),
	@pl_owner_id int = NULL,
	@pl_box_id int = NULL,
	@pl_item_id int = NULL,
	@pl_interfaceserviceid int,
	@pl_transportsequence int,
	@pl_patient_workplan_item_id int,
	@ps_attached_by varchar(24),
	@ps_created_by varchar(24))
AS

DECLARE @ll_error int,
		@ll_rowcount int,
		@ll_attachment_id int

EXECUTE @ll_attachment_id = jmj_new_attachment2
	@ps_description = @ps_description,
	@ps_attachment_file = @ps_attachment_file,
	@ps_extension = @ps_extension,
	@pl_owner_id = @pl_owner_id,
	@pl_box_id = @pl_box_id,
	@pl_item_id = @pl_item_id,
	@pl_interfaceserviceid = @pl_interfaceserviceid,
	@pl_transportsequence = @pl_transportsequence,
	@pl_patient_workplan_item_id = @pl_patient_workplan_item_id,
	@ps_attached_by = @ps_attached_by,
	@ps_created_by = @ps_created_by

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1


RETURN @ll_attachment_id

