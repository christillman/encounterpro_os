$PBExportHeader$u_tabpage_patient_data.sru
forward
global type u_tabpage_patient_data from u_tabpage
end type
type uo_cb_sex from u_cb_sex_toggle within u_tabpage_patient_data
end type
type sle_phone_prefix from singlelineedit within u_tabpage_patient_data
end type
type st_ssn_t from statictext within u_tabpage_patient_data
end type
type em_ssn from editmask within u_tabpage_patient_data
end type
type sle_id_number from singlelineedit within u_tabpage_patient_data
end type
type st_id_number_t from statictext within u_tabpage_patient_data
end type
type st_country_t from statictext within u_tabpage_patient_data
end type
type st_country from statictext within u_tabpage_patient_data
end type
type st_id_document from statictext within u_tabpage_patient_data
end type
type st_id_document_t from statictext within u_tabpage_patient_data
end type
type st_sex_t from statictext within u_tabpage_patient_data
end type
type cb_make_test from commandbutton within u_tabpage_patient_data
end type
type st_test_patient from statictext within u_tabpage_patient_data
end type
type st_maiden_name_title from statictext within u_tabpage_patient_data
end type
type sle_maiden_name from singlelineedit within u_tabpage_patient_data
end type
type cb_clear_referring_provider from commandbutton within u_tabpage_patient_data
end type
type st_referring_provider_title from statictext within u_tabpage_patient_data
end type
type st_birth_time_title from statictext within u_tabpage_patient_data
end type
type st_time_of_birth from statictext within u_tabpage_patient_data
end type
type sle_nickname from singlelineedit within u_tabpage_patient_data
end type
type st_nickname_t from statictext within u_tabpage_patient_data
end type
type st_patient_name from statictext within u_tabpage_patient_data
end type
type st_date_of_birth from statictext within u_tabpage_patient_data
end type
type cb_change_billing_id from commandbutton within u_tabpage_patient_data
end type
type st_race from statictext within u_tabpage_patient_data
end type
type st_race_title from statictext within u_tabpage_patient_data
end type
type st_patient_status from statictext within u_tabpage_patient_data
end type
type st_patient_status_t from statictext within u_tabpage_patient_data
end type
type st_cpr_id from statictext within u_tabpage_patient_data
end type
type st_primary_provider from u_st_primary_provider within u_tabpage_patient_data
end type
type st_patient_name_t from statictext within u_tabpage_patient_data
end type
type st_birthdate from statictext within u_tabpage_patient_data
end type
type st_age_title from statictext within u_tabpage_patient_data
end type
type st_billing_id_t from statictext within u_tabpage_patient_data
end type
type st_phone_num_title from statictext within u_tabpage_patient_data
end type
type sle_phone_number from singlelineedit within u_tabpage_patient_data
end type
type st_primary_provider_title from statictext within u_tabpage_patient_data
end type
type st_office from statictext within u_tabpage_patient_data
end type
type st_office_title from statictext within u_tabpage_patient_data
end type
type st_billing_id from statictext within u_tabpage_patient_data
end type
type uo_picture from u_picture_display within u_tabpage_patient_data
end type
type st_portrait from statictext within u_tabpage_patient_data
end type
type st_age from statictext within u_tabpage_patient_data
end type
type st_referring_provider from statictext within u_tabpage_patient_data
end type
end forward

global type u_tabpage_patient_data from u_tabpage
integer width = 2875
integer height = 1268
string text = "none"
uo_cb_sex uo_cb_sex
sle_phone_prefix sle_phone_prefix
st_ssn_t st_ssn_t
em_ssn em_ssn
sle_id_number sle_id_number
st_id_number_t st_id_number_t
st_country_t st_country_t
st_country st_country
st_id_document st_id_document
st_id_document_t st_id_document_t
st_sex_t st_sex_t
cb_make_test cb_make_test
st_test_patient st_test_patient
st_maiden_name_title st_maiden_name_title
sle_maiden_name sle_maiden_name
cb_clear_referring_provider cb_clear_referring_provider
st_referring_provider_title st_referring_provider_title
st_birth_time_title st_birth_time_title
st_time_of_birth st_time_of_birth
sle_nickname sle_nickname
st_nickname_t st_nickname_t
st_patient_name st_patient_name
st_date_of_birth st_date_of_birth
cb_change_billing_id cb_change_billing_id
st_race st_race
st_race_title st_race_title
st_patient_status st_patient_status
st_patient_status_t st_patient_status_t
st_cpr_id st_cpr_id
st_primary_provider st_primary_provider
st_patient_name_t st_patient_name_t
st_birthdate st_birthdate
st_age_title st_age_title
st_billing_id_t st_billing_id_t
st_phone_num_title st_phone_num_title
sle_phone_number sle_phone_number
st_primary_provider_title st_primary_provider_title
st_office st_office
st_office_title st_office_title
st_billing_id st_billing_id
uo_picture uo_picture
st_portrait st_portrait
st_age st_age
st_referring_provider st_referring_provider
end type
global u_tabpage_patient_data u_tabpage_patient_data

