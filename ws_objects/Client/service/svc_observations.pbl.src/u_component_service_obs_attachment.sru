$PBExportHeader$u_component_service_obs_attachment.sru
forward
global type u_component_service_obs_attachment from u_component_service
end type
end forward

global type u_component_service_obs_attachment from u_component_service
end type
global u_component_service_obs_attachment u_component_service_obs_attachment

forward prototypes
public function long order_workplan (str_attachment pstr_attachment, long pl_workplan_id)
public function integer xx_do_service ()
end prototypes

public function long order_workplan (str_attachment pstr_attachment, long pl_workplan_id);long ll_patient_workplan_id
string ls_in_office_flag
string ls_mode
long ll_parent_patient_workplan_item_id
string ls_dispatch_flag = "Y"

setnull(ls_in_office_flag)
setnull(ls_mode)
setnull(ll_parent_patient_workplan_item_id)

cprdb.sp_order_workplan( &
		current_patient.cpr_id, &
		pl_workplan_id, &
		encounter_id, &
		pstr_attachment.problem_id, &
		pstr_attachment.treatment_id, &
		pstr_attachment.observation_sequence, &
		pstr_attachment.attachment_id, &
		pstr_attachment.attachment_tag, &
		current_user.user_id, &
		current_user.user_id, &
		ls_in_office_flag, &
		ls_mode, &
		ll_parent_patient_workplan_item_id, &
		current_scribe.user_id, &
		ls_dispatch_flag, &
		ll_patient_workplan_id)
if not cprdb.check() then return -1

return ll_patient_workplan_id



end function

public function integer xx_do_service ();long ll_material_id
string ls_observation_id
blob lbl_attachment
str_attachment lstr_new_attachment
string ls_attachment_object
string ls_date_suffix
string ls_comment_title
string ls_attachment_file
long ll_attachment_id
integer li_sts
str_popup popup
str_popup_return popup_return

ls_date_suffix = "_" + string(today(), "yymmdd")

ls_comment_title = get_attribute("comment_title")
ls_attachment_object = context_object
lstr_new_attachment.cpr_id = current_patient.cpr_id
lstr_new_attachment.encounter_id = long(get_attribute("encounter_id"))
lstr_new_attachment.treatment_id = long(get_attribute("treatment_id"))
lstr_new_attachment.observation_sequence = long(get_attribute("observation_sequence"))
lstr_new_attachment.problem_id = long(get_attribute("problem_id"))

if isnull(ls_attachment_object) then
	if not isnull(lstr_new_attachment.observation_sequence) then
		ls_attachment_object = "observation"
	elseif not isnull(lstr_new_attachment.treatment_id) then
		ls_attachment_object = "treatment"
	elseif not isnull(lstr_new_attachment.problem_id) then
		ls_attachment_object = "assessment"
	elseif not isnull(lstr_new_attachment.encounter_id) then
		ls_attachment_object = "encounter"
	else
		ls_attachment_object = "patient"
	end if
end if


CHOOSE CASE lower(ls_attachment_object)
	CASE "patient"
	CASE "encounter"
		if isnull(lstr_new_attachment.encounter_id) then
			mylog.log(this, "u_component_service_obs_attachment.xx_do_service:0043", "Null encounter_id", 4)
			return -1
		end if
	CASE "treatment"
		if isnull(lstr_new_attachment.treatment_id) then
			mylog.log(this, "u_component_service_obs_attachment.xx_do_service:0048", "Null treatment_id", 4)
			return -1
		end if
	CASE "observation"
		if isnull(lstr_new_attachment.observation_sequence) then
			mylog.log(this, "u_component_service_obs_attachment.xx_do_service:0053", "Null observation_sequence", 4)
			return -1
		end if
	CASE "assessment"
		if isnull(lstr_new_attachment.problem_id) then
			mylog.log(this, "u_component_service_obs_attachment.xx_do_service:0058", "Null problem_id", 4)
			return -1
		end if
	CASE ELSE
		mylog.log(this, "u_component_service_obs_attachment.xx_do_service:0062", "Invalid attachment_object (" + ls_attachment_object + ")", 4)
		return -1
END CHOOSE

ls_observation_id = get_attribute("observation_id")
if isnull(ls_observation_id) then
	mylog.log(this, "u_component_service_obs_attachment.xx_do_service:0068", "No observation_id", 4)
	return -1
end if

ll_material_id = datalist.observation_material_id(ls_observation_id)
if isnull(ll_material_id) then
	openwithparm(w_pop_message, "Observation does not have an associated document")
	return 2
end if


if isnull(ls_comment_title) then
	// If we don't have a comment_title then use the material description
	SELECT title
	INTO :ls_comment_title
	FROM c_Patient_Material
	WHERE material_id = :ll_material_id;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		log.log(this, "u_component_service_obs_attachment.xx_do_service:0087", "Material_id not found (" + string(ll_material_id) + ")", 4)
		return -1
	end if
	
	add_attribute("comment_title", ls_comment_title)
end if

SELECTBLOB object
INTO :lbl_attachment
FROM c_Patient_Material
WHERE material_id = :ll_material_id
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_service_obs_attachment.xx_do_service:0101", "material_id not found (" + string(ll_material_id) + ")", 4)
	return -1
end if

SELECT extension
INTO :lstr_new_attachment.extension
FROM c_Patient_Material
WHERE material_id = :ll_material_id
USING cprdb;
if not cprdb.check() then return -1
if cprdb.sqlcode = 100 then
	mylog.log(this, "u_component_service_obs_attachment.xx_do_service:0112", "material_id not found (" + string(ll_material_id) + ")", 4)
	return -1
end if

if isnull(ls_comment_title) then
	ls_attachment_file = lstr_new_attachment.attachment_type + ls_date_suffix
else
	ls_attachment_file = ls_comment_title + ls_date_suffix
end if

setnull(lstr_new_attachment.attachment_id)
lstr_new_attachment.attachment_type = datalist.extension_default_attachment_type(lstr_new_attachment.extension)
lstr_new_attachment.attachment_tag = ls_comment_title
lstr_new_attachment.attachment_file = ls_attachment_file
setnull(lstr_new_attachment.attachment_text)

ll_attachment_id = current_patient.attachments.new_attachment(lstr_new_attachment, lbl_attachment, ls_attachment_object)
if ll_attachment_id <= 0 then
	log.log(this, "u_component_service_obs_attachment.xx_do_service:0130", "Error creating attachment", 4)
	return -1
end if

li_sts = f_edit_attachment(ll_attachment_id)
if li_sts <= 0 then return 2

Return 1


end function

on u_component_service_obs_attachment.create
call super::create
end on

on u_component_service_obs_attachment.destroy
call super::destroy
end on

