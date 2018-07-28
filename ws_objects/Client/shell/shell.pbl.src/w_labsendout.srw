$PBExportHeader$w_labsendout.srw
forward
global type w_labsendout from window
end type
type cb_find_patient from commandbutton within w_labsendout
end type
type st_billto from statictext within w_labsendout
end type
type em_date_of_birth from editmask within w_labsendout
end type
type st_birthdate from statictext within w_labsendout
end type
type st_laboratory from u_st_primary_provider within w_labsendout
end type
type st_middle_name from statictext within w_labsendout
end type
type st_first_name from statictext within w_labsendout
end type
type st_last_name from statictext within w_labsendout
end type
type st_billing_id from statictext within w_labsendout
end type
type uo_cb_yn from u_cb_yn_toggle within w_labsendout
end type
type sle_groupname from singlelineedit within w_labsendout
end type
type sle_groupnumber from singlelineedit within w_labsendout
end type
type sle_policy from singlelineedit within w_labsendout
end type
type st_workmen_title from statictext within w_labsendout
end type
type st_groupname_title from statictext within w_labsendout
end type
type st_groupnumber_title from statictext within w_labsendout
end type
type st_policy_title from statictext within w_labsendout
end type
type sle_i_address2 from singlelineedit within w_labsendout
end type
type st_i_address2_title from statictext within w_labsendout
end type
type sle_i_zip from singlelineedit within w_labsendout
end type
type st_i_zip_title from statictext within w_labsendout
end type
type sle_i_state from singlelineedit within w_labsendout
end type
type st_i_state_title from statictext within w_labsendout
end type
type sle_i_city from singlelineedit within w_labsendout
end type
type st_i_city_title from statictext within w_labsendout
end type
type sle_i_address1 from singlelineedit within w_labsendout
end type
type st_i_address1_title from statictext within w_labsendout
end type
type st_g_zip_title from statictext within w_labsendout
end type
type st_g_state_title from statictext within w_labsendout
end type
type st_g_city_title from statictext within w_labsendout
end type
type st_g_address_title from statictext within w_labsendout
end type
type sle_g_zip from singlelineedit within w_labsendout
end type
type sle_g_city from singlelineedit within w_labsendout
end type
type sle_g_state from singlelineedit within w_labsendout
end type
type sle_g_address from singlelineedit within w_labsendout
end type
type st_g_phone_num_title from statictext within w_labsendout
end type
type sle_g_phone_number from singlelineedit within w_labsendout
end type
type sle_g_middle_name from singlelineedit within w_labsendout
end type
type sle_g_first_name from singlelineedit within w_labsendout
end type
type st_3a from statictext within w_labsendout
end type
type sle_g_last_name from singlelineedit within w_labsendout
end type
type st_g_name_title from statictext within w_labsendout
end type
type st_guarantor from u_st_primary_provider within w_labsendout
end type
type st_guarantor_title from statictext within w_labsendout
end type
type st_billto_title from statictext within w_labsendout
end type
type st_laboratory_title from statictext within w_labsendout
end type
type st_insurance_carrier from u_st_primary_provider within w_labsendout
end type
type st_carrier_title from statictext within w_labsendout
end type
type st_sex from statictext within w_labsendout
end type
type sle_phone_number from singlelineedit within w_labsendout
end type
type st_phone_num_title from statictext within w_labsendout
end type
type st_5 from statictext within w_labsendout
end type
type sle_age from singlelineedit within w_labsendout
end type
type st_age from statictext within w_labsendout
end type
type st_4 from statictext within w_labsendout
end type
type st_3 from statictext within w_labsendout
end type
type pb_cancel from u_picture_button within w_labsendout
end type
type st_cpr_id from statictext within w_labsendout
end type
type pb_ok from u_picture_button within w_labsendout
end type
type ln_1 from line within w_labsendout
end type
type ln_3 from line within w_labsendout
end type
type sle_workmen from singlelineedit within w_labsendout
end type
type uo_cb_sex from u_cb_sex_toggle within w_labsendout
end type
end forward

global type w_labsendout from window
integer width = 2967
integer height = 1832
boolean titlebar = true
string title = "Laboratory Send Out"
windowtype windowtype = response!
long backcolor = 33538240
cb_find_patient cb_find_patient
st_billto st_billto
em_date_of_birth em_date_of_birth
st_birthdate st_birthdate
st_laboratory st_laboratory
st_middle_name st_middle_name
st_first_name st_first_name
st_last_name st_last_name
st_billing_id st_billing_id
uo_cb_yn uo_cb_yn
sle_groupname sle_groupname
sle_groupnumber sle_groupnumber
sle_policy sle_policy
st_workmen_title st_workmen_title
st_groupname_title st_groupname_title
st_groupnumber_title st_groupnumber_title
st_policy_title st_policy_title
sle_i_address2 sle_i_address2
st_i_address2_title st_i_address2_title
sle_i_zip sle_i_zip
st_i_zip_title st_i_zip_title
sle_i_state sle_i_state
st_i_state_title st_i_state_title
sle_i_city sle_i_city
st_i_city_title st_i_city_title
sle_i_address1 sle_i_address1
st_i_address1_title st_i_address1_title
st_g_zip_title st_g_zip_title
st_g_state_title st_g_state_title
st_g_city_title st_g_city_title
st_g_address_title st_g_address_title
sle_g_zip sle_g_zip
sle_g_city sle_g_city
sle_g_state sle_g_state
sle_g_address sle_g_address
st_g_phone_num_title st_g_phone_num_title
sle_g_phone_number sle_g_phone_number
sle_g_middle_name sle_g_middle_name
sle_g_first_name sle_g_first_name
st_3a st_3a
sle_g_last_name sle_g_last_name
st_g_name_title st_g_name_title
st_guarantor st_guarantor
st_guarantor_title st_guarantor_title
st_billto_title st_billto_title
st_laboratory_title st_laboratory_title
st_insurance_carrier st_insurance_carrier
st_carrier_title st_carrier_title
st_sex st_sex
sle_phone_number sle_phone_number
st_phone_num_title st_phone_num_title
st_5 st_5
sle_age sle_age
st_age st_age
st_4 st_4
st_3 st_3
pb_cancel pb_cancel
st_cpr_id st_cpr_id
pb_ok pb_ok
ln_1 ln_1
ln_3 ln_3
sle_workmen sle_workmen
uo_cb_sex uo_cb_sex
end type
global w_labsendout w_labsendout

