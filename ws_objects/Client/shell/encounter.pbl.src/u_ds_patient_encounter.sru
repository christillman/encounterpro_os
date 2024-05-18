$PBExportHeader$u_ds_patient_encounter.sru
forward
global type u_ds_patient_encounter from u_ds_base_class
end type
end forward

global type u_ds_patient_encounter from u_ds_base_class
string dataobject = "dw_encounter_data"
end type
global u_ds_patient_encounter u_ds_patient_encounter

type variables
string non_deleted_find_string = "(upper(encounter_status)='OPEN' or upper(encounter_status)='CLOSED')"


end variables

forward prototypes
public function integer encounter_id (integer pi_encounter_number)
public function integer delete_encounter (long pl_encounter_id)
public function integer encounter_list (string ps_find, ref long pla_encounter_id[])
public function integer first_encounter ()
public function integer last_encounter ()
public function integer last_encounter_for_user (ref u_str_encounter puo_encounter, string ps_user_id)
public function integer next_encounter ()
public function integer prev_encounter ()
public function integer encounter_number (long pl_encounter_id)
public function integer new_encounter (u_str_encounter puo_encounter)
public function integer refresh_encounter (ref u_str_encounter puo_encounter)
public function integer encounter (ref u_str_encounter puo_encounter, long pl_encounter_id)
public function string encounter_description (long pl_encounter_id)
public function u_attachment_list attachment_list (long pl_encounter_id)
public function integer set_encounter_progress (long pl_encounter_id, string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level, datetime pdt_progress_date_time, u_attachment_list puo_attachment_list)
public function string encounter_type (long pl_encounter_id)
public function integer set_encounter_progress (long pl_encounter_id, string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level)
public function integer modify_encounter (long pl_encounter_id, string ps_encounter_field, string ps_new_value)
public function integer set_encounter_progress (long pl_encounter_id, string ps_progress_type, string ps_progress)
public function integer set_encounter_progress (long pl_encounter_id, string ps_progress_type, string ps_progress_key, string ps_progress)
public function integer encounter (ref str_encounter_description pstr_encounter, long pl_encounter_id)
public function integer update_encounter_object (ref u_str_encounter puo_encounter, long pl_row)
private function str_encounter_description get_encounter_description (long pl_row)
public function datetime encounter_date (long pl_encounter_id)
public function string encounter_status (long pl_encounter_id)
public function boolean is_encounter_open (long pl_encounter_id)
public function string attending_doctor (long pl_encounter_id)
public function integer get_encounters (string ps_find, ref str_encounter_description pstr_encounter[])
public function long find_encounter (long pl_encounter_id)
public function long find_object_row (long pl_object_key)
public function integer last_encounter_of_mode (string ps_indirect_flag, ref str_encounter_description pstr_encounter)
public function str_encounter_description last_encounter (string ps_find)
public function integer set_encounter_progress (long pl_encounter_id, string ps_progress_type)
public function string encounter_new_flag (long pl_encounter_id)
public function str_property_value get_property (long pl_object_key, string ps_property, str_attributes pstr_attributes)
public function integer set_encounter_progress (long pl_encounter_id, string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level, datetime pdt_progress_date_time)
public function integer encounter_count ()
public function integer encounter_list (string ps_find, ref str_encounter_description pstra_encounters[])
end prototypes

public function integer encounter_id (integer pi_encounter_number);
if pi_encounter_number > 0 and pi_encounter_number <= rowcount() then
	return object.encounter_id[pi_encounter_number]
else
	return 0
end if

end function

public function integer delete_encounter (long pl_encounter_id);return set_encounter_progress(pl_encounter_id, "CANCELED")

end function

public function integer encounter_list (string ps_find, ref long pla_encounter_id[]);///////////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer count of encounter_id's in reference array pla_encounter_id[]
//
//	Description:returns an array of long containing the encounter id's of all
//					encounters which satisfied criteria specified in ps_find.
//
// Created By:Mark Copenhaver										Creation dt: 7/10/00
//
// Modified By:															Modified On:
////////////////////////////////////////////////////////////////////////////////////////////


long i
long ll_rows
long ll_row

ll_rows = rowcount()
i = 0

