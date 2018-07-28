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

-- Drop Procedure [dbo].[sp_overdue_vaccines]
Print 'Drop Procedure [dbo].[sp_overdue_vaccines]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_overdue_vaccines]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_overdue_vaccines]
GO

-- Create Procedure [dbo].[sp_overdue_vaccines]
Print 'Create Procedure [dbo].[sp_overdue_vaccines]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE sp_overdue_vaccines
AS

SELECT DISTINCT
	 1
FROM	c_vaccine_schedule vs WITH (NOLOCK)
INNER JOIN c_vaccine v WITH (NOLOCK)
ON	v.vaccine_id = vs.vaccine_id
WHERE
	v.description IS NULL
OR	v.description = ''
OR	age IS NULL
OR	age <= 0
OR	age_unit IS NULL
OR	age_unit NOT IN ('day', 'd', 'dd' )

IF @@rowcount <> 0
BEGIN
	RAISERROR ('Vaccine Schedule is configured incorrectly', 16, 1 )

	RETURN
END

SELECT 
	 vs.vaccine_id
	,COUNT( vs.schedule_sequence ) AS cnt_sequence
	,MAX( vs.schedule_sequence) as max_sequence
FROM	c_vaccine_schedule vs WITH (NOLOCK)
GROUP BY
	vs.vaccine_id
HAVING COUNT( vs.schedule_sequence ) <> MAX( vs.schedule_sequence )

IF @@rowcount <> 0
BEGIN
	RAISERROR ('Vaccine Sequence must start at 0 and increment by 1', 16, 1 )

	RETURN
END

DECLARE @tmp TABLE
(	 cpr_id VARCHAR (24)
	,date_of_birth DATETIME
	,vaccine_id VARCHAR (24)
	,description VARCHAR (80)
	,vaccine_count INT
	,next_sequence INT
	,next_vaccine_due_date DATETIME
)

-- Get unique list of all applicable vaccines for all active patients under age 18


INSERT INTO @tmp
(	 cpr_id
	,date_of_birth
	,vaccine_id
	,description
)
SELECT
	 p.cpr_id
	,p.date_of_birth
	,v.vaccine_id
	,v.description
FROM
	p_patient p WITH (NOLOCK)
CROSS JOIN c_vaccine_schedule vs WITH (NOLOCK)
INNER JOIN c_vaccine v WITH (NOLOCK)
ON	v.vaccine_id = vs.vaccine_id
WHERE
	p.patient_status = 'ACTIVE'
AND	DATEDIFF (year, p.date_of_birth, getdate() ) < 18.0
AND	v.status = 'OK'
AND	vs.schedule_sequence = 1


-- Count how many times each vaccine has been administered

UPDATE t
SET	 vaccine_count = (	SELECT COUNT( * ) FROM p_treatment_item pt WITH (NOLOCK)
			WHERE
				t.cpr_id = pt.cpr_id
			AND	t.vaccine_id = pt.drug_id
			AND	pt.treatment_type IN( 'IMMUNIZATION', 'PASTIMMUN' )
			AND	ISNULL( pt.treatment_status, 'OPEN' ) <> 'CANCELLED'
		   )
FROM @tmp t

--  determine the next time the vaccine is to be administered
-- If there is no next time, next sequence and date will be NULL

UPDATE t
SET	 next_sequence = vs.schedule_sequence
	,next_vaccine_due_date = DATEADD( day, vs.age, t.date_of_birth )
FROM @tmp t
INNER JOIN c_vaccine_schedule vs WITH (NOLOCK)
ON	vs.vaccine_id = t.vaccine_id
AND	vs.schedule_sequence = t.vaccine_count + 1

-- Get results where there is a "next time" and that "next time is 
-- <= NOW.	

SELECT
	 dbo.fn_pretty_name
		(	last_name
			,first_name
			,middle_name
			,name_suffix
			,name_prefix
			,degree 
		) as patient_name
	,description
	,next_sequence
	,next_vaccine_due_date
FROM @tmp t
INNER JOIN p_patient p WITH (NOLOCK)
ON	p.cpr_id = t.cpr_id
WHERE
	next_sequence IS NOT NULL
AND	next_vaccine_due_date <= getdate()
ORDER BY
	 next_vaccine_due_date


GO
GRANT EXECUTE
	ON [dbo].[sp_overdue_vaccines]
	TO [cprsystem]
GO