type variables
string encounter_type = ""
string new_flag = ""

datetime encounter_date

integer top_rb_x = 1779
integer top_rb_y = 633
integer rb_gap = 175

boolean query_mode
boolean new_guarantor
string sex

string attending_doctor
string insurance_id
string cpr_id
string guarantor_cpr_id
string patient_office_id

string lab_id
string bill_to
str_popup 	popup
str_popup_return popup_return
str_lists  	lablist
str_lists	payorlist
str_lists	guarantorlist
//u_str_encounter encounter


end variables

forward prototypes
public subroutine pop_payor ()
public subroutine gen_payor ()
public subroutine gen_lab ()
public subroutine pop_lab ()
public function integer verify_complete ()
public subroutine pop_guarantor ()
public subroutine refresh_ins ()
public subroutine gen_guar_relation ()
public subroutine show_patient (string ps_cpr_id)
public subroutine show_guarantor ()
end prototypes

public subroutine pop_payor ();integer i
popup.data_row_count = payorlist.row_count

for i = 1 to popup.data_row_count
		popup.items[i] = payorlist.items[i]
Next	

popup.use_background_color  = false

OpenWithParm(W_POP_PICK,popup)

popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

for i = 1 to popup.data_row_count
	if popup_return.items[1] = payorlist.items[i] then
		bill_to = payorlist.item_codes[i]
		st_billto.text = popup_return.items[i]
		exit
	end if	
Next	

refresh_ins()
return
end subroutine

public subroutine gen_payor ();string ls_payor

ls_payor = datalist.get_preference("TREATMENT", "default_lab_payor")

if isnull(ls_payor) then
	st_billto.text = "Patient"
	bill_to = "P"
else
	st_billto.text = ls_payor
end if

integer i
i = 1
payorlist.item_codes[i] =  'C'
payorlist.items[i] = 'Clinic'
i += 1
payorlist.item_codes[i] =  'P'
payorlist.items[i] = 'Patient'
i += 1
payorlist.item_codes[i] =  'T1'
payorlist.items[i] = 'Medicare'	
i += 1
payorlist.item_codes[i] =  'T2'
payorlist.items[i] = 'Medicaid'
i += 1
payorlist.item_codes[i] =  'T3'
payorlist.items[i] = 'Private Insurance'
i += 1
payorlist.item_codes[i] =  'T3'
payorlist.items[i] = 'StandardPOS'
for i = 1 to 5
	if payorlist.items[i] = ls_payor then
		bill_to = payorlist.item_codes[i]
	end if
next
return
end subroutine

public subroutine gen_lab ();integer i
string ls_labid, ls_labdesc
boolean lab_read

//there are two components to the item (code and description) 
//the description follows the code 
 DECLARE lab_cursor CURSOR FOR  
  SELECT c_Lab.lab_id,   
         c_Lab.lab_name  
    FROM c_Lab;

Open lab_cursor;
if not tf_check() then return 

i = 1

lablist.item_codes[i] =  'Other'
lablist.items[i] = 'Other'
Do 
	Fetch lab_cursor into
		:ls_labid,
		:ls_labdesc;
	if not tf_check() then return 
	if sqlca.sqlcode = 0 then
		i += 1
		lablist.item_codes[i] =  ls_labid
		lablist.items[i] = ls_labdesc
	else
		lab_read = false
	end if
LOOP WHILE lab_read
	
lablist.row_count = i

Close lab_cursor;

if lablist.row_count > 0 then
	st_laboratory.text = lablist.items[1]
	lab_id = lablist.item_codes[1]
end if

return
end subroutine

public subroutine pop_lab ();integer i
popup.data_row_count = lablist.row_count

for i = 1 to popup.data_row_count
		popup.items[i] = lablist.items[i]
Next	

popup.use_background_color  = false

OpenWithParm(W_POP_PICK,popup)

popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

for i = 1 to popup.data_row_count
	if popup_return.items[1] = lablist.items[i] then
		lab_id = lablist.item_codes[i]
		exit
	end if	
Next	

st_laboratory.text = popup_return.items[1]
return
end subroutine

public function integer verify_complete ();datetime ldt_now
date ld_date_of_birth
datetime ldt_date_of_birth
datetime ldt_last_update
string ls_string, ls_date
string ls_cpr_id
string ls_sex
string ls_first_name
string ls_last_name
string ls_middle_name
string ls_degree
string ls_name_prefix
string ls_name_suffix
string ls_primary_language
string ls_marital_status
string ls_race
string ls_payor_flag
string ls_phone_number
string ls_primary_provider_id
string ls_secondary_provider_id
string ls_billing_id
string ls_workmencomp
long ll_patient_id
integer li_sts,li_priority

if not isdate(em_date_of_birth.text) then
	openwithparm(w_pop_message, "You must enter a valid date of birth")
	return -1
end if

if (left(bill_to,1) = "T") then 
	if isnull(insurance_id) then
		openwithparm(w_pop_message, "You must enter a valid insurance carrier")
		return -1
	end if
end if

ld_date_of_birth = date(em_date_of_birth.text)
ls_sex = uo_cb_sex.sex
ls_phone_number = sle_phone_number.text

