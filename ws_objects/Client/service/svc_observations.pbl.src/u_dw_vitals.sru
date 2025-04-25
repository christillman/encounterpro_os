$PBExportHeader$u_dw_vitals.sru
forward
global type u_dw_vitals from u_dw_pick_list
end type
type str_vital_observation from structure within u_dw_vitals
end type
end forward

type str_vital_observation from structure
	string		description
	string		observation_id
	string		location
	integer		result_sequence
	string		location_2
	integer		result_sequence_2
	string		collection_location_domain
end type

global type u_dw_vitals from u_dw_pick_list
integer width = 2135
integer height = 1424
string dataobject = "dw_vitals"
event source_connected ( u_component_observation puo_observation )
event source_disconnected ( u_component_observation puo_observation )
end type
global u_dw_vitals u_dw_vitals

type variables
string vitals_unit_preference

u_component_service service
u_component_treatment treatment

string parent_observation_id
long parent_observation_sequence
long stage

u_component_observation sources[]
integer source_count

u_ds_observation_results results

string result_type = "PERFORM"

boolean first_time = true


end variables

forward prototypes
public subroutine shutdown ()
public subroutine load (string ps_unit_preference)
public function long observation_sequence (long pl_row)
public function integer get_collection_location (integer pl_row)
public subroutine load (long pl_parent_observation_sequence, string ps_unit_preference)
public function integer initialize (u_component_service puo_service, string ps_unit_preference)
public function integer results_posted (u_component_observation puo_external_observation)
protected function integer update_row (long pl_row, string ps_which, string ps_display_value)
public function integer refresh_row (long pl_row)
public function string get_perform_location (integer pl_row)
public function integer update_row (long pl_row, integer pi_result_sequence, string ps_new_value, string ps_new_value_unit, datetime pdt_result_date_time, string ps_abnormal_flag, string ps_abnormal_nature)
public subroutine refresh ()
end prototypes

event source_connected;string ls_find
long ll_row
long ll_rows

ll_rows = rowcount()

ls_find = "external_source='" + puo_observation.external_source + "'"
ll_row = find(ls_find, 1, ll_rows)
DO WHILE ll_row > 0 and ll_row <= ll_rows
	object.connected[ll_row] = "Y"
	
	ll_row = find(ls_find, ll_row + 1, ll_rows + 1)
LOOP


end event

event source_disconnected;string ls_find
long ll_row
long ll_rows

ll_rows = rowcount()

ls_find = "external_source='" + puo_observation.external_source + "'"
ll_row = find(ls_find, 1, ll_rows)
DO WHILE ll_row > 0 and ll_row <= ll_rows
	object.connected[ll_row] = "N"
	
	ll_row = find(ls_find, ll_row + 1, ll_rows + 1)
LOOP


end event

public subroutine shutdown ();f_destroy_observation_sources(source_count, sources)

end subroutine

public subroutine load (string ps_unit_preference);load(parent_observation_sequence, ps_unit_preference)

end subroutine

public function long observation_sequence (long pl_row);long ll_observation_sequence
string ls_observation_id
integer li_child_ordinal
string ls_observation_tag

ll_observation_sequence = object.observation_sequence[pl_row]
if isnull(ll_observation_sequence) then
	// We don't have an observation record yet, so create one
	ls_observation_id = object.observation_id[pl_row]
	li_child_ordinal = object.child_ordinal[pl_row]
	ls_observation_tag = object.observation_tag[pl_row]
	ll_observation_sequence = treatment.add_observation(parent_observation_sequence, &
										ls_observation_id, &
										li_child_ordinal, &
										ls_observation_tag, &
										stage, &
										true)
	if ll_observation_sequence < 0 then
		log.log(this, "u_dw_vitals.observation_sequence:0019", "Error adding observation", 4)
		return -1
	end if
	object.observation_sequence[pl_row] = ll_observation_sequence
end if

return ll_observation_sequence

end function

public function integer get_collection_location (integer pl_row);long ll_observation_sequence
integer li_sts
str_popup popup
str_popup_return popup_return
string ls_location
string ls_location_domain
long ll_rows

ll_observation_sequence = observation_sequence(pl_row)
ls_location_domain = object.collection_location_domain[pl_row]

popup.dataobject = "dw_location_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = ls_location_domain
popup.auto_singleton = true
popup.add_blank_row = true
popup.blank_text = "<None>"
openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,u_dw_vitals.get_collection_location:21")
if popup_return.item_count <> 1 then return 0

ls_location = popup_return.items[1]

if ls_location = "" then
	setnull(ls_location)
	li_sts = treatment.remove_collection_results(ll_observation_sequence)
else
	// Get the observation_sequence
	if ll_observation_sequence < 0 then
		log.log(this, "u_dw_vitals.get_collection_location:0032", "Error adding observation", 4)
		return -1
	end if

	li_sts = treatment.add_collection_result(ll_observation_sequence, ls_location)
	if li_sts <= 0 then return -1
end if


ll_rows = results.retrieve(current_patient.cpr_id, treatment.treatment_id)
refresh_row(pl_row)

return 1

end function

public subroutine load (long pl_parent_observation_sequence, string ps_unit_preference);integer li_count
long i
long ll_null
string ls_result
string ls_result_amount_flag
long ll_rows
string ls_null

setnull(ll_null)
setnull(ls_null)

parent_observation_sequence = pl_parent_observation_sequence

ll_rows = results.retrieve(current_patient.cpr_id, treatment.treatment_id)

vitals_unit_preference = ps_unit_preference

li_count = rowcount()

