
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_p_patient_encounter_update]
Print 'Drop Trigger [dbo].[tr_p_patient_encounter_update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_patient_encounter_update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_patient_encounter_update]
GO

-- Create Trigger [dbo].[tr_p_patient_encounter_update]
Print 'Create Trigger [dbo].[tr_p_patient_encounter_update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[tr_p_patient_encounter_update]
    ON [dbo].[p_Patient_Encounter]
    AFTER UPDATE
    AS 
BEGIN
IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_cpr_id varchar(12),
	@ll_encounter_id int,
	@ls_ordered_by varchar(24),
	@ls_ordered_for varchar(24),
	@ll_workplan_id int,
	@ll_patient_workplan_id int,
	@ls_encounter_type varchar(24),
	@ls_encounter_status varchar(8),
	@ls_prev_encounter_status varchar(8),
	@ls_stone_flag char(1),
	@ll_isvalid int,
	@ls_bill_flag char(1),
	@ls_attending_doctor varchar(24),
	@ls_supervising_doctor varchar(24),
	@ls_set_patient_referring_provider varchar(255)


-- Set the room to dirty when the patient leaves

IF UPDATE ( patient_location ) or UPDATE( encounter_status )
BEGIN
	UPDATE r
	SET room_status = 'DIRTY'
	FROM o_Rooms r
		INNER JOIN deleted d
		ON r.room_id = d.patient_location
		INNER JOIN inserted i
		ON i.cpr_id = d.cpr_id
		AND i.encounter_id = d.encounter_id
	WHERE  r.dirty_flag = 'Y'
	AND r.room_status <> 'DIRTY'
	AND
	(		d.patient_location <> i.patient_location
		OR 	d.encounter_status <> i.encounter_status
	)
END

-- Now see if there are any encounters which just changed from Open to not-open
SET @ls_ordered_by = '#SYSTEM'

IF UPDATE( Encounter_status ) 
BEGIN
	DECLARE lc_closed CURSOR LOCAL STATIC FORWARD_ONLY TYPE_WARNING
	FOR
		SELECT 	 i.cpr_id
			,i.encounter_id
			,i.attending_doctor
			,i.encounter_type
			,d.encounter_status
			,i.encounter_status
			,i.patient_workplan_id
			,d.stone_flag
			,t.close_encounter_workplan_id
		FROM 	inserted i
		INNER JOIN deleted d
		ON 	i.cpr_id = d.cpr_id
		AND 	i.encounter_id = d.encounter_id
		LEFT OUTER JOIN c_encounter_type t
		ON	i.encounter_type = t.encounter_type
		
	OPEN lc_closed
	
	FETCH lc_closed
	INTO 
		 @ls_cpr_id
		,@ll_encounter_id
		,@ls_ordered_for
		,@ls_encounter_type
		,@ls_prev_encounter_status
		,@ls_encounter_status
		,@ll_patient_workplan_id
		,@ls_stone_flag
		,@ll_workplan_id
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ls_encounter_status = 'CLOSED' AND @ls_prev_encounter_status = 'OPEN'
		BEGIN
			-- Clear out next patient location when encounter closes
			UPDATE e
			SET next_patient_location = NULL
			FROM p_Patient_Encounter e
			WHERE cpr_id = @ls_cpr_id
			AND encounter_id = @ll_encounter_id

			EXECUTE sp_cancel_in_office_services
				@ps_cpr_id = @ls_cpr_id,
				@pl_encounter_id = @ll_encounter_id,
				@ps_ordered_by = @ls_ordered_by,
				@ps_created_by = @ls_ordered_by
			
			-- See if this just-closed encounter has a close_encounter_workplan_id
			IF @ll_workplan_id IS NOT NULL AND COALESCE(@ls_stone_flag, 'N') <> 'Y'
				BEGIN
				-- If the encounter was just closed and it has a close_encounter_workplan_id,
				-- then order the workplan
				EXECUTE sp_Order_Workplan
					@ps_cpr_id = @ls_cpr_id,
					@pl_workplan_id = @ll_workplan_id,
					@pl_encounter_id = @ll_encounter_id,
					@ps_ordered_by = @ls_ordered_by,
					@ps_ordered_for = @ls_ordered_for,
					@ps_created_by = @ls_ordered_by,
					@pl_patient_workplan_id = @ll_patient_workplan_id OUTPUT
					
				UPDATE p_Patient_Encounter
				SET stone_flag = 'Y'
				WHERE cpr_id = @ls_cpr_id
				AND encounter_id = @ll_encounter_id
				END
		END
		
		-- If the encounter was cancelled, then cancel the encounter objects
		IF @ls_encounter_status = 'CANCELED' AND @ls_prev_encounter_status IN ('OPEN','CLOSED')
			EXECUTE sp_cancel_encounter_objects
				@ps_cpr_id = @ls_cpr_id,
				@pl_encounter_id = @ll_encounter_id,
				@ps_ordered_by = @ls_ordered_by,
				@ps_created_by = @ls_ordered_by
	
		-- If the encounter is being uncancelled, then uncancel the encounter objects
		IF @ls_encounter_status = 'CLOSED' AND @ls_prev_encounter_status = 'CANCELED'
			EXECUTE sp_uncancel_encounter_objects
				@ps_cpr_id = @ls_cpr_id,
				@pl_encounter_id = @ll_encounter_id,
				@ps_ordered_by = @ls_ordered_by,
				@ps_created_by = @ls_ordered_by
		
		FETCH lc_closed 
		INTO 
			 @ls_cpr_id
			,@ll_encounter_id
			,@ls_ordered_for
			,@ls_encounter_type
			,@ls_prev_encounter_status
			,@ls_encounter_status
			,@ll_patient_workplan_id
			,@ls_stone_flag
			,@ll_workplan_id
	END
	
	CLOSE lc_closed
	DEALLOCATE lc_closed
