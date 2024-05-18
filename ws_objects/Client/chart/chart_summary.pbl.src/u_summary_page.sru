$PBExportHeader$u_summary_page.sru
forward
global type u_summary_page from u_cpr_page_base
end type
type st_more from statictext within u_summary_page
end type
type st_no_outstanding_services from statictext within u_summary_page
end type
type pb_service_1 from u_picture_button within u_summary_page
end type
type pb_service_2 from u_picture_button within u_summary_page
end type
type pb_service_3 from u_picture_button within u_summary_page
end type
type st_service_button_1 from statictext within u_summary_page
end type
type st_service_button_2 from statictext within u_summary_page
end type
type st_service_button_3 from statictext within u_summary_page
end type
type st_other_services_title from statictext within u_summary_page
end type
type st_services_title from statictext within u_summary_page
end type
type st_button_6 from statictext within u_summary_page
end type
type st_button_5 from statictext within u_summary_page
end type
type st_button_4 from statictext within u_summary_page
end type
type st_button_3 from statictext within u_summary_page
end type
type st_button_2 from statictext within u_summary_page
end type
type st_button_1 from statictext within u_summary_page
end type
type pb_6 from u_picture_button within u_summary_page
end type
type pb_3 from u_picture_button within u_summary_page
end type
type pb_2 from u_picture_button within u_summary_page
end type
type pb_5 from u_picture_button within u_summary_page
end type
type pb_1 from u_picture_button within u_summary_page
end type
type pb_4 from u_picture_button within u_summary_page
end type
type st_2 from statictext within u_summary_page
end type
type dw_problems from u_dw_pick_list within u_summary_page
end type
type st_allergy_title from statictext within u_summary_page
end type
type st_procs_title from statictext within u_summary_page
end type
type dw_procs from u_dw_pick_list within u_summary_page
end type
type st_encounters_title from statictext within u_summary_page
end type
type ln_1 from line within u_summary_page
end type
type ln_2 from line within u_summary_page
end type
type st_current_title from statictext within u_summary_page
end type
type dw_allergies from u_dw_pick_list within u_summary_page
end type
type st_this_encounter_title from statictext within u_summary_page
end type
type st_followup_title from statictext within u_summary_page
end type
type dw_followup from u_dw_pick_list within u_summary_page
end type
type dw_encounters from u_dw_pick_list within u_summary_page
end type
type rte_this_encounter from u_rich_text_edit within u_summary_page
end type
end forward

global type u_summary_page from u_cpr_page_base
st_more st_more
st_no_outstanding_services st_no_outstanding_services
pb_service_1 pb_service_1
pb_service_2 pb_service_2
pb_service_3 pb_service_3
st_service_button_1 st_service_button_1
st_service_button_2 st_service_button_2
st_service_button_3 st_service_button_3
st_other_services_title st_other_services_title
st_services_title st_services_title
st_button_6 st_button_6
st_button_5 st_button_5
st_button_4 st_button_4
st_button_3 st_button_3
st_button_2 st_button_2
st_button_1 st_button_1
pb_6 pb_6
pb_3 pb_3
pb_2 pb_2
pb_5 pb_5
pb_1 pb_1
pb_4 pb_4
st_2 st_2
dw_problems dw_problems
st_allergy_title st_allergy_title
st_procs_title st_procs_title
dw_procs dw_procs
st_encounters_title st_encounters_title
ln_1 ln_1
ln_2 ln_2
st_current_title st_current_title
dw_allergies dw_allergies
st_this_encounter_title st_this_encounter_title
st_followup_title st_followup_title
dw_followup dw_followup
dw_encounters dw_encounters
rte_this_encounter rte_this_encounter
end type
global u_summary_page u_summary_page

type variables
integer this_encounter_vital_display_count = 6
integer history_vital_display_count = 4

string history1_category
string history2_category

string procedure_service
string procedure_treatment_types[]

string button_type[]
string button_key[]

u_picture_button button[]
statictext button_title[]

str_menu menu
integer menu_button_count
integer max_button_count = 6
long button_x

u_ds_data patient_services
u_picture_button service_button[]
statictext service_button_title[]
integer service_button_count
integer max_service_button_count = 3