type variables

w_patient_data w_container
end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public function integer show_patient (string ps_cpr_id)
public subroutine display_portrait ()
public subroutine highlight_st (statictext pwo_control, boolean pb_on)
public subroutine highlight_sle (singlelineedit pwo_control, boolean pb_on)
end prototypes

public function integer initialize ();integer li_sts
string ls_temp
string ls_empty = ""

if isnull(current_patient) then
	log.log(this, "u_tabpage_patient_data.initialize:0014", "No current patient", 4)
	return -1
else
	st_cpr_id.text = current_patient.cpr_id
end if

uo_picture.initialize()

return 1

end function

public subroutine refresh ();show_patient(current_patient.cpr_id)


end subroutine

public function integer show_patient (string ps_cpr_id);string ls_temp
u_user luo_user
string ls_empty = ""

st_patient_name.text = current_patient.name()
st_billing_id.text 		= current_patient.billing_id
st_patient_status.text = current_patient.patient_status
st_date_of_birth.text = string(current_patient.date_of_birth)
st_time_of_birth.text = string(current_patient.time_of_birth)
if st_time_of_birth.text = "00:00:00" then st_time_of_birth.text = ""

st_age.text = f_pretty_age(current_patient.date_of_birth, today())
if current_patient.weeks_premature > 0 then
	st_age.text += " (" + string(current_patient.weeks_premature) + " Wks Prem)"
end if

st_cpr_id.text = ps_cpr_id
uo_cb_sex.set_sex(current_patient.sex)
sle_phone_number.text = current_patient.phone_number
st_primary_provider.initialize(current_patient.primary_provider_id)
st_race.text = current_patient.race
sle_nickname.text = current_patient.nickname
sle_maiden_name.text = current_patient.maiden_name

luo_user = user_list.find_user(current_patient.referring_provider_id)
if isnull(luo_user) then
	st_referring_provider.text = ""
	st_referring_provider.backcolor = color_light_grey
	cb_clear_referring_provider.visible = false
else
	st_referring_provider.text = luo_user.user_full_name
	st_referring_provider.backcolor = luo_user.color
	cb_clear_referring_provider.visible = true
end if

if isnull(current_patient.patient_office_id) then
	st_office.text = ""
else
	SELECT description
	INTO :st_office.text
	FROM c_Office
	WHERE office_id = :current_patient.patient_office_id;
	if not tf_check() then return -1
end if


st_test_patient.textcolor = color_text_error
st_test_patient.visible = current_patient.test_patient

if not current_patient.test_patient and config_mode and user_list.is_user_privileged(current_scribe.user_id, "Super User") then
	cb_make_test.width = 462
	cb_make_test.height = 64
	cb_make_test.visible = true
else
	cb_make_test.visible = false
end if

// Avoid Americanisms 
if NOT IsNull(gnv_app.locale) AND gnv_app.locale = "en-US" then
	em_ssn.text = current_patient.ssn
	sle_nickname.text = current_patient.nickname
	sle_maiden_name.text = current_patient.maiden_name
	st_race.text = current_patient.race
		
	st_id_document.visible = false
	sle_id_number.visible = false
	st_country.visible = false
	st_id_document_t.visible = false
	st_id_number_t.visible = false
	st_country_t.visible = false
	sle_phone_prefix.text = "+1"
else
	// some day may have a case statement for locale?
	// Hide the U.S. fields
	em_ssn.visible = false
	sle_nickname.visible = false
	sle_maiden_name.visible = false
	st_race.visible = false
	
	st_ssn_t.visible = false
	st_nickname_t.visible = false
	st_maiden_name_title.visible = false
	st_race_title.visible = false

	st_id_document.text = ""
	sle_id_number.text = ""
	w_container.get_patient_list_item("Id Document", st_id_document.text, sle_id_number.text)
	st_country.text = ""
	w_container.get_patient_list_item("Country", st_country.text, ls_empty)
	sle_phone_prefix.text = ""
	w_container.get_patient_list_item("Country_Phone_Prefix", sle_phone_prefix.text, ls_empty)
end if

display_portrait()

Return 1


end function

public subroutine display_portrait ();string ls_file
string ls_find
integer li_sts
u_component_attachment luo_image
str_progress_list lstr_attachments
long ll_null

setnull(ll_null)

lstr_attachments = current_patient.attachments.get_attachments( "Patient", ll_null, "Attachment", "Portrait")

