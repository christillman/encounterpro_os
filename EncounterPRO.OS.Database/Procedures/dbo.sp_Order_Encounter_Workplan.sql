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

-- Drop Procedure [dbo].[sp_Order_Encounter_Workplan]
Print 'Drop Procedure [dbo].[sp_Order_Encounter_Workplan]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Order_Encounter_Workplan]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Order_Encounter_Workplan]
GO

-- Create Procedure [dbo].[sp_Order_Encounter_Workplan]
Print 'Create Procedure [dbo].[sp_Order_Encounter_Workplan]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_Order_Encounter_Workplan (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@ps_ordered_by varchar(24),
	@ps_created_by varchar(24),
	@pl_patient_workplan_id int OUTPUT )
AS

DECLARE @ls_sex char(1),
	@ls_new_flag char(1),
	@ls_encounter_type varchar(24),
	@li_search_order smallint,
	@ll_workplan_id int,
	@ls_description varchar(80),
	@ls_attending_doctor varchar(24),
	@ls_encounter_description_flag char(1),
	@ls_encounter_description varchar(80),
	@ls_service varchar(24),
	@ls_indirect_flag char(1),
	@ll_patient_workplan_item_id int,
	@ls_ordered_for varchar(24),
	@ls_encounter_status varchar(8),
	@ls_preference_value varchar(255),
	@ls_workplan_owner varchar(24),
	@li_count smallint,
	@ldt_date_of_birth datetime,
	@ldt_follwup_cutoff datetime,
	@ls_followup_check_date_range varchar(255),
	@ls_amount varchar(255),
	@ls_unit varchar(255),
	@ll_space int,
	@ll_amount int,
	@ldt_today datetime

-- Get the patient's sex
SELECT @ls_sex = sex,
	@ldt_date_of_birth = date_of_birth
FROM p_Patient
WHERE cpr_id = @ps_cpr_id

-- Get the new_flag
SELECT @ls_new_flag = new_flag,
	@ls_encounter_type = encounter_type,
	@ls_attending_doctor = attending_doctor,
	@ls_encounter_description = encounter_description,
	@ls_encounter_status = encounter_status,
	@ls_indirect_flag = indirect_flag
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

IF @ls_encounter_status = 'OPEN'
	BEGIN
	-- For open encounter, scan the c_Workplan_Selection table
	SELECT @li_search_order = min(search_order)
	FROM c_Workplan_Selection
	WHERE (encounter_type IS NULL OR encounter_type = @ls_encounter_type)
	AND (sex IS NULL OR sex = @ls_sex)
	AND (new_flag IS NULL OR new_flag = @ls_new_flag)
	AND (@ldt_date_of_birth IS NULL OR age_range_id IS NULL OR age_range_id IN (
									SELECT age_range_id
									FROM v_Patient_Age_Ranges
									WHERE v_Patient_Age_Ranges.cpr_id = @ps_cpr_id) )

	SELECT @ll_workplan_id = min(workplan_id)
	FROM c_Workplan_Selection
	WHERE search_order = @li_search_order
	AND (encounter_type IS NULL OR encounter_type = @ls_encounter_type)
	AND (sex IS NULL OR sex = @ls_sex)
	AND (new_flag IS NULL OR new_flag = @ls_new_flag)
	AND (@ldt_date_of_birth IS NULL OR age_range_id IS NULL OR age_range_id IN (
									SELECT age_range_id
									FROM v_Patient_Age_Ranges
									WHERE v_Patient_Age_Ranges.cpr_id = @ps_cpr_id) )
									
	SET @ls_workplan_owner = @ls_attending_doctor
	END
ELSE
	BEGIN
	-- For closed encounters, look up the workplan_id 
	SET @ls_preference_value = dbo.fn_get_preference ('WORKFLOW',
														'past_encounter_workplan_id',
														@ps_ordered_by,
														NULL)
	
	SET @ll_workplan_id = CONVERT(int, @ls_preference_value)
	
	SET @ls_workplan_owner = @ps_ordered_by
	END

IF @ll_workplan_id IS NULL OR @ll_workplan_id <= 0
	BEGIN
	RAISERROR ('Encounter Workplan not found (%s, %d)',16,-1, @ps_cpr_id, @pl_encounter_id)
	ROLLBACK TRANSACTION
	RETURN
	END

-- Get the description and flag
SELECT @ls_description = description,
	@ls_encounter_description_flag = encounter_description_flag
FROM c_Workplan
WHERE workplan_id = @ll_workplan_id

EXECUTE sp_Order_Workplan
	@ps_cpr_id = @ps_cpr_id,
	@pl_workplan_id = @ll_workplan_id,
	@pl_encounter_id = @pl_encounter_id,
	@ps_description = @ls_description,
	@ps_ordered_by = @ps_ordered_by,
	@ps_ordered_for = @ls_workplan_owner,
	@ps_created_by = @ps_created_by,
	@pl_patient_workplan_id = @pl_patient_workplan_id OUTPUT

