$PBExportHeader$w_edit_patient_data.srw
forward
global type w_edit_patient_data from w_window_base
end type
type sle_phone_number from singlelineedit within w_edit_patient_data
end type
type st_phone_num_title from statictext within w_edit_patient_data
end type
type st_date_of_birth from statictext within w_edit_patient_data
end type
type st_birthdate_t from statictext within w_edit_patient_data
end type
type em_ssn from editmask within w_edit_patient_data
end type
type st_ssn_t from statictext within w_edit_patient_data
end type
type sle_nickname from singlelineedit within w_edit_patient_data
end type
type st_nickname_t from statictext within w_edit_patient_data
end type
type st_race from statictext within w_edit_patient_data
end type
type st_race_title from statictext within w_edit_patient_data
end type
type st_sex_t from statictext within w_edit_patient_data
end type
type st_name_suffix_title from statictext within w_edit_patient_data
end type
type sle_name_suffix from singlelineedit within w_edit_patient_data
end type
type st_name_prefix_title from statictext within w_edit_patient_data
end type
type sle_name_prefix from singlelineedit within w_edit_patient_data
end type
type sle_middle_name from singlelineedit within w_edit_patient_data
end type
type st_middle_name_title from statictext within w_edit_patient_data
end type
type sle_first_name from singlelineedit within w_edit_patient_data
end type
type st_first_name_title from statictext within w_edit_patient_data
end type
type st_last_name_title from statictext within w_edit_patient_data
end type
type st_title from statictext within w_edit_patient_data
end type
type cb_finished from commandbutton within w_edit_patient_data
end type
type sle_last_name from singlelineedit within w_edit_patient_data
end type
type cb_cancel from commandbutton within w_edit_patient_data
end type
type st_email_t from statictext within w_edit_patient_data
end type
type sle_email_address from singlelineedit within w_edit_patient_data
end type
type st_patient_status from statictext within w_edit_patient_data
end type
type st_patient_status_t from statictext within w_edit_patient_data
end type
type sle_address_1 from singlelineedit within w_edit_patient_data
end type
type st_address1_title from statictext within w_edit_patient_data
end type
type st_state_t from statictext within w_edit_patient_data
end type
type st_zip_t from statictext within w_edit_patient_data
end type
type st_city_t from statictext within w_edit_patient_data
end type
type sle_city from singlelineedit within w_edit_patient_data
end type
type sle_zip from singlelineedit within w_edit_patient_data
end type
type sle_state from singlelineedit within w_edit_patient_data
end type
type sle_address_2 from singlelineedit within w_edit_patient_data
end type
type st_address_2_title from statictext within w_edit_patient_data
end type
type sle_maiden_name from singlelineedit within w_edit_patient_data
end type
type st_maiden_name_title from statictext within w_edit_patient_data
end type
type cbx_test_patient from checkbox within w_edit_patient_data
end type
type sle_id_number from singlelineedit within w_edit_patient_data
end type
type st_id_number_t from statictext within w_edit_patient_data
end type
type st_id_document_t from statictext within w_edit_patient_data
end type
type st_id_document from statictext within w_edit_patient_data
end type
type st_country_t from statictext within w_edit_patient_data
end type
type st_country from statictext within w_edit_patient_data
end type
type st_sex from statictext within w_edit_patient_data
end type
type sle_locality_1 from singlelineedit within w_edit_patient_data
end type
type st_locality_1_t from statictext within w_edit_patient_data
end type
type st_locality_2_t from statictext within w_edit_patient_data
end type
type sle_locality_2 from singlelineedit within w_edit_patient_data
end type
type st_locality_3_t from statictext within w_edit_patient_data
end type
type sle_locality_3 from singlelineedit within w_edit_patient_data
end type
type st_locality_4_t from statictext within w_edit_patient_data
end type
type sle_locality_4 from singlelineedit within w_edit_patient_data
end type
type st_locality_5_t from statictext within w_edit_patient_data
end type
type sle_locality_5 from singlelineedit within w_edit_patient_data
end type
type st_locality_6_t from statictext within w_edit_patient_data
end type
type sle_locality_6 from singlelineedit within w_edit_patient_data
end type
end forward

