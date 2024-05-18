$PBExportHeader$w_procedure_definition.srw
forward
global type w_procedure_definition from w_window_base
end type
type sle_description from singlelineedit within w_procedure_definition
end type
type st_1 from statictext within w_procedure_definition
end type
type sle_cpt_code from singlelineedit within w_procedure_definition
end type
type st_2 from statictext within w_procedure_definition
end type
type st_title from statictext within w_procedure_definition
end type
type st_procedure_category from statictext within w_procedure_definition
end type
type st_3 from statictext within w_procedure_definition
end type
type st_4 from statictext within w_procedure_definition
end type
type em_charge from editmask within w_procedure_definition
end type
type sle_units from singlelineedit within w_procedure_definition
end type
type st_units from statictext within w_procedure_definition
end type
type sle_modifier from singlelineedit within w_procedure_definition
end type
type st_mod_title from statictext within w_procedure_definition
end type
type sle_other_modifiers from singlelineedit within w_procedure_definition
end type
type st_oth_mod_title from statictext within w_procedure_definition
end type
type sle_billing_id from singlelineedit within w_procedure_definition
end type
type st_billing_id_title from statictext within w_procedure_definition
end type
type st_5 from statictext within w_procedure_definition
end type
type dw_locations from u_dw_pick_list within w_procedure_definition
end type
type st_location_domain from statictext within w_procedure_definition
end type
type st_risk from statictext within w_procedure_definition
end type
type st_risk_level from statictext within w_procedure_definition
end type
type cb_common_list from commandbutton within w_procedure_definition
end type
type p_risk_level from picture within w_procedure_definition
end type
type st_6 from statictext within w_procedure_definition
end type
type st_default_bill_flag from statictext within w_procedure_definition
end type
type cb_cancel from commandbutton within w_procedure_definition
end type
type cb_ok from commandbutton within w_procedure_definition
end type
type st_bill_assessment from statictext within w_procedure_definition
end type
type st_bill_assessment_title from statictext within w_procedure_definition
end type
type st_well_encounter_flag_sick from statictext within w_procedure_definition
end type
type st_8 from statictext within w_procedure_definition
end type
type st_well_encounter_flag_well from statictext within w_procedure_definition
end type
type st_well_encounter_flag_any from statictext within w_procedure_definition
end type
type cb_extra_charges from commandbutton within w_procedure_definition
end type
type sle_complexity from singlelineedit within w_procedure_definition
end type
type st_complexity_title from statictext within w_procedure_definition
end type
type cb_equivalence from commandbutton within w_procedure_definition
end type
end forward

global type w_procedure_definition from w_window_base
boolean titlebar = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
sle_description sle_description
st_1 st_1
sle_cpt_code sle_cpt_code
st_2 st_2
st_title st_title
st_procedure_category st_procedure_category
st_3 st_3
st_4 st_4
em_charge em_charge
sle_units sle_units
st_units st_units
sle_modifier sle_modifier
st_mod_title st_mod_title
sle_other_modifiers sle_other_modifiers
st_oth_mod_title st_oth_mod_title
sle_billing_id sle_billing_id
st_billing_id_title st_billing_id_title
st_5 st_5
dw_locations dw_locations
st_location_domain st_location_domain
st_risk st_risk
st_risk_level st_risk_level
cb_common_list cb_common_list
p_risk_level p_risk_level
st_6 st_6
st_default_bill_flag st_default_bill_flag
cb_cancel cb_cancel
cb_ok cb_ok
st_bill_assessment st_bill_assessment
st_bill_assessment_title st_bill_assessment_title
st_well_encounter_flag_sick st_well_encounter_flag_sick
st_8 st_8
st_well_encounter_flag_well st_well_encounter_flag_well
st_well_encounter_flag_any st_well_encounter_flag_any
cb_extra_charges cb_extra_charges
sle_complexity sle_complexity
st_complexity_title st_complexity_title
cb_equivalence cb_equivalence
end type
global w_procedure_definition w_procedure_definition

type variables
string procedure_id
string procedure_category_id
//string service
string procedure_type
string vaccine_id
string location_domain
long em_risk_level
long complexity
string default_bill_flag
string procedure_service
string bill_assessment_id
string well_encounter_flag
long owner_id