If lstr_attachments.progress_count > 0 Then
	ls_file = current_patient.attachments.get_attachment(lstr_attachments.progress[lstr_attachments.progress_count].attachment_id)
	uo_picture.display_picture(ls_file)
	st_portrait.visible = false
	uo_picture.visible = true
	filedelete(ls_file)
else
	st_portrait.visible = true
	uo_picture.visible = false
end if



end subroutine

public subroutine highlight_st (statictext pwo_control, boolean pb_on);
IF pb_on THEN
	pwo_control.backcolor = COLOR_LIGHT_YELLOW
ELSE
	IF NOT f_is_empty_string(pwo_control.text) THEN
		pwo_control.backcolor = COLOR_LIGHT_GREY
	END IF
END IF
end subroutine

public subroutine highlight_sle (singlelineedit pwo_control, boolean pb_on);
IF pb_on THEN
	pwo_control.backcolor = COLOR_LIGHT_YELLOW
ELSE
	IF NOT f_is_empty_string(pwo_control.text) THEN
		pwo_control.backcolor = COLOR_WHITE
	END IF
END IF
end subroutine

on u_tabpage_patient_data.create
int iCurrent
call super::create
this.uo_cb_sex=create uo_cb_sex
this.sle_phone_prefix=create sle_phone_prefix
this.st_ssn_t=create st_ssn_t
this.em_ssn=create em_ssn
this.sle_id_number=create sle_id_number
this.st_id_number_t=create st_id_number_t
this.st_country_t=create st_country_t
this.st_country=create st_country
this.st_id_document=create st_id_document
this.st_id_document_t=create st_id_document_t
this.st_sex_t=create st_sex_t
this.cb_make_test=create cb_make_test
this.st_test_patient=create st_test_patient
this.st_maiden_name_title=create st_maiden_name_title
this.sle_maiden_name=create sle_maiden_name
this.cb_clear_referring_provider=create cb_clear_referring_provider
this.st_referring_provider_title=create st_referring_provider_title
this.st_birth_time_title=create st_birth_time_title
this.st_time_of_birth=create st_time_of_birth
this.sle_nickname=create sle_nickname
this.st_nickname_t=create st_nickname_t
this.st_patient_name=create st_patient_name
this.st_date_of_birth=create st_date_of_birth
this.cb_change_billing_id=create cb_change_billing_id
this.st_race=create st_race
this.st_race_title=create st_race_title
this.st_patient_status=create st_patient_status
this.st_patient_status_t=create st_patient_status_t
this.st_cpr_id=create st_cpr_id
this.st_primary_provider=create st_primary_provider
this.st_patient_name_t=create st_patient_name_t
this.st_birthdate=create st_birthdate
this.st_age_title=create st_age_title
this.st_billing_id_t=create st_billing_id_t
this.st_phone_num_title=create st_phone_num_title
this.sle_phone_number=create sle_phone_number
this.st_primary_provider_title=create st_primary_provider_title
this.st_office=create st_office
this.st_office_title=create st_office_title
this.st_billing_id=create st_billing_id
this.uo_picture=create uo_picture
this.st_portrait=create st_portrait
this.st_age=create st_age
this.st_referring_provider=create st_referring_provider
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_cb_sex
this.Control[iCurrent+2]=this.sle_phone_prefix
this.Control[iCurrent+3]=this.st_ssn_t
this.Control[iCurrent+4]=this.em_ssn
this.Control[iCurrent+5]=this.sle_id_number
this.Control[iCurrent+6]=this.st_id_number_t
this.Control[iCurrent+7]=this.st_country_t
this.Control[iCurrent+8]=this.st_country
this.Control[iCurrent+9]=this.st_id_document
this.Control[iCurrent+10]=this.st_id_document_t
this.Control[iCurrent+11]=this.st_sex_t
this.Control[iCurrent+12]=this.cb_make_test
this.Control[iCurrent+13]=this.st_test_patient
this.Control[iCurrent+14]=this.st_maiden_name_title
this.Control[iCurrent+15]=this.sle_maiden_name
this.Control[iCurrent+16]=this.cb_clear_referring_provider
this.Control[iCurrent+17]=this.st_referring_provider_title
this.Control[iCurrent+18]=this.st_birth_time_title
this.Control[iCurrent+19]=this.st_time_of_birth
this.Control[iCurrent+20]=this.sle_nickname
this.Control[iCurrent+21]=this.st_nickname_t
this.Control[iCurrent+22]=this.st_patient_name
this.Control[iCurrent+23]=this.st_date_of_birth
this.Control[iCurrent+24]=this.cb_change_billing_id
this.Control[iCurrent+25]=this.st_race
this.Control[iCurrent+26]=this.st_race_title
this.Control[iCurrent+27]=this.st_patient_status
this.Control[iCurrent+28]=this.st_patient_status_t
this.Control[iCurrent+29]=this.st_cpr_id
this.Control[iCurrent+30]=this.st_primary_provider
this.Control[iCurrent+31]=this.st_patient_name_t
this.Control[iCurrent+32]=this.st_birthdate
this.Control[iCurrent+33]=this.st_age_title
this.Control[iCurrent+34]=this.st_billing_id_t
this.Control[iCurrent+35]=this.st_phone_num_title
this.Control[iCurrent+36]=this.sle_phone_number
this.Control[iCurrent+37]=this.st_primary_provider_title
this.Control[iCurrent+38]=this.st_office
this.Control[iCurrent+39]=this.st_office_title
this.Control[iCurrent+40]=this.st_billing_id
this.Control[iCurrent+41]=this.uo_picture
this.Control[iCurrent+42]=this.st_portrait
this.Control[iCurrent+43]=this.st_age
this.Control[iCurrent+44]=this.st_referring_provider
end on

