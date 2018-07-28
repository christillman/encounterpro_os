$PBExportHeader$u_cpr_exit.sru
forward
global type u_cpr_exit from u_cpr_page_base
end type
type st_code_check_status from statictext within u_cpr_exit
end type
type st_code_check_status_title from statictext within u_cpr_exit
end type
type st_bill_encounter_no from statictext within u_cpr_exit
end type
type cb_send_message from commandbutton within u_cpr_exit
end type
type st_visit_level_title from statictext within u_cpr_exit
end type
type cb_coding from commandbutton within u_cpr_exit
end type
type cb_recalc from commandbutton within u_cpr_exit
end type
type st_bill_encounter_yes from statictext within u_cpr_exit
end type
type st_bill_title from statictext within u_cpr_exit
end type
type dw_billing from u_dw_pick_list within u_cpr_exit
end type
type cb_finish_later from commandbutton within u_cpr_exit
end type
type cb_finished from commandbutton within u_cpr_exit
end type
type cb_beback from commandbutton within u_cpr_exit
end type
type cb_approve_encounter from commandbutton within u_cpr_exit
end type
type st_encounter_approved_by from statictext within u_cpr_exit
end type
end forward

global type u_cpr_exit from u_cpr_page_base
string tag = "EXIT"
st_code_check_status st_code_check_status
st_code_check_status_title st_code_check_status_title
st_bill_encounter_no st_bill_encounter_no
cb_send_message cb_send_message
st_visit_level_title st_visit_level_title
cb_coding cb_coding
cb_recalc cb_recalc
st_bill_encounter_yes st_bill_encounter_yes
st_bill_title st_bill_title
dw_billing dw_billing
cb_finish_later cb_finish_later
cb_finished cb_finished
cb_beback cb_beback
cb_approve_encounter cb_approve_encounter
st_encounter_approved_by st_encounter_approved_by
end type
global u_cpr_exit u_cpr_exit

type variables

boolean is_billed
boolean some_assessments

string coding_service
string billing_edit_service
string code_check_review_service
string code_check_perform_service


string do_later_description
string do_later_service
boolean do_later_prompt

boolean just_suspended_billing = false

string posting_service
string posting_ordered_for

string approve_service


end variables

forward prototypes
public subroutine refresh ()
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine load_billing ()
public subroutine refresh_coding ()
public function integer post_billing ()
end prototypes

public subroutine refresh ();boolean lb_replace
string ls_approved_by
u_user luo_approved_by
string ls_visit_code
string ls_code_check_status

lb_replace = false

if not isnull(current_service.encounter_id) then
	f_set_current_encounter(current_service.encounter_id)
end if

