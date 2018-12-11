$PBExportHeader$w_svc_allergy_vial_definition.srw
forward
global type w_svc_allergy_vial_definition from w_svc_generic
end type
type dw_vial from u_dw_pick_list within w_svc_allergy_vial_definition
end type
type cb_add_allergen from commandbutton within w_svc_allergy_vial_definition
end type
type pb_up from u_picture_button within w_svc_allergy_vial_definition
end type
type pb_down from u_picture_button within w_svc_allergy_vial_definition
end type
type st_total_vol from statictext within w_svc_allergy_vial_definition
end type
type st_allergen from statictext within w_svc_allergy_vial_definition
end type
type st_total_allergen from statictext within w_svc_allergy_vial_definition
end type
type st_page from statictext within w_svc_allergy_vial_definition
end type
type cb_delete from commandbutton within w_svc_allergy_vial_definition
end type
type st_diluent from statictext within w_svc_allergy_vial_definition
end type
type st_diluent_amount from statictext within w_svc_allergy_vial_definition
end type
type st_text from statictext within w_svc_allergy_vial_definition
end type
type st_volume_title from statictext within w_svc_allergy_vial_definition
end type
type st_5 from statictext within w_svc_allergy_vial_definition
end type
type dw_abnormal_results from u_dw_pick_list within w_svc_allergy_vial_definition
end type
type st_2 from statictext within w_svc_allergy_vial_definition
end type
type st_vol from statictext within w_svc_allergy_vial_definition
end type
type st_6 from statictext within w_svc_allergy_vial_definition
end type
type st_vial_schedule from statictext within w_svc_allergy_vial_definition
end type
type st_schedule_title from statictext within w_svc_allergy_vial_definition
end type
type st_frequency from statictext within w_svc_allergy_vial_definition
end type
type st_frequency_title from statictext within w_svc_allergy_vial_definition
end type
type tab_results from u_tab_allergy_abnormal_results within w_svc_allergy_vial_definition
end type
type tab_results from u_tab_allergy_abnormal_results within w_svc_allergy_vial_definition
end type
type st_vial_created from statictext within w_svc_allergy_vial_definition
end type
end forward

global type w_svc_allergy_vial_definition from w_svc_generic
boolean controlmenu = false
string button_type = "COMMAND"
integer max_buttons = 3
dw_vial dw_vial
cb_add_allergen cb_add_allergen
pb_up pb_up
pb_down pb_down
st_total_vol st_total_vol
st_allergen st_allergen
st_total_allergen st_total_allergen
st_page st_page
cb_delete cb_delete
st_diluent st_diluent
st_diluent_amount st_diluent_amount
st_text st_text
st_volume_title st_volume_title
st_5 st_5
dw_abnormal_results dw_abnormal_results
st_2 st_2
st_vol st_vol
st_6 st_6
st_vial_schedule st_vial_schedule
st_schedule_title st_schedule_title
st_frequency st_frequency
st_frequency_title st_frequency_title
tab_results tab_results
st_vial_created st_vial_created
end type
global w_svc_allergy_vial_definition w_svc_allergy_vial_definition

type variables
real	total_volume

long		parent_treatment_id
long		diluent_treatment_id

boolean  vial_created = false

u_component_treatment	treatment

string tests_treatment_type = "AllergyTest"
datetime tests_begin_date

u_unit dose_unit

string vial_schedule
boolean custom_schedule

end variables

forward prototypes
public function real actual_volume ()
public function string get_dose_amount_text (long pl_row)
public function integer load_allergens ()
public function integer load_abnormal_results ()
public function integer update_dose (long pl_row, real pr_new_dose)
public function integer update_allergens_old ()
public function boolean check_new_dose (long pl_row, real pr_new_dose_amount)
public function boolean check_doses ()
end prototypes

public function real actual_volume ();integer 	i
real 		lr_amount
real 		lr_dose_amount
decimal {3} ld_amount,ld_diluent


For i = 1 to dw_vial.rowcount()
	lr_dose_amount = dw_vial.object.dose_amount[i]
	if not isnull(lr_dose_amount) then 	lr_amount += lr_dose_amount
Next

ld_amount = lr_amount

ld_diluent = total_volume - lr_amount

st_diluent_amount.text = string(ld_diluent)

return lr_amount


end function

public function string get_dose_amount_text (long pl_row);string  			ls_unit,ls_value
real    			lr_dose
decimal {3} 	ld_dose

u_unit  			luo_unit

ls_unit = dw_vial.object.dose_unit[pl_row]
luo_unit = unit_list.find_unit(ls_unit)
if isnull(luo_unit) then
	luo_unit = unit_list.find_unit("ML")
end if

lr_dose = dw_vial.object.dose_amount[pl_row]
if isnull(luo_unit) then
	ld_dose = dec(lr_dose)
	ls_value = string(ld_dose)
else
	ls_value = luo_unit.pretty_amount(lr_dose)
