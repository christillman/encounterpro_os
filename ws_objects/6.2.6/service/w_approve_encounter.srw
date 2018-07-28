HA$PBExportHeader$w_approve_encounter.srw
forward
global type w_approve_encounter from w_window_base
end type
type cb_finished from commandbutton within w_approve_encounter
end type
type st_recheck_user from statictext within w_approve_encounter
end type
type st_order_title from statictext within w_approve_encounter
end type
type cb_be_back from commandbutton within w_approve_encounter
end type
type st_the_following from statictext within w_approve_encounter
end type
type st_desc from statictext within w_approve_encounter
end type
type dw_new_rx from u_dw_pick_list within w_approve_encounter
end type
type dw_billing from u_dw_pick_list within w_approve_encounter
end type
type st_the_billing from statictext within w_approve_encounter
end type
type st_bill_title from statictext within w_approve_encounter
end type
type st_bill_encounter from statictext within w_approve_encounter
end type
type cb_recalc from commandbutton within w_approve_encounter
end type
type cb_clear from commandbutton within w_approve_encounter
end type
type st_recheck_desc from statictext within w_approve_encounter
end type
type cb_coding from commandbutton within w_approve_encounter
end type
type st_title from statictext within w_approve_encounter
end type
type str_billable_tests from structure within w_approve_encounter
end type
end forward

type str_billable_tests from structure
	integer		objective_set
	string		observation_id
	long		problem_id
	integer		treatment_sequence
	string		collected
	string		performed
	string		procedure_id
	string		description
	string		perform_flag
	string		cpt_code
	decimal {0}	charge
end type

global type w_approve_encounter from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
cb_finished cb_finished
st_recheck_user st_recheck_user
st_order_title st_order_title
cb_be_back cb_be_back
st_the_following st_the_following
st_desc st_desc
dw_new_rx dw_new_rx
dw_billing dw_billing
st_the_billing st_the_billing
st_bill_title st_bill_title
st_bill_encounter st_bill_encounter
cb_recalc cb_recalc
cb_clear cb_clear
st_recheck_desc st_recheck_desc
cb_coding cb_coding
st_title st_title
end type
global w_approve_encounter w_approve_encounter

type variables
u_component_service service

boolean is_posted
boolean is_billed
boolean some_assessments

boolean capture_signature

string recheck_user_id

string coding_service
string billing_edit_service

end variables

forward prototypes
public subroutine load_billing ()
public subroutine load_new_rx_list ()
public subroutine set_rx_signed (long pl_attachment_id)
public function integer order_recheck ()
public subroutine refresh_coding ()
end prototypes

public subroutine load_billing ();str_encounter_assessment lstr_assessments[]
integer li_assessment_count
integer i, j
long ll_sort_sequence
long ll_row
long ll_treatment_id

dw_billing.settransobject(sqlca)
dw_billing.retrieve(current_patient.cpr_id, current_patient.open_encounter.encounter_id)