global type w_edit_patient_data from w_window_base
integer x = 649
integer y = 252
integer width = 2555
integer height = 1940
string title = "Enter Patient Data"
windowtype windowtype = response!
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
event postopen ( )
sle_phone_number sle_phone_number
st_phone_num_title st_phone_num_title
st_date_of_birth st_date_of_birth
st_birthdate_t st_birthdate_t
em_ssn em_ssn
st_ssn_t st_ssn_t
sle_nickname sle_nickname
st_nickname_t st_nickname_t
st_race st_race
st_race_title st_race_title
st_sex_t st_sex_t
st_name_suffix_title st_name_suffix_title
sle_name_suffix sle_name_suffix
st_name_prefix_title st_name_prefix_title
sle_name_prefix sle_name_prefix
sle_middle_name sle_middle_name
st_middle_name_title st_middle_name_title
sle_first_name sle_first_name
st_first_name_title st_first_name_title
st_last_name_title st_last_name_title
st_title st_title
cb_finished cb_finished
sle_last_name sle_last_name
cb_cancel cb_cancel
st_email_t st_email_t
sle_email_address sle_email_address
st_patient_status st_patient_status
st_patient_status_t st_patient_status_t
sle_address_1 sle_address_1
st_address1_title st_address1_title
st_state_t st_state_t
st_zip_t st_zip_t
st_city_t st_city_t
sle_city sle_city
sle_zip sle_zip
sle_state sle_state
sle_address_2 sle_address_2
st_address_2_title st_address_2_title
sle_maiden_name sle_maiden_name
st_maiden_name_title st_maiden_name_title
cbx_test_patient cbx_test_patient
sle_id_number sle_id_number
st_id_number_t st_id_number_t
st_id_document_t st_id_document_t
st_id_document st_id_document
st_country_t st_country_t
st_country st_country
st_sex st_sex
sle_locality_1 sle_locality_1
st_locality_1_t st_locality_1_t
st_locality_2_t st_locality_2_t
sle_locality_2 sle_locality_2
st_locality_3_t st_locality_3_t
sle_locality_3 sle_locality_3
st_locality_4_t st_locality_4_t
sle_locality_4 sle_locality_4
st_locality_5_t st_locality_5_t
sle_locality_5 sle_locality_5
st_locality_6_t st_locality_6_t
sle_locality_6 sle_locality_6
end type
global w_edit_patient_data w_edit_patient_data

type variables
str_patient new_patient
end variables

forward prototypes
public subroutine highlight_sle (singlelineedit pwo_control, boolean pb_on)
public function boolean validated ()
public subroutine highlight_st (statictext pwo_control, boolean pb_on)
public subroutine set_all_locality_visibility (boolean pb_visible)
public function integer get_patient_list_item (string ps_list_id, ref string ps_list_item, ref string ps_patient_value)
public subroutine get_localities ()
public function integer set_patient_list_item (string ps_list_id, string ps_list_item, string ps_patient_value)
end prototypes

public subroutine highlight_sle (singlelineedit pwo_control, boolean pb_on);
IF pb_on THEN
	pwo_control.backcolor = COLOR_LIGHT_YELLOW
ELSE
	IF NOT f_is_empty_string(pwo_control.text) THEN
		pwo_control.backcolor = COLOR_WHITE
	END IF
END IF
end subroutine

public function boolean validated ();boolean lb_passes = true

IF f_is_empty_string(sle_last_name.text) THEN
	highlight_sle(sle_last_name, true)
	if lb_passes then
		openwithparm(w_pop_message, "The patient's last name is required")
	end if
	lb_passes = false
ELSE
	highlight_sle(sle_last_name, false)
END IF

IF f_is_empty_string(sle_first_name.text) THEN
	highlight_sle(sle_first_name, true)
	if lb_passes then
		openwithparm(w_pop_message, "The patient's first name is required")
	end if
	lb_passes = false
ELSE
	highlight_sle(sle_first_name, false)
END IF

IF f_is_empty_string(st_sex.text) THEN
	highlight_st(st_sex, true)
	if lb_passes then
		openwithparm(w_pop_message, "The patient's gender is required")
	end if
	lb_passes = false
ELSE
	highlight_st(st_sex, false)
END IF

IF f_is_empty_string(st_date_of_birth.text) THEN
	highlight_st(st_date_of_birth, true)
	if lb_passes then
		openwithparm(w_pop_message, "The patient's birth date is required")
	end if
	lb_passes = false
ELSE
	highlight_st(st_date_of_birth, false)
END IF

IF f_is_empty_string(st_id_document.text) THEN
	highlight_st(st_id_document, true)
	if lb_passes then
		openwithparm(w_pop_message, "The id document type is required")
	end if
	lb_passes = false
ELSE
	highlight_st(st_id_document, false)
END IF

IF f_is_empty_string(sle_id_number.text) THEN
	highlight_sle(sle_id_number, true)
	if lb_passes then
		openwithparm(w_pop_message, "The id document number is required")
	end if
	lb_passes = false
ELSE
	highlight_sle(sle_id_number, false)
END IF

IF f_is_empty_string(st_country.text) THEN
	highlight_st(st_country, true)
	if lb_passes then
		openwithparm(w_pop_message, "The issuing country is required")
	end if
	lb_passes = false
ELSE
	highlight_st(st_country, false)
END IF

IF sle_locality_1.visible AND f_is_empty_string(sle_locality_1.text) THEN
	highlight_sle(sle_locality_1, true)
	if lb_passes then
		openwithparm(w_pop_message, "The " + st_locality_1_t.text + " is required")
	end if
	lb_passes = false
ELSE
	highlight_sle(sle_locality_1, false)
END IF

IF sle_locality_2.visible AND f_is_empty_string(sle_locality_2.text) THEN
	highlight_sle(sle_locality_2, true)
	if lb_passes then
		openwithparm(w_pop_message, "The " + st_locality_2_t.text + " is required")
	end if
	lb_passes = false
