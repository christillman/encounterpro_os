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
SET QUOTED_IDENTIFIER OFF
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
-- This procedure is depracated and should no longer be used.  Use xml_add_mapping instead.

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