UPDATE p_Patient
	SET	date_of_birth = :ld_date_of_birth,
			sex = :ls_sex,
			phone_number = :ls_phone_number
	WHERE cpr_id = :cpr_id;
	if not tf_check() then return -1

ls_workmencomp = uo_cb_yn.get_yn()
if isnull(ls_workmencomp) or ls_workmencomp = '' then ls_workmencomp = 'N'
if (bill_to = 'C' or st_laboratory.text = 'Other') then 
	ls_payor_flag = 'N'
else
	ls_payor_flag = 'Y'
end if	

ls_last_name = sle_g_last_name.text
ls_first_name = sle_g_first_name.text
ls_middle_name = sle_g_middle_name.text
ls_phone_number = sle_g_phone_number.text

setnull(ld_date_of_birth)
setnull(ls_race)
setnull(ls_sex)
setnull(ls_name_prefix)
setnull(ls_name_suffix)
setnull(ls_degree)
setnull(ls_primary_provider_id)

if new_guarantor then
	ls_cpr_id = ls_billing_id + '.1'
//	li_sts = f_create_new_patient( &
//									ls_cpr_id,   &
//									ls_race,   &
//									ld_date_of_birth,   &
//									ls_sex,   &
//									ls_phone_number, &
//									ls_primary_language,   &
//									ls_marital_status,   &
//									ls_billing_id,   &
//									ll_patient_id,   &
//									ls_first_name,   &
//									ls_last_name,   &
//									ls_degree,   &
//									ls_name_prefix,   &
//									ls_middle_name,   &
//									ls_name_suffix,   &
//									ls_primary_provider_id, &
//									ls_secondary_provider_id, &
//									li_priority &
//									)
		else	
		UPDATE p_Patient
		SET	last_name = :ls_last_name,
				first_name = :ls_first_name,
				middle_name = :ls_middle_name,
				phone_number = :ls_phone_number,
				address = :sle_g_address.text,
				city = :sle_g_city.text,
				state = :sle_g_state.text,
				zip = :sle_g_zip.text
		WHERE cpr_id = :guarantor_cpr_id;
		if not tf_check() then return -1
end if	

if not isnull(insurance_id) then
		
	  UPDATE c_Authority  
     SET address1 = :sle_i_address1.text,   
         address2 = :sle_i_address2.text,   
         city = :sle_i_city.text,   
         state = :sle_i_state.text,   
         zip = :sle_i_zip.text  
   WHERE ( c_Authority.authority_id = :insurance_id ) AND  
         ( c_Authority.authority_type = 'PAYOR' )   
           ;
	if not tf_check() then return -1
	
	UPDATE p_Patient_Authority
	SET ins_groupnumber = :sle_groupnumber.text,
		ins_groupname = :sle_groupname.text,
		ins_policy = :sle_policy.text,
		ins_workmencomp = :sle_workmen.text
	WHERE cpr_id = :guarantor_cpr_id
	AND authority_id = :insurance_id
	AND authority_sequence = 1;
	if not tf_check() then return -1
	if sqlca.sqlcode <> 0 then
		INSERT INTO p_Patient_Authority (
		cpr_id,
		authority_type,		
		authority_sequence,
		authority_id,
		notes,
		created,
		created_by,
		modified_by,
		ins_groupnumber,
		ins_groupname,
		ins_policy,
		ins_workmencomp,
		lab_id)
		VALUES (
		:guarantor_cpr_id,
		'PAYOR',
		1,
		:insurance_id,
		null,
		:ldt_now,
		:current_scribe.user_id,
		:current_scribe.user_id,
		:sle_groupnumber.text,
		:sle_groupname.text,
		:sle_policy.text,
		:ls_workmencomp,
		:lab_id);
		if not tf_check() then return -1
	end if
end if

Update p_Patient_Relation
Set relation_link = :st_guarantor.text,
	 guarantor_flag = :ls_payor_flag,
	 payor_flag = :st_billto.text
	 where cpr_id = :cpr_id
	 	 and relation_cpr_id = :ls_cpr_id;
if not tf_check() then return  -1

if sqlca.sqlcode <> 0 then
	INSERT into p_Patient_Relation(
		cpr_id,
		relation_cpr_id,
		relation_link,
		guarantor_flag,
		payor_flag)
		VALUES(
		:cpr_id,
		:guarantor_cpr_id,
		:st_guarantor.text,
		:ls_payor_flag,
		:st_billto.text);
	if not tf_check() then return -1
end if	

return 1


end function

public subroutine pop_guarantor ();integer i
popup.data_row_count = guarantorlist.row_count

for i = 1 to popup.data_row_count
		popup.items[i] = guarantorlist.items[i]
Next	

popup.use_background_color  = false

OpenWithParm(W_POP_PICK,popup)

popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

for i = 1 to popup.data_row_count
	if popup_return.items[1] = guarantorlist.items[i] then
		st_guarantor.text = guarantorlist.items[i]
		exit
	end if	
Next	
return
end subroutine

public subroutine refresh_ins ();string ins_category
string ls_workmencomp
string ls_lab_id
integer i
ls_workmencomp = 'N'
CHOOSE CASE bill_to
	CASE  'Medicaid'
		ins_category = 'Medicaid'
	CASE 	'Medicare'
		ins_category = 'Medicare'
	CASE  'Private Insurance'
		ins_category = 'StandardPOS'
	CASE ELSE
		sle_groupnumber.text = '' 
      sle_groupname.text = '' 
      sle_policy.text = '' 
      sle_i_address1.text = '' 
      sle_i_address2.text = '' 
      sle_i_city.text = ''
      sle_i_state.text = ''
		st_insurance_carrier.text = ''  
      setnull(insurance_id) 
		return