ELSE
	highlight_sle(sle_locality_2, false)
END IF

IF sle_locality_3.visible AND f_is_empty_string(sle_locality_3.text) THEN
	highlight_sle(sle_locality_3, true)
	if lb_passes then
		openwithparm(w_pop_message, "The " + st_locality_3_t.text + " is required")
	end if
	lb_passes = false
ELSE
	highlight_sle(sle_locality_3, false)
END IF

IF sle_locality_4.visible AND f_is_empty_string(sle_locality_4.text) THEN
	highlight_sle(sle_locality_4, true)
	if lb_passes then
		openwithparm(w_pop_message, "The " + st_locality_4_t.text + " is required")
	end if
	lb_passes = false
ELSE
	highlight_sle(sle_locality_4, false)
END IF

IF sle_locality_5.visible AND f_is_empty_string(sle_locality_5.text) THEN
	highlight_sle(sle_locality_5, true)
	if lb_passes then
		openwithparm(w_pop_message, "The " + st_locality_5_t.text + " is required")
	end if
	lb_passes = false
ELSE
	highlight_sle(sle_locality_5, false)
END IF

IF sle_locality_6.visible AND f_is_empty_string(sle_locality_6.text) THEN
	highlight_sle(sle_locality_6, true)
	if lb_passes then
		openwithparm(w_pop_message, "The " + st_locality_6_t.text + " is required")
	end if
	lb_passes = false
ELSE
	highlight_sle(sle_locality_6, false)
END IF

RETURN lb_passes

end function

public subroutine highlight_st (statictext pwo_control, boolean pb_on);
IF pb_on THEN
	pwo_control.backcolor = COLOR_LIGHT_YELLOW
ELSE
	IF NOT f_is_empty_string(pwo_control.text) THEN
		pwo_control.backcolor = COLOR_LIGHT_GREY
	END IF
END IF
end subroutine

public subroutine set_all_locality_visibility (boolean pb_visible);
st_locality_1_t.visible = pb_visible
sle_locality_1.visible = pb_visible
st_locality_2_t.visible = pb_visible
sle_locality_2.visible = pb_visible
st_locality_3_t.visible = pb_visible
sle_locality_3.visible = pb_visible
st_locality_4_t.visible = pb_visible
sle_locality_4.visible = pb_visible
st_locality_5_t.visible = pb_visible
sle_locality_5.visible = pb_visible
st_locality_6_t.visible = pb_visible
sle_locality_6.visible = pb_visible


end subroutine

public function integer get_patient_list_item (string ps_list_id, ref string ps_list_item, ref string ps_patient_value);
integer li_item, li_count
boolean lb_found

li_count = UpperBound(new_patient.list_item)
FOR li_item = 1 TO li_count
	IF new_patient.list_item[li_item].list_id = ps_list_id THEN
		IF new_patient.list_item[li_item].list_item = ps_list_item THEN
			lb_found = true
			ps_patient_value = new_patient.list_item[li_item].list_item_patient_data
		ELSEIF ps_list_item = "" THEN
			lb_found = true
			ps_list_item = new_patient.list_item[li_item].list_item
			IF new_patient.list_item[li_item].list_item_patient_data <> "" THEN
				ps_patient_value = new_patient.list_item[li_item].list_item_patient_data
			END IF
		END IF
	END IF
NEXT

IF NOT lb_found THEN
	RETURN -1
END IF

RETURN 0


end function

public subroutine get_localities ();
integer li_item_count, li_item, li_locality_count
integer li_locality_index
u_ds_data lds_selected_localities

lds_selected_localities = CREATE u_ds_data
lds_selected_localities.set_dataobject("dw_list_items_active")
li_locality_count = lds_selected_localities.retrieve("Locality")

// List items are ordered by sort_sequence, list_item
// The sort_sequence determines which one becomes Locality 1, etc.
// or, if sort_sequence hasn't been set, they appear alphabetically
// BTW the sort sequence is set in w_pick_list_members, WYSIWYG

li_item_count = UpperBound(new_patient.list_item)

