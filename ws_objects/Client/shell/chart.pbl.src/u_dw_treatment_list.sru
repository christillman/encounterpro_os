$PBExportHeader$u_dw_treatment_list.sru
forward
global type u_dw_treatment_list from u_dw_pick_list
end type
end forward

global type u_dw_treatment_list from u_dw_pick_list
integer width = 2103
integer height = 1220
string dataobject = "dw_sp_get_treatment_list"
end type
global u_dw_treatment_list u_dw_treatment_list

type variables
string assessment_id
string list_user_id
long parent_definition_id

end variables

forward prototypes
public function integer edit_treatment_item (long pl_row)
public function integer show_treatments (string ps_assessment_id, string ps_list_user_id)
public function integer add_new_treatment (str_assessment_treatment_definition pstr_parent_treatment_def)
public function integer show_treatments (long pl_parent_definition_id)
end prototypes

public function integer edit_treatment_item (long pl_row);long ll_definition_id
str_assessment_treatment_definition lstr_treatment_def
str_assessment_treatment_definition lstr_return_treatment_def
integer li_sts
str_popup_return popup_return
w_window_base lw_window

// Set the treatment definition fields
ll_definition_id = object.definition_id[pl_row]

li_sts = f_get_assessment_treatment_def(ll_definition_id, lstr_treatment_def)
if li_sts <= 0 then return -1

openwithparm(lw_window, lstr_treatment_def, "w_assessment_treatment_edit")
popup_return = message.powerobjectparm
lstr_return_treatment_def = popup_return.returnobject
if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "DELETE" then
	DELETE u_Assessment_Treat_Definition
	WHERE definition_id = :ll_definition_id;
	if not tf_check() then return -1
	deleterow(pl_row)
elseif popup_return.items[1] = "OK" then
	f_save_assessment_treatment_def(lstr_return_treatment_def)
	// Update the description
	if len(lstr_return_treatment_def.treatment_description) > 255 then
		object.treatment_description[pl_row] = left(lstr_return_treatment_def.treatment_description, 252) + "..."
	else
		object.treatment_description[pl_row] = lstr_return_treatment_def.treatment_description
	end if
end if

return 1

end function

public function integer show_treatments (string ps_assessment_id, string ps_list_user_id);long ll_count

assessment_id = ps_assessment_id
list_user_id = ps_list_user_id
setnull(parent_definition_id)

settransobject(sqlca)
ll_count = retrieve(current_patient.cpr_id, assessment_id, list_user_id, parent_definition_id)

return 1

end function

public function integer add_new_treatment (str_assessment_treatment_definition pstr_parent_treatment_def);////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description: Load selected treatments from different treatment types into datawindow.
//
//
// Created By:Sumathi Chinnasamy													Created On: 03/10/2000
////////////////////////////////////////////////////////////////////////////////////////////////////

String	ls_child_flag
integer li_sts
integer i
str_assessment_treatment_definition lstr_new_treatment_def
string ls_treatment_list_id
string ls_treatment_type

// User defined types
u_component_treatment	luo_treatment

ls_child_flag = datalist.treatment_type_followup_flag(pstr_parent_treatment_def.treatment_type)
ls_treatment_list_id = "FOLLOWUP_FLAG_" + ls_child_flag

ls_treatment_type = f_get_treatments_list(ls_treatment_list_id)
If Isnull(ls_treatment_type) Then return 0

luo_treatment = f_get_treatment_component(ls_treatment_type)
If Isnull(luo_treatment) Then
	log.log(this, "u_dw_treatment_list.add_new_treatment.0027", "Error getting treatment component (" + ls_treatment_type + ")", 4)
	return -1
end if

li_sts = luo_treatment.define_treatment()
if li_sts <= 0 then
	component_manager.destroy_component(luo_treatment)
	return li_sts
end if

for i = 1 to luo_treatment.treatment_count
	// Put the treatment item_definition into an assessment_treatment_definition structure
	setnull(lstr_new_treatment_def.definition_id)
	lstr_new_treatment_def.assessment_id = pstr_parent_treatment_def.assessment_id
	lstr_new_treatment_def.treatment_type = luo_treatment.treatment_definition[i].treatment_type
	lstr_new_treatment_def.treatment_description = luo_treatment.treatment_definition[i].item_description
	setnull(lstr_new_treatment_def.workplan_id)
	setnull(lstr_new_treatment_def.followup_workplan_id)
	setnull(lstr_new_treatment_def.instructions)
	lstr_new_treatment_def.user_id = pstr_parent_treatment_def.user_id
	lstr_new_treatment_def.parent_definition_id = pstr_parent_treatment_def.definition_id
	lstr_new_treatment_def.child_flag = ls_child_flag
	
	lstr_new_treatment_def.attributes = f_attribute_arrays_to_str(luo_treatment.treatment_definition[i].attribute_count, &
																						luo_treatment.treatment_definition[i].attribute, &
																						luo_treatment.treatment_definition[i].value )

	f_save_assessment_treatment_def(lstr_new_treatment_def)
next
		
// Destroy the component
component_manager.destroy_component(luo_treatment)

Return 1


end function

public function integer show_treatments (long pl_parent_definition_id);long ll_count

setnull(assessment_id)
setnull(list_user_id)
parent_definition_id = pl_parent_definition_id

settransobject(sqlca)
ll_count = retrieve(current_patient.cpr_id, assessment_id, list_user_id, parent_definition_id)

return 1

end function

on u_dw_treatment_list.create
call super::create
end on

on u_dw_treatment_list.destroy
call super::destroy
end on

event computed_clicked;call super::computed_clicked;edit_treatment_item(clicked_row)

end event

