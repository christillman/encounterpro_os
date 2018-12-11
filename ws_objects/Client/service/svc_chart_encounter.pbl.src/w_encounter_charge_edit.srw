$PBExportHeader$w_encounter_charge_edit.srw
forward
global type w_encounter_charge_edit from w_window_base
end type
type st_override_title from statictext within w_encounter_charge_edit
end type
type cb_clear_override from commandbutton within w_encounter_charge_edit
end type
type st_title from statictext within w_encounter_charge_edit
end type
type cb_done from commandbutton within w_encounter_charge_edit
end type
type cb_cancel from commandbutton within w_encounter_charge_edit
end type
type dw_assessments from u_dw_pick_list within w_encounter_charge_edit
end type
type st_assessments_title from statictext within w_encounter_charge_edit
end type
type st_procedure_title from statictext within w_encounter_charge_edit
end type
type st_procedure_description from statictext within w_encounter_charge_edit
end type
type cb_edit_procedure_def from commandbutton within w_encounter_charge_edit
end type
type cb_change_procedure from commandbutton within w_encounter_charge_edit
end type
type cb_change_level from commandbutton within w_encounter_charge_edit
end type
type cb_delete_charge from commandbutton within w_encounter_charge_edit
end type
type cb_switch_code from commandbutton within w_encounter_charge_edit
end type
type st_billing_flag_title from statictext within w_encounter_charge_edit
end type
type st_bill_yes from statictext within w_encounter_charge_edit
end type
type st_bill_no from statictext within w_encounter_charge_edit
end type
type st_override_charge from statictext within w_encounter_charge_edit
end type
type st_cpt_code_title from statictext within w_encounter_charge_edit
end type
type st_cpt_code from statictext within w_encounter_charge_edit
end type
type st_other_modifiers_title from statictext within w_encounter_charge_edit
end type
type st_other_modifiers from statictext within w_encounter_charge_edit
end type
type st_modifier_title from statictext within w_encounter_charge_edit
end type
type st_modifier from statictext within w_encounter_charge_edit
end type
type st_units_title from statictext within w_encounter_charge_edit
end type
type st_units from statictext within w_encounter_charge_edit
end type
type r_1 from rectangle within w_encounter_charge_edit
end type
end forward

global type w_encounter_charge_edit from w_window_base
integer x = 201
integer y = 100
integer width = 2533
integer height = 1632
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_override_title st_override_title
cb_clear_override cb_clear_override
st_title st_title
cb_done cb_done
cb_cancel cb_cancel
dw_assessments dw_assessments
st_assessments_title st_assessments_title
st_procedure_title st_procedure_title
st_procedure_description st_procedure_description
cb_edit_procedure_def cb_edit_procedure_def
cb_change_procedure cb_change_procedure
cb_change_level cb_change_level
cb_delete_charge cb_delete_charge
cb_switch_code cb_switch_code
st_billing_flag_title st_billing_flag_title
st_bill_yes st_bill_yes
st_bill_no st_bill_no
st_override_charge st_override_charge
st_cpt_code_title st_cpt_code_title
st_cpt_code st_cpt_code
st_other_modifiers_title st_other_modifiers_title
st_other_modifiers st_other_modifiers
st_modifier_title st_modifier_title
st_modifier st_modifier
st_units_title st_units_title
st_units st_units
r_1 r_1
end type
global w_encounter_charge_edit w_encounter_charge_edit

type variables
str_encounter_charge original_encounter_charge
str_encounter_charge modified_encounter_charge

boolean modified

end variables

forward prototypes
public function integer update_assessments ()
public function integer load_charge ()
public function integer load_assessments ()
public function integer update_charge (string ps_procedure_id)
public function integer save_changes ()
public function string get_cpt_code (string ps_procedure_id)
end prototypes

public function integer update_assessments ();long ll_rowcount
long i
string ls_bill_flag
integer li_selected_flag
long ll_problem_id
str_popup_return popup_return
boolean lb_changed
boolean lb_any



lb_changed = false
lb_any = false

