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

-- Drop Procedure [dbo].[sp_drug_efficacy]
Print 'Drop Procedure [dbo].[sp_drug_efficacy]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_drug_efficacy]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_drug_efficacy]
GO

-- Create Procedure [dbo].[sp_drug_efficacy]
Print 'Create Procedure [dbo].[sp_drug_efficacy]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_drug_efficacy AS

SELECT DISTINCT t.cpr_id, t.treatment_id, t.drug_id, t.begin_date, a.problem_id, a.assessment_id
INTO #med_instances
FROM p_Treatment_Item t, p_Assessment_Treatment x, p_Assessment a
WHERE x.cpr_id = t.cpr_id
AND x.treatment_id = t.treatment_id
AND x.cpr_id = a.cpr_id
AND x.problem_id = a.problem_id
AND t.treatment_type = 'MEDICATION'
AND t.drug_id IS NOT NULL

SELECT DISTINCT m.cpr_id, m.treatment_id, m.drug_id, m.begin_date, m.problem_id, m.assessment_id, count(*) as redrugs
INTO #med_instances_redrug
FROM #med_instances m, p_Assessment_Treatment x, p_Treatment_Item t
WHERE x.cpr_id = t.cpr_id
AND x.treatment_id = t.treatment_id
AND x.cpr_id = m.cpr_id
AND x.problem_id = m.problem_id
AND t.treatment_type = 'MEDICATION'
AND t.drug_id IS NOT NULL
AND t.begin_date > m.begin_date
GROUP BY m.cpr_id, m.treatment_id, m.drug_id, m.begin_date, m.problem_id, m.assessment_id

SELECT assessment_id, drug_id, CONVERT(numeric, count(*)) as total_instances
INTO #efficacy_total
FROM #med_instances
GROUP BY assessment_id, drug_id

SELECT assessment_id, drug_id, CONVERT(numeric, count(*)) as redrugs
INTO #efficacy_redrugs
FROM #med_instances_redrug
GROUP BY assessment_id, drug_id

SELECT m.assessment_id,
	m.drug_id,
	CASE WHEN r.redrugs IS NULL THEN CONVERT(numeric, 100) ELSE 100.0 - (100.0 * r.redrugs / m.total_instances) END as rating
INTO #efficacy
FROM #efficacy_total as m INNER JOIN #efficacy_redrugs as r
	ON m.assessment_id = r.assessment_id
	AND m.drug_id = r.drug_id
WHERE m.total_instances >= 50

UPDATE r_Assessment_Treatment_Efficacy
SET rating = NULL

UPDATE r_Assessment_Treatment_Efficacy
SET rating = e.rating
FROM #efficacy e
WHERE r_Assessment_Treatment_Efficacy.assessment_id = e.assessment_id
AND r_Assessment_Treatment_Efficacy.treatment_type = 'MEDICATION'
AND r_Assessment_Treatment_Efficacy.treatment_key = e.drug_id

INSERT INTO r_Assessment_Treatment_Efficacy (
	assessment_id,
	treatment_type,
	treatment_key,
	rating)
SELECT assessment_id,
	'MEDICATION',
	drug_id,
	rating
FROM #efficacy e
WHERE NOT EXISTS (
	SELECT *
	FROM r_Assessment_Treatment_Efficacy r
	WHERE r.assessment_id = e.assessment_id
	AND r.treatment_type = 'MEDICATION'
	AND r.treatment_key = e.drug_id )

GO
GRANT EXECUTE
	ON [dbo].[sp_drug_efficacy]
	TO [cprsystem]
GO