for i = 1 to li_count
	object.observation_sequence[i] = ll_null
	object.result[i] = ""
	object.result_2[i] = ""
	object.observation[i] = ""
	object.location_description[i] = ""
	object.severity_bitmap[i] = ls_null
	refresh_row(i)
	
	// Set the result_amount_flag to "Y" if there is
	// already a value in the database so it doesn't
	// get overridden by an external source
	ls_result_amount_flag = object.result_amount_flag[i]
	if ls_result_amount_flag = "Y" then
		ls_result = object.result[i]
	else
		ls_result = object.observation[i]
	end if
	if first_time then
		if not isnull(ls_result) and ls_result <> "" then
			object.manual_override[i] = "Y"
		else
			object.manual_override[i] = "N"
		end if
	end if
next

first_time = false



end subroutine

public function integer initialize (u_component_service puo_service, string ps_unit_preference);string ls_amount
long ll_row
integer i, j
u_unit luo_unit
integer li_child_ordinal
string ls_display_unit
string ls_display_unit_id
str_c_observation_result lstr_result_1
str_c_observation_result lstr_result_2
string ls_observation_id
integer li_result_sequence
integer li_result_sequence_2
string ls_collection_location_domain
string ls_perform_location_domain
string ls_external_observation
str_observation_tree lstr_tree
string ls_tree_unit_preference
string ls_unit_preference
string ls_display_mask
string ls_null

setnull(ls_null)

service = puo_service

if isnull(service.treatment) then
	log.log(this, "u_dw_vitals.initialize:0027", "Null treatment object", 4)
	return -1
end if

treatment = service.treatment

vitals_unit_preference = ps_unit_preference

parent_observation_id = service.root_observation_id()
if isnull(parent_observation_id) then
	log.log(this, "u_dw_vitals.initialize:0037", "No root observation_id", 4)
	return -1
end if

// First, get any applicable external sources and set their display windows
source_count = f_get_observation_sources(parent_observation_id, sources)
for j = 1 to source_count
	sources[j].display_window = parent
next

lstr_tree = datalist.observation_tree(parent_observation_id)

if lstr_tree.branch_count = 0 then
	log.log(this, "u_dw_vitals.initialize:0050", "No children found (" + parent_observation_id + ")", 4)
	return -1
end if

for i = 1 to lstr_tree.branch_count
	ls_observation_id = lstr_tree.branch[i].child_observation_id
	li_result_sequence = lstr_tree.branch[i].result_sequence
	li_result_sequence_2 = lstr_tree.branch[i].result_sequence_2
	ls_collection_location_domain = datalist.observation_collection_location_domain(ls_observation_id)
	ls_perform_location_domain = datalist.observation_perform_location_domain(ls_observation_id)
	ls_tree_unit_preference = lstr_tree.branch[i].unit_preference
	
	ll_row = insertrow(0)
	object.observation_id[ll_row] = ls_observation_id
	object.description[ll_row] = lstr_tree.branch[i].description
	object.location[ll_row] = lstr_tree.branch[i].location
	if not isnull(lstr_tree.branch[i].location) then
		object.perform_location[ll_row] = lstr_tree.branch[i].location
	end if
	object.result_sequence[ll_row] = li_result_sequence
	object.result_sequence_2[ll_row] = li_result_sequence_2
	object.observation_tag[ll_row] = lstr_tree.branch[i].observation_tag
	
	if ls_collection_location_domain <> "NA" then
		object.collection_location_domain[ll_row] = ls_collection_location_domain
	end if
	if ls_perform_location_domain <> "NA" then
		object.perform_location_domain[ll_row] = ls_perform_location_domain
	end if
	object.edit_service[ll_row] = lstr_tree.branch[i].edit_service

	ls_unit_preference = vitals_unit_preference
	if not isnull(li_result_sequence) then
		lstr_result_1 = datalist.observation_result(ls_observation_id, li_result_sequence)
		object.result_amount_flag[ll_row] = lstr_result_1.result_amount_flag
		object.display_mask[ll_row] = lstr_result_1.display_mask
		object.unit_id[ll_row] = lstr_result_1.result_unit
		// If the result has a unit_preference specified, then use it.
		if not isnull(lstr_result_1.unit_preference) then
			object.unit_preference[ll_row] = lstr_result_1.unit_preference
			ls_unit_preference = lstr_result_1.unit_preference
		elseif not isnull(ls_tree_unit_preference) then
			// Otherwise, use the unit_preference specified in the tree, if any.
			object.unit_preference[ll_row] = ls_tree_unit_preference
			ls_unit_preference = ls_tree_unit_preference
		end if
		// Initialize the display unit to the result unit
		object.display_unit_id[ll_row] = lstr_result_1.result_unit
		
		// Then, if it's not null, see if the unit preference changes the display unit
		if not isnull(lstr_result_1.result_unit) then
			luo_unit = unit_list.find_unit(lstr_result_1.result_unit)
			if isnull(luo_unit) then
				log.log(this, "u_dw_vitals.initialize:0103", "result unit not found (" + lstr_result_1.result_unit + ")", 3)
			else
				ls_display_unit = luo_unit.pretty_unit(ls_unit_preference, ls_display_unit_id)
				object.unit[ll_row] = ls_display_unit
				object.display_unit_id[ll_row] = ls_display_unit_id
			end if
		end if
	else
		object.result_amount_flag[ll_row] = "N"
		object.display_unit_id[ll_row] = ls_null
	end if
	
	ls_unit_preference = vitals_unit_preference
	if not isnull(li_result_sequence_2) then
		lstr_result_2 = datalist.observation_result(ls_observation_id, li_result_sequence_2)
		object.result_amount_flag_2[ll_row] = lstr_result_2.result_amount_flag
		object.display_mask_2[ll_row] = lstr_result_2.display_mask
		// If the result has a unit_preference specified, then use it.
		if not isnull(lstr_result_2.unit_preference) then
			object.unit_preference[ll_row] = lstr_result_2.unit_preference
			ls_unit_preference = lstr_result_2.unit_preference
		elseif not isnull(ls_tree_unit_preference) then
			// Otherwise, use the unit_preference specified in the tree, if any.
			object.unit_preference[ll_row] = ls_tree_unit_preference
			ls_unit_preference = ls_tree_unit_preference
		end if
		// Initialize the display unit to the result unit
		object.display_unit_id_2[ll_row] = lstr_result_2.result_unit
		
		// Then, if it's not null, see if the unit preference changes the display unit
		if not isnull(lstr_result_2.result_unit) then
			luo_unit = unit_list.find_unit(lstr_result_2.result_unit)
			if isnull(luo_unit) then
				log.log(this, "u_dw_vitals.initialize:0136", "result unit not found (" + lstr_result_2.result_unit + ")", 3)
			else
				ls_display_unit = luo_unit.pretty_unit(ls_unit_preference, ls_display_unit_id)
				object.unit[ll_row] = ls_display_unit
				object.display_unit_id_2[ll_row] = ls_display_unit_id
			end if
		end if
	else
		object.result_amount_flag_2[ll_row] = "N"
		object.display_unit_id_2[ll_row] = ls_null
	end if
	

	// Calculate the child ordinal by counting how many times the same observation_id appears before this one
	li_child_ordinal = 1
	for j = 1 to i - 1
		if ls_observation_id = lstr_tree.branch[j].child_observation_id then
			li_child_ordinal += 1
		end if
	next
	object.child_ordinal[ll_row] = li_child_ordinal
	
	// Check for an external source
	for j = 1 to source_count
		ls_external_observation = datalist.external_observation(sources[j].external_source, ls_observation_id)
		if not isnull(ls_external_observation) then
			object.external_source[ll_row] = sources[j].external_source
			object.external_source_description[ll_row] = datalist.external_source_description(sources[j].external_source)
			if sources[j].connected then
				object.connected[ll_row] = "Y"
			else
				object.connected[ll_row] = "N"
			end if
			continue
		end if
	next