string this_encounter_report_service
string summary_report_id
long summary_display_script_id


end variables

forward prototypes
public function integer refresh_problems ()
public function string med_sig (u_component_treatment puo_med)
public function integer refresh_followup ()
public function integer refresh_allergies ()
public function integer refresh_procedures ()
public subroutine refresh_outstanding_services ()
public subroutine service_button_pressed (integer pi_button)
public function integer refresh_recent_encounters ()
public subroutine refresh ()
public subroutine paint_buttons ()
public subroutine button_pressed (integer pi_button)
public function integer refresh_this_encounter ()
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
end prototypes

public function integer refresh_problems ();Long									ll_row
Integer								li_sts
long ll_rows
long ll_lastrow

ll_rows = dw_problems.retrieve(current_patient.cpr_id, "SICK")
if ll_rows <= 0 then
	ll_row = dw_problems.insertrow(0)
	dw_problems.object.assessment[ll_row] = "<No Problems>"
	dw_problems.object.more_rows.visible = false
else
	ll_lastrow = long(dw_problems.object.datawindow.lastrowonpage)
	if ll_lastrow < ll_rows then
		dw_problems.object.more_rows.visible = true
	else
		dw_problems.object.more_rows.visible = false
	end if
end if

return 1



end function

public function string med_sig (u_component_treatment puo_med);integer i, li_count
string ls_duration
string ls_description
string ls_specialty_id
string ls_unit_description, ls_plural_flag
string ls_procedure_description
string ls_in_office_flag
string ls_theraputic_flag
string ls_goal
string ls_temp
integer li_sts
real lr_admin
u_unit luo_unit
str_drug_definition lstr_drug
str_package_definition lstr_package
str_drug_package lstr_drug_package
string ls_null

setnull(ls_null)

li_sts = drugdb.get_drug_package(puo_med.drug_id, puo_med.package_id, lstr_drug, lstr_package, lstr_drug_package)
if li_sts <= 0 then
	log.log(this, "u_summary_page.med_sig:0023", "error getting drug/package definition", 4)
	return ls_null
end if

ls_description += lstr_drug.common_name

if isnull(puo_med.dose_amount) then
	ls_description += " -- REVIEW"
else
	if lstr_drug_package.take_as_directed = "N" then
		if lstr_package.dose_amount > 0 then
			lr_admin = puo_med.dose_amount * lstr_package.administer_per_dose / lstr_package.dose_amount
			ls_temp = f_pretty_amount_unit(lr_admin, lstr_package.administer_unit)
		else
			luo_unit = unit_list.find_unit(puo_med.dose_unit)
			if not isnull(luo_unit) then
				ls_temp = luo_unit.description
			else
				setnull(ls_temp)
			end if
		end if

		if not isnull(ls_temp) then
			ls_description += "  " + ls_temp
		end if
		
		// administer_method is no longer part of the package 
//		ls_temp = lower(lstr_package.administer_method)
//		if not isnull(ls_temp) then
//			ls_description += " " + ls_temp
//		end if
		
		if not isnull(puo_med.administer_frequency) then
			ls_description += " " + puo_med.administer_frequency
		end if
	else
		ls_description += "  Take As Directed"
	end if
end if

return trim(ls_description)

end function

public function integer refresh_followup ();integer li_sts
long i
string lsa_treatment_types[]
integer li_count
string ls_temp
long ll_rows
long ll_lastrow
long ll_row
string ls_encounter_date
str_encounter_description lstr_encounter
u_ds_data luo_data

li_sts = current_patient.encounters.last_encounter_of_mode("D", lstr_encounter)
if li_sts <= 0 then return 0

ls_encounter_date = string(lstr_encounter.encounter_date, date_format_string)

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_child_treatments_of_types_list")
dw_procs.settransobject(sqlca)

li_count = 0

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "FOLLOWUP")
f_parse_string(ls_temp,";",lsa_treatment_types)

dw_followup.Setredraw(False)
dw_followup.Reset()

ll_rows = luo_data.retrieve(current_patient.cpr_id, lstr_encounter.encounter_id, lsa_treatment_types)

for i = 1 to ll_rows
	ll_row = dw_followup.insertrow(0)
	dw_followup.object.heading[i] = ls_encounter_date
	dw_followup.object.description[i] = luo_data.object.treatment_description[i]
