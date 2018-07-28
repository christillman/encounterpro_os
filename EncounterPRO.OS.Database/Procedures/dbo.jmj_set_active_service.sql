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

-- Drop Procedure [dbo].[jmj_set_active_service]
Print 'Drop Procedure [dbo].[jmj_set_active_service]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_set_active_service]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_set_active_service]
GO

-- Create Procedure [dbo].[jmj_set_active_service]
Print 'Create Procedure [dbo].[jmj_set_active_service]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_set_active_service (
	@pl_patient_workplan_item_id integer )
AS


DECLARE @ll_patient_workplan_id int ,
		@ls_user_id varchar(24) ,
		@ll_computer_id int ,
		@ls_cpr_id varchar(12) ,
		@ll_encounter_id int ,
		@ls_patient_location varchar(12) ,
		@ls_office_id varchar(4),
		@ll_treatment_id int,
		@ls_observation_id varchar(24),
		@li_result_sequence smallint ,
		@ls_active_service_flag char(1)

SELECT @ls_active_service_flag = CASE WHEN item_type = 'Service' AND status IN ('DISPATCHED', 'STARTED') THEN 'Y' ELSE 'N' END,
		@ll_patient_workplan_id = patient_workplan_id,
		@ls_cpr_id = cpr_id,
		@ll_encounter_id = encounter_id,
		@ll_treatment_id = treatment_id
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @ll_treatment_id IS NULL
	SET @ll_treatment_id = CAST(dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'treatment_id') AS int)

IF @ll_treatment_id IS NULL
	SELECT @ll_treatment_id = treatment_id
	FROM p_Patient_WP
	WHERE patient_workplan_id = @ll_patient_workplan_id


UPDATE p_Patient_WP_Item
SET active_service_flag = @ls_active_service_flag,
	treatment_id = @ll_treatment_id
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

IF @ls_active_service_flag = 'N'
	BEGIN
	DELETE o
	FROM o_Active_Services o
	WHERE o.patient_workplan_item_id = @pl_patient_workplan_item_id
	
	RETURN 0
	END
ELSE
	BEGIN
	SET @ls_user_id = NULL
	SET @ll_computer_id = NULL
	SET @ls_patient_location = NULL
	SET @ls_office_id = NULL
	
	SELECT @ls_user_id = user_id,
			@ll_computer_id = computer_id
	FROM o_User_Service_Lock
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
	
	SELECT @ls_patient_location = patient_location,
			@ls_office_id = office_id
	FROM p_Patient_Encounter
	WHERE cpr_id = @ls_cpr_id
	AND encounter_id = @ll_encounter_id

	IF @ll_treatment_id IS NULL
		BEGIN
		SET @ls_observation_id = NULL
		SET @li_result_sequence = NULL
		END
	ELSE
		BEGIN
		SET @ls_observation_id = CAST(dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'observation_id') AS varchar(24))
		IF @ls_observation_id IS NULL
			SELECT @ls_observation_id = observation_id
			FROM p_Treatment_Item
			WHERE cpr_id = @ls_cpr_id
			AND treatment_id = @ll_treatment_id
		
		IF @ls_observation_id IS NULL
			SET @li_result_sequence = NULL
		ELSE
			BEGIN
			SET @li_result_sequence = CAST(dbo.fn_get_attribute(@pl_patient_workplan_item_id, 'result_sequence') AS smallint)
			
			IF @li_result_sequence IS NULL
				SET @li_result_sequence = CAST(dbo.fn_patient_object_property(@ls_cpr_id, 'Treatment', @ll_treatment_id, 'result_sequence') AS smallint)
			END
		END



	IF EXISTS(SELECT 1 FROM o_Active_Services WHERE patient_workplan_item_id = @pl_patient_workplan_item_id)
		BEGIN
		UPDATE o
		SET patient_workplan_id = i.patient_workplan_id,
			patient_workplan_item_id = i.patient_workplan_item_id,
			in_office_flag = i.in_office_flag,
			cpr_id = i.cpr_id,
			encounter_id = i.encounter_id,
			ordered_service = i.ordered_service,
			followup_workplan_id = i.followup_workplan_id,
			description = i.description,
			ordered_by = i.ordered_by,
			ordered_for = i.ordered_for,
			priority = i.priority,
			dispatch_date = i.dispatch_date,
			owned_by = i.owned_by,
			begin_date = i.begin_date,
			status = i.status,
			room_id = i.room_id,
			escalation_date = i.escalation_date,
			expiration_date = i.expiration_date,
			user_id = @ls_user_id,
			computer_id	= @ll_computer_id,
			patient_location = @ls_patient_location,
			office_id = @ls_office_id,
			treatment_id = @ll_treatment_id,
			observation_id = @ls_observation_id,
			result_sequence = @li_result_sequence
		FROM o_Active_Services o
			INNER JOIN p_Patient_WP_Item i
			ON o.patient_workplan_item_id = i.patient_workplan_item_id
		WHERE i.patient_workplan_item_id = @pl_patient_workplan_item_id
		END
	ELSE
		BEGIN
		INSERT INTO o_Active_Services (
			patient_workplan_id ,
			patient_workplan_item_id ,
			in_office_flag ,
			cpr_id ,
			encounter_id ,
			ordered_service ,
			followup_workplan_id ,
			description ,
			ordered_by ,
			ordered_for ,
			priority ,
			dispatch_date ,
			owned_by ,
			begin_date ,
			status ,
			room_id ,
			escalation_date ,
			expiration_date ,
			user_id ,
			computer_id ,
			patient_location ,
			office_id ,
			treatment_id ,
			observation_id ,
			result_sequence )
		SELECT i.patient_workplan_id ,
			i.patient_workplan_item_id ,
			i.in_office_flag ,
			i.cpr_id ,
			i.encounter_id ,
			i.ordered_service ,
			i.followup_workplan_id ,
			i.description ,
			i.ordered_by ,
			i.ordered_for ,
			i.priority ,
			i.dispatch_date ,
			i.owned_by ,
			i.begin_date ,
			i.status ,
			i.room_id ,
			i.escalation_date ,
			i.expiration_date ,
			@ls_user_id ,
			@ll_computer_id	,
			@ls_patient_location ,
			@ls_office_id ,
			@ll_treatment_id ,
			@ls_observation_id ,
			@li_result_sequence
		FROM p_Patient_WP_Item i
		WHERE i.patient_workplan_item_id = @pl_patient_workplan_item_id
		END
	END


GO
GRANT EXECUTE
	ON [dbo].[jmj_set_active_service]
	TO [cprsystem]
GO

