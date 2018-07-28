--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

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
	-- First, update the supervisor user_id if needed
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

