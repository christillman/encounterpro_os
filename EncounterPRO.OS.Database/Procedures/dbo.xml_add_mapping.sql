
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[xml_add_mapping]
Print 'Drop Procedure [dbo].[xml_add_mapping]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[xml_add_mapping]') AND [type]='P'))
DROP PROCEDURE [dbo].[xml_add_mapping]
GO

-- Create Procedure [dbo].[xml_add_mapping]
Print 'Create Procedure [dbo].[xml_add_mapping]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE xml_add_mapping (
	@pl_owner_id int ,
	@ps_code_domain varchar(40) ,
	@ps_code_version varchar(40) ,
	@ps_code varchar(80) ,
	@ps_code_description varchar(128) ,
	@ps_epro_domain varchar(64)  ,
	@ps_epro_id varchar(64) ,
	@ps_epro_description varchar(128) ,
	@pl_epro_owner_id int ,
	@ps_created_by varchar(24))
AS
-- This procedure adds a record to c_XML_Code

DECLARE @ll_code_id int,
		@ls_status varchar(12),
		@ls_map_cardinality varchar(12),
		@ll_customer_id int,
		@ll_count int

IF @pl_owner_id IS NULL
	BEGIN
	RAISERROR ('Null @pl_owner_id',16,-1)
	RETURN -1
	END

IF @ps_code_domain IS NULL
	BEGIN
	RAISERROR ('Null @ps_code_domain',16,-1)
	RETURN -1
	END

IF @ps_code IS NULL AND @ps_epro_id IS NULL
	BEGIN
	RAISERROR ('@ps_code and @ps_epro_id cannot both be null',16,-1)
	RETURN -1
	END

IF @ps_epro_domain IS NULL
	BEGIN
	RAISERROR ('Null @ps_epro_domain',16,-1)
	RETURN -1
	END

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

IF @pl_epro_owner_id IS NULL
	SET @pl_epro_owner_id = @ll_customer_id

SELECT @ls_map_cardinality = map_cardinality
FROM c_XML_Code_Domain
WHERE owner_id = @pl_owner_id
AND code_domain = @ps_code_domain

IF @@ERROR <> 0
	RETURN -1

-- If we didn't find a domain record then get the cardinality from the c_Domain_Master table
IF @ls_map_cardinality IS NULL
	BEGIN
	SELECT @ls_map_cardinality = map_cardinality
	FROM c_Domain_Master
	WHERE domain_id = @ps_epro_domain

	IF @@ERROR <> 0
		RETURN

	IF @ls_map_cardinality IS NULL
		SET @ls_map_cardinality = 'ManyToMany'
	END

IF @ls_map_cardinality NOT IN ('OneToOne', 'ManyToOne', 'OneToMany', 'ManyToMany')
	SET @ls_map_cardinality = 'ManyToMany'

