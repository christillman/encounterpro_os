CREATE PROCEDURE jmj_get_encounter_treatments (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_include_deleted char(1))
AS

DECLARE @ldt_encounter_date datetime

SELECT @ldt_encounter_date = encounter_date
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

SELECT treatment_id
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND (
		open_encounter_id = @pl_encounter_id
	OR	ISNULL(close_encounter_id, 0) = @pl_encounter_id
	OR	(begin_date <= @ldt_encounter_date AND (end_date IS NULL OR end_date > @ldt_encounter_date))
	)
AND NOT (ISNULL(close_encounter_id, 0) = @pl_encounter_id AND ISNULL(treatment_status, 'OPEN') = 'MODIFIED')
AND (@ps_include_deleted = 'Y' OR ISNULL(treatment_status, 'OPEN') <> 'Cancelled')