end variables

forward prototypes
public subroutine change_location_domain ()
public subroutine new_location_domain ()
public subroutine edit_location_domain ()
public function integer load_procedure ()
public function integer save_changes ()
end prototypes

public subroutine change_location_domain ();str_popup_return popup_return

open(w_pick_location_domain)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

location_domain = popup_return.items[1]
If dw_locations.retrieve(location_domain) <= 0 Then
	st_location_domain.visible = true
Else
	st_location_domain.visible = false
End If

//set_flags()

//changed = true

end subroutine

public subroutine new_location_domain ();str_popup popup
str_popup_return popup_return
long ll_next_key
integer li_sts
string ls_location_domain

// DECLARE lsp_new_location_domain PROCEDURE FOR dbo.sp_new_location_domain  
//         @ps_location_domain = :ls_location_domain OUT,   
//         @ps_description = :popup_return.item  ;
//
popup.item = "Enter New Location Domain:"
openwithparm(w_pop_get_string, popup)
popup_return = message.powerobjectparm
if isnull(popup_return.item) or popup_return.item = "" then return

sqlca.sp_new_location_domain(ref ls_location_domain, popup_return.item);
//EXECUTE lsp_new_location_domain;
if not tf_check() then return

//FETCH lsp_new_location_domain INTO :ls_location_domain;
//if not tf_check() then return

//CLOSE lsp_new_location_domain;

//changed = true
location_domain = ls_location_domain
//set_flags()

edit_location_domain()

end subroutine

public subroutine edit_location_domain ();str_popup popup

popup.data_row_count = 1
popup.items[1] = location_domain
openwithparm(w_location_domain_edit, popup)

If dw_locations.retrieve(location_domain) <= 0 Then
	st_location_domain.visible = true
Else
	st_location_domain.visible = false
End If

datalist.clear_cache("locations")

end subroutine

public function integer load_procedure ();string ls_description
decimal ldc_charge
integer li_sts
integer i
string ls_temp
string ls_desc,ls_icon
real lr_units

  SELECT description,
  			procedure_type,
  			cpt_code,
			procedure_category_id,
			charge,
			vaccine_id,
			billing_id,
			units,
			modifier,
			other_modifiers,
			location_domain,
			risk_level,
			complexity,
			default_bill_flag,
			bill_assessment_id,
			well_encounter_flag,
			owner_id
    INTO :ls_description,
	 		:procedure_type,
	 		:sle_cpt_code.text,
			:procedure_category_id,
			:ldc_charge,
			:vaccine_id,
			:sle_billing_id.text,
			:lr_units,
			:sle_modifier.text,
			:sle_other_modifiers.text,
			:location_domain,
			:em_risk_level,
			:complexity,
			:default_bill_flag,
			:bill_assessment_id,
			:well_encounter_flag,
			:owner_id
    FROM c_Procedure (NOLOCK)
   WHERE procedure_id = :procedure_id;
if not tf_check() then return -1


f_set_risk_level(em_risk_level,ls_desc,ls_icon)
st_risk_level.text = ls_desc
if isnull(ls_icon) then
	p_risk_level.visible = false
else
	p_risk_level.visible = true
	p_risk_level.picturename = ls_icon
end if

sle_description.text = ls_description

SELECT description
INTO :st_procedure_category.text
FROM c_Procedure_Category
WHERE procedure_type = :procedure_type
AND procedure_category_id = :procedure_category_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	setnull(procedure_category_id)
	st_procedure_category.text = ""
end if

em_charge.text = string(ldc_charge)
sle_units.text = f_pretty_amount_unit(lr_units, "TENTH")

If Not Isnull(location_domain) then 
	dw_locations.retrieve(location_domain)
Else
	st_location_domain.visible = true
End If

st_default_bill_flag.text = datalist.domain_item_description("Procedure Bill Flag", default_bill_flag)

if len(bill_assessment_id) > 0 then
	ls_temp =  datalist.assessment_description(bill_assessment_id)
	if len(ls_temp) > 0 then
		st_bill_assessment.text = ls_temp
	else
		st_bill_assessment.text = "N/A"
	end if