-- Is this a new mapping or a place holder for a missing mapping
IF @ps_epro_id IS NULL
	BEGIN
	SET @ls_status = 'Unmapped'
	-- See if this mapping already exists
	SELECT @ll_code_id = min(code_id)
	FROM c_XML_Code
	WHERE owner_id = @pl_owner_id
	AND code_domain = @ps_code_domain
	AND ISNULL(code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND code = @ps_code
	AND epro_domain = @ps_epro_domain
	AND mapping_owner_id = @ll_customer_id
	AND status = @ls_status
	END
ELSE IF @ps_code IS NULL
	BEGIN
	SET @ls_status = 'Unmapped'
	-- See if this mapping already exists
	SELECT @ll_code_id = min(code_id)
	FROM c_XML_Code
	WHERE owner_id = @pl_owner_id
	AND code_domain = @ps_code_domain
	AND ISNULL(code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND epro_domain = @ps_epro_domain
	AND epro_id = @ps_epro_id
	AND mapping_owner_id = @ll_customer_id
	AND status = @ls_status
	END
ELSE
	BEGIN
	SET @ls_status = 'OK'
	-- See if this mapping already exists
	SELECT @ll_code_id = min(code_id)
	FROM c_XML_Code
	WHERE owner_id = @pl_owner_id
	AND code_domain = @ps_code_domain
	AND ISNULL(code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND code = @ps_code
	AND epro_domain = @ps_epro_domain
	AND epro_id = @ps_epro_id
	AND mapping_owner_id = @ll_customer_id
	AND status = @ls_status
	END

IF @@ERROR <> 0
	RETURN

-- If the mapping already exists the just return
IF @ll_code_id > 0
	RETURN @ll_code_id

-- See if there is already a locally owned unmapped mapping
IF @ls_status = 'OK'
	BEGIN
	SELECT @ll_code_id = min(code_id)
	FROM c_XML_Code
	WHERE owner_id = @pl_owner_id
	AND code_domain = @ps_code_domain
	AND ISNULL(code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND epro_domain = @ps_epro_domain
	AND code = @ps_code
	AND mapping_owner_id = @ll_customer_id
	AND status = 'Unmapped'

	IF @ll_code_id IS NULL
		SELECT @ll_code_id = min(code_id)
		FROM c_XML_Code
		WHERE owner_id = @pl_owner_id
		AND code_domain = @ps_code_domain
		AND ISNULL(code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
		AND epro_domain = @ps_epro_domain
		AND epro_id = @ps_epro_id
		AND mapping_owner_id = @ll_customer_id
		AND status = 'Unmapped'
	END
ELSE
	SET @ll_code_id = NULL

-- If there is an unmapped record then replace it
IF @ll_code_id > 0
	UPDATE c_XML_Code
	SET epro_id = @ps_epro_id ,
		epro_description = COALESCE(epro_description, @ps_epro_description) ,
		code = @ps_code ,
		code_description = COALESCE(code_description, @ps_code_description) ,
		epro_owner_id = @pl_epro_owner_id,
		status = 'OK',
		created = dbo.get_client_datetime(),
		created_by = @ps_created_by
	WHERE code_id = @ll_code_id
ELSE
	BEGIN
	INSERT INTO c_XML_Code (
		owner_id ,
		code_domain ,
		code_version ,
		code ,
		code_description ,
		epro_domain ,
		epro_id ,
		epro_description ,
		epro_owner_id ,
		created_by ,
		status)
	VALUES (
		@pl_owner_id,
		@ps_code_domain ,
		@ps_code_version ,
		@ps_code ,
		@ps_code_description ,
		@ps_epro_domain ,
		@ps_epro_id ,
		@ps_epro_description ,
		@pl_epro_owner_id ,
		@ps_created_by,
		@ls_status)

	SET @ll_code_id = SCOPE_IDENTITY()
	END

-- Disable all locally owned mappings that have a different epro_id for the same code
IF @ls_map_cardinality IN ('ManyToOne', 'OneToOne')
	UPDATE c_XML_Code
	SET status = 'NA'
	WHERE owner_id = @pl_owner_id
	AND code_domain = @ps_code_domain
	AND ISNULL(code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND code = @ps_code
	AND epro_domain = @ps_epro_domain
	AND code_id <> @ll_code_id
	AND mapping_owner_id = @ll_customer_id

-- Disable all locally owned mappings that have a different code for the same epro_id
IF @ls_map_cardinality IN ('OneToMany', 'OneToOne')
	UPDATE c_XML_Code
	SET status = 'NA'
	WHERE owner_id = @pl_owner_id
	AND code_domain = @ps_code_domain
	AND ISNULL(code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND epro_domain = @ps_epro_domain
	AND epro_id = @ps_epro_id
	AND code_id <> @ll_code_id
	AND mapping_owner_id = @ll_customer_id


RETURN @ll_code_id

GO
GRANT EXECUTE
	ON [dbo].[xml_add_mapping]
	TO [cprsystem]
GO

