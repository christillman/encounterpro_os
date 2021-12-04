$PBExportHeader$w_do_immunization.srw
forward
global type w_do_immunization from w_window_base
end type
type st_exp_t from statictext within w_do_immunization
end type
type cb_lit from commandbutton within w_do_immunization
end type
type sle_lit_date from singlelineedit within w_do_immunization
end type
type st_lit_title from statictext within w_do_immunization
end type
type cb_edit_location_domain from commandbutton within w_do_immunization
end type
type cb_cancel_procedure from commandbutton within w_do_immunization
end type
type cb_done from commandbutton within w_do_immunization
end type
type st_location from statictext within w_do_immunization
end type
type st_vaccine_maker from statictext within w_do_immunization
end type
type st_5 from statictext within w_do_immunization
end type
type st_description from statictext within w_do_immunization
end type
type st_3 from statictext within w_do_immunization
end type
type sle_lot_number from singlelineedit within w_do_immunization
end type
type st_2 from statictext within w_do_immunization
end type
type st_expiration_date from statictext within w_do_immunization
end type
type cb_beback from commandbutton within w_do_immunization
end type
type cb_edit_reference_ndc_code from commandbutton within w_do_immunization
end type
type st_reference_ndc_code from statictext within w_do_immunization
end type
type st_ndc_title from statictext within w_do_immunization
end type
type uo_drug_package from u_drug_package within w_do_immunization
end type
type st_package from statictext within w_do_immunization
end type
end forward

global type w_do_immunization from w_window_base
windowtype windowtype = response!
st_exp_t st_exp_t
cb_lit cb_lit
sle_lit_date sle_lit_date
st_lit_title st_lit_title
cb_edit_location_domain cb_edit_location_domain
cb_cancel_procedure cb_cancel_procedure
cb_done cb_done
st_location st_location
st_vaccine_maker st_vaccine_maker
st_5 st_5
st_description st_description
st_3 st_3
sle_lot_number sle_lot_number
st_2 st_2
st_expiration_date st_expiration_date
cb_beback cb_beback
cb_edit_reference_ndc_code cb_edit_reference_ndc_code
st_reference_ndc_code st_reference_ndc_code
st_ndc_title st_ndc_title
uo_drug_package uo_drug_package
st_package st_package
end type
global w_do_immunization w_do_immunization

type variables
String vaccine_id
String param_class
String location_domain
String location
String maker_id
String location_domain_preference_id
u_component_treatment treat_immun
string primary_preference_suffix
string secondary_preference_suffix

date expiration_date


end variables

forward prototypes
public function integer save_changes ()
public subroutine display_expiration_date ()
public subroutine display_ndc ()
end prototypes

public function integer save_changes ();integer li_sts

treat_immun.maker_id = maker_id
treat_immun.lot_number = trim(sle_lot_number.text)
treat_immun.location = location
treat_immun.drug_id = vaccine_id
treat_immun.duration_prn = trim(sle_lit_date.text)
treat_immun.expiration_date = datetime(expiration_date, time(""))
treat_immun.treatment_office_id = gnv_app.office_id
treat_immun.updated = true

li_sts = current_patient.treatments.update_treatment(treat_immun)

return li_sts



end function

public subroutine display_expiration_date ();if isnull(expiration_date) then
	st_expiration_date.text = "N/A"
	st_expiration_date.backcolor = color_light_yellow
elseif expiration_date <= date("1/1/2000") then
	setnull(expiration_date)
	st_expiration_date.text = "N/A"
	st_expiration_date.backcolor = color_light_yellow
elseif expiration_date <= today() then
	st_expiration_date.text = string(expiration_date)
	st_expiration_date.backcolor = color_light_yellow
else
	st_expiration_date.text = string(expiration_date)
	st_expiration_date.backcolor = color_object
end if

end subroutine

public subroutine display_ndc ();str_drug_definition lstr_drug
integer li_sts

li_sts = drugdb.get_drug_definition(treat_immun.drug_id, lstr_drug)
if li_sts <= 0 then
	log.log(this, "w_do_immunization.display_ndc:0006", "Error getting drug definition (" + treat_immun.drug_id + ")", 4)
	st_reference_ndc_code.text = "<Error>"
	return