FOR li_locality_index = 1 TO li_locality_count	
	CHOOSE CASE li_locality_index
		CASE 1
			st_locality_1_t.visible = true
			st_locality_1_t.text = lds_selected_localities.object.list_item[li_locality_index]
			sle_locality_1.visible = true
		CASE 2
			st_locality_2_t.visible = true
			st_locality_2_t.text = lds_selected_localities.object.list_item[li_locality_index]
			sle_locality_2.visible = true
		CASE 3
			st_locality_3_t.visible = true
			st_locality_3_t.text = lds_selected_localities.object.list_item[li_locality_index]
			sle_locality_3.visible = true
		CASE 4
			st_locality_4_t.visible = true
			st_locality_4_t.text = lds_selected_localities.object.list_item[li_locality_index]
			sle_locality_4.visible = true
		CASE 5
			st_locality_5_t.visible = true
			st_locality_5_t.text = lds_selected_localities.object.list_item[li_locality_index]
			sle_locality_5.visible = true
		CASE 6
			st_locality_6_t.visible = true
			st_locality_6_t.text = lds_selected_localities.object.list_item[li_locality_index]
			sle_locality_6.visible = true
		CASE ELSE
			log.log(this, "w_edit_patient_data.get_localities:0044", "Too many locality types", 4)
	END CHOOSE

	FOR li_item = 1 TO li_item_count
		IF new_patient.list_item[li_item].list_id = "Locality" &
				AND new_patient.list_item[li_item].list_item = lds_selected_localities.object.list_item[li_locality_index] THEN
			CHOOSE CASE li_locality_index
				CASE 1
					sle_locality_1.text = new_patient.list_item[li_item].list_item_patient_data
				CASE 2
					sle_locality_2.text = new_patient.list_item[li_item].list_item_patient_data
				CASE 3
					sle_locality_3.text = new_patient.list_item[li_item].list_item_patient_data
				CASE 4
					sle_locality_4.text = new_patient.list_item[li_item].list_item_patient_data
				CASE 5
					sle_locality_5.text = new_patient.list_item[li_item].list_item_patient_data
				CASE 6
					sle_locality_6.text = new_patient.list_item[li_item].list_item_patient_data
			END CHOOSE
		END IF
	NEXT
NEXT


end subroutine

public function integer set_patient_list_item (string ps_list_id, string ps_list_item, string ps_patient_value);
integer li_item, li_count
boolean lb_found

li_count = UpperBound(new_patient.list_item)
FOR li_item = 1 TO li_count
	IF new_patient.list_item[li_item].list_id = ps_list_id &
			AND new_patient.list_item[li_item].list_item = ps_list_item THEN
		lb_found = true
		new_patient.list_item[li_item].list_item_patient_data = ps_patient_value
	ELSEIF new_patient.list_item[li_item].list_id = ps_list_id &
			AND ps_patient_value = "" THEN
		// Must be a single-value list item, changing values
		new_patient.list_item[li_item].list_item = ps_list_item
	END IF
NEXT

IF NOT lb_found THEN
	new_patient.list_item[li_count+1].list_id = ps_list_id
	new_patient.list_item[li_count+1].list_item = ps_list_item
	new_patient.list_item[li_count+1].list_item_patient_data = ps_patient_value
END IF

RETURN 0


end function