END CHOOSE

 SELECT p_Patient_Authority.ins_groupnumber,   
         p_Patient_Authority.ins_groupname,   
         p_Patient_Authority.ins_policy,   
         p_Patient_Authority.ins_workmencomp,  
			p_Patient_Authority.lab_id, 
         c_Authority.address1,   
         c_Authority.address2,   
         c_Authority.city,   
         c_Authority.state,   
         c_Authority.zip,
			c_Authority.authority_id,
         c_Authority.name  
    INTO :sle_groupnumber.text,   
         :sle_groupname.text,   
         :sle_policy.text,   
         :ls_workmencomp, 
			:ls_lab_id,
         :sle_i_address1.text,   
         :sle_i_address2.text,   
         :sle_i_city.text,   
         :sle_i_state.text, 
			:insurance_id,
         :st_insurance_carrier.text   
     FROM c_Authority,   
         p_Patient_Authority  
   WHERE ( c_Authority.authority_id = p_Patient_Authority.authority_id ) and  
         ( p_Patient_Authority.authority_type = c_Authority.authority_type ) and  
         ( ( p_Patient_Authority.cpr_id = :guarantor_cpr_id ) AND  
         ( p_Patient_Authority.authority_sequence = 1 ) AND  
         ( c_Authority.status = 'OK' ) )   ;
if not tf_check() then return

uo_cb_yn.set_yn(ls_workmencomp)

if lablist.row_count > 0 then
	for i = 1 to lablist.row_count
		if lablist.item_codes[i] = ls_lab_id then
			st_laboratory.text = lablist.items[i]
			lab_id = ls_lab_id
			exit
		end if
	next	
end if

for i = 1 to payorlist.row_count
	if payorlist.item_codes[i] = bill_to then
		st_billto.text = popup_return.items[i]
		exit
	end if	
Next	
return
end subroutine

public subroutine gen_guar_relation ();integer i
//'1' = Self,2 = Spouse,'3' = Child,'4' = Other
i = 1
guarantorlist.item_codes[i] =  '1'
guarantorlist.items[i] = 'Self'
i += 1
guarantorlist.item_codes[i] =  '2'
guarantorlist.items[i] = 'Spouse'
i += 1
guarantorlist.item_codes[i] =  '3'
guarantorlist.items[i] = 'Child'	
i += 1
guarantorlist.item_codes[i] =  '4'
guarantorlist.items[i] = 'Other'

st_guarantor.text = 'Self'

return
end subroutine

public subroutine show_patient (string ps_cpr_id);integer li_sts, li_count
date ld_date_of_birth
string ls_primary_provider_id
string ls_secondary_provider_id
string ls_type
string ls_sex
string ls_phone_number
string ls_relation_link
string ls_payor_flag
string ls_authority_id
string ls_billto
st_cpr_id.visible = false
u_user luo_user
integer i
boolean lb_found
cpr_id = ps_cpr_id
//li_sts = tf_get_patient(ps_cpr_id, &
//								st_last_name.text, &
//								st_first_name.text, &
//								st_middle_name.text, &
//								ld_date_of_birth, &
//								st_billing_id.text, &
//								ls_primary_provider_id, &
//								ls_secondary_provider_id, &
//								ls_sex, &
//								ls_phone_number)

if li_sts <= 0 then
	log.log(this, "show_patient()", "Invalid cpr_id (" + ps_cpr_id + ")", 4)
	messagebox("Lab Sendout", "Invalid Patient ID (" + ps_cpr_id + ")" )
	return
end if

em_date_of_birth.text = string(ld_date_of_birth, date_format_string)
sle_age.text = f_pretty_age(ld_date_of_birth, today())
st_cpr_id.text = ps_cpr_id
uo_cb_sex.set_sex(ls_sex)
sle_phone_number.text = ls_phone_number

gen_guar_relation()
gen_payor()
gen_lab()

setnull(ls_billto)
select authority_id 
into :ls_billto
from p_Patient_Authority
where cpr_id = :cpr_id
and authority_type = 'PAYOR'
and authority_sequence = 1;
if not tf_check() then return 
if len(ls_billto) > 0 then
	choose case ls_billto
		case "Medicare"
			bill_to = "T1"
		case "Medicaid"
			bill_to = "T2"
		case else 
			bill_to = "T3"
	end choose	
end if		

ls_payor_flag = bill_to

select relation_cpr_id,
		relation_link,
		payor_flag
into  :guarantor_cpr_id
	   ,:st_guarantor.text
		,:ls_payor_flag
		from p_Patient_Relation
		where cpr_id = :ps_cpr_id
		and guarantor_flag = 'Y';
if not tf_check() then return 
if not sqlca.sqlcode = 0 then
	guarantor_cpr_id = ps_cpr_id
	st_guarantor.text = 'Self'
end if

if not isnull(ls_payor_flag) then
		for i = 1 to payorlist.row_count
			if ls_payor_flag = payorlist.items[i] then
				bill_to = payorlist.item_codes[i]
				st_billto.text = payorlist.items[i]
				exit
			end if	
		Next
end if	

show_guarantor()

end subroutine

public subroutine show_guarantor ();select 	first_name,
			last_name,
			middle_name,
			address,
			city,
			state,
			zip,
			phone_number
		into
		:sle_g_first_name.text,
		:sle_g_last_name.text,
		:sle_g_middle_name.text,
		:sle_g_address.text,
		:sle_g_city.text,
		:sle_g_state.text,
		:sle_g_zip.text,
		:sle_g_phone_number.text
from p_patient
where cpr_id = :guarantor_cpr_id;
if not tf_check() then return

if sqlca.sqlcode <> 0 then
	new_guarantor = true
else
	new_guarantor = false
end if	

refresh_ins() 
end subroutine

event open;call super::open;integer i

u_user luo_user
string ls_image

