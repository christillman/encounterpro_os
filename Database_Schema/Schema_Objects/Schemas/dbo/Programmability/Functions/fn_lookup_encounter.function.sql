CREATE FUNCTION fn_lookup_encounter (
	@ps_cpr_id varchar(12),
	@ps_id_domain varchar(40),
	@ps_id varchar(40) )

RETURNS int

AS
BEGIN

DECLARE @ls_cpr_id varchar(12),
		@ll_encounter_id int

SET @ll_encounter_id = NULL

-- Check for hard-coded id_domains
IF @ps_id_domain IN ('jmj_encounter_id', 'encounter_id')
	SELECT @ll_encounter_id = max(encounter_id)
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = CAST(@ps_id AS int)
ELSE IF @ps_id_domain = 'jmj_guid'
	SELECT @ll_encounter_id = max(encounter_id)
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND CAST(id AS varchar(40)) = @ps_id
ELSE
	SELECT @ll_encounter_id = min(encounter_id)
	FROM p_Patient_Encounter_Progress
	WHERE cpr_id = @ps_cpr_id
	AND progress_type = 'ID'
	AND progress_key = @ps_id_domain
	AND progress_value = @ps_id
	AND current_flag = 'Y'

RETURN @ll_encounter_id

END