on u_tabpage_patient_data.destroy
call super::destroy
destroy(this.uo_cb_sex)
destroy(this.sle_phone_prefix)
destroy(this.st_ssn_t)
destroy(this.em_ssn)
destroy(this.sle_id_number)
destroy(this.st_id_number_t)
destroy(this.st_country_t)
destroy(this.st_country)
destroy(this.st_id_document)
destroy(this.st_id_document_t)
destroy(this.st_sex_t)
destroy(this.cb_make_test)
destroy(this.st_test_patient)
destroy(this.st_maiden_name_title)
destroy(this.sle_maiden_name)
destroy(this.cb_clear_referring_provider)
destroy(this.st_referring_provider_title)
destroy(this.st_birth_time_title)
destroy(this.st_time_of_birth)
destroy(this.sle_nickname)
destroy(this.st_nickname_t)
destroy(this.st_patient_name)
destroy(this.st_date_of_birth)
destroy(this.cb_change_billing_id)
destroy(this.st_race)
destroy(this.st_race_title)
destroy(this.st_patient_status)
destroy(this.st_patient_status_t)
destroy(this.st_cpr_id)
destroy(this.st_primary_provider)
destroy(this.st_patient_name_t)
destroy(this.st_birthdate)
destroy(this.st_age_title)
destroy(this.st_billing_id_t)
destroy(this.st_phone_num_title)
destroy(this.sle_phone_number)
destroy(this.st_primary_provider_title)
destroy(this.st_office)
destroy(this.st_office_title)
destroy(this.st_billing_id)
destroy(this.uo_picture)
destroy(this.st_portrait)
destroy(this.st_age)
destroy(this.st_referring_provider)
end on

type uo_cb_sex from u_cb_sex_toggle within u_tabpage_patient_data
integer x = 590
integer y = 328
integer width = 338
integer taborder = 50
string text = "Female"
end type

event clicked;call super::clicked;
if f_string_modified(current_patient.sex, sex) then
	current_patient.modify_patient("sex", sex)
	set_sex(current_patient.sex)
end if

end event

type sle_phone_prefix from singlelineedit within u_tabpage_patient_data
integer x = 594
integer y = 824
integer width = 224
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;
int li_rc
string ls_empty = ""
string ls_phone_prefix, ls_country_name

if text <> ls_empty then
	SELECT cpp.list_item, cc.list_item 
	INTO :ls_phone_prefix, :ls_country_name
	FROM c_list_item cc
	JOIN c_list_item cpp ON cpp.list_item_id = cc.list_item_id // the country code to match
	WHERE cpp.list_id = 'Country_Phone_Prefix'
	AND cc.list_id = 'Country'
	AND ( cpp.list_item = :text OR cpp.list_item = '+' + :text );
	
	if tf_check() and NOT IsNull(ls_phone_prefix) then 
		
		text = ls_phone_prefix
		li_rc = w_container.set_patient_list_item("Country_Phone_Prefix", ls_phone_prefix, ls_empty)
		if li_rc < 0 then
			log.log(this, "u_tabpage_patient_data.sle_phone_prefix.clicked:0022", "Error setting phone prefix", 3)
		end if

		if st_country.text = ls_empty then
			// Set country according to phone prefix selected, if not already populated
			st_country.text = ls_country_name			
			li_rc = w_container.set_patient_list_item("Country", ls_country_name, ls_empty)
			if li_rc < 0 then
				log.log(this, "u_tabpage_patient_data.sle_phone_prefix.clicked:0027", "Error setting country", 3)
			end if
		elseif st_country.text <> ls_country_name then
			// Warn user if code different
			MessageBox("Warning","Patient phone prefix is " + ls_phone_prefix + " (" + ls_country_name + ") but issuing country is " + st_country.text)
		end if
	end if
