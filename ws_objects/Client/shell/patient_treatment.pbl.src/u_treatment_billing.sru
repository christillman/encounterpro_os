$PBExportHeader$u_treatment_billing.sru
forward
global type u_treatment_billing from u_tabpage
end type
type cb_add_charge from commandbutton within u_treatment_billing
end type
type st_assessment_title from statictext within u_treatment_billing
end type
type st_charge_title from statictext within u_treatment_billing
end type
type st_bill_flag_title from statictext within u_treatment_billing
end type
type st_bill_flag from statictext within u_treatment_billing
end type
type dw_assessments from u_dw_pick_list within u_treatment_billing
end type
type st_no_charges from statictext within u_treatment_billing
end type
type dw_charges from u_dw_pick_list within u_treatment_billing
end type
end forward

global type u_treatment_billing from u_tabpage
integer width = 2802
integer height = 1012
string text = "Billing"
cb_add_charge cb_add_charge
st_assessment_title st_assessment_title
st_charge_title st_charge_title
st_bill_flag_title st_bill_flag_title
st_bill_flag st_bill_flag
dw_assessments dw_assessments
st_no_charges st_no_charges
dw_charges dw_charges
end type
global u_treatment_billing u_treatment_billing

type variables
boolean initialized = false
u_component_treatment treatment
string bill_flag

u_ds_data p_encounter_assessment
u_ds_data p_encounter_assessment_charge

long encounter_charge_id

boolean first_time = true

end variables

forward prototypes
public function integer initialize (u_component_treatment puo_treatment)
public function integer load_charges ()
public function integer set_billing (long pl_assessment_row, string ps_bill_flag)
public function integer display_billing ()
public function integer display_charge (long pl_row)
public function integer display_billing (long pl_charge_row)
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize (u_component_treatment puo_treatment);integer li_count, i
string ls_date
string ls_find
str_assessment_description lstra_assessments[]
str_assessment_description lstr_assessment
str_treatment_description lstra_treatments[]
integer li_sts
long ll_row
integer li_treatment_count

treatment = puo_treatment

dw_assessments.multiselect = true

//dw_assessments.x = 12
//dw_assessments.y = 12
//dw_assessments.height = height - 24
//pb_up.x = dw_assessments.x + dw_assessments.width + 20
//pb_up.y = 20
//pb_down.x = pb_up.x
//pb_down.y = pb_up.y + pb_up.height + 20

p_encounter_assessment = CREATE u_ds_data
p_encounter_assessment.set_dataobject("dw_p_encounter_assessment")

p_encounter_assessment_charge = CREATE u_ds_data
p_encounter_assessment_charge.set_dataobject("dw_p_encounter_assessment_charge")

dw_charges.settransobject(sqlca)

setnull(encounter_charge_id)

ls_date = "datetime('" + string(current_display_encounter.encounter_date, "[shortdate] [time]") + "')"
ls_find = "(begin_date<=" + ls_date + " and (isnull(end_date) or end_date>=" + ls_date + "))"
ls_find += " or open_encounter_id=" + string(current_display_encounter.encounter_id)
ls_find += " or close_encounter_id=" + string(current_display_encounter.encounter_id)

li_count = current_patient.assessments.get_assessments(ls_find, lstra_assessments)
dw_assessments.reset()

for i = 1 to li_count
	// Check to see if the allergy has treatments.  Don't show allergies without treatments.
	if lstra_assessments[i].assessment_type = "ALLERGY" then
		ls_find = "problem_id=" + string(lstra_assessments[i].problem_id)
		ls_find += " and isnull(treatment_status)"
		li_treatment_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
		if li_treatment_count <= 0 then continue
	end if
	li_sts = current_patient.assessments.assessment(lstr_assessment, lstra_assessments[i].problem_id, lstra_assessments[i].diagnosis_sequence)
	if li_sts <= 0 then continue
	
	ll_row = dw_assessments.insertrow(0)
	dw_assessments.object.problem_id[ll_row] = lstr_assessment.problem_id
	dw_assessments.object.assessment_id[ll_row] = lstr_assessment.assessment_id
	dw_assessments.object.description[ll_row] = f_assessment_description(lstr_assessment)
	if isnull(lstr_assessment.assessment_status) then
		dw_assessments.object.icon_bitmap[ll_row] = datalist.assessment_type_icon_open(lstr_assessment.assessment_type)
	else
		dw_assessments.object.icon_bitmap[ll_row] = datalist.assessment_type_icon_closed(lstr_assessment.assessment_type)
	end if