next
//integer l
//
//l = long(width - 800)
//
//object.observation.width = width - 800
////object.result.width = long(object.result.width) + 100
////object.result_2.width = long(object.result_2.width) + 100
////object.location_description.width =  100
////object.unit.width = long(object.unit.width) + 100
//object.more.x = l + 500

return lstr_tree.branch_count

end function

public function integer results_posted (u_component_observation puo_external_observation);integer i
long ll_rows
string ls_find
integer li_result_sequence
integer li_result_sequence_1
integer li_result_sequence_2
long ll_row
integer j
integer r
string ls_location
string ls_which
long ll_observation_sequence
integer li_sts
string ls_result_amount_flag
string ls_manual_override
str_external_observation_attachment lstr_attachment
str_complete_context lstr_context
str_complete_context lstr_document_context

long ll_rows_affected[]
integer li_affected_count
boolean lb_found
integer k
string ls_observation_id

ll_rows = rowcount()

li_affected_count = 0

// For each observation in received from the external source
for i = 1 to puo_external_observation.observation_count
	
	// Loop through the results
	for j = 1 to puo_external_observation.observations[i].result_count
		// Don't process if it's not the right result type
		if puo_external_observation.observations[i].result[j].result_type <> result_type then continue
		
		// Loop through the id pairs for each result
		for k = 1 to puo_external_observation.observations[i].result[j].id_count
			
			// Get the id values
			ls_observation_id = puo_external_observation.observations[i].result[j].observation_id[k]
			li_result_sequence = puo_external_observation.observations[i].result[j].result_sequence[k]
			
			// Find this observation in the datawindow
			ls_find = "observation_id='" + ls_observation_id + "'"
			ll_row = find(ls_find, 1, ll_rows)
			DO WHILE ll_row > 0 and ll_row <= ll_rows
				// If this row has already been entered manually, then skip it
				ls_manual_override = object.manual_override[ll_row]
				if ls_manual_override = "N" then
					
					// get the result details to see if we have one of these
					ls_location = object.location[ll_row]
					li_result_sequence_1 = object.result_sequence[ll_row]
					li_result_sequence_2 = object.result_sequence_2[ll_row]
				
					// Since we just got results for this row, the external source must be connected
					object.connected[ll_row] = "Y"
					
					ls_result_amount_flag = object.result_amount_flag[ll_row]
					ll_observation_sequence = observation_sequence(ll_row)
					if ll_observation_sequence < 0 then
						log.log(this, "u_dw_vitals.results_posted:0064", "Error adding observation", 4)
						return -1
					end if
			
					if ls_result_amount_flag = "Y" then
						// Make sure the location matches
						if isnull(ls_location) or (puo_external_observation.observations[i].result[j].location = ls_location) then
							// Make sure the new result is either result_sequence or result_sequence_2
							if li_result_sequence = li_result_sequence_1 &
							 or li_result_sequence = li_result_sequence_2 then
								// Post the new result
								update_row(ll_row, &
												li_result_sequence, &
												puo_external_observation.observations[i].result[j].result_value, &
												puo_external_observation.observations[i].result[j].result_unit, &
												puo_external_observation.observations[i].result[j].result_date_time, &
												puo_external_observation.observations[i].result[j].abnormal_flag, &
												puo_external_observation.observations[i].result[j].abnormal_nature)
							end if
						end if
					else
						// If we're not looking for a specific result then just add it
						li_sts = treatment.add_result(ll_observation_sequence, &
																li_result_sequence, &
																puo_external_observation.observations[i].result[j].location, &
																puo_external_observation.observations[i].result[j].result_date_time, &
																puo_external_observation.observations[i].result[j].result_value, &
																puo_external_observation.observations[i].result[j].result_unit, &
																puo_external_observation.observations[i].result[j].abnormal_flag, &
																puo_external_observation.observations[i].result[j].abnormal_nature)
						if li_sts <= 0 then return -1
					end if
					
					// Log this as an affected row
					lb_found = false
					for k = 1 to li_affected_count
						if ll_row = ll_rows_affected[k] then
							lb_found = true
							exit
						end if
					next
					if not lb_found then
						li_affected_count += 1
						ll_rows_affected[li_affected_count] = ll_row
					end if
				end if // Manual override
				
				ll_row = find(ls_find, ll_row + 1, ll_rows + 1)
			LOOP
		next
	next
	
	puo_external_observation.set_processed(puo_external_observation.observations[i].external_item_id, 1)