ps_find = "(" + ps_find + ") and (upper(encounter_status) = 'OPEN' or  upper(encounter_status) = 'CLOSED')"

ll_row = find(ps_find, 1, ll_rows)
DO WHILE ll_row > 0 and ll_row <= ll_rows
	i += 1
	pla_encounter_id[i] = object.encounter_id[ll_row]
	ll_row = find(ps_find, ll_row + 1, ll_rows + 1)
LOOP

return i


end function

public function integer first_encounter ();long ll_encounter_id
long ll_row
long ll_rows
string ls_find

ll_rows = rowcount()

if ll_rows <= 0 then return 0

ls_find = "(upper(encounter_status)='OPEN' or upper(encounter_status)='CLOSED')"
ll_row = find(ls_find, 1, ll_rows)
if ll_row > 0 then
	ll_encounter_id = object.encounter_id[ll_row]
	return f_set_current_encounter(ll_encounter_id)
end if

return 0


end function

public function integer last_encounter ();str_encounter_description lstr_encounter
long i
long ll_rows
long ll_row
string ls_find
long ll_encounter_id

ll_rows = rowcount()
i = 0

ls_find = "upper(encounter_status) = 'OPEN' or  upper(encounter_status) = 'CLOSED'"

ll_row = find(ls_find, ll_rows, 1)
if ll_row <= 0 then return 0

ll_encounter_id = object.encounter_id[ll_row]

return f_set_current_encounter(ll_encounter_id)

end function

public function integer last_encounter_for_user (ref u_str_encounter puo_encounter, string ps_user_id);long ll_encounter_id
long ll_row
string ls_find

ls_find = "attending_doctor='" + ps_user_id + "'"

ls_find = "(" + ls_find + ") and (upper(encounter_status) = 'OPEN' or  upper(encounter_status) = 'CLOSED')"

ll_row = find(ls_find, rowcount(), 1)

if ll_row <= 0 then return 0

ll_encounter_id = object.encounter_id[ll_row]

return encounter(puo_encounter, ll_encounter_id)

end function

public function integer next_encounter ();long ll_row
string ls_find
long ll_encounter_id
long ll_rowcount

if isnull(current_display_encounter) or not isvalid(current_display_encounter) then return first_encounter()

ll_rowcount = rowcount()

// First find the current encounter row
ll_row = find_object_row(current_display_encounter.encounter_id)
if ll_row <= 0 then return 0

// Then from there search for a non-deleted encunter
ls_find = "(upper(encounter_status) = 'OPEN' or  upper(encounter_status) = 'CLOSED')"

ll_row = find(ls_find, ll_row + 1, ll_rowcount + 1)
if ll_row > 0 and ll_row <= ll_rowcount then
	ll_encounter_id = object.encounter_id[ll_row]
	return f_set_current_encounter(ll_encounter_id)
end if

return 0


end function

public function integer prev_encounter ();long ll_row
string ls_find
long ll_encounter_id
long ll_rowcount

if isnull(current_display_encounter) or not isvalid(current_display_encounter) then return first_encounter()

ll_rowcount = rowcount()

// First find the current encounter row
ll_row = find_object_row(current_display_encounter.encounter_id)
if ll_row <= 0 then return 0

// Then from there search backwards for a non-deleted encunter
ls_find = "(upper(encounter_status) = 'OPEN' or  upper(encounter_status) = 'CLOSED')"

ll_row = find(ls_find, ll_row - 1, 1)
if ll_row > 0 and ll_row <= ll_rowcount then
	ll_encounter_id = object.encounter_id[ll_row]
	return f_set_current_encounter(ll_encounter_id)
end if

return 0


end function

public function integer encounter_number (long pl_encounter_id);string ls_find
long ll_row
long ll_rowcount
long ll_encounter_number

if isnull(pl_encounter_id) then return 0

ll_encounter_number = 0

ll_rowcount = rowcount()