-- See what service we should use for the followup check service
SET @ls_service = dbo.fn_get_preference ('WORKFLOW',
										'followup_check_service',
										@ps_ordered_by,
										NULL)


-- For direct encounters, see if there are any pending followup workplans
IF @@ROWCOUNT = 1 AND @ls_service IS NOT NULL AND @ls_indirect_flag = 'D'
	BEGIN
	SET @ldt_today = dbo.fn_date_truncate(getdate(), 'Day')

	SET @ldt_follwup_cutoff = NULL

	SET @ls_followup_check_date_range = dbo.fn_get_preference('WORKFLOW', 'followup_check_date_range', DEFAULT, DEFAULT)

	IF @ls_followup_check_date_range IS NOT NULL
		BEGIN
		SET @ll_space = CHARINDEX(' ', @ls_followup_check_date_range) 
		IF @ll_space > 1
			BEGIN
			SET @ls_amount = LEFT(@ls_followup_check_date_range, @ll_space - 1)
			SET @ls_unit = SUBSTRING(@ls_followup_check_date_range, @ll_space + 1, LEN(@ls_followup_check_date_range) - @ll_space)
			IF ISNUMERIC(@ls_amount) = 1 AND LEN(@ls_unit) > 1
				BEGIN
				SET @ll_amount = CAST(@ls_amount AS int)
				SET @ldt_follwup_cutoff = CASE @ls_unit
							WHEN 'YEAR' THEN dateadd(year, -@ll_amount, @ldt_today)
							WHEN 'MONTH' THEN dateadd(month, -@ll_amount, @ldt_today)
							WHEN 'WEEK' THEN dateadd(week, -@ll_amount, @ldt_today)
							WHEN 'DAY' THEN dateadd(day, -@ll_amount, @ldt_today) END
				END
			END
		END

	IF @ldt_follwup_cutoff IS NULL
		SET @ldt_follwup_cutoff = dateadd(day, -30, @ldt_today)


	SELECT @li_count = count(*)
	FROM p_Treatment_Item
	WHERE treatment_type = 'Followup'
	AND open_flag = 'Y'
	AND cpr_id = @ps_cpr_id
	AND ISNULL(CASE duration_unit
			WHEN 'YEAR' THEN dateadd(year, duration_amount, begin_date)
			WHEN 'MONTH' THEN dateadd(month, duration_amount, begin_date)
			WHEN 'WEEK' THEN dateadd(week, duration_amount, begin_date)
			WHEN 'DAY' THEN dateadd(day, duration_amount, begin_date)
			END, begin_date) >= @ldt_follwup_cutoff

	IF @li_count > 0
		BEGIN
		SET @ls_ordered_for = dbo.fn_get_global_preference ('WORKFLOW', 'followup_check_user_id')

		IF @@ROWCOUNT <> 1
			SELECT @ls_ordered_for = NULL

		-- If there are some pending followup workplans, then order a service
		-- to show the pending followup workplans and let the user dispatch them
		EXECUTE sp_order_service_workplan_item
			@ps_cpr_id = @ps_cpr_id,   
			@pl_patient_workplan_id = @pl_patient_workplan_id,
			@ps_ordered_service = @ls_service,
			@ps_in_office_flag = 'Y',
			@ps_ordered_by = @ps_ordered_by,   
			@ps_ordered_for = @ls_ordered_for,   
			@ps_created_by = @ps_created_by,   
			@pl_patient_workplan_item_id = @ll_patient_workplan_item_id OUTPUT

 		EXECUTE sp_add_workplan_item_attribute
			@ps_cpr_id = @ps_cpr_id,   
			@pl_patient_workplan_id = @pl_patient_workplan_id,
			@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,   
			@ps_attribute = 'WORKPLAN_TYPE',   
			@ps_value = 'Followup',   
			@ps_created_by = @ps_created_by

 		EXECUTE sp_add_workplan_item_attribute
			@ps_cpr_id = @ps_cpr_id,   
			@pl_patient_workplan_id = @pl_patient_workplan_id,
			@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,   
			@ps_attribute = 'WORKPLAN_STATUS',
			@ps_value = 'Pending',
			@ps_created_by = @ps_created_by

		END
	END

-- Calculate new encounter_description
IF @ls_description IS NOT NULL
	BEGIN
	-- encounter_description_flag = R (Replace)
	IF @ls_encounter_description_flag = 'R'
		SELECT @ls_encounter_description = @ls_description

	-- encounter_description_flag = A (Append)
	IF @ls_encounter_description_flag = 'A'
		IF @ls_encounter_description IS NULL 
			SELECT @ls_encounter_description = @ls_description
		ELSE
			SELECT @ls_encounter_description = @ls_encounter_description + '; ' + @ls_description
	END


UPDATE p_Patient_Encounter
SET patient_workplan_id = @pl_patient_workplan_id,
	encounter_description = @ls_encounter_description
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

GO
GRANT EXECUTE
	ON [dbo].[sp_Order_Encounter_Workplan]
	TO [cprsystem]
GO

