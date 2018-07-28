$PBExportHeader$w_health_maintenance_rules.srw
forward
global type w_health_maintenance_rules from w_window_base
end type
type dw_maintenance from u_dw_pick_list within w_health_maintenance_rules
end type
type cb_new_item from commandbutton within w_health_maintenance_rules
end type
type st_title from statictext within w_health_maintenance_rules
end type
type cb_ok from commandbutton within w_health_maintenance_rules
end type
type cb_cancel from commandbutton within w_health_maintenance_rules
end type
type cbx_show_disabled from checkbox within w_health_maintenance_rules
end type
end forward

global type w_health_maintenance_rules from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_maintenance dw_maintenance
cb_new_item cb_new_item
st_title st_title
cb_ok cb_ok
cb_cancel cb_cancel
cbx_show_disabled cbx_show_disabled
end type
global w_health_maintenance_rules w_health_maintenance_rules

type variables
integer deleted_count
long deleted_rule_id[]

string maintenance_rule_type = "Rule"
end variables

forward prototypes
public function integer edit_assessments (long pl_row)
public function integer edit_procedures (long pl_row)
public subroutine item_menu (long pl_row)
public function integer update_rule (long pl_row)
public subroutine scroll ()
public function integer update_all_rules ()
public subroutine edit_item (long pl_row)
public function integer refresh ()
public subroutine set_filter ()
end prototypes

public function integer edit_assessments (long pl_row);string ls_assessment_id
string ls_description
long ll_maintenance_rule_id
str_popup popup

 DECLARE lsp_maint_primary_assessment PROCEDURE FOR dbo.sp_maint_primary_assessment  
         @pl_maintenance_rule_id = :ll_maintenance_rule_id,   
         @ps_assessment_id = :ls_assessment_id OUT,   
         @ps_assessment_description = :ls_description OUT ;

ll_maintenance_rule_id = dw_maintenance.object.maintenance_rule_id[pl_row]

popup.data_row_count = 2
popup.items[1] = string(ll_maintenance_rule_id)
popup.items[2] = dw_maintenance.object.description[pl_row]
openwithparm(w_health_maintenance_assessments, popup)

EXECUTE lsp_maint_primary_assessment;
if not tf_check() then return -1

FETCH lsp_maint_primary_assessment INTO :ls_assessment_id, :ls_description;
if not tf_check() then return -1

CLOSE lsp_maint_primary_assessment;

dw_maintenance.object.assessment_description[pl_row] = ls_description

return 1

end function

public function integer edit_procedures (long pl_row);string ls_procedure_id
string ls_description
long ll_maintenance_rule_id
str_popup popup

 DECLARE lsp_maint_primary_procedure PROCEDURE FOR dbo.sp_maint_primary_procedure  
         @pl_maintenance_rule_id = :ll_maintenance_rule_id,   
         @ps_procedure_id = :ls_procedure_id OUT,   
         @ps_procedure_description = :ls_description OUT ;

ll_maintenance_rule_id = dw_maintenance.object.maintenance_rule_id[pl_row]

popup.data_row_count = 2
popup.items[1] = string(ll_maintenance_rule_id)
popup.items[2] = dw_maintenance.object.description[pl_row]
openwithparm(w_health_maintenance_procs, popup)

EXECUTE lsp_maint_primary_procedure;
if not tf_check() then return -1

FETCH lsp_maint_primary_procedure INTO :ls_procedure_id, :ls_description;
if not tf_check() then return -1

CLOSE lsp_maint_primary_procedure;

dw_maintenance.object.procedure_description[pl_row] = ls_description

return 1

end function

public subroutine item_menu (long pl_row);str_popup popup
str_popup_return popup_return
string lsa_buttons[]
integer li_button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_assessment_flag
string ls_status
long ll_maintenance_rule_id
string ls_description
//w_svc_config_hm lw_svc_config_hm
long ll_list_maintenance_rule_id
long ll_null
long ll_new_maintenance_rule_id

setnull(ll_null)

