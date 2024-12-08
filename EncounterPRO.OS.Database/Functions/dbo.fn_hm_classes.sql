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

-- Drop Function [dbo].[fn_hm_classes]
Print 'Drop Function [dbo].[fn_hm_classes]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_hm_classes]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_hm_classes]
GO

-- Create Function [dbo].[fn_hm_classes]
Print 'Create Function [dbo].[fn_hm_classes]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_hm_classes (
	@ps_maintenance_rule_type varchar(24) )

RETURNS @classes TABLE (
	[maintenance_rule_id] [int] NOT NULL,
	[description] [varchar](80) NOT NULL,
	[last_reset] [datetime] NULL,
	[patients] [int] NOT NULL DEFAULT (0),
	[compliant_patients] [int] NOT NULL DEFAULT (0),
	[measured_patients] [int] NOT NULL DEFAULT (0),
	[controlled_patients] [int] NOT NULL DEFAULT (0))

AS
BEGIN

INSERT INTO @classes (
	maintenance_rule_id,
	description,
	last_reset)
SELECT maintenance_rule_id,
	description,
	last_reset
FROM dbo.c_Maintenance_Patient_Class
WHERE (@ps_maintenance_rule_type IS NULL OR maintenance_rule_type = @ps_maintenance_rule_type)

DECLARE @counts TABLE (
	maintenance_rule_id int NOT NULL,
	is_controlled char(1) NOT NULL,
	patient_count int NOT NULL)

INSERT INTO @counts (
	maintenance_rule_id,
	is_controlled,
	patient_count)
SELECT c.maintenance_rule_id,
	c.is_controlled,
	patient_count = count(*)
FROM dbo.p_Maintenance_Class c
	INNER JOIN p_Patient p
	ON c.cpr_id = p.cpr_id
WHERE c.current_flag = 'Y'
AND c.in_class_flag = 'Y'
AND p.patient_status = 'Active'
GROUP BY c.maintenance_rule_id, c.is_controlled

-- Count the total patients as the sum for all three is_controlled states
UPDATE c
SET patients = x.patient_count
FROM @classes c
	INNER JOIN (SELECT maintenance_rule_id, patient_count = sum(patient_count)
		FROM @counts
		GROUP BY maintenance_rule_id) x
	ON c.maintenance_rule_id = x.maintenance_rule_id

-- Count the measured patients as the sum for is_controlled IN ('Y', 'N')
UPDATE c
SET measured_patients = x.patient_count
FROM @classes c
	INNER JOIN (SELECT maintenance_rule_id, patient_count = sum(patient_count)
		FROM @counts
		WHERE is_controlled IN ('Y', 'N')
		GROUP BY maintenance_rule_id) x
	ON c.maintenance_rule_id = x.maintenance_rule_id

-- Count the controlled patients as the count of patients where is_controlled = 'Y'
UPDATE c
SET controlled_patients = x.patient_count
FROM @classes c
	INNER JOIN @counts x
	ON c.maintenance_rule_id = x.maintenance_rule_id
WHERE x.is_controlled = 'Y'

-- Count the compliant patients as the count of patients where on_protocol_flag = 'Y'
UPDATE c
SET compliant_patients = x.patient_count
FROM @classes c
	INNER JOIN (SELECT mc.maintenance_rule_id, patient_count = count(*)
		FROM dbo.p_Maintenance_Class mc
			INNER JOIN p_Patient p
			ON mc.cpr_id = p.cpr_id
		WHERE mc.current_flag = 'Y'
		AND mc.in_class_flag = 'Y'
		AND mc.on_protocol_flag = 'Y'
		AND p.patient_status = 'Active'
		GROUP BY mc.maintenance_rule_id) x
	ON c.maintenance_rule_id = x.maintenance_rule_id



RETURN
END
GO
GRANT SELECT ON [dbo].[fn_hm_classes] TO [cprsystem]
GO

