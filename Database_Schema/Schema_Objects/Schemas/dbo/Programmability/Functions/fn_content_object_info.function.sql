CREATE FUNCTION fn_content_object_info (
	@ps_object_type varchar(24),
	@ps_object_key varchar(64))

RETURNS @objectinfo TABLE (
	object_id uniqueidentifier NULL,
	object_type varchar(24) NOT NULL,
	object_key varchar(64) NOT NULL,
	description varchar(80) NOT NULL,
	owner_id int NOT NULL
)

AS
BEGIN

DECLARE @ls_epro_object varchar(24),
		@ls_item_owner varchar(12),
		@ls_equivalence_flag char(1),
		@ll_customer_id int

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT @ls_epro_object = epro_object,
		@ls_item_owner = item_owner,
		@ls_equivalence_flag = equivalence_flag
FROM c_Domain_Master
WHERE domain_id = @ps_object_type

IF @ls_equivalence_flag = 'Y'
	INSERT INTO @objectinfo (
		object_id ,
		object_type ,
		object_key ,
		description ,
		owner_id)
	SELECT object_id ,
		object_type ,
		object_key ,
		description ,
		owner_id
	FROM c_Equivalence
	WHERE object_type = @ps_object_type
	AND object_key = @ps_object_key
ELSE IF @ls_epro_object = '!Enumerated'
	INSERT INTO @objectinfo (
		object_type ,
		object_key ,
		description ,
		owner_id)
	SELECT domain_id ,
		domain_item ,
		domain_item_description ,
		CASE @ls_item_owner WHEN 'Customer' THEN @ll_customer_id ELSE 0 END
	FROM c_Domain
	WHERE domain_id = @ps_object_type
	AND domain_item = @ps_object_key
	

RETURN
END