if not isnull(current_display_encounter) then
	cb_coding.visible = true
	st_visit_level_title.visible = true
	dw_billing.visible = true
	st_bill_encounter_yes.visible = true
	st_bill_encounter_no.visible = true
	st_bill_title.visible = true
	cb_finish_later.visible = true
	
	ls_approved_by = current_patient.encounters.get_property_value(current_display_encounter.encounter_id, "approved_by")
	if isnull(ls_approved_by) then
		setnull(luo_approved_by)
	else
		luo_approved_by = user_list.find_user(ls_approved_by)
	end if
	
	if isnull(luo_approved_by) then
		lb_replace = true
		st_encounter_approved_by.text = "Billing Not Approved"
		st_encounter_approved_by.backcolor = color_object
	else
		lb_replace = false
		st_encounter_approved_by.text = "Billing Approved By " + luo_approved_by.user_full_name
		st_encounter_approved_by.backcolor = luo_approved_by.color
	end if
	
	// If a visit code has been manually set then don't replace it
	ls_visit_code = current_patient.encounters.get_property_value(current_display_encounter.encounter_id, "Visit Code")
	if not isnull(ls_visit_code) then
		lb_replace = false
	end if

	if len(st_encounter_approved_by.text) > 42 then
		st_encounter_approved_by.textsize = -8
	else
		st_encounter_approved_by.textsize = -10
	end if
	
	current_patient.open_encounter.set_billing_procedure(lb_replace)
	
	if current_patient.open_encounter.bill_flag = "Y" then
		is_billed = true
		st_bill_encounter_yes.backcolor = color_object_selected
		st_bill_encounter_no.backcolor = color_object
	else
		is_billed = false
		st_bill_encounter_yes.backcolor = color_object
		st_bill_encounter_no.backcolor = color_object_selected
	end if
	
	load_billing()
	
	refresh_coding()
	if not current_display_encounter.billing_posted &
	  and (current_user.user_id = current_display_encounter.attending_doctor &
			or current_user.user_id = user_list.supervisor_user_id(current_display_encounter.attending_doctor) &
			or current_user.user_id = current_display_encounter.supervising_doctor &
			or current_user.check_privilege("Encounter Coding") &
			) then
		cb_approve_encounter.visible = true
		cb_recalc.visible = true
		st_bill_encounter_yes.enabled = true
		st_bill_encounter_no.enabled = true
		dw_billing.enabled = true
		st_bill_encounter_yes.borderstyle = styleraised!
		st_bill_encounter_no.borderstyle = styleraised!
		dw_billing.borderstyle = styleraised!
	else
		cb_approve_encounter.visible = false
		cb_recalc.visible = false
		st_bill_encounter_yes.enabled = false
		st_bill_encounter_no.enabled = false
		dw_billing.enabled = false
		st_bill_encounter_yes.borderstyle = stylebox!
		st_bill_encounter_no.borderstyle = stylebox!
		dw_billing.borderstyle = stylebox!
	end if
	
	
	// Display the Code Check status
	ls_code_check_status = current_patient.encounters.get_property_value(current_display_encounter.encounter_id, "Code Check Status")
	if isnull(ls_code_check_status) then
		st_code_check_status.text = "Not Performed"
	else
		st_code_check_status.text = wordcap(ls_code_check_status)
		if lower(ls_code_check_status) = "failed" then
			st_code_check_status.textcolor = color_text_error
		elseif lower(ls_code_check_status) = "warning" then
			st_code_check_status.textcolor = color_text_warning
		else
			st_code_check_status.textcolor = color_text_normal
		end if
	end if

	
else
	cb_coding.visible = false
	dw_billing.visible = false
	st_bill_encounter_yes.visible = false
	st_bill_encounter_no.visible = false
	st_bill_title.visible = false
	st_visit_level_title.visible = false
	cb_recalc.visible = false
	cb_finish_later.visible = false
end if



end subroutine

public subroutine initialize (u_cpr_section puo_section, integer pi_page);string ls_temp

this_section = puo_section
this_page = pi_page

cb_finished.x = width - cb_finished.width - 50
cb_finished.y = height - cb_finished.height - 50

cb_beback.x = cb_finished.x - cb_beback.width - 100
cb_beback.y = cb_finished.y

cb_finish_later.x = 100
cb_finish_later.y = cb_finished.y

cb_send_message.x = 100
cb_send_message.y = cb_finish_later.y - cb_finish_later.height - 50

dw_billing.x = width - dw_billing.width - 50


this_section.load_params(this_page)

approve_service = this_section.get_attribute(this_section.page[this_page].page_id, "approve_service")

code_check_perform_service = this_section.get_attribute(this_section.page[this_page].page_id, "code_check_perform_service")
if isnull(code_check_perform_service) then code_check_perform_service = "Code Check Perform"

code_check_review_service = this_section.get_attribute(this_section.page[this_page].page_id, "code_check_review_service")
if isnull(code_check_review_service) then code_check_review_service = "Code Check Review"

do_later_service = this_section.get_attribute(this_section.page[this_page].page_id, "do_later_service")
if isnull(do_later_service) then do_later_service = "CHART"

do_later_description = this_section.get_attribute(this_section.page[this_page].page_id, "do_later_description")
if isnull(do_later_description) then do_later_description = "Review/Finish Charting"

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "do_later_prompt")
if isnull(ls_temp) then ls_temp = "True"
do_later_prompt = f_string_to_boolean(ls_temp)

coding_service = this_section.get_attribute(this_section.page[this_page].page_id, "coding_service")
if isnull(coding_service) then coding_service = "EMCODING"

billing_edit_service = this_section.get_attribute(this_section.page[this_page].page_id, "billing_edit_service")
if isnull(billing_edit_service) then billing_edit_service = "BILLING"

