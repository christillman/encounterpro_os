﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmj_archive_workplan]
Print 'Drop Procedure [dbo].[jmj_archive_workplan]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_archive_workplan]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_archive_workplan]
GO

-- Create Procedure [dbo].[jmj_archive_workplan]
Print 'Create Procedure [dbo].[jmj_archive_workplan]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_archive_workplan (
	@pl_patient_workplan_id int)
AS

IF @pl_patient_workplan_id IS NULL
	BEGIN
	RAISERROR ('patient_workplan_id cannot be NULL',16,-1)
	RETURN
	END

IF @pl_patient_workplan_id IS NULL OR @pl_patient_workplan_id = 0
	BEGIN
	RAISERROR ('Invalid patient_workplan_id (%d)',16,-1, @pl_patient_workplan_id)
	RETURN
	END

DECLARE @ll_wp_records_added int,
		@ll_wp_records_deleted int,
		@ll_item_records_added int,
		@ll_item_records_deleted int,
		@ll_attribute_records_added int,
		@ll_attribute_records_deleted int,
		@ll_progress_records_added int,
		@ll_progress_records_deleted int,
		@ll_error int

DECLARE @wpitems TABLE (
	patient_workplan_item_id int NOT NULL )

INSERT INTO @wpitems (
	patient_workplan_item_id)
SELECT patient_workplan_item_id
FROM p_Patient_WP_Item
WHERE patient_workplan_id = @pl_patient_workplan_id

SELECT @ll_error = @@ERROR, @ll_item_records_added = @@ROWCOUNT
IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

BEGIN TRANSACTION

----------------------------------------------------------------------
-- Workplans
----------------------------------------------------------------------
INSERT INTO p_Patient_WP_Archive (
	[patient_workplan_id] ,
	[cpr_id] ,
	[workplan_id] ,
	[workplan_type] ,
	[in_office_flag] ,
	[mode] ,
	[last_step_dispatched] ,
	[last_step_date] ,
	[encounter_id] ,
	[problem_id] ,
	[treatment_id] ,
	[observation_sequence] ,
	[attachment_id] ,
	[description] ,
	[ordered_by] ,
	[owned_by] ,
	[parent_patient_workplan_item_id] ,
	[status] ,
	[created_by] ,
	[created] ,
	[id] )
SELECT [patient_workplan_id] ,
	[cpr_id] ,
	[workplan_id] ,
	[workplan_type] ,
	[in_office_flag] ,
	[mode] ,
	[last_step_dispatched] ,
	[last_step_date] ,
	[encounter_id] ,
	[problem_id] ,
	[treatment_id] ,
	[observation_sequence] ,
	[attachment_id] ,
	[description] ,
	[ordered_by] ,
	[owned_by] ,
	[parent_patient_workplan_item_id] ,
	[status] ,
	[created_by] ,
	[created] ,
	[id]
FROM p_Patient_WP
WHERE patient_workplan_id = @pl_patient_workplan_id

SELECT @ll_error = @@ERROR, @ll_wp_records_added = @@ROWCOUNT
IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

----------------------------------------------------------------------
-- Workplan Items
----------------------------------------------------------------------
INSERT INTO p_Patient_WP_Item_Archive (
	[patient_workplan_id] ,
	[patient_workplan_item_id] ,
	[cpr_id] ,
	[encounter_id] ,
	[treatment_id] ,
	[workplan_id] ,
	[item_number] ,
	[step_number] ,
	[item_type] ,
	[ordered_service] ,
	[active_service_flag] ,
	[in_office_flag] ,
	[ordered_treatment_type] ,
	[ordered_workplan_id] ,
	[followup_workplan_id] ,
	[description] ,
	[ordered_by] ,
	[ordered_for] ,
	[priority] ,
	[step_flag] ,
	[auto_perform_flag] ,
	[cancel_workplan_flag] ,
	[dispatch_date] ,
	[dispatch_method] ,
	[consolidate_flag] ,
	[owner_flag] ,
	[runtime_configured_flag] ,
	[observation_tag] ,
	[dispatched_patient_workplan_item_id] ,
	[owned_by] ,
	[begin_date] ,
	[end_date] ,
	[escalation_date] ,
	[expiration_date] ,
	[completed_by] ,
	[room_id] ,
	[status] ,
	[retries] ,
	[folder] ,
	[created_by] ,
	[created] ,
	[id] )
