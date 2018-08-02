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
string ls_unit_description, ls_pretty_fraction, ls_plural_flag
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
	log.log(this, "u_summary_page.med_sig.0023", "error getting drug/package definition", 4)
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
		
		ls_temp = lower(lstr_package.administer_method)
		if not isnull(ls_temp) then
			ls_description += " " + ls_temp
		end if
		
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
	dw_encounters.object.description[ll_row] = "<No Encounters>"
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
boolean enabled = false
string text = "Past Encounters"
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
long backcolor = 33538240
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
long backcolor = 33538240
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
long backcolor = 33538240
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
window lw_parent
w_window_base lw_window
powerobject lo_object
integer li_iterations

// A bug in PowerBuilder is causing the parent window of the w_pop_time_interval popup
// to sometimes be incorrect, which causes encounterpro to freeze when the popup closes.
// This sections attempts to identify the current active window and uses it as the
// parent of the popup
li_iterations = 0
lo_object = getfocus()
DO WHILE isvalid(lo_object) and li_iterations < 20
	if left(lo_object.classname(), 2) = "w_" then
		lw_parent = lo_object
		exit
	end if
	li_iterations += 1
	lo_object = lo_object.getparent()
LOOP

if not isvalid(lw_parent) then
	lw_parent = w_main
end if

popup.title = "Past Encounters"
popup.data_row_count = 2
popup.items[1] = current_patient.cpr_id
popup.items[2] = "SHOW"
openwithparm(lw_window, popup, "w_encounter_list_pick", lw_parent)
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