end if

return ls_value

end function

public function integer load_allergens ();integer li_sts
string      ls_value
integer		i
long			ll_count,ll_row
long ll_rowcount
str_treatment_description lstr_new_allergen

// now retrieve the allergen list
dw_vial.reset()
dw_vial.setfilter("")
dw_vial.filter()
dw_vial.settransobject(sqlca)
ll_rowcount = dw_vial.retrieve(current_patient.cpr_id,treatment.open_encounter_id,parent_treatment_id)
if ll_rowcount < 0 then return -1

// If there's no diluent record then add one
ll_row = dw_vial.find("isnull(drug_id)", 1, ll_rowcount)
if ll_row = 0 then 
	lstr_new_allergen = f_empty_treatment()
	
	lstr_new_allergen.open_encounter_id = treatment.open_encounter_id
	lstr_new_allergen.treatment_description = 'Diluent'
	lstr_new_allergen.begin_date = treatment.begin_date
	lstr_new_allergen.dose_unit = dose_unit.unit_id
	lstr_new_allergen.treatment_type = "AllergyVialDefinition"
	lstr_new_allergen.parent_treatment_id = parent_treatment_id
	lstr_new_allergen.ordered_by = current_user.user_id
	lstr_new_allergen.created_by = current_scribe.user_id
	
	diluent_treatment_id = current_patient.treatments.new_treatment(lstr_new_allergen)
	if diluent_treatment_id <= 0 then
		log.log(this, "w_svc_allergy_vial_definition.load_allergens:0032", "Error creating diluent treatment", 4)
		return -1
	end if
else
	diluent_treatment_id = dw_vial.object.treatment_id[ll_row]
end if

// Filter out the diluent record
dw_vial.setfilter("not isnull(drug_id)")
dw_vial.filter()

st_total_allergen.text = string(dw_vial.rowcount())

dw_vial.set_page(1, pb_up, pb_down, st_page)	

actual_volume()

return 1

end function

public function integer load_abnormal_results ();tab_results.refresh()

return 1

//string ls_temp
//long ll_count
//string ls_top_20_code
//datetime ldt_from_date
//long i
//string ls_result
//string ls_result_value
//string ls_result_unit
//string ls_result_amount_flag
//string ls_print_result_flag
//string ls_print_result_separator
//string ls_abnormal_flag
//string ls_unit_preference
//string ls_display_mask
//string ls_pretty_result
//string ls_observation_description
//string ls_location
//string ls_location_description
//
//if treatment.problem_count >= 1 then
//	dw_abnormal_results.dataobject = "dw_sp_abnormal_results_small"
//	dw_abnormal_results.settransobject(sqlca)
//	ll_count = dw_abnormal_results.retrieve(current_patient.cpr_id, tests_treatment_type, ldt_from_date)
//else
//	dw_abnormal_results.dataobject = "dw_sp_abnormal_results_for_assmnt_small"
//	dw_abnormal_results.settransobject(sqlca)
//	ll_count = dw_abnormal_results.retrieve(current_patient.cpr_id, treatment.problem_id())
//end if
//
//
//for i = 1 to ll_count
//	ls_result = dw_abnormal_results.object.result[i]
//	ls_location = dw_abnormal_results.object.location[i]
//	ls_location_description = dw_abnormal_results.object.location_description[i]
//	ls_result_value = dw_abnormal_results.object.result_value[i]
//	ls_result_unit = dw_abnormal_results.object.result_unit[i]
//	ls_result_amount_flag = dw_abnormal_results.object.result_amount_flag[i]
//	ls_print_result_flag = dw_abnormal_results.object.print_result_flag[i]
//	ls_print_result_separator = dw_abnormal_results.object.print_result_separator[i]
//	ls_abnormal_flag = dw_abnormal_results.object.abnormal_flag[i]
//	ls_unit_preference = dw_abnormal_results.object.unit_preference[i]
//	ls_display_mask = dw_abnormal_results.object.display_mask[i]
//	
//	ls_observation_description = dw_abnormal_results.object.observation_description[i]
//	
//	ls_pretty_result = f_pretty_result( ls_result, &
//											ls_location, &
//											ls_location_description, &
//											ls_result_value, &
//											ls_result_unit, &
//											ls_result_amount_flag, &
//											ls_print_result_flag, &
//											ls_print_result_separator, &
//											ls_abnormal_flag, &
//											ls_unit_preference, &
//											ls_display_mask, &
//											false, &
//											true, &
//											true )
//	
//	if len(ls_pretty_result) > 0 then
//		ls_observation_description += ":  " + ls_pretty_result
//	end if
//	
//	dw_abnormal_results.object.result_description[i] = ls_observation_description
//next
//
//dw_abnormal_results.last_page = 0
//dw_abnormal_results.set_page(1, pb_up, pb_down, st_page)
//
//return ll_count
//
//
end function