next

// Empty the observation
puo_external_observation.observation_count = 0

// Now refresh the results datastore and refresh the affected rows
ll_rows = results.retrieve(current_patient.cpr_id, treatment.treatment_id)
for i = 1 to li_affected_count
	refresh_row(ll_rows_affected[i])
next

return 1

end function

protected function integer update_row (long pl_row, string ps_which, string ps_display_value);integer li_result_sequence
string ls_location
string ls_collection_location_domain
string ls_collection_location
datetime ldt_result_date_time
string ls_display_unit_id
string ls_abnormal_flag
string ls_abnormal_nature
integer li_sts
long ll_observation_sequence
string ls_perform_location_domain
string ls_perform_location

// Get the result properties
ls_collection_location_domain = object.collection_location_domain[pl_row]
ls_perform_location_domain = object.perform_location_domain[pl_row]
ls_perform_location = object.perform_location[pl_row]
ls_location = object.location[pl_row]
ls_display_unit_id = object.display_unit_id[pl_row]
setnull(ldt_result_date_time)
setnull(ls_abnormal_flag)
setnull(ls_abnormal_nature)


// First, capture the location if applicable
if not isnull(ls_collection_location_domain) and ls_collection_location_domain <> "NA" and ps_which = "result" then
	if isnull(ps_display_value) or trim(ps_display_value) = "" then
		ll_observation_sequence = observation_sequence(pl_row)
		li_sts = treatment.remove_collection_results(ll_observation_sequence)
		object.location_description[pl_row] = ""
	else
		li_sts = get_collection_location(pl_row)
		if li_sts < 0 then
			log.log(this, "u_dw_vitals.update_row:0034", "Error getting collection location", 4)
			return -1
		end if
	end if
elseif not isnull(ls_perform_location_domain) and ls_perform_location_domain <> "NA" and isnull(ls_location) then
	if isnull(ls_perform_location) then
		ls_perform_location = get_perform_location(pl_row)
		if isnull(ls_perform_location) then
			return 0
		else
			object.perform_location[pl_row] = ls_perform_location
			object.location_description[pl_row] = datalist.location_description(ls_perform_location)
		end if
	end if
end if

// Get the appropriate result_sequence
if ps_which = "result" then
	li_result_sequence = object.result_sequence[pl_row]
elseif ps_which = "result_2" then
	li_result_sequence = object.result_sequence_2[pl_row]
else
	return -1
end if

// The empty string is the same as a null
if ps_display_value = "" then setnull(ps_display_value)

// Now post the new value
return update_row(pl_row, &
						li_result_sequence, &
						ps_display_value, &
						ls_display_unit_id, &
						ldt_result_date_time, &
						ls_abnormal_flag, &
						ls_abnormal_nature )


end function

public function integer refresh_row (long pl_row);integer li_result_sequence
integer li_result_sequence_2
integer li_sts
string ls_result
long ll_observation_sequence
datetime ldt_result_date_time
string ls_result_value
string ls_result_unit
string ls_abnormal_flag
u_unit luo_display_unit
u_unit luo_result_unit
string ls_observation_id
integer li_child_ordinal
string ls_display_unit
string ls_display_unit_id
string ls_result_amount_flag
string ls_observation
string ls_collection_location_description
str_observation_comment lstr_comment
string ls_comment_title
long ll_null
string ls_unit_preference
string ls_display_mask
string ls_location
integer li_count
string ls_collection_location_domain
string ls_perform_location_domain
string ls_perform_location
long ll_row
string ls_temp
integer li_severity
integer li_severity_2
string ls_severity_bitmap

setnull(ll_null)

// See if we have an observation sequence yet
ll_observation_sequence = object.observation_sequence[pl_row]
ls_observation_id = object.observation_id[pl_row]
li_child_ordinal = object.child_ordinal[pl_row]
ls_collection_location_domain = object.collection_location_domain[pl_row]
ls_perform_location_domain = object.perform_location_domain[pl_row]


// Get the tree-specific unit_preference
ls_unit_preference = object.unit_preference[pl_row]
// If the tree doesn't specify a unit preference, then use the Vitals Screen unit preference
if isnull(ls_unit_preference) then ls_unit_preference = vitals_unit_preference


