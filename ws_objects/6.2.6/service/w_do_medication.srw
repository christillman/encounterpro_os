HA$PBExportHeader$w_do_medication.srw
forward
global type w_do_medication from w_window_base
end type
type st_exp_t from statictext within w_do_medication
end type
type st_description from statictext within w_do_medication
end type
type st_desc_title from statictext within w_do_medication
end type
type cb_edit_location_domain from commandbutton within w_do_medication
end type
type st_5 from statictext within w_do_medication
end type
type st_location from statictext within w_do_medication
end type
type st_2 from statictext within w_do_medication
end type
type sle_lot_number from singlelineedit within w_do_medication
end type
type st_3 from statictext within w_do_medication
end type
type st_vaccine_maker from statictext within w_do_medication
end type
type cb_done from commandbutton within w_do_medication
end type
type cb_cancel_procedure from commandbutton within w_do_medication
end type
type st_title from statictext within w_do_medication
end type
type st_expiration_date from statictext within w_do_medication
end type
type cb_be_back from commandbutton within w_do_medication
end type
type dw_cocktail from datawindow within w_do_medication
end type
type st_cocktail_title from statictext within w_do_medication
end type
end forward

global type w_do_medication from w_window_base
integer width = 2962
integer height = 1936
boolean controlmenu = false
windowtype windowtype = response!
string button_type = "COMMAND"
st_exp_t st_exp_t
st_description st_description
st_desc_title st_desc_title
cb_edit_location_domain cb_edit_location_domain
st_5 st_5
st_location st_location
st_2 st_2
sle_lot_number sle_lot_number
st_3 st_3
st_vaccine_maker st_vaccine_maker
cb_done cb_done
cb_cancel_procedure cb_cancel_procedure
st_title st_title
st_expiration_date st_expiration_date
cb_be_back cb_be_back
dw_cocktail dw_cocktail
st_cocktail_title st_cocktail_title
end type
global w_do_medication w_do_medication

type variables
u_component_treatment officemed

string maker_id
string location_domain
string location

string preference_suffix

date expiration_date

str_drug_definition drug_definition

end variables

event open;call super::open;str_progress_list lstr_progress
integer i
long ll_row
string ls_progress_key
Integer					li_count,li_rtn
String					ls_common_name
u_component_service	service
str_popup_return  	popup_return
string ls_temp
long ll_menu_id
integer li_sts
string ls_description
string ls_amount


// Receive the service instance
service = Message.powerobjectparm
popup_return.item_count = 0

title = current_patient.id_line()

// get the appropriate treatment component instance
li_rtn = current_patient.treatments.treatment(officemed,service.treatment_id)
If li_rtn < 0 Then
	Closewithreturn(This, popup_return)
	Return
End if

st_description.text = officemed.description()
If Not isnull(officemed.drug_id) Then
  SELECT c_Drug_Definition.common_name  
    INTO :ls_common_name  
    FROM c_Drug_Definition (NOLOCK)
   WHERE c_Drug_Definition.drug_id = :officemed.drug_id;

	If Not tf_check() Then ls_common_name = officemed.drug_id

	If sqlca.sqlcode <> 0 then ls_common_name = officemed.drug_id
End if
st_title.text = "Office Medication - " + ls_common_name
preference_suffix = f_gen_key_string(officemed.drug_id + " " + officemed.package_id, 27)

// Get the location domain.  If there isn't a preference for this dosage form
// then use the default location_domain
location_domain = f_get_global_preference("MEDICATION", "LD_" + preference_suffix)
if isnull(location_domain) then location_domain = "!OFFICEMED"

// Check to see if it exists
SELECT count(*)
INTO :li_count
FROM c_Location_Domain
WHERE location_domain = :location_domain;
if not tf_check() then
	closewithreturn(this, popup_return)
	return
end if

// If not, then add it
if li_count <= 0 then
	INSERT INTO c_Location_Domain (
		location_domain,
		description)
	VALUES (
		:location_domain,
		'Medication Locations' );
	if not tf_check() then
		closewithreturn(this, popup_return)
		return
	end if
end if

maker_id = f_get_global_preference("MEDICATION", "MAK_" + preference_suffix)
if isnull(maker_id) then
	st_vaccine_maker.text = "N/A"
else
	SELECT maker_name
	INTO :st_vaccine_maker.text
	FROM c_Drug_Maker
	WHERE maker_id = :maker_id;
	if not tf_check() then
		log.log(this, "post_open", "Error getting maker information", 4)
		closewithreturn(this, popup_return)
		return
	end if
	if sqlca.sqlcode = 100 then
		st_vaccine_maker.text = "N/A"
		setnull(maker_id)
	end if