end if

end event

type st_ssn_t from statictext within u_tabpage_patient_data
integer x = 2057
integer y = 836
integer width = 151
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "SSN"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ssn from editmask within u_tabpage_patient_data
integer x = 2249
integer y = 820
integer width = 558
integer height = 108
integer taborder = 140
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "###-##-####"
end type

event modified;current_patient.ssn = text

end event

type sle_id_number from singlelineedit within u_tabpage_patient_data
integer x = 2034
integer y = 572
integer width = 768
integer height = 108
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;
integer li_rc

if f_is_empty_string(st_id_document.text) then
	openwithparm(w_pop_message, "The id document type must be selected before you may enter the document number")
end if

li_rc = w_container.set_patient_list_item("Id Document", st_id_document.text, text)
highlight_sle(this, false)
if li_rc < 0 then
	log.log(this, "u_tabpage_patient_data.st_id_number.modified:0006", "Error setting document number", 4)
end if

end event

type st_id_number_t from statictext within u_tabpage_patient_data
integer x = 1659
integer y = 588
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "ID Number"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_country_t from statictext within u_tabpage_patient_data
integer x = 105
integer y = 588
integer width = 457
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Issuing Country"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_country from statictext within u_tabpage_patient_data
integer x = 594
integer y = 576
integer width = 768
integer height = 104
integer taborder = 80
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

event clicked;
str_popup popup
str_popup_return popup_return
u_user luo_user
integer li_rc
string ls_empty = ""
string ls_country_phone_prefix

popup.dataobject = "dw_list_items_active"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "Country"
openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,u_tabpage_patient_data.st_country.clicked:15")
if popup_return.item_count <> 1 then return

text = popup_return.items[1]
highlight_st(this, false)

li_rc = w_container.set_patient_list_item("Country", popup_return.items[1], ls_empty)
if li_rc < 0 then
	log.log(this, "u_tabpage_patient_data.st_country.clicked:0020", "Error setting country", 3)
end if

// Set phone prefix according to country selected, if not already populated
SELECT cpp.list_item INTO :ls_country_phone_prefix
FROM c_list_item cc
JOIN c_list_item cpp ON cpp.list_item_id = cc.list_item_id // the country code
WHERE cpp.list_id = "Country_Phone_Prefix"
AND cc.list_id = 'Country'
AND cc.list_item = :popup_return.items[1];

if tf_check() AND NOT IsNull(ls_country_phone_prefix) then
	if ls_country_phone_prefix <> ls_empty AND sle_phone_prefix.text = ls_empty then
		sle_phone_prefix.text = ls_country_phone_prefix
		li_rc = w_container.set_patient_list_item("Country_Phone_Prefix", ls_country_phone_prefix, ls_empty)
		if li_rc < 0 then
			log.log(this, "u_tabpage_patient_data.st_country.clicked:0035", "Error setting country phone prefix", 3)
		end if
	elseif sle_phone_prefix.text <> ls_country_phone_prefix then
		// Warn user if code different
		MessageBox("Warning",popup_return.items[1] + " country code is " + ls_country_phone_prefix + " but patient phone prefix is " + sle_phone_prefix.text)
	end if
end if


end event

type st_id_document from statictext within u_tabpage_patient_data
integer x = 594
integer y = 452
integer width = 681
integer height = 104
integer taborder = 60
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

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user
integer li_rc
string ls_empty = ""

popup.dataobject = "dw_list_items_active"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "Id Document"
openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,u_tabpage_patient_data.st_id_document.clicked:13")
if popup_return.item_count <> 1 then return

li_rc = w_container.set_patient_list_item("Id Document", popup_return.items[1], ls_empty)
if li_rc < 0 then
	log.log(this, "u_tabpage_patient_data.st_id_document.clicked:0019", "Error setting document id type", 4)
end if
// Edited document type, clear out document number
sle_id_number.text = ""
text = popup_return.items[1]
highlight_st(this, false)
end event

type st_id_document_t from statictext within u_tabpage_patient_data
integer x = 133
integer y = 464
integer width = 430
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Id Document"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_sex_t from statictext within u_tabpage_patient_data
integer x = 389
integer y = 348
integer width = 174
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Sex"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_make_test from commandbutton within u_tabpage_patient_data
boolean visible = false
integer width = 462
integer height = 64
integer taborder = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Make Test Patient"
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you want to make this patient a test patient?")
popup_return = f_popup_return("w_pop_yes_no,u_tabpage_patient_data.cb_make_test.clicked:4")
if popup_return.item <> "YES" then return

