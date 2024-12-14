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

-- Drop Function [dbo].[fn_lookup_patient2]
Print 'Drop Function [dbo].[fn_lookup_patient2]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_lookup_patient2]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_lookup_patient2]
GO

-- Create Function [dbo].[fn_lookup_patient2]
Print 'Create Function [dbo].[fn_lookup_patient2]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_lookup_patient2 (
	@pl_owner_id int,
	@ps_IDDomain varchar(40),
	@ps_IDValue varchar(255)
	)

RETURNS varchar(12)

AS
BEGIN

DECLARE @ls_cpr_id varchar(12),
		@ll_treatment_id int,
		@ll_length int,
		@ls_progress_value varchar(40),
		@ls_progress_key varchar(40),
		@ll_customer_id int,
		@ls_current_value varchar(255),
		@ll_rowcount int,
		@ll_error int

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

IF @pl_owner_id IS NULL
	SET @pl_owner_id = @ll_customer_id

IF @ll_customer_id = @pl_owner_id
	SET @ls_progress_key = @ps_IDDomain
ELSE
	SET @ls_progress_key = CAST(@pl_owner_id AS varchar(9)) + '^' + @ps_IDDomain


-- Check for hard-coded id_domains
IF @pl_owner_id = @ll_customer_id AND @ps_IDDomain IN ('jmj_cpr_id', 'cpr_id')
	SELECT @ls_cpr_id = cpr_id
	FROM p_Patient
	WHERE cpr_id = @ps_IDValue
ELSE IF @pl_owner_id = @ll_customer_id AND @ps_IDDomain IN ('JMJBILLINGID', 'jmj_billing_id', 'billing_id')
	SELECT @ls_cpr_id = cpr_id
	FROM p_Patient
	WHERE billing_id = @ps_IDValue
ELSE IF @pl_owner_id = @ll_customer_id AND @ps_IDDomain IN ('jmj_guid', 'id')
	SELECT @ls_cpr_id = cpr_id
	FROM p_Patient
	WHERE CAST(id AS varchar(40)) = @ps_IDValue
ELSE IF @pl_owner_id = @ll_customer_id AND @ps_IDDomain IN ('jmj_treatment_id', 'treatment_id') AND ISNUMERIC(@ps_IDValue) = 1
	BEGIN
	SET @ll_treatment_id = CAST(@ps_IDValue AS int)

	SELECT @ls_cpr_id = cpr_id
	FROM p_Treatment_Item
	WHERE treatment_id = @ll_treatment_id
	END
ELSE
	SELECT @ls_cpr_id = min(cpr_id)
	FROM p_Patient_Progress
	WHERE progress_type = 'ID'
	AND progress_key = @ls_progress_key
	AND progress_value = @ps_IDValue
	AND current_flag = 'Y'

RETURN @ls_cpr_id

END

GO
GRANT EXECUTE
	ON [dbo].[fn_lookup_patient2]
	TO [cprsystem]
GO