next

if ll_rows <= 0 then
	ll_row = dw_followup.insertrow(0)
	dw_followup.object.description[ll_row] = "<No Followup Items>"
	dw_followup.object.more_rows.visible = false
else
	ll_lastrow = long(dw_followup.object.datawindow.lastrowonpage)
	if ll_lastrow < ll_rows then
		dw_followup.object.more_rows.visible = true
	else
		dw_followup.object.more_rows.visible = false
	end if
end if

dw_followup.sort()
dw_followup.groupcalc()
dw_followup.setredraw(true)

DESTROY luo_data

return 1


end function

public function integer refresh_allergies ();Long									ll_row
Integer								li_sts
long ll_rows
long ll_lastrow

ll_rows = dw_allergies.retrieve(current_patient.cpr_id, "ALLERGY")
if ll_rows <= 0 then
	ll_row = dw_allergies.insertrow(0)
	dw_allergies.object.assessment[ll_row] = "<No Allergies>"
	dw_allergies.object.more_rows.visible = false
else
	ll_lastrow = long(dw_problems.object.datawindow.lastrowonpage)
	if ll_lastrow < ll_rows then
		dw_allergies.object.more_rows.visible = true
	else
		dw_allergies.object.more_rows.visible = false
	end if
end if

return 1



end function

public function integer refresh_procedures ();long i
integer li_count
string ls_temp
long ll_rows
long ll_lastrow
long ll_row
integer li_interval_amount
string ls_interval_unit
datetime ldt_from_date
dw_procs.settransobject(sqlca)
string ls_amount

li_count = 0
ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "PROCEDURES")
f_parse_string(ls_temp,";",procedure_treatment_types)

li_interval_amount = 0

//for i = 1 to this_section.page[this_page].param_count
//	if this_section.page[this_page].param[i].param1 = "PROCEDURES_INTERVAL" then
//		li_interval_amount = integer(this_section.page[this_page].param[i].param2)
//		ls_interval_unit = this_section.page[this_page].param[i].param3
//	end if
//next

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "INTERVAL")
if not isnull(ls_temp) then
	f_split_string(ls_temp, " ", ls_amount, ls_interval_unit)
	ls_interval_unit = trim(ls_interval_unit)
	li_interval_amount = integer(trim(ls_amount))
end if

if isnull(li_interval_amount) or li_interval_amount <= 0 then
	li_interval_amount = 99
	ls_interval_unit = "YEAR"
end if

// Subtract the interval from today
ldt_from_date = datetime(f_add_interval(today(), -li_interval_amount, ls_interval_unit), time(""))

ll_rows = dw_procs.retrieve(current_patient.cpr_id, procedure_treatment_types, ldt_from_date)

if ll_rows <= 0 then
	ll_row = dw_procs.insertrow(0)
	dw_procs.object.treatment_description[ll_row] = "<No Procedures>"
	dw_procs.object.more_rows.visible = false
else
	ll_lastrow = long(dw_procs.object.datawindow.lastrowonpage)
	if ll_lastrow < ll_rows then
		dw_procs.object.more_rows.visible = true
	else
		dw_procs.object.more_rows.visible = false
	end if
end if

return 1

end function

public subroutine refresh_outstanding_services ();string ls_button_title
integer i
string ls_temp
long ll_count
long ll_patient_workplan_item_id

st_more.visible = false
st_no_outstanding_services.visible = false

ll_count = patient_services.retrieve(current_patient.cpr_id, current_user.user_id)


if ll_count <= 0 then
	service_button_count = 0
	st_no_outstanding_services.visible = true
elseif ll_count <= max_service_button_count then
	service_button_count = ll_count
else
	service_button_count = max_service_button_count
	st_more.visible = true
end if

// Now initialize the six service_buttons
for i = 1 to service_button_count
	service_button[i].picturename = patient_services.object.button[i]
	service_button[i].visible = true
	
	ls_button_title = patient_services.object.description[i]
	if isnull(ls_button_title) or trim(ls_button_title) = "" then
		ls_button_title = patient_services.object.service_description[i]
	end if
	service_button_title[i].text = ls_button_title
	service_button_title[i].visible = true
