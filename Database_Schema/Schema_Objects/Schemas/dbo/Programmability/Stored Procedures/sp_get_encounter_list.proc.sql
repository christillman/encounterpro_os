CREATE PROCEDURE sp_get_encounter_list (
	@ps_cpr_id varchar(12),
	@ps_encounter_type varchar(24) = NULL,
	@ps_indirect_flag varchar(12) = NULL,
	@ps_encounter_status varchar(8) = NULL )
AS

IF @ps_encounter_type IS NULL
	SET @ps_encounter_type = '%'

IF @ps_indirect_flag IS NULL
	SET @ps_indirect_flag = '%'

IF @ps_encounter_status IS NULL
	SET @ps_encounter_status = '%'

SELECT e.cpr_id,   
         e.encounter_id,   
         e.encounter_type, 
         e.encounter_status,
         COALESCE(e.encounter_description, t.description) as encounter_description,
         e.encounter_date,
         e.attending_doctor,
         u.user_short_name,
         u.color,
         t.description as encounter_type_description,
         COALESCE(o.description, e.office_id) as office_description,
         selected_flag=0,
         t.icon as encounter_type_icon,
		dbo.fn_patient_object_document_status(e.cpr_id, 'Encounter', e.encounter_id) as document_status
FROM	p_Patient_Encounter e
	LEFT OUTER JOIN c_Encounter_Type t
	ON e.encounter_type = t.encounter_type
	LEFT OUTER JOIN c_User u
	ON e.attending_doctor = u.user_id
	LEFT OUTER JOIN c_Office o
	ON e.office_id = o.office_id
WHERE e.cpr_id = @ps_cpr_id
AND	e.encounter_type like @ps_encounter_type
AND	e.indirect_flag like @ps_indirect_flag
AND	e.encounter_status like @ps_encounter_status
ORDER BY e.encounter_date DESC,   
         e.encounter_id DESC

