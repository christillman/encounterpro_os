$PBExportHeader$u_tabpage_shell_hm.sru
forward
global type u_tabpage_shell_hm from u_main_tabpage_base
end type
type cb_new from commandbutton within u_tabpage_shell_hm
end type
type cbx_inactive from checkbox within u_tabpage_shell_hm
end type
type dw_hm_classes from u_dw_pick_list within u_tabpage_shell_hm
end type
end forward

global type u_tabpage_shell_hm from u_main_tabpage_base
integer width = 2606
integer height = 1936
event resized ( )
cb_new cb_new
cbx_inactive cbx_inactive
dw_hm_classes dw_hm_classes
end type
global u_tabpage_shell_hm u_tabpage_shell_hm

type variables
long menu_id
str_menu menu

string maintenance_rule_type = "Rule"

end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public subroutine resize_tabpage ()
public subroutine class_menu (long pl_row)
end prototypes

event resized();resize_tabpage()

end event

public function integer initialize ();resize_tabpage()

return 1

end function

public subroutine refresh ();string ls_filter

if not cbx_inactive.checked then
	ls_filter = "status='OK'"
else
	ls_filter = ""
end if

dw_hm_classes.setfilter(ls_filter)

dw_hm_classes.settransobject(sqlca)
dw_hm_classes.retrieve(maintenance_rule_type)

end subroutine

public subroutine resize_tabpage ();dw_hm_classes.width = width - 100
dw_hm_classes.height = height - 100

cbx_inactive.y = height - 92

dw_hm_classes.object.t_background.width = width - 220

cb_new.x = width - cb_new.width - 100
cb_new.y = height - cb_new.height - 8

//dw_menu.x = (width - dw_menu.width) / 2
//dw_menu.y = 0
//dw_menu.height = height
//
//st_config_mode_menu.x = 0
//st_config_mode_menu.y = height - st_config_mode_menu.height
//
end subroutine

public subroutine class_menu (long pl_row);str_popup popup
str_popup_return popup_return
string lsa_buttons[]
integer li_button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_status
long ll_maintenance_rule_id
string ls_description
w_window_base lw_service_window
long ll_list_maintenance_rule_id
long ll_null
long ll_new_maintenance_rule_id
str_service_info lstr_service

setnull(ll_null)

ls_status = dw_hm_classes.object.status[pl_row]
ll_maintenance_rule_id = dw_hm_classes.object.maintenance_rule_id[pl_row]
ls_description = dw_hm_classes.object.description[pl_row]

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Maintenance Rule"
	popup.button_titles[popup.button_count] = "Edit"
	lsa_buttons[popup.button_count] = "EDIT"
end if

//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "View status screen for this rule"
//	popup.button_titles[popup.button_count] = "Status"
//	lsa_buttons[popup.button_count] = "STATUS"
//end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "View list of patients who qualify for this rule"
	popup.button_titles[popup.button_count] = "View Patients"
	lsa_buttons[popup.button_count] = "PATIENTS"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Copy Maintenance Rule"
	popup.button_titles[popup.button_count] = "Copy"
	lsa_buttons[popup.button_count] = "COPY"
end if

if upper(ls_status) = "OK" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Disable Maintenance Rule"
	popup.button_titles[popup.button_count] = "Disable"
	lsa_buttons[popup.button_count] = "DISABLE"
else
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Enable Maintenance Rule"
	popup.button_titles[popup.button_count] = "Enable"
	lsa_buttons[popup.button_count] = "ENABLE"