popup = message.powerobjectparm

if popup.data_row_count = 0 then
	show_patient(popup.item)
elseif popup.data_row_count = 1 then
	show_patient(popup.items[1])
elseif popup.data_row_count = 2 then
	show_patient(popup.items[1])
else
	log.log(this, "open", "Invalid parameters", 4)
	close(this)
	return
end if






end event

on w_labsendout.create
this.cb_find_patient=create cb_find_patient
this.st_billto=create st_billto
this.em_date_of_birth=create em_date_of_birth
this.st_birthdate=create st_birthdate
this.st_laboratory=create st_laboratory
this.st_middle_name=create st_middle_name
this.st_first_name=create st_first_name
this.st_last_name=create st_last_name
this.st_billing_id=create st_billing_id
this.uo_cb_yn=create uo_cb_yn
this.sle_groupname=create sle_groupname
this.sle_groupnumber=create sle_groupnumber
this.sle_policy=create sle_policy
this.st_workmen_title=create st_workmen_title
this.st_groupname_title=create st_groupname_title
this.st_groupnumber_title=create st_groupnumber_title
this.st_policy_title=create st_policy_title
this.sle_i_address2=create sle_i_address2
this.st_i_address2_title=create st_i_address2_title
this.sle_i_zip=create sle_i_zip
this.st_i_zip_title=create st_i_zip_title
this.sle_i_state=create sle_i_state
this.st_i_state_title=create st_i_state_title
this.sle_i_city=create sle_i_city
this.st_i_city_title=create st_i_city_title
this.sle_i_address1=create sle_i_address1
this.st_i_address1_title=create st_i_address1_title
this.st_g_zip_title=create st_g_zip_title
this.st_g_state_title=create st_g_state_title
this.st_g_city_title=create st_g_city_title
this.st_g_address_title=create st_g_address_title
this.sle_g_zip=create sle_g_zip
this.sle_g_city=create sle_g_city
this.sle_g_state=create sle_g_state
this.sle_g_address=create sle_g_address
this.st_g_phone_num_title=create st_g_phone_num_title
this.sle_g_phone_number=create sle_g_phone_number
this.sle_g_middle_name=create sle_g_middle_name
this.sle_g_first_name=create sle_g_first_name
this.st_3a=create st_3a
this.sle_g_last_name=create sle_g_last_name
this.st_g_name_title=create st_g_name_title
this.st_guarantor=create st_guarantor
this.st_guarantor_title=create st_guarantor_title
this.st_billto_title=create st_billto_title
this.st_laboratory_title=create st_laboratory_title
this.st_insurance_carrier=create st_insurance_carrier
this.st_carrier_title=create st_carrier_title
this.st_sex=create st_sex
this.sle_phone_number=create sle_phone_number
this.st_phone_num_title=create st_phone_num_title
this.st_5=create st_5
this.sle_age=create sle_age
this.st_age=create st_age
this.st_4=create st_4
this.st_3=create st_3
this.pb_cancel=create pb_cancel
this.st_cpr_id=create st_cpr_id
this.pb_ok=create pb_ok
this.ln_1=create ln_1
this.ln_3=create ln_3
this.sle_workmen=create sle_workmen
this.uo_cb_sex=create uo_cb_sex
this.Control[]={this.cb_find_patient,&
this.st_billto,&
this.em_date_of_birth,&
this.st_birthdate,&
this.st_laboratory,&
this.st_middle_name,&
this.st_first_name,&
this.st_last_name,&
this.st_billing_id,&
this.uo_cb_yn,&
this.sle_groupname,&
this.sle_groupnumber,&
this.sle_policy,&
this.st_workmen_title,&
this.st_groupname_title,&
this.st_groupnumber_title,&
this.st_policy_title,&
this.sle_i_address2,&
this.st_i_address2_title,&
this.sle_i_zip,&
this.st_i_zip_title,&
this.sle_i_state,&
this.st_i_state_title,&
this.sle_i_city,&
this.st_i_city_title,&
this.sle_i_address1,&
this.st_i_address1_title,&
this.st_g_zip_title,&
this.st_g_state_title,&
this.st_g_city_title,&
this.st_g_address_title,&
this.sle_g_zip,&
this.sle_g_city,&
this.sle_g_state,&
this.sle_g_address,&
this.st_g_phone_num_title,&
this.sle_g_phone_number,&
this.sle_g_middle_name,&
this.sle_g_first_name,&
this.st_3a,&
this.sle_g_last_name,&
this.st_g_name_title,&
this.st_guarantor,&
this.st_guarantor_title,&
this.st_billto_title,&
this.st_laboratory_title,&
this.st_insurance_carrier,&
this.st_carrier_title,&
this.st_sex,&
this.sle_phone_number,&
this.st_phone_num_title,&
this.st_5,&
this.sle_age,&
this.st_age,&
this.st_4,&
this.st_3,&
this.pb_cancel,&
this.st_cpr_id,&
this.pb_ok,&
this.ln_1,&
this.ln_3,&
this.sle_workmen,&
this.uo_cb_sex}
end on