next

for i = service_button_count + 1 to max_service_button_count
	service_button[i].visible = false
	service_button_title[i].visible = false
next


end subroutine

public subroutine service_button_pressed (integer pi_button);integer li_index
integer li_sts
long ll_patient_workplan_item_id

if pi_button >= 1 and pi_button <= service_button_count then
	ll_patient_workplan_item_id = patient_services.object.patient_workplan_item_id[pi_button]
	service_list.do_service(ll_patient_workplan_item_id)
end if

refresh()





end subroutine

public function integer refresh_recent_encounters ();long i
integer li_encounters
str_encounter_description lstra_encounters[]
long ll_row
long ll_rows
long ll_lastrow
string ls_find

dw_encounters.setredraw(false)
dw_encounters.reset()

ls_find = "indirect_flag='D'"
li_encounters = current_patient.encounters.encounter_list(ls_find, lstra_encounters)

// Insert the encounters in reverse order so the latest is on top
for i = li_encounters to 1 step -1
	ll_row = dw_encounters.insertrow(0)
	dw_encounters.object.item_date[ll_row] = lstra_encounters[i].encounter_date
	dw_encounters.object.description[ll_row] = lstra_encounters[i].description	
next

ll_rows = dw_encounters.rowcount()
if ll_rows <= 0 then
	ll_row = dw_encounters.insertrow(0)
	dw_encounters.object.description[ll_row] = "<No Appointments>"
	dw_encounters.object.more_rows.visible = false
else
	ll_lastrow = long(dw_encounters.object.datawindow.lastrowonpage)
	if ll_lastrow < ll_rows then
		dw_encounters.object.more_rows.visible = true
	else
		dw_encounters.object.more_rows.visible = false
	end if
end if

dw_encounters.setredraw(true)

return 1

end function

public subroutine refresh ();Integer li_sts


li_sts = refresh_problems()
li_sts = refresh_allergies()
//li_sts = refresh_medications()
li_sts = refresh_this_encounter()
li_sts = refresh_followup()
li_sts = refresh_recent_encounters()
//li_sts = refresh_subjective()
//li_sts = refresh_vitals()
li_sts = refresh_procedures()

refresh_outstanding_services()


end subroutine

public subroutine paint_buttons ();integer i
boolean lb_remainder
string ls_temp

lb_remainder = false

if isnull(menu.menu_id) then
	menu_button_count = 0
elseif menu.menu_item_count <= max_button_count then
	menu_button_count = menu.menu_item_count
else
	menu_button_count = max_button_count - 1
	lb_remainder = true
end if

// Now initialize the six buttons
for i = 1 to menu_button_count
	button[i].picturename = menu.menu_item[i].button
	button[i].visible = true
	button_title[i].text = menu.menu_item[i].button_title
	button_title[i].visible = true
next

if lb_remainder then
	ls_temp = datalist.get_preference("PREFERENCES", "menu_remainder_button", "button21.bmp")
	button[max_button_count].picturename = ls_temp
	button[max_button_count].visible = true
	button_title[max_button_count].text = "Other Items"
	button_title[max_button_count].visible = true
else
	for i = menu_button_count + 1 to 6
		button[i].visible = false
		button_title[i].visible = false
	next
end if


end subroutine

public subroutine button_pressed (integer pi_button);integer li_index
integer li_sts
str_attributes lstr_attributes
lstr_attributes.attribute_count = 0

if pi_button <= menu_button_count then
	li_sts = f_do_menu_item(menu.menu_id, menu.menu_item[pi_button].menu_item_id)
else
	li_sts = f_display_menu_remainder(menu.menu_id, false, menu_button_count + 1, lstr_attributes)
end if

refresh()





end subroutine

public function integer refresh_this_encounter ();long ll_display_script_id

ll_display_script_id = long(this_section.get_attribute(this_section.page[this_page].page_id, "this_encounter_display_script_id"))

// Skip if no open encounter
if isnull(current_service) then return 0
if isnull(current_service.encounter_id) then return 0

rte_this_encounter.setredraw(false)
rte_this_encounter.clear_rtf()
rte_this_encounter.display_encounter(current_service.encounter_id, ll_display_script_id)
rte_this_encounter.goto_top()
rte_this_encounter.setredraw(true)

