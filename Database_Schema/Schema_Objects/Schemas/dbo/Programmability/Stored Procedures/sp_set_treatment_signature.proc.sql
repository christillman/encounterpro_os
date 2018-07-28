CREATE PROCEDURE sp_set_treatment_signature (
	@pl_treatment_id int,
	@pl_attachment_id int )
AS

-- create a new signature record
INSERT INTO p_Treatment_Progress (
	cpr_id,
	encounter_id,
	treatment_id,
	user_id,
	progress_date_time,
	progress_type,
	progress_key,
	attachment_id,
	created,
	created_by )
SELECT 	cpr_id,
	encounter_id,
	@pl_treatment_id,
	attached_by,
	attachment_date,
	'Attachment',
	'Signature',
	@pl_attachment_id,
	attachment_date,
	attached_by
FROM p_Attachment
WHERE attachment_id = @pl_attachment_id