ll_rowcount = dw_assessments.rowcount()
for i = 1 to ll_rowcount
	ls_bill_flag = dw_assessments.object.treatment_bill_flag[i]
	li_selected_flag = dw_assessments.object.selected_flag[i]
	ll_problem_id = dw_assessments.object.problem_id[i]

	if isnull(ls_bill_flag) and li_selected_flag = 1 &
	 or ls_bill_flag = "Y" and li_selected_flag = 0 &
	 or ls_bill_flag = "N" and li_selected_flag = 1 then lb_changed = true

	if li_selected_flag = 1 then
		lb_any = true
		ls_bill_flag = "Y"
	else
		ls_bill_flag = "N"
	end if
	
	sqlca.sp_set_assmnt_charge_billing( modified_encounter_charge.cpr_id, &
													modified_encounter_charge.encounter_id, &
													ll_problem_id, &
													modified_encounter_charge.encounter_charge_id, &
													ls_bill_flag, &
													current_scribe.user_id)
	if not tf_check() then return -1
next

if lb_changed then
	return 1
else
	return 0
end if



end function

public function integer load_charge ();long ll_rowcount
long i
string ls_bill_flag
long ll_problem_id
str_popup popup

st_procedure_description.text = modified_encounter_charge.description

if isnull( modified_encounter_charge.cpt_code) then
	st_cpt_code.text = get_cpt_code(modified_encounter_charge.procedure_id)
else
	st_cpt_code.text = modified_encounter_charge.cpt_code
end if

if modified_encounter_charge.units > 0 then
	st_units.text = string(modified_encounter_charge.units)
else
	st_units.text = "1"
end if
st_modifier.text = modified_encounter_charge.modifier
st_other_modifiers.text = modified_encounter_charge.other_modifiers
if isnull(modified_encounter_charge.charge) then
	st_override_charge.text = "N/A"
else
	st_override_charge.text = string(modified_encounter_charge.charge)
end if

if f_string_to_boolean(modified_encounter_charge.charge_bill_flag) then
	st_bill_yes.event trigger clicked()
else
	st_bill_no.event trigger clicked()
end if

if upper(modified_encounter_charge.procedure_type) = "PRIMARY" then
	cb_change_level.visible = true
else
	cb_change_level.visible = false
end if

if upper(modified_encounter_charge.procedure_type) = "TESTCOLLECT" then
	cb_switch_code.visible = true
	cb_switch_code.text = "Switch To Perform Procedure"
else
	cb_switch_code.visible = false
end if

if upper(modified_encounter_charge.procedure_type) = "TESTPERFORM" then
	cb_switch_code.visible = true
	cb_switch_code.text = "Switch To Collect Procedure"
else
	cb_switch_code.visible = false
end if


return 1



end function

public function integer load_assessments ();long ll_rowcount
long i
string ls_bill_flag
long ll_problem_id


// Load the associated assessments
dw_assessments.settransobject(sqlca)
ll_rowcount = dw_assessments.retrieve(modified_encounter_charge.cpr_id, modified_encounter_charge.encounter_id)
if ll_rowcount < 0 then return -1

for i = 1 to ll_rowcount
	ll_problem_id = dw_assessments.object.problem_id[i]
	
	SELECT bill_flag
	INTO :ls_bill_Flag
	FROM p_Encounter_Assessment_Charge
	WHERE cpr_id = :modified_encounter_charge.cpr_id
	AND encounter_id = :modified_encounter_charge.encounter_id
	AND problem_id = :ll_problem_id
	AND encounter_charge_id = :modified_encounter_charge.encounter_charge_id;
	if not tf_check() then return -1
	
	if sqlca.sqlcode = 100 then
		setnull(ls_bill_flag)
	end if

	dw_assessments.setitem(i, "treatment_bill_flag", ls_bill_flag)

	if ls_bill_flag = "Y" then
		dw_assessments.setitem(i, "selected_flag", 1)
	else
		dw_assessments.setitem(i, "selected_flag", 0)
	end if
next



return 1



end function

public function integer update_charge (string ps_procedure_id);u_ds_data luo_data
long ll_count
integer li_sts
string ls_description

SELECT description
INTO :ls_description
FROM c_Procedure
WHERE procedure_id = :ps_procedure_id;
if not tf_check() then return -1

