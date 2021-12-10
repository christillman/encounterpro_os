$PBExportHeader$w_treatment_billing_edit.srw
forward
global type w_treatment_billing_edit from w_window_base
end type
type dw_billing from u_dw_pick_list within w_treatment_billing_edit
end type
type cb_finished from commandbutton within w_treatment_billing_edit
end type
type cb_be_back from commandbutton within w_treatment_billing_edit
end type
type st_1 from statictext within w_treatment_billing_edit
end type
type dw_extra_charges from u_dw_pick_list within w_treatment_billing_edit
end type
type st_2 from statictext within w_treatment_billing_edit
end type
type st_title from statictext within w_treatment_billing_edit
end type
type st_treatment_description from statictext within w_treatment_billing_edit
end type
type cb_search_extra from commandbutton within w_treatment_billing_edit
end type
end forward

global type w_treatment_billing_edit from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
dw_billing dw_billing
cb_finished cb_finished
cb_be_back cb_be_back
st_1 st_1
dw_extra_charges dw_extra_charges
st_2 st_2
st_title st_title
st_treatment_description st_treatment_description
cb_search_extra cb_search_extra
end type
global w_treatment_billing_edit w_treatment_billing_edit

type variables

u_component_service service

string extra_procedure_type


end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();str_treatment_charges lstr_charges
integer i
long ll_row
string ls_name
long ll_sts

lstr_charges = f_get_treatment_charges(current_patient.cpr_id, service.encounter_id, service.treatment_id)

dw_billing.setredraw(false)

dw_billing.reset()

for i = 1 to lstr_charges.charge_count
	ll_row = dw_billing.insertrow(0)
	dw_billing.setitem(ll_row, "description", lstr_charges.charge[i].description)
	dw_billing.setitem(ll_row, "units", lstr_charges.charge[i].units)
	dw_billing.setitem(ll_row, "cpt_code", lstr_charges.charge[i].cpt_code)
	dw_billing.setitem(ll_row, "modifier", lstr_charges.charge[i].modifier)
	dw_billing.setitem(ll_row, "other_modifiers", lstr_charges.charge[i].other_modifiers)
	dw_billing.setitem(ll_row, "charge", lstr_charges.charge[i].charge)
	dw_billing.setitem(ll_row, "last_updated", lstr_charges.charge[i].last_updated)
	dw_billing.setitem(ll_row, "last_updated_by", lstr_charges.charge[i].last_updated_by)
	if not isnull(lstr_charges.charge[i].last_updated_by) then
		ls_name = user_list.user_full_name(lstr_charges.charge[i].last_updated_by)
		dw_billing.setitem(ll_row, "last_updated_name", ls_name)
	end if
	dw_billing.setitem(ll_row, "posted", lstr_charges.charge[i].posted)
	dw_billing.setitem(ll_row, "cpr_id", current_patient.cpr_id)
	dw_billing.setitem(ll_row, "procedure_type", lstr_charges.charge[i].procedure_type)
	dw_billing.setitem(ll_row, "procedure_id", lstr_charges.charge[i].procedure_id)
	dw_billing.setitem(ll_row, "treatment_id", lstr_charges.charge[i].treatment_id)
	dw_billing.setitem(ll_row, "encounter_charge_id", lstr_charges.charge[i].encounter_charge_id)
	dw_billing.setitem(ll_row, "sort_sequence", lstr_charges.charge[i].procedure_type_sort_sequence)
	dw_billing.setitem(ll_row, "treatment_bill_flag", lstr_charges.charge[i].bill_flag)
next

dw_billing.setredraw(true)

ll_sts = dw_extra_charges.retrieve(service.treatment.procedure_id)

return 1

end function

on w_treatment_billing_edit.create
int iCurrent
call super::create
this.dw_billing=create dw_billing
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.st_1=create st_1
this.dw_extra_charges=create dw_extra_charges
this.st_2=create st_2
this.st_title=create st_title
this.st_treatment_description=create st_treatment_description
this.cb_search_extra=create cb_search_extra
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_billing
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.cb_be_back
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.dw_extra_charges
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_title
this.Control[iCurrent+8]=this.st_treatment_description
this.Control[iCurrent+9]=this.cb_search_extra
end on

on w_treatment_billing_edit.destroy
call super::destroy
destroy(this.dw_billing)
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.st_1)
destroy(this.dw_extra_charges)
destroy(this.st_2)
destroy(this.st_title)
destroy(this.st_treatment_description)
destroy(this.cb_search_extra)
end on

event open;call super::open;str_popup_return popup_return
long ll_menu_id

service = message.powerobjectparm

if isnull(service.treatment) then
	log.log(this, "w_treatment_billing_edit:open", "No treatment context", 4)
	popup_return.item_count = 1
	popup_return.items[1] = "ERROR"
	closewithreturn(this, popup_return)
end if

st_treatment_description.text = service.treatment.treatment_description
	

dw_extra_charges.object.compute_description.width = dw_extra_charges.width - 115

dw_billing.settransobject(sqlca)
dw_extra_charges.settransobject(sqlca)

extra_procedure_type = datalist.get_preference("PREFERENCES", "Extra Charge Procedure Type")
if isnull(extra_procedure_type) then extra_procedure_type = "Extra Charge"


// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)


refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_treatment_billing_edit
boolean visible = true
integer x = 2688
integer y = 8
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_treatment_billing_edit
end type

