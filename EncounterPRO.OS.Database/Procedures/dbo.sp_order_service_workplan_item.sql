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

-- Drop Procedure [dbo].[sp_order_service_workplan_item]
Print 'Drop Procedure [dbo].[sp_order_service_workplan_item]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_order_service_workplan_item]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_order_service_workplan_item]
GO

-- Create Procedure [dbo].[sp_order_service_workplan_item]
Print 'Create Procedure [dbo].[sp_order_service_workplan_item]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_order_service_workplan_item
	(
	@ps_cpr_id varchar(12),
	@pl_encounter_id int = NULL,
	@pl_patient_workplan_id int,
	@ps_ordered_service varchar(24),
	@ps_in_office_flag char(1) = NULL,
	@ps_auto_perform_flag char(1) = NULL,
	@ps_observation_tag varchar(12) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24) = NULL,
	@pi_step_number smallint = NULL,
	@ps_created_by varchar(24),
	@pl_patient_workplan_item_id int OUTPUT
	)
AS

DECLARE @ll_workplan_id int,
	@li_count smallint,
	@ls_status varchar(12),
	@ll_encounter_id int,
	@li_last_step_dispatched smallint

SELECT @ll_workplan_id = workplan_id,
	@ll_encounter_id = COALESCE(@pl_encounter_id, encounter_id),
	@li_last_step_dispatched = last_step_dispatched
FROM p_Patient_WP
WHERE patient_workplan_id = @pl_patient_workplan_id

-- If the in_office_flag is not supplied, then inherit from workplan
IF @ps_in_office_flag IS NULL
	SELECT @ps_in_office_flag = in_office_flag
	FROM p_Patient_WP
	WHERE patient_workplan_id = @pl_patient_workplan_id

-- If the ordered_for is not supplied, then inherit from workplan
IF @ps_ordered_for IS NULL
	SELECT @ps_ordered_for = owned_by
	FROM p_Patient_WP
	WHERE patient_workplan_id = @pl_patient_workplan_id

IF @ps_description IS NULL
	SELECT @ps_description = description
	FROM o_Service
	WHERE service = @ps_ordered_service

-- If the workplan is already past the desired step, then set the step number
-- to null so it will get dispatched immediately
IF @li_last_step_dispatched > @pi_step_number
	SET @pi_step_number = NULL

INSERT INTO p_Patient_WP_Item
	(
	cpr_id,
	patient_workplan_id,
	encounter_id,
	workplan_id,
	item_type,
	ordered_service,
	in_office_flag,
	auto_perform_flag,
	observation_tag,
	description,
	ordered_by,
	ordered_for,
	step_number,
	created_by)
VALUES	(
	@ps_cpr_id,
	@pl_patient_workplan_id,
	@ll_encounter_id,
	@ll_workplan_id,
	'Service',
	@ps_ordered_service,
	@ps_in_office_flag,
	@ps_auto_perform_flag,
	@ps_observation_tag,
	@ps_description,
	@ps_ordered_by,
	@ps_ordered_for,
	@pi_step_number,
	@ps_created_by )
IF @@rowcount <> 1
	BEGIN
	RAISERROR ('Could not insert record into p_Patient_WP_Item',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END

SELECT @pl_patient_workplan_item_id = @@identity

IF (@pi_step_number IS NULL) OR (@li_last_step_dispatched IS NULL) OR (@pi_step_number <= @li_last_step_dispatched)
	-- Dispatch workplan item
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
		@ps_cpr_id,
		@pl_patient_workplan_id,
		@pl_patient_workplan_item_id,
		@ll_encounter_id,
		@ps_ordered_by,
		getdate(),
		'DISPATCHED',
		@ps_created_by)


GO
GRANT EXECUTE
	ON [dbo].[sp_order_service_workplan_item]
	TO [cprsystem]
GO

