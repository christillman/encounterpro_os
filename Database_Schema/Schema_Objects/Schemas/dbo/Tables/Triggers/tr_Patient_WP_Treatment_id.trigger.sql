CREATE TRIGGER tr_Patient_WP_Treatment_id ON dbo.p_Patient_WP
FOR INSERT, UPDATE
AS

IF UPDATE( treatment_id )
BEGIN
	UPDATE wp
	SET 	treatment_id = dbo.fn_last_treatment_for_patient(i.cpr_id, i.treatment_id)
	FROM 	p_Patient_WP wp
	INNER JOIN inserted i
	ON 	wp.patient_workplan_id = i.patient_workplan_id
	WHERE i.cpr_id IS NOT NULL
	AND i.treatment_id IS NOT NULL
END

