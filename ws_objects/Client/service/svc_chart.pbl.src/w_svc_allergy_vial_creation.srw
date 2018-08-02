$PBExportHeader$w_svc_allergy_vial_creation.srw
forward
global type w_svc_allergy_vial_creation from w_window_base
end type
type st_title from statictext within w_svc_allergy_vial_creation
end type
type cb_finished from commandbutton within w_svc_allergy_vial_creation
end type
type cb_be_back from commandbutton within w_svc_allergy_vial_creation
end type
type st_expiration_date_title from statictext within w_svc_allergy_vial_creation
end type
type st_expiration_date from statictext within w_svc_allergy_vial_creation
end type
type st_page from statictext within w_svc_allergy_vial_creation
end type
type pb_up from picturebutton within w_svc_allergy_vial_creation
end type
type pb_down from picturebutton within w_svc_allergy_vial_creation
end type
type st_1 from statictext within w_svc_allergy_vial_creation
end type
type st_total_volume from statictext within w_svc_allergy_vial_creation
end type
type cb_2 from commandbutton within w_svc_allergy_vial_creation
end type
type cb_cancel from commandbutton within w_svc_allergy_vial_creation
end type
type st_4 from statictext within w_svc_allergy_vial_creation
end type
type st_description from statictext within w_svc_allergy_vial_creation
end type
type st_allergen_title from statictext within w_svc_allergy_vial_creation
end type
type st_3 from statictext within w_svc_allergy_vial_creation
end type
type st_2 from statictext within w_svc_allergy_vial_creation
end type
type dw_allergens from u_dw_pick_list within w_svc_allergy_vial_creation
end type
type st_details_title from statictext within w_svc_allergy_vial_creation
end type
type sle_comments from singlelineedit within w_svc_allergy_vial_creation
end type
type st_total_volume_title from statictext within w_svc_allergy_vial_creation
end type
type st_bill_units_title from statictext within w_svc_allergy_vial_creation
end type
type st_bill_units_yes from statictext within w_svc_allergy_vial_creation
end type
type st_bill_units_no from statictext within w_svc_allergy_vial_creation
end type
end forward

global type w_svc_allergy_vial_creation from w_window_base
boolean controlmenu = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 2
st_title st_title
cb_finished cb_finished
cb_be_back cb_be_back
st_expiration_date_title st_expiration_date_title
st_expiration_date st_expiration_date
st_page st_page
pb_up pb_up
pb_down pb_down
st_1 st_1
st_total_volume st_total_volume
cb_2 cb_2
cb_cancel cb_cancel
st_4 st_4
st_description st_description
st_allergen_title st_allergen_title
st_3 st_3
st_2 st_2
dw_allergens dw_allergens
st_details_title st_details_title
sle_comments sle_comments
st_total_volume_title st_total_volume_title
st_bill_units_title st_bill_units_title
st_bill_units_yes st_bill_units_yes
st_bill_units_no st_bill_units_no
end type
global w_svc_allergy_vial_creation w_svc_allergy_vial_creation

type variables
u_component_service service

real 	total_volume
string total_volume_unit

long		parent_treatment_id,treatment_id
string 	child_treatment_type = 'AllergyVialAllergen'
string   treatment_type = 'AllergyVialInstance'
string   vial_description
date		expiration_date
real     new_vial_concentration,new_vial_diluent
string   vial_concentration_name

boolean  new_vial = true
boolean  amount_in_vial,diluent_in_vial

string bill_procedure_id
int bill_units
boolean bill_for_creation

end variables

forward prototypes
public subroutine set_treatment_details (long pl_row)
public function string get_comments ()
public function integer refresh ()
public function integer save_vial ()
public function integer save_concentration ()
end prototypes

public subroutine set_treatment_details (long pl_row);String ls_maker,ls_lot,ls_text
String ls_expiration_date
String ls_treatment_status
date   ld_expiration_date
decimal {6} ld_dose

ls_maker = dw_allergens.object.maker_id[pl_row]
ld_expiration_date = date(dw_allergens.object.expiration_date[pl_row])
ls_lot = dw_allergens.object.lot_number[pl_row]
		