public function integer update_dose (long pl_row, real pr_new_dose);long ll_treatment_id
integer li_sts
string ls_new_dose
datetime ldt_progress_date_time
long ll_null
string ls_message
str_popup_return popup_return

setnull(ll_null)

ldt_progress_date_time = datetime(today(), now())

ls_new_dose = dose_unit.pretty_amount(pr_new_dose)
ll_treatment_id = dw_vial.object.treatment_id[pl_row]

if vial_created then
	ls_message = "This vial definition has already been instantiated with the creation of a full-strength vial. "
	ls_message += "Changing the vial definition will also change the constituents of the existing vial(s) "
	ls_message += "and should be done only to correct errors.  Are you sure you want to do this?"
	openwithparm(w_pop_yes_no, ls_message)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 0
end if

li_sts = f_set_progress(current_patient.cpr_id, &
								"Treatment", &
								ll_treatment_id, &
								"Modify", &
								"dose_amount", &
								ls_new_dose, &
								ldt_progress_date_time, &
								ll_null, &
								ll_null, &
								ll_null)


dw_vial.object.dose_amount[pl_row] = pr_new_dose

actual_volume()

// If the vial has already been created then update the diluent amount
if vial_created then
	li_sts = f_set_progress(current_patient.cpr_id, &
									"Treatment", &
									diluent_treatment_id, &
									"Modify", &
									"dose_amount", &
									st_diluent_amount.text, &
									ldt_progress_date_time, &
									ll_null, &
									ll_null, &
									ll_null)
end if

return 1

end function

public function integer update_allergens_old ();Long		ll_rowcount,ll_treatment_id,ll_null
Integer  i,li_vial
string	ls_cpr_id,ls_description
string	ls_drug_id,ls_package_id
long		ll_encounter_id
datetime ldt_begin_date,ldt_progress_date_time
Real     lr_amount,lr_new_amount,lr_prev_amount,lr_diluent
string ls_dose_unit

setnull(ll_null)
setnull(ldt_progress_date_time)

lr_diluent = real(st_diluent_amount.text)

dw_vial.setredraw(false)

// remove the filter
dw_vial.setfilter("")
dw_vial.filter()

// make sure the diluent is always a first record
// when creating a new definition
dw_vial.setsort("sort_sequence A,treatment_id A")
dw_vial.sort()

ll_rowcount = dw_vial.rowcount()

FOR i = 1 To ll_rowcount
	ls_cpr_id = dw_vial.object.cpr_id[i]
	ll_encounter_id = dw_vial.object.open_encounter_id[i]
	ls_drug_id = dw_vial.object.drug_id[i]
	ls_description = dw_vial.object.treatment_description[i]
	ls_package_id = dw_vial.object.package_id[i]
	lr_amount = dw_vial.object.dose_amount[i]
	ls_dose_unit = dw_vial.object.dose_unit[i]
	ldt_begin_date = dw_vial.object.begin_date[i]
	li_vial = dw_vial.object.new_vial[i]

	if ls_drug_id = 'Vial Diluent' and ls_description = 'Diluent' Then
		dw_vial.object.dose_amount[i] = lr_diluent
		lr_amount = lr_diluent
	end if
	
	// insert them into treatment table
	if li_vial = 0 then
		Insert into p_treatment_item
		(
			cpr_id,
			open_encounter_id,
			treatment_type,
			package_id,
			drug_id,
			dose_amount,
			dose_unit,
			treatment_description,
			begin_date,
			parent_treatment_id,
			treatment_status,
			ordered_by,
			created_by
		)
		Values
		(
			:ls_cpr_id,
			:ll_encounter_id,
			'AllergyVialDefinition',
			:ls_package_id,
			:ls_drug_id,
			:lr_amount,
			:ls_dose_unit,
			:ls_description,
			:ldt_begin_date,
			:parent_treatment_id,
			'OPEN',
			:current_user.user_id,
			:current_scribe.user_id
		)
		Using sqlca;
		
	elseif li_vial = 1 then // check it's modified
		
		ll_treatment_id = dw_vial.object.treatment_id[i]
		lr_new_amount = dw_vial.object.dose_amount[i]
		lr_prev_amount = dw_vial.object.prev_vol[i]
		if lr_new_amount <> lr_prev_amount then
			f_set_progress(current_patient.cpr_id, &
								"Treatment", &
								ll_treatment_id, &
								'Modify', &
								'dose_amount', &
								string(lr_new_amount), &
								ldt_progress_date_time, &
								ll_null, &
								ll_null, &
								ll_null)	
		end if
	end if
NEXT

dw_vial.setfilter("drug_id <> 'Vial Diluent'")
dw_vial.filter()

dw_vial.setredraw(true)

Return 1


end function

public function boolean check_new_dose (long pl_row, real pr_new_dose_amount);long i
real lr_total
real lr_dose_amount
string ls_allergen

lr_total = 0

