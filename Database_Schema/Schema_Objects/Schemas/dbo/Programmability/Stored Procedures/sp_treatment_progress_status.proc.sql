CREATE PROCEDURE sp_treatment_progress_status
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@pl_treatment_id int,
	@pl_total_count int OUTPUT,
	@pl_this_encounter_count int OUTPUT
	)
AS

SELECT @pl_total_count = count(*)
FROM p_treatment_Progress p
	INNER JOIN p_treatment_item a
	ON p.cpr_id = a.cpr_id
	AND p.treatment_id = a.treatment_id
	INNER JOIN c_treatment_Type_Progress_Type t
	ON a.treatment_type = t.treatment_type
	AND p.progress_type = t.progress_type
WHERE p.cpr_id = @ps_cpr_id
AND p.treatment_id = @pl_treatment_id

SELECT @pl_this_encounter_count = count(*)
FROM p_treatment_Progress p
	INNER JOIN p_treatment_item a
	ON p.cpr_id = a.cpr_id
	AND p.treatment_id = a.treatment_id
	INNER JOIN c_treatment_Type_Progress_Type t
	ON a.treatment_type = t.treatment_type
	AND p.progress_type = t.progress_type
WHERE p.cpr_id = @ps_cpr_id
AND p.treatment_id = @pl_treatment_id
AND p.encounter_id = @pl_encounter_id