ls_assessment_flag = dw_maintenance.object.assessment_flag[pl_row]

ls_status = dw_maintenance.object.status[pl_row]
ll_maintenance_rule_id = dw_maintenance.object.maintenance_rule_id[pl_row]
ls_description = dw_maintenance.object.description[pl_row]

//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Edit Maintenance Rule"
//	popup.button_titles[popup.button_count] = "Edit"
//	lsa_buttons[popup.button_count] = "EDIT"
//end if
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "View list of patients who qualify for this rule"
//	popup.button_titles[popup.button_count] = "View Patients"
//	lsa_buttons[popup.button_count] = "PATIENTS"
//end if
//
//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Copy Maintenance Rule"
//	popup.button_titles[popup.button_count] = "Copy"
//	lsa_buttons[popup.button_count] = "COPY"
//end if
//
//if upper(ls_status) = "OK" then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button13.bmp"
//	popup.button_helps[popup.button_count] = "Disable Maintenance Rule"
//	popup.button_titles[popup.button_count] = "Disable"
//	lsa_buttons[popup.button_count] = "DISABLE"
//else
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button13.bmp"
//	popup.button_helps[popup.button_count] = "Enable Maintenance Rule"
//	popup.button_titles[popup.button_count] = "Enable"
//	lsa_buttons[popup.button_count] = "ENABLE"
//end if


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Maintenance Rule Description"
	popup.button_titles[popup.button_count] = "Edit Description"
	lsa_buttons[popup.button_count] = "DESCRIPTION"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Maintenance Rule Criteria"
	popup.button_titles[popup.button_count] = "Criteria"
	lsa_buttons[popup.button_count] = "CRITERIA"
end if

if ls_assessment_flag = "Y" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button05.bmp"
	popup.button_helps[popup.button_count] = "Edit Assessments Associated with Rule"
	popup.button_titles[popup.button_count] = "Diagnoses"
	lsa_buttons[popup.button_count] = "ASSESSMENTS"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button05.bmp"
	popup.button_helps[popup.button_count] = "Edit Procedures Associated with Rule"
	popup.button_titles[popup.button_count] = "Procedures"
	lsa_buttons[popup.button_count] = "PROCS"
end if

if ls_status = "OK" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Disable Health Maintenance Rule"
	popup.button_titles[popup.button_count] = "Disable Rule"
	lsa_buttons[popup.button_count] = "DISABLE"
else
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Enable Health Maintenance Rule"
	popup.button_titles[popup.button_count] = "Enable Rule"
	lsa_buttons[popup.button_count] = "ENABLE"
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
	li_button_pressed = message.doubleparm
	if li_button_pressed < 1 or li_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	li_button_pressed = 1
else
	return
end if