//current_patient.open_encounter.get_billing(lstr_assessments, li_assessment_count)
//
//dw_billing.setredraw(false)
//
//dw_billing.reset()
//
//if li_assessment_count = 0 then
//	ll_row = dw_billing.insertrow(0)
//	dw_billing.setitem(ll_row, "assessment_description", "No Billed Diagnoses")
//	dw_billing.setitem(ll_row, "assessment_bill_flag", "N")
//	dw_billing.setitem(ll_row, "treatment_bill_flag", "N")
//	dw_billing.setitem(ll_row, "description", "No Billed Items")
//	some_assessments = false
//	st_bill_encounter.backcolor = color_object
//	st_bill_encounter.text = "No"
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
//				if lstr_assessments[i].charge[j].assessment_charge_bill_flag <> "Y" then continue
//				if lstr_assessments[i].charge[j].charge_bill_flag <> "Y" then continue
//				ll_row = dw_billing.insertrow(0)
//				dw_billing.setitem(ll_row, "assessment_description", lstr_assessments[i].description)
//				dw_billing.setitem(ll_row, "icd_9_code", lstr_assessments[i].icd_9_code)
//				dw_billing.setitem(ll_row, "description", lstr_assessments[i].charge[j].description)
//				dw_billing.setitem(ll_row, "cpt_code", lstr_assessments[i].charge[j].cpt_code)
//				dw_billing.setitem(ll_row, "charge", lstr_assessments[i].charge[j].charge)
//				dw_billing.setitem(ll_row, "cpr_id", current_patient.cpr_id)
//				dw_billing.setitem(ll_row, "problem_id", lstr_assessments[i].problem_id)
//				dw_billing.setitem(ll_row, "treatment_id", lstr_assessments[i].charge[j].treatment_id)
//				dw_billing.setitem(ll_row, "encounter_charge_id", lstr_assessments[i].charge[j].encounter_charge_id)
//				ll_sort_sequence = lstr_assessments[i].charge[j].encounter_charge_id
//				if lstr_assessments[i].charge[j].procedure_type = "PRIMARY" then
//					ll_sort_sequence -= 1000001
//				end if
//				if lstr_assessments[i].charge[j].procedure_type = "SECONDARY" then
//					ll_sort_sequence -= 1000000
//				end if
//				dw_billing.setitem(ll_row, "sort_sequence", ll_sort_sequence)
//				dw_billing.setitem(ll_row, "assessment_bill_flag", lstr_assessments[i].bill_flag)
//				dw_billing.setitem(ll_row, "treatment_bill_flag", lstr_assessments[i].charge[j].charge_bill_flag)
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

public subroutine load_new_rx_list ();integer i, j
long ll_row
long ll_rowcount
long ll_treatment_id
string ls_temp,ls_find,ls_signed_by
integer li_sts
str_encounter_description lstr_encounter
str_treatment_description 		lstr_treatment
str_progress_list lstr_attachments

dw_new_rx.setredraw(false)
dw_new_rx.reset()

current_patient.encounters.encounter(lstr_encounter, current_patient.open_encounter.encounter_id)

temp_datastore.set_dataobject("dw_rx_list")
temp_datastore.retrieve(current_patient.cpr_id, current_patient.open_encounter.encounter_id)
ll_rowcount = temp_datastore.rowcount()


for i = 1 to ll_rowcount
	ll_treatment_id = temp_datastore.object.treatment_id[i]
	ll_row = dw_new_rx.insertrow(0)
	dw_new_rx.setitem(ll_row, "treatment_id", ll_treatment_id)
	lstr_treatment.treatment_id = ll_treatment_id
	lstr_treatment.begin_date = temp_datastore.object.begin_date[i]
	lstr_treatment.end_date = temp_datastore.object.end_date[i]
	lstr_treatment.close_encounter_id = temp_datastore.object.close_encounter_id[i]
	lstr_treatment.treatment_description = temp_datastore.object.treatment_description[i]
	lstr_treatment.treatment_status = temp_datastore.object.treatment_status[i]
	lstr_treatment.open_encounter_id = temp_datastore.object.open_encounter_id[i]
	
	ls_temp = f_treatment_full_description(lstr_treatment,lstr_encounter)
	
	lstr_attachments = current_patient.attachments.get_attachments( "Treatment", ll_treatment_id, "Attachment", "Signature")
	
	// If the treatment already has a signature then show who signed it
	If lstr_attachments.progress_count > 0 Then
		ls_signed_by = user_list.user_full_name(lstr_attachments.progress[lstr_attachments.progress_count].user_id)
		ls_temp += " (Signed by " + ls_signed_by + ")"
		dw_new_rx.setitem(ll_row,"signed",1)
	end if
	dw_new_rx.setitem(ll_row, "rx_sig", ls_temp)
next

dw_new_rx.setredraw(true)

return

end subroutine

public subroutine set_rx_signed (long pl_attachment_id);Integer i
Long    ll_rows,ll_treatment_id

DECLARE lsp_set_treatment_signature PROCEDURE FOR dbo.sp_set_treatment_signature
	@pl_treatment_id = :ll_treatment_id,
	@pl_attachment_id = :pl_attachment_id;

