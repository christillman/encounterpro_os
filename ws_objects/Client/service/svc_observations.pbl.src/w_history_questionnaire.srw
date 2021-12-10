$PBExportHeader$w_history_questionnaire.srw
forward
global type w_history_questionnaire from w_window_base
end type
type st_right_page from statictext within w_history_questionnaire
end type
type st_left_page from statictext within w_history_questionnaire
end type
type pb_left_up from picturebutton within w_history_questionnaire
end type
type pb_left_down from picturebutton within w_history_questionnaire
end type
type pb_right_down from picturebutton within w_history_questionnaire
end type
type pb_right_up from picturebutton within w_history_questionnaire
end type
type cb_done from commandbutton within w_history_questionnaire
end type
type cb_be_back from commandbutton within w_history_questionnaire
end type
type cb_prev from commandbutton within w_history_questionnaire
end type
type cb_next from commandbutton within w_history_questionnaire
end type
type st_right_title from statictext within w_history_questionnaire
end type
type dw_right from u_dw_pick_list within w_history_questionnaire
end type
type dw_left from u_dw_pick_list within w_history_questionnaire
end type
type st_observation_description from statictext within w_history_questionnaire
end type
type st_view_title from statictext within w_history_questionnaire
end type
type cb_view from commandbutton within w_history_questionnaire
end type
type st_title from statictext within w_history_questionnaire
end type
type pb_cancel from u_picture_button within w_history_questionnaire
end type
type pb_done from u_picture_button within w_history_questionnaire
end type
type pb_help from u_pb_help_button within w_history_questionnaire
end type
type cb_edit_observation from commandbutton within w_history_questionnaire
end type
type st_comments from statictext within w_history_questionnaire
end type
type st_new_result from statictext within w_history_questionnaire
end type
end forward

global type w_history_questionnaire from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_right_page st_right_page
st_left_page st_left_page
pb_left_up pb_left_up
pb_left_down pb_left_down
pb_right_down pb_right_down
pb_right_up pb_right_up
cb_done cb_done
cb_be_back cb_be_back
cb_prev cb_prev
cb_next cb_next
st_right_title st_right_title
dw_right dw_right
dw_left dw_left
st_observation_description st_observation_description
st_view_title st_view_title
cb_view cb_view
st_title st_title
pb_cancel pb_cancel
pb_done pb_done
pb_help pb_help
cb_edit_observation cb_edit_observation
st_comments st_comments
st_new_result st_new_result
end type
global w_history_questionnaire w_history_questionnaire

type variables
str_observation_tree_branch branch[]
boolean branch_followon[]
long observation_sequence[]
long question_number

string root_observation_id

string current_view

string current_location
integer current_result_sequence

//u_ds_data c_observation_tree
//u_ds_data c_observation_result
//u_ds_data c_location

u_ds_data p_observation
u_ds_data p_observation_result
u_ds_data p_observation_result_qualifier


u_component_service service

long result_center_x = 750
long result_right_x = 1417


end variables

forward prototypes
public function string branch_child (integer pl_question_number)
public function string branch_parent (integer pl_question_number)
public function string branch_followon (integer pl_question_number)
public function integer add_result (integer pi_result_sequence, string ps_location)
public function integer add_result (integer pi_result_sequence, string ps_location, string ps_result_value, string ps_result_unit)
public function integer result_description (integer pi_result_sequence, string ps_location, ref string ps_description)
public function integer delete_result (integer pi_result_sequence, string ps_location)
public function integer location_description (integer pi_result_sequence, string ps_location, ref string ps_description)
public function boolean is_selected (integer pi_result_sequence, string ps_location)
public function integer get_previous_observation ()
public function boolean is_any_results (string ps_location)
public function boolean is_any_locations (integer pi_result_sequence)
public function integer observation_severity (long pl_observation_sequence)
public function integer find_simple_child ()
public function integer add_observation (long pl_question_number)
public function integer add_branch ()
public function integer display_observation ()
public function integer display_right_side ()
public function integer initialize ()
public function integer get_next_observation ()
end prototypes

public function string branch_child (integer pl_question_number);
// If this is the root, then the child is the root observation
if pl_question_number = 1 then return root_observation_id

if branch_followon[pl_question_number] then
	return branch[pl_question_number].followon_observation_id
else
	return branch[pl_question_number].child_observation_id
end if


end function

public function string branch_parent (integer pl_question_number);return branch[pl_question_number].parent_observation_id

end function

public function string branch_followon (integer pl_question_number);
// If this is the root, then the child is the root observation
if pl_question_number = 1 then return root_observation_id

return branch[pl_question_number].followon_observation_id

end function

public function integer add_result (integer pi_result_sequence, string ps_location);string ls_result_value
string ls_result_amount

setnull(ls_result_value)
setnull(ls_result_amount)

return add_result(pi_result_sequence, ps_location, ls_result_value, ls_result_amount)

