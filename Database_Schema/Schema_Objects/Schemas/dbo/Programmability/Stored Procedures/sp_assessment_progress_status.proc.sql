CREATE PROCEDURE sp_assessment_progress_status
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@pl_problem_id int,
	@pl_total_count int OUTPUT,
	@pl_this_encounter_count int OUTPUT
	)
AS

DECLARE @prg TABLE (
	progress_type varchar(24) NULL,
	progress_key varchar(40) NULL,
	progress_date_time datetime NULL,
	encounter_id int NULL,
	assessment_progress_sequence int NULL)

INSERT INTO @prg (
	progress_type ,
	progress_key ,
	progress_date_time ,
	encounter_id,
	assessment_progress_sequence)
SELECT p.progress_type ,
	p.progress_key ,
	p.progress_date_time ,
	min(encounter_id) as encounter_id,
	max(p.assessment_progress_sequence) as assessment_progress_sequence
FROM p_Assessment_Progress p
	INNER JOIN p_Assessment a
	ON p.cpr_id = a.cpr_id
	AND p.problem_id = a.problem_id
	AND p.diagnosis_sequence = a.diagnosis_sequence
	INNER JOIN c_Assessment_Type_Progress_Type t
	ON a.assessment_type = t.assessment_type
	AND p.progress_type = t.progress_type
WHERE p.cpr_id = @ps_cpr_id
AND p.problem_id = @pl_problem_id
GROUP BY p.progress_type ,
	p.progress_key ,
	p.progress_date_time

SELECT @pl_total_count = count(*)
FROM @prg t
	INNER JOIN p_Assessment_Progress p
	ON t.assessment_progress_sequence = p.assessment_progress_sequence
WHERE p.cpr_id = @ps_cpr_id
AND p.problem_id = @pl_problem_id
AND (progress_value IS NOT NULL OR progress IS NOT NULL)

SELECT @pl_this_encounter_count = count(*)
FROM @prg t
	INNER JOIN p_Assessment_Progress p
	ON t.assessment_progress_sequence = p.assessment_progress_sequence
WHERE p.cpr_id = @ps_cpr_id
AND p.problem_id = @pl_problem_id
AND t.encounter_id = @pl_encounter_id
AND (progress_value IS NOT NULL OR progress IS NOT NULL)

