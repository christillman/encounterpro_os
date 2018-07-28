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

-- Drop Procedure [dbo].[xml_code_lookup]
Print 'Drop Procedure [dbo].[xml_code_lookup]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[xml_code_lookup]') AND [type]='P'))
DROP PROCEDURE [dbo].[xml_code_lookup]
GO

-- Create Procedure [dbo].[xml_code_lookup]
Print 'Create Procedure [dbo].[xml_code_lookup]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
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


GO
GRANT EXECUTE
	ON [dbo].[xml_code_lookup]
	TO [cprsystem]
GO