end function

public function integer add_result (integer pi_result_sequence, string ps_location, string ps_result_value, string ps_result_unit);string ls_null

setnull(ls_null)

return service.treatment.add_result(observation_sequence[question_number], &
												pi_result_sequence, &
												ps_location, &
												datetime(today(), now()), &
												ps_result_value, &
												ps_result_unit, &
												ls_null, &
												ls_null )

end function

public function integer result_description (integer pi_result_sequence, string ps_location, ref string ps_description);// Returns:		0	No results selected
//					1	Results selected
//					-1 Error

boolean lb_selected
str_c_observation_result lstr_result

lstr_result = datalist.observation_result(branch[question_number].child_observation_id, pi_result_sequence)

ps_description = lstr_result.result

lb_selected = is_selected(pi_result_sequence, ps_location)

if lb_selected then
	return 1
else
	return 0
end if



end function

public function integer delete_result (integer pi_result_sequence, string ps_location);
return service.treatment.remove_result(observation_sequence[question_number], &
													pi_result_sequence, &
													ps_location )

end function

public function integer location_description (integer pi_result_sequence, string ps_location, ref string ps_description);// Returns:		0	No results selected
//					1	Results selected
//					-1 Error

boolean lb_selected

ps_description = datalist.location_description(ps_location)

lb_selected = is_selected(pi_result_sequence, ps_location)

if lb_selected then
	return 1
else
	return 0
end if


end function

public function boolean is_selected (integer pi_result_sequence, string ps_location);long ll_count

SELECT count(*)
INTO :ll_count
FROM p_Observation_Result
WHERE cpr_id = :current_patient.cpr_id
AND observation_sequence = :observation_sequence[question_number]
AND result_sequence = pi_result_sequence
AND location = :ps_location
AND current_flag = 'Y';
if not tf_check() then return false

if ll_count > 0 then return true

return false


end function

public function integer get_previous_observation ();integer li_sts
integer li_backup
long ll_branch_id
string ls_find
long ll_row
string ls_observation_id
string ls_composite_flag

li_backup = 1

DO WHILE li_backup < question_number
	if question_number - li_backup = 1 then
		ls_observation_id = root_observation_id
	else
		ls_observation_id = branch_child(question_number - li_backup)
	end if
	
	ls_composite_flag = datalist.observation_composite_flag(ls_observation_id)
	if ls_composite_flag = "Y" then
		li_backup += 1
		continue
	end if
	EXIT
LOOP

if li_backup < question_number then
	question_number -= li_backup
	return 1
else
	return 0
end if



end function

public function boolean is_any_results (string ps_location);return service.treatment.observation_is_any_results(observation_sequence[question_number], ps_location)

end function

public function boolean is_any_locations (integer pi_result_sequence);return service.treatment.observation_is_any_locations(observation_sequence[question_number], pi_result_sequence)


end function

public function integer observation_severity (long pl_observation_sequence);integer li_max_severity


SELECT max(severity)
INTO :li_max_severity
FROM p_Observation_Result
WHERE cpr_id = :current_patient.cpr_id
AND observation_sequence = :observation_sequence[question_number]
AND current_flag = 'Y';
if not tf_check() then return 0


return li_max_severity

end function

public function integer find_simple_child ();long ll_row
long ll_observation_sequence
string ls_find
integer li_sts
string ls_prev_observation_id
string ls_next_observation_id
string ls_composite_flag
string ls_default_view
long i
string ls_status
long ll_null
str_observation_tree lstr_tree

setnull(ll_null)

if question_number <= 0 then
	log.log(this, "w_history_questionnaire.find_simple_child:0017", "no parent observation", 4)
	return -1
end if

if question_number = 1 then
	ls_prev_observation_id = root_observation_id
else
	ls_prev_observation_id = branch_child(question_number)
end if

ls_composite_flag = datalist.observation_composite_flag(ls_prev_observation_id)

if ls_composite_flag = "Y" then
	// Add a slot for the next question
	question_number += 1
	observation_sequence[question_number] = ll_null
	lstr_tree = datalist.observation_tree(ls_prev_observation_id)
	for i = 1 to lstr_tree.branch_count
		branch[question_number] = lstr_tree.branch[i]
		branch_followon[question_number] = false
		ls_next_observation_id = branch[question_number].child_observation_id
		
		// Now, if the next child is composite, then drill down by recursively calling get_next_observation().
		// Otherwise, we're done so return found.
		ls_composite_flag = datalist.observation_composite_flag(ls_next_observation_id)
		if ls_composite_flag = "Y" then
			li_sts = find_simple_child()
			// If a simple child was found, then return found
			if li_sts = 1 then return 1
		else
			return 1
		end if
	next
	
	// If no simple children found, then return not found
	question_number -= 1
	return 0
else
	// This function should only have been called when the previous observation is composite
	log.log(this, "w_history_questionnaire.find_simple_child:0056", "Prev observation not composite (" + string(branch[question_number].branch_id) + ")", 4)
	return -1
