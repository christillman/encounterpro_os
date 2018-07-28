CREATE    TRIGGER tr_Patient_WP_Update ON dbo.p_Patient_WP
FOR UPDATE
AS

IF @@ROWCOUNT = 0
	RETURN

-- If the workplan is being converted to out-of-office and the parent
-- workplan item has its step_flag = 'N', then convert the 
-- parent workplan_item to out-of-office as well

IF UPDATE( in_office_flag )
BEGIN
	UPDATE wi
	SET 	in_office_flag = 'N'
	FROM 	p_Patient_WP_item wi
	INNER JOIN inserted i
	ON 	wi.patient_workplan_item_id = i.parent_patient_workplan_item_id
	INNER JOIN deleted d
	ON 	i.patient_workplan_id = d.patient_workplan_id
	WHERE 	i.in_office_flag = 'N'
	AND 	d.in_office_flag = 'Y'
	AND 	wi.step_flag = 'N'
END

IF UPDATE( description )
	BEGIN
	-- If the workplan item description is defined to include the workplan description
	-- then change it when the workplan description changes
	DECLARE  @ls_wp_token varchar(32)
	SET @ls_wp_token = '%WP%'

	UPDATE item
	SET	description = 	CAST (
								STUFF
								(		c.description
									,CHARINDEX(@ls_wp_token, c.description)
									,DATALENGTH(@ls_wp_token)
									,inserted.description
								) AS varchar(80) )
	FROM p_Patient_WP_Item item
		INNER JOIN inserted
		ON inserted.patient_workplan_id = item.patient_workplan_id
		INNER JOIN c_Workplan_Item c
		ON item.workplan_id = c.workplan_id
		AND item.item_number = c.item_number
	WHERE
		CHARINDEX(@ls_wp_token, c.description) > 0

	END

IF UPDATE (owned_by) OR UPDATE( parent_patient_workplan_item_id )
BEGIN
	UPDATE wi
	SET 	owned_by = i.owned_by
	FROM inserted AS i 
	INNER JOIN deleted AS d
	ON 	i.patient_workplan_id = d.patient_workplan_id
	AND	ISNULL( d.owned_by, '^NULL^' )<> i.owned_by
	INNER JOIN p_Patient_WP_Item AS wi
	ON 	i.parent_patient_workplan_item_id = wi.patient_workplan_item_id
	AND 	ISNULL( wi.owned_by, '^NULL^' ) <> i.owned_by
	WHERE	i.parent_patient_workplan_item_id IS NOT NULL
	AND	i.owned_by IS NOT NULL
END



