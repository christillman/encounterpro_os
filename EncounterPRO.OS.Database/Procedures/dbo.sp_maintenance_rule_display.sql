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

-- Drop Procedure [dbo].[sp_maintenance_rule_display]
Print 'Drop Procedure [dbo].[sp_maintenance_rule_display]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_maintenance_rule_display]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_maintenance_rule_display]
GO

-- Create Procedure [dbo].[sp_maintenance_rule_display]
Print 'Create Procedure [dbo].[sp_maintenance_rule_display]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_maintenance_rule_display    Script Date: 11/16/2000 4:13:15 PM ******/
CREATE PROCEDURE sp_maintenance_rule_display (
	@ps_maintenance_rule_type varchar(24) = 'Rule' )
AS

-- First get a list of the primary assessments
SELECT maintenance_rule_id,
	min(assessment_id) as assessment_id,
	min(CONVERT(varchar(80), '')) as description
INTO #tmp_maint_assmnts
FROM c_Maintenance_Assessment
WHERE primary_flag = 'Y'
GROUP BY maintenance_rule_id

INSERT INTO #tmp_maint_assmnts (
	maintenance_rule_id,
	assessment_id,
	description)
SELECT maintenance_rule_id,
	min(assessment_id) as assessment_id,
	min(CONVERT(varchar(80), '')) as description
FROM c_Maintenance_Assessment
WHERE maintenance_rule_id NOT IN (select maintenance_rule_id FROM #tmp_maint_assmnts)
GROUP BY maintenance_rule_id

-- Then update the assessment description
UPDATE #tmp_maint_assmnts
SET description = a.description
FROM c_Assessment_Definition a
WHERE a.assessment_id = #tmp_maint_assmnts.assessment_id

-- Then get a list of the primary procedures
SELECT maintenance_rule_id,
	min(procedure_id) as procedure_id,
	min(CONVERT(varchar(80), '')) as description
INTO #tmp_maint_rprocs
FROM c_Maintenance_procedure
WHERE primary_flag = 'Y'
GROUP BY maintenance_rule_id

INSERT INTO #tmp_maint_rprocs (
	maintenance_rule_id,
	procedure_id,
	description)
SELECT maintenance_rule_id,
	min(procedure_id) as procedure_id,
	min(CONVERT(varchar(80), '')) as description
FROM c_Maintenance_procedure
WHERE maintenance_rule_id NOT IN (select maintenance_rule_id FROM #tmp_maint_rprocs)
GROUP BY maintenance_rule_id

-- Then update the assessment description
UPDATE #tmp_maint_rprocs
SET description = p.description
FROM c_Procedure p
WHERE p.procedure_id = #tmp_maint_rprocs.procedure_id

-- Then get the maintenance rules with the primary assessments and procedures
SELECT m.maintenance_rule_id,
	m.assessment_flag,
	m.sex,
	m.race,
	m.description,
	ar.age_from,
	ar.age_from_unit,
	ar.age_to,
	ar.age_to_unit,
	ar.description as age_range_description,
	m.interval,
	m.interval_unit,
	m.warning_days,
	CASE assessment_flag WHEN 'Y' then a.assessment_id ELSE NULL END as assessment_id,
	CASE assessment_flag WHEN 'Y' then a.description ELSE NULL END as assessment_description,
	p.procedure_id,
	p.description as procedure_description,
	m.age_range_id,
	selected_flag=0,
	m.status
FROM c_Maintenance_Rule m
	INNER JOIN c_Age_Range ar
	ON m.age_range_id = ar.age_range_id
	LEFT OUTER JOIN #tmp_maint_assmnts a
	ON m.maintenance_rule_id = a.maintenance_rule_id
	LEFT OUTER JOIN #tmp_maint_rprocs p
	ON m.maintenance_rule_id = p.maintenance_rule_id
WHERE m.maintenance_rule_type = @ps_maintenance_rule_type

GO
GRANT EXECUTE
	ON [dbo].[sp_maintenance_rule_display]
	TO [cprsystem]
GO