end if

// If we get here then we didn't find a simple child
return 0

end function

public function integer add_observation (long pl_question_number);long ll_parent_observation_sequence
string ls_child_observation_id
long i
str_observation_tree_branch lstr_branch
long ll_null
long ll_stage

setnull(ll_null)
setnull(ll_stage)

if pl_question_number > 1 then
	// Get the parents' observation sequence
	i = 0
	DO WHILE i < pl_question_number
		i += 1
		if branch_child(pl_question_number - i) = branch_parent(pl_question_number) then EXIT
	LOOP
	ll_parent_observation_sequence = observation_sequence[pl_question_number - i]

	ls_child_observation_id = branch_child(pl_question_number)
	observation_sequence[pl_question_number] = service.treatment.add_observation(ll_parent_observation_sequence, &
																											ls_child_observation_id, &
																											branch[pl_question_number].child_ordinal, &
																											branch[pl_question_number].observation_tag, &
																											ll_stage, &
																											true)
end if


return 1



end function

public function integer add_branch ();string ls_composite_flag
integer ll_starting_question_number
string ls_observation_id
integer li_sts
integer i

ll_starting_question_number = question_number

ls_observation_id = branch_child(question_number)

// Now, if the next child is composite, then drill down by calling find_simple_child().
// Otherwise, we're done so return found.
ls_composite_flag = datalist.observation_composite_flag(ls_observation_id)
if ls_composite_flag = "Y" then
	li_sts = find_simple_child()
	if li_sts = 1 then
		// If we found a child, then we need to add the p_Observation records for
		// all the branches between here and the child
		for i = ll_starting_question_number to question_number
			li_sts = add_observation(i)
			if li_sts <= 0 then
				log.log(this, "w_history_questionnaire.add_branch:0022", "Error adding child p record", 4)
				return -1
			end if
		next
		return 1
	end if
else
	// Add the p_Observation record
	li_sts = add_observation(question_number)
	if li_sts <= 0 then
		log.log(this, "w_history_questionnaire.add_branch:0032", "Error adding simple p record", 4)
		return -1
	end if
	return 1
end if

end function

public function integer display_observation ();long ll_row
long ll_observation_sequence
string ls_find
integer li_sts
string ls_parent_observation_id
string ls_child_observation_id
string ls_tmp_observation_id
string ls_composite_flag
string ls_exclusive_flag
string ls_default_view
string ls_perform_location_domain
integer li_location_count
long i
string ls_status
string ls_sep
string ls_description
string ls_temp
string lsa_locations[]
string lsa_location_descriptions[]
str_observation_results lstr_results
str_observation_comment_list lstr_comments
string ls_comment_title

if question_number <= 1 then
	log.log(this, "w_history_questionnaire.display_observation:0025", "Question number must be greater than 1", 4)
	return -1
end if

ll_observation_sequence = observation_sequence[question_number]

ls_parent_observation_id = branch_parent(question_number)
ls_child_observation_id = branch_child(question_number)

ls_composite_flag = datalist.observation_composite_flag(ls_child_observation_id)
if ls_composite_flag = "Y" then
	log.log(this, "w_history_questionnaire.display_observation:0036", "observation is composite (" + ls_child_observation_id + ")", 4)
	return -1
end if

ls_exclusive_flag = datalist.observation_exclusive_flag(ls_child_observation_id)
if ls_exclusive_flag = "Y" then
	dw_right.multiselect = false
else
	dw_right.multiselect = true
end if

// Calculate observation description
i = 0
ls_sep = ""
ls_description = ""
ll_observation_sequence = observation_sequence[question_number]
ls_find = "observation_sequence=" + string(ll_observation_sequence)
ll_row = p_Observation.find(ls_find, 1, p_Observation.rowcount())
DO WHILE ll_row > 0
	ls_tmp_observation_id = p_Observation.object.observation_id[ll_row]
	ll_observation_sequence = p_Observation.object.parent_observation_sequence[ll_row]
	
	ls_temp = datalist.observation_description(ls_tmp_observation_id)
	if not isnull(ls_temp) and trim(ls_temp) <> "" then
		ls_description = ls_temp + ls_sep + ls_description
		ls_sep = " : "
	end if

	// Quit when we hit the root or a null observation_sequence
	if isnull(ll_observation_sequence) OR ll_observation_sequence = observation_sequence[1] then EXIT
	
	ls_find = "observation_sequence=" + string(ll_observation_sequence)
	ll_row = p_Observation.find(ls_find, 1, p_Observation.rowcount())
LOOP

st_observation_description.text = ls_description