END

-- If the attending doctor gets updated, then check to make sure it's OK
IF UPDATE( attending_doctor ) 
	BEGIN
	-- First, update the supervisor [user_id] if needed
	UPDATE e
	SET supervising_doctor = u.supervisor_user_id
	FROM p_Patient_Encounter e
		INNER JOIN inserted i
		ON e.cpr_id = i.cpr_id
		AND e.encounter_id = i.encounter_id
		INNER JOIN deleted d
		ON e.cpr_id = d.cpr_id
		AND e.encounter_id = d.encounter_id
		INNER JOIN c_User u
		ON i.attending_doctor = u.user_id
	WHERE ISNULL(i.attending_doctor, '<NULL>') <> ISNULL(d.attending_doctor, '<NULL>')

	END	-- IF UPDATE( attending_doctor ) 


UPDATE e
SET encounter_location = u.user_id
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
	INNER JOIN c_User u
	ON e.office_id = u.office_id
	AND u.actor_class = 'Office'
WHERE e.encounter_location IS NULL
AND u.status = 'OK'

UPDATE e
SET indirect_flag = COALESCE(c.default_indirect_flag, 'D')
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
	LEFT OUTER JOIN c_Encounter_Type c
	ON e.encounter_type = c.encounter_type
WHERE e.indirect_flag IS NULL
OR e.indirect_flag = ''

IF UPDATE(referring_doctor)
	BEGIN
	SET @ls_set_patient_referring_provider = dbo.fn_get_preference('PREFERENCES', 'auto_update_referring_provider', NULL, NULL)
	IF LEFT(@ls_set_patient_referring_provider, 1) IN ('T', 'Y')
		BEGIN
		INSERT INTO p_Patient_Progress (
			cpr_id,
			encounter_id,
			user_id,
			progress_date_time,
			progress_type,
			progress_key,
			progress_value,
			created,
			created_by)
		SELECT i.cpr_id,
			i.encounter_id,
			'#SYSTEM',
			getdate(),
			'Modify',
			'referring_provider_id',
			i.referring_doctor,
			getdate(),
			'#SYSTEM'
		FROM inserted i
			INNER JOIN deleted d
			ON i.cpr_id = d.cpr_id
			AND i.encounter_id = d.encounter_id
			INNER JOIN p_Patient p
			ON i.cpr_id = p.cpr_id
		WHERE i.referring_doctor IS NOT NULL
		AND ISNULL(i.referring_doctor, '!NULL') <> ISNULL(d.referring_doctor, '!NULL')
		AND ISNULL(i.referring_doctor, '!NULL') <> ISNULL(p.referring_provider_id, '!NULL')
		END
	END
END
GO

