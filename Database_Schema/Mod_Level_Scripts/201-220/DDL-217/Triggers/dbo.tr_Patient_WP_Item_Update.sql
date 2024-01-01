
DROP TRIGGER [dbo].[tr_Patient_WP_Item_Update]
/****** Object:  Trigger [dbo].[tr_Patient_WP_Item_Update]    Script Date: 14/07/2023 6:42:27 pm ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE TRIGGER [dbo].[tr_Patient_WP_Item_Update] ON [dbo].[p_Patient_WP_Item]
FOR UPDATE 
AS

IF @@ROWCOUNT = 0
	RETURN

IF UPDATE(status) OR UPDATE(item_type ) OR UPDATE(owned_by) OR UPDATE(description)
	BEGIN	
	DECLARE @ll_patient_workplan_item_id int,
			@ls_item_type varchar(12),
			@ls_old_status varchar(12),
			@ls_new_status varchar(12),
			@ls_get_signature varchar(12),
			@ls_get_ordered_for varchar(12),
			@ls_cpr_id varchar(12),
			@ll_patient_workplan_id int,
			@ll_encounter_id int

	DECLARE lc_active_service CURSOR LOCAL FAST_FORWARD FOR
		SELECT i.patient_workplan_item_id, i.item_type, d.status, i.status, i.cpr_id, i.patient_workplan_id, i.encounter_id
		FROM inserted i
			INNER JOIN deleted d
			ON i.patient_workplan_item_id = d.patient_workplan_item_id

	OPEN lc_active_service

	FETCH lc_active_service INTO @ll_patient_workplan_item_id, 
									@ls_item_type, 
									@ls_old_status, 
									@ls_new_status, 
									@ls_cpr_id, 
									@ll_patient_workplan_id, 
									@ll_encounter_id

	WHILE @@FETCH_STATUS = 0
		BEGIN
		
		IF @ls_item_type = 'Document'
			BEGIN
			SET @ls_new_status = NULL
			SET @ls_get_signature = CAST(dbo.fn_workplan_item_attribute_value(@ll_patient_workplan_item_id, 'get_signature') AS varchar(12))
			SET @ls_get_ordered_for = CAST(dbo.fn_workplan_item_attribute_value(@ll_patient_workplan_item_id, 'get_ordered_for') AS varchar(12))

			IF @ls_old_status <> 'Created' and @ls_new_status = 'Created'
				BEGIN
				IF @ls_get_signature = 'No' AND @ls_get_ordered_for = 'No'
					SET @ls_new_status = 'Completed'
				END
			
			IF @ls_old_status <> 'Signed' and @ls_new_status = 'Signed'
				BEGIN
				IF @ls_get_ordered_for = 'No'
					SET @ls_new_status = 'Completed'
				END
			
			-- Commented because the [tr_patient_wp_item_progress_insert] trigger updates this table
			-- including updates of status, resulting in an infinite trigger loop
			-- IF @ls_new_status IS NOT NULL
				--INSERT INTO p_Patient_WP_Item_Progress (
				--	cpr_id,
				--	patient_workplan_id,
				--	patient_workplan_item_id,
				--	encounter_id,
				--	user_id,
				--	progress_date_time,
				--	progress_type,
				--	created_by)
				--VALUES (
				--	@ls_cpr_id,
				--	@ll_patient_workplan_id,
				--	@ll_patient_workplan_item_id,
				--	@ll_encounter_id,
				--	'#SYSTEM',
				--	getdate(),
				--	@ls_new_status,
				--	'#SYSTEM')
			END
		
		IF @ls_item_type = 'Service' AND ISNULL(@ls_old_status, 'Ordered') <> @ls_new_status
			BEGIN
			-- Update the status of the Scheduled Service
			UPDATE s
			SET last_service_date = getdate(),
				last_service_status = @ls_new_status,
				last_successful_date = CASE @ls_new_status WHEN 'Completed' THEN getdate() ELSE s.last_successful_date END
			FROM o_Service_Schedule s
				INNER JOIN inserted i
				ON i.item_number = s.service_sequence
			WHERE i.workplan_id = -1  -- Scheduled Service

			END
		
		EXECUTE jmj_set_active_service
			@pl_patient_workplan_item_id = @ll_patient_workplan_item_id

		FETCH lc_active_service INTO @ll_patient_workplan_item_id, 
										@ls_item_type, 
										@ls_old_status, 
										@ls_new_status, 
										@ls_cpr_id, 
										@ll_patient_workplan_id, 
										@ll_encounter_id
		END

	CLOSE lc_active_service
	DEALLOCATE lc_active_service
	END

/*
	Update the patient WP owner when a WP_item is dispatched and owner_flag is 'Y.  If the
	WOrkplan has been misconfigured and more than 1 record has a flag of 'Y', the MAX subquery
	aritrarily picks the record with the highest patient_workplan_item_id.
*/

IF UPDATE( owned_by ) OR UPDATE( owner_flag )
BEGIN

	UPDATE p_Patient_WP
	SET owned_by = i.owned_by
	FROM	 inserted i
	INNER JOIN deleted d
	ON	i.patient_workplan_item_id = d.patient_workplan_item_id
	AND 	i.owned_by <> ISNULL(  d.owned_by, '^NULL^' )
	INNER JOIN p_Patient_WP
	ON	p_Patient_WP.patient_workplan_id = i.patient_workplan_id
	AND 	ISNULL( p_Patient_WP.owned_by, '^NULL^' ) <> i.owned_by
	WHERE 
		i.owner_flag = 'Y'
	AND 	i.owned_by IS NOT NULL
	AND 	i.patient_workplan_item_id =
			(
				SELECT MAX( i2.patient_workplan_item_id )
				FROM 	 inserted i2
					,deleted d2
				WHERE	i2.patient_workplan_item_id = d2.patient_workplan_item_id
				AND	i2.patient_workplan_id = i.patient_workplan_id
				AND 	ISNULL( d2.owned_by, '^NULL^' ) <>  i2.owned_by
				AND	i2.owner_flag = 'Y'
				AND 	i2.owned_by IS NOT NULL
			)
END

IF UPDATE( expiration_date )
BEGIN
	-- Don't allow an expiration date for messages
	UPDATE wpi
	SET expiration_date = NULL
	FROM p_Patient_WP_Item wpi
		INNER JOIN inserted i
		ON i.patient_workplan_item_id = wpi.patient_workplan_item_id
	WHERE i.item_type = 'Service'
	AND i.ordered_service = 'Message'
	AND i.expiration_date IS NOT NULL
END

GO

ALTER TABLE [dbo].[p_Patient_WP_Item] ENABLE TRIGGER [tr_Patient_WP_Item_Update]
GO


