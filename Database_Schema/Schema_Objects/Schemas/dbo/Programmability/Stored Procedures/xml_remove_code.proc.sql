CREATE PROCEDURE xml_remove_code (
	@pl_owner_id int ,
	@ps_code_domain varchar(40) ,
	@ps_code_version varchar(40) ,
	@ps_code varchar(80) ,
	@ps_epro_domain varchar(64)  ,
	@ps_epro_id varchar(24) ,
	@ps_user_id varchar(24) ,
	@pi_remove_all bit = 0)
AS
-- This procedure removes a record from c_XML_Code

-- If the @pi_remove_all bit is set, then we ignore @ps_epro_id and remove all mappings
-- for the given code_domain and epro_domain

IF @pi_remove_all = 1
	BEGIN
	DELETE FROM c_XML_Code
	WHERE owner_id = @pl_owner_id
	AND code_domain = @ps_code_domain
	AND ISNULL(code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND code = @ps_code
	AND epro_domain = @ps_epro_domain
	END
ELSE
	BEGIN
	DELETE FROM c_XML_Code
	WHERE owner_id = @pl_owner_id
	AND code_domain = @ps_code_domain
	AND ISNULL(code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND code = @ps_code
	AND epro_domain = @ps_epro_domain
	AND epro_id = @ps_epro_id
	
	END