posting_service = this_section.get_attribute(this_section.page[this_page].page_id, "posting_service")
if isnull(posting_service) then posting_service = "SENDBILLING"

posting_ordered_for = this_section.get_attribute(this_section.page[this_page].page_id, "posting_ordered_for")
if isnull(posting_ordered_for) then posting_ordered_for = "#BILL"

if not f_is_module_licensed("Code Checker") then
	st_code_check_status.visible = false
	st_code_check_status_title.visible = false
end if

end subroutine

public subroutine load_billing ();str_encounter_assessment lstr_assessments[]
integer li_assessment_count
integer i, j
long ll_sort_sequence
long ll_row
long ll_treatment_id
string ls_cpt_code
long ll_charge_count
long lla_encounter_charge_id[]
long ll_charge_index
long k

dw_billing.settransobject(sqlca)
dw_billing.retrieve(current_patient.cpr_id, current_patient.open_encounter.encounter_id)

//current_patient.open_encounter.get_billing(lstr_assessments, li_assessment_count)
//
//dw_billing.setredraw(false)
//
//dw_billing.reset()
//
//ll_charge_count = 0
//
//if li_assessment_count = 0 then
//	ll_row = dw_billing.insertrow(0)
//	dw_billing.setitem(ll_row, "assessment_description", "No Billed Diagnoses")
//	dw_billing.setitem(ll_row, "assessment_bill_flag", "N")
//	dw_billing.setitem(ll_row, "treatment_bill_flag", "N")
//	dw_billing.setitem(ll_row, "description", "No Billed Items")
//	some_assessments = false
//	st_bill_encounter_yes.backcolor = color_object
//	st_bill_encounter_no.backcolor = color_object_selected
//	is_billed = false
//else
//	some_assessments = true
//	for i = 1 to li_assessment_count
//		if lstr_assessments[i].charge_count = 0 then
//			ll_row = dw_billing.insertrow(0)
//			dw_billing.setitem(ll_row, "assessment_description", lstr_assessments[i].description)
//			dw_billing.setitem(ll_row, "icd_9_code", lstr_assessments[i].icd_9_code)
//			dw_billing.setitem(ll_row, "description", "Diagnoses With No Billed Items")
//			dw_billing.setitem(ll_row, "cpr_id", current_patient.cpr_id)
//			dw_billing.setitem(ll_row, "problem_id", lstr_assessments[i].problem_id)
//			dw_billing.setitem(ll_row, "assessment_bill_flag", lstr_assessments[i].bill_flag)
//			dw_billing.setitem(ll_row, "treatment_bill_flag", "Y")
//		else
//			if lstr_assessments[i].bill_flag <> "Y" then continue
//			for j = 1 to lstr_assessments[i].charge_count
//				// Find the charge index in our local list
//				ll_charge_index = 0
//				for k = 1 to ll_charge_count
//					if lla_encounter_charge_id[k] = lstr_assessments[i].charge[j].encounter_charge_id then
//						ll_charge_index = k
//						exit
//					end if
//				next
//				if ll_charge_index = 0 then
//					ll_charge_count += 1
//					lla_encounter_charge_id[ll_charge_count] = lstr_assessments[i].charge[j].encounter_charge_id
//					ll_charge_index = ll_charge_count
//				end if
//				
//				if lstr_assessments[i].charge[j].assessment_charge_bill_flag <> "Y" then continue
//				if lstr_assessments[i].charge[j].charge_bill_flag <> "Y" then continue
//				ll_row = dw_billing.insertrow(0)
//				dw_billing.setitem(ll_row, "assessment_description", lstr_assessments[i].description)
//				dw_billing.setitem(ll_row, "icd_9_code", lstr_assessments[i].icd_9_code)
//				dw_billing.setitem(ll_row, "description", lstr_assessments[i].charge[j].description)
//				ls_cpt_code = lstr_assessments[i].charge[j].cpt_code
//				if lstr_assessments[i].charge[j].units > 1 then
//					ls_cpt_code += " x" + string(lstr_assessments[i].charge[j].units)
//				end if
//				dw_billing.setitem(ll_row, "cpt_code", ls_cpt_code)
//				dw_billing.setitem(ll_row, "charge", lstr_assessments[i].charge[j].charge)
//				dw_billing.setitem(ll_row, "cpr_id", current_patient.cpr_id)
//				dw_billing.setitem(ll_row, "problem_id", lstr_assessments[i].problem_id)
//				dw_billing.setitem(ll_row, "treatment_id", lstr_assessments[i].charge[j].treatment_id)
//				dw_billing.setitem(ll_row, "encounter_charge_id", lstr_assessments[i].charge[j].encounter_charge_id)
//				dw_billing.setitem(ll_row, "assessment_bill_flag", lstr_assessments[i].bill_flag)
//				dw_billing.setitem(ll_row, "treatment_bill_flag", lstr_assessments[i].charge[j].charge_bill_flag)
//
//				// Sort the records so that all the records for the same charge sort together
//				if lstr_assessments[i].charge[j].procedure_type = "PRIMARY" then
//					// Sort the primary charges to the top
//					ll_sort_sequence = i - 200
//				elseif lstr_assessments[i].charge[j].procedure_type = "SECONDARY" then
//					// Sort the secondary charges to below the primary charges
//					ll_sort_sequence = i - 100
//				else
//					// sort everything else in the order we found them but keep the charges together
//					// and sort the assessments within the charges
//					ll_sort_sequence = i + (ll_charge_index * li_assessment_count)
//				end if
//
//				dw_billing.setitem(ll_row, "sort_sequence", ll_sort_sequence)
//			next
//		end if
//	next
//end if
//
//dw_billing.sort()
//dw_billing.groupcalc()
//dw_billing.setredraw(true)
//
end subroutine

