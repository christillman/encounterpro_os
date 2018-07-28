CREATE PROCEDURE sp_get_encounters_and_updates_list (
	@ps_cpr_id varchar(12),
	@ps_indirect_flag varchar(12) = NULL)
AS

IF @ps_indirect_flag IS NULL
	SET @ps_indirect_flag = '%'

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
         t.icon as encounter_type_icon
FROM	p_Patient_Encounter e
	LEFT OUTER JOIN c_Encounter_Type t
	ON e.encounter_type = t.encounter_type
	LEFT OUTER JOIN c_User u
	ON e.attending_doctor = u.user_id
	LEFT OUTER JOIN c_Office o
	ON e.office_id = o.office_id
WHERE e.cpr_id = @ps_cpr_id
AND	e.indirect_flag like @ps_indirect_flag
ORDER BY e.encounter_date DESC,   
         e.encounter_id DESC

