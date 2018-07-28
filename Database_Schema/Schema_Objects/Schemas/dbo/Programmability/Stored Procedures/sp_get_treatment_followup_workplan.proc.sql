CREATE PROCEDURE sp_get_treatment_followup_workplan (
	@ps_cpr_id varchar(12),
	@pl_treatment_id integer,
	@pl_encounter_id integer = NULL,
	@ps_ordered_by varchar(24) = NULL,
	@ps_created_by varchar(24) = NULL,
	@ps_workplan_type varchar(12),
	@pl_patient_workplan_id int OUTPUT)
AS

DECLARE @ls_description varchar(80),
		@ls_treatment_type varchar(24),
		@ls_in_office_flag varchar(1)

SELECT @pl_patient_workplan_id = min(patient_workplan_id)
FROM p_Patient_Wp
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id
AND workplan_type = @ps_workplan_type

IF @pl_patient_workplan_id IS NULL
	BEGIN
	SELECT @ls_description = treatment_description,
			@ls_treatment_type = treatment_type
	FROM p_Treatment_Item
	WHERE treatment_id = @pl_treatment_id
	IF @@rowcount <> 1
		BEGIN
		RAISERROR ('No such followup treatment for treatment id (%d)',16,-1, @pl_treatment_id)
		ROLLBACK TRANSACTION
		RETURN
		END

-- Msc Hard coded in_office_flag to 'Y' because followup workplans are always intended
-- to be done when the patient returns to the office
	SET @ls_in_office_flag = 'Y'

-- MSC Removed encounter_id.  Encounter_id will be set when workplan is dispatched.

	INSERT INTO p_Patient_Wp (
		cpr_id,
		workplan_id,
		workplan_type,
		in_office_flag,
		treatment_id,
		description,
		ordered_by,
		created_by )
	VALUES (
		@ps_cpr_id,
		0,
		@ps_workplan_type,
		@ls_in_office_flag,
		@pl_treatment_id,
		@ls_description,
		@ps_created_by,
		@ps_created_by )

	SELECT @pl_patient_workplan_id = @@identity
	END
SELECT @pl_patient_workplan_id

