CREATE PROCEDURE jmj_patient_checkin (
	@ps_cpr_id varchar(12),
	@ps_encounter_type varchar(24),
	@pdt_encounter_date datetime = NULL,
	@ps_encounter_description varchar(80) = NULL,
	@ps_patient_location varchar(24) = NULL,
	@ps_attending_doctor varchar(24) = NULL,
	@ps_referring_doctor varchar(24) = NULL,
	@ps_admit_reason varchar(24) = NULL,
	@ps_new_flag char(1) = NULL,
	@ps_office_id varchar(4),
	@ps_created_by varchar(24)
)

AS
DECLARE @ll_encounter_id int,
		@ll_patient_workplan_id int,
		@ls_bill_flag char(1),
		@ls_billing_posted char(1),
		@ls_indirect_flag char(1),
		@ls_encounter_status varchar(8),
		@ls_encounter_type_description varchar(80),
		@ls_billing_hold_flag char(1),
		@ls_patient_location varchar(24),
		@ls_next_patient_location varchar(24)

SELECT @ls_bill_flag = bill_flag,
		@ls_indirect_flag = default_indirect_flag,
		@ls_encounter_type_description = description
FROM c_Encounter_Type
WHERE encounter_type = @ps_encounter_type

-- billing posted flag (x -not billed)
SET @ls_billing_posted = CASE @ls_bill_flag WHEN 'Y' THEN 'N' ELSE 'X' END
SET @ls_billing_hold_flag = 'N'

SET @ls_encounter_status = 'OPEN'

IF @pdt_encounter_date IS NULL
	SET @pdt_encounter_date = getdate()

IF @ps_encounter_description IS NULL
	SET @ps_encounter_description = @ls_encounter_type_description

IF @ps_new_flag IS NULL
	SET @ps_new_flag = 'N'

INSERT INTO p_Patient_Encounter (
	cpr_id ,
	encounter_type ,
	encounter_status ,
	encounter_date ,
	encounter_description ,
	patient_location ,
	attending_doctor ,
	referring_doctor ,
	admit_reason ,
	bill_flag ,
	billing_posted ,
	indirect_flag ,
	new_flag ,
	billing_hold_flag ,
	office_id ,
	created_by )
VALUES (
	@ps_cpr_id ,
	@ps_encounter_type ,
	@ls_encounter_status ,
	@pdt_encounter_date ,
	@ps_encounter_description ,
	@ps_patient_location ,
	@ps_attending_doctor ,
	@ps_referring_doctor ,
	@ps_admit_reason ,
	@ls_bill_flag ,
	@ls_billing_posted ,
	@ls_indirect_flag ,
	@ps_new_flag ,
	@ls_billing_hold_flag ,
	@ps_office_id ,
	@ps_created_by )

SET @ll_encounter_id = SCOPE_IDENTITY()

-- Add the "Created" progress record
EXECUTE sp_set_encounter_progress
	@ps_cpr_id = @ps_cpr_id,
	@pl_encounter_id = @ll_encounter_id,
	@ps_progress_type = 'Created',
	@ps_user_id = @ps_created_by,
	@ps_created_by = @ps_created_by

-- Order the encounter workplan
EXECUTE sp_Order_Encounter_Workplan  
	@ps_cpr_id = @ps_cpr_id,   
	@pl_encounter_id = @ll_encounter_id,   
	@ps_ordered_by = @ps_created_by,
	@ps_created_by = @ps_created_by,
	@pl_patient_workplan_id = @ll_patient_workplan_id OUTPUT

-- See if the encounter should be in a room but is waiting on a room-type resolution
SELECT @ls_patient_location = patient_location,
		@ls_next_patient_location = next_patient_location
FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @ll_encounter_id

IF @ls_patient_location IS NULL AND LEFT(@ls_next_patient_location, 1) = '$'
	BEGIN
	SELECT @ls_patient_location = MIN(room_id)
	FROM o_Rooms
	WHERE room_type = @ls_next_patient_location
	AND status = 'OK'
	AND office_id = @ps_office_id
	
	IF @ls_patient_location IS NOT NULL
		BEGIN
		EXECUTE sp_set_encounter_progress
			@ps_cpr_id = @ps_cpr_id,
			@pl_encounter_id = @ll_encounter_id,
			@ps_progress_type = 'Modify',
			@ps_progress_key = 'patient_location',
			@ps_progress = @ls_patient_location,
			@ps_user_id = @ps_created_by,
			@ps_created_by = @ps_created_by
		
		EXECUTE sp_set_encounter_progress
			@ps_cpr_id = @ps_cpr_id,
			@pl_encounter_id = @ll_encounter_id,
			@ps_progress_type = 'Modify',
			@ps_progress_key = 'next_patient_location',
			@ps_progress = NULL,
			@ps_user_id = @ps_created_by,
			@ps_created_by = @ps_created_by
		END


	END



RETURN @ll_encounter_id

