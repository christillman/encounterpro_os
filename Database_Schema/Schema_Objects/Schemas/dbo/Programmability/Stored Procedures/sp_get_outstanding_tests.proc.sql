CREATE PROCEDURE sp_get_outstanding_tests (
	@ps_observation_type varchar(24) = NULL,
	@ps_treatment_type varchar(24) = NULL,
	@ps_treatment_key varchar(40) = NULL )
AS

IF @ps_treatment_type IS NOT NULL
	select	p.cpr_id,
		p.first_name,
		p.middle_name,
		p.last_name,
		p.billing_id,
		p.primary_provider_id,
		t.treatment_id,
		t.treatment_type,
		t.treatment_description,
		t.attachment_id,
		t.send_out_flag,
		t.begin_date,
		e.attending_doctor as ordered_by,
		t.treatment_status,
		t.end_date,
		u1.color,
		u2.color,
		selected_flag=0,
		t.open_encounter_id,
		COALESCE(e.office_id, p.office_id)
	from p_Treatment_Item t WITH (NOLOCK)
		INNER JOIN p_Patient p WITH (NOLOCK)
		ON t.cpr_id = p.cpr_id
		INNER JOIN p_Patient_Encounter e WITH (NOLOCK)
		ON t.cpr_id = e.cpr_id
		AND t.open_encounter_id = e.encounter_id
		LEFT OUTER JOIN c_User u1 WITH (NOLOCK)
		ON e.attending_doctor = u1.user_id
		LEFT OUTER JOIN c_User u2 WITH (NOLOCK)
		ON p.primary_provider_id = u2.user_id
	WHERE t.treatment_type = @ps_treatment_type
	AND t.open_flag = 'Y'
	AND (@ps_treatment_key IS NULL OR t.treatment_key = @ps_treatment_key)
ELSE
	select	p.cpr_id,
		p.first_name,
		p.middle_name,
		p.last_name,
		p.billing_id,
		p.primary_provider_id,
		t.treatment_id,
		t.treatment_type,
		t.treatment_description,
		t.attachment_id,
		t.send_out_flag,
		t.begin_date,
		e.attending_doctor as ordered_by,
		t.treatment_status,
		t.end_date,
		u1.color,
		u2.color,
		selected_flag=0,
		t.open_encounter_id,
		COALESCE(e.office_id, p.office_id)
	from c_Treatment_Type tt WITH (NOLOCK)
		INNER LOOP JOIN p_Treatment_Item t WITH (NOLOCK)
		ON t.open_flag = 'Y'
		AND t.treatment_type = tt.treatment_type
		INNER JOIN p_Patient p WITH (NOLOCK)
		ON t.cpr_id = p.cpr_id
		INNER JOIN p_Patient_Encounter e WITH (NOLOCK)
		ON t.cpr_id = e.cpr_id
		AND t.open_encounter_id = e.encounter_id
		LEFT OUTER JOIN c_User u1 WITH (NOLOCK)
		ON e.attending_doctor = u1.user_id
		LEFT OUTER JOIN c_User u2 WITH (NOLOCK)
		ON p.primary_provider_id = u2.user_id
	WHERE tt.observation_type = @ps_observation_type

