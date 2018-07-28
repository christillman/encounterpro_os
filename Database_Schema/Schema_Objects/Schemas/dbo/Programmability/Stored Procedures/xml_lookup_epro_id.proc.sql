CREATE PROCEDURE xml_lookup_epro_id (
	@pl_owner_id int ,
	@ps_code_domain varchar(40) ,
	@ps_code_version varchar(40) = NULL,
	@ps_code varchar(80) ,
	@ps_code_description varchar(80) ,
	@ps_epro_domain varchar(64)  ,
	@ps_created_by varchar(24) ,
	@ps_epro_id varchar(64) OUTPUT )
AS

DECLARE @ls_epro_description varchar(80),
		@ll_code_id int

EXECUTE @ll_code_id = xml_lookup_epro_id2
	@pl_owner_id = @pl_owner_id,
	@ps_code_domain = @ps_code_domain,
	@ps_code_version = @ps_code_version,
	@ps_code = @ps_code,
	@ps_code_description = @ps_code_description,
	@ps_epro_domain = @ps_epro_domain,
	@ps_created_by = @ps_created_by,
	@ps_epro_id = @ps_epro_id OUTPUT,
	@ps_epro_description = @ls_epro_description OUTPUT

RETURN @ll_code_id