SELECT 
	i.patient_workplan_id ,
	i.patient_workplan_item_id ,
	i.cpr_id ,
	i.encounter_id ,
	i.treatment_id ,
	i.workplan_id ,
	i.item_number ,
	i.step_number ,
	i.item_type ,
	i.ordered_service ,
	i.active_service_flag ,
	i.in_office_flag ,
	i.ordered_treatment_type ,
	i.ordered_workplan_id ,
	i.followup_workplan_id ,
	i.description ,
	i.ordered_by ,
	i.ordered_for ,
	i.priority ,
	i.step_flag ,
	i.auto_perform_flag ,
	i.cancel_workplan_flag ,
	i.dispatch_date ,
	i.dispatch_method ,
	i.consolidate_flag ,
	i.owner_flag ,
	i.runtime_configured_flag ,
	i.observation_tag ,
	i.dispatched_patient_workplan_item_id ,
	i.owned_by ,
	i.begin_date ,
	i.end_date ,
	i.escalation_date ,
	i.expiration_date ,
	i.completed_by ,
	i.room_id ,
	i.status ,
	i.retries ,
	i.folder ,
	i.created_by ,
	i.created ,
	i.id
FROM p_Patient_WP_Item i
	INNER JOIN @wpitems t
	ON i.patient_workplan_item_id = t.patient_workplan_item_id

SELECT @ll_error = @@ERROR, @ll_item_records_added = @@ROWCOUNT
IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END


----------------------------------------------------------------------
-- Attributes
----------------------------------------------------------------------
INSERT INTO p_Patient_WP_Item_Attribute_Archive (
	patient_workplan_item_id ,
	attribute_sequence ,
	patient_workplan_id ,
	cpr_id ,
	attribute ,
	value_short ,
	message ,
	actor_id ,
	created_by ,
	created ,
	id )
SELECT 
	a.patient_workplan_item_id ,
	a.attribute_sequence ,
	a.patient_workplan_id ,
	a.cpr_id ,
	a.attribute ,
	a.value_short ,
	a.message ,
	a.actor_id ,
	a.created_by ,
	a.created ,
	a.id 
FROM p_Patient_WP_Item_Attribute a
	INNER JOIN @wpitems t
	ON a.patient_workplan_item_id = t.patient_workplan_item_id

SELECT @ll_error = @@ERROR, @ll_attribute_records_added = @@ROWCOUNT
IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END



----------------------------------------------------------------------
-- Progress
----------------------------------------------------------------------
INSERT INTO p_Patient_WP_Item_Progress_Archive (
	patient_workplan_id ,
	patient_workplan_item_id ,
	patient_workplan_item_prog_id ,
	cpr_id ,
	encounter_id ,
	user_id ,
	progress_date_time ,
	progress_type ,
	created ,
	created_by ,
	id )
SELECT
	p.patient_workplan_id ,
	p.patient_workplan_item_id ,
	p.patient_workplan_item_prog_id ,
	p.cpr_id ,
	p.encounter_id ,
	p.user_id ,
	p.progress_date_time ,
	p.progress_type ,
	p.created ,
	p.created_by ,
	p.id  
FROM p_Patient_WP_Item_Progress p
	INNER JOIN @wpitems t
	ON p.patient_workplan_item_id = t.patient_workplan_item_id

SELECT @ll_error = @@ERROR, @ll_progress_records_added = @@ROWCOUNT
IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END




----------------------------------------------------------------------
-- Now Delete the rows we just archived
----------------------------------------------------------------------

DELETE p
FROM p_Patient_WP_Item_Progress p
	INNER JOIN @wpitems t
	ON p.patient_workplan_item_id = t.patient_workplan_item_id

SELECT @ll_error = @@ERROR, @ll_progress_records_deleted = @@ROWCOUNT
IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

DELETE a
FROM p_Patient_WP_Item_Attribute a
	INNER JOIN @wpitems t
	ON a.patient_workplan_item_id = t.patient_workplan_item_id

SELECT @ll_error = @@ERROR, @ll_attribute_records_deleted = @@ROWCOUNT
IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

DELETE i
FROM p_Patient_WP_Item i
	INNER JOIN @wpitems t
	ON i.patient_workplan_item_id = t.patient_workplan_item_id

SELECT @ll_error = @@ERROR, @ll_item_records_deleted = @@ROWCOUNT
IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END

DELETE FROM p_Patient_WP
WHERE patient_workplan_id = @pl_patient_workplan_id

SELECT @ll_error = @@ERROR, @ll_wp_records_deleted = @@ROWCOUNT
IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN
	END


-- One final check to make sure we added as many records as we deleted before we commit
IF @ll_wp_records_added <> @ll_wp_records_deleted
	BEGIN
	RAISERROR ('Workplan records added to archive did not match deleted records',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

IF @ll_item_records_added <> @ll_item_records_deleted
	BEGIN
	RAISERROR ('Workplan Item records added to archive did not match deleted records',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

IF @ll_attribute_records_added <> @ll_attribute_records_deleted
	BEGIN
	RAISERROR ('Workplan Item Attribute records added to archive did not match deleted records',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

IF @ll_progress_records_added <> @ll_progress_records_deleted
	BEGIN
	RAISERROR ('Workplan Item Progress records added to archive did not match deleted records',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END


COMMIT TRANSACTION

GO
GRANT EXECUTE
	ON [dbo].[jmj_archive_workplan]
	TO [cprsystem]
GO