end if

st_reference_ndc_code.text = lstr_drug.reference_ndc_code

end subroutine

event open;call super::open;Integer						li_rtn,li_count
// user defined
u_component_service		service
str_popup_return        popup_return

// Receive the service instance
service = Message.powerobjectparm
cb_cancel_procedure.visible = true

title = current_patient.id_line()

// get the appropriate treatment component instance
li_rtn = current_patient.treatments.treatment(treat_immun,service.treatment_id)
If li_rtn < 0 Then
	Closewithreturn(This, popup_return)
	Return
End if

// Get the location domain.  If there isn't a preference for this dosage form
// then use the default location_domain
location_domain_preference_id = "!" + treat_immun.procedure_id + "_location_domain"
location_domain = datalist.get_preference("PREFERENCES", location_domain_preference_id)
If Isnull(location_domain) Then location_domain = "!IMMUN"

// Check to see if it exists
SELECT count(*)
INTO :li_count
FROM c_Location_Domain
WHERE location_domain = :location_domain;
If Not tf_check() Then
	Closewithreturn(This, popup_return)
	Return
End if

// If not, then add it
If li_count <= 0 Then
	Insert Into c_Location_Domain (
		location_domain,
		description)
	Values (
		:location_domain,
		'Immunization Locations' );
	If Not tf_check() Then
		Closewithreturn(This, popup_return)
		Return
	End if
End if
postevent("post_open")

end event

on w_do_immunization.create
int iCurrent
call super::create
this.st_exp_t=create st_exp_t
this.cb_lit=create cb_lit
this.sle_lit_date=create sle_lit_date
this.st_lit_title=create st_lit_title
this.cb_edit_location_domain=create cb_edit_location_domain
this.cb_cancel_procedure=create cb_cancel_procedure
this.cb_done=create cb_done
this.st_location=create st_location
this.st_vaccine_maker=create st_vaccine_maker
this.st_5=create st_5
this.st_description=create st_description
this.st_3=create st_3
this.sle_lot_number=create sle_lot_number
this.st_2=create st_2
this.st_expiration_date=create st_expiration_date
this.cb_beback=create cb_beback
this.cb_edit_reference_ndc_code=create cb_edit_reference_ndc_code
this.st_reference_ndc_code=create st_reference_ndc_code
this.st_ndc_title=create st_ndc_title
this.uo_drug_package=create uo_drug_package
this.st_package=create st_package
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_exp_t
this.Control[iCurrent+2]=this.cb_lit
this.Control[iCurrent+3]=this.sle_lit_date
this.Control[iCurrent+4]=this.st_lit_title
this.Control[iCurrent+5]=this.cb_edit_location_domain
this.Control[iCurrent+6]=this.cb_cancel_procedure
this.Control[iCurrent+7]=this.cb_done
this.Control[iCurrent+8]=this.st_location
this.Control[iCurrent+9]=this.st_vaccine_maker
this.Control[iCurrent+10]=this.st_5
this.Control[iCurrent+11]=this.st_description
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.sle_lot_number
this.Control[iCurrent+14]=this.st_2
this.Control[iCurrent+15]=this.st_expiration_date
this.Control[iCurrent+16]=this.cb_beback
this.Control[iCurrent+17]=this.cb_edit_reference_ndc_code
this.Control[iCurrent+18]=this.st_reference_ndc_code
this.Control[iCurrent+19]=this.st_ndc_title
this.Control[iCurrent+20]=this.uo_drug_package
this.Control[iCurrent+21]=this.st_package
end on

on w_do_immunization.destroy
call super::destroy
destroy(this.st_exp_t)
destroy(this.cb_lit)
destroy(this.sle_lit_date)
destroy(this.st_lit_title)
destroy(this.cb_edit_location_domain)
destroy(this.cb_cancel_procedure)
destroy(this.cb_done)
destroy(this.st_location)
destroy(this.st_vaccine_maker)
destroy(this.st_5)
destroy(this.st_description)
destroy(this.st_3)
destroy(this.sle_lot_number)
destroy(this.st_2)
destroy(this.st_expiration_date)
destroy(this.cb_beback)
destroy(this.cb_edit_reference_ndc_code)
destroy(this.st_reference_ndc_code)
destroy(this.st_ndc_title)
destroy(this.uo_drug_package)
destroy(this.st_package)
end on

