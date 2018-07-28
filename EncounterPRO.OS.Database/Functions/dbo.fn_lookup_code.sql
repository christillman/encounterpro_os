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

-- Drop Function [dbo].[fn_lookup_code]
Print 'Drop Function [dbo].[fn_lookup_code]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_lookup_code]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_lookup_code]
GO

-- Create Function [dbo].[fn_lookup_code]
Print 'Create Function [dbo].[fn_lookup_code]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_lookup_code (
	@ps_epro_domain varchar(64)  ,
	@ps_epro_id varchar(64) ,
	@ps_code_domain varchar(40) ,
	@pl_owner_id int
	 )

RETURNS varchar(80)

AS
BEGIN

DECLARE @ls_code varchar(80),
		@ll_code_id int,
		@ls_code_version varchar(40),
		@ll_error int,
		@ll_rowcount int,
		@ll_customer_id int,
		@ls_base_tablename varchar(64)

SET @ls_code_version = NULL

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

IF @ps_epro_id IS NULL
	BEGIN
	SET @ls_code = NULL
	RETURN @ls_code
	END

-- Get the base table of the domain
SELECT @ls_base_tablename = o.base_tablename
FROM c_Epro_Object o
	INNER JOIN c_Domain_Master d
	ON o.epro_object = d.epro_object
WHERE d.domain_id = @ps_epro_domain

IF @ls_base_tablename = 'c_User'
	BEGIN
	SET @ls_code = dbo.fn_lookup_user_ID(@ps_epro_id, @pl_owner_id, @ps_code_domain)
	END
ELSE IF @ls_base_tablename = 'p_Patient'
	BEGIN
	SET @ls_code = dbo.fn_lookup_patient_ID(@ps_epro_id, @pl_owner_id, @ps_code_domain)
	END
ELSE
	BEGIN
	SELECT TOP 1 @ll_code_id = code_id, @ls_code = code
	FROM c_XML_Code  
	WHERE c_XML_Code.owner_id = @pl_owner_id
	AND c_XML_Code.code_domain = @ps_code_domain
	AND ISNULL(c_XML_Code.code_version, 'NULL') = ISNULL(@ls_code_version, 'NULL')
	AND c_XML_Code.epro_domain = @ps_epro_domain
	AND c_XML_Code.epro_id = @ps_epro_id
	AND mapping_owner_id IN (@ll_customer_id, @pl_owner_id, 0)
	AND [status] = 'OK'
	ORDER BY CASE c_XML_Code.mapping_owner_id WHEN @ll_customer_id THEN 1 WHEN 0 THEN 2 ELSE 3 END,
			CASE c_XML_Code.epro_owner_id WHEN 0 THEN 1 WHEN @ll_customer_id THEN 2 ELSE 3 END
	
	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0 OR @ll_rowcount = 0
		SET @ls_code = NULL
	END
	
RETURN @ls_code

END
GO
GRANT EXECUTE
	ON [dbo].[fn_lookup_code]
	TO [cprsystem]
GO