ls_perform_location_domain = datalist.observation_perform_location_domain(ls_child_observation_id)
if isnull(ls_perform_location_domain) or ls_perform_location_domain = "NA" then
	dw_left.visible = false
	st_view_title.visible = false
	cb_view.visible = false
	pb_left_up.visible = false
	pb_left_down.visible = false
	st_left_page.visible = false
	li_location_count = 0
	current_view = "L"
	dw_right.x = result_center_x
else
	dw_left.visible = true
	st_view_title.visible = true
	cb_view.visible = true
	pb_left_up.visible = true
	pb_left_down.visible = true
	st_left_page.visible = true
	if isnull(current_view) then current_view = datalist.observation_default_view(ls_child_observation_id)
	li_location_count = datalist.locations_in_domain(ls_perform_location_domain, lsa_locations, lsa_location_descriptions)
	dw_right.x = result_right_x
end if

st_right_title.x = dw_right.x
st_right_page.x = dw_right.x + 1266
pb_right_up.x = dw_right.x + 1266
pb_right_down.x = dw_right.x + 1266
st_new_result.x = dw_right.x + 1266

lstr_results = datalist.observation_results(ls_child_observation_id)

ll_observation_sequence = observation_sequence[question_number]

dw_left.reset()
dw_right.reset()

if current_view = "R" then
	cb_view.text = "By Result"
	st_right_title.text = "Locations"
	for i = 1 to lstr_results.result_count
		ls_status = lstr_results.result[i].status
		if ls_status = "OK" then
			ll_row = dw_left.insertrow(0)
			dw_left.object.description[ll_row] = lstr_results.result[i].result
			dw_left.object.result_sequence[ll_row] = lstr_results.result[i].result_sequence
			if is_any_locations(lstr_results.result[i].result_sequence) then dw_left.object.results_flag[ll_row] = 1
		end if
	next
else
	cb_view.text = "By Location"
	st_right_title.text = "Results"
	for i = 1 to li_location_count
		ll_row = dw_left.insertrow(0)
		dw_left.object.description[ll_row] = lsa_location_descriptions[i]
		dw_left.object.location[ll_row] = lsa_locations[i]
		if is_any_results(lsa_locations[i]) then dw_left.object.results_flag[ll_row] = 1
	next
end if

if dw_left.visible then
	if dw_left.rowcount() > 0 then
		dw_left.last_page = 0
		dw_left.set_page(1, st_left_page.text)
		if dw_left.last_page <= 1 then
			pb_left_up.visible = false
			pb_left_down.visible = false
			st_left_page.visible = false
		else
			pb_left_up.visible = true
			pb_left_down.visible = true
			st_left_page.visible = true
		end if
		dw_left.object.selected_flag[1] = 1
		dw_left.event post selected(1)
	end if
else
	current_location = "NA"
	li_sts = display_right_side()
	if li_sts < 0 then return -1
end if

lstr_comments = service.treatment.get_comments(ll_observation_sequence, "%")
ls_description = ""
for i = 1 to lstr_comments.comment_count
	if ls_description <> "" then ls_description += "~n"
	ls_comment_title = lstr_comments.comment[i].comment_title
	if isnull(ls_comment_title) then
		ls_comment_title = user_list.user_short_name(lstr_comments.comment[i].user_id)
	end if
	ls_description += ls_comment_title + ":  "
	ls_description += lstr_comments.comment[i].comment
next
if ls_description = "" then ls_description = "Comments..."
st_comments.text = ls_description


return 1


end function

public function integer display_right_side ();string ls_status
long ll_row
integer li_sts
long ll_location_count
long ll_result_count
long i
integer li_result_sequence
string lsa_locations[]
string lsa_location_descriptions[]
str_observation_results lstr_results
string ls_perform_location_domain
string ls_description

dw_right.reset()

if current_view = "R" then
	ls_perform_location_domain = datalist.observation_perform_location_domain(branch[question_number].child_observation_id)
	ll_location_count = datalist.locations_in_domain(ls_perform_location_domain, lsa_locations, lsa_location_descriptions)
	for i = 1 to ll_location_count
		li_sts = location_description(current_result_sequence, lsa_locations[i], ls_description)
		if li_sts < 0 then
			log.log(this, "w_history_questionnaire.display_right_side:0022", "Error getting right side description.  Location skipped (" + lsa_locations[i] + ")", 4)
		else
			ll_row = dw_right.insertrow(0)
			dw_right.object.selected_flag[ll_row] = li_sts
			dw_right.object.description[ll_row] = ls_description
			dw_right.object.result_sequence[ll_row] = current_result_sequence
			dw_right.object.location[ll_row] = lsa_locations[i]
		end if
	next
