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

-- Drop Procedure [dbo].[sp_set_treatment_followup_workplan_item]
Print 'Drop Procedure [dbo].[sp_set_treatment_followup_workplan_item]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_set_treatment_followup_workplan_item]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_set_treatment_followup_workplan_item]
GO

-- Create Procedure [dbo].[sp_set_treatment_followup_workplan_item]
Print 'Create Procedure [dbo].[sp_set_treatment_followup_workplan_item]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_set_treatment_followup_workplan_item (
	@ps_cpr_id varchar(12) = NULL,
	@pl_encounter_id integer = NULL,
	@pl_patient_workplan_id int,
	@ps_ordered_treatment_type varchar(12),
	@ps_description varchar(80),
	@ps_ordered_by varchar(24),
	@ps_created_by varchar(24),
	@pdt_created datetime = NULL,
	@pl_patient_workplan_item_id int OUTPUT)
AS

DECLARE @lc_in_office_flag char,
		@ll_parent_treatment_id int,
		@ll_new_treatment_id int,
		@ll_problem_id int,
		@ls_progress varchar(40),
		@ldt_treatment_date datetime,
		@ldt_encounter_date datetime,
		@ls_encounter_status varchar(8)

IF @ps_cpr_id IS NULL OR @pl_encounter_id IS NULL
BEGIN
SELECT @ps_cpr_id = cpr_id,
	@pl_encounter_id = encounter_id
FROM p_Patient_Wp
WHERE patient_workplan_id = @pl_patient_workplan_id
IF @@rowcount <> 1
	BEGIN
	RAISERROR ('No such workplan (%d)',16,-1, @pl_patient_workplan_id)
	ROLLBACK TRANSACTION
	RETURN
	END
END

-- Disable because we really don't want anyone passing in the created timestamp
--IF @pdt_created IS NULL
--	SELECT @pdt_created = dbo.get_client_datetime()

SELECT @lc_in_office_flag = in_office_flag
FROM c_Treatment_Type
WHERE treatment_type = @ps_ordered_treatment_type

SELECT @ll_parent_treatment_id = treatment_id
FROM p_Patient_WP
WHERE patient_workplan_id = @pl_patient_workplan_id

SELECT @ll_problem_id = max(problem_id)
FROM p_Assessment_Treatment
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @ll_parent_treatment_id

SELECT @ls_encounter_status = encounter_status,
		@ldt_encounter_date = encounter_date
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

IF @ls_encounter_status = 'OPEN'
	SET @ldt_treatment_date = dbo.get_client_datetime()
ELSE
	SET @ldt_treatment_date = @ldt_encounter_date

-- Instantiate the treatment
INSERT INTO dbo.p_Treatment_Item
           (cpr_id
           ,open_encounter_id
           ,treatment_type
           ,begin_date
           ,treatment_description
           ,parent_treatment_id
           ,ordered_by
           ,created_by)
VALUES
           (@ps_cpr_id
           ,@pl_encounter_id
           ,@ps_ordered_treatment_type
           ,@ldt_treatment_date
           ,@ps_description
           ,@ll_parent_treatment_id
           ,@ps_ordered_by
           ,@ps_created_by)

SET @ll_new_treatment_id = SCOPE_IDENTITY()

-- Add the "Created" progress record
EXECUTE sp_set_treatment_progress
	@ps_cpr_id = @ps_cpr_id,
	@pl_treatment_id = @ll_new_treatment_id,
	@pl_encounter_id = @pl_encounter_id,
	@ps_progress_type = 'Created',
	@ps_user_id = @ps_ordered_by,
	@ps_created_by = @ps_created_by 

-- Associate it with the same assessments as the parent
IF @ll_problem_id IS NOT NULL
	BEGIN
	SET @ls_progress = CAST(@ll_problem_id AS varchar(40))
	EXECUTE sp_set_treatment_progress
		@ps_cpr_id = @ps_cpr_id,
		@pl_treatment_id = @ll_new_treatment_id,
		@pl_encounter_id = @pl_encounter_id,
		@ps_progress_type = 'Assessment',
		@ps_progress_key = 'Associate',
		@ps_progress = @ls_progress,
		@ps_user_id = @ps_ordered_by,
		@ps_created_by = @ps_created_by 
	END

INSERT INTO p_Patient_Wp_Item (
	patient_workplan_id,
	cpr_id,
	encounter_id,
	treatment_id,
	workplan_id,
	step_number,
	item_type,
	ordered_treatment_type,
	in_office_flag,
	ordered_by,
	description,
	created_by,
	created )
VALUES (
	@pl_patient_workplan_id,
	@ps_cpr_id,
	@pl_encounter_id,
	@ll_new_treatment_id,
	0,
	1,
	'Treatment',
	@ps_ordered_treatment_type,
	@lc_in_office_flag,
	@ps_created_by,
	@ps_description,
	@ps_created_by,
	dbo.get_client_datetime() )

IF @@rowcount <> 1
	BEGIN
	RAISERROR ('Insert Failed for adding followup workplan item for (%d)',16,-1, @pl_patient_workplan_id)
	ROLLBACK TRANSACTION
	RETURN
	END

SELECT @pl_patient_workplan_item_id = SCOPE_IDENTITY()

RETURN @ll_new_treatment_id

GO
GRANT EXECUTE
	ON [dbo].[sp_set_treatment_followup_workplan_item]
	TO [cprsystem]
GO