ls_result_amount_flag = object.result_amount_flag[pl_row]
if ls_result_amount_flag = "Y" then
	// If the observation_sequence is null, see if there's one in the treatment component
	if isnull(ll_observation_sequence) then
		ll_row = results.find_observation(parent_observation_sequence, &
																				ls_observation_id, &
																				li_child_ordinal, &
																				stage)
		if ll_row <= 0 then
			setnull(ll_observation_sequence)
		else
			ll_observation_sequence = results.object.observation_sequence[ll_row]
		end if
		object.observation_sequence[pl_row] = ll_observation_sequence
	end if
	
	// Get the display unit id
	ls_display_unit_id = object.display_unit_id[pl_row]
	
	if isnull(ls_display_unit_id) then
		log.log(this, "u_dw_vitals.refresh_row:0071", "Null display unit (" + ls_observation_id + ")", 4)
		return -1
	end if
	
	luo_display_unit = unit_list.find_unit(ls_display_unit_id)
	if isnull(luo_display_unit) then
		log.log(this, "u_dw_vitals.refresh_row:0077", "Invalid display unit (" + ls_display_unit_id + ")", 4)
		return -1
	end if
	
	// Now convert the display unit to the right unit preference and get the "pretty" description
	ls_display_unit = luo_display_unit.pretty_unit(ls_unit_preference, ls_display_unit_id)
	
	// Since the call to pretty_unit() might have changed the display_unit_id, save the current
	// value back to the datawindow and get the new unit object
	object.display_unit_id[pl_row] = ls_display_unit_id
	luo_display_unit = unit_list.find_unit(ls_display_unit_id)
	if isnull(luo_display_unit) then
		log.log(this, "u_dw_vitals.refresh_row:0089", "Invalid display unit (" + ls_display_unit_id + ")", 4)
		return -1
	end if
	
	// And save the display unit "pretty" description back to the datawindow
	if upper(luo_display_unit.print_unit) = "Y" then
		object.unit[pl_row] = ls_display_unit
	elseif luo_display_unit.multiplier > 0 then
		ls_temp = luo_display_unit.major_unit_display_suffix + "-" + luo_display_unit.minor_unit_display_suffix
		object.unit[pl_row] = ls_temp
	else
		object.unit[pl_row] = ""
	end if
	
	// If we didn't find the observation then just clear the display fields
	if isnull(ll_observation_sequence) then
		object.result[pl_row] = ""
		object.result_2[pl_row] = ""
		return 0
	end if
	
	// We found an observation record, so check for a result for the first result_sequence
	li_result_sequence = object.result_sequence[pl_row]
	li_result_sequence_2 = object.result_sequence_2[pl_row]
	ls_location = object.location[pl_row]
	ll_row = results.find_result(ll_observation_sequence, ls_location, li_result_sequence)
	
	setnull(ls_severity_bitmap)
	
	if ll_row <= 0 then
		// If no result then blank the display
		object.result[pl_row] = ""	
	else
		// We found a result so display it
		ls_perform_location = results.object.location[ll_row]
		ldt_result_date_time = results.object.result_date_time[ll_row]
		ls_result_value = results.object.result_value[ll_row]
		ls_result_unit = results.object.result_unit[ll_row]
		ls_abnormal_flag = results.object.abnormal_flag[ll_row]
		li_severity = results.object.severity[ll_row]
		if li_severity > 1 then
			ls_severity_bitmap = 	datalist.domain_item_bitmap( "RESULTSEVERITY", string(li_severity))
		end if
		
		// Store the perform location
		object.perform_location[pl_row] = ls_perform_location
		
		// We found a result, so use the result unit_id to get the display amount
		if isnull(ls_result_unit) then
			log.log(this, "u_dw_vitals.refresh_row:0138", "Null result unit 1 (" + ls_observation_id + ")", 4)
			return -1
		end if
		
		luo_result_unit = unit_list.find_unit(ls_result_unit)
		if isnull(luo_result_unit) then
			log.log(this, "u_dw_vitals.refresh_row:0144", "Invalid unit (" + ls_result_unit + ")", 4)
			return -1
		end if
		
		// First convert from the stored unit to the displayed unit
		ls_display_mask = object.display_mask[pl_row]
		ls_result = luo_result_unit.convert(luo_display_unit.unit_id, ls_result_value,ls_display_mask)
		
		// The put the display amount into the datawindow
		object.result[pl_row] = ls_result
	end if
	
	// If there's not a second result_sequence, then we're done
	if not isnull(li_result_sequence_2) then
		// There is a second result_sequence so check for a second result
		ll_row = results.find_result(ll_observation_sequence, ls_location, li_result_sequence_2)
		
		if ll_row <= 0 then
			// If no result then blank the display
			object.result_2[pl_row] = ""
		else
			// We found a result so display it
			ls_perform_location = results.object.location[ll_row]
			ldt_result_date_time = results.object.result_date_time[ll_row]
			ls_result_value = results.object.result_value[ll_row]
			ls_result_unit = results.object.result_unit[ll_row]
			ls_abnormal_flag = results.object.abnormal_flag[ll_row]
			li_severity_2 = results.object.severity[ll_row]
			if li_severity_2 > li_severity and li_severity_2 > 1 then
				ls_severity_bitmap = 	datalist.domain_item_bitmap( "RESULTSEVERITY", string(li_severity_2))
			end if
			
			// We found the result, so get the corresponding unit object and generate the
			// display amount
			if isnull(ls_result_unit) then
				log.log(this, "u_dw_vitals.refresh_row:0179", "Null result unit 2 (" + ls_observation_id + ")", 4)
				return -1
			end if
			
			luo_result_unit = unit_list.find_unit(ls_result_unit)
			if isnull(luo_result_unit) then
				log.log(this, "u_dw_vitals.refresh_row:0185", "Invalid unit (" + ls_result_unit + ")", 4)
				return -1
			end if
			
			// First convert from the stored unit to the displayed unit
			ls_display_mask = object.display_mask_2[pl_row]
			ls_result = luo_result_unit.convert(luo_display_unit.unit_id, ls_result_value, ls_display_mask)
			
			// The display the 2nd result
			object.result_2[pl_row] = ls_result
		end if
	end if

	// Set the severity bitmap
	object.severity_bitmap[pl_row] = ls_severity_bitmap

	if not isnull(ls_collection_location_domain) and ls_collection_location_domain <> "NA" then
		// Set the collection location description
		li_sts = results.display_observation_sequence(ll_observation_sequence, &
																	"COLLECT", &
																	"N", &
																	true, &
																	ls_collection_location_description)
		object.location_description[pl_row] = ls_collection_location_description
	elseif not isnull(ls_perform_location_domain) and ls_perform_location_domain <> "NA" and isnull(ls_location) then
		ls_perform_location = object.perform_location[pl_row]
		object.location_description[pl_row] = datalist.location_description(ls_perform_location)
	end if
