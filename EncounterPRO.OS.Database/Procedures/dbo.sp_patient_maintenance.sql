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

-- Drop Procedure [dbo].[sp_patient_maintenance]
Print 'Drop Procedure [dbo].[sp_patient_maintenance]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_patient_maintenance]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_patient_maintenance]
GO

-- Create Procedure [dbo].[sp_patient_maintenance]
Print 'Create Procedure [dbo].[sp_patient_maintenance]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_patient_maintenance
(	@ps_cpr_id varchar(12)
)
AS
-- First get a list of the relevent rules.

DECLARE @tmp_maint_procs TABLE
(	 maintenance_rule_id INT NOT NULL
	,assessment_flag CHAR (1)
	,description VARCHAR (80)
	,interval INT
	,interval_unit VARCHAR (24)
	,warning_days INT
)

INSERT INTO @tmp_maint_procs
(	 maintenance_rule_id
	,assessment_flag
	,description
	,interval
	,interval_unit
	,warning_days
)
SELECT	 m.maintenance_rule_id
	,m.assessment_flag
	,m.description
	,m.interval
	,m.interval_unit
	,m.warning_days
FROM	 p_Patient p WITH (NOLOCK)
	,c_Maintenance_Rule m WITH (NOLOCK)
	,c_Age_Range ar WITH (NOLOCK)
WHERE p.cpr_id = @ps_cpr_id
AND (m.sex IS NULL OR p.sex = m.sex)
AND (m.race IS NULL OR p.race = m.race)
AND m.age_range_id = ar.age_range_id
AND getdate() >= CASE ar.age_from_unit
			WHEN 'YEAR' THEN dateadd(year, ar.age_from, p.date_of_birth)
			WHEN 'MONTH' THEN dateadd(month, ar.age_from, p.date_of_birth)
			WHEN 'DAY' THEN dateadd(day, ar.age_from, p.date_of_birth)
			END
AND (ar.age_to IS NULL OR
	getdate() < CASE ar.age_to_unit
			WHEN 'YEAR' THEN dateadd(year, ar.age_to, p.date_of_birth)
			WHEN 'MONTH' THEN dateadd(month, ar.age_to, p.date_of_birth)
			WHEN 'DAY' THEN dateadd(day, ar.age_to, p.date_of_birth)
			END )
AND m.status = 'OK'

-- Delete assessment-based rules where the patient doesn't have any of the listed assessments
DELETE t FROM @tmp_maint_procs t
WHERE assessment_flag = 'Y'
AND NOT EXISTS (SELECT problem_id
			FROM p_Assessment, c_Maintenance_Assessment
			WHERE p_Assessment.cpr_id = @ps_cpr_id
			AND t.maintenance_rule_id = c_Maintenance_Assessment.maintenance_rule_id
			AND c_Maintenance_Assessment.assessment_id = p_Assessment.assessment_id
			AND ( ( c_Maintenance_Assessment.assessment_current_flag <> 'Y')
				OR (p_Assessment.end_date IS NULL) )
			)



-- Then get a list of the latest closed Procedures associated with each rule

DECLARE @tmp_maint_procs_dn TABLE
(	 maintenance_rule_id INT
	,begin_date  datetime
)
INSERT INTO @tmp_maint_procs_dn
(	 maintenance_rule_id
	,begin_date
)
SELECT
	 m.maintenance_rule_id
	,max(t.begin_date)
FROM	 @tmp_maint_procs m
	,c_Maintenance_Procedure p WITH (NOLOCK)
	,p_Treatment_Item t WITH (NOLOCK)
WHERE	t.cpr_id = @ps_cpr_id
AND 	m.maintenance_rule_id = p.maintenance_rule_id
AND 	p.procedure_id = t.procedure_id
AND 	t.treatment_status = 'CLOSED'
GROUP BY
	m.maintenance_rule_id


-- Then get a list of the latest closed Procedures with the same CPT_code 
-- as the Procedure associated with each rule