return 1

end function

public subroutine initialize (u_cpr_section puo_section, integer pi_page);integer i
string ls_temp

this_section = puo_section
this_page = pi_page

this_section.load_params(this_page)

dw_problems.settransobject(sqlca)

dw_allergies.settransobject(sqlca)

ls_temp = this_section.get_attribute(this_section.page[this_page].page_id, "menu_id")
if isnull(ls_temp) then
	setnull(menu.menu_id)
else
	menu = datalist.get_menu(long(ls_temp))
end if

summary_report_id = this_section.get_attribute(this_section.page[this_page].page_id, "summary_report_id")
if isnull(summary_report_id) then summary_report_id = "{4B657EFA-AB67-482B-9FAB-1764440DF116}"

summary_display_script_id = long(this_section.get_attribute(this_section.page[this_page].page_id, "summary_display_script_id"))
if isnull(summary_display_script_id) then summary_display_script_id = long(datalist.get_preference("PREFERENCES", "default_encounter_display_script_id"))


this_encounter_report_service = this_section.get_attribute(this_section.page[this_page].page_id, "this_encounter_report_service")
if isnull(this_encounter_report_service) then this_encounter_report_service = "REPORT"

procedure_service = this_section.get_attribute(this_section.page[this_page].page_id, "procedure_service")
if isnull(procedure_service) then procedure_service = "RESULTS_BY_TREATMENT"

// Put the buttons in an array so we can reference them by an index
button[1] = pb_1
button[2] = pb_2
button[3] = pb_3
button[4] = pb_4
button[5] = pb_5
button[6] = pb_6

button_title[1] = st_button_1
button_title[2] = st_button_2
button_title[3] = st_button_3
button_title[4] = st_button_4
button_title[5] = st_button_5
button_title[6] = st_button_6

// Put the service_buttons in an array so we can reference them by an index
patient_services = CREATE u_ds_data
patient_services.set_dataobject("dw_sp_get_patient_services")

service_button[1] = pb_service_1
service_button[2] = pb_service_2
service_button[3] = pb_service_3

service_button_title[1] = st_service_button_1
service_button_title[2] = st_service_button_2
service_button_title[3] = st_service_button_3


paint_buttons()

real lr_x_factor
real lr_y_factor

lr_x_factor = width / 2875
lr_y_factor = height / 1272

f_resize_objects(control, lr_x_factor, lr_y_factor, false, true)

end subroutine

