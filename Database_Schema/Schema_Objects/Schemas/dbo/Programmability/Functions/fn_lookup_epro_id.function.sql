CREATE FUNCTION fn_lookup_epro_id (
	@pl_owner_id int ,
	@ps_code_domain varchar(40) ,
	@ps_code varchar(80) ,
	@ps_epro_domain varchar(64) 
	 )

RETURNS varchar(24)

AS
BEGIN

DECLARE @ls_epro_id varchar(24),
		@ll_code_id int,
		@ls_code_version varchar(40),
		@ll_error int,
		@ll_rowcount int,
		@ll_customer_id int

SET @ls_code_version = NULL

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

IF @ps_code IS NULL
	SET @ls_epro_id = NULL
ELSE
	BEGIN
	SELECT TOP 1 @ll_code_id = code_id, @ls_epro_id = epro_id
	FROM c_XML_Code  
	WHERE c_XML_Code.owner_id = @pl_owner_id
	AND c_XML_Code.code_domain = @ps_code_domain
	AND ISNULL(c_XML_Code.code_version, 'NULL') = ISNULL(@ls_code_version, 'NULL')
	AND c_XML_Code.code = @ps_code
	AND c_XML_Code.epro_domain = @ps_epro_domain
	AND epro_id IS NOT NULL
	AND mapping_owner_id IN (@ll_customer_id, @pl_owner_id, 0)
	AND [status] = 'OK'
	ORDER BY CASE c_XML_Code.mapping_owner_id WHEN @ll_customer_id THEN 1 WHEN 0 THEN 2 ELSE 3 END,
			CASE c_XML_Code.epro_owner_id WHEN 0 THEN 1 WHEN @ll_customer_id THEN 2 ELSE 3 END
	
	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0 OR @ll_rowcount = 0
		SET @ls_epro_id = NULL
	END
	
RETURN @ls_epro_id

END