event close;// Destroy the component
component_manager.destroy_component(treat_immun)
end event

event post_open;call super::post_open;integer li_vaccine_index
string ls_message
string ls_description
str_popup_return popup_return
string ls_temp
popup_return.item_count = 0

//treat_immun.maker_id = maker_id
//treat_immun.lot_number = sle_lot_number.text
//treat_immun.location = location
//treat_immun.drug_id = vaccine_id
//treat_immun.duration_prn = sle_lit_date.text
//treat_immun.expiration_date = datetime(expiration_date, time(""))
//treat_immun.treatment_office_id = office_id
//treat_immun.updated = true

ls_temp = datalist.get_preference("IMMUNIZATION", "Vaccine Primary State Object")
if lower(ls_temp) = "Drug" then
	primary_preference_suffix = treat_immun.drug_id
	secondary_preference_suffix = treat_immun.procedure_id
else
	primary_preference_suffix = treat_immun.procedure_id
	secondary_preference_suffix = treat_immun.drug_id
end if

///////////////////////////////////////////////////////////////////////
// Maker
///////////////////////////////////////////////////////////////////////
setnull(maker_id)
if isnull(treat_immun.maker_id) then
	ls_temp = datalist.get_preference("IMMUNIZATION", "MAKER_"+primary_preference_suffix)
	if isnull(ls_temp) then
		// For backward compatibility, look up the last value for this procedure
		ls_temp = datalist.get_preference("IMMUNIZATION", "MAKER_"+secondary_preference_suffix)
	end if
	if len(ls_temp) > 0 then
		maker_id = ls_temp
	end if
else
	maker_id = treat_immun.maker_id
end if

If isnull(maker_id) Then
	st_vaccine_maker.text = "N/A"
Else
	SELECT maker_name
	INTO :st_vaccine_maker.text
	FROM c_Drug_Maker
	WHERE maker_id = :maker_id;
	If Not tf_check() Then
		log.log(This, "w_do_immunization:post", "Error getting maker information", 4)
		closewithreturn(This, popup_return)
		return
	End If
	If sqlca.sqlcode = 100 Then
		st_vaccine_maker.text = "N/A"
		setnull(maker_id)
	End if
End if

///////////////////////////////////////////////////////////////////////
// Lot Number
///////////////////////////////////////////////////////////////////////
if isnull(treat_immun.lot_number) then
	ls_temp = datalist.get_preference("IMMUNIZATION", "LOT_" + maker_id + "_" + primary_preference_suffix)
	if isnull(ls_temp) then
		// For backward compatibility, look up the last value for this procedure
		ls_temp = datalist.get_preference("IMMUNIZATION", "LOT_" + maker_id + "_" + secondary_preference_suffix)
	end if
	if len(ls_temp) > 0 then
		sle_lot_number.text = ls_temp
	end if
else
	sle_lot_number.text = treat_immun.lot_number
end if

///////////////////////////////////////////////////////////////////////
// Expiration date
///////////////////////////////////////////////////////////////////////
if isnull(treat_immun.expiration_date) then
	// If we don't have an expiration date yet, then look up the last one for this vaccine
	ls_temp = datalist.get_preference("IMMUNIZATION", "EXP_" + maker_id + "_" + primary_preference_suffix)
	if isnull(ls_temp) then
		// For backward compatibility, look up the last value for this procedure
		ls_temp = datalist.get_preference("IMMUNIZATION", "EXP_" + maker_id + "_" + secondary_preference_suffix)
	end if
	if isdate(ls_temp) then
		expiration_date = date(ls_temp)
	else
		setnull(expiration_date)
	end if
else
	expiration_date = date(treat_immun.expiration_date)
end if

display_expiration_date()


