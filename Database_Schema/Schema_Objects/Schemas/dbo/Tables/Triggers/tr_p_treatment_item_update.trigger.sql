CREATE TRIGGER tr_p_treatment_item_update ON dbo.p_Treatment_Item
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(treatment_description)
BEGIN
	UPDATE p_Patient_WP
	SET description = inserted.treatment_description
	FROM inserted
	WHERE inserted.cpr_id = p_Patient_WP.cpr_id
	AND inserted.open_encounter_id = p_Patient_WP.encounter_id
	AND inserted.treatment_id = p_Patient_WP.treatment_id
END

IF UPDATE( treatment_status ) 
	BEGIN
	UPDATE t
	SET open_flag = CASE WHEN t.treatment_status IN ('CLOSED', 'CANCELLED', 'MODIFIED') THEN 'N' ELSE 'Y' END
	FROM p_Treatment_Item t
		INNER JOIN inserted i
		ON t.cpr_id = i.cpr_id
		AND t.treatment_id = i.treatment_id

	-- Make sure the end_date is populated if the treatment isn't open
	UPDATE t
	SET end_date = COALESCE(t.end_date, t.begin_date)
	FROM p_Treatment_Item t
		INNER JOIN inserted i
		ON t.cpr_id = i.cpr_id
		AND t.treatment_id = i.treatment_id
	WHERE t.open_flag = 'N'
	AND t.end_date IS NULL
	END

IF UPDATE(procedure_id) OR UPDATE(material_id) OR UPDATE(drug_id) OR UPDATE(observation_id) OR UPDATE(treatment_description)
	UPDATE t
	SET treatment_key = CASE t.key_field WHEN 'P' THEN t.procedure_id
												WHEN 'M' THEN CAST(t.material_id AS varchar(40))
												WHEN 'D' THEN t.drug_id
												WHEN 'O' THEN t.observation_id
												ELSE CAST(t.treatment_description AS varchar(40)) END
	FROM p_Treatment_Item t
		INNER JOIN inserted i
		ON t.cpr_id = i.cpr_id
		AND t.treatment_id = i.treatment_id
	WHERE t.treatment_key IS NULL
	OR t.treatment_key <> CASE t.key_field WHEN 'P' THEN t.procedure_id
												WHEN 'M' THEN CAST(t.material_id AS varchar(40))
												WHEN 'D' THEN t.drug_id
												WHEN 'O' THEN t.observation_id
												ELSE CAST(t.treatment_description AS varchar(40)) END