for i = 1 to dw_vial.rowcount()
	if i = pl_row then
		lr_dose_amount = pr_new_dose_amount
		
		if isnull(lr_dose_amount) or lr_dose_amount <= 0 then
			Openwithparm(w_pop_message,"Allergen volume must be greater than zero.")
			Return false
		end if
		
		if lr_dose_amount > total_volume then
			Openwithparm(w_pop_message,"Allergen volume must be less than " + st_vol.text)
			Return false
		end if
	else
		lr_dose_amount = dw_vial.object.dose_amount[i]
	end if
	
	lr_total += lr_dose_amount
next

if lr_total > total_volume then
	Openwithparm(w_pop_message,"The total of all allergen volumes must be less than or equal to " + st_vol.text)
	Return false
end if

return true



end function

public function boolean check_doses ();long i
real lr_total
real lr_dose_amount

lr_total = 0

for i = 1 to dw_vial.rowcount()
	lr_dose_amount = dw_vial.object.dose_amount[i]
	
	if isnull(lr_dose_amount) or lr_dose_amount <= 0 then
		Openwithparm(w_pop_message,"Every allergen must have a volume greater than zero.")
		Return false
	end if
	
	if lr_dose_amount > total_volume then
		Openwithparm(w_pop_message,"Every allergen must have a volume less than " + st_vol.text)
		Return false
	end if
	
	lr_total += lr_dose_amount
next

if lr_total > total_volume then
	Openwithparm(w_pop_message,"The total of all allergen volumes must be less than or equal to " + st_vol.text)
	Return false
end if

return true



end function

on w_svc_allergy_vial_definition.create
int iCurrent
call super::create
this.dw_vial=create dw_vial
this.cb_add_allergen=create cb_add_allergen
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_total_vol=create st_total_vol
this.st_allergen=create st_allergen
this.st_total_allergen=create st_total_allergen
this.st_page=create st_page
this.cb_delete=create cb_delete
this.st_diluent=create st_diluent
this.st_diluent_amount=create st_diluent_amount
this.st_text=create st_text
this.st_volume_title=create st_volume_title
this.st_5=create st_5
this.dw_abnormal_results=create dw_abnormal_results
this.st_2=create st_2
this.st_vol=create st_vol
this.st_6=create st_6
this.st_vial_schedule=create st_vial_schedule
this.st_schedule_title=create st_schedule_title
this.st_frequency=create st_frequency
this.st_frequency_title=create st_frequency_title
this.tab_results=create tab_results
this.st_vial_created=create st_vial_created
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_vial
this.Control[iCurrent+2]=this.cb_add_allergen
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.pb_down
this.Control[iCurrent+5]=this.st_total_vol
this.Control[iCurrent+6]=this.st_allergen
this.Control[iCurrent+7]=this.st_total_allergen
this.Control[iCurrent+8]=this.st_page
this.Control[iCurrent+9]=this.cb_delete
this.Control[iCurrent+10]=this.st_diluent
this.Control[iCurrent+11]=this.st_diluent_amount
this.Control[iCurrent+12]=this.st_text
this.Control[iCurrent+13]=this.st_volume_title
this.Control[iCurrent+14]=this.st_5
this.Control[iCurrent+15]=this.dw_abnormal_results
this.Control[iCurrent+16]=this.st_2
this.Control[iCurrent+17]=this.st_vol
this.Control[iCurrent+18]=this.st_6
this.Control[iCurrent+19]=this.st_vial_schedule
this.Control[iCurrent+20]=this.st_schedule_title
this.Control[iCurrent+21]=this.st_frequency
this.Control[iCurrent+22]=this.st_frequency_title
this.Control[iCurrent+23]=this.tab_results
this.Control[iCurrent+24]=this.st_vial_created
end on

on w_svc_allergy_vial_definition.destroy
call super::destroy
destroy(this.dw_vial)
destroy(this.cb_add_allergen)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_total_vol)
destroy(this.st_allergen)
destroy(this.st_total_allergen)
destroy(this.st_page)
destroy(this.cb_delete)
destroy(this.st_diluent)
destroy(this.st_diluent_amount)
destroy(this.st_text)
destroy(this.st_volume_title)
destroy(this.st_5)
destroy(this.dw_abnormal_results)
destroy(this.st_2)
destroy(this.st_vol)
destroy(this.st_6)
destroy(this.st_vial_schedule)
destroy(this.st_schedule_title)
destroy(this.st_frequency)
destroy(this.st_frequency_title)
destroy(this.tab_results)
destroy(this.st_vial_created)
end on

event open;call super::open;string ls_text
str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

treatment = service.treatment

if isnull(current_patient) then
	log.log(this,"w_svc_allergy_vial_definition:open","current patient object is null",4)
	close(this)
	return -1
end if

if isnull(service.treatment) then
	ls_text="treatment object is null for patient,encounter "+current_patient.cpr_id+","+string(current_patient.open_encounter_id)
	log.log(this,"w_svc_allergy_vial_definition:open",ls_text,4)
	closewithreturn(this,popup_return)
	return