Start of PowerBuilder Binary Data Section : Do NOT Edit
05u_summary_page.bin 
2F00001800e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000008fffffffe0000000400000005000000060000000700000009fffffffe0000000afffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000300000000000000000000000000000000000000000000000000000000d3878a6001ca361c0000000300000cc00000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000001a0000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000010000087b00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a00000002000000010000000426bd990111dde7d0130041aa7c6650d300000000d3878a6001ca361cd3878a6001ca361c000000000000000000000000fffffffe00000002000000030000000400000005000000060000000700000008000000090000000a0000000b0000000c0000000d0000000e0000000f000000100000001100000012000000130000001400000015000000160000001700000018000000190000001a0000001b0000001c0000001d0000001e0000001f000000200000002100000022fffffffe0000002400000025000000260000002700000028000000290000002a0000002b0000002c0000002d0000002e0000002f000000300000003100000032fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
23ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff005000540036002d003100340036003200390037003100360065003900420072006900750064006c0072006500310020002e0031003b0030003a00430050005c0000fffe0002020526bd990111dde7d0130041aa7c6650d300000001fb8f0821101b01640008ed8413c72e2b000000300000084b0000003a00000100000001d800000101000001e000000102000001e800000103000001f000000104000001f8000001050000020000000106000002080000010700000210000001080000021800000109000002200000010a000002280000010b000002300000010c000002380000010d000002400000010e000002480000010f00000250000001100000025800000111000002600000011200000268000001130000027000000114000002ac00000115000002b400000116000002bc00000117000002c400000118000002cc00000119000002d40000011a000002dc0000011b000002e40000011c000002ec0000011d000002f40000011e000002fc0000011f0000030c0000012000000314000001210000031c0000012200000324000001230000032c0000012400000334000001250000033c0000012600000344000001270000034c0000012800000354000001290000035c0000012a000003640000012b0000036c0000012c000003740000012d0000037c0000012e000003840000012f0000038c0000013000000394000001310000039c00000132000003a800000133000003b000000134000003b800000135000003c000000136000003c800000137000003d000000138000003d800000000000003e0000000030002000000000003000013f200000003000008c900000003000000490000000200000001000000020000000100000002000000010000000b0000000000000002000000000000000b0000ffff0000000b0000ffff0000000200000000000000020000006400000002000000030000000b000000000000000b0000ffff00000002000000000000000b0000ffff0000000b000000000000000800000031505c3a4352474f525c317e4149454854317e414d5458545c7e5458455c302e325c6e694252454d414e4143494454562e0000000000000002000000030000000300002fd00000000300003de000000003000005a000000003000005a000000003000005a000000003000005a000000002000000640000000b000000000000000b0000ffff0000000800000006616972410000006c000000020000000c0000000b000000000000000b000000000000000b000000000000000b0000000000000002000000000000000300ffffff0000000200000000000000020000006400000002000000000000000200000020000000020000000000000002000000140000000200000000000000020000000000000002000000000000000200000000000000020000000000000008000000010000000000000002000000010000000b0000ffff0000000b0000ffff0000000b000000000000000200000000000000020000000100000002000000000000003a00000000000000010001330000000a006c6c61006e75776f32006f640d000001770000007764726f6d7061720065646f00000112000000106d726f66657374617463656c006e6f69000001090000000e65646968656c65736f6974630108006e00090000646500006f6d7469280065640d0000016c00000073656e69696361700074676e000001190000000c656761706772616d00726e69000001070000000d746e6f63636c6f727372616800012d0000000800646e690072746e6500011e00000009006e6f66006d616e74011a0065000c000061700000616d65676e696772010e0062000d00006c6300006863706972646c6930006e6508000001690000006e65646e180062740c000001700000006d656761696772611500746e0a00000170000000776567616874646900010b0000000d00756f6d006f70657365746e6901060072000a00006162000074736b6300656c790000013400000015747865746d61726672616d656c72656b73656e6900012f0000000800646e690074746e650001270000000c006e696c0061707365676e696300010c0000000b006f6f7a006361666d00726f740000010a0000000e65736e696f697472646f6d6e012a0065000e00007266000064656d61617473690065636e000001130000001270737476646c6c656974636972616e6f01030079000c0000735f00006b636f74706f7270013600730010000061700000726f6567746e65696f6974610135006e00170000696600006c646c65746b6e696567726172616d747372656b0001210000000b006e6f6600617469740063696c0000011000000009657a697365646f6d0001050000000c00726f620073726564656c79740001370000000e006761700065697665797473772600656c0a000001610000006e67696c746e656d0001240000000900736162006e696c6501160065000b00006170000065686567746867690001250000000c0078657400636b6274726f6c6f0001230000000e006e6f6600646e7574696c72652200656e0f0000016600000073746e6f6b69727472687465011f0075000900006f6600006973746e1100657a0700000174000000656b6261012b0079000f0000726600006c656d6177656e69687464690001290000000b0061726600
217473656d00656c7900000101000000097478655f78746e6500012000000009006e6f66006c6f62740102006400090000655f00006e657478380079740d0000016600000073746e6f697474650073676e0000011d0000000c6e6972706c6f63740073726f000001170000000c656761706772616d006c6e690000010d000000097765697665646f6d00012c0000000800646e69006c746e6500012e0000000900646e690066746e650131006c00050000657400001c0074780c00000170000000746e69727366666f1b0074650a00000170000000746e69726d6f6f7a0001140000000b0072637300626c6c6f007372610000010400000009676e616c65676175000100000000090065765f006f697372010f006e000d00006c630000697370696e696c62000073670063006100020000000013f2000008c9000000490000000000ffffff0100010100000100010100000064000001000003000100005c3a4330474f5250317e41524548545c7e414d4958545c3154584554302e327e6e69425c454d415c4143495254562e4e03000044002fd000003de0000005a0000005a0000005a0000005a00000006400724105010c6c616900000000ff0000000000ffff000064000000200000001400000000000000000001000000010100010100000020000000dc0000030e0001050000000000000000020000005c000000010000010100010000000100000000009f000000010001000000000000000000000000000000000000ff1050000000000001900000000000412202006c616972000000000000000000000000000000000000000000000000010000000100010000000000000000000000000020006400006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000023000003db000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001400046e01000108dc01b8010d4a16260111011a940170011f0227de0123012c4c01280130ba39960135003e040100000000000000000000000041000000690072006c0061000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e4000000010000040900010000010006002e000000ffffb7000000000000000000000000010000000000000000000000000000000000000000000100000000000000000000000000010000000100010000000100000000000000000000000000000000005400000030000001000000000000000000000000000000000000000000400000000000000100000000000000000000000000000024000000010000010000000000ff1000000000000001900000000000410202006c6169720000000000000000000000000000000000000000000000000000000000000000000000000000000041000000690072006c006100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000005000000000000000002000640000000f00046e01000108dc01b8010d4a16260111011a940170011f0227de0123012c4c01280130ba39960135013e04010900010000010006002e000000ffffb700000000000000000000000000000000000012000000000000000000000000000000000000000000000000004e005b0072006f0061006d005d006c000100000000004e0000003200000000003700000037023702d0023702e000002fa000003da005a0052005a00500800f020000000001000000000000001b00000000000001000000000000000000000000000000000020006c006f00430064006e006e00650065007300000064006f0052006b006300650077006c006c00450020007400780061007200420020006c006f00000064006300530069007200740070004d002000200054006f00420064006c0054000000200077006500430020006e0054004d0054000000200077006500430020006e0054004d00430020006e006f006500640073006e006400650054000000200077006500430020006e0054004d00430020006e006f006500640073006e0064006500450020
2E007400780061007200420020006c006f00000064006c00410065006700690072006e006100420000007300610065006b00760072006c00690065006c004f00200064006c004600200063006100000065006100420068007500750061002000730033003900420000006c00650020006c0054004d00420000007200650069006c0020006e006100530073006e004600200000004200650042006c0072006e0069000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15u_summary_page.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