on w_edit_patient_data.create
int iCurrent
call super::create
this.sle_phone_number=create sle_phone_number
this.st_phone_num_title=create st_phone_num_title
this.st_date_of_birth=create st_date_of_birth
this.st_birthdate_t=create st_birthdate_t
this.em_ssn=create em_ssn
this.st_ssn_t=create st_ssn_t
this.sle_nickname=create sle_nickname
this.st_nickname_t=create st_nickname_t
this.st_race=create st_race
this.st_race_title=create st_race_title
this.st_sex_t=create st_sex_t
this.st_name_suffix_title=create st_name_suffix_title
this.sle_name_suffix=create sle_name_suffix
this.st_name_prefix_title=create st_name_prefix_title
this.sle_name_prefix=create sle_name_prefix
this.sle_middle_name=create sle_middle_name
this.st_middle_name_title=create st_middle_name_title
this.sle_first_name=create sle_first_name
this.st_first_name_title=create st_first_name_title
this.st_last_name_title=create st_last_name_title
this.st_title=create st_title
this.cb_finished=create cb_finished
this.sle_last_name=create sle_last_name
this.cb_cancel=create cb_cancel
this.st_email_t=create st_email_t
this.sle_email_address=create sle_email_address
this.st_patient_status=create st_patient_status
this.st_patient_status_t=create st_patient_status_t
this.sle_address_1=create sle_address_1
this.st_address1_title=create st_address1_title
this.st_state_t=create st_state_t
this.st_zip_t=create st_zip_t
this.st_city_t=create st_city_t
this.sle_city=create sle_city
this.sle_zip=create sle_zip
this.sle_state=create sle_state
this.sle_address_2=create sle_address_2
this.st_address_2_title=create st_address_2_title
this.sle_maiden_name=create sle_maiden_name
this.st_maiden_name_title=create st_maiden_name_title
this.cbx_test_patient=create cbx_test_patient
this.sle_id_number=create sle_id_number
this.st_id_number_t=create st_id_number_t
this.st_id_document_t=create st_id_document_t
this.st_id_document=create st_id_document
this.st_country_t=create st_country_t
this.st_country=create st_country
this.st_sex=create st_sex
this.sle_locality_1=create sle_locality_1
this.st_locality_1_t=create st_locality_1_t
this.st_locality_2_t=create st_locality_2_t
this.sle_locality_2=create sle_locality_2
this.st_locality_3_t=create st_locality_3_t
this.sle_locality_3=create sle_locality_3
this.st_locality_4_t=create st_locality_4_t
this.sle_locality_4=create sle_locality_4
this.st_locality_5_t=create st_locality_5_t
this.sle_locality_5=create sle_locality_5
this.st_locality_6_t=create st_locality_6_t
this.sle_locality_6=create sle_locality_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_phone_number
this.Control[iCurrent+2]=this.st_phone_num_title
this.Control[iCurrent+3]=this.st_date_of_birth
this.Control[iCurrent+4]=this.st_birthdate_t
this.Control[iCurrent+5]=this.em_ssn
this.Control[iCurrent+6]=this.st_ssn_t
this.Control[iCurrent+7]=this.sle_nickname
this.Control[iCurrent+8]=this.st_nickname_t
this.Control[iCurrent+9]=this.st_race
this.Control[iCurrent+10]=this.st_race_title
this.Control[iCurrent+11]=this.st_sex_t
this.Control[iCurrent+12]=this.st_name_suffix_title
this.Control[iCurrent+13]=this.sle_name_suffix
this.Control[iCurrent+14]=this.st_name_prefix_title
this.Control[iCurrent+15]=this.sle_name_prefix
this.Control[iCurrent+16]=this.sle_middle_name
this.Control[iCurrent+17]=this.st_middle_name_title
this.Control[iCurrent+18]=this.sle_first_name
this.Control[iCurrent+19]=this.st_first_name_title
this.Control[iCurrent+20]=this.st_last_name_title
this.Control[iCurrent+21]=this.st_title
this.Control[iCurrent+22]=this.cb_finished
this.Control[iCurrent+23]=this.sle_last_name
this.Control[iCurrent+24]=this.cb_cancel
this.Control[iCurrent+25]=this.st_email_t
this.Control[iCurrent+26]=this.sle_email_address
this.Control[iCurrent+27]=this.st_patient_status
this.Control[iCurrent+28]=this.st_patient_status_t
this.Control[iCurrent+29]=this.sle_address_1
this.Control[iCurrent+30]=this.st_address1_title
this.Control[iCurrent+31]=this.st_state_t
this.Control[iCurrent+32]=this.st_zip_t
this.Control[iCurrent+33]=this.st_city_t
this.Control[iCurrent+34]=this.sle_city
this.Control[iCurrent+35]=this.sle_zip
this.Control[iCurrent+36]=this.sle_state
this.Control[iCurrent+37]=this.sle_address_2
this.Control[iCurrent+38]=this.st_address_2_title
this.Control[iCurrent+39]=this.sle_maiden_name
this.Control[iCurrent+40]=this.st_maiden_name_title
this.Control[iCurrent+41]=this.cbx_test_patient
this.Control[iCurrent+42]=this.sle_id_number
this.Control[iCurrent+43]=this.st_id_number_t
this.Control[iCurrent+44]=this.st_id_document_t
this.Control[iCurrent+45]=this.st_id_document
this.Control[iCurrent+46]=this.st_country_t
this.Control[iCurrent+47]=this.st_country
this.Control[iCurrent+48]=this.st_sex
this.Control[iCurrent+49]=this.sle_locality_1
this.Control[iCurrent+50]=this.st_locality_1_t
this.Control[iCurrent+51]=this.st_locality_2_t
this.Control[iCurrent+52]=this.sle_locality_2
this.Control[iCurrent+53]=this.st_locality_3_t
this.Control[iCurrent+54]=this.sle_locality_3
this.Control[iCurrent+55]=this.st_locality_4_t
this.Control[iCurrent+56]=this.sle_locality_4
this.Control[iCurrent+57]=this.st_locality_5_t
this.Control[iCurrent+58]=this.sle_locality_5
this.Control[iCurrent+59]=this.st_locality_6_t
this.Control[iCurrent+60]=this.sle_locality_6
end on

on w_edit_patient_data.destroy
call super::destroy
destroy(this.sle_phone_number)
destroy(this.st_phone_num_title)
destroy(this.st_date_of_birth)
destroy(this.st_birthdate_t)
destroy(this.em_ssn)
destroy(this.st_ssn_t)
destroy(this.sle_nickname)
destroy(this.st_nickname_t)
destroy(this.st_race)
destroy(this.st_race_title)
destroy(this.st_sex_t)
destroy(this.st_name_suffix_title)
destroy(this.sle_name_suffix)
destroy(this.st_name_prefix_title)
destroy(this.sle_name_prefix)
destroy(this.sle_middle_name)
destroy(this.st_middle_name_title)
destroy(this.sle_first_name)
destroy(this.st_first_name_title)
destroy(this.st_last_name_title)
destroy(this.st_title)
destroy(this.cb_finished)
destroy(this.sle_last_name)
destroy(this.cb_cancel)
destroy(this.st_email_t)
destroy(this.sle_email_address)
destroy(this.st_patient_status)
destroy(this.st_patient_status_t)
destroy(this.sle_address_1)
destroy(this.st_address1_title)
destroy(this.st_state_t)
destroy(this.st_zip_t)
destroy(this.st_city_t)
destroy(this.sle_city)
destroy(this.sle_zip)
destroy(this.sle_state)
destroy(this.sle_address_2)
destroy(this.st_address_2_title)
destroy(this.sle_maiden_name)
destroy(this.st_maiden_name_title)
destroy(this.cbx_test_patient)
destroy(this.sle_id_number)
destroy(this.st_id_number_t)
destroy(this.st_id_document_t)
destroy(this.st_id_document)
destroy(this.st_country_t)
destroy(this.st_country)
destroy(this.st_sex)
destroy(this.sle_locality_1)
destroy(this.st_locality_1_t)
destroy(this.st_locality_2_t)
destroy(this.sle_locality_2)
destroy(this.st_locality_3_t)
destroy(this.sle_locality_3)
destroy(this.st_locality_4_t)
destroy(this.sle_locality_4)
destroy(this.st_locality_5_t)
destroy(this.sle_locality_5)
destroy(this.st_locality_6_t)
destroy(this.sle_locality_6)
end on

