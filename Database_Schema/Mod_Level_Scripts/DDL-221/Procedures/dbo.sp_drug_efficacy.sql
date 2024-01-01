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
FROM p_Treatment_Item t
JOIN p_Assessment_Treatment x ON x.cpr_id = t.cpr_id
	AND x.treatment_id = t.treatment_id
JOIN p_Assessment a ON x.cpr_id = a.cpr_id
	AND x.problem_id = a.problem_id
WHERE t.treatment_type = 'MEDICATION'
AND t.drug_id IS NOT NULL

SELECT DISTINCT m.cpr_id, m.treatment_id, m.drug_id, m.begin_date, m.problem_id, m.assessment_id, count(*) as redrugs
INTO #med_instances_redrug
FROM #med_instances m
JOIN p_Assessment_Treatment x ON x.cpr_id = m.cpr_id
	AND x.problem_id = m.problem_id
JOIN p_Treatment_Item t ON  x.cpr_id = t.cpr_id
	AND x.treatment_id = t.treatment_id
WHERE t.treatment_type = 'MEDICATION'
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
FROM #efficacy_total as m 
	INNER JOIN #efficacy_redrugs as r
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