if isnull(ls_maker) then ls_maker = ""
if isnull(ld_expiration_date) then 
	ls_expiration_date = "" 
else
	ls_expiration_date = string(ld_expiration_date)
end if

if isnull(ls_lot) then ls_lot = ""
		
ls_text = ls_maker + " "+ls_expiration_Date+" "+ls_lot
dw_allergens.object.treatment_details[pl_row] = ls_text

ls_treatment_status = dw_allergens.object.treatment_status[pl_row]
if upper(ls_treatment_status) = 'CLOSED' Then
	dw_allergens.object.put_in_vial[pl_row] = 'Yes'
end if
ld_dose = dec(dw_allergens.object.dose_amount[pl_row])
dw_allergens.object.dose_amount_text[pl_row] = string(ld_dose, "0.######")
end subroutine

public function string get_comments ();string ls_comment
integer i

str_progress_list lstr_progress

lstr_progress = f_get_progress(current_patient.cpr_id, &
                 			     "Treatment", &
		                        treatment_id, &
        			               'Comment', &
                 			      'Comment')
// get the comments
For i = 1 to lstr_progress.progress_count
	if lstr_progress.progress[i].progress_type = 'Comment' then
		if not isnull(lstr_progress.progress[i].progress) then
			ls_comment += lstr_progress.progress[i].progress + "~r~n"
		end if
	end if
next

return ls_comment
end function

public function integer refresh ();integer i
integer li_page
u_unit luo_unit


// if there's already an vial with incomplete state then show the
// details

SELECT expiration_date,
		treatment_description,
		dose_amount,
		dose_unit
INTO :expiration_date,
		:vial_description,
		:total_volume,
		:total_volume_unit
FROM p_Treatment_Item
WHERE treatment_id = :treatment_id;
if not tf_check() then return -1

if not isnull(expiration_date) then
	st_expiration_date.text = string(expiration_date,"mm/dd/yyyy")
end if

st_description.text = vial_description

// get the comments
sle_comments.text = get_comments()


luo_unit = unit_list.find_unit(total_volume_unit)
if isnull(luo_unit) or isnull(total_volume) then
	st_total_volume.text = "<Unknown>"
else
	st_total_volume.text = luo_unit.pretty_amount_unit(total_volume)
end if


// look for child treatments to this vial instance
dw_allergens.setredraw(false)
li_page = dw_allergens.current_page
dw_allergens.reset()
dw_allergens.retrieve(treatment_id, child_treatment_type)
	
// show maker/lot number details
for i = 1 to dw_allergens.rowcount()
	set_treatment_details(i)
next

dw_allergens.sort()

dw_allergens.set_page(li_page, pb_up, pb_down, st_page)

dw_allergens.setredraw(true)


return 1

end function

public function integer save_vial ();string ls_end_date
long  ll_rowcount,ll_null
string ls_null,ls_text
datetime ldt_progress_date_time

str_popup_return popup_return

setnull(ldt_progress_date_time)
setnull(ll_null)
setnull(ls_null)

// if there are few more allergens not added into a vial then
// do not allow the user to complete the service
dw_allergens.setredraw(false)
dw_allergens.setfilter("treatment_status = 'OPEN'")
dw_allergens.filter()
ll_rowcount = dw_allergens.rowcount()
if ll_rowcount > 0 then
	Openwithparm(w_pop_message,"Please add all the allergens in order to complete the vial")
	dw_allergens.setfilter("")
	dw_allergens.filter()
	dw_allergens.sort()
	dw_allergens.setredraw(true)
	return -1
end if
dw_allergens.setfilter("")
dw_allergens.filter()
dw_allergens.setredraw(true)