CHOOSE CASE lsa_buttons[li_button_pressed]
//	CASE "EDIT"
//		openwithparm(lw_svc_config_hm, ll_maintenance_rule_id, "w_svc_config_hm")
//		refresh()
//	CASE "PATIENTS"
//		// Create a "list" rule record.  Start it disabled.
//		ll_list_maintenance_rule_id = sqlca.jmj_hm_new_rule( ll_maintenance_rule_id, &
//																				ll_null, &
//																				ls_description, &
//																				"List", &
//																				"NA", &
//																				current_scribe.user_id )
//		if not tf_check() then return
//
//		openwithparm(lw_svc_config_hm, ll_list_maintenance_rule_id, "w_svc_config_hm")
//		
//		// See if it's still disabled
//		SELECT status
//		INTO :ls_status
//		FROM c_Maintenance_Patient_Class
//		WHERE maintenance_rule_id = :ll_list_maintenance_rule_id;
//		if not tf_check() then return
//		
//		// If it's still disabled then the used was just using it for ad-hoc queries.  We don't want it cluttering
//		// things up so delete it
//		if upper(ls_status) = "NA" then
//			DELETE
//			FROM c_Maintenance_Patient_Class
//			WHERE maintenance_rule_id = :ll_list_maintenance_rule_id;
//			if not tf_check() then return
//		end if
//	CASE "COPY"
//		popup.data_row_count = 0
//		popup.item = ""
//		popup.title = "Enter Title For New Maintenance Rule"
//		openwithparm(w_pop_prompt_string, popup)
//		popup_return = message.powerobjectparm
//		if popup_return.item_count <> 1 then return
//		
//		ls_description = popup_return.items[1]
//		
//		// Create new rule record
//		ll_new_maintenance_rule_id = sqlca.jmj_hm_new_rule( ll_null, &
//																				ll_maintenance_rule_id, &
//																				ls_description, &
//																				maintenance_rule_type, &
//																				"OK", &
//																				current_scribe.user_id )
//		if not tf_check() then return
//		
//		openwithparm(lw_svc_config_hm, ll_new_maintenance_rule_id, "w_svc_config_hm")
//		refresh()
//	CASE "DISABLE"
//		UPDATE c_Maintenance_Patient_Class
//		SET status = 'NA'
//		WHERE maintenance_rule_id = :ll_maintenance_rule_id;
//		if not tf_check() then return
//		refresh()
//	CASE "ENABLE"
//		UPDATE c_Maintenance_Patient_Class
//		SET status = 'OK'
//		WHERE maintenance_rule_id = :ll_maintenance_rule_id;
//		if not tf_check() then return
//		refresh()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	CASE "DESCRIPTION"
		popup.item = dw_maintenance.object.description[pl_row]
		popup.title = "Enter Maintenance Rule Description"
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		dw_maintenance.object.description[pl_row] = popup_return.items[1]
	CASE "CRITERIA"
		edit_item(pl_row)
	CASE "ASSESSMENTS"
		edit_assessments(pl_row)
	CASE "PROCS"
		edit_procedures(pl_row)
	CASE "DISABLE"
		openwithparm(w_pop_yes_no, "Are you sure you wish to disable this maintenance item?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		UPDATE c_Maintenance_Patient_Class
		SET status = 'NA'
		WHERE maintenance_rule_id = :ll_maintenance_rule_id;
		if not tf_check() then return
		dw_maintenance.object.status[pl_row] = "NA"
		
		dw_maintenance.filter()
	CASE "ENABLE"
		openwithparm(w_pop_yes_no, "Are you sure you wish to enable this maintenance item?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		UPDATE c_Maintenance_Patient_Class
		SET status = 'OK'
		WHERE maintenance_rule_id = :ll_maintenance_rule_id;
		if not tf_check() then return
		dw_maintenance.object.status[pl_row] = "OK"
		
		dw_maintenance.filter()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return




end subroutine

public function integer update_rule (long pl_row);long ll_maintenance_rule_id
string ls_assessment_flag
string ls_sex
string ls_race
string ls_description
long ll_interval,ll_age_range_id
string ls_interval_unit
long ll_warning_days

 DECLARE lsp_new_maintenance_rule PROCEDURE FOR dbo.sp_new_maintenance_rule  
         @ps_assessment_flag = :ls_assessment_flag,   
         @ps_sex = :ls_sex,
			@ps_race = :ls_race,
			@pl_age_range_id = :ll_age_range_id,
         @ps_description = :ls_description,   
         @pl_interval = :ll_interval,   
         @ps_interval_unit = :ls_interval_unit,   
         @pl_warning_days = :ll_warning_days,   
         @pl_maintenance_rule_id = :ll_maintenance_rule_id OUT  ;


ll_maintenance_rule_id = dw_maintenance.object.maintenance_rule_id[pl_row]
ls_assessment_flag = dw_maintenance.object.assessment_flag[pl_row]
ls_sex = dw_maintenance.object.sex[pl_row]
ls_race = dw_maintenance.object.race[pl_row]
ls_description = dw_maintenance.object.description[pl_row]
ll_interval = dw_maintenance.object.interval[pl_row]
ls_interval_unit = dw_maintenance.object.interval_unit[pl_row]
ll_warning_days = dw_maintenance.object.warning_days[pl_row]
ll_age_range_id = dw_maintenance.object.age_range_id[pl_row]
if isnull(ll_maintenance_rule_id) then
	EXECUTE lsp_new_maintenance_rule;
	if not tf_check() then return -1
	
	FETCH lsp_new_maintenance_rule INTO :ll_maintenance_rule_id;
	if not tf_check() then return -1

	CLOSE lsp_new_maintenance_rule;
	
	dw_maintenance.object.maintenance_rule_id[pl_row] = ll_maintenance_rule_id
else
	UPDATE c_Maintenance_Rule
	SET assessment_flag = :ls_assessment_flag,
		sex = :ls_sex,
		race = :ls_race,
		description = :ls_description,
		age_range_id = :ll_age_range_id,
		interval = :ll_interval,
		interval_unit = :ls_interval_unit,
		warning_days = :ll_warning_days
	WHERE maintenance_rule_id = :ll_maintenance_rule_id;
	if not tf_check() then return -1
end if

Return 1




end function

public subroutine scroll ();
end subroutine

public function integer update_all_rules ();long i
long ll_rowcount
integer li_sts
long ll_maintenance_rule_id

// First update the non-deleted rows
ll_rowcount = dw_maintenance.rowcount()

for i = 1 to ll_rowcount
	li_sts = update_rule(i)
	if li_sts < 0 then return li_sts
next


// Now delete the deleted rows
//for i = 1 to deleted_count
//	DELETE FROM c_Maintenance_Rule
//	WHERE maintenance_rule_id = :deleted_rule_id[i];
//	if not tf_check() then return -1
//next

// reset deleted count
deleted_count = 0
scroll()
return 1




end function

public subroutine edit_item (long pl_row);str_popup popup
str_popup_return popup_return

popup.data_row_count = 13

popup.items[1] = dw_maintenance.object.sex[pl_row]
popup.items[2] = dw_maintenance.object.race[pl_row]
popup.items[3] = string(dw_maintenance.object.interval[pl_row])
popup.items[4] = dw_maintenance.object.interval_unit[pl_row]
popup.items[5] = string(dw_maintenance.object.warning_days[pl_row])
popup.items[6] = dw_maintenance.object.assessment_flag[pl_row]
popup.items[7] = dw_maintenance.object.age_range_description[pl_row]
popup.items[8] = string(dw_maintenance.object.age_range_id[pl_row])
popup.items[9] = string(dw_maintenance.object.age_from[pl_row])
popup.items[10] = dw_maintenance.object.age_from_unit[pl_row]
popup.items[11] = string(dw_maintenance.object.age_to[pl_row])
popup.items[12] = dw_maintenance.object.age_to_unit[pl_row]
popup.items[13] = dw_maintenance.object.description[pl_row]

openwithparm(w_health_maintenance_rule_edit, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 12 then return

dw_maintenance.object.sex[pl_row] = popup_return.items[1]
dw_maintenance.object.race[pl_row] = popup_return.items[2]
dw_maintenance.object.age_range_id[pl_row] = long(popup_return.items[3])
dw_maintenance.object.age_from[pl_row] = long(popup_return.items[4])
dw_maintenance.object.age_from_unit[pl_row] = popup_return.items[5]
dw_maintenance.object.age_to[pl_row] = long(popup_return.items[6])
dw_maintenance.object.age_to_unit[pl_row] = popup_return.items[7]
dw_maintenance.object.interval[pl_row] = long(popup_return.items[8])
dw_maintenance.object.interval_unit[pl_row] = popup_return.items[9]
dw_maintenance.object.warning_days[pl_row] = long(popup_return.items[10])
dw_maintenance.object.assessment_flag[pl_row] = popup_return.items[11]
dw_maintenance.object.age_range_description[pl_row] = popup_return.items[12]
end subroutine

public function integer refresh ();long ll_count

dw_maintenance.settransobject(sqlca)
set_filter()
ll_count = dw_maintenance.retrieve("Rule")
if ll_count < 0 then return -1

return 1



end function

public subroutine set_filter ();if cbx_show_disabled.checked then
	dw_maintenance.setfilter("")
else
	dw_maintenance.setfilter("status='OK'")
end if

end subroutine

on w_health_maintenance_rules.create
int iCurrent
call super::create
this.dw_maintenance=create dw_maintenance
this.cb_new_item=create cb_new_item
this.st_title=create st_title
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.cbx_show_disabled=create cbx_show_disabled
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_maintenance
this.Control[iCurrent+2]=this.cb_new_item
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.cbx_show_disabled
end on

on w_health_maintenance_rules.destroy
call super::destroy
destroy(this.dw_maintenance)
destroy(this.cb_new_item)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.cbx_show_disabled)
end on

event open;call super::open;
str_popup popup
integer li_pos

deleted_count = 0

dw_maintenance.object.backdrop.width = dw_maintenance.width - 110

refresh()

scroll()


end event

type pb_epro_help from w_window_base`pb_epro_help within w_health_maintenance_rules
integer x = 2857
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_health_maintenance_rules
end type

type dw_maintenance from u_dw_pick_list within w_health_maintenance_rules
integer x = 137
integer y = 132
integer width = 2725
integer height = 1448
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_sp_maintenance_rule_display"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;item_menu(selected_row)
clear_selected()

end event

type cb_new_item from commandbutton within w_health_maintenance_rules
integer x = 1129
integer y = 1664
integer width = 663
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Maintenance Rule"
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_row
string ls_description


popup.item = ""
popup.title = "Enter Maintenance Rule Description"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_description = popup_return.items[1]


popup.data_row_count = 13

setnull(popup.items[1])
setnull(popup.items[2])
popup.items[3] = "99"
popup.items[4] = "Month"
popup.items[5] = "30"
popup.items[6] = "N"
setnull(popup.items[7]) // age range description
setnull(popup.items[8]) // age range id
Setnull(popup.items[9]) // age from
Setnull(popup.items[10]) // age from unit
Setnull(popup.items[11]) // age to
Setnull(popup.items[12]) // age to unit
popup.items[13] = ls_description

Openwithparm(w_health_maintenance_rule_edit, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 12 then return

ll_row = dw_maintenance.insertrow(0)
dw_maintenance.object.description[ll_row] = ls_description
dw_maintenance.object.sex[ll_row] = popup_return.items[1]
dw_maintenance.object.race[ll_row] = popup_return.items[2]
dw_maintenance.object.age_range_id[ll_row] = long(popup_return.items[3])
dw_maintenance.object.age_from[ll_row] = long(popup_return.items[4])
dw_maintenance.object.age_from_unit[ll_row] = popup_return.items[5]
dw_maintenance.object.age_to[ll_row] = long(popup_return.items[6])
dw_maintenance.object.age_to_unit[ll_row] = popup_return.items[7]
dw_maintenance.object.interval[ll_row] = long(popup_return.items[8])
dw_maintenance.object.interval_unit[ll_row] = popup_return.items[9]
dw_maintenance.object.warning_days[ll_row] = long(popup_return.items[10])
dw_maintenance.object.assessment_flag[ll_row] = popup_return.items[11]
dw_maintenance.object.age_range_description[ll_row] = popup_return.items[12]

update_rule(ll_row)
scroll()




end event

type st_title from statictext within w_health_maintenance_rules
integer width = 2921
integer height = 100
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Health Maintenance Rules"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_health_maintenance_rules
integer x = 2286
integer y = 1664
integer width = 576
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;integer li_sts

li_sts = update_all_rules()
if li_sts <= 0 then return

close(parent)

end event

type cb_cancel from commandbutton within w_health_maintenance_rules
integer x = 41
integer y = 1664
integer width = 576
integer height = 112
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(parent)

end event

type cbx_show_disabled from checkbox within w_health_maintenance_rules
integer x = 119
integer y = 1580
integer width = 704
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Show Disabled Rules"
end type

event clicked;set_filter()
dw_maintenance.filter()


end event