end if
parent_treatment_id = treatment.treatment_id

st_title.text = "Vial definition for ~"" + service.treatment.treatment_description + "~""

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


//tab_patient_data.initialize()
//
//tab_patient_data.selecttab(1)


postevent("post_open")


end event

event post_open;call super::post_open;string      ls_value,ls_text
integer		i
long			ll_count,ll_row
integer li_sts
str_popup_return popup_return
string ls_dose_unit
string ls_temp
datetime ldt_progress_date_time
long ll_null

setnull(ldt_progress_date_time)
setnull(ll_null)

li_sts = tab_results.initialize(service)


popup_return.item_count = 1
popup_return.items[1] = "ERROR"

ls_text = service.get_attribute("text")
if isnull(ls_text) then ls_text = "Allergen"

cb_add_allergen.text = "Add "+ls_text
st_allergen.text = "Total "+ls_text+"s"
st_text.text = ls_text

vial_schedule = f_get_progress_value(current_patient.cpr_id, &
													"Treatment", &
													parent_treatment_id, &
													"Property", &
													"Vial Schedule")
if len(vial_schedule) > 0 then
	SELECT count(*)
	INTO :ll_count
	FROM c_Domain
	WHERE domain_id = 'Vial Schedule'
	AND domain_item = :vial_schedule;
	if not tf_check() then return
	if ll_count > 0 then
		st_vial_schedule.text = vial_schedule
	else
		st_vial_schedule.text = "<Custom Schedule>"
		custom_schedule = true
	end if
else
	vial_schedule = "Standard"
	st_vial_schedule.text = vial_schedule
	
	li_sts = f_set_progress(current_patient.cpr_id, &
									"Treatment", &
									parent_treatment_id, &
									"Property", &
									"Vial Schedule", &
									st_vial_schedule.text, &
									ldt_progress_date_time, &
									ll_null, &
									ll_null, &
									ll_null)
end if



dose_unit = unit_list.find_unit(treatment.dose_unit)
if isnull(dose_unit) then
	ls_dose_unit = service.get_attribute("dose_unit")
	if isnull(ls_dose_unit) then ls_dose_unit = "ML"
	
	dose_unit = unit_list.find_unit(ls_dose_unit)
	if isnull(dose_unit) then
		log.log(this, "w_svc_allergy_vial_definition:post", "Error getting dose unit", 4)
		closewithreturn(this, popup_return)
		return
	end if
	
	// Update the treatment with the dose unit
	
	li_sts = f_set_progress(current_patient.cpr_id, &
									"Treatment", &
									parent_treatment_id, &
									"Modify", &
									"dose_unit", &
									dose_unit.unit_id, &
									ldt_progress_date_time, &
									ll_null, &
									ll_null, &
									ll_null)
	treatment.dose_unit = dose_unit.unit_id
end if


total_volume = treatment.dose_amount
if isnull(total_volume) or total_volume <= 0 then
	ls_temp = service.get_attribute("total_volume")
	if isnull(ls_temp) then
		total_volume = 5.00
	else
		total_volume = real(ls_temp)
	end if
	
	li_sts = f_set_progress(current_patient.cpr_id, &
									"Treatment", &
									parent_treatment_id, &
									"Modify", &
									"dose_amount", &
									dose_unit.pretty_amount(total_volume), &
									ldt_progress_date_time, &
									ll_null, &
									ll_null, &
									ll_null)
	treatment.dose_amount = total_volume
end if

st_vol.text = dose_unit.pretty_amount_unit(total_volume)

if len(dose_unit.description) > 0 then
	st_volume_title.text = "Vol. (" + dose_unit.description + ")"
end if

if len(treatment.administer_frequency) > 0 then
	st_frequency.text = treatment.administer_frequency
else
	st_frequency.text = service.get_attribute("default_administer_frequency")
	if isnull(st_frequency.text) then
		st_frequency.text = "1X/WEEK"
	end if
	li_sts = f_set_progress(current_patient.cpr_id, &
									"Treatment", &
									parent_treatment_id, &
									"Modify", &
									"administer_frequency", &
									st_frequency.text, &
									ldt_progress_date_time, &
									ll_null, &
									ll_null, &
									ll_null)
end if


li_sts = load_allergens()

li_sts = load_abnormal_results()

tests_treatment_type = service.get_attribute("allergy_test_treatment_type")
if isnull(tests_treatment_type) then tests_treatment_type = "ALLERGYTEST"


// check if there's atleast one vial created using this definition
SELECT count(*)
INTO :ll_count
FROM p_treatment_item
WHERE parent_treatment_id = :parent_treatment_id
and treatment_type = 'AllergyVialInstance'
and treatment_status in ('NEW','OPEN')
using sqlca;
if not tf_check() then return -1