end if

sle_lot_number.text = f_get_global_preference("MEDICATION", "LOT_" + left(maker_id, 8) + "_" + preference_suffix)

ls_temp = f_get_global_preference("MEDICATION", "EXP_" + left(maker_id, 8) + "_" + preference_suffix)
if isnull(ls_temp) then
	st_expiration_date.text = "N/A"
elseif isdate(ls_temp) then
	st_expiration_date.text = ls_temp
	expiration_date = date(ls_temp)
else
	st_expiration_date.text = "N/A"
end if

location = f_get_global_preference("MEDICATION", "LOC_" + preference_suffix)
if isnull(location) then
	st_location.text = "N/A"
else
	SELECT description
	INTO :st_location.text
	FROM c_Location
	WHERE location_domain = :location_domain
	AND location = :location;
	if not tf_check() then
		log.log(this, "post_open", "Error getting location information", 4)
		closewithreturn(this, popup_return)
		return
	end if
	if sqlca.sqlcode = 100 then
		st_location.text = "N/A"
		setnull(location)
	end if
end if


li_sts = drugdb.get_drug_definition(officemed.drug_id, drug_definition)
if lower(drug_definition.drug_type) = "cocktail" then
	dw_cocktail.visible = true
	st_cocktail_title.visible = true

	setnull(ls_progress_key)
	
	dw_cocktail.reset()
	
	lstr_progress = f_get_progress(current_patient.cpr_id, &
											"Treatment", &
											officemed.treatment_id, &
											"Cocktail", &
											ls_progress_key)
	
	for i = 1 to lstr_progress.progress_count
		ls_description = drugdb.get_drug_property(lstr_progress.progress[i].progress_key, "common_name")
		if isnull(ls_description) then ls_description = lstr_progress.progress[i].progress_key
		
		ls_amount = f_pretty_amount_unit_from_string(lstr_progress.progress[i].progress)
		if isnull(ls_amount) then ls_amount = lstr_progress.progress[i].progress
		
		ll_row = dw_cocktail.insertrow(0)
		dw_cocktail.object.description[ll_row] = ls_description + ": " + ls_amount
	next
else
	dw_cocktail.visible = false
	st_cocktail_title.visible = false
end if


// Don't offer the "I'll Be Back" option for manual services
max_buttons = 4
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 5
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)


end event

on w_do_medication.create
int iCurrent
call super::create
this.st_exp_t=create st_exp_t
this.st_description=create st_description
this.st_desc_title=create st_desc_title
this.cb_edit_location_domain=create cb_edit_location_domain
this.st_5=create st_5
this.st_location=create st_location
this.st_2=create st_2
this.sle_lot_number=create sle_lot_number
this.st_3=create st_3
this.st_vaccine_maker=create st_vaccine_maker
this.cb_done=create cb_done
this.cb_cancel_procedure=create cb_cancel_procedure
this.st_title=create st_title
this.st_expiration_date=create st_expiration_date
this.cb_be_back=create cb_be_back
this.dw_cocktail=create dw_cocktail
this.st_cocktail_title=create st_cocktail_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_exp_t
this.Control[iCurrent+2]=this.st_description
this.Control[iCurrent+3]=this.st_desc_title
this.Control[iCurrent+4]=this.cb_edit_location_domain
this.Control[iCurrent+5]=this.st_5
this.Control[iCurrent+6]=this.st_location
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.sle_lot_number
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_vaccine_maker
this.Control[iCurrent+11]=this.cb_done
this.Control[iCurrent+12]=this.cb_cancel_procedure
this.Control[iCurrent+13]=this.st_title
this.Control[iCurrent+14]=this.st_expiration_date
this.Control[iCurrent+15]=this.cb_be_back
this.Control[iCurrent+16]=this.dw_cocktail
this.Control[iCurrent+17]=this.st_cocktail_title
end on

on w_do_medication.destroy
call super::destroy
destroy(this.st_exp_t)
destroy(this.st_description)
destroy(this.st_desc_title)
destroy(this.cb_edit_location_domain)
destroy(this.st_5)
destroy(this.st_location)
destroy(this.st_2)
destroy(this.sle_lot_number)
destroy(this.st_3)
destroy(this.st_vaccine_maker)
destroy(this.cb_done)
destroy(this.cb_cancel_procedure)
destroy(this.st_title)
destroy(this.st_expiration_date)
destroy(this.cb_be_back)
destroy(this.dw_cocktail)
destroy(this.st_cocktail_title)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_do_medication
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_do_medication
end type