public subroutine refresh_coding ();integer li_encounter_level

li_encounter_level = f_current_visit_level(current_patient.cpr_id, current_display_encounter.encounter_id)

if isnull(li_encounter_level) then
	cb_coding.text = "0"
else
	cb_coding.text = string(li_encounter_level)
end if


end subroutine

public function integer post_billing ();integer li_sts
String ls_cpr_id,ls_find
Long ll_encounter_id,ll_find

// Update flag if it shows an error
UPDATE p_Patient_Encounter
SET billing_posted = "R"
WHERE cpr_id = :current_patient.cpr_id
AND encounter_id = :current_display_encounter.encounter_id
AND billing_posted = "E";
if not tf_check() then return -1

li_sts = service_list.order_service(current_patient.cpr_id, current_display_encounter.encounter_id, posting_service, posting_ordered_for, "Post Billing")

return li_sts


end function

on u_cpr_exit.create
int iCurrent
call super::create
this.st_code_check_status=create st_code_check_status
this.st_code_check_status_title=create st_code_check_status_title
this.st_bill_encounter_no=create st_bill_encounter_no
this.cb_send_message=create cb_send_message
this.st_visit_level_title=create st_visit_level_title
this.cb_coding=create cb_coding
this.cb_recalc=create cb_recalc
this.st_bill_encounter_yes=create st_bill_encounter_yes
this.st_bill_title=create st_bill_title
this.dw_billing=create dw_billing
this.cb_finish_later=create cb_finish_later
this.cb_finished=create cb_finished
this.cb_beback=create cb_beback
this.cb_approve_encounter=create cb_approve_encounter
this.st_encounter_approved_by=create st_encounter_approved_by
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_code_check_status
this.Control[iCurrent+2]=this.st_code_check_status_title
this.Control[iCurrent+3]=this.st_bill_encounter_no
this.Control[iCurrent+4]=this.cb_send_message
this.Control[iCurrent+5]=this.st_visit_level_title
this.Control[iCurrent+6]=this.cb_coding
this.Control[iCurrent+7]=this.cb_recalc
this.Control[iCurrent+8]=this.st_bill_encounter_yes
this.Control[iCurrent+9]=this.st_bill_title
this.Control[iCurrent+10]=this.dw_billing
this.Control[iCurrent+11]=this.cb_finish_later
this.Control[iCurrent+12]=this.cb_finished
this.Control[iCurrent+13]=this.cb_beback
this.Control[iCurrent+14]=this.cb_approve_encounter
this.Control[iCurrent+15]=this.st_encounter_approved_by
end on