else
	st_bill_assessment.text = "N/A"
end if

if upper(well_encounter_flag) = "N" then
	st_well_encounter_flag_sick.backcolor = color_object_selected
	st_well_encounter_flag_well.backcolor = color_object
	st_well_encounter_flag_any.backcolor = color_object
	well_encounter_flag = "N"
elseif upper(well_encounter_flag) = "Y" then
	st_well_encounter_flag_sick.backcolor = color_object
	st_well_encounter_flag_well.backcolor = color_object_selected
	st_well_encounter_flag_any.backcolor = color_object
	well_encounter_flag = "Y"
else
	st_well_encounter_flag_sick.backcolor = color_object
	st_well_encounter_flag_well.backcolor = color_object
	st_well_encounter_flag_any.backcolor = color_object_selected
	well_encounter_flag = "A"
end if

if complexity > 0 then
	sle_complexity.text = string(complexity)
else
	sle_complexity.text = ""
end if




Return 1
end function

public function integer save_changes ();str_popup_return popup_return
decimal ldc_charge
string ls_temp
string ls_modifier
string ls_other_modifiers
string ls_billing_id
integer li_sts
real lr_units

u_ds_data luo_sp_new_procedure
integer li_spdw_count
u_ds_data luo_sp_update_procedure
integer li_spdw_count2

//if isnull(procedure_category_id) then
//	openwithparm(w_pop_message, "You must assign a category")
//	return
//end if

if isnull(sle_modifier.text) or trim(sle_modifier.text) = "" then
	setnull(ls_modifier)
else
	ls_modifier = trim(sle_modifier.text)
end if

if isnull(sle_other_modifiers.text) or trim(sle_other_modifiers.text) = "" then
	setnull(ls_other_modifiers)
else
	ls_other_modifiers = trim(sle_other_modifiers.text)
end if

if isnull(sle_billing_id.text) or trim(sle_billing_id.text) = "" then
	setnull(ls_billing_id)
else
	ls_billing_id = trim(sle_billing_id.text)
end if

ldc_charge = dec(em_charge.text)
if ldc_charge = 0.00 then setnull(ldc_charge)

lr_units = real(sle_units.text)
if isnull(lr_units) or lr_units <= 0 then lr_units = 1

if isnumber(sle_complexity.text) then
	if long(sle_complexity.text) > 0 then
		complexity = long(sle_complexity.text)
	else
		setnull(complexity)
	end if
else
	setnull(complexity)
end if


if isnull(procedure_id) then
	luo_sp_new_procedure = CREATE u_ds_data
	luo_sp_new_procedure.set_dataobject("dw_sp_new_procedure")
	li_spdw_count = luo_sp_new_procedure.retrieve(procedure_type, &
																sle_cpt_code.text, &
																ldc_charge, &
																procedure_category_id, &
																sle_description.text, &
																procedure_service, &
						                                             vaccine_id, &
																lr_units, &
																ls_modifier, &
																ls_other_modifiers, &
																ls_billing_id, &
																location_domain, &
																em_risk_level, &
																default_bill_flag)
	if li_spdw_count <= 0 then
		openwithparm(w_pop_message, "Error saving new procedure")
		return -1
	else
		procedure_id = luo_sp_new_procedure.object.procedure_id[1]
	end if
	destroy luo_sp_new_procedure
else
	sqlca.sp_update_procedure(procedure_id, &
										procedure_type, &
										sle_cpt_code.text, &
										ldc_charge, &
										procedure_category_id, &
										sle_description.text, &
										vaccine_id, &
										lr_units, &
										ls_modifier, &
										ls_other_modifiers, &
										ls_billing_id, &
										location_domain, &
										em_risk_level, &
										default_bill_flag)
	if not tf_check() then return -1
end if

UPDATE c_Procedure
SET bill_assessment_id = :bill_assessment_id,
	well_encounter_flag = :well_encounter_flag,
	complexity = :complexity
WHERE procedure_id = :procedure_id;
if not tf_check() then return -1

return 1