event open;str_popup popup
string ls_empty = ""

popup = message.powerobjectparm

st_title.text = popup.title
new_patient = popup.objectparm

cbx_test_patient.visible = popup.multiselect

sle_address_1.text = new_patient.address_line_1
sle_email_address.text = new_patient.email_address
sle_first_name.text = new_patient.first_name
sle_last_name.text = new_patient.last_name
sle_middle_name.text = new_patient.middle_name
sle_name_prefix.text = new_patient.name_prefix
sle_phone_number.text = new_patient.phone_number
st_sex.text = new_patient.sex
st_date_of_birth.text = string(new_patient.date_of_birth)
st_patient_status.text = new_patient.patient_status

cbx_test_patient.checked = new_patient.test_patient

// Avoid Americanisms 
if NOT IsNull(gnv_app.locale) AND gnv_app.locale = "en_us" then
	// Hmmm, ssn never WAS populated
	sle_name_suffix.text = new_patient.name_suffix
	sle_nickname.text = new_patient.nickname
	sle_maiden_name.text = new_patient.maiden_name
	sle_state.text = new_patient.state
	sle_address_2.text = new_patient.address_line_2
	sle_city.text = new_patient.city
	sle_zip.text = new_patient.zip
	st_race.text = new_patient.race
	
	st_id_document.visible = false
	sle_id_number.visible = false
	st_country.visible = false
	st_id_document_t.visible = false
	st_id_number_t.visible = false
	st_country_t.visible = false
	set_all_locality_visibility(false)
	
else
	// some day may have a case statement for locale?
	// Hide the U.S. fields
	em_ssn.visible = false
	sle_name_suffix.visible = false
	sle_nickname.visible = false
	sle_maiden_name.visible = false
	sle_address_2.visible = false
	sle_city.visible = false
	sle_state.visible = false
	sle_zip.visible = false
	st_race.visible = false
	
	st_ssn_t.visible = false
	st_name_suffix_title.visible = false
	st_nickname_t.visible = false
	st_maiden_name_title.visible = false
	st_address_2_title.visible = false
	st_city_t.visible = false
	st_state_t.visible = false
	st_zip_t.visible = false
	st_race_title.visible = false

	st_id_document.text = ""
	sle_id_number.text = ""
	get_patient_list_item("Id Document", st_id_document.text, sle_id_number.text)
	st_country.text = ""
	get_patient_list_item("Country", st_country.text, ls_empty)
	get_localities()
end if
center_popup()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_edit_patient_data
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_edit_patient_data
integer x = 18
integer y = 1492
end type

type sle_phone_number from singlelineedit within w_edit_patient_data
integer x = 1687
integer y = 392
integer width = 768
integer height = 108
integer taborder = 100
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.phone_number = sqlca.fn_pretty_phone(text)
text = new_patient.phone_number

end event

type st_phone_num_title from statictext within w_edit_patient_data
integer x = 1426
integer y = 408
integer width = 229
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Phone"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_date_of_birth from statictext within w_edit_patient_data
integer x = 1687
integer y = 268
integer width = 443
integer height = 104
integer taborder = 90
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

ld_date_of_birth = new_patient.date_of_birth

ls_text = f_select_date(ld_date_of_birth, "Date of Birth")
if isnull(ls_text) then return

new_patient.date_of_birth = date(ls_text)
text = ls_text
highlight_st(this, false)
end event

type st_birthdate_t from statictext within w_edit_patient_data
integer x = 1381
integer y = 280
integer width = 274
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Birthdate"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ssn from editmask within w_edit_patient_data
integer x = 1687
integer y = 776
integer width = 402
integer height = 108
integer taborder = 130
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

event modified;new_patient.ssn = text

end event

type st_ssn_t from statictext within w_edit_patient_data
integer x = 1504
integer y = 792
integer width = 151
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "SSN"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nickname from singlelineedit within w_edit_patient_data
integer x = 539
integer y = 776
integer width = 768
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.nickname = text

end event

type st_nickname_t from statictext within w_edit_patient_data
integer x = 210
integer y = 792
integer width = 306
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Nickname"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_race from statictext within w_edit_patient_data
integer x = 1687
integer y = 648
integer width = 530
integer height = 104
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

event clicked;str_popup popup
str_popup_return popup_return
u_user luo_user

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "RACE"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

new_patient.race = popup_return.items[1]
text = new_patient.race
highlight_st(this, false)
end event

