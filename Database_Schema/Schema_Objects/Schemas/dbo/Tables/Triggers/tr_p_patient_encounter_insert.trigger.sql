CREATE TRIGGER [dbo].[tr_p_patient_encounter_insert]
    ON [dbo].[p_Patient_Encounter]
    AFTER INSERT
    AS 
BEGIN

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_exclude_role varchar(24),
		@ll_isvalid int,
		@ls_cpr_id varchar(12), 
		@ll_encounter_id int,
		@ls_set_patient_referring_provider varchar(255)

UPDATE e
SET encounter_description = et.description
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
	INNER JOIN c_Encounter_Type et
	ON e.encounter_type = et.encounter_type
WHERE i.encounter_type = i.encounter_description
AND e.encounter_description IS NULL

UPDATE e
SET discharge_date = i.encounter_date
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
WHERE i.encounter_status = 'CLOSED'
AND i.discharge_date IS NULL

UPDATE e
SET attending_doctor = NULL
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
WHERE i.attending_doctor = ''


SET @ls_exclude_role = dbo.fn_get_preference('BILLINGSYSTEM', 'Medicaid No Supervisor Role', NULL, NULL)

UPDATE e
SET supervising_doctor = u.supervisor_user_id
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
	INNER JOIN c_User u
	ON i.attending_doctor = u.user_id
WHERE i.supervising_doctor IS NULL
AND u.supervisor_user_id IS NOT NULL
AND NOT EXISTS (
	SELECT 1
	FROM inserted i
		INNER JOIN c_User_Role r
		ON i.attending_doctor = r.user_id
		INNER JOIN p_Patient_Authority a
		ON i.cpr_id = a.cpr_id
		INNER JOIN c_Authority ca
		ON ca.authority_id = a.authority_id
	WHERE  r.role_id = @ls_exclude_role
	AND a.authority_type = 'PAYOR'
	AND a.authority_sequence = 1
	AND ca.authority_category = 'Medicaid'
	)

UPDATE e
SET encounter_location = u.user_id
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
	INNER JOIN c_User u
	ON e.office_id = u.office_id
	AND u.actor_class = 'Office'
WHERE e.encounter_location IS NULL
AND u.status = 'OK'

UPDATE e
SET indirect_flag = COALESCE(c.default_indirect_flag, 'D')
FROM p_Patient_Encounter e
	INNER JOIN inserted i
	ON e.cpr_id = i.cpr_id
	AND e.encounter_id = i.encounter_id
	LEFT OUTER JOIN c_Encounter_Type c
	ON e.encounter_type = c.encounter_type
WHERE e.indirect_flag IS NULL
OR e.indirect_flag = ''

IF UPDATE(referring_doctor)
	BEGIN
	SET @ls_set_patient_referring_provider = dbo.fn_get_preference('PREFERENCES', 'auto_update_referring_provider', NULL, NULL)
	IF LEFT(@ls_set_patient_referring_provider, 1) IN ('T', 'Y')
		BEGIN
		INSERT INTO p_Patient_Progress (
			cpr_id,
			encounter_id,
			user_id,
			progress_date_time,
			progress_type,
			progress_key,
			progress_value,
			created,
			created_by)
		SELECT i.cpr_id,
			i.encounter_id,
			'#SYSTEM',
			getdate(),
			'Modify',
			'referring_provider_id',
			i.referring_doctor,
			getdate(),
			'#SYSTEM'
		FROM inserted i
			INNER JOIN p_Patient p
			ON i.cpr_id = p.cpr_id
		WHERE i.referring_doctor IS NOT NULL
		AND ISNULL(i.referring_doctor, '!NULL') <> ISNULL(p.referring_provider_id, '!NULL')
		END
	END

END