modified_encounter_charge.procedure_id = ps_procedure_id
modified_encounter_charge.description = ls_description

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_sp_get_procedure_cpt")
ll_count = luo_data.retrieve(modified_encounter_charge.cpr_id, ps_procedure_id)
if ll_count < 0 then return -1
if ll_count > 0 then
//	modified_encounter_charge.authority_id = luo_data.object.authority_id[1]
	modified_encounter_charge.cpt_code = luo_data.object.cpt_code[1]
	modified_encounter_charge.modifier = luo_data.object.modifier[1]
	modified_encounter_charge.other_modifiers = luo_data.object.other_modifiers[1]
	modified_encounter_charge.units = luo_data.object.units[1]
	modified_encounter_charge.charge = luo_data.object.charge[1]
end if

DESTROY luo_data

li_sts = load_charge()

modified = true

return li_sts


end function

public function integer save_changes ();integer li_sts
datetime ldt_now

ldt_now = datetime(today(), now())

UPDATE p_Encounter_Charge
SET procedure_type = :modified_encounter_charge.procedure_type,
	procedure_id = :modified_encounter_charge.procedure_id,
	charge = :modified_encounter_charge.charge,
	bill_flag = :modified_encounter_charge.charge_bill_flag,
	cpt_code = :modified_encounter_charge.cpt_code,
	units = :modified_encounter_charge.units,
	modifier = :modified_encounter_charge.modifier,
	other_modifiers = :modified_encounter_charge.other_modifiers,
	last_updated = :ldt_now,
	last_updated_by = :current_scribe.user_id
WHERE cpr_id = :modified_encounter_charge.cpr_id
AND encounter_id = :modified_encounter_charge.encounter_id
AND encounter_charge_id = :modified_encounter_charge.encounter_charge_id;
if not tf_check() then return -1


li_sts = update_assessments()
if li_sts < 0 then
	openwithparm(w_pop_message, "An error has occured saving the associated assessments")
	return -1
end if

return 1

end function

public function string get_cpt_code (string ps_procedure_id);u_ds_data luo_data
long ll_count
integer li_sts
string ls_cpt_code
string ls_null

setnull(ls_null)

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_sp_get_procedure_cpt")
ll_count = luo_data.retrieve(modified_encounter_charge.cpr_id, ps_procedure_id)
if ll_count < 0 then return ls_null
if ll_count > 0 then
	ls_cpt_code = luo_data.object.cpt_code[1]
end if

DESTROY luo_data

return ls_cpt_code

end function

on w_encounter_charge_edit.create
int iCurrent
call super::create
this.st_override_title=create st_override_title
this.cb_clear_override=create cb_clear_override
this.st_title=create st_title
this.cb_done=create cb_done
this.cb_cancel=create cb_cancel
this.dw_assessments=create dw_assessments
this.st_assessments_title=create st_assessments_title
this.st_procedure_title=create st_procedure_title
this.st_procedure_description=create st_procedure_description
this.cb_edit_procedure_def=create cb_edit_procedure_def
this.cb_change_procedure=create cb_change_procedure
this.cb_change_level=create cb_change_level
this.cb_delete_charge=create cb_delete_charge
this.cb_switch_code=create cb_switch_code
this.st_billing_flag_title=create st_billing_flag_title
this.st_bill_yes=create st_bill_yes
this.st_bill_no=create st_bill_no
this.st_override_charge=create st_override_charge
this.st_cpt_code_title=create st_cpt_code_title
this.st_cpt_code=create st_cpt_code
this.st_other_modifiers_title=create st_other_modifiers_title
this.st_other_modifiers=create st_other_modifiers
this.st_modifier_title=create st_modifier_title
this.st_modifier=create st_modifier
this.st_units_title=create st_units_title
this.st_units=create st_units
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_override_title
this.Control[iCurrent+2]=this.cb_clear_override
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.cb_done
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.dw_assessments
this.Control[iCurrent+7]=this.st_assessments_title
this.Control[iCurrent+8]=this.st_procedure_title
this.Control[iCurrent+9]=this.st_procedure_description
this.Control[iCurrent+10]=this.cb_edit_procedure_def
this.Control[iCurrent+11]=this.cb_change_procedure
this.Control[iCurrent+12]=this.cb_change_level
this.Control[iCurrent+13]=this.cb_delete_charge
this.Control[iCurrent+14]=this.cb_switch_code
this.Control[iCurrent+15]=this.st_billing_flag_title
this.Control[iCurrent+16]=this.st_bill_yes
this.Control[iCurrent+17]=this.st_bill_no
this.Control[iCurrent+18]=this.st_override_charge
this.Control[iCurrent+19]=this.st_cpt_code_title
this.Control[iCurrent+20]=this.st_cpt_code
this.Control[iCurrent+21]=this.st_other_modifiers_title
this.Control[iCurrent+22]=this.st_other_modifiers
this.Control[iCurrent+23]=this.st_modifier_title
this.Control[iCurrent+24]=this.st_modifier
this.Control[iCurrent+25]=this.st_units_title
this.Control[iCurrent+26]=this.st_units
this.Control[iCurrent+27]=this.r_1
end on