else
	// If the observation_sequence is null, see if there's one in the treatment component
	if isnull(ll_observation_sequence) then
		ll_row = results.find_observation(parent_observation_sequence, &
																				ls_observation_id, &
																				li_child_ordinal, &
																				stage)
		if ll_row <= 0 then
			setnull(ll_observation_sequence)
		else
			ll_observation_sequence = results.object.observation_sequence[ll_row]
		end if
		object.observation_sequence[pl_row] = ll_observation_sequence
	end if
	
	if isnull(ll_observation_sequence) then
		setnull(ls_observation)
	else
		ls_comment_title = object.description[pl_row]
		li_sts = results.display_observation_sequence(ll_observation_sequence, "PERFORM", "N", true, ls_observation)
	end if
	object.observation[pl_row] = ls_observation
end if

return 1


end function

public function string get_perform_location (integer pl_row);long ll_observation_sequence
integer li_sts
str_popup popup
str_popup_return popup_return
string ls_location
string ls_location_domain
string ls_null

setnull(ls_null)

// Get the observation_sequence
ll_observation_sequence = observation_sequence(pl_row)
if isnull(ll_observation_sequence) then return ls_null

ls_location_domain = object.perform_location_domain[pl_row]

popup.dataobject = "dw_location_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = ls_location_domain
popup.auto_singleton = true
openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,u_dw_vitals.get_perform_location:24")
if popup_return.item_count <> 1 then return ls_null

ls_location = popup_return.items[1]

return ls_location


end function

public function integer update_row (long pl_row, integer pi_result_sequence, string ps_new_value, string ps_new_value_unit, datetime pdt_result_date_time, string ps_abnormal_flag, string ps_abnormal_nature);// This method takes a new result value for a particular row
// and, if necessary, converts it to the proper display unit,
// posts it to the datawindow and updates the database

u_unit luo_new_value_unit
u_unit luo_display_unit

string ls_display_value
string ls_display_unit_id
string ls_display_mask
long ll_rows

integer li_sts
long ll_observation_sequence
integer li_result_sequence
string ls_which
string ls_perform_location

// Get the observation_sequence
ll_observation_sequence = observation_sequence(pl_row)
if ll_observation_sequence < 0 then
	log.log(this, "u_dw_vitals.update_row:0022", "Error adding observation", 4)
	return -1
end if

// Get the displayed unit_id
ls_display_unit_id = object.display_unit_id[pl_row]
if isnull(ls_display_unit_id) then
	log.log(this, "u_dw_vitals.update_row:0029", "Null result unit id", 4)
	return -1
end if

// If a unit is not passed in, then assume the display unit
if isnull(ps_new_value_unit) then ps_new_value_unit = ls_display_unit_id


// Get the appropriate result_sequence
li_result_sequence = object.result_sequence[pl_row]
if li_result_sequence = pi_result_sequence then
	ls_which = "result"
else
	// result_sequence_1 didn't match so check result_sequence_2
	li_result_sequence = object.result_sequence_2[pl_row]
	if li_result_sequence = pi_result_sequence then
		ls_which = "result_2"
	else
		// neither result matched so just return
		return 0
	end if
end if


// Get the perform location.  If there isn't one then just return
ls_perform_location = object.perform_location[pl_row]
if isnull(ls_perform_location) then return 0

// Get the unit objects
luo_new_value_unit = unit_list.find_unit(ps_new_value_unit)
if isnull(luo_new_value_unit) then
	log.log(this, "u_dw_vitals.update_row:0060", "Error finding new value unit (" + ps_new_value_unit + ")", 4)
	return -1
end if

luo_display_unit = unit_list.find_unit(ls_display_unit_id)
if isnull(luo_display_unit) then
	log.log(this, "u_dw_vitals.update_row:0066", "Error finding new value unit (" + ls_display_unit_id + ")", 4)
	return -1
end if

// If the display_value is null then remove the result
if isnull(ps_new_value) then
	// Add the new value to the database
	li_sts = treatment.remove_result(ll_observation_sequence, &
											li_result_sequence, &
											ls_perform_location)
	if li_sts <= 0 then return -1
