
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
SET QUOTED_IDENTIFIER ON
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
		@ls_encounter_status varchar(8),
		@ls_workplan_type varchar(12)

IF @ps_cpr_id IS NULL OR @pl_encounter_id IS NULL
BEGIN
SELECT @ps_cpr_id = cpr_id,
	@pl_encounter_id = encounter_id,
	@ls_workplan_type = workplan_type
FROM p_Patient_Wp
WHERE patient_workplan_id = @pl_patient_workplan_id

IF @ls_workplan_type IS NULL
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