on w_encounter_charge_edit.destroy
call super::destroy
destroy(this.st_override_title)
destroy(this.cb_clear_override)
destroy(this.st_title)
destroy(this.cb_done)
destroy(this.cb_cancel)
destroy(this.dw_assessments)
destroy(this.st_assessments_title)
destroy(this.st_procedure_title)
destroy(this.st_procedure_description)
destroy(this.cb_edit_procedure_def)
destroy(this.cb_change_procedure)
destroy(this.cb_change_level)
destroy(this.cb_delete_charge)
destroy(this.cb_switch_code)
destroy(this.st_billing_flag_title)
destroy(this.st_bill_yes)
destroy(this.st_bill_no)
destroy(this.st_override_charge)
destroy(this.st_cpt_code_title)
destroy(this.st_cpt_code)
destroy(this.st_other_modifiers_title)
destroy(this.st_other_modifiers)
destroy(this.st_modifier_title)
destroy(this.st_modifier)
destroy(this.st_units_title)
destroy(this.st_units)
destroy(this.r_1)
end on

event open;call super::open;integer li_sts

original_encounter_charge = message.powerobjectparm
modified_encounter_charge = original_encounter_charge

li_sts = load_charge()
if li_sts < 0 then
	close(this)
	return
end if

li_sts = load_assessments()
if li_sts < 0 then
	close(this)
	return
end if

if user_list.is_user_service(current_user.user_id, "CONFIG_PROCEDURES") then
	cb_edit_procedure_def.visible = true
else
	cb_edit_procedure_def.visible = false
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_encounter_charge_edit
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_encounter_charge_edit
end type

type st_override_title from statictext within w_encounter_charge_edit
integer x = 1216
integer y = 844
integer width = 571
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Override Charge $:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_clear_override from commandbutton within w_encounter_charge_edit
integer x = 2176
integer y = 856
integer width = 206
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;
setnull(modified_encounter_charge.charge)
st_override_charge.text = "N/A"
modified = true

end event

type st_title from statictext within w_encounter_charge_edit
integer x = 5
integer width = 2510
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Encounter Charge Edit"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_done from commandbutton within w_encounter_charge_edit
integer x = 1989
integer y = 1440
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;integer li_sts


li_sts = save_changes()
if li_sts < 0 then
	openwithparm(w_pop_message, "An error has occured saving the changes")
	return
end if

close(parent)

end event

type cb_cancel from commandbutton within w_encounter_charge_edit
integer x = 78
integer y = 1440
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts


if modified then
	openwithparm(w_pop_yes_no, "Do you wish to exit without saving the changes to this charge?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if

popup_return.item_count = 0
closewithreturn(parent, popup_return)

end event

type dw_assessments from u_dw_pick_list within w_encounter_charge_edit
integer x = 782
integer y = 1092
integer width = 955
integer height = 460
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_pick_proc_assessments_small"
boolean vscrollbar = true
boolean multiselect = true
end type

event clicked;call super::clicked;modified = true

end event

type st_assessments_title from statictext within w_encounter_charge_edit
integer x = 905
integer y = 1024
integer width = 704
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Associated Assessments"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_procedure_title from statictext within w_encounter_charge_edit
integer x = 32
integer y = 132
integer width = 357
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Procedure:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_procedure_description from statictext within w_encounter_charge_edit
integer x = 398
integer y = 132
integer width = 1582
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "none"
boolean border = true
boolean focusrectangle = false
end type

type cb_edit_procedure_def from commandbutton within w_encounter_charge_edit
integer x = 2002
integer y = 132
integer width = 361
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit Proc Def"
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_procedure_id

popup.data_row_count = 2
setnull(popup.items[1]) // procedure_type-- not needed if procedure_id is supplied
popup.items[2] = modified_encounter_charge.procedure_id

openwithparm(w_procedure_definition, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <= 0 then return

ls_procedure_id = popup_return.item

openwithparm(w_pop_yes_no, "The procedure definition has been modified.  Do you wish to update this charge with any changes made to the definition?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then update_charge(ls_procedure_id)

end event

type cb_change_procedure from commandbutton within w_encounter_charge_edit
integer x = 398
integer y = 232
integer width = 462
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change Procedure"
end type

event clicked;str_popup popup
str_picked_procedures lstr_procedures


popup.data_row_count = 1
popup.items[1] = modified_encounter_charge.procedure_type
popup.multiselect = false
openwithparm(w_pick_procedures, popup)
lstr_procedures = message.powerobjectparm

if lstr_procedures.procedure_count < 1 then return

update_charge(lstr_procedures.procedures[1].procedure_id)


end event

type cb_change_level from commandbutton within w_encounter_charge_edit
integer x = 919
integer y = 232
integer width = 462
integer height = 88
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change Level"
end type

event clicked;str_popup popup
str_popup_return popup_return
//string ls_cpt_code
//decimal ldc_charge
//integer li_sts
//string ls_procedure_id
//string ls_description
//string ls_category_id
//string ls_category_description
//long ll_encounter_charge_id
string ls_visit_code_group

SELECT et.visit_code_group
INTO :ls_visit_code_group
FROM P_Patient_Encounter e
	INNER JOIN c_Encounter_Type et
	ON e.encounter_type = et.encounter_type
WHERE e.cpr_id = :modified_encounter_charge.cpr_id
AND e.encounter_id = :modified_encounter_charge.encounter_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then ls_visit_code_group = "SICK"

popup.dataobject = "dw_em_visit_code_item"
popup.displaycolumn = 5
popup.datacolumn = 4
popup.argument_count = 1
popup.argument[1] = ls_visit_code_group

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

update_charge(popup_return.items[1])


end event

type cb_delete_charge from commandbutton within w_encounter_charge_edit
integer x = 78
integer y = 1080
integer width = 462
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete This Charge"
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you wish to delete this charge?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

DELETE p_Encounter_Charge
WHERE cpr_id = :modified_encounter_charge.cpr_id
AND encounter_id = :modified_encounter_charge.encounter_id
AND encounter_charge_id = :modified_encounter_charge.encounter_charge_id;
if not tf_check() then return

close(parent)



end event

type cb_switch_code from commandbutton within w_encounter_charge_edit
integer x = 1440
integer y = 232
integer width = 731
integer height = 88
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Switch To Perform Procedure"
end type

event clicked;string ls_procedure_id
u_ds_data luo_data
long ll_count

if upper(modified_encounter_charge.procedure_type) = "TESTCOLLECT" then
	SELECT o.perform_procedure_id
	INTO :ls_procedure_id
	FROM p_Treatment_Item t
		INNER JOIN c_Observation o
		ON t.observation_id = o.observation_id
		INNER JOIN c_Procedure p
		ON o.perform_procedure_id = p.procedure_id
	WHERE t.cpr_id = :modified_encounter_charge.cpr_id
	AND t.treatment_id = :modified_encounter_charge.treatment_id;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		openwithparm(w_pop_message, "This charge does not have a ~"Perform~" procedure")
		return
	end if
	cb_switch_code.text = "Switch To Collect Procedure"
else
	SELECT o.collection_procedure_id
	INTO :ls_procedure_id
	FROM p_Treatment_Item t
		INNER JOIN c_Observation o
		ON t.observation_id = o.observation_id
		INNER JOIN c_Procedure p
		ON o.perform_procedure_id = p.procedure_id
	WHERE t.cpr_id = :modified_encounter_charge.cpr_id
	AND t.treatment_id = :modified_encounter_charge.treatment_id;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		openwithparm(w_pop_message, "This charge does not have a ~"Collect~" procedure")
		return
	end if
	cb_switch_code.text = "Switch To Perform Procedure"
end if

update_charge(ls_procedure_id)


end event

type st_billing_flag_title from statictext within w_encounter_charge_edit
integer x = 96
integer y = 844
integer width = 512
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Bill This Charge:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_bill_yes from statictext within w_encounter_charge_edit
integer x = 635
integer y = 828
integer width = 165
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_bill_no.backcolor = color_object

modified_encounter_charge.charge_bill_flag = "Y"


end event

type st_bill_no from statictext within w_encounter_charge_edit
integer x = 846
integer y = 828
integer width = 165
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_bill_yes.backcolor = color_object

modified_encounter_charge.charge_bill_flag = "N"


end event

type st_override_charge from statictext within w_encounter_charge_edit
integer x = 1838
integer y = 836
integer width = 315
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "N/A"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
decimal{2} ldc_charge

ldc_charge = modified_encounter_charge.charge

popup.argument_count = 1
popup.argument[1] = "BILLINGCHARGES"
popup.title = "Enter The Override Charge"
popup.realitem = ldc_charge

openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if upper(popup_return.item) = "CANCEL" then return
ldc_charge = popup_return.realitem

// If the user entered a negative number then return
if ldc_charge < 0 or isnull(ldc_charge) then return

// If the charge did not change then return
if ldc_charge = modified_encounter_charge.charge then return

modified_encounter_charge.charge = ldc_charge
text = string(modified_encounter_charge.charge)
modified = true


end event

type st_cpt_code_title from statictext within w_encounter_charge_edit
integer x = 343
integer y = 460
integer width = 357
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "CPT Code:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_cpt_code from statictext within w_encounter_charge_edit
integer x = 709
integer y = 456
integer width = 421
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_other_modifiers_title from statictext within w_encounter_charge_edit
integer x = 1161
integer y = 592
integer width = 494
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Other Modifiers:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_other_modifiers from statictext within w_encounter_charge_edit
integer x = 1664
integer y = 588
integer width = 421
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.multiselect = true
popup.argument_count = 2
popup.argument[1] = "BillingOtherModifier"
popup.argument[2] = "BillingOtherModifier|" + modified_encounter_charge.procedure_id
popup.title = "Enter other modifiers separated by commas"
popup.displaycolumn = 12
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "" then
	setnull(modified_encounter_charge.other_modifiers)
else
	modified_encounter_charge.other_modifiers = popup_return.items[1]
end if

text = modified_encounter_charge.other_modifiers

modified = true

end event

type st_modifier_title from statictext within w_encounter_charge_edit
integer x = 1298
integer y = 460
integer width = 357
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Modifier:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_modifier from statictext within w_encounter_charge_edit
integer x = 1664
integer y = 456
integer width = 421
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.multiselect = true
popup.argument_count = 2
popup.argument[1] = "BillingModifier"
popup.argument[2] = "BillingModifier|" + modified_encounter_charge.procedure_id
popup.title = "Enter Modifier"
popup.displaycolumn = 2
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

if popup_return.items[1] = "" then
	setnull(modified_encounter_charge.modifier)
else
	modified_encounter_charge.modifier = popup_return.items[1]
end if
text = modified_encounter_charge.modifier

modified = true

end event

type st_units_title from statictext within w_encounter_charge_edit
integer x = 297
integer y = 592
integer width = 402
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Charge Units:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_units from statictext within w_encounter_charge_edit
integer x = 709
integer y = 588
integer width = 421
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "none"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
real lr_units
string ls_cpt_code

lr_units = modified_encounter_charge.units

popup.argument_count = 1
popup.argument[1] = "BILLINGUNITS"
popup.title = "Enter Number of Units to Bill"
popup.realitem = lr_units

openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if upper(popup_return.item) = "CANCEL" then return
if popup_return.realitem < 1 or isnull(popup_return.realitem) then return
if popup_return.realitem = lr_units then return

modified_encounter_charge.units = popup_return.realitem
text = string(modified_encounter_charge.units)
modified = true


end event

type r_1 from rectangle within w_encounter_charge_edit
integer linethickness = 4
long fillcolor = 33538240
integer x = 238
integer y = 392
integer width = 1970
integer height = 344
end type