on u_summary_page.create
int iCurrent
call super::create
this.st_more=create st_more
this.st_no_outstanding_services=create st_no_outstanding_services
this.pb_service_1=create pb_service_1
this.pb_service_2=create pb_service_2
this.pb_service_3=create pb_service_3
this.st_service_button_1=create st_service_button_1
this.st_service_button_2=create st_service_button_2
this.st_service_button_3=create st_service_button_3
this.st_other_services_title=create st_other_services_title
this.st_services_title=create st_services_title
this.st_button_6=create st_button_6
this.st_button_5=create st_button_5
this.st_button_4=create st_button_4
this.st_button_3=create st_button_3
this.st_button_2=create st_button_2
this.st_button_1=create st_button_1
this.pb_6=create pb_6
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_5=create pb_5
this.pb_1=create pb_1
this.pb_4=create pb_4
this.st_2=create st_2
this.dw_problems=create dw_problems
this.st_allergy_title=create st_allergy_title
this.st_procs_title=create st_procs_title
this.dw_procs=create dw_procs
this.st_encounters_title=create st_encounters_title
this.ln_1=create ln_1
this.ln_2=create ln_2
this.st_current_title=create st_current_title
this.dw_allergies=create dw_allergies
this.st_this_encounter_title=create st_this_encounter_title
this.st_followup_title=create st_followup_title
this.dw_followup=create dw_followup
this.dw_encounters=create dw_encounters
this.rte_this_encounter=create rte_this_encounter
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_more
this.Control[iCurrent+2]=this.st_no_outstanding_services
this.Control[iCurrent+3]=this.pb_service_1
this.Control[iCurrent+4]=this.pb_service_2
this.Control[iCurrent+5]=this.pb_service_3
this.Control[iCurrent+6]=this.st_service_button_1
this.Control[iCurrent+7]=this.st_service_button_2
this.Control[iCurrent+8]=this.st_service_button_3
this.Control[iCurrent+9]=this.st_other_services_title
this.Control[iCurrent+10]=this.st_services_title
this.Control[iCurrent+11]=this.st_button_6
this.Control[iCurrent+12]=this.st_button_5
this.Control[iCurrent+13]=this.st_button_4
this.Control[iCurrent+14]=this.st_button_3
this.Control[iCurrent+15]=this.st_button_2
this.Control[iCurrent+16]=this.st_button_1
this.Control[iCurrent+17]=this.pb_6
this.Control[iCurrent+18]=this.pb_3
this.Control[iCurrent+19]=this.pb_2
this.Control[iCurrent+20]=this.pb_5
this.Control[iCurrent+21]=this.pb_1
this.Control[iCurrent+22]=this.pb_4
this.Control[iCurrent+23]=this.st_2
this.Control[iCurrent+24]=this.dw_problems
this.Control[iCurrent+25]=this.st_allergy_title
this.Control[iCurrent+26]=this.st_procs_title
this.Control[iCurrent+27]=this.dw_procs
this.Control[iCurrent+28]=this.st_encounters_title
this.Control[iCurrent+29]=this.ln_1
this.Control[iCurrent+30]=this.ln_2
this.Control[iCurrent+31]=this.st_current_title
this.Control[iCurrent+32]=this.dw_allergies
this.Control[iCurrent+33]=this.st_this_encounter_title
this.Control[iCurrent+34]=this.st_followup_title
this.Control[iCurrent+35]=this.dw_followup
this.Control[iCurrent+36]=this.dw_encounters
this.Control[iCurrent+37]=this.rte_this_encounter
end on

on u_summary_page.destroy
call super::destroy
destroy(this.st_more)
destroy(this.st_no_outstanding_services)
destroy(this.pb_service_1)
destroy(this.pb_service_2)
destroy(this.pb_service_3)
destroy(this.st_service_button_1)
destroy(this.st_service_button_2)
destroy(this.st_service_button_3)
destroy(this.st_other_services_title)
destroy(this.st_services_title)
destroy(this.st_button_6)
destroy(this.st_button_5)
destroy(this.st_button_4)
destroy(this.st_button_3)
destroy(this.st_button_2)
destroy(this.st_button_1)
destroy(this.pb_6)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_5)
destroy(this.pb_1)
destroy(this.pb_4)
destroy(this.st_2)
destroy(this.dw_problems)
destroy(this.st_allergy_title)
destroy(this.st_procs_title)
destroy(this.dw_procs)
destroy(this.st_encounters_title)
destroy(this.ln_1)
destroy(this.ln_2)
destroy(this.st_current_title)
destroy(this.dw_allergies)
destroy(this.st_this_encounter_title)
destroy(this.st_followup_title)
destroy(this.dw_followup)
destroy(this.dw_encounters)
destroy(this.rte_this_encounter)
end on