INSERT INTO @tmp_maint_procs_dn
(	 maintenance_rule_id
	,begin_date
)
SELECT
	 m.maintenance_rule_id
	,max(t.begin_date)
FROM
	p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN c_Procedure c WITH (NOLOCK)
	ON c.procedure_id = t.procedure_id
	INNER JOIN c_procedure c2 WITH (NOLOCK)
	ON c2.cpt_code = c.cpt_code
	AND ISNULL(c2.modifier, '!!') = ISNULL(c.modifier, '!!')
	INNER JOIN c_Maintenance_Procedure p WITH (NOLOCK)
	ON p.procedure_id = c2.procedure_id
	INNER JOIN @tmp_maint_procs m
	ON m.maintenance_rule_id = p.maintenance_rule_id
WHERE	c.cpt_code IS NOT NULL
AND	c.cpt_code <> ''
AND	c2.procedure_id <> c.procedure_id
AND	t.cpr_id = @ps_cpr_id
AND 	t.treatment_status = 'CLOSED'
GROUP BY
	m.maintenance_rule_id

-- Then get a list of the latest closed Perform Procedures associated with each rule

INSERT INTO @tmp_maint_procs_dn
(	 maintenance_rule_id
	,begin_date
)
SELECT 	 m.maintenance_rule_id
	,max(t.begin_date)
FROM	 @tmp_maint_procs m
	,c_Maintenance_Procedure p WITH (NOLOCK)
	,p_Treatment_Item t WITH (NOLOCK)
	,c_Observation o WITH (NOLOCK)
WHERE 	t.cpr_id = @ps_cpr_id
AND 	m.maintenance_rule_id = p.maintenance_rule_id
AND 	t.observation_id = o.observation_id
AND 	p.procedure_id = o.perform_procedure_id
AND 	t.treatment_status = 'CLOSED'
GROUP BY 
	m.maintenance_rule_id


-- Then get a list of the latest closed Perform Procedures with the same CPT_code 
-- as the Perform Procedure associated with each rule

INSERT INTO @tmp_maint_procs_dn
(	 maintenance_rule_id
	,begin_date
)
SELECT 	 m.maintenance_rule_id
		,max(t.begin_date)
FROM
	p_Treatment_Item t WITH (NOLOCK)
	INNER JOIN c_observation o  WITH (NOLOCK)
	ON t.observation_id = o.observation_id
	INNER JOIN c_Procedure c WITH (NOLOCK)
	ON c.procedure_id = o.perform_procedure_id
	INNER JOIN c_procedure c2
	ON c2.cpt_code = c.cpt_code
	INNER JOIN c_Maintenance_Procedure p WITH (NOLOCK)
	ON p.procedure_id = c2.procedure_id
	INNER JOIN @tmp_maint_procs m
	ON m.maintenance_rule_id = p.maintenance_rule_id
WHERE	c.cpt_code IS NOT NULL
AND	c.cpt_code <> ''
AND	c2.procedure_id <> c.procedure_id
AND 	t.cpr_id = @ps_cpr_id
AND 	t.treatment_status = 'CLOSED'
GROUP BY 
	m.maintenance_rule_id



SELECT m.maintenance_rule_id,
	m.assessment_flag,
	m.description,
	m.interval,
	m.interval_unit,
	m.warning_days,
	t.begin_date,
	CASE interval_unit
			WHEN 'YEAR' THEN dateadd(year, m.interval, t.begin_date)
			WHEN 'MONTH' THEN dateadd(month, m.interval, t.begin_date)
			WHEN 'DAY' THEN dateadd(day, m.interval, t.begin_date)
			END as schedule_date,
	1 as status,
	0 as selected_flag

FROM @tmp_maint_procs m
LEFT OUTER JOIN @tmp_maint_procs_dn t
ON m.maintenance_rule_id = t.maintenance_rule_id
GO
GRANT EXECUTE
	ON [dbo].[sp_patient_maintenance]
	TO [cprsystem]
GO