on u_cpr_exit.destroy
call super::destroy
destroy(this.st_code_check_status)
destroy(this.st_code_check_status_title)
destroy(this.st_bill_encounter_no)
destroy(this.cb_send_message)
destroy(this.st_visit_level_title)
destroy(this.cb_coding)
destroy(this.cb_recalc)
destroy(this.st_bill_encounter_yes)
destroy(this.st_bill_title)
destroy(this.dw_billing)
destroy(this.cb_finish_later)
destroy(this.cb_finished)
destroy(this.cb_beback)
destroy(this.cb_approve_encounter)
destroy(this.st_encounter_approved_by)
end on

type cb_configure_tab from u_cpr_page_base`cb_configure_tab within u_cpr_exit
end type

type st_code_check_status from statictext within u_cpr_exit
integer x = 722
integer y = 488
integer width = 690
integer height = 112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Not Performed"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_code_check_status
str_attributes lstr_attributes
integer li_idx

ls_code_check_status = current_patient.encounters.get_property_value(current_display_encounter.encounter_id, "Code Check Status")
if isnull(ls_code_check_status) then
	openwithparm(w_pop_yes_no, "The Code Check service has not yet been performed on this encounter.  Do you with to perform the Code Check service now?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return

	li_idx = f_please_wait_open()
	
	service_list.do_service(current_patient.cpr_id, &
									current_service.encounter_id, &
									code_check_perform_service, &
									lstr_attributes)
	
	f_please_wait_close(li_idx)
end if

service_list.do_service(current_patient.cpr_id, &
								current_service.encounter_id, &
								code_check_review_service, &
								lstr_attributes)

end event

type st_code_check_status_title from statictext within u_cpr_exit
integer y = 500
integer width = 704
integer height = 88
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Code Check Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_bill_encounter_no from statictext within u_cpr_exit
integer x = 1088
integer y = 64
integer width = 206
integer height = 112
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

event clicked;
backcolor = color_object_selected
st_bill_encounter_yes.backcolor = color_object
is_billed = false
current_patient.encounters.modify_encounter(current_display_encounter.encounter_id, "bill_flag", "N")


end event

type cb_send_message from commandbutton within u_cpr_exit
integer x = 91
integer y = 924
integer width = 709
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Send Message"
end type

event clicked;str_attributes lstr_attributes

service_list.do_service(current_patient.cpr_id, &
								current_service.encounter_id, &
								"SENDMESSAGE", &
								lstr_attributes)


end event

type st_visit_level_title from statictext within u_cpr_exit
integer y = 288
integer width = 704
integer height = 88
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Current Visit Level:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_coding from commandbutton within u_cpr_exit
integer x = 722
integer y = 276
integer width = 206
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "1"
end type

event clicked;str_attributes lstr_attributes

if isnull(current_display_encounter) then return

service_list.do_service(current_patient.cpr_id, current_display_encounter.encounter_id, coding_service)

refresh_coding()

current_patient.open_encounter.set_billing_procedure(true)
load_billing()

end event

type cb_recalc from commandbutton within u_cpr_exit
integer x = 946
integer y = 276
integer width = 690
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recalculate Visit Code"
end type

event clicked;
current_patient.open_encounter.set_billing_procedure(true)
load_billing()

end event

type st_bill_encounter_yes from statictext within u_cpr_exit
integer x = 855
integer y = 64
integer width = 206
integer height = 112
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

event clicked;if not some_assessments then
	openwithparm(w_pop_message, "This encounter cannot be billed since there are no assessments associated with it.")
	return
end if

backcolor = color_object_selected
st_bill_encounter_no.backcolor = color_object
is_billed = true
current_patient.encounters.modify_encounter(current_display_encounter.encounter_id, "bill_flag", "Y")


end event

type st_bill_title from statictext within u_cpr_exit
integer x = 32
integer y = 84
integer width = 791
integer height = 88
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Bill This Encounter:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_billing from u_dw_pick_list within u_cpr_exit
integer x = 1714
integer y = 20
integer width = 1134
integer height = 1048
integer taborder = 10
string dataobject = "dw_jmj_encounter_charges_small"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;str_attributes lstr_attributes

if isnull(current_display_encounter) then return

service_list.do_service(billing_edit_service)

load_billing()

end event

type cb_finish_later from commandbutton within u_cpr_exit
integer x = 91
integer y = 1092
integer width = 709
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Finish Later"
end type

event clicked;str_attributes lstr_attributes
str_popup popup
str_popup_return popup_return
integer li_choice
string ls_description
integer li_null

setnull(li_null)

f_attribute_add_attribute(lstr_attributes, "in_office_flag", "N")
ls_description = do_later_description

if do_later_prompt then
	popup.title = "Enter a reason or note for completing this chart later"
	popup.argument_count = 1
	popup.argument[1] = "CHARTLATER"
	
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	ls_description += " - " + popup_return.items[1]
end if

// If this encounter is open and billed
if upper(current_display_encounter.encounter_status) = "OPEN" &
	and not current_display_encounter.billing_posted &
	and current_display_encounter.attending_doctor = current_user.user_id &
	and is_billed then
	popup.title = "This encounter has not yet been sent to the billing system."
	popup.title += "  Do you wish to send this encounter to the billing system now"
	popup.title += " or wait until you are finished charting?"
	popup.data_row_count = 3
	popup.items[1] = "Send Billing Now"
	popup.items[2] = "Send Billing Later"
	popup.items[3] = "Cancel"
	openwithparm(w_pop_choices_3, popup)
	li_choice = message.doubleparm
	CHOOSE CASE li_choice
		CASE 1
			current_patient.set_encounter_property( current_display_encounter.encounter_id, "send_billing_suspended", "F")
		CASE 2
			current_patient.set_encounter_property( current_display_encounter.encounter_id, "send_billing_suspended", "T")
			just_suspended_billing = true
		CASE ELSE
			return
	END CHOOSE
end if

// Order the service
service_list.order_service( current_patient.cpr_id, &
								current_display_encounter.encounter_id, &
								do_later_service, &
								current_user.user_id, &
								ls_description, &
								li_null, &
								lstr_attributes)


// Act like the user clicked "I'm Finished"
this_section.my_cpr_main.close("CLOSE")


end event

type cb_finished from commandbutton within u_cpr_exit
integer x = 2149
integer y = 1100
integer width = 709
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'m Finished"
end type

event clicked;boolean lb_send_billing_suspended
string ls_prompt
str_popup_return popup_return

// Check to see if we need to release the billing
if not isnull(current_display_encounter) then
	if current_display_encounter.attending_doctor = current_user.user_id &
	  and is_billed &
	  and not just_suspended_billing then
		// We're billable so see if we're suspended
		lb_send_billing_suspended = f_string_to_boolean(current_patient.encounters.get_property_value(current_display_encounter.encounter_id, "send_billing_suspended"))
		if lb_send_billing_suspended then
			// We're suspended so see if the user wants to release the suspension
			ls_prompt = "The billing send for this encounter was previously suspended.  Do you wish to release this encounter to be sent to the billing system now?"
			openwithparm(w_pop_yes_no, ls_prompt)
			popup_return = message.powerobjectparm
			if popup_return.item = "YES" then
				// Release the encounter
				current_patient.set_encounter_property( current_display_encounter.encounter_id, "send_billing_suspended", "F")
				// if the encounter is closed, then dispatch a send_billing service
				if upper(current_display_encounter.encounter_status) = "CLOSED" then
					post_billing()
				end if
			end if
		end if
	end if
end if


this_section.my_cpr_main.close("CLOSE")

end event

type cb_beback from commandbutton within u_cpr_exit
integer x = 1367
integer y = 1100
integer width = 709
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;this_section.my_cpr_main.close()

end event

type cb_approve_encounter from commandbutton within u_cpr_exit
integer x = 1170
integer y = 700
integer width = 443
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Approve Billing"
end type

event clicked;str_attributes lstr_attributes

if isnull(approve_service) then
	current_patient.set_encounter_property(current_display_encounter.encounter_id, "approved_by", current_user.user_id)
else
	service_list.do_service(current_patient.cpr_id, &
									current_service.encounter_id, &
									approve_service, &
									lstr_attributes)
end if


refresh()

end event

type st_encounter_approved_by from statictext within u_cpr_exit
integer x = 37
integer y = 700
integer width = 1120
integer height = 112
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