type dw_billing from u_dw_pick_list within w_treatment_billing_edit
integer x = 1083
integer y = 436
integer width = 1797
integer height = 972
integer taborder = 10
string dataobject = "dw_treatment_billing_edit"
boolean vscrollbar = true
boolean livescroll = false
end type

event post_click;call super::post_click;integer li_sts
str_encounter_charge lstr_encounter_charge

lstr_encounter_charge.cpr_id = current_patient.cpr_id
lstr_encounter_charge.encounter_id = service.encounter_id
lstr_encounter_charge.encounter_charge_id = dw_billing.object.encounter_charge_id[clicked_row]
lstr_encounter_charge.problem_id = dw_billing.object.problem_id[clicked_row]

SELECT c. procedure_type,
	c.procedure_id ,
	c.charge ,
	c.bill_flag ,
	c.cpt_code ,
	c.units ,
	c.modifier ,
	c.other_modifiers ,
	p.description ,
	c.last_updated,
	c.last_updated_by,
	c.posted
INTO :lstr_encounter_charge.procedure_type,
	:lstr_encounter_charge.procedure_id ,
	:lstr_encounter_charge.charge,
	:lstr_encounter_charge.charge_bill_flag ,
	:lstr_encounter_charge.cpt_code ,
	:lstr_encounter_charge.units ,
	:lstr_encounter_charge.modifier ,
	:lstr_encounter_charge.other_modifiers ,
	:lstr_encounter_charge.description ,
	:lstr_encounter_charge.last_updated ,
	:lstr_encounter_charge.last_updated_by ,
	:lstr_encounter_charge.posted 
FROM p_Encounter_Charge c
	INNER JOIN c_Procedure p
	ON c.procedure_id = p.procedure_id
WHERE c.cpr_id = :lstr_encounter_charge.cpr_id
AND c.encounter_id = :lstr_encounter_charge.encounter_id
AND c.encounter_charge_id = :lstr_encounter_charge.encounter_charge_id;
if not tf_check() then return

if f_string_to_boolean(lstr_encounter_charge.posted) then
	openwithparm(w_pop_message, "This charge has already been posted to the billing system and cannot be edited")
	return
end if

openwithparm(w_encounter_charge_edit, lstr_encounter_charge)

refresh()

return

end event

event constructor;call super::constructor;active_header = true

end event

type cb_finished from commandbutton within w_treatment_billing_edit
integer x = 2427
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 30
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

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)
end event

type cb_be_back from commandbutton within w_treatment_billing_edit
integer x = 1961
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 40
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

type st_1 from statictext within w_treatment_billing_edit
integer x = 1152
integer y = 356
integer width = 1554
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Current Charges For Treatment"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_extra_charges from u_dw_pick_list within w_treatment_billing_edit
integer x = 37
integer y = 436
integer width = 1006
integer height = 972
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_procedure_extra_charges"
boolean vscrollbar = true
end type

event selected;call super::selected;string ls_extra_procedure_id


ls_extra_procedure_id = object.extra_procedure_id[selected_row]


sqlca.sp_add_encounter_charge(current_patient.cpr_id, &
						service.encounter_id, &
						ls_extra_procedure_id, &
						service.treatment_id, &
						current_scribe.user_id, &
						"N")
if not tf_check() then return

refresh()

end event

type st_2 from statictext within w_treatment_billing_edit
integer x = 96
integer y = 356
integer width = 873
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Extra Charges"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_treatment_billing_edit
integer width = 2921
integer height = 108
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Treatment Charge Edit"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_treatment_description from statictext within w_treatment_billing_edit
integer y = 156
integer width = 2921
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Treatment Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_search_extra from commandbutton within w_treatment_billing_edit
integer x = 338
integer y = 1416
integer width = 407
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Search"
end type

event clicked;str_popup popup
str_popup_return popup_return
str_picked_procedures lstr_procedures
long ll_count
long ll_choice
string ls_order_flag

popup.data_row_count = 1
popup.items[1] = extra_procedure_type
popup.multiselect = false
openwithparm(w_pick_procedures, popup)
lstr_procedures = message.powerobjectparm

if lstr_procedures.procedure_count < 1 then return

openwithparm(w_pop_yes_no, "The charge ~"" + lstr_procedures.procedures[1].description + "~" will be added to this treatment.  Do you wish to also add this charge to the list of available charges?")
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	ll_count = dw_extra_charges.rowcount() + 1

	popup.data_row_count = 2
	popup.items[1] = "Automatically Ordered"
	popup.items[2] = "Optional"
	popup.title = "Do you want this extra charge to be automatically ordered whenever this treatment is ordered?"
	openwithparm(w_pop_choices_2, popup)
	ll_choice = message.doubleparm
	if ll_choice = 1 then
		ls_order_flag = "Auto"
	else
		ls_order_flag = "Optional"
	end if
	
	INSERT INTO c_Procedure_Extra_Charge (
		procedure_id,
		extra_procedure_id,
		order_flag,
		sort_sequence)
	VALUES (
		:service.treatment.procedure_id,
		:lstr_procedures.procedures[1].procedure_id,
		:ls_order_flag,
		:ll_count);
	if not tf_check() then return
end if

sqlca.sp_add_encounter_charge(current_patient.cpr_id, &
						service.encounter_id, &
						lstr_procedures.procedures[1].procedure_id, &
						service.treatment_id, &
						current_scribe.user_id, &
						"N")
if not tf_check() then return

refresh()

end event