next


if dw_charges.rowcount() <= 0 then return 0

return 1



end function

public function integer load_charges ();integer li_sts

if isnull(current_display_encounter) then
	log.log(this, "u_treatment_billing.load_charges:0004", "Invalid current_display_encounter", 4)
	return -1
end if

li_sts = dw_charges.retrieve(current_patient.cpr_id, current_patient.open_encounter_id, treatment.treatment_id)
if li_sts < 0 then return -1
if li_sts = 0 then
	dw_charges.visible = false
	st_bill_flag_title.visible = false
	st_charge_title.visible = false
	st_bill_flag.visible = false
	st_no_charges.visible = true
else
	dw_charges.visible = true
	st_bill_flag_title.visible = true
	st_charge_title.visible = true
	st_bill_flag.visible = true
	st_no_charges.visible = false
end if

if dw_charges.rowcount() <= 0 then return 0

return 1


end function

public function integer set_billing (long pl_assessment_row, string ps_bill_flag);long ll_problem_id
long ll_assessment_row
long ll_charge_row
string ls_assessment_id
string ls_find
integer li_sts
string ls_bill_flag

ll_problem_id = dw_assessments.object.problem_id[pl_assessment_row]
ls_assessment_id = dw_assessments.object.assessment_id[pl_assessment_row]

sqlca.sp_set_assmnt_charge_billing(current_patient.cpr_id, &
												current_display_encounter.encounter_id, &
												ll_problem_id, &
												encounter_charge_id, &
												ps_bill_flag, &
												current_scribe.user_id)
if not tf_check() then return -1

display_billing()

return 1

end function

public function integer display_billing ();integer li_sts
string ls_find
long ll_row

if encounter_charge_id > 0 then
	ls_find = "encounter_charge_id=" + string(encounter_charge_id)
	ll_row = dw_charges.find(ls_find, 1, dw_charges.rowcount())
end if

if isnull(ll_row) or ll_row <= 0 then
	ll_row = dw_charges.get_selected_row()
	if ll_row <= 0 then ll_row = 1
end if

li_sts = load_charges()
if li_sts <= 0 then return li_sts

if dw_charges.rowcount() > 0 then
	dw_charges.object.selected_flag[ll_row] = 1
	display_charge(ll_row)
end if


return 1

end function

public function integer display_charge (long pl_row);long i
string ls_find
integer li_sts
long ll_charges
long ll_problem_id
string ls_bill_flag
long ll_row

if pl_row <= 0 or isnull(pl_row) then return 0

// Get the encounter_charge_id
encounter_charge_id = dw_charges.object.encounter_charge_id[pl_row]

// Check the charge's own bill flag and set the bill button
ls_bill_flag = dw_charges.object.bill_flag[pl_row]
if ls_bill_flag = "Y" then
	st_bill_flag.text = "Yes"
	st_bill_flag.backcolor = color_object_selected
else
	st_bill_flag.text = "No"
	st_bill_flag.backcolor = color_object
end if


// Refresh the billing data
li_sts = p_encounter_assessment.retrieve(current_patient.cpr_id, current_patient.open_encounter_id)
if li_sts < 0 then return -1

li_sts = p_encounter_assessment_charge.retrieve(current_patient.cpr_id, current_patient.open_encounter_id)
if li_sts < 0 then return -1

// First, highlight the associated billed assessments
dw_assessments.clear_selected(false)

ls_find = "encounter_charge_id=" + string(encounter_charge_id)
ls_find += " and bill_flag='Y'"
p_encounter_assessment_charge.setfilter(ls_find)
p_encounter_assessment_charge.filter()
ll_charges = p_encounter_assessment_charge.rowcount()

for i = 1 to ll_charges
	ll_problem_id = p_encounter_assessment_charge.object.problem_id[i]
	ls_find = "problem_id=" + string(ll_problem_id)
	ll_row = dw_assessments.find(ls_find, 1, dw_assessments.rowcount())
	if ll_row > 0 then dw_assessments.object.selected_flag[ll_row] = 1
next

return 1


end function

public function integer display_billing (long pl_charge_row);
return 1

end function

public function integer initialize ();
return 1


end function

public subroutine refresh ();
if first_time then
	initialize(parent_tab.service.treatment)
	first_time = false
end if


display_billing()

end subroutine

