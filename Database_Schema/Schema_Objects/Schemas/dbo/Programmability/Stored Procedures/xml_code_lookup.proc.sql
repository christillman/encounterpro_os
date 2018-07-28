CREATE PROCEDURE xml_code_lookup (
	@pl_owner_id int ,
	@ps_code_domain varchar(40) ,
	@ps_code_version varchar(40) = NULL,
	@ps_code varchar(80) ,
	@ps_description varchar(80) ,
	@ps_epro_domain varchar(64)  ,
	@ps_created_by varchar(24) ,
	@ps_auto_create char(1) = 'Y' )
AS

-- This stored procedure is deprecated and should not be used.  Use xml_lookup_epro_id instead

DECLARE @ll_count int,
		@ll_code_id int,
		@ls_epro_id varchar(80),
		@ll_customer_id int

SET @ps_code = COALESCE(@ps_code, @ps_description)

IF @ps_code IS NULL
	RETURN 0

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

-- See if it's there
SELECT @ll_count = count(*)
FROM c_XML_Code
WHERE c_XML_Code.owner_id = @pl_owner_id
AND c_XML_Code.code_domain = @ps_code_domain
AND ISNULL(code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
AND c_XML_Code.code = @ps_code
AND c_XML_Code.epro_domain = @ps_epro_domain

-- If it's not there then see if we should add it or generate a default
IF @ll_count = 0
	BEGIN
	IF @ps_auto_create = 'Y'  -- Go ahead a create the code and map it
		BEGIN
		EXECUTE xml_new_code	@pl_owner_id = @pl_owner_id ,
								@ps_code_domain = @ps_code_domain ,
								@ps_code_version = @ps_code_version ,
								@ps_code = @ps_code ,
								@ps_description = @ps_description,
								@ps_epro_domain = @ps_epro_domain,
								@ps_epro_id = @ls_epro_id OUTPUT,
								@ps_created_by = @ps_created_by

		IF @ls_epro_id IS NOT NULL
			EXECUTE @ll_code_id = xml_add_code	@pl_owner_id = @pl_owner_id ,
												@ps_code_domain = @ps_code_domain ,
												@ps_code_version = @ps_code_version ,
												@ps_code = @ps_code ,
												@ps_epro_domain = @ps_epro_domain,
												@ps_epro_id = @ls_epro_id,
												@ps_created_by = @ps_created_by,
												@pi_replace_flag = 1
		END
	IF @ps_auto_create = 'M'  -- Create the Mapping record, but leave the epro_id NULL
		BEGIN
		EXECUTE @ll_code_id = xml_add_code	@pl_owner_id = @pl_owner_id ,
											@ps_code_domain = @ps_code_domain ,
											@ps_code_version = @ps_code_version ,
											@ps_code = @ps_code ,
											@ps_epro_domain = @ps_epro_domain,
											@ps_epro_id = NULL,
											@ps_created_by = @ps_created_by,
											@pi_replace_flag = 0
		END
	END

-- Finally, get what's in the code table now
IF @ls_epro_id IS NOT NULL
	SELECT code_id = @ll_code_id,   
			owner_id = @pl_owner_id,   
			code_domain = @ps_code_domain,   
			code_version = @ps_code_version,   
			code = @ps_code,   
			epro_domain = @ps_epro_domain,   
			epro_id = @ls_epro_id,   
			unique_flag = 1,   
			created = getdate(),   
			created_by = @ps_created_by,   
			last_updated = getdate()
	FROM c_1_Record
ELSE
	SELECT c_XML_Code.code_id,   
			c_XML_Code.owner_id,   
			c_XML_Code.code_domain,   
			c_XML_Code.code_version,   
			c_XML_Code.code,   
			c_XML_Code.epro_domain,   
			c_XML_Code.epro_id,   
			c_XML_Code.unique_flag,   
			c_XML_Code.created,   
			c_XML_Code.created_by,   
			c_XML_Code.last_updated,
			c_XML_Code.mapping_owner_id,
			c_XML_Code.epro_owner_id,
			mapping_owner_sort = CASE c_XML_Code.mapping_owner_id WHEN @ll_customer_id THEN 1 WHEN 0 THEN 2 ELSE 3 END,
			epro_owner_sort = CASE c_XML_Code.epro_owner_id WHEN 0 THEN 1 WHEN @ll_customer_id THEN 2 ELSE 3 END
	FROM c_XML_Code  
	WHERE c_XML_Code.owner_id = @pl_owner_id
	AND c_XML_Code.code_domain = @ps_code_domain
	AND ISNULL(c_XML_Code.code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND c_XML_Code.code = @ps_code
	AND c_XML_Code.epro_domain = @ps_epro_domain
	AND mapping_owner_id IN (@ll_customer_id, @pl_owner_id, 0)
	ORDER BY CASE c_XML_Code.mapping_owner_id WHEN @ll_customer_id THEN 1 WHEN 0 THEN 2 ELSE 3 END,
			CASE c_XML_Code.epro_owner_id WHEN 0 THEN 1 WHEN @ll_customer_id THEN 2 ELSE 3 END


