HA$PBExportHeader$u_configuration_node_document_purpose_workplan.sru
forward
global type u_configuration_node_document_purpose_workplan from u_configuration_node_base
end type
end forward

global type u_configuration_node_document_purpose_workplan from u_configuration_node_base
end type
global u_configuration_node_document_purpose_workplan u_configuration_node_document_purpose_workplan

forward prototypes
public function boolean has_children ()
public function integer activate ()
public subroutine refresh_label ()
end prototypes

public function boolean has_children ();return false
end function

public function integer activate ();String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
string ls_status
str_service_info lstr_service
string ls_id
w_window_base lw_window
str_c_workplan lstr_workplan
str_workplan_context lstr_workplan_context
long ll_workplan_id
string ls_workplan_id
string ls_context_object
string ls_new_old
string ls_purpose

Setnull(ls_null)
Setnull(ll_null)

f_split_string(node.key, "|", ls_new_old, ls_workplan_id)
if isnumber(ls_workplan_id) then
	ll_workplan_id = long(ls_workplan_id)
else
	setnull(ll_workplan_id)
end if

ls_purpose = parent_configuration_node.parent_configuration_node.node.key
ls_context_object = parent_configuration_node.parent_configuration_node.parent_configuration_node.node.key

if ll_workplan_id > 0 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Edit Workplan"
	popup.button_titles[popup.button_count] = "Edit Workplan"
	lsa_buttons[popup.button_count] = "EDIT"
end if

if ll_workplan_id > 0 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Change Workplan"
	popup.button_titles[popup.button_count] = "Change Workplan"
	lsa_buttons[popup.button_count] = "SET"
else
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Set Workplan"
	popup.button_titles[popup.button_count] = "Set Workplan"
	lsa_buttons[popup.button_count] = "SET"
end if

if ll_workplan_id > 0 then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Remove Workplan"
	popup.button_titles[popup.button_count] = "Remove Workplan"
	lsa_buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return 1
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return 1
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "EDIT"
		SELECT CAST(id AS varchar(40))
		INTO :ls_id
		FROM c_workplan
		WHERE workplan_id = :ll_workplan_id;
		if not tf_check() then return 1
		if sqlca.sqlcode = 100 then return 1
		
		popup.data_row_count = 2
		popup.items[1] = ls_id
		popup.items[2] = "true"
		
		openwithparm(lw_window, popup, "w_Workplan_definition_display")
	CASE "SET"
		lstr_workplan_context.context_object = ls_context_object
		lstr_workplan_context.in_office_flag = "N"
		
		openwithparm(lw_window, lstr_workplan_context, "w_pick_workplan")
		lstr_workplan = message.powerobjectparm
		if isnull(lstr_workplan.workplan_id) then return 1
		
		if ls_new_old = "NEW" then
			UPDATE c_Document_Purpose
			SET new_object_workplan_id = :lstr_workplan.workplan_id
			WHERE purpose = :ls_purpose;
			if not tf_check() then return 1
		else
			UPDATE c_Document_Purpose
			SET existing_object_workplan_id = :lstr_workplan.workplan_id
			WHERE purpose = :ls_purpose;
			if not tf_check() then return 1
		end if
		
		node.key = ls_new_old + "|" + string(lstr_workplan.workplan_id)
		return 2
	CASE "REMOVE"
		if ls_new_old = "NEW" then
			UPDATE c_Document_Purpose
			SET new_object_workplan_id = NULL
			WHERE purpose = :ls_purpose;
			if not tf_check() then return 1
		else
			UPDATE c_Document_Purpose
			SET existing_object_workplan_id = NULL
			WHERE purpose = :ls_purpose;
			if not tf_check() then return 1
		end if
		
		node.key = ls_new_old + "|"
		return 2
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1

end function

public subroutine refresh_label ();long ll_workplan_id
string ls_workplan_id
string ls_new_old
string ls_description
string ls_temp

f_split_string(node.key, "|", ls_new_old, ls_workplan_id)
if isnumber(ls_workplan_id) then
	ll_workplan_id = long(ls_workplan_id)
else
	setnull(ll_workplan_id)
end if


if ls_new_old = "NEW" then
	ls_description = "New Object Workplan:  "
else
	ls_description = "Existing Object Workplan:  "
end if

SELECT description
INTO :ls_temp
FROM c_Workplan
WHERE workplan_id = :ll_workplan_id;
if not tf_check() then return
if len(ls_temp) > 0 then
	ls_description += ls_temp
else
	ls_description += "<None>"
end if

node.label = ls_description

end subroutine

on u_configuration_node_document_purpose_workplan.create
call super::create
end on

on u_configuration_node_document_purpose_workplan.destroy
call super::destroy
end on

