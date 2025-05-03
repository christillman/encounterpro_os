$PBExportHeader$w_svc_treatment_billing.srw
forward
global type w_svc_treatment_billing from w_window_base
end type
type st_title from statictext within w_svc_treatment_billing
end type
type cb_finished from commandbutton within w_svc_treatment_billing
end type
type cb_be_back from commandbutton within w_svc_treatment_billing
end type
type st_treatment_type_title from statictext within w_svc_treatment_billing
end type
type st_treatment_description_title from statictext within w_svc_treatment_billing
end type
type st_treatment_type from statictext within w_svc_treatment_billing
end type
type st_treatment_description from statictext within w_svc_treatment_billing
end type
type st_authority_title from statictext within w_svc_treatment_billing
end type
type st_authority from statictext within w_svc_treatment_billing
end type
type cb_choose_authority from commandbutton within w_svc_treatment_billing
end type
type st_formulary_title from statictext within w_svc_treatment_billing
end type
type st_formulary from statictext within w_svc_treatment_billing
end type
type st_billing_title from statictext within w_svc_treatment_billing
end type
type st_collection_title from statictext within w_svc_treatment_billing
end type
type st_perform_title from statictext within w_svc_treatment_billing
end type
type st_bill_collection from statictext within w_svc_treatment_billing
end type
type st_bill_perform from statictext within w_svc_treatment_billing
end type
type pb_view_formulary from picturebutton within w_svc_treatment_billing
end type
end forward

global type w_svc_treatment_billing from w_window_base
integer height = 1840
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
st_title st_title
cb_finished cb_finished
cb_be_back cb_be_back
st_treatment_type_title st_treatment_type_title
st_treatment_description_title st_treatment_description_title
st_treatment_type st_treatment_type
st_treatment_description st_treatment_description
st_authority_title st_authority_title
st_authority st_authority
cb_choose_authority cb_choose_authority
st_formulary_title st_formulary_title
st_formulary st_formulary
st_billing_title st_billing_title
st_collection_title st_collection_title
st_perform_title st_perform_title
st_bill_collection st_bill_collection
st_bill_perform st_bill_perform
pb_view_formulary pb_view_formulary
end type
global w_svc_treatment_billing w_svc_treatment_billing

type variables
u_component_service service

string authority_id

u_ds_data patient_authorities
u_ds_data authority_treatment_formulary

boolean bill_collection = false
boolean bill_perform = false


end variables

forward prototypes
public function integer set_authority (string ps_authority_id)
public function integer set_billing ()
end prototypes

public function integer set_authority (string ps_authority_id);long ll_row
string ls_find
long ll_rows

if isnull(ps_authority_id) then
	ll_row = 0
else
	ls_find = "authority_id='" + ps_authority_id + "'"
	ll_row = patient_authorities.find(ls_find, 1, patient_authorities.rowcount())
end if

if ll_row > 0 then
	authority_id = ps_authority_id
	st_authority.text = patient_authorities.object.authority_name[ll_row]
else
	setnull(authority_id)
	st_authority.text = "<None>"
end if

// Set the formulary
if isnull(authority_id) then
	ll_rows = 0
else
	authority_treatment_formulary.set_dataobject("dw_sp_authority_treatment_formulary")
	ll_rows = authority_treatment_formulary.retrieve(current_patient.cpr_id, service.treatment.treatment_id, authority_id)
end if

if ll_rows > 0 then
	st_formulary.text = authority_treatment_formulary.object.description[1]
	pb_view_formulary.picturename = authority_treatment_formulary.object.button[1]
	st_formulary_title.visible = true
	st_formulary.visible = true
	pb_view_formulary.visible = true
else
	st_formulary_title.visible = false
	st_formulary.visible = false
	pb_view_formulary.visible = false
end if		


return 1


end function

public function integer set_billing ();long ll_problem_id
string ls_bill_flag

setnull(ll_problem_id)

if st_collection_title.text = "Bill Procedure" then
	// we're using the bill_collection flag to control the billing of treatments
	// with procedure id's and not observation_id's.
	if bill_collection then
		ls_bill_flag = "Y"
	else
		ls_bill_flag = "N"
	end if
	
	sqlca.sp_set_treatment_billing(current_patient.cpr_id, &
											service.encounter_id, &
											ll_problem_id, &
											service.treatment.treatment_id, &
											"PROCEDURE", &
											ls_bill_flag, &
											current_scribe.user_id )
	
	if not tf_check() then return -1
