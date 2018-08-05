$PBExportHeader$u_timed_set_list.sru
forward
global type u_timed_set_list from u_dw_pick_list
end type
end forward

global type u_timed_set_list from u_dw_pick_list
integer width = 736
integer height = 1220
string dataobject = "dw_timed_set_list"
boolean vscrollbar = true
boolean border = false
end type
global u_timed_set_list u_timed_set_list

type variables
boolean hide_roots = false

u_component_service service
u_component_treatment treatment

end variables

forward prototypes
public function long select_set (long pl_row)
public function long select_set ()
public function long new_timed_set ()
public function long initialize (u_component_service puo_service)
public function integer load ()
public function str_p_observation get_observation (long pl_observation_sequence)
end prototypes

public function long select_set (long pl_row);if pl_row <= 0 OR pl_row > rowcount() or isnull(pl_row) then return 0

clear_selected()

object.selected_flag[pl_row] = 1

this.event POST selected(pl_row)

return pl_row

end function

public function long select_set ();long ll_row
string ls_user_id
long i
long ll_rowcount

ll_rowcount = rowcount()

// Find the last row for the user_id
for i = ll_rowcount to 1 step -1
	ls_user_id = object.user_id[i]
	if hide_roots or (ls_user_id = current_user.user_id) then
		clear_selected()
		object.selected_flag[i] = 1
		this.event POST selected(i)
		return i
	end if
next

// If there wasn't one, then add one
ll_row = new_timed_set()

return ll_row

end function

public function long new_timed_set ();long ll_observation_sequence
str_treatment_observation lstra_observations[]
long ll_observation_count
string ls_find
long ll_row
u_user luo_user
string ls_description
string ls_observation_id

ls_observation_id = service.root_observation_id()
ll_observation_sequence = service.treatment.add_root_observation(ls_observation_id, service.observation_tag, service.service, false)
if ll_observation_sequence <= 0 then return -1

ls_find = "observation_sequence=" + string(ll_observation_sequence)
ll_observation_count = treatment.find_observations(ls_find, lstra_observations)
if ll_observation_count <> 1 then return -1

clear_selected()

ll_row = insertrow(0)
object.observation_sequence[ll_row] = lstra_observations[1].observation_sequence
object.user_id[ll_row] = lstra_observations[1].created_by
ls_description = string(lstra_observations[1].created, "hh:mm:ss")
luo_user = user_list.find_user(lstra_observations[1].created_by)
if not isnull(luo_user) then
	ls_description += "  (" + luo_user.user_short_name
end if
object.description[ll_row] = ls_description

object.selected_flag[ll_row] = 1
this.event POST selected(ll_row)

return ll_row

end function

public function long initialize (u_component_service puo_service);
service = puo_service
treatment = service.treatment


return 1

end function

public function integer load ();str_treatment_observation lstra_observations[]
long ll_observation_count
string ls_find
long i
long ll_row
u_user luo_user
string ls_description
string ls_observation_id
long ll_observation_sequence
str_p_observation lstr_observation

ls_observation_id = service.root_observation_id()
ll_observation_sequence = service.get_root_observation()
if isnull(ll_observation_sequence) then
	log.log(this, "u_timed_set_list.load:0015", "root observation not found", 4)
	return -1
end if

// Get the observation structure
lstr_observation = get_observation(ll_observation_sequence)

if isnull(lstr_observation.parent_observation_sequence) then
	// Find the roots which match the observation_id
	ls_find += "isnull(parent_observation_sequence)"
	ls_find += " and observation_id='" + ls_observation_id + "'"
	ll_observation_count = treatment.find_observations(ls_find, lstra_observations)
	
	for i = 1 to ll_observation_count
		ll_row = insertrow(0)
		object.observation_sequence[ll_row] = lstra_observations[i].observation_sequence
		object.user_id[ll_row] = lstra_observations[i].created_by
		ls_description = string(lstra_observations[i].created, "hh:mm:ss")
		luo_user = user_list.find_user(lstra_observations[i].created_by)
		if not isnull(luo_user) then
			ls_description += "  (" + luo_user.user_short_name
		end if
		object.description[ll_row] = ls_description
	next
else
	hide_roots = false
	visible = false
	
	ll_observation_count = 1
	ll_row = insertrow(0)
	object.observation_sequence[ll_row] = ll_observation_sequence
	object.user_id[ll_row] = lstr_observation.created_by
	ls_description = string(lstr_observation.created, "hh:mm:ss")
	luo_user = user_list.find_user(lstr_observation.created_by)
	if not isnull(luo_user) then
		ls_description += "  (" + luo_user.user_short_name
	end if
	object.description[ll_row] = ls_description
end if

return ll_observation_count

end function

public function str_p_observation get_observation (long pl_observation_sequence);
str_p_observation lstr_observation

SELECT cpr_id,
		treatment_id,
		observation_sequence,
		observation_id,
		encounter_id,
		result_expected_date,
		observation_tag,
		abnormal_flag,
		severity,
		composite_flag,
		parent_observation_sequence,
		stage,
		observed_by,
		created,
		created_by
INTO :lstr_observation.cpr_id,
		:lstr_observation.treatment_id,
		:lstr_observation.observation_sequence,
		:lstr_observation.observation_id,
		:lstr_observation.encounter_id,
		:lstr_observation.result_expected_date,
		:lstr_observation.observation_tag,
		:lstr_observation.abnormal_flag,
		:lstr_observation.severity,
		:lstr_observation.composite_flag,
		:lstr_observation.parent_observation_sequence,
		:lstr_observation.stage,
		:lstr_observation.observed_by,
		:lstr_observation.created,
		:lstr_observation.created_by
FROM p_Observation
WHERE cpr_id = :current_patient.cpr_id
AND observation_sequence = :pl_observation_sequence;
if not tf_check() then setnull(lstr_observation.observation_sequence)

return lstr_observation

end function

on u_timed_set_list.create
end on

on u_timed_set_list.destroy
end on

