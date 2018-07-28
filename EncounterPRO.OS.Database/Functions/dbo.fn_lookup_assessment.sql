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

-- Drop Function [dbo].[fn_lookup_assessment]
Print 'Drop Function [dbo].[fn_lookup_assessment]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_lookup_assessment]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_lookup_assessment]
GO

-- Create Function [dbo].[fn_lookup_assessment]
Print 'Create Function [dbo].[fn_lookup_assessment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_lookup_assessment (
	@ps_cpr_id varchar(12),
	@ps_id_domain varchar(40),
	@ps_id varchar(40) )

RETURNS int

AS
BEGIN

DECLARE @ls_cpr_id varchar(12),
		@ll_problem_id int

SET @ll_problem_id = NULL

-- Check for hard-coded id_domains
IF @ps_id_domain IN ('jmj_problem_id', 'problem_id')
	SELECT @ll_problem_id = max(problem_id)
	FROM p_assessment
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = CAST(@ps_id AS int)
ELSE IF @ps_id_domain = 'jmj_guid'
	SELECT @ll_problem_id = max(problem_id)
	FROM p_assessment
	WHERE cpr_id = @ps_cpr_id
	AND CAST(id AS varchar(40)) = @ps_id
ELSE
	SELECT @ll_problem_id = min(problem_id)
	FROM p_Assessment_Progress
	WHERE cpr_id = @ps_cpr_id
	AND progress_type = 'ID'
	AND progress_key = @ps_id_domain
	AND progress_value = @ps_id
	AND current_flag = 'Y'

RETURN @ll_problem_id

END

GO
GRANT EXECUTE
	ON [dbo].[fn_lookup_assessment]
	TO [cprsystem]
GO

