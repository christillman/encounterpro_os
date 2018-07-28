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

-- Drop Function [dbo].[fn_encounter_risk_level_detail]
Print 'Drop Function [dbo].[fn_encounter_risk_level_detail]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_encounter_risk_level_detail]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_encounter_risk_level_detail]
GO

-- Create Function [dbo].[fn_encounter_risk_level_detail]
Print 'Create Function [dbo].[fn_encounter_risk_level_detail]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_encounter_risk_level_detail (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer)

RETURNS @risk TABLE (
	context_object varchar(24) NOT NULL,
	context_object_type varchar(24) NOT NULL,
	context_object_type_description varchar(40) NOT NULL,
	object_key int NOT NULL,
	description varchar(80) NOT NULL,
	risk_action varchar(24) NOT NULL,
	risk_source varchar(24) NOT NULL,
	risk_level int NOT NULL)

AS

BEGIN

-- First get the highest risk level of the assessments created and billed during the encounter
--SELECT @ll_risk_level = max(COALESCE(p.risk_level, d.risk_level))
INSERT INTO @risk (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	risk_action ,
	risk_source ,
	risk_level )
SELECT DISTINCT
	'Assessment',
	ISNULL(p.assessment_type, 'SICK'),
	CAST(ISNULL(t.description, 'Sick') AS varchar(40)),
	p.problem_id,
	p.assessment,
	'Assessment Touched',
	CASE WHEN p.risk_level IS NULL THEN 'Assessment Default' ELSE 'Assessment' END,
	COALESCE(p.risk_level, d.risk_level)
FROM p_Encounter_Assessment a WITH (NOLOCK)
	INNER JOIN p_Assessment p WITH (NOLOCK)
	ON a.cpr_id = p.cpr_id 
	AND a.problem_id = p.problem_id
	AND a.encounter_id = p.open_encounter_id
	INNER JOIN c_Assessment_Definition d WITH (NOLOCK)
	ON a.assessment_id = d.assessment_id
	LEFT OUTER JOIN c_Assessment_Type t WITH (NOLOCK)
	ON p.assessment_type = t.assessment_type
WHERE a.cpr_id = @ps_cpr_id
AND a.encounter_id = @pl_encounter_id
AND a.bill_flag = 'Y'
AND p.cpr_id = @ps_cpr_id
AND p.open_encounter_id = @pl_encounter_id
AND COALESCE(p.risk_level, d.risk_level) > 0


-- First get the highest risk level of the assessment progress notes made during the encounter
--SELECT @ll_risk_level = max(p.risk_level)
INSERT INTO @risk (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	risk_action ,
	risk_source ,
	risk_level )
SELECT DISTINCT
	'Assessment',
	ISNULL(pa.assessment_type, 'SICK'),
	CAST(ISNULL(t.description, 'Sick') AS varchar(40)),
	pa.problem_id,
	pa.assessment,
	'Assessment Progress',
	'Assessment Progress',
	p.risk_level
FROM p_Encounter_Assessment a WITH (NOLOCK)
	INNER JOIN p_Assessment_progress p WITH (NOLOCK)
	ON a.cpr_id = p.cpr_id 
	AND a.problem_id = p.problem_id
	AND a.encounter_id = p.encounter_id
	INNER JOIN p_Assessment pa WITH (NOLOCK)
	ON a.cpr_id = pa.cpr_id 
	AND a.problem_id = pa.problem_id
	LEFT OUTER JOIN c_Assessment_Type t WITH (NOLOCK)
	ON pa.assessment_type = t.assessment_type
WHERE a.cpr_id = @ps_cpr_id
AND a.encounter_id = @pl_encounter_id
AND a.bill_flag = 'Y'
AND p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id
AND pa.current_flag = 'Y'
AND p.risk_level > 0



-- Then get the max risk_level of the treatments created during the encounter
-- For treatments with procedure_ids
--SELECT @ll_risk_level = max(COALESCE(t.risk_level, COALESCE(p.risk_level, tt.risk_level)))
INSERT INTO @risk (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	risk_action ,
	risk_source ,
	risk_level )
SELECT DISTINCT
	'Treatment',
	t.treatment_type,
	CAST(tt.description AS varchar(40)),
	t.treatment_id,
	t.treatment_description,
	'Treatment Ordered',
	CASE WHEN t.risk_level IS NULL 
			THEN	CASE WHEN p.risk_level IS NULL 
							THEN 'Treatment Type Default' 
							ELSE 'Procedure Default' END
			ELSE	'Treatment' END,
	COALESCE(t.risk_level, COALESCE(p.risk_level, tt.risk_level))
FROM p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN c_Treatment_Type tt WITH (NOLOCK)
	ON t.treatment_type = tt.treatment_type
	LEFT OUTER JOIN c_Procedure p WITH (NOLOCK)
	ON t.procedure_id = p.procedure_id
WHERE t.cpr_id = @ps_cpr_id
AND t.open_encounter_id = @pl_encounter_id
AND (t.treatment_status IS NULL or t.treatment_status <> 'CANCELLED')
AND COALESCE(t.risk_level, COALESCE(p.risk_level, tt.risk_level)) > 0

-- Then get the max risk_level of the treatments progress notes created during the encounter
--SELECT @ll_risk_level = max(p.risk_level)
INSERT INTO @risk (
	context_object ,
	context_object_type ,
	context_object_type_description ,
	object_key ,
	description ,
	risk_action ,
	risk_source ,
	risk_level )
SELECT DISTINCT
	'Treatment',
	t.treatment_type,
	CAST(tt.description AS varchar(40)),
	t.treatment_id,
	t.treatment_description,
	'Treatment Progress',
	'Treatment Progress',
	p.risk_level
FROM p_Treatment_Progress p WITH (NOLOCK)
	INNER JOIN p_Treatment_Item t WITH (NOLOCK)
	ON p.cpr_id = t.cpr_id
	AND p.treatment_id = t.treatment_id
	INNER JOIN c_Treatment_Type tt WITH (NOLOCK)
	ON t.treatment_type = tt.treatment_type
WHERE p.cpr_id = @ps_cpr_id
AND p.encounter_id = @pl_encounter_id
AND p.risk_level > 0

RETURN
END

GO
GRANT SELECT
	ON [dbo].[fn_encounter_risk_level_detail]
	TO [cprsystem]
GO