type st_exp_t from statictext within w_do_medication
integer x = 535
integer y = 824
integer width = 571
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Expiration date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_description from statictext within w_do_medication
integer x = 727
integer y = 212
integer width = 1609
integer height = 156
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type st_desc_title from statictext within w_do_medication
integer x = 155
integer y = 216
integer width = 553
integer height = 72
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_edit_location_domain from commandbutton within w_do_medication
integer x = 1952
integer y = 968
integer width = 169
integer height = 112
integer taborder = 40
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
			location_domain = popup_return.items[1]
			li_sts = datalist.update_preference("MEDICATION", "Global", "Global", "LD_" + preference_suffix, location_domain)
			if li_sts <= 0 then log.log(this, "clicked", "Error updating location domain preference", 3)
			st_location.postevent("clicked")
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end event

type st_5 from statictext within w_do_medication
integer x = 754
integer y = 984
integer width = 352
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Location:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_location from statictext within w_do_medication
integer x = 1147
integer y = 968
integer width = 786
integer height = 112
integer taborder = 30
integer textsize = -12
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

type st_2 from statictext within w_do_medication
integer x = 553
integer y = 504
integer width = 553
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Drug Maker:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_lot_number from singlelineedit within w_do_medication
integer x = 1147
integer y = 640
integer width = 786
integer height = 112
integer taborder = 20
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_do_medication
integer x = 553
integer y = 664
integer width = 553
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Lot Number:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_vaccine_maker from statictext within w_do_medication
integer x = 1147
integer y = 476
integer width = 786
integer height = 112
integer taborder = 10
integer textsize = -12
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


popup.dataobject = "dw_maker_pick_list"
popup.datacolumn = 1
popup.displaycolumn = 2
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

type cb_done from commandbutton within w_do_medication
integer x = 1637
integer y = 1224
integer width = 837
integer height = 216
integer taborder = 50
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Medication Given"
boolean default = true
end type

event clicked;str_popup_return popup_return

if not isnull(maker_id) then
	officemed.maker_id = maker_id
	officemed.updated = true
	f_set_global_preference("MEDICATION", "MAK_" + preference_suffix, maker_id)
end if

if not isnull(sle_lot_number.text) and sle_lot_number.text <> "" then
	officemed.lot_number = sle_lot_number.text
	officemed.updated = true
	f_set_global_preference("MEDICATION", "LOT_" + left(maker_id, 8) + "_" + preference_suffix, sle_lot_number.text)
end if

if not isnull(location) then
	officemed.location = location
	officemed.updated = true
	f_set_global_preference("MEDICATION", "LOC_" + preference_suffix, location)
end if

if not isnull(expiration_date) then
	officemed.expiration_date = datetime(expiration_date, time(""))
	officemed.updated = true
	f_set_global_preference("MEDICATION", "EXP_" + left(maker_id, 8) + "_" + preference_suffix, string(expiration_date))
end if

current_patient.treatments.update_treatment(officemed)
//officemed.save()

popup_return.item_count = 1
popup_return.items[1] = "CLOSE"
closewithreturn(parent, popup_return)

end event

type cb_cancel_procedure from commandbutton within w_do_medication
integer x = 553
integer y = 1224
integer width = 837
integer height = 216
integer taborder = 60
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel Medication"
end type

event clicked;str_popup_return popup_return
integer li_sts

openwithparm(w_pop_ok, "Cancel " + officemed.description() + "?")

if message.doubleparm <> 1 then return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"
closewithreturn(parent, popup_return)

end event

type st_title from statictext within w_do_medication
integer width = 2894
integer height = 144
integer textsize = -22
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_expiration_date from statictext within w_do_medication
integer x = 1147
integer y = 804
integer width = 786
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -12
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

if isnull(expiration_date) or expiration_date < date('1/1/1901') then
	ld_expiration_date = today()
else
	ld_expiration_date = expiration_date
end if

ls_text = f_select_date(ld_expiration_date, "Expiration Date")
if isnull(ls_text) then return

expiration_date = ld_expiration_date
text = ls_text


end event

type cb_be_back from commandbutton within w_do_medication
integer x = 2382
integer y = 1584
integer width = 443
integer height = 108
integer taborder = 90
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
integer li_sts

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type dw_cocktail from datawindow within w_do_medication
integer x = 2062
integer y = 484
integer width = 700
integer height = 424
integer taborder = 50
boolean bringtotop = true
string dataobject = "dw_display_drug_cocktail"
boolean livescroll = true
end type

type st_cocktail_title from statictext within w_do_medication
integer x = 2062
integer y = 420
integer width = 439
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Constituents"
boolean focusrectangle = false
end type

