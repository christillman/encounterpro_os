CREATE FUNCTION fn_lookup_code (
	@ps_epro_domain varchar(64)  ,
	@ps_epro_id varchar(64) ,
	@ps_code_domain varchar(40) ,
	@pl_owner_id int
	 )

RETURNS varchar(80)

AS
BEGIN

DECLARE @ls_code varchar(80),
		@ll_code_id int,
		@ls_code_version varchar(40),
		@ll_error int,
		@ll_rowcount int,
		@ll_customer_id int,
		@ls_base_tablename varchar(64)

SET @ls_code_version = NULL

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

IF @ps_epro_id IS NULL
	BEGIN
	SET @ls_code = NULL
	RETURN @ls_code
	END

-- Get the base table of the domain
SELECT @ls_base_tablename = o.base_tablename
FROM c_Epro_Object o
	INNER JOIN c_Domain_Master d
	ON o.epro_object = d.epro_object
WHERE d.domain_id = @ps_epro_domain

IF @ls_base_tablename = 'c_User'
	BEGIN
	SET @ls_code = dbo.fn_lookup_user_ID(@ps_epro_id, @pl_owner_id, @ps_code_domain)
	END
ELSE IF @ls_base_tablename = 'p_Patient'
	BEGIN
	SET @ls_code = dbo.fn_lookup_patient_ID(@ps_epro_id, @pl_owner_id, @ps_code_domain)
	END
ELSE
	BEGIN
	SELECT TOP 1 @ll_code_id = code_id, @ls_code = code
	FROM c_XML_Code  
	WHERE c_XML_Code.owner_id = @pl_owner_id
	AND c_XML_Code.code_domain = @ps_code_domain
	AND ISNULL(c_XML_Code.code_version, 'NULL') = ISNULL(@ls_code_version, 'NULL')
	AND c_XML_Code.epro_domain = @ps_epro_domain
	AND c_XML_Code.epro_id = @ps_epro_id
	AND mapping_owner_id IN (@ll_customer_id, @pl_owner_id, 0)
	AND [status] = 'OK'
	ORDER BY CASE c_XML_Code.mapping_owner_id WHEN @ll_customer_id THEN 1 WHEN 0 THEN 2 ELSE 3 END,
			CASE c_XML_Code.epro_owner_id WHEN 0 THEN 1 WHEN @ll_customer_id THEN 2 ELSE 3 END
	
	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0 OR @ll_rowcount = 0
		SET @ls_code = NULL
	END
	
RETURN @ls_code

END