type cb_configure_tab from u_cpr_page_base`cb_configure_tab within u_summary_page
end type

type st_more from statictext within u_summary_page
boolean visible = false
integer x = 2642
integer y = 436
integer width = 201
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "More..."
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer button_pressed
integer li_sts
window lw_pop_buttons
integer i
string ls_button_title
long ll_patient_workplan_item_id

popup.button_count = 0

for i = max_service_button_count + 1 to patient_services.rowcount()
	popup.button_count += 1
	popup.button_icons[popup.button_count] = patient_services.object.button[i]
	ls_button_title = patient_services.object.description[i]
	if isnull(ls_button_title) or trim(ls_button_title) = "" then
		ls_button_title = patient_services.object.service_description[i]
	end if
	popup.button_helps[popup.button_count] = ls_button_title
	popup.button_titles[popup.button_count] = ls_button_title
next

if popup.button_count > 0 then
	popup.button_count += 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed >= popup.button_count then return 0
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return 0
end if

ll_patient_workplan_item_id = patient_services.object.patient_workplan_item_id[button_pressed + max_service_button_count]
li_sts = service_list.do_service(ll_patient_workplan_item_id)

refresh()

end event

type st_no_outstanding_services from statictext within u_summary_page
boolean visible = false
integer x = 2021
integer y = 216
integer width = 722
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "No Outstanding Services"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_service_1 from u_picture_button within u_summary_page
boolean visible = false
integer x = 1961
integer y = 100
integer taborder = 10
string picturename = ""
string disabledname = ""
end type

event clicked;service_button_pressed(1)

end event

type pb_service_2 from u_picture_button within u_summary_page
boolean visible = false
integer x = 2267
integer y = 100
integer taborder = 20
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;service_button_pressed(2)

end event

type pb_service_3 from u_picture_button within u_summary_page
boolean visible = false
integer x = 2574
integer y = 100
integer taborder = 30
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;service_button_pressed(3)

end event

type st_service_button_1 from statictext within u_summary_page
boolean visible = false
integer x = 1961
integer y = 316
integer width = 247
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
alignment alignment = center!
boolean focusrectangle = false
end type

type st_service_button_2 from statictext within u_summary_page
boolean visible = false
integer x = 2267
integer y = 316
integer width = 247
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
alignment alignment = center!
boolean focusrectangle = false
end type

type st_service_button_3 from statictext within u_summary_page
boolean visible = false
integer x = 2574
integer y = 316
integer width = 247
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
alignment alignment = center!
boolean focusrectangle = false
end type

type st_other_services_title from statictext within u_summary_page
integer x = 1947
integer y = 484
integer width = 882
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
string text = "Other Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_services_title from statictext within u_summary_page
integer x = 1943
integer y = 12
integer width = 882
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
string text = "Outstanding Services"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_button_6 from statictext within u_summary_page
integer x = 2574
integer y = 1132
integer width = 247
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
alignment alignment = center!
boolean focusrectangle = false
end type

type st_button_5 from statictext within u_summary_page
integer x = 2267
integer y = 1132
integer width = 247
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
alignment alignment = center!
boolean focusrectangle = false
end type

type st_button_4 from statictext within u_summary_page
integer x = 1961
integer y = 1132
integer width = 247
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
alignment alignment = center!
boolean focusrectangle = false
end type

type st_button_3 from statictext within u_summary_page
integer x = 2574
integer y = 784
integer width = 247
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
alignment alignment = center!
boolean focusrectangle = false
end type

type st_button_2 from statictext within u_summary_page
integer x = 2267
integer y = 784
integer width = 247
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
alignment alignment = center!
boolean focusrectangle = false
end type

type st_button_1 from statictext within u_summary_page
integer x = 1961
integer y = 784
integer width = 247
integer height = 112
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_6 from u_picture_button within u_summary_page
integer x = 2574
integer y = 916
integer taborder = 80
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(6)

end event

type pb_3 from u_picture_button within u_summary_page
integer x = 2574
integer y = 568
integer taborder = 70
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(3)

end event

type pb_2 from u_picture_button within u_summary_page
integer x = 2267
integer y = 568
integer taborder = 120
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(2)

end event

type pb_5 from u_picture_button within u_summary_page
integer x = 2267
integer y = 916
integer taborder = 130
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(5)

end event

type pb_1 from u_picture_button within u_summary_page
integer x = 1961
integer y = 568
integer taborder = 140
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(1)

end event

type pb_4 from u_picture_button within u_summary_page
integer x = 1961
integer y = 916
integer taborder = 150
boolean originalsize = false
string picturename = ""
string disabledname = ""
end type

event clicked;button_pressed(4)

end event

type st_2 from statictext within u_summary_page
integer x = 32
integer y = 76
integer width = 882
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Problems"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_problems from u_dw_pick_list within u_summary_page
integer x = 37
integer y = 144
integer width = 882
integer height = 368
integer taborder = 100
boolean bringtotop = true
string dataobject = "dw_problem_list_small"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;str_attributes lstr_attributes
string ls_service

ls_service = "PROBLEMS"

service_list.do_service(current_patient.cpr_id, &
								current_patient.open_encounter_id, &
								ls_service, &
								lstr_attributes)


refresh_problems()

end event

type st_allergy_title from statictext within u_summary_page
integer x = 32
integer y = 520
integer width = 882
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Allergies"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_procs_title from statictext within u_summary_page
integer x = 32
integer y = 852
integer width = 882
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Labs && Procedures"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_procs from u_dw_pick_list within u_summary_page
integer x = 37
integer y = 920
integer width = 882
integer height = 328
integer taborder = 90
boolean bringtotop = true
string dataobject = "dw_treatments_of_types_list_small"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
str_attributes lstr_attributes
integer i

popup.data_row_count = upperbound(procedure_treatment_types)
for i = 1 to popup.data_row_count
	popup.items[i] = datalist.treatment_type_description(procedure_treatment_types[i])
next
popup.auto_singleton = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

lstr_attributes.attribute_count = 1
lstr_attributes.attribute[1].attribute = "treatment_type"
lstr_attributes.attribute[1].value = procedure_treatment_types[popup_return.item_indexes[1]]

service_list.do_service(procedure_service, lstr_attributes)

end event

type st_encounters_title from statictext within u_summary_page
integer x = 983
integer y = 448
integer width = 882
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
string text = "Past Appointments"
alignment alignment = center!
boolean focusrectangle = false
end type

type ln_1 from line within u_summary_page
integer linethickness = 8
integer beginx = 951
integer endx = 951
integer endy = 1272
end type

type ln_2 from line within u_summary_page
integer linethickness = 8
integer beginx = 1902
integer beginy = 4
integer endx = 1902
integer endy = 1276
end type

type st_current_title from statictext within u_summary_page
integer x = 32
integer y = 4
integer width = 882
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
string text = "Current Status"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_allergies from u_dw_pick_list within u_summary_page
integer x = 37
integer y = 592
integer width = 882
integer height = 232
integer taborder = 60
boolean bringtotop = true
string dataobject = "dw_problem_list_small"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;str_attributes lstr_attributes
string ls_service

ls_service = "ASSESSMENT_LIST"

service_list.do_service(current_patient.cpr_id, &
								current_patient.open_encounter_id, &
								ls_service, &
								lstr_attributes)


refresh_allergies()

end event

type st_this_encounter_title from statictext within u_summary_page
integer x = 983
integer y = 12
integer width = 882
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
string text = "This Encounter"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_followup_title from statictext within u_summary_page
integer x = 983
integer y = 844
integer width = 882
integer height = 68
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 7191717
boolean enabled = false
string text = "Pending Followups"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_followup from u_dw_pick_list within u_summary_page
integer x = 983
integer y = 920
integer width = 882
integer height = 328
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_group_heading_list_small"
borderstyle borderstyle = styleraised!
end type

type dw_encounters from u_dw_pick_list within u_summary_page
integer x = 983
integer y = 524
integer width = 882
integer height = 304
integer taborder = 50
boolean bringtotop = true
string dataobject = "dw_dated_list_small"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;str_popup popup
str_popup_return popup_return
str_attributes lstr_attributes
w_window_base lw_window

popup.title = "Past Appointments"
popup.data_row_count = 2
popup.items[1] = current_patient.cpr_id
popup.items[2] = "SHOW"
openwithparm(lw_window, popup, "w_encounter_list_pick", f_getparentwindow(this))
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return


end event

type rte_this_encounter from u_rich_text_edit within u_summary_page
integer x = 983
integer y = 88
integer width = 882
integer height = 340
integer taborder = 110
borderstyle borderstyle = styleraised!
end type

event field_clicked;call super::field_clicked;str_attributes lstr_attributes

lstr_attributes.attribute_count = 4
lstr_attributes.attribute[1].attribute = "report_id"
lstr_attributes.attribute[1].value = summary_report_id
lstr_attributes.attribute[2].attribute = "display_script_id"
lstr_attributes.attribute[2].value = string(summary_display_script_id)
lstr_attributes.attribute[3].attribute = "encounter_id"
lstr_attributes.attribute[3].value = string(current_patient.open_encounter_id)
lstr_attributes.attribute[4].attribute = "destination"
lstr_attributes.attribute[4].value = "SCREEN"

service_list.do_service(this_encounter_report_service, lstr_attributes)

// Set the focus somewhere else so the lbuttondown event doesn't
// get triggered again
dw_problems.setfocus()

end event

