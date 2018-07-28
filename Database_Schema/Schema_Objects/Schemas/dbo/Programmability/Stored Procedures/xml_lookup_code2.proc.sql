CREATE PROCEDURE xml_lookup_code2 (
	@ps_epro_domain varchar(64)  ,
	@ps_epro_id varchar(64) ,
	@ps_epro_description varchar(80) ,
	@pl_owner_id int ,
	@ps_code_domain varchar(40) ,
	@ps_code_version varchar(40) = NULL,
	@ps_created_by varchar(24) ,
	@pl_patient_workplan_item_id int = NULL,
	@ps_code varchar(80) OUTPUT,
	@ps_code_description varchar(80) OUTPUT
	)
AS

DECLARE @ll_count int,
		@ll_error int,
		@ll_code_id int,
		@ll_customer_id int,
		@ls_epro_object varchar(24),
		@ls_missing_map_action varchar(24)


SET @ps_code = NULL
SET @ps_code_description = NULL

IF @ps_epro_domain IS NULL
	RETURN 0

IF @ps_epro_id IS NULL
	RETURN 0

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT TOP 1 @ll_code_id = x.code_id, @ps_code = x.code, @ps_code_description = x.code_description
FROM c_XML_Code x
WHERE x.epro_domain = @ps_epro_domain
AND x.epro_id = @ps_epro_id
AND x.owner_id = @pl_owner_id
AND x.code_domain = @ps_code_domain
AND ISNULL(x.code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
AND x.code IS NOT NULL
AND mapping_owner_id IN (@ll_customer_id, @pl_owner_id, 0)
AND [status] = 'OK'
ORDER BY unique_flag DESC,  -- unique_flag aka default_flag
		CASE x.mapping_owner_id WHEN @ll_customer_id THEN 1 WHEN 0 THEN 2 ELSE 3 END,
		CASE x.epro_owner_id WHEN 0 THEN 1 WHEN @ll_customer_id THEN 2 ELSE 3 END

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_count = 1
	BEGIN
	EXECUTE dbo.xml_set_document_mapping
		@pl_patient_workplan_item_id = @pl_patient_workplan_item_id ,
		@pl_code_id = @ll_code_id ,
		@ps_map_action = 'Success'

	RETURN @ll_code_id
	END

-- If we get here then there are no valid mapping records for the specified owner_id/code_domain/code/epro_domain
SET @ls_missing_map_action = NULL

-- See if the domain table has a missing map action
SELECT @ls_missing_map_action = missing_map_action_out
FROM dbo.c_XML_Code_Domain
WHERE owner_id = @pl_owner_id
AND code_domain = @ps_code_domain

SELECT @ls_epro_object = epro_object,
		@ls_missing_map_action = COALESCE(@ls_missing_map_action, missing_map_action)
FROM c_Domain_Master
WHERE domain_id = @ps_epro_domain

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_count = 0
	BEGIN
	-- There is no domain master record so use the default behavior
	SET @ls_epro_object = NULL

	-- The default behavior for outgoing mappings is 'Ignore'
	SET @ls_missing_map_action = COALESCE(@ls_missing_map_action, 'Ignore')
	END

-- If the action is 'Fail' or 'Ignore' then create a null mapping and return the code_id for it
IF @ls_missing_map_action IN ('Fail', 'Ignore')
	BEGIN
	SET @ps_code = NULL
	SET @ps_code_description = NULL

	EXECUTE @ll_code_id = xml_add_mapping @pl_owner_id = @pl_owner_id ,
										@ps_code_domain = @ps_code_domain ,
										@ps_code_version = @ps_code_version ,
										@ps_code = @ps_code ,
										@ps_code_description = @ps_code_description ,
										@ps_epro_domain = @ps_epro_domain,
										@ps_epro_id = @ps_epro_id,
										@ps_epro_description = @ps_epro_description,
										@pl_epro_owner_id = @ll_customer_id,
										@ps_created_by = @ps_created_by

	EXECUTE dbo.xml_set_document_mapping
		@pl_patient_workplan_item_id = @pl_patient_workplan_item_id ,
		@pl_code_id = @ll_code_id ,
		@ps_map_action = @ls_missing_map_action

	RETURN @ll_code_id
	END

-- For now the only actions are 'Create' and 'Fail' and 'Ignore', so if we get here it must be 'Create'
SET @ps_code = @ps_epro_id
SET @ps_code_description = @ps_epro_description

EXECUTE @ll_code_id = xml_add_mapping @pl_owner_id = @pl_owner_id ,
										@ps_code_domain = @ps_code_domain ,
										@ps_code_version = @ps_code_version ,
										@ps_code = @ps_code ,
										@ps_code_description = @ps_code_description ,
										@ps_epro_domain = @ps_epro_domain,
										@ps_epro_id = @ps_epro_id,
										@ps_epro_description = @ps_epro_description,
										@pl_epro_owner_id = @ll_customer_id,
										@ps_created_by = @ps_created_by

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

EXECUTE dbo.xml_set_document_mapping
	@pl_patient_workplan_item_id = @pl_patient_workplan_item_id ,
	@pl_code_id = @ll_code_id ,
	@ps_map_action = 'Create'


RETURN @ll_code_id