else
	lstr_results = datalist.observation_results(branch[question_number].child_observation_id)
	for i = 1 to lstr_results.result_count
		if lstr_results.result[i].result_type = "PERFORM" then
			ls_status = lstr_results.result[i].status
			li_result_sequence = lstr_results.result[i].result_sequence
			if ls_status = "OK" or is_selected(li_result_sequence, current_location) then
				ll_row = dw_right.insertrow(0)
				li_sts = result_description(li_result_sequence, current_location, ls_description)
				if li_sts < 0 then
					log.log(this, "w_history_questionnaire.display_right_side:0041", "Error getting right side description.  Location skipped (" + string(li_result_sequence) + ")", 4)
				else
					dw_right.object.selected_flag[ll_row] = li_sts
					dw_right.object.description[ll_row] = ls_description
					dw_right.object.result_sequence[ll_row] = lstr_results.result[i].result_sequence
					dw_right.object.location[ll_row] = current_location
				end if
			end if
		end if
	next
end if

dw_right.last_page = 0
dw_right.set_page(1, st_right_page.text)
if dw_right.last_page <= 1 then
	pb_right_up.visible = false
	pb_right_down.visible = false
	st_right_page.visible = false
else
	pb_right_up.visible = true
	pb_right_down.visible = true
	st_right_page.visible = true
end if

return 1














end function

public function integer initialize ();integer li_sts
string ls_composite_flag
integer i

p_observation = service.treatment.p_Observation
p_observation_result = service.treatment.p_observation_result
p_observation_result_qualifier = service.treatment.p_observation_result_qualifier

question_number = 1
observation_sequence[1] = service.get_root_observation()
branch_followon[1] = false
setnull(branch[1].branch_id)

// This scree can only display simple observations, so if the root is composite,
// we need to traverse the observation tree and find the first non-composite.
ls_composite_flag = datalist.observation_composite_flag(root_observation_id)
if ls_composite_flag = "Y" then
	li_sts = find_simple_child()
	if li_sts = 1 then
		// If we found a child, then we need to add the p_Observation records for
		// all the branches between here and the child
		for i = 2 to question_number
			li_sts = add_observation(i)
			if li_sts <= 0 then
				log.log(this, "w_history_questionnaire.initialize:0025", "Error adding root child p record", 4)
				return -1
			end if
		next
	end if
end if

// Now see if there's a next observation so we can set the buttons correctly
li_sts = get_next_observation()
if li_sts <= 0 then
	cb_next.enabled = false
	cb_be_back.weight = 700
	cb_done.weight = 700
else
	cb_next.enabled = true
	cb_be_back.weight = 400
	cb_done.weight = 400
	li_sts = get_previous_observation()
	if li_sts < 0 then return -1
end if

cb_prev.enabled = false

li_sts = display_observation()
if li_sts <= 0 then return -1


return 1

end function

public function integer get_next_observation ();string ls_temp
long ll_branch_id
long ll_observation_sequence
string ls_find
integer li_sts
string ls_prev_observation_id
string ls_next_observation_id
string ls_composite_flag
string ls_default_view
long i
string ls_status
long ll_parent_observation_sequence
integer li_this_severity
string ls_observation_id
long ll_parent_branch_id
long ll_backup
string ls_this_observation_id
string ls_followon_observation_id
integer li_followon_severity
str_observation_tree lstr_tree
boolean lb_branch_found


// If the branch_id is null then the previous observation must be the root.  This can only happen
// if the root is simple, so there won't be a next observation
if isnull(branch[question_number].branch_id) then return 0

// Find the previous p_observation record
ll_parent_observation_sequence = observation_sequence[question_number]

ls_prev_observation_id = branch[question_number].child_observation_id
ls_composite_flag = datalist.observation_composite_flag(ls_prev_observation_id)

if ls_composite_flag = "Y" then
	// This function should only be called from a simple observation so return error
	log.log(this, "w_history_questionnaire.get_next_observation:0036", "previous observation_sequence not found (" + string(ll_parent_observation_sequence) + ")", 4)
	return -1
end if

// Initialize the branch_id
ll_branch_id = branch[question_number].branch_id

// Initialize the "back up the tree" level to zero
ll_backup = 1

// Increment the tree down one level in anticipation of finding the next observation
question_number += 1
branch_followon[question_number] = false

