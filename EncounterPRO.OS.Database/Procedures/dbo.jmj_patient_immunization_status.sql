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

-- Drop Procedure [dbo].[jmj_patient_immunization_status]
Print 'Drop Procedure [dbo].[jmj_patient_immunization_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_patient_immunization_status]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_patient_immunization_status]
GO

-- Create Procedure [dbo].[jmj_patient_immunization_status]
Print 'Create Procedure [dbo].[jmj_patient_immunization_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_patient_immunization_status (
	@ps_cpr_id varchar(12),
	@pdt_current_date datetime = NULL)

AS

IF @pdt_current_date IS NULL
	SET @pdt_current_date = getdate()


DECLARE @schedule TABLE (
	disease_group varchar(24) NOT NULL,
	disease_id int NOT NULL,
	description varchar(80) NOT NULL,
	disease_group_sort_sequence int NOT NULL,
	disease_sort_sequence int NOT NULL,
	dose_number int NULL,
	dose_date datetime NULL,
	dose_status varchar(24) NOT NULL,
	dose_text varchar(255) NULL)

DECLARE @groups TABLE (
	disease_group varchar(24) NOT NULL,
	disease_id int NOT NULL,
	next_dose_number int NULL,
	last_dose_number int NULL)


INSERT INTO @schedule (
	disease_group ,
	disease_id ,
	description ,
	disease_group_sort_sequence ,
	disease_sort_sequence ,
	dose_number ,
	dose_date ,
	dose_status ,
	dose_text )
SELECT disease_group ,
	disease_id ,
	description ,
	disease_group_sort_sequence ,
	disease_sort_sequence ,
	dose_number ,
	dose_date ,
	dose_status ,
	dose_text
FROM dbo.fn_patient_immunization_schedule(@ps_cpr_id, @pdt_current_date)

INSERT INTO @groups (
	disease_group ,
	disease_id ,
	next_dose_number,
	last_dose_number )
SELECT DISTINCT disease_group ,
	disease_id ,
	1,
	0
FROM @schedule

UPDATE g
SET next_dose_number = x.dose_number
FROM @groups g
	INNER JOIN (SELECT disease_group ,
					disease_id ,
					min(dose_number) as dose_number
				FROM @schedule
				WHERE dose_status IN ('Give Now', 'Projected', 'Ineligible')
				GROUP BY disease_group, disease_id) x
	ON g.disease_group = x.disease_group
	AND g.disease_id = x.disease_id

UPDATE g
SET last_dose_number = x.dose_number
FROM @groups g
	INNER JOIN (SELECT disease_group ,
					disease_id ,
					max(dose_number) as dose_number
				FROM @schedule
				WHERE dose_status = 'Given'
				GROUP BY disease_group, disease_id) x
	ON g.disease_group = x.disease_group
	AND g.disease_id = x.disease_id

SELECT s.disease_group ,
	s.disease_id ,
	s.description ,
	s.disease_group_sort_sequence ,
	s.disease_sort_sequence ,
	s.dose_number ,
	s.dose_date ,
	s.dose_status ,
	s.dose_text
FROM @groups g
	INNER JOIN @schedule s
	ON g.disease_group = s.disease_group
	AND g.disease_id = s.disease_id
	AND g.next_dose_number = s.dose_number
WHERE s.dose_status IN ('Give Now', 'Projected', 'Ineligible')
AND g.next_dose_number > g.last_dose_number
UNION
SELECT s.disease_group ,
	s.disease_id ,
	s.description ,
	s.disease_group_sort_sequence ,
	s.disease_sort_sequence ,
	s.dose_number + 1,
	CAST(NULL as datetime),
	'Completed' ,
	CAST(NULL as varchar(255))
FROM @groups g
	INNER JOIN @schedule s
	ON g.disease_group = s.disease_group
	AND g.disease_id = s.disease_id
	AND g.last_dose_number = s.dose_number
WHERE s.dose_status NOT IN ('Give Now', 'Projected', 'Ineligible')
AND g.next_dose_number <= g.last_dose_number
UNION
SELECT s.disease_group ,
	s.disease_id ,
	s.description ,
	s.disease_group_sort_sequence ,
	s.disease_sort_sequence ,
	s.dose_number ,
	s.dose_date ,
	s.dose_status ,
	s.dose_text
FROM @schedule s
WHERE s.dose_status = 'Ineligible'
UNION
SELECT d.disease_group ,
	0 ,
	d.disease_group ,
	d.sort_sequence ,
	0 ,
	CAST(NULL as int),
	CAST(NULL as datetime),
	'Ineligible' ,
	CAST(NULL as varchar(255))
FROM c_Disease_Group d
WHERE NOT EXISTS (
	SELECT 1
	FROM @schedule s
	WHERE d.disease_group = s.disease_group)


GO
GRANT EXECUTE
	ON [dbo].[jmj_patient_immunization_status]
	TO [cprsystem]
GO