else
	// This is an observation treatment so bill the collect and perform procedures
	
	// First the collect procedure
	if bill_collection then
		ls_bill_flag = "Y"
	else
		ls_bill_flag = "N"
	end if

	sqlca.sp_set_treatment_billing(current_patient.cpr_id, &
											service.encounter_id, &
											ll_problem_id, &
											service.treatment.treatment_id, &
											"TESTCOLLECT", &
											ls_bill_flag, &
											current_scribe.user_id )
	if not tf_check() then return -1
	

	// Then the perform procedure
	if bill_perform then
		ls_bill_flag = "Y"
	else
		ls_bill_flag = "N"
	end if

	sqlca.sp_set_treatment_billing(current_patient.cpr_id, &
											service.encounter_id, &
											ll_problem_id, &
											service.treatment.treatment_id, &
											"TESTPERFORM", &
											ls_bill_flag, &
											current_scribe.user_id )
	if not tf_check() then return -1
end if


return 1

end function

event open;call super::open;long ll_menu_id
long ll_rows
str_popup_return popup_return
string ls_null
long ll_property_id

setnull(ls_null)

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm
if isnull(service.treatment) then
	log.log(this, "w_svc_treatment_billing:open", "No treatment object", 4)
	closewithreturn(this, popup_return)
	return
end if

// Set the title and sizes
title = current_patient.id_line()

st_treatment_type.text = datalist.treatment_type_description(service.treatment.treatment_type)
st_treatment_description.text = service.treatment.treatment_description

if len(st_title.text) > 42 then
	if len(st_title.text) > 60 then
		if len(st_title.text) > 70 then
			st_title.textsize = -10
		else
			st_title.textsize = -12
		end if
	else
		st_title.textsize = -14
	end if
else
	st_title.textsize = -18
end if

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
if not isnull(ll_menu_id) then paint_menu(ll_menu_id)

patient_authorities = CREATE u_ds_data
authority_treatment_formulary = CREATE u_ds_data


setnull(authority_id)

patient_authorities.set_dataobject("dw_p_patient_authority")
ll_rows = patient_authorities.retrieve(current_patient.cpr_id)
if ll_rows > 0 then
	set_authority(patient_authorities.object.authority_id[1])
	if ll_rows > 1 then
		cb_choose_authority.visible = true
	else
		cb_choose_authority.visible = false
	end if
else
	set_authority(ls_null)
	cb_choose_authority.visible = false
end if

if isnull(service.treatment.procedure_id) then
	if isnull(service.treatment.observation_id) then
		st_billing_title.visible = false
		st_collection_title.visible = false
		st_perform_title.visible = false
		st_bill_collection.visible = false
		st_bill_perform.visible = false
	end if
else
	st_perform_title.visible = false
	st_bill_perform.visible = false
	st_collection_title.text = "Bill Procedure"
end if


end event

on w_svc_treatment_billing.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.st_treatment_type_title=create st_treatment_type_title
this.st_treatment_description_title=create st_treatment_description_title
this.st_treatment_type=create st_treatment_type
this.st_treatment_description=create st_treatment_description
this.st_authority_title=create st_authority_title
this.st_authority=create st_authority
this.cb_choose_authority=create cb_choose_authority
this.st_formulary_title=create st_formulary_title
this.st_formulary=create st_formulary
this.st_billing_title=create st_billing_title
this.st_collection_title=create st_collection_title
this.st_perform_title=create st_perform_title
this.st_bill_collection=create st_bill_collection
this.st_bill_perform=create st_bill_perform
this.pb_view_formulary=create pb_view_formulary
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.cb_be_back
this.Control[iCurrent+4]=this.st_treatment_type_title
this.Control[iCurrent+5]=this.st_treatment_description_title
this.Control[iCurrent+6]=this.st_treatment_type
this.Control[iCurrent+7]=this.st_treatment_description
this.Control[iCurrent+8]=this.st_authority_title
this.Control[iCurrent+9]=this.st_authority
this.Control[iCurrent+10]=this.cb_choose_authority
this.Control[iCurrent+11]=this.st_formulary_title
this.Control[iCurrent+12]=this.st_formulary
this.Control[iCurrent+13]=this.st_billing_title
this.Control[iCurrent+14]=this.st_collection_title
this.Control[iCurrent+15]=this.st_perform_title
this.Control[iCurrent+16]=this.st_bill_collection
this.Control[iCurrent+17]=this.st_bill_perform
this.Control[iCurrent+18]=this.pb_view_formulary
end on