if ll_count >= 1 then
	vial_created = true
	cb_add_allergen.visible = false
	cb_delete.visible = false
	st_vial_created.visible = true
	st_vol.enabled = false
	st_vol.borderstyle = stylebox!
//	dw_vial.enabled = false
end if

end event

type pb_epro_help from w_svc_generic`pb_epro_help within w_svc_allergy_vial_definition
end type

type st_config_mode_menu from w_svc_generic`st_config_mode_menu within w_svc_allergy_vial_definition
integer x = 14
integer y = 1552
integer height = 68
end type

type cb_finished from w_svc_generic`cb_finished within w_svc_allergy_vial_definition
integer weight = 700
end type

event cb_finished::clicked;integer					i
real						lr_dose_amount
str_popup_return		popup_return
integer li_sts
datetime ldt_progress_date_time
long ll_null

setnull(ll_null)
ldt_progress_date_time = datetime(today(), now())

if not vial_created then
	// Make sure the doses are valid
	if not check_doses() then return
	
	// recalc the diluent
	actual_volume()

	// Update the diluent amount
	li_sts = f_set_progress(current_patient.cpr_id, &
									"Treatment", &
									diluent_treatment_id, &
									"Modify", &
									"dose_amount", &
									st_diluent_amount.text, &
									ldt_progress_date_time, &
									ll_null, &
									ll_null, &
									ll_null)

	// Mark treatment as "Ready"
	li_sts = f_set_progress(current_patient.cpr_id, &
									"Treatment", &
									parent_treatment_id, &
									"Property", &
									"Vial Definition", &
									"Ready", &
									ldt_progress_date_time, &
									ll_null, &
									ll_null, &
									ll_null)
end if

current_patient.load_treatments()

popup_return.item_count = 1
popup_return.items[1] = "OK"
closewithreturn(parent, popup_return)


end event

type cb_be_back from w_svc_generic`cb_be_back within w_svc_allergy_vial_definition
integer weight = 700
end type

event cb_be_back::clicked;integer li_return
integer li_sts
str_popup_return popup_return
integer					i
real						lr_dose_amount
datetime ldt_progress_date_time
long ll_null

setnull(ll_null)
ldt_progress_date_time = datetime(today(), now())

if not vial_created then
	// If we're in edit mode and the user exits through the "I'll Be Back"
	// button, then mark the parent treatment as "Not Ready"
	li_sts = f_set_progress(current_patient.cpr_id, &
									"Treatment", &
									parent_treatment_id, &
									"Property", &
									"Vial Definition", &
									"Not Ready", &
									ldt_progress_date_time, &
									ll_null, &
									ll_null, &
									ll_null)
end if




popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cb_cancel from w_svc_generic`cb_cancel within w_svc_allergy_vial_definition
integer weight = 700
end type

type st_title from w_svc_generic`st_title within w_svc_allergy_vial_definition
string text = "Allergy Vial Definition"
end type

type dw_vial from u_dw_pick_list within w_svc_allergy_vial_definition
integer x = 997
integer y = 452
integer width = 1897
integer height = 828
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_vial_definition"
boolean livescroll = false
end type

event selected;call super::selected;
cb_delete.enabled = true

end event

event unselected;call super::unselected;cb_delete.enabled = false


end event

event buttonclicked;call super::buttonclicked;string 	ls_dose
real 		lr_dose
integer li_sts

str_popup popup
str_popup_return popup_return

// If there's a pending change, process it now
accepttext()

if dwo.name = "b_vol" then
	lr_dose = object.dose_amount[row]
	
	if isnull(lr_dose) then lr_dose = 0.00
	popup.realitem = lr_dose
	popup.objectparm = dose_unit
	Openwithparm(w_number, popup)
	popup_return = message.powerobjectparm

	if popup_return.item <> "OK" then 
		object.selected_flag[row] = 0
		return
	end if

	lr_dose = popup_return.realitem
	
	if check_new_dose(row, lr_dose) then
		li_sts = update_dose(row, lr_dose)
	end if
End If

clear_selected()


end event

event itemchanged;call super::itemchanged;integer li_sts
real lr_dose

if dwo.name = "dose_amount" then
	lr_dose = real(data)
	
	if check_new_dose(row, lr_dose) then
		li_sts = update_dose(row, lr_dose)
	else
		return 1
	end if
End If

clear_selected()

return 0



end event

event losefocus;call super::losefocus;accepttext()

end event

type cb_add_allergen from commandbutton within w_svc_allergy_vial_definition
integer x = 1134
integer y = 220
integer width = 635
integer height = 140
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Allergen"
end type

event clicked;integer li_sts
long		i,ll_row
str_pick_allergens lstr_pick_allergens
str_treatment_description lstr_new_allergen
w_pick_allergens		lw_pick_allergens
str_picked_drugs 	lstr_drugs


lstr_pick_allergens.tests_treatment_type = tests_treatment_type
lstr_pick_allergens.allow_multiple = true
lstr_pick_allergens.title = "Select Allergens for " + service.treatment.treatment_description
OpenWithParm(lw_pick_allergens, lstr_pick_allergens)
lstr_drugs = message.powerobjectparm