on w_labsendout.destroy
destroy(this.cb_find_patient)
destroy(this.st_billto)
destroy(this.em_date_of_birth)
destroy(this.st_birthdate)
destroy(this.st_laboratory)
destroy(this.st_middle_name)
destroy(this.st_first_name)
destroy(this.st_last_name)
destroy(this.st_billing_id)
destroy(this.uo_cb_yn)
destroy(this.sle_groupname)
destroy(this.sle_groupnumber)
destroy(this.sle_policy)
destroy(this.st_workmen_title)
destroy(this.st_groupname_title)
destroy(this.st_groupnumber_title)
destroy(this.st_policy_title)
destroy(this.sle_i_address2)
destroy(this.st_i_address2_title)
destroy(this.sle_i_zip)
destroy(this.st_i_zip_title)
destroy(this.sle_i_state)
destroy(this.st_i_state_title)
destroy(this.sle_i_city)
destroy(this.st_i_city_title)
destroy(this.sle_i_address1)
destroy(this.st_i_address1_title)
destroy(this.st_g_zip_title)
destroy(this.st_g_state_title)
destroy(this.st_g_city_title)
destroy(this.st_g_address_title)
destroy(this.sle_g_zip)
destroy(this.sle_g_city)
destroy(this.sle_g_state)
destroy(this.sle_g_address)
destroy(this.st_g_phone_num_title)
destroy(this.sle_g_phone_number)
destroy(this.sle_g_middle_name)
destroy(this.sle_g_first_name)
destroy(this.st_3a)
destroy(this.sle_g_last_name)
destroy(this.st_g_name_title)
destroy(this.st_guarantor)
destroy(this.st_guarantor_title)
destroy(this.st_billto_title)
destroy(this.st_laboratory_title)
destroy(this.st_insurance_carrier)
destroy(this.st_carrier_title)
destroy(this.st_sex)
destroy(this.sle_phone_number)
destroy(this.st_phone_num_title)
destroy(this.st_5)
destroy(this.sle_age)
destroy(this.st_age)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.pb_cancel)
destroy(this.st_cpr_id)
destroy(this.pb_ok)
destroy(this.ln_1)
destroy(this.ln_3)
destroy(this.sle_workmen)
destroy(this.uo_cb_sex)
end on

type cb_find_patient from commandbutton within w_labsendout
integer x = 2633
integer y = 648
integer width = 192
integer height = 104
integer taborder = 90
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;if isvalid(w_patient_select) then
	open(w_patient_select)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	guarantor_cpr_id = popup_return.items[1]
	new_guarantor = true
	show_guarantor()
end if	
end event

type st_billto from statictext within w_labsendout
integer x = 238
integer y = 464
integer width = 699
integer height = 108
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
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

event clicked;call super::clicked;pop_payor()
end event

type em_date_of_birth from editmask within w_labsendout
integer x = 910
integer y = 276
integer width = 393
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "mm/dd/yy"
boolean spin = true
double increment = 1
string minmax = "~~"
end type

event modified;call super::modified;date ld_date_of_birth

ld_date_of_birth = date(em_date_of_birth.text)
st_age.text = f_pretty_age(ld_date_of_birth, today())

end event

type st_birthdate from statictext within w_labsendout
integer x = 658
integer y = 292
integer width = 251
integer height = 60
integer textsize = -8
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

type st_laboratory from u_st_primary_provider within w_labsendout
integer x = 1719
integer y = 464
integer width = 699
fontcharset fontcharset = ansi!
string text = "<None>"
end type

event clicked;call super::clicked;pop_lab()


end event

type st_middle_name from statictext within w_labsendout
integer x = 2322
integer y = 68
integer width = 192
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
boolean border = true
boolean focusrectangle = false
end type

type st_first_name from statictext within w_labsendout
integer x = 1810
integer y = 68
integer width = 498
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
boolean border = true
boolean focusrectangle = false
end type

type st_last_name from statictext within w_labsendout
integer x = 905
integer y = 68
integer width = 873
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
boolean border = true
boolean focusrectangle = false
end type

type st_billing_id from statictext within w_labsendout
integer x = 224
integer y = 68
integer width = 402
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 80269524
boolean border = true
boolean focusrectangle = false
end type

type uo_cb_yn from u_cb_yn_toggle within w_labsendout
integer x = 672
integer y = 1516
integer taborder = 100
string text = "N"
end type

type sle_groupname from singlelineedit within w_labsendout
integer x = 1326
integer y = 1500
integer width = 535
integer height = 104
integer taborder = 60
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type sle_groupnumber from singlelineedit within w_labsendout
integer x = 1326
integer y = 1364
integer width = 379
integer height = 104
integer taborder = 230
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type sle_policy from singlelineedit within w_labsendout
integer x = 197
integer y = 1364
integer width = 690
integer height = 104
integer taborder = 210
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type st_workmen_title from statictext within w_labsendout
integer x = 50
integer y = 1512
integer width = 622
integer height = 112
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Workmens Compensation Indicator"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_groupname_title from statictext within w_labsendout
integer x = 1019
integer y = 1520
integer width = 393
integer height = 60
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Group Name"
boolean focusrectangle = false
end type

type st_groupnumber_title from statictext within w_labsendout
integer x = 960
integer y = 1388
integer width = 393
integer height = 60
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Group Number"
boolean focusrectangle = false
end type

type st_policy_title from statictext within w_labsendout
integer x = 50
integer y = 1380
integer width = 393
integer height = 60
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Policy"
boolean focusrectangle = false
end type

type sle_i_address2 from singlelineedit within w_labsendout
integer x = 933
integer y = 1224
integer width = 535
integer height = 104
integer taborder = 190
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type st_i_address2_title from statictext within w_labsendout
integer x = 933
integer y = 1168
integer width = 393
integer height = 60
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Address Line 2"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_i_zip from singlelineedit within w_labsendout
integer x = 2427
integer y = 1224
integer width = 407
integer height = 104
integer taborder = 220
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type st_i_zip_title from statictext within w_labsendout
integer x = 2336
integer y = 1168
integer width = 187
integer height = 60
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "ZIP"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_i_state from singlelineedit within w_labsendout
integer x = 2126
integer y = 1224
integer width = 242
integer height = 104
integer taborder = 200
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type st_i_state_title from statictext within w_labsendout
integer x = 2080
integer y = 1168
integer width = 187
integer height = 60
integer textsize = -8
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

