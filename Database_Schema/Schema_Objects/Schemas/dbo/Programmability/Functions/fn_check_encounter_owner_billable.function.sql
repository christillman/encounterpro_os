CREATE FUNCTION fn_check_encounter_owner_billable (
	@ps_cpr_id varchar(24) ,
	@pl_encounter_id int 
	)
RETURNS varchar(24)
AS
BEGIN
DECLARE @ls_attending_doctor varchar(24)
IF EXISTS(SELECT 1 FROM c_Domain WHERE domain_id = 'BILLING_PROVIDER')
	BEGIN
	SELECT @ls_attending_doctor = attending_doctor
	FROM p_Patient_Encounter (NOLOCK)
	WHERE bill_flag = 'Y'
	AND encounter_status = 'CLOSED'
	AND cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND (
			EXISTS (SELECT 1
					FROM c_Domain
					WHERE domain_id = 'BILLING_PROVIDER'
					AND c_Domain.domain_item = p_Patient_Encounter.attending_doctor)
	    )
	END
ELSE
	SELECT @ls_attending_doctor = attending_doctor
	FROM p_Patient_Encounter (NOLOCK)
	WHERE bill_flag = 'Y'
	AND encounter_status = 'CLOSED'
	AND cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id

RETURN @ls_attending_doctor

END