type st_race_title from statictext within w_edit_patient_data
integer x = 1481
integer y = 664
integer width = 174
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Race"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_sex_t from statictext within w_edit_patient_data
integer x = 1486
integer y = 156
integer width = 174
integer height = 72
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Sex"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_name_suffix_title from statictext within w_edit_patient_data
integer x = 110
integer y = 664
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Name Suffix"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_name_suffix from singlelineedit within w_edit_patient_data
integer x = 539
integer y = 648
integer width = 768
integer height = 108
integer taborder = 50
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

event modified;new_patient.name_suffix = text

end event

type st_name_prefix_title from statictext within w_edit_patient_data
integer x = 110
integer y = 156
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Name Prefix"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_name_prefix from singlelineedit within w_edit_patient_data
integer x = 539
integer y = 140
integer width = 768
integer height = 108
integer taborder = 10
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

event modified;new_patient.name_prefix = text

end event

type sle_middle_name from singlelineedit within w_edit_patient_data
integer x = 539
integer y = 520
integer width = 768
integer height = 108
integer taborder = 40
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

event modified;new_patient.middle_name = text

end event

type st_middle_name_title from statictext within w_edit_patient_data
integer x = 101
integer y = 536
integer width = 416
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Middle Name"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_first_name from singlelineedit within w_edit_patient_data
integer x = 539
integer y = 392
integer width = 768
integer height = 108
integer taborder = 30
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

event modified;new_patient.first_name = text
highlight_sle(this, false)
end event

type st_first_name_title from statictext within w_edit_patient_data
integer x = 110
integer y = 408
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "First Name"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_last_name_title from statictext within w_edit_patient_data
integer x = 110
integer y = 280
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Last Name"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_edit_patient_data
integer width = 2546
integer height = 120
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "New Patient"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_finished from commandbutton within w_edit_patient_data
integer x = 1934
integer y = 1664
integer width = 517
integer height = 112
integer taborder = 290
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;
// Validate id number was supplied if document type was chosen
IF not validated() THEN
	beep(1)
	return -1
END IF

str_popup_return popup_return

popup_return.item = "OK"
popup_return.objectparm2 = new_patient

closewithreturn(parent, popup_return)

end event

type sle_last_name from singlelineedit within w_edit_patient_data
integer x = 539
integer y = 264
integer width = 768
integer height = 108
integer taborder = 20
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

event modified;new_patient.last_name = text
highlight_sle(this, false)
end event

type cb_cancel from commandbutton within w_edit_patient_data
integer x = 50
integer y = 1664
integer width = 402
integer height = 112
integer taborder = 300
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

popup_return.item = "CANCEL"

closewithreturn(parent, popup_return)

end event

type st_email_t from statictext within w_edit_patient_data
integer x = 1426
integer y = 536
integer width = 229
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Email"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_email_address from singlelineedit within w_edit_patient_data
integer x = 1687
integer y = 520
integer width = 768
integer height = 108
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.email_address = text

end event

type st_patient_status from statictext within w_edit_patient_data
integer x = 1070
integer y = 1548
integer width = 549
integer height = 104
integer taborder = 280
boolean bringtotop = true
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
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

new_patient.patient_status = popup_return.items[1]
text = new_patient.patient_status

end event

type st_patient_status_t from statictext within w_edit_patient_data
integer x = 608
integer y = 1556
integer width = 416
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Patient Status"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_address_1 from singlelineedit within w_edit_patient_data
integer x = 535
integer y = 1052
integer width = 1911
integer height = 108
integer taborder = 170
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.address_line_1 = text

end event

type st_address1_title from statictext within w_edit_patient_data
integer x = 160
integer y = 1068
integer width = 352
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Address 1"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_state_t from statictext within w_edit_patient_data
integer x = 1184
integer y = 1320
integer width = 174
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "State"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_zip_t from statictext within w_edit_patient_data
integer x = 1550
integer y = 1316
integer width = 137
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Zip"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_city_t from statictext within w_edit_patient_data
integer x = 338
integer y = 1320
integer width = 174
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "City"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_city from singlelineedit within w_edit_patient_data
integer x = 535
integer y = 1304
integer width = 608
integer height = 104
integer taborder = 190
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;text = left(text,40)
new_patient.city = text

end event

type sle_zip from singlelineedit within w_edit_patient_data
integer x = 1705
integer y = 1300
integer width = 352
integer height = 104
integer taborder = 210
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

event modified;text = left(text,10)
new_patient.zip = text

end event

type sle_state from singlelineedit within w_edit_patient_data
integer x = 1371
integer y = 1304
integer width = 169
integer height = 104
integer taborder = 200
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;text = left(text,2)

new_patient.state = text

end event

type sle_address_2 from singlelineedit within w_edit_patient_data
integer x = 535
integer y = 1172
integer width = 955
integer height = 108
integer taborder = 180
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.address_line_2 = text

end event

type st_address_2_title from statictext within w_edit_patient_data
integer x = 160
integer y = 1188
integer width = 352
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Address 2"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_maiden_name from singlelineedit within w_edit_patient_data
integer x = 539
integer y = 904
integer width = 768
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;new_patient.maiden_name = text

