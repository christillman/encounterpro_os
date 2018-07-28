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

-- Drop Procedure [dbo].[sp_Order_Treatment_Workplans]
Print 'Drop Procedure [dbo].[sp_Order_Treatment_Workplans]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Order_Treatment_Workplans]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Order_Treatment_Workplans]
GO

-- Create Procedure [dbo].[sp_Order_Treatment_Workplans]
Print 'Create Procedure [dbo].[sp_Order_Treatment_Workplans]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_Order_Treatment_Workplans
	(
	@ps_cpr_id varchar(12),
	@pl_treatment_id int,
	@ps_treatment_type varchar(24),
	@ps_treatment_mode varchar(24) = NULL,
	@pl_ordered_workplan_id int = NULL,
	@pl_followup_workplan_id int = NULL,
	@pl_encounter_id int,
	@ps_description varchar(80),
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24) = NULL,
	@pl_parent_patient_workplan_item_id int = NULL,
	@ps_in_office_flag char(1) = NULL,
	@ps_created_by varchar(24),
	@pl_ordered_patient_workplan_id int OUTPUT,
	@pl_followup_patient_workplan_id int OUTPUT
	)
AS

DECLARE @ls_encounter_status varchar(12),
		@ls_ordered_for varchar(24),
		@ls_office_id varchar(4),
		@ll_count int,
		@ls_max_treatment_mode varchar(24)


SET @ls_ordered_for = COALESCE(@ps_ordered_for, @ps_ordered_by)

IF @pl_ordered_workplan_id <= 0
	SET @pl_ordered_workplan_id = NULL

-- Make sure we have an in_office_flag
IF @ps_in_office_flag IS NULL
	BEGIN
	SELECT @ls_encounter_status = encounter_status
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	
	IF @@ROWCOUNT = 1
		BEGIN
		-- If the associated encounter is open then default the in_office_flag to 'Y'
		IF @ls_encounter_status = 'OPEN'
			SET @ps_in_office_flag = 'Y'
		ELSE
			SET @ps_in_office_flag = 'N'
		END
	ELSE
		BEGIN
		IF @pl_parent_patient_workplan_item_id IS NULL
			SET @ps_in_office_flag = 'N'
		ELSE
			-- Inheriting the in_office_flag from the parent workplan item
			SELECT @ps_in_office_flag = in_office_flag
			FROM p_Patient_WP_Item
			WHERE patient_workplan_item_id = @pl_parent_patient_workplan_item_id
		END
	
	END

IF 	@ps_in_office_flag = 'Y'
	BEGIN
	-- Now order the workplan associated with this treatment
	IF @pl_ordered_workplan_id IS NULL
		BEGIN
		-- If the treatment mode is not supplied then see if there is a default
		
		IF @ps_treatment_mode IS NULL
			BEGIN
			SELECT @ls_office_id = office_id
			FROM p_Treatment_Item
			WHERE cpr_id = @ps_cpr_id
			AND treatment_id = @pl_treatment_id
			
			IF @ls_office_id IS NULL
				SELECT @ls_office_id = office_id
				FROM dbo.fn_current_epro_user_context()
			
			SELECT @ps_treatment_mode = treatment_mode
			FROM o_Treatment_Type_Default_Mode
			WHERE treatment_type = @ps_treatment_type
			AND treatment_key = '!Default'
			AND office_id = @ls_office_id
			
			IF @ps_treatment_mode IS NULL
				BEGIN
				SELECT @ll_count = count(*),
						@ls_max_treatment_mode = max(treatment_mode)
				FROM c_Treatment_Type_Workplan
				WHERE treatment_type = @ps_treatment_type

				IF @ll_count = 1
					SET @ps_treatment_mode = @ls_max_treatment_mode
				END

			IF @ps_treatment_mode IS NOT NULL
				UPDATE p_Treatment_Item
				SET treatment_mode = @ps_treatment_mode
				WHERE cpr_id = @ps_cpr_id
				AND treatment_id = @pl_treatment_id
				
			END
		
		SELECT @pl_ordered_workplan_id = workplan_id
		FROM c_Treatment_Type_Workplan
		WHERE treatment_type = @ps_treatment_type
		AND treatment_mode = @ps_treatment_mode
		END

	IF @pl_ordered_workplan_id IS NULL
		SELECT @pl_ordered_workplan_id = c_Treatment_Type.workplan_id
		FROM c_Treatment_Type
		WHERE treatment_type = @ps_treatment_type

	IF @pl_ordered_workplan_id IS NOT NULL
		EXECUTE sp_Order_Workplan
			@ps_cpr_id = @ps_cpr_id,
			@pl_workplan_id = @pl_ordered_workplan_id,
			@pl_encounter_id = @pl_encounter_id,
			@pl_treatment_id = @pl_treatment_id,
			@ps_description = @ps_description,
			@ps_ordered_by = @ps_ordered_by,
			@ps_ordered_for = @ls_ordered_for,
			@pl_parent_patient_workplan_item_id = @pl_parent_patient_workplan_item_id,
			@ps_created_by = @ps_created_by,
			@ps_dispatch_flag = 'Y' ,
			@pl_patient_workplan_id = @pl_ordered_patient_workplan_id OUTPUT
	END
ELSE
	BEGIN
	-- Order an empty workplan
	EXECUTE sp_Order_Workplan
		@ps_cpr_id = @ps_cpr_id,
		@pl_encounter_id = @pl_encounter_id,
		@pl_treatment_id = @pl_treatment_id,
		@ps_description = @ps_description,
		@ps_ordered_by = @ps_ordered_by,
		@ps_ordered_for = @ls_ordered_for,
		@pl_parent_patient_workplan_item_id = @pl_parent_patient_workplan_item_id,
		@ps_created_by = @ps_created_by,
		@pl_patient_workplan_id = @pl_ordered_patient_workplan_id OUTPUT
	
	-- The order the services for the past treatment
	EXECUTE sp_Order_Past_Treatment_Services
		@pl_patient_workplan_id = @pl_ordered_patient_workplan_id,
		@pl_treatment_id = @pl_treatment_id,
		@ps_ordered_by = @ps_ordered_by,
		@ps_ordered_for = @ls_ordered_for,
		@ps_created_by = @ps_created_by
	END

-- If we didn't specify an ordered_for, then for the followup workplan use the owner of the associated
-- encounter workplan, if any.
IF @ps_ordered_for IS NULL
	BEGIN
	SELECT @ls_ordered_for = w.owned_by
	FROM p_Patient_WP w, p_Patient_Encounter e
	WHERE e.cpr_id = @ps_cpr_id
	AND e.encounter_id = @pl_encounter_id
	AND e.patient_workplan_id = w.patient_workplan_id
	END

-- If there is a followup workplan_id, order it but don't dispatch it
IF @pl_followup_workplan_id IS NOT NULL
	EXECUTE sp_Order_Workplan
		@ps_cpr_id = @ps_cpr_id,
		@pl_workplan_id = @pl_followup_workplan_id,
		@pl_encounter_id = @pl_encounter_id,
		@pl_treatment_id = @pl_treatment_id,
		@ps_description = @ps_description,
		@ps_ordered_by = @ps_ordered_by,
		@ps_ordered_for = @ls_ordered_for,
		@pl_parent_patient_workplan_item_id = @pl_parent_patient_workplan_item_id,
		@ps_created_by = @ps_created_by,
		@ps_dispatch_flag = 'N' ,
		@pl_patient_workplan_id = @pl_followup_patient_workplan_id OUTPUT

GO
GRANT EXECUTE
	ON [dbo].[sp_Order_Treatment_Workplans]
	TO [cprsystem]
GO