IF ll_rowcount = 0 THEN // a vial is successfully created then set the status to 'OPEN'
	// expiration date is must
	if isnull(expiration_date) then
		Openwithparm(w_pop_message,"Please enter a valid vial expiration date to complete the vial")
		return -1
	end if 
	 f_set_progress(current_patient.cpr_id, &
								"Treatment", &
								treatment_id, &
								'Modify', &
								'treatment_status', &
								'OPEN', &
								ldt_progress_date_time, &
								ll_null, &
								ll_null, &
								ll_null)
			
	// assume the user completing the vial is the owner for the vial
	f_set_progress(current_patient.cpr_id, &
						"Treatment", &
						treatment_id, &
						'PROPERTY', &
						'Filled By', &
						current_user.user_full_name, &
						ldt_progress_date_time, &
						ll_null, &
						ll_null, &
						ll_null)
END IF

return 1
end function

public function integer save_concentration ();string ls_end_date,ls_comment
long  ll_rowcount,ll_null
string ls_null,ls_text
datetime ldt_progress_date_time,ldt_null

str_popup_return popup_return

setnull(ldt_progress_date_time)
setnull(ll_null)
setnull(ls_null)
setnull(ldt_null)

if isnull(expiration_date) then
	Openwithparm(w_pop_message,"Please enter a valid vial expiration date to complete the vial")
	return -1
end if 

if new_vial_concentration <= 0 then
	Openwithparm(w_pop_message,"Please enter a valid vial concentration amount")
	return -1
end if

if isnull(vial_concentration_name) or len(vial_concentration_name) = 0 then
	Openwithparm(w_pop_message,"Please select a vial")
	return -1
end if

if not (amount_in_vial) or not(diluent_in_vial) then
	Openwithparm(w_pop_message,"Please confirm whether the concentration/diluent is added into a vial")
	return -1
end if
// if the vial is filled in from another vial successfully 
 f_set_progress(current_patient.cpr_id, &
					"Treatment", &
					treatment_id, &
					'Modify', &
					'treatment_status', &
					'OPEN', &
					ldt_progress_date_time, &
					ll_null, &
					ll_null, &
					ll_null)
			
// assume the user completing the vial is the owner for the vial
f_set_progress(current_patient.cpr_id, &
					"Treatment", &
					treatment_id, &
					'PROPERTY', &
					'Filled By', &
					current_user.user_full_name, &
					ldt_progress_date_time, &
					ll_null, &
					ll_null, &
					ll_null)
					
if isnull(new_vial_diluent) then new_vial_diluent = 0.00
ls_comment = vial_concentration_name+" concentration amount: "+string(new_vial_concentration)
ls_comment += " , diluent: "+string(new_vial_diluent)
f_set_progress(current_patient.cpr_id, &
               "Treatment", &
                treatment_id, &
               'Comment', &
               'Comment', &
                ls_comment, &
                ldt_null, &
                ll_null, &
                ll_null, &
                ll_null)
								
Return 1
end function

event open;call super::open;integer li_return
long ll_menu_id
long ll_rows
str_popup_return popup_return
string ls_null
long ll_property_id
string ls_temp
u_unit luo_unit
string ls_cpt_code

setnull(ls_null)

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm
if isnull(service.treatment) then
	log.log(this, "w_svc_allergy_vial_creation.open.0018", "No treatment object", 4)
	closewithreturn(this, popup_return)
	return
end if


luo_unit = unit_list.find_unit(service.treatment.dose_unit)
if isnull(luo_unit) then
	log.log(this, "w_svc_allergy_vial_creation.open.0018", "No dose unit", 4)
	closewithreturn(this, popup_return)
	return
end if
	
st_total_volume.text = luo_unit.pretty_amount_unit(service.treatment.dose_amount)

// Set the title and sizes
title = current_patient.id_line()

st_title.text = "Create new vial for ~"" + service.treatment.treatment_description + "~""

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
	cb_cancel.x = cb_be_back.x
	max_buttons = 3
end if

ll_menu_id = long(service.get_attribute("menu_id"))
if not isnull(ll_menu_id) then paint_menu(ll_menu_id)

parent_treatment_id = service.treatment.treatment_id
dw_allergens.settransobject(sqlca)

service.get_attribute("bill_procedure_id", bill_procedure_id)
if len(bill_procedure_id) > 0 then
	SELECT cpt_code
	INTO :ls_cpt_code
	FROM c_Procedure
	WHERE procedure_id = :bill_procedure_id;
	if not tf_check() then
		closewithreturn(this, popup_return)
		return
	end if
