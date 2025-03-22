
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[xml_add_code]
Print 'Drop Procedure [dbo].[xml_add_code]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[xml_add_code]') AND [type]='P'))
DROP PROCEDURE [dbo].[xml_add_code]
GO

-- Create Procedure [dbo].[xml_add_code]
Print 'Create Procedure [dbo].[xml_add_code]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--exec xml_add_code 100, 'LabcorpCatalog', NULL, '096479', 'observation_id', '0001212x', 'DEMOFAMILIA', 0

CREATE PROCEDURE xml_add_code (
	@pl_owner_id int ,
	@ps_code_domain varchar(40) ,
	@ps_code_version varchar(40) ,
	@ps_code varchar(80) ,
	@ps_epro_domain varchar(64)  ,
	@ps_epro_id varchar(64) ,
	@ps_created_by varchar(24),
	@pi_replace_flag bit = 1,
	@ps_description varchar(128) = NULL)
AS
-- This procedure adds a record to c_XML_Code
-- This procedure is deprecated and should no longer be used.  Use xml_add_mapping instead.

DECLARE @ll_code_id int,
		@ls_status varchar(12)

IF @pi_replace_flag = 1
	BEGIN
	UPDATE c_XML_Code
	SET epro_id = @ps_epro_id
	WHERE owner_id = @pl_owner_id
	AND code_domain = @ps_code_domain
	AND ISNULL(code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND epro_domain = @ps_epro_domain
	AND code = @ps_code

	IF @@ROWCOUNT > 0
		BEGIN
		SELECT @ll_code_id = max(code_id)
		FROM c_XML_Code
		WHERE owner_id = @pl_owner_id
		AND code_domain = @ps_code_domain
		AND ISNULL(code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
		AND epro_domain = @ps_epro_domain
		AND code = @ps_code

		RETURN @ll_code_id
		END
	END
ELSE
	BEGIN
	-- If this code mapping already exists, then just return the mapping and don't create a new one
	SELECT @ll_code_id = max(code_id)
	FROM c_XML_Code
	WHERE owner_id = @pl_owner_id
	AND code_domain = @ps_code_domain
	AND ISNULL(code_version, 'NULL') = ISNULL(@ps_code_version, 'NULL')
	AND epro_domain = @ps_epro_domain
	AND code = @ps_code
	AND epro_id = @ps_epro_id
	
	IF @ll_code_id IS NOT NULL
		RETURN @ll_code_id
	END

IF @ps_epro_id IS NULL
	SET @ls_status = 'Unmapped'
ELSE
	SET @ls_status = 'OK'

INSERT INTO c_XML_Code (
	owner_id ,
	code_domain ,
	code_version ,
	code ,
	epro_domain ,
	epro_id ,
	created_by ,
	unique_flag ,
	status,
	code_description)
VALUES (
	@pl_owner_id,
	@ps_code_domain ,
	@ps_code_version ,
	@ps_code ,
	@ps_epro_domain ,
	@ps_epro_id ,
	@ps_created_by,
	@pi_replace_flag,
	@ls_status,
	@ps_description )

SET @ll_code_id = SCOPE_IDENTITY()

RETURN @ll_code_id

GO
GRANT EXECUTE
	ON [dbo].[xml_add_code]
	TO [cprsystem]
GO