type sle_i_city from singlelineedit within w_labsendout
integer x = 1531
integer y = 1224
integer width = 535
integer height = 104
integer taborder = 140
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type st_i_city_title from statictext within w_labsendout
integer x = 1449
integer y = 1168
integer width = 187
integer height = 60
integer textsize = -8
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

type sle_i_address1 from singlelineedit within w_labsendout
integer x = 46
integer y = 1224
integer width = 837
integer height = 104
integer taborder = 110
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

event __set_imemode;datetime ldt_now
string ls_cpr_id
string ls_race
date ld_date_of_birth
datetime ldt_date_of_birth
string ls_sex
string ls_primary_language
string ls_marital_status
string ls_billing_id
string ls_first_name
string ls_last_name
string ls_degree
string ls_name_prefix
string ls_middle_name
string ls_name_suffix
string ls_primary_provider_id
string ls_secondary_provider_id
string ls_payor_flag
datetime ldt_last_update

long ll_workplan_id
string ls_room_id
datetime ldt_room_time
string ls_patient_status
integer li_priority
string ls_new_flag
string ls_reports_printed

string ls_phone_number
boolean lb_workflow
long ll_patient_id

string ls_string, ls_date
integer li_patient_index, li_sts, li_log_index

ls_last_name = sle_g_last_name.text
ls_first_name = sle_g_first_name.text
ls_middle_name = sle_g_middle_name.text
ls_phone_number = sle_g_phone_number.text

setnull(ld_date_of_birth)
setnull(ls_race)
setnull(ls_sex)
setnull(ls_name_prefix)
setnull(ls_name_suffix)
setnull(ls_degree)
setnull(ls_primary_provider_id)

if new_guarantor then
	ls_cpr_id = ls_billing_id + '.1'

//	li_sts = f_create_new_patient( &
//									ls_cpr_id,   &
//									ls_race,   &
//									ld_date_of_birth,   &
//									ls_sex,   &
//									ls_phone_number, &
//									ls_primary_language,   &
//									ls_marital_status,   &
//									ls_billing_id,   &
//									ll_patient_id,   &
//									ls_first_name,   &
//									ls_last_name,   &
//									ls_degree,   &
//									ls_name_prefix,   &
//									ls_middle_name,   &
//									ls_name_suffix,   &
//									ls_primary_provider_id, &
//									ls_secondary_provider_id, &
//									li_priority &
//									)
	
	else	
		ls_cpr_id = guarantor_cpr_id
end if
	
	UPDATE p_Patient
	SET	last_name = :ls_last_name,
			first_name = :ls_first_name,
			middle_name = :ls_middle_name,
			phone_number = :ls_phone_number,
			address = :sle_g_address.text,
			city = :sle_g_city.text,
			state = :sle_g_state.text,
			zip = :sle_g_zip.text
	WHERE cpr_id = :ls_cpr_id;
	if not tf_check() then return 

if not isnull(insurance_id) then
	
	  UPDATE c_Authority  
     SET address1 = :sle_i_address1.text,   
         address2 = :sle_i_address2.text,   
         city = :sle_i_city.text,   
         state = :sle_i_state.text,   
         zip = :sle_i_zip.text  
   WHERE ( c_Authority.authority_id = :insurance_id ) AND  
         ( c_Authority.authority_type = 'PAYOR' )   
           ;
	if not tf_check() then return
	
	UPDATE p_Patient_Authority
	SET ins_groupnumber = :sle_groupnumber.text,
		ins_groupname = :sle_groupname.text,
		ins_policy = :sle_policy.text,
		ins_workmencomp = :sle_workmen.text
	WHERE cpr_id = :ls_cpr_id
	AND authority_id = :insurance_id
	AND authority_sequence = 1;
	if not tf_check() then return
	if sqlca.sqlcode <> 0 then
		INSERT INTO p_Patient_Authority (
		cpr_id,
		authority_type,		
		authority_sequence,
		authority_id,
		notes,
		created,
		created_by,
		modified_by,
		ins_groupnumber,
		ins_groupname,
		ins_policy,
		ins_workmencomp)
		VALUES (
		:ls_cpr_id,
		'PAYOR',
		1,
		:insurance_id,
		null,
		:ldt_now,
		:current_scribe.user_id,
		:current_scribe.user_id,
		:sle_groupnumber.text,
		:sle_groupname.text,
		:sle_policy.text,
		:sle_workmen.text);
		if not tf_check() then return
	end if
end if
if bill_to = 'C' then 
	ls_payor_flag = 'N'
else
	ls_payor_flag = 'Y'
end if	

  UPDATE p_Patient_Relation  
     SET relation_link = :st_guarantor.text,   
         guarantor_flag = :ls_payor_flag,   
         payor_flag = :st_billto.text 
   WHERE ( p_Patient_Relation.cpr_id = :cpr_id ) AND  
         ( p_Patient_Relation.relation_cpr_id = :ls_cpr_id )   
           ;
if not tf_check() then return 

if sqlca.sqlcode <> 0 then
	  INSERT INTO p_Patient_Relation  
         ( cpr_id,   
           relation_cpr_id,   
           relation_link,   
           guarantor_flag,   
           payor_flag )  
  VALUES ( :cpr_id,   
           :ls_cpr_id,   
           :st_guarantor.text,   
           :ls_payor_flag,   
           :st_billto.text )  ;

	if not tf_check() then return 
end if	

//current_user.complete_service()

if isvalid(w_labsendout) then closewithreturn(parent, popup_return)

end event

type st_i_address1_title from statictext within w_labsendout
integer x = 50
integer y = 1168
integer width = 393
integer height = 60
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Address Line 1"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_g_zip_title from statictext within w_labsendout
integer x = 1737
integer y = 780
integer width = 187
integer height = 60
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "ZIP"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_g_state_title from statictext within w_labsendout
integer x = 1481
integer y = 780
integer width = 187
integer height = 60
integer textsize = -8
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