// Now find the next simple observation...
DO WHILE ll_backup < question_number
	// Each iteration of the outside loop goes back up the tree one level.  Then
	// the inside loop checks all subsequent children of the same parent for a
	// simple observation to display.  This implements a "depth first" tree search,
	// starting at the current observation.

	ls_prev_observation_id = branch_parent(question_number - ll_backup)
	ls_this_observation_id = branch_child(question_number - ll_backup)
	ls_followon_observation_id = branch_followon(question_number - ll_backup)
	ls_composite_flag = datalist.observation_composite_flag(ls_this_observation_id)
	
	if ls_composite_flag = "Y" or ll_backup = 1 or not isnull(ls_followon_observation_id) then
		// If the simple observation has a followon observation, determine whether to follow it
		if ll_backup = 1 and not (ls_composite_flag = "Y") and not isnull(ls_followon_observation_id) then
			li_followon_severity = branch[question_number - ll_backup].followon_severity
			li_this_severity = observation_severity(observation_sequence[question_number - ll_backup])
			if li_followon_severity <= li_this_severity or isnull(li_followon_severity) then
				// If we follow the followon observation, use the same branch structure as the previous
				// observation, but set the followon flag to signify that we're using the followon
				// observation instead of the child observation.
				branch[question_number] = branch[question_number - ll_backup]
				branch_followon[question_number] = true
				li_sts = add_branch()
				if li_sts <= 0 then
					log.log(this, "w_history_questionnaire.get_next_observation:0075", "Error adding followon branch", 4)
					return -1
				end if
				return 1
			end if
		end if
		
		// Now loop through the subsequent children from the same parent, and see if one of them is simple
		lb_branch_found = false
		lstr_tree = datalist.observation_tree(branch[question_number - ll_backup].parent_observation_id)
		for i = 1 to lstr_tree.branch_count
			// Ignore branches before the current branch
			if lstr_tree.branch[i].branch_id = branch[question_number - ll_backup].branch_id then
				// This is the current branch
				lb_branch_found = true
			elseif lb_branch_found then
				// Make sure we still have the right parent observation
				ls_next_observation_id = lstr_tree.branch[i].child_observation_id
				branch[question_number] = lstr_tree.branch[i]
				li_sts = add_branch()
				if li_sts < 0 then
					log.log(this, "w_history_questionnaire.get_next_observation:0096", "Error adding child branch", 4)
					return -1
				end if
				if li_sts > 0 then return 1
			end if
		next
	end if
	
	// Since we haven't returned yet, we didn't find a subsequent simple observation under
	// The current parent.  We need to continue the search at the observation following
	// the parent within the parents' parent.  So increment the "back up the tree"
	// level until we find the branch where the current parent is the child of another parent.
	DO
		ll_backup += 1
		if ll_backup >= question_number - 1 then EXIT
	LOOP UNTIL ls_prev_observation_id = branch_child(question_number - ll_backup)
	
	if ll_backup < question_number then ll_branch_id = branch[question_number - ll_backup].branch_id
LOOP

// If we get here then we didn't find a subsequent simple observation
question_number -= 1
return 0

end function

on w_history_questionnaire.create
int iCurrent
call super::create
this.st_right_page=create st_right_page
this.st_left_page=create st_left_page
this.pb_left_up=create pb_left_up
this.pb_left_down=create pb_left_down
this.pb_right_down=create pb_right_down
this.pb_right_up=create pb_right_up
this.cb_done=create cb_done
this.cb_be_back=create cb_be_back
this.cb_prev=create cb_prev
this.cb_next=create cb_next
this.st_right_title=create st_right_title
this.dw_right=create dw_right
this.dw_left=create dw_left
this.st_observation_description=create st_observation_description
this.st_view_title=create st_view_title
this.cb_view=create cb_view
this.st_title=create st_title
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
this.pb_help=create pb_help
this.cb_edit_observation=create cb_edit_observation
this.st_comments=create st_comments
this.st_new_result=create st_new_result
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_right_page
this.Control[iCurrent+2]=this.st_left_page
this.Control[iCurrent+3]=this.pb_left_up
this.Control[iCurrent+4]=this.pb_left_down
this.Control[iCurrent+5]=this.pb_right_down
this.Control[iCurrent+6]=this.pb_right_up
this.Control[iCurrent+7]=this.cb_done
this.Control[iCurrent+8]=this.cb_be_back
this.Control[iCurrent+9]=this.cb_prev
this.Control[iCurrent+10]=this.cb_next
this.Control[iCurrent+11]=this.st_right_title
this.Control[iCurrent+12]=this.dw_right
this.Control[iCurrent+13]=this.dw_left
this.Control[iCurrent+14]=this.st_observation_description
this.Control[iCurrent+15]=this.st_view_title
this.Control[iCurrent+16]=this.cb_view
this.Control[iCurrent+17]=this.st_title
this.Control[iCurrent+18]=this.pb_cancel
this.Control[iCurrent+19]=this.pb_done
this.Control[iCurrent+20]=this.pb_help
this.Control[iCurrent+21]=this.cb_edit_observation
this.Control[iCurrent+22]=this.st_comments
this.Control[iCurrent+23]=this.st_new_result
end on

on w_history_questionnaire.destroy
call super::destroy
destroy(this.st_right_page)
destroy(this.st_left_page)
destroy(this.pb_left_up)
destroy(this.pb_left_down)
destroy(this.pb_right_down)
destroy(this.pb_right_up)
destroy(this.cb_done)
destroy(this.cb_be_back)
destroy(this.cb_prev)
destroy(this.cb_next)
destroy(this.st_right_title)
destroy(this.dw_right)
destroy(this.dw_left)
destroy(this.st_observation_description)
destroy(this.st_view_title)
destroy(this.cb_view)
destroy(this.st_title)
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.pb_help)
destroy(this.cb_edit_observation)
destroy(this.st_comments)
destroy(this.st_new_result)
end on