openwithparm(w_pop_yes_no, "Are you ABSOLUTELY sure you want to make this patient a test patient?  THIS CANNOT BE UNDONE!")
popup_return = f_popup_return("w_pop_yes_no,u_tabpage_patient_data.cb_make_test.clicked:8")
if popup_return.item <> "YES" then return

UPDATE p_Patient
SET test_patient = 1
WHERE cpr_id = :current_patient.cpr_id;
if not tf_check() then return

current_patient.set_progress("Progress", "Progress", "Patient was converted to a Test Patient", 0)

refresh()

end event

type st_test_patient from statictext within u_tabpage_patient_data
integer x = 9
integer width = 1595
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 7191717
string text = "This is a testing/training patient and NOT a real person"
boolean focusrectangle = false
end type

type st_maiden_name_title from statictext within u_tabpage_patient_data
integer x = 160
integer y = 468
integer width = 402
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Maiden Name"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_maiden_name from singlelineedit within u_tabpage_patient_data
integer x = 594
integer y = 452
integer width = 526
integer height = 108
integer taborder = 50
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;if f_string_modified(current_patient.nickname, text) then
	current_patient.modify_patient("maiden_name", text)
	text = current_patient.maiden_name
end if

end event

type cb_clear_referring_provider from commandbutton within u_tabpage_patient_data
integer x = 1157
integer y = 1124
integer width = 165
integer height = 72
integer taborder = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;string ls_null

setnull(ls_null)

current_patient.modify_patient("referring_provider_id", ls_null)
st_referring_provider.text = ""
st_referring_provider.backcolor = color_light_grey
visible = false

end event

type st_referring_provider_title from statictext within u_tabpage_patient_data
integer x = 14
integer y = 1104
integer width = 549
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Referring Provider"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_birth_time_title from statictext within u_tabpage_patient_data
integer x = 1179
integer y = 720
integer width = 192
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Time"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_time_of_birth from statictext within u_tabpage_patient_data
integer x = 1399
integer y = 704
integer width = 581
integer height = 104
integer taborder = 110
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

event clicked;time lt_time_of_birth
string ls_text
str_popup popup
str_popup_return popup_return

popup.title = "Enter Patient's Birth Time"
popup.item = string(current_patient.time_of_birth)

openwithparm(w_pop_prompt_time, popup)
popup_return = f_popup_return("w_pop_prompt_time,u_tabpage_patient_data.st_time_of_birth.clicked:10")
if popup_return.item_count < 1 then return

lt_time_of_birth = time(popup_return.items[1])

if (lt_time_of_birth <> current_patient.time_of_birth) or isnull(current_patient.time_of_birth) then
	text = popup_return.items[1]
	current_patient.modify_patient("time_of_birth", text)
end if


end event

type sle_nickname from singlelineedit within u_tabpage_patient_data
integer x = 1618
integer y = 452
integer width = 544
integer height = 108
integer taborder = 70
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;if f_string_modified(current_patient.nickname, text) then
	current_patient.modify_patient("nickname", text)
	text = current_patient.nickname
end if

end event

type st_nickname_t from statictext within u_tabpage_patient_data
integer x = 1061
integer y = 468
integer width = 526
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Nickname"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_patient_name from statictext within u_tabpage_patient_data
integer x = 594
integer y = 208
integer width = 1573
integer height = 104
integer taborder = 20
integer textsize = -9
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

event clicked;str_patient_alias lstr_alias


if not user_list.is_user_privileged(current_scribe.user_id, "Edit Patient Details") then
	OpenWithParm(w_pop_message, "You may not correct a patient's name. Please refer to a supervisor for this. To create a new patient, use the New Patient button on the Charts tab.")
	return
end if

lstr_alias.cpr_id = current_patient.cpr_id
lstr_alias.alias_type = 'Primary'

openwithparm(w_patient_alias_edit, lstr_alias)

current_patient.load_patient()
st_patient_name.text = current_patient.name()


end event

type st_date_of_birth from statictext within u_tabpage_patient_data
integer x = 594
integer y = 704
integer width = 443
integer height = 104
integer taborder = 100
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

event clicked;date ld_date_of_birth
string ls_text

if not user_list.is_user_privileged(current_scribe.user_id, "Edit Patient Details") then
	OpenWithParm(w_pop_message, "You may not edit patient details. Please refer to a supervisor.")
	return
end if

ld_date_of_birth = current_patient.date_of_birth

ls_text = f_select_date(ld_date_of_birth, "Date of Birth")
if isnull(ls_text) then return

if (ld_date_of_birth <> current_patient.date_of_birth) or isnull(current_patient.date_of_birth) then
	current_patient.modify_patient("date_of_birth", string(ld_date_of_birth, db_date_format))
	text = string(current_patient.date_of_birth, date_format_string)