end function

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts

popup = message.powerobjectparm

setnull(procedure_service)
setnull(vaccine_id)

if popup.data_row_count = 1 then
	procedure_type = popup.items[1]
	setnull(procedure_id)
	st_well_encounter_flag_sick.backcolor = color_object
	st_well_encounter_flag_well.backcolor = color_object
	st_well_encounter_flag_any.backcolor = color_object_selected
	well_encounter_flag = "A"
elseif popup.data_row_count = 2 then
	procedure_type = popup.items[1]
	procedure_id = popup.items[2]
else
	log.log(this, "w_procedure_definition:open", "Invalid parameters", 4)
	setnull(popup_return.item)
	popup_return.item_count = 0
	closewithreturn(this, popup_return)
	return
end if

st_title.text = datalist.procedure_type_description(procedure_type) + " Procedure"

postevent("post_open")

end event

on w_procedure_definition.create
int iCurrent
call super::create
this.sle_description=create sle_description
this.st_1=create st_1
this.sle_cpt_code=create sle_cpt_code
this.st_2=create st_2
this.st_title=create st_title
this.st_procedure_category=create st_procedure_category
this.st_3=create st_3
this.st_4=create st_4
this.em_charge=create em_charge
this.sle_units=create sle_units
this.st_units=create st_units
this.sle_modifier=create sle_modifier
this.st_mod_title=create st_mod_title
this.sle_other_modifiers=create sle_other_modifiers
this.st_oth_mod_title=create st_oth_mod_title
this.sle_billing_id=create sle_billing_id
this.st_billing_id_title=create st_billing_id_title
this.st_5=create st_5
this.dw_locations=create dw_locations
this.st_location_domain=create st_location_domain
this.st_risk=create st_risk
this.st_risk_level=create st_risk_level
this.cb_common_list=create cb_common_list
this.p_risk_level=create p_risk_level
this.st_6=create st_6
this.st_default_bill_flag=create st_default_bill_flag
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_bill_assessment=create st_bill_assessment
this.st_bill_assessment_title=create st_bill_assessment_title
this.st_well_encounter_flag_sick=create st_well_encounter_flag_sick
this.st_8=create st_8
this.st_well_encounter_flag_well=create st_well_encounter_flag_well
this.st_well_encounter_flag_any=create st_well_encounter_flag_any
this.cb_extra_charges=create cb_extra_charges
this.sle_complexity=create sle_complexity
this.st_complexity_title=create st_complexity_title
this.cb_equivalence=create cb_equivalence
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_description
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_cpt_code
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.st_procedure_category
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.em_charge
this.Control[iCurrent+10]=this.sle_units
this.Control[iCurrent+11]=this.st_units
this.Control[iCurrent+12]=this.sle_modifier
this.Control[iCurrent+13]=this.st_mod_title
this.Control[iCurrent+14]=this.sle_other_modifiers
this.Control[iCurrent+15]=this.st_oth_mod_title
this.Control[iCurrent+16]=this.sle_billing_id
this.Control[iCurrent+17]=this.st_billing_id_title
this.Control[iCurrent+18]=this.st_5
this.Control[iCurrent+19]=this.dw_locations
this.Control[iCurrent+20]=this.st_location_domain
this.Control[iCurrent+21]=this.st_risk
this.Control[iCurrent+22]=this.st_risk_level
this.Control[iCurrent+23]=this.cb_common_list
this.Control[iCurrent+24]=this.p_risk_level
this.Control[iCurrent+25]=this.st_6
this.Control[iCurrent+26]=this.st_default_bill_flag
this.Control[iCurrent+27]=this.cb_cancel
this.Control[iCurrent+28]=this.cb_ok
this.Control[iCurrent+29]=this.st_bill_assessment
this.Control[iCurrent+30]=this.st_bill_assessment_title
this.Control[iCurrent+31]=this.st_well_encounter_flag_sick
this.Control[iCurrent+32]=this.st_8
this.Control[iCurrent+33]=this.st_well_encounter_flag_well
this.Control[iCurrent+34]=this.st_well_encounter_flag_any
this.Control[iCurrent+35]=this.cb_extra_charges
this.Control[iCurrent+36]=this.sle_complexity
this.Control[iCurrent+37]=this.st_complexity_title
this.Control[iCurrent+38]=this.cb_equivalence
end on

