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

-- Drop Function [dbo].[fn_encounter_risk_level]
Print 'Drop Function [dbo].[fn_encounter_risk_level]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_encounter_risk_level]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_encounter_risk_level]
GO

-- Create Function [dbo].[fn_encounter_risk_level]
Print 'Create Function [dbo].[fn_encounter_risk_level]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_encounter_risk_level (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer)

RETURNS int

AS

BEGIN

DECLARE @ll_risk_level int,
	@ll_encounter_risk_level int,
	@ll_default_assessment_risk_level int,
	@ll_default_treatment_risk_level int,
	@ldc_existing_scale dec(6,3)

SET @ll_encounter_risk_level = 0

-- First get the highest risk level of the assessments created and billed during the encounter
SELECT @ll_risk_level = max(COALESCE(p.risk_level, d.risk_level))
FROM p_Encounter_Assessment a WITH (NOLOCK)
	INNER JOIN p_Assessment p WITH (NOLOCK)
	ON a.cpr_id = p.cpr_id 
	AND a.problem_id = p.problem_id
	AND a.encounter_id = p.open_encounter_id
	INNER JOIN c_Assessment_Definition d WITH (NOLOCK)
	ON a.assessment_id = d.assessment_id
WHERE a.cpr_id = @ps_cpr_id
AND a.encounter_id = @pl_encounter_id
AND a.bill_flag = 'Y'
AND p.cpr_id = @ps_cpr_id
AND p.open_encounter_id = @pl_encounter_id

IF @ll_risk_level > @ll_encounter_risk_level
	SET @ll_encounter_risk_level = @ll_risk_level

-- First get the highest risk level of the assessment progress notes made during the encounter
SELECT @ll_risk_level = max(p.risk_level)
FROM p_Encounter_Assessment a WITH (NOLOCK)
	INNER JOIN p_Assessment_progress p WITH (NOLOCK)
	ON a.cpr_id = p.cpr_id 
	AND a.problem_id = p.problem_id
	AND a.encounter_id = p.encounter_id
WHERE a.cpr_id = @ps_cpr_id
AND a.encounter_id = @pl_encounter_id
AND a.bill_flag = 'Y'
AND p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id

IF @ll_risk_level > @ll_encounter_risk_level
	SET @ll_encounter_risk_level = @ll_risk_level


-- Then get the max risk_level of the treatments created during the encounter
-- For treatments with procedure_ids
SELECT @ll_risk_level = max(COALESCE(t.risk_level, COALESCE(p.risk_level, tt.risk_level)))
FROM p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN c_Treatment_Type tt WITH (NOLOCK)
	ON t.treatment_type = tt.treatment_type
	LEFT OUTER JOIN c_Procedure p WITH (NOLOCK)
	ON t.procedure_id = p.procedure_id
WHERE t.cpr_id = @ps_cpr_id
AND t.open_encounter_id = @pl_encounter_id
AND (t.treatment_status IS NULL or t.treatment_status <> 'CANCELLED')

IF @ll_risk_level > @ll_encounter_risk_level
	SET @ll_encounter_risk_level = @ll_risk_level

-- Then get the max risk_level of the treatments progress notes created during the encounter
SELECT @ll_risk_level = max(t.risk_level)
FROM p_Treatment_Progress t WITH (NOLOCK)
WHERE t.cpr_id = @ps_cpr_id
AND t.encounter_id = @pl_encounter_id

IF @ll_risk_level > @ll_encounter_risk_level
	SET @ll_encounter_risk_level = @ll_risk_level


RETURN @ll_encounter_risk_level
END

GO
GRANT EXECUTE
	ON [dbo].[fn_encounter_risk_level]
	TO [cprsystem]
GO