ll_row = find(non_deleted_find_string, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	ll_encounter_number += 1
	
	if pl_encounter_id = long(object.encounter_id[ll_row]) then return ll_encounter_number
	
	ll_row = find(non_deleted_find_string, ll_row + 1, ll_rowcount + 1)
LOOP

return 0

end function

public function integer new_encounter (u_str_encounter puo_encounter);long ll_row
integer li_sts
string ls_check_encounter_type
integer li_count

ll_row = insertrow(0)

object.cpr_id[ll_row] = current_patient.cpr_id
object.encounter_type[ll_row] = puo_encounter.encounter_type   
object.new_flag[ll_row] = puo_encounter.new_flag
object.encounter_status[ll_row] = puo_encounter.encounter_status   
object.encounter_date[ll_row] = puo_encounter.encounter_date   
object.encounter_description[ll_row] = puo_encounter.encounter_description
object.patient_class[ll_row] = puo_encounter.patient_class   
object.patient_location[ll_row] = puo_encounter.patient_location   
object.next_patient_location[ll_row] = puo_encounter.next_patient_location   
object.admission_type[ll_row] = puo_encounter.admission_type   
object.attending_doctor[ll_row] = puo_encounter.attending_doctor   
object.referring_doctor[ll_row] = puo_encounter.referring_doctor   
object.ambulatory_status[ll_row] = puo_encounter.ambulatory_status   
object.vip_indicator[ll_row] = puo_encounter.vip_indicator   
object.charge_price_ind[ll_row] = puo_encounter.charge_price_ind   
object.courtesy_code[ll_row] = puo_encounter.courtesy_code   
object.discharge_disp[ll_row] = puo_encounter.discharge_disp   
object.discharge_date[ll_row] = puo_encounter.discharge_date   
object.admit_reason[ll_row] = puo_encounter.admit_reason   
object.indirect_flag[ll_row] = puo_encounter.indirect_flag   
object.billing_note[ll_row] = puo_encounter.billing_note
object.bill_flag[ll_row] = puo_encounter.bill_flag
object.billing_hold_flag[ll_row] = puo_encounter.billing_hold_flag
object.encounter_billing_id[ll_row] = puo_encounter.encounter_billing_id
object.office_id[ll_row] = puo_encounter.encounter_office_id
object.created_by[ll_row] = puo_encounter.created_by

// billing posted flag (x -not billed)
if upper(puo_encounter.bill_flag) = "Y" then
	object.billing_posted[ll_row] = "N"
else
	object.billing_posted[ll_row] = "X"
end if

li_sts = update()
if li_sts <= 0 then return -1

puo_encounter.encounter_id = object.encounter_id[ll_row]
If isnull(puo_encounter.encounter_id) Then
	log.log(this, "u_ds_patient_encounter.new_encounter:0047", "encounter_id not generated", 4)
	Return -1
End if

// Double check that this encounter_id matches the one in the database
li_count = 0
SELECT 1
INTO :li_count
FROM p_Patient_Encounter
WHERE cpr_id = :current_patient.cpr_id
AND encounter_id = :puo_encounter.encounter_id
AND encounter_type = :puo_encounter.encounter_type
AND encounter_date = :puo_encounter.encounter_date;
if not tf_check() then return -1
if li_count <> 1 then
	log.log(this, "u_ds_patient_encounter.new_encounter:0062", "Incorrect encounter_id", 1)
	// If we got the wrong encounter_id, then execute a query to find the correct encounter_id
	SELECT max(encounter_id)
	INTO :puo_encounter.encounter_id
	FROM p_Patient_Encounter
	WHERE cpr_id = :current_patient.cpr_id
	AND encounter_type = :puo_encounter.encounter_type
	AND encounter_date = :puo_encounter.encounter_date;
	if not tf_check() then return -1
	if isnull(puo_encounter.encounter_id) then
		log.log(this, "u_ds_patient_encounter.new_encounter:0072", "Unable to determine correct encounter_id", 4)
		return -1
	end if
	object.encounter_id[ll_row] = puo_encounter.encounter_id
	setitemstatus(ll_row, 0, Primary!, NotModified!)
	log.log(this, "u_ds_patient_encounter.new_encounter:0077", "Correct encounter_id found", 1)
end if

// Add the "Created" progress record
set_encounter_progress(puo_encounter.encounter_id, "Created")

return 1
end function

public function integer refresh_encounter (ref u_str_encounter puo_encounter);long ll_row,ll_encounter_id
integer li_sts
string ls_encounter_type

if not isvalid(puo_encounter) or isnull(puo_encounter) then
	log.log(this, "u_ds_patient_encounter.refresh_encounter:0006", "Invalid Appointment Object", 4)
	return -1
end if

if isnull(puo_encounter.encounter_id) then
	log.log(this, "u_ds_patient_encounter.refresh_encounter:0011", "Null Appointment Id", 4)
	return -1
end if

ll_row = find_encounter(puo_encounter.encounter_id)
if isnull(ll_row) then
	log.log(this, "u_ds_patient_encounter.refresh_encounter:0017", "Appointment not found (" + string(puo_encounter.encounter_id) + ")", 4)
	return -1
end if

li_sts = reselectrow(ll_row)
if li_sts < 0 then
	log.log(this, "u_ds_patient_encounter.refresh_encounter:0023", "Error reselecting row (" + string(puo_encounter.encounter_id) + ")", 4)
	return -1
end if
	
update_encounter_object(puo_encounter, ll_row)

puo_encounter.updated = false
puo_encounter.ib_exists = true

return 1


end function

public function integer encounter (ref u_str_encounter puo_encounter, long pl_encounter_id);long ll_row

if isnull(pl_encounter_id) then return 0

puo_encounter = CREATE u_str_encounter

ll_row = find_encounter(pl_encounter_id)
if isnull(ll_row) then return 0

update_encounter_object(puo_encounter, ll_row)

puo_encounter.updated = false
puo_encounter.ib_exists = true

Return 1


end function

public function string encounter_description (long pl_encounter_id);string ls_find
long ll_row
long ll_rowcount
string ls_description
string ls_encounter_type

setnull(ls_description)

if isnull(pl_encounter_id) then return ls_description

ll_rowcount = rowcount()

ls_find = "encounter_id=" + string(pl_encounter_id)
ll_row = find(ls_find, 1, ll_rowcount)

if ll_row <= 0 then return ls_description
	
ls_description = object.encounter_description[ll_row]

if isnull(ls_description) or trim(ls_description) = "" then
	ls_encounter_type = object.encounter_type[ll_row]
	ls_description = datalist.encounter_type_description(ls_encounter_type)
end if

return ls_description

end function

public function u_attachment_list attachment_list (long pl_encounter_id);long ll_row
string ls_find

u_attachment_list luo_attachment_list

if isnull(pl_encounter_id) then
	setnull(luo_attachment_list)
	return luo_attachment_list
end if

ls_find = "encounter_id=" + string(pl_encounter_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row <= 0 then
	setnull(luo_attachment_list)
	return luo_attachment_list
end if

parent_patient.attachments.encounter_attachment_list(luo_attachment_list, pl_encounter_id)
Return luo_attachment_list

end function

public function integer set_encounter_progress (long pl_encounter_id, string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level, datetime pdt_progress_date_time, u_attachment_list puo_attachment_list);string ls_find
long ll_row
string ls_encounter_status
datetime ldt_end_date
long ll_close_encounter_id
long ll_attachment_id
long ll_patient_workplan_item_id
integer li_sts

setnull(ll_attachment_id)
setnull(ll_patient_workplan_item_id)

str_popup	popup
str_popup_return popup_return

if isnull(parent_patient.open_encounter) then
	log.log(this, "u_ds_patient_encounter.set_encounter_progress:0017", "No open appointment", 4)
	return -1
end if

if isnull(pl_encounter_id) or pl_encounter_id <= 0 then
	log.log(this, "u_ds_patient_encounter.set_encounter_progress:0022", "Invalid encounter_id", 4)
	return -1
end if

ls_find = "encounter_id=" + string(pl_encounter_id)
ll_row = find(ls_find, 1, rowcount())
if ll_row <= 0 then
	log.log(this, "u_ds_patient_encounter.set_encounter_progress:0029", "appointment not found", 4)
	return -1
end if

li_sts = f_set_progress(current_patient.cpr_id, &
								"Encounter", &
								pl_encounter_id, &
								ps_progress_type, &
								ps_progress_key, &
								ps_progress, &
								pdt_progress_date_time, &
								pl_risk_level, &
								ll_attachment_id, &
								ll_patient_workplan_item_id)
if li_sts < 0 then return -1

reselectrow(ll_row)
if not isnull(current_display_encounter) then
	if current_display_encounter.encounter_id = pl_encounter_id then
		update_encounter_object(current_display_encounter, ll_row)
	end if
end if


Return 1

end function

public function string encounter_type (long pl_encounter_id);string ls_find
long ll_row
long ll_rowcount
string ls_encounter_type

setnull(ls_encounter_type)

if isnull(pl_encounter_id) then return ls_encounter_type

ll_rowcount = rowcount()

ls_find = "encounter_id=" + string(pl_encounter_id)
ll_row = find(ls_find, 1, ll_rowcount)

if ll_row <= 0 then return ls_encounter_type
	
ls_encounter_type = object.encounter_type[ll_row]

return ls_encounter_type

end function

public function integer set_encounter_progress (long pl_encounter_id, string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level);u_attachment_list luo_attachment_list
datetime ldt_progress_date_time

setnull(luo_attachment_list)
setnull(ldt_progress_date_time)

return set_encounter_progress(pl_encounter_id, ps_progress_type, ps_progress_key, ps_progress, pl_risk_level, ldt_progress_date_time, luo_attachment_list)


end function

public function integer modify_encounter (long pl_encounter_id, string ps_encounter_field, string ps_new_value);u_attachment_list luo_attachment_list
datetime ldt_progress_date_time
string ls_progress_type
long ll_risk_level

setnull(ll_risk_level)
setnull(luo_attachment_list)
setnull(ldt_progress_date_time)

ls_progress_type = "Modify"

return set_encounter_progress(pl_encounter_id, ls_progress_type, ps_encounter_field, ps_new_value, ll_risk_level, ldt_progress_date_time, luo_attachment_list)


end function

public function integer set_encounter_progress (long pl_encounter_id, string ps_progress_type, string ps_progress);u_attachment_list luo_attachment_list
datetime ldt_progress_date_time
string ls_progress_key
long ll_risk_level

setnull(ls_progress_key)
setnull(ll_risk_level)
setnull(luo_attachment_list)
setnull(ldt_progress_date_time)

return set_encounter_progress(pl_encounter_id, ps_progress_type, ls_progress_key, ps_progress, ll_risk_level, ldt_progress_date_time, luo_attachment_list)


end function

public function integer set_encounter_progress (long pl_encounter_id, string ps_progress_type, string ps_progress_key, string ps_progress);u_attachment_list luo_attachment_list
datetime ldt_progress_date_time
long ll_risk_level

setnull(luo_attachment_list)
setnull(ldt_progress_date_time)
setnull(ll_risk_level)

return set_encounter_progress(pl_encounter_id, ps_progress_type, ps_progress_key, ps_progress, ll_risk_level, ldt_progress_date_time, luo_attachment_list)


end function

public function integer encounter (ref str_encounter_description pstr_encounter, long pl_encounter_id);long ll_row

if isnull(pl_encounter_id) then
	setnull(pstr_encounter.encounter_id)
	return 0
end if

ll_row = find_encounter(pl_encounter_id)
if isnull(ll_row) then
	setnull(pstr_encounter.encounter_id)
	return 0
end if

pstr_encounter = get_encounter_description(ll_row)

return 1


end function

public function integer update_encounter_object (ref u_str_encounter puo_encounter, long pl_row);string ls_encounter_type
long ll_encounter_id

puo_encounter.encounter_id = object.encounter_id[pl_row]
puo_encounter.encounter_type = object.encounter_type[pl_row]
puo_encounter.encounter_status = object.encounter_status[pl_row]
puo_encounter.encounter_date = object.encounter_date[pl_row]
puo_encounter.encounter_description = object.encounter_description[pl_row]
puo_encounter.indirect_flag = object.indirect_flag[pl_row]
puo_encounter.patient_class = object.patient_class[pl_row]
puo_encounter.patient_location = object.patient_location[pl_row]
puo_encounter.next_patient_location = object.next_patient_location[pl_row]
puo_encounter.admission_type = object.admission_type[pl_row]
puo_encounter.attending_doctor = object.attending_doctor[pl_row]
puo_encounter.referring_doctor = object.referring_doctor[pl_row]
puo_encounter.supervising_doctor = object.supervising_doctor[pl_row]
puo_encounter.ambulatory_status = object.ambulatory_status[pl_row]
puo_encounter.vip_indicator = object.vip_indicator[pl_row]
puo_encounter.charge_price_ind = object.charge_price_ind[pl_row]
puo_encounter.courtesy_code = object.courtesy_code[pl_row]
puo_encounter.discharge_disp = object.discharge_disp[pl_row]
puo_encounter.discharge_date = object.discharge_date[pl_row]
puo_encounter.admit_reason = object.admit_reason[pl_row]
puo_encounter.new_flag = object.new_flag[pl_row]
puo_encounter.billing_note = object.billing_note[pl_row]
puo_encounter.encounter_billing_id = object.encounter_billing_id[pl_row]
puo_encounter.bill_flag = object.bill_flag[pl_row]
puo_encounter.billing_posted = f_string_to_boolean(string(object.billing_posted[pl_row]))
puo_encounter.billing_hold_flag = object.billing_hold_flag[pl_row]
puo_encounter.encounter_office_id = object.office_id[pl_row]
puo_encounter.created_by = object.created_by[pl_row]
puo_encounter.patient_workplan_id = object.patient_workplan_id[pl_row]

if isnull(puo_encounter.encounter_description) or trim(puo_encounter.encounter_description) = "" then
	ls_encounter_type = object.encounter_type[pl_row]
	puo_encounter.encounter_description = datalist.encounter_type_description(ls_encounter_type)
end if

ll_encounter_id = puo_encounter.encounter_id
parent_patient.attachments.encounter_attachment_list(puo_encounter.attachment_list,ll_encounter_id)
puo_encounter.parent_patient = parent_patient

return 1


end function

private function str_encounter_description get_encounter_description (long pl_row);str_encounter_description lstr_encounter
string ls_encounter_type
boolean lb_default_grant

lstr_encounter.cpr_id = object.cpr_id[pl_row]
lstr_encounter.encounter_id = object.encounter_id[pl_row]
lstr_encounter.encounter_date = object.encounter_date[pl_row]
lstr_encounter.encounter_type = object.encounter_type[pl_row]
lstr_encounter.indirect_flag = object.indirect_flag[pl_row]
lstr_encounter.description = object.encounter_description[pl_row]
lstr_encounter.discharge_date = object.discharge_date[pl_row]
lstr_encounter.attending_doctor = object.attending_doctor[pl_row]
lstr_encounter.referring_doctor = object.referring_doctor[pl_row]
lstr_encounter.supervising_doctor = object.supervising_doctor[pl_row]
lstr_encounter.new_flag = object.new_flag[pl_row]
lstr_encounter.billing_posted = f_string_to_boolean(string(object.billing_posted[pl_row]))
lstr_encounter.encounter_status = object.encounter_status[pl_row]
lstr_encounter.office_id = object.office_id[pl_row]
lstr_encounter.bill_flag = object.bill_flag[pl_row]
lstr_encounter.patient_name = current_patient.name()
lstr_encounter.date_of_birth = current_patient.date_of_birth
lstr_encounter.created = object.created[pl_row]
lstr_encounter.created_by = object.created_by[pl_row]
lstr_encounter.patient_workplan_id = object.patient_workplan_id[pl_row]
lstr_encounter.patient_location = object.patient_location[pl_row]

if isnull(lstr_encounter.description) or trim(lstr_encounter.description) = "" then
	ls_encounter_type = object.encounter_type[pl_row]
	lstr_encounter.description = datalist.encounter_type_description(ls_encounter_type)
end if

if int(object.default_grant[pl_row]) = 0 then
	lb_default_grant = false
else
	lb_default_grant = true
end if
lstr_encounter.access_control_list = current_patient.get_access_control_list( "Encounter", &
																										lstr_encounter.encounter_id, &
																										lb_default_grant)


return lstr_encounter


end function

public function datetime encounter_date (long pl_encounter_id);string ls_find
long ll_row
long ll_rowcount
datetime ldt_encounter_date

setnull(ldt_encounter_date)

if isnull(pl_encounter_id) then return ldt_encounter_date

ll_rowcount = rowcount()

ls_find = "encounter_id=" + string(pl_encounter_id)
ll_row = find(ls_find, 1, ll_rowcount)

if ll_row <= 0 then return ldt_encounter_date
	
ldt_encounter_date = object.encounter_date[ll_row]

return ldt_encounter_date

end function

public function string encounter_status (long pl_encounter_id);string ls_find
long ll_row
long ll_rowcount
string ls_encounter_status

setnull(ls_encounter_status)

if isnull(pl_encounter_id) then return ls_encounter_status

ll_rowcount = rowcount()

ls_find = "encounter_id=" + string(pl_encounter_id)
ll_row = find(ls_find, 1, ll_rowcount)

if ll_row <= 0 then return ls_encounter_status
	
ls_encounter_status = object.encounter_status[ll_row]

return ls_encounter_status

end function

public function boolean is_encounter_open (long pl_encounter_id);string ls_find
long ll_row
long ll_rowcount
string ls_encounter_status

setnull(ls_encounter_status)

if isnull(pl_encounter_id) then return false

ll_rowcount = rowcount()

ls_find = "encounter_id=" + string(pl_encounter_id)
ll_row = find(ls_find, 1, ll_rowcount)

if ll_row <= 0 then return false
	
ls_encounter_status = object.encounter_status[ll_row]

if upper(ls_encounter_status) = "OPEN" then return true

return false

end function

public function string attending_doctor (long pl_encounter_id);string ls_find
long ll_row
long ll_rowcount
string ls_attending_doctor

setnull(ls_attending_doctor)

if isnull(pl_encounter_id) then return ls_attending_doctor

ll_rowcount = rowcount()

ls_find = "encounter_id=" + string(pl_encounter_id)
ll_row = find(ls_find, 1, ll_rowcount)

if ll_row <= 0 then return ls_attending_doctor
	
ls_attending_doctor = object.attending_doctor[ll_row]

return ls_attending_doctor

end function

public function integer get_encounters (string ps_find, ref str_encounter_description pstr_encounter[]);///////////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer count of encounters in reference array pstr_encounter[]
//
//	Description:returns an array of structures containing the 
//					encounters which satisfied criteria specified in ps_find.
//
// Created By:Mark Copenhaver										Creation dt: 7/10/00
//
// Modified By:															Modified On:
////////////////////////////////////////////////////////////////////////////////////////////


long i
long ll_rows
long ll_row

ll_rows = rowcount()
i = 0

ps_find = "(" + ps_find + ") and (upper(encounter_status) = 'OPEN' or  upper(encounter_status) = 'CLOSED')"

ll_row = find(ps_find, 1, ll_rows)
DO WHILE ll_row > 0 and ll_row <= ll_rows
	i += 1
	pstr_encounter[i] = get_encounter_description(ll_row)
	ll_row = find(ps_find, ll_row + 1, ll_rows + 1)
LOOP

return i


end function

public function long find_encounter (long pl_encounter_id);long ll_row
long ll_null
string ls_find
long ll_rows

setnull(ll_null)

if isnull(pl_encounter_id) then return ll_null

ll_rows = rowcount()

ls_find = "encounter_id=" + string(pl_encounter_id)
ll_row = find(ls_find, 1, ll_rows)
if ll_row < 0 then
	return ll_null
elseif ll_row = 0 then
	ll_rows = retrieve(current_patient.cpr_id)
	ll_row = find(ls_find, 1, ll_rows)
	if ll_row <= 0 then
		return ll_null
	else
		return ll_row
	end if
else
	return ll_row
end if

Return ll_null

end function

public function long find_object_row (long pl_object_key);return find_encounter(pl_object_key)

end function

public function integer last_encounter_of_mode (string ps_indirect_flag, ref str_encounter_description pstr_encounter);long ll_encounter_id
long ll_row
long i

ll_row = rowcount()

setnull(ll_encounter_id)

for i = ll_row to 1 step -1
	if object.indirect_flag[i] = ps_indirect_flag then
		ll_encounter_id = object.encounter_id[ll_row]
		exit
	end if
next

if isnull(ll_encounter_id) then
	return 0
else
	return encounter(pstr_encounter, ll_encounter_id)
end if


end function

public function str_encounter_description last_encounter (string ps_find);///////////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Encounter_description structure.  encounter_id field is null if find string didn't match any encounter
//
//	Description:returns a structure of the last encounter which satisfied criteria specified in ps_find.
//
// Created By:Mark Copenhaver										Creation dt: 7/10/00
//
// Modified By:															Modified On:
////////////////////////////////////////////////////////////////////////////////////////////

str_encounter_description lstr_encounter
long i
long ll_rows
long ll_row

ll_rows = rowcount()
i = 0

ps_find = "(" + ps_find + ") and (upper(encounter_status) = 'OPEN' or  upper(encounter_status) = 'CLOSED')"

ll_row = find(ps_find, ll_rows, 1)
if ll_row > 0 then return get_encounter_description(ll_row)

setnull(lstr_encounter.encounter_id)

return lstr_encounter

end function

public function integer set_encounter_progress (long pl_encounter_id, string ps_progress_type);u_attachment_list luo_attachment_list
datetime ldt_progress_date_time
string ls_progress_key
long ll_risk_level
string ls_progress

setnull(ls_progress_key)
setnull(ll_risk_level)
setnull(luo_attachment_list)
setnull(ldt_progress_date_time)
setnull(ls_progress)

return set_encounter_progress(pl_encounter_id, ps_progress_type, ls_progress_key, ls_progress, ll_risk_level, ldt_progress_date_time, luo_attachment_list)


end function

public function string encounter_new_flag (long pl_encounter_id);string ls_find
long ll_row
long ll_rowcount
string ls_encounter_status

setnull(ls_encounter_status)

if isnull(pl_encounter_id) then return ls_encounter_status

ll_rowcount = rowcount()

ls_find = "encounter_id=" + string(pl_encounter_id)
ll_row = find(ls_find, 1, ll_rowcount)

if ll_row <= 0 then return ls_encounter_status
	
ls_encounter_status = object.encounter_status[ll_row]

return ls_encounter_status

end function

public function str_property_value get_property (long pl_object_key, string ps_property, str_attributes pstr_attributes);str_property_value lstr_property_value
long ll_row

setnull(lstr_property_value.value)
setnull(lstr_property_value.display_value)
setnull(lstr_property_value.textcolor)
setnull(lstr_property_value.backcolor)
setnull(lstr_property_value.weight)

ll_row = find_object_row(pl_object_key)
if isnull(ll_row) or ll_row <= 0 then return lstr_property_value

CHOOSE CASE lower(ps_property)
	CASE ""
	CASE ELSE
		lstr_property_value = get_property(pl_object_key, ps_property)
END CHOOSE

return lstr_property_value

end function

public function integer set_encounter_progress (long pl_encounter_id, string ps_progress_type, string ps_progress_key, string ps_progress, long pl_risk_level, datetime pdt_progress_date_time);u_attachment_list luo_attachment_list

setnull(luo_attachment_list)

return set_encounter_progress(pl_encounter_id, ps_progress_type, ps_progress_key, ps_progress, pl_risk_level, pdt_progress_date_time, luo_attachment_list)


end function

public function integer encounter_count ();string ls_find
long ll_row
long ll_rowcount
long ll_encounter_count

ll_encounter_count = 0

ll_rowcount = rowcount()

ll_row = find(non_deleted_find_string, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	ll_encounter_count += 1
	ll_row = find(non_deleted_find_string, ll_row + 1, ll_rowcount + 1)
LOOP

return ll_encounter_count


end function

public function integer encounter_list (string ps_find, ref str_encounter_description pstra_encounters[]);long i
long ll_rows
long ll_row
string ls_find
string ls_encounter_type

ll_rows = rowcount()
i = 0

ls_find = ps_find

ls_find = "(" + ls_find + ") and (upper(encounter_status) = 'OPEN' or  upper(encounter_status) = 'CLOSED')"

ll_row = find(ls_find, 1, ll_rows)
DO WHILE ll_row > 0 and ll_row <= ll_rows
	i += 1
	pstra_encounters[i] = get_encounter_description(ll_row)

	ll_row = find(ls_find, ll_row + 1, ll_rows + 1)
LOOP

return i


end function

on u_ds_patient_encounter.create
call super::create
end on

on u_ds_patient_encounter.destroy
call super::destroy
end on

event constructor;call super::constructor;context_object = "Encounter"

end event