event open;call super::open;str_popup_return popup_return
integer li_sts

service = Message.powerobjectparm

popup_return.item_count = 0

if isnull(service.treatment) or not isvalid(service.treatment) then
	log.log(this, "w_history_questionnaire:open", "Invalid treatment object", 4)
	closewithreturn(this, popup_return)
	return
end if

root_observation_id = service.root_observation_id()
if isnull(root_observation_id) then
	log.log(this, "w_history_questionnaire:open", "Invalid observation", 4)
	closewithreturn(this, popup_return)
	return
end if

st_title.text = datalist.observation_description(root_observation_id)

title = current_patient.id_line()

li_sts = initialize()
if li_sts <= 0 then
	log.log(this, "w_history_questionnaire:open", "Initialization failed", 4)
	closewithreturn(this, popup_return)
	return
end if

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_history_questionnaire
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_history_questionnaire
end type

type st_right_page from statictext within w_history_questionnaire
integer x = 2683
integer y = 396
integer width = 197
integer height = 56
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "99 of 99"
boolean focusrectangle = false
end type

type st_left_page from statictext within w_history_questionnaire
integer x = 1115
integer y = 448
integer width = 197
integer height = 56
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "99 of 99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_left_up from picturebutton within w_history_questionnaire
integer x = 1143
integer y = 512
integer width = 137
integer height = 116
integer taborder = 10
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;dw_left.set_page(dw_left.current_page - 1, st_left_page.text)

end event

type pb_left_down from picturebutton within w_history_questionnaire
integer x = 1143
integer y = 644
integer width = 137
integer height = 116
integer taborder = 40
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;dw_left.set_page(dw_left.current_page + 1, st_left_page.text)

end event

type pb_right_down from picturebutton within w_history_questionnaire
integer x = 2683
integer y = 596
integer width = 137
integer height = 116
integer taborder = 50
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_down.bmp"
end type

event clicked;dw_right.set_page(dw_right.current_page + 1, st_right_page.text)

end event

type pb_right_up from picturebutton within w_history_questionnaire
integer x = 2683
integer y = 460
integer width = 137
integer height = 116
integer taborder = 60
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;dw_right.set_page(dw_right.current_page - 1, st_right_page.text)

end event

type cb_done from commandbutton within w_history_questionnaire
integer x = 2446
integer y = 1608
integer width = 421
integer height = 108
integer taborder = 140
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_history_questionnaire
integer x = 2007
integer y = 1608
integer width = 416
integer height = 108
integer taborder = 110
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cb_prev from commandbutton within w_history_questionnaire
integer x = 1733
integer y = 1448
integer width = 553
integer height = 112
integer taborder = 120
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<< Previous <<"
end type

event clicked;integer li_sts

li_sts = get_previous_observation()
if li_sts <= 0 then return

cb_be_back.weight = 400
cb_done.weight = 400
cb_next.enabled = true

// See if there's another previous observation
li_sts = get_previous_observation()
if li_sts <= 0 then
	enabled = false
else
	enabled = true
	li_sts = get_next_observation()
end if

li_sts = display_observation()
if li_sts <= 0 then return


end event

type cb_next from commandbutton within w_history_questionnaire
integer x = 2313
integer y = 1448
integer width = 553
integer height = 112
integer taborder = 130
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">> Next >>"
end type

event clicked;integer li_sts

// Get the next observation
li_sts = get_next_observation()
if li_sts <= 0 then return

// Now see if there's one after that
li_sts = get_next_observation()
if li_sts <= 0 then
	enabled = false
	cb_be_back.weight = 700
	cb_done.weight = 700
else
	enabled = true
	cb_be_back.weight = 400
	cb_done.weight = 400
	li_sts = get_previous_observation()
	if li_sts < 0 then return
end if

cb_prev.enabled = true

li_sts = display_observation()
if li_sts <= 0 then return


end event

type st_right_title from statictext within w_history_questionnaire
integer x = 1417
integer y = 344
integer width = 1257
integer height = 92
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Results"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_right from u_dw_pick_list within w_history_questionnaire
integer x = 1417
integer y = 452
integer width = 1257
integer height = 932
integer taborder = 70
string dataobject = "dw_observation_history_results"
boolean border = false
end type

event selected;call super::selected;integer li_result_sequence
string ls_location

li_result_sequence = object.result_sequence[selected_row]
ls_location = object.location[selected_row]

add_result(li_result_sequence, ls_location)

if dw_left.visible then dw_left.event post results_changed()

end event

event unselected;call super::unselected;integer li_result_sequence
string ls_location

li_result_sequence = object.result_sequence[unselected_row]
ls_location = object.location[unselected_row]

delete_result(li_result_sequence, ls_location)

if dw_left.visible then dw_left.event post results_changed()

end event

