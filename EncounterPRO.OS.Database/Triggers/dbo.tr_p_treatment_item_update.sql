
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_p_treatment_item_update]
Print 'Drop Trigger [dbo].[tr_p_treatment_item_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_treatment_item_update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_treatment_item_update]
GO

-- Create Trigger [dbo].[tr_p_treatment_item_update]
Print 'Create Trigger [dbo].[tr_p_treatment_item_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
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
	JOIN p_Patient_WP  
	ON inserted.cpr_id = p_Patient_WP.cpr_id
	AND inserted.open_encounter_id = p_Patient_WP.encounter_id
	AND inserted.treatment_id = p_Patient_WP.treatment_id
END

IF UPDATE(office_dispense_amount) OR UPDATE( dispense_unit )
BEGIN
	DECLARE @ls_cpr_id varchar(12),
		@ll_treatment_id int

	DECLARE pharmacist_items CURSOR LOCAL STATIC FORWARD_ONLY TYPE_WARNING FOR
	SELECT inserted.cpr_id, inserted.treatment_id
	FROM inserted
	JOIN deleted  
	ON inserted.cpr_id = deleted.cpr_id
	AND inserted.treatment_id = deleted.treatment_id
	WHERE inserted.office_dispense_amount > 0
	AND inserted.dispense_unit IS NOT NULL
	
	OPEN pharmacist_items
	
	FETCH pharmacist_items INTO
		@ls_cpr_id,
		@ll_treatment_id
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXECUTE sp_dispatch_pharmacist_service
			@ps_cpr_id = @ls_cpr_id,
			@pl_treatment_id = @ll_treatment_id
	
		FETCH pharmacist_items INTO
			@ls_cpr_id,
			@ll_treatment_id
	END
	
	CLOSE pharmacist_items
	
	DEALLOCATE pharmacist_items
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
GO

