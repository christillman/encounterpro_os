CREATE PROCEDURE xml_remove_mapping (
	@pl_owner_id int ,
	@ps_code_domain varchar(40) ,
	@ps_code_version varchar(40) ,
	@ps_code varchar(80) ,
	@ps_epro_domain varchar(64)  ,
	@ps_epro_id varchar(24) ,
	@ps_user_id varchar(24) ,
	@pi_remove_all bit = 0)
AS
-- This procedure disables records in c_XML_Code

-- If the @pi_remove_all bit is set, then we ignore @ps_epro_id and disable all mappings
-- for the given code_domain and epro_domain

DECLARE @ll_customer_id int,
		@ll_count int,
		@ls_code_description varchar(80)

SELECT @ll_customer_id = customer_id
FROM c_Database_Status


IF @pi_remove_all = 1
	BEGIN
	UPDATE x
	SET status = 'NA'
	FROM c_XML_Code x
	WHERE x.owner_id = @pl_owner_id
	AND x.code_domain = @ps_code_domain
	AND ISNULL(x.code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND x.code = @ps_code
	AND x.epro_domain = @ps_epro_domain
	AND x.status <> 'NA'
	AND x.mapping_owner_id = @ll_customer_id
	END
ELSE
	BEGIN
	-- Save the code description in case we need to create an "Unmapped" record
	SELECT @ls_code_description = max(x.code_description)
	FROM c_XML_Code x
	WHERE x.owner_id = @pl_owner_id
	AND x.code_domain = @ps_code_domain
	AND ISNULL(x.code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND x.code = @ps_code
	AND x.epro_domain = @ps_epro_domain
	AND x.epro_id = @ps_epro_id
	AND x.status <> 'NA'
	AND x.mapping_owner_id = @ll_customer_id

	UPDATE x
	SET status = 'NA'
	FROM c_XML_Code x
	WHERE x.owner_id = @pl_owner_id
	AND x.code_domain = @ps_code_domain
	AND ISNULL(x.code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND x.code = @ps_code
	AND x.epro_domain = @ps_epro_domain
	AND x.epro_id = @ps_epro_id
	AND x.status <> 'NA'
	AND x.mapping_owner_id = @ll_customer_id

	-- If there aren't any mappings left, then add an "Unmapped" record
	SELECT @ll_count = count(*)
	FROM c_XML_Code x
	WHERE x.owner_id = @pl_owner_id
	AND x.code_domain = @ps_code_domain
	AND ISNULL(x.code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND x.code = @ps_code
	AND x.epro_domain = @ps_epro_domain
	AND x.status IN ('OK', 'Unmapped')

	IF @ll_count = 0
		EXECUTE xml_add_mapping @pl_owner_id = @pl_owner_id,
								@ps_code_domain = @ps_code_domain,
								@ps_code_version = @ps_code_version,
								@ps_code = @ps_code,
								@ps_code_description = @ls_code_description,
								@ps_epro_domain = @ps_epro_domain,
								@ps_epro_id = NULL,
								@ps_epro_description = NULL,
								@pl_epro_owner_id = @ll_customer_id,
								@ps_created_by = @ps_user_id

	END