on w_procedure_definition.destroy
call super::destroy
destroy(this.sle_description)
destroy(this.st_1)
destroy(this.sle_cpt_code)
destroy(this.st_2)
destroy(this.st_title)
destroy(this.st_procedure_category)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.em_charge)
destroy(this.sle_units)
destroy(this.st_units)
destroy(this.sle_modifier)
destroy(this.st_mod_title)
destroy(this.sle_other_modifiers)
destroy(this.st_oth_mod_title)
destroy(this.sle_billing_id)
destroy(this.st_billing_id_title)
destroy(this.st_5)
destroy(this.dw_locations)
destroy(this.st_location_domain)
destroy(this.st_risk)
destroy(this.st_risk_level)
destroy(this.cb_common_list)
destroy(this.p_risk_level)
destroy(this.st_6)
destroy(this.st_default_bill_flag)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_bill_assessment)
destroy(this.st_bill_assessment_title)
destroy(this.st_well_encounter_flag_sick)
destroy(this.st_8)
destroy(this.st_well_encounter_flag_well)
destroy(this.st_well_encounter_flag_any)
destroy(this.cb_extra_charges)
destroy(this.sle_complexity)
destroy(this.st_complexity_title)
destroy(this.cb_equivalence)
end on

event post_open;integer li_sts

Setnull(location_domain)
dw_locations.settransobject(sqlca)

If isnull(procedure_id) Then
	default_bill_flag = "Y"
	st_default_bill_flag.text = "Bill"
	setnull(procedure_category_id)
	setnull(em_charge.text)
	owner_id = sqlca.customer_id
	sle_description.text = ""
	sle_cpt_code.text = ""
	sle_modifier.text = ""
	sle_other_modifiers.text = ""
	sle_billing_id.text = ""
	st_procedure_category.text = ""
	sle_units.text = "1.0"
	st_location_domain.visible = true
	cb_common_list.visible = false
Else
	li_sts = load_procedure()
	If li_sts <= 0 Then
		Close(This)
		Return
	End If
	cb_common_list.visible = true
End if
end event

