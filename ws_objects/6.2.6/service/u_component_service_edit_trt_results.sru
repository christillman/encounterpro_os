HA$PBExportHeader$u_component_service_edit_trt_results.sru
forward
global type u_component_service_edit_trt_results from u_component_service
end type
end forward

global type u_component_service_edit_trt_results from u_component_service
end type
global u_component_service_edit_trt_results u_component_service_edit_trt_results

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();//
// We will get a list of the root observations for this treatment and
// prompt the user to decide which one to edit.  If there is only one root
// then that one will be selected automatically.  If there are no roots, or if
// the selected root has no service then a default service will be ordered.
//
// Once a root has been selected, then the service associated with that root will be ordered.
// If the service value in p_Observation is null, then a configurable default service will be used.
//

long ll_count
string ls_find
str_treatment_observation lstra_observations[]
long ll_root_idx
str_popup popup
str_popup_return popup_return
long i
str_attributes lstr_attributes
integer li_sts
string ls_service
string ls_result_type
string ls_observation_id
string ls_temp

// First make sure we have a treatment
if isnull(treatment) then
	log.log(this, "xx_do_service()", "Null treatment", 4)
	return -1
end if

// Initialize the attributes with the ones passed into this service
lstr_attributes = get_attributes()

ls_observation_id = get_attribute("observation_id")

ls_result_type = get_attribute("result_type")
if isnull(ls_result_type) then ls_result_type = "PERFORM"

// Then get a list of the roots
ls_find = "isnull(parent_observation_sequence)"
if not isnull(ls_observation_id) then
	ls_find += " and observation_id='" + ls_observation_id + "'"
end if

ll_count = treatment.find_observations(ls_find, lstra_observations)

if ll_count < 0 then
	log.log(this, "xx_do_service()", "Error finding roots", 4)
	return -1
elseif ll_count = 0 then
	ll_root_idx = 0
elseif ll_count = 1 then
	ll_root_idx = 1
else
	popup.data_row_count = ll_count
	for i = 1 to ll_count
		popup.items[i] = lstra_observations[i].observation_description
		ls_temp = user_list.user_full_name(lstra_observations[i].observed_by)
		ls_temp += " - " + string(date(lstra_observations[i].created))
		if time(lstra_observations[i].created) > time("00:00:00") then
			ls_temp += " " + string(time(lstra_observations[i].created))
		end if
		if len(ls_temp) > 0 then
			popup.items[i] += " (" + ls_temp + ")"
		end if
	next
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then
		if manual_service then
			return 2
		else
			popup.data_row_count = 2
			popup.items[1] = "Perform this service later"
			popup.items[2] = "Cancel this service"
			openwithparm(w_pop_pick, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count <> 1 then
				return 0
			else
				if popup_return.item_indexes[1] = 1 then
					return 0
				else
					return 2
				end if
			end if
		end if
	end if
	ll_root_idx = popup_return.item_indexes[1]
end if

f_attribute_add_attribute(lstr_attributes, "treatment_id", string(treatment.treatment_id))
f_attribute_add_attribute(lstr_attributes, "result_type", ls_result_type)


if ll_root_idx > 0 then
	ls_service = lstra_observations[ll_root_idx].service
	f_attribute_add_attribute(lstr_attributes, "observation_sequence", string(lstra_observations[ll_root_idx].observation_sequence))
else
	setnull(ls_service)
end if

if isnull(ls_service) then
	ls_service = get_attribute("edit_service")
	if isnull(ls_service) then ls_service = "RESULTS"
end if

// Call service with attributes
li_sts = service_list.do_service( &
											current_patient.cpr_id, &
											encounter_id, &
											ls_service, &
											treatment, &
											lstr_attributes )

if li_sts < 0 then return -1

return 1


end function

on u_component_service_edit_trt_results.create
call super::create
end on

on u_component_service_edit_trt_results.destroy
call super::destroy
end on