on u_treatment_billing.create
int iCurrent
call super::create
this.cb_add_charge=create cb_add_charge
this.st_assessment_title=create st_assessment_title
this.st_charge_title=create st_charge_title
this.st_bill_flag_title=create st_bill_flag_title
this.st_bill_flag=create st_bill_flag
this.dw_assessments=create dw_assessments
this.st_no_charges=create st_no_charges
this.dw_charges=create dw_charges
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_add_charge
this.Control[iCurrent+2]=this.st_assessment_title
this.Control[iCurrent+3]=this.st_charge_title
this.Control[iCurrent+4]=this.st_bill_flag_title
this.Control[iCurrent+5]=this.st_bill_flag
this.Control[iCurrent+6]=this.dw_assessments
this.Control[iCurrent+7]=this.st_no_charges
this.Control[iCurrent+8]=this.dw_charges
end on

on u_treatment_billing.destroy
call super::destroy
destroy(this.cb_add_charge)
destroy(this.st_assessment_title)
destroy(this.st_charge_title)
destroy(this.st_bill_flag_title)
destroy(this.st_bill_flag)
destroy(this.dw_assessments)
destroy(this.st_no_charges)
destroy(this.dw_charges)
end on

event destructor;if isvalid(p_encounter_assessment) AND NOT isnull(p_encounter_assessment) then DESTROY p_encounter_assessment
if isvalid(p_encounter_assessment_charge) AND NOT isnull(p_encounter_assessment_charge) then DESTROY p_encounter_assessment_charge

end event

type cb_add_charge from commandbutton within u_treatment_billing
integer x = 219
integer y = 864
integer width = 421
integer height = 104
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Charge"
end type

event clicked;long i
long ll_problem_id
integer li_sts
str_popup popup
long ll_row
string ls_procedure_id
string ls_procedure_type
str_picked_procedures lstr_procedures

// Select procedure
popup.data_row_count = 1
setnull(popup.items[1])

openwithparm(w_pick_procedures, popup)
lstr_procedures = message.powerobjectparm
if lstr_procedures.procedure_count <> 1 then return

ls_procedure_id = lstr_procedures.procedures[1].procedure_id

encounter_charge_id = sqlca.sp_add_encounter_charge( current_patient.cpr_id, &
														current_display_encounter.encounter_id, &
														ls_procedure_id, &
														treatment.treatment_id, &
														current_scribe.user_id, &
														"N")
if not tf_check() then return -1

display_billing()



end event

type st_assessment_title from statictext within u_treatment_billing
integer x = 1262
integer width = 1070
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Associated Assessments"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_charge_title from statictext within u_treatment_billing
integer x = 169
integer width = 517
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Charges"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_bill_flag_title from statictext within u_treatment_billing
integer x = 59
integer y = 732
integer width = 430
integer height = 84
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Bill Charge:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_bill_flag from statictext within u_treatment_billing
integer x = 512
integer y = 724
integer width = 229
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

event clicked;long ll_row
string ls_bill_flag
integer li_sts

ll_row = dw_charges.get_selected_row()
if ll_row <= 0 then return

ls_bill_flag = dw_charges.object.bill_flag[ll_row]

if ls_bill_flag = "Y" then
	ls_bill_flag = "N"
else
	ls_bill_flag = "Y"
end if

tf_begin_transaction(this, "clicked")
sqlca.sp_set_charge_billing(	current_patient.cpr_id, &
										current_display_encounter.encounter_id, &
										encounter_charge_id, &
										ls_bill_flag, &
										current_scribe.user_id)
if not tf_check() then return
tf_commit()

dw_charges.object.bill_flag[ll_row] = ls_bill_flag

if ls_bill_flag = "Y" then
	backcolor = color_object_selected
	text = "Yes"
else
	backcolor = color_object
	text = "No"
end if


return

end event

type dw_assessments from u_dw_pick_list within u_treatment_billing
integer x = 974
integer y = 84
integer width = 1815
integer height = 908
integer taborder = 10
string dataobject = "dw_assessment_list"
boolean vscrollbar = true
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event selected;if isnull(encounter_charge_id) then
	clear_selected()
	return
end if

set_billing(selected_row, "Y")

end event

event unselected;if isnull(encounter_charge_id) then
	clear_selected()
	return
end if

set_billing(unselected_row, "N")

end event

type st_no_charges from statictext within u_treatment_billing
integer x = 73
integer y = 228
integer width = 2167
integer height = 308
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "No charges have been issued for this appointment "
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_charges from u_dw_pick_list within u_treatment_billing
integer x = 18
integer y = 84
integer width = 910
integer height = 620
integer taborder = 30
string dataobject = "dw_encounter_charge_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;display_charge(selected_row)

end event