type st_g_city_title from statictext within w_labsendout
integer x = 827
integer y = 780
integer width = 187
integer height = 60
integer textsize = -8
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

type st_g_address_title from statictext within w_labsendout
integer x = 50
integer y = 780
integer width = 229
integer height = 60
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Address"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_g_zip from singlelineedit within w_labsendout
integer x = 1810
integer y = 836
integer width = 407
integer height = 104
integer taborder = 150
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type sle_g_city from singlelineedit within w_labsendout
integer x = 905
integer y = 836
integer width = 594
integer height = 104
integer taborder = 160
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type sle_g_state from singlelineedit within w_labsendout
integer x = 1527
integer y = 836
integer width = 242
integer height = 104
integer taborder = 170
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type sle_g_address from singlelineedit within w_labsendout
integer x = 46
integer y = 836
integer width = 805
integer height = 104
integer taborder = 120
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type st_g_phone_num_title from statictext within w_labsendout
integer x = 2523
integer y = 780
integer width = 187
integer height = 60
integer textsize = -8
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

type sle_g_phone_number from singlelineedit within w_labsendout
integer x = 2368
integer y = 836
integer width = 480
integer height = 108
integer taborder = 130
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

on modified;text = upper(left(text, 1)) + mid(text, 2)

end on

type sle_g_middle_name from singlelineedit within w_labsendout
integer x = 2322
integer y = 648
integer width = 192
integer height = 104
integer taborder = 80
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
boolean displayonly = true
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type sle_g_first_name from singlelineedit within w_labsendout
integer x = 1810
integer y = 648
integer width = 498
integer height = 104
integer taborder = 70
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
boolean displayonly = true
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type st_3a from statictext within w_labsendout
integer x = 1787
integer y = 680
integer width = 41
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = ","
boolean focusrectangle = false
end type

type sle_g_last_name from singlelineedit within w_labsendout
integer x = 905
integer y = 648
integer width = 873
integer height = 104
integer taborder = 40
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
boolean displayonly = true
end type

event modified;text = trim(text)
text = upper(left(text, 1)) + mid(text, 2)

end event

type st_g_name_title from statictext within w_labsendout
integer x = 713
integer y = 648
integer width = 187
integer height = 56
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_guarantor from u_st_primary_provider within w_labsendout
integer x = 293
integer y = 652
integer width = 352
string text = "<None>"
end type

event clicked;call super::clicked;pop_guarantor()
end event

type st_guarantor_title from statictext within w_labsendout
integer x = 9
integer y = 648
integer width = 311
integer height = 116
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Guarantor Relation"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_billto_title from statictext within w_labsendout
integer x = 18
integer y = 480
integer width = 270
integer height = 68
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Bill To"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_laboratory_title from statictext within w_labsendout
integer x = 1385
integer y = 476
integer width = 370
integer height = 60
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Laboratory"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_insurance_carrier from u_st_primary_provider within w_labsendout
integer x = 558
integer y = 1032
integer width = 2107
end type

event clicked;call super::clicked;if isvalid(w_carrier_select) then
	open(w_carrier_select)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return

	insurance_id = popup_return.items[1]
	text = popup_return.descriptions[1]

	refresh_ins() 
END IF
end event

type st_carrier_title from statictext within w_labsendout
integer x = 91
integer y = 1044
integer width = 453
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Insurance Carrier"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_sex from statictext within w_labsendout
integer x = 96
integer y = 292
integer width = 169
integer height = 60
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Sex"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_phone_number from singlelineedit within w_labsendout
integer x = 2373
integer y = 276
integer width = 480
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

on modified;text = upper(left(text, 1)) + mid(text, 2)

end on

type st_phone_num_title from statictext within w_labsendout
integer x = 2194
integer y = 292
integer width = 187
integer height = 60
integer textsize = -8
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

type st_5 from statictext within w_labsendout
integer x = 73
integer y = 60
integer width = 155
integer height = 120
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Billing ID"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_age from singlelineedit within w_labsendout
integer x = 1541
integer y = 276
integer width = 421
integer height = 108
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
boolean autohscroll = false
end type

type st_age from statictext within w_labsendout
integer x = 1399
integer y = 292
integer width = 142
integer height = 60
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Age"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_labsendout
integer x = 713
integer y = 76
integer width = 187
integer height = 56
integer textsize = -8
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_labsendout
integer x = 1787
integer y = 88
integer width = 41
integer height = 72
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = ","
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_labsendout
integer x = 2011
integer y = 1484
integer taborder = 0
string picturename = "button11.bmp"
string disabledname = "button11.bmp"
end type

event clicked;close(parent)
end event

on mouse_move;f_cpr_set_msg("Cancel")
end on

type st_cpr_id from statictext within w_labsendout
integer x = 613
integer y = 128
integer width = 178
integer height = 52
integer textsize = -6
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
boolean focusrectangle = false
end type

type pb_ok from u_picture_button within w_labsendout
integer x = 2624
integer y = 1484
integer taborder = 50
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;integer li_sts
li_sts = verify_complete()
if li_sts < 1 then return

close(parent)


end event

on mouse_move;f_cpr_set_msg("Create Encounter")
end on

type ln_1 from line within w_labsendout
integer linethickness = 3
integer beginy = 996
integer endx = 2967
integer endy = 996
end type

type ln_3 from line within w_labsendout
integer linethickness = 3
integer beginy = 616
integer endx = 2967
integer endy = 616
end type

type sle_workmen from singlelineedit within w_labsendout
integer x = 699
integer y = 1512
integer width = 69
integer height = 96
integer taborder = 180
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type uo_cb_sex from u_cb_sex_toggle within w_labsendout
integer x = 238
integer y = 276
integer taborder = 10
boolean bringtotop = true
end type

