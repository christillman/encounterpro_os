CREATE  PROCEDURE [dbo].[jmjfix_modified_med_list]
AS

DECLARE @modified TABLE (
 cpr_id varchar(12) NOT NULL,
 billing_id varchar(24) NULL,
 original_treatment_id int NOT NULL,
 modified_treatment_id int NOT NULL,
 original_date datetime NOT NULL,
 modified_date datetime NOT NULL,
 original_treatment_description varchar(1024) NULL,
 modified_treatment_description varchar(1024) NULL,
 modified_description_count int NULL)

INSERT INTO @modified (
 cpr_id ,
 original_treatment_id ,
 modified_treatment_id ,
 original_date,
 modified_date )
SELECT t1.cpr_id ,
 t2.treatment_id ,
 t1.treatment_id ,
 t2.begin_date,
 t1.begin_date
FROM p_Treatment_Item t1 WITH (NOLOCK)
 INNER JOIN p_Treatment_Item t2 WITH (NOLOCK)
 ON t1.cpr_id = t2.cpr_id
 AND t1.original_treatment_id = t2.treatment_id
WHERE t1.treatment_type = 'MEDICATION'

UPDATE x
SET modified_treatment_description = COALESCE(p.progress_value, CAST(p.progress AS varchar(1024))),
	modified_description_count = y.modified_description_count
FROM @modified x
	INNER JOIN (SELECT cpr_id,
						treatment_id,
						max(treatment_progress_sequence) as treatment_progress_sequence,
						count(treatment_progress_sequence) as modified_description_count
				FROM p_Treatment_Progress WITH (NOLOCK)
				WHERE progress_type = 'Modify'
				AND progress_key = 'treatment_description'
				AND current_flag = 'Y'
				GROUP BY cpr_id, treatment_id) y
	ON x.cpr_id = y.cpr_id
	AND x.modified_treatment_id = y.treatment_id
	INNER JOIN p_Treatment_Progress p WITH (NOLOCK)
	ON x.cpr_id = p.cpr_id
	AND x.modified_treatment_id = p.treatment_id
	AND y.treatment_progress_sequence = p.treatment_progress_sequence

UPDATE x
SET original_treatment_description = COALESCE(p.progress_value, CAST(p.progress AS varchar(1024)))
FROM @modified x
	INNER JOIN (SELECT cpr_id, treatment_id, max(treatment_progress_sequence) as treatment_progress_sequence
				FROM p_Treatment_Progress WITH (NOLOCK)
				WHERE progress_type = 'Modify'
				AND progress_key = 'treatment_description'
				AND current_flag = 'Y'
				GROUP BY cpr_id, treatment_id) y
	ON x.cpr_id = y.cpr_id
	AND x.original_treatment_id = y.treatment_id
	INNER JOIN p_Treatment_Progress p WITH (NOLOCK)
	ON x.cpr_id = p.cpr_id
	AND x.original_treatment_id = p.treatment_id
	AND y.treatment_progress_sequence = p.treatment_progress_sequence

DECLARE @ldt_migration_date datetime

SELECT @ldt_migration_date = max(l.executed_date_time)
FROM c_Database_Script_Log l
	INNER JOIN c_Database_Script s
	ON l.script_id = s.script_id
WHERE s.script_type = 'Migration24'

DECLARE @wrongdesc TABLE (
	cpr_id varchar(12) NOT NULL,
	billing_id varchar(24) NULL,
	treatment_id int NOT NULL,
	begin_date datetime NOT NULL,
	treatment_description varchar(80) NULL,
	common_name varchar(80) NOT NULL,
	left_desc varchar(80) NULL)

IF @ldt_migration_date IS NOT NULL
	INSERT INTO @wrongdesc (
		cpr_id ,
		billing_id ,
		treatment_id ,
		begin_date ,
		treatment_description,
		common_name )
	SELECT t.cpr_id ,
		COALESCE(p.billing_id, t.cpr_id) as billing_id ,
		t.treatment_id ,
		t.begin_date datetime ,
		t.treatment_description ,
		d.common_name
	FROM p_Treatment_Item t WITH (NOLOCK)
		INNER JOIN p_Patient p WITH (NOLOCK)
		ON t.cpr_id = p.cpr_id
		INNER JOIN c_Drug_Definition d WITH (NOLOCK)
		ON t.drug_id = d.drug_id
	WHERE t.treatment_type = 'MEDICATION'
	AND t.treatment_description NOT LIKE d.common_name + '%'
	AND t.begin_date < @ldt_migration_date
	AND ISNULL(t.treatment_status, 'OPEN') <> 'CANCELLED'
	AND d.common_name IS NOT NULL

UPDATE @wrongdesc
SET left_desc = RTRIM(LEFT(treatment_description, CHARINDEX(',', treatment_description) - 1))
WHERE CHARINDEX(',', treatment_description) > 0



-- Get the modified treatments that appear to have the wrong treatment_description, and
-- Add the medication treatments that appear incomplete.
SELECT cpr_id ,
	COALESCE(billing_id, cpr_id) as billing_id ,
	original_treatment_id ,
	modified_treatment_id ,
	original_date ,
	modified_date ,
	original_treatment_description
FROM @modified
WHERE original_treatment_description = modified_treatment_description
AND modified_description_count = 1
UNION
SELECT i.cpr_id ,
	COALESCE(pp.billing_id, i.cpr_id) as billing_id ,
	i.treatment_id as original_treatment_id,
	i.treatment_id as modified_treatment_id,
	begin_date as original_date ,
	begin_date as modified_date ,
	treatment_description as original_treatment_description
FROM p_Treatment_Item i WITH (NOLOCK)
	INNER JOIN p_Patient pp WITH (NOLOCK)
	ON i.cpr_id = pp.cpr_id
WHERE LEN(treatment_description) >= 78
AND PATINDEX('%refill%', treatment_description) = 0
AND refills <> 0
AND treatment_type = 'MEDICATION'
AND NOT EXISTS (
	SELECT 1
	FROM p_Treatment_Progress p WITH (NOLOCK)
	WHERE i.cpr_id = p.cpr_id
	AND i.treatment_id = p.treatment_id
	AND p.progress_type = 'Modify'
	AND p.progress_key = 'treatment_description')
UNION
SELECT w.cpr_id ,
	w.billing_id ,
	w.treatment_id as original_treatment_id,
	w.treatment_id as modified_treatment_id,
	w.begin_date as original_date ,
	w.begin_date as modified_date ,
	w.treatment_description as original_treatment_description
FROM @wrongdesc w
WHERE w.common_name NOT LIKE w.left_desc + '%'
AND NOT EXISTS (
	SELECT 1
	FROM p_Treatment_Progress p WITH (NOLOCK)
	WHERE w.cpr_id = p.cpr_id
	AND w.treatment_id = p.treatment_id
	AND p.progress_type = 'Modify'
	AND p.progress_key = 'treatment_description')