end if

st_age.text = f_pretty_age(current_patient.date_of_birth, today())
if current_patient.weeks_premature > 0 then
	st_age.text += " (" + string(current_patient.weeks_premature) + " Wks Prem)"
end if

end event

type cb_change_billing_id from commandbutton within u_tabpage_patient_data
integer x = 1417
integer y = 80
integer width = 151
integer height = 104
integer taborder = 190
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;string ls_billing_id
string ls_cpr_id
string ls_patient_status
integer li_spdw_count
string ls_patient_name

str_popup popup
str_popup_return popup_return
u_ds_data luo_sp_generate_billing_id

if not isnull(st_billing_id.text) and trim(st_billing_id.text) <> "" then
	openwithparm(w_pop_yes_no, "Are you sure you wish to change the billing id?")
	popup_return = f_popup_return("w_pop_yes_no,u_tabpage_patient_data.cb_change_billing_id.clicked:13")
	if popup_return.item <> "YES" then return
else
	openwithparm(w_pop_yes_no, "Do you wish to automatically assign the billing id?")
	popup_return = f_popup_return("w_pop_yes_no,u_tabpage_patient_data.cb_change_billing_id.clicked:17")
	if popup_return.item = "YES" then
		
		luo_sp_generate_billing_id	= CREATE u_ds_data
		luo_sp_generate_billing_id.set_dataobject("dw_sp_generate_billing_id")
		li_spdw_count = luo_sp_generate_billing_id.retrieve(current_patient.cpr_id, current_user.user_id, current_scribe.user_id)
		if li_spdw_count <= 0 then 
			setnull(ls_billing_id)
		else
			ls_billing_id = luo_sp_generate_billing_id.object.billing_id[1]
		end if
//		CWW, END
		
		current_patient.billing_id = ls_billing_id
		st_billing_id.text = ls_billing_id
		return
	end if
end if

destroy luo_sp_generate_billing_id

popup.item = st_billing_id.text
popup.title = "Enter patient billing id"
openwithparm(w_pop_prompt_string, popup)
popup_return = f_popup_return("w_pop_prompt_string,u_tabpage_patient_data.cb_change_billing_id.clicked:41")
if popup_return.item_count <> 1 then return

// Check for duplicate
ls_billing_id = popup_return.items[1]
SELECT cpr_id,
		patient_status
INTO :ls_cpr_id,
		:ls_patient_status
FROM p_Patient
WHERE billing_id = :ls_billing_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	setnull(ls_cpr_id)
end if

if not isnull(ls_cpr_id) then
	ls_patient_name = sqlca.fn_patient_full_name(ls_cpr_id)
	if isnull(ls_patient_name) or ls_patient_name = "" then ls_patient_name = "<No Name>"
	openwithparm(w_pop_message,"The billing id (" + ls_billing_id + ") is already in use by another patient record:  " + ls_patient_name + " (" + wordcap(ls_patient_status) + ")")
	return -1
end if

if f_string_modified(current_patient.billing_id, popup_return.items[1]) then
	current_patient.modify_patient("billing_id", popup_return.items[1])
	st_billing_id.text = current_patient.billing_id
end if

end event

type st_race from statictext within u_tabpage_patient_data
integer x = 1618
integer y = 332
integer width = 544
integer height = 100
integer taborder = 40
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

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "RACE"
openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,u_tabpage_patient_data.cb_race.clicked:11")
if popup_return.item_count <> 1 then return

if f_string_modified(current_patient.race, popup_return.items[1]) then
	current_patient.modify_patient("race", popup_return.items[1])
	text = current_patient.race
end if

end event

type st_race_title from statictext within u_tabpage_patient_data
integer x = 1413
integer y = 348
integer width = 174
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Race"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_patient_status from statictext within u_tabpage_patient_data
integer x = 1618
integer y = 76
integer width = 544
integer height = 104
integer taborder = 10
integer textsize = -9
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

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "PATIENT_STATUS"
openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,u_tabpage_patient_data.st_patient_status.clicked:11")
if popup_return.item_count <> 1 then return

if f_string_modified(current_patient.patient_status, popup_return.items[1]) then
	current_patient.modify_patient("patient_status", popup_return.items[1])
	text = current_patient.patient_status
end if



end event

type st_patient_status_t from statictext within u_tabpage_patient_data
integer x = 1623
integer y = 8
integer width = 549
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Patient Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_cpr_id from statictext within u_tabpage_patient_data
integer x = 2446
integer y = 1116
integer width = 375
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_primary_provider from u_st_primary_provider within u_tabpage_patient_data
integer x = 594
integer y = 956
integer taborder = 150
integer textsize = -9
long backcolor = 67108864
end type