end if


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit Maintenance Rule Description"
//	popup.button_titles[popup.button_count] = "Edit Description"
//	lsa_buttons[popup.button_count] = "DESCRIPTION"
//end if
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit Maintenance Rule Criteria"
//	popup.button_titles[popup.button_count] = "Criteria"
//	lsa_buttons[popup.button_count] = "CRITERIA"
//end if
//
//if ls_assessment_flag = "Y" then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button05.bmp"
//	popup.button_helps[popup.button_count] = "Edit Assessments Associated with Rule"
//	popup.button_titles[popup.button_count] = "Diagnoses"
//	lsa_buttons[popup.button_count] = "ASSESSMENTS"
//end if
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button05.bmp"
//	popup.button_helps[popup.button_count] = "Edit Procedures Associated with Rule"
//	popup.button_titles[popup.button_count] = "Procedures"
//	lsa_buttons[popup.button_count] = "PROCS"
//end if
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button13.bmp"
//	popup.button_helps[popup.button_count] = "Delete Health Maintenance Rule"
//	popup.button_titles[popup.button_count] = "Delete Rule"
//	lsa_buttons[popup.button_count] = "DELETE"
//end if

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
	li_button_pressed = message.doubleparm
	if li_button_pressed < 1 or li_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	li_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[li_button_pressed]
	CASE "EDIT"
		lstr_service.service = "CONFIG_HM"
		f_attribute_add_attribute(lstr_service.attributes, "maintenance_rule_id", string(ll_maintenance_rule_id))
		f_attribute_add_attribute(lstr_service.attributes, "mode", "EDIT")
		service_list.do_service(lstr_service)
		refresh()
	CASE "STATUS"
		lstr_service.service = "CONFIG_HM"
		f_attribute_add_attribute(lstr_service.attributes, "maintenance_rule_id", string(ll_maintenance_rule_id))
		f_attribute_add_attribute(lstr_service.attributes, "mode", "STATUS")
		service_list.do_service(lstr_service)
		refresh()
	CASE "PATIENTS"
		lstr_service.service = "CONFIG_HM"
		f_attribute_add_attribute(lstr_service.attributes, "maintenance_rule_id", string(ll_maintenance_rule_id))
		f_attribute_add_attribute(lstr_service.attributes, "mode", "EDIT")
		f_attribute_add_attribute(lstr_service.attributes, "tabpage", "Patients")
		service_list.do_service(lstr_service)
		refresh()
	CASE "COPY"
		popup.data_row_count = 0
		popup.item = ""
		popup.title = "Enter Title For New Maintenance Rule"
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		ls_description = popup_return.items[1]
		
		// Create new rule record
		ll_new_maintenance_rule_id = sqlca.jmj_hm_new_rule( ll_null, &
																				ll_maintenance_rule_id, &
																				ls_description, &
																				maintenance_rule_type, &
																				"OK", &
																				current_scribe.user_id )
		if not tf_check() then return
		
		lstr_service.service = "CONFIG_HM"
		f_attribute_add_attribute(lstr_service.attributes, "maintenance_rule_id", string(ll_new_maintenance_rule_id))
		f_attribute_add_attribute(lstr_service.attributes, "mode", "EDIT")
		service_list.do_service(lstr_service)
		refresh()
	CASE "DISABLE"
		UPDATE c_Maintenance_Patient_Class
		SET status = 'NA'
		WHERE maintenance_rule_id = :ll_maintenance_rule_id;
		if not tf_check() then return
		refresh()
	CASE "ENABLE"
		UPDATE c_Maintenance_Patient_Class
		SET status = 'OK'
		WHERE maintenance_rule_id = :ll_maintenance_rule_id;
		if not tf_check() then return
		refresh()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	CASE "DESCRIPTION"
//		popup.item = dw_hm_classes.object.description[pl_row]
//		popup.title = "Enter Maintenance Rule Description"
//		openwithparm(w_pop_prompt_string, popup)
//		popup_return = message.powerobjectparm
//		if popup_return.item_count <> 1 then return
//		
//		dw_hm_classes.object.description[pl_row] = popup_return.items[1]
//	CASE "CRITERIA"
//		edit_item(pl_row)
//	CASE "ASSESSMENTS"
//		edit_assessments(pl_row)
//	CASE "PROCS"
//		edit_procedures(pl_row)
//	CASE "DELETE"
//		openwithparm(w_pop_yes_no, "Are you sure you wish to delete this maintenance item?")
//		popup_return = message.powerobjectparm
//		if popup_return.item <> "YES" then return
//		deleted_count += 1
//		deleted_rule_id[deleted_count] = dw_hm_classes.object.maintenance_rule_id[pl_row]
//		dw_hm_classes.deleterow(pl_row)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return




end subroutine

on u_tabpage_shell_hm.create
int iCurrent
call super::create
this.cb_new=create cb_new
this.cbx_inactive=create cbx_inactive
this.dw_hm_classes=create dw_hm_classes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_new
this.Control[iCurrent+2]=this.cbx_inactive
this.Control[iCurrent+3]=this.dw_hm_classes
end on

on u_tabpage_shell_hm.destroy
call super::destroy
destroy(this.cb_new)
destroy(this.cbx_inactive)
destroy(this.dw_hm_classes)
end on

type cb_new from commandbutton within u_tabpage_shell_hm
integer x = 946
integer y = 1600
integer width = 357
integer height = 76
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New"
end type

event clicked;str_attributes lstr_attributes
string ls_id
long ll_maintenance_rule_id
str_service_info lstr_service

ls_id = f_new_config_object("Health Management Class", lstr_attributes)

ll_maintenance_rule_id = long(f_attribute_find_attribute(lstr_attributes, "maintenance_rule_id"))
if isnull(ll_maintenance_rule_id) then
	openwithparm(w_pop_message, "An error occured creating the new Health Management Class")
	return
end if

lstr_service.service = "CONFIG_HM"
f_attribute_add_attribute(lstr_service.attributes, "maintenance_rule_id", string(ll_maintenance_rule_id))
f_attribute_add_attribute(lstr_service.attributes, "mode", "EDIT")
service_list.do_service(lstr_service)

refresh()

return



end event

type cbx_inactive from checkbox within u_tabpage_shell_hm
integer x = 5
integer y = 1424
integer width = 443
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Show Inactive"
end type

event clicked;refresh()

end event

type dw_hm_classes from u_dw_pick_list within u_tabpage_shell_hm
integer width = 2299
integer height = 1408
integer taborder = 10
string dataobject = "dw_fn_hm_classes"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;
class_menu(selected_row)

clear_selected()


end event