ll_rows = dw_new_rx.rowcount()
For i = 1 to ll_rows
	If dw_new_rx.object.signed[i] = 1 Then Continue
	ll_treatment_id = dw_new_rx.object.treatment_id[i]
	EXECUTE lsp_set_treatment_signature;
Next
Return


end subroutine

public function integer order_recheck ();long ll_encounter_id
string ls_cpr_id

ls_cpr_id = current_patient.cpr_id
ll_encounter_id = current_patient.open_encounter_id
service_list.order_service(ls_cpr_id,ll_encounter_id,"RECHECK",recheck_user_id,st_recheck_desc.text)

Return 1

end function

public subroutine refresh_coding ();integer li_encounter_level

li_encounter_level = f_current_visit_level(current_patient.cpr_id, current_display_encounter.encounter_id)

if isnull(li_encounter_level) then
	cb_coding.text = "0"
else
	cb_coding.text = string(li_encounter_level)
end if


end subroutine

on w_approve_encounter.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.st_recheck_user=create st_recheck_user
this.st_order_title=create st_order_title
this.cb_be_back=create cb_be_back
this.st_the_following=create st_the_following
this.st_desc=create st_desc
this.dw_new_rx=create dw_new_rx
this.dw_billing=create dw_billing
this.st_the_billing=create st_the_billing
this.st_bill_title=create st_bill_title
this.st_bill_encounter=create st_bill_encounter
this.cb_recalc=create cb_recalc
this.cb_clear=create cb_clear
this.st_recheck_desc=create st_recheck_desc
this.cb_coding=create cb_coding
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.st_recheck_user
this.Control[iCurrent+3]=this.st_order_title
this.Control[iCurrent+4]=this.cb_be_back
this.Control[iCurrent+5]=this.st_the_following
this.Control[iCurrent+6]=this.st_desc
this.Control[iCurrent+7]=this.dw_new_rx
this.Control[iCurrent+8]=this.dw_billing
this.Control[iCurrent+9]=this.st_the_billing
this.Control[iCurrent+10]=this.st_bill_title
this.Control[iCurrent+11]=this.st_bill_encounter
this.Control[iCurrent+12]=this.cb_recalc
this.Control[iCurrent+13]=this.cb_clear
this.Control[iCurrent+14]=this.st_recheck_desc
this.Control[iCurrent+15]=this.cb_coding
this.Control[iCurrent+16]=this.st_title
end on

on w_approve_encounter.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.st_recheck_user)
destroy(this.st_order_title)
destroy(this.cb_be_back)
destroy(this.st_the_following)
destroy(this.st_desc)
destroy(this.dw_new_rx)
destroy(this.dw_billing)
destroy(this.st_the_billing)
destroy(this.st_bill_title)
destroy(this.st_bill_encounter)
destroy(this.cb_recalc)
destroy(this.cb_clear)
destroy(this.st_recheck_desc)
destroy(this.cb_coding)
destroy(this.st_title)
end on

event open;call super::open;integer 				li_sts,li_log_index
str_popup_return 	popup_return
str_popup 			popup
long ll_menu_id
string ls_temp

popup_return.item_count = 0

service = Message.Powerobjectparm

if isnull(current_patient.open_encounter) then
	log.log(this, "open", "No open encounter", 4)
	closewithreturn(this, popup_return)
	return
end if

title = current_patient.id_line()

current_patient.open_encounter.set_billing_procedure(false)

if current_patient.open_encounter.bill_flag = "Y" then
	is_billed = true
	st_bill_encounter.backcolor = color_object_selected
	st_bill_encounter.text = "Yes"
else
	is_billed = false
	st_bill_encounter.backcolor = color_object
	st_bill_encounter.text = "No"
end if

load_new_rx_list()
load_billing()

setnull(recheck_user_id)

cb_clear.visible = false

is_posted = current_patient.open_encounter.is_posted()

if is_posted then
	dw_billing.modify("datawindow.color=" + string(COLOR_DARK_GREY))
	dw_billing.enabled = false
	st_the_billing.text = "The following items were billed:"