else
	// Add the new value to the database
	li_sts = treatment.add_result(ll_observation_sequence, &
											li_result_sequence, &
											ls_perform_location, &
											pdt_result_date_time, &
											ps_new_value, &
											ps_new_value_unit, &
											ps_abnormal_flag, &
											ps_abnormal_nature )
	if li_sts <= 0 then return -1
end if

// Convert for display
//ls_display_mask = object.display_mask[pl_row]
//ls_display_value = luo_new_value_unit.convert(ls_display_unit_id, ps_new_value, ls_display_mask)
//
// Put the new display value in the datawindow
//setitem(pl_row, ls_which, ls_display_value)
//accepttext()

// Refresh row from the database
ll_rows = results.retrieve(current_patient.cpr_id, treatment.treatment_id)
refresh_row(pl_row)


return 1


end function

public subroutine refresh ();long ll_rows

ll_rows = results.retrieve(current_patient.cpr_id, treatment.treatment_id)

load(parent_observation_sequence, vitals_unit_preference)

end subroutine

event itemchanged;call super::itemchanged;
this.function POST update_row(row, dwo.name, data)

return

end event

event losefocus;call super::losefocus;accepttext()

end event

event clicked;integer i
integer li_sts
string ls_service
string ls_value
string ls_new_value
string ls_unit_id
str_popup_return popup_return
str_popup popup
u_unit luo_unit
string ls_collection_location_domain
str_attributes lstr_attributes
long ll_observation_sequence
string ls_observation_id
integer li_child_ordinal
string ls_external_source
string ls_external_source_description
string ls_manual_override
string ls_perform_location_domain
string ls_location
string top_20_code_1
string top_20_code_2
integer li_result_sequence
integer li_result_sequence_2
long ll_null
string ls_observation_tag
string ls_previous_perform_location
string ls_new_perform_location
string ls_display_unit_id
datetime ldt_result_date_time
string ls_abnormal_flag
string ls_abnormal_nature
string ls_result
string ls_result_2
long ll_rows
boolean lb_null_service
boolean lb_found_result
str_amount_unit lstr_amount_unit

str_observation_results lstr_results
str_c_observation_result lstr_result

setnull(ll_null)

accepttext()

if row <= 0 then return

ls_observation_id = object.observation_id[row]
ls_observation_tag = object.observation_tag[row]

ll_observation_sequence = object.observation_sequence[row]

if dwo.name = "more" then
	ls_external_source = object.external_source[row]
	ls_external_source_description = object.external_source_description[row]
	if isnull(ls_external_source_description) then ls_external_source_description = "External Device"
	ls_manual_override = object.manual_override[row]
	if not isnull(ls_external_source) and ls_manual_override = "Y" then
		popup.data_row_count = 2
		popup.items[1] = "Enter Result Manually"
		popup.items[2] = "Get result(s) from " + ls_external_source_description
		openwithparm(w_pop_pick, popup)
		popup_return = f_popup_return("w_pop_pick,u_dw_vitals.clicked:63")
		if popup_return.item_count <> 1 then return
		
		if popup_return.item_indexes[1] = 2 then
			object.manual_override[row] = "N"
			for i = 1 to source_count
				if sources[i].external_source = ls_external_source then sources[i].timer_ding()
			next
			return
		end if
	end if
	
	// Get the 2nd result first, if necessary
	li_result_sequence_2 = object.result_sequence_2[row]
	if not isnull(li_result_sequence_2) then
		ls_unit_id = object.display_unit_id_2[row]
		luo_unit = unit_list.find_unit(ls_unit_id)
		if isnull(luo_unit) then
			log.log(this, "u_dw_vitals:clic", "Error finding unit (" + ls_unit_id + ")", 4)
			return
		end if
		
		ls_value = object.result_2[row]
		top_20_code_1 = ls_observation_id + "|" + string(li_result_sequence_2)
		top_20_code_2 = ""
		lstr_result = datalist.observation_result(ls_observation_id, li_result_sequence_2)
		lstr_amount_unit = luo_unit.get_value_and_unit(ls_value, top_20_code_1, top_20_code_2, false, lstr_result.result)
		ls_new_value = lstr_amount_unit.amount
//		ls_new_value = luo_unit.get_value(ls_value, top_20_code_1, top_20_code_2)
		if ls_value <> ls_new_value &
			or (isnull(ls_value) and not isnull(ls_new_value)) &
			or (isnull(ls_new_value) and not isnull(ls_value)) then
				object.result_2[row] = ls_new_value
				update_row(row, "result_2", ls_new_value)
		end if
	end if

	// Now get the 1st result
	ls_unit_id = object.display_unit_id[row]
	luo_unit = unit_list.find_unit(ls_unit_id)
	if isnull(luo_unit) then
		log.log(this, "u_dw_vitals:clic", "Error finding unit (" + ls_unit_id + ")", 4)
		return
	end if
		
	li_result_sequence = object.result_sequence[row]
	ls_value = object.result[row]
	top_20_code_2 = "ResultPick|" + ls_observation_id + "|" + string(li_result_sequence)
	top_20_code_1 = current_patient.cpr_id + "|" + top_20_code_2
	lstr_result = datalist.observation_result(ls_observation_id, li_result_sequence)
	lstr_amount_unit = luo_unit.get_value_and_unit(ls_value, top_20_code_1, top_20_code_2, false, lstr_result.result)
	ls_new_value = lstr_amount_unit.amount
//	ls_new_value = luo_unit.get_value(ls_value, top_20_code_1, top_20_code_2)
	if ls_value <> ls_new_value &
		or (isnull(ls_value) and not isnull(ls_new_value)) &
		or (isnull(ls_new_value) and not isnull(ls_value)) then
			object.result[row] = ls_new_value
			update_row(row, "result", ls_new_value)
	end if
	object.manual_override[row] = "Y"
