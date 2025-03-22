
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[xml_lookup_epro_id2]
Print 'Drop Procedure [dbo].[xml_lookup_epro_id2]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[xml_lookup_epro_id2]') AND [type]='P'))
DROP PROCEDURE [dbo].[xml_lookup_epro_id2]
GO

-- Create Procedure [dbo].[xml_lookup_epro_id2]
Print 'Create Procedure [dbo].[xml_lookup_epro_id2]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE xml_lookup_epro_id2 (
	@pl_owner_id int ,
	@ps_code_domain varchar(40) ,
	@ps_code_version varchar(40) = NULL,
	@ps_code varchar(80) ,
	@ps_code_description varchar(80) ,
	@ps_epro_domain varchar(64)  ,
	@ps_created_by varchar(24) ,
	@pl_patient_workplan_item_id int = NULL,
	@ps_epro_id varchar(64) OUTPUT ,
	@ps_epro_description varchar(80) OUTPUT )
AS

DECLARE @ll_code_id int,
		@ll_customer_id int,
		@ls_epro_object varchar(24),
		@ls_missing_map_action varchar(24),
		@ls_action varchar(12)

SET @ps_code = COALESCE(@ps_code, @ps_code_description)

IF @ps_code IS NULL
	RETURN 0

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT TOP 1 @ll_code_id = code_id, @ps_epro_id = epro_id, @ps_epro_description = epro_description
FROM c_XML_Code  
WHERE c_XML_Code.owner_id = @pl_owner_id
AND c_XML_Code.code_domain = @ps_code_domain
AND ISNULL(c_XML_Code.code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
AND c_XML_Code.code = @ps_code
AND (@ps_code_description IS NULL OR @ps_code_description = @ps_code OR @ps_code_description = c_XML_Code.code_description)
AND c_XML_Code.epro_domain = @ps_epro_domain
AND epro_id IS NOT NULL
AND mapping_owner_id IN (@ll_customer_id, @pl_owner_id, 0)
AND [status] = 'OK'
ORDER BY unique_flag DESC,  -- unique_flag aka default_flag
		CASE c_XML_Code.mapping_owner_id WHEN @ll_customer_id THEN 1 WHEN 0 THEN 2 ELSE 3 END,
		CASE c_XML_Code.epro_owner_id WHEN 0 THEN 1 WHEN @ll_customer_id THEN 2 ELSE 3 END

IF @@ERROR <> 0
	RETURN -1

IF @ll_code_id IS NOT NULL
	BEGIN
	EXECUTE dbo.xml_set_document_mapping
		@pl_patient_workplan_item_id = @pl_patient_workplan_item_id ,
		@pl_code_id = @ll_code_id ,
		@ps_map_action = 'Success'

	RETURN @ll_code_id
	END

-- If we get here then there are no valid mapping records for the specified owner_id/code_domain/code/epro_domain
-- See if the domain table has a missing map action
SELECT @ls_missing_map_action = missing_map_action_in
FROM dbo.c_XML_Code_Domain
WHERE owner_id = @pl_owner_id
AND code_domain = @ps_code_domain

SELECT @ls_epro_object = epro_object,
		@ls_missing_map_action = COALESCE(@ls_missing_map_action, missing_map_action)
FROM c_Domain_Master
WHERE domain_id = @ps_epro_domain

IF @@ERROR <> 0
	RETURN -1

IF @ls_epro_object IS NULL
	BEGIN
	-- There is no domain master record so use the default behavior
	SET @ls_epro_object = NULL
	SET @ls_missing_map_action = COALESCE(@ls_missing_map_action, 'Create')
	END

-- If the action is to fail then create a null mapping and return the code_id for it
IF @ls_missing_map_action IN ('Fail', 'Ignore')
	BEGIN
	SET @ps_epro_id = NULL
	SET @ps_epro_description = NULL

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

-- For now the only actions are 'Create' and 'Fail', so if we get here it must be 'Create'

EXECUTE xml_create_epro_id	@pl_owner_id = @pl_owner_id ,
							@ps_code_domain = @ps_code_domain ,
							@ps_code_version = @ps_code_version ,
							@ps_code = @ps_code ,
							@ps_code_description = @ps_code_description,
							@ps_epro_domain = @ps_epro_domain,
							@ps_epro_id = @ps_epro_id OUTPUT,
							@ps_created_by = @ps_created_by

IF @@ERROR <> 0
	RETURN -1

-- Since we created the epro_id, then set the epro_description to the code_description
SET @ps_epro_description = @ps_code_description

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

IF @@ERROR <> 0
	RETURN -1

EXECUTE dbo.xml_set_document_mapping
	@pl_patient_workplan_item_id = @pl_patient_workplan_item_id ,
	@pl_code_id = @ll_code_id ,
	@ps_map_action = 'Create'

RETURN @ll_code_id

GO
GRANT EXECUTE
	ON [dbo].[xml_lookup_epro_id2]
	TO [cprsystem]
GO