else
	setnull(ls_cpt_code)
end if

if len(ls_cpt_code) > 0 then
	service.get_attribute("bill_units", bill_units)
	if isnull(bill_units) then bill_units = 12
	st_bill_units_title.visible = true
	st_bill_units_yes.visible = true
	st_bill_units_no.visible = true
	
	st_bill_units_title.text = "Bill " + string(bill_units) + " of " + ls_cpt_code + ":"
	st_bill_units_yes.backcolor = color_object_selected
	bill_for_creation = true
else
	st_bill_units_title.visible = false
	st_bill_units_yes.visible = false
	st_bill_units_no.visible = false
	bill_for_creation = false
end if

postevent("post_open")

end event

on w_svc_allergy_vial_creation.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.st_expiration_date_title=create st_expiration_date_title
this.st_expiration_date=create st_expiration_date
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_1=create st_1
this.st_total_volume=create st_total_volume
this.cb_2=create cb_2
this.cb_cancel=create cb_cancel
this.st_4=create st_4
this.st_description=create st_description
this.st_allergen_title=create st_allergen_title
this.st_3=create st_3
this.st_2=create st_2
this.dw_allergens=create dw_allergens
this.st_details_title=create st_details_title
this.sle_comments=create sle_comments
this.st_total_volume_title=create st_total_volume_title
this.st_bill_units_title=create st_bill_units_title
this.st_bill_units_yes=create st_bill_units_yes
this.st_bill_units_no=create st_bill_units_no
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.cb_be_back
this.Control[iCurrent+4]=this.st_expiration_date_title
this.Control[iCurrent+5]=this.st_expiration_date
this.Control[iCurrent+6]=this.st_page
this.Control[iCurrent+7]=this.pb_up
this.Control[iCurrent+8]=this.pb_down
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_total_volume
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.cb_cancel
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.st_description
this.Control[iCurrent+15]=this.st_allergen_title
this.Control[iCurrent+16]=this.st_3
this.Control[iCurrent+17]=this.st_2
this.Control[iCurrent+18]=this.dw_allergens
this.Control[iCurrent+19]=this.st_details_title
this.Control[iCurrent+20]=this.sle_comments
this.Control[iCurrent+21]=this.st_total_volume_title
this.Control[iCurrent+22]=this.st_bill_units_title
this.Control[iCurrent+23]=this.st_bill_units_yes
this.Control[iCurrent+24]=this.st_bill_units_no
end on

on w_svc_allergy_vial_creation.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.st_expiration_date_title)
destroy(this.st_expiration_date)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_1)
destroy(this.st_total_volume)
destroy(this.cb_2)
destroy(this.cb_cancel)
destroy(this.st_4)
destroy(this.st_description)
destroy(this.st_allergen_title)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_allergens)
destroy(this.st_details_title)
destroy(this.sle_comments)
destroy(this.st_total_volume_title)
destroy(this.st_bill_units_title)
destroy(this.st_bill_units_yes)
destroy(this.st_bill_units_no)
end on

event post_open;call super::post_open;/********************************************************************
//
//
// Description: Once a vial is in 'OPEN' status
// (all allergens are added into a vial then it can not be
// edited.
//
// 
//
//
*********************************************************************/
integer  i
date		ld_expiration_date
str_popup popup
str_popup_return popup_return
str_popup_return error_return
str_new_vial_properties lstr_new_vial

error_return.item_count = 1
error_return.items[1] = "ERROR"

openwithparm(w_new_vial_type_select, parent_treatment_id)
lstr_new_vial = message.powerobjectparm
if isnull(lstr_new_vial.new_vial_type) then
	ClosewithReturn(this,error_return)
	return 1
end if

treatment_id = sqlca.sp_create_vial_instance (current_patient.cpr_id, &
																current_patient.open_encounter.encounter_id, &
																parent_treatment_id, &
																lstr_new_vial.new_vial_type, &
																current_user.user_id, &
																current_scribe.user_id, &
																lstr_new_vial.dilute_from_vial_type, &
																lstr_new_vial.new_vial_amount, &
																lstr_new_vial.new_vial_unit)
