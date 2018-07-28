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

-- Drop Procedure [dbo].[jmjrpt_patient_pastdue_HM_by_age]
Print 'Drop Procedure [dbo].[jmjrpt_patient_pastdue_HM_by_age]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjrpt_patient_pastdue_HM_by_age]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjrpt_patient_pastdue_HM_by_age]
GO

-- Create Procedure [dbo].[jmjrpt_patient_pastdue_HM_by_age]
Print 'Create Procedure [dbo].[jmjrpt_patient_pastdue_HM_by_age]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE jmjrpt_patient_pastdue_HM_by_age
	@pl_age_range integer
AS
Declare @months varchar(4)
Declare @age_range_control integer
Declare @patient_age_range integer
Declare @cpr_id varchar(12),@billing_id varchar(24),@birth_date datetime,@begin_date datetime
Declare @last_name varchar(40),@first_name varchar(20)
Select @age_range_control = @pl_age_range
-- First get a list of the relevent rules.

DECLARE @tmp_maint_procs TABLE
(	 maintenance_rule_id INT NOT NULL
	,assessment_flag CHAR (1)
	,description VARCHAR (80)
	,interval INT
	,interval_unit VARCHAR (24)
	,warning_days INT
	,cpr_id varchar(12)
	,billing_id varchar(24)
	,last_name varchar(40)
	,first_name varchar(20)
	,schedule_date datetime
	,Due varchar(14)
)
INSERT INTO @tmp_maint_procs
(	 maintenance_rule_id
	,assessment_flag
	,description
	,interval
	,interval_unit
	,warning_days
	,cpr_id
	,billing_id
	,last_name
	,first_name
)
SELECT	 m.maintenance_rule_id
	,m.assessment_flag
	,m.description
	,m.interval
	,m.interval_unit
	,m.warning_days
	,p.cpr_id
	,p.billing_id
	,p.last_name
	,p.first_name
FROM	 p_Patient p WITH (NOLOCK)
	,c_Maintenance_Rule m WITH (NOLOCK)
	,c_Age_Range ar WITH (NOLOCK)
WHERE ar.age_range_id = @age_range_control
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
AND p.patient_status = 'ACTIVE'

-- Delete assessment-based rules where the patient doesn't have any of the listed assessments
DELETE t FROM @tmp_maint_procs t
WHERE assessment_flag = 'Y'
AND NOT EXISTS (SELECT problem_id
			FROM p_Assessment, c_Maintenance_Assessment
			WHERE p_Assessment.cpr_id = t.cpr_id
			AND t.maintenance_rule_id = c_Maintenance_Assessment.maintenance_rule_id
			AND c_Maintenance_Assessment.assessment_id = p_Assessment.assessment_id
			AND ( ( c_Maintenance_Assessment.assessment_current_flag <> 'Y')
				OR (p_Assessment.end_date IS NULL) )
			)

-- Then get a list of the latest performed procedures associated with each rule
DECLARE @tmp_maint_procs_dn TABLE
(	 maintenance_rule_id INT
	,begin_date  datetime
	,cpr_id varchar(12)
)
INSERT INTO @tmp_maint_procs_dn
(	 maintenance_rule_id
	,begin_date
	,cpr_id
)
SELECT
	 m.maintenance_rule_id
	,max(t.begin_date)
	,m.cpr_id
FROM	 @tmp_maint_procs m
	,c_Maintenance_Procedure p WITH (NOLOCK)
	,p_Treatment_Item t WITH (NOLOCK)
WHERE	t.cpr_id = m.cpr_id
AND 	m.maintenance_rule_id = p.maintenance_rule_id
AND 	p.procedure_id = t.procedure_id
AND 	t.treatment_status = 'CLOSED'
GROUP BY
	m.cpr_id,m.maintenance_rule_id

-- Then get a list of the latest performed procedures associated with each rule ('OBSERVATIONS' )
INSERT INTO @tmp_maint_procs_dn
(	 maintenance_rule_id
	,begin_date
	,cpr_id
)
SELECT 	 m.maintenance_rule_id
	,max(t.begin_date)
	,m.cpr_id
FROM	 @tmp_maint_procs m
	,c_Maintenance_Procedure p WITH (NOLOCK)
	,p_Treatment_Item t WITH (NOLOCK)
	,c_Observation o WITH (NOLOCK)
WHERE 	t.cpr_id = m.cpr_id
AND 	m.maintenance_rule_id = p.maintenance_rule_id
AND 	t.observation_id = o.observation_id
AND 	p.procedure_id = o.perform_procedure_id
AND 	t.treatment_status = 'CLOSED'
GROUP BY 
	m.cpr_id,m.maintenance_rule_id

Update @tmp_maint_procs
Set schedule_date = CASE m.interval_unit
			WHEN 'YEAR' THEN dateadd(year,m.interval, t.begin_date)
			WHEN 'MONTH' THEN dateadd(month, m.interval, t.begin_date)
			WHEN 'DAY' THEN dateadd(day,m.interval, t.begin_date)
			END
FROM @tmp_maint_procs m
LEFT OUTER JOIN @tmp_maint_procs_dn t
ON m.maintenance_rule_id = t.maintenance_rule_id
Update @tmp_maint_procs
Set Due = 'Never Done'
Where schedule_date is null
Update @tmp_maint_procs
Set Due = Convert(varchar(10),schedule_date,101)
Where schedule_date is not null
SELECT billing_id AS Bill_ID,
	last_name + ',' + first_name AS Patient,
	description,
	Due
FROM @tmp_maint_procs
Where (schedule_date is null or (DATEDIFF( day, schedule_date, getdate() ) > 0 ))
Order By Patient,description

GO
GRANT EXECUTE
	ON [dbo].[jmjrpt_patient_pastdue_HM_by_age]
	TO [cprsystem]
GO