if lstr_drugs.drug_count = 0 then return

For i = 1 to lstr_drugs.drug_count
	lstr_new_allergen = f_empty_treatment()
	
	lstr_new_allergen.open_encounter_id = treatment.open_encounter_id
	lstr_new_allergen.drug_id = lstr_drugs.drugs[i].drug_id
	lstr_new_allergen.treatment_description = lstr_drugs.drugs[i].description
	lstr_new_allergen.package_id = lstr_drugs.drugs[i].package_id
	lstr_new_allergen.begin_date = treatment.begin_date
	lstr_new_allergen.dose_unit = dose_unit.unit_id
	lstr_new_allergen.treatment_type = "AllergyVialDefinition"
	lstr_new_allergen.parent_treatment_id = parent_treatment_id
	lstr_new_allergen.ordered_by = current_user.user_id
	lstr_new_allergen.created_by = current_scribe.user_id
	
	li_sts = current_patient.treatments.new_treatment(lstr_new_allergen)
Next

li_sts = load_allergens()

li_sts = load_abnormal_results()

return


end event

type pb_up from u_picture_button within w_svc_allergy_vial_definition
integer x = 2601
integer y = 240
integer width = 137
integer height = 116
integer taborder = 11
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

type pb_down from u_picture_button within w_svc_allergy_vial_definition
integer x = 2757
integer y = 240
integer width = 137
integer height = 116
integer taborder = 21
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

type st_total_vol from statictext within w_svc_allergy_vial_definition
integer x = 2016
integer y = 1392
integer width = 389
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Total Volume :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_allergen from statictext within w_svc_allergy_vial_definition
integer x = 1335
integer y = 1392
integer width = 503
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16776960
long backcolor = 33538240
string text = "Total Allergens :"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_total_allergen from statictext within w_svc_allergy_vial_definition
integer x = 1819
integer y = 1392
integer width = 169
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16776960
long backcolor = 33538240
string text = "0"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_page from statictext within w_svc_allergy_vial_definition
integer x = 2528
integer y = 172
integer width = 357
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99 of 99"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_delete from commandbutton within w_svc_allergy_vial_definition
integer x = 1851
integer y = 220
integer width = 576
integer height = 140
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Delete Allergen"
end type

event clicked;integer					li_sts
string					ls_progress,ls_null
long						ll_null
datetime 				ldt_progress_date_time
integer					li_new_vial
str_popup				popup
str_popup_return 		popup_return
long ll_row
long ll_treatment_id

setnull(ls_null)
setnull(ll_null)
setnull(ldt_progress_date_time)

ll_row = dw_vial.get_selected_row()
if dw_vial.rowcount() = 0 or ll_row = 0 then 
	enabled = false
	return
end if

ll_treatment_id = dw_vial.object.treatment_id[ll_row]

// enter the reason for cancellation
popup.argument_count = 1
popup.argument[1] = "DELETE_ALLERGEN"
popup.title = "Enter the reason:"
Openwithparm(w_pop_prompt_string, popup)
popup_return = Message.powerobjectparm
If popup_return.item_count = 1 then
	ls_progress = popup_return.items[1]
else
	return
End if
	