on w_svc_treatment_billing.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.st_treatment_type_title)
destroy(this.st_treatment_description_title)
destroy(this.st_treatment_type)
destroy(this.st_treatment_description)
destroy(this.st_authority_title)
destroy(this.st_authority)
destroy(this.cb_choose_authority)
destroy(this.st_formulary_title)
destroy(this.st_formulary)
destroy(this.st_billing_title)
destroy(this.st_collection_title)
destroy(this.st_perform_title)
destroy(this.st_bill_collection)
destroy(this.st_bill_perform)
destroy(this.pb_view_formulary)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_svc_treatment_billing
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_treatment_billing
end type

type st_title from statictext within w_svc_treatment_billing
integer width = 2898
integer height = 132
integer textsize = -22
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Set Treatment Billing"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_svc_treatment_billing
integer x = 2427
integer y = 1620
integer width = 443
integer height = 108
integer taborder = 150
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts
string ls_description

li_sts = set_billing()
if li_sts < 0 then
	openwithparm(w_pop_message, "Setting the billing failed")
	return
end if

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_svc_treatment_billing
integer x = 1961
integer y = 1620
integer width = 443
integer height = 108
integer taborder = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_treatment_type_title from statictext within w_svc_treatment_billing
integer x = 288
integer y = 244
integer width = 489
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Treatment Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_treatment_description_title from statictext within w_svc_treatment_billing
integer x = 288
integer y = 380
integer width = 489
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Treatment:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_treatment_type from statictext within w_svc_treatment_billing
integer x = 805
integer y = 232
integer width = 1093
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_treatment_description from statictext within w_svc_treatment_billing
integer x = 805
integer y = 380
integer width = 1824
integer height = 148
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_authority_title from statictext within w_svc_treatment_billing
integer x = 288
integer y = 596
integer width = 489
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Authority:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_authority from statictext within w_svc_treatment_billing
integer x = 805
integer y = 584
integer width = 1093
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
boolean border = true
boolean focusrectangle = false
end type

type cb_choose_authority from commandbutton within w_svc_treatment_billing
integer x = 1906
integer y = 584
integer width = 133
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button
long ll_row
integer i
string ls_null

setnull(ls_null)

popup.data_row_count = patient_authorities.rowcount()

for i = 1 to popup.data_row_count
	popup.items[i] = patient_authorities.object.authority_name[i]
next
popup.data_row_count += 1
popup.items[popup.data_row_count] = "<None>"
	
openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,w_svc_treatment_billing.cb_choose_authority.clicked:0020")
if popup_return.item_count <> 1 then return

ll_row = popup_return.item_indexes[1]

if ll_row = popup.data_row_count then
	set_authority(ls_null)
else
	set_authority(patient_authorities.object.authority_id[ll_row])
end if

end event

type st_formulary_title from statictext within w_svc_treatment_billing
integer x = 288
integer y = 712
integer width = 489
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Formulary:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_formulary from statictext within w_svc_treatment_billing
integer x = 805
integer y = 708
integer width = 1838
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
boolean border = true
boolean focusrectangle = false
end type

type st_billing_title from statictext within w_svc_treatment_billing
integer x = 951
integer y = 924
integer width = 955
integer height = 100
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 7191717
string text = "Billing"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_collection_title from statictext within w_svc_treatment_billing
integer x = 905
integer y = 1112
integer width = 608
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Bill Collection Code:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_perform_title from statictext within w_svc_treatment_billing
integer x = 905
integer y = 1276
integer width = 608
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Bill Perform Code:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_bill_collection from statictext within w_svc_treatment_billing
integer x = 1541
integer y = 1096
integer width = 402
integer height = 100
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

event clicked;if bill_collection then
	bill_collection = false
	text = "No"
else
	bill_collection = true
	text = "Yes"
end if


end event

type st_bill_perform from statictext within w_svc_treatment_billing
integer x = 1541
integer y = 1260
integer width = 402
integer height = 100
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

event clicked;if bill_perform then
	bill_perform = false
	text = "No"
else
	bill_perform = true
	text = "Yes"
end if


end event

type pb_view_formulary from picturebutton within w_svc_treatment_billing
integer x = 2661
integer y = 688
integer width = 151
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
end type