end event

type st_maiden_name_title from statictext within w_edit_patient_data
integer x = 64
integer y = 916
integer width = 453
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Maiden Name"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_test_patient from checkbox within w_edit_patient_data
integer x = 567
integer y = 1680
integer width = 1253
integer height = 80
integer taborder = 310
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "This is a test patient and NOT a real person"
end type

event clicked;new_patient.test_patient = checked

end event

type sle_id_number from singlelineedit within w_edit_patient_data
integer x = 1687
integer y = 712
integer width = 768
integer height = 108
integer taborder = 160
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

li_rc = set_patient_list_item("Id Document", st_id_document.text, text)
highlight_sle(this, false)
if li_rc < 0 then
	log.log(this, "w_edit_patient_data.st_id_number.modified:0006", "Error setting document number", 4)
end if

end event

type st_id_number_t from statictext within w_edit_patient_data
integer x = 1321
integer y = 728
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
long backcolor = 33538240
boolean enabled = false
string text = "ID Number"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_id_document_t from statictext within w_edit_patient_data
integer x = 91
integer y = 724
integer width = 430
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Id Document"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_id_document from statictext within w_edit_patient_data
integer x = 544
integer y = 712
integer width = 768
integer height = 104
integer taborder = 140
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
popup.datacolumn = 3
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "Id Document"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

li_rc = set_patient_list_item("Id Document", popup_return.items[1], ls_empty)
if li_rc < 0 then
	log.log(this, "w_edit_patient_data.st_id_document.clicked:0019", "Error setting document id type", 4)
end if
// Edited document type, clear out document number
sle_id_number.text = ""
text = popup_return.items[1]
highlight_st(this, false)
end event

type st_country_t from statictext within w_edit_patient_data
integer x = 73
integer y = 868
integer width = 457
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Issuing Country"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_country from statictext within w_edit_patient_data
integer x = 544
integer y = 848
integer width = 768
integer height = 104
integer taborder = 150
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

popup.dataobject = "dw_list_items_active"
popup.datacolumn = 3
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "Country"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

li_rc = set_patient_list_item("Country", popup_return.items[1], ls_empty)
if li_rc < 0 then
	log.log(this, "w_edit_patient_data.st_country.clicked:0019", "Error setting country", 4)
end if
text = popup_return.items[1]
highlight_st(this, false)

end event

type st_sex from statictext within w_edit_patient_data
integer x = 1687
integer y = 144
integer width = 443
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
if text = "Male" then
	text = "Female"
	new_patient.sex = "F"
else
	text = "Male"
	new_patient.sex = "M"
end if
highlight_st(this, false)
end event

type sle_locality_1 from singlelineedit within w_edit_patient_data
integer x = 535
integer y = 1172
integer width = 768
integer height = 104
integer taborder = 220
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
set_patient_list_item("Locality", st_locality_1_t.text, text)
highlight_sle(this, false)

end event

type st_locality_1_t from statictext within w_edit_patient_data
integer x = 192
integer y = 1188
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Locality 1"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_locality_2_t from statictext within w_edit_patient_data
integer x = 1330
integer y = 1188
integer width = 325
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Locality 2"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_locality_2 from singlelineedit within w_edit_patient_data
integer x = 1673
integer y = 1172
integer width = 768
integer height = 104
integer taborder = 230
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
set_patient_list_item("Locality", st_locality_2_t.text, text)
highlight_sle(this, false)

end event

type st_locality_3_t from statictext within w_edit_patient_data
integer x = 192
integer y = 1308
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Locality 3"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_locality_3 from singlelineedit within w_edit_patient_data
integer x = 535
integer y = 1292
integer width = 768
integer height = 104
integer taborder = 240
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
set_patient_list_item("Locality", st_locality_3_t.text, text)
highlight_sle(this, false)

end event

type st_locality_4_t from statictext within w_edit_patient_data
integer x = 1330
integer y = 1308
integer width = 325
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Locality 4"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_locality_4 from singlelineedit within w_edit_patient_data
integer x = 1673
integer y = 1292
integer width = 768
integer height = 104
integer taborder = 250
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
set_patient_list_item("Locality", st_locality_4_t.text, text)
highlight_sle(this, false)

end event

type st_locality_5_t from statictext within w_edit_patient_data
integer x = 192
integer y = 1428
integer width = 320
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Locality 5"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_locality_5 from singlelineedit within w_edit_patient_data
integer x = 535
integer y = 1412
integer width = 768
integer height = 104
integer taborder = 260
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
set_patient_list_item("Locality", st_locality_5_t.text, text)
highlight_sle(this, false)

end event

type st_locality_6_t from statictext within w_edit_patient_data
integer x = 1330
integer y = 1428
integer width = 325
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Locality 6"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_locality_6 from singlelineedit within w_edit_patient_data
integer x = 1673
integer y = 1412
integer width = 768
integer height = 104
integer taborder = 270
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
set_patient_list_item("Locality", st_locality_6_t.text, text)
highlight_sle(this, false)

end event