// Prompt once more to make sure
openwithparm(w_pop_yes_no, "Are you sure you wish to cancel this allergen?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return 0

li_sts = f_set_progress(current_patient.cpr_id, &
								"Treatment", &
								ll_treatment_id, &
								'CANCELLED', &
								ls_null, &
								ls_progress, &
								ldt_progress_date_time, &
								ll_null, &
								ll_null, &
								ll_null)

li_sts = load_abnormal_results( )

li_sts = load_allergens( )

enabled = false


end event

type st_diluent from statictext within w_svc_allergy_vial_definition
integer x = 997
integer y = 1284
integer width = 1897
integer height = 88
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Diluent"
boolean border = true
boolean focusrectangle = false
end type

type st_diluent_amount from statictext within w_svc_allergy_vial_definition
integer x = 2455
integer y = 1292
integer width = 274
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "0.00"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_text from statictext within w_svc_allergy_vial_definition
integer x = 1015
integer y = 384
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Allergen"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_volume_title from statictext within w_svc_allergy_vial_definition
integer x = 2313
integer y = 384
integer width = 521
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Volume"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_5 from statictext within w_svc_allergy_vial_definition
integer x = 997
integer y = 372
integer width = 1897
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type dw_abnormal_results from u_dw_pick_list within w_svc_allergy_vial_definition
integer x = 187
integer y = 300
integer width = 613
integer height = 908
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_sp_abnormal_results_for_assmnt_small"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_svc_allergy_vial_definition
integer x = 82
integer y = 1380
integer width = 55
integer height = 64
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "*"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_vol from statictext within w_svc_allergy_vial_definition
integer x = 2423
integer y = 1384
integer width = 439
integer height = 92
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "0.00"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string 	ls_dose
integer li_sts
real lr_last_total_volume
datetime ldt_progress_date_time
str_popup popup
str_popup_return popup_return
long ll_null

setnull(ll_null)
setnull(ldt_progress_date_time)

lr_last_total_volume = total_volume

popup.realitem = total_volume
popup.objectparm = dose_unit
Openwithparm(w_number, popup)
popup_return = message.powerobjectparm

if popup_return.item <> "OK" then return

total_volume = popup_return.realitem

// If the total_volume didn't change then just return
if total_volume = lr_last_total_volume then return

// If the new total volume doesn't pass the check then warn the user
if not check_doses() then
	openwithparm(w_pop_message, "With the modified total volume, one or more of the allergen volumes is invalid.  You must make the allergen volumes valid before leaving this screen.")
end if

// If we get here then we have a new total volume


st_vol.text = dose_unit.pretty_amount_unit(total_volume)

li_sts = f_set_progress(current_patient.cpr_id, &
								"Treatment", &
								parent_treatment_id, &
								"Modify", &
								"dose_amount", &
								dose_unit.pretty_amount(total_volume), &
								ldt_progress_date_time, &
								ll_null, &
								ll_null, &
								ll_null)
treatment.dose_amount = total_volume


actual_volume()


end event

type st_6 from statictext within w_svc_allergy_vial_definition
integer x = 105
integer y = 1376
integer width = 763
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "= Allergen Already in Vial"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_vial_schedule from statictext within w_svc_allergy_vial_definition
integer x = 585
integer y = 1484
integer width = 741
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Standard"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_null
datetime 		ldt_null

setnull(ldt_null)
setnull(ll_null)
setnull(ll_null)

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "Vial Schedule"
popup.add_blank_row = true
popup.blank_text = "<Custom Schedule>"

openwithparm(w_pop_pick, popup)

popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	// Call progress note edit to get the comments
	popup.data_row_count = 3
	popup.items[1] = "ALLERGY_CUSTOM_SCHEDULE"
	popup.items[2] = "ALLERGY_CUSTOM_SCHEDULE"
	if custom_schedule then
		popup.items[3] = vial_schedule
	else
		popup.items[3] = ""
	end if
	
	Openwithparm(w_progress_note_edit,popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count = 0 then return
	
	vial_schedule = popup_return.items[1]
	li_sts = f_set_progress(current_patient.cpr_id, &
									"Treatment", &
									parent_treatment_id, &
									"Property", &
									"Vial Schedule", &
									vial_schedule, &
									ldt_null, &
									ll_null, &
									ll_null, &
									ll_null)
	text = "<Custom Schedule>"
	custom_schedule = true
else
	if vial_schedule <> popup_return.items[1] then
		vial_schedule = popup_return.items[1]
		li_sts = f_set_progress(current_patient.cpr_id, &
										"Treatment", &
										parent_treatment_id, &
										"Property", &
										"Vial Schedule", &
										vial_schedule, &
										ldt_null, &
										ll_null, &
										ll_null, &
										ll_null)
		text = vial_schedule
	end if
end if


end event

type st_schedule_title from statictext within w_svc_allergy_vial_definition
integer x = 283
integer y = 1496
integer width = 288
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Schedule:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_frequency from statictext within w_svc_allergy_vial_definition
integer x = 1714
integer y = 1484
integer width = 741
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "1X/WEEK"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
datetime ldt_progress_date_time
long ll_null

setnull(ldt_progress_date_time)
setnull(ll_null)

popup.dataobject = "dw_administer_frequency"
popup.datacolumn = 1
popup.displaycolumn = 4

openwithparm(w_pop_pick, popup)

popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if text <> popup_return.items[1] then
	li_sts = f_set_progress(current_patient.cpr_id, &
									"Treatment", &
									parent_treatment_id, &
									"Modify", &
									"administer_frequency", &
									popup_return.items[1], &
									ldt_progress_date_time, &
									ll_null, &
									ll_null, &
									ll_null)
	text = popup_return.items[1]
	treatment.administer_frequency = popup_return.items[1]
end if


end event

type st_frequency_title from statictext within w_svc_allergy_vial_definition
integer x = 1399
integer y = 1496
integer width = 297
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
string text = "Frequency:"
alignment alignment = right!
boolean focusrectangle = false
end type

type tab_results from u_tab_allergy_abnormal_results within w_svc_allergy_vial_definition
integer x = 23
integer y = 136
integer width = 965
integer height = 1240
integer taborder = 20
boolean bringtotop = true
end type

type st_vial_created from statictext within w_svc_allergy_vial_definition
boolean visible = false
integer x = 1120
integer y = 124
integer width = 681
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 65280
long backcolor = 33538240
string text = "FS Vial Already Craeted"
alignment alignment = center!
boolean focusrectangle = false
end type

