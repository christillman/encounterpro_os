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

-- Drop Procedure [dbo].[xml_lookup_code2]
Print 'Drop Procedure [dbo].[xml_lookup_code2]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[xml_lookup_code2]') AND [type]='P'))
DROP PROCEDURE [dbo].[xml_lookup_code2]
GO

-- Create Procedure [dbo].[xml_lookup_code2]
Print 'Create Procedure [dbo].[xml_lookup_code2]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
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

GO
GRANT EXECUTE
	ON [dbo].[xml_lookup_code2]
	TO [cprsystem]
GO