event clicked;call super::clicked;if not isnull(user) then
	if f_string_modified(current_patient.primary_provider_id, user.user_id) then
		current_patient.modify_patient("primary_provider_id", user.user_id)
		initialize(current_patient.primary_provider_id)
	end if
end if

end event

type st_patient_name_t from statictext within u_tabpage_patient_data
integer x = 37
integer y = 224
integer width = 526
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Patient Name"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_birthdate from statictext within u_tabpage_patient_data
integer x = 288
integer y = 720
integer width = 274
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Birthdate"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_age_title from statictext within u_tabpage_patient_data
integer x = 2057
integer y = 724
integer width = 142
integer height = 68
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Age"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_billing_id_t from statictext within u_tabpage_patient_data
integer x = 261
integer y = 92
integer width = 302
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Billing ID"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_phone_num_title from statictext within u_tabpage_patient_data
integer x = 37
integer y = 840
integer width = 526
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Phone"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_phone_number from singlelineedit within u_tabpage_patient_data
integer x = 832
integer y = 824
integer width = 946
integer height = 108
integer taborder = 130
integer textsize = -9
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;if f_string_modified(current_patient.phone_number, text) then
	current_patient.modify_patient("phone_number", text)
	text = current_patient.phone_number
end if

end event

type st_primary_provider_title from statictext within u_tabpage_patient_data
integer x = 37
integer y = 972
integer width = 526
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Primary Provider"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_office from statictext within u_tabpage_patient_data
integer x = 2062
integer y = 956
integer width = 750
integer height = 104
integer taborder = 160
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

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

popup.dataobject = "dw_office_pick"
popup.datacolumn = 1
popup.displaycolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,u_tabpage_patient_data.st_office.clicked:10")
if popup_return.item_count <> 1 then return

if f_string_modified(current_patient.patient_office_id, popup_return.items[1]) then
	current_patient.modify_patient("office_id", popup_return.items[1])
end if

text = popup_return.descriptions[1]


end event

type st_office_title from statictext within u_tabpage_patient_data
integer x = 1568
integer y = 972
integer width = 462
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Primary Office"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_billing_id from statictext within u_tabpage_patient_data
integer x = 594
integer y = 76
integer width = 805
integer height = 104
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

event clicked;
OpenWithParm(w_pop_message, "The Billing Id is not editable here.")

end event

type uo_picture from u_picture_display within u_tabpage_patient_data
integer x = 2217
integer y = 72
integer width = 581
integer height = 452
boolean border = true
borderstyle borderstyle = styleraised!
end type

on uo_picture.destroy
call u_picture_display::destroy
end on

event picture_clicked;call super::picture_clicked;string ls_service

ls_service = datalist.get_preference("PREFERENCES", "portrait_service")
if isnull(ls_service) then ls_service = "PORTRAIT"

service_list.do_service(current_patient.cpr_id,current_patient.open_encounter_id,ls_service)

display_portrait()

end event

type st_portrait from statictext within u_tabpage_patient_data
integer x = 2217
integer y = 76
integer width = 581
integer height = 452
integer textsize = -12
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Portrait"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

event clicked;string ls_service

ls_service = datalist.get_preference("PREFERENCES", "portrait_service")
if isnull(ls_service) then ls_service = "PORTRAIT"

service_list.do_service(current_patient.cpr_id,current_patient.open_encounter_id,ls_service)

display_portrait()

end event

type st_age from statictext within u_tabpage_patient_data
integer x = 2249
integer y = 700
integer width = 562
integer height = 108
integer taborder = 120
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

event clicked;open(w_pop_premature)
refresh()

end event

type st_referring_provider from statictext within u_tabpage_patient_data
integer x = 594
integer y = 1088
integer width = 553
integer height = 108
integer taborder = 170
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

event clicked;str_pick_users lstr_pick_users
integer li_sts

lstr_pick_users.actor_class = "Consultant"
lstr_pick_users.specialty_id = ""
lstr_pick_users.hide_users = true

if not isnull(current_patient) then
	lstr_pick_users.cpr_id = current_patient.cpr_id
end if

lstr_pick_users.pick_screen_title = "Select Consultant"
li_sts = user_list.pick_users(lstr_pick_users)
if li_sts <= 0 then return

if f_string_modified(current_patient.referring_provider_id, lstr_pick_users.selected_users.user[1].user_id) then
	current_patient.modify_patient("referring_provider_id", lstr_pick_users.selected_users.user[1].user_id)
	text = lstr_pick_users.selected_users.user[1].user_full_name
	backcolor = lstr_pick_users.selected_users.user[1].color
	cb_clear_referring_provider.visible = true
end if




end event

