CREATE PROCEDURE xml_lookup_code (
	@ps_epro_domain varchar(64)  ,
	@ps_epro_id varchar(64) ,
	@ps_epro_description varchar(80) ,
	@pl_owner_id int ,
	@ps_code_domain varchar(40) ,
	@ps_code_version varchar(40) = NULL,
	@ps_created_by varchar(24) ,
	@ps_code varchar(80) OUTPUT
	)
AS

DECLARE @ls_code_description varchar(80),
		@ll_code_id int

EXECUTE @ll_code_id = xml_lookup_code2
	@ps_epro_domain = @ps_epro_domain,
	@ps_epro_id = @ps_epro_id,
	@ps_epro_description = @ps_epro_description,
	@pl_owner_id = @pl_owner_id,
	@ps_code_domain = @ps_code_domain,
	@ps_code_version = @ps_code_version,
	@ps_created_by = @ps_created_by,
	@ps_code = @ps_code OUTPUT,
	@ps_code_description = @ls_code_description OUTPUT


RETURN @ll_code_id

