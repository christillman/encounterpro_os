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

-- Drop Procedure [dbo].[sp_local_copy_workplan]
Print 'Drop Procedure [dbo].[sp_local_copy_workplan]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_local_copy_workplan]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_local_copy_workplan]
GO

-- Create Procedure [dbo].[sp_local_copy_workplan]
Print 'Create Procedure [dbo].[sp_local_copy_workplan]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_local_copy_workplan (
	@pl_workplan_id int,
	@ps_new_id varchar(40) = NULL,
	@ps_new_description varchar(80) = NULL )
AS

-- This stored procedure creates a local copy of the specified workplan and returns the new workplan_id
DECLARE @ll_new_workplan_id int,
	@ll_customer_id int,
	@ll_owner_id int,
	@lid_id uniqueidentifier,
	@ll_item_number int,
	@ll_new_item_number int,
	@lid_new_id uniqueidentifier,
	@li_count smallint

IF @ps_new_id IS NULL
	SET @lid_new_id = newid()
ELSE
	SET @lid_new_id = CAST(@ps_new_id AS uniqueidentifier)

SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SELECT @ll_owner_id = owner_id,
		@lid_id = id,
		@ps_new_description = COALESCE(@ps_new_description, description)
FROM c_Workplan
WHERE workplan_id = @pl_workplan_id

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('No such workplan (%d)',16,-1, @pl_workplan_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- If the new workplan is a local version of the old workplan, then make sure the old workplan isn't already locally owned
IF @lid_id = @lid_new_id AND @ll_owner_id = @ll_customer_id
	BEGIN
	RAISERROR ('Workplan is already locally owned (%d)',16,-1, @pl_workplan_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Make sure there aren't any other workplans out there with this id and owner combo
SELECT @li_count = count(*)
FROM c_Workplan
WHERE id = @lid_new_id
AND owner_id = @ll_customer_id

IF @li_count > 0
	BEGIN
	RAISERROR ('Locally owned workplan already exists (%d)',16,-1, @pl_workplan_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

BEGIN TRANSACTION

INSERT INTO c_Workplan (
	workplan_type,
	treatment_type,
	in_office_flag,
	assessment_id,
	procedure_id,
	description,
	encounter_description_flag,
	specialty_id,
	owner_id,
	last_updated,
	id,
	status)
SELECT workplan_type,
	treatment_type,
	in_office_flag,
	assessment_id,
	procedure_id,
	@ps_new_description,
	encounter_description_flag,
	specialty_id,
	@ll_customer_id,
	dbo.get_client_datetime(),
	@lid_new_id,
	'OK'
FROM c_Workplan
WHERE workplan_id = @pl_workplan_id

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

SET @ll_new_workplan_id = SCOPE_IDENTITY()

IF @ll_new_workplan_id <= 0 OR @ll_new_workplan_id IS NULL
	RETURN -1

-- Disable any other copies of this workplan
UPDATE c_Workplan
SET status = 'NA'
WHERE id = @lid_new_id
AND workplan_id <> @ll_new_workplan_id

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Now copy all the workplan details

INSERT INTO c_Workplan_Step (
	[workplan_id] ,
	[step_number] ,
	[room_type] ,
	[description] ,
	[step_delay] ,
	[step_delay_unit] ,
	[delay_from_flag] ,
	[sort_sequence] )
SELECT @ll_new_workplan_id ,
	[step_number] ,
	[room_type] ,
	[description] ,
	[step_delay] ,
	[step_delay_unit] ,
	[delay_from_flag] ,
	[sort_sequence]
FROM c_Workplan_Step
WHERE workplan_id = @pl_workplan_id

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

INSERT INTO c_Workplan_Step_Room (
	[workplan_id] ,
	[step_number] ,
	[office_id] ,
	[room_id] )
SELECT @ll_new_workplan_id ,
	[step_number] ,
	[office_id] ,
	[room_id]
FROM c_Workplan_Step_Room
WHERE workplan_id = @pl_workplan_id

IF @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

DECLARE lc_wpitem CURSOR LOCAL FAST_FORWARD FOR
	SELECT item_number
	FROM c_Workplan_Item
	WHERE workplan_id = @pl_workplan_id

OPEN lc_wpitem

FETCH lc_wpitem INTO @ll_item_number

WHILE @@FETCH_STATUS = 0
	BEGIN

	INSERT INTO c_Workplan_Item (
		[workplan_id] ,
		[step_number] ,
		[item_type] ,
		[ordered_service] ,
		[in_office_flag] ,
		[ordered_treatment_type] ,
		[ordered_workplan_id] ,
		[followup_workplan_id] ,
		[ordered_for] ,
		[description] ,
		[button_title] ,
		[button_help] ,
		[priority] ,
		[sort_sequence] ,
		[step_flag] ,
		[auto_perform_flag] ,
		[cancel_workplan_flag] ,
		[age_range_id] ,
		[sex] ,
		[new_flag] ,
		[workplan_owner] ,
		[abnormal_flag] ,
		[severity] ,
		[consolidate_flag] ,
		[owner_flag] ,
		[runtime_configured_flag] ,
		[modes] ,
		[observation_tag] ,
		[escalation_time] ,
		[escalation_unit_id] ,
		[expiration_time] ,
		[expiration_unit_id] )
	SELECT @ll_new_workplan_id ,
		[step_number] ,
		[item_type] ,
		[ordered_service] ,
		[in_office_flag] ,
		[ordered_treatment_type] ,
		[ordered_workplan_id] ,
		[followup_workplan_id] ,
		[ordered_for] ,
		[description] ,
		[button_title] ,
		[button_help] ,
		[priority] ,
		[sort_sequence] ,
		[step_flag] ,
		[auto_perform_flag] ,
		[cancel_workplan_flag] ,
		[age_range_id] ,
		[sex] ,
		[new_flag] ,
		[workplan_owner] ,
		[abnormal_flag] ,
		[severity] ,
		[consolidate_flag] ,
		[owner_flag] ,
		[runtime_configured_flag] ,
		[modes] ,
		[observation_tag] ,
		[escalation_time] ,
		[escalation_unit_id] ,
		[expiration_time] ,
		[expiration_unit_id] 
	FROM c_Workplan_Item
	WHERE workplan_id = @pl_workplan_id
	AND item_number = @ll_item_number

	IF @@ERROR <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END
	
	SET @ll_new_item_number = SCOPE_IDENTITY()

	INSERT INTO c_Workplan_Item_Attribute (
		[workplan_id] ,
		[item_number] ,
		[attribute],
		[value] )
	SELECT @ll_new_workplan_id ,
		@ll_new_item_number ,
		[attribute],
		[value] 
	FROM c_Workplan_Item_Attribute
	WHERE workplan_id = @pl_workplan_id
	AND item_number = @ll_item_number

	IF @@ERROR <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END
	
	FETCH lc_wpitem INTO @ll_item_number
	END

CLOSE lc_wpitem
DEALLOCATE lc_wpitem

COMMIT TRANSACTION

RETURN @ll_new_workplan_id

GO
GRANT EXECUTE
	ON [dbo].[sp_local_copy_workplan]
	TO [cprsystem]
GO

