CREATE TRIGGER tr_p_assessment_insert ON dbo.p_Assessment
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

INSERT INTO p_Assessment_Progress(
	cpr_id,
	problem_id,
	encounter_id,
	user_id,
	progress_date_time,
	diagnosis_sequence,
	progress_type,
	created,
	created_by)
SELECT cpr_id,
	problem_id,
	open_encounter_id,
	diagnosed_by,
	created,
	diagnosis_sequence,
	'Created',
	getdate(),
	created_by
FROM inserted
WHERE diagnosis_sequence = 1
	
UPDATE p
SET assessment_id = i.assessment_id
FROM p_Encounter_Assessment p
	INNER JOIN inserted i
	ON i.cpr_id = p.cpr_id
	AND i.open_encounter_id = p.encounter_id
	AND i.problem_id = p.problem_id
WHERE i.diagnosis_sequence > 1

UPDATE t1
SET current_flag = 'N'
FROM p_Assessment t1
	INNER JOIN inserted t2
	ON t1.cpr_id = t2.cpr_id
	AND t1.problem_id = t2.problem_id
WHERE t1.diagnosis_sequence < t2.diagnosis_sequence

UPDATE a
SET location = a1.location,
	assessment = a.assessment + ' (' + l.description + ')'
FROM p_Assessment a
	INNER JOIN inserted i
	ON a.cpr_id = i.cpr_id
	AND a.problem_id = i.problem_id
	AND a.diagnosis_sequence = i.diagnosis_sequence
	INNER JOIN p_Assessment a1
	ON a1.cpr_id = i.cpr_id
	AND a1.problem_id = i.problem_id
	AND a1.diagnosis_sequence = 1
	INNER JOIN c_Assessment_Definition c
	ON a.assessment_id = c.assessment_id
	INNER JOIN c_Location l
	ON a1.location = l.location
WHERE i.diagnosis_sequence > 1
AND a1.location IS NOT NULL
AND a.location IS NULL
AND c.location_domain IS NOT NULL

UPDATE a
SET acuteness = COALESCE(a.acuteness, c.acuteness)
FROM p_Assessment a
	INNER JOIN inserted i
	ON a.cpr_id = i.cpr_id
	AND a.problem_id = i.problem_id
	AND a.diagnosis_sequence = i.diagnosis_sequence
	INNER JOIN c_Assessment_Definition c
	ON a.assessment_id = c.assessment_id

