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

-- Drop Trigger [dbo].[tr_Patient_WP_Item_Update]
Print 'Drop Trigger [dbo].[tr_Patient_WP_Item_Update]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_Patient_WP_Item_Update]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_Patient_WP_Item_Update]
GO

-- Create Trigger [dbo].[tr_Patient_WP_Item_Update]
Print 'Create Trigger [dbo].[tr_Patient_WP_Item_Update]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_Patient_WP_Item_Update ON p_Patient_WP_Item
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
			
			IF @ls_new_status IS NOT NULL
				INSERT INTO p_Patient_WP_Item_Progress (
					cpr_id,
					patient_workplan_id,
					patient_workplan_item_id,
					encounter_id,
					user_id,
					progress_date_time,
					progress_type,
					created_by)
				VALUES (
					@ls_cpr_id,
					@ll_patient_workplan_id,
					@ll_patient_workplan_item_id,
					@ll_encounter_id,
					'#SYSTEM',
					getdate(),
					@ls_new_status,
					'#SYSTEM')
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

