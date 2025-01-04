
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
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE sp_overdue_vaccines
AS

DECLARE @ll_count int
SELECT @ll_count = count(*)
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

IF @ll_count <> 0
BEGIN
	RAISERROR ('Vaccine Schedule is configured incorrectly', 16, 1 )

	RETURN
END

SELECT @ll_count = count(*)
FROM (SELECT 
	 vs.vaccine_id
	,COUNT( vs.schedule_sequence ) AS cnt_sequence
	,MAX( vs.schedule_sequence) as max_sequence
FROM	c_vaccine_schedule vs WITH (NOLOCK)
GROUP BY
	vs.vaccine_id
HAVING COUNT( vs.schedule_sequence ) <> MAX( vs.schedule_sequence )
) t

IF @ll_count <> 0
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
AND	DATEDIFF (year, p.date_of_birth, dbo.get_client_datetime() ) < 18.0
AND	v.status = 'OK'
AND	vs.schedule_sequence = 1

-- Count how many times each vaccine has been administered

UPDATE t
SET	 vaccine_count = (	
	SELECT COUNT(distinct v.vaccine_id) 
	FROM p_treatment_item pt WITH (NOLOCK)
	JOIN c_vaccine v ON pt.drug_id = v.drug_id
	WHERE t.cpr_id = pt.cpr_id
	AND	t.vaccine_id = v.vaccine_id
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
AND	next_vaccine_due_date <= dbo.get_client_datetime()
ORDER BY
	 next_vaccine_due_date


GO
GRANT EXECUTE
	ON [dbo].[sp_overdue_vaccines]
	TO [cprsystem]
GO