if not tf_check() then
	Openwithparm(w_pop_message,"Error creating vial")
	ClosewithReturn(this,error_return)
	return
end if

// if incomplete vial definition or no vial definition then return
if isnull(treatment_id) or treatment_id <= 0 then
	Openwithparm(w_pop_message,"Please complete the vial definition before creating a vial")
	ClosewithReturn(this,error_return)
	return 1
end if

refresh()

return 1


end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_allergy_vial_creation
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_allergy_vial_creation
integer x = 46
integer y = 1560
end type

type st_title from statictext within w_svc_allergy_vial_creation
integer width = 2898
integer height = 132
integer textsize = -22
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Create New Vial for"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_svc_allergy_vial_creation
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

if new_vial then
	if save_vial() <= 0 then return
else
	if save_concentration() <= 0 then return
end if

if bill_for_creation then
	sqlca.sp_add_encounter_charge( service.cpr_id, &
											service.encounter_id, &
											bill_procedure_id, &
											service.treatment.parent_treatment_id, &
											current_scribe.user_id, &
											"Y" )
end if

popup_return.item_count = 1
popup_return.items[1] = "OK"

Closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_svc_allergy_vial_creation
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

type st_expiration_date_title from statictext within w_svc_allergy_vial_creation
integer x = 1897
integer y = 180
integer width = 343
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Exp. Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_expiration_date from statictext within w_svc_allergy_vial_creation
integer x = 2267
integer y = 168
integer width = 562
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;date ld_expiration_date
string ls_text
datetime ldt_progress_date_time
long ll_null


setnull(ll_null)
setnull(ldt_progress_date_time)

ld_expiration_date = expiration_date
if isnull(ld_expiration_date) then ld_expiration_date = today()

ls_text = f_select_date(ld_expiration_date, "Vial Expiration Date")
if isnull(ls_text) then return

if ld_expiration_date < today() then
	openwithparm(w_pop_message,"Enter a valid expiration date")
	setfocus()
	return
end if

st_expiration_date.text = ls_text

// expiration_date
if (expiration_date <> ld_expiration_date) or isnull(expiration_date)  then

	f_set_progress(current_patient.cpr_id, &
					"Treatment", &
					treatment_id, &
					'Modify', &
					'expiration_date', &
					string(ld_expiration_date), &
					ldt_progress_date_time, &
					ll_null, &
					ll_null, &
					ll_null)	
end if
expiration_date = ld_expiration_date

end event

type st_page from statictext within w_svc_allergy_vial_creation
integer x = 2702
integer y = 776
integer width = 142
integer height = 108
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean focusrectangle = false
end type

type pb_up from picturebutton within w_svc_allergy_vial_creation
integer x = 2702
integer y = 528
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_allergens.current_page

dw_allergens.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from picturebutton within w_svc_allergy_vial_creation
integer x = 2702
integer y = 652
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_allergens.current_page
li_last_page = dw_allergens.last_page

dw_allergens.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_1 from statictext within w_svc_allergy_vial_creation
integer x = 123
integer y = 308
integer width = 338
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Comment:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_total_volume from statictext within w_svc_allergy_vial_creation
integer x = 2043
integer y = 1512
integer width = 453
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "5.00 ml"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_svc_allergy_vial_creation
integer x = 2473
integer y = 300
integer width = 137
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string 			ls_comment
long   			ll_null
datetime 		ldt_null

str_popup			popup
str_popup_return  popup_return

setnull(ldt_null)
setnull(ll_null)


// Call progress note edit to get the comments
popup.data_row_count = 3
popup.items[1] = "VIAL_CREATION_"+string(treatment_id)
popup.items[2] = "VIAL_CREATON"
popup.items[3] = ls_comment