type pb_epro_help from w_window_base`pb_epro_help within w_procedure_definition
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_procedure_definition
integer x = 59
integer y = 1612
end type

type sle_description from singlelineedit within w_procedure_definition
integer x = 512
integer y = 220
integer width = 2171
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_procedure_definition
integer x = 73
integer y = 228
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_cpt_code from singlelineedit within w_procedure_definition
integer x = 512
integer y = 388
integer width = 334
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_procedure_definition
integer x = 73
integer y = 396
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "CPT Code:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_procedure_definition
integer width = 2926
integer height = 144
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Procedure Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_procedure_category from statictext within w_procedure_definition
integer x = 512
integer y = 556
integer width = 946
integer height = 104
integer taborder = 60
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

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_procedure_categories"
popup.datacolumn = 2
popup.displaycolumn = 1
popup.argument_count = 1
popup.argument[1] = procedure_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	if popup_return.choices_count = 0 then
		openwithparm(w_pop_message, "The ~"" + procedure_type + "~" procedure type has no category options")
	end if
	return
end if

procedure_category_id = popup_return.items[1]
text = popup_return.descriptions[1]


end event

type st_3 from statictext within w_procedure_definition
integer x = 73
integer y = 572
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Category:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_procedure_definition
integer x = 73
integer y = 744
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Charge:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_charge from editmask within w_procedure_definition
integer x = 512
integer y = 736
integer width = 334
integer height = 92
integer taborder = 80
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##,###.00"
string displaydata = "\The rollback transaction request has no corresponding BEGIN TRANSACTION."
end type

type sle_units from singlelineedit within w_procedure_definition
integer x = 1170
integer y = 388
integer width = 334
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_units from statictext within w_procedure_definition
integer x = 928
integer y = 396
integer width = 201
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Units:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_modifier from singlelineedit within w_procedure_definition
integer x = 2199
integer y = 360
integer width = 142
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_mod_title from statictext within w_procedure_definition
integer x = 1765
integer y = 368
integer width = 407
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "CPT Modifier:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_other_modifiers from singlelineedit within w_procedure_definition
integer x = 2199
integer y = 476
integer width = 430
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_oth_mod_title from statictext within w_procedure_definition
integer x = 1696
integer y = 484
integer width = 475
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Other Modifiers:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_billing_id from singlelineedit within w_procedure_definition
integer x = 1344
integer y = 736
integer width = 430
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_billing_id_title from statictext within w_procedure_definition
integer x = 923
integer y = 744
integer width = 393
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Billing Code:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_procedure_definition
integer x = 1769
integer y = 964
integer width = 507
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Location Domain"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_locations from u_dw_pick_list within w_procedure_definition
integer x = 1687
integer y = 1048
integer width = 695
integer height = 732
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_location_list"
borderstyle borderstyle = styleraised!
end type

event clicked;string 		ls_buttons[]
integer 		ll_button_pressed, li_sts, li_service_count
string		ls_user_id,ls_assessment_id
integer 		li_update_flag
window 		lw_pop_buttons
str_popup 			popup
str_popup_return 	popup_return


if not isnull(location_domain) and location_domain <> "NA" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Locations in this Domain"
	popup.button_titles[popup.button_count] = "Edit Domain"
	ls_buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Change Location Domain"
	popup.button_titles[popup.button_count] = "Change Domain"
	ls_buttons[popup.button_count] = "CHANGE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonx5.bmp"
	popup.button_helps[popup.button_count] = "Not Applicable"
	popup.button_titles[popup.button_count] = "Not Applicable"
	ls_buttons[popup.button_count] = "NA"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	ls_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return
end if

CHOOSE CASE ls_buttons[ll_button_pressed]
	CASE "EDIT"
		edit_location_domain()
	CASE "CHANGE"
		change_location_domain()
	CASE "NEW"
		new_location_domain()
	CASE "NA"
		location_domain = "NA"
		retrieve(location_domain)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type st_location_domain from statictext within w_procedure_definition
boolean visible = false
integer x = 1915
integer y = 1316
integer width = 215
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "None"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_risk from statictext within w_procedure_definition
integer x = 73
integer y = 916
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Risk Level:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_risk_level from statictext within w_procedure_definition
integer x = 512
integer y = 900
integer width = 549
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

event clicked;string ls_desc,ls_icon

f_get_risk_level(em_risk_level,ls_desc)
text = ls_desc
f_set_risk_level(em_risk_level,ls_desc,ls_icon)
if isnull(ls_icon) then
	p_risk_level.visible = false
else
	p_risk_level.visible = true
	p_risk_level.picturename = ls_icon
end if
end event

type cb_common_list from commandbutton within w_procedure_definition
integer x = 50
integer y = 1440
integer width = 480
integer height = 112
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Specialty List"
end type

event clicked;str_popup popup

popup.title = sle_description.text
popup.items[1] = "Procedure" // common list context
popup.items[2] = procedure_id // common list id
popup.data_row_count = 2

openwithparm(w_specialty_common_lists, popup)

end event

type p_risk_level from picture within w_procedure_definition
integer x = 1097
integer y = 900
integer width = 133
integer height = 112
boolean bringtotop = true
boolean originalsize = true
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_6 from statictext within w_procedure_definition
integer x = 1797
integer y = 748
integer width = 306
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Bill Rule:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_default_bill_flag from statictext within w_procedure_definition
integer x = 2121
integer y = 732
integer width = 681
integer height = 104
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Accumulate Charges"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_domain_translate_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "Procedure Bill Flag"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.descriptions[1]
default_bill_flag = popup_return.items[1]

end event

type cb_cancel from commandbutton within w_procedure_definition
integer x = 50
integer y = 1668
integer width = 402
integer height = 112
integer taborder = 31
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

event clicked;str_popup_return popup_return

setnull(popup_return.item)
popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cb_ok from commandbutton within w_procedure_definition
integer x = 2464
integer y = 1668
integer width = 402
integer height = 112
integer taborder = 41
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

event clicked;str_popup_return popup_return
decimal ldc_charge
string ls_temp
string ls_modifier
string ls_other_modifiers
string ls_billing_id
integer li_sts
real lr_units

u_ds_data luo_sp_new_procedure
integer li_spdw_count
u_ds_data luo_sp_update_procedure
integer li_spdw_count2

li_sts = save_changes()
if li_sts < 0 then return

popup_return.item = procedure_id
popup_return.item_count = 4
popup_return.items[1] = sle_cpt_code.text
popup_return.items[2] = string(ldc_charge)
popup_return.items[3] = procedure_category_id
popup_return.items[4] = sle_description.text
closewithreturn(parent, popup_return)


end event

type st_bill_assessment from statictext within w_procedure_definition
integer x = 512
integer y = 1064
integer width = 946
integer height = 104
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

event clicked;str_popup popup
str_picked_assessments lstr_assessments
w_window_base lw_pick
string ls_assessment_type

if upper(procedure_type) = "VACCINEADMIN" or  upper(procedure_type) = "IMMUNIZATION" then
	ls_assessment_type = "VACCINE"
else
	ls_assessment_type = "SICK"
end if

popup.data_row_count = 2
popup.items[1] = ls_assessment_type
setnull(popup.items[2])
openwithparm(lw_pick, popup, "w_pick_assessments")
lstr_assessments = message.powerobjectparm
if lstr_assessments.assessment_count < 1 then return

bill_assessment_id = lstr_assessments.assessments[1].assessment_id
text = lstr_assessments.assessments[1].description

end event

type st_bill_assessment_title from statictext within w_procedure_definition
integer x = 69
integer y = 1056
integer width = 402
integer height = 124
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Auto-Billed Assessment:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_well_encounter_flag_sick from statictext within w_procedure_definition
integer x = 512
integer y = 1248
integer width = 206
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Sick"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_well_encounter_flag_sick.backcolor = color_object_selected
st_well_encounter_flag_well.backcolor = color_object
st_well_encounter_flag_any.backcolor = color_object

well_encounter_flag = "N"


end event

type st_8 from statictext within w_procedure_definition
integer x = 69
integer y = 1244
integer width = 402
integer height = 124
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Well Appointment Affinity:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_well_encounter_flag_well from statictext within w_procedure_definition
integer x = 777
integer y = 1248
integer width = 206
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Well"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_well_encounter_flag_sick.backcolor = color_object
st_well_encounter_flag_well.backcolor = color_object_selected
st_well_encounter_flag_any.backcolor = color_object

well_encounter_flag = "Y"


end event

type st_well_encounter_flag_any from statictext within w_procedure_definition
integer x = 1042
integer y = 1248
integer width = 206
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Any"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_well_encounter_flag_sick.backcolor = color_object
st_well_encounter_flag_well.backcolor = color_object
st_well_encounter_flag_any.backcolor = color_object_selected

well_encounter_flag = "A"


end event

type cb_extra_charges from commandbutton within w_procedure_definition
integer x = 599
integer y = 1440
integer width = 480
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Extra Charges"
end type

event clicked;integer li_sts

li_sts = save_changes()
if li_sts < 0 then return

openwithparm(w_procedure_extra_charges_edit, procedure_id)

end event

type sle_complexity from singlelineedit within w_procedure_definition
integer x = 2199
integer y = 592
integer width = 430
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_complexity_title from statictext within w_procedure_definition
integer x = 1696
integer y = 600
integer width = 475
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Complexity:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_equivalence from commandbutton within w_procedure_definition
integer x = 1147
integer y = 1440
integer width = 480
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Equivalence"
end type

event clicked;str_content_object lstr_item
w_object_equivalence lw_window

if isnull(procedure_id) then return

lstr_item.object_id = sqlca.fn_object_id_from_key("Procedure", procedure_id)
lstr_item.object_type = "Procedure"
lstr_item.object_key = procedure_id
lstr_item.description = sle_description.text
lstr_item.owner_id = owner_id

openwithparm(lw_window, lstr_item, "w_object_equivalence")

end event