///////////////////////////////////////////////////////////////////////
// Literature Date
///////////////////////////////////////////////////////////////////////
if len(treat_immun.duration_prn) > 0 then
	sle_lit_date.text = treat_immun.duration_prn
	sle_lit_date.backcolor = color_white
	sle_lit_date.enabled = true
else
	sle_lit_date.backcolor = color_object
	sle_lit_date.enabled = false
end if

st_description.text = treat_immun.description()

///////////////////////////////////////////////////////////////////////
// Location
///////////////////////////////////////////////////////////////////////
setnull(location)
if isnull(treat_immun.location) then
	ls_temp = datalist.get_preference("IMMUNIZATION", "LOCATION_"+primary_preference_suffix)
	if isnull(ls_temp) then
		// For backward compatibility, look up the last value for this procedure
		ls_temp = datalist.get_preference("IMMUNIZATION", "LOCATION_"+secondary_preference_suffix)
	end if
	if len(ls_temp) > 0 then
		location = ls_temp
	end if
else
	location = treat_immun.location
end if
If isnull(location) Then
	st_location.text = "N/A"
Else
	SELECT description
	INTO :st_location.text
	FROM c_Location
	WHERE location_domain = :location_domain
	AND location = :location;
	If Not tf_check() Then
		log.log(this, "w_do_immunization:post", "Error getting maker information", 4)
		closewithreturn(this, popup_return)
		Return
	End if
	If sqlca.sqlcode = 100 Then
		st_location.text = "N/A"
		setnull(location)
	End If
End If

if isnull(treat_immun.drug_id) then
	li_vaccine_index = vaccine_list.get_vaccine_from_proc(treat_immun.procedure_id)
	If li_vaccine_index <= 0 Then
		ls_message = "The immunization procedure (" + st_description.text &
						 + ") is not configured with a corresponding vaccine.  Please select a vaccine for this procedure " &
						 + " on the procedure definition screen."
		openwithparm(w_pop_message, ls_message)
		log.log(this, "w_do_immunization:post", "Unable to locate vaccine for procedure " + treat_immun.procedure_id, 3)
		closewithreturn(this, popup_return)
		Return
	End if
	
	vaccine_id = vaccine_list.vaccine[li_vaccine_index].drug_id
else
	vaccine_id = treat_immun.drug_id
end if

display_ndc()

if user_list.is_user_service(current_user.user_id, "CONFIG_DRUGS") then
	cb_edit_reference_ndc_code.visible = true
else
	cb_edit_reference_ndc_code.visible = false
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_do_immunization
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_do_immunization
end type

type st_exp_t from statictext within w_do_immunization
integer x = 311
integer y = 796
integer width = 581
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Expiration Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_lit from commandbutton within w_do_immunization
integer x = 2158
integer y = 944
integer width = 603
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Gave Literature"
end type

event clicked;sle_lit_date.text = f_get_global_preference("IMMUNIZATION", "LIT_" + maker_id + "_" + secondary_preference_suffix)
sle_lit_date.backcolor = color_white
sle_lit_date.enabled = true
sle_lit_date.setfocus()

end event

type sle_lit_date from singlelineedit within w_do_immunization
integer x = 933
integer y = 944
integer width = 1193
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_lit_title from statictext within w_do_immunization
integer x = 334
integer y = 964
integer width = 558
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Literature Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_edit_location_domain from commandbutton within w_do_immunization
integer x = 2158
integer y = 1112
integer width = 169
integer height = 112
integer taborder = 20
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
string ls_assessment_id
integer li_update_flag

if not isnull(location_domain) and location_domain <> "NA" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Locations in this Domain"
	popup.button_titles[popup.button_count] = "Edit Domain"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Change Location Domain"
	popup.button_titles[popup.button_count] = "Change Domain"
	buttons[popup.button_count] = "CHANGE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "EDIT"
		popup.data_row_count = 1
		popup.items[1] = location_domain
		openwithparm(w_location_domain_edit, popup)
		st_location.postevent("clicked")
	CASE "CHANGE"
		open(w_pick_location_domain)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		
		if popup_return.items[1] <> location_domain then
			if not isnull(location_domain_preference_id) then
				li_sts = datalist.update_preference("PREFERENCES", "Global", "Global", location_domain_preference_id, location_domain)
				if li_sts <= 0 then log.log(this, "w_do_immunization.cb_edit_location_domain.clicked:0060", "Error updating location domain preference", 3)
			end if
			location_domain = popup_return.items[1]
			st_location.postevent("clicked")
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type cb_cancel_procedure from commandbutton within w_do_immunization
integer x = 59
integer y = 1564
integer width = 837
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel Immunization"
end type

