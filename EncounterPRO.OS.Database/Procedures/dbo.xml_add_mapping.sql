--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

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
SET QUOTED_IDENTIFIER OFF
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
		@ll_error int,
		@ll_rowcount int,
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

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @@ERROR <> 0
	RETURN -1

-- If we didn't find a domain record then get the cardinality from the c_Domain_Master table
IF @ll_rowcount = 0
	BEGIN
	SELECT @ls_map_cardinality = map_cardinality
	FROM c_Domain_Master
	WHERE domain_id = @ps_epro_domain

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN

	IF @ll_rowcount = 0
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


SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
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