type dw_left from u_dw_pick_list within w_history_questionnaire
event results_changed ( )
integer x = 82
integer y = 504
integer width = 1047
integer height = 888
integer taborder = 20
string dataobject = "dw_left_side_display"
boolean border = false
end type

event results_changed;long ll_row

ll_row = get_selected_row()
if ll_row <= 0 then return

if current_view = "R" then
	if is_any_locations(integer(object.result_sequence[ll_row])) then
		dw_left.object.results_flag[ll_row] = 1
	else
		dw_left.object.results_flag[ll_row] = 0
	end if
else
	if is_any_results(string(object.location[ll_row])) then
		dw_left.object.results_flag[ll_row] = 1
	else
		dw_left.object.results_flag[ll_row] = 0
	end if
end if

end event

event selected;call super::selected;if current_view = "R" then
	current_result_sequence = object.result_sequence[selected_row]
else
	current_location = object.location[selected_row]
end if

display_right_side()

end event

type st_observation_description from statictext within w_history_questionnaire
integer y = 132
integer width = 2907
integer height = 168
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Composite Observation"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_view_title from statictext within w_history_questionnaire
integer x = 178
integer y = 396
integer width = 242
integer height = 84
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "View:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_view from commandbutton within w_history_questionnaire
integer x = 457
integer y = 376
integer width = 535
integer height = 112
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "By Location"
end type

event clicked;if current_view = "R" then
	current_view = "L"
	text = "By Location"
	st_right_title.text = "Results"
else
	current_view = "R"
	text = "By Result"
	st_right_title.text = "Locations"
end if

display_observation()

end event

type st_title from statictext within w_history_questionnaire
integer y = 8
integer width = 2907
integer height = 112
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Composite Observation"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_history_questionnaire
boolean visible = false
integer x = 59
integer y = 1772
integer taborder = 150
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_done from u_picture_button within w_history_questionnaire
boolean visible = false
integer x = 366
integer y = 1756
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_help from u_pb_help_button within w_history_questionnaire
integer x = 1746
integer y = 1608
integer taborder = 90
boolean bringtotop = true
boolean originalsize = false
end type

type cb_edit_observation from commandbutton within w_history_questionnaire
integer x = 1390
integer y = 1596
integer width = 210
integer height = 108
integer taborder = 120
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit"
end type

event clicked;string ls_observation_id
string ls_composite_flag
str_popup popup
str_popup_return popup_return

if question_number < 1 then
	log.log(this, "w_history_questionnaire.cb_edit_observation.clicked:0007", "Invalid Question Number", 4)
	return -1
end if


popup.data_row_count = 2
popup.items[1] = "Edit This Observation"
popup.items[2] = "Edit Entire Questionnaire"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return
if popup_return.item_indexes[1] = 1 then
	ls_observation_id = branch_child(question_number)
else
	ls_observation_id = root_observation_id
end if

ls_composite_flag = datalist.observation_composite_flag(ls_observation_id)

popup.data_row_count = 2
popup.items[1] = ls_observation_id
popup.items[2] = "True"

if ls_composite_flag = "Y" then
	popup.data_row_count = 2
	popup.items[1] = ls_observation_id
	popup.items[2] = "Y"
	openwithparm(w_observation_tree_display, popup)
else
	openwithparm(w_observation_definition, popup)
end if

popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

display_observation()

return

end event

type st_comments from statictext within w_history_questionnaire
integer x = 64
integer y = 1416
integer width = 1170
integer height = 300
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Comments..."
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_observation_comment_list lstr_comments
integer i
long ll_observation_sequence
string ls_description
str_popup popup
string ls_comment_title

ll_observation_sequence = observation_sequence[question_number]

popup.data_row_count = 3
popup.objectparm = service
popup.items[1] = string(ll_observation_sequence)
popup.items[2] = current_user.user_id
setnull(popup.items[3])
popup.title = st_observation_description.text
openwithparm(w_observation_comment, popup)


lstr_comments = service.treatment.get_comments(ll_observation_sequence, "%")
ls_description = ""
for i = 1 to lstr_comments.comment_count
	if ls_description <> "" then ls_description += "~n"
	ls_comment_title = lstr_comments.comment[i].comment_title
	if isnull(ls_comment_title) then
		ls_comment_title = user_list.user_short_name(lstr_comments.comment[i].user_id)
	end if
	ls_description += ls_comment_title + ":  "
	ls_description += lstr_comments.comment[i].comment
next
if ls_description = "" then ls_description = "Comments..."
text = ls_description

end event

type st_new_result from statictext within w_history_questionnaire
integer x = 2683
integer y = 924
integer width = 192
integer height = 132
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "New Result"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup

popup.data_row_count = 3
popup.items[1] = 	branch_child(question_number)
setnull(popup.items[2])
popup.items[3] = "NA"
popup.title = datalist.observation_description(popup.items[1])

openwithparm(w_new_observation_result, popup)
display_observation()
return


end event