Openwithparm(w_progress_note_edit,popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

ls_comment = popup_return.items[1]
If not isnull(ls_comment) and len(ls_comment) > 0 Then

	f_set_progress(current_patient.cpr_id, &
                        "Treatment", &
                        treatment_id, &
                        'Comment', &
                        'Comment', &
                        ls_comment, &
                        ldt_null, &
                        ll_null, &
                        ll_null, &
                        ll_null)
								
	ls_comment = get_comments()
	sle_comments.text = ls_comment
End If
end event

type cb_cancel from commandbutton within w_svc_allergy_vial_creation
integer x = 1495
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
string text = "Cancel"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"
closewithreturn(parent, popup_return)


end event

type st_4 from statictext within w_svc_allergy_vial_creation
integer x = 41
integer y = 180
integer width = 215
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_description from statictext within w_svc_allergy_vial_creation
integer x = 283
integer y = 168
integer width = 1522
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

type st_allergen_title from statictext within w_svc_allergy_vial_creation
integer x = 73
integer y = 448
integer width = 1042
integer height = 72
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Constituent"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_svc_allergy_vial_creation
integer x = 2400
integer y = 456
integer width = 247
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "In Vial?"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_svc_allergy_vial_creation
integer x = 2107
integer y = 460
integer width = 293
integer height = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Amount"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_allergens from u_dw_pick_list within w_svc_allergy_vial_creation
integer x = 59
integer y = 520
integer width = 2629
integer height = 972
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_allergy_vial_creation"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event selected;call super::selected;string ls_treatment_status
long ll_treatment_id,ll_null
datetime ldt_null
string	ls_null
string ls_temp
str_popup_return	popup_return

setnull(ldt_null)
setnull(ll_null)
setnull(ls_null)

ll_treatment_id = object.treatment_id[selected_row]
ls_treatment_status = object.treatment_status[selected_row]

// if it's diluent then 
IF isnull(object.drug_id[selected_row]) then
	ls_temp = object.treatment_description[selected_row]
	if len(ls_temp) > 0 then
		ls_temp = "Is " + ls_temp + " added into the vial?"
	else
		ls_temp = "Is constituent added into the vial?"
	end if
	Openwithparm(w_pop_yes_no, ls_temp)
	popup_return = message.powerobjectparm
	IF popup_return.item <> "YES" THEN
		if ls_treatment_status = 'CLOSED' THEN
			f_set_progress(current_patient.cpr_id, &
						"Treatment", &
						ll_treatment_id, &
						'Modify', &
						'treatment_status', &
						'OPEN', &
						ldt_null, &
						ll_null, &
						ll_null, &
						ll_null)	
		end if
	ELSE
		if ls_treatment_status = 'OPEN' Then
			 f_set_progress(current_patient.cpr_id, &
								"Treatment", &
								ll_treatment_id, &
								'CLOSED', &
								ls_null, &
								'added in vial', &
								ldt_null, &
								ll_null, &
								ll_null, &
								ll_null)	
		end if
	END IF
ELSE
	Openwithparm(w_vial_instance_details, ll_treatment_id)
END IF

refresh()


end event

type st_details_title from statictext within w_svc_allergy_vial_creation
integer x = 1097
integer y = 444
integer width = 1015
integer height = 76
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Maker/Exp Date/Lot No"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_comments from singlelineedit within w_svc_allergy_vial_creation
integer x = 480
integer y = 296
integer width = 1975
integer height = 96
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_total_volume_title from statictext within w_svc_allergy_vial_creation
integer x = 1600
integer y = 1516
integer width = 430
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Total Volume:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_bill_units_title from statictext within w_svc_allergy_vial_creation
integer x = 14
integer y = 1524
integer width = 795
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Bill 12 Units of 65387:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_bill_units_yes from statictext within w_svc_allergy_vial_creation
integer x = 827
integer y = 1516
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
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_bill_units_yes.backcolor = color_object_selected
st_bill_units_no.backcolor = color_object

bill_for_creation = true


end event

type st_bill_units_no from statictext within w_svc_allergy_vial_creation
integer x = 1083
integer y = 1516
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
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_bill_units_yes.backcolor = color_object
st_bill_units_no.backcolor = color_object_selected

bill_for_creation = false


end event