else
	dw_billing.modify("datawindow.color=" + string(COLOR_LIGHT_GREY))
	dw_billing.enabled = true
	st_the_billing.text = "The following items will be billed:"
end if

coding_service = service.get_attribute("coding_service")
if isnull(coding_service) then coding_service = "EMCODING"

billing_edit_service = service.get_attribute("billing_edit_service")
if isnull(billing_edit_service) then billing_edit_service = "BILLING"

ls_temp = service.get_attribute("capture_signature")
if isnull(ls_temp) then ls_temp = "True"
capture_signature = f_string_to_boolean(ls_temp)

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.text = "Cancel"
else
	cb_be_back.text = "I'll Be Back"
end if

max_buttons = 3
ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)


refresh_coding()


end event

type pb_epro_help from w_window_base`pb_epro_help within w_approve_encounter
boolean visible = true
integer x = 2642
integer y = 1368
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_approve_encounter
end type

type cb_finished from commandbutton within w_approve_encounter
integer x = 2258
integer y = 1612
integer width = 608
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Approve Encounter"
end type

event clicked;string				ls_temp,ls_service
String				ls_find
long					ll_encounter_id,ll_attachment_id
integer				li_sts
str_popup popup

str_popup_return popup_return
str_attributes   lstra_attributes
str_attachment   lstr_attachment
str_progress_list lstr_attachments

if capture_signature then
	// See if a signature device is available
	if not f_is_external_source_available("Signature") then
		popup.title = "This computer does not have a signature capture device.  Do you wish to:"
		popup.data_row_count = 2
		popup.items[1] = "Approve Without Signing"
		popup.items[2] = "Sign Later"
		openwithparm(w_pop_choices_2, popup)
		li_sts = message.doubleparm
		if li_sts = 1 then
			popup_return.item_count = 1
			popup_return.items[1] = "COMPLETE"
		else
			popup_return.item_count = 0
		end if
		closewithreturn(parent, popup_return)
		return
	end if
	
	// get the service name for calling signature window
	ls_service = service.get_attribute("signature_service")
	If isnull(ls_service) Then ls_service = "EXTERNAL_SOURCE"
	
	ll_encounter_id = current_patient.open_encounter.encounter_id
	
	f_attribute_add_attribute(lstra_attributes, "encounter_id", String(ll_encounter_id))
	f_attribute_add_attribute(lstra_attributes, "external_source_type", "Signature")

	ls_temp = service.get_attribute("signature_progress_type")
	if isnull(ls_temp) then ls_temp = "Signature"
	f_attribute_add_attribute(lstra_attributes, "progress_type", ls_temp)
	
	ls_temp = service.get_attribute("signature_progress_key")
	if isnull(ls_temp) then ls_temp = "Encounter Owner"
	f_attribute_add_attribute(lstra_attributes, "progress_key", ls_temp)
	
	li_sts = service_list.do_service(ls_service,lstra_attributes)
	If li_sts <> 1 Then
		popup.title = "No signature was captured.  Do you wish to:"
		popup.data_row_count = 3
		popup.items[1] = "Try Again"
		popup.items[2] = "Approve Without Signing"
		popup.items[3] = "Sign Later"
		openwithparm(w_pop_choices_3, popup)
		li_sts = message.doubleparm
		if li_sts = 1 then
			return
		elseif li_sts = 2 then
			popup_return.item_count = 1
			popup_return.items[1] = "COMPLETE"
		else
			popup_return.item_count = 0
		end if
		closewithreturn(parent, popup_return)
		return
	End If
	

	lstr_attachments = current_patient.attachments.get_attachments( "Encounter", ll_encounter_id, "Attachment", "Signature")
	
	If lstr_attachments.progress_count > 0 Then
		ll_attachment_id = lstr_attachments.progress[lstr_attachments.progress_count].attachment_id
		// Use the encounter signature for all other unsigned Rx's
		If ll_attachment_id > 0 Then set_rx_signed(ll_attachment_id)
	End If
end if

if not isnull(recheck_user_id) then order_recheck()

popup_return.item_count = 1
popup_return.items[1] = "COMPLETE"
popup_return.item = "COMPLETE"

closewithreturn(parent, popup_return)

end event

type st_recheck_user from statictext within w_approve_encounter
event clicked pbm_bnclicked
integer x = 773
integer y = 1140
integer width = 718
integer height = 120
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string lsa_user_id[]
u_user luo_user

luo_user = user_list.pick_user("ALL")
if isnull(luo_user) then return

text = luo_user.user_short_name
backcolor = luo_user.color

recheck_user_id = luo_user.user_id
st_desc.visible = true
st_recheck_desc.visible = true
cb_clear.visible = true


end event

type st_order_title from statictext within w_approve_encounter
integer x = 192
integer y = 1164
integer width = 553
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Order Recheck By:"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_be_back from commandbutton within w_approve_encounter
event clicked pbm_bnclicked
integer x = 1787
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return


if service.manual_service then
	popup_return.item_count = 1
	popup_return.items[1] = "CANCEL"
	popup_return.item = "CANCEL"
else
	if not isnull(recheck_user_id) then order_recheck()
	popup_return.item_count = 1
	popup_return.items[1] = "INCOMPLETE"
	popup_return.item = "INCOMPLETE"
end if

closewithreturn(parent, popup_return)


end event

type st_the_following from statictext within w_approve_encounter
integer x = 201
integer y = 224
integer width = 1289
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "The following medications were prescribed:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_desc from statictext within w_approve_encounter
boolean visible = false
integer x = 142
integer y = 1280
integer width = 603
integer height = 52
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Recheck Description"
boolean focusrectangle = false
end type

type dw_new_rx from u_dw_pick_list within w_approve_encounter
integer x = 37
integer y = 304
integer width = 1669
integer height = 720
integer taborder = 40
string dataobject = "dw_new_rx_list"
borderstyle borderstyle = styleraised!
end type

type dw_billing from u_dw_pick_list within w_approve_encounter
integer x = 1742
integer y = 304
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

type st_the_billing from statictext within w_approve_encounter
integer x = 1751
integer y = 224
integer width = 1079
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "The following items will be billed:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_bill_title from statictext within w_approve_encounter
integer x = 1797
integer y = 124
integer width = 699
integer height = 88
boolean bringtotop = true
integer textsize = -10
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

type st_bill_encounter from statictext within w_approve_encounter
integer x = 2514
integer y = 112
integer width = 279
integer height = 100
boolean bringtotop = true
integer textsize = -12
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

event clicked;
if not some_assessments then
	openwithparm(w_pop_message, "This encounter cannot be billed since there are no assessments associated with it.")
	return
end if

if is_billed then
	text = "No"
	is_billed = false
	current_patient.encounters.modify_encounter(current_display_encounter.encounter_id, "bill_flag", "N")
else
	text = "Yes"
	is_billed = true
	current_patient.encounters.modify_encounter(current_display_encounter.encounter_id, "bill_flag", "Y")
end if

end event

type cb_recalc from commandbutton within w_approve_encounter
integer x = 1906
integer y = 1360
integer width = 690
integer height = 112
integer taborder = 60
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

type cb_clear from commandbutton within w_approve_encounter
integer x = 1504
integer y = 1184
integer width = 192
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(recheck_user_id)
st_desc.visible = false
st_recheck_desc.visible = false
st_recheck_user.text = "<None>"
st_recheck_user.backcolor = color_object
visible = false

end event

type st_recheck_desc from statictext within w_approve_encounter
integer x = 142
integer y = 1348
integer width = 1522
integer height = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup				popup
str_popup_return 		popup_return

popup.argument_count = 1
popup.argument[1] = "RECHECK"
popup.title = "Enter the reason for recheck:"
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]

end event

type cb_coding from commandbutton within w_approve_encounter
integer x = 1746
integer y = 1360
integer width = 146
integer height = 112
integer taborder = 10
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

service_list.do_service(coding_service)

refresh_coding()

current_patient.open_encounter.set_billing_procedure(true)
load_billing()

end event

type st_title from statictext within w_approve_encounter
integer width = 2926
integer height = 116
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