event clicked;integer li_sts
str_popup_return popup_return

openwithparm(w_pop_ok, "Cancel " + treat_immun.description() + "?")

if message.doubleparm <> 1 then return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"
closewithreturn(parent, popup_return)


end event

type cb_done from commandbutton within w_do_immunization
integer x = 1979
integer y = 1564
integer width = 837
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Immunization Given"
end type

event clicked;str_popup_return popup_return
integer li_item, li_vaccine_index
string ls_maker_id, ls_site, ls_lot_number, ls_location
datetime ldt_vaccine_date
integer li_sts

if isnull(maker_id) then
	messagebox("Vaccine Information", "Maker Required")
	return
end if

if trim(sle_lot_number.text) = "" then
	messagebox("Vaccine Information", "Lot Number Required")
	return
end if

if isnull(location) then
	messagebox("Vaccine Information", "Location Required")
	return
end if

if trim(sle_lit_date.text) = "" then
	openwithparm(w_pop_yes_no, "Are you sure you wish to complete the immunization without giving literature?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if

if len(maker_id) > 0 then
	datalist.update_preference( "IMMUNIZATION", &
										"Office", &
										gnv_app.office_id, &
										"MAKER_" + primary_preference_suffix, &
										maker_id)
	datalist.update_preference( "IMMUNIZATION", &
										"Office", &
										gnv_app.office_id, &
										"MAKER_" + secondary_preference_suffix, &
										maker_id)
end if

if len(sle_lot_number.text) > 0 and trim(sle_lot_number.text) <> "" then
	datalist.update_preference( "IMMUNIZATION", &
										"Office", &
										gnv_app.office_id, &
										"LOT_" + maker_id + "_" + primary_preference_suffix, &
										trim(sle_lot_number.text))
	datalist.update_preference( "IMMUNIZATION", &
										"Office", &
										gnv_app.office_id, &
										"LOT_" + maker_id + "_" + secondary_preference_suffix, &
										trim(sle_lot_number.text))
end if
	
	
if len(sle_lit_date.text) > 0 then
	datalist.update_preference( "IMMUNIZATION", &
										"Office", &
										gnv_app.office_id, &
										"LIT_" + maker_id + "_" + primary_preference_suffix, &
										sle_lit_date.text)
	datalist.update_preference( "IMMUNIZATION", &
										"Office", &
										gnv_app.office_id, &
										"LIT_" + maker_id + "_" + secondary_preference_suffix, &
										sle_lit_date.text)
end if
	
	
if len(location) > 0 then
	datalist.update_preference( "IMMUNIZATION", &
										"Office", &
										gnv_app.office_id, &
										"LOCATION_"+primary_preference_suffix, &
										location)
	datalist.update_preference( "IMMUNIZATION", &
										"Office", &
										gnv_app.office_id, &
										"LOCATION_"+secondary_preference_suffix, &
										location)
end if


if not isnull(expiration_date) then
	//f_set_global_preference("IMMUNIZATION", "EXP_" + maker_id + "_" + treat_immun.procedure_id, string(expiration_date, date_format_string))
	datalist.update_preference( "IMMUNIZATION", &
										"Office", &
										gnv_app.office_id, &
										"EXP_" + maker_id + "_" + primary_preference_suffix, &
										string(expiration_date))
	datalist.update_preference( "IMMUNIZATION", &
										"Office", &
										gnv_app.office_id, &
										"EXP_" + maker_id + "_" + secondary_preference_suffix, &
										string(expiration_date))
end if

li_sts = save_changes()
if li_sts < 0 then
	log.log(this, "w_do_immunization.cb_done.clicked:0099", "Error saving changes", 4)
	return
end if

popup_return.item_count = 1
popup_return.items[1] = "CLOSE"
closewithreturn(Parent, popup_return)


end event

type st_location from statictext within w_do_immunization
integer x = 933
integer y = 1112
integer width = 1193
integer height = 112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "N/A"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return


popup.dataobject = "dw_location_pick"
popup.argument_count = 1
popup.argument[1] = location_domain
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "N/A"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

if popup_return.items[1] = "" then
	setnull(location)
else
	location = popup_return.items[1]
end if

text = popup_return.descriptions[1]

end event

type st_vaccine_maker from statictext within w_do_immunization
integer x = 933
integer y = 440
integer width = 1193
integer height = 112
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "N/A"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return


popup.dataobject = "dw_maker_pick"
popup.argument_count = 1
popup.argument[1] = vaccine_id
popup.datacolumn = 2
popup.displaycolumn = 1
popup.add_blank_row = true
popup.blank_text = "N/A"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

if popup_return.items[1] = "" then
	setnull(maker_id)	
else
	maker_id = popup_return.items[1]
end if

text = popup_return.descriptions[1]

sle_lot_number.setfocus()

end event

type st_5 from statictext within w_do_immunization
integer x = 539
integer y = 1132
integer width = 352
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Location:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_description from statictext within w_do_immunization
integer width = 2926
integer height = 144
integer textsize = -22
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_do_immunization
integer x = 338
integer y = 628
integer width = 553
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Lot Number:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_lot_number from singlelineedit within w_do_immunization
integer x = 933
integer y = 608
integer width = 1193
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_do_immunization
integer x = 338
integer y = 460
integer width = 553
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Vaccine Maker:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_expiration_date from statictext within w_do_immunization
integer x = 933
integer y = 776
integer width = 1193
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;date ld_expiration_date
string ls_text

ld_expiration_date = expiration_date
if isnull(ld_expiration_date) then ld_expiration_date = today()

ls_text = f_select_date(ld_expiration_date, "Expiration Date")
if isnull(ls_text) then return

expiration_date = ld_expiration_date

display_expiration_date()

end event

type cb_beback from commandbutton within w_do_immunization
integer x = 1449
integer y = 1564
integer width = 466
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = save_changes()
if li_sts < 0 then
	log.log(this, "w_do_immunization.cb_beback.clicked:0006", "Error saving changes", 4)
	return
end if

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cb_edit_reference_ndc_code from commandbutton within w_do_immunization
integer x = 2158
integer y = 1280
integer width = 169
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;w_window_base lw_config_drug

openwithparm(lw_config_drug, treat_immun.drug_id, "w_config_drug")

drugdb.clear_cache()

display_ndc()

end event

type st_reference_ndc_code from statictext within w_do_immunization
integer x = 933
integer y = 1280
integer width = 1193
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_ndc_title from statictext within w_do_immunization
integer x = 69
integer y = 1300
integer width = 823
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Reference NDC Code:"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_drug_package from u_drug_package within w_do_immunization
integer x = 933
integer y = 288
integer width = 1193
integer height = 112
boolean bringtotop = true
integer textsize = -10
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = true
boolean disabledlook = false
end type

event clicked;call super::clicked;window w
integer i
real lr_temp
string ls_form_rxcui, ls_ingr_rxcui, ls_form_description, ls_drug_id
str_popup popup
str_popup_return popup_return

// Replace above popup with new 2-column formulation window
ls_drug_id = vaccine_id
ls_form_description = f_choose_vaccine(ls_drug_id, ls_form_rxcui, ls_ingr_rxcui)

// This is inherited from u_drug_package, which has a form_rxcui array.
selectformulation(ls_form_rxcui)

// We want to assign to the window instance variable.
vaccine_id = ls_drug_id

end event

type st_package from statictext within w_do_immunization
integer x = 315
integer y = 316
integer width = 576
integer height = 68
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Formulation:"
alignment alignment = right!
boolean focusrectangle = false
end type

