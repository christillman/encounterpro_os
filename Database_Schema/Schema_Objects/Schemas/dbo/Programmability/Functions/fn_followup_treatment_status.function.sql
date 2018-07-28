CREATE FUNCTION dbo.fn_followup_treatment_status (
	@ps_cpr_id varchar(12),
	@pl_followup_treatment_id int)

RETURNS @treatments TABLE (
	treatment_id int NOT NULL,
	treatment_description varchar(1024) NOT NULL,
	treatment_type varchar(24) NOT NULL,
	treatment_type_description varchar(80) NOT NULL,
	treatment_type_icon varchar(64) NULL,
	treatment_status varchar(12) NOT NULL,
	parent_patient_workplan_item_id int NOT NULL )


AS

BEGIN

-- First get the list of treatment workplan_items in any followup workplans attached to the passed in treatment
DECLARE @ll_items TABLE (
	patient_workplan_item_id int NOT NULL,
	treatment_id int NOT NULL)

INSERT INTO @ll_items (
	patient_workplan_item_id,
	treatment_id)
SELECT i.patient_workplan_item_id,
		i.treatment_id
FROM p_Patient_WP w
	INNER JOIN p_Patient_WP_Item i
	ON i.patient_workplan_id = w.patient_workplan_id
WHERE w.cpr_id = @ps_cpr_id
AND w.treatment_id = @pl_followup_treatment_id
AND ISNULL(w.workplan_type, 'Followup') NOT IN ('Patient', 'Encounter', 'Treatment')
AND ISNULL(i.status, 'OPEN') <> 'CANCELLED'
AND i.item_type = 'Treatment'
AND i.treatment_id > 0

-- Then return the status of each treatment
INSERT INTO @treatments (
	treatment_id ,
	treatment_description ,
	treatment_type ,
	treatment_type_description ,
	treatment_type_icon ,
	treatment_status ,
	parent_patient_workplan_item_id )
SELECT t.treatment_id ,
	t.treatment_description ,
	t.treatment_type ,
	tt.description ,
	tt.icon ,
	ISNULL(t.treatment_status, 'Open') ,
	x.patient_workplan_item_id
FROM @ll_items x
	INNER JOIN p_Treatment_Item t
	ON t.cpr_id = @ps_cpr_id
	AND x.treatment_id = t.treatment_id
	INNER JOIN c_Treatment_Type tt
	ON t.treatment_type = tt.treatment_type

UPDATE x
SET treatment_description = CAST(progress AS varchar(1024))
FROM @treatments x
	INNER JOIN p_Treatment_Progress p
	ON p.cpr_id = @ps_cpr_id
	AND p.treatment_id = x.treatment_id
	AND p.progress_type = 'Modify'
	AND p.progress_key = 'treatment_description'
	AND p.current_flag = 'Y'
	AND p.progress IS NOT NULL

RETURN

END

