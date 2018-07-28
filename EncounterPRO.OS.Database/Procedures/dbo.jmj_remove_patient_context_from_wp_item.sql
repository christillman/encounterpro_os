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

-- Drop Procedure [dbo].[jmj_remove_patient_context_from_wp_item]
Print 'Drop Procedure [dbo].[jmj_remove_patient_context_from_wp_item]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_remove_patient_context_from_wp_item]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_remove_patient_context_from_wp_item]
GO

-- Create Procedure [dbo].[jmj_remove_patient_context_from_wp_item]
Print 'Create Procedure [dbo].[jmj_remove_patient_context_from_wp_item]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_remove_patient_context_from_wp_item (
	@pl_patient_workplan_item_id int,
	@ps_user_id varchar(24) = '#SYSTEM',
	@ps_created_by varchar(24) = '#SYSTEM')
AS


DECLARE @ls_ordered_service varchar(24),
		@ll_item_number int,
		@li_step_number smallint,
		@ll_patient_workplan_id int,
		@ls_cpr_id varchar(12),
		@ll_encounter_id int,
		@ll_workplan_id int,
		@ls_in_office_flag char(1),
		@ll_actor_id int

IF @pl_patient_workplan_item_id IS NULL
	RETURN 0

SELECT @ll_actor_id = actor_id
FROM c_User
WHERE user_id = @ps_user_id

BEGIN TRANSACTION

-- Get some information from the item table and take a update lock
SELECT @ls_ordered_service = ordered_service,
		@ll_item_number = item_number,
		@li_step_number = step_number,
		@ll_patient_workplan_id = patient_workplan_id,
		@ls_cpr_id = cpr_id,
		@ll_encounter_id = encounter_id,
		@ll_workplan_id = workplan_id,
		@ls_in_office_flag = in_office_flag
FROM p_Patient_WP_Item WITH (UPDLOCK)
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('Cannot find workplan item (%d)',16,-1, @pl_patient_workplan_item_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ll_item_number IS NOT NULL OR @li_step_number IS NOT NULL
	BEGIN
	RAISERROR ('Items ordered as part of a workplan cannot have their patient context removed (%d)',16,-1, @pl_patient_workplan_item_id)
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Remove the patient context from the existing attribute records
UPDATE p_Patient_WP_Item_Attribute
SET cpr_id = NULL,
	patient_workplan_id = 0
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

-- Log the original values in the attributes table before removing them

IF @ll_patient_workplan_id IS NOT NULL
	INSERT INTO p_Patient_WP_Item_Attribute (
		patient_workplan_item_id,
		patient_workplan_id,
		attribute,
		value_short,
		actor_id,
		created_by,
		created)
	VALUES (
		@pl_patient_workplan_item_id,
		0,
		'patient_workplan_id_from_wp_item',
		CAST(@ll_patient_workplan_id AS varchar(20)),
		@ll_actor_id,
		@ps_created_by,
		getdate())

If @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ls_cpr_id IS NOT NULL
	INSERT INTO p_Patient_WP_Item_Attribute (
		patient_workplan_item_id,
		patient_workplan_id,
		attribute,
		value_short,
		actor_id,
		created_by,
		created)
	VALUES (
		@pl_patient_workplan_item_id,
		0,
		'cpr_id_from_wp_item',
		@ls_cpr_id,
		@ll_actor_id,
		@ps_created_by,
		getdate())

If @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ll_encounter_id IS NOT NULL
	INSERT INTO p_Patient_WP_Item_Attribute (
		patient_workplan_item_id,
		patient_workplan_id,
		attribute,
		value_short,
		actor_id,
		created_by,
		created)
	VALUES (
		@pl_patient_workplan_item_id,
		0,
		'encounter_id_from_wp_item',
		CAST(@ll_encounter_id AS varchar(20)),
		@ll_actor_id,
		@ps_created_by,
		getdate())

If @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ll_workplan_id IS NOT NULL
	INSERT INTO p_Patient_WP_Item_Attribute (
		patient_workplan_item_id,
		patient_workplan_id,
		attribute,
		value_short,
		actor_id,
		created_by,
		created)
	VALUES (
		@pl_patient_workplan_item_id,
		0,
		'workplan_id_from_wp_item',
		CAST(@ll_workplan_id AS varchar(20)),
		@ll_actor_id,
		@ps_created_by,
		getdate())

If @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ls_in_office_flag IS NOT NULL
	INSERT INTO p_Patient_WP_Item_Attribute (
		patient_workplan_item_id,
		patient_workplan_id,
		attribute,
		value_short,
		actor_id,
		created_by,
		created)
	VALUES (
		@pl_patient_workplan_item_id,
		0,
		'in_office_flag_from_wp_item',
		@ls_in_office_flag,
		@ll_actor_id,
		@ps_created_by,
		getdate())

If @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Remove the patient context from the workplan item table
UPDATE p_Patient_WP_Item
SET patient_workplan_id = 0,
	cpr_id = NULL,
	encounter_id = NULL,
	workplan_id = 0,
	in_office_flag = 'N'
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

If @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

If @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Rename the patient context attributes in the item attribute table so that they still exist but they
-- won't affect the message anymore.
UPDATE p_Patient_WP_Item_Attribute
SET attribute = attribute + '_original'
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
AND attribute IN ('cpr_id', 'encounter_id', 'problem_id', 'treatment_id', 'message_object', 'context_object', 'in_office_flag')

If @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

-- Add an explicit in_office_flag attribute
INSERT INTO p_Patient_WP_Item_Attribute (
	patient_workplan_item_id,
	patient_workplan_id,
	attribute,
	value_short,
	actor_id,
	created_by,
	created)
VALUES (
	@pl_patient_workplan_item_id,
	0,
	'in_office_flag',
	'N',
	@ll_actor_id,
	@ps_created_by,
	getdate())

If @@ERROR <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

COMMIT TRANSACTION

-- Finally, log the action that just took place
INSERT INTO o_Log (
	severity,
	log_date_time,
	caller,
	script,
	message,
	cpr_id,
	encounter_id,
	patient_workplan_item_id,
	service,
	user_id,
	scribe_user_id)
VALUES (
	'WARNING',
	getdate(),
	'Stored Procedure',
	'jmj_remove_patient_context_from_wp_item',
	'Patient context removed from workplan item',
	@ls_cpr_id,
	@ll_encounter_id,
	@pl_patient_workplan_item_id,
	@ls_ordered_service,
	@ps_user_id,
	@ps_created_by)

GO
GRANT EXECUTE
	ON [dbo].[jmj_remove_patient_context_from_wp_item]
	TO [cprsystem]
GO