elseif dwo.name = "location_description" then
	ls_collection_location_domain = object.collection_location_domain[row]
	ls_perform_location_domain = object.perform_location_domain[row]
	ls_location = object.location[row]
	if not isnull(ls_collection_location_domain) and ls_collection_location_domain <> "NA" then
		li_sts = get_collection_location(row)
	elseif not isnull(ls_perform_location_domain) and ls_perform_location_domain <> "NA" and isnull(ls_location) then
		if isnull(ll_observation_sequence) then
			openwithparm(w_pop_message, "You must enter a result before you select a location.")
			return
		end if
		ls_previous_perform_location = object.perform_location[row]
		ls_new_perform_location = get_perform_location(row)
		if not isnull(ls_new_perform_location) then
			li_result_sequence = object.result_sequence[row]
			li_result_sequence_2 = object.result_sequence_2[row]
			object.location_description[row] = datalist.location_description(ls_new_perform_location)
			if not isnull(ls_previous_perform_location) then
				// Remove prevous result(s)
				if not isnull(li_result_sequence) then
					li_sts = treatment.remove_result(ll_observation_sequence, &
															li_result_sequence, &
															ls_previous_perform_location)
					if li_sts <= 0 then return -1
				end if
				if not isnull(li_result_sequence_2) then
					li_sts = treatment.remove_result(ll_observation_sequence, &
															li_result_sequence_2, &
															ls_previous_perform_location)
					if li_sts <= 0 then return -1
				end if
				
			end if
			// Add new result(s)
			ls_display_unit_id = object.display_unit_id[row]
			setnull(ldt_result_date_time)
			setnull(ls_abnormal_flag)
			setnull(ls_abnormal_nature)
			ls_result = object.result[row]
			ls_result_2 = object.result_2[row]
			
			if not isnull(li_result_sequence) and not isnull(ls_result) then
				li_sts = treatment.add_result(ll_observation_sequence, &
														li_result_sequence, &
														ls_new_perform_location, &
														ldt_result_date_time, &
														ls_result, &
														ls_display_unit_id, &
														ls_abnormal_flag, &
														ls_abnormal_nature )
				if li_sts <= 0 then return -1
			end if
			
			if not isnull(li_result_sequence_2) and not isnull(ls_result_2) then
				li_sts = treatment.add_result(ll_observation_sequence, &
														li_result_sequence_2, &
														ls_new_perform_location, &
														ldt_result_date_time, &
														ls_result_2, &
														ls_display_unit_id, &
														ls_abnormal_flag, &
														ls_abnormal_nature )
				if li_sts <= 0 then return -1
			end if
		end if
	end if
elseif dwo.name = "observation" then
	// Get service to be used to edit observation
	ls_service = object.edit_service[row]
	if isnull(ls_service) then
		ls_service = datalist.get_preference("PREFERENCES", "default_observation_edit_service", "OBSERVATION_COMMENT")
		lb_null_service = true
	else
		lb_null_service = false
	end if
	
	// Make sure we have an observation sequence
	if isnull(ll_observation_sequence) then
		// We don't have an observation record yet, so create one
		li_child_ordinal = object.child_ordinal[row]
		ll_observation_sequence = treatment.add_observation(parent_observation_sequence, &
											ls_observation_id, &
											li_child_ordinal, &
											ls_observation_tag, &
											stage, &
											ls_service, &
											true)
		if ll_observation_sequence < 0 then
			log.log(this, "u_dw_vitals:clic", "Error adding observation", 4)
			return
		end if
		object.observation_sequence[row] = ll_observation_sequence
	end if
	
	// If the user didn't specify a service to handle the click, then see if there
	// are any results to get
	ls_perform_location_domain = object.perform_location_domain[row]
	lb_found_result = false
	if lb_null_service AND isnull(ls_perform_location_domain) then
		lstr_results = datalist.observation_results(ls_observation_id)
		
		for i = 1 to lstr_results.result_count
			if upper(lstr_results.result[i].result_type) = upper(result_type) &
			  AND lstr_results.result[i].result_amount_flag = "Y" then
				treatment.set_result( ll_observation_sequence, &
											lstr_results.result[i].result_sequence, &
											"NA")
				lb_found_result = true
			end if
		next
	end if
	
	if not lb_found_result then
		// Add observation_sequence to attribute list
		lstr_attributes.attribute_count = 3
		lstr_attributes.attribute[1].attribute = "treatment_id"
		lstr_attributes.attribute[1].value = string(treatment.treatment_id)
		lstr_attributes.attribute[2].attribute = "observation_sequence"
		lstr_attributes.attribute[2].value = string(ll_observation_sequence)
		lstr_attributes.attribute[3].attribute = "comment_title"
		lstr_attributes.attribute[3].value = object.description[row]
		
		// Call service with attributes
		li_sts = service_list.do_service( &
													current_patient.cpr_id, &
													current_patient.open_encounter_id, &
													ls_service, &
													treatment, &
													lstr_attributes )
	end if

	
	ll_rows = results.retrieve(current_patient.cpr_id, treatment.treatment_id)
	refresh_row(row)
end if




end event

on u_dw_vitals.create
call super::create
end on

on u_dw_vitals.destroy
call super::destroy
end on

event constructor;call super::constructor;setnull(stage)

results = CREATE u_ds_observation_results
results.set_dataobject("dw_sp_obstree_treatment")

end event

event destructor;call super::destructor;DESTROY u_ds_observation_results

end event

